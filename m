Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27853E8E1A
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 12:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237130AbhHKKIL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 06:08:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:49617 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237062AbhHKKHx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 06:07:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10072"; a="215083953"
X-IronPort-AV: E=Sophos;i="5.84,311,1620716400"; 
   d="scan'208";a="215083953"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 03:07:29 -0700
X-IronPort-AV: E=Sophos;i="5.84,311,1620716400"; 
   d="scan'208";a="484785752"
Received: from chenyi-pc.sh.intel.com ([10.239.159.88])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 03:07:26 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 7/7] KVM: VMX: Enable PKS for nested VM
Date:   Wed, 11 Aug 2021 18:11:26 +0800
Message-Id: <20210811101126.8973-8-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210811101126.8973-1-chenyi.qiang@intel.com>
References: <20210811101126.8973-1-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PKS MSR passes through guest directly. Configure the MSR to match the
L0/L1 settings so that nested VM runs PKS properly.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 41 +++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmcs12.c |  2 ++
 arch/x86/kvm/vmx/vmcs12.h |  4 ++++
 arch/x86/kvm/vmx/vmx.c    |  1 +
 arch/x86/kvm/vmx/vmx.h    |  2 ++
 5 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1a52134b0c42..b551e6ec7db5 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -251,6 +251,10 @@ static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
 	dest->ds_sel = src->ds_sel;
 	dest->es_sel = src->es_sel;
 #endif
+	if (unlikely(src->pkrs != dest->pkrs)) {
+		vmcs_write64(HOST_IA32_PKRS, src->pkrs);
+		dest->pkrs = src->pkrs;
+	}
 }
 
 static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
@@ -660,6 +664,12 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 					MSR_IA32_PRED_CMD,
 					MSR_TYPE_W);
 
+	if (!msr_write_intercepted_l01(vcpu, MSR_IA32_PKRS))
+		nested_vmx_disable_intercept_for_msr(
+					msr_bitmap_l1, msr_bitmap_l0,
+					MSR_IA32_PKRS,
+					MSR_TYPE_R | MSR_TYPE_W);
+
 	kvm_vcpu_unmap(vcpu, &to_vmx(vcpu)->nested.msr_bitmap_map, false);
 
 	return true;
@@ -2394,6 +2404,10 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
 		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
 			vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
+
+		if (vmx->nested.nested_run_pending &&
+		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS))
+			vmcs_write64(GUEST_IA32_PKRS, vmcs12->guest_ia32_pkrs);
 	}
 
 	if (nested_cpu_has_xsaves(vmcs12))
@@ -2482,6 +2496,11 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
 	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
 		vmcs_write64(GUEST_BNDCFGS, vmx->nested.vmcs01_guest_bndcfgs);
