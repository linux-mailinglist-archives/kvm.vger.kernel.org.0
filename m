Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547B234C33D
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 07:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbhC2Fuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 01:50:32 -0400
Received: from mga07.intel.com ([134.134.136.100]:15632 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230437AbhC2FuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Mar 2021 01:50:03 -0400
IronPort-SDR: 7kot5cITVil+oLS5yZaB9qcxL6OUg8fs9rfpySI4cifpAT6PJlIkOtFp58ual5+OPikwSNeHX9
 ZOTwa07lnWow==
X-IronPort-AV: E=McAfee;i="6000,8403,9937"; a="255478755"
X-IronPort-AV: E=Sophos;i="5.81,285,1610438400"; 
   d="scan'208";a="255478755"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2021 22:50:02 -0700
IronPort-SDR: NUtgFmNLl+JwLC3NArebTMTACnpXZPYhHns9wrCYsVaD7XQRZRk5iPF6jMDfIqDHoo27N4pLb0
 i94Og2T+iOWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,285,1610438400"; 
   d="scan'208";a="417506874"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 28 Mar 2021 22:49:59 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     peterz@infradead.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     eranian@google.com, andi@firstfloor.org, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v4 10/16] KVM: x86: Set PEBS_UNAVAIL in IA32_MISC_ENABLE when PEBS is enabled
Date:   Mon, 29 Mar 2021 13:41:31 +0800
Message-Id: <20210329054137.120994-11-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210329054137.120994-1-like.xu@linux.intel.com>
References: <20210329054137.120994-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The bit 12 represents "Processor Event Based Sampling Unavailable (RO)" :
	1 = PEBS is not supported.
	0 = PEBS is supported.

A write to this PEBS_UNAVL available bit will bring #GP(0) when guest PEBS
is enabled. Some PEBS drivers in guest may care about this bit.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 2 ++
 arch/x86/kvm/x86.c           | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 7f18c760dbae..4dcf66e6c398 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -588,6 +588,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		bitmap_set(pmu->all_valid_pmc_idx, INTEL_PMC_IDX_FIXED_VLBR, 1);
 
 	if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT) {
+		vcpu->arch.ia32_misc_enable_msr &= ~MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
 		if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_BASELINE) {
 			pmu->pebs_enable_mask = ~pmu->global_ctrl;
 			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
@@ -598,6 +599,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		} else
 			pmu->pebs_enable_mask = ~((1ull << pmu->nr_arch_gp_counters) - 1);
 	} else {
+		vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
 		vcpu->arch.perf_capabilities &= ~PERF_CAP_PEBS_MASK;
 	}
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 536b64360b75..888f2c3cc288 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3126,6 +3126,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_MISC_ENABLE:
 		data &= ~MSR_IA32_MISC_ENABLE_EMON;
+		if (!msr_info->host_initiated &&
+		    (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT) &&
+		    (data & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL))
+			return 1;
 		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
 		    ((vcpu->arch.ia32_misc_enable_msr ^ data) & MSR_IA32_MISC_ENABLE_MWAIT)) {
 			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
-- 
2.29.2

