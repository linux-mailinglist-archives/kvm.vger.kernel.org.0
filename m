Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 755056DCCE9
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 23:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjDJVuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 17:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjDJVuK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 17:50:10 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2269198B
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 14:50:08 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-51400ab994dso330346a12.3
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 14:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681163408;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mj8dSCbGPlf0CRd5FNuA/sfSA8tqFa0rbdFYnaL0J0Y=;
        b=ooZshyiJM9UMbazIhJLtbwAA6XYym8j66UHXKxeDstWut5Z0om8gM2U8Wxsv7usA1j
         /RDW4i+lw+54YqovzPCcrlvFD5NCURhqkzQMR563bk2Ly9QOz5ySTdTxMQVj88bnxUju
         3Dzdpb7KWHHAHE0BhKFgGARlvJvvIfMjuqA0VuoHQfC43Hpnrz2IAWW2RnTKFagUXePJ
         U6P9qyO957ebbuy6n78f7arEMU33C09rdIUe0Q76GW9f9hUnEQf3z+RLkXpYSiJoeHU4
         mqgH7xOTHOZ4UyZtodRVU/csERu6lokPoNn9lXbhrWIiqNfE65Zi6wLRrRG6OSM00cRs
         S0TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681163408;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mj8dSCbGPlf0CRd5FNuA/sfSA8tqFa0rbdFYnaL0J0Y=;
        b=VWOmpSy8NXfXttMh1Rwl+qkVU8jE5Bbcz/gtMFf1bdG1tfh/MKeIhSapQVh6Dz4jPh
         OVQQECbnwovAPxO/nO2lOwOViHQWmtRLEQkaqpVeE5mYzHAtUn63/Be0d2kMseEBEB2h
         41C6jJWwJ/MoUfOAuWDo3CS/KYrDSuAPI7VydM3t83A97sv+yHV7sg/SwxFN8L8B2rLP
         O4vvncYTIe5Oi2lbGXwaESGXVqd1x+6/KwXGjNnewmlfmGRixVIMjmupNun/vDuMlEXm
         znNMbNRYUruNuy8IGgXouRaIIm4moQobzPw5kRJaHKi+U8L/hn7syqlkPal5eJi+fFjK
         etKg==
X-Gm-Message-State: AAQBX9dwTBgGjSma0c6MT2XKQfKzS7PZnxJtpzoj+6izW+k/rbl2n2Fg
        +1qdzpKRKECq1KYqBjQtFB4pdFLOczk=
X-Google-Smtp-Source: AKy350YbhvrLBgazf2oCDb5y29XRCncB+f0XTQue/QJfvSxLioZvcRsgREAZwOBt6wfR46kpVcAihEU1g4Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:b87:b0:626:23a1:7b8a with SMTP id
 g7-20020a056a000b8700b0062623a17b8amr295013pfj.3.1681163408325; Mon, 10 Apr
 2023 14:50:08 -0700 (PDT)
Date:   Mon, 10 Apr 2023 14:50:06 -0700
In-Reply-To: <20230410081438.1750-34-xin3.li@intel.com>
Mime-Version: 1.0
References: <20230410081438.1750-1-xin3.li@intel.com> <20230410081438.1750-34-xin3.li@intel.com>
Message-ID: <ZDSEjhGV9D90J6Bx@google.com>
Subject: Re: [PATCH v8 33/33] KVM: x86/vmx: refactor VMX_DO_EVENT_IRQOFF to
 generate FRED stack frames
From:   Sean Christopherson <seanjc@google.com>
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, jiangshanlai@gmail.com,
        shan.kang@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"KVM: VMX:" for the shortlog please.

