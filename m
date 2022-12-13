Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5BE864AFA4
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 07:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234499AbiLMGJz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 01:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234391AbiLMGJp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 01:09:45 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EEC1ADB8
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 22:09:27 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id c9-20020a63da09000000b0047954824506so2772282pgh.5
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 22:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XJmCztab5I+GOPa0DQl6Gc8jULACLfl5WBPqqp47Nbo=;
        b=eOYAUekkYFKW32/sardr9LbkqefyMBx11vxUVkrH0ldjTntI2ZqZ12Z1YKA8CIJJll
         5gJKypePk09DROtfI5aCEo66BA5V+NzqriBgU1mn2W2AI3R8kOtCMoF3y5solFD0HK9p
         p320W+0By14HNqdn0+hlsW1X/3EZmtWRJH2n3mdjsIYLGDt3ZRy7pdDm1JUce8nvs+U+
         agGnzIMGnjy9CKnRAg/9Z18OiIYhxe/3PQZzB9sfpM59C3Qi4oSGs7XPTYOW3TOVjoiO
         e+gPF63js8NwFX6PxL4drafuNhkepvmEbblZQV/V0zrMJiMYs2C9kZeO/uUexIci8mmg
         Pl7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XJmCztab5I+GOPa0DQl6Gc8jULACLfl5WBPqqp47Nbo=;
        b=MfxMi8CtJmHTlfn2Cn9lnDP6OGmspK2ItGgN7aZwwk0jKvcG/9bsY3UiHG3GtkySFL
         TIeFRVZ5MGPpWpBxrpPn69kFSx8E+0KzOmZfVoXryCf0sqwAxo01gNl6s5ZoaJXKzzQS
         uBnYiY02SnFhaf4H9AQsSRE+M/pJENbtmuEWp8ybqDQzFIYW6Eo/gX92RdT5xbJuZsox
         ZzhRqZ2eYEm94uObWGmjkbbrUd1CkygCeBXSKrSGMzunZ/xWl2ng2HKacMttzTdUC0MY
         55N+sb0sxWXIVmNhIXf+TYGtSiNTbdUAp1cAOWyZzkQWWoHaPPO8mQMAEihW5UQCgVzB
         apQw==
X-Gm-Message-State: ANoB5pnLd4K0Wf1MuhzP2Si3ITq299nQ+ZkA4ZGb5+InwQOQ2pEXAioT
        9ZocIuI5s04sgFcV6ZV4GqDmbwPpzFw=
X-Google-Smtp-Source: AA0mqf4IGPRfK+e8J3A9Bf74E8Zn6ZE1wP/oefeh6jkbHly8QijandEcr34pV6l+ae2KwuKns91h9X4Yb7M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:2ecb:b0:219:5b3b:2b9f with SMTP id
 h11-20020a17090a2ecb00b002195b3b2b9fmr22689pjs.2.1670911766390; Mon, 12 Dec
 2022 22:09:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Dec 2022 06:09:11 +0000
In-Reply-To: <20221213060912.654668-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213060912.654668-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213060912.654668-7-seanjc@google.com>
Subject: [PATCH 6/7] KVM: VMX: Provide separate subroutines for invoking NMI
 vs. IRQ handlers
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split the asm subroutines for handling NMIs versus IRQs that occur in the
guest so that the NMI handler can be called from a noinstr section.  As a
bonus, the NMI path doesn't need an indirect branch.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmenter.S | 70 +++++++++++++++++++++-----------------
 arch/x86/kvm/vmx/vmx.c     | 26 ++++++--------
 2 files changed, 50 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 766c6b3ef5ed..9d987e7e48c4 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -31,6 +31,39 @@
 #define VCPU_R15	__VCPU_REGS_R15 * WORD_SIZE
 #endif
 
