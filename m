Return-Path: <kvm+bounces-5498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 37163822774
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 04:12:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6C261F23900
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 03:12:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C14619440;
	Wed,  3 Jan 2024 03:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="isNWIjuL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C5818EB1;
	Wed,  3 Jan 2024 03:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704251400; x=1735787400;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Eeaf7B8dirhUHv9DIHZWEq1uq11aLwrgRQAZz8Kd1ZM=;
  b=isNWIjuLYa45CXCh8QfQKbNUDDMZPGOU3xV2f7/47nAsgiAyezx9CVHe
   M24cg8yQRU8T1EXoclil3Hztukzti0tqAVB+li6yl8at11i3gR9rpLIVp
   7wySSup3uhQBbakcLcp+YF+8XWeCdWu6b98mDHk+rmz2T5VpXFh7etjvs
   4xcHOpcYDux0OJj+hQHHn80rTrcRJ05u8dzc9RPT/VLmvWvv0mt5KPq5g
   kB9NyuWoNhM4HoVaoiyQxg2aL+Zrm9IAPnZx64MnkwoJ3+f0DqngmsTNU
   R0io7lbb8ocowenlOUw1TLgWnRa8MR8rsBTmwaZhAXPVitNjFMviYaU/5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="10343166"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="10343166"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2024 19:10:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="729665980"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="729665980"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by orsmga003.jf.intel.com with ESMTP; 02 Jan 2024 19:09:55 -0800
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
Subject: [kvm-unit-tests Patch v3 08/11] x86: pmu: Improve instruction and branches events verification
Date: Wed,  3 Jan 2024 11:14:06 +0800
Message-Id: <20240103031409.2504051-9-dapeng1.mi@linux.intel.com>
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

If HW supports GLOBAL_CTRL MSR, enabling and disabling PMCs are moved in
__precise_count_loop(). Thus, instructions and branches events can be
verified against a precise count instead of a rough range.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index 88b89ad889b9..b764827c1c3d 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -25,6 +25,10 @@
 	"nop; nop; nop; nop; nop; nop; nop;\n\t"	\
 	"loop 1b;\n\t"
 
+/*Enable GLOBAL_CTRL + disable GLOBAL_CTRL instructions */
+#define PRECISE_EXTRA_INSTRNS  (2 + 4)
+#define PRECISE_LOOP_INSTRNS   (N * LOOP_INSTRNS + PRECISE_EXTRA_INSTRNS)
+#define PRECISE_LOOP_BRANCHES  (N)
 #define PRECISE_LOOP_ASM						\
 	"wrmsr;\n\t"							\
 	"mov %%ecx, %%edi; mov %%ebx, %%ecx;\n\t"			\
@@ -107,6 +111,24 @@ static inline void loop(u64 cntrs)
 		__precise_count_loop(cntrs);
 }
 
+static void adjust_events_range(struct pmu_event *gp_events, int branch_idx)
+{
+	/*
+	 * If HW supports GLOBAL_CTRL MSR, enabling and disabling PMCs are
+	 * moved in __precise_count_loop(). Thus, instructions and branches
+	 * events can be verified against a precise count instead of a rough
+	 * range.
+	 */
+	if (this_cpu_has_perf_global_ctrl()) {
+		/* instructions event */
+		gp_events[0].min = PRECISE_LOOP_INSTRNS;
+		gp_events[0].max = PRECISE_LOOP_INSTRNS;
+		/* branches event */
+		gp_events[branch_idx].min = PRECISE_LOOP_BRANCHES;
+		gp_events[branch_idx].max = PRECISE_LOOP_BRANCHES;
+	}
+}
+
 volatile uint64_t irq_received;
 
 static void cnt_overflow(isr_regs_t *regs)
@@ -771,6 +793,7 @@ static void check_invalid_rdpmc_gp(void)
 
 int main(int ac, char **av)
 {
+	int branch_idx;
 	setup_vm();
 	handle_irq(PMI_VECTOR, cnt_overflow);
 	buf = malloc(N*64);
@@ -784,13 +807,16 @@ int main(int ac, char **av)
 		}
 		gp_events = (struct pmu_event *)intel_gp_events;
 		gp_events_size = sizeof(intel_gp_events)/sizeof(intel_gp_events[0]);
+		branch_idx = 5;
 		report_prefix_push("Intel");
 		set_ref_cycle_expectations();
 	} else {
 		gp_events_size = sizeof(amd_gp_events)/sizeof(amd_gp_events[0]);
 		gp_events = (struct pmu_event *)amd_gp_events;
+		branch_idx = 2;
 		report_prefix_push("AMD");
 	}
+	adjust_events_range(gp_events, branch_idx);
 
 	printf("PMU version:         %d\n", pmu.version);
 	printf("GP counters:         %d\n", pmu.nr_gp_counters);
-- 
2.34.1


