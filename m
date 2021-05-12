Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B00337B84C
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 10:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbhELIrD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 04:47:03 -0400
Received: from mga17.intel.com ([192.55.52.151]:10038 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230474AbhELIqt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 04:46:49 -0400
IronPort-SDR: YBQNBrL1YuzOKWMbN+8vmpDAIiqZErUYYe7tbXrIl6OkmcUsH4O5uHNx6ToZ0NKP4XDgREmrIh
 8BGfrsu7i2uA==
X-IronPort-AV: E=McAfee;i="6200,9189,9981"; a="179918841"
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="179918841"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2021 01:45:41 -0700
IronPort-SDR: wTubRvc+/IylDD15mu9NMkzaZAmidfPu7BSkZSIL4D6/9EDYH4Uio7mADAl6UUweIBeaxvUQBf
 FOwMf7AoTy9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="392636389"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga006.jf.intel.com with ESMTP; 12 May 2021 01:45:37 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, peterz@infradead.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        eranian@google.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>,
        Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v3 3/5] KVM: x86/pmu: Add counter reload MSR emulation for all counters
Date:   Wed, 12 May 2021 16:44:44 +0800
Message-Id: <20210512084446.342526-4-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512084446.342526-1-like.xu@linux.intel.com>
References: <20210512084446.342526-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Intel PEBS-via-PT feature introduces a new output mechanism that
directs PEBS records to the PT buffer, and after each PEBS record is
generated, it automatically reloads the counter values from a new set
of "reload values" MSRs (based on  MSR_RELOAD_FIXED_CTRx and
MSR_RELOAD_PMCx), instead of the counter reload values stored in
the DS management area.

If perf_capabilities supports this capability, PEBS records will be
directed to the PT buffer when the relevant bit in pebs_enable is set.

Co-developed-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/perf_event.h     |  5 -----
 arch/x86/include/asm/kvm_host.h  |  1 +
 arch/x86/include/asm/msr-index.h |  6 ++++++
 arch/x86/kvm/pmu.h               |  8 ++++++++
 arch/x86/kvm/vmx/pmu_intel.c     | 18 ++++++++++++++++++
 5 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 685a1a4e9438..4171f1328732 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -115,11 +115,6 @@ struct amd_nb {
 };
 
 #define PEBS_COUNTER_MASK	((1ULL << MAX_PEBS_EVENTS) - 1)
