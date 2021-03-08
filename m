Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44DB3310E1
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 15:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhCHOd4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 09:33:56 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26788 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229797AbhCHOdr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 09:33:47 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128EWqdG188252;
        Mon, 8 Mar 2021 09:33:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ham2dK2fY5OiMoZYAMmsJxpiGcqzxpu3SIdpjxCzXME=;
 b=jb2VAN9ot8U7f1DXPSU5V3F/yG6fYvHnBQPDcF75hMCskWE9UXSTdkRTiNuicvpk+x+4
 7r/P0sb+tonVPLVtBOGtjCAVEUsUoeEKSmbkev2u0y4cDkr8LQRxXajpNGF3p4v95h43
 Jkd6lMf4DbInavzLvGvsJ3JmggtUrhWZ1kYp1f4YqQc0U02etH9KCRP9DF8RRfws6wHR
 AGx/i4iaj7J1o9eELm1dnvlbMhTCs6WcaLtOt5/5LM70gPAXqMRrwNWwWSWmvzvQevbN
 nkb01+OldIn7Bku/CHWWPAd3bnP4XhvBYotmI3i7gSN/ITVE2E0aqimkUyzsgIYZUTjf dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375njbrg8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:33:47 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128EXTMx194066;
        Mon, 8 Mar 2021 09:33:46 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375njbrg7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:33:46 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128EXimo017746;
        Mon, 8 Mar 2021 14:33:44 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3741c81029-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 14:33:44 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128EXff348038372
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 14:33:41 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FB1AA4040;
        Mon,  8 Mar 2021 14:33:41 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C708CA404D;
        Mon,  8 Mar 2021 14:33:40 +0000 (GMT)
Received: from fedora.fritz.box (unknown [9.145.7.187])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 14:33:40 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 08/16] s390x: Fully commit to stack save area for exceptions
Date:   Mon,  8 Mar 2021 15:31:39 +0100
Message-Id: <20210308143147.64755-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308143147.64755-1-frankja@linux.ibm.com>
References: <20210308143147.64755-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_08:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 mlxscore=0 priorityscore=1501 clxscore=1015 impostorscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103080080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Having two sets of macros for saving registers on exceptions makes
maintaining harder. Also we have limited space in the lowcore to save
stuff and by using the stack as a save area, we can stack exceptions.

So let's use the SAVE/RESTORE_REGS_STACK as the default. When we also
move the diag308 macro over we can remove the old SAVE/RESTORE_REGS
macros.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/asm-offsets.c   | 15 ++++++++----
 lib/s390x/asm/arch_def.h  | 31 ++++++++++++++++++++-----
 lib/s390x/asm/interrupt.h |  4 ++--
 lib/s390x/interrupt.c     | 20 ++++++++++------
 s390x/cstart64.S          | 18 ++++++++-------
 s390x/macros.S            | 48 +++++++++++++++++++++++----------------
 6 files changed, 90 insertions(+), 46 deletions(-)

diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
index a19f14b9..2658b59a 100644
--- a/lib/s390x/asm-offsets.c
+++ b/lib/s390x/asm-offsets.c
@@ -70,16 +70,23 @@ int main(void)
 	OFFSET(GEN_LC_ARS_SA, lowcore, ars_sa);
 	OFFSET(GEN_LC_CRS_SA, lowcore, crs_sa);
 	OFFSET(GEN_LC_PGM_INT_TDB, lowcore, pgm_int_tdb);
-	OFFSET(__SF_SIE_CONTROL, stack_frame, empty1[0]);
-	OFFSET(__SF_SIE_SAVEAREA, stack_frame, empty1[1]);
-	OFFSET(__SF_SIE_REASON, stack_frame, empty1[2]);
-	OFFSET(__SF_SIE_FLAGS, stack_frame, empty1[3]);
+	OFFSET(__SF_SIE_CONTROL, stack_frame, argument_area[0]);
+	OFFSET(__SF_SIE_SAVEAREA, stack_frame, argument_area[1]);
+	OFFSET(__SF_SIE_REASON, stack_frame, argument_area[2]);
+	OFFSET(__SF_SIE_FLAGS, stack_frame, argument_area[3]);
 	OFFSET(SIE_SAVEAREA_HOST_GRS, vm_save_area, host.grs[0]);
 	OFFSET(SIE_SAVEAREA_HOST_FPRS, vm_save_area, host.fprs[0]);
 	OFFSET(SIE_SAVEAREA_HOST_FPC, vm_save_area, host.fpc);
 	OFFSET(SIE_SAVEAREA_GUEST_GRS, vm_save_area, guest.grs[0]);
 	OFFSET(SIE_SAVEAREA_GUEST_FPRS, vm_save_area, guest.fprs[0]);
 	OFFSET(SIE_SAVEAREA_GUEST_FPC, vm_save_area, guest.fpc);
