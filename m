Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084F123E985
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 10:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgHGIrK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 04:47:10 -0400
Received: from mga06.intel.com ([134.134.136.31]:65145 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728088AbgHGIrD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 04:47:03 -0400
IronPort-SDR: 69whCAa6IyEaCcYEPfPaAQ+Fvmy5gfcSM9T6g61p7DsbjLiiUJcQETsOCmhkyri6FlflHV6Nob
 91SozWc2Rfuw==
X-IronPort-AV: E=McAfee;i="6000,8403,9705"; a="214565755"
X-IronPort-AV: E=Sophos;i="5.75,445,1589266800"; 
   d="scan'208";a="214565755"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2020 01:47:01 -0700
IronPort-SDR: NMWduveskULa4Jj0BSdDvlgojNhV1Pt7nv1o3YBtgSQSqaVb1gFMF4oD5xkh5Uqky9py+fW0nj
 I5Und0QdZdig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,445,1589266800"; 
   d="scan'208";a="307317202"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga002.jf.intel.com with ESMTP; 07 Aug 2020 01:46:59 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC 7/7] KVM: VMX: Enable PKS for nested VM
Date:   Fri,  7 Aug 2020 16:48:41 +0800
Message-Id: <20200807084841.7112-8-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200807084841.7112-1-chenyi.qiang@intel.com>
References: <20200807084841.7112-1-chenyi.qiang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PKS MSR passes through guest directly. Configure the MSR to match the
L0/L1 settings so that nested VM runs PKS properly.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 32 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmcs12.c |  2 ++
 arch/x86/kvm/vmx/vmcs12.h |  6 +++++-
 arch/x86/kvm/vmx/vmx.c    | 10 ++++++++++
 arch/x86/kvm/vmx/vmx.h    |  1 +
 5 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index df2c2e733549..1f9823d21ecd 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -647,6 +647,12 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
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
@@ -2427,6 +2433,10 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
 		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
 			vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
+
+		if (vmx->nested.nested_run_pending &&
+		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS))
+			vmcs_write64(GUEST_IA32_PKRS, vmcs12->guest_ia32_pkrs);
 	}
 
 	if (nested_cpu_has_xsaves(vmcs12))
@@ -2509,6 +2519,11 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
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
@@ -2849,6 +2864,10 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 					   vmcs12->host_ia32_perf_global_ctrl)))
 		return -EINVAL;
 
+	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PKRS) &&
+	    CC(!kvm_pkrs_valid(vmcs12->host_ia32_pkrs)))
+		return -EINVAL;
+
 #ifdef CONFIG_X86_64
 	ia32e = !!(vcpu->arch.efer & EFER_LMA);
 #else
@@ -2998,6 +3017,10 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	if (nested_check_guest_non_reg_state(vmcs12))
 		return -EINVAL;
 
+	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS) &&
+	    CC(!kvm_pkrs_valid(vmcs12->guest_ia32_pkrs)))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -3271,6 +3294,9 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	if (kvm_mpx_supported() &&
 		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
 		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
+	if (kvm_cpu_cap_has(X86_FEATURE_PKS) &&
+	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS))
+		vmx->nested.vmcs01_guest_pkrs = vmcs_read64(GUEST_IA32_PKRS);
 
 	/*
 	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
@@ -3865,6 +3891,7 @@ static bool is_vmcs12_ext_field(unsigned long field)
 	case GUEST_IDTR_BASE:
 	case GUEST_PENDING_DBG_EXCEPTIONS:
 	case GUEST_BNDCFGS:
+	case GUEST_IA32_PKRS:
 		return true;
 	default:
 		break;
@@ -3916,6 +3943,8 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
 		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
 	if (kvm_mpx_supported())
 		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
+	if (kvm_cpu_cap_has(X86_FEATURE_PKS))
+		vmcs12->guest_ia32_pkrs = vmcs_read64(GUEST_IA32_PKRS);
 
 	vmx->nested.need_sync_vmcs02_to_vmcs12_rare = false;
 }
@@ -4151,6 +4180,9 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 		WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
 					 vmcs12->host_ia32_perf_global_ctrl));
 
+	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PKRS)
+		vmcs_write64(GUEST_IA32_PKRS, vmcs12->host_ia32_pkrs);
+
 	/* Set L1 segment info according to Intel SDM
 	    27.5.2 Loading Host Segment and Descriptor-Table Registers */
 	seg = (struct kvm_segment) {
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
index 5cdf4d3848fb..3c3fb554c3fc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7178,6 +7178,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 	cr4_fixed1_update(X86_CR4_PKE,        ecx, feature_bit(PKU));
 	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
 	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
+	cr4_fixed1_update(X86_CR4_PKS,        ecx, feature_bit(PKS));
 
 #undef cr4_fixed1_update
 }
@@ -7197,6 +7198,15 @@ static void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
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
index 639798e4a6ca..2819d3e030b9 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -176,6 +176,7 @@ struct nested_vmx {
 	/* to migrate it to L2 if VM_ENTRY_LOAD_DEBUG_CONTROLS is off */
 	u64 vmcs01_debugctl;
 	u64 vmcs01_guest_bndcfgs;
+	u64 vmcs01_guest_pkrs;
 
 	/* to migrate it to L1 if L2 writes to L1's CR8 directly */
 	int l1_tpr_threshold;
-- 
2.17.1

