Return-Path: <kvm+bounces-7106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D90A83D696
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:38:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E22F0290A00
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D851E145B23;
	Fri, 26 Jan 2024 08:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UoqDZD1p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D0E145B18;
	Fri, 26 Jan 2024 08:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259434; cv=none; b=Aoif5RM4Qf08IjoLw3sJIGtlZdsWOBCzIBgNiYnBXWLZnrBZdzv9neR9M/h6+2Fbmn2Y/enZvE/Xgi+2oG+JWbE9y6WmqZj/nSrI7AK4MCC+O2eO8mMgdN1xq1vNkgm0HP2Xgn+7Ck9kJmddNp3zkqt7T/T2JwF6An9HuyhR9+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259434; c=relaxed/simple;
	bh=QMfF6UVJKJmKe5Nw2yQkoJ61OilPXSnKASfHqVZmtoU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=k0W+J7AIsk+gMBeEBvq88rVb0rTu8K+ncYrkH/TY8q60eOR8p2SzrYCQBzf+FQHTeVlrtqnSqm2I8sQx0vVhjHwRp3mXWchxnnJnNBYDmFWAsxhuahn4jSG9hpiyv5tmanBv+mzXR4Cjy2/AnLSE6ZJWBeVJ9XlqWLDULo0ghkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UoqDZD1p; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259433; x=1737795433;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QMfF6UVJKJmKe5Nw2yQkoJ61OilPXSnKASfHqVZmtoU=;
  b=UoqDZD1pbIUPp8PX804v2qArGJw/+46FXv1LvaiVkeqwBDjTofYss+Kz
   q6CAFb9Ne1mYU5TkxbC1gTG7xVMr8WPrD/5tfbq1kc8ZoqnklcUsI5bbW
   yFSmc4aLbhl/YIDvLhlbJGggpqxK5HkQQWYUOUJlKL1EGXJ1NonJOGwTM
   UHEqQHo25JkGXC2Bd1lvGoXOjjLq0nj2uLsZN6ZZpi5QxvuyYSPMJVWmT
   8pCZfT5+eFpNGNbqVIjWX5pDJcYDQBxQh0HJuGwx/jKxHhgaQAwiDiM0b
   nn8/4B1fJ5IdXTQ2T6F9weID8UBpN2siohFsBpeSDq/PzmKOk/g5ME3gP
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792620"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792620"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:57:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310107"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310107"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:57:07 -0800
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
Subject: [RFC PATCH 19/41] KVM: x86/pmu: Whitelist PMU MSRs for passthrough PMU
Date: Fri, 26 Jan 2024 16:54:22 +0800
Message-Id: <20240126085444.324918-20-xiong.y.zhang@linux.intel.com>
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

Whitelist PMU MSRs is_valid_passthrough_msr() to avoid warnings in kernel
message. In addition add comments in vmx_possible_passthrough_msrs() to
specify that interception of PMU MSRs are specially handled in
intel_passthrough_pmu_msrs().

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8ab266e1e2a7..349954f90fe9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -158,7 +158,7 @@ module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
 
 /*
  * List of MSRs that can be directly passed to the guest.
- * In addition to these x2apic and PT MSRs are handled specially.
+ * In addition to these x2apic, PMU and PT MSRs are handled specially.
  */
 static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
 	MSR_IA32_SPEC_CTRL,
@@ -698,6 +698,15 @@ static bool is_valid_passthrough_msr(u32 msr)
 	case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
 	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
 		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
+	case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 + 7:
+	case MSR_IA32_PMC0 ... MSR_IA32_PMC0 + 7:
+	case MSR_IA32_PERFCTR0 ... MSR_IA32_PERFCTR0 + 7:
+	case MSR_CORE_PERF_FIXED_CTR_CTRL:
+	case MSR_CORE_PERF_FIXED_CTR0 ... MSR_CORE_PERF_FIXED_CTR0 + 2:
+	case MSR_CORE_PERF_GLOBAL_STATUS:
+	case MSR_CORE_PERF_GLOBAL_CTRL:
+	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
+		/* PMU MSRs. These are handled in intel_passthrough_pmu_msrs() */
 		return true;
 	}
 
-- 
2.34.1


