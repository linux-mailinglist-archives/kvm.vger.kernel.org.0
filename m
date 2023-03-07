Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 482B76AD9F7
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 10:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbjCGJL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 04:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbjCGJLV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 04:11:21 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC40052934
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 01:11:13 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3277gOP5030658
        for <kvm@vger.kernel.org>; Tue, 7 Mar 2023 09:11:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=XxKPJTd2L5GIjADK1WRww3bpPjxJLjQIBvYps2w4IQo=;
 b=S19os1ldyxu6Gm3s9LmdFVJiezA34YRKb9p6IiCnsxpCpxQYql5rNGVkPPQVMci1pweT
 TlLhUr0VqS6c2/+vDXH8re8gEKS7o6AnpNVwdwP+p0ft8ULWH26ogL5M+Moce3gGb9nz
 wnzOYAOKWF1sqjJTxUf/GH874qPAWIsV0dM4UurFbrf0yTEC+dpRP9OUcZdzNdi+Noyw
 sUm5TFRy90fubjAGZ7pIeRHr4F2/ELwgtrKWBojMRMpn8xUOysfuD8AVeUAEyYBGpLSM
 2BNqZ0txvwspOBrV/rAZSuKjY14vRzp0qd3+Iq3aNtlR3s+lbBBvif019OJKLwpwSg93 MA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p513ff2jw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 09:11:12 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3279BCKI022949
        for <kvm@vger.kernel.org>; Tue, 7 Mar 2023 09:11:12 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p513ff2j6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Mar 2023 09:11:12 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 326MkTum001841;
        Tue, 7 Mar 2023 09:11:10 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3p4192b4cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Mar 2023 09:11:10 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3279B60G983710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Mar 2023 09:11:07 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4BB220043;
        Tue,  7 Mar 2023 09:11:06 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C0EF20040;
        Tue,  7 Mar 2023 09:11:06 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com.com (unknown [9.171.61.17])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  7 Mar 2023 09:11:06 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH v3 6/7] s390x: define a macro for the stack frame size
Date:   Tue,  7 Mar 2023 10:10:50 +0100
Message-Id: <20230307091051.13945-7-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307091051.13945-1-mhartmay@linux.ibm.com>
References: <20230307091051.13945-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Mlg2uiSoigOlGhqjxGyoevKH_kas20-X
X-Proofpoint-GUID: RUIslHlhCH266Su5DEcGzO5UWAuGoMuY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_02,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303070082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define and use a macro for the stack frame size. While at it, fix
whitespace in the `gs_handler_asm` block.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Co-developed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 lib/s390x/asm-offsets.c     |  1 +
 s390x/Makefile              |  2 +-
 s390x/cstart64.S            |  2 +-
 s390x/flat.lds.S            |  4 +++-
 s390x/gs.c                  | 38 +++++++++++++++++++++----------------
 s390x/macros.S              |  4 ++--
 s390x/snippets/c/flat.lds.S |  6 ++++--
 7 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
index f612f3277a95..188dd2e51181 100644
--- a/lib/s390x/asm-offsets.c
+++ b/lib/s390x/asm-offsets.c
@@ -87,6 +87,7 @@ int main(void)
 	OFFSET(STACK_FRAME_INT_GRS0, stack_frame_int, grs0);
 	OFFSET(STACK_FRAME_INT_GRS1, stack_frame_int, grs1);
 	DEFINE(STACK_FRAME_INT_SIZE, sizeof(struct stack_frame_int));
+	DEFINE(STACK_FRAME_SIZE, sizeof(struct stack_frame));
 
 	return 0;
 }
