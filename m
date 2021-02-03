Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E4730DC39
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 15:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbhBCOG5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 09:06:57 -0500
Received: from mga06.intel.com ([134.134.136.31]:50299 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231744AbhBCOGx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 09:06:53 -0500
IronPort-SDR: G5kQ/gmL4HTCR2UXZtZi7lQ59lg8CPo5JpyJlXubUlp2ppWLYGaROHmHjkdsFvniUoCMkd5hvm
 y0c/71sb+hBw==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="242555128"
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="242555128"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 06:03:52 -0800
IronPort-SDR: nhRAm2WtplWkRNHz3Zzg//E0csLQq1E/wlBZ1APikljqDXpcwMh8c4xb1DC1kGIgc+SLt09wsP
 WrpbRlekBngw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="371490691"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga008.fm.intel.com with ESMTP; 03 Feb 2021 06:03:50 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] KVM: vmx/pmu: Add Arch LBR emulation and its VMCS field
Date:   Wed,  3 Feb 2021 21:57:13 +0800
Message-Id: <20210203135714.318356-4-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210203135714.318356-1-like.xu@linux.intel.com>
References: <20210203135714.318356-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When set bit 21 in vmentry_ctrl, VM entry will write the value from the
"Guest IA32_LBR_CTL" guest state field to IA32_LBR_CTL. When set bit 26
in vmexit_ctrl, VM exit will clear IA32_LBR_CTL after the value has been
saved to the "Guest IA32_LBR_CTL" guest state field.

To enable guest Arch LBR, KVM should set both the "Load Guest IA32_LBR_CTL"
entry control and the "Clear IA32_LBR_CTL" exit control. If these two
conditions cannot be met, the vmx_get_perf_capabilities() will clear
the LBR_FMT bits.

If Arch LBR is exposed on KVM, the guest could set X86_FEATURE_ARCH_LBR
to enable guest LBR, which is equivalent to the legacy LBR_FMT setting.
The Arch LBR feature could bypass the host/guest x86_model check and
the records msrs can still be pass-through to guest as usual and work
like the legacy LBR.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/vmx.h      |  2 ++
 arch/x86/kvm/vmx/capabilities.h | 25 +++++++++++++++++--------
 arch/x86/kvm/vmx/pmu_intel.c    | 17 ++++++++++++++---
 arch/x86/kvm/vmx/vmx.c          |  6 ++++--
 4 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index c099c3d17612..755179c0a5da 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -95,6 +95,7 @@
 #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
 #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
 #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
+#define VM_EXIT_CLEAR_IA32_LBR_CTL		0x04000000
 #define VM_EXIT_LOAD_CET_STATE                  0x10000000
 
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
@@ -110,6 +111,7 @@
 #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
 #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
 #define VM_ENTRY_LOAD_CET_STATE                 0x00100000
+#define VM_ENTRY_LOAD_IA32_LBR_CTL		0x00200000
 
 #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
 
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 473c55c824b1..d84af64314fc 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -383,20 +383,29 @@ static inline bool vmx_pt_mode_is_host_guest(void)
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
index a00d89c93eb7..7f20a8e75306 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -176,12 +176,17 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
 
 bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu)
 {
+	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) !=
+	    guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
+		return false;
+
 	/*
 	 * As a first step, a guest could only enable LBR feature if its
 	 * cpu model is the same as the host because the LBR registers
 	 * would be pass-through to the guest and they're model specific.
 	 */
-	return boot_cpu_data.x86_model == guest_cpuid_model(vcpu);
+	return !guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) &&
+		boot_cpu_data.x86_model == guest_cpuid_model(vcpu);
 }
 
 bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
@@ -199,8 +204,11 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
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
@@ -689,6 +697,9 @@ static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
 			vmx_set_intercept_for_msr(vcpu, lbr->info + i, MSR_TYPE_RW, set);
 	}
 
+	if (guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
+		return;
+
 	vmx_set_intercept_for_msr(vcpu, MSR_LBR_SELECT, MSR_TYPE_RW, set);
 	vmx_set_intercept_for_msr(vcpu, MSR_LBR_TOS, MSR_TYPE_RW, set);
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index edecf2961924..9ddf0a14d75c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2632,7 +2632,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_EXIT_CLEAR_BNDCFGS |
 	      VM_EXIT_PT_CONCEAL_PIP |
 	      VM_EXIT_CLEAR_IA32_RTIT_CTL |
-	      VM_EXIT_LOAD_CET_STATE;
+	      VM_EXIT_LOAD_CET_STATE |
+	      VM_EXIT_CLEAR_IA32_LBR_CTL;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
 				&_vmexit_control) < 0)
 		return -EIO;
@@ -2657,7 +2658,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_ENTRY_LOAD_BNDCFGS |
 	      VM_ENTRY_PT_CONCEAL_PIP |
 	      VM_ENTRY_LOAD_IA32_RTIT_CTL |
-	      VM_ENTRY_LOAD_CET_STATE;
+	      VM_ENTRY_LOAD_CET_STATE |
+	      VM_ENTRY_LOAD_IA32_LBR_CTL;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
 				&_vmentry_control) < 0)
 		return -EIO;
-- 
2.29.2

