Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1D81B5714
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 10:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgDWISD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 04:18:03 -0400
Received: from mga18.intel.com ([134.134.136.126]:57581 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726939AbgDWISC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 04:18:02 -0400
IronPort-SDR: JcIKQUBUbIM5NgFKLrHtjs8vSx2gPzlYPgKqA60Lh0lw1WDbm9Jgt57wsx0XE4vyL8uO7Yb4kz
 FjDDCt6ciGmQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 01:18:01 -0700
IronPort-SDR: hFrHCninqD9YsRzxP/bzn3hOVnU7+JVcJCZY/XB6HYgXVjF4NLuD1ooK/yK969TctOCKu5aAc1
 8KU6Wzu7WivA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,306,1583222400"; 
   d="scan'208";a="255910120"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 23 Apr 2020 01:17:58 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei.w.wang@intel.com,
        ak@linux.intel.com, Like Xu <like.xu@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v10 08/11] KVM: x86/pmu: Add LBR feature emulation via guest LBR event
Date:   Thu, 23 Apr 2020 16:14:09 +0800
Message-Id: <20200423081412.164863-9-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200423081412.164863-1-like.xu@linux.intel.com>
References: <20200423081412.164863-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMX transition is much more frequent than vcpu switching, and saving/
restoring tens of LBR msrs (e.g. 32 LBR records entries) brings too much
overhead to the frequent vmx transition itself, which is not necessary.
So the guest LBR records only gets saved/restored on the vcpu context
switching via the help of native LBR event callstack mechanism. Generally,
the LBR-related msrs and its functionality are emulated in this way:

The guest first access on the LBR related msrs (including DEBUGCTLMSR
and records msrs) is always interceptible. The KVM handler would create
a guest LBR event which enables the callstack mode and none of hardware
counter is assigned. The host perf would enable and schedule this event
as usual but in an exclusive way.

When the guest LBR event exists and the LBR stack is available (defined
as 'event->oncpu != -1'), the LBR records msrs access would not be
intercepted but pass-through to the vcpu before vm-entry. This kind
of availability check is always performed before vm-entry, but as late
as possible to avoid reclaiming resources from any higher priority event.
A negative check result would bring the registers interception back, and
it also prevents real registers accesses and potential data leakage.

At this point, vPMU only supports Architecture v2 and the guest needs
to re-enable LBR via DEBUGCTLMSR in the guest PMI handler. The guest
LBR event will be released when the vPMU is reset but soon, the lazy
release mechanism would be applied to this event like a regular vPMC.

Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Suggested-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  11 ++
 arch/x86/kvm/pmu.c              |   6 +-
 arch/x86/kvm/pmu.h              |   7 +
 arch/x86/kvm/vmx/pmu_intel.c    | 228 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c          |   9 +-
 arch/x86/kvm/vmx/vmx.h          |   2 +
 6 files changed, 256 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3a4433607773..f73c9b789bff 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -506,6 +506,17 @@ struct kvm_pmu {
 	 * redundant check before cleanup if guest don't use vPMU at all.
 	 */
 	u8 event_count;
+
+	/*
+	 * Emulate LBR feature via pass-through LBR registers when the
+	 * per-vcpu guest LBR event is scheduled on the current pcpu.
+	 *
+	 * Note the records could't be trusted if the host reclaims the LBR.
+	 */
+	struct perf_event *lbr_event;
+
+	/* A flag to reduce the overhead of LBR pass-through or cancellation. */
+	bool lbr_already_available;
 };
 
 struct kvm_pmu_ops;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index b24b19ede76a..5776d305e254 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -378,8 +378,11 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 {
-	if (lapic_in_kernel(vcpu))
+	if (lapic_in_kernel(vcpu)) {
 		kvm_apic_local_deliver(vcpu->arch.apic, APIC_LVTPC);
+		if (kvm_x86_ops.pmu_ops->deliver_pmi)
+			kvm_x86_ops.pmu_ops->deliver_pmi(vcpu);
+	}
 }
 
 bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
@@ -434,6 +437,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 	init_irq_work(&pmu->irq_work, kvm_pmi_trigger_fn);
 	pmu->event_count = 0;
 	pmu->need_cleanup = false;
