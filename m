Return-Path: <kvm+bounces-1477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A5A17E7CBC
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 14:56:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16067281813
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 13:56:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B7E81C286;
	Fri, 10 Nov 2023 13:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fzFMUQW+"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1437F3717F
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 13:54:45 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E9538224
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 05:54:43 -0800 (PST)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADHO6p017719;
	Fri, 10 Nov 2023 13:54:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=K7Iy8LlS1dUK0JjoQpkmPfvo1DjY8lLTbh33pd1A5WY=;
 b=fzFMUQW+wpb+7wx+E86+yHt0jQePqNyPIc0QpcoXjELFicrrNSklJdEjQNtsZBGxYMeg
 kMEH1oj8N0sm90plyLT7x3ozaBQCIKZmFJDBZmYdBQcqiy+sg3VVSfm93AvDg95Dnu8s
 3dOiV5Xmu7XYxeZKkMgbDqqFm4l41nPHu8Ly7QWWc8HvA8bZ+n/rgqvhpAsQ6IT2nrRF
 kmvGN06tvg7gkQqJEM4IEFiQXw3c5cnrgYIDv/mXk/6PkxtCipF301HpwmxH5iJEF6O6
 jEm34KeswnneYjOjCGzvO0rduBg85exnzRKo5XiScvvEGsP35TLfMvM64qgr/tgWbAP6 3w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9n97s790-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:40 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AADJmpj028350;
	Fri, 10 Nov 2023 13:54:39 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9n97s78c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:39 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADaIO3014340;
	Fri, 10 Nov 2023 13:54:38 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u7w22b7xj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:38 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AADsZBT39846374
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 13:54:35 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 32DD220040;
	Fri, 10 Nov 2023 13:54:35 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C6C4A2004E;
	Fri, 10 Nov 2023 13:54:34 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.18.113])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Nov 2023 13:54:34 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 17/26] scripts: Implement multiline strings for extra_params
Date: Fri, 10 Nov 2023 14:52:26 +0100
Message-ID: <20231110135348.245156-18-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231110135348.245156-1-nrb@linux.ibm.com>
References: <20231110135348.245156-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yMVIPi_87ZFxFsOZ9LboH8Bvce9SBe9_
X-Proofpoint-GUID: 5v8lNtFKBMdR1uMsuzRvefcZzwWKDDH3
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-10_10,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 spamscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311100114

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

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
Link: https://lore.kernel.org/r/20231030160349.458764-10-nsg@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 scripts/common.bash  | 16 ++++++++++++++++
 scripts/runtime.bash |  4 ++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/scripts/common.bash b/scripts/common.bash
index 7b983f7..b9413d6 100644
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
index ada8ffd..fc156f2 100644
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


