Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A8E1E7755
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 09:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgE2Ho3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 03:44:29 -0400
Received: from mga03.intel.com ([134.134.136.65]:51936 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbgE2Ho1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 03:44:27 -0400
IronPort-SDR: hvTpKnSu74pybBIp02AnPKKOmjqxfqhLHWdKDHH+Ly37CUYNsvjuzsfgLNcIxaKuPDbL7yS4Qo
 EwCSKDpDGo3A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 00:44:27 -0700
IronPort-SDR: O8WseacqUy0Gp1w9+qH+MC0ZHhxoCfuwxus1BxVqNhkuy2tf0fBxNiazjqn35PlAIBQ/s5/s5/
 sbwzGkHTmAAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="302754543"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga002.fm.intel.com with ESMTP; 29 May 2020 00:44:25 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH RESEND v4 2/2] KVM: x86/pmu: Support full width counting
Date:   Fri, 29 May 2020 15:43:45 +0800
Message-Id: <20200529074347.124619-3-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200529074347.124619-1-like.xu@linux.intel.com>
References: <20200529074347.124619-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel CPUs have a new alternative MSR range (starting from MSR_IA32_PMC0)
for GP counters that allows writing the full counter width. Enable this
range from a new capability bit (IA32_PERF_CAPABILITIES.FW_WRITE[bit 13]).

The guest would query CPUID to get the counter width, and sign extends
the counter values as needed. The traditional MSRs always limit to 32bit,
even though the counter internally is larger (48 or 57 bits).

When the new capability is set, use the alternative range which do not
have these restrictions. This lowers the overhead of perf stat slightly
because it has to do less interrupts to accumulate the counter value.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            |  2 +-
 arch/x86/kvm/vmx/capabilities.h | 11 +++++++
 arch/x86/kvm/vmx/pmu_intel.c    | 52 ++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.c          |  3 ++
 arch/x86/kvm/x86.c              |  2 ++
 6 files changed, 66 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3485f8454088..452e1bfea4c1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -600,6 +600,7 @@ struct kvm_vcpu_arch {
 	u64 ia32_xss;
 	u64 microcode_version;
 	u64 arch_capabilities;
+	u64 perf_capabilities;
 
 	/*
 	 * Paging state of the vcpu
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index cd708b0b460a..9d781308b872 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -296,7 +296,7 @@ void kvm_set_cpu_caps(void)
 		F(XMM3) | F(PCLMULQDQ) | 0 /* DTES64, MONITOR */ |
 		0 /* DS-CPL, VMX, SMX, EST */ |
 		0 /* TM2 */ | F(SSSE3) | 0 /* CNXT-ID */ | 0 /* Reserved */ |
-		F(FMA) | F(CX16) | 0 /* xTPR Update, PDCM */ |
+		F(FMA) | F(CX16) | 0 /* xTPR Update */ | F(PDCM) |
 		F(PCID) | 0 /* Reserved, DCA */ | F(XMM4_1) |
 		F(XMM4_2) | F(X2APIC) | F(MOVBE) | F(POPCNT) |
 		0 /* Reserved*/ | F(AES) | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX) |
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 8903475f751e..4bbd8b448d22 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -18,6 +18,8 @@ extern int __read_mostly pt_mode;
 #define PT_MODE_SYSTEM		0
 #define PT_MODE_HOST_GUEST	1
 
+#define PMU_CAP_FW_WRITES	(1ULL << 13)
+
 struct nested_vmx_msrs {
 	/*
 	 * We only store the "true" versions of the VMX capability MSRs. We
@@ -367,4 +369,13 @@ static inline bool vmx_pt_mode_is_host_guest(void)
 	return pt_mode == PT_MODE_HOST_GUEST;
 }
 
+static inline u64 vmx_get_perf_capabilities(void)
+{
+	/*
+	 * Since counters are virtualized, KVM would support full
+	 * width counting unconditionally, even if the host lacks it.
+	 */
+	return PMU_CAP_FW_WRITES;
+}
+
 #endif /* __KVM_X86_VMX_CAPS_H */
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index e1a303fefc16..d33d890b605f 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -18,6 +18,8 @@
 #include "nested.h"
 #include "pmu.h"
 
