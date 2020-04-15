Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CACF1AB03F
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 20:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411646AbgDOR7a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 13:59:30 -0400
Received: from mga18.intel.com ([134.134.136.126]:30609 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441072AbgDORzc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 13:55:32 -0400
IronPort-SDR: EVdjmh/sCK8CIYnCO/8JzERUTb6NqpYrUftCT/5luvbHJBeBksGULxQ9d3FerO8fYNnXeOUSCV
 p4ztj9pxx6pQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 10:55:25 -0700
IronPort-SDR: rIyvRrsfOfs12vCRwg+J2r8Zc0NuaQVdfPE+aV9we346vC3aEGkZQCpQEl1N1Y022DPssYS8Sc
 ER91dLdgMZyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,387,1580803200"; 
   d="scan'208";a="332567364"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 15 Apr 2020 10:55:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 10/10] KVM: VMX: Convert vcpu_vmx.exit_reason to a union
Date:   Wed, 15 Apr 2020 10:55:19 -0700
Message-Id: <20200415175519.14230-11-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200415175519.14230-1-sean.j.christopherson@intel.com>
References: <20200415175519.14230-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert vcpu_vmx.exit_reason from a u32 to a union (of size u32).  The
full VM_EXIT_REASON field is comprised of a 16-bit basic exit reason in
bits 15:0, and single-bit modifiers in bits 31:16.

Historically, KVM has only had to worry about handling the "failed
VM-Entry" modifier, which could only be set in very specific flows and
required dedicated handling.  I.e. manually stripping the FAILED_VMENTRY
bit was a somewhat viable approach.  But even with only a single bit to
worry about, KVM has had several bugs related to comparing a basic exit
reason against the full exit reason store in vcpu_vmx.

Upcoming Intel features, e.g. SGX, will add new modifier bits that can
be set on more or less any VM-Exit, as opposed to the significantly more
restricted FAILED_VMENTRY, i.e. correctly handling everything in one-off
flows isn't scalable.  Tracking exit reason in a union forces code to
explicitly choose between consuming the full exit reason and the basic
exit, and is a convenient way to document and access the modifiers.

No functional change intended.

Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 37 +++++++++++++++--------
 arch/x86/kvm/vmx/vmx.c    | 62 ++++++++++++++++++++-------------------
 arch/x86/kvm/vmx/vmx.h    | 25 +++++++++++++++-
 3 files changed, 80 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6f303ccd478d..f22810b3b980 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3255,7 +3255,10 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	bool evaluate_pending_interrupts;
-	u32 exit_reason = EXIT_REASON_INVALID_STATE;
+	union vmx_exit_reason exit_reason = {
+		.basic = EXIT_REASON_INVALID_STATE,
+		.failed_vmentry = 1,
+	};
 	u32 exit_qual;
 
 	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
