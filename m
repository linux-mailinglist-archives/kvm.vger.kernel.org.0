Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67DA53CB4E4
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 10:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238543AbhGPI6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 04:58:12 -0400
Received: from mga07.intel.com ([134.134.136.100]:48060 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239176AbhGPI6F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 04:58:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10046"; a="274526443"
X-IronPort-AV: E=Sophos;i="5.84,244,1620716400"; 
   d="scan'208";a="274526443"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 01:55:10 -0700
X-IronPort-AV: E=Sophos;i="5.84,244,1620716400"; 
   d="scan'208";a="495984185"
Received: from vmm_a4_icx.sh.intel.com (HELO localhost.localdomain) ([10.239.53.245])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 01:55:06 -0700
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
Subject: [PATCH V8 17/18] KVM: x86/cpuid: Refactor host/guest CPU model consistency check
Date:   Fri, 16 Jul 2021 16:53:24 +0800
Message-Id: <20210716085325.10300-18-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210716085325.10300-1-lingshan.zhu@intel.com>
References: <20210716085325.10300-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

For the same purpose, the leagcy intel_pmu_lbr_is_compatible() can be
renamed for reuse by more callers, and remove the comment about LBR
use case can be deleted by the way.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
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
index 05bc218c08df..a77d5a5f2ba5 100644
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
index d8552dbece6f..d0af51c1389d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2221,7 +2221,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if ((data & PMU_CAP_LBR_FMT) !=
 			    (vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT))
 				return 1;
-			if (!intel_pmu_lbr_is_compatible(vcpu))
+			if (!cpuid_model_is_consistent(vcpu))
 				return 1;
 		}
 		ret = kvm_set_msr_common(vcpu, msr_info);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index f8343cb18f37..26f2dd469ae7 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -97,7 +97,6 @@ union vmx_exit_reason {
 #define vcpu_to_lbr_records(vcpu) (&to_vmx(vcpu)->lbr_desc.records)
 
 void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
-bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu);
 bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
 
 int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
-- 
2.27.0

