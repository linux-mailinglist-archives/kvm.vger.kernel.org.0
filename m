Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43E319A48F
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 03:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732903AbfHWBHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 21:07:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:37991 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732776AbfHWBHP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 21:07:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 18:07:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,419,1559545200"; 
   d="scan'208";a="186733524"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Aug 2019 18:07:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 13/13] KVM: x86: Remove emulation_result enums, EMULATE_{DONE,FAIL,USER_EXIT}
Date:   Thu, 22 Aug 2019 18:07:09 -0700
Message-Id: <20190823010709.24879-14-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190823010709.24879-1-sean.j.christopherson@intel.com>
References: <20190823010709.24879-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Deferring emulation failure handling (in some cases) to the caller of
x86_emulate_instruction() has proven fragile, e.g. multiple instances of
KVM not setting run->exit_reason on EMULATE_FAIL, largely due to it
being difficult to discern what emulation types can return what result,
and which combination of types and results are handled where.

Now that x86_emulate_instruction() always handles emulation failure,
i.e. EMULATION_FAIL is only referenced in callers, remove the
emulation_result enums entirely.  Per KVM's existing exit handling
conventions, return '0' and '1' for "exit to userspace" and "resume
guest" respectively.  Doing so cleans up many callers, e.g. they can
return kvm_emulate_instruction() directly instead of having to interpret
its result.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  6 ----
 arch/x86/kvm/mmu.c              | 14 ++------
 arch/x86/kvm/svm.c              | 22 ++++++-------
 arch/x86/kvm/vmx/vmx.c          | 28 ++++++----------
 arch/x86/kvm/x86.c              | 57 ++++++++++++++++-----------------
 5 files changed, 49 insertions(+), 78 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a38c93362945..3f524cea20ad 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1308,12 +1308,6 @@ extern u64  kvm_default_tsc_scaling_ratio;
 
 extern u64 kvm_mce_cap_supported;
 
-enum emulation_result {
-	EMULATE_DONE,         /* no further processing */
-	EMULATE_USER_EXIT,    /* kvm_run ready for userspace exit */
-	EMULATE_FAIL,         /* can't emulate this instruction */
-};
-
 #define EMULTYPE_NO_DECODE	    (1 << 0)
 #define EMULTYPE_TRAP_UD	    (1 << 1)
 #define EMULTYPE_SKIP		    (1 << 2)
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 845e39d8a970..22322f61f794 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5364,7 +5364,6 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
 		       void *insn, int insn_len)
 {
 	int r, emulation_type = 0;
-	enum emulation_result er;
 	bool direct = vcpu->arch.mmu->direct_map;
 
 	/* With shadow page tables, fault_address contains a GVA or nGPA.  */
@@ -5431,17 +5430,8 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
 			return 1;
 	}
 
-	er = x86_emulate_instruction(vcpu, cr2, emulation_type, insn, insn_len);
-
-	switch (er) {
-	case EMULATE_DONE:
-		return 1;
-	case EMULATE_USER_EXIT:
-	case EMULATE_FAIL:
-		return 0;
-	default:
-		BUG();
-	}
+	return x86_emulate_instruction(vcpu, cr2, emulation_type, insn,
+				       insn_len);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d9d88cecaba6..f374f11358b7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -787,7 +787,7 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	kvm_rip_write(vcpu, svm->next_rip);
 	svm_set_interrupt_shadow(vcpu, 0);
 
-	return EMULATE_DONE;
+	return 1;
 }
 
 static void svm_queue_exception(struct kvm_vcpu *vcpu)
@@ -2775,8 +2775,7 @@ static int gp_interception(struct vcpu_svm *svm)
 		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
 		return 1;
 	}
-	return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP) !=
-						EMULATE_USER_EXIT;
+	return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP);
 }
 
 static bool is_erratum_383(void)
@@ -2874,7 +2873,7 @@ static int io_interception(struct vcpu_svm *svm)
 	string = (io_info & SVM_IOIO_STR_MASK) != 0;
 	in = (io_info & SVM_IOIO_TYPE_MASK) != 0;
 	if (string)
-		return kvm_emulate_instruction(vcpu, 0) == EMULATE_DONE;
+		return kvm_emulate_instruction(vcpu, 0);
 
 	port = io_info >> 16;
 	size = (io_info & SVM_IOIO_SIZE_MASK) >> SVM_IOIO_SIZE_SHIFT;
@@ -3881,17 +3880,15 @@ static int task_switch_interception(struct vcpu_svm *svm)
 	    int_type == SVM_EXITINTINFO_TYPE_SOFT ||
 	    (int_type == SVM_EXITINTINFO_TYPE_EXEPT &&
 	     (int_vec == OF_VECTOR || int_vec == BP_VECTOR))) {
-		if (skip_emulated_instruction(&svm->vcpu) == EMULATE_USER_EXIT)
+		if (!skip_emulated_instruction(&svm->vcpu))
 			return 0;
 	}
 
 	if (int_type != SVM_EXITINTINFO_TYPE_SOFT)
 		int_vec = -1;
 
