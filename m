Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E0D2AAF5D
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 03:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbgKICR7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 21:17:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:64958 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729445AbgKICR5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Nov 2020 21:17:57 -0500
IronPort-SDR: gPO59/w1EhIuj/Y5RhwTzmeeP3qFoYKX6bck+3zIlIMEsy+hkj7mXU9inGFCE7vYZxQEz3qKSN
 XbG7mju3oqiw==
X-IronPort-AV: E=McAfee;i="6000,8403,9799"; a="187684681"
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="187684681"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2020 18:17:56 -0800
IronPort-SDR: mAiQqHdrBGr2R/NGvsN8MEeVzvFqtCf8XXtPy5ZhOsziMI+/bQQznunofqlw9wvjM06RSHg232
 vpBVNoNdHQYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="540646300"
Received: from e5-2699-v4-likexu.sh.intel.com ([10.239.48.39])
  by orsmga005.jf.intel.com with ESMTP; 08 Nov 2020 18:17:52 -0800
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
Subject: [PATCH RFC v2 17/17] KVM: x86/pmu: Adjust guest DS pebs reset counter values for mapped counter
Date:   Mon,  9 Nov 2020 10:12:54 +0800
Message-Id: <20201109021254.79755-18-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201109021254.79755-1-like.xu@linux.intel.com>
References: <20201109021254.79755-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The original PEBS reset counter value has been saved to pmc->reset_counter.

When the guest PEBS counter X is enabled, the reset value RST-x would be
written to guest DS reset field RST-y and it will be auto reloaded to the
real host counter Y which is mapped to the guest PEBS counter X during
this vm-entry period.

KVM would record each last host reset counter index field for each guest
PEBS counter and trigger the reset values rewrite once any entry in the
host-guest counter mapping table is changed before vm-entry.

The frequent changes in the mapping relationship should only happen when
perf multiplexes the counters with the default 1ms timer. The time cost
of adjusting the guest reset values will not exceed 1ms (13347ns on ICX),
and there will be no race with the multiplex timer to create a livelock.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/pmu.c              | 15 +++++++++++
 arch/x86/kvm/pmu.h              |  1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 47 ++++++++++++++++++++++++++++++---
 4 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 32a677ff1e55..93026e9361d9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -418,6 +418,7 @@ struct kvm_pmc {
 	enum pmc_type type;
 	u8 idx;
 	u64 counter;
+	u8 host_idx;
 	u64 reset_counter;
 	u64 eventsel;
 	struct perf_event *perf_event;
@@ -460,6 +461,7 @@ struct kvm_pmu {
 	bool need_rewrite_ds_pebs_interrupt_threshold;
 	bool need_rewrite_pebs_records;
 	bool need_save_reset_counter;
+	bool need_rewrite_reset_counter;
 
 	/*
 	 * The gate to release perf_events not marked in
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 64dce19644e3..d12dbe07117e 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -154,6 +154,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 	if (IS_ERR(event)) {
 		pr_debug_ratelimited("kvm_pmu: event creation failed %ld for pmc->idx = %d\n",
 			    PTR_ERR(event), pmc->idx);
+		pmc->host_idx = -1;
 		return;
 	}
 
@@ -554,6 +555,7 @@ void kvm_pmu_counter_cross_mapped_check(struct kvm_vcpu *vcpu)
 	int bit;
 
 	pmu->counter_cross_mapped = false;
+	pmu->need_rewrite_reset_counter = false;
 
 	for_each_set_bit(bit, (unsigned long *)&pmu->pebs_enable, X86_PMC_IDX_MAX) {
 		pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, bit);
@@ -567,6 +569,19 @@ void kvm_pmu_counter_cross_mapped_check(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	for_each_set_bit(bit, (unsigned long *)&pmu->pebs_enable, X86_PMC_IDX_MAX) {
+		pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, bit);
+
+		if (!pmc || !pmc_speculative_in_use(pmc) || !pmc_is_enabled(pmc))
+			continue;
+
+		if ((pmc->perf_event && (pmc->host_idx != pmc->perf_event->hw.idx))) {
+			pmu->need_rewrite_reset_counter = true;
+			kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
+			break;
+		}
+	}
+
 	if (!pmu->counter_cross_mapped)
 		return;
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 6cdc9fd03195..2776a048fd27 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -74,6 +74,7 @@ static inline void pmc_release_perf_event(struct kvm_pmc *pmc)
 		pmc->perf_event = NULL;
 		pmc->current_config = 0;
 		pmc_to_pmu(pmc)->event_count--;
+		pmc->host_idx = -1;
 	}
 }
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index f5a69addd7a8..0aab3a4f9e41 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -659,10 +659,46 @@ static int save_ds_pebs_reset_values(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static int rewrite_ds_pebs_reset_counters(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc = NULL;
+	gpa_t gpa;
+	int srcu_idx, bit, ret;
+	u64 offset, host_idx, idx;
+
+	ret = -EFAULT;
+	srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+	for_each_set_bit(bit, (unsigned long *)&pmu->pebs_enable, X86_PMC_IDX_MAX) {
+		pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, bit);
+
+		if (!pmc || !pmc->perf_event)
+			continue;
+
+		host_idx = pmc->perf_event->hw.idx;
+		idx = (host_idx < INTEL_PMC_IDX_FIXED) ?
+				host_idx : (MAX_PEBS_EVENTS + host_idx - INTEL_PMC_IDX_FIXED);
+		offset = offsetof(struct debug_store, pebs_event_reset) + sizeof(u64) * idx;
+		gpa = kvm_mmu_gva_to_gpa_system(vcpu, pmu->ds_area + offset, NULL);
+		if (gpa == UNMAPPED_GVA)
+			goto out;
+
+		if (kvm_write_guest(vcpu->kvm, gpa, &pmc->reset_counter, sizeof(u64)))
+			goto out;
+
+		pmc->host_idx = pmc->perf_event->hw.idx;
+	}
+	ret = 0;
+
+out:
+	srcu_read_unlock(&vcpu->kvm->srcu, srcu_idx);
+	return ret;
+}
+
 void intel_pmu_handle_event(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	int ret1, ret2, ret3;
+	int ret1, ret2, ret3, ret4;
 
 	if (pmu->need_rewrite_pebs_records) {
 		pmu->need_rewrite_pebs_records = false;
@@ -682,11 +718,16 @@ void intel_pmu_handle_event(struct kvm_vcpu *vcpu)
 		ret3 = save_ds_pebs_reset_values(vcpu);
 	}
 
+	if (pmu->need_rewrite_reset_counter) {
+		ret4 = pmu->need_rewrite_reset_counter = false;
+		rewrite_ds_pebs_reset_counters(vcpu);
+	}
+
 out:
 
-	if (ret1 == -ENOMEM || ret2 == -ENOMEM || ret3 == -ENOMEM)
+	if (ret1 == -ENOMEM || ret2 == -ENOMEM || ret3 == -ENOMEM || ret4 == -ENOMEM)
 		pr_debug_ratelimited("%s: Fail to emulate guest PEBS due to OOM.", __func__);
-	else if (ret1 == -EFAULT || ret2 == -EFAULT || ret3 == -EFAULT)
+	else if (ret1 == -EFAULT || ret2 == -EFAULT || ret3 == -EFAULT || ret4 == -EFAULT)
 		pr_debug_ratelimited("%s: Fail to emulate guest PEBS due to GPA fault.", __func__);
 }
 
-- 
2.21.3

