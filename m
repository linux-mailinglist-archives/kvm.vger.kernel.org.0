Return-Path: <kvm+bounces-26908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42EED978EB1
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 09:05:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED1BD1F266DC
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 07:05:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED3771D04BD;
	Sat, 14 Sep 2024 07:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HaxM0CtN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CE21D049D;
	Sat, 14 Sep 2024 07:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726297308; cv=none; b=gpNLKkVRlB92mO9FRx4lnI3CKnNjL8C0iraU4t+TJl8XmzbsKGPkFP9C+pPnf6g4UBElmxcHW5/kSvbiqe6yyJYm3f2emEZtY6Y+inB2Qj22HZNCgaTHt1j45iq5YBeaitAniyOnkhmn9e99ChlH4ws+iX/cmVbShRWdMZiCa14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726297308; c=relaxed/simple;
	bh=Ih04t7D/0iaLudr3E/C/IlUJ8oePrTKqbytNL2ob+RE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OeSR94SyjS7jqh6tlzu7kBWR/BR3aBFubYOnCF+2RwJT8POJV3eimuFubvz//SswT3106vrotenJhc3/4rHY1in5AORyyS2whAAztxydn4mxSKBFxsnRj+Pxbd2wlaqwifJHKl8WekFEGOmifLBCQUxa/t4+QQZ5GmrChge7wz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HaxM0CtN; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726297307; x=1757833307;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ih04t7D/0iaLudr3E/C/IlUJ8oePrTKqbytNL2ob+RE=;
  b=HaxM0CtNveJljxjyw4+W+QF7fK+uFLPCYXiP8ut73hutqeuK7idtQKWs
   DVJ4DuZ9mWPDHgLajnx0gV1tCoXVJ/ZpPMu34Mut/3ui40JzVlWIkndee
   jBZKvEbErxQzyhGvIU2kKC9Ae+Mv9ArbIdlgkRkd+DdiBXlGSI4lTpyCy
   reF6f27BWR0IqokpKv88BctktvpKvFeDOdc8N6VTyFcu1gT39KWAVJ/SJ
   n6mx3fp+92dfAC02cYoiNnYKFxVOPe1WLOfWRThwdCBKa6SAoQ1PlNekx
   sKHJQ6AUTOrSGmzDI4M0iT2Ym+b0kpJ3X6gAOhHcPRzTj0oeS/IynPk17
   g==;
X-CSE-ConnectionGUID: wEFe2iz2SKe4mHDfdNT2CA==
X-CSE-MsgGUID: tfKzfjC0R3aSx5kxW83TuQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="35778844"
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="35778844"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2024 00:01:46 -0700
X-CSE-ConnectionGUID: DqgFYJEGQj+a1W0wwMSUuQ==
X-CSE-MsgGUID: XZVUL+iFStWvfLybBSp6LQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="67950986"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa006.fm.intel.com with ESMTP; 14 Sep 2024 00:01:43 -0700
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
Subject: [kvm-unit-tests patch v6 13/18] x86: pmu: Improve instruction and branches events verification
Date: Sat, 14 Sep 2024 10:17:23 +0000
Message-Id: <20240914101728.33148-14-dapeng1.mi@linux.intel.com>
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

If HW supports GLOBAL_CTRL MSR, enabling and disabling PMCs are moved in
__precise_count_loop(). Thus, instructions and branches events can be
verified against a precise count instead of a rough range.

BTW, some intermittent failures on AMD processors using PerfMonV2 is
seen due to variance in counts. This probably has to do with the way
instructions leading to a VM-Entry or VM-Exit are accounted when
counting retired instructions and branches.

https://lore.kernel.org/all/6d512a14-ace1-41a3-801e-0beb41425734@amd.com/

So only enable this precise check for Intel processors.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index 270f11b9..13c7c45d 100644
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
@@ -123,6 +128,30 @@ static inline void loop(u64 cntrs)
 		__precise_loop(cntrs);
 }
 
+static void adjust_events_range(struct pmu_event *gp_events,
+				int instruction_idx, int branch_idx)
+{
+	/*
+	 * If HW supports GLOBAL_CTRL MSR, enabling and disabling PMCs are
+	 * moved in __precise_loop(). Thus, instructions and branches events
+	 * can be verified against a precise count instead of a rough range.
+	 *
+	 * We see some intermittent failures on AMD processors using PerfMonV2
+	 * due to variance in counts. This probably has to do with the way
+	 * instructions leading to a VM-Entry or VM-Exit are accounted when
+	 * counting retired instructions and branches. Thus only enable the
+	 * precise validation for Intel processors.
+	 */
+	if (pmu.is_intel && this_cpu_has_perf_global_ctrl()) {
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
@@ -832,6 +861,9 @@ static void check_invalid_rdpmc_gp(void)
 
 int main(int ac, char **av)
 {
+	int instruction_idx;
+	int branch_idx;
+
 	setup_vm();
 	handle_irq(PMI_VECTOR, cnt_overflow);
 	buf = malloc(N*64);
@@ -845,13 +877,18 @@ int main(int ac, char **av)
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


