Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6103A1F81B0
	for <lists+kvm@lfdr.de>; Sat, 13 Jun 2020 10:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgFMIMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Jun 2020 04:12:07 -0400
Received: from mga07.intel.com ([134.134.136.100]:64586 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726538AbgFMIMC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Jun 2020 04:12:02 -0400
IronPort-SDR: XTBFLHg8hQ8qRg5nYPRUGrjkxV16EE6modBjI7IZIA0aBbDdWzQYJeHNKFbNx1AQTT4xfGwDah
 VcSwPq/ycdOQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2020 01:11:29 -0700
IronPort-SDR: MD26/cXuaZr5OmUoJIq/1HbTSaDeBW97q3yFzz90PlKZqelc54cq2imr6NSvnUDI0n0QXf6OyF
 jzEZfD/Pkm0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,506,1583222400"; 
   d="scan'208";a="474467427"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 13 Jun 2020 01:11:25 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v12 08/11] KVM: vmx/pmu: Pass-through LBR msrs when guest LBR event is scheduled
Date:   Sat, 13 Jun 2020 16:09:53 +0800
Message-Id: <20200613080958.132489-9-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200613080958.132489-1-like.xu@linux.intel.com>
References: <20200613080958.132489-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest first access on the LBR related msrs (including DEBUGCTLMSR and
records msrs) is always interceptible. The KVM handler would create a guest
LBR event which enables the callstack mode and none of hardware counter is
assigned. The host perf would schedule and enable this event as usual but
in an exclusive way.

If the guest LBR event is scheduled on with the corresponding vcpu context,
KVM will pass-through all LBR records msrs to the guest. The LBR callstack
mechanism implemented in the host could helps save/restore the guest LBR
records during the event context switches, which reduces a lot of overhead
if we save/restore tens of LBR msrs (e.g. 32 LBR records entries) in the
much more frequent VMX transitions.

To avoid reclaiming LBR resources from any higher priority event on host,
KVM would always check the exist of guest LBR event and its state before
vm-entry as late as possible. A negative result would cancel the
pass-through state, and it also prevents real registers accesses and
potential data leakage. If host reclaims the LBR between two checks, the
interception state and LBR records can be safely preserved due to native
save/restore support from guest LBR event.

The KVM emits a pr_warn() when the LBR hardware is unavailable to the
guest LBR event. The administer is supposed to reminder users that the
guest result may be inaccurate if someone is using LBR to record
hypervisor on the host side.

The guest LBR event will be released when the vPMU is reset but soon,
the lazy release mechanism would be applied to this event like a
regular vPMC.

Suggested-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 138 ++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c       |  70 +++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h       |   8 ++
 3 files changed, 212 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index d92e95b64c74..a78c440ebff2 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -175,6 +175,24 @@ static inline bool lbr_is_enabled(struct kvm_vcpu *vcpu)
 	return lbr->nr && (vcpu->arch.perf_capabilities & PMU_CAP_LBR_FMT);
 }
 
+static bool intel_is_valid_lbr_record_msr(struct kvm_vcpu *vcpu, u32 index)
+{
+	struct x86_pmu_lbr *lbr = &to_vmx(vcpu)->lbr_desc.lbr;
+	bool ret = false;
+
+	if (!lbr_is_enabled(vcpu))
+		return ret;
+
+	ret =  (index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS) ||
+		(index >= lbr->from && index < lbr->from + lbr->nr) ||
+		(index >= lbr->to && index < lbr->to + lbr->nr);
+
+	if (!ret && lbr->info)
+		ret = (index >= lbr->info && index < lbr->info + lbr->nr);
+
+	return ret;
+}
+
 static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -194,7 +212,8 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
-			get_fixed_pmc(pmu, msr) || get_fw_gp_pmc(pmu, msr);
+			get_fixed_pmc(pmu, msr) || get_fw_gp_pmc(pmu, msr) ||
+			intel_is_valid_lbr_record_msr(vcpu, msr);
 		break;
 	}
 
