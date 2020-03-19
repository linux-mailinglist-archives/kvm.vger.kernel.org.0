Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29E1F18ACD2
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 07:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgCSGfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 02:35:40 -0400
Received: from mga18.intel.com ([134.134.136.126]:53786 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727083AbgCSGfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 02:35:40 -0400
IronPort-SDR: uN70BF67evq3fYIOzWXYrvPcgwYfO6elXpxF4mw3jyNrYXI6j3GParuuDhjplExTyO8VcCgoBh
 ICM546pLLQcA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 23:35:39 -0700
IronPort-SDR: mO6BQX3Nubr+1jnwsgXjApcFxUDYoktBvcVK/l5I75yXI3q9hhvDsIoE62AI6hXhjSQ8r+nluz
 bZOVt17vDFQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,570,1574150400"; 
   d="scan'208";a="248439100"
Received: from snr.bj.intel.com ([10.240.193.90])
  by orsmga006.jf.intel.com with ESMTP; 18 Mar 2020 23:35:33 -0700
From:   Luwei Kang <luwei.kang@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@redhat.com, namhyung@kernel.org, tglx@linutronix.de,
        bp@alien8.de, hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        pawan.kumar.gupta@linux.intel.com, ak@linux.intel.com,
        thomas.lendacky@amd.com, fenghua.yu@intel.com,
        kan.liang@linux.intel.com, Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v2 1/5] KVM: x86/pmu: Add base address parameter for get_fixed_pmc function
Date:   Thu, 19 Mar 2020 22:33:46 +0800
Message-Id: <1584628430-23220-2-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584628430-23220-1-git-send-email-luwei.kang@intel.com>
References: <1584628430-23220-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PEBS output to Inte PT feature introduces some new
MSRs(MSR_RELOAD_FIXED_CTRx) for fixed function counters that using for
autoload the present value after writing out a PEBS event.

Introduce a base MSRs address parameter to make this function can get
kvm performance monitor counter structure by MSR_RELOAD_FIXED_CTRx
registers.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 arch/x86/kvm/pmu.h           |  5 ++---
 arch/x86/kvm/vmx/pmu_intel.c | 16 ++++++++++------
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 9de6ef1..d640628 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -117,10 +117,9 @@ static inline struct kvm_pmc *get_gp_pmc(struct kvm_pmu *pmu, u32 msr,
 }
 
 /* returns fixed PMC with the specified MSR */
-static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
+static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu,
+						u32 msr, u32 base)
 {
-	int base = MSR_CORE_PERF_FIXED_CTR0;
-
 	if (msr >= base && msr < base + pmu->nr_arch_fixed_counters) {
 		u32 index = array_index_nospec(msr - base,
 					       pmu->nr_arch_fixed_counters);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 6a0eef3..2db9b9e 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -43,7 +43,8 @@ static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 		u8 old_ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl, i);
 		struct kvm_pmc *pmc;
 
-		pmc = get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i);
+		pmc = get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i,
+					MSR_CORE_PERF_FIXED_CTR0);
 
 		if (old_ctrl == new_ctrl)
 			continue;
@@ -135,7 +136,8 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 	else {
 		u32 idx = pmc_idx - INTEL_PMC_IDX_FIXED;
 
-		return get_fixed_pmc(pmu, idx + MSR_CORE_PERF_FIXED_CTR0);
+		return get_fixed_pmc(pmu, idx + MSR_CORE_PERF_FIXED_CTR0,
+						MSR_CORE_PERF_FIXED_CTR0);
 	}
 }
 
@@ -196,7 +198,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
-			get_fixed_pmc(pmu, msr);
+			get_fixed_pmc(pmu, msr, MSR_CORE_PERF_FIXED_CTR0);
 		break;
 	}
 
@@ -236,7 +238,7 @@ static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
 
-	pmc = get_fixed_pmc(pmu, msr);
+	pmc = get_fixed_pmc(pmu, msr, MSR_CORE_PERF_FIXED_CTR0);
 	pmc = pmc ? pmc : get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0);
 	pmc = pmc ? pmc : get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0);
 
@@ -278,7 +280,8 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 			u64 val = pmc_read_counter(pmc);
 			*data = val & pmu->counter_bitmask[KVM_PMC_GP];
 			return 0;
-		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
+		} else if ((pmc = get_fixed_pmc(pmu, msr,
+				MSR_CORE_PERF_FIXED_CTR0))) {
 			u64 val = pmc_read_counter(pmc);
 			*data = val & pmu->counter_bitmask[KVM_PMC_FIXED];
 			return 0;
@@ -354,7 +357,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				data = (s64)(s32)data;
 			pmc->counter += data - pmc_read_counter(pmc);
 			return 0;
-		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
+		} else if ((pmc = get_fixed_pmc(pmu, msr,
+				MSR_CORE_PERF_FIXED_CTR0))) {
 			pmc->counter += data - pmc_read_counter(pmc);
 			return 0;
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
-- 
1.8.3.1

