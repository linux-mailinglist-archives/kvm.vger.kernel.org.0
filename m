Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC6518ACD4
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 07:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbgCSGfx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 02:35:53 -0400
Received: from mga07.intel.com ([134.134.136.100]:53530 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727120AbgCSGfw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 02:35:52 -0400
IronPort-SDR: JhQwyoD1zybLXHyd4e4sop52SYKUtukwJPnroOGBbxCFGM7+MfMf8NiKjjMBXj4vKzf8a/d0Vo
 FQW+j6k+Jnmg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 23:35:52 -0700
IronPort-SDR: 4RkaYS/Mfpl/sbXysiJGLMeWazWpGn5QMfwNlC7zjmnPwbb3paiyv5ucG0CmKR4/USgTue7++J
 Zn9XFzn1/0vA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,570,1574150400"; 
   d="scan'208";a="248439144"
Received: from snr.bj.intel.com ([10.240.193.90])
  by orsmga006.jf.intel.com with ESMTP; 18 Mar 2020 23:35:46 -0700
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
Subject: [PATCH v2 3/5] KVM: x86/pmu: PEBS output Intel PT MSRs emulation
Date:   Thu, 19 Mar 2020 22:33:48 +0800
Message-Id: <1584628430-23220-4-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584628430-23220-1-git-send-email-luwei.kang@intel.com>
References: <1584628430-23220-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PEBS output to PT introduce a mechanism to direct PEBS output into
the Intel PT output stream and new performance monitoring counter
reload MSRs, which are used by PEBS in place of the counter reload
values stored in the DS management area when PEBS output is directed
into the Intel PT output stream.

This patch implements the reload MSRs read/write emulation and update
the mask value of MSR_IA32_PEBS_ENABLE register.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 arch/x86/events/perf_event.h     |  5 -----
 arch/x86/include/asm/kvm_host.h  |  2 ++
 arch/x86/include/asm/msr-index.h |  5 +++++
 arch/x86/kvm/vmx/pmu_intel.c     | 42 +++++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/x86.c               | 32 ++++++++++++++++++++++++++++++
 5 files changed, 76 insertions(+), 10 deletions(-)

diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 621529c..957adbb 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -87,11 +87,6 @@ struct amd_nb {
 };
 
 #define PEBS_COUNTER_MASK	((1ULL << MAX_PEBS_EVENTS) - 1)
-#define PEBS_PMI_AFTER_EACH_RECORD BIT_ULL(60)
-#define PEBS_OUTPUT_OFFSET	61
-#define PEBS_OUTPUT_MASK	(3ull << PEBS_OUTPUT_OFFSET)
-#define PEBS_OUTPUT_PT		(1ull << PEBS_OUTPUT_OFFSET)
-#define PEBS_VIA_PT_MASK	(PEBS_OUTPUT_PT | PEBS_PMI_AFTER_EACH_RECORD)
 
 /*
  * Flags PEBS can handle without an PMI.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7b0a023..bba7270 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -456,6 +456,7 @@ struct kvm_pmc {
 	enum pmc_type type;
 	u8 idx;
 	u64 counter;
+	u64 reload_cnt;
 	u64 eventsel;
 	struct perf_event *perf_event;
 	struct kvm_vcpu *vcpu;
@@ -500,6 +501,7 @@ struct kvm_pmu {
 	bool need_cleanup;
 
 	bool has_pebs_via_ds;
+	bool has_pebs_via_pt;
 	bool has_pebs_adaptive;
 
 	/*
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 750a2d5..768e61c 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -148,6 +148,11 @@
 #define LBR_INFO_CYCLES			0xffff
 
 #define MSR_IA32_PEBS_ENABLE		0x000003f1
+#define PEBS_PMI_AFTER_EACH_RECORD	BIT_ULL(60)
+#define PEBS_OUTPUT_OFFSET		61
+#define PEBS_OUTPUT_MASK		(3ull << PEBS_OUTPUT_OFFSET)
+#define PEBS_OUTPUT_PT			(1ull << PEBS_OUTPUT_OFFSET)
+#define PEBS_VIA_PT_MASK		(PEBS_OUTPUT_PT | PEBS_PMI_AFTER_EACH_RECORD)
 #define MSR_PEBS_DATA_CFG		0x000003f2
 #define MSR_IA32_DS_AREA		0x00000600
 #define MSR_IA32_PERF_CAPABILITIES	0x00000345
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index f04e5eb..a8b0a8d 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -188,9 +188,11 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 		ret = pmu->version > 1;
 		break;
 	case MSR_IA32_DS_AREA:
+		ret = pmu->has_pebs_via_ds;
+		break;
 	case MSR_IA32_PEBS_ENABLE:
 	case MSR_IA32_PERF_CAPABILITIES:
-		ret = pmu->has_pebs_via_ds;
+		ret = pmu->has_pebs_via_ds || pmu->has_pebs_via_pt;
 		break;
 	case MSR_PEBS_DATA_CFG:
 		ret = pmu->has_pebs_adaptive;
@@ -199,6 +201,9 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
 			get_fixed_pmc(pmu, msr, MSR_CORE_PERF_FIXED_CTR0);
+		if (!ret && pmu->has_pebs_via_pt)
+			ret = get_gp_pmc(pmu, msr, MSR_RELOAD_PMC0) ||
+				get_fixed_pmc(pmu, msr, MSR_RELOAD_FIXED_CTR0);
 		break;
 	}
 
@@ -253,6 +258,11 @@ static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
 	pmc = get_fixed_pmc(pmu, msr, MSR_CORE_PERF_FIXED_CTR0);
 	pmc = pmc ? pmc : get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0);
 	pmc = pmc ? pmc : get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0);
+	if (!pmc && pmu->has_pebs_via_pt) {
+		pmc = pmc ? pmc : get_gp_pmc(pmu, msr, MSR_RELOAD_PMC0);
+		pmc = pmc ? pmc :
+			get_fixed_pmc(pmu, msr, MSR_RELOAD_FIXED_CTR0);
+	}
 
 	return pmc;
 }
@@ -300,6 +310,11 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			*data = pmc->eventsel;
 			return 0;
+		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_RELOAD_PMC0)) ||
+				(pmc = get_fixed_pmc(pmu, msr,
+						MSR_RELOAD_FIXED_CTR0))) {
+			*data = pmc->reload_cnt;
+			return 0;
 		}
 	}
 
@@ -380,6 +395,13 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				reprogram_gp_counter(pmc, data);
 				return 0;
 			}
+		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_RELOAD_PMC0)) ||
+			(pmc = get_fixed_pmc(pmu, msr,
+				MSR_RELOAD_FIXED_CTR0))) {
+			if (!(data & ~pmc_bitmask(pmc))) {
+				pmc->reload_cnt = data;
+				return 0;
+			}
 		}
 	}
 
@@ -449,14 +471,17 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	if (entry && (entry->ecx & X86_FEATURE_DTES64) &&
 		     (entry->ecx & X86_FEATURE_PDCM) &&
 		     (entry->edx & X86_FEATURE_DS) &&
-		      intel_is_pebs_via_ds_supported()) {
+		      intel_is_pebs_via_ds_supported())
 		pmu->has_pebs_via_ds = 1;
-		pmu->pebs_enable_mask = ~pmu->global_ctrl;
-	}
 
-	if (pmu->has_pebs_via_ds) {
+	if (intel_is_pebs_via_pt_supported())
+		pmu->has_pebs_via_pt = 1;
+
+	if (pmu->has_pebs_via_ds || pmu->has_pebs_via_pt) {
 		u64 perf_cap;
 
+		pmu->pebs_enable_mask = ~pmu->global_ctrl;
+
 		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
 		pmu->perf_cap = (perf_cap & (PERF_CAP_PEBS_TRAP |
 					     PERF_CAP_ARCH_REG |
@@ -471,6 +496,11 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 				pmu->fixed_ctr_ctrl_mask &= ~(1ULL <<
 						(INTEL_PMC_IDX_FIXED + i * 4));
 		}
+
+		if (pmu->has_pebs_via_pt) {
+			pmu->pebs_enable_mask &= ~PEBS_VIA_PT_MASK;
+			 pmu->perf_cap |= PERF_CAP_PEBS_OUTPUT_PT;
+		}
 	}
 
 	entry = kvm_find_cpuid_entry(vcpu, 7, 0);
@@ -497,6 +527,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->gp_counters[i].vcpu = vcpu;
 		pmu->gp_counters[i].idx = i;
 		pmu->gp_counters[i].current_config = 0;
+		pmu->gp_counters[i].reload_cnt = 0;
 	}
 
 	for (i = 0; i < INTEL_PMC_MAX_FIXED; i++) {
@@ -504,6 +535,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->fixed_counters[i].vcpu = vcpu;
 		pmu->fixed_counters[i].idx = i + INTEL_PMC_IDX_FIXED;
 		pmu->fixed_counters[i].current_config = 0;
+		pmu->fixed_counters[i].reload_cnt = 0;
 	}
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aa1344b..5031f50 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1193,6 +1193,17 @@ bool kvm_rdpmc(struct kvm_vcpu *vcpu)
 	MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
+	MSR_RELOAD_FIXED_CTR0, MSR_RELOAD_FIXED_CTR0 + 1,
+	MSR_RELOAD_FIXED_CTR0 + 2, MSR_RELOAD_FIXED_CTR0 + 3,
+	MSR_RELOAD_PMC0, MSR_RELOAD_PMC0 + 1,
+	MSR_RELOAD_PMC0 + 2, MSR_RELOAD_PMC0 + 3,
+	MSR_RELOAD_PMC0 + 4, MSR_RELOAD_PMC0 + 5,
+	MSR_RELOAD_PMC0 + 6, MSR_RELOAD_PMC0 + 7,
+	MSR_RELOAD_PMC0 + 8, MSR_RELOAD_PMC0 + 9,
+	MSR_RELOAD_PMC0 + 10, MSR_RELOAD_PMC0 + 11,
+	MSR_RELOAD_PMC0 + 12, MSR_RELOAD_PMC0 + 13,
+	MSR_RELOAD_PMC0 + 14, MSR_RELOAD_PMC0 + 15,
+	MSR_RELOAD_PMC0 + 16, MSR_RELOAD_PMC0 + 17,
 	MSR_IA32_PEBS_ENABLE, MSR_IA32_DS_AREA,
 	MSR_PEBS_DATA_CFG,
 };
@@ -5270,11 +5281,32 @@ static void kvm_init_msr_list(void)
 				continue;
 			break;
 		case MSR_IA32_PEBS_ENABLE:
+			if (!kvm_x86_ops->pmu_ops ||
+			   (!kvm_x86_ops->pmu_ops->is_pebs_via_ds_supported() &&
+			    !kvm_x86_ops->pmu_ops->is_pebs_via_pt_supported()))
+				continue;
+			break;
 		case MSR_IA32_DS_AREA:
 			if (!kvm_x86_ops->pmu_ops ||
 			    !kvm_x86_ops->pmu_ops->is_pebs_via_ds_supported())
 				continue;
 			break;
+		case MSR_RELOAD_FIXED_CTR0 ... MSR_RELOAD_FIXED_CTR0 + INTEL_PMC_MAX_FIXED:
+			if (!kvm_x86_ops->pmu_ops ||
+			    !kvm_x86_ops->pmu_ops->is_pebs_via_pt_supported())
+				continue;
+			if (msrs_to_save_all[i] - MSR_RELOAD_FIXED_CTR0 >=
+				min(INTEL_PMC_MAX_FIXED, x86_pmu.num_counters_fixed))
+				continue;
+			break;
+		case MSR_RELOAD_PMC0 ... MSR_RELOAD_PMC0 + 17:
+			if (!kvm_x86_ops->pmu_ops ||
+			    !kvm_x86_ops->pmu_ops->is_pebs_via_pt_supported())
+				continue;
+			if (msrs_to_save_all[i] - MSR_RELOAD_PMC0 >=
+				min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
+				continue;
+			break;
 		case MSR_PEBS_DATA_CFG:
 			if (!kvm_x86_ops->pmu_ops ||
 			    !kvm_x86_ops->pmu_ops->is_pebs_baseline_supported())
-- 
1.8.3.1