@@ -213,6 +232,113 @@ static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
 	return pmc;
 }
 
+static int intel_pmu_create_lbr_event(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct lbr_desc *lbr_desc = &to_vmx(vcpu)->lbr_desc;
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
+		.config = INTEL_FIXED_VLBR_EVENT,
+		.sample_type = PERF_SAMPLE_BRANCH_STACK,
+		.pinned = true,
+		.exclude_host = true,
+		.branch_sample_type = PERF_SAMPLE_BRANCH_CALL_STACK |
+					PERF_SAMPLE_BRANCH_USER,
+	};
+
+	if (unlikely(lbr_desc->event))
+		return 0;
+
+	event = perf_event_create_kernel_counter(&attr, -1,
+						current, NULL, NULL);
+	if (IS_ERR(event)) {
+		pr_debug_ratelimited("%s: failed %ld\n",
+					__func__, PTR_ERR(event));
+		return -ENOENT;
+	}
+	lbr_desc->event = event;
+	pmu->event_count++;
+	return 0;
+}
+
+static void intel_pmu_free_lbr_event(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct lbr_desc *lbr_desc = &to_vmx(vcpu)->lbr_desc;
+	struct perf_event *event = lbr_desc->event;
+
+	if (!event)
+		return;
+
+	perf_event_release_kernel(event);
+	lbr_desc->event = NULL;
+	pmu->event_count--;
+}
+
+/*
+ * It's safe to access LBR msrs from guest when they have not
+ * been passthrough since the host would help restore or reset
+ * the LBR msrs records when the guest LBR event is scheduled in.
+ */
+static bool access_lbr_record_msr(struct kvm_vcpu *vcpu,
+				     struct msr_data *msr_info, bool read)
+{
+	struct lbr_desc *lbr_desc = &to_vmx(vcpu)->lbr_desc;
+	u32 index = msr_info->index;
+
+	if (!intel_is_valid_lbr_record_msr(vcpu, index))
+		return false;
+
+	if (msr_info->host_initiated)
+		goto dummy;
+
+	if (!lbr_desc->event && !intel_pmu_create_lbr_event(vcpu))
+		goto dummy;
+
+	/*
+	 * Disable irq to ensure the LBR feature doesn't get reclaimed by the
+	 * host at the time the value is read from the msr, and this avoids the
+	 * host LBR value to be leaked to the guest. If LBR has been reclaimed,
+	 * return 0 on guest reads.
+	 */
+	local_irq_disable();
+	if (lbr_desc->event->state == PERF_EVENT_STATE_ACTIVE) {
+		if (read)
+			rdmsrl(index, msr_info->data);
+		else
+			wrmsrl(index, msr_info->data);
+	} else if (read)
+		msr_info->data = 0;
+	local_irq_enable();
+
+	return true;
+
+dummy:
+	if (read)
+		msr_info->data = 0;
+	return true;
+}
+
 static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -256,7 +382,8 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			msr_info->data = pmc->eventsel;
 			return 0;
-		}
+		} else if (access_lbr_record_msr(vcpu, msr_info, true))
+			return 0;
 	}
 
 	return 1;
@@ -354,6 +481,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data & ~vcpu_get_supported_debugctl(vcpu))
 			return 1;
 		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
+		if (!msr_info->host_initiated && !to_vmx(vcpu)->lbr_desc.event)
+			intel_pmu_create_lbr_event(vcpu);
 		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
@@ -382,7 +511,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				reprogram_gp_counter(pmc, data);
 				return 0;
 			}
-		}
+		} else if (access_lbr_record_msr(vcpu, msr_info, false))
+			return 0;
 	}
 
 	return 1;
@@ -483,6 +613,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 	vcpu->arch.perf_capabilities = guest_cpuid_has(vcpu, X86_FEATURE_PDCM) ?
 		vmx_get_perf_capabilities() : 0;
 	lbr_desc->lbr.nr = 0;
