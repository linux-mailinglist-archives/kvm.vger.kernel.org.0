Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDF6183F11
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 03:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgCMCT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 22:19:28 -0400
Received: from mga14.intel.com ([192.55.52.115]:25868 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbgCMCT1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 22:19:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 19:19:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,546,1574150400"; 
   d="scan'208";a="261743874"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 12 Mar 2020 19:19:22 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Liang Kan <kan.liang@linux.intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Like Xu <like.xu@linux.intel.com>,
        linux-kernel@vger.kernel.org, Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v9 09/10] KVM: x86: Expose MSR_IA32_PERF_CAPABILITIES to guest for LBR record format
Date:   Fri, 13 Mar 2020 10:16:15 +0800
Message-Id: <20200313021616.112322-10-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200313021616.112322-1-like.xu@linux.intel.com>
References: <20200313021616.112322-1-like.xu@linux.intel.com>
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

Cc: Luwei Kang <luwei.kang@intel.com>
Co-developed-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            |  3 ++-
 arch/x86/kvm/pmu.h              |  9 +++++++++
 arch/x86/kvm/vmx/pmu_intel.c    | 28 ++++++++++++++++++++++++++++
 4 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b4c1761ca783..d915eedcbe43 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -483,6 +483,7 @@ struct kvm_pmu {
 	u64 global_ctrl_mask;
 	u64 global_ovf_ctrl_mask;
 	u64 reserved_bits;
+	u64 perf_capabilities;
 	u8 version;
 	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
 	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b1c469446b07..55f57d6c3de0 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -446,6 +446,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 	unsigned f_rdtscp = kvm_x86_ops->rdtscp_supported() ? F(RDTSCP) : 0;
 	unsigned f_xsaves = kvm_x86_ops->xsaves_supported() ? F(XSAVES) : 0;
 	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
+	unsigned int f_pdcm = kvm_pmu_get_perf_capabilities() ? F(PDCM) : 0;
 
 	/* cpuid 1.edx */
 	const u32 kvm_cpuid_1_edx_x86_features =
@@ -474,7 +475,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		F(XMM3) | F(PCLMULQDQ) | 0 /* DTES64, MONITOR */ |
 		0 /* DS-CPL, VMX, SMX, EST */ |
 		0 /* TM2 */ | F(SSSE3) | 0 /* CNXT-ID */ | 0 /* Reserved */ |
-		F(FMA) | F(CX16) | 0 /* xTPR Update, PDCM */ |
+		F(FMA) | F(CX16) | 0 /* xTPR Update*/ | f_pdcm |
 		F(PCID) | 0 /* Reserved, DCA */ | F(XMM4_1) |
 		F(XMM4_2) | F(X2APIC) | F(MOVBE) | F(POPCNT) |
 		0 /* Reserved*/ | F(AES) | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX) |
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index d4ef7ec3331d..1cf73f39335d 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -43,6 +43,7 @@ struct kvm_pmu_ops {
 	bool (*lbr_setup)(struct kvm_vcpu *vcpu);
 	void (*lbr_cleanup)(struct kvm_vcpu *vcpu);
 	void (*availability_check)(struct kvm_vcpu *vcpu);
+	u64 (*get_perf_capabilities)(void);
 };
 
 static inline bool event_is_oncpu(struct perf_event *event)
@@ -149,6 +150,14 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
 	return sample_period;
 }
 
+static inline u64 kvm_pmu_get_perf_capabilities(void)
+{
+	if (kvm_x86_ops->pmu_ops->get_perf_capabilities)
+		return kvm_x86_ops->pmu_ops->get_perf_capabilities();
+
+	return 0;
+}
+
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index bbb5f4c63f52..167061ce0434 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -19,6 +19,8 @@
 #include "pmu.h"
 #include "vmx.h"
 
+#define X86_PERF_CAP_MASK_LBR_FMT			0x3f
+
 static struct kvm_event_hw_type_mapping intel_arch_events[] = {
 	/* Index must match CPUID 0x0A.EBX bit vector */
 	[0] = { 0x3c, 0x00, PERF_COUNT_HW_CPU_CYCLES },
@@ -182,6 +184,9 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_IA32_DEBUGCTLMSR:
 		ret = pmu->version > 1;
 		break;
+	case MSR_IA32_PERF_CAPABILITIES:
+		ret = guest_cpuid_has(vcpu, X86_FEATURE_PDCM);
+		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
@@ -342,6 +347,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
 		return 0;
+	case MSR_IA32_PERF_CAPABILITIES:
+		msr_info->data = pmu->perf_capabilities;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
 			u64 val = pmc_read_counter(pmc);
@@ -419,6 +427,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (pmu->lbr_event)
 			__set_bit(KVM_PMU_LBR_IN_USE_IDX, pmu->pmc_in_use);
 		return 0;
+	case MSR_IA32_PERF_CAPABILITIES:
+		return 1; /* RO MSR */
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
 			if (!msr_info->host_initiated)
@@ -448,6 +458,19 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return 1;
 }
 
+static u64 intel_pmu_get_perf_capabilities(void)
+{
+	u64 perf_cap = 0;
+
+	if (boot_cpu_has(X86_FEATURE_PDCM))
+		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
+
+	/* Currently, KVM only support LBR.  */
+	perf_cap &= X86_PERF_CAP_MASK_LBR_FMT;
+
+	return perf_cap;
+}
+
 static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -474,6 +497,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		return;
 
 	perf_get_x86_pmu_capability(&x86_pmu);
+	pmu->perf_capabilities = intel_pmu_get_perf_capabilities();
 
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
 					 x86_pmu.num_counters_gp);
@@ -501,6 +525,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		pmu->global_ovf_ctrl_mask &=
 				~MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI;
 
+	if (!vcpu->kvm->arch.lbr_in_guest)
+		pmu->perf_capabilities &= ~X86_PERF_CAP_MASK_LBR_FMT;
+
 	entry = kvm_find_cpuid_entry(vcpu, 7, 0);
 	if (entry &&
 	    (boot_cpu_has(X86_FEATURE_HLE) || boot_cpu_has(X86_FEATURE_RTM)) &&
@@ -652,4 +679,5 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.lbr_setup = intel_pmu_setup_lbr,
 	.availability_check = intel_pmu_availability_check,
 	.lbr_cleanup = intel_pmu_cleanup_lbr,
+	.get_perf_capabilities = intel_pmu_get_perf_capabilities,
 };
-- 
2.21.1

