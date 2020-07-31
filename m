Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931A7234069
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 09:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731836AbgGaHqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 03:46:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:55461 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731644AbgGaHqS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 03:46:18 -0400
IronPort-SDR: VMPRQSMWjiJ3of0aOFOI2uniq4w8tKwWj6wkoIK3rAJZH3oRCWcWSeUwMEn0IKzSDCHnQHZKCl
 eMRlUHe6GTJw==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="149570534"
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="149570534"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 00:46:16 -0700
IronPort-SDR: qiy7CALWXeasyv1xfHa40So6nl9ewD8p9GPtIPJl56VeaiIJPWPlpEbinDrLB9ReuRsmtUSAea
 h0M+LEG+M5XQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="323160600"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga002.fm.intel.com with ESMTP; 31 Jul 2020 00:46:13 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, wei.w.wang@intel.com,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH 3/6] KVM: vmx/pmu: Add MSR_ARCH_LBR_DEPTH emulation for Arch LBR
Date:   Fri, 31 Jul 2020 15:43:59 +0800
Message-Id: <20200731074402.8879-4-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200731074402.8879-1-like.xu@linux.intel.com>
References: <20200731074402.8879-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The number of Arch LBR entries available for recording operations
is dictated by the value in MSR_ARCH_LBR_DEPTH.DEPTH. The supported
LBR depth values can be found in CPUID.(EAX=01CH, ECX=0):EAX[7:0]
and for each bit n set in this field, the MSR_ARCH_LBR_DEPTH.DEPTH
value 8*(n+1) is supported.

On a software write to MSR_ARCH_LBR_DEPTH, all LBR entries are reset
to 0. Emulate the reset behavior by introducing lbr_desc->arch_lbr_reset
and sync it to the host MSR_ARCH_LBR_DEPTH msr when the guest LBR
event is ACTIVE and the LBR records msrs are pass-through to the guest.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 44 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h       |  3 +++
 2 files changed, 47 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index d61a30d3a6ed..8021fbdbd618 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -231,6 +231,9 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		ret = pmu->version > 1;
 		break;
+	case MSR_ARCH_LBR_DEPTH:
+		ret =  guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
+		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
@@ -261,6 +264,7 @@ static inline void intel_pmu_release_guest_lbr_event(struct kvm_vcpu *vcpu)
 	if (lbr_desc->event) {
 		perf_event_release_kernel(lbr_desc->event);
 		lbr_desc->event = NULL;
+		lbr_desc->arch_lbr_reset = false;
 		vcpu_to_pmu(vcpu)->event_count--;
 	}
 }
@@ -356,11 +360,27 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+/*
+ * Check if the requested depth values is supported
+ * based on the bits [0:7] of the guest cpuid.1c.eax.
+ */
+static bool arch_lbr_depth_is_valid(struct kvm_vcpu *vcpu, u64 depth)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = kvm_find_cpuid_entry(vcpu, 0x1c, 0);
+	if (depth && best)
+		return (best->eax & 0xff) & (1ULL << (depth / 8 - 1));
+
+	return false;
+}
+
 static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
 	u32 msr = msr_info->index;
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 
 	switch (msr) {
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
@@ -375,6 +395,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		msr_info->data = pmu->global_ovf_ctrl;
 		return 0;
+	case MSR_ARCH_LBR_DEPTH:
+		msr_info->data = lbr_desc->records.nr;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -403,6 +426,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	struct kvm_pmc *pmc;
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 
 	switch (msr) {
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
@@ -435,6 +459,13 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
+	case MSR_ARCH_LBR_DEPTH:
+		if (!arch_lbr_depth_is_valid(vcpu, data))
+			return 1;
+		lbr_desc->records.nr = data;
+		lbr_desc->arch_lbr_reset = true;
+		__set_bit(INTEL_GUEST_LBR_INUSE, pmu->pmc_in_use);
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -484,6 +515,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->version = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
+	lbr_desc->arch_lbr_reset = false;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry)
@@ -567,6 +599,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 	lbr_desc->records.nr = 0;
 	lbr_desc->event = NULL;
 	lbr_desc->already_passthrough = false;
+	lbr_desc->arch_lbr_reset = false;
 }
 
 static void intel_pmu_reset(struct kvm_vcpu *vcpu)
@@ -623,6 +656,14 @@ static void intel_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 		intel_pmu_legacy_freezing_lbrs_on_pmi(vcpu);
 }
 
+static void intel_pmu_arch_lbr_reset(struct kvm_vcpu *vcpu)
+{
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
+
+	wrmsrl(MSR_ARCH_LBR_DEPTH, lbr_desc->records.nr);
+	lbr_desc->arch_lbr_reset = false;
+}
+
 static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
 {
 	unsigned long *msr_bitmap = to_vmx(vcpu)->vmcs01.msr_bitmap;
@@ -658,6 +699,9 @@ static inline void vmx_enable_lbr_msrs_passthrough(struct kvm_vcpu *vcpu)
 {
 	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 
+	if (unlikely(lbr_desc->arch_lbr_reset))
+		intel_pmu_arch_lbr_reset(vcpu);
+
 	if (lbr_desc->already_passthrough)
 		return;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index f95d61942a1c..5c02463993ca 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -115,6 +115,9 @@ struct lbr_desc {
 
 	/* A flag to reduce the overhead of LBR pass-through or cancellation. */
 	bool already_passthrough;
+
+	/* Reset all LBR entries on a guest write to MSR_ARCH_LBR_DEPTH */
+	bool arch_lbr_reset;
 };
 
 /*
-- 
2.21.3

