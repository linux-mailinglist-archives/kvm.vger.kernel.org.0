Return-Path: <kvm+bounces-7127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 45CEA83D6CE
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:49:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C66FE1F2F994
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:49:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03B17152E04;
	Fri, 26 Jan 2024 08:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JEEePFvw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD62482CD;
	Fri, 26 Jan 2024 08:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259542; cv=none; b=qxsms+8CpVNAh40B5Yaf3uGznbI94fJ8XWoou2Vg6AKA5forzC/fFrKGyG/2oGXan0mRJorwKdjGT6Gf++zl4LoF+YztRwGA0Uu8nLO/tAQAihc0jeGEeLaehc8A0Z7aJBztmAD6Y/piunU1Hl+NVp5lMwwwdURljou6u0iQCvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259542; c=relaxed/simple;
	bh=4CxvW83RwYpJecZ+4IDD/HSNudmMoK3QPmnjuOvCTfI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G0ju54kDNAf7Y2V6aL2m4ru5aTKTKYAeEnIiXdYXRbr0SjFGaUppUnnE707Ge3WgMm3WIwukOA1dysF2wB7rRLgBy4a/NKmGYfrFzkHhydynC5DqwBHBUexRm5QH0KBEwaf2spRJqABxAnjNzPEbg+FCh73CEIp9pqRnetjmPb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JEEePFvw; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259541; x=1737795541;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4CxvW83RwYpJecZ+4IDD/HSNudmMoK3QPmnjuOvCTfI=;
  b=JEEePFvwWQMaP9ciI4V0jIvmJ2gtyoJMVgFZ2VM53qU3Y6tVANC100ke
   afcMAeXzmsrlVt0hwEmI2EfTKfKFxv8d4TcwliQXZER52DLAtvIJw7aEG
   z+hfoe1FpPtnZRkNBfmNpaTNnO/Fk7nbK9TpakvyyMfXiZV5oWRp5L+H1
   J8qpiHFc2bh3uCAOly/l2QR7pEiXYhArOvp9tdgb0J3d1LW0g70vE6EPW
   YSfY7JOKN6wRxxy2yo0jyIuNsdgcOZeGaUCzecAHXELTo91glcIYaWRbQ
   BQnXWWPTJrrylbbemHxLq96PDBqZ+nfiPWtvAua6QOags6dRINxxhMR7T
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9793141"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9793141"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:59:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310561"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310561"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:58:54 -0800
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
Subject: [RFC PATCH 40/41] KVM: x86/pmu: Separate passthrough PMU logic in set/get_msr() from non-passthrough vPMU
Date: Fri, 26 Jan 2024 16:54:43 +0800
Message-Id: <20240126085444.324918-41-xiong.y.zhang@linux.intel.com>
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

Separate passthrough PMU logic from non-passthrough vPMU code. There are
two places in passthrough vPMU when set/get_msr() may call into the
existing non-passthrough vPMU code: 1) set/get counters; 2) set global_ctrl
MSR.

In the former case, non-passthrough vPMU will call into
pmc_{read,write}_counter() which wires to the perf API. Update these
functions to avoid the perf API invocation.

The 2nd case is where global_ctrl MSR writes invokes reprogram_counters()
which will invokes the non-passthrough PMU logic. So use pmu->passthrough
flag to wrap out the call.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/pmu.c |  4 +++-
 arch/x86/kvm/pmu.h | 10 +++++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 9e62e96fe48a..de653a67ba93 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -652,7 +652,9 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (pmu->global_ctrl != data) {
 			diff = pmu->global_ctrl ^ data;
 			pmu->global_ctrl = data;
-			reprogram_counters(pmu, diff);
+			/* Passthrough vPMU never reprogram counters. */
+			if (!pmu->passthrough)
+				reprogram_counters(pmu, diff);
 		}
 		break;
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 0fc37a06fe48..ab8d4a8e58a8 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -70,6 +70,9 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
 	u64 counter, enabled, running;
 
 	counter = pmc->counter;
+	if (pmc_to_pmu(pmc)->passthrough)
+		return counter & pmc_bitmask(pmc);
+
 	if (pmc->perf_event && !pmc->is_paused)
 		counter += perf_event_read_value(pmc->perf_event,
 						 &enabled, &running);
@@ -79,7 +82,12 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
 
 static inline void pmc_write_counter(struct kvm_pmc *pmc, u64 val)
 {
-	pmc->counter += val - pmc_read_counter(pmc);
+	/* In passthrough PMU, counter value is the actual value in HW. */
+	if (pmc_to_pmu(pmc)->passthrough)
+		pmc->counter = val;
+	else
+		pmc->counter += val - pmc_read_counter(pmc);
+
 	pmc->counter &= pmc_bitmask(pmc);
 }
 
-- 
2.34.1


