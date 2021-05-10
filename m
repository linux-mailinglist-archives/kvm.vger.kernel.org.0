Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB71A377DD6
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbhEJIRm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:17:42 -0400
Received: from mga12.intel.com ([192.55.52.136]:42733 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230328AbhEJIRc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 04:17:32 -0400
IronPort-SDR: WEKYwzbX0clR+4Nz/tWspvCD+qO9a+pHrja7DrUTL5BkBqYN4v75e5Gb06DGLWUKABjFJ1M/Bg
 Kz5jHpwXjwCg==
X-IronPort-AV: E=McAfee;i="6200,9189,9979"; a="178727770"
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="178727770"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 01:16:28 -0700
IronPort-SDR: rO01TNqQ7ZCtch5cHzws/mP+Yx3VD/cMmgkv8dxV7HYiLIrPHt/91Msv8EIELUR0OIO4dxlGK3
 vAYwiy+E2ZWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="408250883"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga002.jf.intel.com with ESMTP; 10 May 2021 01:16:25 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH v4 05/10] KVM: vmx/pmu: Add Arch LBR emulation and its VMCS field
Date:   Mon, 10 May 2021 16:15:29 +0800
Message-Id: <20210510081535.94184-6-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510081535.94184-1-like.xu@linux.intel.com>
References: <20210510081535.94184-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

New VMX controls bits for Arch LBR are added. When bit 21 in vmentry_ctrl
is set, VM entry will write the value from the "Guest IA32_LBR_CTL" guest
state field to IA32_LBR_CTL. When bit 26 in vmexit_ctrl is set, VM exit
will clear IA32_LBR_CTL after the value has been saved to the "Guest
IA32_LBR_CTL" guest state field. The host value would be saved before
vm-entry and restored after vm-exit like the legacy host_debugctlmsr;

To enable guest Arch LBR, KVM should set both the "Load Guest IA32_LBR_CTL"
entry control and the "Clear IA32_LBR_CTL" exit control bits. If these two
conditions cannot be met, KVM will clear the LBR_FMT bits and will not
expose the Arch LBR feature.

If Arch LBR is exposed on KVM, the guest should set both the ARCH_LBR CPUID
and the same LBR_FMT value as the host via MSR_IA32_PERF_CAPABILITIES to
enable guest Arch LBR.

KVM will bypass the host/guest x86 cpu model check and the records msrs can
still be pass-through to guest as usual and work like a model-specific LBR.
KVM is consistent with the host and does not support the LER entry.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/vmx.h      |  2 ++
 arch/x86/kvm/vmx/capabilities.h | 25 +++++++++++++++++--------
 arch/x86/kvm/vmx/pmu_intel.c    | 27 ++++++++++++++++++++++-----
 arch/x86/kvm/vmx/vmx.c          | 32 ++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.h          |  1 +
 5 files changed, 72 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index ea3be961cc8e..d9b1dffc4638 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -95,6 +95,7 @@
 #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
 #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
 #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
+#define VM_EXIT_CLEAR_IA32_LBR_CTL		0x04000000
 
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
@@ -108,6 +109,7 @@
 #define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
 #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
 #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
+#define VM_ENTRY_LOAD_IA32_LBR_CTL		0x00200000
 
 #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
 
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 8dee8a5fbc17..ff2904950bb2 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -378,20 +378,29 @@ static inline bool vmx_pt_mode_is_host_guest(void)
 	return pt_mode == PT_MODE_HOST_GUEST;
 }
 
-static inline u64 vmx_get_perf_capabilities(void)
+static inline bool cpu_has_vmx_arch_lbr(void)
 {
-	u64 perf_cap = 0;
-
-	if (boot_cpu_has(X86_FEATURE_PDCM))
-		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
-
-	perf_cap &= PMU_CAP_LBR_FMT;
+	return (vmcs_config.vmexit_ctrl & VM_EXIT_CLEAR_IA32_LBR_CTL) &&
+		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_LBR_CTL);
+}
 
+static inline u64 vmx_get_perf_capabilities(void)
+{
 	/*
 	 * Since counters are virtualized, KVM would support full
 	 * width counting unconditionally, even if the host lacks it.
 	 */
-	return PMU_CAP_FW_WRITES | perf_cap;
+	u64 perf_cap = PMU_CAP_FW_WRITES;
+	u64 host_perf_cap = 0;
+
+	if (boot_cpu_has(X86_FEATURE_PDCM))
+		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
+
+	perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
+	if (boot_cpu_has(X86_FEATURE_ARCH_LBR) && !cpu_has_vmx_arch_lbr())
+		perf_cap &= ~PMU_CAP_LBR_FMT;
+
+	return perf_cap;
 }
 
 static inline u64 vmx_supported_debugctl(void)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 15490d31b828..9199d3974d57 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -181,12 +181,16 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
 
 bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu)
 {
+	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
+		return guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
+
 	/*
 	 * As a first step, a guest could only enable LBR feature if its
 	 * cpu model is the same as the host because the LBR registers
 	 * would be pass-through to the guest and they're model specific.
 	 */
-	return boot_cpu_data.x86_model == guest_cpuid_model(vcpu);
+	return !boot_cpu_has(X86_FEATURE_ARCH_LBR) &&
+		boot_cpu_data.x86_model == guest_cpuid_model(vcpu);
 }
 
 bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
