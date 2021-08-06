Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E37A3E2B99
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 15:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344236AbhHFNj1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 09:39:27 -0400
Received: from mga03.intel.com ([134.134.136.65]:4257 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344231AbhHFNjU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 09:39:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10068"; a="214398011"
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="214398011"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 06:39:03 -0700
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="523463517"
Received: from vmm_a4_icx.sh.intel.com (HELO localhost.localdomain) ([10.239.53.245])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 06:38:55 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     peterz@infradead.org, pbonzini@redhat.com
Cc:     bp@alien8.de, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, boris.ostrvsky@oracle.com,
        Like Xu <like.xu@linux.intel.com>,
        Luwei Kang <luwei.kang@intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V10 08/18] KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS
Date:   Fri,  6 Aug 2021 21:37:52 +0800
Message-Id: <20210806133802.3528-9-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210806133802.3528-1-lingshan.zhu@intel.com>
References: <20210806133802.3528-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

If IA32_PERF_CAPABILITIES.PEBS_BASELINE [bit 14] is set, the
IA32_PEBS_ENABLE MSR exists and all architecturally enumerated fixed
and general-purpose counters have corresponding bits in IA32_PEBS_ENABLE
that enable generation of PEBS records. The general-purpose counter bits
start at bit IA32_PEBS_ENABLE[0], and the fixed counter bits start at
bit IA32_PEBS_ENABLE[32].

When guest PEBS is enabled, the IA32_PEBS_ENABLE MSR will be
added to the perf_guest_switch_msr() and atomically switched during
the VMX transitions just like CORE_PERF_GLOBAL_CTRL MSR.

Based on whether the platform supports x86_pmu.pebs_vmx, it has also
refactored the way to add more msrs to arr[] in intel_guest_get_msrs()
for extensibility.

Originally-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Co-developed-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/events/intel/core.c     | 75 ++++++++++++++++++++++++--------
 arch/x86/include/asm/kvm_host.h  |  3 ++
 arch/x86/include/asm/msr-index.h |  6 +++
 arch/x86/kvm/vmx/pmu_intel.c     | 31 +++++++++++++
 4 files changed, 97 insertions(+), 18 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 552a623dc886..d196b32617c5 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3896,33 +3896,72 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	return 0;
 }
 
+/*
+ * Currently, the only caller of this function is the atomic_switch_perf_msrs().
+ * The host perf conext helps to prepare the values of the real hardware for
+ * a set of msrs that need to be switched atomically in a vmx transaction.
+ *
+ * For example, the pseudocode needed to add a new msr should look like:
+ *
+ * arr[(*nr)++] = (struct perf_guest_switch_msr){
+ *	.msr = the hardware msr address,
+ *	.host = the value the hardware has when it doesn't run a guest,
+ *	.guest = the value the hardware has when it runs a guest,
+ * };
+ *
+ * These values have nothing to do with the emulated values the guest sees
+ * when it uses {RD,WR}MSR, which should be handled by the KVM context,
+ * specifically in the intel_pmu_{get,set}_msr().
+ */
 static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
 	u64 intel_ctrl = hybrid(cpuc->pmu, intel_ctrl);
+	u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
+	int global_ctrl, pebs_enable;
+
+	*nr = 0;
+	global_ctrl = (*nr)++;
+	arr[global_ctrl] = (struct perf_guest_switch_msr){
+		.msr = MSR_CORE_PERF_GLOBAL_CTRL,
+		.host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask,
+		.guest = intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),
+	};
 
-	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
-	arr[0].host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
-	arr[0].guest = intel_ctrl & ~cpuc->intel_ctrl_host_mask;
-	arr[0].guest &= ~(cpuc->pebs_enabled & x86_pmu.pebs_capable);
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
+	pebs_enable = (*nr)++;
+
+	arr[pebs_enable] = (struct perf_guest_switch_msr){
+		.msr = MSR_IA32_PEBS_ENABLE,
+		.host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask,
+		.guest = pebs_mask & ~cpuc->intel_ctrl_host_mask,
+	};
+
+	/* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
+	arr[0].guest |= arr[*nr].guest;
+
 	return arr;
 }
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 172fabbcc11a..425e872ddf4f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -505,6 +505,9 @@ struct kvm_pmu {
 	DECLARE_BITMAP(all_valid_pmc_idx, X86_PMC_IDX_MAX);
 	DECLARE_BITMAP(pmc_in_use, X86_PMC_IDX_MAX);
 
+	u64 pebs_enable;
+	u64 pebs_enable_mask;
+
 	/*
 	 * The gate to release perf_events not marked in
 	 * pmc_in_use only once in a vcpu time slice.
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index a7c413432b33..986b285b97f7 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -189,6 +189,12 @@
 #define PERF_CAP_PT_IDX			16
 
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
2.27.0

