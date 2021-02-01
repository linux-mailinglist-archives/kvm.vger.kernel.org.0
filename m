Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821DD30A171
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 06:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbhBAF1y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 00:27:54 -0500
Received: from mga17.intel.com ([192.55.52.151]:9252 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231153AbhBAFZQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 00:25:16 -0500
IronPort-SDR: ASdvq18k6yFyXwWBVU/63UdT59oZMdsF+BeuL9VhAAqyVwc/fyfB0391Qgrnb2Qwz33z04lfsC
 NeZKDvssuEBA==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="160401850"
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="160401850"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 21:17:36 -0800
IronPort-SDR: G6rMJXj7EDBheyKfuHIe/JMoBOoKC1X075VYL9IYvo2TvQkabUupXXtqSBsFDvBfcIsti1SaI8
 +MHwrOODQGhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="390694323"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 31 Jan 2021 21:17:33 -0800
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
Subject: [PATCH v14 09/11] KVM: vmx/pmu: Release guest LBR event via lazy release mechanism
Date:   Mon,  1 Feb 2021 13:10:37 +0800
Message-Id: <20210201051039.255478-10-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210201051039.255478-1-like.xu@linux.intel.com>
References: <20210201051039.255478-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 arch/x86/kvm/pmu.c           |  3 +++
 arch/x86/kvm/pmu.h           |  1 +
 arch/x86/kvm/vmx/pmu_intel.c | 21 ++++++++++++++++++++-
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 405890c723a1..136dc2f3c5d3 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -476,6 +476,9 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 			pmc_stop_counter(pmc);
 	}
 
+	if (kvm_x86_ops.pmu_ops->cleanup)
+		kvm_x86_ops.pmu_ops->cleanup(vcpu);
+
 	bitmap_zero(pmu->pmc_in_use, X86_PMC_IDX_MAX);
 }
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 742a4e98df8c..7b30bc967af3 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -40,6 +40,7 @@ struct kvm_pmu_ops {
 	void (*init)(struct kvm_vcpu *vcpu);
 	void (*reset)(struct kvm_vcpu *vcpu);
 	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
+	void (*cleanup)(struct kvm_vcpu *vcpu);
 };
 
 static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 51edd9c1adfa..23cd31b849f4 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -288,8 +288,10 @@ int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu)
 					PERF_SAMPLE_BRANCH_USER,
 	};
 
-	if (unlikely(lbr_desc->event))
+	if (unlikely(lbr_desc->event)) {
+		__set_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use);
 		return 0;
+	}
 
 	event = perf_event_create_kernel_counter(&attr, -1,
 						current, NULL, NULL);
@@ -300,6 +302,7 @@ int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu)
 	}
 	lbr_desc->event = event;
 	pmu->event_count++;
+	__set_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use);
 	return 0;
 }
 
@@ -332,9 +335,11 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
 			rdmsrl(index, msr_info->data);
 		else
 			wrmsrl(index, msr_info->data);
+		__set_bit(INTEL_PMC_IDX_FIXED_VLBR, vcpu_to_pmu(vcpu)->pmc_in_use);
 		local_irq_enable();
 		return true;
 	}
+	clear_bit(INTEL_PMC_IDX_FIXED_VLBR, vcpu_to_pmu(vcpu)->pmc_in_use);
 	local_irq_enable();
 
 dummy:
@@ -463,6 +468,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	struct kvm_cpuid_entry2 *entry;
 	union cpuid10_eax eax;
 	union cpuid10_edx edx;
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 
 	pmu->nr_arch_gp_counters = 0;
 	pmu->nr_arch_fixed_counters = 0;
@@ -482,6 +488,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		return;
 
 	perf_get_x86_pmu_capability(&x86_pmu);
+	if (lbr_desc->records.nr)
+		bitmap_set(pmu->all_valid_pmc_idx, INTEL_PMC_IDX_FIXED_VLBR, 1);
 
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
 					 x86_pmu.num_counters_gp);
@@ -658,17 +666,21 @@ static inline void vmx_enable_lbr_msrs_passthrough(struct kvm_vcpu *vcpu)
  */
 void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
 {
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 
 	if (!lbr_desc->event) {
 		vmx_disable_lbr_msrs_passthrough(vcpu);
 		if (vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR)
 			goto warn;
+		if (test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use))
+			goto warn;
 		return;
 	}
 
 	if (lbr_desc->event->state < PERF_EVENT_STATE_ACTIVE) {
 		vmx_disable_lbr_msrs_passthrough(vcpu);
+		__clear_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use);
 		goto warn;
 	} else
 		vmx_enable_lbr_msrs_passthrough(vcpu);
@@ -680,6 +692,12 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
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
@@ -695,4 +713,5 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.init = intel_pmu_init,
 	.reset = intel_pmu_reset,
 	.deliver_pmi = intel_pmu_deliver_pmi,
+	.cleanup = intel_pmu_cleanup,
 };
-- 
2.29.2

