Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86AEC7D12D7
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 17:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377717AbjJTPcy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 11:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377725AbjJTPcw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 11:32:52 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4F9D6E;
        Fri, 20 Oct 2023 08:32:48 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KFEXYS006326;
        Fri, 20 Oct 2023 15:32:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=s9EX2lIAtk9uao5McAdt1Ddbm+myB+BjqVbx+TMyoXA=;
 b=j8E/0fyL1CHn832cATMu4G7DyNqhEotu9/CADmqwTY1NC2KNAuNM1X3mw+SOVLHY2uzO
 RLMd36k5uin4QRz7Ix94atiU6lkBH4hi6JShGBy7uk392fX13Yl0u2FEI5esdgwYISob
 oVWloGaw2AHtlojJhBajYhHIrrzi5ukOklTh+AO8Gd93AYPIwHbb+JPST6M9uackWEy2
 c88F9c5pSgtiIeB48EQNTZX2NB+Hmc78Tea2zs3QR8oSafSNOP/eAFHZ1sui6p7kXj6H
 md37KNyRSuZYYG1hww+WbkI5YM5RMJePkgvYUKDLs1DQLnoC3y3+RNf2AyNwKM6sy+Fm IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tuv120skv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Oct 2023 15:32:43 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39KFEXOX006341;
        Fri, 20 Oct 2023 15:32:43 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tuv120sc9-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Oct 2023 15:32:43 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39KCCgCB019392;
        Fri, 20 Oct 2023 14:49:09 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tuc4556ek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Oct 2023 14:49:09 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39KEn6mc37093984
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 14:49:06 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BBCF520040;
        Fri, 20 Oct 2023 14:49:06 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82BED2004B;
        Fri, 20 Oct 2023 14:49:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 20 Oct 2023 14:49:06 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Colton Lewis <coltonlewis@google.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 09/10] scripts: Implement multiline strings for extra_params
Date:   Fri, 20 Oct 2023 16:48:59 +0200
Message-Id: <20231020144900.2213398-10-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231020144900.2213398-1-nsg@linux.ibm.com>
References: <20231020144900.2213398-1-nsg@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JZk7ZdMXW1IxR-YNLazzMXQDcp0A-OmC
X-Proofpoint-ORIG-GUID: 298pfpG1O1wftfqKStlZAurirNHaqWwh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 suspectscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2310170001 definitions=main-2310200128
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement a rudimentary form only.
extra_params can get long when passing a lot of arguments to qemu.
Multiline strings help with readability of the .cfg file.
Multiline strings begin and end with """, which must occur on separate
lines.

For example:
extra_params = """-cpu max,ctop=on -smp cpus=1,cores=16,maxcpus=128 \
-append '-drawers 2 -books 2 -sockets 2 -cores 16' \
-device max-s390x-cpu,core-id=31,drawer-id=0,book-id=0,socket-id=0"""

The command string built with extra_params is eval'ed by the runtime
script, so the newlines need to be escaped with \.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 scripts/common.bash  | 16 ++++++++++++++++
 scripts/runtime.bash |  4 ++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/scripts/common.bash b/scripts/common.bash
index 7b983f7d..b9413d68 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -36,6 +36,22 @@ function for_each_unittest()
 			kernel=$TEST_DIR/${BASH_REMATCH[1]}
 		elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
 			smp=${BASH_REMATCH[1]}
+		elif [[ $line =~ ^extra_params\ *=\ *'"""'(.*)$ ]]; then
+			opts=${BASH_REMATCH[1]}$'\n'
+			while read -r -u $fd; do
+				#escape backslash newline, but not double backslash
+				if [[ $opts =~ [^\\]*(\\*)$'\n'$ ]]; then
+					if (( ${#BASH_REMATCH[1]} % 2 == 1 )); then
+						opts=${opts%\\$'\n'}
+					fi
+				fi
+				if [[ "$REPLY" =~ ^(.*)'"""'[:blank:]*$ ]]; then
+					opts+=${BASH_REMATCH[1]}
+					break
+				else
+					opts+=$REPLY$'\n'
+				fi
+			done
 		elif [[ $line =~ ^extra_params\ *=\ *(.*)$ ]]; then
 			opts=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^groups\ *=\ *(.*)$ ]]; then
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index ada8ffd7..fc156f2f 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -15,7 +15,7 @@ extract_summary()
 # We assume that QEMU is going to work if it tried to load the kernel
 premature_failure()
 {
-    local log="$(eval $(get_cmdline _NO_FILE_4Uhere_) 2>&1)"
+    local log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
 
     echo "$log" | grep "_NO_FILE_4Uhere_" |
         grep -q -e "could not \(load\|open\) kernel" -e "error loading" &&
@@ -168,7 +168,7 @@ function run()
     # extra_params in the config file may contain backticks that need to be
     # expanded, so use eval to start qemu.  Use "> >(foo)" instead of a pipe to
     # preserve the exit status.
-    summary=$(eval $cmdline 2> >(RUNTIME_log_stderr $testname) \
+    summary=$(eval "$cmdline" 2> >(RUNTIME_log_stderr $testname) \
                              > >(tee >(RUNTIME_log_stdout $testname $kernel) | extract_summary))
     ret=$?
     [ "$KUT_STANDALONE" != "yes" ] && echo > >(RUNTIME_log_stdout $testname $kernel)
-- 
2.41.0

