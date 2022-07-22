Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C815657D9E5
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 08:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbiGVGAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 02:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbiGVGAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 02:00:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20AD0545DC
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 23:00:51 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26M5iZoe014733
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 06:00:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=eex1ESOPI9cZF+dkFiTfwxSy9rJFD2EEyI4eHKszPYg=;
 b=lvWBiKPODg7bcFFx2s51swjdvXkyFtxKBXXL2lcTwiMYoUTRx+z6E1WotKxnWac/WxG9
 ulHrhGAX7sCAAHTDmdH4T1ygfA7iziWaxHMqlIy7M84uzZJuGitUdlulmWIgg/cG809A
 1fKixWYuQDKlI8FeLYeBAjL0phdHf7f1OvrLWZcW7fq0oCP6JywMIOh+DCfbyp+oG4cx
 EkJIMafH29IeafGS3+eDrU4tfwSnqPRObbfIosG+Sd8kV7M7elN3T9vI3WidvmBdeunr
 p2Qnia1lKCxGWRsb7HS3075YuXtBZtylO+tgaKaSJITbcC7Jf1cdBrjLQU8V5KLIq9qg HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfp0ygad5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 06:00:50 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26M5u3J1028141
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 06:00:50 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfp0ygac0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 06:00:49 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26M5onQC030184;
        Fri, 22 Jul 2022 06:00:47 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3hbmy8yxnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 06:00:47 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26M60iNW19464554
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jul 2022 06:00:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 746F152051;
        Fri, 22 Jul 2022 06:00:44 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 41A7A52052;
        Fri, 22 Jul 2022 06:00:44 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 1/4] runtime: add support for panic tests
Date:   Fri, 22 Jul 2022 08:00:40 +0200
Message-Id: <20220722060043.733796-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220722060043.733796-1-nrb@linux.ibm.com>
References: <20220722060043.733796-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VOAkuXOpFan7gFagGsomfcL6Y_3azUDS
X-Proofpoint-GUID: bIK00ly99abc6Jfb1jeellZt8c6YtlMu
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_28,2022-07-21_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207220021
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QEMU supports a guest state "guest-panicked" which indicates something
in the guest went wrong, for example on s390x, when an external
interrupt loop was triggered.

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
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/run             |  2 +-
 scripts/arch-run.bash | 49 +++++++++++++++++++++++++++++++++++++++++++
 scripts/runtime.bash  |  3 +++
 3 files changed, 53 insertions(+), 1 deletion(-)

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
index 0dfaf017db0a..739490bc7da2 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -104,6 +104,14 @@ qmp ()
 	echo '{ "execute": "qmp_capabilities" }{ "execute":' "$2" '}' | ncat -U $1
 }
 
+qmp_events ()
+{
+	while ! test -S "$1"; do sleep 0.1; done
+	echo '{ "execute": "qmp_capabilities" }{ "execute": "cont" }' \
+		| ncat --no-shutdown -U $1 \
+		| jq -c 'select(has("event"))'
+}
+
 run_migration ()
 {
 	if ! command -v ncat >/dev/null 2>&1; then
@@ -164,6 +172,40 @@ run_migration ()
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
+	if [ "$panic_event_count" -lt 1 ]; then
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
@@ -171,6 +213,13 @@ migration_cmd ()
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

