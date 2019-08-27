Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7CC9F551
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 23:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731173AbfH0VlY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 17:41:24 -0400
Received: from mga03.intel.com ([134.134.136.65]:61898 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730851AbfH0Vkt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 17:40:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 14:40:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="scan'208";a="182919777"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 27 Aug 2019 14:40:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v2 13/14] KVM: VMX: Handle single-step #DB for EMULTYPE_SKIP on EPT misconfig
Date:   Tue, 27 Aug 2019 14:40:39 -0700
Message-Id: <20190827214040.18710-14-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190827214040.18710-1-sean.j.christopherson@intel.com>
References: <20190827214040.18710-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMX's EPT misconfig flow to handle fast-MMIO path falls back to decoding
the instruction to determine the instruction length when running as a
guest (Hyper-V doesn't fill VMCS.VM_EXIT_INSTRUCTION_LEN because it's
technically not defined for EPT misconfigs).  Rather than implement the
slow skip in VMX's generic skip_emulated_instruction(),
handle_ept_misconfig() directly calls kvm_emulate_instruction() with
EMULTYPE_SKIP, which intentionally doesn't do single-step detection, and
so handle_ept_misconfig() misses a single-step #DB.

Rework the EPT misconfig fallback case to route it through
kvm_skip_emulated_instruction() so that single-step #DBs and interrupt
shadow updates are handled automatically.  I.e. make VMX's slow skip
logic match SVM's and have the SVM flow not intentionally avoid the
shadow update.

Alternatively, the handle_ept_misconfig() could manually handle single-
step detection, but that results in EMULTYPE_SKIP having split logic for
the interrupt shadow vs. single-step #DBs, and split emulator logic is
largely what led to this mess in the first place.

Modifying SVM to mirror VMX flow isn't really an option as SVM's case
isn't limited to a specific exit reason, i.e. handling the slow skip in
skip_emulated_instruction() is mandatory for all intents and purposes.

Drop VMX's skip_emulated_instruction() wrapper since it can now fail,
and instead WARN if it fails unexpectedly, e.g. if exit_reason somehow
becomes corrupted.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Fixes: d391f12070672 ("x86/kvm/vmx: do not use vm-exit instruction length for fast MMIO when running nested")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm.c     | 17 +++++++-------
 arch/x86/kvm/vmx/vmx.c | 52 ++++++++++++++++++------------------------
 arch/x86/kvm/x86.c     |  6 ++++-
 3 files changed, 36 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 2a76b955c230..4e1f79348aa1 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -777,14 +777,15 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 		svm->next_rip = svm->vmcb->control.next_rip;
 	}
 
-	if (!svm->next_rip)
-		return kvm_emulate_instruction(vcpu, EMULTYPE_SKIP);
-
-	if (svm->next_rip - kvm_rip_read(vcpu) > MAX_INST_SIZE)
-		printk(KERN_ERR "%s: ip 0x%lx next 0x%llx\n",
-		       __func__, kvm_rip_read(vcpu), svm->next_rip);
-
-	kvm_rip_write(vcpu, svm->next_rip);
+	if (!svm->next_rip) {
+		if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP))
+			return 0;
+	} else {
+		if (svm->next_rip - kvm_rip_read(vcpu) > MAX_INST_SIZE)
+			pr_err("%s: ip 0x%lx next 0x%llx\n",
+			       __func__, kvm_rip_read(vcpu), svm->next_rip);
+		kvm_rip_write(vcpu, svm->next_rip);
+	}
 	svm_set_interrupt_shadow(vcpu, 0);
 
 	return 1;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ebb97fc11a91..ec20781f2226 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1472,17 +1472,27 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
 	return 0;
 }
 
-/*
- * Returns an int to be compatible with SVM implementation (which can fail).
- * Do not use directly, use skip_emulated_instruction() instead.
- */
-static int __skip_emulated_instruction(struct kvm_vcpu *vcpu)
+static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
 	unsigned long rip;
 
