Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 805EB183F15
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 03:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgCMCTU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 22:19:20 -0400
Received: from mga14.intel.com ([192.55.52.115]:25868 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbgCMCTT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 22:19:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 19:19:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,546,1574150400"; 
   d="scan'208";a="261743856"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 12 Mar 2020 19:19:13 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Liang Kan <kan.liang@linux.intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Like Xu <like.xu@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v9 07/10] KVM: x86/pmu: Add LBR feature emulation via guest LBR event
Date:   Fri, 13 Mar 2020 10:16:13 +0800
Message-Id: <20200313021616.112322-8-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200313021616.112322-1-like.xu@linux.intel.com>
References: <20200313021616.112322-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMX transition is much more frequent than vcpu switching, and saving/
restoring tens of LBR MSRs (e.g. 32 LBR stack entries) brings too much
overhead to the frequent vmx transition itself, which is not necessary.
So the guest LBR stack msrs only gets saved/restored on the vcpu context
switching via the help of native LBR event callstack mechanism. Generally,
the LBR-related MSRs and its functionality are emulated in this way:

The guest first access on the LBR related MSRs (including DEBUGCTLMSR
and stack msrs) is always interceptible. The KVM hanlder would create
a guest LBR event which enables the callstack mode and none of hardware
counter is assigned. The host perf would enable and schedule this event
as usual. When the guest LBR event exists and the LBR stack is available
(defined as 'event->oncpu != -1'), the LBR stack msrs access would not
be intercepted but pass-through to the vcpu before vm-entry. This kind
of availability check is always performed before vm-entry, but as late
as possible to avoid reclaiming resources from any higher priority LBR
event. A negative check result would bring the interception back, and
prevent real registers accesses and potential data leakage.

At this point, vPMU only supports architecture v2 and the guest PMI
handler enables LBR via DEBUGCTLMSR rather than GLOBAL_OVF_CTRL. So
when the guest sets the enable bit, the DEBUGCTLMSR trap will ensure
the LBRS_FROZEN bit is cleared on any host with v4 or higher PMU and
the LBR facility could record as guest expected. The guest LBR event
will be released when the vPMU is reset but in next step, the lazy
release mechanism would be applied to this event like a regular vPMC.

Suggested-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |   4 +
 arch/x86/kvm/pmu.c              |   7 ++
 arch/x86/kvm/pmu.h              |   7 ++
 arch/x86/kvm/vmx/pmu_intel.c    | 199 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c          |   4 +-
 arch/x86/kvm/vmx/vmx.h          |   2 +
 arch/x86/kvm/x86.c              |  12 ++
 7 files changed, 230 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b87d2ab28b0e..b4c1761ca783 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -502,6 +502,10 @@ struct kvm_pmu {
 	 * redundant check before cleanup if guest don't use vPMU at all.
 	 */
 	u8 event_count;
+
+	/* Last Branch Recording Emulation */
+	struct perf_event *lbr_event;
+	bool lbr_is_availabile;
 };
 
 struct kvm_pmu_ops;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 306a79af0d0e..84b5ec50ca6d 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -434,6 +434,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 	init_irq_work(&pmu->irq_work, kvm_pmi_trigger_fn);
 	pmu->event_count = 0;
 	pmu->need_cleanup = false;
+	pmu->lbr_is_availabile = false;
 	kvm_pmu_refresh(vcpu);
 }
 
@@ -526,3 +527,9 @@ bool kvm_pmu_lbr_setup(struct kvm_vcpu *vcpu)
 
 	return false;
 }
+
+void kvm_pmu_availability_check(struct kvm_vcpu *vcpu)
+{
+	if (kvm_x86_ops->pmu_ops->availability_check)
+		kvm_x86_ops->pmu_ops->availability_check(vcpu);
+}
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index c0fb092f985e..3ddff3972b8d 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -38,8 +38,14 @@ struct kvm_pmu_ops {
 	void (*init)(struct kvm_vcpu *vcpu);
 	void (*reset)(struct kvm_vcpu *vcpu);
 	bool (*lbr_setup)(struct kvm_vcpu *vcpu);
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
@@ -157,6 +163,7 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu);
 void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
 bool kvm_pmu_lbr_setup(struct kvm_vcpu *vcpu);
