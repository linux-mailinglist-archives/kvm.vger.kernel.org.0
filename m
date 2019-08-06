Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD98E82D79
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 10:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732435AbfHFIGU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 04:06:20 -0400
Received: from mga03.intel.com ([134.134.136.65]:5868 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732423AbfHFIGT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 04:06:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 01:01:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,352,1559545200"; 
   d="scan'208";a="373337443"
Received: from devel-ww.sh.intel.com ([10.239.48.128])
  by fmsmga005.fm.intel.com with ESMTP; 06 Aug 2019 01:01:01 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, peterz@infradead.org, pbonzini@redhat.com
Cc:     kan.liang@intel.com, mingo@redhat.com, rkrcmar@redhat.com,
        like.xu@intel.com, wei.w.wang@intel.com, jannh@google.com,
        arei.gonglei@huawei.com, jmattson@google.com
Subject: [PATCH v8 12/14] KVM/x86/lbr: lbr emulation
Date:   Tue,  6 Aug 2019 15:16:12 +0800
Message-Id: <1565075774-26671-13-git-send-email-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565075774-26671-1-git-send-email-wei.w.wang@intel.com>
References: <1565075774-26671-1-git-send-email-wei.w.wang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In general, the lbr emulation works in this way:
Guest first access (since vcpu scheduled in) to the lbr related msr
gets trapped to kvm, and the handler will do the following things:
  - create an lbr perf event to have the vcpu get the lbr feature
    from host perf following the perf scheduling rules;
  - pass the lbr related msrs through to the guest for direct accesses
    without vm-exits till the end of this vcpu time slice.

The guest first access is made interceptible so that the kvm side lbr
emulation can always get if the lbr feature has been used during the
vcpu time slice. If the lbr feature isn't used during a time slice,
the lbr event created for the vcpu will be freed.

Some considerations:
- Why not free the vcpu lbr event when the guest clears the lbr enable bit?
Guest may frequently clear the lbr enable bit (in the debugctl msr) during
its use of the lbr feature, e.g. in PMI handler. This will cause the kvm
emulation to frequently alloc/free the vcpu lbr event, which is
unnecessary. Technically, we want to free the vcpu lbr event when the guest
doesn't need to run lbr anymore. Heuristically, we free the vcpu lbr event
when the guest doesn't touch any of the lbr msrs during an entire vcpu time
slice.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |   2 +
 arch/x86/kvm/pmu.c              |   6 ++
 arch/x86/kvm/pmu.h              |   2 +
 arch/x86/kvm/vmx/pmu_intel.c    | 206 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |   4 +-
 arch/x86/kvm/vmx/vmx.h          |   2 +
 arch/x86/kvm/x86.c              |   2 +
 7 files changed, 222 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 692a0c2..ecd22b5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -469,6 +469,8 @@ struct kvm_pmu {
 	u64 global_ctrl_mask;
 	u64 global_ovf_ctrl_mask;
 	u64 reserved_bits;
+	/* Indicate if the lbr msrs were accessed in this vcpu time slice */
+	bool lbr_used;
 	u8 version;
 	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
 	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 1a291ed..afad092 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -360,6 +360,12 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return kvm_x86_ops->pmu_ops->set_msr(vcpu, msr_info);
 }
 
+void kvm_pmu_sched_in(struct kvm_vcpu *vcpu, int cpu)
+{
+	if (kvm_x86_ops->pmu_ops->sched_in)
+		kvm_x86_ops->pmu_ops->sched_in(vcpu, cpu);
+}
+
 /* refresh PMU settings. This function generally is called when underlying
  * settings are changed (such as changes of PMU CPUID by guest VMs), which
  * should rarely happen.
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index f61024e..f875721 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -32,6 +32,7 @@ struct kvm_pmu_ops {
 	bool (*lbr_enable)(struct kvm_vcpu *vcpu);
 	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
+	void (*sched_in)(struct kvm_vcpu *vcpu, int cpu);
 	void (*refresh)(struct kvm_vcpu *vcpu);
 	void (*init)(struct kvm_vcpu *vcpu);
 	void (*reset)(struct kvm_vcpu *vcpu);
@@ -116,6 +117,7 @@ int kvm_pmu_is_valid_msr_idx(struct kvm_vcpu *vcpu, unsigned idx);
 bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr);
 int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
+void kvm_pmu_sched_in(struct kvm_vcpu *vcpu, int cpu);
 void kvm_pmu_refresh(struct kvm_vcpu *vcpu);
 void kvm_pmu_reset(struct kvm_vcpu *vcpu);
 void kvm_pmu_init(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 89730f8..5580f1a 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -17,6 +17,7 @@
 #include "cpuid.h"
 #include "lapic.h"
 #include "pmu.h"
+#include "vmx.h"
 
 static struct kvm_event_hw_type_mapping intel_arch_events[] = {
 	/* Index must match CPUID 0x0A.EBX bit vector */
@@ -141,6 +142,19 @@ static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu,
 	return &counters[idx];
 }
 
