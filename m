Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56B730A143
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 06:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhBAFYd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 00:24:33 -0500
Received: from mga17.intel.com ([192.55.52.151]:9252 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229878AbhBAFVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 00:21:54 -0500
IronPort-SDR: ear1ZIXZY2KCd/CAgi6vdoMfczYR4m8FJfCR7sQbeE5Or/nmJbGSoQrQUsJyGQxc8urFHRFpmQ
 /X0JcgW38Wqg==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="160401841"
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="160401841"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 21:17:26 -0800
IronPort-SDR: wH8wreO5u8WZ/5ePqQTU2avmPEW6Io6FkFYUfIkV2mm2TWAvIAmtB3lZuffLJDatfRlqwDP3SV
 k0WsbJxulnzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="390694298"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 31 Jan 2021 21:17:23 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com,
        alex.shi@linux.alibaba.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v14 06/11] KVM: vmx/pmu: Pass-through LBR msrs when the guest LBR event is ACTIVE
Date:   Mon,  1 Feb 2021 13:10:34 +0800
Message-Id: <20210201051039.255478-7-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210201051039.255478-1-like.xu@linux.intel.com>
References: <20210201051039.255478-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Reviewed-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 127 ++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c       |  10 +++
 arch/x86/kvm/vmx/vmx.h       |   1 +
 3 files changed, 135 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 22c271a1c7a4..287fc14f0445 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -190,6 +190,24 @@ bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
 	return lbr->nr && (vcpu->arch.perf_capabilities & PMU_CAP_LBR_FMT);
 }
 
+static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
+{
+	struct x86_pmu_lbr *records = vcpu_to_lbr_records(vcpu);
+	bool ret = false;
+
+	if (!intel_pmu_lbr_is_enabled(vcpu))
+		return ret;
+
+	ret = (index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS) ||
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
@@ -205,7 +223,8 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
-			get_fixed_pmc(pmu, msr) || get_fw_gp_pmc(pmu, msr);
+			get_fixed_pmc(pmu, msr) || get_fw_gp_pmc(pmu, msr) ||
+			intel_pmu_is_valid_lbr_msr(vcpu, msr);
 		break;
 	}
 
@@ -284,6 +303,46 @@ int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu)
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
@@ -318,7 +377,8 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			msr_info->data = pmc->eventsel;
 			return 0;
-		}
+		} else if (intel_pmu_handle_lbr_msrs_access(vcpu, msr_info, true))
+			return 0;
 	}
 
 	return 1;
@@ -389,7 +449,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				reprogram_gp_counter(pmc, data);
 				return 0;
 			}
-		}
+		} else if (intel_pmu_handle_lbr_msrs_access(vcpu, msr_info, false))
+			return 0;
 	}
 
 	return 1;
@@ -517,6 +578,66 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 	intel_pmu_release_guest_lbr_event(vcpu);
 }
 
+static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
+{
+	struct x86_pmu_lbr *lbr = vcpu_to_lbr_records(vcpu);
+	int i;
+
+	for (i = 0; i < lbr->nr; i++) {
+		vmx_set_intercept_for_msr(vcpu, lbr->from + i, MSR_TYPE_RW, set);
+		vmx_set_intercept_for_msr(vcpu, lbr->to + i, MSR_TYPE_RW, set);
+		if (lbr->info)
+			vmx_set_intercept_for_msr(vcpu, lbr->info + i, MSR_TYPE_RW, set);
+	}
+
+	vmx_set_intercept_for_msr(vcpu, MSR_LBR_SELECT, MSR_TYPE_RW, set);
+	vmx_set_intercept_for_msr(vcpu, MSR_LBR_TOS, MSR_TYPE_RW, set);
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
index c85a42b39bed..40fdeb394328 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -658,6 +658,14 @@ static bool is_valid_passthrough_msr(u32 msr)
 	case MSR_IA32_RTIT_CR3_MATCH:
 	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
 		/* PT MSRs. These are handled in pt_update_intercept_for_msr() */
+	case MSR_LBR_SELECT:
+	case MSR_LBR_TOS:
+	case MSR_LBR_INFO_0 ... MSR_LBR_INFO_0 + 31:
+	case MSR_LBR_NHM_FROM ... MSR_LBR_NHM_FROM + 31:
+	case MSR_LBR_NHM_TO ... MSR_LBR_NHM_TO + 31:
+	case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
+	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
+		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
 		return true;
 	}
 
@@ -6730,6 +6738,8 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	pt_guest_enter(vmx);
 
 	atomic_switch_perf_msrs(vmx);
+	if (intel_pmu_lbr_is_enabled(vcpu))
+		vmx_passthrough_lbr_msrs(vcpu);
 
 	if (enable_preemption_timer)
 		vmx_update_hv_timer(vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index ae645c2082ba..863bb3fe73d4 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -77,6 +77,7 @@ bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu);
 bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
 
 int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
+void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu);
 
 struct lbr_desc {
 	/* Basic info about guest LBR records. */
-- 
2.29.2

