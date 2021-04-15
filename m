Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932BC360047
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 05:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbhDODVY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 23:21:24 -0400
Received: from mga07.intel.com ([134.134.136.100]:2259 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229878AbhDODVV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 23:21:21 -0400
IronPort-SDR: mWckecmkdH8E79H2DZGnAtYjzdVXGHdsC6A+Z2RCK+YXY2MuqiKQ+13VqJ4pRag/NCI+7+hN01
 4sKRiADLz0PA==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="258742992"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="258742992"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 20:20:50 -0700
IronPort-SDR: 5LXq84e/+byLd4sxNA6rXbFp4Kn61+1TjR5kUnNBBCNaqrpadsdQyAlG9sKqtX7y9Dbai1/8qq
 NpsM6wLpSCFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="425014005"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 14 Apr 2021 20:20:46 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     peterz@infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     andi@firstfloor.org, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v5 07/16] KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS
Date:   Thu, 15 Apr 2021 11:20:07 +0800
Message-Id: <20210415032016.166201-8-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210415032016.166201-1-like.xu@linux.intel.com>
References: <20210415032016.166201-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If IA32_PERF_CAPABILITIES.PEBS_BASELINE [bit 14] is set, the
IA32_PEBS_ENABLE MSR exists and all architecturally enumerated fixed
and general purpose counters have corresponding bits in IA32_PEBS_ENABLE
that enable generation of PEBS records. The general-purpose counter bits
start at bit IA32_PEBS_ENABLE[0], and the fixed counter bits start at
bit IA32_PEBS_ENABLE[32].

When guest PEBS is enabled, the IA32_PEBS_ENABLE MSR will be
added to the perf_guest_switch_msr() and atomically switched during
the VMX transitions just like CORE_PERF_GLOBAL_CTRL MSR.

Based on whether the platform supports x86_pmu.pebs_vmx, it has also
refactored the way to add more msrs to art[] in intel_guest_get_msrs()
for extensibility.

Originally-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Co-developed-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/intel/core.c     | 61 +++++++++++++++++++++-----------
 arch/x86/include/asm/kvm_host.h  |  3 ++
 arch/x86/include/asm/msr-index.h |  6 ++++
 arch/x86/kvm/vmx/pmu_intel.c     | 31 ++++++++++++++++
 4 files changed, 80 insertions(+), 21 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 2f8ac53fe594..4e5ed12cb52d 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3838,31 +3838,50 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
+	u64 pebs_mask = (x86_pmu.flags & PMU_FL_PEBS_ALL) ?
+		cpuc->pebs_enabled : (cpuc->pebs_enabled & PEBS_COUNTER_MASK);
+
+	*nr = 0;
+	arr[(*nr)++] = (struct perf_guest_switch_msr){
+		.msr = MSR_CORE_PERF_GLOBAL_CTRL,
+		.host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask,
+		.guest = x86_pmu.intel_ctrl &
+			(~cpuc->intel_ctrl_host_mask | ~pebs_mask),
+	};
 
-	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
-	arr[0].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
-	arr[0].guest = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_host_mask;
-	if (x86_pmu.flags & PMU_FL_PEBS_ALL)
-		arr[0].guest &= ~cpuc->pebs_enabled;
-	else
-		arr[0].guest &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
-	*nr = 1;
+	if (!x86_pmu.pebs)
+		return arr;
 