-	rip = kvm_rip_read(vcpu);
-	rip += vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
-	kvm_rip_write(vcpu, rip);
+	/*
+	 * Using VMCS.VM_EXIT_INSTRUCTION_LEN on EPT misconfig depends on
+	 * undefined behavior: Intel's SDM doesn't mandate the VMCS field be
+	 * set when EPT misconfig occurs.  In practice, real hardware updates
+	 * VM_EXIT_INSTRUCTION_LEN on EPT misconfig, but other hypervisors
+	 * (namely Hyper-V) don't set it due to it being undefined behavior,
+	 * i.e. we end up advancing IP with some random value.
+	 */
+	if (!static_cpu_has(X86_FEATURE_HYPERVISOR) ||
+	    to_vmx(vcpu)->exit_reason != EXIT_REASON_EPT_MISCONFIG) {
+		rip = kvm_rip_read(vcpu);
+		rip += vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
+		kvm_rip_write(vcpu, rip);
+	} else {
+		if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP))
+			return 0;
+	}
 
 	/* skipping an emulated instruction also counts */
 	vmx_set_interrupt_shadow(vcpu, 0);
@@ -1490,11 +1500,6 @@ static int __skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static inline void skip_emulated_instruction(struct kvm_vcpu *vcpu)
-{
-	(void)__skip_emulated_instruction(vcpu);
-}
-
 static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -4557,7 +4562,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 			vcpu->arch.dr6 &= ~DR_TRAP_BITS;
 			vcpu->arch.dr6 |= dr6 | DR6_RTM;
 			if (is_icebp(intr_info))
-				skip_emulated_instruction(vcpu);
+				WARN_ON(!skip_emulated_instruction(vcpu));
 
 			kvm_queue_exception(vcpu, DB_VECTOR);
 			return 1;
@@ -5067,7 +5072,7 @@ static int handle_task_switch(struct kvm_vcpu *vcpu)
 	if (!idt_v || (type != INTR_TYPE_HARD_EXCEPTION &&
 		       type != INTR_TYPE_EXT_INTR &&
 		       type != INTR_TYPE_NMI_INTR))
-		skip_emulated_instruction(vcpu);
+		WARN_ON(!skip_emulated_instruction(vcpu));
 
 	/*
 	 * TODO: What about debug traps on tss switch?
@@ -5134,20 +5139,7 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
 	if (!is_guest_mode(vcpu) &&
 	    !kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS, gpa, 0, NULL)) {
 		trace_kvm_fast_mmio(gpa);
-		/*
-		 * Doing kvm_skip_emulated_instruction() depends on undefined
-		 * behavior: Intel's manual doesn't mandate
-		 * VM_EXIT_INSTRUCTION_LEN to be set in VMCS when EPT MISCONFIG
-		 * occurs and while on real hardware it was observed to be set,
-		 * other hypervisors (namely Hyper-V) don't set it, we end up
-		 * advancing IP with some random value. Disable fast mmio when
-		 * running nested and keep it for real hardware in hope that
-		 * VM_EXIT_INSTRUCTION_LEN will always be set correctly.
-		 */
-		if (!static_cpu_has(X86_FEATURE_HYPERVISOR))
-			return kvm_skip_emulated_instruction(vcpu);
-		else
-			return kvm_emulate_instruction(vcpu, EMULTYPE_SKIP);
+		return kvm_skip_emulated_instruction(vcpu);
 	}
 
 	return kvm_mmu_page_fault(vcpu, gpa, PFERR_RSVD_MASK, NULL, 0);
@@ -7701,7 +7693,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 
 	.run = vmx_vcpu_run,
 	.handle_exit = vmx_handle_exit,
-	.skip_emulated_instruction = __skip_emulated_instruction,
+	.skip_emulated_instruction = skip_emulated_instruction,
 	.set_interrupt_shadow = vmx_set_interrupt_shadow,
 	.get_interrupt_shadow = vmx_get_interrupt_shadow,
 	.patch_hypercall = vmx_patch_hypercall,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 53a16eb2aba8..9d5a2b77473b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6552,11 +6552,15 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 		return 1;
 	}
 
+	/*
+	 * Note, EMULTYPE_SKIP is intended for use *only* by vendor callbacks
+	 * for kvm_skip_emulated_instruction().  The caller is responsible for
+	 * updating interruptibility state and injecting single-step #DBs.
+	 */
 	if (emulation_type & EMULTYPE_SKIP) {
 		kvm_rip_write(vcpu, ctxt->_eip);
 		if (ctxt->eflags & X86_EFLAGS_RF)
 			kvm_set_rflags(vcpu, ctxt->eflags & ~X86_EFLAGS_RF);
-		kvm_x86_ops->set_interrupt_shadow(vcpu, 0);
 		return 1;
 	}
 
-- 
2.22.0