+	if (kvm_cpu_cap_has(X86_FEATURE_PKS) &&
+	    (!vmx->nested.nested_run_pending ||
+	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS)))
+		vmcs_write64(GUEST_IA32_PKRS, vmx->nested.vmcs01_guest_pkrs);
+
 	vmx_set_rflags(vcpu, vmcs12->guest_rflags);
 
 	/* EXCEPTION_BITMAP and CR0_GUEST_HOST_MASK should basically be the
@@ -2840,6 +2859,10 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 					   vmcs12->host_ia32_perf_global_ctrl)))
 		return -EINVAL;
 
+	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PKRS) &&
+	    CC(!kvm_pkrs_valid(vmcs12->host_ia32_pkrs)))
+		return -EINVAL;
+
 #ifdef CONFIG_X86_64
 	ia32e = !!(vcpu->arch.efer & EFER_LMA);
 #else
@@ -2990,6 +3013,10 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	if (nested_check_guest_non_reg_state(vmcs12))
 		return -EINVAL;
 
+	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS) &&
+	    CC(!kvm_pkrs_valid(vmcs12->guest_ia32_pkrs)))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -3325,6 +3352,9 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	if (kvm_mpx_supported() &&
 		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
 		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
+	if (kvm_cpu_cap_has(X86_FEATURE_PKS) &&
+	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS))
+		vmx->nested.vmcs01_guest_pkrs = vmcs_read64(GUEST_IA32_PKRS);
 
 	/*
 	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
@@ -3964,6 +3994,7 @@ static bool is_vmcs12_ext_field(unsigned long field)
 	case GUEST_IDTR_BASE:
 	case GUEST_PENDING_DBG_EXCEPTIONS:
 	case GUEST_BNDCFGS:
+	case GUEST_IA32_PKRS:
 		return true;
 	default:
 		break;
@@ -4015,6 +4046,8 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
 		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
 	if (kvm_mpx_supported())
 		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
+	if (guest_cpuid_has(vcpu, X86_FEATURE_PKS))
+		vmcs12->guest_ia32_pkrs = vmcs_read64(GUEST_IA32_PKRS);
 
 	vmx->nested.need_sync_vmcs02_to_vmcs12_rare = false;
 }
@@ -4252,6 +4285,9 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 		WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
 					 vmcs12->host_ia32_perf_global_ctrl));
 
+	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PKRS)
+		vmcs_write64(GUEST_IA32_PKRS, vmcs12->host_ia32_pkrs);
+
 	/* Set L1 segment info according to Intel SDM
 	    27.5.2 Loading Host Segment and Descriptor-Table Registers */
 	seg = (struct kvm_segment) {
@@ -6466,7 +6502,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
 #endif
 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
-		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
+		VM_EXIT_LOAD_IA32_PKRS;
 	msrs->exit_ctls_high |=
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
@@ -6486,7 +6523,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		VM_ENTRY_IA32E_MODE |
 #endif
 		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
-		VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL | VM_ENTRY_LOAD_IA32_PKRS;
 	msrs->entry_ctls_high |=
 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER);
 
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index d9f5d7c56ae3..cf088dfa69c6 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -63,9 +63,11 @@ const unsigned short vmcs_field_to_offset_table[] = {
 	FIELD64(GUEST_PDPTR2, guest_pdptr2),
 	FIELD64(GUEST_PDPTR3, guest_pdptr3),
 	FIELD64(GUEST_BNDCFGS, guest_bndcfgs),
+	FIELD64(GUEST_IA32_PKRS, guest_ia32_pkrs),
 	FIELD64(HOST_IA32_PAT, host_ia32_pat),
 	FIELD64(HOST_IA32_EFER, host_ia32_efer),
 	FIELD64(HOST_IA32_PERF_GLOBAL_CTRL, host_ia32_perf_global_ctrl),
+	FIELD64(HOST_IA32_PKRS, host_ia32_pkrs),
 	FIELD(PIN_BASED_VM_EXEC_CONTROL, pin_based_vm_exec_control),
 	FIELD(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control),
 	FIELD(EXCEPTION_BITMAP, exception_bitmap),
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 5e0e1b39f495..2cf201f19155 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -185,6 +185,8 @@ struct __packed vmcs12 {
 	u16 host_gs_selector;
 	u16 host_tr_selector;
 	u16 guest_pml_index;
+	u64 host_ia32_pkrs;
+	u64 guest_ia32_pkrs;
 };
 
 /*
@@ -359,6 +361,8 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(host_gs_selector, 992);
 	CHECK_OFFSET(host_tr_selector, 994);
 	CHECK_OFFSET(guest_pml_index, 996);
+	CHECK_OFFSET(host_ia32_pkrs, 998);
+	CHECK_OFFSET(guest_ia32_pkrs, 1006);
 }
 
 extern const unsigned short vmcs_field_to_offset_table[];
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 71f2aefd6454..a910d9b423eb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7112,6 +7112,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 	cr4_fixed1_update(X86_CR4_PKE,        ecx, feature_bit(PKU));
 	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
 	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
+	cr4_fixed1_update(X86_CR4_PKS,        ecx, feature_bit(PKS));
 
 #undef cr4_fixed1_update
 }
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 858d9a959c72..fff314dc8356 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -203,6 +203,8 @@ struct nested_vmx {
 	u64 vmcs01_debugctl;
 	u64 vmcs01_guest_bndcfgs;
 
+	u64 vmcs01_guest_pkrs;
+
 	/* to migrate it to L1 if L2 writes to L1's CR8 directly */
 	int l1_tpr_threshold;
 
-- 
2.17.1