-
-
 	return kvm_task_switch(&svm->vcpu, tss_selector, int_vec, reason,
-			       has_error_code, error_code) != EMULATE_USER_EXIT;
+			       has_error_code, error_code);
 }
 
 static int cpuid_interception(struct vcpu_svm *svm)
@@ -3912,7 +3909,7 @@ static int iret_interception(struct vcpu_svm *svm)
 static int invlpg_interception(struct vcpu_svm *svm)
 {
 	if (!static_cpu_has(X86_FEATURE_DECODEASSISTS))
-		return kvm_emulate_instruction(&svm->vcpu, 0) == EMULATE_DONE;
+		return kvm_emulate_instruction(&svm->vcpu, 0);
 
 	kvm_mmu_invlpg(&svm->vcpu, svm->vmcb->control.exit_info_1);
 	return kvm_skip_emulated_instruction(&svm->vcpu);
@@ -3920,13 +3917,12 @@ static int invlpg_interception(struct vcpu_svm *svm)
 
 static int emulate_on_interception(struct vcpu_svm *svm)
 {
-	return kvm_emulate_instruction(&svm->vcpu, 0) == EMULATE_DONE;
+	return kvm_emulate_instruction(&svm->vcpu, 0);
 }
 
 static int rsm_interception(struct vcpu_svm *svm)
 {
-	return kvm_emulate_instruction_from_buffer(&svm->vcpu,
-					rsm_ins_bytes, 2) == EMULATE_DONE;
+	return kvm_emulate_instruction_from_buffer(&svm->vcpu, rsm_ins_bytes, 2);
 }
 
 static int rdpmc_interception(struct vcpu_svm *svm)
@@ -4745,7 +4741,7 @@ static int avic_unaccelerated_access_interception(struct vcpu_svm *svm)
 		ret = avic_unaccel_trap_write(svm);
 	} else {
 		/* Handling Fault */
-		ret = (kvm_emulate_instruction(&svm->vcpu, 0) == EMULATE_DONE);
+		ret = kvm_emulate_instruction(&svm->vcpu, 0);
 	}
 
 	return ret;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5b5f622cc092..44d868c49301 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1487,7 +1487,7 @@ static int __skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	/* skipping an emulated instruction also counts */
 	vmx_set_interrupt_shadow(vcpu, 0);
 
-	return EMULATE_DONE;
+	return 1;
 }
 
 static inline void skip_emulated_instruction(struct kvm_vcpu *vcpu)
@@ -4438,7 +4438,7 @@ static int handle_rmode_exception(struct kvm_vcpu *vcpu,
 	 * Cause the #SS fault with 0 error code in VM86 mode.
 	 */
 	if (((vec == GP_VECTOR) || (vec == SS_VECTOR)) && err_code == 0) {
-		if (kvm_emulate_instruction(vcpu, 0) == EMULATE_DONE) {
+		if (kvm_emulate_instruction(vcpu, 0)) {
 			if (vcpu->arch.halt_request) {
 				vcpu->arch.halt_request = 0;
 				return kvm_vcpu_halt(vcpu);
@@ -4510,8 +4510,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 			kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
 			return 1;
 		}
-		return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP) !=
-							EMULATE_USER_EXIT;
+		return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP);
 	}
 
 	/*
@@ -4608,7 +4607,7 @@ static int handle_io(struct kvm_vcpu *vcpu)
 	++vcpu->stat.io_exits;
 
 	if (string)
-		return kvm_emulate_instruction(vcpu, 0) == EMULATE_DONE;
+		return kvm_emulate_instruction(vcpu, 0);
 
 	port = exit_qualification >> 16;
 	size = (exit_qualification & 7) + 1;
@@ -4682,7 +4681,7 @@ static int handle_set_cr4(struct kvm_vcpu *vcpu, unsigned long val)
 static int handle_desc(struct kvm_vcpu *vcpu)
 {
 	WARN_ON(!(vcpu->arch.cr4 & X86_CR4_UMIP));
-	return kvm_emulate_instruction(vcpu, 0) == EMULATE_DONE;
+	return kvm_emulate_instruction(vcpu, 0);
 }
 
 static int handle_cr(struct kvm_vcpu *vcpu)
@@ -4927,7 +4926,7 @@ static int handle_vmcall(struct kvm_vcpu *vcpu)
 
 static int handle_invd(struct kvm_vcpu *vcpu)
 {
-	return kvm_emulate_instruction(vcpu, 0) == EMULATE_DONE;
+	return kvm_emulate_instruction(vcpu, 0);
 }
 
 static int handle_invlpg(struct kvm_vcpu *vcpu)
@@ -4994,7 +4993,7 @@ static int handle_apic_access(struct kvm_vcpu *vcpu)
 			return kvm_skip_emulated_instruction(vcpu);
 		}
 	}
-	return kvm_emulate_instruction(vcpu, 0) == EMULATE_DONE;
+	return kvm_emulate_instruction(vcpu, 0);
 }
 
 static int handle_apic_eoi_induced(struct kvm_vcpu *vcpu)
@@ -5071,7 +5070,7 @@ static int handle_task_switch(struct kvm_vcpu *vcpu)
 	 */
 	return kvm_task_switch(vcpu, tss_selector,
 			       type == INTR_TYPE_SOFT_INTR ? idt_index : -1,
-			       reason, has_error_code, error_code) != EMULATE_USER_EXIT;
+			       reason, has_error_code, error_code);
 }
 
 static int handle_ept_violation(struct kvm_vcpu *vcpu)
