Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6105C6D7736
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 10:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237601AbjDEIpv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 04:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237575AbjDEIpp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 04:45:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBBD422E
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 01:45:44 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3358g4F0016974;
        Wed, 5 Apr 2023 08:45:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=YeidoZ6UYcu5yanv23XQkMVHFykVjJlMLJoGb5DTzy4=;
 b=I9OFVwQcXIhq+Sq81pv5DJwdysCRx2ra5X1sEt0RW0mBYg4m4OC7uTavxlYFbTKoxCDA
 AlW5TtKRT/DdXz4o5/LjRkJ8hsBcLsmrBCGbhJTVSiOFbyQVjJqex4KDUbbwfF/bMULe
 2i1FkHAo17GaGmjIA1kUUnTF2DTttqLB7CLzwQsKOmaeL5Yz08YxBoPWwmv6g9WhV7p3
 qCDTD3heA4ZAjhWTyvLbTc920O/k8aF6VuYANrAvJfsHlKOlm7w0vIJ8+d1RaYnNkh7Q
 f22Cufux9xCPZtjgw4Km6a9wgKn3SwRBum5YqFojd0qGe4SaegzLY0pVBefTZY0aGgxQ NA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps5q082g8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 08:45:41 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3358jfgP028584;
        Wed, 5 Apr 2023 08:45:41 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps5q082fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 08:45:41 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 334NupGn003364;
        Wed, 5 Apr 2023 08:45:39 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3ppc8735nb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 08:45:38 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3358jYbN28836496
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Apr 2023 08:45:34 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2273A20049;
        Wed,  5 Apr 2023 08:45:34 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A071920040;
        Wed,  5 Apr 2023 08:45:33 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.30.226])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  5 Apr 2023 08:45:33 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL v3 06/14] s390x: define a macro for the stack frame size
Date:   Wed,  5 Apr 2023 10:45:20 +0200
Message-Id: <20230405084528.16027-7-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230405084528.16027-1-nrb@linux.ibm.com>
References: <20230405084528.16027-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NV8bdooW1u8LR-rqeXJdCuJ2lfoDGnWk
X-Proofpoint-ORIG-GUID: illDhqEkzQ6LXZMc8_19a0UN5s8UadKb
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-05_04,2023-04-04_05,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 spamscore=0
 mlxscore=0 clxscore=1015 impostorscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304050079
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

