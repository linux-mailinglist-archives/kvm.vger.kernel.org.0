Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 520E7A10EE
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 07:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbfH2Fiy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 01:38:54 -0400
Received: from mga05.intel.com ([192.55.52.43]:33970 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbfH2Fiy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 01:38:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 22:38:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,442,1559545200"; 
   d="scan'208";a="210416115"
Received: from icl-2s.bj.intel.com ([10.240.193.48])
  by fmsmga002.fm.intel.com with ESMTP; 28 Aug 2019 22:38:47 -0700
From:   Luwei Kang <luwei.kang@intel.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, ak@linux.intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luwei Kang <luwei.kang@intel.com>
Subject: [RFC v1 1/9] KVM: x86: Add base address parameter for get_fixed_pmc function
Date:   Thu, 29 Aug 2019 13:34:01 +0800
Message-Id: <1567056849-14608-2-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567056849-14608-1-git-send-email-luwei.kang@intel.com>
References: <1567056849-14608-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PEBS output Inte PT introduces some new MSRs (MSR_RELOAD_FIXED_CTRx)
for fixed function counters that use for autoload the preset value
after writing out a PEBS event.

Introduce base MSRs address parameter to make this function can get
performance monitor counter structure by MSR_RELOAD_FIXED_CTRx registers.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 arch/x86/kvm/pmu.h           |  5 ++---
 arch/x86/kvm/vmx/pmu_intel.c | 14 +++++++++-----
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 58265f7..c62a1ff 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -93,10 +93,9 @@ static inline struct kvm_pmc *get_gp_pmc(struct kvm_pmu *pmu, u32 msr,
 }
 
 /* returns fixed PMC with the specified MSR */
-static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
+static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr,
+								int base)
 {
-	int base = MSR_CORE_PERF_FIXED_CTR0;
-
 	if (msr >= base && msr < base + pmu->nr_arch_fixed_counters)
 		return &pmu->fixed_counters[msr - base];
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 4dea0e0..01441be 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -41,7 +41,8 @@ static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 		u8 old_ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl, i);
 		struct kvm_pmc *pmc;
 
-		pmc = get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i);
+		pmc = get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i,
+						MSR_CORE_PERF_FIXED_CTR0);
 
 		if (old_ctrl == new_ctrl)
 			continue;
@@ -106,7 +107,8 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 	else {
 		u32 idx = pmc_idx - INTEL_PMC_IDX_FIXED;
 
-		return get_fixed_pmc(pmu, idx + MSR_CORE_PERF_FIXED_CTR0);
+		return get_fixed_pmc(pmu, idx + MSR_CORE_PERF_FIXED_CTR0,
+						MSR_CORE_PERF_FIXED_CTR0);
 	}
 }
 
@@ -155,7 +157,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
-			get_fixed_pmc(pmu, msr);
+			get_fixed_pmc(pmu, msr, MSR_CORE_PERF_FIXED_CTR0);
 		break;
 	}
 
@@ -185,7 +187,8 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 			u64 val = pmc_read_counter(pmc);
 			*data = val & pmu->counter_bitmask[KVM_PMC_GP];
 			return 0;
-		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
+		} else if ((pmc = get_fixed_pmc(pmu, msr,
+						MSR_CORE_PERF_FIXED_CTR0))) {
 			u64 val = pmc_read_counter(pmc);
 			*data = val & pmu->counter_bitmask[KVM_PMC_FIXED];
 			return 0;
@@ -243,7 +246,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			else
 				pmc->counter = (s32)data;
 			return 0;
-		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
+		} else if ((pmc = get_fixed_pmc(pmu, msr,
+						MSR_CORE_PERF_FIXED_CTR0))) {
 			pmc->counter = data;
 			return 0;
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
-- 
1.8.3.1

