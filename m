Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD6D2E95FB
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 14:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbhADN3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 08:29:15 -0500
Received: from mga07.intel.com ([134.134.136.100]:23250 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726640AbhADN3P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jan 2021 08:29:15 -0500
IronPort-SDR: KjHsI/8d0xRFiM95W0aL8rJCK24ciym7hn9Lwud3cRVe1UKsJ7rLzNIFXscPzWgN8Orwt6Tktf
 /bVu11FUyRqw==
X-IronPort-AV: E=McAfee;i="6000,8403,9853"; a="241034427"
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="241034427"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 05:22:46 -0800
IronPort-SDR: eBxYjP/J05eFgqSvOMglKkiZj9IcYxsNkrm0tK07TIZTAVIPPpC1WDmuHzQI6/XJsUYunHzpj/
 8rf1Nkp+gDdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="461944683"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga001.fm.intel.com with ESMTP; 04 Jan 2021 05:22:43 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>,
        Kan Liang <kan.liang@linux.intel.com>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH v3 14/17] KVM: vmx/pmu: Limit pebs_interrupt_threshold in the guest DS area
Date:   Mon,  4 Jan 2021 21:15:39 +0800
Message-Id: <20210104131542.495413-15-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104131542.495413-1-like.xu@linux.intel.com>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the host counter X is scheduled to the guest PEBS counter Y,
the guest ds pebs_interrupt_threshold field in guest DS area would
be changed to only ONE record before vm-entry which helps KVM
more easily and accurately handle the cross-mapping emulation
when the PEBS overflow PMI is generated.

In most cases, the guest counters would not be scheduled in a cross-mapped
way which means there is no need to change guest DS
pebs_interrupt_threshold and the applicable_counters fields in the guest
PEBS records are naturally correct. PEBS facility writes multiple PEBS
records into guest DS w/o interception and the performance is good.

AFAIK, we don't expect that changing the pebs_interrupt_threshold value
from the KVM side will break any guest PEBS drivers.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++
 arch/x86/kvm/pmu.c              | 17 +++-----
 arch/x86/kvm/pmu.h              | 11 +++++
 arch/x86/kvm/vmx/pmu_intel.c    | 77 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              |  1 +
 5 files changed, 98 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5de4c14cf526..ea204c628f45 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -450,12 +450,15 @@ struct kvm_pmu {
 	DECLARE_BITMAP(pmc_in_use, X86_PMC_IDX_MAX);
 
 	u64 ds_area;
+	u64 cached_ds_area;
+	struct gfn_to_hva_cache ds_area_cache;
 	u64 pebs_enable;
 	u64 pebs_enable_mask;
 	u64 pebs_data_cfg;
 	u64 pebs_data_cfg_mask;
 
 	bool counter_cross_mapped;
+	bool need_rewrite_ds_pebs_interrupt_threshold;
 
 	/*
 	 * The gate to release perf_events not marked in
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index e898da4699c9..c0f18b304933 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -472,17 +472,6 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 	kvm_pmu_refresh(vcpu);
 }
 
-static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
-{
-	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
-
-	if (pmc_is_fixed(pmc))
-		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
-			pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
-
-	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
-}
-
 /* Release perf_events for vPMCs that have been unused for a full time slice.  */
 void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 {
@@ -577,4 +566,10 @@ void kvm_pmu_counter_cross_mapped_check(struct kvm_vcpu *vcpu)
 			break;
 		}
 	}
+
+	if (!pmu->counter_cross_mapped)
+		return;
+
+	if (pmu->need_rewrite_ds_pebs_interrupt_threshold)
+		kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 }
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index b1e52e33f08c..6cdc9fd03195 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -147,6 +147,17 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
 	return sample_period;
 }
 
+static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
+{
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+
+	if (pmc_is_fixed(pmc))
+		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
+			pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
+
+	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
+}
+
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 2a06f923fbc7..b69e7c47fb05 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -211,6 +211,36 @@ static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
 	return pmc;
 }
 
