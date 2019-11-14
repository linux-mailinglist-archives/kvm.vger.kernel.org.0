Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD6A8FB051
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 13:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfKMMX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 07:23:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59194 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726449AbfKMMX0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 07:23:26 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xADCIG5N111667
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 07:23:24 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w8hdn93ux-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 07:23:24 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Wed, 13 Nov 2019 12:23:22 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 13 Nov 2019 12:23:21 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xADCMil528901810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 12:22:44 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 849714C044;
        Wed, 13 Nov 2019 12:23:20 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4810A4C046;
        Wed, 13 Nov 2019 12:23:20 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.55])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Nov 2019 12:23:20 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com
Subject: [PATCH v1 1/4] s390x: saving regs for interrupts
Date:   Wed, 13 Nov 2019 13:23:16 +0100
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573647799-30584-1-git-send-email-pmorel@linux.ibm.com>
References: <1573647799-30584-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111312-0028-0000-0000-000003B686E9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111312-0029-0000-0000-000024798E7F
Message-Id: <1573647799-30584-2-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-13_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=693 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911130116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If we use multiple source of interrupts, for exemple, using SCLP console
to print information while using I/O interrupts or during exceptions, we
need to have a re-entrant register saving interruption handling.

Instead of saving at a static place, let's save the base registers on
the stack.

Note that we keep the static register saving that we need for the RESET
tests.

We also care to give the handlers a pointer to the save registers in
case the handler needs it (fixup_pgm_int needs the old psw address).

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/asm/interrupt.h | 15 ++++++++++-----
 lib/s390x/interrupt.c     | 16 ++++++++--------
 s390x/cstart64.S          | 17 ++++++++++++++---
 3 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
index 4cfade9..a39a3a3 100644
--- a/lib/s390x/asm/interrupt.h
+++ b/lib/s390x/asm/interrupt.h
@@ -15,11 +15,16 @@
 #define EXT_IRQ_EXTERNAL_CALL	0x1202
 #define EXT_IRQ_SERVICE_SIG	0x2401
 
-void handle_pgm_int(void);
-void handle_ext_int(void);
-void handle_mcck_int(void);
-void handle_io_int(void);
-void handle_svc_int(void);
+typedef struct saved_registers {
+        unsigned long regs[15];
+} sregs_t;
+
+void handle_pgm_int(sregs_t *regs);
+void handle_ext_int(sregs_t *regs);
+void handle_mcck_int(sregs_t *regs);
+void handle_io_int(sregs_t *regs);
+void handle_svc_int(sregs_t *regs);
+
 void expect_pgm_int(void);
 void expect_ext_int(void);
 uint16_t clear_pgm_int(void);
diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 5cade23..7aecfc5 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -50,7 +50,7 @@ void check_pgm_int_code(uint16_t code)
 	       code == lc->pgm_int_code, code, lc->pgm_int_code);
 }
 
-static void fixup_pgm_int(void)
+static void fixup_pgm_int(sregs_t *regs)
 {
 	switch (lc->pgm_int_code) {
 	case PGM_INT_CODE_PRIVILEGED_OPERATION:
@@ -64,7 +64,7 @@ static void fixup_pgm_int(void)
 		/* Handling for iep.c test case. */
 		if (lc->trans_exc_id & 0x80UL && lc->trans_exc_id & 0x04UL &&
 		    !(lc->trans_exc_id & 0x08UL))
-			lc->pgm_old_psw.addr = lc->sw_int_grs[14];
+			lc->pgm_old_psw.addr = regs->regs[14];
 		break;
 	case PGM_INT_CODE_SEGMENT_TRANSLATION:
 	case PGM_INT_CODE_PAGE_TRANSLATION:
@@ -103,7 +103,7 @@ static void fixup_pgm_int(void)
 	/* suppressed/terminated/completed point already at the next address */
 }
 
-void handle_pgm_int(void)
+void handle_pgm_int(sregs_t *regs)
 {
 	if (!pgm_int_expected)
 		report_abort("Unexpected program interrupt: %d at %#lx, ilen %d\n",
@@ -111,10 +111,10 @@ void handle_pgm_int(void)
 			     lc->pgm_int_id);
 
 	pgm_int_expected = false;
-	fixup_pgm_int();
+	fixup_pgm_int(regs);
 }
 
-void handle_ext_int(void)
+void handle_ext_int(sregs_t *regs)
 {
 	if (!ext_int_expected &&
 	    lc->ext_int_code != EXT_IRQ_SERVICE_SIG) {
@@ -134,19 +134,19 @@ void handle_ext_int(void)
 		lc->ext_old_psw.mask &= ~PSW_MASK_EXT;
 }
 
-void handle_mcck_int(void)
+void handle_mcck_int(sregs_t *regs)
 {
 	report_abort("Unexpected machine check interrupt: at %#lx",
 		     lc->mcck_old_psw.addr);
 }
 
-void handle_io_int(void)
+void handle_io_int(sregs_t *regs)
 {
 	report_abort("Unexpected io interrupt: at %#lx",
 		     lc->io_old_psw.addr);
 }
 
-void handle_svc_int(void)
+void handle_svc_int(sregs_t *regs)
 {
 	report_abort("Unexpected supervisor call interrupt: at %#lx",
 		     lc->svc_old_psw.addr);
diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 8e2b21e..eaff481 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -90,6 +90,17 @@ memsetxc:
 	xc 0(1,%r1),0(%r1)
 
 	.macro SAVE_REGS
+	slgfi	%r15, 15 * 8
+	stmg	%r0, %r14, 0(%r15)
+	lgr	%r2, %r15
+	.endm
+
+	.macro RESTORE_REGS
+	lmg     %r0, %r14, 0(%r15)
+	algfi   %r15, 15 * 8
+	.endm
+
+	.macro SAVE_REGS_RESET
 	/* save grs 0-15 */
 	stmg	%r0, %r15, GEN_LC_SW_INT_GRS
 	/* save cr0 */
@@ -105,7 +116,7 @@ memsetxc:
 	stfpc	GEN_LC_SW_INT_FPC
 	.endm
 
-	.macro RESTORE_REGS
+	.macro RESTORE_REGS_RESET
 	/* restore fprs 0-15 + fpc */
 	la	%r1, GEN_LC_SW_INT_FPRS
 	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
@@ -125,7 +136,7 @@ memsetxc:
  */
 .globl diag308_load_reset
 diag308_load_reset:
-	SAVE_REGS
+	SAVE_REGS_RESET
 	/* Save the first PSW word to the IPL PSW */
 	epsw	%r0, %r1
 	st	%r0, 0
@@ -142,7 +153,7 @@ diag308_load_reset:
 	/* We lost cr0 due to the reset */
 0:	larl	%r1, initial_cr0
 	lctlg	%c0, %c0, 0(%r1)
-	RESTORE_REGS
+	RESTORE_REGS_RESET
 	lhi	%r2, 1
 	br	%r14
 
-- 
2.7.4