On Mon, Apr 10, 2023, Xin Li wrote:
> -.macro VMX_DO_EVENT_IRQOFF call_insn call_target
> +.macro VMX_DO_EVENT_IRQOFF call_insn call_target fred=0 nmi=0
>  	/*
>  	 * Unconditionally create a stack frame, getting the correct RSP on the
>  	 * stack (for x86-64) would take two instructions anyways, and RBP can
> @@ -41,16 +43,55 @@
>  	mov %_ASM_SP, %_ASM_BP
>  
>  #ifdef CONFIG_X86_64
> +#ifdef CONFIG_X86_FRED
> +	/*
> +	 * It's not necessary to change current stack level for handling IRQ/NMI
> +	 * because the state of the kernel stack is well defined in this place
> +	 * in the code, and it is known not to be deep in a bunch of nested I/O
> +	 * layer handlers that eat up the stack.
> +	 *
> +	 * Before starting to push a FRED stack frame, FRED reserves a redzone
> +	 * (for CALL emulation) and aligns RSP to a 64-byte boundary.
> +	 */
> +	sub $(FRED_CONFIG_REDZONE_AMOUNT << 6), %rsp
> +	and $FRED_STACK_FRAME_RSP_MASK, %rsp
> +
> +	/*
> +	 * A FRED stack frame has extra 16 bytes of information pushed at the
> +	 * regular stack top comparing to an IDT stack frame.
> +	 */
> +	push $0		/* Reserved by FRED, must be 0 */
> +	push $0		/* FRED event data, 0 for NMI and external interrupts */
> +#else
>  	/*
>  	 * Align RSP to a 16-byte boundary (to emulate CPU behavior) before
>  	 * creating the synthetic interrupt stack frame for the IRQ/NMI.
>  	 */
>  	and  $-16, %rsp
> -	push $__KERNEL_DS
> +#endif
> +
> +	.if \fred
> +	.if \nmi
> +	mov $(2 << 32 | 2 << 48), %rax		/* NMI event type and vector */
> +	.else
> +	mov %rdi, %rax
> +	shl $32, %rax				/* External interrupt vector */
> +	.endif
> +	add $__KERNEL_DS, %rax
> +	bts $57, %rax				/* Set 64-bit mode */
> +	.else
> +	mov $__KERNEL_DS, %rax
> +	.endif
> +	push %rax

This is painfully difficult to read, and the trampolines only add to that pain.
Using macros instead of magic numbers would alleviate a small amount of pain, but
but the #ifdefs and .if \fred/\nmi are the real culprits.

