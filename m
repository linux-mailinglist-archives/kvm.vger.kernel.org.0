Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7498D1A23A7
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 15:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgDHN43 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 09:56:29 -0400
Received: from mga12.intel.com ([192.55.52.136]:62331 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbgDHN43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 09:56:29 -0400
IronPort-SDR: 2dPekf3pj2q0oRwW18OJ941CZjHc/lmCDGCKs7YGDjveQteaQb3enmRC4UeC33S/M0NjG4LOHQ
 Y2TSekEZoe+A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2020 06:56:29 -0700
IronPort-SDR: 6T27AKxi9WqlYaZn+NUIyFxt0s1YdajtB3TlU333E1f8p+8NwQD2HREi3vlEwTCoIYInkl0giA
 FseFDgKw02+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,358,1580803200"; 
   d="scan'208";a="244043287"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga008.fm.intel.com with ESMTP; 08 Apr 2020 06:56:26 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH] KVM: x86/pmu: Support full width counting
Date:   Wed,  8 Apr 2020 21:53:25 +0800
Message-Id: <20200408135325.3160-1-like.xu@linux.intel.com>
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

The perf driver queries CPUID to get the counter width, and sign extends
the counter values as needed. The traditional MSRs always limit to 32bit,
even though the counter internally is larger (usually 48 bits).

When the new capability is set, use the alternative range which do not
have these restrictions. This lowers the overhead of perf stat slightly
because it has to do less interrupts to accumulate the counter value.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/capabilities.h | 15 +++++++++++++
 arch/x86/kvm/vmx/pmu_intel.c    | 38 +++++++++++++++++++++++++++------
 arch/x86/kvm/vmx/vmx.c          |  2 ++
 4 files changed, 50 insertions(+), 6 deletions(-)

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
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 8903475f751e..3624568633bd 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -367,4 +367,19 @@ static inline bool vmx_pt_mode_is_host_guest(void)
 	return pt_mode == PT_MODE_HOST_GUEST;
 }
 
+#define PMU_CAP_FW_WRITE	(1ULL << 13)
+
+static inline u64 vmx_supported_perf_capabilities(void)
+{
+	u64 perf_cap = 0;
+
+	if (boot_cpu_has(X86_FEATURE_PDCM))
+		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
+
+	/* Currently, KVM only support Full-Width Writes. */
+	perf_cap &= PMU_CAP_FW_WRITE;
+
+	return perf_cap;
+}
+
 #endif /* __KVM_X86_VMX_CAPS_H */
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 7c857737b438..99563d1ec854 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -150,6 +150,12 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 	return &counters[array_index_nospec(idx, num_counters)];
 }
 
+static inline bool full_width_writes_is_enabled(struct kvm_pmu *pmu)
+{
+	return (vmx_supported_perf_capabilities() & PMU_CAP_FW_WRITE) &&
+		(pmu->perf_capabilities & PMU_CAP_FW_WRITE);
+}
+
 static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -162,10 +168,15 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
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
+			(get_gp_pmc(pmu, msr, MSR_IA32_PMC0) &&
+				full_width_writes_is_enabled(pmu));
 		break;
 	}
 
@@ -202,8 +213,12 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		*data = pmu->global_ovf_ctrl;
 		return 0;
+	case MSR_IA32_PERF_CAPABILITIES:
+		*data = pmu->perf_capabilities;
+		return 0;
 	default:
-		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
+		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))
+			|| (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
 			u64 val = pmc_read_counter(pmc);
 			*data = val & pmu->counter_bitmask[KVM_PMC_GP];
 			return 0;
@@ -258,9 +273,13 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
+	case MSR_IA32_PERF_CAPABILITIES:
+		return 1; /* RO MSR */
 	default:
-		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
-			if (!msr_info->host_initiated)
+		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))
+			|| (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
+			if (!msr_info->host_initiated &&
+				!full_width_writes_is_enabled(pmu))
 				data = (s64)(s32)data;
 			pmc->counter += data - pmc_read_counter(pmc);
 			if (pmc->perf_event)
@@ -303,15 +322,18 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry)
-		return;
+		goto end;
 	eax.full = entry->eax;
 	edx.full = entry->edx;
 
 	pmu->version = eax.split.version_id;
 	if (!pmu->version)
-		return;
+		goto end;
 
 	perf_get_x86_pmu_capability(&x86_pmu);
+	pmu->perf_capabilities = vmx_supported_perf_capabilities();
+	if (!pmu->perf_capabilities)
+		guest_cpuid_clear(vcpu, X86_FEATURE_PDCM);
 
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
 					 x86_pmu.num_counters_gp);
@@ -351,6 +373,10 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
 
 	nested_vmx_pmu_entry_exit_ctls_update(vcpu);
+	return;
+
+end:
+	guest_cpuid_clear(vcpu, X86_FEATURE_PDCM);
 }
 
 static void intel_pmu_init(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4f844257a72d..abc0f15a4de5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7112,6 +7112,8 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_check_and_set(X86_FEATURE_INVPCID);
 	if (vmx_pt_mode_is_host_guest())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
+	if (vmx_supported_perf_capabilities())
+		kvm_cpu_cap_check_and_set(X86_FEATURE_PDCM);
 
 	/* PKU is not yet implemented for shadow paging. */
 	if (enable_ept && boot_cpu_has(X86_FEATURE_OSPKE))
-- 
2.21.1

