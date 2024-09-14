Return-Path: <kvm+bounces-26906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 73CBF978EAE
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 09:04:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E7037B26C92
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 07:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2764C1D015D;
	Sat, 14 Sep 2024 07:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VJkN42E6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FA01CF5D3;
	Sat, 14 Sep 2024 07:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726297301; cv=none; b=CU8f6iEAzpCyW6aJpvgJgpKgqO7+PzTQY3pxQHK+9BHNQ+p5svbZ1QHuM8l89NIMg8FWfXNWm1S7ZxRd7x2ZAzULSF03HgnncPpnKRoAL9NMhldqV/JKQQJFotNKUS+QlzDR3KMtJ5pCDDzreUqtbanEUkmT/ZohbhI1/HviaxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726297301; c=relaxed/simple;
	bh=oXErb7tWEYRmcTgERbH7uxK8jSQS/T5b989AwlEhXdg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tXkZmtQZoeY6fvzeufdcZYMiZnuWK2S8vU2QeNG71E29Bbj9ihDapSubn3NGCxiXG2/4yO3NobjUZL7NUD/Qbg/2Me3CU1nzB/MLH20aCdv1peGZtgYwmFOBQf2O95uRs7XlPh5UaqneeNayJqODh9SrW6RkPskqgcZa+oDXmhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VJkN42E6; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726297300; x=1757833300;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oXErb7tWEYRmcTgERbH7uxK8jSQS/T5b989AwlEhXdg=;
  b=VJkN42E6MwVgJFiyb+wWgUJWNWp0nQkWfV1NfHe3kVOZGHnxACO4cSAV
   CcTD56JW6h9mvV7xxSCHJoAG7aBlXB0GIiu1AIZ2imC43NKTAQjnzCsvm
   hcETHsIt/WdzG5gSLRzWgYrDYKamiP0bFYMcM3wU0kwfwoWjzN5AIxXFq
   QfbFJUQVIkIMxhBmSmB6vuEG44yy2Q2SZiBnIsmPVOfgOcQdbTw1azf5x
   E5nfyAd9WfXO0n+655Ps7onveFwe8y8p8T9qt3Donf3EhZnxdfsKwW+h1
   MdjlI73th0opsQRGZNEgKSNDd4TDWajyJF2MZmky5gDdFNEWahw+tTdGU
   w==;
X-CSE-ConnectionGUID: Te0FZd+MRrO+RxqKlddx2g==
X-CSE-MsgGUID: s2zssjELT0ybAQv8MczwUQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="35778822"
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="35778822"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2024 00:01:40 -0700
X-CSE-ConnectionGUID: ermrybJ2SUiZh1Yp1FfbHQ==
X-CSE-MsgGUID: 44PPAOhASdWQwpJS1QEo0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="67950969"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa006.fm.intel.com with ESMTP; 14 Sep 2024 00:01:37 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests patch v6 11/18] x86: pmu: Use macro to replace hard-coded instructions event index
Date: Sat, 14 Sep 2024 10:17:21 +0000
Message-Id: <20240914101728.33148-12-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
References: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace hard-coded instruction event index with macro to avoid possible
mismatch issue if new event is added in the future and cause
instructions event index changed, but forget to update the hard-coded
event index.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 523369b2..91484c77 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -55,6 +55,7 @@ struct pmu_event {
  * intel_gp_events[].
  */
 enum {
+	INTEL_INSTRUCTIONS_IDX  = 1,
 	INTEL_REF_CYCLES_IDX	= 2,
 	INTEL_BRANCHES_IDX	= 5,
 };
@@ -64,6 +65,7 @@ enum {
  * amd_gp_events[].
  */
 enum {
+	AMD_INSTRUCTIONS_IDX    = 1,
 	AMD_BRANCHES_IDX	= 2,
 };
 
@@ -328,11 +330,16 @@ static uint64_t measure_for_overflow(pmu_counter_t *cnt)
 
 static void check_counter_overflow(void)
 {
-	uint64_t overflow_preset;
 	int i;
+	uint64_t overflow_preset;
+	int instruction_idx = pmu.is_intel ?
+			      INTEL_INSTRUCTIONS_IDX :
+			      AMD_INSTRUCTIONS_IDX;
+
 	pmu_counter_t cnt = {
 		.ctr = MSR_GP_COUNTERx(0),
-		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
+		.config = EVNTSEL_OS | EVNTSEL_USR |
+			  gp_events[instruction_idx].unit_sel /* instructions */,
 	};
 	overflow_preset = measure_for_overflow(&cnt);
 
@@ -388,13 +395,18 @@ static void check_counter_overflow(void)
 
 static void check_gp_counter_cmask(void)
 {
+	int instruction_idx = pmu.is_intel ?
+			      INTEL_INSTRUCTIONS_IDX :
+			      AMD_INSTRUCTIONS_IDX;
+
 	pmu_counter_t cnt = {
 		.ctr = MSR_GP_COUNTERx(0),
-		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
+		.config = EVNTSEL_OS | EVNTSEL_USR |
+			  gp_events[instruction_idx].unit_sel /* instructions */,
 	};
 	cnt.config |= (0x2 << EVNTSEL_CMASK_SHIFT);
 	measure_one(&cnt);
-	report(cnt.count < gp_events[1].min, "cmask");
+	report(cnt.count < gp_events[instruction_idx].min, "cmask");
 }
 
 static void do_rdpmc_fast(void *ptr)
@@ -469,9 +481,14 @@ static void check_running_counter_wrmsr(void)
 {
 	uint64_t status;
 	uint64_t count;
+	unsigned int instruction_idx = pmu.is_intel ?
+				       INTEL_INSTRUCTIONS_IDX :
+				       AMD_INSTRUCTIONS_IDX;
+
 	pmu_counter_t evt = {
 		.ctr = MSR_GP_COUNTERx(0),
-		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
+		.config = EVNTSEL_OS | EVNTSEL_USR |
+			  gp_events[instruction_idx].unit_sel,
 	};
 
 	report_prefix_push("running counter wrmsr");
@@ -480,7 +497,7 @@ static void check_running_counter_wrmsr(void)
 	loop();
 	wrmsr(MSR_GP_COUNTERx(0), 0);
 	stop_event(&evt);
-	report(evt.count < gp_events[1].min, "cntr");
+	report(evt.count < gp_events[instruction_idx].min, "cntr");
 
 	/* clear status before overflow test */
 	if (this_cpu_has_perf_global_status())
@@ -511,6 +528,9 @@ static void check_emulated_instr(void)
 	uint64_t gp_counter_width = (1ull << pmu.gp_counter_width) - 1;
 	unsigned int branch_idx = pmu.is_intel ?
 				  INTEL_BRANCHES_IDX : AMD_BRANCHES_IDX;
+	unsigned int instruction_idx = pmu.is_intel ?
+				       INTEL_INSTRUCTIONS_IDX :
+				       AMD_INSTRUCTIONS_IDX;
 	pmu_counter_t brnch_cnt = {
 		.ctr = MSR_GP_COUNTERx(0),
 		/* branch instructions */
@@ -519,7 +539,7 @@ static void check_emulated_instr(void)
 	pmu_counter_t instr_cnt = {
 		.ctr = MSR_GP_COUNTERx(1),
 		/* instructions */
-		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
+		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[instruction_idx].unit_sel,
 	};
 	report_prefix_push("emulated instruction");
 
-- 
2.40.1