>  static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
> @@ -6916,14 +6916,20 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
>  {
>  	u32 intr_info = vmx_get_intr_info(vcpu);
>  	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
> -	gate_desc *desc = (gate_desc *)host_idt_base + vector;
> +	unsigned long entry_or_vector;
> +
> +#ifdef CONFIG_X86_64
> +	entry_or_vector = vector;
> +#else
> +	entry_or_vector = gate_offset((gate_desc *)host_idt_base + vector);
> +#endif

And then this is equally gross.  Rather than funnel FRED+legacy into a single
function only to split them back out, just route FRED into its own asm subroutine.
The common bits are basically the creation/destruction of the stack frame and the
CALL itself, i.e. the truly interesting bits are what's different.

Pretty much all of the #ifdeffery goes away, the helpers just need #ifdefs to
play nice with CONFIG_X86_FRED=n.  E.g. something like the below as a starting
point (it most definitely doesn't compile, and most definitely isn't 100% correct).

---
 arch/x86/kvm/vmx/vmenter.S | 72 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c     | 19 ++++++++--
 2 files changed, 88 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 631fd7da2bc3..a6929c78e038 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -2,12 +2,14 @@
 #include <linux/linkage.h>
 #include <asm/asm.h>
 #include <asm/bitsperlong.h>
+#include <asm/fred.h>
 #include <asm/kvm_vcpu_regs.h>
 #include <asm/nospec-branch.h>
 #include <asm/percpu.h>
 #include <asm/segment.h>
 #include "kvm-asm-offsets.h"
 #include "run_flags.h"
+#include "../../entry/calling.h"
 
 #define WORD_SIZE (BITS_PER_LONG / 8)
 
@@ -31,6 +33,62 @@
 #define VCPU_R15	__VCPU_REGS_R15 * WORD_SIZE
 #endif
 
+#ifdef CONFIG_X86_FRED
+.macro VMX_DO_FRED_EVENT_IRQOFF call_target cs_val
+	/*
+	 * Unconditionally create a stack frame, getting the correct RSP on the
+	 * stack (for x86-64) would take two instructions anyways, and RBP can
+	 * be used to restore RSP to make objtool happy (see below).
+	 */
+	push %_ASM_BP
+	mov %_ASM_SP, %_ASM_BP
+
+	/*
+	 * Don't check the FRED stack level, the call stack leading to this
+	 * helper is effectively constant and shallow (relatively speaking).
+	 *
+	 * Emulate the FRED-defined redzone and stack alignment (128 bytes and
+	 * 64 bytes respectively).
+	 */
+	sub $(FRED_CONFIG_REDZONE_AMOUNT << 6), %rsp
+	and $FRED_STACK_FRAME_RSP_MASK, %rsp
+
+	/*
+	* A FRED stack frame has extra 16 bytes of information pushed at the
+	* regular stack top compared to an IDT stack frame.
+	*/
+	push $0         /* Reserved by FRED, must be 0 */
+	push $0         /* FRED event data, 0 for NMI and external interrupts */
+	shl $32, %rax
+	orq $__KERNEL_DS | $FRED_64_BIT_MODE, %ax
+	push %rax	/* Vector (from the "caller") and DS */
+
+	push %rbp
+	pushf
+	push \cs_val
+
+	push $0 /* FRED error code, 0 for NMI and external interrupts */
+	PUSH_REGS
+
+	/* Load @pt_regs */
+	movq    %rsp, %_ASM_ARG1
+
+	call \call_target
+
+	POP_REGS
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
+#endif
+
 .macro VMX_DO_EVENT_IRQOFF call_insn call_target
 	/*
 	 * Unconditionally create a stack frame, getting the correct RSP on the
@@ -299,6 +357,14 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
 
 SYM_FUNC_END(__vmx_vcpu_run)
 
+#ifdef CONFIG_X86_FRED
+SYM_FUNC_START(vmx_do_fred_nmi_irqoff)
+	push $FRED_NMI_ERROR_CODE
+	mov $NMI_VECTOR | $FRED_NMI_SOMETHING, %eax
+	VMX_DO_FRED_EVENT_IRQOFF call fred_entrypoint_kernel $FRED_NMI_CS_VAL
+SYM_FUNC_END(vmx_do_nmi_irqoff)
+#endif
+
 SYM_FUNC_START(vmx_do_nmi_irqoff)
 	VMX_DO_EVENT_IRQOFF call asm_exc_nmi_kvm_vmx
 SYM_FUNC_END(vmx_do_nmi_irqoff)
@@ -357,6 +423,12 @@ SYM_FUNC_START(vmread_error_trampoline)
 SYM_FUNC_END(vmread_error_trampoline)
 #endif
 
+#ifdef CONFIG_X86_FRED
+SYM_FUNC_START(vmx_do_fred_interrupt_irqoff)
+	mov %_ASM_ARG1, %rax
+	VMX_DO_FRED_EVENT_IRQOFF call external_interrupt
+#endif
+
 SYM_FUNC_START(vmx_do_interrupt_irqoff)
 	VMX_DO_EVENT_IRQOFF CALL_NOSPEC _ASM_ARG1
 SYM_FUNC_END(vmx_do_interrupt_irqoff)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 11080a649f60..42f50b0cc125 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6891,6 +6891,14 @@ static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 	memset(vmx->pi_desc.pir, 0, sizeof(vmx->pi_desc.pir));
 }
 
+#ifdef CONFIG_X86_FRED
+void vmx_do_fred_interrupt_irqoff(unsigned int vector);
+void vmx_do_fred_nmi_irqoff(unsigned int vector);
+#else
+#define vmx_do_fred_interrupt_irqoff(x) BUG();
+#define vmx_do_fred_nmi_irqoff(x) BUG();
+#endif
+
 void vmx_do_interrupt_irqoff(unsigned long entry);
 void vmx_do_nmi_irqoff(void);
 
@@ -6933,14 +6941,16 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 {
 	u32 intr_info = vmx_get_intr_info(vcpu);
 	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
-	gate_desc *desc = (gate_desc *)host_idt_base + vector;
 
 	if (KVM_BUG(!is_external_intr(intr_info), vcpu->kvm,
 	    "unexpected VM-Exit interrupt info: 0x%x", intr_info))
 		return;
 
 	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
-	vmx_do_interrupt_irqoff(gate_offset(desc));
+	if (cpu_feature_enabled(X86_FEATURE_FRED))
+		vmx_do_fred_interrupt_irqoff(vector);
+	else
+		vmx_do_interrupt_irqoff(gate_offset((gate_desc *)host_idt_base + vector));
 	kvm_after_interrupt(vcpu);
 
 	vcpu->arch.at_instruction_boundary = true;
@@ -7226,7 +7236,10 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	if ((u16)vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI &&
 	    is_nmi(vmx_get_intr_info(vcpu))) {
 		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
-		vmx_do_nmi_irqoff();
+		if (cpu_feature_enabled(X86_FEATURE_FRED))
+			vmx_do_fred_nmi_irqoff();
+		else
+			vmx_do_nmi_irqoff();
 		kvm_after_interrupt(vcpu);
 	}
 

base-commit: 33d1a64081c98e390e064db18738428d6fb96f95
-- 

