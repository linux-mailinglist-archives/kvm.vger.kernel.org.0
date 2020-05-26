Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB0B1CA61B
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 10:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgEHIc3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 04:32:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:5577 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbgEHIc3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 04:32:29 -0400
IronPort-SDR: +oJ4+65JHV1Vq7QARSz2SCltQcOl9NCXNVmLBw9GpqxH1MxDAHln8XQhHjDL/Ryanb6MwgN7c3
 Ukp1K04RZpag==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 01:32:27 -0700
IronPort-SDR: Qr93mbw7sD4NFF4KyDDh79AGWmK7UbL+Qcn2E8aCIkCtt1Aag5pbO+RTirJ3SJR7oQwyml3tA4
 xPiK+8R3GkJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,366,1583222400"; 
   d="scan'208";a="305365397"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by FMSMGA003.fm.intel.com with ESMTP; 08 May 2020 01:32:25 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v3] KVM: x86/pmu: Support full width counting
Date:   Fri,  8 May 2020 16:32:17 +0800
Message-Id: <20200508083218.120559-1-like.xu@linux.intel.com>
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
 arch/x86/kvm/vmx/capabilities.h | 11 +++++++++
 arch/x86/kvm/vmx/pmu_intel.c    | 42 +++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/vmx.c          |  3 +++
 arch/x86/kvm/x86.c              |  1 +
 6 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 35a915787559..8c3ae83f63d9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -599,6 +599,7 @@ struct kvm_vcpu_arch {
 	u64 ia32_xss;
 	u64 microcode_version;
 	u64 arch_capabilities;
+	u64 perf_capabilities;
 
 	/*
 	 * Paging state of the vcpu
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 35845704cf57..411ce1b58341 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -294,7 +294,7 @@ void kvm_set_cpu_caps(void)
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
index 7c857737b438..008c204306ea 100644
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
@@ -150,6 +152,14 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
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
+			(fw_writes_is_enabled(vcpu) &&
+				get_gp_pmc(pmu, msr, MSR_IA32_PMC0));
 		break;
 	}
 
@@ -202,8 +217,12 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		*data = pmu->global_ovf_ctrl;
 		return 0;
+	case MSR_IA32_PERF_CAPABILITIES:
+		*data = vcpu->arch.perf_capabilities;
+		return 0;
 	default:
-		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
+		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
+			(pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
 			u64 val = pmc_read_counter(pmc);
 			*data = val & pmu->counter_bitmask[KVM_PMC_GP];
 			return 0;
@@ -258,9 +277,21 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
+	case MSR_IA32_PERF_CAPABILITIES:
+		if (msr_info->host_initiated &&
+			!(data & ~vmx_get_perf_capabilities())) {
+			vcpu->arch.perf_capabilities = data;
+			return 0;
+		}
+		return 1;
 	default:
-		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
-			if (!msr_info->host_initiated)
+		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
+			(pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
+			if ((msr & MSR_PMC_FULL_WIDTH_BIT) &&
+				(data & ~pmu->counter_bitmask[KVM_PMC_GP]))
+				return 1;
+			if (!msr_info->host_initiated &&
+				!(msr & MSR_PMC_FULL_WIDTH_BIT))
 				data = (s64)(s32)data;
 			pmc->counter += data - pmc_read_counter(pmc);
 			if (pmc->perf_event)
@@ -300,6 +331,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->version = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
+	vcpu->arch.perf_capabilities = 0;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry)
@@ -312,6 +344,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		return;
 
 	perf_get_x86_pmu_capability(&x86_pmu);
+	if (guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
+		vcpu->arch.perf_capabilities = vmx_get_perf_capabilities();
 
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
 					 x86_pmu.num_counters_gp);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bc5e5cf1d4cc..ee94d94e855a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1789,6 +1789,9 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
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
index 7e46027f405a..8d94d0b74fbb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1323,6 +1323,7 @@ static const u32 msr_based_features_all[] = {
 	MSR_F10H_DECFG,
 	MSR_IA32_UCODE_REV,
 	MSR_IA32_ARCH_CAPABILITIES,
+	MSR_IA32_PERF_CAPABILITIES,
 };
 
 static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all)];
-- 
2.21.1