+	OFFSET(STACK_FRAME_INT_BACKCHAIN, stack_frame_int, back_chain);
+	OFFSET(STACK_FRAME_INT_FPC, stack_frame_int, fpc);
+	OFFSET(STACK_FRAME_INT_FPRS, stack_frame_int, fprs);
+	OFFSET(STACK_FRAME_INT_CRS, stack_frame_int, crs);
+	OFFSET(STACK_FRAME_INT_GRS0, stack_frame_int, grs0);
+	OFFSET(STACK_FRAME_INT_GRS1, stack_frame_int, grs1);
+	DEFINE(STACK_FRAME_INT_SIZE, sizeof(struct stack_frame_int));
 
 	return 0;
 }
diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 9c4e330a..b8e9fe40 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -8,13 +8,32 @@
 #ifndef _ASM_S390X_ARCH_DEF_H_
 #define _ASM_S390X_ARCH_DEF_H_
 
-/*
- * We currently only specify the stack frame members needed for the
- * SIE library code.
- */
 struct stack_frame {
-	unsigned long back_chain;
-	unsigned long empty1[5];
+	struct stack_frame *back_chain;
+	uint64_t reserved;
+	/* GRs 2 - 5 */
+	uint64_t argument_area[4];
+	/* GRs 6 - 15 */
+	uint64_t grs[10];
+	/* FPRs 0, 2, 4, 6 */
+	int64_t  fprs[4];
+};
+
+struct stack_frame_int {
+	struct stack_frame *back_chain;
+	uint64_t reserved;
+	/*
+	 * The GRs are offset compatible with struct stack_frame so we
+	 * can easily fetch GR14 for backtraces.
+	 */
+	/* GRs 2 - 15 */
+	uint64_t grs0[14];
+	/* GRs 0 and 1 */
+	uint64_t grs1[2];
+	uint32_t reserved1;
+	uint32_t fpc;
+	uint64_t fprs[16];
+	uint64_t crs[16];
 };
 
 struct psw {
diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
index 1a2e2cd8..31e4766d 100644
--- a/lib/s390x/asm/interrupt.h
+++ b/lib/s390x/asm/interrupt.h
@@ -14,8 +14,8 @@
 #define EXT_IRQ_SERVICE_SIG	0x2401
 
 void register_pgm_cleanup_func(void (*f)(void));
-void handle_pgm_int(void);
-void handle_ext_int(void);
+void handle_pgm_int(struct stack_frame_int *stack);
+void handle_ext_int(struct stack_frame_int *stack);
 void handle_mcck_int(void);
 void handle_io_int(void);
 void handle_svc_int(void);
diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 1ce36073..46ae0bd7 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -56,7 +56,7 @@ void register_pgm_cleanup_func(void (*f)(void))
 	pgm_cleanup_func = f;
 }
 
