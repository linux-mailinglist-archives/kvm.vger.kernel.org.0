Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4EA2EEB19
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 02:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbhAHBsz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 20:48:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:27995 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729922AbhAHBsy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 20:48:54 -0500
IronPort-SDR: 9iiN9hjdI2XP1Ybd+XHPweuAU4RgZiiXUcjOC6OtcdKr98/nNi6+p7v6IbUjGPiWa11a5qxIb+
 p6LEFADOj9HQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="177672424"
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="177672424"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 17:43:40 -0800
IronPort-SDR: LmWcOyDft4qsOBX5+mNuAS80gt1r8VU1nrAdVFa1o1EQqs3w5SAFF/t0pvL1WUk2CgI/+8Hh6e
 E6xx5m2rt0gg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="379938134"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 07 Jan 2021 17:43:36 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND v13 10/10] KVM: vmx/pmu: Release guest LBR event via lazy release mechanism
Date:   Fri,  8 Jan 2021 09:37:04 +0800
Message-Id: <20210108013704.134985-11-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210108013704.134985-1-like.xu@linux.intel.com>
References: <20210108013704.134985-1-like.xu@linux.intel.com>
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
Reviewed-by: Andi Kleen <ak@linux.intel.com>
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
index 8120685c43d4..4d10f564607d 100644
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
@@ -669,17 +673,21 @@ static inline void vmx_enable_lbr_msrs_passthrough(struct kvm_vcpu *vcpu)
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
@@ -691,6 +699,12 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
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
@@ -706,4 +720,5 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.init = intel_pmu_init,
 	.reset = intel_pmu_reset,
 	.deliver_pmi = intel_pmu_deliver_pmi,
+	.cleanup = intel_pmu_cleanup,
 };
-- 
2.29.2

