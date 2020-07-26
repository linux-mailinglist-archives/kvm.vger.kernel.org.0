Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF14722E0C7
	for <lists+kvm@lfdr.de>; Sun, 26 Jul 2020 17:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgGZPfM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jul 2020 11:35:12 -0400
Received: from mga03.intel.com ([134.134.136.65]:17603 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727888AbgGZPfK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jul 2020 11:35:10 -0400
IronPort-SDR: 8LddHnFtNXfG/IBnRcoiKk+SfzvuY1BDe8YYCVDqYWopXUq/yFkJ3HPRGmAs1WSGReVM4rpDWh
 2+dAfwXj9epQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9694"; a="150890995"
X-IronPort-AV: E=Sophos;i="5.75,399,1589266800"; 
   d="scan'208";a="150890995"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2020 08:35:10 -0700
IronPort-SDR: 3kRb4S3UMZcWPJI1RKxZm7xPc4u8SJTUoDKGN/qEQh3LTJHvrqW/HSMT2vhA67KsmhfJXAvW+2
 CPGlp+YJ1wGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,399,1589266800"; 
   d="scan'208";a="303177649"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 26 Jul 2020 08:35:07 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v13 10/10] KVM: vmx/pmu: Release guest LBR event via lazy release mechanism
Date:   Sun, 26 Jul 2020 23:32:29 +0800
Message-Id: <20200726153229.27149-12-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200726153229.27149-1-like.xu@linux.intel.com>
References: <20200726153229.27149-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vPMU uses GUEST_LBR_IN_USE_IDX (bit 58) in 'pmu->pmc_in_use' to
indicate whether a guest LBR event is still needed by the vcpu. If the
vcpu no longer accesses LBR related registers within a scheduling time
slice, and the enable bit of LBR has been unset, vPMU will treat the
guest LBR event as a bland event of a vPMC counter and release it
as usual. Also, the pass-through state of LBR records msrs is cancelled.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/pmu.c           |  7 +++++++
 arch/x86/kvm/pmu.h           |  4 ++++
 arch/x86/kvm/vmx/pmu_intel.c | 17 ++++++++++++++++-
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 405890c723a1..e7c72eea07d4 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -463,6 +463,7 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 	struct kvm_pmc *pmc = NULL;
 	DECLARE_BITMAP(bitmask, X86_PMC_IDX_MAX);
 	int i;
+	bool extra_cleanup = false;
 
 	pmu->need_cleanup = false;
 
@@ -474,8 +475,14 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 
 		if (pmc && pmc->perf_event && !pmc_speculative_in_use(pmc))
 			pmc_stop_counter(pmc);
+
+		if (i == INTEL_GUEST_LBR_INUSE)
+			extra_cleanup = true;
 	}
 
+	if (extra_cleanup && kvm_x86_ops.pmu_ops->cleanup)
+		kvm_x86_ops.pmu_ops->cleanup(vcpu);
+
 	bitmap_zero(pmu->pmc_in_use, X86_PMC_IDX_MAX);
 }
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 742a4e98df8c..c8b650866f56 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -15,6 +15,9 @@
 #define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
 #define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
 
+/* Indicates whether Intel LBR msrs were accessed during the last time slice. */
+#define INTEL_GUEST_LBR_INUSE INTEL_PMC_IDX_FIXED_VLBR
+
 #define MAX_FIXED_COUNTERS	3
 
 struct kvm_event_hw_type_mapping {
@@ -40,6 +43,7 @@ struct kvm_pmu_ops {
 	void (*init)(struct kvm_vcpu *vcpu);
 	void (*reset)(struct kvm_vcpu *vcpu);
 	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
+	void (*cleanup)(struct kvm_vcpu *vcpu);
 };
 
 static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index bcac0f59bbf1..d61a30d3a6ed 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -310,6 +310,7 @@ int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu)
 	}
 	lbr_desc->event = event;
 	vcpu_to_pmu(vcpu)->event_count++;
+	__set_bit(INTEL_GUEST_LBR_INUSE, vcpu_to_pmu(vcpu)->pmc_in_use);
 	return 0;
 }
 
@@ -342,10 +343,12 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
 			rdmsrl(index, msr_info->data);
 		else
 			wrmsrl(index, msr_info->data);
+		__set_bit(INTEL_GUEST_LBR_INUSE, vcpu_to_pmu(vcpu)->pmc_in_use);
 		local_irq_enable();
 		return true;
 	}
 	local_irq_enable();
+	clear_bit(INTEL_GUEST_LBR_INUSE, vcpu_to_pmu(vcpu)->pmc_in_use);
 
 dummy:
 	if (read)
@@ -496,7 +499,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	if (!intel_pmu_lbr_is_enabled(vcpu)) {
 		vcpu->arch.perf_capabilities &= ~PMU_CAP_LBR_FMT;
 		lbr_desc->records.nr = 0;
-	}
+	} else
+		bitmap_set(pmu->all_valid_pmc_idx, INTEL_GUEST_LBR_INUSE, 1);
 
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
 					 x86_pmu.num_counters_gp);
@@ -673,17 +677,21 @@ static inline void vmx_enable_lbr_msrs_passthrough(struct kvm_vcpu *vcpu)
  */
 void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
 {
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 
 	if (!lbr_desc->event) {
 		vmx_disable_lbr_msrs_passthrough(vcpu);
 		if (vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR)
 			goto warn;
+		if (test_bit(INTEL_GUEST_LBR_INUSE, pmu->pmc_in_use))
+			goto warn;
 		return;
 	}
 
 	if (lbr_desc->event->state < PERF_EVENT_STATE_ACTIVE) {
 		vmx_disable_lbr_msrs_passthrough(vcpu);
+		__clear_bit(INTEL_GUEST_LBR_INUSE, pmu->pmc_in_use);
 		goto warn;
 	} else
 		vmx_enable_lbr_msrs_passthrough(vcpu);
@@ -695,6 +703,12 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
 		vcpu->vcpu_id);
 }
 
+static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
+{
+	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
+		intel_pmu_release_guest_lbr_event(vcpu);
+}
+
 struct kvm_pmu_ops intel_pmu_ops = {
 	.find_arch_event = intel_find_arch_event,
 	.find_fixed_event = intel_find_fixed_event,
@@ -710,4 +724,5 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.init = intel_pmu_init,
 	.reset = intel_pmu_reset,
 	.deliver_pmi = intel_pmu_deliver_pmi,
+	.cleanup = intel_pmu_cleanup,
 };
-- 
2.21.3

