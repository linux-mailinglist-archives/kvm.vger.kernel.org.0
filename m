Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1192EEB0C
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 02:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729921AbhAHBqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 20:46:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:27995 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729466AbhAHBqN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 20:46:13 -0500
IronPort-SDR: kF2XNeo5il6aFixrhfyzjY1yKwrf2P0iSbbYj4rN/6bnapBS1sv576JbFaAXcn5LwvUqXECFbs
 S9vTCXFHklYg==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="177672391"
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="177672391"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 17:43:17 -0800
IronPort-SDR: nV0bwRGmXbebWLJwCyB/Nrai2/WukHGIN1bJg5ojb01ErYQm47vW3sw0bDqM0OuKhrI+bxdbYp
 n0i/i50gDfzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="379938058"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 07 Jan 2021 17:43:14 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND v13 04/10] KVM: vmx/pmu: Clear PMU_CAP_LBR_FMT when guest LBR is disabled
Date:   Fri,  8 Jan 2021 09:36:58 +0800
Message-Id: <20210108013704.134985-5-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210108013704.134985-1-like.xu@linux.intel.com>
References: <20210108013704.134985-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The LBR could be enabled on the guest if host perf supports LBR
(checked via x86_perf_get_lbr()) and the vcpu model is compatible
with the host one.

If LBR is disabled on the guest, the bits [0, 5] of the read-only
MSR_IA32_PERF_CAPABILITIES which tells about the record format
stored in the LBR records would be cleared.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kvm/vmx/capabilities.h |  1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 40 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h          | 12 ++++++++++
 3 files changed, 53 insertions(+)

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
index f8083ecf8c7b..91212fe5ec56 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -168,6 +168,39 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
 	return get_gp_pmc(pmu, msr, MSR_IA32_PMC0);
 }
 
+bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu)
+{
+	struct x86_pmu_lbr *lbr = vcpu_to_lbr_records(vcpu);
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	if (pmu->version < 2)
+		return false;
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
+bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
+{
+	struct x86_pmu_lbr *lbr = vcpu_to_lbr_records(vcpu);
+	u64 lbr_fmt = vcpu->arch.perf_capabilities & PMU_CAP_LBR_FMT;
+
+	if (lbr->nr && lbr_fmt)
+		return true;
+
+	if (!lbr_fmt || !intel_pmu_lbr_is_compatible(vcpu))
+		return false;
+
+	return true;
+}
+
 static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -320,6 +353,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	struct kvm_cpuid_entry2 *entry;
 	union cpuid10_eax eax;
 	union cpuid10_edx edx;
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 
 	pmu->nr_arch_gp_counters = 0;
 	pmu->nr_arch_fixed_counters = 0;
@@ -339,6 +373,10 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		return;
 
 	perf_get_x86_pmu_capability(&x86_pmu);
+	if (!intel_pmu_lbr_is_enabled(vcpu)) {
+		vcpu->arch.perf_capabilities &= ~PMU_CAP_LBR_FMT;
+		lbr_desc->records.nr = 0;
+	}
 
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
 					 x86_pmu.num_counters_gp);
@@ -384,6 +422,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 {
 	int i;
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 
 	for (i = 0; i < INTEL_PMC_MAX_GENERIC; i++) {
 		pmu->gp_counters[i].type = KVM_PMC_GP;
@@ -401,6 +440,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.perf_capabilities = guest_cpuid_has(vcpu, X86_FEATURE_PDCM) ?
 		vmx_get_perf_capabilities() : 0;
+	lbr_desc->records.nr = 0;
 }
 
 static void intel_pmu_reset(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index adc40d36909c..1b0bbfffa1f0 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -70,6 +70,17 @@ struct pt_desc {
 	struct pt_ctx guest;
 };
 
+#define vcpu_to_lbr_desc(vcpu) (&to_vmx(vcpu)->lbr_desc)
+#define vcpu_to_lbr_records(vcpu) (&to_vmx(vcpu)->lbr_desc.records)
+
+bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu);
+bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
+
+struct lbr_desc {
+	/* Basic info about guest LBR records. */
+	struct x86_pmu_lbr records;
+};
+
 /*
  * The nested_vmx structure is part of vcpu_vmx, and holds information we need
  * for correct emulation of VMX (i.e., nested VMX) on this vcpu.
@@ -279,6 +290,7 @@ struct vcpu_vmx {
 	u64 ept_pointer;
 
 	struct pt_desc pt_desc;
+	struct lbr_desc lbr_desc;
 
 	/* Save desired MSR intercept (read: pass-through) state */
 #define MAX_POSSIBLE_PASSTHROUGH_MSRS	13
-- 
2.29.2

