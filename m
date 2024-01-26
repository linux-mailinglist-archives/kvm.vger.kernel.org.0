Return-Path: <kvm+bounces-7110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EBBC883D69F
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:40:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 795BC1F2D34D
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9FF01474DE;
	Fri, 26 Jan 2024 08:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pj+X4SWu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77CF33CF7;
	Fri, 26 Jan 2024 08:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259454; cv=none; b=ulB4MJD60A/2yYTYJXcT/NWQroeNnHgVWUQEcHg4Ow6FCxTDWhrAmKJUfCiWmU79CmCbbFabVWi3N5ijJABpXc6SVf0Utjufr2ui+IFIYsjxGkhLIsJVbiij9jWxwVKyj2ryHDzQZvtesUfAwCATPSHufkzUla+M46FOFHqZ9lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259454; c=relaxed/simple;
	bh=aqXZtsYM8yBxMah4+UqygYn+me8SEAHU5KBDJu/R31g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h4XC1z2bAquftol1QzZ9dEqFRk6dTQi4rwn2iPygR63NrkgF+wmB7XeOA4K67E9GWgOiXXDnkyYvelS/Xeg2HlLi5dW6giftC6ksx2khc9BE3QRG/hmPD0nCm2m7GJljI3iw1JZNURzumjv0WWfYMSzM9xBI5o+XeXwRPyvfVgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pj+X4SWu; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259453; x=1737795453;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aqXZtsYM8yBxMah4+UqygYn+me8SEAHU5KBDJu/R31g=;
  b=Pj+X4SWupkwYi1e8NlXB8tgFTm4+TBb2gO0OzvTamuNZYmCCP/TpDDNG
   IlvqnKcv3GVWTkP9V34rWnRN/tigrBXy6mN06sLYPjmAlUcPE2K5fmrSJ
   AYTXaTEOsvUxtNLRki1sOYFHmh01l89EYfWxLbVxC/S7h5827PdsErW68
   ZZFOMRpkIVv16MHz6fzvibQjTp9R0DzfKKYRavt25hoATk6BAF9y823Sg
   VKATE++Jn1mo5EAsRYy9dE8J6FfB6fDDBGzqcL1WNTknlPOlElDPZljTT
   ZBAlQYF5Nz+dan7Oy7zbkUo0DGLqUMxV87XOxuW9SRiaSgp0B4gizG/yz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792668"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792668"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:57:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310191"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310191"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:57:27 -0800
From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	peterz@infradead.org,
	mizhang@google.com,
	kan.liang@intel.com,
	zhenyuw@linux.intel.com,
	dapeng1.mi@linux.intel.com,
	jmattson@google.com
Cc: kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiyuan.lv@intel.com,
	eranian@google.com,
	irogers@google.com,
	samantha.alt@intel.com,
	like.xu.linux@gmail.com,
	chao.gao@intel.com,
	xiong.y.zhang@linux.intel.com
Subject: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU state for Intel CPU
Date: Fri, 26 Jan 2024 16:54:26 +0800
Message-Id: <20240126085444.324918-24-xiong.y.zhang@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Implement the save/restore of PMU state for pasthrough PMU in Intel. In
passthrough mode, KVM owns exclusively the PMU HW when control flow goes to
the scope of passthrough PMU. Thus, KVM needs to save the host PMU state
and gains the full HW PMU ownership. On the contrary, host regains the
ownership of PMU HW from KVM when control flow leaves the scope of
passthrough PMU.

Implement PMU context switches for Intel CPUs and opptunistically use
rdpmcl() instead of rdmsrl() when reading counters since the former has
lower latency in Intel CPUs.

Co-developed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 73 ++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 0d58fe7d243e..f79bebe7093d 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -823,10 +823,83 @@ void intel_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
 
 static void intel_save_pmu_context(struct kvm_vcpu *vcpu)
 {
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
+	u32 i;
+
+	if (pmu->version != 2) {
+		pr_warn("only PerfMon v2 is supported for passthrough PMU");
+		return;
+	}
+
+	/* Global ctrl register is already saved at VM-exit. */
+	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, pmu->global_status);
+	/* Clear hardware MSR_CORE_PERF_GLOBAL_STATUS MSR, if non-zero. */
+	if (pmu->global_status)
+		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, pmu->global_status);
+
+	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
+		pmc = &pmu->gp_counters[i];
+		rdpmcl(i, pmc->counter);
+		rdmsrl(i + MSR_ARCH_PERFMON_EVENTSEL0, pmc->eventsel);
+		/*
+		 * Clear hardware PERFMON_EVENTSELx and its counter to avoid
+		 * leakage and also avoid this guest GP counter get accidentally
+		 * enabled during host running when host enable global ctrl.
+		 */
+		if (pmc->eventsel)
+			wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, 0);
+		if (pmc->counter)
+			wrmsrl(MSR_IA32_PMC0 + i, 0);
+	}
+
+	rdmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
+	/*
+	 * Clear hardware FIXED_CTR_CTRL MSR to avoid information leakage and
+	 * also avoid these guest fixed counters get accidentially enabled
+	 * during host running when host enable global ctrl.
+	 */
+	if (pmu->fixed_ctr_ctrl)
+		wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
+	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+		pmc = &pmu->fixed_counters[i];
+		rdpmcl(INTEL_PMC_FIXED_RDPMC_BASE | i, pmc->counter);
+		if (pmc->counter)
+			wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
+	}
 }
 
 static void intel_restore_pmu_context(struct kvm_vcpu *vcpu)
 {
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
+	u64 global_status;
+	int i;
+
+	if (pmu->version != 2) {
+		pr_warn("only PerfMon v2 is supported for passthrough PMU");
+		return;
+	}
+
+	/* Clear host global_ctrl and global_status MSR if non-zero. */
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, global_status);
+	if (global_status)
+		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, global_status);
+
+	wrmsrl(MSR_CORE_PERF_GLOBAL_STATUS_SET, pmu->global_status);
+
+	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
+		pmc = &pmu->gp_counters[i];
+		wrmsrl(MSR_IA32_PMC0 + i, pmc->counter);
+		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, pmc->eventsel);
+	}
+
+	wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
+	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+		pmc = &pmu->fixed_counters[i];
+		wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, pmc->counter);
+	}
 }
 
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
-- 
2.34.1


