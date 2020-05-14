Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139461D2A2E
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 10:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgENIbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 04:31:41 -0400
Received: from mga18.intel.com ([134.134.136.126]:12089 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbgENIbi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 04:31:38 -0400
IronPort-SDR: W4Rt+hdlF8vci5HIRxf29XpmGvJ1o67WCAoQQKbjfid9qBzzaym/qOWHNgiG2XpjaAFqZbuO+p
 xv8i8eIM4YXw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 01:31:38 -0700
IronPort-SDR: oCtuCIo9U1CfvTSQf5RJmZv36XdFMFTEjgQYtcdujEGfbP1FaDUazar6pqMgXvXMZx+rqSUF4R
 hNYK6Mvh8ZnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,390,1583222400"; 
   d="scan'208";a="341540003"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga001.jf.intel.com with ESMTP; 14 May 2020 01:31:34 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, ak@linux.intel.com,
        wei.w.wang@intel.com, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v11 08/11] KVM: x86/pmu: Emulate LBR feature via guest LBR event
Date:   Thu, 14 May 2020 16:30:51 +0800
Message-Id: <20200514083054.62538-9-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200514083054.62538-1-like.xu@linux.intel.com>
References: <20200514083054.62538-1-like.xu@linux.intel.com>
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

At this point, vPMU only supports Architecture v2 and the guest needs
to re-enable LBR via DEBUGCTLMSR in the guest PMI handler. The guest
LBR event will be released when the vPMU is reset but soon, the lazy
release mechanism would be applied to this event like a regular vPMC.

The debugctl msr is handled separately in vmx/svm and they're not
completely identical, hence remove the common msr handling code.

Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Suggested-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |   9 ++
 arch/x86/kvm/pmu.c              |   5 +-
 arch/x86/kvm/pmu.h              |   6 +
 arch/x86/kvm/vmx/pmu_intel.c    | 220 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c          |   5 +-
 arch/x86/kvm/vmx/vmx.h          |   2 +
 arch/x86/kvm/x86.c              |  13 --
 7 files changed, 241 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8c3ae83f63d9..57b281c4b196 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -503,6 +503,14 @@ struct kvm_pmu {
 	 * redundant check before cleanup if guest don't use vPMU at all.
 	 */
 	u8 event_count;
+
+	/*
+	 * Emulate LBR feature via pass-through LBR registers when the
+	 * per-vcpu guest LBR event is scheduled on the current pcpu.
+	 *
+	 * The records may be inaccurate if the host reclaims the LBR.
+	 */
+	struct perf_event *lbr_event;
 };
 
 struct kvm_pmu_ops;
