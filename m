Return-Path: <kvm+bounces-72121-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wKglF+vvoGmOoAQAu9opvQ
	(envelope-from <kvm+bounces-72121-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 02:14:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DF35C1B1717
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 02:14:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C5B0730B54F9
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 01:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 304762D0C97;
	Fri, 27 Feb 2026 01:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hKdYouIO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C78283CBF;
	Fri, 27 Feb 2026 01:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772154796; cv=none; b=d2b7qx7Xhm8Q/FuXhigYQWl+OVr2iP4jHhEFwQ62FWtO7vuDroLrsg1I+EKmZLMC+Le4OOS3pMcVMaDjvjifcoIhyL0UnOwZijWw2nYv0gNwJYaYQ8YxCyCLY5HXwIIIiKal6Zs62sWO7iwdw8nK7+9KFhvZHWw5rIwV+HcqcmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772154796; c=relaxed/simple;
	bh=mDYqh6GemFCjr7ottiOKdiu1PcHAuOFMku95NE54oiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DjMSFFxkkkgo40Erx8smGmf9zvz3/SD8tpny2B3L9PAu9b6Qa2BtnbzG1EzBqUgS8+pGsc7ZdFHsYc4QNmXkCw9aAhMB4CEZp0+lmaxU5Vc4Ghp8rFjx4nrnblXo/vrlhxxAE0XT2ZZ1tdJxEODxUyD3vGiwM9XS03rqpgvWOtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hKdYouIO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE01FC19423;
	Fri, 27 Feb 2026 01:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772154796;
	bh=mDYqh6GemFCjr7ottiOKdiu1PcHAuOFMku95NE54oiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hKdYouIOjDXx0aZVIntyqa/pR7tHrAZB4jArom+PjUaWU7oVn/QErRJYvYLcaXTZK
	 li2ajITA35SEJElELwtbnkr5exRExTlFeq5SAeGQc1uYZmmaafKoggbp+6CW8f85dI
	 upUMjC1v1UzqQIHnWRxQoG39AWf1W6PZ5CGvLCXn1M+6LFVEm/iH/kaECq6gNcbOuZ
	 tcsjWRdlfv1t9twNV4Pk+sBkU4YFUXtvNQfPQ19WBZrC0M7Pa6AAMQGVKdDPVsS4Hc
	 xXv6AnkO5FklZSS++WGcy1GvycYGyvd1IHdBoSi+QZn18861KSUuS84jaXzuQH513M
	 4zZmwxh89etVA==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH 1/3] KVM: x86: Move nested_run_pending to kvm_vcpu_arch
Date: Fri, 27 Feb 2026 01:13:04 +0000
Message-ID: <20260227011306.3111731-2-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260227011306.3111731-1-yosry@kernel.org>
References: <20260227011306.3111731-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72121-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,cr0.pg:url]
X-Rspamd-Queue-Id: DF35C1B1717
X-Rspamd-Action: no action

Move nested_run_pending field present in both svm_nested_state and
nested_vmx to the common kvm_vcpu_arch. This allows for common code to
use without plumbing it through per-vendor helpers.

nested_run_pending remains zero-initialized, as the entire kvm_vcpu
struct is, and all further accesses are done through vcpu->arch instead
of svm->nested or vmx->nested.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/svm/nested.c       | 14 +++++-----
 arch/x86/kvm/svm/svm.c          | 12 ++++-----
 arch/x86/kvm/svm/svm.h          |  4 ---
 arch/x86/kvm/vmx/nested.c       | 46 ++++++++++++++++-----------------
 arch/x86/kvm/vmx/vmx.c          | 16 ++++++------
 arch/x86/kvm/vmx/vmx.h          |  3 ---
 7 files changed, 47 insertions(+), 51 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ff07c45e3c731..0d989f1b67657 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1098,6 +1098,9 @@ struct kvm_vcpu_arch {
 	 */
 	bool pdptrs_from_userspace;
 
+	/* Pending nested VM-Enter to L2, cannot synthesize a VM-Exit to L1 */
+	bool nested_run_pending;
+
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t hv_root_tdp;
 #endif
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index de90b104a0dd5..c2d4c9c63146e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1049,7 +1049,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	if (!npt_enabled)
 		vmcb01->save.cr3 = kvm_read_cr3(vcpu);
 
-	svm->nested.nested_run_pending = 1;
+	vcpu->arch.nested_run_pending = 1;
 
 	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, true))
 		goto out_exit_err;
