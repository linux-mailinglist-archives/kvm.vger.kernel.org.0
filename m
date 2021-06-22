Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E093B009D
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 11:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhFVJrA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 05:47:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:20229 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230298AbhFVJqh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 05:46:37 -0400
IronPort-SDR: YLLJPkPfQDl5I+ueEIyY2LyPWJbCjMmjlES6hNjZG3FBAJ4SONkAMsqPWWwVp+Zqat6td9KEIT
 dYvE94vZwCNg==
X-IronPort-AV: E=McAfee;i="6200,9189,10022"; a="194331043"
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="194331043"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 02:44:16 -0700
IronPort-SDR: QAoZHiwuj2R+pbdej/iUKwfqQB9RnZ07DpHEkIW7Flj9aHfouAvpcBL8AmxyHJomcCORl560/L
 JqYOxOG+ZDqA==
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="641600287"
Received: from vmm_a4_icx.sh.intel.com (HELO localhost.localdomain) ([10.239.53.245])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 02:44:11 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     peterz@infradead.org, pbonzini@redhat.com
Cc:     bp@alien8.de, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        weijiang.yang@intel.com, kan.liang@linux.intel.com,
        ak@linux.intel.com, wei.w.wang@intel.com, eranian@google.com,
        liuxiangdong5@huawei.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, like.xu.linux@gmail.com,
        Like Xu <like.xu@linux.intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V7 13/18] KVM: x86: Set PEBS_UNAVAIL in IA32_MISC_ENABLE when PEBS is enabled
Date:   Tue, 22 Jun 2021 17:43:01 +0800
Message-Id: <20210622094306.8336-14-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210622094306.8336-1-lingshan.zhu@intel.com>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

The bit 12 represents "Processor Event Based Sampling Unavailable (RO)" :
	1 = PEBS is not supported.
	0 = PEBS is supported.

A write to this PEBS_UNAVL available bit will bring #GP(0) when guest PEBS
is enabled. Some PEBS drivers in guest may care about this bit.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 2 ++
 arch/x86/kvm/x86.c           | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 58f32a55cc2e..296246bf253d 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -588,6 +588,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		bitmap_set(pmu->all_valid_pmc_idx, INTEL_PMC_IDX_FIXED_VLBR, 1);
 
 	if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT) {
+		vcpu->arch.ia32_misc_enable_msr &= ~MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
 		if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_BASELINE) {
 			pmu->pebs_enable_mask = ~pmu->global_ctrl;
 			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
@@ -601,6 +602,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 				~((1ull << pmu->nr_arch_gp_counters) - 1);
 		}
 	} else {
+		vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
 		vcpu->arch.perf_capabilities &= ~PERF_CAP_PEBS_MASK;
 	}
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 33eecb508d8b..8a905c098787 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3214,6 +3214,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
2.27.0

