Return-Path: <kvm+bounces-7105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B01783D694
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:38:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B27D1F2521E
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13BA1145343;
	Fri, 26 Jan 2024 08:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RodnbQRQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFF5144628;
	Fri, 26 Jan 2024 08:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259429; cv=none; b=JxAsW/b6D0bNDDQwoUpjunfr4UaRWBVY9HCKBVlfoTycQDjdKuZEgzQO3gjZ+nWKbAsAxZEbOgICjIj38frTextu/TaRtRWBTr/Nd2n+HHo33i/nevdSYR4NOjpAcUtOcdHi9TuZIosbwlxEtKaAhxggC73PxTgFW4ll+vOeWeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259429; c=relaxed/simple;
	bh=33GvgNSc67Y43IDULKlxZdH1EO3byZjhBrpeli7mbiQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VkkKOjDksMQz8c727XkZpxepxeFqFgk1m76nHJvpUWSup771BR4Wf7fvRf/3IAqYzgR61HTGJyiPCMDwsMk65MxwkjkFbSaO5hCLx3VCwJMiAu+sM8NFXRbOCsTvzMJg2960g3WmLPFtPoR7sMT+RH9NU6esrEhivD9FojRlhEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RodnbQRQ; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259428; x=1737795428;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=33GvgNSc67Y43IDULKlxZdH1EO3byZjhBrpeli7mbiQ=;
  b=RodnbQRQ9rRy8YJRaAF998vTCHvwgFxcLj0VwAmek3SZNVjAdWdiBxgF
   RReNHthqhoWz1654EwRMEMH9YIA0JndvRANCOhE2DHxAxPI1+zSyQSQXy
   VTd4E/gLcNSoTfaI2o9WEH3ARxcvtg+WCQ+9CgZsvpAbTEzjOC3FyXeGv
   aTVRh3GLMpreXzEKpdTdJhXivPeJK7Y5lEwBK90n5jnCSM+uOu7cLZdPP
   oDbL5JTPk2pi/RE7ja0ef0vHORZYV6nRlZ5rE4HegBYQhVJiHralP/meI
   XZgLMfm+6PTAxH61IaCGXY7i933UTDS6wfNFRqgbaLoc3PMawjWuMd/BZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792596"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792596"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:57:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310100"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310100"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:57:02 -0800
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
	xiong.y.zhang@linux.intel.com,
	Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [RFC PATCH 18/41] KVM: x86/pmu: Intercept full-width GP counter MSRs by checking with perf capabilities
Date: Fri, 26 Jan 2024 16:54:21 +0800
Message-Id: <20240126085444.324918-19-xiong.y.zhang@linux.intel.com>
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

Intercept full-width GP counter MSRs in passthrough PMU if guest does not
have the capability to write in full-width. In addition, opportunistically
add a warning if non-full-width counter MSRs are also intercepted, in which
case it is a clear mistake.

Co-developed-by: Xiong Zhang <xiong.y.zhang@intel.com>
Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 7f6cabb2c378..49df154fbb5b 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -429,6 +429,13 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
+			if (is_passthrough_pmu_enabled(vcpu) &&
+			    !(msr & MSR_PMC_FULL_WIDTH_BIT) &&
+			    !msr_info->host_initiated) {
+				pr_warn_once("passthrough PMU never intercepts non-full-width PMU counters\n");
+				return 1;
+			}
+
 			if ((msr & MSR_PMC_FULL_WIDTH_BIT) &&
 			    (data & ~pmu->counter_bitmask[KVM_PMC_GP]))
 				return 1;
@@ -801,7 +808,8 @@ void intel_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
 	for (i = 0; i < vcpu_to_pmu(vcpu)->nr_arch_gp_counters; i++) {
 		vmx_set_intercept_for_msr(vcpu, MSR_ARCH_PERFMON_EVENTSEL0 + i, MSR_TYPE_RW, false);
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PERFCTR0 + i, MSR_TYPE_RW, false);
-		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PMC0 + i, MSR_TYPE_RW, false);
+		if (fw_writes_is_enabled(vcpu))
+			vmx_set_intercept_for_msr(vcpu, MSR_IA32_PMC0 + i, MSR_TYPE_RW, false);
 	}
 
 	vmx_set_intercept_for_msr(vcpu, MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_TYPE_RW, false);
-- 
2.34.1


