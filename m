Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290ED561937
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 13:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235081AbiF3LbM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 07:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235038AbiF3LbH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 07:31:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B8A51B28;
        Thu, 30 Jun 2022 04:31:06 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25U9G5q7012676;
        Thu, 30 Jun 2022 11:31:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=TkvifhYzNvYEsIUk1043eqErZ58Lf4B0ktx1M9hAqA8=;
 b=kut4uv0wfVYwLz6dkHpU2afmS9bGt1j+Aw+2a0XALC/RzgeBLh5RJ9tmTl0HBrf3wKu1
 pC6rVQIRBuRqXJDCtYYf9KsJOPRxEFv9GJQDNBn+2h22u5imL0vM031d7A+AtH0SyUzz
 q1aSi8STieuzON+GtGzUH2dLNnFJQq2og1x/lFzjNyHjaANFSYIEm4/rGrCgxD24V9cr
 3jt2PkF1W/ryEZCmu68QHXlZ6ho5PIQhFwCoU2pGmMDCquqceuyx1INMd1yKYPda7ET+
 tg1BsXiGBaC/g6OEZBjm7qG+N4O7VXjURBPmzygGqjwYGHs/8MjHw7vrTPY7YA0/UBZc jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1923uf2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 11:31:05 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25UBLrH8006650;
        Thu, 30 Jun 2022 11:31:05 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1923uf29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 11:31:04 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25UBLXs7012706;
        Thu, 30 Jun 2022 11:31:02 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3gwt0900eu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 11:31:02 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25UBV7Rk27132226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jun 2022 11:31:07 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEF90A405C;
        Thu, 30 Jun 2022 11:30:59 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1BFCA405B;
        Thu, 30 Jun 2022 11:30:59 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Jun 2022 11:30:59 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 1/3] runtime: add support for panic tests
Date:   Thu, 30 Jun 2022 13:30:57 +0200
Message-Id: <20220630113059.229221-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630113059.229221-1-nrb@linux.ibm.com>
References: <20220630113059.229221-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: H8hBLZOhz__PGoThXZuBAOVrBLdAJ6Kq
X-Proofpoint-GUID: 2DyE5KZ8xh4LsWG-7cskor66fieTwgbh
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_07,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206300043
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QEMU suports a guest state "guest-panicked" which indicates something in
the guest went wrong, for example on s390x, when an external interrupt
loop was triggered.

Since the guest does not continue to run when it is in the
guest-panicked state, it is currently impossible to write panicking
tests in kvm-unit-tests. Support from the runtime is needed to check
that the guest enters the guest-panicked state.

Similar to migration tests, add a new group panic. Tests in this
group must enter the guest-panicked state to succeed.

The runtime will spawn a QEMU instance, connect to the QMP and listen
for events. To parse the QMP protocol, jq[1] is used. Same as with
netcat in the migration tests, panic tests won't run if jq is not
installed.

The guest is created in the stopped state and only continued when
connection to the QMP was successful. This ensures no events are missed
between QEMU start and the connect to the QMP.

[1] https://stedolan.github.io/jq/

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/run             |  2 +-
 scripts/arch-run.bash | 47 +++++++++++++++++++++++++++++++++++++++++++
 scripts/runtime.bash  |  3 +++
 3 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/s390x/run b/s390x/run
index 24138f6803be..f1111dbdbe62 100755
--- a/s390x/run
+++ b/s390x/run
@@ -30,7 +30,7 @@ M+=",accel=$ACCEL"
 command="$qemu -nodefaults -nographic $M"
 command+=" -chardev stdio,id=con0 -device sclpconsole,chardev=con0"
 command+=" -kernel"
-command="$(migration_cmd) $(timeout_cmd) $command"
+command="$(panic_cmd) $(migration_cmd) $(timeout_cmd) $command"
 
 # We return the exit code via stdout, not via the QEMU return code
 run_qemu_status $command "$@"
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 0dfaf017db0a..5663a1ddb09e 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -104,6 +104,12 @@ qmp ()
 	echo '{ "execute": "qmp_capabilities" }{ "execute":' "$2" '}' | ncat -U $1
 }
 
+qmp_events ()
+{
+	while ! test -S "$1"; do sleep 0.1; done
+	echo '{ "execute": "qmp_capabilities" }{ "execute": "cont" }' | ncat --no-shutdown -U $1 | jq -c 'select(has("event"))'
+}
+
 run_migration ()
 {
 	if ! command -v ncat >/dev/null 2>&1; then
@@ -164,6 +170,40 @@ run_migration ()
 	return $ret
 }
 
+run_panic ()
+{
+	if ! command -v ncat >/dev/null 2>&1; then
+		echo "${FUNCNAME[0]} needs ncat (netcat)" >&2
+		return 77
+	fi
+
+	if ! command -v jq >/dev/null 2>&1; then
+		echo "${FUNCNAME[0]} needs jq" >&2
+		return 77
+	fi
+
+	qmp=$(mktemp -u -t panic-qmp.XXXXXXXXXX)
+
+	trap 'kill 0; exit 2' INT TERM
+	trap 'rm -f ${qmp}' RETURN EXIT
+
+	# start VM stopped so we don't miss any events
+	eval "$@" -chardev socket,id=mon1,path=${qmp},server=on,wait=off \
+		-mon chardev=mon1,mode=control -S &
+
+	panic_event_count=$(qmp_events ${qmp} | jq -c 'select(.event == "GUEST_PANICKED")' | wc -l)
+	if [ $panic_event_count -lt 1 ]; then
+		echo "FAIL: guest did not panic"
+		ret=3
+	else
+		# some QEMU versions report multiple panic events
+		echo "PASS: guest panicked"
+		ret=1
+	fi
+
+	return $ret
+}
+
 migration_cmd ()
 {
 	if [ "$MIGRATION" = "yes" ]; then
@@ -171,6 +211,13 @@ migration_cmd ()
 	fi
 }
 
+panic_cmd ()
+{
+	if [ "$PANIC" = "yes" ]; then
+		echo "run_panic"
+	fi
+}
+
 search_qemu_binary ()
 {
 	local save_path=$PATH
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 7d0180bf14bd..8072f3bb536a 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -145,6 +145,9 @@ function run()
     if find_word "migration" "$groups"; then
         cmdline="MIGRATION=yes $cmdline"
     fi
+    if find_word "panic" "$groups"; then
+        cmdline="PANIC=yes $cmdline"
+    fi
     if [ "$verbose" = "yes" ]; then
         echo $cmdline
     fi
-- 
2.36.1