@@ -1058,7 +1058,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 		goto out;
 
 out_exit_err:
-	svm->nested.nested_run_pending = 0;
+	vcpu->arch.nested_run_pending = 0;
 	svm->nmi_l1_to_l2 = false;
 	svm->soft_int_injected = false;
 
@@ -1138,7 +1138,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	/* Exit Guest-Mode */
 	leave_guest_mode(vcpu);
 	svm->nested.vmcb12_gpa = 0;
-	WARN_ON_ONCE(svm->nested.nested_run_pending);
+	WARN_ON_ONCE(vcpu->arch.nested_run_pending);
 
 	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 
@@ -1399,7 +1399,7 @@ void svm_leave_nested(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	if (is_guest_mode(vcpu)) {
-		svm->nested.nested_run_pending = 0;
+		vcpu->arch.nested_run_pending = 0;
 		svm->nested.vmcb12_gpa = INVALID_GPA;
 
 		leave_guest_mode(vcpu);
@@ -1584,7 +1584,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 	 * previously injected event, the pending exception occurred while said
 	 * event was being delivered and thus needs to be handled.
 	 */
-	bool block_nested_exceptions = svm->nested.nested_run_pending;
+	bool block_nested_exceptions = vcpu->arch.nested_run_pending;
 	/*
 	 * New events (not exceptions) are only recognized at instruction
 	 * boundaries.  If an event needs reinjection, then KVM is handling a
@@ -1761,7 +1761,7 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
 		kvm_state.size += KVM_STATE_NESTED_SVM_VMCB_SIZE;
 		kvm_state.flags |= KVM_STATE_NESTED_GUEST_MODE;
 
-		if (svm->nested.nested_run_pending)
+		if (vcpu->arch.nested_run_pending)
 			kvm_state.flags |= KVM_STATE_NESTED_RUN_PENDING;
 	}
 
@@ -1898,7 +1898,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 	svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
 
-	svm->nested.nested_run_pending =
+	vcpu->arch.nested_run_pending =
 		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
 
 	svm->nested.vmcb12_gpa = kvm_state->hdr.svm.vmcb_pa;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8f8bc863e2143..1d5f119ed2484 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3860,7 +3860,7 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
 static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	if (svm->nested.nested_run_pending)
+	if (vcpu->arch.nested_run_pending)
 		return -EBUSY;
 
 	if (svm_nmi_blocked(vcpu))
@@ -3902,7 +3902,7 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (svm->nested.nested_run_pending)
+	if (vcpu->arch.nested_run_pending)
 		return -EBUSY;
 
 	if (svm_interrupt_blocked(vcpu))
@@ -4403,11 +4403,11 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 		nested_sync_control_from_vmcb02(svm);
 
 		/* Track VMRUNs that have made past consistency checking */
-		if (svm->nested.nested_run_pending &&
+		if (vcpu->arch.nested_run_pending &&
 		    !svm_is_vmrun_failure(svm->vmcb->control.exit_code))
                         ++vcpu->stat.nested_run;
 
-		svm->nested.nested_run_pending = 0;
+		vcpu->arch.nested_run_pending = 0;
 	}
 
 	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
@@ -4766,7 +4766,7 @@ bool svm_smi_blocked(struct kvm_vcpu *vcpu)
 static int svm_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	if (svm->nested.nested_run_pending)
+	if (vcpu->arch.nested_run_pending)
 		return -EBUSY;
 
 	if (svm_smi_blocked(vcpu))
@@ -4884,7 +4884,7 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
 	if (ret)
 		goto unmap_save;
 
-	svm->nested.nested_run_pending = 1;
+	vcpu->arch.nested_run_pending = 1;
 
 unmap_save:
 	kvm_vcpu_unmap(vcpu, &map_save);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ebd7b36b1ceb9..e6ca25b1c7807 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -195,10 +195,6 @@ struct svm_nested_state {
 	 */
 	void *msrpm;
 
-	/* A VMRUN has started but has not yet been performed, so
-	 * we cannot inject a nested vmexit yet.  */
-	bool nested_run_pending;
-
 	/* cache for control fields of the guest */
 	struct vmcb_ctrl_area_cached ctl;
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 248635da67661..031075467a6dc 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2273,7 +2273,7 @@ static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu,
 
 static u64 nested_vmx_calc_efer(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 {
-	if (vmx->nested.nested_run_pending &&
+	if (vmx->vcpu.arch.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_EFER))
 		return vmcs12->guest_ia32_efer;
 	else if (vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE)
@@ -2513,7 +2513,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 	/*
 	 * Interrupt/Exception Fields
 	 */
-	if (vmx->nested.nested_run_pending) {
+	if (vmx->vcpu.arch.nested_run_pending) {
 		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
 			     vmcs12->vm_entry_intr_info_field);
 		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE,
@@ -2621,7 +2621,7 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 			vmcs_write64(GUEST_PDPTR3, vmcs12->guest_pdptr3);
 		}
 
-		if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
+		if (kvm_mpx_supported() && vmx->vcpu.arch.nested_run_pending &&
 		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
 			vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
 	}
@@ -2718,7 +2718,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 			!(evmcs->hv_clean_fields & HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1);
 	}
 
-	if (vmx->nested.nested_run_pending &&
+	if (vcpu->arch.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS)) {
 		kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
 		vmx_guest_debugctl_write(vcpu, vmcs12->guest_ia32_debugctl &
@@ -2728,13 +2728,13 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		vmx_guest_debugctl_write(vcpu, vmx->nested.pre_vmenter_debugctl);
 	}
 
-	if (!vmx->nested.nested_run_pending ||
+	if (!vcpu->arch.nested_run_pending ||
 	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE))
 		vmcs_write_cet_state(vcpu, vmx->nested.pre_vmenter_s_cet,
 				     vmx->nested.pre_vmenter_ssp,
 				     vmx->nested.pre_vmenter_ssp_tbl);
 
-	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
+	if (kvm_mpx_supported() && (!vcpu->arch.nested_run_pending ||
 	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
 		vmcs_write64(GUEST_BNDCFGS, vmx->nested.pre_vmenter_bndcfgs);
 	vmx_set_rflags(vcpu, vmcs12->guest_rflags);
@@ -2747,7 +2747,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	vcpu->arch.cr0_guest_owned_bits &= ~vmcs12->cr0_guest_host_mask;
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~vcpu->arch.cr0_guest_owned_bits);
 
-	if (vmx->nested.nested_run_pending &&
+	if (vcpu->arch.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT)) {
 		vmcs_write64(GUEST_IA32_PAT, vmcs12->guest_ia32_pat);
 		vcpu->arch.pat = vmcs12->guest_ia32_pat;
@@ -3335,7 +3335,7 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	 *   to bit 8 (LME) if bit 31 in the CR0 field (corresponding to
 	 *   CR0.PG) is 1.
 	 */
-	if (to_vmx(vcpu)->nested.nested_run_pending &&
+	if (vcpu->arch.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_EFER)) {
 		if (CC(!kvm_valid_efer(vcpu, vmcs12->guest_ia32_efer)) ||
 		    CC(ia32e != !!(vmcs12->guest_ia32_efer & EFER_LMA)) ||
@@ -3613,15 +3613,15 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 
 	kvm_service_local_tlb_flush_requests(vcpu);
 
-	if (!vmx->nested.nested_run_pending ||
+	if (!vcpu->arch.nested_run_pending ||
 	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
 		vmx->nested.pre_vmenter_debugctl = vmx_guest_debugctl_read();
 	if (kvm_mpx_supported() &&
-	    (!vmx->nested.nested_run_pending ||
+	    (!vcpu->arch.nested_run_pending ||
 	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
 		vmx->nested.pre_vmenter_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
 
-	if (!vmx->nested.nested_run_pending ||
+	if (!vcpu->arch.nested_run_pending ||
 	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE))
 		vmcs_read_cet_state(vcpu, &vmx->nested.pre_vmenter_s_cet,
 				    &vmx->nested.pre_vmenter_ssp,
@@ -3830,7 +3830,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	 * We're finally done with prerequisite checking, and can start with
 	 * the nested entry.
 	 */
-	vmx->nested.nested_run_pending = 1;
+	vcpu->arch.nested_run_pending = 1;
 	vmx->nested.has_preemption_timer_deadline = false;
 	status = nested_vmx_enter_non_root_mode(vcpu, true);
 	if (unlikely(status != NVMX_VMENTRY_SUCCESS))
@@ -3862,12 +3862,12 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 		    !nested_cpu_has(vmcs12, CPU_BASED_NMI_WINDOW_EXITING) &&
 		    !(nested_cpu_has(vmcs12, CPU_BASED_INTR_WINDOW_EXITING) &&
 		      (vmcs12->guest_rflags & X86_EFLAGS_IF))) {
-			vmx->nested.nested_run_pending = 0;
+			vcpu->arch.nested_run_pending = 0;
 			return kvm_emulate_halt_noskip(vcpu);
 		}
 		break;
 	case GUEST_ACTIVITY_WAIT_SIPI:
-		vmx->nested.nested_run_pending = 0;
+		vcpu->arch.nested_run_pending = 0;
 		kvm_set_mp_state(vcpu, KVM_MP_STATE_INIT_RECEIVED);
 		break;
 	default:
@@ -3877,7 +3877,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	return 1;
 
 vmentry_failed:
-	vmx->nested.nested_run_pending = 0;
+	vcpu->arch.nested_run_pending = 0;
 	if (status == NVMX_VMENTRY_KVM_INTERNAL_ERROR)
 		return 0;
 	if (status == NVMX_VMENTRY_VMEXIT)
@@ -4274,7 +4274,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	 * previously injected event, the pending exception occurred while said
 	 * event was being delivered and thus needs to be handled.
 	 */
-	bool block_nested_exceptions = vmx->nested.nested_run_pending;
+	bool block_nested_exceptions = vcpu->arch.nested_run_pending;
 	/*
 	 * Events that don't require injection, i.e. that are virtualized by
 	 * hardware, aren't blocked by a pending VM-Enter as KVM doesn't need
@@ -4643,7 +4643,7 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 
 	if (nested_cpu_has_preemption_timer(vmcs12) &&
 	    vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER &&
-	    !vmx->nested.nested_run_pending)
+	    !vcpu->arch.nested_run_pending)
 		vmcs12->vmx_preemption_timer_value =
 			vmx_get_preemption_timer_value(vcpu);
 
@@ -5042,7 +5042,7 @@ void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	vmx->nested.mtf_pending = false;
 
 	/* trying to cancel vmlaunch/vmresume is a bug */
-	WARN_ON_ONCE(vmx->nested.nested_run_pending);
+	WARN_ON_ONCE(vcpu->arch.nested_run_pending);
 
 #ifdef CONFIG_KVM_HYPERV
 	if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
@@ -6665,7 +6665,7 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 	unsigned long exit_qual;
 	u32 exit_intr_info;
 
-	WARN_ON_ONCE(vmx->nested.nested_run_pending);
+	WARN_ON_ONCE(vcpu->arch.nested_run_pending);
 
 	/*
 	 * Late nested VM-Fail shares the same flow as nested VM-Exit since KVM
@@ -6761,7 +6761,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 		if (is_guest_mode(vcpu)) {
 			kvm_state.flags |= KVM_STATE_NESTED_GUEST_MODE;
 
-			if (vmx->nested.nested_run_pending)
+			if (vcpu->arch.nested_run_pending)
 				kvm_state.flags |= KVM_STATE_NESTED_RUN_PENDING;
 
 			if (vmx->nested.mtf_pending)
@@ -6836,7 +6836,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 void vmx_leave_nested(struct kvm_vcpu *vcpu)
 {
 	if (is_guest_mode(vcpu)) {
-		to_vmx(vcpu)->nested.nested_run_pending = 0;
+		vcpu->arch.nested_run_pending = 0;
 		nested_vmx_vmexit(vcpu, -1, 0, 0);
 	}
 	free_nested(vcpu);
@@ -6973,7 +6973,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE))
 		return 0;
 
-	vmx->nested.nested_run_pending =
+	vcpu->arch.nested_run_pending =
 		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
 
 	vmx->nested.mtf_pending =
@@ -7025,7 +7025,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	return 0;
 
 error_guest_mode:
-	vmx->nested.nested_run_pending = 0;
+	vcpu->arch.nested_run_pending = 0;
 	return ret;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 967b58a8ab9d0..9ef3fb04403d2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5279,7 +5279,7 @@ bool vmx_nmi_blocked(struct kvm_vcpu *vcpu)
 
 int vmx_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
-	if (to_vmx(vcpu)->nested.nested_run_pending)
+	if (vcpu->arch.nested_run_pending)
 		return -EBUSY;
 
 	/* An NMI must not be injected into L2 if it's supposed to VM-Exit.  */
@@ -5306,7 +5306,7 @@ bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu)
 
 int vmx_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
-	if (to_vmx(vcpu)->nested.nested_run_pending)
+	if (vcpu->arch.nested_run_pending)
 		return -EBUSY;
 
 	/*
@@ -6118,7 +6118,7 @@ static bool vmx_unhandleable_emulation_required(struct kvm_vcpu *vcpu)
 	 * only reachable if userspace modifies L2 guest state after KVM has
 	 * performed the nested VM-Enter consistency checks.
 	 */
-	if (vmx->nested.nested_run_pending)
+	if (vcpu->arch.nested_run_pending)
 		return true;
 
 	/*
@@ -6802,7 +6802,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	 * invalid guest state should never happen as that means KVM knowingly
 	 * allowed a nested VM-Enter with an invalid vmcs12.  More below.
 	 */
-	if (KVM_BUG_ON(vmx->nested.nested_run_pending, vcpu->kvm))
+	if (KVM_BUG_ON(vcpu->arch.nested_run_pending, vcpu->kvm))
 		return -EIO;
 
 	if (is_guest_mode(vcpu)) {
@@ -7730,11 +7730,11 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 		 * Track VMLAUNCH/VMRESUME that have made past guest state
 		 * checking.
 		 */
-		if (vmx->nested.nested_run_pending &&
+		if (vcpu->arch.nested_run_pending &&
 		    !vmx_get_exit_reason(vcpu).failed_vmentry)
 			++vcpu->stat.nested_run;
 
-		vmx->nested.nested_run_pending = 0;
+		vcpu->arch.nested_run_pending = 0;
 	}
 
 	if (unlikely(vmx->fail))
@@ -8491,7 +8491,7 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu)
 int vmx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	/* we need a nested vmexit to enter SMM, postpone if run is pending */
-	if (to_vmx(vcpu)->nested.nested_run_pending)
+	if (vcpu->arch.nested_run_pending)
 		return -EBUSY;
 	return !is_smm(vcpu);
 }
@@ -8532,7 +8532,7 @@ int vmx_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
 		if (ret)
 			return ret;
 
-		vmx->nested.nested_run_pending = 1;
+		vcpu->arch.nested_run_pending = 1;
 		vmx->nested.smm.guest_mode = false;
 	}
 	return 0;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 70bfe81dea540..db84e8001da58 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -138,9 +138,6 @@ struct nested_vmx {
 	 */
 	bool enlightened_vmcs_enabled;
 
-	/* L2 must run next, and mustn't decide to exit to L1. */
-	bool nested_run_pending;
-
 	/* Pending MTF VM-exit into L1.  */
 	bool mtf_pending;
 
-- 
2.53.0.473.g4a7958ca14-goog


