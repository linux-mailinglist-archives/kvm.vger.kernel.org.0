Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D241C7FF2
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 04:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgEGCO6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 22:14:58 -0400
Received: from mga07.intel.com ([134.134.136.100]:51519 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgEGCO6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 22:14:58 -0400
IronPort-SDR: 6+o5o9Z8Nei5ikD7cVdrsq+LH3/i3l3edyJZCTHd+gqSOdJbrpmyyYk68JJf3VhnKy4fb029Av
 b6sbRbHwWGrQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 19:14:57 -0700
IronPort-SDR: fw44h69tpA8aEv4BASRoUBgr4ADobJFK+151kyMvE1I+gBX5dTBNNDPw12opxqiLEgankTFDXc
 feNhsAPwH3ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,361,1583222400"; 
   d="scan'208";a="251376347"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga008.fm.intel.com with ESMTP; 06 May 2020 19:14:53 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v2] KVM: x86/pmu: Support full width counting
Date:   Thu,  7 May 2020 10:14:52 +0800
Message-Id: <20200507021452.174646-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.1
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
even though the counter internally is larger (usually 48 bits).

When the new capability is set, use the alternative range which do not
have these restrictions. This lowers the overhead of perf stat slightly
because it has to do less interrupts to accumulate the counter value.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            |  2 +-
 arch/x86/kvm/vmx/capabilities.h | 15 ++++++++++++++
 arch/x86/kvm/vmx/pmu_intel.c    | 35 +++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/vmx.c          |  5 +++++
 arch/x86/kvm/x86.c              |  8 ++++++++
 6 files changed, 61 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 42a2d0d3984a..1c2e3e79490b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -481,6 +481,7 @@ struct kvm_pmu {
 	u64 counter_bitmask[2];
 	u64 global_ctrl_mask;
 	u64 global_ovf_ctrl_mask;
+	u64 perf_capabilities;
 	u64 reserved_bits;
 	u8 version;
 	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 901cd1fdecd9..654ec2718fe4 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -297,7 +297,7 @@ void kvm_set_cpu_caps(void)
 		F(XMM3) | F(PCLMULQDQ) | 0 /* DTES64, MONITOR */ |
 		0 /* DS-CPL, VMX, SMX, EST */ |
 		0 /* TM2 */ | F(SSSE3) | 0 /* CNXT-ID */ | 0 /* Reserved */ |
-		F(FMA) | F(CX16) | 0 /* xTPR Update, PDCM */ |
+		F(FMA) | F(CX16) | 0 /* xTPR Update */ | F(PDCM) |
 		F(PCID) | 0 /* Reserved, DCA */ | F(XMM4_1) |
 		F(XMM4_2) | F(X2APIC) | F(MOVBE) | F(POPCNT) |
 		0 /* Reserved*/ | F(AES) | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX) |
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 8903475f751e..9c4123292656 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -367,4 +367,19 @@ static inline bool vmx_pt_mode_is_host_guest(void)
 	return pt_mode == PT_MODE_HOST_GUEST;
 }
 
+#define PMU_CAP_FW_WRITES	(1ULL << 13)
+
+static inline u64 vmx_get_perf_capabilities(void)
+{
+	u64 perf_cap = 0;
+
+	if (boot_cpu_has(X86_FEATURE_PDCM))
+		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
+
+	/* Currently, KVM only supports Full-Width Writes. */
+	perf_cap &= PMU_CAP_FW_WRITES;
+
+	return perf_cap;
+}
+
 #endif /* __KVM_X86_VMX_CAPS_H */
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 7c857737b438..c15b5b03de38 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -150,6 +150,16 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 	return &counters[array_index_nospec(idx, num_counters)];
 }
 
+static inline bool fw_writes_is_enabled(struct kvm_pmu *pmu)
+{
+	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
+
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
+		return false;
+
+	return pmu->perf_capabilities & PMU_CAP_FW_WRITES;
+}
+
 static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -162,10 +172,15 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
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
+			get_fixed_pmc(pmu, msr) ||
+			(fw_writes_is_enabled(pmu) &&
+				get_gp_pmc(pmu, msr, MSR_IA32_PMC0));
 		break;
 	}
 
@@ -202,8 +217,12 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		*data = pmu->global_ovf_ctrl;
 		return 0;
+	case MSR_IA32_PERF_CAPABILITIES:
+		*data = pmu->perf_capabilities;
+		return 0;
 	default:
-		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
+		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
+			(pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
 			u64 val = pmc_read_counter(pmc);
 			*data = val & pmu->counter_bitmask[KVM_PMC_GP];
 			return 0;
@@ -258,9 +277,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
+	case MSR_IA32_PERF_CAPABILITIES:
+		return 1; /* RO MSR */
 	default:
-		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
-			if (!msr_info->host_initiated)
+		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
+			(pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
+			if (data & ~pmu->counter_bitmask[KVM_PMC_GP])
+				return 1;
+			if (!fw_writes_is_enabled(pmu))
 				data = (s64)(s32)data;
 			pmc->counter += data - pmc_read_counter(pmc);
 			if (pmc->perf_event)
@@ -300,6 +324,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->version = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
+	pmu->perf_capabilities = 0;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry)
@@ -312,6 +337,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		return;
 
 	perf_get_x86_pmu_capability(&x86_pmu);
+	if (guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
+		pmu->perf_capabilities = vmx_get_perf_capabilities();
 
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
 					 x86_pmu.num_counters_gp);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c2c6335a998c..f0c70a76f8fd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1772,6 +1772,11 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 		if (!nested)
 			return 1;
 		return vmx_get_vmx_msr(&vmcs_config.nested, msr->index, &msr->data);
+	case MSR_IA32_PERF_CAPABILITIES:
+		if (!nested)
+			return 1;
+		msr->data = vmx_get_perf_capabilities();
+		return 0;
 	default:
 		return 1;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c5835f9cb9ad..59b6b272ca17 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1220,6 +1220,13 @@ static const u32 msrs_to_save_all[] = {
 	MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
+
+	MSR_IA32_PMC0, MSR_IA32_PMC0 + 1, MSR_IA32_PMC0 + 2,
+	MSR_IA32_PMC0 + 3, MSR_IA32_PMC0 + 4, MSR_IA32_PMC0 + 5,
+	MSR_IA32_PMC0 + 6, MSR_IA32_PMC0 + 7, MSR_IA32_PMC0 + 8,
+	MSR_IA32_PMC0 + 9, MSR_IA32_PMC0 + 10, MSR_IA32_PMC0 + 11,
+	MSR_IA32_PMC0 + 12, MSR_IA32_PMC0 + 13, MSR_IA32_PMC0 + 14,
+	MSR_IA32_PMC0 + 15, MSR_IA32_PMC0 + 16, MSR_IA32_PMC0 + 17,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
@@ -1314,6 +1321,7 @@ static const u32 msr_based_features_all[] = {
 	MSR_F10H_DECFG,
 	MSR_IA32_UCODE_REV,
 	MSR_IA32_ARCH_CAPABILITIES,
+	MSR_IA32_PERF_CAPABILITIES,
 };
 
 static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all)];
-- 
2.21.1