-	if (x86_pmu.pebs && x86_pmu.pebs_no_isolation) {
-		/*
-		 * If PMU counter has PEBS enabled it is not enough to
-		 * disable counter on a guest entry since PEBS memory
-		 * write can overshoot guest entry and corrupt guest
-		 * memory. Disabling PEBS solves the problem.
-		 *
-		 * Don't do this if the CPU already enforces it.
-		 */
-		arr[1].msr = MSR_IA32_PEBS_ENABLE;
-		arr[1].host = cpuc->pebs_enabled;
-		arr[1].guest = 0;
-		*nr = 2;
+	/*
+	 * If PMU counter has PEBS enabled it is not enough to
+	 * disable counter on a guest entry since PEBS memory
+	 * write can overshoot guest entry and corrupt guest
+	 * memory. Disabling PEBS solves the problem.
+	 *
+	 * Don't do this if the CPU already enforces it.
+	 */
+	if (x86_pmu.pebs_no_isolation) {
+		arr[(*nr)++] = (struct perf_guest_switch_msr){
+			.msr = MSR_IA32_PEBS_ENABLE,
+			.host = cpuc->pebs_enabled,
+			.guest = 0,
+		};
+		return arr;
 	}
 
+	if (!x86_pmu.pebs_vmx)
+		return arr;
+
+	arr[*nr] = (struct perf_guest_switch_msr){
+		.msr = MSR_IA32_PEBS_ENABLE,
+		.host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask,
+		.guest = pebs_mask & ~cpuc->intel_ctrl_host_mask,
+	};
+
+	/* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
+	arr[0].guest |= arr[*nr].guest;
+
+	++(*nr);
 	return arr;
 }
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5b9692397350..a48abcad3329 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -460,6 +460,9 @@ struct kvm_pmu {
 	DECLARE_BITMAP(all_valid_pmc_idx, X86_PMC_IDX_MAX);
 	DECLARE_BITMAP(pmc_in_use, X86_PMC_IDX_MAX);
 
+	u64 pebs_enable;
+	u64 pebs_enable_mask;
+
 	/*
 	 * The gate to release perf_events not marked in
 	 * pmc_in_use only once in a vcpu time slice.
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 546d6ecf0a35..2e997c8c79bf 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -186,6 +186,12 @@
 #define MSR_IA32_DS_AREA		0x00000600
 #define MSR_IA32_PERF_CAPABILITIES	0x00000345
 #define MSR_PEBS_LD_LAT_THRESHOLD	0x000003f6
+#define PERF_CAP_PEBS_TRAP             BIT_ULL(6)
+#define PERF_CAP_ARCH_REG              BIT_ULL(7)
+#define PERF_CAP_PEBS_FORMAT           0xf00
+#define PERF_CAP_PEBS_BASELINE         BIT_ULL(14)
+#define PERF_CAP_PEBS_MASK	(PERF_CAP_PEBS_TRAP | PERF_CAP_ARCH_REG | \
+				 PERF_CAP_PEBS_FORMAT | PERF_CAP_PEBS_BASELINE)
 
 #define MSR_IA32_RTIT_CTL		0x00000570
 #define RTIT_CTL_TRACEEN		BIT(0)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index ac7fe714e6c1..9938b485c31c 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -220,6 +220,9 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		ret = pmu->version > 1;
 		break;
+	case MSR_IA32_PEBS_ENABLE:
+		ret = vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT;
+		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
@@ -367,6 +370,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		msr_info->data = pmu->global_ovf_ctrl;
 		return 0;
+	case MSR_IA32_PEBS_ENABLE:
+		msr_info->data = pmu->pebs_enable;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -427,6 +433,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
+	case MSR_IA32_PEBS_ENABLE:
+		if (pmu->pebs_enable == data)
+			return 0;
+		if (!(data & pmu->pebs_enable_mask)) {
+			pmu->pebs_enable = data;
+			return 0;
+		}
+		break;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -479,6 +493,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->version = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
 	pmu->fixed_ctr_ctrl_mask = ~0ull;
+	pmu->pebs_enable_mask = ~0ull;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry)
@@ -545,6 +560,22 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 
 	if (lbr_desc->records.nr)
 		bitmap_set(pmu->all_valid_pmc_idx, INTEL_PMC_IDX_FIXED_VLBR, 1);
+
+	if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT) {
+		if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_BASELINE) {
+			pmu->pebs_enable_mask = ~pmu->global_ctrl;
+			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
+			for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+				pmu->fixed_ctr_ctrl_mask &=
+					~(1ULL << (INTEL_PMC_IDX_FIXED + i * 4));
+			}
+		} else {
+			pmu->pebs_enable_mask =
+				~((1ull << pmu->nr_arch_gp_counters) - 1);
+		}
+	} else {
+		vcpu->arch.perf_capabilities &= ~PERF_CAP_PEBS_MASK;
+	}
 }
 
 static void intel_pmu_init(struct kvm_vcpu *vcpu)
-- 
2.30.2

