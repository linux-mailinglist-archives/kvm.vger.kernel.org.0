Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBCD6C9DE2
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 10:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233341AbjC0I1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 04:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbjC0I1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 04:27:05 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F8F5FF9;
        Mon, 27 Mar 2023 01:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679905505; x=1711441505;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MdNLDINmriyqE7KeCKfADER0gVCNbMyHdH3hw5/HrHQ=;
  b=kKmkED1czx7Sfskt/cv4466E6hEYlpFGNlvDFQLHjHXR7ealU3UEenCM
   v0S4SrdykcnVEwE+/GeLaBUhQkq2EnDYxrouP6Nai948tonm57Lf6qETd
   TIfGHS2nU3+sfZFz+SDRFcO/C6N4cbULYHsrLIwN7TcaKVIkfx/TKVgFP
   LMyhiKb3WsAGDqojJcJXmRXvFF5HOxVc1LsjzntouKb/hwwv1ue2pZJBa
   YaPlR2AC9NmXIIeI1udGwtQoiqDCL/OQ+oRikWBcJF7NCBogja5WkLUzC
   MWWqdIdq705/7OLyxGs1hsucPYm1S1nsD8P4iSnfJ+rcj6SMz/gluIxM+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="338930440"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="338930440"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 01:24:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="713787170"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="713787170"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga008.jf.intel.com with ESMTP; 27 Mar 2023 01:24:42 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, jiangshanlai@gmail.com,
        shan.kang@intel.com
Subject: [PATCH v6 33/33] KVM: x86/vmx: refactor VMX_DO_EVENT_IRQOFF to generate FRED stack frames
Date:   Mon, 27 Mar 2023 00:58:38 -0700
Message-Id: <20230327075838.5403-34-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230327075838.5403-1-xin3.li@intel.com>
References: <20230327075838.5403-1-xin3.li@intel.com>
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
a trampoline function first to have the return instruction address pushed on
the regular stack. Then the trampoline function pushes an error code (0 for
both IRQ and NMI) and jumps to fred_entrypoint_kernel() for NMI handling or
calls external_interrupt() for IRQ handling.

The trampoline function for IRQ handling pushes general purpose registers to
form a pt_regs structure and then use it to call external_interrupt(). As a
result, IRQ handling does not execute any noinstr code.

Of course external_interrupt() needs to be exported.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/traps.h |  2 ++
 arch/x86/kernel/traps.c      |  5 +++
 arch/x86/kvm/vmx/vmenter.S   | 59 ++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.c       |  8 ++++-
 4 files changed, 70 insertions(+), 4 deletions(-)

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
index 631fd7da2bc3..43c9da9c9c24 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -8,6 +8,7 @@
 #include <asm/segment.h>
 #include "kvm-asm-offsets.h"
 #include "run_flags.h"
+#include "../../entry/calling.h"
 
 #define WORD_SIZE (BITS_PER_LONG / 8)
 
@@ -31,7 +32,7 @@
 #define VCPU_R15	__VCPU_REGS_R15 * WORD_SIZE
 #endif
 
-.macro VMX_DO_EVENT_IRQOFF call_insn call_target
+.macro VMX_DO_EVENT_IRQOFF call_insn call_target fred=1 nmi=0
 	/*
 	 * Unconditionally create a stack frame, getting the correct RSP on the
 	 * stack (for x86-64) would take two instructions anyways, and RBP can
@@ -46,11 +47,34 @@
 	 * creating the synthetic interrupt stack frame for the IRQ/NMI.
 	 */
 	and  $-16, %rsp
+
+	.if \fred
+	push $0		/* Reserved by FRED, must be 0 */
+	push $0		/* FRED event data, 0 for NMI and external interrupts */
+
+	.if \nmi
+	mov $(2 << 32 | 2 << 48), %_ASM_AX	/* NMI event type and vector */
+	.else
+	mov %_ASM_ARG1, %_ASM_AX
+	shl $32, %_ASM_AX			/* external interrupt vector */
+	.endif
+	add $__KERNEL_DS, %_ASM_AX
+	bts $57, %_ASM_AX			/* bit 57: 64-bit mode */
+	push %_ASM_AX
+	.else
 	push $__KERNEL_DS
+	.endif
+
 	push %rbp
 #endif
 	pushf
+	.if \nmi
+	mov $__KERNEL_CS, %_ASM_AX
+	bts $28, %_ASM_AX			/* set the NMI bit */
+	push %_ASM_AX
+	.else
 	push $__KERNEL_CS
+	.endif
 	\call_insn \call_target
 
 	/*
@@ -299,8 +323,19 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
 
 SYM_FUNC_END(__vmx_vcpu_run)
 
+SYM_FUNC_START(vmx_do_nmi_trampoline)
+#ifdef CONFIG_X86_FRED
+	ALTERNATIVE "jmp .Lno_errorcode_push", "", X86_FEATURE_FRED
+	push $0		/* FRED error code, 0 for NMI */
+	jmp fred_entrypoint_kernel
+#endif
+
+.Lno_errorcode_push:
+	jmp asm_exc_nmi_kvm_vmx
+SYM_FUNC_END(vmx_do_nmi_trampoline)
+
 SYM_FUNC_START(vmx_do_nmi_irqoff)
-	VMX_DO_EVENT_IRQOFF call asm_exc_nmi_kvm_vmx
+	VMX_DO_EVENT_IRQOFF call vmx_do_nmi_trampoline nmi=1
 SYM_FUNC_END(vmx_do_nmi_irqoff)
 
 
@@ -358,5 +393,23 @@ SYM_FUNC_END(vmread_error_trampoline)
 #endif
 
 SYM_FUNC_START(vmx_do_interrupt_irqoff)
-	VMX_DO_EVENT_IRQOFF CALL_NOSPEC _ASM_ARG1
+	VMX_DO_EVENT_IRQOFF CALL_NOSPEC _ASM_ARG1 fred=0
 SYM_FUNC_END(vmx_do_interrupt_irqoff)
+
+#ifdef CONFIG_X86_64
+SYM_FUNC_START(vmx_do_fred_interrupt_trampoline)
+	push $0	/* FRED error code, 0 for NMI and external interrupts */
+	PUSH_REGS
+
+	movq	%rsp, %rdi	/* %rdi -> pt_regs */
+	call external_interrupt
+
+	POP_REGS
+	addq $8,%rsp		/* Drop FRED error code */
+	RET
+SYM_FUNC_END(vmx_do_fred_interrupt_trampoline)
+
+SYM_FUNC_START(vmx_do_fred_interrupt_irqoff)
+	VMX_DO_EVENT_IRQOFF call vmx_do_fred_interrupt_trampoline
+SYM_FUNC_END(vmx_do_fred_interrupt_irqoff)
+#endif
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d2d6e1b6c788..5addfee5cc6d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6875,6 +6875,7 @@ static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 }
 
 void vmx_do_interrupt_irqoff(unsigned long entry);
+void vmx_do_fred_interrupt_irqoff(unsigned int vector);
 void vmx_do_nmi_irqoff(void);
 
 static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
@@ -6923,7 +6924,12 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 		return;
 
 	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
-	vmx_do_interrupt_irqoff(gate_offset(desc));
+#ifdef CONFIG_X86_64
+	if (cpu_feature_enabled(X86_FEATURE_FRED))
+		vmx_do_fred_interrupt_irqoff(vector);
+	else
+#endif
+		vmx_do_interrupt_irqoff(gate_offset(desc));
 	kvm_after_interrupt(vcpu);
 
 	vcpu->arch.at_instruction_boundary = true;
-- 
2.34.1

