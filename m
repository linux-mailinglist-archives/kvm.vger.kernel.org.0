Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3653405F5
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 13:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbhCRMp3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 08:45:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36756 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231288AbhCRMpS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 08:45:18 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12ICXgeO181150
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 08:45:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=iokZsD+ZIMIwe/b1kJBsFdMzqpZQBgb9PIpdseOdxx0=;
 b=Ww4i8WCzTmnN+ub4AIIenB18rUJcB27wtPb7TfNpA40lXvZal4AVyqFYeRD1wYTSxbVj
 9Qozs/XxXzunk6jR5KxNUC04V5mhC001vgHM2hzFEUtF74FQGHOXJRM4gJTM7EUJl4LE
 bdWFFPzA/veb2DE9jggpAY8qYrDY8hG16rzHZPdn98GUgxcHJpn438fnhepOwJhyER6r
 Tw9Sk6RAywu6AZ9bIwLAO7C5pRZGJOMKe6YM7LkwoWTkqV/nHO9vzTT/wETnGcV54gYa
 IyQXBYmVVyt7TA9mwn4UpSXRHO5M6OA8YhfBkc2f+8PCYXW5k60pFep0BuLcYF/WSTVW wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37c10fjtvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 08:45:17 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12ICXwXr182858
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 08:45:17 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37c10fjtv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 08:45:17 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12ICRliA004910;
        Thu, 18 Mar 2021 12:45:15 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 378n18ms7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 12:45:14 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12ICjCO411338030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 12:45:12 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D8F942045;
        Thu, 18 Mar 2021 12:45:12 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A0A242057;
        Thu, 18 Mar 2021 12:45:11 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.24.61])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Mar 2021 12:45:11 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     lvivier@redhat.com, thuth@redhat.com, david@redhat.com,
        drjones@redhat.com, pbonzini@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests RFC 1/2] scripts: Check kvm availability by asking qemu
Date:   Thu, 18 Mar 2021 12:44:59 +0000
Message-Id: <20210318124500.45447-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210318124500.45447-1-frankja@linux.ibm.com>
References: <20210318124500.45447-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_07:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 suspectscore=0 mlxlogscore=994
 adultscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103180095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The existence of the /dev/kvm character device doesn't imply that the
kvm module is part of the kernel or that it's always magically loaded
when needed.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arm/run               | 4 ++--
 powerpc/run           | 4 ++--
 s390x/run             | 4 ++--
 scripts/arch-run.bash | 7 +++++--
 x86/run               | 4 ++--
 5 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/arm/run b/arm/run
index a390ca5a..ca2d44e0 100755
--- a/arm/run
+++ b/arm/run
@@ -10,10 +10,10 @@ if [ -z "$STANDALONE" ]; then
 fi
 processor="$PROCESSOR"
 
-ACCEL=$(get_qemu_accelerator) ||
+qemu=$(search_qemu_binary) ||
 	exit $?
 
-qemu=$(search_qemu_binary) ||
+ACCEL=$(get_qemu_accelerator) ||
 	exit $?
 
 if ! $qemu -machine '?' 2>&1 | grep 'ARM Virtual Machine' > /dev/null; then
diff --git a/powerpc/run b/powerpc/run
index 597ab96e..b51ac6fc 100755
--- a/powerpc/run
+++ b/powerpc/run
@@ -9,10 +9,10 @@ if [ -z "$STANDALONE" ]; then
 	source scripts/arch-run.bash
 fi
 
-ACCEL=$(get_qemu_accelerator) ||
+qemu=$(search_qemu_binary) ||
 	exit $?
 
-qemu=$(search_qemu_binary) ||
+ACCEL=$(get_qemu_accelerator) ||
 	exit $?
 
 if ! $qemu -machine '?' 2>&1 | grep 'pseries' > /dev/null; then
diff --git a/s390x/run b/s390x/run
index 09805044..2ec6da70 100755
--- a/s390x/run
+++ b/s390x/run
@@ -9,10 +9,10 @@ if [ -z "$STANDALONE" ]; then
 	source scripts/arch-run.bash
 fi
 
-ACCEL=$(get_qemu_accelerator) ||
+qemu=$(search_qemu_binary) ||
 	exit $?
 
-qemu=$(search_qemu_binary) ||
+ACCEL=$(get_qemu_accelerator) ||
 	exit $?
 
 M='-machine s390-ccw-virtio'
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 5997e384..8cc9a61e 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -342,8 +342,11 @@ trap_exit_push ()
 
 kvm_available ()
 {
-	[ -c /dev/kvm ] ||
-		return 1
+	if $($qemu -accel kvm 2> /dev/null); then
+		return 0;
+	else
+		return 1;
+	fi
 
 	[ "$HOST" = "$ARCH_NAME" ] ||
 		( [ "$HOST" = aarch64 ] && [ "$ARCH" = arm ] ) ||
diff --git a/x86/run b/x86/run
index 8b2425f4..cbf49143 100755
--- a/x86/run
+++ b/x86/run
@@ -9,10 +9,10 @@ if [ -z "$STANDALONE" ]; then
 	source scripts/arch-run.bash
 fi
 
-ACCEL=$(get_qemu_accelerator) ||
+qemu=$(search_qemu_binary) ||
 	exit $?
 
-qemu=$(search_qemu_binary) ||
+ACCEL=$(get_qemu_accelerator) ||
 	exit $?
 
 if ! ${qemu} -device '?' 2>&1 | grep -F -e \"testdev\" -e \"pc-testdev\" > /dev/null;
-- 
2.27.0

