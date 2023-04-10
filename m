Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE1286DC499
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 10:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjDJIne (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 04:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjDJInI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 04:43:08 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAB64C18;
        Mon, 10 Apr 2023 01:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681116085; x=1712652085;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H2LkgNfdgZCxqjwQsMzz3P7aFl8VuyYKoqg0zmKZpZ0=;
  b=JpuXekzSTlq2nI3bstm/g7N199dVqiWAhyTbgMyQzPODcB1Zrpadrm2x
   lTQXpURSZS5Lau9xb6jJv1l6KaJARRNuPjnNTCDrxRSh0Bk+8koo7gwRt
   ePqUEkFuUYj1yLAl8MKxD8RtAhBdZYtCewIHDsZNKtBhk6+VOExVSCva6
   izIsVuRMBY9El6rzuZBOoBlANq3J9D57Qw3D+ZhRLLzWHVUqXjA4D+E0L
   OOoJOhEtjbWyhx4dezwX87W39wzBMstu8zp+ew5LjUyGDoGAd2/8Edt9R
   VAbzyglmV1Ouplb8PaQJqsgDHx4LoWHzjLOHQ+hZ5XWHa0IuKeaZn849t
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="342078228"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="342078228"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 01:41:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="799436372"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="799436372"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga002.fm.intel.com with ESMTP; 10 Apr 2023 01:41:08 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, jiangshanlai@gmail.com,
        shan.kang@intel.com
Subject: [PATCH v8 33/33] KVM: x86/vmx: refactor VMX_DO_EVENT_IRQOFF to generate FRED stack frames
Date:   Mon, 10 Apr 2023 01:14:38 -0700
Message-Id: <20230410081438.1750-34-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230410081438.1750-1-xin3.li@intel.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Comparing to an IDT stack frame, a FRED stack frame has extra 16 bytes of
information pushed at the regular stack top and 8 bytes of error code _always_
pushed at the regular stack bottom, VMX_DO_EVENT_IRQOFF can be refactored
to generate FRED stack frames with event type and vector properly set. Thus,
IRQ/NMI can be handled with the existing approach when FRED is enabled.

As a FRED stack frame always contains an error code pushed by hardware, call
a trampoline code first to have the return instruction address pushed on
the regular stack. Then the trampoline code pushes an error code (0 for
both IRQ and NMI) and jumps to fred_entrypoint_kernel() for NMI handling or
calls external_interrupt() for IRQ handling.

The trampoline code for IRQ handling pushes general purpose registers to
form a pt_regs structure and then use it to call external_interrupt(). As a
result, IRQ handling no longer re-enter the noinstr code.

Export fred_entrypoint_kernel() and external_interrupt() for above changes.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v7:
* Always call external_interrupt() for IRQ handling on x86_64, thus avoid
  re-entering the noinstr code.
* Create a FRED stack frame when FRED is compiled-in but not enabled, which
  uses some extra stack space but simplifies the code.

Changes since v6:
* Export fred_entrypoint_kernel(), required when kvm-intel built as a module.
* Reserve a REDZONE for CALL emulation and align RSP to a 64-byte boundary
  before pushing a new FRED stack frame.
---
 arch/x86/entry/entry_64_fred.S        |  1 +
 arch/x86/include/asm/asm-prototypes.h |  1 +
 arch/x86/include/asm/fred.h           |  1 +
 arch/x86/include/asm/traps.h          |  2 +
 arch/x86/kernel/traps.c               |  5 ++
 arch/x86/kvm/vmx/vmenter.S            | 78 +++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.c                | 12 +++--
 7 files changed, 93 insertions(+), 7 deletions(-)

diff --git a/arch/x86/entry/entry_64_fred.S b/arch/x86/entry/entry_64_fred.S
index efe2bcd11273..de74ab97ff00 100644
--- a/arch/x86/entry/entry_64_fred.S
+++ b/arch/x86/entry/entry_64_fred.S
@@ -59,3 +59,4 @@ SYM_CODE_START_NOALIGN(fred_entrypoint_kernel)
 	FRED_EXIT
 	ERETS
 SYM_CODE_END(fred_entrypoint_kernel)
+EXPORT_SYMBOL(fred_entrypoint_kernel)
diff --git a/arch/x86/include/asm/asm-prototypes.h b/arch/x86/include/asm/asm-prototypes.h
index b1a98fa38828..076bf8dee702 100644
--- a/arch/x86/include/asm/asm-prototypes.h
+++ b/arch/x86/include/asm/asm-prototypes.h
@@ -12,6 +12,7 @@
 #include <asm/special_insns.h>
 #include <asm/preempt.h>
 #include <asm/asm.h>
+#include <asm/fred.h>
 #include <asm/gsseg.h>
 
 #ifndef CONFIG_X86_CMPXCHG64
diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index f7caf3b2f3f7..d00b9cab6aa6 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -129,6 +129,7 @@ DECLARE_FRED_HANDLER(fred_exc_machine_check);
  * The actual assembly entry and exit points
  */
 extern __visible void fred_entrypoint_user(void);
+extern __visible void fred_entrypoint_kernel(void);
 
 /*
  * Initialization
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 612b3d6fec53..017b95624325 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -58,4 +58,6 @@ typedef DECLARE_SYSTEM_INTERRUPT_HANDLER((*system_interrupt_handler));
 
 system_interrupt_handler get_system_interrupt_handler(unsigned int i);
 
+int external_interrupt(struct pt_regs *regs);
+
 #endif /* _ASM_X86_TRAPS_H */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 73471053ed02..0f1fcd53cb52 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -1573,6 +1573,11 @@ int external_interrupt(struct pt_regs *regs)
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_KVM_INTEL)
+/* For KVM VMX to handle IRQs in IRQ induced VM exits. */
+EXPORT_SYMBOL_GPL(external_interrupt);
+#endif
+
 #endif /* CONFIG_X86_64 */
 
 void __init install_system_interrupt_handler(unsigned int n, const void *asm_addr, const void *addr)
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 631fd7da2bc3..f2e1f8e61be9 100644
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
 
