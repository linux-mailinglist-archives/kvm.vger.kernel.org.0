Return-Path: <kvm+bounces-7104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C24783D689
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:37:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1C24B2794C
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:37:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E7A71419BF;
	Fri, 26 Jan 2024 08:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MZn8s8xT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0696141989;
	Fri, 26 Jan 2024 08:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259424; cv=none; b=nT6N41TRDNNBB8uuI4QvZeCvbaQ2eARp1wQ40coI3g9rGQ8AXxKFgd5BHkaceR17efOaRWWAmaqgvdKbgi/Zk+szPQ2c6O5Emc/nJ3DNfmAyiWEzrTsEdLT4mKSBifT2ZEbrfKX3Hvvj6JpBBzAA1e2toLJU9JWHH0nmh17dB7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259424; c=relaxed/simple;
	bh=GzJZFmwxaViqE549pvNgrElLN7vRyewyPIaEXXRczfc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uxTZIbKJjQHPXOL12FYEd6IgZSUICDDTCwamp3US4n8enWvfl5PKOPekRYBCyQx0uk0lnN9UQWmp7ga7ZyTxUHt36UcVj8xyiOuK8Rvolf1iOBVNotxwi1tj81mXrXluAWNC/qUMbAWht0iLCBx7OepAIERDWqoKewbb6QrdA/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MZn8s8xT; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259423; x=1737795423;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GzJZFmwxaViqE549pvNgrElLN7vRyewyPIaEXXRczfc=;
  b=MZn8s8xTS3blgqv5/60f0HP3oKe7efeDMhJPyyxt0/CI+pOMpNIr3WFu
   il65di4ax0Y1ZxnWndh9KeRlRssLLXkEZBirT9F3Ik0WyRAUrWNYARlWi
   lHH6DA29uaUps5/Q4m1z4gTn0Tcgu3XW4DtphFD13+PTk5NG0SR9RSvZd
   pJjwQ7+YsfI2PoHcf4zHkYXINAvToo0h6pVYRwJ90uVHC//1QaeBpAwNR
   oY4EFtdm+AjIu7z3wFVzITfg0gegNr0B148aWqiK9zY3vIbFv5wIBYlGS
   7x7ZGhKVWpcPRsk+XMaX7vgxyes43wxlrkWs0m1Yhp3C6p/3XGNTaR4Z7
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792564"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792564"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:57:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310087"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310087"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:56:57 -0800
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
Subject: [RFC PATCH 17/41] KVM: x86/pmu: Implement pmu function for Intel CPU to disable MSR interception
Date: Fri, 26 Jan 2024 16:54:20 +0800
Message-Id: <20240126085444.324918-18-xiong.y.zhang@linux.intel.com>
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

Disable PMU MSRs interception, these MSRs are defined in Architectural
Performance Monitoring from SDM, so that guest can access them without
VM-exit.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 15cc107ed573..7f6cabb2c378 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -794,6 +794,25 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
 	}
 }
 
+void intel_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
+{
+	int i;
+
+	for (i = 0; i < vcpu_to_pmu(vcpu)->nr_arch_gp_counters; i++) {
+		vmx_set_intercept_for_msr(vcpu, MSR_ARCH_PERFMON_EVENTSEL0 + i, MSR_TYPE_RW, false);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PERFCTR0 + i, MSR_TYPE_RW, false);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PMC0 + i, MSR_TYPE_RW, false);
+	}
+
+	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_TYPE_RW, false);
+	for (i = 0; i < vcpu_to_pmu(vcpu)->nr_arch_fixed_counters; i++)
+		vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_FIXED_CTR0 + i, MSR_TYPE_RW, false);
+
+	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_GLOBAL_STATUS, MSR_TYPE_RW, false);
+	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL, MSR_TYPE_RW, false);
+	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL, MSR_TYPE_RW, false);
+}
+
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.hw_event_available = intel_hw_event_available,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
@@ -808,6 +827,7 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.reset = intel_pmu_reset,
 	.deliver_pmi = intel_pmu_deliver_pmi,
 	.cleanup = intel_pmu_cleanup,
+	.passthrough_pmu_msrs = intel_passthrough_pmu_msrs,
 	.EVENTSEL_EVENT = ARCH_PERFMON_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_INTEL_PMC_MAX_GENERIC,
 	.MIN_NR_GP_COUNTERS = 1,
-- 
2.34.1


