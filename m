Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2C62E9611
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 14:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbhADNa3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 08:30:29 -0500
Received: from mga07.intel.com ([134.134.136.100]:23242 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbhADNa2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jan 2021 08:30:28 -0500
IronPort-SDR: 0m1hGqyg//CUplEbGe58Ee4dysT23WHLgQ80lHgB3HaX72/ThfYZ8sDg/u2H+px/fk3jOG1h1x
 DFBWT2u/MHzg==
X-IronPort-AV: E=McAfee;i="6000,8403,9853"; a="241034459"
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="241034459"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 05:22:49 -0800
IronPort-SDR: JocRUK8k8ASaPNfd+Pt3539+sNH+2EnMZDn4Mr51/hdscxbK30Rb/5xYht4apSanqajY8f+mBv
 lFykmFgSMkXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="461944689"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga001.fm.intel.com with ESMTP; 04 Jan 2021 05:22:46 -0800
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
Subject: [PATCH v3 15/17] KVM: vmx/pmu: Rewrite applicable_counters field in guest PEBS records
Date:   Mon,  4 Jan 2021 21:15:40 +0800
Message-Id: <20210104131542.495413-16-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104131542.495413-1-like.xu@linux.intel.com>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PEBS event counters scheduled by host may different to the counters
required by guest. The host counter index will be leaked into the guest
PEBS record and the guest driver will be confused by the counter indexes
in the "Applicable Counters" field of the PEBS records and ignore them.

Before the guest PEBS overflow PMI is injected into the guest through
global status, KVM needs to rewrite the "Applicable Counters" field with
the right enabled guest pebs counter idx(s) in the guest PEBS records.

Co-developed-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +
 arch/x86/kvm/pmu.c              |  1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 84 +++++++++++++++++++++++++++++++--
 3 files changed, 82 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ea204c628f45..e6394ac54f81 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -452,6 +452,7 @@ struct kvm_pmu {
 	u64 ds_area;
 	u64 cached_ds_area;
 	struct gfn_to_hva_cache ds_area_cache;
+	struct gfn_to_hva_cache pebs_buffer_base_cache;
 	u64 pebs_enable;
 	u64 pebs_enable_mask;
 	u64 pebs_data_cfg;
@@ -459,6 +460,7 @@ struct kvm_pmu {
 
 	bool counter_cross_mapped;
 	bool need_rewrite_ds_pebs_interrupt_threshold;
+	bool need_rewrite_pebs_records;
 
 	/*
 	 * The gate to release perf_events not marked in
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index c0f18b304933..581653589108 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -77,6 +77,7 @@ static void kvm_perf_overflow_intr(struct perf_event *perf_event,
 
 	if (!test_and_set_bit(pmc->idx, pmu->reprogram_pmi)) {
 		if (perf_event->attr.precise_ip) {
+			pmu->need_rewrite_pebs_records = pmu->counter_cross_mapped;
 			/* Indicate PEBS overflow PMI to guest. */
 			__set_bit(GLOBAL_STATUS_BUFFER_OVF_BIT,
 				(unsigned long *)&pmu->global_status);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index b69e7c47fb05..4c095c31db38 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -557,22 +557,96 @@ static int rewrite_ds_pebs_interrupt_threshold(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static int rewrite_ds_pebs_records(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc = NULL;
+	struct debug_store *ds = NULL;
+	gpa_t gpa;
+	u64 pebs_buffer_base, offset, buffer_base, status, new_status, format_size;
+	int srcu_idx, bit, ret = 0;
+
+	if (!pmu->counter_cross_mapped)
+		return ret;
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
+	if (ds->pebs_index <= ds->pebs_buffer_base)
+		goto out;
+
+	pebs_buffer_base = ds->pebs_buffer_base;
+	offset = offsetof(struct pebs_basic, applicable_counters);
+	buffer_base = 0;
+
+	gpa = kvm_mmu_gva_to_gpa_system(vcpu, pebs_buffer_base, NULL);
+	if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &pmu->pebs_buffer_base_cache,
+			gpa, sizeof(struct pebs_basic)))
+		goto out;
+
+	do {
+		ret = -EFAULT;
+		if (kvm_read_guest_offset_cached(vcpu->kvm, &pmu->pebs_buffer_base_cache,
+				&status, buffer_base + offset, sizeof(u64)))
+			goto out;
+		if (kvm_read_guest_offset_cached(vcpu->kvm, &pmu->pebs_buffer_base_cache,
+				&format_size, buffer_base, sizeof(u64)))
+			goto out;
+
+		new_status = 0ull;
+		for_each_set_bit(bit, (unsigned long *)&pmu->pebs_enable, X86_PMC_IDX_MAX) {
+			pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, bit);
+
+			if (!pmc || !pmc->perf_event)
+				continue;
+
+			if (test_bit(pmc->perf_event->hw.idx, (unsigned long *)&status))
+				new_status |= BIT_ULL(pmc->idx);
+		}
+		if (kvm_write_guest_offset_cached(vcpu->kvm, &pmu->pebs_buffer_base_cache,
+				&new_status, buffer_base + offset, sizeof(u64)))
+			goto out;
+
+		ret = 0;
+		buffer_base += format_size >> 48;
+	} while (pebs_buffer_base + buffer_base < ds->pebs_index);
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
-	int ret;
+	int ret1, ret2;
+
+	if (pmu->need_rewrite_pebs_records) {
+		pmu->need_rewrite_pebs_records = false;
+		ret1 = rewrite_ds_pebs_records(vcpu);
+	}
 
 	if (!(pmu->global_ctrl & pmu->pebs_enable))
-		return;
+		goto out;
 
 	if (pmu->counter_cross_mapped && pmu->need_rewrite_ds_pebs_interrupt_threshold) {
-		ret = rewrite_ds_pebs_interrupt_threshold(vcpu);
 		pmu->need_rewrite_ds_pebs_interrupt_threshold = false;
+		ret2 = rewrite_ds_pebs_interrupt_threshold(vcpu);
 	}
 
-	if (ret == -ENOMEM)
+out:
+
+	if (ret1 == -ENOMEM || ret2 == -ENOMEM)
 		pr_debug_ratelimited("%s: Fail to emulate guest PEBS due to OOM.", __func__);
-	else if (ret == -EFAULT)
+	else if (ret1 == -EFAULT || ret2 == -EFAULT)
 		pr_debug_ratelimited("%s: Fail to emulate guest PEBS due to GPA fault.", __func__);
 }
 
-- 
2.29.2

