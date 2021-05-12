Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE5537B84B
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 10:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhELIqz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 04:46:55 -0400
Received: from mga17.intel.com ([192.55.52.151]:10038 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230181AbhELIqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 04:46:45 -0400
IronPort-SDR: uwsVPVwyvcvwOLJGY9MxY6Y4dzPRHJ4Ir3Tuykuw/OPToSYFSdeaSGh5QiEb2myW5yDbcIUQmL
 fXEOFpmwngWw==
X-IronPort-AV: E=McAfee;i="6200,9189,9981"; a="179918834"
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="179918834"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2021 01:45:36 -0700
IronPort-SDR: urEe+zPi+pjlkkhP5Mkd9dSdduCvsW1Erwnna7vaqztMAccftphu8Z8dajWXrgNxP8biPocIza
 OMCwmTphwOmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="392636360"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga006.jf.intel.com with ESMTP; 12 May 2021 01:45:33 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, peterz@infradead.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        eranian@google.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v3 2/5] KVM: x86/pmu: Add the base address parameter for get_fixed_pmc()
Date:   Wed, 12 May 2021 16:44:43 +0800
Message-Id: <20210512084446.342526-3-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512084446.342526-1-like.xu@linux.intel.com>
References: <20210512084446.342526-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Luwei Kang <luwei.kang@intel.com>

Introduce a new base MSR address pass-in parameter for get_fixed_pmc()
so that the caller can define its base for fixed counters (such as
MSR_RELOAD_FIXED_CTRx that can be used in the PBES-via-PT feature).

Refactor the code using the current value MSR_CORE_PERF_FIXED_CTR0.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
The checkpatch.pl yell "ERROR: do not use assignment in if condition",
should I fix the orignal coding style ?

 arch/x86/kvm/pmu.h           |  5 ++---
 arch/x86/kvm/vmx/pmu_intel.c | 17 +++++++++++------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 832cf56e6924..6720881b8370 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -126,10 +126,9 @@ static inline struct kvm_pmc *get_gp_pmc(struct kvm_pmu *pmu, u32 msr,
 }
 
 /* returns fixed PMC with the specified MSR */
-static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
+static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu,
+					    u32 msr, u32 base)
 {
-	int base = MSR_CORE_PERF_FIXED_CTR0;
-
 	if (msr >= base && msr < base + pmu->nr_arch_fixed_counters) {
 		u32 index = array_index_nospec(msr - base,
 					       pmu->nr_arch_fixed_counters);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index a706d3597720..c10cb3008bf1 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -44,7 +44,8 @@ static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 		u8 old_ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl, i);
 		struct kvm_pmc *pmc;
 
-		pmc = get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i);
+		pmc = get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i,
+				    MSR_CORE_PERF_FIXED_CTR0);
 
 		if (old_ctrl == new_ctrl)
 			continue;
@@ -114,7 +115,8 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 	else {
 		u32 idx = pmc_idx - INTEL_PMC_IDX_FIXED;
 
-		return get_fixed_pmc(pmu, idx + MSR_CORE_PERF_FIXED_CTR0);
+		return get_fixed_pmc(pmu, idx + MSR_CORE_PERF_FIXED_CTR0,
+				     MSR_CORE_PERF_FIXED_CTR0);
 	}
 }
 
@@ -222,7 +224,8 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
-			get_fixed_pmc(pmu, msr) || get_fw_gp_pmc(pmu, msr) ||
+			get_fixed_pmc(pmu, msr, MSR_CORE_PERF_FIXED_CTR0) ||
+			get_fw_gp_pmc(pmu, msr) ||
 			intel_pmu_is_valid_lbr_msr(vcpu, msr);
 		break;
 	}
@@ -235,7 +238,7 @@ static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
 
-	pmc = get_fixed_pmc(pmu, msr);
+	pmc = get_fixed_pmc(pmu, msr, MSR_CORE_PERF_FIXED_CTR0);
 	pmc = pmc ? pmc : get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0);
 	pmc = pmc ? pmc : get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0);
 
@@ -382,7 +385,8 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			msr_info->data =
 				val & pmu->counter_bitmask[KVM_PMC_GP];
 			return 0;
-		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
+		} else if ((pmc = get_fixed_pmc(pmu, msr,
+						MSR_CORE_PERF_FIXED_CTR0))) {
 			u64 val = pmc_read_counter(pmc);
 			msr_info->data =
 				val & pmu->counter_bitmask[KVM_PMC_FIXED];
@@ -470,7 +474,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				perf_event_period(pmc->perf_event,
 						  get_sample_period(pmc, data));
 			return 0;
-		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
+		} else if ((pmc = get_fixed_pmc(pmu, msr,
+						MSR_CORE_PERF_FIXED_CTR0))) {
 			pmc->counter += data - pmc_read_counter(pmc);
 			if (pmc->perf_event)
 				perf_event_period(pmc->perf_event,
-- 
2.31.1

