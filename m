Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DB631DBA7
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 15:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233572AbhBQOnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 09:43:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45930 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233557AbhBQOnJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 09:43:09 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11HEVceZ007709;
        Wed, 17 Feb 2021 09:42:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=yDNNIpw75coDq2VlwbsKJJe2Tqsimvi4czW3X5yIAAo=;
 b=RWcdTa4GN9Glhs4sSNq2dLcJyfRNyJknV66ZQR1vrd2JFYY7R0NXUVyyo/WTg7rbKcCC
 Vhz5omP5IxWIpecPiKD5SGNgLnRi1sKkF7fvExMAegael+QP9OjCnP0TBfmrQ9ROQFTG
 yQ7j7OE7S3HVMG0/r0pKWH5E/q13cZzjBMQtVkbURCsJGlZiJpkFgzwcg4Uh5tpU3rtq
 wHxlFCEGbbtW/yPncfYFpSIMC2m5RIEVOVWzELc4gakzATK6auygcS1P5KKQpP5/0nyq
 vg49dJDjY4ixz5quFnFM8Ref7z+UtVhXnbrpNDkR5kSpcLsPHQ7tK8RF4szoTMJSE0/G 3w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36s4uk0sh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 09:42:29 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11HEVdpw007925;
        Wed, 17 Feb 2021 09:42:28 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36s4uk0sga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 09:42:28 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11HEYuBG022595;
        Wed, 17 Feb 2021 14:42:26 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 36p6d89yj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 14:42:26 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11HEgBta34799874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 14:42:11 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9E5A11C052;
        Wed, 17 Feb 2021 14:42:22 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 426B311C058;
        Wed, 17 Feb 2021 14:42:22 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Feb 2021 14:42:22 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 4/8] s390x: Introduce and use CALL_INT_HANDLER macro
Date:   Wed, 17 Feb 2021 09:41:12 -0500
Message-Id: <20210217144116.3368-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210217144116.3368-1-frankja@linux.ibm.com>
References: <20210217144116.3368-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-17_11:2021-02-16,2021-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 adultscore=0 spamscore=0 clxscore=1015 mlxlogscore=952 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170109
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
index a7d62c6f..212a3823 100644
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
+	/* Allocate stack pace for called C function, as specified in s390 ELF ABI */
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

