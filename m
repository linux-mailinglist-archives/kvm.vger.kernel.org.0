Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFF3DE622B
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2019 12:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfJ0LNJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Oct 2019 07:13:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:12491 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbfJ0LMi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Oct 2019 07:12:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Oct 2019 04:12:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,236,1569308400"; 
   d="scan'208";a="282690158"
Received: from unknown (HELO snr.jf.intel.com) ([10.54.39.141])
  by orsmga001.jf.intel.com with ESMTP; 27 Oct 2019 04:12:36 -0700
From:   Luwei Kang <luwei.kang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, ak@linux.intel.com, thomas.lendacky@amd.com,
        peterz@infradead.org, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v1 3/8] KVM: x86: Allocate performance counter for PEBS event
Date:   Sun, 27 Oct 2019 19:11:12 -0400
Message-Id: <1572217877-26484-4-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
References: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch add a new parameter "pebs" that to make the
host PMU framework allocate the performance counter for
guest PEBS event.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 arch/x86/kvm/pmu.c           | 23 +++++++++++++++--------
 arch/x86/kvm/pmu.h           |  5 +++--
 arch/x86/kvm/pmu_amd.c       |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c | 10 +++++-----
 4 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 46875bb..5088d1c 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -99,7 +99,7 @@ static void kvm_perf_overflow_intr(struct perf_event *perf_event,
 static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 				  unsigned config, bool exclude_user,
 				  bool exclude_kernel, bool intr,
-				  bool in_tx, bool in_tx_cp)
+				  bool in_tx, bool in_tx_cp, bool pebs)
 {
 	struct perf_event *event;
 	struct perf_event_attr attr = {
@@ -111,9 +111,12 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		.exclude_user = exclude_user,
 		.exclude_kernel = exclude_kernel,
 		.config = config,
+		.precise_ip = pebs ? 1 : 0,
+		.aux_output = pebs ? 1 : 0,
 	};
 
-	attr.sample_period = (-pmc->counter) & pmc_bitmask(pmc);
+	attr.sample_period = pebs ? (-pmc->reload_cnt) & pmc_bitmask(pmc) :
+					(-pmc->counter) & pmc_bitmask(pmc);
 
 	if (in_tx)
 		attr.config |= HSW_IN_TX;
@@ -140,7 +143,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 	clear_bit(pmc->idx, (unsigned long*)&pmc_to_pmu(pmc)->reprogram_pmi);
 }
 
-void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
+void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel, bool pebs)
 {
 	unsigned config, type = PERF_TYPE_RAW;
 	u8 event_select, unit_mask;
@@ -198,11 +201,12 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 			      !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
 			      eventsel & ARCH_PERFMON_EVENTSEL_INT,
 			      (eventsel & HSW_IN_TX),
-			      (eventsel & HSW_IN_TX_CHECKPOINTED));
+			      (eventsel & HSW_IN_TX_CHECKPOINTED),
+			      pebs);
 }
 EXPORT_SYMBOL_GPL(reprogram_gp_counter);
 
-void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
+void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx, bool pebs)
 {
 	unsigned en_field = ctrl & 0x3;
 	bool pmi = ctrl & 0x8;
@@ -228,7 +232,8 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 			      kvm_x86_ops->pmu_ops->find_fixed_event(idx),
 			      !(en_field & 0x2), /* exclude user */
 			      !(en_field & 0x1), /* exclude kernel */
-			      pmi, false, false);
+			      pmi, false, false,
+			      pebs);
 }
 EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
 
@@ -240,12 +245,14 @@ void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx)
 		return;
 
 	if (pmc_is_gp(pmc))
-		reprogram_gp_counter(pmc, pmc->eventsel);
+		reprogram_gp_counter(pmc, pmc->eventsel,
+				(pmu->pebs_enable & BIT_ULL(pmc_idx)));
 	else {
 		int idx = pmc_idx - INTEL_PMC_IDX_FIXED;
 		u8 ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl, idx);
 
-		reprogram_fixed_counter(pmc, ctrl, idx);
+		reprogram_fixed_counter(pmc, ctrl, idx,
+				(pmu->pebs_enable & BIT_ULL(pmc_idx)));
 	}
 }
 EXPORT_SYMBOL_GPL(reprogram_counter);
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index c62a1ff..0c59a15 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -102,8 +102,9 @@ static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr,
 	return NULL;
 }
 
-void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
-void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
+void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel, bool pebs);
+void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx,
+								bool pebs);
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
 
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
index c838838..7b3e307 100644
--- a/arch/x86/kvm/pmu_amd.c
+++ b/arch/x86/kvm/pmu_amd.c
@@ -248,7 +248,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data == pmc->eventsel)
 			return 0;
 		if (!(data & pmu->reserved_bits)) {
-			reprogram_gp_counter(pmc, data);
+			reprogram_gp_counter(pmc, data, false);
 			return 0;
 		}
 	}
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 3f723a3..15b5f05 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -48,7 +48,8 @@ static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 		if (old_ctrl == new_ctrl)
 			continue;
 
-		reprogram_fixed_counter(pmc, new_ctrl, i);
+		reprogram_fixed_counter(pmc, new_ctrl, i,
+			(pmu->pebs_enable & BIT_ULL(i + INTEL_PMC_IDX_FIXED)));
 	}
 
 	pmu->fixed_ctr_ctrl = data;
@@ -292,7 +293,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if (data == pmc->eventsel)
 				return 0;
 			if (!(data & pmu->reserved_bits)) {
-				reprogram_gp_counter(pmc, data);
+				reprogram_gp_counter(pmc, data,
+					(pmu->pebs_enable & BIT_ULL(pmc->idx)));
 				return 0;
 			}
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_RELOAD_PMC0)) ||
@@ -301,10 +303,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if (data == pmc->reload_cnt)
 				return 0;
 			if (!(data & ~pmc_bitmask(pmc))) {
-				int pmc_idx = pmc_is_fixed(pmc) ? pmc->idx +
-						INTEL_PMC_IDX_FIXED : pmc->idx;
 				pmc->reload_cnt = data;
-				reprogram_counter(pmu, pmc_idx);
+				reprogram_counter(pmu, pmc->idx);
 				return 0;
 			}
 		}
-- 
1.8.3.1

