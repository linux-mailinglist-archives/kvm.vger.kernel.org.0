Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB84E621F
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2019 12:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfJ0LMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Oct 2019 07:12:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:12491 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726816AbfJ0LMi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Oct 2019 07:12:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Oct 2019 04:12:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,236,1569308400"; 
   d="scan'208";a="282690149"
Received: from unknown (HELO snr.jf.intel.com) ([10.54.39.141])
  by orsmga001.jf.intel.com with ESMTP; 27 Oct 2019 04:12:35 -0700
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
Subject: [PATCH v1 2/8] KVM: x86: PEBS output to Intel PT MSRs emulation
Date:   Sun, 27 Oct 2019 19:11:11 -0400
Message-Id: <1572217877-26484-3-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
References: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel new hardware introduces a mechanism to direct PEBS records
output into the Intel PT buffer that can be used for enabling PEBS
in KVM guest. This patch implements the registers read and write
emulation when PEBS is supported in KVM guest.

KMM needs to reprogram the counters when the value of these MSRs
be changed that to make sure it can take effect in hardware.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 arch/x86/include/asm/kvm_host.h  |  4 +++
 arch/x86/include/asm/msr-index.h |  6 ++++
 arch/x86/kvm/vmx/capabilities.h  | 15 ++++++++++
 arch/x86/kvm/vmx/pmu_intel.c     | 63 ++++++++++++++++++++++++++++++++++++++--
 4 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 50eb430..ed01936 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -448,6 +448,7 @@ struct kvm_pmc {
 	enum pmc_type type;
 	u8 idx;
 	u64 counter;
+	u64 reload_cnt;
 	u64 eventsel;
 	struct perf_event *perf_event;
 	struct kvm_vcpu *vcpu;
@@ -465,7 +466,10 @@ struct kvm_pmu {
 	u64 global_ctrl_mask;
 	u64 global_ovf_ctrl_mask;
 	u64 reserved_bits;
+	u64 pebs_enable;
+	u64 pebs_enable_mask;
 	u8 version;
+	bool pebs_via_pt;	/* PEBS output to Intel PT */
 	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
 	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
 	struct irq_work irq_work;
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 20ce682..d22f8d9 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -131,9 +131,13 @@
 #define LBR_INFO_ABORT			BIT_ULL(61)
 #define LBR_INFO_CYCLES			0xffff
 
+#define MSR_IA32_PEBS_PMI_AFTER_REC	BIT_ULL(60)
+#define MSR_IA32_PEBS_OUTPUT_PT		BIT_ULL(61)
+#define MSR_IA32_PEBS_OUTPUT_MASK	(3ULL << 61)
 #define MSR_IA32_PEBS_ENABLE		0x000003f1
 #define MSR_PEBS_DATA_CFG		0x000003f2
 #define MSR_IA32_DS_AREA		0x00000600
+#define MSR_IA32_PERF_CAP_PEBS_OUTPUT_PT	BIT_ULL(16)
 #define MSR_IA32_PERF_CAPABILITIES	0x00000345
 #define MSR_PEBS_LD_LAT_THRESHOLD	0x000003f6
 
@@ -665,6 +669,8 @@
 #define MSR_IA32_MISC_ENABLE_FERR			(1ULL << MSR_IA32_MISC_ENABLE_FERR_BIT)
 #define MSR_IA32_MISC_ENABLE_FERR_MULTIPLEX_BIT		10
 #define MSR_IA32_MISC_ENABLE_FERR_MULTIPLEX		(1ULL << MSR_IA32_MISC_ENABLE_FERR_MULTIPLEX_BIT)
+#define MSR_IA32_MISC_ENABLE_PEBS_BIT			12
+#define MSR_IA32_MISC_ENABLE_PEBS			(1ULL << MSR_IA32_MISC_ENABLE_PEBS_BIT)
 #define MSR_IA32_MISC_ENABLE_TM2_BIT			13
 #define MSR_IA32_MISC_ENABLE_TM2			(1ULL << MSR_IA32_MISC_ENABLE_TM2_BIT)
 #define MSR_IA32_MISC_ENABLE_ADJ_PREF_DISABLE_BIT	19
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 7aa6971..fc861d4 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -348,4 +348,19 @@ static inline bool cpu_has_vmx_intel_pt(void)
 		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_RTIT_CTL);
 }
 
+static inline bool cpu_has_vmx_pebs_output_pt(void)
+{
+	u64 misc, perf_cap;
+
+	rdmsrl(MSR_IA32_MISC_ENABLE, misc);
+	rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
+
+	/*
+	 * Support Processor Event Based Sampling (PEBS) and
+	 * PEBS output to Intel PT.
+	 */
+	return (!(misc & MSR_IA32_MISC_ENABLE_PEBS) &&
+		(perf_cap & MSR_IA32_PERF_CAP_PEBS_OUTPUT_PT));
+}
+
 #endif /* __KVM_X86_VMX_CAPS_H */
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 2a485b5..3f723a3 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -12,6 +12,7 @@
 #include <linux/kvm_host.h>
 #include <linux/perf_event.h>
 #include <asm/perf_event.h>