+/* Return true if it is one of the lbr related msrs. */
+static inline bool is_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
+{
+	struct x86_perf_lbr_stack *stack = &vcpu->kvm->arch.lbr_stack;
+	int nr = stack->nr;
+
+	return !!(index == MSR_LBR_SELECT ||
+		  index == stack->tos ||
+		  (index >= stack->from && index < stack->from + nr) ||
+		  (index >= stack->to && index < stack->to + nr) ||
+		  (index >= stack->info && index < stack->info));
+}
+
 static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -152,9 +166,12 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_CORE_PERF_GLOBAL_CTRL:
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 	case MSR_IA32_PERF_CAPABILITIES:
+	case MSR_IA32_DEBUGCTLMSR:
 		ret = pmu->version > 1;
 		break;
 	default:
+		if (is_lbr_msr(vcpu, msr))
+			return pmu->version > 1;
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
 			get_fixed_pmc(pmu, msr);
@@ -362,6 +379,163 @@ static bool intel_pmu_lbr_enable(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+/*
+ * "set = 1" to make the lbr msrs interceptible, otherwise pass the lbr msrs
+ * through to the guest.
+ */
+static void intel_pmu_set_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu,
+						 bool set)
+{
+	unsigned long *msr_bitmap = to_vmx(vcpu)->vmcs01.msr_bitmap;
+	struct x86_perf_lbr_stack *stack = &vcpu->kvm->arch.lbr_stack;
+	int nr = stack->nr;
+	int i;
+
+	vmx_set_intercept_for_msr(msr_bitmap, MSR_LBR_SELECT,
+				  MSR_TYPE_RW, set);
+	vmx_set_intercept_for_msr(msr_bitmap, stack->tos,
+				  MSR_TYPE_RW, set);
+	for (i = 0; i < nr; i++) {
+		vmx_set_intercept_for_msr(msr_bitmap, stack->from + i,
+					  MSR_TYPE_RW, set);
+		vmx_set_intercept_for_msr(msr_bitmap, stack->to + i,
+					  MSR_TYPE_RW, set);
+		if (stack->info)
+			vmx_set_intercept_for_msr(msr_bitmap, stack->info + i,
+						  MSR_TYPE_RW, set);
+	}
+}
+
+static bool intel_pmu_set_lbr_msr(struct kvm_vcpu *vcpu,
+				  struct msr_data *msr_info)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	u32 index = msr_info->index;
+	u64 data = msr_info->data;
+	bool ret = false;
+
+	/* The lbr event should have been allocated when reaching here. */
+	if (WARN_ON(!pmu->lbr_event))
+		return ret;
+
+	/*
+	 * Host perf could reclaim the lbr feature via ipi calls, and this can
+	 * be detected via lbr_event->oncpu being set to -1. To ensure the
+	 * writes to the lbr msrs don't happen after the lbr feature has been
+	 * reclaimed by the host, the interrupt is disabled before performing
+	 * the writes.
+	 */
+	local_irq_disable();
+	if (pmu->lbr_event->oncpu == -1)
+		goto out;
+
+	switch (index) {
+	case MSR_IA32_DEBUGCTLMSR:
+		ret = true;
+		/*
+		 * Currently, only FREEZE_LBRS_ON_PMI and DEBUGCTLMSR_LBR are
+		 * supported.
+		 */
+		data &= (DEBUGCTLMSR_FREEZE_LBRS_ON_PMI | DEBUGCTLMSR_LBR);
+		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
+		break;
+	default:
+		if (is_lbr_msr(vcpu, index)) {
+			ret = true;
+			wrmsrl(index, data);
+		}
+	}
+
+out:
+	local_irq_enable();
+	return ret;
+}
+
+static bool intel_pmu_get_lbr_msr(struct kvm_vcpu *vcpu,
+				  struct msr_data *msr_info)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	u32 index = msr_info->index;
+	bool ret = false;
+
+	/* The lbr event should have been allocated when reaching here. */
+	if (WARN_ON(!pmu->lbr_event))
+		return ret;
+
+	/*
+	 * Disable irq to ensure the lbr feature doesn't get reclaimed by the
+	 * host at the time the value is read from the msr, this avoids the
+	 * host lbr value to be leaked to the guest. If lbr has been reclaimed,
+	 * return 0 on guest reads.
+	 */
+	local_irq_disable();
+	if (pmu->lbr_event->oncpu == -1) {
+		msr_info->data = 0;
+		goto out;
+	}
+
+	switch (index) {
+	case MSR_IA32_DEBUGCTLMSR:
+		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
+		ret = true;
+		break;
+	default:
+		if (is_lbr_msr(vcpu, index)) {
+			ret = true;
+			rdmsrl(index, msr_info->data);
+		}
+	}
+
+out:
+	local_irq_enable();
+	return ret;
+}
+
+static bool intel_pmu_access_lbr_msr(struct kvm_vcpu *vcpu,
+				     struct msr_data *msr_info,
+				     bool set)
+{
+	u32 index = msr_info->index;
+	bool ret = false;
+
+	/* Return false if the msr access has nothing to do with lbr. */
+	if ((index != MSR_IA32_DEBUGCTLMSR) && !is_lbr_msr(vcpu, index))
+		return false;
+
+	/*
+	 * Guest initiated access is allowed when userspace has explicitly
+	 * enabled lbr.
+	 */
+	if (!msr_info->host_initiated && !vcpu->kvm->arch.lbr_in_guest)
+		return false;
+
+	if (intel_pmu_create_lbr_event(vcpu))
+		return false;
+
+	if (set)
+		ret = intel_pmu_set_lbr_msr(vcpu, msr_info);
+	else
+		ret = intel_pmu_get_lbr_msr(vcpu, msr_info);
+
+	/*
+	 * If this is the guest's first access to an lbr related msr, pass
+	 * the lbr related msrs through to the guest for direct accesses.
+	 * It is possible in theory that a cpu pinned lbr event could take
+	 * over the lbr feature the moment after the pass-through is set
+	 * up via intel_pmu_set_intercept_for_lbr_msrs below. Don't worry,
+	 * because it will be double checked right before vm-entry to
+	 * ensure the lbr msrs are pass-throughed with the lbr being owned
+	 * by this vcpu's lbr event (see vcpu_enter_guest for more
+	 * details).
+	 */
+	if (ret && !vcpu->arch.pmu.lbr_used) {
+		vcpu->arch.pmu.lbr_used = true;
+		intel_pmu_set_intercept_for_lbr_msrs(vcpu, false);
+	}
+
+	return ret;
+}
+
 static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -408,6 +582,8 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			msr_info->data = pmc->eventsel;
 			return 0;
