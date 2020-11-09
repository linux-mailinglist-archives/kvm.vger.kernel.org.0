Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58BA2AAF61
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 03:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729397AbgKICRq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 21:17:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:64952 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729419AbgKICRp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Nov 2020 21:17:45 -0500
IronPort-SDR: sFHXjvoE3BqT9WAQvt96U65NKBDppbv0He693WYqa+pMZw4ZIu/smU+sYJQO2MRyDqDGt6heDa
 SpK4YgOSzYLg==
X-IronPort-AV: E=McAfee;i="6000,8403,9799"; a="187684652"
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="187684652"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2020 18:17:45 -0800
IronPort-SDR: 60GmL2LNpX6LBr9umxhLdWlQ10uAkpjyP8+zwY3ZCApQSOycRKgQyq+NbW2AOMJi/NQfWtRuwP
 nPyWBbMivZ6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="540646271"
Received: from e5-2699-v4-likexu.sh.intel.com ([10.239.48.39])
  by orsmga005.jf.intel.com with ESMTP; 08 Nov 2020 18:17:41 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>, luwei.kang@intel.com,
        Thomas Gleixner <tglx@linutronix.de>, wei.w.wang@intel.com,
        Tony Luck <tony.luck@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Mark Gross <mgross@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC v2 14/17] KVM: vmx/pmu: Limit pebs_interrupt_threshold in the guest DS area
Date:   Mon,  9 Nov 2020 10:12:51 +0800
Message-Id: <20201109021254.79755-15-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201109021254.79755-1-like.xu@linux.intel.com>
References: <20201109021254.79755-1-like.xu@linux.intel.com>
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
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/pmu.c              | 17 +++-----
 arch/x86/kvm/pmu.h              | 11 +++++
 arch/x86/kvm/vmx/pmu_intel.c    | 71 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              |  1 +
 5 files changed, 90 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bffb384485da..77b529b8c16a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -456,6 +456,7 @@ struct kvm_pmu {
 	u64 pebs_data_cfg_mask;
 
 	bool counter_cross_mapped;
+	bool need_rewrite_ds_pebs_interrupt_threshold;
 
 	/*
 	 * The gate to release perf_events not marked in
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index f87be3c2140e..7c8e3ca5b7ad 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -471,17 +471,6 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
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
@@ -576,4 +565,10 @@ void kvm_pmu_counter_cross_mapped_check(struct kvm_vcpu *vcpu)
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
index 2917105e584e..346b1104e674 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -211,6 +211,23 @@ static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
 	return pmc;
 }
 
+static void intel_pmu_pebs_setup(struct kvm_pmu *pmu)
+{
+	struct kvm_pmc *pmc = NULL;
+	int bit;
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
+}
+
 static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -287,6 +304,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		if (kvm_valid_perf_global_ctrl(pmu, data)) {
 			global_ctrl_changed(pmu, data);
+			if (pmu->global_ctrl & pmu->pebs_enable)
+				intel_pmu_pebs_setup(pmu);
 			return 0;
 		}
 		break;
@@ -491,12 +510,64 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 		pmu->global_ovf_ctrl = 0;
 }
 
+static int rewrite_ds_pebs_interrupt_threshold(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct debug_store *ds = NULL;
+	u64 new_threshold, offset;
+	gpa_t gpa;
+	int srcu_idx, ret = -ENOMEM;
+
+	ds = kmalloc(sizeof(struct debug_store), GFP_KERNEL);
+	if (!ds)
+		goto out;
+
+	ret = -EFAULT;
+	srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+	gpa = kvm_mmu_gva_to_gpa_system(vcpu, pmu->ds_area, NULL);
+	if (gpa == UNMAPPED_GVA)
+		goto unlock_out;
+
+	if (kvm_read_guest(vcpu->kvm, gpa, ds, sizeof(struct debug_store)))
+		goto unlock_out;
+
+	/* Adding sizeof(struct pebs_basic) offset is enough to generate PMI. */
+	new_threshold = ds->pebs_buffer_base + sizeof(struct pebs_basic);
+	offset = offsetof(struct debug_store, pebs_interrupt_threshold);
+	gpa = kvm_mmu_gva_to_gpa_system(vcpu, pmu->ds_area + offset, NULL);
+	if (gpa == UNMAPPED_GVA)
+		goto unlock_out;
+
+	if (kvm_write_guest(vcpu->kvm, gpa, &new_threshold, sizeof(u64)))
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
 void intel_pmu_handle_event(struct kvm_vcpu *vcpu)
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
index 88a544e6379f..8db0811c1dd3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5856,6 +5856,7 @@ gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
 {
 	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, 0, exception);
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_gva_to_gpa_system);
 
 static int kvm_read_guest_virt_helper(gva_t addr, void *val, unsigned int bytes,
 				      struct kvm_vcpu *vcpu, u32 access,
-- 
2.21.3

