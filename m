Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B23C3CB4DF
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 10:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239647AbhGPI6F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 04:58:05 -0400
Received: from mga07.intel.com ([134.134.136.100]:48052 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239179AbhGPI5t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 04:57:49 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10046"; a="274526419"
X-IronPort-AV: E=Sophos;i="5.84,244,1620716400"; 
   d="scan'208";a="274526419"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 01:54:54 -0700
X-IronPort-AV: E=Sophos;i="5.84,244,1620716400"; 
   d="scan'208";a="495984048"
Received: from vmm_a4_icx.sh.intel.com (HELO localhost.localdomain) ([10.239.53.245])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 01:54:50 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     peterz@infradead.org, pbonzini@redhat.com
Cc:     bp@alien8.de, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, boris.ostrvsky@oracle.com,
        Like Xu <like.xu@linux.intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V8 13/18] KVM: x86: Set PEBS_UNAVAIL in IA32_MISC_ENABLE when PEBS is enabled
Date:   Fri, 16 Jul 2021 16:53:20 +0800
Message-Id: <20210716085325.10300-14-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210716085325.10300-1-lingshan.zhu@intel.com>
References: <20210716085325.10300-1-lingshan.zhu@intel.com>
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
index 2f5d1ed00e4a..d3987a217ebe 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3322,6 +3322,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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

