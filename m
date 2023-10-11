Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A647C4DCB
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 10:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345757AbjJKI5F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 04:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345725AbjJKI5A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 04:57:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223B694
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 01:56:59 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39B8lQSL026581;
        Wed, 11 Oct 2023 08:56:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=6Qh0BG5dt06sxDD29FGz1McZIvs0mkaJu/lElRWc5SM=;
 b=mYKfWLOsCmJQl5FQgwZ9YzgwOsCw2g+AwCKhRoM2j4RIuOAHaIG8ZfGHhNKCHrc1+uBs
 Fd9UXpSLLTbXK9Ov1RZxa7hu1SIantnTT0s4/E0Tnj26QKda3rCOiff4TpxNZ6IHJpI+
 ShKnetXFnlPy4Rl2jK39n9kK4Pd+h0xtNgxzKp6rqBzPfXHrvVea7qeSDXBY2i1Pu7GO
 q11L3AUrpcAJRZWvtvJrtQQcJRygNz2kSN+/pGWHpWVx1hZjvyX3MOh+nhK6DBugOHAM
 rCPNtEg/I1/IQ2C0G6n8g63Y249isEpbR3mhFAiI6NaYw6nM9OgsiljnULSVVc6c9f+6 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tnrgg0acj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 08:56:48 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39B8menS031948;
        Wed, 11 Oct 2023 08:56:48 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tnrgg0ac1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 08:56:48 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39B6p4fe001147;
        Wed, 11 Oct 2023 08:56:47 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tkkvjxf7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 08:56:47 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39B8uiXq16122594
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Oct 2023 08:56:44 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 324072004B;
        Wed, 11 Oct 2023 08:56:44 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F27FD20040;
        Wed, 11 Oct 2023 08:56:43 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 11 Oct 2023 08:56:43 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Shaoqin Huang <shahuang@redhat.com>
Subject: [kvm-unit-tests PATCH 8/9] scripts: Implement multiline strings for extra_params
Date:   Wed, 11 Oct 2023 10:56:31 +0200
Message-Id: <20231011085635.1996346-9-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231011085635.1996346-1-nsg@linux.ibm.com>
References: <20231011085635.1996346-1-nsg@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TOFDyLV63icBGOovKpgj4N_XN00OufO6
X-Proofpoint-GUID: E9gh9t2rktaFgM_I2Phy9Zk7rKa4oQNY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-11_06,2023-10-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 clxscore=1015 bulkscore=0 suspectscore=0 phishscore=0 impostorscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310110078
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


This could certainly be done differently, suggestions welcome.


 scripts/common.bash  | 11 +++++++++++
 scripts/runtime.bash |  4 ++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/scripts/common.bash b/scripts/common.bash
index 7b983f7d..738e64af 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -36,6 +36,17 @@ function for_each_unittest()
 			kernel=$TEST_DIR/${BASH_REMATCH[1]}
 		elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
 			smp=${BASH_REMATCH[1]}
+		elif [[ $line =~ ^extra_params\ *=\ *'"""'(.*)$ ]]; then
+			opts=${BASH_REMATCH[1]}$'\n'
+			while read -r -u $fd; do
+				opts=${opts%\\$'\n'}
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