+	lbr_desc->event = NULL;
 }
 
 static void intel_pmu_reset(struct kvm_vcpu *vcpu)
@@ -507,6 +638,7 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 
 	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status =
 		pmu->global_ovf_ctrl = 0;
+	intel_pmu_free_lbr_event(vcpu);
 }
 
 struct kvm_pmu_ops intel_pmu_ops = {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 08e26a9518c2..58a8af433741 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3857,6 +3857,71 @@ void pt_update_intercept_for_msr(struct vcpu_vmx *vmx)
 	}
 }
 
+static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
+{
+	unsigned long *msr_bitmap = to_vmx(vcpu)->vmcs01.msr_bitmap;
+	struct x86_pmu_lbr *lbr = &to_vmx(vcpu)->lbr_desc.lbr;
+	int i;
+
+	WARN_ON_ONCE(!lbr->nr);
+
+	vmx_set_intercept_for_msr(msr_bitmap, MSR_LBR_SELECT, MSR_TYPE_RW, set);
+	vmx_set_intercept_for_msr(msr_bitmap, MSR_LBR_TOS, MSR_TYPE_RW, set);
+	for (i = 0; i < lbr->nr; i++) {
+		vmx_set_intercept_for_msr(msr_bitmap,
+			lbr->from + i, MSR_TYPE_RW, set);
+		vmx_set_intercept_for_msr(msr_bitmap,
+			lbr->to + i, MSR_TYPE_RW, set);
+		if (lbr->info)
+			vmx_set_intercept_for_msr(msr_bitmap,
+				lbr->info + i, MSR_TYPE_RW, set);
+	}
+}
+
+static inline void vmx_lbr_disable_passthrough(struct kvm_vcpu *vcpu)
+{
+	vmx_update_intercept_for_lbr_msrs(vcpu, true);
+}
+
+static inline void vmx_lbr_enable_passthrough(struct kvm_vcpu *vcpu)
+{
+	vmx_update_intercept_for_lbr_msrs(vcpu, false);
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
+static void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
+{
+	struct lbr_desc *lbr_desc = &to_vmx(vcpu)->lbr_desc;
+
+	if (!lbr_desc->event) {
+		vmx_lbr_disable_passthrough(vcpu);
+		if (vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR)
+			goto warn;
+		return;
+	}
+
+	if (lbr_desc->event->state < PERF_EVENT_STATE_ACTIVE) {
+		vmx_lbr_disable_passthrough(vcpu);
+		goto warn;
+	} else
+		vmx_lbr_enable_passthrough(vcpu);
+
+	return;
+
+warn:
+	pr_warn_ratelimited("kvm: vcpu-%d: fail to passthrough LBR.\n",
+		vcpu->vcpu_id);
+}
+
 static bool vmx_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -6728,8 +6793,11 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	pt_guest_enter(vmx);
 
-	if (vcpu_to_pmu(vcpu)->version)
+	if (vcpu_to_pmu(vcpu)->version) {
 		atomic_switch_perf_msrs(vmx);
+		if (vcpu->arch.perf_capabilities & PMU_CAP_LBR_FMT)
+			vmx_passthrough_lbr_msrs(vcpu);
+	}
 	atomic_switch_umwait_control_msr(vmx);
 
 	if (enable_preemption_timer)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index ef24338b194d..c67ce758412e 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -94,6 +94,14 @@ struct pt_desc {
 struct lbr_desc {
 	/* Basic information about LBR records. */
 	struct x86_pmu_lbr lbr;
+
+	/*
+	 * Emulate LBR feature via passthrough LBR registers when the
+	 * per-vcpu guest LBR event is scheduled on the current pcpu.
+	 *
+	 * The records may be inaccurate if the host reclaims the LBR.
+	 */
+	struct perf_event *event;
 };
 
 /*
-- 
2.21.3