+void kvm_pmu_availability_check(struct kvm_vcpu *vcpu);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index eef11e716570..92627f31cda3 100644
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
 
+static inline bool intel_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
+{
+	struct x86_pmu_lbr *stack = &vcpu->kvm->arch.lbr_stack;
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
 
@@ -184,6 +205,120 @@ static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
 	return pmc;
 }
 
+/*
+ * "set = true" to make the LBR stack msrs interceptible,
+ * otherwise pass through the LBR stack msrs to the guest.
+ */
+static void intel_pmu_set_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu,
+						  bool set)
+{
+	unsigned long *msr_bitmap = to_vmx(vcpu)->vmcs01.msr_bitmap;
+	struct x86_pmu_lbr *stack = &vcpu->kvm->arch.lbr_stack;
+	int i;
+
+	vmx_set_intercept_for_msr(msr_bitmap, MSR_LBR_SELECT, MSR_TYPE_RW, set);
+	vmx_set_intercept_for_msr(msr_bitmap, MSR_LBR_TOS, MSR_TYPE_RW, set);
+	for (i = 0; i < stack->nr; i++) {
+		vmx_set_intercept_for_msr(msr_bitmap, stack->from + i,
+					MSR_TYPE_RW, set);
+		vmx_set_intercept_for_msr(msr_bitmap, stack->to + i,
+					MSR_TYPE_RW, set);
+		if (stack->info)
+			vmx_set_intercept_for_msr(msr_bitmap,
+					stack->info + i, MSR_TYPE_RW, set);
+	}
+}
+
+int intel_pmu_create_lbr_event(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct perf_event *event;
+
+	/*
+	 * The perf_event_attr is constructed in the minimum efficient way:
+	 * - set 'pinned = true' to make it task pinned so that if another
+	 *   cpu pinned event reclaims LBR, the event->oncpu will be set to -1;
+	 * - set 'sample_type = PERF_SAMPLE_BRANCH_STACK' and 'exclude_host =
+	 *   true' to mark it as a guest LBR event which indicates host perf
+	 *   to schedule it without any hw counter but a fake one,
+	 *   check is_guest_lbr_event() and intel_guest_event_constraints();
+	 * - set 'branch_sample_type = PERF_SAMPLE_BRANCH_CALL_STACK |
+	 *   PERF_SAMPLE_BRANCH_USER' to configure it as a callstack LBR event.
+	 *   which allocs ctx->task_ctx_data and request host perf subsystem
+	 *   to save/restore guest LBR stack during host context switches,
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
+	if (pmu->lbr_event)
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
+void intel_pmu_free_lbr_event(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct perf_event *event = pmu->lbr_event;
+
+	if (!event)
+		return;
+
+	perf_event_release_kernel(event);
+	intel_pmu_set_intercept_for_lbr_msrs(vcpu, true);
+	pmu->lbr_is_availabile = false;
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
+	 * host at the time the value is read from the msr, this avoids the
+	 * host lbr value to be leaked to the guest. If lbr has been reclaimed,
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
@@ -203,6 +338,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		msr_info->data = pmu->global_ovf_ctrl;
 		return 0;
+	case MSR_IA32_DEBUGCTLMSR:
+		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
 			u64 val = pmc_read_counter(pmc);
@@ -217,7 +355,8 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			msr_info->data = pmc->eventsel;
 			return 0;
-		}
+		} else if (intel_pmu_access_lbr_msr(vcpu, msr_info, true))
+			return 0;
 	}
 
 	return 1;
@@ -261,6 +400,22 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
+	case MSR_IA32_DEBUGCTLMSR:
+		/* Values other than LBR are reserved and should throw a #GP */
+		if (data & ~(DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI))
+			return 1;
+		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
+		if (data && !intel_pmu_create_lbr_event(vcpu) &&
+			event_is_oncpu(pmu->lbr_event)) {
+			/*
+			 * On the host with v4 PMU, the LBR starts to
+			 * record when the enable bit is set in debugctl
+			 * and LBRS_FROZEN is cleared in the global status.
+			 */
+			wrmsrl_safe(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
+					GLOBAL_STATUS_LBRS_FROZEN);
+		}
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
 			if (!msr_info->host_initiated)
@@ -283,7 +438,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				reprogram_gp_counter(pmc, data);
 				return 0;
 			}