+#include "capabilities.h"
 #include "x86.h"
 #include "cpuid.h"
 #include "lapic.h"
@@ -65,6 +66,20 @@ static void global_ctrl_changed(struct kvm_pmu *pmu, u64 data)
 		reprogram_counter(pmu, bit);
 }
 
+static void pebs_enable_changed(struct kvm_pmu *pmu, u64 data)
+{
+	int bit;
+	u64 mask = (BIT_ULL(pmu->nr_arch_gp_counters) - 1) |
+		((BIT_ULL(pmu->nr_arch_fixed_counters) - 1) <<
+						INTEL_PMC_IDX_FIXED);
+	u64 diff = (pmu->pebs_enable ^ data) & mask;
+
+	pmu->pebs_enable = data;
+
+	for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX)
+		reprogram_counter(pmu, bit);
+}
+
 static unsigned intel_find_arch_event(struct kvm_pmu *pmu,
 				      u8 event_select,
 				      u8 unit_mask)
@@ -154,10 +169,15 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		ret = pmu->version > 1;
 		break;
+	case MSR_IA32_PEBS_ENABLE:
+		ret = pmu->pebs_via_pt;
+		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
-			get_fixed_pmc(pmu, msr, MSR_CORE_PERF_FIXED_CTR0);
+			get_fixed_pmc(pmu, msr, MSR_CORE_PERF_FIXED_CTR0) ||
+			get_gp_pmc(pmu, msr, MSR_RELOAD_PMC0) ||
+			get_fixed_pmc(pmu, msr, MSR_RELOAD_FIXED_CTR0);
 		break;
 	}
 
@@ -182,6 +202,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		*data = pmu->global_ovf_ctrl;
 		return 0;
+	case MSR_IA32_PEBS_ENABLE:
+		*data = pmu->pebs_enable;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
 			u64 val = pmc_read_counter(pmc);
@@ -195,6 +218,11 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			*data = pmc->eventsel;
 			return 0;
+		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_RELOAD_PMC0)) ||
+			   (pmc = get_fixed_pmc(pmu, msr,
+						MSR_RELOAD_FIXED_CTR0))) {
+			*data = pmc->reload_cnt;
+			return 0;
 		}
 	}
 
@@ -239,6 +267,16 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
+	case MSR_IA32_PEBS_ENABLE:
+		if (pmu->pebs_enable == data)
+			return 0;
+		if (!data || (!(data & pmu->pebs_enable_mask) &&
+		     (data & MSR_IA32_PEBS_OUTPUT_MASK) ==
+						MSR_IA32_PEBS_OUTPUT_PT)) {
+			pebs_enable_changed(pmu, data);
+			return 0;
+		}
+		break;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
 			if (msr_info->host_initiated)
@@ -257,6 +295,18 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				reprogram_gp_counter(pmc, data);
 				return 0;
 			}
+		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_RELOAD_PMC0)) ||
+			   (pmc = get_fixed_pmc(pmu, msr,
+						MSR_RELOAD_FIXED_CTR0))) {
+			if (data == pmc->reload_cnt)
+				return 0;
+			if (!(data & ~pmc_bitmask(pmc))) {
+				int pmc_idx = pmc_is_fixed(pmc) ? pmc->idx +
+						INTEL_PMC_IDX_FIXED : pmc->idx;
+				pmc->reload_cnt = data;
+				reprogram_counter(pmu, pmc_idx);
+				return 0;
+			}
 		}
 	}
 
@@ -308,14 +358,23 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 
 	pmu->global_ctrl = ((1ull << pmu->nr_arch_gp_counters) - 1) |
 		(((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED);
+
 	pmu->global_ctrl_mask = ~pmu->global_ctrl;
 	pmu->global_ovf_ctrl_mask = pmu->global_ctrl_mask
 			& ~(MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF |
 			    MSR_CORE_PERF_GLOBAL_OVF_CTRL_COND_CHGD);
-	if (kvm_x86_ops->pt_supported())
+	if (kvm_x86_ops->pt_supported()) {
 		pmu->global_ovf_ctrl_mask &=
 				~MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI;
 
+		if (cpu_has_vmx_pebs_output_pt()) {
+			pmu->pebs_via_pt = true;
+			pmu->pebs_enable_mask = ~(pmu->global_ctrl |
+					MSR_IA32_PEBS_PMI_AFTER_REC |
+					MSR_IA32_PEBS_OUTPUT_MASK);
+		}
+	}
+
 	entry = kvm_find_cpuid_entry(vcpu, 7, 0);
 	if (entry &&
 	    (boot_cpu_has(X86_FEATURE_HLE) || boot_cpu_has(X86_FEATURE_RTM)) &&
-- 
1.8.3.1

