Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80085A10F2
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 07:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbfH2FjI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 01:39:08 -0400
Received: from mga17.intel.com ([192.55.52.151]:42121 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727447AbfH2FjI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 01:39:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 22:39:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,442,1559545200"; 
   d="scan'208";a="210416213"
Received: from icl-2s.bj.intel.com ([10.240.193.48])
  by fmsmga002.fm.intel.com with ESMTP; 28 Aug 2019 22:39:02 -0700
From:   Luwei Kang <luwei.kang@intel.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, ak@linux.intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luwei Kang <luwei.kang@intel.com>
Subject: [RFC v1 3/9] KVM: x86: Implement MSR_IA32_PEBS_ENABLE read/write emulation
Date:   Thu, 29 Aug 2019 13:34:03 +0800
Message-Id: <1567056849-14608-4-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567056849-14608-1-git-send-email-luwei.kang@intel.com>
References: <1567056849-14608-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements the MSR_IA32_PEBS_ENABLE register
read/write emulation for KVM guest. MSR_IA32_PEBS_ENABLE
register can be accessed only when PEBS is supported in KVM.

VMM need to reprogram the counter when the value of this MSR
changed because some of the counters will be created or destroyed.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 arch/x86/include/asm/kvm_host.h  |  2 ++
 arch/x86/include/asm/msr-index.h |  3 +++
 arch/x86/kvm/vmx/pmu_intel.c     | 42 +++++++++++++++++++++++++++++++++++++---
 3 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3463326..df966c9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -471,6 +471,8 @@ struct kvm_pmu {
 	u64 global_ctrl_mask;
 	u64 global_ovf_ctrl_mask;
 	u64 reserved_bits;
+	u64 pebs_enable;
+	u64 pebs_enable_mask;
 	u8 version;
 	bool pebs_pt;	/* PEBS output to Intel PT */
 	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 3dd166a..a9e8720 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -131,6 +131,9 @@
 #define LBR_INFO_ABORT			BIT_ULL(61)
 #define LBR_INFO_CYCLES			0xffff
 
+#define MSR_IA32_PEBS_PMI_AFTER_REC	(1UL << 60)
+#define MSR_IA32_PEBS_OUTPUT_PT		(1UL << 61)
+#define MSR_IA32_PEBS_OUTPUT_MASK	(3UL << 61)
 #define MSR_IA32_PEBS_ENABLE		0x000003f1
 #define MSR_PEBS_DATA_CFG		0x000003f2
 #define MSR_IA32_DS_AREA		0x00000600
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index e1c987f..fc79cc6 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -66,6 +66,20 @@ static void global_ctrl_changed(struct kvm_pmu *pmu, u64 data)
 		reprogram_counter(pmu, bit);
 }
 
+static void pebs_enable_changed(struct kvm_pmu *pmu, u64 data)
+{
+	int bit;
+	u64 mask = ((1ull << pmu->nr_arch_gp_counters) - 1) |
+		(((1ull << pmu->nr_arch_fixed_counters) - 1) <<
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
@@ -155,6 +169,9 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		ret = pmu->version > 1;
 		break;
+	case MSR_IA32_PEBS_ENABLE:
+		ret = pmu->pebs_pt;
+		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
@@ -183,6 +200,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		*data = pmu->global_ovf_ctrl;
 		return 0;
+	case MSR_IA32_PEBS_ENABLE:
+		*data = pmu->pebs_enable;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
 			u64 val = pmc_read_counter(pmc);
@@ -240,6 +260,16 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
+	case MSR_IA32_PEBS_ENABLE:
+		if (pmu->pebs_enable == data)
+			return 0;
+		if (!(data & pmu->pebs_enable_mask) &&
+		     (data & MSR_IA32_PEBS_OUTPUT_MASK) ==
+						MSR_IA32_PEBS_OUTPUT_PT) {
+			pebs_enable_changed(pmu, data);
+			return 0;
+		}
+		break;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
 			if (msr_info->host_initiated)
@@ -270,6 +300,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	struct kvm_cpuid_entry2 *entry;
 	union cpuid10_eax eax;
 	union cpuid10_edx edx;
+	u64 cnts_mask;
 
 	pmu->nr_arch_gp_counters = 0;
 	pmu->nr_arch_fixed_counters = 0;
@@ -304,9 +335,10 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 			((u64)1 << edx.split.bit_width_fixed) - 1;
 	}
 
-	pmu->global_ctrl = ((1ull << pmu->nr_arch_gp_counters) - 1) |
+	cnts_mask = ((1ull << pmu->nr_arch_gp_counters) - 1) |
 		(((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED);
-	pmu->global_ctrl_mask = ~pmu->global_ctrl;
+
+	pmu->global_ctrl_mask = ~cnts_mask;
 	pmu->global_ovf_ctrl_mask = pmu->global_ctrl_mask
 			& ~(MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF |
 			    MSR_CORE_PERF_GLOBAL_OVF_CTRL_COND_CHGD);
@@ -314,8 +346,12 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		pmu->global_ovf_ctrl_mask &=
 				~MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI;
 
-		if (cpu_has_vmx_pebs_output_pt())
+		if (cpu_has_vmx_pebs_output_pt()) {
 			pmu->pebs_pt = true;
+			pmu->pebs_enable_mask = ~(cnts_mask |
+					MSR_IA32_PEBS_PMI_AFTER_REC |
+					MSR_IA32_PEBS_OUTPUT_MASK);
+		}
 	}
 
 	entry = kvm_find_cpuid_entry(vcpu, 7, 0);
-- 
1.8.3.1