+.macro VMX_DO_EVENT_IRQOFF call_insn call_target
+	/*
+	 * Unconditionally create a stack frame, getting the correct RSP on the
+	 * stack (for x86-64) would take two instructions anyways, and RBP can
+	 * be used to restore RSP to make objtool happy (see below).
+	 */
+	push %_ASM_BP
+	mov %_ASM_SP, %_ASM_BP
+
+#ifdef CONFIG_X86_64
+	/*
+	 * Align RSP to a 16-byte boundary (to emulate CPU behavior) before
+	 * creating the synthetic interrupt stack frame for the IRQ/NMI.
+	 */
+	and  $-16, %rsp
+	push $__KERNEL_DS
+	push %rbp
+#endif
+	pushf
+	push $__KERNEL_CS
+	\call_insn \call_target
+
+	/*
+	 * "Restore" RSP from RBP, even though IRET has already unwound RSP to
+	 * the correct value.  objtool doesn't know the callee will IRET and,
+	 * without the explicit restore, thinks the stack is getting walloped.
+	 * Using an unwind hint is problematic due to x86-64's dynamic alignment.
+	 */
+	mov %_ASM_BP, %_ASM_SP
+	pop %_ASM_BP
+	RET
+.endm
+
 .section .noinstr.text, "ax"
 
 /**
@@ -320,35 +353,10 @@ SYM_FUNC_START(vmread_error_trampoline)
 SYM_FUNC_END(vmread_error_trampoline)
 #endif
 
-SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
-	/*
-	 * Unconditionally create a stack frame, getting the correct RSP on the
-	 * stack (for x86-64) would take two instructions anyways, and RBP can
-	 * be used to restore RSP to make objtool happy (see below).
-	 */
-	push %_ASM_BP
-	mov %_ASM_SP, %_ASM_BP
+SYM_FUNC_START(vmx_do_nmi_irqoff)
+	VMX_DO_EVENT_IRQOFF call asm_exc_nmi_kvm_vmx
+SYM_FUNC_END(vmx_do_nmi_irqoff)
 
-#ifdef CONFIG_X86_64
-	/*
-	 * Align RSP to a 16-byte boundary (to emulate CPU behavior) before
-	 * creating the synthetic interrupt stack frame for the IRQ/NMI.
-	 */
-	and  $-16, %rsp
-	push $__KERNEL_DS
-	push %rbp
-#endif
-	pushf
-	push $__KERNEL_CS
-	CALL_NOSPEC _ASM_ARG1
-
-	/*
-	 * "Restore" RSP from RBP, even though IRET has already unwound RSP to
-	 * the correct value.  objtool doesn't know the callee will IRET and,
-	 * without the explicit restore, thinks the stack is getting walloped.
-	 * Using an unwind hint is problematic due to x86-64's dynamic alignment.
-	 */
-	mov %_ASM_BP, %_ASM_SP
-	pop %_ASM_BP
-	RET
-SYM_FUNC_END(vmx_do_interrupt_nmi_irqoff)
+SYM_FUNC_START(vmx_do_interrupt_irqoff)
+	VMX_DO_EVENT_IRQOFF CALL_NOSPEC _ASM_ARG1
+SYM_FUNC_END(vmx_do_interrupt_irqoff)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7ace22ee240d..c242e2591896 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6786,17 +6786,8 @@ static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 	memset(vmx->pi_desc.pir, 0, sizeof(vmx->pi_desc.pir));
 }
 
-void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
-
-static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
-					unsigned long entry)
-{
-	bool is_nmi = entry == (unsigned long)asm_exc_nmi_kvm_vmx;
-
-	kvm_before_interrupt(vcpu, is_nmi ? KVM_HANDLING_NMI : KVM_HANDLING_IRQ);
-	vmx_do_interrupt_nmi_irqoff(entry);
-	kvm_after_interrupt(vcpu);
-}
+void vmx_do_interrupt_irqoff(unsigned long entry);
+void vmx_do_nmi_irqoff(void);
 
 static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
 {
@@ -6820,7 +6811,6 @@ static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
 
 static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
 {
-	const unsigned long nmi_entry = (unsigned long)asm_exc_nmi_kvm_vmx;
 	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
 
 	/* if exit due to PF check for async PF */
@@ -6833,8 +6823,11 @@ static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
 	else if (is_machine_check(intr_info))
 		kvm_machine_check();
 	/* We need to handle NMIs before interrupts are enabled */
-	else if (is_nmi(intr_info))
-		handle_interrupt_nmi_irqoff(&vmx->vcpu, nmi_entry);
+	else if (is_nmi(intr_info)) {
+		kvm_before_interrupt(&vmx->vcpu, KVM_HANDLING_NMI);
+		vmx_do_nmi_irqoff();
+		kvm_after_interrupt(&vmx->vcpu);
+	}
 }
 
 static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
@@ -6847,7 +6840,10 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
 		return;
 
-	handle_interrupt_nmi_irqoff(vcpu, gate_offset(desc));
+	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
+	vmx_do_interrupt_irqoff(gate_offset(desc));
+	kvm_after_interrupt(vcpu);
+
 	vcpu->arch.at_instruction_boundary = true;
 }
 
-- 
2.39.0.rc1.256.g54fd8350bd-goog

