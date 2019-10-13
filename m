Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05056D5945
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 03:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729843AbfJNBVD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Oct 2019 21:21:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:18548 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729180AbfJNBVD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Oct 2019 21:21:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Oct 2019 18:21:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,294,1566889200"; 
   d="scan'208";a="395033674"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga005.fm.intel.com with ESMTP; 13 Oct 2019 18:20:59 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        peterz@infradead.org, Jim Mattson <jmattson@google.com>
Cc:     rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] KVM: x86/vPMU: Add lazy mechanism to release perf_event per vPMC
Date:   Sun, 13 Oct 2019 17:15:33 +0800
Message-Id: <20191013091533.12971-5-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191013091533.12971-1-like.xu@linux.intel.com>
References: <20191013091533.12971-1-like.xu@linux.intel.com>
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

If the guest doesn't access (set_msr/get_msr/rdpmc) any of the vPMC's MSRs
during an entire vcpu sched time slice, and its independent enable bit of
the vPMC isn't set, we can predict that the guest has finished the use of
this vPMC, and then it's time to release non-reused perf_events in the
first call of vcpu_enter_guest() after the vcpu gets next scheduled in.

This lazy mechanism delays the event release time to the beginning of the
next scheduled time slice if vPMC's MSRs aren't accessed during this time
slice. If guest comes back to use this vPMC in next time slice, a new perf
event would be re-created via perf_event_create_kernel_counter() as usual.

Suggested-by: Wei W Wang <wei.w.wang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h | 15 ++++++++++++
 arch/x86/kvm/pmu.c              | 43 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/pmu.h              |  3 +++
 arch/x86/kvm/pmu_amd.c          | 13 ++++++++++
 arch/x86/kvm/vmx/pmu_intel.c    | 25 +++++++++++++++++++
 arch/x86/kvm/x86.c              | 12 +++++++++
 6 files changed, 111 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1abbbbae4953..45f9cdae150b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -472,6 +472,21 @@ struct kvm_pmu {
 	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
 	struct irq_work irq_work;
 	u64 reprogram_pmi;
+
+	/* for vPMC being set, do not released its perf_event (if any) */
+	u64 lazy_release_ctrl;
+
+	/*
+	 * The gate to release perf_events not marked in
+	 * lazy_release_ctrl only once in a vcpu time slice.
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
index 09d1a03c057c..7ab262f009f6 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -137,6 +137,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 	}
 
 	pmc->perf_event = event;
+	pmc_to_pmu(pmc)->event_count++;
 	clear_bit(pmc->idx, (unsigned long*)&pmc_to_pmu(pmc)->reprogram_pmi);
 }
 
@@ -368,6 +369,7 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	if (!pmc)
 		return 1;
 
+	__set_bit(pmc->idx, (unsigned long *)&pmu->lazy_release_ctrl);
 	*data = pmc_read_counter(pmc) & mask;
 	return 0;
 }
@@ -385,11 +387,13 @@ bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 
 int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 {
+	kvm_x86_ops->pmu_ops->update_lazy_release_ctrl(vcpu, msr);
 	return kvm_x86_ops->pmu_ops->get_msr(vcpu, msr, data);
 }
 
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
+	kvm_x86_ops->pmu_ops->update_lazy_release_ctrl(vcpu, msr_info->index);
 	return kvm_x86_ops->pmu_ops->set_msr(vcpu, msr_info);
 }
 
@@ -417,9 +421,48 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 	memset(pmu, 0, sizeof(*pmu));
 	kvm_x86_ops->pmu_ops->init(vcpu);
 	init_irq_work(&pmu->irq_work, kvm_pmi_trigger_fn);
+	pmu->lazy_release_ctrl = 0;
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
+	u64 bitmask = ~pmu->lazy_release_ctrl;
+	int i;
+
+	if (!unlikely(pmu->need_cleanup))
+		return;
+
+	/* do cleanup before the first time of running vcpu after sched_in */
+	pmu->need_cleanup = false;
+
+	/* release events for unmarked vPMCs in the last sched time slice */
+	for_each_set_bit(i, (unsigned long *)&bitmask, X86_PMC_IDX_MAX) {
+		pmc = kvm_x86_ops->pmu_ops->pmc_idx_to_pmc(pmu, i);
+
+		if (pmc && pmc->perf_event && !pmc_speculative_in_use(pmc))
+			pmc_stop_counter(pmc);
+	}
+
+	/* reset vPMC lazy-release bitmap for this sched time slice */
+	pmu->lazy_release_ctrl = 0;
+}
+
 void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
 {
 	kvm_pmu_reset(vcpu);
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 3a95952702d2..1bf8adb1d211 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -34,6 +34,7 @@ struct kvm_pmu_ops {
 	void (*refresh)(struct kvm_vcpu *vcpu);
 	void (*init)(struct kvm_vcpu *vcpu);
 	void (*reset)(struct kvm_vcpu *vcpu);
+	void (*update_lazy_release_ctrl)(struct kvm_vcpu *vcpu, u32 msr);
 };
 
 static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
@@ -61,6 +62,7 @@ static inline void pmc_release_perf_event(struct kvm_pmc *pmc)
 		perf_event_release_kernel(pmc->perf_event);
 		pmc->perf_event = NULL;
 		pmc->programed_config = 0;
+		pmc_to_pmu(pmc)->event_count--;
 	}
 }
 
