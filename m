Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEEF51B5716
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 10:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgDWISF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 04:18:05 -0400
Received: from mga18.intel.com ([134.134.136.126]:57581 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726958AbgDWISE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 04:18:04 -0400
IronPort-SDR: Lkyj9c4DsWqVrnnxuaUtWCqoa6tJlJMdUqd0xXI+CKDfL++lAVV770+yTGhzvH22z2uf9Z7STJ
 +CbW5jpIdDeA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 01:18:04 -0700
IronPort-SDR: QZiZNQlmLhnIEy2Vi9ZIlYYvxPYjkgcr2IZ/siBbTitvMw4mco8lXNra4KQ5rtnRJ4jlbpK+iU
 teCf+2ypb86w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,306,1583222400"; 
   d="scan'208";a="255910138"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 23 Apr 2020 01:18:01 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei.w.wang@intel.com,
        ak@linux.intel.com, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v10 09/11] KVM: x86/pmu: Release guest LBR event via vPMU lazy release mechanism
Date:   Thu, 23 Apr 2020 16:14:10 +0800
Message-Id: <20200423081412.164863-10-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200423081412.164863-1-like.xu@linux.intel.com>
References: <20200423081412.164863-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vPMU uses INTEL_PMC_IDX_FIXED_VLBR (bit 58) in 'pmu->pmc_in_use' to
indicate whether a guest LBR event is still needed by the vcpu. If the vcpu
no longer accesses LBR related registers within a scheduling time slice,
and the enable bit of LBR has been unset, vPMU will treat the guest LBR
event as a bland event of a vPMC counter and release it as usual. Also the
pass-through state of LBR records msrs is cancelled.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/pmu.c           |  9 +++++++++
 arch/x86/kvm/pmu.h           |  4 ++++
 arch/x86/kvm/vmx/pmu_intel.c | 12 +++++++++++-
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 5776d305e254..7dad899850bb 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -452,6 +452,12 @@ static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
 	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
 }
 
+void kvm_pmu_lbr_cleanup(struct kvm_vcpu *vcpu)
+{
+	if (kvm_x86_ops.pmu_ops->lbr_cleanup)
+		kvm_x86_ops.pmu_ops->lbr_cleanup(vcpu);
+}
+
 /* Release perf_events for vPMCs that have been unused for a full time slice.  */
 void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 {
@@ -470,6 +476,9 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 
 		if (pmc && pmc->perf_event && !pmc_speculative_in_use(pmc))
 			pmc_stop_counter(pmc);
+
+		if (i == KVM_PMU_LBR_IN_USE_IDX && pmu->lbr_event)
+			kvm_pmu_lbr_cleanup(vcpu);
 	}
 
 	bitmap_zero(pmu->pmc_in_use, X86_PMC_IDX_MAX);
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 594642ab2575..008105051114 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -15,6 +15,9 @@
 #define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
 #define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
 
+/* Indicates whether LBR msrs were accessed during the last time slice. */
+#define KVM_PMU_LBR_IN_USE_IDX INTEL_PMC_IDX_FIXED_VLBR
+
 struct kvm_event_hw_type_mapping {
 	u8 eventsel;
 	u8 unit_mask;
@@ -40,6 +43,7 @@ struct kvm_pmu_ops {
 	bool (*lbr_setup)(struct kvm_vcpu *vcpu);
 	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
 	void (*availability_check)(struct kvm_vcpu *vcpu);
+	void (*lbr_cleanup)(struct kvm_vcpu *vcpu);
 };
 
 static inline bool event_is_oncpu(struct perf_event *event)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index bb8e4dccbb18..37088bbcde7f 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -282,7 +282,7 @@ static void intel_pmu_free_lbr_event(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct perf_event *event = pmu->lbr_event;
 
-	if (!event)
+	if (unlikely(!event))
 		return;
 
 	perf_event_release_kernel(event);
@@ -320,6 +320,7 @@ static bool intel_pmu_access_lbr_msr(struct kvm_vcpu *vcpu,
 		msr_info->data = 0;
 	local_irq_enable();
 
+	__set_bit(KVM_PMU_LBR_IN_USE_IDX, pmu->pmc_in_use);
 	return true;
 }
 
@@ -411,6 +412,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
 		if (!pmu->lbr_event)
 			intel_pmu_create_lbr_event(vcpu);
+		__set_bit(KVM_PMU_LBR_IN_USE_IDX, pmu->pmc_in_use);
 		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
@@ -505,6 +507,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		0, pmu->nr_arch_gp_counters);
 	bitmap_set(pmu->all_valid_pmc_idx,
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
+	bitmap_set(pmu->all_valid_pmc_idx, KVM_PMU_LBR_IN_USE_IDX, 1);
 
 	nested_vmx_pmu_entry_exit_ctls_update(vcpu);
 }
@@ -650,6 +653,12 @@ static void intel_pmu_availability_check(struct kvm_vcpu *vcpu)
 		intel_pmu_lbr_availability_check(vcpu);
 }
 
+static void intel_pmu_cleanup_lbr(struct kvm_vcpu *vcpu)
+{
+	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
+		intel_pmu_free_lbr_event(vcpu);
+}
+
 struct kvm_pmu_ops intel_pmu_ops = {
 	.find_arch_event = intel_find_arch_event,
 	.find_fixed_event = intel_find_fixed_event,
@@ -667,4 +676,5 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.lbr_setup = intel_pmu_lbr_setup,
 	.deliver_pmi = intel_pmu_deliver_pmi,
 	.availability_check = intel_pmu_availability_check,
+	.lbr_cleanup = intel_pmu_cleanup_lbr,
 };
-- 
2.21.1

