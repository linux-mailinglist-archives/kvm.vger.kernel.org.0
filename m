Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85251B986A
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 09:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgD0HW4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 03:22:56 -0400
Received: from mga18.intel.com ([134.134.136.126]:21447 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726407AbgD0HW4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 03:22:56 -0400
IronPort-SDR: 8Bdx+mITLVhmosy5c8Omz2S1GbTtMh0YB04ow1/9x63F2YSUQWcx2/f2wzDpypTuzW0mQMcODa
 FMNwLRYaBdPQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 00:22:55 -0700
IronPort-SDR: /n3zHjQ+Pv2v1hw++y3auFQ6d6e26xnf/XjpUBfomwRrThcUCOblFbFkM6jCOmKvP1TnAzg0xo
 +WxG+ihL7QjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,323,1583222400"; 
   d="scan'208";a="458717516"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 27 Apr 2020 00:22:53 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: [RESEND PATCH] KVM: x86/pmu: Support full width counting
Date:   Mon, 27 Apr 2020 15:19:22 +0800
Message-Id: <20200427071922.86257-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jim & Sean,

Do you mind helping review this little feature for vPMU?

The related specification in the Intel SDM is "18.2.6 Full-Width Writes to
Performance Counter Registers" and related kernel commit is 069e0c3c40581.

If there is anything needs to be improved, please let me know. 

Thanks,
Like Xu

----

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
 arch/x86/kvm/vmx/capabilities.h | 15 +++++++++++++++
 arch/x86/kvm/vmx/pmu_intel.c    | 32 ++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/vmx.c          |  2 ++
 arch/x86/kvm/x86.c              |  8 ++++++++
 5 files changed, 54 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7cd68d1d0627..d9c48223f38d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -486,6 +486,7 @@ struct kvm_pmu {
 	u64 counter_bitmask[2];
 	u64 global_ctrl_mask;
 	u64 global_ovf_ctrl_mask;
+	u64 perf_capabilities;
 	u64 reserved_bits;
 	u8 version;
 	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 8903475f751e..f87880aaa63b 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -367,4 +367,19 @@ static inline bool vmx_pt_mode_is_host_guest(void)
 	return pt_mode == PT_MODE_HOST_GUEST;
 }
 
+#define PMU_CAP_FW_WRITES	(1ULL << 13)
+
+static inline u64 vmx_supported_perf_capabilities(void)
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
index 7c857737b438..fde2952216dc 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -150,6 +150,14 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 	return &counters[array_index_nospec(idx, num_counters)];
 }
 
+static inline bool fw_writes_is_enabled(struct kvm_pmu *pmu)
+{
+	if (!guest_cpuid_has(pmu_to_vcpu(pmu), X86_FEATURE_PDCM))
+		return false;
+
+	return pmu->perf_capabilities & PMU_CAP_FW_WRITES;
+}
+
 static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -162,10 +170,15 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
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
 
@@ -202,8 +215,12 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
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
@@ -258,9 +275,13 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
+			if (!msr_info->host_initiated &&
+				!fw_writes_is_enabled(pmu))
 				data = (s64)(s32)data;
 			pmc->counter += data - pmc_read_counter(pmc);
 			if (pmc->perf_event)
@@ -300,6 +321,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->version = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
+	pmu->perf_capabilities = 0;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry)
@@ -312,6 +334,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		return;
 
 	perf_get_x86_pmu_capability(&x86_pmu);
+	if (guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
+		pmu->perf_capabilities = vmx_supported_perf_capabilities();
 
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
 					 x86_pmu.num_counters_gp);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3ab6ca6062ce..24d49a11311b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7222,6 +7222,8 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_check_and_set(X86_FEATURE_INVPCID);
 	if (vmx_pt_mode_is_host_guest())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
+	if (vmx_supported_perf_capabilities())
+		kvm_cpu_cap_check_and_set(X86_FEATURE_PDCM);
 
 	/* PKU is not yet implemented for shadow paging. */
 	if (enable_ept && boot_cpu_has(X86_FEATURE_OSPKE))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 856b6fc2c2ba..25fb16eed884 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1229,6 +1229,14 @@ static const u32 msrs_to_save_all[] = {
 	MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
+
+	MSR_IA32_PERF_CAPABILITIES,
+	MSR_IA32_PMC0, MSR_IA32_PMC0 + 1, MSR_IA32_PMC0 + 2,
+	MSR_IA32_PMC0 + 3, MSR_IA32_PMC0 + 4, MSR_IA32_PMC0 + 5,
+	MSR_IA32_PMC0 + 6, MSR_IA32_PMC0 + 7, MSR_IA32_PMC0 + 8,
+	MSR_IA32_PMC0 + 9, MSR_IA32_PMC0 + 10, MSR_IA32_PMC0 + 11,
+	MSR_IA32_PMC0 + 12, MSR_IA32_PMC0 + 13, MSR_IA32_PMC0 + 14,
+	MSR_IA32_PMC0 + 15, MSR_IA32_PMC0 + 16, MSR_IA32_PMC0 + 17,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
-- 
2.21.1