@@ -31,7 +33,7 @@
 #define VCPU_R15	__VCPU_REGS_R15 * WORD_SIZE
 #endif
 
-.macro VMX_DO_EVENT_IRQOFF call_insn call_target
+.macro VMX_DO_EVENT_IRQOFF call_insn call_target fred=0 nmi=0
 	/*
 	 * Unconditionally create a stack frame, getting the correct RSP on the
 	 * stack (for x86-64) would take two instructions anyways, and RBP can
@@ -41,16 +43,55 @@
 	mov %_ASM_SP, %_ASM_BP
 
 #ifdef CONFIG_X86_64
+#ifdef CONFIG_X86_FRED
+	/*
+	 * It's not necessary to change current stack level for handling IRQ/NMI
+	 * because the state of the kernel stack is well defined in this place
+	 * in the code, and it is known not to be deep in a bunch of nested I/O
+	 * layer handlers that eat up the stack.
+	 *
+	 * Before starting to push a FRED stack frame, FRED reserves a redzone
+	 * (for CALL emulation) and aligns RSP to a 64-byte boundary.
+	 */
+	sub $(FRED_CONFIG_REDZONE_AMOUNT << 6), %rsp
+	and $FRED_STACK_FRAME_RSP_MASK, %rsp
+
+	/*
+	 * A FRED stack frame has extra 16 bytes of information pushed at the
+	 * regular stack top comparing to an IDT stack frame.
+	 */
+	push $0		/* Reserved by FRED, must be 0 */
+	push $0		/* FRED event data, 0 for NMI and external interrupts */
+#else
 	/*
 	 * Align RSP to a 16-byte boundary (to emulate CPU behavior) before
 	 * creating the synthetic interrupt stack frame for the IRQ/NMI.
 	 */
 	and  $-16, %rsp
