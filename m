Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45B522E0CA
	for <lists+kvm@lfdr.de>; Sun, 26 Jul 2020 17:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgGZPfE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jul 2020 11:35:04 -0400
Received: from mga03.intel.com ([134.134.136.65]:17603 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbgGZPfB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jul 2020 11:35:01 -0400
IronPort-SDR: vj/IGNBPO4vHPjqqBS8kN33pLl5ymCITw4rjrI2cIZya66Ln5mXXAaEOr81OPWPAfh2mkWNwwI
 TbKWLsm24kGw==
X-IronPort-AV: E=McAfee;i="6000,8403,9694"; a="150890982"
X-IronPort-AV: E=Sophos;i="5.75,399,1589266800"; 
   d="scan'208";a="150890982"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2020 08:35:00 -0700
IronPort-SDR: fqPlJUCJZrmydxakwXfGreiY+E+LJSnwfYc62Kl7U+6BSpBW4OjwFFD95Iwo4hLWea0RrnseDc
 3DvTK2at45+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,399,1589266800"; 
   d="scan'208";a="303177596"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 26 Jul 2020 08:34:57 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v13 06/10] KVM: vmx/pmu: Pass-through LBR msrs to when the guest LBR event is ACTIVE
Date:   Sun, 26 Jul 2020 23:32:25 +0800
Message-Id: <20200726153229.27149-8-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200726153229.27149-1-like.xu@linux.intel.com>
References: <20200726153229.27149-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In addition to DEBUGCTLMSR_LBR, any KVM trap caused by LBR msrs access
will result in a creation of guest LBR event per-vcpu.

If the guest LBR event is scheduled on with the corresponding vcpu context,
KVM will pass-through all LBR records msrs to the guest. The LBR callstack
mechanism implemented in the host could help save/restore the guest LBR
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

Suggested-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 131 ++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c       |   2 +
 arch/x86/kvm/vmx/vmx.h       |   1 +
 3 files changed, 131 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index db1d78ddabac..0358ceea34d4 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -201,6 +201,24 @@ bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
+{
+	struct x86_pmu_lbr *records = vcpu_to_lbr_records(vcpu);
+	bool ret = false;
+
+	if (!intel_pmu_lbr_is_enabled(vcpu))
+		return ret;
+
+	ret =  (index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS) ||
+		(index >= records->from && index < records->from + records->nr) ||
+		(index >= records->to && index < records->to + records->nr);
+
+	if (!ret && records->info)
+		ret = (index >= records->info && index < records->info + records->nr);
+
+	return ret;
+}
+
 static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -216,7 +234,8 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
-			get_fixed_pmc(pmu, msr) || get_fw_gp_pmc(pmu, msr);
+			get_fixed_pmc(pmu, msr) || get_fw_gp_pmc(pmu, msr) ||
+			intel_pmu_is_valid_lbr_msr(vcpu, msr);
 		break;
 	}
 
@@ -294,6 +313,46 @@ int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+/*
+ * It's safe to access LBR msrs from guest when they have not
+ * been passthrough since the host would help restore or reset
+ * the LBR msrs records when the guest LBR event is scheduled in.
+ */
+static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
+				     struct msr_data *msr_info, bool read)
+{
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
+	u32 index = msr_info->index;
+
+	if (!intel_pmu_is_valid_lbr_msr(vcpu, index))
+		return false;
+
+	if (!lbr_desc->event && !intel_pmu_create_guest_lbr_event(vcpu))
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
+		local_irq_enable();
+		return true;
+	}
+	local_irq_enable();
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
@@ -328,7 +387,8 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			msr_info->data = pmc->eventsel;
 			return 0;
-		}
+		} else if (intel_pmu_handle_lbr_msrs_access(vcpu, msr_info, true))
+			return 0;
 	}
 
 	return 1;
@@ -399,7 +459,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				reprogram_gp_counter(pmc, data);
 				return 0;
 			}
-		}
+		} else if (intel_pmu_handle_lbr_msrs_access(vcpu, msr_info, false))
+			return 0;
 	}
 
 	return 1;
@@ -528,6 +589,70 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 	intel_pmu_release_guest_lbr_event(vcpu);
 }
 
+static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
+{
+	unsigned long *msr_bitmap = to_vmx(vcpu)->vmcs01.msr_bitmap;
+	struct x86_pmu_lbr *lbr = vcpu_to_lbr_records(vcpu);
+	int i;
+
+	for (i = 0; i < lbr->nr; i++) {
+		vmx_set_intercept_for_msr(msr_bitmap,
+			lbr->from + i, MSR_TYPE_RW, set);
+		vmx_set_intercept_for_msr(msr_bitmap,
+			lbr->to + i, MSR_TYPE_RW, set);
+		if (lbr->info)
+			vmx_set_intercept_for_msr(msr_bitmap,
+				lbr->info + i, MSR_TYPE_RW, set);
+	}
+
+	vmx_set_intercept_for_msr(msr_bitmap, MSR_LBR_SELECT, MSR_TYPE_RW, set);
+	vmx_set_intercept_for_msr(msr_bitmap, MSR_LBR_TOS, MSR_TYPE_RW, set);
+}
+
+static inline void vmx_disable_lbr_msrs_passthrough(struct kvm_vcpu *vcpu)
+{
+	vmx_update_intercept_for_lbr_msrs(vcpu, true);
+}
+
+static inline void vmx_enable_lbr_msrs_passthrough(struct kvm_vcpu *vcpu)
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
+void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
+{
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
+
+	if (!lbr_desc->event) {
+		vmx_disable_lbr_msrs_passthrough(vcpu);
+		if (vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR)
+			goto warn;
+		return;
+	}
+
+	if (lbr_desc->event->state < PERF_EVENT_STATE_ACTIVE) {
+		vmx_disable_lbr_msrs_passthrough(vcpu);
+		goto warn;
+	} else
+		vmx_enable_lbr_msrs_passthrough(vcpu);
+
+	return;
+
+warn:
+	pr_warn_ratelimited("kvm: vcpu-%d: fail to passthrough LBR.\n",
+		vcpu->vcpu_id);
+}
+
 struct kvm_pmu_ops intel_pmu_ops = {
 	.find_arch_event = intel_find_arch_event,
 	.find_fixed_event = intel_find_fixed_event,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1204dc730e4f..daab79d1ccc3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6822,6 +6822,8 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	pt_guest_enter(vmx);
 
 	atomic_switch_perf_msrs(vmx);
+	if (intel_pmu_lbr_is_enabled(vcpu))
+		vmx_passthrough_lbr_msrs(vcpu);
 
 	if (enable_preemption_timer)
 		vmx_update_hv_timer(vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index eef8eaaec031..dd029b57215c 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -99,6 +99,7 @@ bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu);
 bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
 
 int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
+void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu);
 
 struct lbr_desc {
 	/* Basic info about guest LBR records. */
-- 
2.21.3

