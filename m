Return-Path: <kvm+bounces-7124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BAC5683D6C4
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:47:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 703531F2D360
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:47:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16698151458;
	Fri, 26 Jan 2024 08:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nMi0Gc4A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007544595F;
	Fri, 26 Jan 2024 08:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259526; cv=none; b=pscJeA3C+k5/tDj/DphuC0q6Jyn++RPyhOTQonHAU6wo3igDMYoHRnUl4QQ8R19bsOVk0dxuc5wzmFeiJ3nSd3N8LQXtGVk1qhTITe3uD3Qnxzkact7+KA5OL3sxO/wASuALLRfJcajLeqFc+2deTXmCU+4XQwPc+w9sn7pjFEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259526; c=relaxed/simple;
	bh=x5C5Od06oBAnqpreQLTjGicQhvVIOtKOokF+NlLLHQY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SjmzZ15Hisqro4E56jGHAoPkwm4G8IFyqD4iPttW9urllIFpkF2HZ/9AOnEj9mYErmcfVv/gTWrI7a9zhT0cX8lLi6PAuXM4JNmBHg4KZ8qnVgiL5GYfvxAM7hq6EopnyVccTVKXBEnuSlqIIeFucFcDY0oVhKIE+2sjo8MTF9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nMi0Gc4A; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259525; x=1737795525;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x5C5Od06oBAnqpreQLTjGicQhvVIOtKOokF+NlLLHQY=;
  b=nMi0Gc4ADYFhJTLRcbfAXIXn1gdiQxEBQ1guAHIbRNTx46mNJ4bDBNG/
   RwlqMRzOak4zYcRTYTd7/fWzeNDoVQgIvzIMu7vmRBSoNrCBXYuFQbp8W
   E0heKRz/XWJiEgWKh/V5EqU3ubcyMkgzfg/0a9nk1bX+RWyU7szyzVAlo
   A/x9v54YtEecH4MvnhqzxhJN0btVqFL8pkV9e9WaySD2gB9FcmBoT6lYw
   sh4zNDLYhIN3neLUmR+6TwZavGDVnQSmEiRcM4gtUWXpJEw+/HRb67ebK
   P9Ci+/PdQByC9EAoa/dKy61GNd3hpePGNQjmfLiXfPx6S5XUZJVC8e1ij
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9793046"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9793046"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:58:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310478"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310478"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:58:39 -0800
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
Subject: [RFC PATCH 37/41] KVM: x86/pmu: Allow writing to fixed counter selector if counter is exposed
Date: Fri, 26 Jan 2024 16:54:40 +0800
Message-Id: <20240126085444.324918-38-xiong.y.zhang@linux.intel.com>
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

From: Mingwei Zhang <mizhang@google.com>

Allow writing to fixed counter selector if counter is exposed. If this
fixed counter is filtered out, this counter won't be enabled on HW.

Passthrough PMU implements the context switch at VM Enter/Exit boundary the
guest value cannot be directly written to HW since the HW PMU is owned by
the host. Introduce a new field fixed_ctr_ctrl_hw in kvm_pmu to cache the
guest value.  which will be assigne to HW at PMU context restore.

Since passthrough PMU intercept writes to fixed counter selector, there is
no need to read the value at pmu context save, but still clear the fix
counter ctrl MSR and counters when switching out to host PMU.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 28 ++++++++++++++++++++++++----
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fd1c69371dbf..b02688ed74f7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -527,6 +527,7 @@ struct kvm_pmu {
 	unsigned nr_arch_fixed_counters;
 	unsigned available_event_types;
 	u64 fixed_ctr_ctrl;
+	u64 fixed_ctr_ctrl_hw;
 	u64 fixed_ctr_ctrl_mask;
 	u64 global_ctrl;
 	u64 global_status;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 713c2a7c7f07..93cfb86c1292 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -68,6 +68,25 @@ static int fixed_pmc_events[] = {
 	[2] = PSEUDO_ARCH_REFERENCE_CYCLES,
 };
 
+static void reprogram_fixed_counters_in_passthrough_pmu(struct kvm_pmu *pmu, u64 data)
+{
+	struct kvm_pmc *pmc;
+	u64 new_data = 0;
+	int i;
+
+	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+		pmc = get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i);
+		if (check_pmu_event_filter(pmc)) {
+			pmc->current_config = fixed_ctrl_field(data, i);
+			new_data |= intel_fixed_bits_by_idx(i, pmc->current_config);
+		} else {
+			pmc->counter = 0;
+		}
+	}
+	pmu->fixed_ctr_ctrl_hw = new_data;
+	pmu->fixed_ctr_ctrl = data;
+}
+
 static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 {
 	struct kvm_pmc *pmc;
@@ -401,7 +420,9 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data & pmu->fixed_ctr_ctrl_mask)
 			return 1;
 
-		if (pmu->fixed_ctr_ctrl != data)
+		if (is_passthrough_pmu_enabled(vcpu))
+			reprogram_fixed_counters_in_passthrough_pmu(pmu, data);
+		else if (pmu->fixed_ctr_ctrl != data)
 			reprogram_fixed_counters(pmu, data);
 		break;
 	case MSR_IA32_PEBS_ENABLE:
@@ -864,13 +885,12 @@ static void intel_save_pmu_context(struct kvm_vcpu *vcpu)
 			wrmsrl(MSR_IA32_PMC0 + i, 0);
 	}
 
-	rdmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
 	/*
 	 * Clear hardware FIXED_CTR_CTRL MSR to avoid information leakage and
 	 * also avoid these guest fixed counters get accidentially enabled
 	 * during host running when host enable global ctrl.
 	 */
-	if (pmu->fixed_ctr_ctrl)
+	if (pmu->fixed_ctr_ctrl_hw)
 		wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
 	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
 		pmc = &pmu->fixed_counters[i];
@@ -915,7 +935,7 @@ static void intel_restore_pmu_context(struct kvm_vcpu *vcpu)
 		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, 0);
 	}
 
-	wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
+	wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl_hw);
 	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
 		pmc = &pmu->fixed_counters[i];
 		wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, pmc->counter);
-- 
2.34.1


