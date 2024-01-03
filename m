Return-Path: <kvm+bounces-5494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C323F82276C
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 04:11:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0DB861F237D5
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 03:11:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2854F18AFA;
	Wed,  3 Jan 2024 03:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CF/B0rch"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECD318657;
	Wed,  3 Jan 2024 03:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704251385; x=1735787385;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IFRmYSrTmp2pxalXjLvBMU2+p6f3KOk5hMuD5pr8++o=;
  b=CF/B0rchhttdHjZIi6qOw6XwO2OQnj34waFacoSZHU83mJQ/gg/Qo2hL
   dTFIs56Y2FK7+unpkQek2PAX+mrhnCada5UBYZ9VcXw+NPD2bfmTeki25
   zrkpp7TvR70zI4K9fMoSDgOu1Sdt9BWUoYFSacKtXr0gi/gB48nxU3s6V
   dC/S5lS7JHUJwBgKZm5+GZpR0UVnvvztEf7WKxhyX5TKrDb5p1ngCJXxr
   fnO5AiOSQQJUYvqbRcdjz3SduqQtkak5BUsQGTVuZgvJxyWJ30NDzV2wS
   /661zVJaewB37m3VhBBNKc3N5VuVIWO8cKS6kUYDXWNihB4bIi7kDcV06
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="10343137"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="10343137"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2024 19:09:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="729665937"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="729665937"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by orsmga003.jf.intel.com with ESMTP; 02 Jan 2024 19:09:40 -0800
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhang Xiong <xiong.y.zhang@intel.com>,
	Mingwei Zhang <mizhang@google.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests Patch v3 04/11] x86: pmu: Switch instructions and core cycles events sequence
Date: Wed,  3 Jan 2024 11:14:02 +0800
Message-Id: <20240103031409.2504051-5-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When running pmu test on SPR, sometimes the following failure is
reported.

PMU version:         2
GP counters:         8
GP counter width:    48
Mask length:         8
Fixed counters:      3
Fixed counter width: 48
1000000 <= 55109398 <= 50000000
FAIL: Intel: core cycles-0
1000000 <= 18279571 <= 50000000
PASS: Intel: core cycles-1
1000000 <= 12238092 <= 50000000
PASS: Intel: core cycles-2
1000000 <= 7981727 <= 50000000
PASS: Intel: core cycles-3
1000000 <= 6984711 <= 50000000
PASS: Intel: core cycles-4
1000000 <= 6773673 <= 50000000
PASS: Intel: core cycles-5
1000000 <= 6697842 <= 50000000
PASS: Intel: core cycles-6
1000000 <= 6747947 <= 50000000
PASS: Intel: core cycles-7

The count of the "core cycles" on first counter would exceed the upper
boundary and leads to a failure, and then the "core cycles" count would
drop gradually and reach a stable state.

That looks reasonable. The "core cycles" event is defined as the 1st
event in xxx_gp_events[] array and it is always verified at first.
when the program loop() is executed at the first time it needs to warm
up the pipeline and cache, such as it has to wait for cache is filled.
All these warm-up work leads to a quite large core cycles count which
may exceeds the verification range.

The event "instructions" instead of "core cycles" is a good choice as
the warm-up event since it would always return a fixed count. Thus
switch instructions and core cycles events sequence in the
xxx_gp_events[] array.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index a42fff8d8b36..67ebfbe55b49 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -31,16 +31,16 @@ struct pmu_event {
 	int min;
 	int max;
 } intel_gp_events[] = {
-	{"core cycles", 0x003c, 1*N, 50*N},
 	{"instructions", 0x00c0, 10*N, 10.2*N},
+	{"core cycles", 0x003c, 1*N, 50*N},
 	{"ref cycles", 0x013c, 1*N, 30*N},
 	{"llc references", 0x4f2e, 1, 2*N},
 	{"llc misses", 0x412e, 1, 1*N},
 	{"branches", 0x00c4, 1*N, 1.1*N},
 	{"branch misses", 0x00c5, 0, 0.1*N},
 }, amd_gp_events[] = {
-	{"core cycles", 0x0076, 1*N, 50*N},
 	{"instructions", 0x00c0, 10*N, 10.2*N},
+	{"core cycles", 0x0076, 1*N, 50*N},
 	{"branches", 0x00c2, 1*N, 1.1*N},
 	{"branch misses", 0x00c3, 0, 0.1*N},
 }, fixed_events[] = {
@@ -307,7 +307,7 @@ static void check_counter_overflow(void)
 	int i;
 	pmu_counter_t cnt = {
 		.ctr = MSR_GP_COUNTERx(0),
-		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
+		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[0].unit_sel /* instructions */,
 	};
 	overflow_preset = measure_for_overflow(&cnt);
 
@@ -365,11 +365,11 @@ static void check_gp_counter_cmask(void)
 {
 	pmu_counter_t cnt = {
 		.ctr = MSR_GP_COUNTERx(0),
-		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
+		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[0].unit_sel /* instructions */,
 	};
 	cnt.config |= (0x2 << EVNTSEL_CMASK_SHIFT);
 	measure_one(&cnt);
-	report(cnt.count < gp_events[1].min, "cmask");
+	report(cnt.count < gp_events[0].min, "cmask");
 }
 
 static void do_rdpmc_fast(void *ptr)
@@ -446,7 +446,7 @@ static void check_running_counter_wrmsr(void)
 	uint64_t count;
 	pmu_counter_t evt = {
 		.ctr = MSR_GP_COUNTERx(0),
-		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
+		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[0].unit_sel,
 	};
 
 	report_prefix_push("running counter wrmsr");
@@ -455,7 +455,7 @@ static void check_running_counter_wrmsr(void)
 	loop();
 	wrmsr(MSR_GP_COUNTERx(0), 0);
 	stop_event(&evt);
-	report(evt.count < gp_events[1].min, "cntr");
+	report(evt.count < gp_events[0].min, "cntr");
 
 	/* clear status before overflow test */
 	if (this_cpu_has_perf_global_status())
@@ -493,7 +493,7 @@ static void check_emulated_instr(void)
 	pmu_counter_t instr_cnt = {
 		.ctr = MSR_GP_COUNTERx(1),
 		/* instructions */
-		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
+		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[0].unit_sel,
 	};
 	report_prefix_push("emulated instruction");
 
-- 
2.34.1