-#define PEBS_PMI_AFTER_EACH_RECORD BIT_ULL(60)
-#define PEBS_OUTPUT_OFFSET	61
-#define PEBS_OUTPUT_MASK	(3ull << PEBS_OUTPUT_OFFSET)
-#define PEBS_OUTPUT_PT		(1ull << PEBS_OUTPUT_OFFSET)
-#define PEBS_VIA_PT_MASK	(PEBS_OUTPUT_PT | PEBS_PMI_AFTER_EACH_RECORD)
 
 /*
  * Flags PEBS can handle without an PMI.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 15bff609fd57..29d2d8027014 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -443,6 +443,7 @@ struct kvm_pmc {
 	u8 idx;
 	u64 counter;
 	u64 eventsel;
+	u64 reload_counter;
 	struct perf_event *perf_event;
 	struct kvm_vcpu *vcpu;
 	/*
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 1ab3f280f3a9..364c40ecd963 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -187,12 +187,18 @@
 #define MSR_IA32_PERF_CAPABILITIES	0x00000345
 #define PERF_CAP_METRICS_IDX		15
 #define PERF_CAP_PT_IDX			16
+#define PEBS_PMI_AFTER_EACH_RECORD	BIT_ULL(60)
+#define PEBS_OUTPUT_OFFSET		61
+#define PEBS_OUTPUT_MASK		(3ull << PEBS_OUTPUT_OFFSET)
+#define PEBS_OUTPUT_PT			(1ull << PEBS_OUTPUT_OFFSET)
+#define PEBS_VIA_PT_MASK		(PEBS_OUTPUT_PT | PEBS_PMI_AFTER_EACH_RECORD)
 
 #define MSR_PEBS_LD_LAT_THRESHOLD	0x000003f6
 #define PERF_CAP_PEBS_TRAP             BIT_ULL(6)
 #define PERF_CAP_ARCH_REG              BIT_ULL(7)
 #define PERF_CAP_PEBS_FORMAT           0xf00
 #define PERF_CAP_PEBS_BASELINE         BIT_ULL(14)
+#define PERF_CAP_PEBS_OUTPUT_PT        BIT_ULL(16)
 #define PERF_CAP_PEBS_MASK	(PERF_CAP_PEBS_TRAP | PERF_CAP_ARCH_REG | \
 				 PERF_CAP_PEBS_FORMAT | PERF_CAP_PEBS_BASELINE)
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 6720881b8370..f9895a7a59bc 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -115,6 +115,10 @@ static inline bool kvm_valid_perf_global_ctrl(struct kvm_pmu *pmu,
 static inline struct kvm_pmc *get_gp_pmc(struct kvm_pmu *pmu, u32 msr,
 					 u32 base)
 {
+	if ((msr == MSR_RELOAD_PMC0 || msr == MSR_RELOAD_FIXED_CTR0) &&
+	    !(pmu_to_vcpu(pmu)->arch.perf_capabilities & PERF_CAP_PEBS_OUTPUT_PT))
+		return NULL;
+
 	if (msr >= base && msr < base + pmu->nr_arch_gp_counters) {
 		u32 index = array_index_nospec(msr - base,
 					       pmu->nr_arch_gp_counters);
@@ -129,6 +133,10 @@ static inline struct kvm_pmc *get_gp_pmc(struct kvm_pmu *pmu, u32 msr,
 static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu,
 					    u32 msr, u32 base)
 {
+	if ((msr == MSR_RELOAD_PMC0 || msr == MSR_RELOAD_FIXED_CTR0) &&
+	    !(pmu_to_vcpu(pmu)->arch.perf_capabilities & PERF_CAP_PEBS_OUTPUT_PT))
+		return NULL;
+
 	if (msr >= base && msr < base + pmu->nr_arch_fixed_counters) {
 		u32 index = array_index_nospec(msr - base,
 					       pmu->nr_arch_fixed_counters);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index c10cb3008bf1..e5c12c958cdb 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -226,6 +226,8 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
 			get_fixed_pmc(pmu, msr, MSR_CORE_PERF_FIXED_CTR0) ||
 			get_fw_gp_pmc(pmu, msr) ||
+			get_gp_pmc(pmu, msr, MSR_RELOAD_PMC0) ||
+			get_fixed_pmc(pmu, msr, MSR_RELOAD_FIXED_CTR0) ||
 			intel_pmu_is_valid_lbr_msr(vcpu, msr);
 		break;
 	}
@@ -241,6 +243,8 @@ static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
 	pmc = get_fixed_pmc(pmu, msr, MSR_CORE_PERF_FIXED_CTR0);
 	pmc = pmc ? pmc : get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0);
 	pmc = pmc ? pmc : get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0);
+	pmc = pmc ? pmc : get_gp_pmc(pmu, msr, MSR_RELOAD_PMC0);
+	pmc = pmc ? pmc : get_fixed_pmc(pmu, msr, MSR_RELOAD_FIXED_CTR0);
 
 	return pmc;
 }
@@ -394,6 +398,10 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			msr_info->data = pmc->eventsel;
 			return 0;
+		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_RELOAD_PMC0)) ||
+			   (pmc = get_fixed_pmc(pmu, msr, MSR_RELOAD_FIXED_CTR0))) {
+			msr_info->data = pmc->reload_counter;
+			return 0;
 		} else if (intel_pmu_handle_lbr_msrs_access(vcpu, msr_info, true))
 			return 0;
 	}
@@ -488,6 +496,12 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				reprogram_gp_counter(pmc, data);
 				return 0;
 			}
+		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_RELOAD_PMC0)) ||
+			   (pmc = get_fixed_pmc(pmu, msr, MSR_RELOAD_FIXED_CTR0))) {
+			if (!(data & ~pmc_bitmask(pmc))) {
+				pmc->reload_counter = data;
+				return 0;
+			}
 		} else if (intel_pmu_handle_lbr_msrs_access(vcpu, msr_info, false))
 			return 0;
 	}
@@ -595,6 +609,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 			pmu->pebs_enable_mask =
 				~((1ull << pmu->nr_arch_gp_counters) - 1);
 		}
+		if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_OUTPUT_PT)
+			pmu->pebs_enable_mask &= ~PEBS_VIA_PT_MASK;
 	} else {
 		vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
 		vcpu->arch.perf_capabilities &= ~PERF_CAP_PEBS_MASK;
@@ -612,6 +628,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->gp_counters[i].vcpu = vcpu;
 		pmu->gp_counters[i].idx = i;
 		pmu->gp_counters[i].current_config = 0;
+		pmu->gp_counters[i].reload_counter = 0;
 	}
 
 	for (i = 0; i < INTEL_PMC_MAX_FIXED; i++) {
@@ -619,6 +636,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->fixed_counters[i].vcpu = vcpu;
 		pmu->fixed_counters[i].idx = i + INTEL_PMC_IDX_FIXED;
 		pmu->fixed_counters[i].current_config = 0;
+		pmu->fixed_counters[i].reload_counter = 0;
 	}
 
 	vcpu->arch.perf_capabilities = vmx_get_perf_capabilities();
-- 
2.31.1