+#define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
+
 static struct kvm_event_hw_type_mapping intel_arch_events[] = {
 	/* Index must match CPUID 0x0A.EBX bit vector */
 	[0] = { 0x3c, 0x00, PERF_COUNT_HW_CPU_CYCLES },
@@ -150,6 +152,22 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 	return &counters[array_index_nospec(idx, num_counters)];
 }
 
+static inline bool fw_writes_is_enabled(struct kvm_vcpu *vcpu)
+{
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
+		return false;
+
+	return vcpu->arch.perf_capabilities & PMU_CAP_FW_WRITES;
+}
+
+static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
+{
+	if (!fw_writes_is_enabled(pmu_to_vcpu(pmu)))
+		return NULL;
+
+	return get_gp_pmc(pmu, msr, MSR_IA32_PMC0);
+}
+
 static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -162,10 +180,13 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		ret = pmu->version > 1;
 		break;
+	case MSR_IA32_PERF_CAPABILITIES:
+		ret = guest_cpuid_has(vcpu, X86_FEATURE_PDCM);
+		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
-			get_fixed_pmc(pmu, msr);
+			get_fixed_pmc(pmu, msr) || get_fw_gp_pmc(pmu, msr);
 		break;
 	}
 
@@ -203,8 +224,15 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		msr_info->data = pmu->global_ovf_ctrl;
 		return 0;
+	case MSR_IA32_PERF_CAPABILITIES:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
+			return 1;
+		msr_info->data = vcpu->arch.perf_capabilities;
+		return 0;
 	default:
-		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
+		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
+		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
 			u64 val = pmc_read_counter(pmc);
 			msr_info->data =
 				val & pmu->counter_bitmask[KVM_PMC_GP];
@@ -261,9 +289,22 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
+	case MSR_IA32_PERF_CAPABILITIES:
+		if (!msr_info->host_initiated)
+			return 1;
+		if (guest_cpuid_has(vcpu, X86_FEATURE_PDCM) ?
+			(data & ~vmx_get_perf_capabilities()) : data)
+			return 1;
+		vcpu->arch.perf_capabilities = data;
+		return 0;
 	default:
-		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
-			if (!msr_info->host_initiated)
+		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
+		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
+			if ((msr & MSR_PMC_FULL_WIDTH_BIT) &&
+			    (data & ~pmu->counter_bitmask[KVM_PMC_GP]))
+				return 1;
+			if (!msr_info->host_initiated &&
+			    !(msr & MSR_PMC_FULL_WIDTH_BIT))
 				data = (s64)(s32)data;
 			pmc->counter += data - pmc_read_counter(pmc);
 			if (pmc->perf_event)
@@ -303,6 +344,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->version = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
+	vcpu->arch.perf_capabilities = 0;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry)
@@ -315,6 +357,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		return;
 
 	perf_get_x86_pmu_capability(&x86_pmu);
+	if (guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
+		vcpu->arch.perf_capabilities = vmx_get_perf_capabilities();
 
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
 					 x86_pmu.num_counters_gp);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7b55dc6230a9..d5b7c3b55ae4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1788,6 +1788,9 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 		if (!nested)
 			return 1;
 		return vmx_get_vmx_msr(&vmcs_config.nested, msr->index, &msr->data);
+	case MSR_IA32_PERF_CAPABILITIES:
+		msr->data = vmx_get_perf_capabilities();
+		return 0;
 	default:
 		return 1;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9f77776f1479..791d5955d1b8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1253,6 +1253,7 @@ static const u32 emulated_msrs_all[] = {
 	MSR_IA32_TSC_ADJUST,
 	MSR_IA32_TSCDEADLINE,
 	MSR_IA32_ARCH_CAPABILITIES,
+	MSR_IA32_PERF_CAPABILITIES,
 	MSR_IA32_MISC_ENABLE,
 	MSR_IA32_MCG_STATUS,
 	MSR_IA32_MCG_CTL,
@@ -1319,6 +1320,7 @@ static const u32 msr_based_features_all[] = {
 	MSR_F10H_DECFG,
 	MSR_IA32_UCODE_REV,
 	MSR_IA32_ARCH_CAPABILITIES,
+	MSR_IA32_PERF_CAPABILITIES,
 };
 
 static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all)];
-- 
2.21.3

