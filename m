Return-Path: <kvm+bounces-20874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E1B57924DA7
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 04:16:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 841201F25B2D
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 02:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1B18D502;
	Wed,  3 Jul 2024 02:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="El7wYhD6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB6A481B3;
	Wed,  3 Jul 2024 02:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972786; cv=none; b=ql65lQVS1yt1WQ6l/lW338vAGUcyb2cjXo1JpGY+G+c2oO/CLOEspHCB9PmALBzz7TYCa+thYFExXmeTJu2mQ262L/P/OnFAQoErCAzcvG3DoiVrUelUt2Wthq44/WyOh6OxKogH9HJRP45qDE1gUOmDuyv+zFKUOnSqlY37fXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972786; c=relaxed/simple;
	bh=FCse/DvXG4dC22OIH9BaCqPSPPWfgSwn2bsmt/aN2Ps=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sYOuKZKkAQsOoq8+hccVV87xoNqEDfrWEvhK+sNCv7qoQ7uRpZLHx32E8itBHeCVhE5SGGxZATIvpLM5GfCE8ct0S5v4cGriVk3i8flK3f2qUCQm8Q4xdXZMVxnkNdQS4ZjW03jIcQPfSG+44/TdHBhOgVTGz0SrqTbIGnY7Z/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=El7wYhD6; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719972784; x=1751508784;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FCse/DvXG4dC22OIH9BaCqPSPPWfgSwn2bsmt/aN2Ps=;
  b=El7wYhD6TPdvuV3h5ggnV48rHDs6vrSxnJHGRizoYCT8vxCkVrFSRmii
   EOCR+JqnhfnWcK3FCoOa7VpcH3lzo3T4HzzEaOVAYCoGpoX7MXV/HhNMO
   BmN4ij5l8zNv7IE896gs4AxD0WBRTeNqrIk/4NJ+tlCbPUHn2g7WEdqy7
   DgJ/lfhJNdnCdxvGmvoWEFYOhAPsQAfM4yBU01sj91ps4P9aUxi7w8v09
   flGcw8Jao99gmCenVmsqRjqO1e7HvVKhQJj3DmKQpNNidmc4RYbIS9VSx
   JqMY3kXef7hNU5aoD6hfl5uIDr7ZT33yhhXYYkO2htbY1X8/3YxxkqFEV
   Q==;
X-CSE-ConnectionGUID: 3d4Y5ciNQQepTSDP31gzfg==
X-CSE-MsgGUID: Sfl5x1QlRF2jv5jkEBAynQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="17311089"
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="17311089"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:13:04 -0700
X-CSE-ConnectionGUID: QMzN9DxzTGKXENbG6qNapg==
X-CSE-MsgGUID: SS1jDho5Q6qIaiubxy2MBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="46148695"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa010.fm.intel.com with ESMTP; 02 Jul 2024 19:13:01 -0700
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
Subject: [Patch v5 12/18] x86: pmu: Improve instruction and branches events verification
Date: Wed,  3 Jul 2024 09:57:06 +0000
Message-Id: <20240703095712.64202-13-dapeng1.mi@linux.intel.com>
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

If HW supports GLOBAL_CTRL MSR, enabling and disabling PMCs are moved in
__precise_count_loop(). Thus, instructions and branches events can be
verified against a precise count instead of a rough range.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index d005e376..ffb7b4a4 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -19,6 +19,11 @@
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
@@ -122,6 +127,24 @@ static inline void loop(u64 cntrs)
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
@@ -823,6 +846,9 @@ static void check_invalid_rdpmc_gp(void)
 
 int main(int ac, char **av)
 {
+	int instruction_idx;
+	int branch_idx;
+
 	setup_vm();
 	handle_irq(PMI_VECTOR, cnt_overflow);
 	buf = malloc(N*64);
@@ -836,13 +862,18 @@ int main(int ac, char **av)
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
2.40.1


