Return-Path: <kvm+bounces-72105-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0L0EHZTUoGmrnAQAu9opvQ
	(envelope-from <kvm+bounces-72105-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:17:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C82961B0D83
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:17:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EE75C312AA23
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 23:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BD8A47B40C;
	Thu, 26 Feb 2026 23:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SOnYCMV+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E73F47AF50;
	Thu, 26 Feb 2026 23:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772147683; cv=none; b=YTyUv75DiOUQC6Y9RKyz3ACsLsq2lQjNtCMR2ITeOPL2+QO0384s/MSykL2uGrraG/QI3pYCKDx4a4OZIjwfU4ss8M4r/9Yt4Quo/QOKXrhEddxKQa17EGrzNruT2bD6sU2dPDa3Jd0b8jfr8MRQWOAqJtchA3s1ofUb4cRP0ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772147683; c=relaxed/simple;
	bh=Bkf9lgivbj9yHO0jtGEtBziWCxVqJEo3GXtfNuN9svE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExtiQrvI970V+tx3eZ5rqkvE0EVYM5Lu0gDUq0o6uCCW2sbSF2KgmyIlZrqltDc4r/60LMrql/vgfEWq9fKWrlD+x2cAClm9zIh6JOlEUl8QrliooAl8/SY9s6mJRDyDa9gRKMZgTJCGbWVa17Cc+5QAxI5skMx9x36wpt4817w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SOnYCMV+; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772147682; x=1803683682;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bkf9lgivbj9yHO0jtGEtBziWCxVqJEo3GXtfNuN9svE=;
  b=SOnYCMV+P39/TWLN19ijHP40XzUGcFcI4n59/21SrwKAAEjhnvjfQt0C
   gdRHdFsauhzXyeIvULO4rU0E5AGYBiLE+5cBLi0VpeI3Kpl5IoY4qilwK
   Bc2+9eGKkG+w7++4Lo3gjWvCplEeUsjh49kBpy2Md21O9V9aU3zyaUJKf
   whuXN8uTosmmx/fxsqaZbBUJPPwk2jtW+6vHcDT3MXKbeNtmY3eMEVfGs
   3qBYc/cU8gpcEeW0J8RyMq983jvc5UVSm54ZRLp8LpGmuhwgKqNth+8l4
   Fbo85bolFMSVSSX0xEc/u4XfpE5UT1kHdusG9n+uCjeZCvI5Fuk+Rf/Rp
   w==;
X-CSE-ConnectionGUID: 4zuWwssRRuCav7ZHo9zAeQ==
X-CSE-MsgGUID: oT9biQg7Qr2sKei29md/lA==
X-IronPort-AV: E=McAfee;i="6800,10657,11713"; a="72928319"
X-IronPort-AV: E=Sophos;i="6.21,313,1763452800"; 
   d="scan'208";a="72928319"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 15:14:38 -0800
X-CSE-ConnectionGUID: 5wazMpc4SvSR3Y6UGFQ23Q==
X-CSE-MsgGUID: OcWac/PIQAyduagoO0/59w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,313,1763452800"; 
   d="scan'208";a="221340142"
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.43])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 15:14:38 -0800
From: Zide Chen <zide.chen@intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Zide Chen <zide.chen@intel.com>,
	Das Sandipan <Sandipan.Das@amd.com>,
	Shukla Manali <Manali.Shukla@amd.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Falcon Thomas <thomas.falcon@intel.com>,
	Xudong Hao <xudong.hao@intel.com>
Subject: [PATCH 3/3] KVM: x86/pmu: Support PERF_METRICS MSR in mediated vPMU
Date: Thu, 26 Feb 2026 15:06:06 -0800
Message-ID: <20260226230606.146532-4-zide.chen@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260226230606.146532-1-zide.chen@intel.com>
References: <20260226230606.146532-1-zide.chen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72105-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zide.chen@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C82961B0D83
X-Rspamd-Action: no action

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Bit 15 in IA32_PERF_CAPABILITIES indicates that the CPU provides
built-in support for Topdown Microarchitecture Analysis (TMA) L1
metrics via the IA32_PERF_METRICS MSR.

Expose this capability only when mediated vPMU is enabled, as emulating
IA32_PERF_METRICS in the legacy vPMU model is impractical.

Pass IA32_PERF_METRICS through to the guest only when mediated vPMU is
enabled and bit 15 is set in guest IA32_PERF_CAPABILITIES is.  Allow
kvm_pmu_{get,set}_msr() to handle this MSR for host accesses.

