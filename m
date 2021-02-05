Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1303106D1
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 09:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbhBEIfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 03:35:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:19417 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229684AbhBEIfO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 03:35:14 -0500
IronPort-SDR: aZOah/ODkNBF6XMuhVxB/d1sjgLO1m7vx/AuDY6QIWWPVNaDasAKTpICr0G+5J3mzCMZDzDmgd
 a4Si/iKNJOAQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="181550714"
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; 
   d="scan'208";a="181550714"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 00:34:13 -0800
IronPort-SDR: DVfKAsixtZyXnDgonpvrV8SyOEEhK6EXDWUYfbZvShxzEeYkj2irjUg7Ucv+RzS/A/TrE4EAvh
 Gz/rndCZbBig==
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; 
   d="scan'208";a="393761956"
Received: from chenyi-pc.sh.intel.com ([10.239.159.24])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 00:34:11 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/5] KVM: VMX: Enable PKS for nested VM
Date:   Fri,  5 Feb 2021 16:37:06 +0800
Message-Id: <20210205083706.14146-6-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210205083706.14146-1-chenyi.qiang@intel.com>
References: <20210205083706.14146-1-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PKS MSR passes through guest directly. Configure the MSR to match the
L0/L1 settings so that nested VM runs PKS properly.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 37 +++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmcs12.c |  2 ++
 arch/x86/kvm/vmx/vmcs12.h |  6 +++++-
 arch/x86/kvm/vmx/vmx.c    | 10 ++++++++++
 arch/x86/kvm/vmx/vmx.h    |  1 +
 5 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2266d98ace6f..a0b0f6fc7808 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -653,6 +653,12 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
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
@@ -2439,6 +2445,10 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
 		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
 			vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
+
+		if (vmx->nested.nested_run_pending &&
+		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS))
+			vmcs_write64(GUEST_IA32_PKRS, vmcs12->guest_ia32_pkrs);
 	}
 
 	if (nested_cpu_has_xsaves(vmcs12))
@@ -2527,6 +2537,11 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
 	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
 		vmcs_write64(GUEST_BNDCFGS, vmx->nested.vmcs01_guest_bndcfgs);
