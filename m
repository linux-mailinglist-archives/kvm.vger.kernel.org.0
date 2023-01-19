Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2440673726
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 12:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbjASLlq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 06:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbjASLlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 06:41:15 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1AF837B6A
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 03:41:10 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30JBcYca034637
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:41:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=/k163sN2KWyjHZayQwunJGYWD/JlmIKy/xhezyJ7L1w=;
 b=o4y/NxAeaTbZc/KWFh8+mLxVtHzFvooIUVy9rCZZ8WWLpJV3eX4YndunOV84MwU+nvL/
 0quSkct0LMQHAIrDenA4eGKiA4lcHiMfviw67DUuzRtt4EiiHN/ozdQIQVuUd4cS/oRC
 UG/B5oQSQ5k7Nc3F4nleit6AW8TXed6k2XoGAG2Y4ZHHGSyZ8mmjrWMJlVWedviEyyo6
 0J9ULEu4HElq0KGStTobnwo5DMfmbDk09ZVLpxYmq7qlgyWKSTd7v6vqjxJpN+1VPZdW
 sdSlnrxnx6VGyC7eosSfgmiT3igTlEcXmC541uwNEySXDEg6/vs4E5Kk0j1v/poZUWtg EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n72624enk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:41:09 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30JBcjZA036075
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:41:09 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n72624emy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 11:41:09 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30J0KLPJ025743;
        Thu, 19 Jan 2023 11:41:07 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3n3m16cu1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 11:41:07 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30JBf49Z49611094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 11:41:04 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 071A020040;
        Thu, 19 Jan 2023 11:41:04 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 981F820043;
        Thu, 19 Jan 2023 11:41:03 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com.com (unknown [9.171.91.27])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 19 Jan 2023 11:41:03 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH v2 6/8] s390x: define a macro for the stack frame size
Date:   Thu, 19 Jan 2023 12:40:43 +0100
Message-Id: <20230119114045.34553-7-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230119114045.34553-1-mhartmay@linux.ibm.com>
References: <20230119114045.34553-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WJLYsCOzx1mOUnIq9qBLvRQ3JbSvVJZZ
X-Proofpoint-ORIG-GUID: jboCHXem0ncyRdtXh3xwRz3qNvh0aH1O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-19_09,2023-01-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 impostorscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301190091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define and use a macro for the stack frame size.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 lib/s390x/asm-offsets.c     | 1 +
 s390x/Makefile              | 2 +-
 s390x/cstart64.S            | 2 +-
 s390x/flat.lds.S            | 4 +++-
 s390x/gs.c                  | 5 +++--
 s390x/macros.S              | 4 ++--
 s390x/snippets/c/flat.lds.S | 6 ++++--
 7 files changed, 15 insertions(+), 9 deletions(-)

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
index 44ccca8102d6..9a8e2af1b2be 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -159,7 +159,7 @@ $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $(SNIPP
 %.hdr.obj: %.hdr
 	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
 
-%.lds: %.lds.S
+%.lds: %.lds.S $(asm-offsets)
 	$(CPP) $(autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<
 
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
index 4993eb8f43a9..2c2b972d7e65 100644
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
@@ -41,8 +42,8 @@ extern void gs_handler_asm(void);
 	    "	    aghi    %r15,-320\n" 		/* Allocate stack frame */
 	    "	    stmg    %r0,%r13,192(%r15)\n" 	/* Store regs to save area */
 	    "	    stg	    %r14,312(%r15)\n"
-	    "	    la	    %r2,160(%r15)\n" 		/* Store gscb address in this_cb */
-	    "	    .insn   rxy,0xe30000000049,0,160(%r15)\n" /* stgsc */
+	    "	    la	    %r2," xstr(STACK_FRAME_SIZE) "(%r15) \n" 		/* Store gscb address in this_cb */
+	    "	    .insn   rxy,0xe30000000049,0," xstr(STACK_FRAME_SIZE) "(%r15)\n" /* stgsc */
 	    "	    lg	    %r14,24(%r2)\n" 		/* Get GSEPLA from GSCB*/
 	    "	    lg	    %r14,40(%r14)\n" 		/* Get GSERA from GSEPL*/
 	    "	    stg	    %r14,304(%r15)\n" 		/* Store GSERA in r14 of reg save area */
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

