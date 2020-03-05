Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A823317A2B9
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 11:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgCEKAO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 05:00:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:16971 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727052AbgCEKAM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 05:00:12 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 02:00:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,517,1574150400"; 
   d="scan'208";a="234366830"
Received: from snr.bj.intel.com ([10.240.193.90])
  by orsmga008.jf.intel.com with ESMTP; 05 Mar 2020 02:00:05 -0800
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
        kan.liang@linux.intel.com, like.xu@linux.intel.com,
        Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v1 11/11] KVM: x86/pmu: Adaptive PEBS virtualization enabling
Date:   Fri,  6 Mar 2020 01:57:05 +0800
Message-Id: <1583431025-19802-12-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
References: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PEBS feature enabled the collection of the GPRs, eventing IP, TSC and
memory access related information. On Icelake, it has been enhanced to collect
more CPU state information like XMM register values, and LBR To and FROM
addresses as per customer usage requests. With the addition of these new
groups of data, the PEBS record size is greatly increased. Adaptive PEBS
provides Software the capability to configure the PEBS records to capture
only the data of interest, keeping the record size compact. By default, the
PEBS record will only contain the Basic group. Optionally, each counter can
be configured to generate a PEBS records with the groups specified in
MSR_PEBS_DATA_CFG.

This patch implement the adaptive PEBS virtualization enabling in
KVM guest, include feature detection, MSRs emulation, expose
capability.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 arch/x86/include/asm/kvm_host.h  |  3 +++
 arch/x86/include/asm/msr-index.h |  1 +
 arch/x86/kvm/pmu.h               |  1 +
 arch/x86/kvm/vmx/pmu_intel.c     | 46 ++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/x86.c               |  6 ++++++
 5 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6f82fb7..7b0a023 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -482,6 +482,8 @@ struct kvm_pmu {
 	u64 pebs_enable;
 	u64 pebs_enable_mask;
 	u64 ds_area;
+	u64 pebs_data_cfg;
+	u64 pebs_data_cfg_mask;
 	u64 perf_cap;
 	u8 version;
 	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
@@ -498,6 +500,7 @@ struct kvm_pmu {
 	bool need_cleanup;
 
 	bool has_pebs_via_ds;
+	bool has_pebs_adaptive;
 
 	/*
 	 * The total number of programmed perf_events and it helps to avoid
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 2bf66e9..d3d6e48 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -154,6 +154,7 @@
 #define PERF_CAP_PEBS_TRAP		BIT_ULL(6)
 #define PERF_CAP_ARCH_REG		BIT_ULL(7)
 #define PERF_CAP_PEBS_FORMAT		0xf00
+#define PERF_CAP_PEBS_BASELINE		BIT_ULL(14)
 #define MSR_PEBS_LD_LAT_THRESHOLD	0x000003f6
 
 #define MSR_IA32_RTIT_CTL		0x00000570
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 476780b..9de6ef1 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -33,6 +33,7 @@ struct kvm_pmu_ops {
 	int (*is_valid_rdpmc_ecx)(struct kvm_vcpu *vcpu, unsigned int idx);
 	bool (*is_valid_msr)(struct kvm_vcpu *vcpu, u32 msr);
 	bool (*is_pebs_via_ds_supported)(void);
+	bool (*is_pebs_baseline_supported)(void);
 	int (*get_msr)(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 	void (*refresh)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 578b830..6a0eef3 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -70,14 +70,21 @@ static void global_ctrl_changed(struct kvm_pmu *pmu, u64 data)
 static void pebs_enable_changed(struct kvm_pmu *pmu, u64 data)
 {
 	struct vcpu_vmx *vmx = to_vmx(pmu_to_vcpu(pmu));
-	u64 host_ds_area;
+	u64 host_ds_area, host_pebs_data_cfg;
 
 	if (data) {
 		rdmsrl_safe(MSR_IA32_DS_AREA, &host_ds_area);
 		add_atomic_switch_msr(vmx, MSR_IA32_DS_AREA,
 			pmu->ds_area, host_ds_area, false);
-	} else
+
+		rdmsrl_safe(MSR_PEBS_DATA_CFG, &host_pebs_data_cfg);
+		add_atomic_switch_msr(vmx, MSR_PEBS_DATA_CFG,
+			pmu->pebs_data_cfg, host_pebs_data_cfg, false);
+
+	} else {
 		clear_atomic_switch_msr(vmx, MSR_IA32_DS_AREA);
+		clear_atomic_switch_msr(vmx, MSR_PEBS_DATA_CFG);
+	}
 
 	pmu->pebs_enable = data;
 }
@@ -183,6 +190,9 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_IA32_PERF_CAPABILITIES:
 		ret = pmu->has_pebs_via_ds;
 		break;
+	case MSR_PEBS_DATA_CFG:
+		ret = pmu->has_pebs_adaptive;
+		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
@@ -209,6 +219,18 @@ static bool intel_is_pebs_via_ds_supported(void)
 	return true;
 }
 
+static bool intel_is_pebs_baseline_supported(void)
+{
+	u64 perf_cap;
+
+	rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
+	if (intel_is_pebs_via_ds_supported() &&
+			(perf_cap & PERF_CAP_PEBS_BASELINE))
+		return true;
+
+	return false;
+}
+
 static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -245,6 +267,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 	case MSR_IA32_DS_AREA:
 		*data = pmu->ds_area;
 		return 0;
+	case MSR_PEBS_DATA_CFG:
+		*data = pmu->pebs_data_cfg;
+		return 0;
 	case MSR_IA32_PERF_CAPABILITIES:
 		*data = pmu->perf_cap;
 		return 0;
@@ -315,6 +340,12 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_DS_AREA:
 		pmu->ds_area = data;
 		return 0;
+	case MSR_PEBS_DATA_CFG:
+		if (!(data & pmu->pebs_data_cfg_mask)) {
+			pmu->pebs_data_cfg = data;
+			return 0;
+		}
+		break;
 	case MSR_IA32_PERF_CAPABILITIES:
 		break; /* RO MSR */
 	default:
@@ -414,6 +445,16 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		pmu->perf_cap = (perf_cap & (PERF_CAP_PEBS_TRAP |
 					     PERF_CAP_ARCH_REG |
 					     PERF_CAP_PEBS_FORMAT));
+
+		if (perf_cap & PERF_CAP_PEBS_BASELINE) {
+			pmu->has_pebs_adaptive = 1;
+			pmu->perf_cap |= PERF_CAP_PEBS_BASELINE;
+			pmu->pebs_data_cfg_mask = ~0xff00000full;
+			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
+			for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
+				pmu->fixed_ctr_ctrl_mask &= ~(1ULL <<
+						(INTEL_PMC_IDX_FIXED + i * 4));
+		}
 	}
 
 	entry = kvm_find_cpuid_entry(vcpu, 7, 0);
@@ -484,6 +525,7 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.is_valid_rdpmc_ecx = intel_is_valid_rdpmc_ecx,
 	.is_valid_msr = intel_is_valid_msr,
 	.is_pebs_via_ds_supported = intel_is_pebs_via_ds_supported,
+	.is_pebs_baseline_supported = intel_is_pebs_baseline_supported,
 	.get_msr = intel_pmu_get_msr,
 	.set_msr = intel_pmu_set_msr,
 	.refresh = intel_pmu_refresh,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5ab8447..aa1344b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1194,6 +1194,7 @@ bool kvm_rdpmc(struct kvm_vcpu *vcpu)
 	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
 	MSR_IA32_PEBS_ENABLE, MSR_IA32_DS_AREA,
+	MSR_PEBS_DATA_CFG,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
@@ -5274,6 +5275,11 @@ static void kvm_init_msr_list(void)
 			    !kvm_x86_ops->pmu_ops->is_pebs_via_ds_supported())
 				continue;
 			break;
+		case MSR_PEBS_DATA_CFG:
+			if (!kvm_x86_ops->pmu_ops ||
+			    !kvm_x86_ops->pmu_ops->is_pebs_baseline_supported())
+				continue;
+			break;
 		case MSR_IA32_RTIT_CTL:
 		case MSR_IA32_RTIT_STATUS:
 			if (!kvm_x86_ops->pt_supported())
-- 
1.8.3.1