Save and restore this MSR on host/guest PMU context switches so that
host PMU activity does not clobber the guest value, and guest state
is not leaked into the host.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Zide Chen <zide.chen@intel.com>
---
 arch/x86/include/asm/kvm_host.h   |  1 +
 arch/x86/include/asm/msr-index.h  |  1 +
 arch/x86/include/asm/perf_event.h |  1 +
 arch/x86/kvm/vmx/pmu_intel.c      | 31 +++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/pmu_intel.h      |  5 +++++
 arch/x86/kvm/vmx/vmx.c            |  6 ++++++
 arch/x86/kvm/x86.c                |  6 +++++-
 7 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4666b2c7988f..bf817c613451 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -575,6 +575,7 @@ struct kvm_pmu {
 	u64 global_status_rsvd;
 	u64 reserved_bits;
 	u64 raw_event_mask;
+	u64 perf_metrics;
 	struct kvm_pmc gp_counters[KVM_MAX_NR_GP_COUNTERS];
 	struct kvm_pmc fixed_counters[KVM_MAX_NR_FIXED_COUNTERS];
 
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index da5275d8eda6..337667a7ad1b 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -331,6 +331,7 @@
 #define PERF_CAP_PEBS_FORMAT		0xf00
 #define PERF_CAP_FW_WRITES		BIT_ULL(13)
 #define PERF_CAP_PEBS_BASELINE		BIT_ULL(14)
+#define PERF_CAP_PERF_METRICS		BIT_ULL(15)
 #define PERF_CAP_PEBS_TIMING_INFO	BIT_ULL(17)
 #define PERF_CAP_PEBS_MASK		(PERF_CAP_PEBS_TRAP | PERF_CAP_ARCH_REG | \
 					 PERF_CAP_PEBS_FORMAT | PERF_CAP_PEBS_BASELINE | \
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index ff5acb8b199b..dfead3a34b74 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -445,6 +445,7 @@ static inline bool is_topdown_idx(int idx)
 #define GLOBAL_STATUS_ARCH_PEBS_THRESHOLD_BIT	54
 #define GLOBAL_STATUS_ARCH_PEBS_THRESHOLD	BIT_ULL(GLOBAL_STATUS_ARCH_PEBS_THRESHOLD_BIT)
 #define GLOBAL_STATUS_PERF_METRICS_OVF_BIT	48
+#define GLOBAL_STATUS_PERF_METRICS_OVF		BIT_ULL(GLOBAL_STATUS_PERF_METRICS_OVF_BIT)
 
 #define GLOBAL_CTRL_EN_PERF_METRICS		BIT_ULL(48)
 /*
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 9da47cf2af63..61bb2086f94a 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -180,6 +180,8 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	switch (msr) {
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
 		return kvm_pmu_has_perf_global_ctrl(pmu);
+	case MSR_PERF_METRICS:
+		return vcpu_has_perf_metrics(vcpu);
 	case MSR_IA32_PEBS_ENABLE:
 		ret = vcpu_get_perf_capabilities(vcpu) & PERF_CAP_PEBS_FORMAT;
 		break;
@@ -335,6 +337,10 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
 		msr_info->data = pmu->fixed_ctr_ctrl;
 		break;
+	case MSR_PERF_METRICS:
+		WARN_ON(!msr_info->host_initiated);
+		msr_info->data = pmu->perf_metrics;
+		break;
 	case MSR_IA32_PEBS_ENABLE:
 		msr_info->data = pmu->pebs_enable;
 		break;
@@ -384,6 +390,10 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (pmu->fixed_ctr_ctrl != data)
 			reprogram_fixed_counters(pmu, data);
 		break;
+	case MSR_PERF_METRICS:
+		WARN_ON(!msr_info->host_initiated);
+		pmu->perf_metrics = data;
+		break;
 	case MSR_IA32_PEBS_ENABLE:
 		if (data & pmu->pebs_enable_rsvd)
 			return 1;
@@ -579,6 +589,11 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		pmu->global_status_rsvd &=
 				~MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI;
 
+	if (perf_capabilities & PERF_CAP_PERF_METRICS) {
+		pmu->global_ctrl_rsvd &= ~GLOBAL_CTRL_EN_PERF_METRICS;
+		pmu->global_status_rsvd &= ~GLOBAL_STATUS_PERF_METRICS_OVF;
+	}
+
 	if (perf_capabilities & PERF_CAP_PEBS_FORMAT) {
 		if (perf_capabilities & PERF_CAP_PEBS_BASELINE) {
 			pmu->pebs_enable_rsvd = counter_rsvd;
@@ -622,6 +637,9 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 
 static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 {
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	pmu->perf_metrics = 0;
 	intel_pmu_release_guest_lbr_event(vcpu);
 }
 
@@ -793,6 +811,13 @@ static void intel_mediated_pmu_load(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	u64 global_status, toggle;
 
+	/*
+	 * PERF_METRICS MSR must be restored closely after fixed counter 3
+	 * (kvm_pmu_load_guest_pmcs()).
+	 */
+	if (vcpu_has_perf_metrics(vcpu))
+		wrmsrq(MSR_PERF_METRICS, pmu->perf_metrics);
+
 	rdmsrq(MSR_CORE_PERF_GLOBAL_STATUS, global_status);
 	toggle = pmu->global_status ^ global_status;
 	if (global_status & toggle)
@@ -821,6 +846,12 @@ static void intel_mediated_pmu_put(struct kvm_vcpu *vcpu)
 	 */
 	if (pmu->fixed_ctr_ctrl_hw)
 		wrmsrq(MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
+
+	if (vcpu_has_perf_metrics(vcpu)) {
+		pmu->perf_metrics = rdpmc(INTEL_PMC_FIXED_RDPMC_METRICS);
+		if (pmu->perf_metrics)
+			wrmsrq(MSR_PERF_METRICS, 0);
+	}
 }
 
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/pmu_intel.h b/arch/x86/kvm/vmx/pmu_intel.h
index 5d9357640aa1..2ec547223b09 100644
--- a/arch/x86/kvm/vmx/pmu_intel.h
+++ b/arch/x86/kvm/vmx/pmu_intel.h
@@ -40,4 +40,9 @@ struct lbr_desc {
 
 extern struct x86_pmu_lbr vmx_lbr_caps;
 
+static inline bool vcpu_has_perf_metrics(struct kvm_vcpu *vcpu)
+{
+	return !!(vcpu_get_perf_capabilities(vcpu) & PERF_CAP_PERF_METRICS);
+}
+
 #endif /* __KVM_X86_VMX_PMU_INTEL_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 967b58a8ab9d..4ade1394460a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4338,6 +4338,9 @@ static void vmx_recalc_pmu_msr_intercepts(struct kvm_vcpu *vcpu)
 				  MSR_TYPE_RW, intercept);
 	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
 				  MSR_TYPE_RW, intercept);
