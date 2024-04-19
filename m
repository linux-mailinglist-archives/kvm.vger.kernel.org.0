Return-Path: <kvm+bounces-15197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E6AF8AA771
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 05:49:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED8D3285F30
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 03:49:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8B757C08E;
	Fri, 19 Apr 2024 03:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hr59Z/tX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706A85FEE4;
	Fri, 19 Apr 2024 03:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713498370; cv=none; b=riBMXo5TmMYS/eBN7h5dtKutRUrbV4mzeeFyjI/FU6BDudzJXIFjXFoq77Akn4ZzSG2f+85DUqXEl5TkDMMNmEUI5rD2bZYCUfBJn1BeGXGvqYoGB4fttup+Rib7b2lxoP/coJv5PzpY6f2gdnb7rueSALZSktUW/pTHiG0vB3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713498370; c=relaxed/simple;
	bh=lwt15SLJk+6I+/6HTQgdnMGKM74ORGjHD0Jay1bNsxQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Lz5eXU6evINLw6rCKJ5OvYpFYGLxJSm53oLaTjgXC9ftjUTxpXlrURJDNIkPkBHH0Mxnz5I63F6JUzi9wiV98wcgraKdz0v1R0RrwDpNCRaq+HO30YF+0cZhXSWqMXDI9I1z8wN7iR2iyqGJS8J+vxGXfsuy99609OMva9EzjKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hr59Z/tX; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713498369; x=1745034369;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lwt15SLJk+6I+/6HTQgdnMGKM74ORGjHD0Jay1bNsxQ=;
  b=hr59Z/tXJsiezzpFh3GOMJZWH+4V10m80xlnb7ARyHSmvNEZWfFyc15v
   ctqpGDnfS6JO9znM8AxNh2pA3MzXW7R+gITFXuWSaCM8LkOoLizko35ZD
   iClIe9Vr6H6x7DWIOLfEcTc8lxaJsRuuGYuSX+0pb4JiiYKy1d8cw0195
   hqWsrfF1kwAzF7TVUoPbyHFB3KpTE00AbwxcZh+KwCzFsADGHAMTWuLKq
   /a3RlG+B6MB6lus1wDKGoFXIuqyIA501NYZMHDNFn3bu+kqSRK9JsiYLN
   9szqUSdD0l1FUTt06B0mb6B02wnwltXw81n8UT7iUqhSFpGutJUM1BmYR
   Q==;
X-CSE-ConnectionGUID: Lsvedh9nSq6Qa/x9yMQaWg==
X-CSE-MsgGUID: vDGMFyedS16MZY+FSk2fAA==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="31565487"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="31565487"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 20:46:09 -0700
X-CSE-ConnectionGUID: 7vf4fdEgTYeiF5B0rGy5BQ==
X-CSE-MsgGUID: NXLQgSTKTquuoWE5QROKug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="54410280"
Received: from unknown (HELO dmi-pnp-i7.sh.intel.com) ([10.239.159.155])
  by fmviesa001.fm.intel.com with ESMTP; 18 Apr 2024 20:46:06 -0700
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
Subject: [kvm-unit-tests Patch v4 12/17] x86: pmu: Improve instruction and branches events verification
Date: Fri, 19 Apr 2024 11:52:28 +0800
Message-Id: <20240419035233.3837621-13-dapeng1.mi@linux.intel.com>
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

If HW supports GLOBAL_CTRL MSR, enabling and disabling PMCs are moved in
__precise_count_loop(). Thus, instructions and branches events can be
verified against a precise count instead of a rough range.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index d97309d7b8a3..1f81d96030e4 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -18,6 +18,11 @@
 #define EXPECTED_INSTR 17
 #define EXPECTED_BRNCH 5
 
+
+/* Enable GLOBAL_CTRL + disable GLOBAL_CTRL instructions */
+#define EXTRA_INSTRNS  (3 + 3)
+#define LOOP_INSTRNS   (N * 10 + EXTRA_INSTRNS)
+#define LOOP_BRANCHES  (N)
 #define LOOP_ASM(_wrmsr)						\
 	_wrmsr "\n\t"							\
 	"mov %%ecx, %%edi; mov %%ebx, %%ecx;\n\t"			\
@@ -121,6 +126,24 @@ static inline void loop(u64 cntrs)
 		__precise_loop(cntrs);
 }
 
+static void adjust_events_range(struct pmu_event *gp_events,
+				int instruction_idx, int branch_idx)
+{
+	/*
+	 * If HW supports GLOBAL_CTRL MSR, enabling and disabling PMCs are
+	 * moved in __precise_loop(). Thus, instructions and branches events
+	 * can be verified against a precise count instead of a rough range.
+	 */
+	if (this_cpu_has_perf_global_ctrl()) {
+		/* instructions event */
+		gp_events[instruction_idx].min = LOOP_INSTRNS;
+		gp_events[instruction_idx].max = LOOP_INSTRNS;
+		/* branches event */
+		gp_events[branch_idx].min = LOOP_BRANCHES;
+		gp_events[branch_idx].max = LOOP_BRANCHES;
+	}
+}
+
 volatile uint64_t irq_received;
 
 static void cnt_overflow(isr_regs_t *regs)
@@ -821,6 +844,9 @@ static void check_invalid_rdpmc_gp(void)
 
 int main(int ac, char **av)
 {
+	int instruction_idx;
+	int branch_idx;
+
 	setup_vm();
 	handle_irq(PMI_VECTOR, cnt_overflow);
 	buf = malloc(N*64);
@@ -834,13 +860,18 @@ int main(int ac, char **av)
 		}
 		gp_events = (struct pmu_event *)intel_gp_events;
 		gp_events_size = sizeof(intel_gp_events)/sizeof(intel_gp_events[0]);
+		instruction_idx = INTEL_INSTRUCTIONS_IDX;
+		branch_idx = INTEL_BRANCHES_IDX;
 		report_prefix_push("Intel");
 		set_ref_cycle_expectations();
 	} else {
 		gp_events_size = sizeof(amd_gp_events)/sizeof(amd_gp_events[0]);
 		gp_events = (struct pmu_event *)amd_gp_events;
+		instruction_idx = AMD_INSTRUCTIONS_IDX;
+		branch_idx = AMD_BRANCHES_IDX;
 		report_prefix_push("AMD");
 	}
+	adjust_events_range(gp_events, instruction_idx, branch_idx);
 
 	printf("PMU version:         %d\n", pmu.version);
 	printf("GP counters:         %d\n", pmu.nr_gp_counters);
-- 
2.34.1


