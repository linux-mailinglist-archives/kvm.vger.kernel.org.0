Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFC830A128
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 06:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhBAFUk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 00:20:40 -0500
Received: from mga17.intel.com ([192.55.52.151]:9252 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229599AbhBAFUU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 00:20:20 -0500
IronPort-SDR: obD2YWLjMRfsMFqnZAjtB47m+2PpwzfnnOewJMOKerQL6shHJ+MQksyVP0jz6YXc159vX+6o8L
 L33E5ypnrkWg==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="160401834"
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="160401834"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 21:17:17 -0800
IronPort-SDR: Hv5BLOohfR/IRau0m287u74CGpaHFi9pG9Ny1gnlC63Ufu++xU/w2QMq75VF6m8Ob6arbXI2Sy
 SgvNKfVFRpyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="390694276"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 31 Jan 2021 21:17:14 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com,
        alex.shi@linux.alibaba.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v14 03/11] KVM: vmx/pmu: Add PMU_CAP_LBR_FMT check when guest LBR is enabled
Date:   Mon,  1 Feb 2021 13:10:31 +0800
Message-Id: <20210201051039.255478-4-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210201051039.255478-1-like.xu@linux.intel.com>
References: <20210201051039.255478-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Usespace could set the bits [0, 5] of the IA32_PERF_CAPABILITIES
MSR which tells about the record format stored in the LBR records.

The LBR will be enabled on the guest if host perf supports LBR
(checked via x86_perf_get_lbr()) and the vcpu model is compatible
with the host one.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/capabilities.h |  1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 17 +++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  7 +++++++
 arch/x86/kvm/vmx/vmx.h          | 11 +++++++++++
 4 files changed, 36 insertions(+)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index a58cf3655351..db1178a66d93 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -19,6 +19,7 @@ extern int __read_mostly pt_mode;
 #define PT_MODE_HOST_GUEST	1
 
 #define PMU_CAP_FW_WRITES	(1ULL << 13)
+#define PMU_CAP_LBR_FMT		0x3f
 
 struct nested_vmx_msrs {
 	/*
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index f632039173ff..01b2cd8eca47 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -168,6 +168,21 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
 	return get_gp_pmc(pmu, msr, MSR_IA32_PMC0);
 }
 
+bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu)
+{
+	struct x86_pmu_lbr *lbr = vcpu_to_lbr_records(vcpu);
+
+	/*
+	 * As a first step, a guest could only enable LBR feature if its
+	 * cpu model is the same as the host because the LBR registers
+	 * would be pass-through to the guest and they're model specific.
+	 */
+	if (boot_cpu_data.x86_model != guest_cpuid_model(vcpu))
+		return false;
+
+	return !x86_perf_get_lbr(lbr);
+}
+
 static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -388,6 +403,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 {
 	int i;
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 
 	for (i = 0; i < INTEL_PMC_MAX_GENERIC; i++) {
 		pmu->gp_counters[i].type = KVM_PMC_GP;
@@ -404,6 +420,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 	}
 
 	vcpu->arch.perf_capabilities = 0;
+	lbr_desc->records.nr = 0;
 }
 
 static void intel_pmu_reset(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 387adaa1194f..af9c7632ecfa 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2212,6 +2212,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_PERF_CAPABILITIES:
 		if (data && !vcpu_to_pmu(vcpu)->version)
 			return 1;
+		if (data & PMU_CAP_LBR_FMT) {
+			if ((data & PMU_CAP_LBR_FMT) !=
+			    (vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT))
+				return 1;
+			if (!intel_pmu_lbr_is_compatible(vcpu))
+				return 1;
+		}
 		ret = kvm_set_msr_common(vcpu, msr_info);
 		break;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index adc40d36909c..095e357e5316 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -70,6 +70,16 @@ struct pt_desc {
 	struct pt_ctx guest;
 };
 
+#define vcpu_to_lbr_desc(vcpu) (&to_vmx(vcpu)->lbr_desc)
+#define vcpu_to_lbr_records(vcpu) (&to_vmx(vcpu)->lbr_desc.records)
+
+bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu);
+
+struct lbr_desc {
+	/* Basic info about guest LBR records. */
+	struct x86_pmu_lbr records;
+};
+
 /*
  * The nested_vmx structure is part of vcpu_vmx, and holds information we need
  * for correct emulation of VMX (i.e., nested VMX) on this vcpu.
@@ -279,6 +289,7 @@ struct vcpu_vmx {
 	u64 ept_pointer;
 
 	struct pt_desc pt_desc;
+	struct lbr_desc lbr_desc;
 
 	/* Save desired MSR intercept (read: pass-through) state */
 #define MAX_POSSIBLE_PASSTHROUGH_MSRS	13
-- 
2.29.2