@@ -5143,8 +5142,7 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
 		if (!static_cpu_has(X86_FEATURE_HYPERVISOR))
 			return kvm_skip_emulated_instruction(vcpu);
 		else
-			return kvm_emulate_instruction(vcpu, EMULTYPE_SKIP) ==
-								EMULATE_DONE;
+			return kvm_emulate_instruction(vcpu, EMULTYPE_SKIP);
 	}
 
 	return kvm_mmu_page_fault(vcpu, gpa, PFERR_RSVD_MASK, NULL, 0);
@@ -5163,7 +5161,6 @@ static int handle_nmi_window(struct kvm_vcpu *vcpu)
 static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	enum emulation_result err = EMULATE_DONE;
 	bool intr_window_requested;
 	unsigned count = 130;
 
@@ -5184,14 +5181,9 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 		if (kvm_test_request(KVM_REQ_EVENT, vcpu))
 			return 1;
 
-		err = kvm_emulate_instruction(vcpu, 0);
-
-		if (err == EMULATE_USER_EXIT)
+		if (!kvm_emulate_instruction(vcpu, 0))
 			return 0;
 
-		if (WARN_ON_ONCE(err == EMULATE_FAIL))
-			return 1;
-
 		if (vmx->emulation_required && !vmx->rmode.vm86_active &&
 		    vcpu->arch.exception.pending) {
 			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e457363622e5..53a16eb2aba8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5339,7 +5339,7 @@ int handle_ud(struct kvm_vcpu *vcpu)
 		emul_type = EMULTYPE_TRAP_UD_FORCED;
 	}
 
-	return kvm_emulate_instruction(vcpu, emul_type) != EMULATE_USER_EXIT;
+	return kvm_emulate_instruction(vcpu, emul_type);
 }
 EXPORT_SYMBOL_GPL(handle_ud);
 
@@ -6205,14 +6205,14 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 
 	if (emulation_type & EMULTYPE_VMWARE_GP) {
 		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
-		return EMULATE_DONE;
+		return 1;
 	}
 
 	if (emulation_type & EMULTYPE_SKIP) {
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
 		vcpu->run->internal.ndata = 0;
-		return EMULATE_USER_EXIT;
+		return 0;
 	}
 
 	kvm_queue_exception(vcpu, UD_VECTOR);
@@ -6221,10 +6221,10 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
 		vcpu->run->internal.ndata = 0;
-		return EMULATE_USER_EXIT;
+		return 0;
 	}
 
-	return EMULATE_DONE;
+	return 1;
 }
 
 static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t cr2,
@@ -6388,10 +6388,10 @@ static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu)
 		kvm_run->debug.arch.pc = vcpu->arch.singlestep_rip;
 		kvm_run->debug.arch.exception = DB_VECTOR;
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
-		return EMULATE_USER_EXIT;
+		return 0;
 	}
 	kvm_queue_exception_p(vcpu, DB_VECTOR, DR6_BS);
-	return EMULATE_DONE;
+	return 1;
 }
 
 int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
@@ -6400,7 +6400,7 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	int r;
 
 	r = kvm_x86_ops->skip_emulated_instruction(vcpu);
-	if (unlikely(r != EMULATE_DONE))
+	if (unlikely(!r))
 		return 0;
 
 	/*
@@ -6413,7 +6413,7 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	 */
 	if (unlikely(rflags & X86_EFLAGS_TF))
 		r = kvm_vcpu_do_singlestep(vcpu);
-	return r == EMULATE_DONE;
+	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_skip_emulated_instruction);
 
@@ -6432,7 +6432,7 @@ static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
 			kvm_run->debug.arch.pc = eip;
 			kvm_run->debug.arch.exception = DB_VECTOR;
 			kvm_run->exit_reason = KVM_EXIT_DEBUG;