@@ -204,8 +208,11 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
 	if (!intel_pmu_lbr_is_enabled(vcpu))
 		return ret;
 
-	ret = (index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS) ||
-		(index >= records->from && index < records->from + records->nr) ||
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
+		ret = (index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS);
+
+	if (!ret)
+		ret = (index >= records->from && index < records->from + records->nr) ||
 		(index >= records->to && index < records->to + records->nr);
 
 	if (!ret && records->info)
@@ -696,6 +703,9 @@ static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
 			vmx_set_intercept_for_msr(vcpu, lbr->info + i, MSR_TYPE_RW, set);
 	}
 
+	if (guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
+		return;
+
 	vmx_set_intercept_for_msr(vcpu, MSR_LBR_SELECT, MSR_TYPE_RW, set);
 	vmx_set_intercept_for_msr(vcpu, MSR_LBR_TOS, MSR_TYPE_RW, set);
 }
@@ -739,10 +749,13 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
+	bool lbr_enable = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) ?
+		(vmcs_read64(GUEST_IA32_LBR_CTL) & ARCH_LBR_CTL_LBREN) :
+		(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR);
 
 	if (!lbr_desc->event) {
 		vmx_disable_lbr_msrs_passthrough(vcpu);
-		if (vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR)
+		if (lbr_enable)
 			goto warn;
 		if (test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use))
 			goto warn;
@@ -765,7 +778,11 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
 
 static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 {
-	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
+	bool lbr_enable = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) ?
+		(vmcs_read64(GUEST_IA32_LBR_CTL) & ARCH_LBR_CTL_LBREN) :
+		(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR);
+
+	if (!lbr_enable)
 		intel_pmu_release_guest_lbr_event(vcpu);
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 458d84672104..74f0b302f4a2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -670,6 +670,9 @@ static bool is_valid_passthrough_msr(u32 msr)
 	case MSR_LBR_NHM_TO ... MSR_LBR_NHM_TO + 31:
 	case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
 	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
+	case MSR_ARCH_LBR_FROM_0 ... MSR_ARCH_LBR_FROM_0 + 31:
+	case MSR_ARCH_LBR_TO_0 ... MSR_ARCH_LBR_TO_0 + 31:
+	case MSR_ARCH_LBR_INFO_0 ... MSR_ARCH_LBR_INFO_0 + 31:
 		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
 		return true;
 	}
@@ -1396,6 +1399,26 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 		decache_tsc_multiplier(vmx);
 }
 
+static inline unsigned long get_lbrctlmsr(void)
+{
+	unsigned long lbrctlmsr = 0;
+
+	if (!static_cpu_has(X86_FEATURE_ARCH_LBR))
+		return 0;
+
+	rdmsrl(MSR_ARCH_LBR_CTL, lbrctlmsr);
+
+	return lbrctlmsr;
+}
+
+static inline void update_lbrctlmsr(unsigned long lbrctlmsr)
+{
+	if (!static_cpu_has(X86_FEATURE_ARCH_LBR))
+		return;
+
+	wrmsrl(MSR_ARCH_LBR_CTL, lbrctlmsr);
+}
+
 /*
  * Switches to specified vcpu, until a matching vcpu_put(), but assumes
  * vcpu mutex is already taken.
@@ -1409,6 +1432,7 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	vmx_vcpu_pi_load(vcpu, cpu);
 
 	vmx->host_debugctlmsr = get_debugctlmsr();
+	vmx->host_lbrctlmsr = get_lbrctlmsr();
 }
 
 static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
@@ -2595,7 +2619,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_EXIT_LOAD_IA32_EFER |
 	      VM_EXIT_CLEAR_BNDCFGS |
 	      VM_EXIT_PT_CONCEAL_PIP |
-	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
+	      VM_EXIT_CLEAR_IA32_RTIT_CTL |
+	      VM_EXIT_CLEAR_IA32_LBR_CTL;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
 				&_vmexit_control) < 0)
 		return -EIO;
@@ -2619,7 +2644,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_ENTRY_LOAD_IA32_EFER |
 	      VM_ENTRY_LOAD_BNDCFGS |
 	      VM_ENTRY_PT_CONCEAL_PIP |
-	      VM_ENTRY_LOAD_IA32_RTIT_CTL;
+	      VM_ENTRY_LOAD_IA32_RTIT_CTL |
+	      VM_ENTRY_LOAD_IA32_LBR_CTL;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
 				&_vmentry_control) < 0)
 		return -EIO;
@@ -6828,6 +6854,8 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	/* MSR_IA32_DEBUGCTLMSR is zeroed on vmexit. Restore it if needed */
 	if (vmx->host_debugctlmsr)
 		update_debugctlmsr(vmx->host_debugctlmsr);
+	if (vmx->host_lbrctlmsr)
+		update_lbrctlmsr(vmx->host_lbrctlmsr);
 
 #ifndef CONFIG_X86_64
 	/*
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index cc362e2d3eaa..69e243fea23d 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -328,6 +328,7 @@ struct vcpu_vmx {
 	u64 current_tsc_ratio;
 
 	unsigned long host_debugctlmsr;
+	unsigned long host_lbrctlmsr;
 
 	/*
 	 * Only bits masked by msr_ia32_feature_control_valid_bits can be set in
-- 
2.31.1

