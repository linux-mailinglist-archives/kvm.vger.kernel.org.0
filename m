Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0932E95E9
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 14:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbhADN0e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 08:26:34 -0500
Received: from mga07.intel.com ([134.134.136.100]:23250 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727048AbhADN0d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jan 2021 08:26:33 -0500
IronPort-SDR: Qj3i0dvR825hzxT+mf2etGN+Fj+3IgLo5wi0JGaI2+QyTNFmbu68UH9Xl+bYNzsWzDMhZSoUgq
 YUjrWHkAZHqw==
X-IronPort-AV: E=McAfee;i="6000,8403,9853"; a="241034343"
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="241034343"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 05:22:26 -0800
IronPort-SDR: zUO4EeqK75InJk4nv3cJdljoi8V6YmyefJgTp1a3LV+jk5mb7uX/3R0SzyENUQlChspxE0Z09Q
 +6TtZLAVhrDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="461944599"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga001.fm.intel.com with ESMTP; 04 Jan 2021 05:22:22 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>,
        Kan Liang <kan.liang@linux.intel.com>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH v3 08/17] KVM: x86/pmu: Add PEBS_DATA_CFG MSR emulation to support adaptive PEBS
Date:   Mon,  4 Jan 2021 21:15:33 +0800
Message-Id: <20210104131542.495413-9-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104131542.495413-1-like.xu@linux.intel.com>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If IA32_PERF_CAPABILITIES.PEBS_BASELINE [bit 14] is set, the adaptive
PEBS is supported. The PEBS_DATA_CFG MSR and adaptive record enable
bits (IA32_PERFEVTSELx.Adaptive_Record and IA32_FIXED_CTR_CTRL.
FCx_Adaptive_Record) are also supported.

Adaptive PEBS provides software the capability to configure the PEBS
records to capture only the data of interest, keeping the record size
compact. An overflow of PMCx results in generation of an adaptive PEBS
record with state information based on the selections specified in
MSR_PEBS_DATA_CFG (Memory Info [bit 0], GPRs [bit 1], XMMs [bit 2],
and LBRs [bit 3], LBR Entries [bit 31:24]). By default, the PEBS record
will only contain the Basic group.

When guest adaptive PEBS is enabled, the IA32_PEBS_ENABLE MSR will
be added to the perf_guest_switch_msr() and switched during the VMX
transitions just like CORE_PERF_GLOBAL_CTRL MSR.

Co-developed-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/intel/core.c    | 12 ++++++++++++
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/vmx/pmu_intel.c    | 16 ++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  5 ++++-
 4 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index ccddda455bec..736487e6c5e3 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3748,6 +3748,18 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
 		*nr = 3;
 	}
 
+	if (arr[1].guest && x86_pmu.intel_cap.pebs_baseline) {
+		arr[3].msr = MSR_PEBS_DATA_CFG;
+		arr[3].host = cpuc->pebs_data_cfg;
+		/* KVM will update MSR_PEBS_DATA_CFG with the trapped guest value. */
+		arr[3].guest = 0ull;
+		*nr = 4;
+	} else if (*nr == 3) {
+		arr[3].msr = MSR_PEBS_DATA_CFG;
+		arr[3].host = arr[3].guest = 0;
+		*nr = 4;
+	}
+
 	return arr;
 }
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 520a21af711b..4ff6aa00a325 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -452,6 +452,8 @@ struct kvm_pmu {
 	u64 ds_area;
 	u64 pebs_enable;
 	u64 pebs_enable_mask;
+	u64 pebs_data_cfg;
+	u64 pebs_data_cfg_mask;
 
 	/*
 	 * The gate to release perf_events not marked in
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index ff5fc405703f..c04e12812797 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -186,6 +186,9 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_IA32_DS_AREA:
 		ret = guest_cpuid_has(vcpu, X86_FEATURE_DS);
 		break;
+	case MSR_PEBS_DATA_CFG:
+		ret = vcpu->arch.perf_capabilities & PERF_CAP_PEBS_BASELINE;
+		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
@@ -233,6 +236,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_DS_AREA:
 		msr_info->data = pmu->ds_area;
 		return 0;
+	case MSR_PEBS_DATA_CFG:
+		msr_info->data = pmu->pebs_data_cfg;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -305,6 +311,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		pmu->ds_area = data;
 		return 0;
+	case MSR_PEBS_DATA_CFG:
+		if (pmu->pebs_data_cfg == data)
+			return 0;
+		if (!(data & pmu->pebs_data_cfg_mask)) {
+			pmu->pebs_data_cfg = data;
+			return 0;
+		}
+		break;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -355,6 +369,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->reserved_bits = 0xffffffff00200000ull;
 	pmu->fixed_ctr_ctrl_mask = ~0ull;
 	pmu->pebs_enable_mask = ~0ull;
+	pmu->pebs_data_cfg_mask = ~0ull;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry)
@@ -417,6 +432,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 			for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
 				pmu->fixed_ctr_ctrl_mask &=
 					~(1ULL << (INTEL_PMC_IDX_FIXED + i * 4));
+			pmu->pebs_data_cfg_mask = ~0xff00000full;
 		} else
 			pmu->pebs_enable_mask = ~((1ull << pmu->nr_arch_gp_counters) - 1);
 	} else {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 42c65acc6c01..dbb0e49aae64 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6531,8 +6531,11 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 	if (!msrs)
 		return;
 
-	if (nr_msrs > 2 && msrs[1].guest)
+	if (nr_msrs > 2 && msrs[1].guest) {
 		msrs[2].guest = pmu->ds_area;
+		if (nr_msrs > 3)
+			msrs[3].guest = pmu->pebs_data_cfg;
+	}
 
 	for (i = 0; i < nr_msrs; i++)
 		if (msrs[i].host == msrs[i].guest)
-- 
2.29.2

