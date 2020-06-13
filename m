Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390EE1F81B7
	for <lists+kvm@lfdr.de>; Sat, 13 Jun 2020 10:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgFMIMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Jun 2020 04:12:38 -0400
Received: from mga07.intel.com ([134.134.136.100]:64600 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbgFMIL2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Jun 2020 04:11:28 -0400
IronPort-SDR: lCJBEv6yoeivg0OH1VDe5Bs5s7m5jupXbDgrjLHcmWoQ12UyxWeDdfy4K2N3wB5QtZc2S0XfxK
 y6VKCuQ+ZKWA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2020 01:11:23 -0700
IronPort-SDR: 7in4YY3BPNZOJr2n1l8cSCsQmx5eSbtT9kmNtVEJe/0rPQwt+DztugEGNexQXtGJjhf+FZOu6g
 L4EvCSkGxTnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,506,1583222400"; 
   d="scan'208";a="474467393"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 13 Jun 2020 01:11:19 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v12 06/11] KVM: vmx/pmu: Expose LBR to guest via MSR_IA32_PERF_CAPABILITIES
Date:   Sat, 13 Jun 2020 16:09:51 +0800
Message-Id: <20200613080958.132489-7-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200613080958.132489-1-like.xu@linux.intel.com>
References: <20200613080958.132489-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The bits [0, 5] of the read-only MSR_IA32_PERF_CAPABILITIES tells about
the record format stored in the LBR records. Userspace could expose guest
LBR when host supports LBR and the exactly supported LBR format value is
initialized to the MSR_IA32_PERF_CAPABILITIES and vcpu model is compatible.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/capabilities.h | 11 ++++++-
 arch/x86/kvm/vmx/pmu_intel.c    | 52 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.h          |  6 ++++
 3 files changed, 65 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 4bbd8b448d22..b633a90320ee 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -19,6 +19,7 @@ extern int __read_mostly pt_mode;
 #define PT_MODE_HOST_GUEST	1
 
 #define PMU_CAP_FW_WRITES	(1ULL << 13)
+#define PMU_CAP_LBR_FMT		0x3f
 
 struct nested_vmx_msrs {
 	/*
@@ -375,7 +376,15 @@ static inline u64 vmx_get_perf_capabilities(void)
 	 * Since counters are virtualized, KVM would support full
 	 * width counting unconditionally, even if the host lacks it.
 	 */
-	return PMU_CAP_FW_WRITES;
+	u64 perf_cap = PMU_CAP_FW_WRITES;
+
+	if (boot_cpu_has(X86_FEATURE_PDCM))
+		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
+
+	/* From now on, KVM will support LBR.  */
+	perf_cap |= perf_cap & PMU_CAP_LBR_FMT;
+
+	return perf_cap;
 }
 
 #endif /* __KVM_X86_VMX_CAPS_H */
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index bdcce65c7a1d..a953c7d633f6 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -168,6 +168,13 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
 	return get_gp_pmc(pmu, msr, MSR_IA32_PMC0);
 }
 
+static inline bool lbr_is_enabled(struct kvm_vcpu *vcpu)
+{
+	struct x86_pmu_lbr *lbr = &to_vmx(vcpu)->lbr_desc.lbr;
+
+	return lbr->nr && (vcpu->arch.perf_capabilities & PMU_CAP_LBR_FMT);
+}
+
 static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -251,6 +258,30 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return 1;
 }
 
+static inline bool lbr_fmt_is_matched(u64 data)
+{
+	return (data & PMU_CAP_LBR_FMT) ==
+		(vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT);
+}
+
+static inline bool lbr_is_compatible(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	if (pmu->version < 2)
+		return false;
+
+	/*
+	 * As a first step, a guest could only enable LBR feature if its cpu
+	 * model is the same as the host because the LBR registers would
+	 * be pass-through to the guest and they're model specific.
+	 */
+	if (boot_cpu_data.x86_model != guest_cpuid_model(vcpu))
+		return false;
+
+	return true;
+}
+
 static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -295,6 +326,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (guest_cpuid_has(vcpu, X86_FEATURE_PDCM) ?
 			(data & ~vmx_get_perf_capabilities()) : data)
 			return 1;
+		if (data & PMU_CAP_LBR_FMT) {
+			if (!lbr_fmt_is_matched(data))
+				return 1;
+			if (!lbr_is_compatible(vcpu))
+				return 1;
+			if (x86_perf_get_lbr(&to_vmx(vcpu)->lbr_desc.lbr))
+				return 1;
+		}
 		vcpu->arch.perf_capabilities = data;
 		return 0;
 	default:
@@ -337,6 +376,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	struct kvm_cpuid_entry2 *entry;
 	union cpuid10_eax eax;
 	union cpuid10_edx edx;
+	struct lbr_desc *lbr_desc = &to_vmx(vcpu)->lbr_desc;
 
 	pmu->nr_arch_gp_counters = 0;
 	pmu->nr_arch_fixed_counters = 0;
@@ -344,7 +384,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->version = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
-	vcpu->arch.perf_capabilities = 0;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry)
@@ -357,8 +396,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		return;
 
 	perf_get_x86_pmu_capability(&x86_pmu);
-	if (guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
-		vcpu->arch.perf_capabilities = vmx_get_perf_capabilities();
 
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
 					 x86_pmu.num_counters_gp);
@@ -397,6 +434,10 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	bitmap_set(pmu->all_valid_pmc_idx,
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
 
+	if ((vcpu->arch.perf_capabilities & PMU_CAP_LBR_FMT) &&
+	    x86_perf_get_lbr(&lbr_desc->lbr))
+		vcpu->arch.perf_capabilities &= ~PMU_CAP_LBR_FMT;
+
 	nested_vmx_pmu_entry_exit_ctls_update(vcpu);
 }
 
@@ -404,6 +445,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 {
 	int i;
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct lbr_desc *lbr_desc = &to_vmx(vcpu)->lbr_desc;
 
 	for (i = 0; i < INTEL_PMC_MAX_GENERIC; i++) {
 		pmu->gp_counters[i].type = KVM_PMC_GP;
@@ -418,6 +460,10 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->fixed_counters[i].idx = i + INTEL_PMC_IDX_FIXED;
 		pmu->fixed_counters[i].current_config = 0;
 	}
+
+	vcpu->arch.perf_capabilities = guest_cpuid_has(vcpu, X86_FEATURE_PDCM) ?
+		vmx_get_perf_capabilities() : 0;
+	lbr_desc->lbr.nr = 0;
 }
 
 static void intel_pmu_reset(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 8a83b5edc820..ef24338b194d 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -91,6 +91,11 @@ struct pt_desc {
 	struct pt_ctx guest;
 };
 
+struct lbr_desc {
+	/* Basic information about LBR records. */
+	struct x86_pmu_lbr lbr;
+};
+
 /*
  * The nested_vmx structure is part of vcpu_vmx, and holds information we need
  * for correct emulation of VMX (i.e., nested VMX) on this vcpu.
@@ -302,6 +307,7 @@ struct vcpu_vmx {
 	u64 ept_pointer;
 
 	struct pt_desc pt_desc;
+	struct lbr_desc lbr_desc;
 };
 
 enum ept_pointers_status {
-- 
2.21.3