@@ -125,6 +127,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 void kvm_pmu_refresh(struct kvm_vcpu *vcpu);
 void kvm_pmu_reset(struct kvm_vcpu *vcpu);
 void kvm_pmu_init(struct kvm_vcpu *vcpu);
+void kvm_pmu_cleanup(struct kvm_vcpu *vcpu);
 void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
 
diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
index 3d656b2d439f..c74087dad5e8 100644
--- a/arch/x86/kvm/pmu_amd.c
+++ b/arch/x86/kvm/pmu_amd.c
@@ -208,6 +208,18 @@ static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	return ret;
 }
 
+static void amd_update_lazy_release_ctrl(struct kvm_vcpu *vcpu, u32 msr)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc = NULL;
+
+	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
+	pmc = pmc ? pmc : get_gp_pmc_amd(pmu, msr, PMU_TYPE_EVNTSEL);
+
+	if (pmc)
+		__set_bit(pmc->idx, (unsigned long *)&pmu->lazy_release_ctrl);
+}
+
 static int amd_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -315,4 +327,5 @@ struct kvm_pmu_ops amd_pmu_ops = {
 	.refresh = amd_pmu_refresh,
 	.init = amd_pmu_init,
 	.reset = amd_pmu_reset,
+	.update_lazy_release_ctrl = amd_update_lazy_release_ctrl,
 };
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index fa14882dc3ad..8be7551ffcb3 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -140,6 +140,30 @@ static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu,
 	return &counters[idx];
 }
 
+static void intel_update_lazy_release_ctrl(struct kvm_vcpu *vcpu, u32 msr)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc = NULL;
+	int i;
+
+	if (msr == MSR_CORE_PERF_FIXED_CTR_CTRL) {
+		for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+			if (!fixed_ctrl_field(pmu->fixed_ctr_ctrl, i))
+				continue;
+			__set_bit(INTEL_PMC_IDX_FIXED + i,
+				(unsigned long *)&pmu->lazy_release_ctrl);
+		}
+		return;
+	}
+
+	pmc = get_fixed_pmc(pmu, msr);
+	pmc = pmc ? pmc : get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0);
+	pmc = pmc ? pmc : get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0);
+
+	if (pmc)
+		__set_bit(pmc->idx, (unsigned long *)&pmu->lazy_release_ctrl);
+}
+
 static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -376,4 +400,5 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.refresh = intel_pmu_refresh,
 	.init = intel_pmu_init,
 	.reset = intel_pmu_reset,
+	.update_lazy_release_ctrl = intel_update_lazy_release_ctrl,
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 661e2bf38526..023ea5efb3bb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8080,6 +8080,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		goto cancel_injection;
 	}
 
+	/*
+	 * vPMU uses a lazy method to release the perf_events created for
+	 * features emulation when the related MSRs weren't accessed during
+	 * last vcpu time slice. Technically, this cleanup check happens on
+	 * the first call of vcpu_enter_guest after the vcpu gets scheduled in.
+	 */
+	kvm_pmu_cleanup(vcpu);
+
 	preempt_disable();
 
 	kvm_x86_ops->prepare_guest_switch(vcpu);
@@ -9415,7 +9423,11 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 
 void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
 	vcpu->arch.l1tf_flush_l1d = true;
+	if (pmu->version && unlikely(pmu->event_count))
+		pmu->need_cleanup = true;
 	kvm_x86_ops->sched_in(vcpu, cpu);
 }
 
-- 
2.21.0

