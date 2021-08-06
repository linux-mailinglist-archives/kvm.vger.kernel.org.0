Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93B53E2BA1
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 15:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344312AbhHFNjp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 09:39:45 -0400
Received: from mga03.intel.com ([134.134.136.65]:4263 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344229AbhHFNji (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 09:39:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10068"; a="214398047"
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="214398047"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 06:39:21 -0700
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="523463685"
Received: from vmm_a4_icx.sh.intel.com (HELO localhost.localdomain) ([10.239.53.245])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 06:39:17 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     peterz@infradead.org, pbonzini@redhat.com
Cc:     bp@alien8.de, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, boris.ostrvsky@oracle.com,
        Like Xu <like.xu@linux.intel.com>,
        Luwei Kang <luwei.kang@intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V10 12/18] KVM: x86/pmu: Add PEBS_DATA_CFG MSR emulation to support adaptive PEBS
Date:   Fri,  6 Aug 2021 21:37:56 +0800
Message-Id: <20210806133802.3528-13-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210806133802.3528-1-lingshan.zhu@intel.com>
References: <20210806133802.3528-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

If IA32_PERF_CAPABILITIES.PEBS_BASELINE [bit 14] is set, the adaptive
PEBS is supported. The PEBS_DATA_CFG MSR and adaptive record enable
bits (IA32_PERFEVTSELx.Adaptive_Record and IA32_FIXED_CTR_CTRL.
FCx_Adaptive_Record) are also supported.

Adaptive PEBS provides software the capability to configure the PEBS
records to capture only the data of interest, keeping the record size
compact. An overflow of PMCx results in generation of an adaptive PEBS
record with state information based on the selections specified in
MSR_PEBS_DATA_CFG.By default, the record only contain the Basic group.

When guest adaptive PEBS is enabled, the IA32_PEBS_ENABLE MSR will
be added to the perf_guest_switch_msr() and switched during the VMX
transitions just like CORE_PERF_GLOBAL_CTRL MSR.

Co-developed-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/events/intel/core.c    |  8 ++++++++
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/vmx/pmu_intel.c    | 16 ++++++++++++++++
 3 files changed, 26 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 6501f8adb2b6..a698aae54fcb 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3960,6 +3960,14 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 		.guest = kvm_pmu->ds_area,
 	};
 
+	if (x86_pmu.intel_cap.pebs_baseline) {
+		arr[(*nr)++] = (struct perf_guest_switch_msr){
+			.msr = MSR_PEBS_DATA_CFG,
+			.host = cpuc->pebs_data_cfg,
+			.guest = kvm_pmu->pebs_data_cfg,
+		};
+	}
+
 	pebs_enable = (*nr)++;
 	arr[pebs_enable] = (struct perf_guest_switch_msr){
 		.msr = MSR_IA32_PEBS_ENABLE,
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 35f106f9f124..0fc1fef1af70 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -508,6 +508,8 @@ struct kvm_pmu {
 	u64 ds_area;
 	u64 pebs_enable;
 	u64 pebs_enable_mask;
+	u64 pebs_data_cfg;
+	u64 pebs_data_cfg_mask;
 
 	/*
 	 * The gate to release perf_events not marked in
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 5584b8dfadb3..58f32a55cc2e 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -226,6 +226,9 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_IA32_DS_AREA:
 		ret = guest_cpuid_has(vcpu, X86_FEATURE_DS);
 		break;
+	case MSR_PEBS_DATA_CFG:
+		ret = vcpu->arch.perf_capabilities & PERF_CAP_PEBS_BASELINE;
+		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
@@ -379,6 +382,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_DS_AREA:
 		msr_info->data = pmu->ds_area;
 		return 0;
+	case MSR_PEBS_DATA_CFG:
+		msr_info->data = pmu->pebs_data_cfg;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -452,6 +458,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -505,6 +519,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->reserved_bits = 0xffffffff00200000ull;
 	pmu->fixed_ctr_ctrl_mask = ~0ull;
 	pmu->pebs_enable_mask = ~0ull;
+	pmu->pebs_data_cfg_mask = ~0ull;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry)
@@ -580,6 +595,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 				pmu->fixed_ctr_ctrl_mask &=
 					~(1ULL << (INTEL_PMC_IDX_FIXED + i * 4));
 			}
+			pmu->pebs_data_cfg_mask = ~0xff00000full;
 		} else {
 			pmu->pebs_enable_mask =
 				~((1ull << pmu->nr_arch_gp_counters) - 1);
-- 
2.27.0

