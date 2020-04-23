Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE4E1B5713
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 10:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgDWISB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 04:18:01 -0400
Received: from mga18.intel.com ([134.134.136.126]:57581 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726923AbgDWIR6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 04:17:58 -0400
IronPort-SDR: AIO5YHZkv2jdUc7rcACCrdUz7M0glSHsuvepIN19qGVjcoEjhluDU3zpEap9A8qa8fmS8TWYq6
 cYBcRSifkljQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 01:17:58 -0700
IronPort-SDR: QolaHi84UJehdN5a2aqTmqF5/hjUlBTMEAgCeE0GmG4CD36HwZvOXSCHMsK7CmzXtipPlYUZjs
 tNG3n5andvOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,306,1583222400"; 
   d="scan'208";a="255910108"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 23 Apr 2020 01:17:55 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei.w.wang@intel.com,
        ak@linux.intel.com
Subject: [PATCH v10 07/11] KVM: x86/pmu: Tweak kvm_pmu_get_msr to pass 'struct msr_data' in
Date:   Thu, 23 Apr 2020 16:14:08 +0800
Message-Id: <20200423081412.164863-8-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200423081412.164863-1-like.xu@linux.intel.com>
References: <20200423081412.164863-1-like.xu@linux.intel.com>
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
index c1f95b2f9559..b24b19ede76a 100644
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
index 971da6431d74..19d8e057c0b5 100644
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
@@ -148,7 +148,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
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
index 4056bd114844..5d7d002e5a3e 100644
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
index b5ce89016eeb..99f819dfcc90 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3083,7 +3083,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
 	case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
-			return kvm_pmu_get_msr(vcpu, msr_info->index, &msr_info->data);
+			return kvm_pmu_get_msr(vcpu, msr_info);
 		msr_info->data = 0;
 		break;
 	case MSR_IA32_UCODE_REV:
@@ -3245,7 +3245,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
-			return kvm_pmu_get_msr(vcpu, msr_info->index, &msr_info->data);
+			return kvm_pmu_get_msr(vcpu, msr_info);
 		if (!ignore_msrs) {
 			vcpu_debug_ratelimited(vcpu, "unhandled rdmsr: 0x%x\n",
 					       msr_info->index);
-- 
2.21.1