+		} else if (intel_pmu_access_lbr_msr(vcpu, msr_info, false)) {
+			return 0;
 		}
 	}
 
@@ -471,12 +647,39 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				reprogram_gp_counter(pmc, data);
 				return 0;
 			}
+		} else if (intel_pmu_access_lbr_msr(vcpu, msr_info, true)) {
+			return 0;
 		}
 	}
 
 	return 1;
 }
 
+static void intel_pmu_sched_in(struct kvm_vcpu *vcpu, int cpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	u64 guest_debugctl;
+
+	/*
+	 * The lbr feature was used in last vcpu time slice, so set the lbr
+	 * msrs interceptible so that we can capture whether it's used again
+	 * in this time slice.
+	 */
+	if (pmu->lbr_used) {
+		pmu->lbr_used = false;
+		intel_pmu_set_intercept_for_lbr_msrs(vcpu, true);
+	} else if (pmu->lbr_event) {
+		/*
+		 * The lbr feature wasn't used during last vcpu time slice
+		 * and the vcpu lbr event hasn't been freed, so it's time to
+		 * free the lbr event.
+		 */
+		guest_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
+		if (!(guest_debugctl & DEBUGCTLMSR_LBR))
+			intel_pmu_free_lbr_event(vcpu);
+	}
+}
+
 static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -574,6 +777,8 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 
 	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status =
 		pmu->global_ovf_ctrl = 0;
+
+	intel_pmu_free_lbr_event(vcpu);
 }
 
 struct kvm_pmu_ops intel_pmu_ops = {
@@ -587,6 +792,7 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.lbr_enable = intel_pmu_lbr_enable,
 	.get_msr = intel_pmu_get_msr,
 	.set_msr = intel_pmu_set_msr,
+	.sched_in = intel_pmu_sched_in,
 	.refresh = intel_pmu_refresh,
 	.init = intel_pmu_init,
 	.reset = intel_pmu_reset,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 074385c..af1a1f9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3557,8 +3557,8 @@ static __always_inline void vmx_enable_intercept_for_msr(unsigned long *msr_bitm
 	}
 }
 
-static __always_inline void vmx_set_intercept_for_msr(unsigned long *msr_bitmap,
-			     			      u32 msr, int type, bool value)
+void vmx_set_intercept_for_msr(unsigned long *msr_bitmap, u32 msr, int type,
+			       bool value)
 {
 	if (value)
 		vmx_enable_intercept_for_msr(msr_bitmap, msr, type);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 82d0bc3..85acaf0 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -328,6 +328,8 @@ void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu);
 bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu);
 void vmx_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked);
 void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
+void vmx_set_intercept_for_msr(unsigned long *msr_bitmap, u32 msr, int type,
+			       bool value);
 struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7a7cd93..b76f019 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9294,6 +9294,8 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
 	vcpu->arch.l1tf_flush_l1d = true;
+
+	kvm_pmu_sched_in(vcpu, cpu);
 	kvm_x86_ops->sched_in(vcpu, cpu);
 }
 
-- 
2.7.4

