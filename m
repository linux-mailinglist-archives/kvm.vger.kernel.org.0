Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805681D2A2F
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 10:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgENIbp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 04:31:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:12089 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbgENIbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 04:31:42 -0400
IronPort-SDR: TG6NlhK4t1bHSH6fjc8czu5w4viDRJK8lYzAZ1RohHq4Udw+xA7rxBlnUATMPjACSJ8MZ392X7
 Ftvxgg1BZl2g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 01:31:42 -0700
IronPort-SDR: ngAH6ptEBPTrLytTUpnJBZPf3RhKEQk5758ZlvxDhdIdCRUNI5kFipbeZ+9qYv8Fb3zxyXeu0f
 mKu91DrVeQqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,390,1583222400"; 
   d="scan'208";a="341540017"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga001.jf.intel.com with ESMTP; 14 May 2020 01:31:38 -0700
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
Subject: [PATCH v11 09/11] KVM: x86/pmu: Release guest LBR event via vPMU lazy release mechanism
Date:   Thu, 14 May 2020 16:30:52 +0800
Message-Id: <20200514083054.62538-10-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200514083054.62538-1-like.xu@linux.intel.com>
References: <20200514083054.62538-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vPMU uses GUEST_LBR_IN_USE_IDX (bit 58) in 'pmu->pmc_in_use' to
indicate whether a guest LBR event is still needed by the vcpu. If the vcpu
no longer accesses LBR related registers within a scheduling time slice,
and the enable bit of LBR has been unset, vPMU will treat the guest LBR
event as a bland event of a vPMC counter and release it as usual. Also the
passthrough state of LBR records msrs is cancelled.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/pmu.c           |  9 +++++++++
 arch/x86/kvm/pmu.h           |  4 ++++
 arch/x86/kvm/vmx/pmu_intel.c | 11 +++++++++++
 3 files changed, 24 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 5053f4238218..d0dece055605 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -451,6 +451,12 @@ static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
 	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
 }
 
+static inline void kvm_pmu_lbr_cleanup(struct kvm_vcpu *vcpu)
+{
+	if (kvm_x86_ops.pmu_ops->lbr_cleanup)
+		kvm_x86_ops.pmu_ops->lbr_cleanup(vcpu);
+}
+
 /* Release perf_events for vPMCs that have been unused for a full time slice.  */
 void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 {
@@ -469,6 +475,9 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 
 		if (pmc && pmc->perf_event && !pmc_speculative_in_use(pmc))
 			pmc_stop_counter(pmc);
+
+		if (i == GUEST_LBR_IN_USE_IDX && pmu->lbr_event)
+			kvm_pmu_lbr_cleanup(vcpu);
 	}
 
 	bitmap_zero(pmu->pmc_in_use, X86_PMC_IDX_MAX);
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index ed96cbb40757..78f0cfe1622f 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -15,6 +15,9 @@
 #define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
 #define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
 
+/* Indicates whether LBR msrs were accessed during the last time slice. */
+#define GUEST_LBR_IN_USE_IDX INTEL_PMC_IDX_FIXED_VLBR
+
 struct kvm_event_hw_type_mapping {
 	u8 eventsel;
 	u8 unit_mask;
@@ -38,6 +41,7 @@ struct kvm_pmu_ops {
 	void (*init)(struct kvm_vcpu *vcpu);
 	void (*reset)(struct kvm_vcpu *vcpu);
 	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
+	void (*lbr_cleanup)(struct kvm_vcpu *vcpu);
 };
 
 static inline bool event_is_oncpu(struct perf_event *event)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 8f9c837c7dca..ea4faae56473 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -353,6 +353,7 @@ static bool intel_pmu_access_lbr_msr(struct kvm_vcpu *vcpu,
 		msr_info->data = 0;
 	local_irq_enable();
 
+	__set_bit(GUEST_LBR_IN_USE_IDX, pmu->pmc_in_use);
 	return true;
 }
 
@@ -460,6 +461,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
 		if (!msr_info->host_initiated && !pmu->lbr_event)
 			intel_pmu_create_lbr_event(vcpu);
+		__set_bit(GUEST_LBR_IN_USE_IDX, pmu->pmc_in_use);
 		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
@@ -555,6 +557,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		0, pmu->nr_arch_gp_counters);
 	bitmap_set(pmu->all_valid_pmc_idx,
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
+	if (lbr_is_enabled(vcpu))
+		bitmap_set(pmu->all_valid_pmc_idx, GUEST_LBR_IN_USE_IDX, 1);
 
 	nested_vmx_pmu_entry_exit_ctls_update(vcpu);
 }
@@ -636,6 +640,12 @@ static void intel_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 		intel_pmu_legacy_freezing_lbrs_on_pmi(vcpu);
 }
 
+static void intel_pmu_lbr_cleanup(struct kvm_vcpu *vcpu)
+{
+	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
+		intel_pmu_free_lbr_event(vcpu);
+}
+
 struct kvm_pmu_ops intel_pmu_ops = {
 	.find_arch_event = intel_find_arch_event,
 	.find_fixed_event = intel_find_fixed_event,
@@ -651,4 +661,5 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.init = intel_pmu_init,
 	.reset = intel_pmu_reset,
 	.deliver_pmi = intel_pmu_deliver_pmi,
+	.lbr_cleanup = intel_pmu_lbr_cleanup,
 };
-- 
2.21.3

