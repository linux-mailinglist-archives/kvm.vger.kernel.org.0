Return-Path: <kvm+bounces-21665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ADF7931D5B
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 00:57:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37FD51C215F9
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 22:57:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36BC413E02B;
	Mon, 15 Jul 2024 22:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZdUUXnIm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63133BBC2
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 22:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721084232; cv=none; b=K5ZUNKxGZJ1l0BiBTPz4cSrk3XGoi0SMHxpsLwP9fIWnKELDOLdlhTDYMujbo0ruFZrAVRodXG+479NqN3Y0EQ3l8pKJoC4+M8rH8WnDC7WkPwQe+rFzOu62nxqmtXNLqoixsP2fRbG4f+mUWvsV7AK/nGjpWu6TzEhsiioP210=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721084232; c=relaxed/simple;
	bh=58vKqcwpGRGJs9CnWxmBNJVLw8BGfXqYVCVz4TQ+/G4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=U9LZbTouqO/EVhtdPKZbNKw8BocvLr2J3PfG27lSXmWruOgxqNkUwzTNgwYjcIstFPMHvMW92PvkFDMSAe+rG8xil44tGlmtUxBgo7yi4tX6GEkS7pqiqeckvIHCiuZBWVV4m9Pq27+Iy5EzZKgT4pkEf0Rm2QmbSJ8peWfcK0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZdUUXnIm; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721084231; x=1752620231;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=58vKqcwpGRGJs9CnWxmBNJVLw8BGfXqYVCVz4TQ+/G4=;
  b=ZdUUXnImfwXkcJ0/N0jSr5feh7Q70C9i/5ieuvJ1R0NSCvYNc/kGE5pr
   jeaN0+bQhQGW0n3UoXI2g51g+CppLflV8aOAKpl5iI2hEIV6KYsuI1moZ
   zmEz7Ow4qPZxPzaj5HRaF1f9xkegrtNcFCR2g5PB+i/1HSIl1/AO4Bvxu
   R5qpgdRwUomf3Tkbjyg+prCc9338GS8B/4h91/DkrBHq3v1ww/zpIq/CF
   LnhpnYx5PixU/kRzH0FaLnPGa4mPC0HRa6YNZnJGI1GlNT1EeJNcBns9N
   paZephbSVbumj5DkSItkJKTSOhV4H+Ec1fB7i64BxM3I90J0efIRzKeG+
   w==;
X-CSE-ConnectionGUID: m2D2YVTOT4iG7F1x7zar7A==
X-CSE-MsgGUID: wU9fKG9tSjOXefxkWjYNCQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11134"; a="18302600"
X-IronPort-AV: E=Sophos;i="6.09,211,1716274800"; 
   d="scan'208";a="18302600"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 15:57:10 -0700
X-CSE-ConnectionGUID: rl+4Umm0RkqPOLXWUee3dQ==
X-CSE-MsgGUID: oSLA//c6SKaytMYOZ/cYTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,211,1716274800"; 
   d="scan'208";a="49864877"
Received: from otc-tsn-4.jf.intel.com ([10.23.153.135])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 15:57:09 -0700
From: Kishen Maloor <kishen.maloor@intel.com>
To: kvm@vger.kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	lprosek@redhat.com,
	mlevitsk@redhat.com
Cc: Kishen Maloor <kishen.maloor@intel.com>
Subject: [PATCH] KVM: nVMX: Simplify SMM entry/exit flows in nested guest mode
Date: Mon, 15 Jul 2024 18:56:54 -0400
Message-Id: <20240715225654.32614-1-kishen.maloor@intel.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This change aims to resolve a TODO documented in commit 5d76b1f8c793
("KVM: nVMX: Rename nested.vmcs01_* fields to nested.pre_vmenter_*"):

/*
 * TODO: Implement custom flows for forcing the vCPU out/in of L2 on
 * SMI and RSM.  Using the common VM-Exit + VM-Enter routines is wrong
 * SMI and RSM only modify state that is saved and restored via SMRAM.
 * E.g. most MSRs are left untouched, but many are modified by VM-Exit
 * and VM-Enter, and thus L2's values may be corrupted on SMI+RSM.
 */

When a SMI is injected while running a L2 guest, the VMX enter/leave_smm()
callbacks currently invoke the standard L2 VM-Exit/Entry routines. This has
the side-effect of touching more state than necessary to emulate SMM.

This change thus introduces new functions nested_vmx_enter_smm() and
nested_vmx_leave_smm() to be invoked by the VMX enter/leave_smm()
callbacks respectively during SMI and RSM. These functions cover
the sufficient steps to transition a vCPU out of L2 after SMI and back
into L2 during RSM.

nested_vmx_enter_smm() updates and flushes the vmcs12 cache, leaves guest
mode, deinitializes the nested mmu context, switches to vmcs01 and loads
the host cr3 to facilitate execution of the SMM handler.

nested_vmx_leave_smm() switches to vmcs02, re-enters guest mode and uses
prepare_vmcs02() to re-establish state required for continuing L2
execution.

