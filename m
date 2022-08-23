Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14CF259E626
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 17:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241473AbiHWPiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 11:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240327AbiHWPhb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 11:37:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C548689B
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 04:27:15 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27NAGcUP023480
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 10:38:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=Lm0Q1nGo7xgKWHR3YHGNm/bXM1Blb6wuFPQUbkcBzSk=;
 b=FWABjmJjuc20aIwD8pjcjYueIYOmZLFsJ7CTAmN6XWNiuFpIl1B11g871q+kEujbIBHt
 lAu9/qdGlOplm3nsfAHDNGVY/mheYCkTflSTw7TLMp3YS59p5I1Q7eB7ZSTbJQC/TpLK
 k7ma7Gs77tVtSPsEMtGnSZ2kbEO66CVO73cy7LRwGEJyyxDQfNVDsvrfgysD8fo0LS1W
 XkYjdDWlddlKeSWjqBvmBuiAcMehX6orEByycMobzdHQ/eWegXaCuLyuBy2TATOl68UR
 L3XA+sTde4fDlQ8o2dPLOVhI1rlFkJi9E9LpEdfRXy98pkw4Wc7Osk+4RTeZ8CMetydp RA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4w07rmnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 10:38:39 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27NAItfX029786
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 10:38:38 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4w07rmn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 10:38:38 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27NAL9KE031500;
        Tue, 23 Aug 2022 10:38:36 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3j2q88umcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 10:38:36 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27NAZZDv32375210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 10:35:35 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A95B242041;
        Tue, 23 Aug 2022 10:38:33 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 768AC42052;
        Tue, 23 Aug 2022 10:38:33 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Aug 2022 10:38:33 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v6 1/4] runtime: add support for panic tests
Date:   Tue, 23 Aug 2022 12:38:30 +0200
Message-Id: <20220823103833.156942-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220823103833.156942-1-nrb@linux.ibm.com>
References: <20220823103833.156942-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nzvcxN2BG-CEWq6oCVPDfKXbWGEgCkOS
X-Proofpoint-ORIG-GUID: 7JUpo4k0lffthAdrPUF69t3wTURau5ym
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_04,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 phishscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208230040
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QEMU supports a guest state "guest-panicked" which indicates something
in the guest went wrong. For example on s390x, when an external
interrupt loop was triggered.

Since the guest does not continue to run when it is in the
guest-panicked state, it is currently impossible to write panicking
tests in kvm-unit-tests. Support from the runtime is needed to check
that the guest enters the guest-panicked state.

Similar to migration tests, add a new "panic" group. Tests in this
group must enter the guest-panicked state to succeed.

The runtime will spawn a QEMU instance, connect to the QMP and listen
for events. To parse the QMP protocol, jq[1] is used. Same as with
netcat in the migration tests, panic tests won't run if jq is not
installed.

The guest is created in the stopped state and only is resumed when
connection to the QMP was successful. This ensures no events are missed
between QEMU start and the connect to the QMP.

[1] https://stedolan.github.io/jq/

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
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
index 0dfaf017db0a..51e4b97b27d1 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -104,6 +104,14 @@ qmp ()
 	echo '{ "execute": "qmp_capabilities" }{ "execute":' "$2" '}' | ncat -U $1
 }
 
+qmp_events ()
+{
+	while ! test -S "$1"; do sleep 0.1; done
+	echo '{ "execute": "qmp_capabilities" }{ "execute": "cont" }' |
+		ncat --no-shutdown -U $1 |
+		jq -c 'select(has("event"))'
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
index bbf87cf4ed3f..f8794e9a25ce 100644
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

