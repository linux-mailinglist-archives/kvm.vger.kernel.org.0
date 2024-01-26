Return-Path: <kvm+bounces-7121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 532AD83D6CC
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:49:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 37CD4B2C76A
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:46:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6534D14F52F;
	Fri, 26 Jan 2024 08:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tqs/wwmI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505BA14F522;
	Fri, 26 Jan 2024 08:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259510; cv=none; b=N5fO1D5w2UYpBWA4Kau7P9lweL1y8LQ9TNesS5V4Kvp96R5M2rcYH46oCSgQlZKHHG9AL6+oRX33cQ6iUFVFgtKrsm12MnvEgnVPTjJowbkqyLxPflp8XI8Mrx+q7oqT+9F2rWljxRB9hZVcwIi/jaVbVE4bWxIQ9Fr3OxMepvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259510; c=relaxed/simple;
	bh=lc30mIArQmDYKUSrlU3o4au3+PWflrmT0YtX99/0sZg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ui6KgKgyiId+kJhREXcvhWdF7gjRrET5I8SCniKuXhzmI+k+NbgYAR+lpOXy+zIJxlJ+fsQA+LuSy3PA+urmFs86vH0V+YY57zMnezQz9W3apZkQM43BvEKAm0cLX4ZzykQV056Z/MfJA1dfBEbejpEOqUxroOYHa0JLd4s4uSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tqs/wwmI; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259509; x=1737795509;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lc30mIArQmDYKUSrlU3o4au3+PWflrmT0YtX99/0sZg=;
  b=Tqs/wwmI/OtgM+D4eRC89H0NlNzkGUf2/DJBkSPz8xIRB82NBE2gdZ11
   Apev+K97+dDZngSX1Z+NBkzlVfIUzx96U0hXoI+vOo0O6WRg3n5GXizdJ
   ZwnyBdFRuu3ohHEKDn4TJJYf6Z+4FOhFWLYfnOkkgzxEP9ZCI+ASrWIZu
   yyyXDeDzYkLR/zxNlVyjgvfkc5maIgG4eZvgUvxgA3hYSv12H0hW8e9h8
   1lklOh567mz/Md2oktPd2jsIGDJ4cjqmuSbHznkr8Oysmaezj3p9gp7MQ
   /nu6f9H25YrRWqplrr7J7YuJjrNDqNo+YnzVul7941YHQctTmOUgzg1Uq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792978"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792978"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:58:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310425"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310425"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:58:23 -0800
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
Subject: [RFC PATCH 34/41] KVM: x86/pmu: Intercept EVENT_SELECT MSR
Date: Fri, 26 Jan 2024 16:54:37 +0800
Message-Id: <20240126085444.324918-35-xiong.y.zhang@linux.intel.com>
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

From: Xiong Zhang <xiong.y.zhang@intel.com>

Event selectors for GP counters are still intercepted for the purpose of
security, i.e., preventing guest from using unallowed events to steal
information or take advantages of any CPU errata.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 1 -
 arch/x86/kvm/vmx/vmx.c       | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 9bbd5084a766..621922005184 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -809,7 +809,6 @@ void intel_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
 	int i;
 
 	for (i = 0; i < vcpu_to_pmu(vcpu)->nr_arch_gp_counters; i++) {
-		vmx_set_intercept_for_msr(vcpu, MSR_ARCH_PERFMON_EVENTSEL0 + i, MSR_TYPE_RW, false);
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PERFCTR0 + i, MSR_TYPE_RW, false);
 		if (fw_writes_is_enabled(vcpu))
 			vmx_set_intercept_for_msr(vcpu, MSR_IA32_PMC0 + i, MSR_TYPE_RW, false);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d28afa87be70..1a518800d154 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -698,7 +698,6 @@ static bool is_valid_passthrough_msr(u32 msr)
 	case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
 	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
 		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
-	case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 + 7:
 	case MSR_IA32_PMC0 ... MSR_IA32_PMC0 + 7:
 	case MSR_IA32_PERFCTR0 ... MSR_IA32_PERFCTR0 + 7:
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
-- 
2.34.1


