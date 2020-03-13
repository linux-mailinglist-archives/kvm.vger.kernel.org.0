Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F48E183F0F
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 03:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgCMCTY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 22:19:24 -0400
Received: from mga14.intel.com ([192.55.52.115]:25868 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbgCMCTW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 22:19:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 19:19:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,546,1574150400"; 
   d="scan'208";a="261743861"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 12 Mar 2020 19:19:18 -0700
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
Subject: [PATCH v9 08/10] KVM: x86/pmu: Release guest LBR event via vPMU lazy release mechanism
Date:   Fri, 13 Mar 2020 10:16:14 +0800
Message-Id: <20200313021616.112322-9-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200313021616.112322-1-like.xu@linux.intel.com>
References: <20200313021616.112322-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest LBR event uses bit 58 in pmu->pmc_in_use (which is also the
LBRS_FROZEN bit in GLOBAL_STATUS) to indicate whether the event is still
needed by the vcpu. If the guest no longer accesses the LBR related MSRs
within a scheduling time slice and the enable bit of LBR is unset, vPMU
would treat the guest LBR event as a bland event of a vPMC counter and
release it as usual and the pass-through state of stack MSRs is canceled.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/pmu.c           |  9 +++++++++
 arch/x86/kvm/pmu.h           |  4 ++++
 arch/x86/kvm/vmx/pmu_intel.c | 16 ++++++++++++++++
 3 files changed, 29 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 84b5ec50ca6d..57859ff8b118 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -449,6 +449,12 @@ static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
 	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
 }
 
+void kvm_pmu_lbr_cleanup(struct kvm_vcpu *vcpu)
+{
+	if (kvm_x86_ops->pmu_ops->lbr_cleanup)
+		kvm_x86_ops->pmu_ops->lbr_cleanup(vcpu);
+}
+
 /* Release perf_events for vPMCs that have been unused for a full time slice.  */
 void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 {
@@ -467,6 +473,9 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 
 		if (pmc && pmc->perf_event && !pmc_speculative_in_use(pmc))
 			pmc_stop_counter(pmc);
+
+		if (i == KVM_PMU_LBR_IN_USE_IDX)
+			kvm_pmu_lbr_cleanup(vcpu);
 	}
 
 	bitmap_zero(pmu->pmc_in_use, X86_PMC_IDX_MAX);
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 3ddff3972b8d..d4ef7ec3331d 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -15,6 +15,9 @@
 #define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
 #define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
 
+/* Indicate if the LBR MSRs were accessed during a time slice */
+#define KVM_PMU_LBR_IN_USE_IDX GLOBAL_STATUS_LBRS_FROZEN_BIT
+
 struct kvm_event_hw_type_mapping {
 	u8 eventsel;
 	u8 unit_mask;
@@ -38,6 +41,7 @@ struct kvm_pmu_ops {
 	void (*init)(struct kvm_vcpu *vcpu);
 	void (*reset)(struct kvm_vcpu *vcpu);
 	bool (*lbr_setup)(struct kvm_vcpu *vcpu);
+	void (*lbr_cleanup)(struct kvm_vcpu *vcpu);
 	void (*availability_check)(struct kvm_vcpu *vcpu);
 };
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 92627f31cda3..bbb5f4c63f52 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -316,6 +316,7 @@ static bool intel_pmu_access_lbr_msr(struct kvm_vcpu *vcpu,
 		msr_info->data = 0;
 	local_irq_enable();
 
+	__set_bit(KVM_PMU_LBR_IN_USE_IDX, pmu->pmc_in_use);
 	return true;
 }
 
@@ -415,6 +416,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			wrmsrl_safe(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
 					GLOBAL_STATUS_LBRS_FROZEN);
 		}
+		if (pmu->lbr_event)
+			__set_bit(KVM_PMU_LBR_IN_USE_IDX, pmu->pmc_in_use);
 		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
@@ -508,6 +511,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		0, pmu->nr_arch_gp_counters);
 	bitmap_set(pmu->all_valid_pmc_idx,
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
+	bitmap_set(pmu->all_valid_pmc_idx, KVM_PMU_LBR_IN_USE_IDX, 1);
 
 	nested_vmx_pmu_entry_exit_ctls_update(vcpu);
 }
@@ -620,6 +624,17 @@ void intel_pmu_availability_check(struct kvm_vcpu *vcpu)
 		intel_pmu_lbr_availability_check(vcpu);
 }
 
+static void intel_pmu_cleanup_lbr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	if (!pmu->lbr_event)
+		return;
+
+	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
+		intel_pmu_free_lbr_event(vcpu);
+}
+
 struct kvm_pmu_ops intel_pmu_ops = {
 	.find_arch_event = intel_find_arch_event,
 	.find_fixed_event = intel_find_fixed_event,
@@ -636,4 +651,5 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.reset = intel_pmu_reset,
 	.lbr_setup = intel_pmu_setup_lbr,
 	.availability_check = intel_pmu_availability_check,
+	.lbr_cleanup = intel_pmu_cleanup_lbr,
 };
-- 
2.21.1