-static void fixup_pgm_int(void)
+static void fixup_pgm_int(struct stack_frame_int *stack)
 {
 	/* If we have an error on SIE we directly move to sie_exit */
 	if (lc->pgm_old_psw.addr >= (uint64_t)&sie_entry &&
@@ -76,7 +76,13 @@ static void fixup_pgm_int(void)
 		/* Handling for iep.c test case. */
 		if (lc->trans_exc_id & 0x80UL && lc->trans_exc_id & 0x04UL &&
 		    !(lc->trans_exc_id & 0x08UL))
-			lc->pgm_old_psw.addr = lc->sw_int_grs[14];
+			/*
+			 * We branched to the instruction that caused
+			 * the exception so we can use the return
+			 * address in GR14 to jump back and continue
+			 * executing test code.
+			 */
+			lc->pgm_old_psw.addr = stack->grs0[12];
 		break;
 	case PGM_INT_CODE_SEGMENT_TRANSLATION:
 	case PGM_INT_CODE_PAGE_TRANSLATION:
@@ -115,7 +121,7 @@ static void fixup_pgm_int(void)
 	/* suppressed/terminated/completed point already at the next address */
 }
 
-void handle_pgm_int(void)
+void handle_pgm_int(struct stack_frame_int *stack)
 {
 	if (!pgm_int_expected) {
 		/* Force sclp_busy to false, otherwise we will loop forever */
@@ -130,10 +136,10 @@ void handle_pgm_int(void)
 	if (pgm_cleanup_func)
 		(*pgm_cleanup_func)();
 	else
-		fixup_pgm_int();
+		fixup_pgm_int(stack);
 }
 
-void handle_ext_int(void)
+void handle_ext_int(struct stack_frame_int *stack)
 {
 	if (!ext_int_expected &&
 	    lc->ext_int_code != EXT_IRQ_SERVICE_SIG) {
@@ -143,13 +149,13 @@ void handle_ext_int(void)
 	}
 
 	if (lc->ext_int_code == EXT_IRQ_SERVICE_SIG) {
-		lc->sw_int_crs[0] &= ~(1UL << 9);
+		stack->crs[0] &= ~(1UL << 9);
 		sclp_handle_ext();
 	} else {
 		ext_int_expected = false;
 	}
 
-	if (!(lc->sw_int_crs[0] & CR0_EXTM_MASK))
+	if (!(stack->crs[0] & CR0_EXTM_MASK))
 		lc->ext_old_psw.mask &= ~PSW_MASK_EXT;
 }
 
diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index ace0c0d9..ad0e2145 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -92,21 +92,23 @@ memsetxc:
 
 .section .text
 pgm_int:
-	SAVE_REGS
+	SAVE_REGS_STACK
+	lgr     %r2, %r15
 	brasl	%r14, handle_pgm_int
-	RESTORE_REGS
+	RESTORE_REGS_STACK
 	lpswe	GEN_LC_PGM_OLD_PSW
 
 ext_int:
-	SAVE_REGS
+	SAVE_REGS_STACK
+	lgr     %r2, %r15
 	brasl	%r14, handle_ext_int
-	RESTORE_REGS
+	RESTORE_REGS_STACK
 	lpswe	GEN_LC_EXT_OLD_PSW
 
 mcck_int:
-	SAVE_REGS
+	SAVE_REGS_STACK
 	brasl	%r14, handle_mcck_int
-	RESTORE_REGS
+	RESTORE_REGS_STACK
 	lpswe	GEN_LC_MCCK_OLD_PSW
 
 io_int:
@@ -116,9 +118,9 @@ io_int:
 	lpswe	GEN_LC_IO_OLD_PSW
 
 svc_int:
-	SAVE_REGS
+	SAVE_REGS_STACK
 	brasl	%r14, handle_svc_int
-	RESTORE_REGS
+	RESTORE_REGS_STACK
 	lpswe	GEN_LC_SVC_OLD_PSW
 
 	.align	8
diff --git a/s390x/macros.S b/s390x/macros.S
index e51a557a..a7d62c6f 100644
--- a/s390x/macros.S
+++ b/s390x/macros.S
@@ -3,9 +3,10 @@
  * s390x assembly macros
  *
  * Copyright (c) 2017 Red Hat Inc
- * Copyright (c) 2020 IBM Corp.
+ * Copyright (c) 2020, 2021 IBM Corp.
  *
  * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
  *  Pierre Morel <pmorel@linux.ibm.com>
  *  David Hildenbrand <david@redhat.com>
  */
@@ -41,36 +42,45 @@
 
 /* Save registers on the stack (r15), so we can have stacked interrupts. */
 	.macro SAVE_REGS_STACK
-	/* Allocate a stack frame for 15 general registers */
-	slgfi   %r15, 15 * 8
+	/* Allocate a full stack frame */
+	slgfi   %r15, STACK_FRAME_INT_SIZE
 	/* Store registers r0 to r14 on the stack */
-	stmg    %r0, %r14, 0(%r15)
-	/* Allocate a stack frame for 16 floating point registers */
-	/* The size of a FP register is the size of an double word */
-	slgfi   %r15, 16 * 8
+	stmg    %r2, %r15, STACK_FRAME_INT_GRS0(%r15)
+	stg     %r0, STACK_FRAME_INT_GRS1(%r15)
+	stg     %r1, STACK_FRAME_INT_GRS1 + 8(%r15)
+	/* Store the gr15 value before we allocated the new stack */
+	lgr     %r0, %r15
+	algfi   %r0, STACK_FRAME_INT_SIZE
+	stg     %r0, 13 * 8 + STACK_FRAME_INT_GRS0(%r15)
+	stg     %r0, STACK_FRAME_INT_BACKCHAIN(%r15)
+	/*
+	 * Store CR0 and load initial CR0 so AFP is active and we can
+	 * access all fprs to save them.
+	 */
+	stctg   %c0,%c15,STACK_FRAME_INT_CRS(%r15)
+	larl	%r1, initial_cr0
+	lctlg	%c0, %c0, 0(%r1)
 	/* Save fp register on stack: offset to SP is multiple of reg number */
 	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
-	std	\i, \i * 8(%r15)
+	std	\i, \i * 8 + STACK_FRAME_INT_FPRS(%r15)
 	.endr
-	/* Save fpc, but keep stack aligned on 64bits */
-	slgfi   %r15, 8
-	stfpc	0(%r15)
+	/* Save fpc */
+	stfpc	STACK_FRAME_INT_FPC(%r15)
 	.endm
 
 /* Restore the register in reverse order */
 	.macro RESTORE_REGS_STACK
 	/* Restore fpc */
-	lfpc	0(%r15)
-	algfi	%r15, 8
+	lfpc	STACK_FRAME_INT_FPC(%r15)
 	/* Restore fp register from stack: SP still where it was left */
 	/* and offset to SP is a multiple of reg number */
 	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
-	ld	\i, \i * 8(%r15)
+	ld	\i, \i * 8 + STACK_FRAME_INT_FPRS(%r15)
 	.endr
-	/* Now that we're done, rewind the stack pointer by 16 double word */
-	algfi   %r15, 16 * 8
+	/* Load CR0 back */
+	lctlg	%c0, %c15, STACK_FRAME_INT_CRS(%r15)
 	/* Load the registers from stack */
-	lmg     %r0, %r14, 0(%r15)
-	/* Rewind the stack by 15 double word */
-	algfi   %r15, 15 * 8
+	lg      %r0, STACK_FRAME_INT_GRS1(%r15)
+	lg      %r1, STACK_FRAME_INT_GRS1 + 8(%r15)
+	lmg     %r2, %r15, STACK_FRAME_INT_GRS0(%r15)
 	.endm
-- 
2.29.2

