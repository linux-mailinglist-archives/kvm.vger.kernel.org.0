Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C70CB770C48
	for <lists+kvm@lfdr.de>; Sat,  5 Aug 2023 01:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjHDXUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 19:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjHDXUA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 19:20:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242AB46B3
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 16:19:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F36A62167
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 23:19:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B6EC433C7;
        Fri,  4 Aug 2023 23:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691191198;
        bh=mOpAzve8RStLdiTN+8kmZPlJWr5E9fH4tPTrmFgIOK8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PZ16+Oppfb9STNSR8NfgdCsfSKySpReE+TtezvQ5bxDP8LQEsybrjBieOu7gUPQRv
         9+4Xnf4HZ2PWdlPKtRmnLgnalCdm1LtLE7rPSN/LxdAED9dHFZEsb6NjqPrD/E/apC
         kOeKfwzLSPkqE+3MaM7MyV2g5X+qgPeiJ/96kw9VP/YFHdtG+fChflSCEzceOHl2Ax
         uszoMyw2C7xdbVW82Is/FgiPGvruLhOvvPX/s7Zl7rvw8PArVVmH7mLGXUdJQ3BLsY
         +9C0CUsPvvi48J8gGaOIQbGQ17kuczbc/6OG1pV9c2S9/4GYgT1SW1kEy1+Nk1OF8E
         4juwse3Qya26Q==
Date:   Fri, 4 Aug 2023 18:19:54 -0500
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Nikunj A Dadhania <nikunj@amd.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>
Subject: Re: [PATCH] KVM: SVM: Add exception to disable objtool warning for
 kvm-amd.o
Message-ID: <20230804231954.swdjx6lxkccxals6@treble>
References: <20230802091107.1160320-1-nikunj@amd.com>
 <20230803120637.GD214207@hirez.programming.kicks-ass.net>
 <b22761ea-cab6-0e11-cdc9-ec26c300cd3f@redhat.com>
 <20230803190728.GJ212435@hirez.programming.kicks-ass.net>
 <7c2f6fa3-23ba-6df5-24d9-28f95f866574@redhat.com>
 <20230804204840.GR212435@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230804204840.GR212435@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 04, 2023 at 10:48:40PM +0200, Peter Zijlstra wrote:
> On Fri, Aug 04, 2023 at 12:20:05PM +0200, Paolo Bonzini wrote:
> > It's not clobbered in a part that will cause unwinding; we can further
> > restrict the part to a handful of instructions (and add a mov %rsp, %rbp
> > at the top, see untested patch after signature).
> > 
> > I think the chance of this failure is similar or lower to the chance of
> > a memory failure that hits the exception handler code itself.
> 
> Yes, that's very helpful, the below is your patch with a few extra
> hints and a comment. This seems to cure things.
> 
> Specifically, your change is needed to put UNWIND_HINT_RESTORE before we
> go CALL things (like entry_ibpb), otherwise objtool gets upset we CALL
> without having a valid framepointer.
> 
> Josh, this look ok to you?

Looks mostly right, except this now creates an unnecessary gap in
unwinding coverage for the ORC unwinder.  So it's better to put the
FP-specific changes behind CONFIG_FRAME_POINTER:

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
index 8e8295e774f0..51f6851b1ae5 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -99,6 +99,9 @@
  */
 SYM_FUNC_START(__svm_vcpu_run)
 	push %_ASM_BP
+#ifdef CONFIG_FRAME_POINTER
+	mov %_ASM_SP, %_ASM_BP
+#endif
 #ifdef CONFIG_X86_64
 	push %r15
 	push %r14
@@ -121,7 +124,20 @@ SYM_FUNC_START(__svm_vcpu_run)
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
+#ifdef CONFIG_FRAME_POINTER
+	UNWIND_HINT_SAVE
+	push %_ASM_BP
+#endif
 	push %_ASM_ARG1
 
 .ifnc _ASM_ARG1, _ASM_DI
@@ -153,7 +169,6 @@ SYM_FUNC_START(__svm_vcpu_run)
 	mov VCPU_RCX(%_ASM_DI), %_ASM_CX
 	mov VCPU_RDX(%_ASM_DI), %_ASM_DX
 	mov VCPU_RBX(%_ASM_DI), %_ASM_BX
-	mov VCPU_RBP(%_ASM_DI), %_ASM_BP
 	mov VCPU_RSI(%_ASM_DI), %_ASM_SI
 #ifdef CONFIG_X86_64
 	mov VCPU_R8 (%_ASM_DI),  %r8
@@ -165,6 +180,7 @@ SYM_FUNC_START(__svm_vcpu_run)
 	mov VCPU_R14(%_ASM_DI), %r14
 	mov VCPU_R15(%_ASM_DI), %r15
 #endif
+	mov VCPU_RBP(%_ASM_DI), %_ASM_BP
 	mov VCPU_RDI(%_ASM_DI), %_ASM_DI
 
 	/* Enter guest mode */
@@ -177,11 +193,18 @@ SYM_FUNC_START(__svm_vcpu_run)
 	/* Pop @svm to RAX while it's the only available register. */
 	pop %_ASM_AX
 
-	/* Save all guest registers.  */
+	/*
+	 * Save all guest registers. Pop the frame pointer as soon as possible
+	 * to enable unwinding.
+	 */
+	mov %_ASM_BP,   VCPU_RBP(%_ASM_AX)
+#ifdef CONFIG_FRAME_POINTER
+	pop %_ASM_BP
+	UNWIND_HINT_RESTORE
+#endif
 	mov %_ASM_CX,   VCPU_RCX(%_ASM_AX)
 	mov %_ASM_DX,   VCPU_RDX(%_ASM_AX)
 	mov %_ASM_BX,   VCPU_RBX(%_ASM_AX)
-	mov %_ASM_BP,   VCPU_RBP(%_ASM_AX)
 	mov %_ASM_SI,   VCPU_RSI(%_ASM_AX)
 	mov %_ASM_DI,   VCPU_RDI(%_ASM_AX)
 #ifdef CONFIG_X86_64
@@ -297,6 +320,9 @@ SYM_FUNC_END(__svm_vcpu_run)
  */
 SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	push %_ASM_BP
+#ifdef CONFIG_FRAME_POINTER
+	mov %_ASM_SP, %_ASM_BP
+#endif
 #ifdef CONFIG_X86_64
 	push %r15
 	push %r14
@@ -316,7 +342,11 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	/* Accessed directly from the stack in RESTORE_HOST_SPEC_CTRL.  */
 	push %_ASM_ARG2
 
-	/* Save @svm. */
+	/* Save frame pointer and @svm. */
+#ifdef CONFIG_FRAME_POINTER
+	UNWIND_HINT_SAVE
+	push %_ASM_BP
+#endif
 	push %_ASM_ARG1
 
 .ifnc _ASM_ARG1, _ASM_DI
@@ -341,8 +371,15 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 
 2:	cli
 
-	/* Pop @svm to RDI, guest registers have been saved already. */
+	/*
+	 * Guest registers have been saved already.
+	 * Pop @svm to RDI and restore the frame pointer to allow unwinding.
+	 */
 	pop %_ASM_DI
+#ifdef CONFIG_FRAME_POINTER
+	pop %_ASM_BP
+	UNWIND_HINT_RESTORE
+#endif
 
 #ifdef CONFIG_RETPOLINE
 	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
