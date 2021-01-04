Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43B02E9613
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 14:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbhADNah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 08:30:37 -0500
Received: from mga07.intel.com ([134.134.136.100]:23246 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbhADNad (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jan 2021 08:30:33 -0500
IronPort-SDR: 4tsIokbNkQToyEu5woAusd1wDCJcOnI/C4BR73NFWjcLztXYSV6ni9SGVyzMTxiaJ9fb0kCucm
 bwSzI9D731Ng==
X-IronPort-AV: E=McAfee;i="6000,8403,9853"; a="241034492"
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="241034492"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 05:22:53 -0800
IronPort-SDR: gmWafp9ugMIA9HtjKXLJ/3I3gfVE0kZ6Cq5GPq4IeP2pUNm+BQ1DyXVIWqP9nNzvgTsoD9Lgnv
 kbwBhTYe3BrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="461944716"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga001.fm.intel.com with ESMTP; 04 Jan 2021 05:22:49 -0800
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
Subject: [PATCH v3 16/17] KVM: x86/pmu: Save guest pebs reset values when pebs is configured
Date:   Mon,  4 Jan 2021 21:15:41 +0800
Message-Id: <20210104131542.495413-17-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104131542.495413-1-like.xu@linux.intel.com>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest pebs counter X may be cross mapped to the host counter Y.
While the PEBS facility would reload the reset value once a PEBS record
is written to guest DS and potentially continue to generate PEBS records
before guest read the previous records.

KVM will adjust the guest DS pebs reset counter values for exactly mapped
host counters but before that, it needs to save the original expected guest
reset counter values right after the counter is fully enabled via a trap.

We assume that every time the guest PEBS driver enables the counter for
large PEBS, it will configure the DS reset counter values as Linux does.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/vmx/pmu_intel.c    | 47 ++++++++++++++++++++++++++++++---
 2 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e6394ac54f81..1d17e51c5c8a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -418,6 +418,7 @@ struct kvm_pmc {
 	enum pmc_type type;
 	u8 idx;
 	u64 counter;
+	u64 reset_counter;
 	u64 eventsel;
 	struct perf_event *perf_event;
 	struct kvm_vcpu *vcpu;
@@ -461,6 +462,7 @@ struct kvm_pmu {
 	bool counter_cross_mapped;
 	bool need_rewrite_ds_pebs_interrupt_threshold;
 	bool need_rewrite_pebs_records;
+	bool need_save_reset_counter;
 
 	/*
 	 * The gate to release perf_events not marked in
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 4c095c31db38..4e6ed0e8bddf 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -219,12 +219,14 @@ static void intel_pmu_pebs_setup(struct kvm_pmu *pmu)
 	gpa_t gpa;
 
 	pmu->need_rewrite_ds_pebs_interrupt_threshold = false;
+	pmu->need_save_reset_counter = false;
 
 	for_each_set_bit(bit, (unsigned long *)&pmu->pebs_enable, X86_PMC_IDX_MAX) {
 		pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, bit);
 
 		if (pmc && pmc_speculative_in_use(pmc)) {
 			pmu->need_rewrite_ds_pebs_interrupt_threshold = true;
+			pmu->need_save_reset_counter = true;
 			break;
 		}
 	}
@@ -624,10 +626,44 @@ static int rewrite_ds_pebs_records(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static int save_ds_pebs_reset_values(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc = NULL;
+	struct debug_store *ds = NULL;
+	int srcu_idx, bit, idx, ret;
+
+	ds = kmalloc(sizeof(struct debug_store), GFP_KERNEL);
+	if (!ds)
+		return -ENOMEM;
+
+	ret = -EFAULT;
+	srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+	if (kvm_read_guest_cached(vcpu->kvm, &pmu->ds_area_cache,
+			ds, sizeof(struct debug_store)))
+		goto out;
+
+	for_each_set_bit(bit, (unsigned long *)&pmu->pebs_enable, X86_PMC_IDX_MAX) {
+		pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, bit);
+
+		if (pmc) {
+			idx = (pmc->idx < INTEL_PMC_IDX_FIXED) ?
+				pmc->idx : (MAX_PEBS_EVENTS + pmc->idx - INTEL_PMC_IDX_FIXED);
+			pmc->reset_counter = ds->pebs_event_reset[idx];
+		}
+	}
+	ret = 0;
+
+out:
+	srcu_read_unlock(&vcpu->kvm->srcu, srcu_idx);
+	kfree(ds);
+	return ret;
+}
+
 static void intel_pmu_handle_event(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	int ret1, ret2;
+	int ret1, ret2, ret3;
 
 	if (pmu->need_rewrite_pebs_records) {
 		pmu->need_rewrite_pebs_records = false;
@@ -642,11 +678,16 @@ static void intel_pmu_handle_event(struct kvm_vcpu *vcpu)
 		ret2 = rewrite_ds_pebs_interrupt_threshold(vcpu);
 	}
 
+	if (pmu->need_save_reset_counter) {
+		pmu->need_save_reset_counter = false;
+		ret3 = save_ds_pebs_reset_values(vcpu);
+	}
+
 out:
 
-	if (ret1 == -ENOMEM || ret2 == -ENOMEM)
+	if (ret1 == -ENOMEM || ret2 == -ENOMEM || ret3 == -ENOMEM)
 		pr_debug_ratelimited("%s: Fail to emulate guest PEBS due to OOM.", __func__);
-	else if (ret1 == -EFAULT || ret2 == -EFAULT)
+	else if (ret1 == -EFAULT || ret2 == -EFAULT || ret3 == -EFAULT)
 		pr_debug_ratelimited("%s: Fail to emulate guest PEBS due to GPA fault.", __func__);
 }
 
-- 
2.29.2

