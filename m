Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EBE1CEC23
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 06:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgELEnB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 00:43:01 -0400
Received: from mga18.intel.com ([134.134.136.126]:51199 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgELEnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 00:43:01 -0400
IronPort-SDR: ZYFJW30tSSdvZtaPgYMmNmd47mZqX6Tm820cww46VwXOGlBkEKChPe/gULchVpk7JxVb3Uwba0
 iejp/mua0yfg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 21:43:00 -0700
IronPort-SDR: MjMkHUNgp6gNHCPPO/kkCaXOUxUA2bH+ljPM0M9fNhULWt6qub9kjEz2PVh9VunXQpy9vwK1/7
 ZChJN7V097Ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,382,1583222400"; 
   d="scan'208";a="261995735"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 11 May 2020 21:42:58 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     pbonzini@redhat.com
Cc:     jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        like.xu@linux.intel.com, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH 1/2] KVM: x86/pmu: Tweak kvm_pmu_get_msr to pass 'struct msr_data' in
Date:   Tue, 12 May 2020 12:42:44 +0800
Message-Id: <20200512044245.130220-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <f1c77c79-7ff8-c5f3-e011-9874a4336217@redhat.com>
References: <f1c77c79-7ff8-c5f3-e011-9874a4336217@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wei Wang <wei.w.wang@intel.com>

Change kvm_pmu_get_msr() to get the msr_data struct, as the host_initiated
field from the struct could be used by get_msr. This also makes this API
consistent with kvm_pmu_set_msr. No functional changes.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 arch/x86/kvm/pmu.c           |  4 ++--
 arch/x86/kvm/pmu.h           |  4 ++--
 arch/x86/kvm/svm/pmu.c       |  7 ++++---
 arch/x86/kvm/vmx/pmu_intel.c | 19 +++++++++++--------
 arch/x86/kvm/x86.c           |  4 ++--
 5 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index a5078841bdac..b86346903f2e 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -397,9 +397,9 @@ static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 		__set_bit(pmc->idx, pmu->pmc_in_use);
 }
 
-int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
+int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
-	return kvm_x86_ops.pmu_ops->get_msr(vcpu, msr, data);
+	return kvm_x86_ops.pmu_ops->get_msr(vcpu, msr_info);
 }
 
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index a6c78a797cb1..ab85eed8a6cc 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -32,7 +32,7 @@ struct kvm_pmu_ops {
 	struct kvm_pmc *(*msr_idx_to_pmc)(struct kvm_vcpu *vcpu, u32 msr);
 	int (*is_valid_rdpmc_ecx)(struct kvm_vcpu *vcpu, unsigned int idx);
 	bool (*is_valid_msr)(struct kvm_vcpu *vcpu, u32 msr);
-	int (*get_msr)(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
+	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 	void (*refresh)(struct kvm_vcpu *vcpu);
 	void (*init)(struct kvm_vcpu *vcpu);
@@ -147,7 +147,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
 int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
 int kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx);
 bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr);
-int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
+int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 void kvm_pmu_refresh(struct kvm_vcpu *vcpu);
 void kvm_pmu_reset(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index ce0b10fe5e2b..035da07500e8 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -215,21 +215,22 @@ static struct kvm_pmc *amd_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
 	return pmc;
 }
 
-static int amd_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
+static int amd_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
+	u32 msr = msr_info->index;
 
 	/* MSR_PERFCTRn */
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
 	if (pmc) {
-		*data = pmc_read_counter(pmc);
+		msr_info->data = pmc_read_counter(pmc);
 		return 0;
 	}
 	/* MSR_EVNTSELn */
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_EVNTSEL);
 	if (pmc) {
-		*data = pmc->eventsel;
+		msr_info->data = pmc->eventsel;
 		return 0;
 	}
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 7c857737b438..e1a303fefc16 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -184,35 +184,38 @@ static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
 	return pmc;
 }
 
-static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
+static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
+	u32 msr = msr_info->index;
 
 	switch (msr) {
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
-		*data = pmu->fixed_ctr_ctrl;
+		msr_info->data = pmu->fixed_ctr_ctrl;
 		return 0;
 	case MSR_CORE_PERF_GLOBAL_STATUS:
-		*data = pmu->global_status;
+		msr_info->data = pmu->global_status;
 		return 0;
 	case MSR_CORE_PERF_GLOBAL_CTRL:
-		*data = pmu->global_ctrl;
+		msr_info->data = pmu->global_ctrl;
 		return 0;
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
-		*data = pmu->global_ovf_ctrl;
+		msr_info->data = pmu->global_ovf_ctrl;
 		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
 			u64 val = pmc_read_counter(pmc);
-			*data = val & pmu->counter_bitmask[KVM_PMC_GP];
+			msr_info->data =
+				val & pmu->counter_bitmask[KVM_PMC_GP];
 			return 0;
 		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
 			u64 val = pmc_read_counter(pmc);
-			*data = val & pmu->counter_bitmask[KVM_PMC_FIXED];
+			msr_info->data =
+				val & pmu->counter_bitmask[KVM_PMC_FIXED];
 			return 0;
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
-			*data = pmc->eventsel;
+			msr_info->data = pmc->eventsel;
 			return 0;
 		}
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7e46027f405a..23fe511c6ba0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3106,7 +3106,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
 	case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
-			return kvm_pmu_get_msr(vcpu, msr_info->index, &msr_info->data);
+			return kvm_pmu_get_msr(vcpu, msr_info);
 		msr_info->data = 0;
 		break;
 	case MSR_IA32_UCODE_REV:
@@ -3268,7 +3268,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
-			return kvm_pmu_get_msr(vcpu, msr_info->index, &msr_info->data);
+			return kvm_pmu_get_msr(vcpu, msr_info);
 		if (!ignore_msrs) {
 			vcpu_debug_ratelimited(vcpu, "unhandled rdmsr: 0x%x\n",
 					       msr_info->index);
-- 
2.21.3

