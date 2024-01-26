Return-Path: <kvm+bounces-7111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A085383D6A1
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:40:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D36551C2A417
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:40:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C24A148304;
	Fri, 26 Jan 2024 08:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xwf7SOLT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A43629CFD;
	Fri, 26 Jan 2024 08:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259459; cv=none; b=n5FYbxXZAZT/jgWdTdn4Tc9hktB/IVyqU+6VjLrsLg8Tw2sAWoS0z0o6fKvP1YwNXHL8Qz69txl//cKGRtnbofQNk4IuE34Jjzu5y+w440RnqjLf+6T0U0HKFO5ddxfdo2fxma/2Ie7DWIfQncoNEUAJlTPVh3GRA4BsegzOjlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259459; c=relaxed/simple;
	bh=3WCeEYGAFPAkAns129DOzz7S7gPlPsPln4IPxq3aqXs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=avKoSh3s0ksM3hSa1pLxIUpd/kVGQndbrP61KzV07FX1Tzcwl5v7a6/Z4gQO/Ebo0iqXI/r6rM4MmzqLNhNwyPY4Mb5djTsJR4Q8oWyCWihMvUOPt5XBg1PeOeghjSUB/2KgzIqXLeQaJ4MdXFctKZBUCySfxffofuVcYRrWQDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xwf7SOLT; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259458; x=1737795458;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3WCeEYGAFPAkAns129DOzz7S7gPlPsPln4IPxq3aqXs=;
  b=Xwf7SOLTwuKzfiNSCT8L9syxt/Q/DhttC51thRDpVFoYuwmkNvms58Hd
   gEj/S1RLjbF7VO26KDVjY9p4X70x0VM/1MnJzrMnjt4dGZNqToNZzW+yr
   bslXLjV0noSt7c6H2Z9FnfoW0hQ9Ss2YHeVSruP98wxtRSooGqExgvIpy
   Cu+Nwk8G/+YdkGYssskmloyk3X+AIhKTaI0aGQ0aaBHtMHDYVTSh6A/bi
   +wVL/opcj2msjp/3O+LVEJ+jKSL0FB8YyLVbivY37LcM+SfTd6oEEyCO2
   rRZjRwOQhVogVKoxP3jApwYyQ8dx8SCqhC7b+UVZxWA6njmw1rLX/8Xrx
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792686"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792686"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:57:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310204"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310204"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:57:32 -0800
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
Subject: [RFC PATCH 24/41] KVM: x86/pmu: Zero out unexposed Counters/Selectors to avoid information leakage
Date: Fri, 26 Jan 2024 16:54:27 +0800
Message-Id: <20240126085444.324918-25-xiong.y.zhang@linux.intel.com>
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

Zero out unexposed counters/selectors because even though KVM intercepts
all accesses to unexposed PMU MSRs, it does pass through RDPMC instruction
which allows guest to read all GP counters and fixed counters. So, zero out
unexposed counter values which might contain critical information for the
host.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index f79bebe7093d..4b4da7f17895 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -895,11 +895,27 @@ static void intel_restore_pmu_context(struct kvm_vcpu *vcpu)
 		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, pmc->eventsel);
 	}
 
+	/*
+	 * Zero out unexposed GP counters/selectors to avoid information leakage
+	 * since passthrough PMU does not intercept RDPMC.
+	 */
+	for (i = pmu->nr_arch_gp_counters; i < kvm_pmu_cap.num_counters_gp; i++) {
+		wrmsrl(MSR_IA32_PMC0 + i, 0);
+		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, 0);
+	}
+
 	wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
 	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
 		pmc = &pmu->fixed_counters[i];
 		wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, pmc->counter);
 	}
+
+	/*
+	 * Zero out unexposed fixed counters to avoid information leakage
+	 * since passthrough PMU does not intercept RDPMC.
+	 */
+	for (i = pmu->nr_arch_fixed_counters; i < kvm_pmu_cap.num_counters_fixed; i++)
+		wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
 }
 
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
-- 
2.34.1