+	pmu->lbr_already_available = false;
 	kvm_pmu_refresh(vcpu);
 }
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 19d8e057c0b5..594642ab2575 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -38,8 +38,15 @@ struct kvm_pmu_ops {
 	void (*init)(struct kvm_vcpu *vcpu);
 	void (*reset)(struct kvm_vcpu *vcpu);
 	bool (*lbr_setup)(struct kvm_vcpu *vcpu);
+	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
+	void (*availability_check)(struct kvm_vcpu *vcpu);
 };
 
+static inline bool event_is_oncpu(struct perf_event *event)
+{
+	return event && event->oncpu != -1;
+}
+
 static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 5d7d002e5a3e..bb8e4dccbb18 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -17,6 +17,7 @@
 #include "lapic.h"
 #include "nested.h"
 #include "pmu.h"
+#include "vmx.h"
 
 static struct kvm_event_hw_type_mapping intel_arch_events[] = {
 	/* Index must match CPUID 0x0A.EBX bit vector */
@@ -150,6 +151,24 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 	return &counters[array_index_nospec(idx, num_counters)];
 }
 
+static bool intel_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
+{
+	struct x86_pmu_lbr *stack = &vcpu->kvm->arch.lbr;
+	bool ret = false;
+
+	if (!vcpu->kvm->arch.lbr_in_guest)
+		return ret;
+
+	ret = (index == MSR_LBR_SELECT || index == MSR_LBR_TOS ||
+		(index >= stack->from && index < stack->from + stack->nr) ||
+		(index >= stack->to && index < stack->to + stack->nr));
+
+	if (!ret && stack->info)
+		ret = (index >= stack->info && index < stack->info + stack->nr);
+
+	return ret;
+}
+
 static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -160,12 +179,14 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_CORE_PERF_GLOBAL_STATUS:
 	case MSR_CORE_PERF_GLOBAL_CTRL:
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
+	case MSR_IA32_DEBUGCTLMSR:
 		ret = pmu->version > 1;
 		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
-			get_fixed_pmc(pmu, msr);
+			get_fixed_pmc(pmu, msr) ||
+			intel_is_valid_lbr_msr(vcpu, msr);
 		break;
 	}
 
@@ -184,6 +205,124 @@ static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
 	return pmc;
 }
 
