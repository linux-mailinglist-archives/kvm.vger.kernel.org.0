Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C76ABDFF2B
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 10:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388301AbfJVIMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 04:12:36 -0400
Received: from mga06.intel.com ([134.134.136.31]:64390 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388287AbfJVIMf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 04:12:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 01:12:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,326,1566889200"; 
   d="scan'208";a="200703530"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 22 Oct 2019 01:12:32 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     pbonzini@redhat.com, peterz@infradead.org, kvm@vger.kernel.org
Cc:     like.xu@intel.com, linux-kernel@vger.kernel.org,
        jmattson@google.com, sean.j.christopherson@intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com
Subject: [PATCH v3 6/6] KVM: x86/vPMU: Add lazy mechanism to release perf_event per vPMC
Date:   Tue, 22 Oct 2019 00:06:51 +0800
Message-Id: <20191021160651.49508-7-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191021160651.49508-1-like.xu@linux.intel.com>
References: <20191021160651.49508-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, a host perf_event is created for a vPMC functionality emulation.
It’s unpredictable to determine if a disabled perf_event will be reused.
If they are disabled and are not reused for a considerable period of time,
those obsolete perf_events would increase host context switch overhead that
could have been avoided.

If the guest doesn't WRMSR any of the vPMC's MSRs during an entire vcpu
sched time slice, and its independent enable bit of the vPMC isn't set,
we can predict that the guest has finished the use of this vPMC, and then
do request KVM_REQ_PMU in kvm_arch_sched_in and release those perf_events
in the first call of kvm_pmu_handle_event() after the vcpu is scheduled in.

This lazy mechanism delays the event release time to the beginning of the
next scheduled time slice if vPMC's MSRs aren't changed during this time
slice. If guest comes back to use this vPMC in next time slice, a new perf
event would be re-created via perf_event_create_kernel_counter() as usual.

Suggested-by: Wei W Wang <wei.w.wang@intel.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h | 14 ++++++++
 arch/x86/kvm/pmu.c              | 58 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/pmu.h              |  2 ++
 arch/x86/kvm/pmu_amd.c          |  1 +
 arch/x86/kvm/vmx/pmu_intel.c    |  6 ++++
 arch/x86/kvm/x86.c              |  6 ++++
 6 files changed, 87 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ccce4aaa44df..b8ee62cf669b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -475,6 +475,20 @@ struct kvm_pmu {
 	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
 	struct irq_work irq_work;
 	u64 reprogram_pmi;
+	DECLARE_BITMAP(all_valid_pmc_idx, X86_PMC_IDX_MAX);
+	DECLARE_BITMAP(pmc_in_use, X86_PMC_IDX_MAX);
+
+	/*
+	 * The gate to release perf_events not marked in
+	 * pmc_in_use only once in a vcpu time slice.
+	 */
+	bool need_cleanup;
+
+	/*
+	 * The total number of programmed perf_events and it helps to avoid
+	 * redundant check before cleanup if guest don't use vPMU at all.
+	 */
+	u8 event_count;
 };
 
 struct kvm_pmu_ops;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 80a17377ec81..a8793f965941 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -137,6 +137,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 	}
 
 	pmc->perf_event = event;
+	pmc_to_pmu(pmc)->event_count++;
 	clear_bit(pmc->idx, (unsigned long*)&pmc_to_pmu(pmc)->reprogram_pmi);
 }
 
@@ -309,6 +310,15 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 
 		reprogram_counter(pmu, bit);
 	}
+
+	/*
+	 * vPMU uses a lazy method to release the perf_events created for
+	 * features emulation when the related MSRs weren't accessed during
+	 * last vcpu time slice. Technically, this cleanup check happens on
+	 * the first call of vcpu_enter_guest after the vcpu gets scheduled in.
+	 */
+	if (unlikely(pmu->need_cleanup))
+		kvm_pmu_cleanup(vcpu);
 }
 
 /* check if idx is a valid index to access PMU */
@@ -384,6 +394,15 @@ bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 		kvm_x86_ops->pmu_ops->is_valid_msr(vcpu, msr);
 }
 
