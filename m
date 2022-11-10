Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0CC623BAF
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 07:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbiKJGR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 01:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232353AbiKJGRV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 01:17:21 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972492ED74
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 22:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668061040; x=1699597040;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=btiN7wu6yHcG/APG6+UAvWqTkcuTq8Wkw/RVvQEA/KE=;
  b=UFuDICDlXM8XDuj2dEHsuV/OkRV5rSadt0Edbr2WtgP7jds61PvQSyLq
   Rc5ybyF4u7sPNbeWpyr+xH3VN/6ZmB7lQOqPmhwMo1ZPlZQYNSwktGEQa
   QtdJ24yBbTgyj65BdikoK30srYDYpIQdicfP0PWG81MqWr+UjmcFo6DAh
   GRD+tAlT+XTF6FPP6aD9ME5C/K7HbIIXMVrC5UO2hxpBBSAgSnWtJj1G/
   hUO6SYTcWzNpSfgSc3iuWhPshbAU4ozz3OixXFRAWqe/nGlKkQaRQyA4Y
   T1ZOdv6nxZHC4Nwg4iTTldScwAnXX79iLL+IHWRJ6ZA4iGnRYwcIVaDXO
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="311223528"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="311223528"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 22:17:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="700667274"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="700667274"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 09 Nov 2022 22:17:17 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernnel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, kevin.tian@intel.com
Subject: [PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq() for NMI/IRQ reinjection
Date:   Wed,  9 Nov 2022 21:53:46 -0800
Message-Id: <20221110055347.7463-6-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110055347.7463-1-xin3.li@intel.com>
References: <20221110055347.7463-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To eliminate dispatching NMI/IRQ through the IDT, add
kvm_vmx_reinject_nmi_irq(), which calls external_interrupt()
for IRQ reinjection.

Lastly replace calling a NMI/IRQ handler in an IDT descriptor
with calling kvm_vmx_reinject_nmi_irq().

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/traps.h |  2 ++
 arch/x86/kernel/traps.c      | 23 +++++++++++++++++++++++
 arch/x86/kvm/vmx/vmenter.S   | 33 ---------------------------------
 arch/x86/kvm/vmx/vmx.c       | 19 +++++++------------
 4 files changed, 32 insertions(+), 45 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 89c4233e19db..4c56a8d31762 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -57,4 +57,6 @@ void __noreturn handle_stack_overflow(struct pt_regs *regs,
 		unsigned long vector __maybe_unused)
 typedef DECLARE_SYSTEM_INTERRUPT_HANDLER((*system_interrupt_handler));
 
+void kvm_vmx_reinject_nmi_irq(u32 vector);
+
 #endif /* _ASM_X86_TRAPS_H */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index c1eb3bd335ce..9abf91534b13 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -1528,6 +1528,29 @@ __visible noinstr void external_interrupt(struct pt_regs *regs,
 	common_interrupt(regs, vector);
 }
 
+#if IS_ENABLED(CONFIG_KVM_INTEL)
+/*
+ * KVM VMX reinjects NMI/IRQ on its current stack, it's a sync
+ * call thus the values in the pt_regs structure are not used in
+ * executing NMI/IRQ handlers, except cs.RPL and flags.IF, which
+ * are both always 0 in the VMX NMI/IRQ reinjection context. Thus
+ * we simply allocate a zeroed pt_regs structure on current stack
+ * to call external_interrupt().
+ */
+void kvm_vmx_reinject_nmi_irq(u32 vector)
+{
+	struct pt_regs irq_regs;
+
+	memset(&irq_regs, 0, sizeof(irq_regs));
+
+	if (vector == NMI_VECTOR)
+		return exc_nmi(&irq_regs);
+
+	external_interrupt(&irq_regs, vector);
+}
+EXPORT_SYMBOL_GPL(kvm_vmx_reinject_nmi_irq);
+#endif
+
 void __init trap_init(void)
 {
 	/* Init cpu_entry_area before IST entries are set up */
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 8477d8bdd69c..0c1608b329cd 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -317,36 +317,3 @@ SYM_FUNC_START(vmread_error_trampoline)
 
 	RET
 SYM_FUNC_END(vmread_error_trampoline)
-
-SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
-	/*
-	 * Unconditionally create a stack frame, getting the correct RSP on the
-	 * stack (for x86-64) would take two instructions anyways, and RBP can
-	 * be used to restore RSP to make objtool happy (see below).
-	 */
-	push %_ASM_BP
-	mov %_ASM_SP, %_ASM_BP
-
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
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 63247c57c72c..b457e4888468 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -46,6 +46,7 @@
 #include <asm/mshyperv.h>
 #include <asm/mwait.h>
 #include <asm/spec-ctrl.h>
+#include <asm/traps.h>
 #include <asm/virtext.h>
 #include <asm/vmx.h>
 
@@ -6758,15 +6759,11 @@ static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 	memset(vmx->pi_desc.pir, 0, sizeof(vmx->pi_desc.pir));
 }
 
-void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
-
-static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
-					unsigned long entry)
+static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu, u32 vector)
 {
-	bool is_nmi = entry == (unsigned long)asm_exc_nmi_noist;
-
-	kvm_before_interrupt(vcpu, is_nmi ? KVM_HANDLING_NMI : KVM_HANDLING_IRQ);
-	vmx_do_interrupt_nmi_irqoff(entry);
+	kvm_before_interrupt(vcpu, vector == NMI_VECTOR ?
+				   KVM_HANDLING_NMI : KVM_HANDLING_IRQ);
+	kvm_vmx_reinject_nmi_irq(vector);
 	kvm_after_interrupt(vcpu);
 }
 
@@ -6792,7 +6789,6 @@ static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
 
 static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
 {
-	const unsigned long nmi_entry = (unsigned long)asm_exc_nmi_noist;
 	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
 
 	/* if exit due to PF check for async PF */
@@ -6806,20 +6802,19 @@ static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
 		kvm_machine_check();
 	/* We need to handle NMIs before interrupts are enabled */
 	else if (is_nmi(intr_info))
-		handle_interrupt_nmi_irqoff(&vmx->vcpu, nmi_entry);
+		handle_interrupt_nmi_irqoff(&vmx->vcpu, NMI_VECTOR);
 }
 
 static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 {
 	u32 intr_info = vmx_get_intr_info(vcpu);
 	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
-	gate_desc *desc = (gate_desc *)host_idt_base + vector;
 
 	if (KVM_BUG(!is_external_intr(intr_info), vcpu->kvm,
 	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
 		return;
 
-	handle_interrupt_nmi_irqoff(vcpu, gate_offset(desc));
+	handle_interrupt_nmi_irqoff(vcpu, vector);
 	vcpu->arch.at_instruction_boundary = true;
 }
 
-- 
2.34.1

