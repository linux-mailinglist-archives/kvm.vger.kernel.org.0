Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDEF379D0F
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 04:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhEKCoy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 22:44:54 -0400
Received: from mga03.intel.com ([134.134.136.65]:7572 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230321AbhEKCol (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 22:44:41 -0400
IronPort-SDR: 00tvoG2dfU4tGMo3xzjSXdGH7VhJI/aPaD3Rl8TI9Bn+TkmvnkY3SKvEXEeiornE48Ys3BFnnY
 7JgVmJdSrfIQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9980"; a="199391233"
X-IronPort-AV: E=Sophos;i="5.82,290,1613462400"; 
   d="scan'208";a="199391233"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 19:43:36 -0700
IronPort-SDR: wwW2QJsm9ANHeAsGjOALSHYd5nNjmxU5we1Yy3L/61DnWojmHzSAJicD11JklpB3QUPU/B2Zp1
 Efn8lhT30Cag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,290,1613462400"; 
   d="scan'208";a="468591850"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga002.fm.intel.com with ESMTP; 10 May 2021 19:43:31 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>,
        Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v6 09/16] KVM: x86/pmu: Add PEBS_DATA_CFG MSR emulation to support adaptive PEBS
Date:   Tue, 11 May 2021 10:42:07 +0800
Message-Id: <20210511024214.280733-10-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210511024214.280733-1-like.xu@linux.intel.com>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
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
MSR_PEBS_DATA_CFG.By default, the record only contain the Basic group.

When guest adaptive PEBS is enabled, the IA32_PEBS_ENABLE MSR will
be added to the perf_guest_switch_msr() and switched during the VMX
transitions just like CORE_PERF_GLOBAL_CTRL MSR.

Co-developed-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/intel/core.c    |  8 ++++++++
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/vmx/pmu_intel.c    | 16 ++++++++++++++++
 3 files changed, 26 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index de3bc8dfe85e..18843412718a 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3940,6 +3940,14 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 		.guest = pmu->ds_area,
 	};
 
+	if (x86_pmu.intel_cap.pebs_baseline) {
+		arr[(*nr)++] = (struct perf_guest_switch_msr){
+			.msr = MSR_PEBS_DATA_CFG,
+			.host = cpuc->pebs_data_cfg,
+			.guest = pmu->pebs_data_cfg,
+		};
+	}
+
 	arr[*nr] = (struct perf_guest_switch_msr){
 		.msr = MSR_IA32_PEBS_ENABLE,
 		.host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask,
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 296bc3eecdc6..b4deb7820397 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -476,6 +476,8 @@ struct kvm_pmu {
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
2.31.1