+static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc = kvm_x86_ops->pmu_ops->msr_idx_to_pmc(vcpu, msr);
+
+	if (pmc)
+		__set_bit(pmc->idx, pmu->pmc_in_use);
+}
+
 int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 {
 	return kvm_x86_ops->pmu_ops->get_msr(vcpu, msr, data);
@@ -391,6 +410,7 @@ int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
+	kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
 	return kvm_x86_ops->pmu_ops->set_msr(vcpu, msr_info);
 }
 
@@ -418,9 +438,47 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 	memset(pmu, 0, sizeof(*pmu));
 	kvm_x86_ops->pmu_ops->init(vcpu);
 	init_irq_work(&pmu->irq_work, kvm_pmi_trigger_fn);
+	pmu->event_count = 0;
+	pmu->need_cleanup = false;
 	kvm_pmu_refresh(vcpu);
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
+void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc = NULL;
+	DECLARE_BITMAP(bitmask, X86_PMC_IDX_MAX);
+	int i;
+
+	/* do cleanup before the first time of running vcpu after sched_in */
+	pmu->need_cleanup = false;
+
+	bitmap_andnot(bitmask, pmu->all_valid_pmc_idx,
+		      pmu->pmc_in_use, X86_PMC_IDX_MAX);
+
+	/* release events for unmarked vPMCs in the last sched time slice */
+	for_each_set_bit(i, bitmask, X86_PMC_IDX_MAX) {
+		pmc = kvm_x86_ops->pmu_ops->pmc_idx_to_pmc(pmu, i);
+
+		if (pmc && pmc->perf_event && !pmc_speculative_in_use(pmc))
+			pmc_stop_counter(pmc);
+	}
+
+	/* reset vPMC lazy-release bitmap for this sched time slice */
+	bitmap_zero(pmu->pmc_in_use, X86_PMC_IDX_MAX);
+}
+
 void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
 {
 	kvm_pmu_reset(vcpu);
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 4bf1d25c92d3..325c12b5c9b4 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -62,6 +62,7 @@ static inline void pmc_release_perf_event(struct kvm_pmc *pmc)
 		perf_event_release_kernel(pmc->perf_event);
 		pmc->perf_event = NULL;
 		pmc->current_config = 0;
+		pmc_to_pmu(pmc)->event_count--;
 	}
 }
 
@@ -126,6 +127,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 void kvm_pmu_refresh(struct kvm_vcpu *vcpu);
 void kvm_pmu_reset(struct kvm_vcpu *vcpu);
 void kvm_pmu_init(struct kvm_vcpu *vcpu);
+void kvm_pmu_cleanup(struct kvm_vcpu *vcpu);
 void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
 
diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
index 0ed2cc7c5902..f0aa291f9963 100644
--- a/arch/x86/kvm/pmu_amd.c
+++ b/arch/x86/kvm/pmu_amd.c
@@ -279,6 +279,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->nr_arch_fixed_counters = 0;
 	pmu->global_status = 0;
+	bitmap_set(pmu->all_valid_pmc_idx, 0, pmu->nr_arch_gp_counters);
 }
 
 static void amd_pmu_init(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 002b98a8977e..a00197291f81 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -46,6 +46,7 @@ static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 		if (old_ctrl == new_ctrl)
 			continue;
 
+		__set_bit(INTEL_PMC_IDX_FIXED + i, pmu->pmc_in_use);
 		reprogram_fixed_counter(pmc, new_ctrl, i);
 	}
 
@@ -329,6 +330,11 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	    (boot_cpu_has(X86_FEATURE_HLE) || boot_cpu_has(X86_FEATURE_RTM)) &&
 	    (entry->ebx & (X86_FEATURE_HLE|X86_FEATURE_RTM)))
 		pmu->reserved_bits ^= HSW_IN_TX|HSW_IN_TX_CHECKPOINTED;
+
+	bitmap_set(pmu->all_valid_pmc_idx,
+		0, pmu->nr_arch_gp_counters);
+	bitmap_set(pmu->all_valid_pmc_idx,
+		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
 }
 
 static void intel_pmu_init(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 72ce691fd45d..a18cb93e80d4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9415,7 +9415,13 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 
 void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
 	vcpu->arch.l1tf_flush_l1d = true;
+	if (pmu->version && unlikely(pmu->event_count)) {
+		pmu->need_cleanup = true;
+		kvm_make_request(KVM_REQ_PMU, vcpu);
+	}
 	kvm_x86_ops->sched_in(vcpu, cpu);
 }
 
-- 
2.21.0