+
+	if (kvm_cpu_cap_has(X86_FEATURE_PKS) &&
+	    (!vmx->nested.nested_run_pending ||
+	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS)))
+		vmcs_write64(GUEST_IA32_PKRS, vmx->nested.vmcs01_guest_pkrs);
 	vmx_set_rflags(vcpu, vmcs12->guest_rflags);
 
 	/* EXCEPTION_BITMAP and CR0_GUEST_HOST_MASK should basically be the
@@ -2867,6 +2882,10 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 					   vmcs12->host_ia32_perf_global_ctrl)))
 		return -EINVAL;
 
+	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PKRS) &&
+	    CC(!kvm_pkrs_valid(vmcs12->host_ia32_pkrs)))
+		return -EINVAL;
+
 #ifdef CONFIG_X86_64
 	ia32e = !!(vcpu->arch.efer & EFER_LMA);
 #else
@@ -3016,6 +3035,10 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	if (nested_check_guest_non_reg_state(vmcs12))
 		return -EINVAL;
 
+	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS) &&
+	    CC(!kvm_pkrs_valid(vmcs12->guest_ia32_pkrs)))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -3326,6 +3349,9 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	if (kvm_mpx_supported() &&
 		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
 		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
+	if (kvm_cpu_cap_has(X86_FEATURE_PKS) &&
+	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS))
+		vmx->nested.vmcs01_guest_pkrs = vmcs_read64(GUEST_IA32_PKRS);
 
 	/*
 	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
@@ -3929,6 +3955,7 @@ static bool is_vmcs12_ext_field(unsigned long field)
 	case GUEST_IDTR_BASE:
 	case GUEST_PENDING_DBG_EXCEPTIONS:
 	case GUEST_BNDCFGS:
+	case GUEST_IA32_PKRS:
 		return true;
 	default:
 		break;
@@ -3980,6 +4007,8 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
 		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
 	if (kvm_mpx_supported())
 		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
+	if (guest_cpuid_has(vcpu, X86_FEATURE_PKS))
+		vmcs12->guest_ia32_pkrs = vmcs_read64(GUEST_IA32_PKRS);
 
 	vmx->nested.need_sync_vmcs02_to_vmcs12_rare = false;
 }
@@ -4215,6 +4244,9 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 		WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
 					 vmcs12->host_ia32_perf_global_ctrl));
 
+	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PKRS)
+		vmcs_write64(GUEST_IA32_PKRS, vmcs12->host_ia32_pkrs);
+
 	/* Set L1 segment info according to Intel SDM
 	    27.5.2 Loading Host Segment and Descriptor-Table Registers */
 	seg = (struct kvm_segment) {
@@ -6330,7 +6362,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
 #endif
 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
-		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
+		VM_EXIT_LOAD_IA32_PKRS;
 	msrs->exit_ctls_high |=
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
@@ -6350,7 +6383,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		VM_ENTRY_IA32E_MODE |
 #endif
 		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
-		VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL | VM_ENTRY_LOAD_IA32_PKRS;
 	msrs->entry_ctls_high |=
 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER);
 
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index c8e51c004f78..df7b2143b807 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -61,9 +61,11 @@ const unsigned short vmcs_field_to_offset_table[] = {
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
index 80232daf00ff..009b4c317375 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -69,7 +69,9 @@ struct __packed vmcs12 {
 	u64 vm_function_control;
 	u64 eptp_list_address;
 	u64 pml_address;
-	u64 padding64[3]; /* room for future expansion */
+	u64 guest_ia32_pkrs;
+	u64 host_ia32_pkrs;
+	u64 padding64[1]; /* room for future expansion */
 	/*
 	 * To allow migration of L1 (complete with its L2 guests) between
 	 * machines of different natural widths (32 or 64 bit), we cannot have
@@ -256,6 +258,8 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(vm_function_control, 296);
 	CHECK_OFFSET(eptp_list_address, 304);
 	CHECK_OFFSET(pml_address, 312);
+	CHECK_OFFSET(guest_ia32_pkrs, 320);
+	CHECK_OFFSET(host_ia32_pkrs, 328);
 	CHECK_OFFSET(cr0_guest_host_mask, 344);
 	CHECK_OFFSET(cr4_guest_host_mask, 352);
 	CHECK_OFFSET(cr0_read_shadow, 360);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a3d95492e2b7..f3e8e1ba0003 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7198,6 +7198,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 	cr4_fixed1_update(X86_CR4_PKE,        ecx, feature_bit(PKU));
 	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
 	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
+	cr4_fixed1_update(X86_CR4_PKS,        ecx, feature_bit(PKS));
 
 #undef cr4_fixed1_update
 }
@@ -7217,6 +7218,15 @@ static void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
 			vmx->nested.msrs.exit_ctls_high &= ~VM_EXIT_CLEAR_BNDCFGS;
 		}
 	}
+
+	if (kvm_cpu_cap_has(X86_FEATURE_PKS) &&
+	    guest_cpuid_has(vcpu, X86_FEATURE_PKS)) {
+		vmx->nested.msrs.entry_ctls_high |= VM_ENTRY_LOAD_IA32_PKRS;
+		vmx->nested.msrs.exit_ctls_high |= VM_EXIT_LOAD_IA32_PKRS;
+	} else {
+		vmx->nested.msrs.entry_ctls_high &= ~VM_ENTRY_LOAD_IA32_PKRS;
+		vmx->nested.msrs.exit_ctls_high &= ~VM_EXIT_LOAD_IA32_PKRS;
+	}
 }
 
 static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index f6f66e5c6510..9d3670e45636 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -155,6 +155,7 @@ struct nested_vmx {
 	/* to migrate it to L2 if VM_ENTRY_LOAD_DEBUG_CONTROLS is off */
 	u64 vmcs01_debugctl;
 	u64 vmcs01_guest_bndcfgs;
+	u64 vmcs01_guest_pkrs;
 
 	/* to migrate it to L1 if L2 writes to L1's CR8 directly */
 	int l1_tpr_threshold;
-- 
2.17.1

