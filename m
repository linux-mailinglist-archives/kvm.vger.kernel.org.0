Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413D32AAF62
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 03:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729435AbgKICRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 21:17:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:64958 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729431AbgKICRt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Nov 2020 21:17:49 -0500
IronPort-SDR: qDq8NWuPZP+Mecl0t7Ek6v3dshS14OumuhbYe2op3f70ghr+2u/MIqWAPmccPvC/5lsznn2CqR
 7pf5GpLZpASg==
X-IronPort-AV: E=McAfee;i="6000,8403,9799"; a="187684670"
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="187684670"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2020 18:17:48 -0800
IronPort-SDR: j5U2XaiU6WXg5m97koqDGeIX7BjV3J97z0p8UgUek0vDkrCUMfKLa+gTuVV9I0mmjZvGrxJkty
 48nON/ucXD/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="540646276"
Received: from e5-2699-v4-likexu.sh.intel.com ([10.239.48.39])
  by orsmga005.jf.intel.com with ESMTP; 08 Nov 2020 18:17:45 -0800
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
Subject: [PATCH RFC v2 15/17] KVM: vmx/pmu: Rewrite applicable_counters field in the guest PEBS record
Date:   Mon,  9 Nov 2020 10:12:52 +0800
Message-Id: <20201109021254.79755-16-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201109021254.79755-1-like.xu@linux.intel.com>
References: <20201109021254.79755-1-like.xu@linux.intel.com>
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
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/pmu.c              |  1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 85 +++++++++++++++++++++++++++++++--
 3 files changed, 82 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 77b529b8c16a..cdc3c6efdd8e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -457,6 +457,7 @@ struct kvm_pmu {
 
 	bool counter_cross_mapped;
 	bool need_rewrite_ds_pebs_interrupt_threshold;
+	bool need_rewrite_pebs_records;
 
 	/*
 	 * The gate to release perf_events not marked in
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 7c8e3ca5b7ad..64dce19644e3 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -77,6 +77,7 @@ static void kvm_perf_overflow_intr(struct perf_event *perf_event,
 
 	if (!test_and_set_bit(pmc->idx, pmu->reprogram_pmi)) {
 		if (perf_event->attr.precise_ip) {
+			pmu->need_rewrite_pebs_records = pmu->counter_cross_mapped;
 			/* Indicate PEBS overflow PMI to guest. */
 			__set_bit(62, (unsigned long *)&pmu->global_status);
 		} else
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 346b1104e674..d58d04ee13a5 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -551,22 +551,97 @@ static int rewrite_ds_pebs_interrupt_threshold(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static int rewrite_ds_pebs_records(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc = NULL;
+	struct debug_store *ds = NULL;
+	gpa_t gpa;
+	u64 pebs_buffer_base, offset, status, new_status, format_size;
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
+	gpa = kvm_mmu_gva_to_gpa_system(vcpu, pmu->ds_area, NULL);
+	if (gpa == UNMAPPED_GVA)
+		goto out;
+
+	if (kvm_read_guest(vcpu->kvm, gpa, ds, sizeof(struct debug_store)))
+		goto out;
+
+	if (ds->pebs_index <= ds->pebs_buffer_base)
+		goto out;
+
+	pebs_buffer_base = ds->pebs_buffer_base;
+	offset = offsetof(struct pebs_basic, applicable_counters);
+
+	do {
+		ret = -EFAULT;
+		gpa = kvm_mmu_gva_to_gpa_system(vcpu, pebs_buffer_base + offset, NULL);
+		if (gpa == UNMAPPED_GVA)
+			goto out;
+		if (kvm_read_guest(vcpu->kvm, gpa, &status, sizeof(u64)))
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
+		if (kvm_write_guest(vcpu->kvm, gpa, &new_status, sizeof(u64)))
+			goto out;
+
+		gpa = kvm_mmu_gva_to_gpa_system(vcpu, pebs_buffer_base, NULL);
+		if (gpa == UNMAPPED_GVA)
+			goto out;
+		if (kvm_read_guest(vcpu->kvm, gpa, &format_size, sizeof(u64)))
+			goto out;
+		ret = 0;
+
+		pebs_buffer_base = pebs_buffer_base + (format_size >> 48);
+	} while (pebs_buffer_base < ds->pebs_index);
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
2.21.3