@@ -984,6 +992,7 @@ struct kvm_arch {
 	bool guest_can_read_msr_platform_info;
 	bool exception_payload_enabled;
 
+	struct x86_pmu_lbr lbr;
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
 };
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index b86346903f2e..5053f4238218 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -378,8 +378,11 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 {
-	if (lapic_in_kernel(vcpu))
+	if (lapic_in_kernel(vcpu)) {
+		if (kvm_x86_ops.pmu_ops->deliver_pmi)
+			kvm_x86_ops.pmu_ops->deliver_pmi(vcpu);
 		kvm_apic_local_deliver(vcpu->arch.apic, APIC_LVTPC);
+	}
 }
 
 bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index ab85eed8a6cc..ed96cbb40757 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -37,8 +37,14 @@ struct kvm_pmu_ops {
 	void (*refresh)(struct kvm_vcpu *vcpu);
 	void (*init)(struct kvm_vcpu *vcpu);
 	void (*reset)(struct kvm_vcpu *vcpu);
+	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
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
index 79e5bf36ffc8..8f9c837c7dca 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -17,6 +17,7 @@
 #include "lapic.h"
 #include "nested.h"
 #include "pmu.h"
+#include "vmx.h"
 
 static struct kvm_event_hw_type_mapping intel_arch_events[] = {
 	/* Index must match CPUID 0x0A.EBX bit vector */
@@ -150,6 +151,48 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 	return &counters[array_index_nospec(idx, num_counters)];
 }
 
+static bool lbr_is_enabled(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	if (likely(vcpu->kvm->arch.lbr.nr))
+		return true;
+
+	if (pmu->version < 2)
+		return false;
+
+	if (!(vcpu->arch.perf_capabilities & PERF_CAP_LBR_FMT))
+		return false;
+
+	/*
+	 * As a first step, a guest could only enable LBR feature if its cpu
+	 * model is the same as the host because the LBR registers would
+	 * be passthrough to the guest and they're model specific.
+	 */
+	if (boot_cpu_data.x86_model != guest_cpuid_model(vcpu))
+		return false;
+
+	return !x86_perf_get_lbr(&vcpu->kvm->arch.lbr);
+}
+
+static bool intel_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
+{
+	struct x86_pmu_lbr *stack = &vcpu->kvm->arch.lbr;
+	bool ret = false;
+
+	if (!lbr_is_enabled(vcpu))
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
@@ -160,6 +203,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_CORE_PERF_GLOBAL_STATUS:
 	case MSR_CORE_PERF_GLOBAL_CTRL:
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
+	case MSR_IA32_DEBUGCTLMSR:
 		ret = pmu->version > 1;
 		break;
 	case MSR_IA32_PERF_CAPABILITIES:
@@ -168,7 +212,8 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
-			get_fixed_pmc(pmu, msr);
+			get_fixed_pmc(pmu, msr) ||
+			intel_is_valid_lbr_msr(vcpu, msr);
 		break;
 	}
 
@@ -187,6 +232,130 @@ static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
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
+	 * - set '.exclude_host = true' to record guest branches behavior;
+	 *
+	 * - set '.config = INTEL_FIXED_VLBR_EVENT' to indicates host perf
+	 *   schedule the event without a real HW counter but a fake one;
+	 *   check is_guest_lbr_event() and __intel_get_event_constraints();
+	 *
+	 * - set 'sample_type = PERF_SAMPLE_BRANCH_STACK' and
+	 *   'branch_sample_type = PERF_SAMPLE_BRANCH_CALL_STACK |
+	 *   PERF_SAMPLE_BRANCH_USER' to configure it as a LBR callstack
+	 *   event, which helps KVM to save/restore guest LBR records
+	 *   during host context switches and reduces quite a lot overhead,
+	 *   check branch_user_callstack() and intel_pmu_lbr_sched_task();
+	 */
+	struct perf_event_attr attr = {
+		.type = PERF_TYPE_RAW,
+		.size = sizeof(attr),
+		.pinned = true,
+		.exclude_host = true,
+		.config = INTEL_FIXED_VLBR_EVENT,
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
+	pmu->event_count--;
+	pmu->lbr_event = NULL;
+}
+
+/*
+ * It's safe to access LBR msrs from guest when they have not
+ * been passthrough since the host would help restore or reset
+ * the LBR msrs records when the guest LBR event is scheduled in.
+ */
+static bool intel_pmu_access_lbr_msr(struct kvm_vcpu *vcpu,
+				     struct msr_data *msr_info, bool read)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	u32 index = msr_info->index;
+
+	if (!intel_is_valid_lbr_msr(vcpu, index))
+		return false;
+
+	if (!msr_info->host_initiated && !pmu->lbr_event)
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
@@ -212,6 +381,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		msr_info->data = vcpu->arch.perf_capabilities;
 		return 0;
+	case MSR_IA32_DEBUGCTLMSR:
+		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
 			u64 val = pmc_read_counter(pmc);
@@ -226,7 +398,8 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			msr_info->data = pmc->eventsel;
 			return 0;
-		}
+		} else if (intel_pmu_access_lbr_msr(vcpu, msr_info, true))
+			return 0;
 	}
 
 	return 1;
@@ -280,6 +453,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		vcpu->arch.perf_capabilities = data;
 		return 0;
