Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B21C770A07
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 22:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbjHDUsv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 16:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjHDUss (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 16:48:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259464C31
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 13:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SsIlIsZ6z0Qa+ezvqAt5qK8xNpKejIA94e/4QHw6gFA=; b=G4bWC5pfW52gl63xbxu5L3W2fv
        GlXwvwfNxqd0v3X9Vcjhnr35CVe0/3K25YwZOzdaiAqbcc8niPnN8ryEpX0eM/HlVCk6oHBG5Z/AL
        gAAGiSzBoeh5ewGQPIzUkpjSBAhJ8w37xzWVaGC+X8wwAs6Fn8U0bmoI+21dqXUJaB3Dre6EdOjjk
        33FJFdmKylQw9X1Hwch3uY0e/C2luBGiojoV5hZWKyRlem5dR47qCKTqtXZFxTJso93Qq6H2QeJfu
        4T1o0xk3mm9TUTDU4+TZVwbI3hUe1LL9NM5zG9Xe+RDMWY+WyBZYAwr5b1ooScKT4DFEczTgYOqdq
        CJ28NUCw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qS1iz-00BxlH-7U; Fri, 04 Aug 2023 20:48:41 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 30AFC30007E;
        Fri,  4 Aug 2023 22:48:40 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1762B276A4B5C; Fri,  4 Aug 2023 22:48:40 +0200 (CEST)
Date:   Fri, 4 Aug 2023 22:48:40 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Nikunj A Dadhania <nikunj@amd.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>
Subject: Re: [PATCH] KVM: SVM: Add exception to disable objtool warning for
 kvm-amd.o
Message-ID: <20230804204840.GR212435@hirez.programming.kicks-ass.net>
References: <20230802091107.1160320-1-nikunj@amd.com>
 <20230803120637.GD214207@hirez.programming.kicks-ass.net>
 <b22761ea-cab6-0e11-cdc9-ec26c300cd3f@redhat.com>
 <20230803190728.GJ212435@hirez.programming.kicks-ass.net>
 <7c2f6fa3-23ba-6df5-24d9-28f95f866574@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c2f6fa3-23ba-6df5-24d9-28f95f866574@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 04, 2023 at 12:20:05PM +0200, Paolo Bonzini wrote:
> It's not clobbered in a part that will cause unwinding; we can further
> restrict the part to a handful of instructions (and add a mov %rsp, %rbp
> at the top, see untested patch after signature).
> 
> I think the chance of this failure is similar or lower to the chance of
> a memory failure that hits the exception handler code itself.

Yes, that's very helpful, the below is your patch with a few extra
hints and a comment. This seems to cure things.

Specifically, your change is needed to put UNWIND_HINT_RESTORE before we
go CALL things (like entry_ibpb), otherwise objtool gets upset we CALL
without having a valid framepointer.

Josh, this look ok to you?

---
 arch/x86/kvm/Makefile      |  4 ----
 arch/x86/kvm/svm/vmenter.S | 38 ++++++++++++++++++++++++++++++++------
 2 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 80e3fe184d17..0c5c2f090e93 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -3,10 +3,6 @@
 ccflags-y += -I $(srctree)/arch/x86/kvm
 ccflags-$(CONFIG_KVM_WERROR) += -Werror
 
-ifeq ($(CONFIG_FRAME_POINTER),y)
-OBJECT_FILES_NON_STANDARD_vmenter.o := y
-endif
-
 include $(srctree)/virt/kvm/Makefile.kvm
 
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 8e8295e774f0..99b9be9a56c3 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -99,6 +99,8 @@
  */
 SYM_FUNC_START(__svm_vcpu_run)
 	push %_ASM_BP
+	mov %_ASM_SP, %_ASM_BP
+
 #ifdef CONFIG_X86_64
 	push %r15
 	push %r14
@@ -121,7 +123,18 @@ SYM_FUNC_START(__svm_vcpu_run)
 	/* Needed to restore access to percpu variables.  */
 	__ASM_SIZE(push) PER_CPU_VAR(svm_data + SD_save_area_pa)
 
-	/* Finally save @svm. */
+	/*
+	 * Finally save frame pointer and @svm.
+	 *
+	 * Clobbering BP here is mostly ok since GIF will block NMIs and with
+	 * the exception of #MC and the kvm_rebooting _ASM_EXTABLE()s below
+	 * nothing untoward will happen until BP is restored.
+	 *
+	 * The kvm_rebooting exceptions should not want to unwind stack, and
+	 * while #MV might want to unwind stack, it is ultimately fatal.
+	 */
+	UNWIND_HINT_SAVE
+	push %_ASM_BP
 	push %_ASM_ARG1
 
 .ifnc _ASM_ARG1, _ASM_DI
@@ -153,7 +166,6 @@ SYM_FUNC_START(__svm_vcpu_run)
 	mov VCPU_RCX(%_ASM_DI), %_ASM_CX
 	mov VCPU_RDX(%_ASM_DI), %_ASM_DX
 	mov VCPU_RBX(%_ASM_DI), %_ASM_BX
-	mov VCPU_RBP(%_ASM_DI), %_ASM_BP
 	mov VCPU_RSI(%_ASM_DI), %_ASM_SI
 #ifdef CONFIG_X86_64
 	mov VCPU_R8 (%_ASM_DI),  %r8
@@ -165,6 +177,7 @@ SYM_FUNC_START(__svm_vcpu_run)
 	mov VCPU_R14(%_ASM_DI), %r14
 	mov VCPU_R15(%_ASM_DI), %r15
 #endif
+	mov VCPU_RBP(%_ASM_DI), %_ASM_BP
 	mov VCPU_RDI(%_ASM_DI), %_ASM_DI
 
 	/* Enter guest mode */
@@ -177,11 +190,16 @@ SYM_FUNC_START(__svm_vcpu_run)
 	/* Pop @svm to RAX while it's the only available register. */
 	pop %_ASM_AX
 
-	/* Save all guest registers.  */
+	/*
+	 * Save all guest registers. Pop the frame pointer as soon as possible
+	 * to enable unwinding.
+	 */
+	mov %_ASM_BP,   VCPU_RBP(%_ASM_AX)
+	pop %_ASM_BP
+	UNWIND_HINT_RESTORE
 	mov %_ASM_CX,   VCPU_RCX(%_ASM_AX)
 	mov %_ASM_DX,   VCPU_RDX(%_ASM_AX)
 	mov %_ASM_BX,   VCPU_RBX(%_ASM_AX)
-	mov %_ASM_BP,   VCPU_RBP(%_ASM_AX)
 	mov %_ASM_SI,   VCPU_RSI(%_ASM_AX)
 	mov %_ASM_DI,   VCPU_RDI(%_ASM_AX)
 #ifdef CONFIG_X86_64
@@ -297,6 +315,7 @@ SYM_FUNC_END(__svm_vcpu_run)
  */
 SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	push %_ASM_BP
+	mov %_ASM_SP, %_ASM_BP
 #ifdef CONFIG_X86_64
 	push %r15
 	push %r14
@@ -316,7 +335,9 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	/* Accessed directly from the stack in RESTORE_HOST_SPEC_CTRL.  */
 	push %_ASM_ARG2
 
-	/* Save @svm. */
+	/* Save frame pointer and @svm. */
+	UNWIND_HINT_SAVE
+	push %_ASM_BP
 	push %_ASM_ARG1
 
 .ifnc _ASM_ARG1, _ASM_DI
@@ -341,8 +362,13 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 
 2:	cli
 
-	/* Pop @svm to RDI, guest registers have been saved already. */
+	/*
+	 * Guest registers have been saved already.
+	 * Pop @svm to RDI and restore the frame pointer to allow unwinding.
+	 */
 	pop %_ASM_DI
+	pop %_ASM_BP
+	UNWIND_HINT_RESTORE
 
 #ifdef CONFIG_RETPOLINE
 	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
