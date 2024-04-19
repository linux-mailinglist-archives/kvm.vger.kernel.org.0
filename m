Return-Path: <kvm+bounces-15195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D44128AA76D
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 05:48:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B00F285916
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 03:48:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 387B752F7D;
	Fri, 19 Apr 2024 03:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UqvJdMNe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9994317A;
	Fri, 19 Apr 2024 03:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713498365; cv=none; b=OHxS0HYLn9xXjfsmy87INGmGR3TyaDnREIdvaqS6G01hSbeDRYvDMlQxL6tdUYVZZtbGPe3EC4TvivgWkloiSBbdOOV3IrFEJM2EuGhKFsQOtwqAX3RUFC/dDBIi3oUleIQT2UUX2HXX8a0uKr70nwFlrt8NSSq2ny2pBWaoIC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713498365; c=relaxed/simple;
	bh=/eDNOrT42kpAxYyGh97YDD4hXbu+mRJnDOxAdDrrLl4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=adDPtdClBmh06mMry9F/PoC2htaKlgl9Fwt/8llTOE2Q8gJFjWhs9GjwC5fB98nByreJ+fVoIfev5Oxq7JAoc44QK2NIwD5B+FxaKGyP953IDX6+yQ5A5p0VWO12NMXKD0grCol1N4+j5exS0QrffOyXFdX8HkOd4x3n5jY2Blc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UqvJdMNe; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713498363; x=1745034363;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/eDNOrT42kpAxYyGh97YDD4hXbu+mRJnDOxAdDrrLl4=;
  b=UqvJdMNexQBN6bfgz0Dm1R4r6L+ZBuGLmUVi5uw+b/U2cJH3EELRgHdk
   PEbsE5OFm2UVYccQ5aPK0RGvGUXIfOO/KZ6URXTuQPQ5CEwku+uvFYzb8
   Q73fkeSFny19e+qpNSix+8lchmYD6O8Y3+4mvKIYgssuu6IoJoVdLtAQJ
   3bNDOJMOcFXrkmvY+4YYQGINDN+sZEOPtrqXDsOUcl6WmicC+fAccgKtZ
   uIrdlAmResTV5eKLOXSP7ROnPaAarf9fQWlJctb1NEryZovc6Xhfmsb8v
   b/KE4LoMf2hCllfcxpkYuNGnp4I4REMi+pg3ZyZB0LiEZyPhE+chje1wJ
   g==;
X-CSE-ConnectionGUID: IzUasVH4Q9Kaz0p8ghtRBA==
X-CSE-MsgGUID: j9MjMzYbRUGHjxj+W2ZDQg==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="31565472"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="31565472"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 20:46:03 -0700
X-CSE-ConnectionGUID: siuQYcQ/QDWc4frLCM2/Ng==
X-CSE-MsgGUID: 2cU109VxTN2Nzwn0o5Qopw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="54410231"
Received: from unknown (HELO dmi-pnp-i7.sh.intel.com) ([10.239.159.155])
  by fmviesa001.fm.intel.com with ESMTP; 18 Apr 2024 20:46:00 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests Patch v4 10/17] x86: pmu: Use macro to replace hard-coded instructions event index
Date: Fri, 19 Apr 2024 11:52:26 +0800
Message-Id: <20240419035233.3837621-11-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240419035233.3837621-1-dapeng1.mi@linux.intel.com>
References: <20240419035233.3837621-1-dapeng1.mi@linux.intel.com>
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
index 6ae46398d84b..20bc6de9c936 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -54,6 +54,7 @@ struct pmu_event {
  * intel_gp_events[].
  */
 enum {
+	INTEL_INSTRUCTIONS_IDX  = 1,
 	INTEL_REF_CYCLES_IDX	= 2,
 	INTEL_BRANCHES_IDX	= 5,
 };
@@ -63,6 +64,7 @@ enum {
  * amd_gp_events[].
  */
 enum {
+	AMD_INSTRUCTIONS_IDX    = 1,
 	AMD_BRANCHES_IDX	= 2,
 };
 
@@ -317,11 +319,16 @@ static uint64_t measure_for_overflow(pmu_counter_t *cnt)
 
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
 
@@ -377,13 +384,18 @@ static void check_counter_overflow(void)
 
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
@@ -458,9 +470,14 @@ static void check_running_counter_wrmsr(void)
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
@@ -469,7 +486,7 @@ static void check_running_counter_wrmsr(void)
 	loop();
 	wrmsr(MSR_GP_COUNTERx(0), 0);
 	stop_event(&evt);
-	report(evt.count < gp_events[1].min, "cntr");
+	report(evt.count < gp_events[instruction_idx].min, "cntr");
 
 	/* clear status before overflow test */
 	if (this_cpu_has_perf_global_status())
@@ -500,6 +517,9 @@ static void check_emulated_instr(void)
 	uint64_t gp_counter_width = (1ull << pmu.gp_counter_width) - 1;
 	unsigned int branch_idx = pmu.is_intel ?
 				  INTEL_BRANCHES_IDX : AMD_BRANCHES_IDX;
+	unsigned int instruction_idx = pmu.is_intel ?
+				       INTEL_INSTRUCTIONS_IDX :
+				       AMD_INSTRUCTIONS_IDX;
 	pmu_counter_t brnch_cnt = {
 		.ctr = MSR_GP_COUNTERx(0),
 		/* branch instructions */
@@ -508,7 +528,7 @@ static void check_emulated_instr(void)
 	pmu_counter_t instr_cnt = {
 		.ctr = MSR_GP_COUNTERx(1),
 		/* instructions */
-		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
+		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[instruction_idx].unit_sel,
 	};
 	report_prefix_push("emulated instruction");
 
-- 
2.34.1