+
+	vmx_set_intercept_for_msr(vcpu, MSR_PERF_METRICS, MSR_TYPE_RW,
+				  !vcpu_has_perf_metrics(vcpu));
 }
 
 static void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
@@ -8183,6 +8186,9 @@ static __init u64 vmx_get_perf_capabilities(void)
 		perf_cap &= ~PERF_CAP_PEBS_BASELINE;
 	}
 
+	if (enable_mediated_pmu)
+		perf_cap |= host_perf_cap & PERF_CAP_PERF_METRICS;
+
 	return perf_cap;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2ab7a4958620..4d0e38303aa5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -357,7 +357,7 @@ static const u32 msrs_to_save_pmu[] = {
 	MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
 	MSR_ARCH_PERFMON_FIXED_CTR2, MSR_ARCH_PERFMON_FIXED_CTR3,
 	MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
-	MSR_CORE_PERF_GLOBAL_CTRL,
+	MSR_CORE_PERF_GLOBAL_CTRL, MSR_PERF_METRICS,
 	MSR_IA32_PEBS_ENABLE, MSR_IA32_DS_AREA, MSR_PEBS_DATA_CFG,
 
 	/* This part of MSRs should match KVM_MAX_NR_INTEL_GP_COUNTERS. */
@@ -7675,6 +7675,10 @@ static void kvm_probe_msr_to_save(u32 msr_index)
 		     intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2))
 			return;
 		break;
+	case MSR_PERF_METRICS:
+		if (!(kvm_caps.supported_perf_cap & PERF_CAP_PERF_METRICS))
+			return;
+		break;
 	case MSR_ARCH_PERFMON_PERFCTR0 ...
 	     MSR_ARCH_PERFMON_PERFCTR0 + KVM_MAX_NR_GP_COUNTERS - 1:
 		if (msr_index - MSR_ARCH_PERFMON_PERFCTR0 >=
-- 
2.53.0


