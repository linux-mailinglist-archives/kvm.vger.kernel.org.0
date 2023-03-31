Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322286D1F15
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 13:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbjCaLcM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 07:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbjCaLcJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 07:32:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04251E736
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 04:31:35 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32VAC523010463;
        Fri, 31 Mar 2023 11:30:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=YeidoZ6UYcu5yanv23XQkMVHFykVjJlMLJoGb5DTzy4=;
 b=Bs1tfx/18J2h92DyMu3dd/LmuDCSaTMstsOF92cEbSFGY9Rjm8TA91l4dibuElY+Gic5
 kopI22lHOYeL/2ZbUf6Qe1i80BSrOSYff/zgpCiX0Gn1SiqtGmoS/tUoAyYZ47TW1I6B
 SOO9z0yCAa3aGvFd2XU2wp6Jcf86JFKa6lOirEAbpyZGt/Ws4N+0Q6ETYS64yjmps65G
 7uf7jWB4PrmZX1j2Xi5dO/ov8wMZxqwJrrEgcY4Tl0VpCF4QB+ncV5LuMEKm81IBr/9t
 ITf15z7inQjrWFAadz528wzaOhzESPMXrDadN0JnNjtLyZ9edc/EAsKVNxfPSBdyEv0/ AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnwj61wdj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 11:30:56 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32VBHSCo017343;
        Fri, 31 Mar 2023 11:30:56 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnwj61wcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 11:30:55 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32ULi5l5005448;
        Fri, 31 Mar 2023 11:30:53 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3phrk6pqpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 11:30:53 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32VBUokb22020718
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 11:30:50 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 184562004B;
        Fri, 31 Mar 2023 11:30:50 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F30220040;
        Fri, 31 Mar 2023 11:30:49 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.9.190])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 31 Mar 2023 11:30:49 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 06/14] s390x: define a macro for the stack frame size
Date:   Fri, 31 Mar 2023 13:30:20 +0200
Message-Id: <20230331113028.621828-7-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230331113028.621828-1-nrb@linux.ibm.com>
References: <20230331113028.621828-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: H7stvmq47uzxiSFt1SErMwmLNcJ8Ljv_
X-Proofpoint-ORIG-GUID: 1zE6EcJEzVveEPDvN3UChxq2m6T7qe3b
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_06,2023-03-30_04,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303310091
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
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