+	case MSR_IA32_DEBUGCTLMSR:
+		/* Values other than LBR are reserved and should throw a #GP */
+		if (data & ~(DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI))
+			return 1;
+		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
+		if (!msr_info->host_initiated && !pmu->lbr_event)
+			intel_pmu_create_lbr_event(vcpu);
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
 			if (!msr_info->host_initiated)
@@ -302,7 +483,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				reprogram_gp_counter(pmc, data);
 				return 0;
 			}
-		}
+		} else if (intel_pmu_access_lbr_msr(vcpu, msr_info, false))
+			return 0;
 	}
 
 	return 1;
@@ -421,6 +603,37 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 
 	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status =
 		pmu->global_ovf_ctrl = 0;
+	intel_pmu_free_lbr_event(vcpu);
+}
+
+/*
+ * Emulate LBR_On_PMI behavior for 1 < pmu.version < 4.
+ *
+ * If Freeze_LBR_On_PMI = 1, the LBR is frozen on PMI and
+ * the KVM emulates to clear the LBR bit (bit 0) in IA32_DEBUGCTL.
+ *
+ * Guest needs to re-enable LBR to resume branches recording.
+ */
+static void intel_pmu_legacy_freezing_lbrs_on_pmi(struct kvm_vcpu *vcpu)
+{
+	u64 data;
+
+	if (!lbr_is_enabled(vcpu))
+		return;
+
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
+	if (version > 1 && version < 4)
+		intel_pmu_legacy_freezing_lbrs_on_pmi(vcpu);
 }
 
 struct kvm_pmu_ops intel_pmu_ops = {
@@ -437,4 +650,5 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.refresh = intel_pmu_refresh,
 	.init = intel_pmu_init,
 	.reset = intel_pmu_reset,
+	.deliver_pmi = intel_pmu_deliver_pmi,
 };
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ee94d94e855a..9969d663826a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3748,8 +3748,8 @@ static __always_inline void vmx_enable_intercept_for_msr(unsigned long *msr_bitm
 	}
 }
 
-static __always_inline void vmx_set_intercept_for_msr(unsigned long *msr_bitmap,
-			     			      u32 msr, int type, bool value)
+void vmx_set_intercept_for_msr(unsigned long *msr_bitmap,
+				u32 msr, int type, bool value)
 {
 	if (value)
 		vmx_enable_intercept_for_msr(msr_bitmap, msr, type);
@@ -6698,6 +6698,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	if (vcpu_to_pmu(vcpu)->version)
 		atomic_switch_perf_msrs(vmx);
+
 	atomic_switch_umwait_control_msr(vmx);
 
 	if (enable_preemption_timer)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 298ddef79d00..1b6bb964badf 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -349,6 +349,8 @@ bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu);
 bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu);
 void vmx_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked);
 void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
+void vmx_set_intercept_for_msr(unsigned long *msr_bitmap,
+				u32 msr, int type, bool value);
 struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b577fadffb1d..8b4a5c6b206d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2815,18 +2815,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		}
 		break;
-	case MSR_IA32_DEBUGCTLMSR:
-		if (!data) {
-			/* We support the non-activated case already */
-			break;
-		} else if (data & ~(DEBUGCTLMSR_LBR | DEBUGCTLMSR_BTF)) {
-			/* Values other than LBR and BTF are vendor-specific,
-			   thus reserved and should throw a #GP */
-			return 1;
-		}
-		vcpu_unimpl(vcpu, "%s: MSR_IA32_DEBUGCTLMSR 0x%llx, nop\n",
-			    __func__, data);
-		break;
 	case 0x200 ... 0x2ff:
 		return kvm_mtrr_set_msr(vcpu, msr, data);
 	case MSR_IA32_APICBASE:
@@ -3083,7 +3071,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	switch (msr_info->index) {
 	case MSR_IA32_PLATFORM_ID:
 	case MSR_IA32_EBL_CR_POWERON:
-	case MSR_IA32_DEBUGCTLMSR:
 	case MSR_IA32_LASTBRANCHFROMIP:
 	case MSR_IA32_LASTBRANCHTOIP:
 	case MSR_IA32_LASTINTFROMIP:
-- 
2.21.3

