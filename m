Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BEA379D1B
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 04:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhEKCp0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 22:45:26 -0400
Received: from mga14.intel.com ([192.55.52.115]:39588 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230439AbhEKCpI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 22:45:08 -0400
IronPort-SDR: TlPgKjs+UMx44UTkPuaWCocpAZ4/YKfH5BSYXBjpu6Wx1AYUauXRBjsNKrJKM65MNXIDVob6Dc
 frVAKJWqjMgA==
X-IronPort-AV: E=McAfee;i="6200,9189,9980"; a="199015656"
X-IronPort-AV: E=Sophos;i="5.82,290,1613462400"; 
   d="scan'208";a="199015656"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 19:44:03 -0700
IronPort-SDR: J41q9Qu854HboYETMwsjLabXZF6hMgJzEMsuLqCuINGZTs3h5+qW5EfWtrCI6a6fj8IOn/AsJL
 vk6K4+Hl7K9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,290,1613462400"; 
   d="scan'208";a="468592084"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga002.fm.intel.com with ESMTP; 10 May 2021 19:43:59 -0700
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
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v6 15/16] KVM: x86/cpuid: Refactor host/guest CPU model consistency check
Date:   Tue, 11 May 2021 10:42:13 +0800
Message-Id: <20210511024214.280733-16-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210511024214.280733-1-like.xu@linux.intel.com>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For the same purpose, the leagcy intel_pmu_lbr_is_compatible() can be
renamed for reuse by more callers, and remove the comment about LBR
use case can be deleted by the way.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/cpuid.h         |  5 +++++
 arch/x86/kvm/vmx/pmu_intel.c | 12 +-----------
 arch/x86/kvm/vmx/vmx.c       |  2 +-
 arch/x86/kvm/vmx/vmx.h       |  1 -
 4 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index c99edfff7f82..439ce776b9a0 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -143,6 +143,11 @@ static inline int guest_cpuid_model(struct kvm_vcpu *vcpu)
 	return x86_model(best->eax);
 }
 
+static inline bool cpuid_model_is_consistent(struct kvm_vcpu *vcpu)
+{
+	return boot_cpu_data.x86_model == guest_cpuid_model(vcpu);
+}
+
 static inline int guest_cpuid_stepping(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index d0610716675b..a706d3597720 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -173,16 +173,6 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
 	return get_gp_pmc(pmu, msr, MSR_IA32_PMC0);
 }
 
-bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu)
-{
-	/*
-	 * As a first step, a guest could only enable LBR feature if its
-	 * cpu model is the same as the host because the LBR registers
-	 * would be pass-through to the guest and they're model specific.
-	 */
-	return boot_cpu_data.x86_model == guest_cpuid_model(vcpu);
-}
-
 bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
 {
 	struct x86_pmu_lbr *lbr = vcpu_to_lbr_records(vcpu);
@@ -578,7 +568,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 
 	nested_vmx_pmu_entry_exit_ctls_update(vcpu);
 
-	if (intel_pmu_lbr_is_compatible(vcpu))
+	if (cpuid_model_is_consistent(vcpu))
 		x86_perf_get_lbr(&lbr_desc->records);
 	else
 		lbr_desc->records.nr = 0;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e43d58020c75..e11efe9d2ff4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2306,7 +2306,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if ((data & PMU_CAP_LBR_FMT) !=
 			    (vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT))
 				return 1;
-			if (!intel_pmu_lbr_is_compatible(vcpu))
+			if (!cpuid_model_is_consistent(vcpu))
 				return 1;
 		}
 		ret = kvm_set_msr_common(vcpu, msr_info);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 72f1175e474b..3afdcebb0a11 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -97,7 +97,6 @@ union vmx_exit_reason {
 #define vcpu_to_lbr_records(vcpu) (&to_vmx(vcpu)->lbr_desc.records)
 
 void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
-bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu);
 bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
 
 int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
-- 
2.31.1

