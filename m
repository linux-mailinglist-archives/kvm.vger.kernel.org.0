Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8624D32127A
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 10:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbhBVJAC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 04:00:02 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59312 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229518AbhBVI76 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 03:59:58 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11M8xGrZ089676;
        Mon, 22 Feb 2021 03:59:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=aicl9r5ua1wlj46BMs5yCw3wpwYzwZorUfpR39KQ8oo=;
 b=VKRZR4RTQYB/hmFHT1RfLOKFa/sl9K6HI6d8o8UM7S3hMw1o43f1N9tLbc1V/Yb0n6p0
 DhlQi+K7vIhuErBZcY1//r2DiC/6oO5EnGgurHsc9ocnsBYuUTFhlX6BE3PyV2F5x+PO
 b45fRfuFOfGt1JCisBrtdU40CDV7rnikHTrq1Mk1YVeoE315J+YxACWjonzp1ZsaYsIW
 f3LJe/75p89cqEJ7U4HSGM31wVc7n5Pd0L6IYjojOVbiF1MY258AmksQs5PiKRvqvcEN
 8pUdS/Dg3jjXv65IiW8bOteMjrhXaWJHiJthenncE58opwSy+nzpB/50bQhWUOWXDyFJ mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36v9k2g01m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 03:59:16 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11M8xGlP089645;
        Mon, 22 Feb 2021 03:59:16 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36v9k2g00u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 03:59:15 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11M8xE71030690;
        Mon, 22 Feb 2021 08:59:14 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 36tt28rray-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 08:59:14 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11M8xBfN49349020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Feb 2021 08:59:11 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17A64AE056;
        Mon, 22 Feb 2021 08:59:11 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6CB22AE045;
        Mon, 22 Feb 2021 08:59:10 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 22 Feb 2021 08:59:10 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 3/7] s390x: Introduce and use CALL_INT_HANDLER macro
Date:   Mon, 22 Feb 2021 03:57:52 -0500
Message-Id: <20210222085756.14396-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210222085756.14396-1-frankja@linux.ibm.com>
References: <20210222085756.14396-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-22_02:2021-02-18,2021-02-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=973 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 spamscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102220071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ELF ABI dictates that we need to allocate 160 bytes of stack space
for the C functions we're calling. Since we would need to do that for
every interruption handler which, combined with the new stack argument
being saved in GR2, makes cstart64.S look a bit messy.

So let's introduce the CALL_INT_HANDLER macro that handles all of
that, calls the C interrupt handler and handles cleanup afterwards.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/cstart64.S | 28 +++++-----------------------
 s390x/macros.S   | 17 +++++++++++++++++
 2 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 35d20293..666a9567 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -92,37 +92,19 @@ memsetxc:
 
 .section .text
 pgm_int:
-	SAVE_REGS_STACK
-	lgr     %r2, %r15
-	brasl	%r14, handle_pgm_int
-	RESTORE_REGS_STACK
-	lpswe	GEN_LC_PGM_OLD_PSW
+	CALL_INT_HANDLER handle_pgm_int, GEN_LC_PGM_OLD_PSW
 
 ext_int:
-	SAVE_REGS_STACK
-	lgr     %r2, %r15
-	brasl	%r14, handle_ext_int
-	RESTORE_REGS_STACK
-	lpswe	GEN_LC_EXT_OLD_PSW
+	CALL_INT_HANDLER handle_ext_int, GEN_LC_EXT_OLD_PSW
 
 mcck_int:
-	SAVE_REGS_STACK
-	brasl	%r14, handle_mcck_int
-	RESTORE_REGS_STACK
-	lpswe	GEN_LC_MCCK_OLD_PSW
+	CALL_INT_HANDLER handle_mcck_int, GEN_LC_MCCK_OLD_PSW
 
 io_int:
-	SAVE_REGS_STACK
-	lgr     %r2, %r15
-	brasl	%r14, handle_io_int
-	RESTORE_REGS_STACK
-	lpswe	GEN_LC_IO_OLD_PSW
+	CALL_INT_HANDLER handle_io_int, GEN_LC_IO_OLD_PSW
 
 svc_int:
-	SAVE_REGS_STACK
-	brasl	%r14, handle_svc_int
-	RESTORE_REGS_STACK
-	lpswe	GEN_LC_SVC_OLD_PSW
+	CALL_INT_HANDLER handle_svc_int, GEN_LC_SVC_OLD_PSW
 
 	.align	8
 initial_psw:
diff --git a/s390x/macros.S b/s390x/macros.S
index a7d62c6f..11f4397a 100644
--- a/s390x/macros.S
+++ b/s390x/macros.S
@@ -11,6 +11,23 @@
  *  David Hildenbrand <david@redhat.com>
  */
 #include <asm/asm-offsets.h>
+/*
+ * Exception handler macro that saves registers on the stack,
+ * allocates stack space and calls the C handler function. Afterwards
+ * we re-load the registers and load the old PSW.
+ */
+	.macro CALL_INT_HANDLER c_func, old_psw
+	SAVE_REGS_STACK
+	/* Save the stack address in GR2 which is the first function argument */
+	lgr     %r2, %r15
+	/* Allocate stack space for called C function, as specified in s390 ELF ABI */
+	slgfi   %r15, 160
+	brasl	%r14, \c_func
+	algfi   %r15, 160
+	RESTORE_REGS_STACK
+	lpswe	\old_psw
+	.endm
+
 	.macro SAVE_REGS
 	/* save grs 0-15 */
 	stmg	%r0, %r15, GEN_LC_SW_INT_GRS
-- 
2.25.1

