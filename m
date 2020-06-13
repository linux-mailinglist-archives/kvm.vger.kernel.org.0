Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506051F81B3
	for <lists+kvm@lfdr.de>; Sat, 13 Jun 2020 10:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgFMIMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Jun 2020 04:12:17 -0400
Received: from mga07.intel.com ([134.134.136.100]:64611 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726570AbgFMILj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Jun 2020 04:11:39 -0400
IronPort-SDR: FgeE9e97xthOFHzWlJ0Nsop+I38LwSDLSOyn36DpCUXeRkrknJQLhT2Uii8uaCmCQkrg4C5WTN
 BKNah2O01/dg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2020 01:11:37 -0700
IronPort-SDR: EWhDzJPbkRJ4BkuFB+j0sRW1P5napTO3QjlklnI/66bD6YiCojHmZdDwqF27bnNQcf0O9aaiAN
 NZl96hYG1CNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,506,1583222400"; 
   d="scan'208";a="474467465"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 13 Jun 2020 01:11:34 -0700
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
Subject: [PATCH v12 11/11] KVM: vmx/pmu: Release guest LBR event via lazy release mechanism
Date:   Sat, 13 Jun 2020 16:09:56 +0800
Message-Id: <20200613080958.132489-12-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200613080958.132489-1-like.xu@linux.intel.com>
References: <20200613080958.132489-1-like.xu@linux.intel.com>
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
as usual. Also the pass-through state of LBR records msrs is cancelled.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/pmu.c           |  7 +++++++
 arch/x86/kvm/pmu.h           |  4 ++++
 arch/x86/kvm/vmx/pmu_intel.c | 14 +++++++++++++-
 arch/x86/kvm/vmx/vmx.c       |  4 ++++
 4 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 5053f4238218..e5b76f1c3ce8 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -458,6 +458,7 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 	struct kvm_pmc *pmc = NULL;
 	DECLARE_BITMAP(bitmask, X86_PMC_IDX_MAX);
 	int i;
+	bool arch_cleanup = false;
 
 	pmu->need_cleanup = false;
 
@@ -469,8 +470,14 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 
 		if (pmc && pmc->perf_event && !pmc_speculative_in_use(pmc))
 			pmc_stop_counter(pmc);
+
+		if (i == INTEL_GUEST_LBR_INUSE)
+			arch_cleanup = true;
 	}
 
+	if (arch_cleanup && kvm_x86_ops.pmu_ops->cleanup)
+		kvm_x86_ops.pmu_ops->cleanup(vcpu);
+
 	bitmap_zero(pmu->pmc_in_use, X86_PMC_IDX_MAX);
 }
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 095b84392b89..d5023eacd8ed 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -15,6 +15,9 @@
 #define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
 #define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
 
+/* Indicates whether Intel LBR msrs were accessed during the last time slice. */
+#define INTEL_GUEST_LBR_INUSE INTEL_PMC_IDX_FIXED_VLBR
+
 struct kvm_event_hw_type_mapping {
 	u8 eventsel;
 	u8 unit_mask;
@@ -38,6 +41,7 @@ struct kvm_pmu_ops {
 	void (*init)(struct kvm_vcpu *vcpu);
 	void (*reset)(struct kvm_vcpu *vcpu);
 	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
+	void (*cleanup)(struct kvm_vcpu *vcpu);
 };
 
 static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 75ba0444b4d1..c1c5058acc90 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -303,6 +303,7 @@ static void intel_pmu_free_lbr_event(struct kvm_vcpu *vcpu)
 static bool access_lbr_record_msr(struct kvm_vcpu *vcpu,
 				     struct msr_data *msr_info, bool read)
 {
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct lbr_desc *lbr_desc = &to_vmx(vcpu)->lbr_desc;
 	u32 index = msr_info->index;
 
@@ -331,6 +332,7 @@ static bool access_lbr_record_msr(struct kvm_vcpu *vcpu,
 		msr_info->data = 0;
 	local_irq_enable();
 
+	__set_bit(INTEL_GUEST_LBR_INUSE, pmu->pmc_in_use);
 	return true;
 
 dummy:
@@ -483,6 +485,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
 		if (!msr_info->host_initiated && !to_vmx(vcpu)->lbr_desc.event)
 			intel_pmu_create_lbr_event(vcpu);
+		__set_bit(INTEL_GUEST_LBR_INUSE, pmu->pmc_in_use);
 		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
@@ -584,7 +587,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
 
 	if ((vcpu->arch.perf_capabilities & PMU_CAP_LBR_FMT) &&
-	    x86_perf_get_lbr(&lbr_desc->lbr))
+	    !x86_perf_get_lbr(&lbr_desc->lbr))
+		bitmap_set(pmu->all_valid_pmc_idx, INTEL_GUEST_LBR_INUSE, 1);
+	else
 		vcpu->arch.perf_capabilities &= ~PMU_CAP_LBR_FMT;
 
 	nested_vmx_pmu_entry_exit_ctls_update(vcpu);
@@ -672,6 +677,12 @@ static void intel_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 		intel_pmu_legacy_freezing_lbrs_on_pmi(vcpu);
 }
 
+static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
+{
+	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
+		intel_pmu_free_lbr_event(vcpu);
+}
+
 struct kvm_pmu_ops intel_pmu_ops = {
 	.find_arch_event = intel_find_arch_event,
 	.find_fixed_event = intel_find_fixed_event,
@@ -687,4 +698,5 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.init = intel_pmu_init,
 	.reset = intel_pmu_reset,
 	.deliver_pmi = intel_pmu_deliver_pmi,
+	.cleanup = intel_pmu_cleanup,
 };
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 800a26e3b571..8521fc640b95 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3912,17 +3912,21 @@ static inline void vmx_lbr_enable_passthrough(struct kvm_vcpu *vcpu)
  */
 static void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
 {
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct lbr_desc *lbr_desc = &to_vmx(vcpu)->lbr_desc;
 
 	if (!lbr_desc->event) {
 		vmx_lbr_disable_passthrough(vcpu);
 		if (vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR)
 			goto warn;
+		if (test_bit(INTEL_GUEST_LBR_INUSE, pmu->pmc_in_use))
+			goto warn;
 		return;
 	}
 
 	if (lbr_desc->event->state < PERF_EVENT_STATE_ACTIVE) {
 		vmx_lbr_disable_passthrough(vcpu);
+		__clear_bit(INTEL_GUEST_LBR_INUSE, pmu->pmc_in_use);
 		goto warn;
 	} else
 		vmx_lbr_enable_passthrough(vcpu);
-- 
2.21.3