-		}
+		} else if (intel_pmu_access_lbr_msr(vcpu, msr_info, false))
+			return 0;
 	}
 
 	return 1;
@@ -396,6 +552,8 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 		pmc->counter = 0;
 	}
 
+	intel_pmu_free_lbr_event(vcpu);
+
 	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status =
 		pmu->global_ovf_ctrl = 0;
 }
@@ -428,6 +586,40 @@ static bool intel_pmu_setup_lbr(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+void intel_pmu_lbr_availability_check(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	/*
+	 * the LBR stack gets reclaimed via IPI calls, so checking of
+	 * lbr_event->oncpu needs to be in an atomic context.
+	 * Use assertion to confirm that irq has already been disabled.
+	 */
+	lockdep_assert_irqs_disabled();
+
+	if (pmu->lbr_is_availabile && event_is_oncpu(pmu->lbr_event))
+		return;
+
+	if (!pmu->lbr_is_availabile && !event_is_oncpu(pmu->lbr_event))
+		return;
+
+	if (event_is_oncpu(pmu->lbr_event)) {
+		intel_pmu_set_intercept_for_lbr_msrs(vcpu, false);
+		pmu->lbr_is_availabile = true;
+	} else {
+		intel_pmu_set_intercept_for_lbr_msrs(vcpu, true);
+		pmu->lbr_is_availabile = false;
+	}
+}
+
+void intel_pmu_availability_check(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	if (vcpu->kvm->arch.lbr_in_guest && unlikely(pmu->lbr_event))
+		intel_pmu_lbr_availability_check(vcpu);
+}
+
 struct kvm_pmu_ops intel_pmu_ops = {
 	.find_arch_event = intel_find_arch_event,
 	.find_fixed_event = intel_find_fixed_event,
@@ -443,4 +635,5 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.init = intel_pmu_init,
 	.reset = intel_pmu_reset,
 	.lbr_setup = intel_pmu_setup_lbr,
+	.availability_check = intel_pmu_availability_check,
 };
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 57742ddfd854..c13c2b00bb16 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3682,8 +3682,8 @@ static __always_inline void vmx_enable_intercept_for_msr(unsigned long *msr_bitm
 	}
 }
 
-static __always_inline void vmx_set_intercept_for_msr(unsigned long *msr_bitmap,
-			     			      u32 msr, int type, bool value)
+void vmx_set_intercept_for_msr(unsigned long *msr_bitmap,
+				u32 msr, int type, bool value)
 {
 	if (value)
 		vmx_enable_intercept_for_msr(msr_bitmap, msr, type);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index e64da06c7009..a0644eef5631 100644
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
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ce6b0326a1ad..3771d5fb2524 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8338,6 +8338,18 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 */
 	smp_mb__after_srcu_read_unlock();
 
+	/*
+	 * Higher priority host perf events (e.g. cpu pinned) could reclaim the
+	 * pmu resources (e.g. lbr) that were assigned to the guest. This is
+	 * usually done via ipi calls (more details in perf_install_in_context).
+	 *
+	 * Before entering the non-root mode (with irq disabled here), double
+	 * confirm that the pmu features enabled to the guest are not reclaimed
+	 * by higher priority host events. Otherwise, disallow vcpu's access to
+	 * the reclaimed features.
+	 */
+	kvm_pmu_availability_check(vcpu);
+
 	/*
 	 * This handles the case where a posted interrupt was
 	 * notified with kvm_vcpu_kick.
-- 
2.21.1

