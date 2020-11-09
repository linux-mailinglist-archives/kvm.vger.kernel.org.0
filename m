Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9542AAF5B
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 03:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbgKICRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 21:17:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:64958 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729445AbgKICRx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Nov 2020 21:17:53 -0500
IronPort-SDR: 5uuO/H5jVLH7fDOZziSf65IRpZucRsZgj6Npxu5jJnqijah+S4toVmhLoSXYZNgUcXuUbuHJGm
 vyMQBZZ2Fvkw==
X-IronPort-AV: E=McAfee;i="6000,8403,9799"; a="187684676"
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="187684676"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2020 18:17:52 -0800
IronPort-SDR: tACAG5bgdzO4iAd2sttP3a/5Ja2d/QinZb+irtiGB3z/iiuj35A5iLFscsDp/FEXA7A0EXwY8u
 Te52dqD3iBoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="540646284"
Received: from e5-2699-v4-likexu.sh.intel.com ([10.239.48.39])
  by orsmga005.jf.intel.com with ESMTP; 08 Nov 2020 18:17:49 -0800
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
Subject: [PATCH RFC v2 16/17] KVM: x86/pmu: Save guest pebs reset value when a pebs counter is configured
Date:   Mon,  9 Nov 2020 10:12:53 +0800
Message-Id: <20201109021254.79755-17-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201109021254.79755-1-like.xu@linux.intel.com>
References: <20201109021254.79755-1-like.xu@linux.intel.com>
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
 arch/x86/kvm/vmx/pmu_intel.c    | 51 +++++++++++++++++++++++++++++++--
 2 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cdc3c6efdd8e..32a677ff1e55 100644
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
@@ -458,6 +459,7 @@ struct kvm_pmu {
 	bool counter_cross_mapped;
 	bool need_rewrite_ds_pebs_interrupt_threshold;
 	bool need_rewrite_pebs_records;
+	bool need_save_reset_counter;
 
 	/*
 	 * The gate to release perf_events not marked in
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index d58d04ee13a5..f5a69addd7a8 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -217,12 +217,14 @@ static void intel_pmu_pebs_setup(struct kvm_pmu *pmu)
 	int bit;
 
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
@@ -619,10 +621,48 @@ static int rewrite_ds_pebs_records(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static int save_ds_pebs_reset_values(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc = NULL;
+	struct debug_store *ds = NULL;
+	gpa_t gpa;
+	int srcu_idx, bit, idx, ret;
+
+	ds = kmalloc(sizeof(struct debug_store), GFP_KERNEL);
+	if (!ds)
+		return -ENOMEM;
+
+	ret = -EFAULT;
+	srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+	gpa = kvm_mmu_gva_to_gpa_system(vcpu, pmu->ds_area, NULL);
+	if (gpa == UNMAPPED_GVA)
+		goto out;
+
+	if (kvm_read_guest(vcpu->kvm, gpa, ds, sizeof(struct debug_store)))
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
 void intel_pmu_handle_event(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	int ret1, ret2;
+	int ret1, ret2, ret3;
 
 	if (pmu->need_rewrite_pebs_records) {
 		pmu->need_rewrite_pebs_records = false;
@@ -637,11 +677,16 @@ void intel_pmu_handle_event(struct kvm_vcpu *vcpu)
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
2.21.3