+static void intel_pmu_pebs_setup(struct kvm_pmu *pmu)
+{
+	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
+	struct kvm_pmc *pmc = NULL;
+	int bit, idx;
+	gpa_t gpa;
+
+	pmu->need_rewrite_ds_pebs_interrupt_threshold = false;
+
+	for_each_set_bit(bit, (unsigned long *)&pmu->pebs_enable, X86_PMC_IDX_MAX) {
+		pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, bit);
+
+		if (pmc && pmc_speculative_in_use(pmc)) {
+			pmu->need_rewrite_ds_pebs_interrupt_threshold = true;
+			break;
+		}
+	}
+
+	if (pmu->pebs_enable && pmu->cached_ds_area != pmu->ds_area) {
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
+		gpa = kvm_mmu_gva_to_gpa_system(vcpu, pmu->ds_area, NULL);
+		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &pmu->ds_area_cache,
+				gpa, sizeof(struct debug_store)))
+			goto out;
+		pmu->cached_ds_area = pmu->ds_area;
+out:
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	}
+}
+
 static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -287,6 +317,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		if (kvm_valid_perf_global_ctrl(pmu, data)) {
 			global_ctrl_changed(pmu, data);
+			if (pmu->global_ctrl & pmu->pebs_enable)
+				intel_pmu_pebs_setup(pmu);
 			return 0;
 		}
 		break;
@@ -491,12 +523,57 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 		pmu->global_ovf_ctrl = 0;
 }
 
+static int rewrite_ds_pebs_interrupt_threshold(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct debug_store *ds = NULL;
+	u64 new_threshold, offset;
+	int srcu_idx, ret = -ENOMEM;
+
+	ds = kmalloc(sizeof(struct debug_store), GFP_KERNEL);
+	if (!ds)
+		goto out;
+
+	ret = -EFAULT;
+	srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+	if (kvm_read_guest_cached(vcpu->kvm, &pmu->ds_area_cache,
+			ds, sizeof(struct debug_store)))
+		goto unlock_out;
+
+	/* Adding sizeof(struct pebs_basic) offset is enough to generate PMI. */
+	new_threshold = ds->pebs_buffer_base + sizeof(struct pebs_basic);
+	offset = offsetof(struct debug_store, pebs_interrupt_threshold);
+	if (kvm_write_guest_offset_cached(vcpu->kvm, &pmu->ds_area_cache,
+			&new_threshold, offset, sizeof(u64)))
+		goto unlock_out;
+
+	ret = 0;
+
+unlock_out:
+	srcu_read_unlock(&vcpu->kvm->srcu, srcu_idx);
+
+out:
+	kfree(ds);
+	return ret;
+}
+
 static void intel_pmu_handle_event(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	int ret;
 
 	if (!(pmu->global_ctrl & pmu->pebs_enable))
 		return;
+
+	if (pmu->counter_cross_mapped && pmu->need_rewrite_ds_pebs_interrupt_threshold) {
+		ret = rewrite_ds_pebs_interrupt_threshold(vcpu);
+		pmu->need_rewrite_ds_pebs_interrupt_threshold = false;
+	}
+
+	if (ret == -ENOMEM)
+		pr_debug_ratelimited("%s: Fail to emulate guest PEBS due to OOM.", __func__);
+	else if (ret == -EFAULT)
+		pr_debug_ratelimited("%s: Fail to emulate guest PEBS due to GPA fault.", __func__);
 }
 
 struct kvm_pmu_ops intel_pmu_ops = {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4ab1ce26244d..118e6752b563 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5917,6 +5917,7 @@ gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
 {
 	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, 0, exception);
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_gva_to_gpa_system);
 
 static int kvm_read_guest_virt_helper(gva_t addr, void *val, unsigned int bytes,
 				      struct kvm_vcpu *vcpu, u32 access,
-- 
2.29.2

