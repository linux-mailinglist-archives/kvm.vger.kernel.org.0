Return-Path: <kvm+bounces-20872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CF89924DA2
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 04:16:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00B8D1F255E2
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 02:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1745743ADF;
	Wed,  3 Jul 2024 02:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FrLHIbfT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83E23C684;
	Wed,  3 Jul 2024 02:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972779; cv=none; b=NAH0dCfCEdLSUEoscYbKw9gY8I1+nhI+3TmNjJYmVa5PXksstYUdooDy6PLoFEoDeFB26N/LoCmShN5PJ9D0/pYSPFu6CRcF9myB8+1PYpzIoEu3yINXGuXZUJepqlx1WLHiY0qO80qURHQPPuLgJLtOQ+FP1oIZnOgbXWTABNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972779; c=relaxed/simple;
	bh=BLmsm0gM4dSBIJJ2W5B1NOYTfu7WTdBS8FwT6npdFoE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FRwKXrBOB/sOwJ0rsRmIwngzFYSiOyJJOTR1FP+G9c8KGJOJVQGKo36h1BX+dA6+4CaCjryWYdHu1czh+4HJIyR9xeVMhxd9C2wFraOTrH5CfZPhQFHNyDPoZ2Ovoxwl8JJtjhcZCr9evSNhKAdPnjP8w6p7qsx3BfxLmh4N/cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FrLHIbfT; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719972778; x=1751508778;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BLmsm0gM4dSBIJJ2W5B1NOYTfu7WTdBS8FwT6npdFoE=;
  b=FrLHIbfTsKUrw6BnngeZI0HJV/cP3mw7F/mrRSyowf9vdgteVDhl0dVx
   nsH0MtE8j50Nz+4x0nf83JlrGSlnrOAvozQK4lt7YXvd84ZsB9I5Hb4tf
   102Vy/S45dyTuzIc82WYtI7ZFIMQw3ltH8hwo50hvdTJN3kuvdIbG1usd
   /D7GZosQNINNuZSoi6SuxvphqSA3ayOjXVo5RdxB2re9qatEAUmLESBJz
   oaV9VAlUvAp8GRYRvaiTs55ddsDkz2ofIQjEv9Cg/L0Us8iFJkiD+iiee
   vnBT2Ag1MFCNJS16C6rOK9aqWjCnOrImGH9tb/YGxjk3dfAxyo+f7Mf7N
   Q==;
X-CSE-ConnectionGUID: B/vwsXjHSde6DHSjiZ5VYA==
X-CSE-MsgGUID: wN2W4TvSQhqBr/nLg7ZWwA==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="17311054"
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="17311054"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:12:57 -0700
X-CSE-ConnectionGUID: EgIKyDyiQ++/IFQ2B9qAQg==
X-CSE-MsgGUID: oscjfgi7QTW1nrEjRRPMiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="46148645"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa010.fm.intel.com with ESMTP; 02 Jul 2024 19:12:55 -0700
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
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [Patch v5 10/18] x86: pmu: Use macro to replace hard-coded instructions event index
Date: Wed,  3 Jul 2024 09:57:04 +0000
Message-Id: <20240703095712.64202-11-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240703095712.64202-1-dapeng1.mi@linux.intel.com>
References: <20240703095712.64202-1-dapeng1.mi@linux.intel.com>
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
index b7de3b58..31b49a74 100644
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
 
@@ -319,11 +321,16 @@ static uint64_t measure_for_overflow(pmu_counter_t *cnt)
 
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
 
@@ -379,13 +386,18 @@ static void check_counter_overflow(void)
 
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
@@ -460,9 +472,14 @@ static void check_running_counter_wrmsr(void)
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
@@ -471,7 +488,7 @@ static void check_running_counter_wrmsr(void)
 	loop();
 	wrmsr(MSR_GP_COUNTERx(0), 0);
 	stop_event(&evt);
-	report(evt.count < gp_events[1].min, "cntr");
+	report(evt.count < gp_events[instruction_idx].min, "cntr");
 
 	/* clear status before overflow test */
 	if (this_cpu_has_perf_global_status())
@@ -502,6 +519,9 @@ static void check_emulated_instr(void)
 	uint64_t gp_counter_width = (1ull << pmu.gp_counter_width) - 1;
 	unsigned int branch_idx = pmu.is_intel ?
 				  INTEL_BRANCHES_IDX : AMD_BRANCHES_IDX;
+	unsigned int instruction_idx = pmu.is_intel ?
+				       INTEL_INSTRUCTIONS_IDX :
+				       AMD_INSTRUCTIONS_IDX;
 	pmu_counter_t brnch_cnt = {
 		.ctr = MSR_GP_COUNTERx(0),
 		/* branch instructions */
@@ -510,7 +530,7 @@ static void check_emulated_instr(void)
 	pmu_counter_t instr_cnt = {
 		.ctr = MSR_GP_COUNTERx(1),
 		/* instructions */
-		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
+		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[instruction_idx].unit_sel,
 	};
 	report_prefix_push("emulated instruction");
 
-- 
2.40.1