-	push $__KERNEL_DS
+#endif
+
+	.if \fred
+	.if \nmi
+	mov $(2 << 32 | 2 << 48), %rax		/* NMI event type and vector */
+	.else
+	mov %rdi, %rax
+	shl $32, %rax				/* External interrupt vector */
+	.endif
+	add $__KERNEL_DS, %rax
+	bts $57, %rax				/* Set 64-bit mode */
+	.else
+	mov $__KERNEL_DS, %rax
+	.endif
+	push %rax
+
 	push %rbp
 #endif
 	pushf
-	push $__KERNEL_CS
+	mov $__KERNEL_CS, %_ASM_AX
+	.if \fred && \nmi
+	bts $28, %_ASM_AX			/* Set the NMI bit */
+	.endif
+	push %_ASM_AX
 	\call_insn \call_target
 
 	/*
@@ -299,8 +340,19 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
 
 SYM_FUNC_END(__vmx_vcpu_run)
 
+SYM_CODE_START(vmx_do_nmi_trampoline)
+#ifdef CONFIG_X86_FRED
+	ALTERNATIVE "jmp .Lno_errorcode_push", "", X86_FEATURE_FRED
+	push $0		/* FRED error code, 0 for NMI */
+	jmp fred_entrypoint_kernel
+#endif
+
+.Lno_errorcode_push:
+	jmp asm_exc_nmi_kvm_vmx
+SYM_CODE_END(vmx_do_nmi_trampoline)
+
 SYM_FUNC_START(vmx_do_nmi_irqoff)
-	VMX_DO_EVENT_IRQOFF call asm_exc_nmi_kvm_vmx
+	VMX_DO_EVENT_IRQOFF call vmx_do_nmi_trampoline fred=1 nmi=1
 SYM_FUNC_END(vmx_do_nmi_irqoff)
 
 
@@ -357,6 +409,24 @@ SYM_FUNC_START(vmread_error_trampoline)
 SYM_FUNC_END(vmread_error_trampoline)
 #endif
 
+#ifdef CONFIG_X86_64
+SYM_CODE_START(vmx_do_interrupt_trampoline)
+	push $0	/* FRED error code, 0 for NMI and external interrupts */
+	PUSH_REGS
+
+	movq	%rsp, %rdi	/* %rdi -> pt_regs */
+	call external_interrupt
+
+	POP_REGS
+	addq $8,%rsp		/* Drop FRED error code */
+	RET
+SYM_CODE_END(vmx_do_interrupt_trampoline)
+#endif
+
 SYM_FUNC_START(vmx_do_interrupt_irqoff)
+#ifdef CONFIG_X86_64
+	VMX_DO_EVENT_IRQOFF call vmx_do_interrupt_trampoline fred=1
+#else
 	VMX_DO_EVENT_IRQOFF CALL_NOSPEC _ASM_ARG1
+#endif
 SYM_FUNC_END(vmx_do_interrupt_irqoff)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d2d6e1b6c788..d85bcfd191b7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6874,7 +6874,7 @@ static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 	memset(vmx->pi_desc.pir, 0, sizeof(vmx->pi_desc.pir));
 }
 
-void vmx_do_interrupt_irqoff(unsigned long entry);
+void vmx_do_interrupt_irqoff(unsigned long entry_or_vector);
 void vmx_do_nmi_irqoff(void);
 
 static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
@@ -6916,14 +6916,20 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 {
 	u32 intr_info = vmx_get_intr_info(vcpu);
 	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
-	gate_desc *desc = (gate_desc *)host_idt_base + vector;
+	unsigned long entry_or_vector;
+
+#ifdef CONFIG_X86_64
+	entry_or_vector = vector;
+#else
+	entry_or_vector = gate_offset((gate_desc *)host_idt_base + vector);
+#endif
 
 	if (KVM_BUG(!is_external_intr(intr_info), vcpu->kvm,
 	    "unexpected VM-Exit interrupt info: 0x%x", intr_info))
 		return;
 
 	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
-	vmx_do_interrupt_irqoff(gate_offset(desc));
+	vmx_do_interrupt_irqoff(entry_or_vector);
 	kvm_after_interrupt(vcpu);
 
 	vcpu->arch.at_instruction_boundary = true;
-- 
2.34.1