@@ -3316,7 +3319,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 		goto vmentry_fail_vmexit_guest_mode;
 
 	if (from_vmentry) {
-		exit_reason = EXIT_REASON_MSR_LOAD_FAIL;
+		exit_reason.basic = EXIT_REASON_MSR_LOAD_FAIL;
 		exit_qual = nested_vmx_load_msr(vcpu,
 						vmcs12->vm_entry_msr_load_addr,
 						vmcs12->vm_entry_msr_load_count);
@@ -3384,7 +3387,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 		return NVMX_VMENTRY_VMEXIT;
 
 	load_vmcs12_host_state(vcpu, vmcs12);
-	vmcs12->vm_exit_reason = exit_reason | VMX_EXIT_REASONS_FAILED_VMENTRY;
+	vmcs12->vm_exit_reason = exit_reason.full;
 	vmcs12->exit_qualification = exit_qual;
 	if (enable_shadow_vmcs || vmx->nested.hv_evmcs)
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
@@ -5418,7 +5421,12 @@ static int handle_vmfunc(struct kvm_vcpu *vcpu)
 	return kvm_skip_emulated_instruction(vcpu);
 
 fail:
-	nested_vmx_vmexit(vcpu, vmx->exit_reason,
+	/*
+	 * This is effectively a reflected VM-Exit, as opposed to a synthesized
+	 * nested VM-Exit.  Pass the original exit reason, i.e. don't hardcode
+	 * EXIT_REASON_VMFUNC as the exit reason.
+	 */
+	nested_vmx_vmexit(vcpu, vmx->exit_reason.full,
 			  vmcs_read32(VM_EXIT_INTR_INFO),
 			  vmcs_readl(EXIT_QUALIFICATION));
 	return 1;
@@ -5486,7 +5494,8 @@ static bool nested_vmx_exit_handled_io(struct kvm_vcpu *vcpu,
  * MSR bitmap. This may be the case even when L0 doesn't use MSR bitmaps.
  */
 static bool nested_vmx_exit_handled_msr(struct kvm_vcpu *vcpu,
-	struct vmcs12 *vmcs12, u32 exit_reason)
+					struct vmcs12 *vmcs12,
+					union vmx_exit_reason exit_reason)
 {
 	u32 msr_index = kvm_rcx_read(vcpu);
 	gpa_t bitmap;
@@ -5500,7 +5509,7 @@ static bool nested_vmx_exit_handled_msr(struct kvm_vcpu *vcpu,
 	 * First we need to figure out which of the four to use:
 	 */
 	bitmap = vmcs12->msr_bitmap;
-	if (exit_reason == EXIT_REASON_MSR_WRITE)
+	if (exit_reason.basic == EXIT_REASON_MSR_WRITE)
 		bitmap += 2048;
 	if (msr_index >= 0xc0000000) {
 		msr_index -= 0xc0000000;
@@ -5646,11 +5655,12 @@ static bool nested_vmx_exit_handled_mtf(struct vmcs12 *vmcs12)
  * Return true if L0 wants to handle an exit from L2 regardless of whether or not
  * L1 wants the exit.  Only call this when in is_guest_mode (L2).
  */
-static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu, u32 exit_reason)
+static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
+				     union vmx_exit_reason exit_reason)
 {
 	u32 intr_info;
 
-	switch (exit_reason) {
+	switch (exit_reason.basic) {
 	case EXIT_REASON_EXCEPTION_NMI:
 		intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 		if (is_nmi(intr_info))
@@ -5706,12 +5716,13 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu, u32 exit_reason)
  * Return 1 if L1 wants to intercept an exit from L2.  Only call this when in
  * is_guest_mode (L2).
  */
-static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu, u32 exit_reason)
+static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
+				     union vmx_exit_reason exit_reason)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	u32 intr_info;
 
-	switch (exit_reason) {
+	switch (exit_reason.basic) {
 	case EXIT_REASON_EXCEPTION_NMI:
 		intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 		if (is_nmi(intr_info))
@@ -5830,7 +5841,7 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu, u32 exit_reason)
 bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u32 exit_reason = vmx->exit_reason;
+	union vmx_exit_reason exit_reason = vmx->exit_reason;
 	u32 exit_intr_info, exit_qual;
 
 	WARN_ON_ONCE(vmx->nested.nested_run_pending);
@@ -5851,7 +5862,7 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 	exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 	exit_qual = vmcs_readl(EXIT_QUALIFICATION);
 
-	trace_kvm_nested_vmexit(kvm_rip_read(vcpu), exit_reason, exit_qual,
+	trace_kvm_nested_vmexit(kvm_rip_read(vcpu), exit_reason.full, exit_qual,
 				vmx->idt_vectoring_info, exit_intr_info,
 				vmcs_read32(VM_EXIT_INTR_ERROR_CODE),
 				KVM_ISA_VMX);
@@ -5880,7 +5891,7 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 	}
 
 reflect_vmexit:
-	nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info, exit_qual);
+	nested_vmx_vmexit(vcpu, exit_reason.full, exit_intr_info, exit_qual);
 	return true;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 19a82f846e8e..98da427c0d4b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1562,7 +1562,7 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	 * i.e. we end up advancing IP with some random value.
 	 */
 	if (!static_cpu_has(X86_FEATURE_HYPERVISOR) ||
-	    to_vmx(vcpu)->exit_reason != EXIT_REASON_EPT_MISCONFIG) {
+	    to_vmx(vcpu)->exit_reason.basic != EXIT_REASON_EPT_MISCONFIG) {
 		rip = kvm_rip_read(vcpu);
 		rip += vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
 		kvm_rip_write(vcpu, rip);
@@ -5872,10 +5872,11 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 	enum exit_fastpath_completion exit_fastpath)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u32 exit_reason = vmx->exit_reason;
+	union vmx_exit_reason exit_reason = vmx->exit_reason;
 	u32 vectoring_info = vmx->idt_vectoring_info;
+	u16 exit_handler_index;
 
-	trace_kvm_exit(exit_reason, vcpu, KVM_ISA_VMX);
+	trace_kvm_exit(exit_reason.full, vcpu, KVM_ISA_VMX);
 
 	/*
 	 * Flush logged GPAs PML buffer, this will make dirty_bitmap more
@@ -5909,11 +5910,11 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 			return 1;
 	}
 
-	if (exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY) {
+	if (exit_reason.failed_vmentry) {
 		dump_vmcs();
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
-			= exit_reason;
+			= exit_reason.full;
 		return 0;
 	}
 
@@ -5933,17 +5934,17 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 	 * will cause infinite loop.
 	 */
 	if ((vectoring_info & VECTORING_INFO_VALID_MASK) &&
-			(exit_reason != EXIT_REASON_EXCEPTION_NMI &&
-			exit_reason != EXIT_REASON_EPT_VIOLATION &&
-			exit_reason != EXIT_REASON_PML_FULL &&
-			exit_reason != EXIT_REASON_TASK_SWITCH)) {
+	    (exit_reason.basic != EXIT_REASON_EXCEPTION_NMI &&
+	     exit_reason.basic != EXIT_REASON_EPT_VIOLATION &&
+	     exit_reason.basic != EXIT_REASON_PML_FULL &&
+	     exit_reason.basic != EXIT_REASON_TASK_SWITCH)) {
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_DELIVERY_EV;
 		vcpu->run->internal.ndata = 3;
 		vcpu->run->internal.data[0] = vectoring_info;
-		vcpu->run->internal.data[1] = exit_reason;
+		vcpu->run->internal.data[1] = exit_reason.full;
 		vcpu->run->internal.data[2] = vcpu->arch.exit_qualification;
-		if (exit_reason == EXIT_REASON_EPT_MISCONFIG) {
+		if (exit_reason.basic == EXIT_REASON_EPT_MISCONFIG) {
 			vcpu->run->internal.ndata++;
 			vcpu->run->internal.data[3] =
 				vmcs_read64(GUEST_PHYSICAL_ADDRESS);
@@ -5975,38 +5976,39 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 		return 1;
 	}
 
-	if (exit_reason >= kvm_vmx_max_exit_handlers)
+	if (exit_reason.basic >= kvm_vmx_max_exit_handlers)
 		goto unexpected_vmexit;
 #ifdef CONFIG_RETPOLINE
-	if (exit_reason == EXIT_REASON_MSR_WRITE)
+	if (exit_reason.basic == EXIT_REASON_MSR_WRITE)
 		return kvm_emulate_wrmsr(vcpu);
-	else if (exit_reason == EXIT_REASON_PREEMPTION_TIMER)
+	else if (exit_reason.basic == EXIT_REASON_PREEMPTION_TIMER)
 		return handle_preemption_timer(vcpu);
-	else if (exit_reason == EXIT_REASON_INTERRUPT_WINDOW)
+	else if (exit_reason.basic == EXIT_REASON_INTERRUPT_WINDOW)
 		return handle_interrupt_window(vcpu);
-	else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
+	else if (exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
 		return handle_external_interrupt(vcpu);
-	else if (exit_reason == EXIT_REASON_HLT)
+	else if (exit_reason.basic == EXIT_REASON_HLT)
 		return kvm_emulate_halt(vcpu);
-	else if (exit_reason == EXIT_REASON_EPT_MISCONFIG)
+	else if (exit_reason.basic == EXIT_REASON_EPT_MISCONFIG)
 		return handle_ept_misconfig(vcpu);
 #endif
 
-	exit_reason = array_index_nospec(exit_reason,
-					 kvm_vmx_max_exit_handlers);
-	if (!kvm_vmx_exit_handlers[exit_reason])
+	exit_handler_index = array_index_nospec((u16)exit_reason.basic,
+						kvm_vmx_max_exit_handlers);
+	if (!kvm_vmx_exit_handlers[exit_handler_index])
 		goto unexpected_vmexit;
 
-	return kvm_vmx_exit_handlers[exit_reason](vcpu);
+	return kvm_vmx_exit_handlers[exit_handler_index](vcpu);
 
 unexpected_vmexit:
-	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n", exit_reason);
+	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
+		    exit_reason.full);
 	dump_vmcs();
 	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 	vcpu->run->internal.suberror =
 			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
 	vcpu->run->internal.ndata = 1;
-	vcpu->run->internal.data[0] = exit_reason;
+	vcpu->run->internal.data[0] = exit_reason.full;
 	return 0;
 }
 
@@ -6359,12 +6361,12 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu,
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (vmx->exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
+	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
 		handle_external_interrupt_irqoff(vcpu);
-	else if (vmx->exit_reason == EXIT_REASON_EXCEPTION_NMI)
+	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)
 		handle_exception_nmi_irqoff(vmx);
 	else if (!is_guest_mode(vcpu) &&
-		vmx->exit_reason == EXIT_REASON_MSR_WRITE)
+		 vmx->exit_reason.basic == EXIT_REASON_MSR_WRITE)
 		*exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
 }
 
@@ -6736,11 +6738,11 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx->nested.nested_run_pending = 0;
 	vmx->idt_vectoring_info = 0;
 
-	vmx->exit_reason = vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON);
-	if ((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY)
+	vmx->exit_reason.full = vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON);
+	if (vmx->exit_reason.basic == EXIT_REASON_MCE_DURING_VMENTRY)
 		kvm_machine_check();
 
-	if (vmx->fail || (vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
+	if (vmx->fail || vmx->exit_reason.failed_vmentry)
 		return;
 
 	vmx->loaded_vmcs->launched = 1;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 31d7252df163..d7013c939ead 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -90,6 +90,29 @@ struct pt_desc {
 	struct pt_ctx guest;
 };
 
+union vmx_exit_reason {
+	struct {
+		u32	basic			: 16;
+		u32	reserved16		: 1;
+		u32	reserved17		: 1;
+		u32	reserved18		: 1;
+		u32	reserved19		: 1;
+		u32	reserved20		: 1;
+		u32	reserved21		: 1;
+		u32	reserved22		: 1;
+		u32	reserved23		: 1;
+		u32	reserved24		: 1;
+		u32	reserved25		: 1;
+		u32	reserved26		: 1;
+		u32	enclave_mode		: 1;
+		u32	smi_pending_mtf		: 1;
+		u32	smi_from_vmx_root	: 1;
+		u32	reserved30		: 1;
+		u32	failed_vmentry		: 1;
+	};
+	u32 full;
+};
+
 /*
  * The nested_vmx structure is part of vcpu_vmx, and holds information we need
  * for correct emulation of VMX (i.e., nested VMX) on this vcpu.
@@ -261,7 +284,7 @@ struct vcpu_vmx {
 	int vpid;
 	bool emulation_required;
 
-	u32 exit_reason;
+	union vmx_exit_reason exit_reason;
 
 	/* Posted interrupt descriptor */
 	struct pi_desc pi_desc;
-- 
2.26.0