+static int intel_pmu_create_lbr_event(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct perf_event *event;
+
+	/*
+	 * The perf_event_attr is constructed in the minimum efficient way:
+	 * - set 'pinned = true' to make it task pinned so that if another
+	 *   cpu pinned event reclaims LBR, the event->oncpu will be set to -1;
+	 *
+	 * - set 'sample_type = PERF_SAMPLE_BRANCH_STACK' and
+	 *   'exclude_host = true' to mark it as a guest LBR event which
+	 *   indicates host perf to schedule it without but a fake counter,
+	 *   check is_guest_lbr_event() and intel_guest_event_constraints();
+	 *
+	 * - set 'branch_sample_type = PERF_SAMPLE_BRANCH_CALL_STACK |
+	 *   PERF_SAMPLE_BRANCH_USER' to configure it to use callstack mode,
+	 *   which allocs 'ctx->task_ctx_data' and request host perf subsystem
+	 *   to save/restore guest LBR records during host context switches,
+	 *   check branch_user_callstack() and intel_pmu_lbr_sched_task();
+	 */
+	struct perf_event_attr attr = {
+		.type = PERF_TYPE_RAW,
+		.size = sizeof(attr),
+		.pinned = true,
+		.exclude_host = true,
+		.sample_type = PERF_SAMPLE_BRANCH_STACK,
+		.branch_sample_type = PERF_SAMPLE_BRANCH_CALL_STACK |
+					PERF_SAMPLE_BRANCH_USER,
+	};
+
+	if (unlikely(pmu->lbr_event))
+		return 0;
+
+	event = perf_event_create_kernel_counter(&attr, -1,
+						current, NULL, NULL);
+	if (IS_ERR(event)) {
+		pr_debug_ratelimited("%s: failed %ld\n",
+					__func__, PTR_ERR(event));
+		return -ENOENT;
+	}
+	pmu->lbr_event = event;
+	pmu->event_count++;
+	return 0;
+}
+
+/*
+ * "set = true" to make the LBR records registers interceptible,
+ * otherwise passthrough the LBR records registers to the vcpu.
+ */
+static void intel_pmu_intercept_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
+{
+	unsigned long *msr_bitmap = to_vmx(vcpu)->vmcs01.msr_bitmap;
+	struct x86_pmu_lbr *stack = &vcpu->kvm->arch.lbr;
+	int i;
+
+	if (!stack->nr)
+		return;
+
+	for (i = 0; i < stack->nr; i++) {
+		vmx_set_intercept_for_msr(msr_bitmap,
+				stack->from + i, MSR_TYPE_RW, set);
+		vmx_set_intercept_for_msr(msr_bitmap,
+				stack->to + i, MSR_TYPE_RW, set);
+		if (stack->info)
+			vmx_set_intercept_for_msr(msr_bitmap,
+				stack->info + i, MSR_TYPE_RW, set);
+	}
+	vmx_set_intercept_for_msr(msr_bitmap, MSR_LBR_SELECT, MSR_TYPE_RW, set);
+	vmx_set_intercept_for_msr(msr_bitmap, MSR_LBR_TOS, MSR_TYPE_RW, set);
+}
+
+static void intel_pmu_free_lbr_event(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct perf_event *event = pmu->lbr_event;
+
+	if (!event)
+		return;
+
+	perf_event_release_kernel(event);
+	intel_pmu_intercept_lbr_msrs(vcpu, true);
+	pmu->lbr_already_available = false;
+	pmu->event_count--;
+	pmu->lbr_event = NULL;
+}
+
+static bool intel_pmu_access_lbr_msr(struct kvm_vcpu *vcpu,
+				     struct msr_data *msr_info, bool read)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	u32 index = msr_info->index;
+
+	if (!intel_is_valid_lbr_msr(vcpu, index))
+		return false;
+
+	if (!pmu->lbr_event)
+		intel_pmu_create_lbr_event(vcpu);
+
+	/*
+	 * Disable irq to ensure the LBR feature doesn't get reclaimed by the
+	 * host at the time the value is read from the msr, and this avoids the
+	 * host LBR value to be leaked to the guest. If LBR has been reclaimed,
+	 * return 0 on guest reads.
+	 */
+	local_irq_disable();
+	if (event_is_oncpu(pmu->lbr_event)) {
+		if (read)
+			rdmsrl(index, msr_info->data);
+		else
+			wrmsrl(index, msr_info->data);
+	} else if (read)
+		msr_info->data = 0;
+	local_irq_enable();
+
+	return true;
+}
+
 static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -203,6 +342,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		msr_info->data = pmu->global_ovf_ctrl;
 		return 0;
+	case MSR_IA32_DEBUGCTLMSR:
+		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
 			u64 val = pmc_read_counter(pmc);
@@ -217,7 +359,8 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			msr_info->data = pmc->eventsel;
 			return 0;
-		}
+		} else if (intel_pmu_access_lbr_msr(vcpu, msr_info, true))
+			return 0;
 	}
 
 	return 1;
@@ -261,6 +404,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
+	case MSR_IA32_DEBUGCTLMSR:
+		/* Values other than LBR are reserved and should throw a #GP */
+		if (data & ~(DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI))
+			return 1;
+		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
+		if (!pmu->lbr_event)
+			intel_pmu_create_lbr_event(vcpu);
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
 			if (!msr_info->host_initiated)
@@ -283,7 +434,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				reprogram_gp_counter(pmc, data);
 				return 0;
 			}
-		}
+		} else if (intel_pmu_access_lbr_msr(vcpu, msr_info, false))
+			return 0;
 	}
 
 	return 1;
@@ -397,6 +549,8 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 		pmc->counter = 0;
 	}
 
+	intel_pmu_free_lbr_event(vcpu);
+
 	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status =
 		pmu->global_ovf_ctrl = 0;
 }
