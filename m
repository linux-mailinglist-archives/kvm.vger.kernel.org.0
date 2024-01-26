Return-Path: <kvm+bounces-7122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E38983D6BF
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:46:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 041F81F231CE
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:46:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A7B84595E;
	Fri, 26 Jan 2024 08:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B6N9e6bh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FB514F547;
	Fri, 26 Jan 2024 08:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259519; cv=none; b=RXJP5dkVDfBvtRpeVm4rDZ+eGvFjkES9Qapq+97cZMiG91/JHirBle1hEgP87+/cHtFPK67cJxl3kKKAJMOJsWrKKeJCAN0hrZjuBYmRXHL6OFliiYT8gwjytDxTFKCDMg2p+ThNvSozKQ62DOb+LAYQV/NsfoeYnK08TkNhhv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259519; c=relaxed/simple;
	bh=Ljh9yt1ZTZazh8g8HMDGH1EBGrH5rCz+avVoyaVnQW0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h7FckSGJ45OuwP1N29hFRYhOGNsybCPeQcZr+j8MYd5zi6xtBmqfYNdzOzSXAlNTchch31cGaP/g+XCWz+LZNZUX8yYxSWIUVgXT5vqb/5bjTiBZ1kmX4gpSlehUH6VxkvMAlbWPINfZimW86j+5Cg1Z5EExlXkJTcMrPy+TDr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B6N9e6bh; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259519; x=1737795519;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ljh9yt1ZTZazh8g8HMDGH1EBGrH5rCz+avVoyaVnQW0=;
  b=B6N9e6bhNtLqJSDKICtGGx0xZuhj2Sv4Lx9oP5e0L0yiMa/uoQF4CqFq
   BP/qZFV8iXvC+4csqJfYVj020yBu13qsFWK0faaKI+3fblCfYV+WD8oba
   QNS4eGcsMklNln0ndpS0K5X2U4+PXhKvwlwuAk7vX55V9zMB0qO0SJyAm
   zlQ0phnECrXLnK18QyZDf1GGua1BEDcPswts8BSDY+xh7fa5UlYLnxNkQ
   YQZF6XcDVvEFl5iXue33CPLbtok/jAPgmSeCCvf32lWGtSYm1Vsp+Tmgk
   uWre2CUogfjpMTwG+gDHtAoL3gbRiq/e7vCoi6eZOL1/OdavQI/fwc66I
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792988"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792988"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:58:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310443"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310443"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:58:28 -0800
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
Subject: [RFC PATCH 35/41] KVM: x86/pmu: Allow writing to event selector for GP counters if event is allowed
Date: Fri, 26 Jan 2024 16:54:38 +0800
Message-Id: <20240126085444.324918-36-xiong.y.zhang@linux.intel.com>
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

Only allow writing to event selector if event is allowed in filter. Since
passthrough PMU implementation does the PMU context switch at VM Enter/Exit
boudary, even if the value of event selector passes the checking, it cannot
be written directly to HW since PMU HW is owned by the host PMU at the
moment.  Because of that, introduce eventsel_hw to cache that value which
will be assigned into HW just before VM entry.

Note that regardless of whether an event value is allowed, the value will
be cached in pmc->eventsel and guest VM can always read the cached value
back. This implementation is consistent with the HW CPU design.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 18 ++++++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ede45c923089..fd1c69371dbf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -503,6 +503,7 @@ struct kvm_pmc {
 	u64 counter;
 	u64 prev_counter;
 	u64 eventsel;
+	u64 eventsel_hw;
 	struct perf_event *perf_event;
 	struct kvm_vcpu *vcpu;
 	/*
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 621922005184..92c5baed8d36 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -458,7 +458,18 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if (data & reserved_bits)
 				return 1;
 
-			if (data != pmc->eventsel) {
+			if (is_passthrough_pmu_enabled(vcpu)) {
+				pmc->eventsel = data;
+				if (!check_pmu_event_filter(pmc)) {
+					/* When guest request an invalid event,
+					 * stop the counter by clearing the
+					 * event selector MSR.
+					 */
+					pmc->eventsel_hw = 0;
+					return 0;
+				}
+				pmc->eventsel_hw = data;
+			} else if (data != pmc->eventsel) {
 				pmc->eventsel = data;
 				kvm_pmu_request_counter_reprogram(pmc);
 			}
@@ -843,13 +854,12 @@ static void intel_save_pmu_context(struct kvm_vcpu *vcpu)
 	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
 		pmc = &pmu->gp_counters[i];
 		rdpmcl(i, pmc->counter);
-		rdmsrl(i + MSR_ARCH_PERFMON_EVENTSEL0, pmc->eventsel);
 		/*
 		 * Clear hardware PERFMON_EVENTSELx and its counter to avoid
 		 * leakage and also avoid this guest GP counter get accidentally
 		 * enabled during host running when host enable global ctrl.
 		 */
-		if (pmc->eventsel)
+		if (pmc->eventsel_hw)
 			wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, 0);
 		if (pmc->counter)
 			wrmsrl(MSR_IA32_PMC0 + i, 0);
@@ -894,7 +904,7 @@ static void intel_restore_pmu_context(struct kvm_vcpu *vcpu)
 	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
 		pmc = &pmu->gp_counters[i];
 		wrmsrl(MSR_IA32_PMC0 + i, pmc->counter);
-		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, pmc->eventsel);
+		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, pmc->eventsel_hw);
 	}
 
 	/*
-- 
2.34.1