Suggested-by: Sean Christopherson <seanjc@google.com>
Fixes: 72e9cbdb4338 ("KVM: nVMX: fix SMI injection in guest mode")
Signed-off-by: Kishen Maloor <kishen.maloor@intel.com>
---
The kvm unit tests and self tests did not flag any errors on my setup. I
would appreciate any comments.
---
 arch/x86/kvm/vmx/nested.c | 76 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/nested.h |  2 ++
 arch/x86/kvm/vmx/vmx.c    | 19 ++++------
 3 files changed, 85 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 643935a0f70a..af90190864dc 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4784,6 +4784,82 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 	nested_vmx_abort(vcpu, VMX_ABORT_LOAD_HOST_MSR_FAIL);
 }
 
+int nested_vmx_leave_smm(struct kvm_vcpu *vcpu)
+{
+	enum vm_entry_failure_code entry_failure_code;
+	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	kvm_service_local_tlb_flush_requests(vcpu);
+
+	vmx_switch_vmcs(vcpu, &vmx->nested.vmcs02);
+
+	prepare_vmcs02_early(vmx, &vmx->vmcs01, vmcs12);
+
+	if (prepare_vmcs02(vcpu, vmcs12, false, &entry_failure_code)) {
+		vmx_switch_vmcs(vcpu, &vmx->vmcs01);
+		nested_vmx_restore_host_state(vcpu);
+		return -EINVAL;
+	}
+
+	enter_guest_mode(vcpu);
+
+	kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
+
+	vmx->nested.preemption_timer_expired = false;
+	if (nested_cpu_has_preemption_timer(vmcs12)) {
+		u64 timer_value = vmx_calc_preemption_timer_value(vcpu);
+
+		vmx_start_preemption_timer(vcpu, timer_value);
+	}
+
+	return 0;
+}
+
+void nested_vmx_enter_smm(struct kvm_vcpu *vcpu)
+{
+	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	enum vm_entry_failure_code ignored;
+
+#ifdef CONFIG_KVM_HYPERV
+	if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu))
+		nested_get_evmcs_page(vcpu);
+#endif
+
+	if (nested_cpu_has_preemption_timer(vmcs12))
+		hrtimer_cancel(&to_vmx(vcpu)->nested.preemption_timer);
+
+	kvm_service_local_tlb_flush_requests(vcpu);
+
+	leave_guest_mode(vcpu);
+
+	sync_vmcs02_to_vmcs12(vcpu, vmcs12);
+	nested_flush_cached_shadow_vmcs12(vcpu, vmcs12);
+
+	vmx->nested.mtf_pending = false;
+	vcpu->arch.nmi_injected = false;
+	kvm_clear_exception_queue(vcpu);
+	kvm_clear_interrupt_queue(vcpu);
+
+	kvm_vcpu_unmap(vcpu, &vmx->nested.apic_access_page_map, false);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
+	vmx->nested.pi_desc = NULL;
+
+	vmx_switch_vmcs(vcpu, &vmx->vmcs01);
+
+	if (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
+		indirect_branch_prediction_barrier();
+
+	nested_ept_uninit_mmu_context(vcpu);
+
+	if (nested_vmx_load_cr3(vcpu, vmcs12->host_cr3, false, true, &ignored))
+		nested_vmx_abort(vcpu, VMX_ABORT_LOAD_HOST_PDPTE_FAIL);
+
+	nested_vmx_transition_tlb_flush(vcpu, vmcs12, false);
+}
+
 /*
  * Emulate an exit from nested guest (L2) to L1, i.e., prepare to run L1
  * and modify vmcs12 to make it see what it would expect to see there if
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index cce4e2aa30fb..1a91849cc780 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -23,11 +23,13 @@ void nested_vmx_hardware_unsetup(void);
 __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *));
 void nested_vmx_set_vmcs_shadowing_bitmap(void);
 void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu);
+int nested_vmx_leave_smm(struct kvm_vcpu *vcpu);
 enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 						     bool from_vmentry);
 bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu);
 void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		       u32 exit_intr_info, unsigned long exit_qualification);
+void nested_vmx_enter_smm(struct kvm_vcpu *vcpu);
 void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu);
 int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b3c83c06f826..e698fb7c08e4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8231,16 +8231,9 @@ int vmx_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	/*
-	 * TODO: Implement custom flows for forcing the vCPU out/in of L2 on
-	 * SMI and RSM.  Using the common VM-Exit + VM-Enter routines is wrong
-	 * SMI and RSM only modify state that is saved and restored via SMRAM.
-	 * E.g. most MSRs are left untouched, but many are modified by VM-Exit
-	 * and VM-Enter, and thus L2's values may be corrupted on SMI+RSM.
-	 */
 	vmx->nested.smm.guest_mode = is_guest_mode(vcpu);
 	if (vmx->nested.smm.guest_mode)
-		nested_vmx_vmexit(vcpu, -1, 0, 0);
+		nested_vmx_enter_smm(vcpu);
 
 	vmx->nested.smm.vmxon = vmx->nested.vmxon;
 	vmx->nested.vmxon = false;
@@ -8259,12 +8252,14 @@ int vmx_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
 	}
 
 	if (vmx->nested.smm.guest_mode) {
-		ret = nested_vmx_enter_non_root_mode(vcpu, false);
-		if (ret)
-			return ret;
-
 		vmx->nested.nested_run_pending = 1;
 		vmx->nested.smm.guest_mode = false;
+
+		ret = nested_vmx_leave_smm(vcpu);
+		if (ret) {
+			vmx->nested.nested_run_pending = 0;
+			return ret;
+		}
 	}
 	return 0;
 }
-- 
2.31.1


