Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0392F36D9F
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 09:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbfFFHom (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 03:44:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:24992 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726976AbfFFHog (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 03:44:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 00:44:36 -0700
X-ExtLoop1: 1
Received: from devel-ww.sh.intel.com ([10.239.48.128])
  by orsmga005.jf.intel.com with ESMTP; 06 Jun 2019 00:44:33 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, ak@linux.intel.com, peterz@infradead.org
Cc:     kan.liang@intel.com, mingo@redhat.com, rkrcmar@redhat.com,
        like.xu@intel.com, wei.w.wang@intel.com, jannh@google.com,
        arei.gonglei@huawei.com, jmattson@google.com
Subject: [PATCH v6 05/12] KVM/x86/vPMU: tweak kvm_pmu_get_msr
Date:   Thu,  6 Jun 2019 15:02:24 +0800
Message-Id: <1559804551-42271-6-git-send-email-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559804551-42271-1-git-send-email-wei.w.wang@intel.com>
References: <1559804551-42271-1-git-send-email-wei.w.wang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch changes kvm_pmu_get_msr to get the msr_data struct, because
The host_initiated field from the struct could be used by get_msr. This
also makes this API be consistent with kvm_pmu_set_msr.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kvm/pmu.c           |  4 ++--
 arch/x86/kvm/pmu.h           |  4 ++--
 arch/x86/kvm/pmu_amd.c       |  7 ++++---
 arch/x86/kvm/vmx/pmu_intel.c | 19 +++++++++++--------
 arch/x86/kvm/x86.c           |  4 ++--
 5 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index fea8a67..6d4d1cb 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -318,9 +318,9 @@ bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	return kvm_x86_ops->pmu_ops->is_valid_msr(vcpu, msr);
 }
 
-int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
+int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
-	return kvm_x86_ops->pmu_ops->get_msr(vcpu, msr, data);
+	return kvm_x86_ops->pmu_ops->get_msr(vcpu, msr_info);
 }
 
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index c099b4b..7926b65 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -30,7 +30,7 @@ struct kvm_pmu_ops {
 	int (*is_valid_msr_idx)(struct kvm_vcpu *vcpu, unsigned idx);
 	bool (*is_valid_msr)(struct kvm_vcpu *vcpu, u32 msr);
 	bool (*lbr_enable)(struct kvm_vcpu *vcpu);
-	int (*get_msr)(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
+	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 	void (*refresh)(struct kvm_vcpu *vcpu);
 	void (*init)(struct kvm_vcpu *vcpu);
@@ -114,7 +114,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
 int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
 int kvm_pmu_is_valid_msr_idx(struct kvm_vcpu *vcpu, unsigned idx);
 bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr);
-int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
+int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 void kvm_pmu_refresh(struct kvm_vcpu *vcpu);
 void kvm_pmu_reset(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
index d311808..5dda598 100644
--- a/arch/x86/kvm/pmu_amd.c
+++ b/arch/x86/kvm/pmu_amd.c
@@ -210,21 +210,22 @@ static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	return ret;
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
index b465ff0..f14e764 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -300,35 +300,38 @@ static bool intel_pmu_lbr_enable(struct kvm_vcpu *vcpu)
 	return true;
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
index 44a300f..c7ec6aa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2793,7 +2793,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
 	case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
-			return kvm_pmu_get_msr(vcpu, msr_info->index, &msr_info->data);
+			return kvm_pmu_get_msr(vcpu, msr_info);
 		msr_info->data = 0;
 		break;
 	case MSR_IA32_UCODE_REV:
@@ -2945,7 +2945,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
-			return kvm_pmu_get_msr(vcpu, msr_info->index, &msr_info->data);
+			return kvm_pmu_get_msr(vcpu, msr_info);
 		if (!ignore_msrs) {
 			vcpu_debug_ratelimited(vcpu, "unhandled rdmsr: 0x%x\n",
 					       msr_info->index);
-- 
2.7.4

