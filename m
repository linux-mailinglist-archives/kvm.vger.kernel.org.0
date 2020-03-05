Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A69617A2B2
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 11:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgCEJ7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 04:59:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:51102 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbgCEJ7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 04:59:49 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 01:59:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,517,1574150400"; 
   d="scan'208";a="234366630"
Received: from snr.bj.intel.com ([10.240.193.90])
  by orsmga008.jf.intel.com with ESMTP; 05 Mar 2020 01:59:42 -0800
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
Subject: [PATCH v1 08/11] KVM: x86/pmu: PEBS MSRs emulation
Date:   Fri,  6 Mar 2020 01:57:02 +0800
Message-Id: <1583431025-19802-9-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
References: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implement the PEBS MSRs emulation in KVM, include
IA32_PEBS_ENABLE and IA32_DS_AREA.

The IA32_DS_AREA register will be added into the MSR-load list when PEBS is
enabled in KVM guest that to make the guest's DS value can be loaded to the
real HW before VM-entry, and will be removed when PEBS is disabled.

Originally-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Luwei Kang <luwei.kang@intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++++
 arch/x86/kvm/vmx/pmu_intel.c    | 45 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  4 ++--
 arch/x86/kvm/vmx/vmx.h          |  4 ++++
 arch/x86/kvm/x86.c              |  7 +++++++
 5 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 033d9f9..33b990b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -479,6 +479,8 @@ struct kvm_pmu {
 	u64 global_ovf_ctrl_mask;
 	u64 reserved_bits;
 	u64 pebs_enable;
+	u64 pebs_enable_mask;
+	u64 ds_area;
 	u8 version;
 	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
 	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
@@ -493,6 +495,8 @@ struct kvm_pmu {
 	 */
 	bool need_cleanup;
 
+	bool has_pebs_via_ds;
+
 	/*
 	 * The total number of programmed perf_events and it helps to avoid
 	 * redundant check before cleanup if guest don't use vPMU at all.
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index a67bd34..227589a 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -67,6 +67,21 @@ static void global_ctrl_changed(struct kvm_pmu *pmu, u64 data)
 		reprogram_counter(pmu, bit);
 }
 
+static void pebs_enable_changed(struct kvm_pmu *pmu, u64 data)
+{
+	struct vcpu_vmx *vmx = to_vmx(pmu_to_vcpu(pmu));
+	u64 host_ds_area;
+
+	if (data) {
+		rdmsrl_safe(MSR_IA32_DS_AREA, &host_ds_area);
+		add_atomic_switch_msr(vmx, MSR_IA32_DS_AREA,
+			pmu->ds_area, host_ds_area, false);
+	} else
+		clear_atomic_switch_msr(vmx, MSR_IA32_DS_AREA);
+
+	pmu->pebs_enable = data;
+}
+
 static unsigned intel_find_arch_event(struct kvm_pmu *pmu,
 				      u8 event_select,
 				      u8 unit_mask)
@@ -163,6 +178,10 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		ret = pmu->version > 1;
 		break;
+	case MSR_IA32_DS_AREA:
+	case MSR_IA32_PEBS_ENABLE:
+		ret = pmu->has_pebs_via_ds;
+		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
@@ -219,6 +238,12 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		*data = pmu->global_ovf_ctrl;
 		return 0;
+	case MSR_IA32_PEBS_ENABLE:
+		*data = pmu->pebs_enable;
+		return 0;
+	case MSR_IA32_DS_AREA:
+		*data = pmu->ds_area;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
 			u64 val = pmc_read_counter(pmc);
@@ -275,6 +300,17 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
+	case MSR_IA32_PEBS_ENABLE:
+		if (pmu->pebs_enable == data)
+			return 0;
+		if (!(data & pmu->pebs_enable_mask)) {
+			pebs_enable_changed(pmu, data);
+			return 0;
+		}
+		break;
+	case MSR_IA32_DS_AREA:
+		pmu->ds_area = data;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
 			if (!msr_info->host_initiated)
@@ -351,6 +387,15 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		pmu->global_ovf_ctrl_mask &=
 				~MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI;
 
+	entry = kvm_find_cpuid_entry(vcpu, 1, 0);
+	if (entry && (entry->ecx & X86_FEATURE_DTES64) &&
+		     (entry->ecx & X86_FEATURE_PDCM) &&
+		     (entry->edx & X86_FEATURE_DS) &&
+		      intel_is_pebs_via_ds_supported()) {
+		pmu->has_pebs_via_ds = 1;
+		pmu->pebs_enable_mask = ~pmu->global_ctrl;
+	}
+
 	entry = kvm_find_cpuid_entry(vcpu, 7, 0);
 	if (entry &&
 	    (boot_cpu_has(X86_FEATURE_HLE) || boot_cpu_has(X86_FEATURE_RTM)) &&
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cef7089..c6d9a87 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -864,7 +864,7 @@ int vmx_find_msr_index(struct vmx_msrs *m, u32 msr)
 	return -ENOENT;
 }
 
-static void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr)
+void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr)
 {
 	int i;
 	struct msr_autoload *m = &vmx->msr_autoload;
@@ -916,7 +916,7 @@ static void add_atomic_switch_msr_special(struct vcpu_vmx *vmx,
 	vm_exit_controls_setbit(vmx, exit);
 }
 
-static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
+void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 				  u64 guest_val, u64 host_val, bool entry_only)
 {
 	int i, j = 0;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index e64da06..ea899e7 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -536,4 +536,8 @@ static inline bool vmx_has_waitpkg(struct vcpu_vmx *vmx)
 
 void dump_vmcs(void);
 
+extern void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr);
+extern void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
+			u64 guest_val, u64 host_val, bool entry_only);
+
 #endif /* __KVM_X86_VMX_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5de2006..7a23406 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1193,6 +1193,7 @@ bool kvm_rdpmc(struct kvm_vcpu *vcpu)
 	MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
+	MSR_IA32_PEBS_ENABLE, MSR_IA32_DS_AREA,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
@@ -5263,6 +5264,12 @@ static void kvm_init_msr_list(void)
 			if (!kvm_x86_ops->rdtscp_supported())
 				continue;
 			break;
+		case MSR_IA32_PEBS_ENABLE:
+		case MSR_IA32_DS_AREA:
+			if (!kvm_x86_ops->pmu_ops ||
+			    !kvm_x86_ops->pmu_ops->is_pebs_via_ds_supported())
+				continue;
+			break;
 		case MSR_IA32_RTIT_CTL:
 		case MSR_IA32_RTIT_STATUS:
 			if (!kvm_x86_ops->pt_supported())
-- 
1.8.3.1

