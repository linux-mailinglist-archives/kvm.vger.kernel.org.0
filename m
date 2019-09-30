Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 973ACC2ADF
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 01:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732576AbfI3X2H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 19:28:07 -0400
Received: from mga05.intel.com ([192.55.52.43]:63706 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732511AbfI3X2G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 19:28:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Sep 2019 16:28:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,568,1559545200"; 
   d="scan'208";a="215880236"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 30 Sep 2019 16:28:03 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, peterz@infradead.org,
        Jim Mattson <jmattson@google.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: x86/vPMU: Add lazy mechanism to release perf_event per vPMC
Date:   Mon, 30 Sep 2019 15:22:57 +0800
Message-Id: <20190930072257.43352-4-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190930072257.43352-1-like.xu@linux.intel.com>
References: <20190930072257.43352-1-like.xu@linux.intel.com>
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
this vPMC, and then it's time to release the non-reused perf_event on the
first call of vcpu_enter_guest() since the vcpu gets next scheduled in.

This lazy mechanism delays the event release time to the beginning of the
next scheduled time slice if vPMC's MSRs aren't accessed during this time
slice. If guest comes back to use this vPMC in next time slice, a new perf
event would be re-created via perf_event_create_kernel_counter() as usual.

Suggested-by: Wei W Wang <wei.w.wang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  8 ++++++
 arch/x86/kvm/pmu.c              | 43 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/pmu.h              |  3 +++
 arch/x86/kvm/pmu_amd.c          | 13 ++++++++++
 arch/x86/kvm/vmx/pmu_intel.c    | 25 +++++++++++++++++++
 arch/x86/kvm/x86.c              |  6 +++++
 6 files changed, 98 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 15f2ebad94f9..6723c04c8dc6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -479,6 +479,14 @@ struct kvm_pmu {
 	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
 	struct irq_work irq_work;
 	u64 reprogram_pmi;
+
+	/* for PMC being set, do not released its perf_event (if any) */
+	u64 lazy_release_ctrl;
+
+	union {
+		u8 event_count :7; /* the total number of created perf_events */
+		bool enable_cleanup :1;
+	} state;
 };
 
 struct kvm_pmu_ops;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 74bc5c42b8b5..1b3cec38b1a1 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -137,6 +137,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 	}
 
 	pmc->perf_event = event;
+	pmc_to_pmu(pmc)->state.event_count++;
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
+	pmu->state.event_count = 0;
+	pmu->state.enable_cleanup = false;
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
+	if (!unlikely(pmu->state.enable_cleanup))
+		return;
+
+	/* do cleanup before the first time of running vcpu after sched_in */
+	pmu->state.enable_cleanup = false;
+
+	/* cleanup unmarked vPMC in the last sched time slice */
+	for_each_set_bit(i, (unsigned long *)&bitmask, X86_PMC_IDX_MAX) {
+		pmc = kvm_x86_ops->pmu_ops->pmc_idx_to_pmc(pmu, i);
+
+		if (pmc && pmc->perf_event && !pmc_speculative_in_use(pmc))
+			pmc_stop_counter(pmc);
+	}
+
+	/* reset vPMC lazy-release states for this sched time slice */
+	pmu->lazy_release_ctrl = 0;
+}
+
 void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
 {
 	kvm_pmu_reset(vcpu);
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 3a95952702d2..c681738ba59c 100644
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
+		pmc_to_pmu(pmc)->state.event_count--;
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
index 73bbefa1d54e..4aa7d2eea5c8 100644
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
@@ -373,4 +397,5 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.refresh = intel_pmu_refresh,
 	.init = intel_pmu_init,
 	.reset = intel_pmu_reset,
+	.update_lazy_release_ctrl = intel_update_lazy_release_ctrl,
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0ed07d8d2caa..945b8be53a90 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8076,6 +8076,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		goto cancel_injection;
 	}
 
+	kvm_pmu_cleanup(vcpu);
+
 	preempt_disable();
 
 	kvm_x86_ops->prepare_guest_switch(vcpu);
@@ -9415,7 +9417,11 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 
 void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
 	vcpu->arch.l1tf_flush_l1d = true;
+	if (pmu->version && unlikely(pmu->state.event_count))
+		pmu->state.enable_cleanup = true;
 	kvm_x86_ops->sched_in(vcpu, cpu);
 }
 
-- 
2.21.0

