######################################################################################################################
## This script was developed by Guberni and is part of Tellki monitoring solution                     		    	##
##                                                                                                      	    	##
## December, 2014                     	                                                                	    	##
##                                                                                                      	    	##
## Version 1.0                                                                                          	    	##
##																									    	    	##
## DESCRIPTION: Monitor disk devices performance (read/write operations)											##
##																											    	##
## SYNTAX: ./PhysicalDisk_Linux.sh <METRIC_STATE>             														##
##																											    	##
## EXAMPLE: ./PhysicalDisk_Linux.sh "1,1"         														    		##
##																											    	##
##                                      ############                                                    	    	##
##                                      ## README ##                                                    	    	##
##                                      ############                                                    	    	##
##																											    	##
## This script is used combined with runremote.sh script, but you can use as standalone. 			    	    	##
##																											    	##
## runremote.sh - executes input script locally or at a remove server, depending on the LOCAL parameter.	    	##
##																											    	##
## SYNTAX: sh "runremote.sh" <HOST> <METRIC_STATE> <USER_NAME> <PASS_WORD> <TEMP_DIR> <SSH_KEY> <LOCAL> 	    	##
##																											    	##
## EXAMPLE: (LOCAL)  sh "runremote.sh" "PhysicalDisk_Linux.sh" "192.168.1.1" "1,1" "" "" "" "" "1"              	##
## 			(REMOTE) sh "runremote.sh" "PhysicalDisk_Linux.sh" "192.168.1.1" "1,1" "user" "pass" "/tmp" "null" "0"  ##
##																											    	##
## HOST - hostname or ip address where script will be executed.                                         	    	##
## METRIC_STATE - is generated internally by Tellki and its only used by Tellki default monitors.       	    	##
##         		  1 - metric is on ; 0 - metric is off					              						    	##
## USER_NAME - user name required to connect to remote host. Empty ("") for local monitoring.           	    	##
## PASS_WORD - password required to connect to remote host. Empty ("") for local monitoring.            	    	##
## TEMP_DIR - (remote monitoring only): directory on remote host to copy scripts before being executed.		    	##
## SSH_KEY - private ssh key to connect to remote host. Empty ("null") if password is used.                 	    ##
## LOCAL - 1: local monitoring / 0: remote monitoring                                                   	    	##
######################################################################################################################

#METRIC_ID
BlocksReadID="109:Blocks Read per Second:4"
BlocksWriteID="108:Blocks Write per Second:4"

#INPUTS
BlocksReadID_on=`echo $1 | awk -F',' '{print $1}'`
BlocksWriteID_on=`echo $1 | awk -F',' '{print $2}'`

vmstat_out=`vmstat 1 3 | tail -1`

	if [ $BlocksReadID_on -eq 1 ]
	then
		BlocksReadSec=`echo $vmstat_out | awk '{print $9}'`
		if [ "$BlocksReadSec" = "" ]
		then
			#Unable to collect metrics
			exit 8 
		fi
	fi
	if [ $BlocksWriteID_on -eq 1 ]
	then
		BlocksWriteSec=`echo $vmstat_out | awk '{print $10}'`
		if [ "$BlocksWriteSec" = "" ]
		then
			#Unable to collect metrics
			exit 8 
		fi
	fi

# Send Metrics
if [ $BlocksReadID_on -eq 1 ]
then
	echo "$BlocksReadID|$BlocksReadSec|"
fi
if [ $BlocksWriteID_on -eq 1 ]
then
	echo "$BlocksWriteID|$BlocksWriteSec|"
fi
