Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC5E26AD86
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 21:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgIOT0U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 15:26:20 -0400
Received: from mga18.intel.com ([134.134.136.126]:37595 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727960AbgIOTPN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 15:15:13 -0400
IronPort-SDR: jQUEd+vJEx4SA4+KQiX//vem2dBP/Bnkm0zMzEC3/wdRruho8EjTin/22NYy+Vm2yDmv3PpNXT
 +ky70b3YSe8g==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="147082731"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="147082731"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 12:15:08 -0700
IronPort-SDR: x9f57plf7ZJ+OJ3I5thAEF0Uu3RcSCDq9uNYiOAqtWE5H3fbDBbIf2u41HmvS6Wo0n+msAQ7Ao
 0I4NCQqJ+c4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="507694446"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga005.fm.intel.com with ESMTP; 15 Sep 2020 12:15:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH v2 1/2] KVM: VMX: Move IRQ invocation to assembly subroutine
Date:   Tue, 15 Sep 2020 12:15:04 -0700
Message-Id: <20200915191505.10355-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915191505.10355-1-sean.j.christopherson@intel.com>
References: <20200915191505.10355-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the asm blob that invokes the appropriate IRQ handler after VM-Exit
into a proper subroutine.  Unconditionally create a stack frame in the
subroutine so that, as objtool sees things, the function has standard
stack behavior.  The dynamic stack adjustment makes using unwind hints
problematic.

Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmenter.S | 34 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c     | 33 +++------------------------------
 2 files changed, 37 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 799db084a336..90ad7a6246e3 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -4,6 +4,7 @@
 #include <asm/bitsperlong.h>
 #include <asm/kvm_vcpu_regs.h>
 #include <asm/nospec-branch.h>
+#include <asm/segment.h>
 
 #define WORD_SIZE (BITS_PER_LONG / 8)
 
@@ -294,3 +295,36 @@ SYM_FUNC_START(vmread_error_trampoline)
 
 	ret
 SYM_FUNC_END(vmread_error_trampoline)
+
+SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
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
+	CALL_NOSPEC _ASM_ARG1
+
+	/*
+	 * "Restore" RSP from RBP, even though IRET has already unwound RSP to
+	 * the correct value.  objtool doesn't know the callee will IRET and,
+	 * without the explicit restore, thinks the stack is getting walloped.
+	 * Using an unwind hint is problematic due to x86-64's dynamic alignment.
+	 */
+	mov %_ASM_BP, %_ASM_SP
+	pop %_ASM_BP
+	ret
+SYM_FUNC_END(vmx_do_interrupt_nmi_irqoff)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 46ba2e03a892..391f079d9136 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6409,6 +6409,8 @@ static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 	memset(vmx->pi_desc.pir, 0, sizeof(vmx->pi_desc.pir));
 }
 
+void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
+
 static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
 {
 	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
@@ -6430,10 +6432,6 @@ static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
 static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 {
 	unsigned int vector;
-	unsigned long entry;
-#ifdef CONFIG_X86_64
-	unsigned long tmp;
-#endif
 	gate_desc *desc;
 	u32 intr_info = vmx_get_intr_info(vcpu);
 
@@ -6443,36 +6441,11 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 
 	vector = intr_info & INTR_INFO_VECTOR_MASK;
 	desc = (gate_desc *)host_idt_base + vector;
-	entry = gate_offset(desc);
 
 	kvm_before_interrupt(vcpu);
-
-	asm volatile(
-#ifdef CONFIG_X86_64
-		"mov %%rsp, %[sp]\n\t"
-		"and $-16, %%rsp\n\t"
-		"push %[ss]\n\t"
-		"push %[sp]\n\t"
-#endif
-		"pushf\n\t"
-		"push %[cs]\n\t"
-		CALL_NOSPEC
-		:
-#ifdef CONFIG_X86_64
-		[sp]"=&r"(tmp),
-#endif
-		ASM_CALL_CONSTRAINT
-		:
-		[thunk_target]"r"(entry),
-#ifdef CONFIG_X86_64
-		[ss]"i"(__KERNEL_DS),
-#endif
-		[cs]"i"(__KERNEL_CS)
-	);
-
+	vmx_do_interrupt_nmi_irqoff(gate_offset(desc));
 	kvm_after_interrupt(vcpu);
 }
-STACK_FRAME_NON_STANDARD(handle_external_interrupt_irqoff);
 
 static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
-- 
2.28.0