diff --git a/s390x/Makefile b/s390x/Makefile
index e13a04eecb3e..fc8201f7762b 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -160,7 +160,7 @@ $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $(SNIPP
 	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
 
 lds-autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d -MT $@
-%.lds: %.lds.S
+%.lds: %.lds.S $(asm-offsets)
 	$(CPP) $(lds-autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<
 
 .SECONDEXPANSION:
diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 6f83da2a6c0a..468ace3ea4df 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -38,7 +38,7 @@ start:
 	/* setup stack */
 	larl	%r15, stackptr
 	/* Clear first stack frame */
-	xc      0(160,%r15), 0(%r15)
+	xc      0(STACK_FRAME_SIZE,%r15), 0(%r15)
 	/* setup initial PSW mask + control registers*/
 	larl	%r1, initial_psw
 	lpswe	0(%r1)
diff --git a/s390x/flat.lds.S b/s390x/flat.lds.S
index 952f6cd457ed..0cb7e383cc76 100644
--- a/s390x/flat.lds.S
+++ b/s390x/flat.lds.S
@@ -1,3 +1,5 @@
+#include <asm/asm-offsets.h>
+
 SECTIONS
 {
 	.lowcore : {
@@ -44,6 +46,6 @@ SECTIONS
 	/*
 	 * stackptr set with initial stack frame preallocated
 	 */
-	stackptr = . - 160;
+	stackptr = . - STACK_FRAME_SIZE;
 	stacktop = .;
 }
diff --git a/s390x/gs.c b/s390x/gs.c
index 4993eb8f43a9..9ae893eaf89a 100644
--- a/s390x/gs.c
+++ b/s390x/gs.c
@@ -9,6 +9,7 @@
  *    Janosch Frank <frankja@linux.ibm.com>
  */
 #include <libcflat.h>
+#include <asm/asm-offsets.h>
 #include <asm/page.h>
 #include <asm/facility.h>
 #include <asm/interrupt.h>
@@ -35,22 +36,27 @@ static inline unsigned long load_guarded(unsigned long *p)
 
 /* guarded-storage event handler and finally it calls gs_handler */
 extern void gs_handler_asm(void);
-	asm(".globl gs_handler_asm\n"
-	    "gs_handler_asm:\n"
-	    "	    lgr	    %r14,%r15\n" 		/* Save current stack address in r14 */
-	    "	    aghi    %r15,-320\n" 		/* Allocate stack frame */
-	    "	    stmg    %r0,%r13,192(%r15)\n" 	/* Store regs to save area */
-	    "	    stg	    %r14,312(%r15)\n"
-	    "	    la	    %r2,160(%r15)\n" 		/* Store gscb address in this_cb */
-	    "	    .insn   rxy,0xe30000000049,0,160(%r15)\n" /* stgsc */
-	    "	    lg	    %r14,24(%r2)\n" 		/* Get GSEPLA from GSCB*/
-	    "	    lg	    %r14,40(%r14)\n" 		/* Get GSERA from GSEPL*/
-	    "	    stg	    %r14,304(%r15)\n" 		/* Store GSERA in r14 of reg save area */
-	    "	    brasl   %r14,gs_handler\n" 		/* Jump to gs_handler */
-	    "	    lmg	    %r0,%r15,192(%r15)\n" 	/* Restore regs */
-	    "	    aghi    %r14, 6\n" 			/* Add lgg instr len to GSERA */
-	    "	    br	    %r14\n" 			/* Jump to next instruction after lgg */
-	    "	    .size gs_handler_asm,.-gs_handler_asm\n");
+	asm (          ".macro	STGSC	args:vararg\n"
+		"	.insn	rxy,0xe30000000049,\\args\n"
+		"	.endm\n"
+		"	.globl	gs_handler_asm\n"
+		"gs_handler_asm:\n"
+		"	lgr	%r14,%r15\n"				/* Save current stack address in r14 */
+		".Lgs_handler_frame = 16*8+32+" xstr(STACK_FRAME_SIZE) "\n"
+		"	aghi	%r15,-(.Lgs_handler_frame)\n"		/* Allocate stack frame */
+		"	stmg	%r0,%r13,192(%r15)\n"			/* Store regs to save area */
+		"	stg	%r14,312(%r15)\n"
+		"	la	%r2," xstr(STACK_FRAME_SIZE) "(%r15)\n"	/* Store gscb address in this_cb */
+		"	STGSC	%r0," xstr(STACK_FRAME_SIZE) "(%r15)\n"
+		"	lg	%r14,24(%r2)\n"				/* Get GSEPLA from GSCB*/
+		"	lg	%r14,40(%r14)\n"			/* Get GSERA from GSEPL*/
+		"	stg	%r14,304(%r15)\n"			/* Store GSERA in r14 of reg save area */
+		"	brasl	%r14,gs_handler\n"			/* Jump to gs_handler */
+		"	lmg	%r0,%r15,192(%r15)\n"			/* Restore regs */
+		"	aghi	%r14, 6\n"				/* Add lgg instr len to GSERA */
+		"	br	%r14\n"					/* Jump to next instruction after lgg */
+		".size gs_handler_asm,.-gs_handler_asm\n"
+	);
 
 void gs_handler(struct gs_cb *this_cb)
 {
diff --git a/s390x/macros.S b/s390x/macros.S
index 13cff299488f..e2a56a366c70 100644
--- a/s390x/macros.S
+++ b/s390x/macros.S
@@ -21,14 +21,14 @@
 	/* Save the stack address in GR2 which is the first function argument */
 	lgr     %r2, %r15
 	/* Allocate stack space for called C function, as specified in s390 ELF ABI */
-	slgfi   %r15, 160
+	slgfi   %r15, STACK_FRAME_SIZE
 	/*
 	 * Save the address of the interrupt stack into the back chain
 	 * of the called function.
 	 */
 	stg     %r2, STACK_FRAME_INT_BACKCHAIN(%r15)
 	brasl	%r14, \c_func
-	algfi   %r15, 160
+	algfi   %r15, STACK_FRAME_SIZE
 	RESTORE_REGS_STACK
 	lpswe	\old_psw
 	.endm
diff --git a/s390x/snippets/c/flat.lds.S b/s390x/snippets/c/flat.lds.S
index 9e5eb66bec23..468b5f1eebe8 100644
--- a/s390x/snippets/c/flat.lds.S
+++ b/s390x/snippets/c/flat.lds.S
@@ -1,3 +1,5 @@
+#include <asm/asm-offsets.h>
+
 SECTIONS
 {
 	.lowcore : {
@@ -18,9 +20,9 @@ SECTIONS
 	. = 0x4000;
 	/*
 	 * The stack grows down from 0x4000 to 0x2000, we pre-allocoate
-	 * a frame via the -160.
+	 * a frame via the -STACK_FRAME_SIZE.
 	 */
-	stackptr = . - 160;
+	stackptr = . - STACK_FRAME_SIZE;
 	stacktop = .;
 	/* Start text 0x4000 */
 	.text : {
-- 
2.34.1

