Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36681B5718
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 10:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgDWISL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 04:18:11 -0400
Received: from mga18.intel.com ([134.134.136.126]:57581 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726995AbgDWISJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 04:18:09 -0400
IronPort-SDR: FJThBqhzBBa1rDHizR7/ZuBvU8BnbxC5N57QSFFdIrGO8G6wEQeh72M5EwUHIAUWVnpf8Xzih/
 xou8sbiOsJhA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 01:18:07 -0700
IronPort-SDR: 3AQcnxQdW6oA1jrhobz0RzfWLjVaxYv5vSx1sy8pCDYg6DGyfk4v9pC5aeyuH1X0YVRMzPAD/N
 hkBa7QfWL61Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,306,1583222400"; 
   d="scan'208";a="255910147"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 23 Apr 2020 01:18:04 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei.w.wang@intel.com,
        ak@linux.intel.com, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v10 10/11] KVM: x86: Expose MSR_IA32_PERF_CAPABILITIES for LBR record format
Date:   Thu, 23 Apr 2020 16:14:11 +0800
Message-Id: <20200423081412.164863-11-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200423081412.164863-1-like.xu@linux.intel.com>
References: <20200423081412.164863-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The MSR_IA32_PERF_CAPABILITIES is a read only MSR that enumerates the
existence of performance monitoring features. Bits [0, 5] of it tells
about the LBR format of the branch record addresses stored in the LBR
stack. Expose those bits to the guest when the guest LBR is enabled.

Co-developed-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/capabilities.h | 15 +++++++++++++++
 arch/x86/kvm/vmx/pmu_intel.c    | 13 +++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  2 ++
 4 files changed, 31 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f73c9b789bff..137097981180 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -487,6 +487,7 @@ struct kvm_pmu {
 	u64 global_ctrl_mask;
 	u64 global_ovf_ctrl_mask;
 	u64 reserved_bits;
+	u64 perf_capabilities;
 	u8 version;
 	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
 	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 8903475f751e..be61cd5bce0c 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -367,4 +367,19 @@ static inline bool vmx_pt_mode_is_host_guest(void)
 	return pt_mode == PT_MODE_HOST_GUEST;
 }
 
+#define PERF_CAP_LBR_FMT			0x3f
+
+static inline u64 vmx_supported_perf_capabilities(void)
+{
+	u64 perf_cap = 0;
+
+	if (boot_cpu_has(X86_FEATURE_PDCM))
+		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
+
+	/* Currently, KVM only supports LBR.  */
+	perf_cap &= PERF_CAP_LBR_FMT;
+
+	return perf_cap;
+}
+
 #endif /* __KVM_X86_VMX_CAPS_H */
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 37088bbcde7f..c64c53bdc77d 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -182,6 +182,9 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_IA32_DEBUGCTLMSR:
 		ret = pmu->version > 1;
 		break;
+	case MSR_IA32_PERF_CAPABILITIES:
+		ret = guest_cpuid_has(vcpu, X86_FEATURE_PDCM);
+		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
@@ -346,6 +349,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
 		return 0;
+	case MSR_IA32_PERF_CAPABILITIES:
+		msr_info->data = pmu->perf_capabilities;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
 			u64 val = pmc_read_counter(pmc);
@@ -414,6 +420,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			intel_pmu_create_lbr_event(vcpu);
 		__set_bit(KVM_PMU_LBR_IN_USE_IDX, pmu->pmc_in_use);
 		return 0;
+	case MSR_IA32_PERF_CAPABILITIES:
+		return 1; /* RO MSR */
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
 			if (!msr_info->host_initiated)
@@ -458,6 +466,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->version = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
 	vcpu->kvm->arch.lbr_in_guest = false;
+	pmu->perf_capabilities = 0;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry)
@@ -470,6 +479,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		return;
 
 	perf_get_x86_pmu_capability(&x86_pmu);
+	pmu->perf_capabilities = vmx_supported_perf_capabilities();
 
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
 					 x86_pmu.num_counters_gp);
@@ -497,6 +507,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		pmu->global_ovf_ctrl_mask &=
 				~MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI;
 
+	if (!vcpu->kvm->arch.lbr_in_guest)
+		pmu->perf_capabilities &= ~PERF_CAP_LBR_FMT;
+
 	entry = kvm_find_cpuid_entry(vcpu, 7, 0);
 	if (entry &&
 	    (boot_cpu_has(X86_FEATURE_HLE) || boot_cpu_has(X86_FEATURE_RTM)) &&
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 31c294b2d941..ae2cb7967018 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7201,6 +7201,8 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_check_and_set(X86_FEATURE_INVPCID);
 	if (vmx_pt_mode_is_host_guest())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
+	if (vmx_supported_perf_capabilities())
+		kvm_cpu_cap_check_and_set(X86_FEATURE_PDCM);
 
 	/* PKU is not yet implemented for shadow paging. */
 	if (enable_ept && boot_cpu_has(X86_FEATURE_OSPKE))
-- 
2.21.1