-			*r = EMULATE_USER_EXIT;
+			*r = 0;
 			return true;
 		}
 	}
@@ -6448,7 +6448,7 @@ static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
 			vcpu->arch.dr6 &= ~DR_TRAP_BITS;
 			vcpu->arch.dr6 |= dr6 | DR6_RTM;
 			kvm_queue_exception(vcpu, DB_VECTOR);
-			*r = EMULATE_DONE;
+			*r = 1;
 			return true;
 		}
 	}
@@ -6535,13 +6535,13 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 			if ((emulation_type & EMULTYPE_TRAP_UD) ||
 			    (emulation_type & EMULTYPE_TRAP_UD_FORCED)) {
 				kvm_queue_exception(vcpu, UD_VECTOR);
-				return EMULATE_DONE;
+				return 1;
 			}
 			if (reexecute_instruction(vcpu, cr2, write_fault_to_spt,
 						emulation_type))
-				return EMULATE_DONE;
+				return 1;
 			if (ctxt->have_exception && inject_emulated_exception(vcpu))
-				return EMULATE_DONE;
+				return 1;
 			return handle_emulation_failure(vcpu, emulation_type);
 		}
 	}
@@ -6549,7 +6549,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 	if ((emulation_type & EMULTYPE_VMWARE_GP) &&
 	    !is_vmware_backdoor_opcode(ctxt)) {
 		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
-		return EMULATE_DONE;
+		return 1;
 	}
 
 	if (emulation_type & EMULTYPE_SKIP) {
@@ -6557,11 +6557,11 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 		if (ctxt->eflags & X86_EFLAGS_RF)
 			kvm_set_rflags(vcpu, ctxt->eflags & ~X86_EFLAGS_RF);
 		kvm_x86_ops->set_interrupt_shadow(vcpu, 0);
-		return EMULATE_DONE;
+		return 1;
 	}
 
 	if (retry_instruction(ctxt, cr2, emulation_type))
-		return EMULATE_DONE;
+		return 1;
 
 	/* this is needed for vmware backdoor interface to work since it
 	   changes registers values  during IO operation */
@@ -6577,18 +6577,18 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 	r = x86_emulate_insn(ctxt);
 
 	if (r == EMULATION_INTERCEPTED)
-		return EMULATE_DONE;
+		return 1;
 
 	if (r == EMULATION_FAILED) {
 		if (reexecute_instruction(vcpu, cr2, write_fault_to_spt,
 					emulation_type))
-			return EMULATE_DONE;
+			return 1;
 
 		return handle_emulation_failure(vcpu, emulation_type);
 	}
 
 	if (ctxt->have_exception) {
-		r = EMULATE_DONE;
+		r = 1;
 		if (inject_emulated_exception(vcpu))
 			return r;
 	} else if (vcpu->arch.pio.count) {
@@ -6599,25 +6599,25 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 			writeback = false;
 			vcpu->arch.complete_userspace_io = complete_emulated_pio;
 		}
-		r = EMULATE_USER_EXIT;
+		r = 0;
 	} else if (vcpu->mmio_needed) {
 		++vcpu->stat.mmio_exits;
 
 		if (!vcpu->mmio_is_write)
 			writeback = false;
-		r = EMULATE_USER_EXIT;
+		r = 0;
 		vcpu->arch.complete_userspace_io = complete_emulated_mmio;
 	} else if (r == EMULATION_RESTART)
 		goto restart;
 	else
-		r = EMULATE_DONE;
+		r = 1;
 
 	if (writeback) {
 		unsigned long rflags = kvm_x86_ops->get_rflags(vcpu);
 		toggle_interruptibility(vcpu, ctxt->interruptibility);
 		vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
 		kvm_rip_write(vcpu, ctxt->eip);
-		if (r == EMULATE_DONE && ctxt->tf)
+		if (r && ctxt->tf)
 			r = kvm_vcpu_do_singlestep(vcpu);
 		if (!ctxt->have_exception ||
 		    exception_type(ctxt->exception.vector) == EXCPT_TRAP)
@@ -8213,12 +8213,11 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 static inline int complete_emulated_io(struct kvm_vcpu *vcpu)
 {
 	int r;
+
 	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 	r = kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE);
 	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
-	if (r != EMULATE_DONE)
-		return 0;
-	return 1;
+	return r;
 }
 
 static int complete_emulated_pio(struct kvm_vcpu *vcpu)
@@ -8590,13 +8589,13 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
 		vcpu->run->internal.ndata = 0;
-		return EMULATE_USER_EXIT;
+		return 0;
 	}
 
 	kvm_rip_write(vcpu, ctxt->eip);
 	kvm_set_rflags(vcpu, ctxt->eflags);
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
-	return EMULATE_DONE;
+	return 1;
 }
 EXPORT_SYMBOL_GPL(kvm_task_switch);
 
-- 
2.22.0

