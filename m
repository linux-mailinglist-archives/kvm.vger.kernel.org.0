Return-Path: <kvm+bounces-77-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D3EFD7DBD64
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 17:04:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4BED6B20D7F
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 16:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6D4B18E0F;
	Mon, 30 Oct 2023 16:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="F6djy3hW"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA37518C18
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 16:04:05 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13839F7;
	Mon, 30 Oct 2023 09:04:04 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39UFGNW2028460;
	Mon, 30 Oct 2023 16:03:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=T+KK4iHoPpXSCeFZ9GUqRcs3dIrnE46B59xOeReic6M=;
 b=F6djy3hWeqL2CGsC3kUV+r+L0H+kVxczZrhHvLB9uuqemV1Izxtn5F5P+93SF4HGQ50v
 sDiWsax8JbV6S9lGsKN+i57Gfk1NQPHIYDLqSSNeBkzee5mPjz/wmkSbvWc8O1W8J9oC
 Fz2GCdc6FJUxrSn8RJZQxx+2JLdZPFW4v6Xyw6qIC2Cj6BMy4MgS5Ha0w/gcJEVQv4AX
 g/AektS/vKlLvvHCuycKxL5A0f+xoWY2HAr5Ne6mSycZ3b0CTCNHk7Wbym/FWkTxAlP3
 WkdvLGSL2/u27/DHS4OJ613OSTPyGcT/oMFwdT1TQ+UPuzH0uDPU60uMup3Sp6rHK8di mw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u2escsv1h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:03:59 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39UFfr0X029033;
	Mon, 30 Oct 2023 16:03:58 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u2escsv0f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:03:58 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39UEWUq4007734;
	Mon, 30 Oct 2023 16:03:57 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u1dmna5gm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:03:57 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39UG3s7O26149334
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Oct 2023 16:03:54 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F357120040;
	Mon, 30 Oct 2023 16:03:53 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C96992004D;
	Mon, 30 Oct 2023 16:03:53 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 30 Oct 2023 16:03:53 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Andrew Jones <andrew.jones@linux.dev>, Thomas Huth <thuth@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>
Cc: linux-s390@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v3 09/10] scripts: Implement multiline strings for extra_params
Date: Mon, 30 Oct 2023 17:03:48 +0100
Message-Id: <20231030160349.458764-10-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231030160349.458764-1-nsg@linux.ibm.com>
References: <20231030160349.458764-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fXToMO4aVHjXk2q7B5bKWPZHbocppo5Z
X-Proofpoint-ORIG-GUID: b631_-FIwI66t-730ApdAYJrq3839x4H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-30_10,2023-10-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 bulkscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2310300124

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

Reviewed-by: Thomas Huth <thuth@redhat.com>
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


