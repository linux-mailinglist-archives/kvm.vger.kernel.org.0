Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C747324278D
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 11:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgHLJ1V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 05:27:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48194 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726962AbgHLJ1U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Aug 2020 05:27:20 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07C94OEN060825;
        Wed, 12 Aug 2020 05:27:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0acSJCr1o0RQcfcNtXQDeitKyCbzJCGqJk1XWIvSBuQ=;
 b=Oe74AEmgEYBjZZMrrkOQ82qJILQ0iZnUXsKA6/+/Fdl1jOOGzyGvH50v/D+u/W6j43tV
 NityKHqCaYFBY5IgYHyiy1AW+BcYbqsaJriyRHQktcS+DIJVxSbiOPApv2stBT0kj2p/
 ZWO1L6Ki4meSmeQeefDlFfJoeLs8o245Md/weOHHBBouiPRsV3/glnKNdKmK30IWsS0U
 GSRaYYEJlWuFqoJPo46Mxz3qXaP3UIPtubEWxfwCI8CYguErIGNKMmlD3V3RkLKd6RrN
 jpgamP6GN5C8hBsDkk8mvONqMiroyUL4EJtrbAD/gObM4sZuTloUGekiHWtJMFqGmMXu bQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32utn8r23m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 05:27:20 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07C94WSS061446;
        Wed, 12 Aug 2020 05:27:19 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32utn8r232-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 05:27:19 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07C9LL7M032034;
        Wed, 12 Aug 2020 09:27:17 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 32skp7tmea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 09:27:17 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07C9REpY31195392
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Aug 2020 09:27:14 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2690652052;
        Wed, 12 Aug 2020 09:27:14 +0000 (GMT)
Received: from marcibm.ibmuc.com (unknown [9.145.75.196])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id BB5085204F;
        Wed, 12 Aug 2020 09:27:13 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests RFC v2 1/4] common.bash: run `cmd` only if a test case was found
Date:   Wed, 12 Aug 2020 11:27:02 +0200
Message-Id: <20200812092705.17774-2-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200812092705.17774-1-mhartmay@linux.ibm.com>
References: <20200812092705.17774-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-12_02:2020-08-11,2020-08-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 impostorscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008120064
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's only useful to run `cmd` in `for_each_unittest` if a test case
was found. This change allows us to remove the guards from the
functions `run_task` and `mkstandalone`.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 run_tests.sh            | 3 ---
 scripts/common.bash     | 8 ++++++--
 scripts/mkstandalone.sh | 4 ----
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/run_tests.sh b/run_tests.sh
index 01e36dcfa06e..24aba9cc3a98 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -126,9 +126,6 @@ RUNTIME_log_stdout () {
 function run_task()
 {
 	local testname="$1"
-	if [ -z "$testname" ]; then
-		return
-	fi
 
 	while (( $(jobs | wc -l) == $unittest_run_queues )); do
 		# wait for any background test to finish
diff --git a/scripts/common.bash b/scripts/common.bash
index 9a6ebbd7f287..96655c9ffd1f 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -17,7 +17,9 @@ function for_each_unittest()
 
 	while read -r -u $fd line; do
 		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
-			"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+			if [ -n "${testname}" ]; then
+				"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+			fi
 			testname=${BASH_REMATCH[1]}
 			smp=1
 			kernel=""
@@ -45,6 +47,8 @@ function for_each_unittest()
 			timeout=${BASH_REMATCH[1]}
 		fi
 	done
-	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+	if [ -n "${testname}" ]; then
+		"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+	fi
 	exec {fd}<&-
 }
diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index 9d506cc95072..cefdec30cb33 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -83,10 +83,6 @@ function mkstandalone()
 {
 	local testname="$1"
 
-	if [ -z "$testname" ]; then
-		return
-	fi
-
 	if [ -n "$one_testname" ] && [ "$testname" != "$one_testname" ]; then
 		return
 	fi
-- 
2.25.4