@@ -430,6 +584,72 @@ static bool intel_pmu_lbr_setup(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static void intel_pmu_legacy_freezing_lbrs_on_pmi(struct kvm_vcpu *vcpu)
+{
+	u64 data;
+
+	if (!vcpu->kvm->arch.lbr_in_guest)
+		return;
+
+	/*
+	 * If Freeze_LBR_On_PMI = 1, the LBR is frozen on PMI and
+	 * the KVM emulates to clear the LBR bit (bit 0) in IA32_DEBUGCTL.
+	 *
+	 * Guest would then re-enable LBR to resume recording branches.
+	 */
+	data = vmcs_read64(GUEST_IA32_DEBUGCTL);
+	if (data & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI) {
+		data &= ~DEBUGCTLMSR_LBR;
+		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
+	}
+}
+
+static void intel_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
+{
+	u8 version = vcpu_to_pmu(vcpu)->version;
+
+	/* Freeze_LBR_on_PMI is supported for PMU version <= 3 and >1 */
+	if (version > 1 && version <= 3)
+		intel_pmu_legacy_freezing_lbrs_on_pmi(vcpu);
+}
+
+static void intel_pmu_lbr_availability_check(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	if (pmu->lbr_already_available && event_is_oncpu(pmu->lbr_event))
+		return;
+
+	if (!pmu->lbr_already_available && !event_is_oncpu(pmu->lbr_event))
+		return;
+
+	if (event_is_oncpu(pmu->lbr_event)) {
+		intel_pmu_intercept_lbr_msrs(vcpu, false);
+		pmu->lbr_already_available = true;
+	} else {
+		intel_pmu_intercept_lbr_msrs(vcpu, true);
+		pmu->lbr_already_available = false;
+	}
+}
+
+/*
+ * Higher priority host perf events (e.g. cpu pinned) could reclaim the
+ * pmu resources (e.g. LBR) that were assigned to the guest. This is
+ * usually done via ipi calls (more details in perf_install_in_context).
+ *
+ * Before entering the non-root mode (with irq disabled here), double
+ * confirm that the pmu features enabled to the guest are not reclaimed
+ * by higher priority host events. Otherwise, disallow vcpu's access to
+ * the reclaimed features.
+ */
+static void intel_pmu_availability_check(struct kvm_vcpu *vcpu)
+{
+	lockdep_assert_irqs_disabled();
+
+	if (vcpu->kvm->arch.lbr_in_guest && vcpu_to_pmu(vcpu)->lbr_event)
+		intel_pmu_lbr_availability_check(vcpu);
+}
+
 struct kvm_pmu_ops intel_pmu_ops = {
 	.find_arch_event = intel_find_arch_event,
 	.find_fixed_event = intel_find_fixed_event,
@@ -445,4 +665,6 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.init = intel_pmu_init,
 	.reset = intel_pmu_reset,
 	.lbr_setup = intel_pmu_lbr_setup,
+	.deliver_pmi = intel_pmu_deliver_pmi,
+	.availability_check = intel_pmu_availability_check,
 };
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 766303b31949..31c294b2d941 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3717,8 +3717,8 @@ static __always_inline void vmx_enable_intercept_for_msr(unsigned long *msr_bitm
 	}
 }
 
-static __always_inline void vmx_set_intercept_for_msr(unsigned long *msr_bitmap,
-			     			      u32 msr, int type, bool value)
+void vmx_set_intercept_for_msr(unsigned long *msr_bitmap,
+				u32 msr, int type, bool value)
 {
 	if (value)
 		vmx_enable_intercept_for_msr(msr_bitmap, msr, type);
@@ -6622,8 +6622,11 @@ static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	pt_guest_enter(vmx);
 
-	if (vcpu_to_pmu(vcpu)->version)
+	if (vcpu_to_pmu(vcpu)->version) {
 		atomic_switch_perf_msrs(vmx);
+		kvm_x86_ops.pmu_ops->availability_check(vcpu);
+	}
+
 	atomic_switch_umwait_control_msr(vmx);
 
 	if (enable_preemption_timer)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index edfb739e5907..e0845e1dab06 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -347,6 +347,8 @@ void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu);
 bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu);
 void vmx_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked);
 void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
+void vmx_set_intercept_for_msr(unsigned long *msr_bitmap,
+				u32 msr, int type, bool value);
 struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
-- 
2.21.1

