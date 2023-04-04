Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A2E6D5F2D
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 13:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbjDDLhQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 07:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234795AbjDDLhG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 07:37:06 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C862D44
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 04:36:56 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334BSTo9005801;
        Tue, 4 Apr 2023 11:36:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=YeidoZ6UYcu5yanv23XQkMVHFykVjJlMLJoGb5DTzy4=;
 b=m5G8CyTHJMSMaVJKw1Wd3t15nIiMS8G5UNNLI2TT/SXNDHNQJVZyaC2vnn7tbLpTrM3y
 YuLu8BvyKjlARzk4hmv44kpS9uZuumFKYLPqDapBNu6m8y1s162HwrDdj0bx9EwFxFMR
 7HgmDjUc530Z8pPRNxVudx/OqFzYtjcAUojAlEnKz/wqtbAQ/FikjSV2G4sITxKR9mrZ
 WkcLK2s2+qcUy23tiR+4SzEKZRNu8ZuFghmYqqWGxEs5/d94NFoUs64BxU5gZC1P6n6M
 aIbSVxq7kgB4VWfRgzUOu+9ZlVivtal/zTje+FkRcbZeic4zawyuwSkXQ8bRvPY1phhE rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prhabtw0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:53 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334BGSKx035789;
        Tue, 4 Apr 2023 11:36:53 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prhabtw0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:53 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 333MGB3K002680;
        Tue, 4 Apr 2023 11:36:51 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3ppc87ag5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:51 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334Bal1317957584
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 11:36:47 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9083120040;
        Tue,  4 Apr 2023 11:36:47 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09D6A20043;
        Tue,  4 Apr 2023 11:36:47 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.55.238])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 11:36:46 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL v2 06/14] s390x: define a macro for the stack frame size
Date:   Tue,  4 Apr 2023 13:36:31 +0200
Message-Id: <20230404113639.37544-7-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404113639.37544-1-nrb@linux.ibm.com>
References: <20230404113639.37544-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: n4lDKYuzAPiDF0Y4qARkhWrCA5QQGOvM
X-Proofpoint-GUID: vxRp9PPDBvKjpDDLLP8uD4tC7_6FUZrP
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_04,2023-04-04_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 phishscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304040107
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Hartmayer <mhartmay@linux.ibm.com>

Define and use a macro for the stack frame size. While at it, fix
whitespace in the `gs_handler_asm` block.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Co-developed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20230307091051.13945-7-mhartmay@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile              |  2 +-
 lib/s390x/asm-offsets.c     |  1 +
 s390x/cstart64.S            |  2 +-
 s390x/flat.lds.S            |  4 +++-
 s390x/macros.S              |  4 ++--
 s390x/snippets/c/flat.lds.S |  6 ++++--
 s390x/gs.c                  | 38 +++++++++++++++++++++----------------
 7 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index 6732b48..ab146eb 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -162,7 +162,7 @@ $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $(SNIPP
 	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
 
 lds-autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d -MT $@
-%.lds: %.lds.S
+%.lds: %.lds.S $(asm-offsets)
 	$(CPP) $(lds-autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<
 
 .SECONDEXPANSION:
diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
index f612f32..188dd2e 100644
--- a/lib/s390x/asm-offsets.c
+++ b/lib/s390x/asm-offsets.c
@@ -87,6 +87,7 @@ int main(void)
 	OFFSET(STACK_FRAME_INT_GRS0, stack_frame_int, grs0);
 	OFFSET(STACK_FRAME_INT_GRS1, stack_frame_int, grs1);
 	DEFINE(STACK_FRAME_INT_SIZE, sizeof(struct stack_frame_int));
+	DEFINE(STACK_FRAME_SIZE, sizeof(struct stack_frame));
 
 	return 0;
 }
diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 6f83da2..468ace3 100644
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
index 952f6cd..0cb7e38 100644
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
diff --git a/s390x/macros.S b/s390x/macros.S
index 13cff29..e2a56a3 100644
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
index 9e5eb66..468b5f1 100644
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
diff --git a/s390x/gs.c b/s390x/gs.c
index 4993eb8..9ae893e 100644
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
-- 
2.39.2

