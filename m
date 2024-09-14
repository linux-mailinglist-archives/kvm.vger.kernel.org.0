Return-Path: <kvm+bounces-26912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9699C978EBA
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 09:06:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 398DA28C5FA
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 07:06:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76CEC1D130B;
	Sat, 14 Sep 2024 07:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mE05eoHG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345301D12EF;
	Sat, 14 Sep 2024 07:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726297320; cv=none; b=e/rC7ebpFWH8JK8cSeRskeMfoL+rKcdTgTJozS3LNwe9SXlj8Pehjwu7sUm7oTUeVDES7HVhArphl/6sVQqEyIUPbQWozwykHXybuoyl5dMHe/akheYSPoXnUxqXvVs6XbloVFbfS78DCQukcbioSnWAgynNjIChii+c9tWS2gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726297320; c=relaxed/simple;
	bh=RPa+ulwIzhMZ5m/sqo9YLmXKAMy+I/zbCrWW8L0dxrQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jkY21ReU8bX/nmx4gUIiX9D3O/HQl/Eu0Gcuic+3++E3KCC69P59RyaszRjGD+E/DBqNHVxU8b/Cb0nGHTiO/KrDb2hAEjDkl6SHj+axyZg9wcbMcS5/+OqDIkJXesX3K9aEX+MpbY3eaZFrlWvBqYclk9zePNNNzcWpabt9DsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mE05eoHG; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726297319; x=1757833319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RPa+ulwIzhMZ5m/sqo9YLmXKAMy+I/zbCrWW8L0dxrQ=;
  b=mE05eoHGS0WGqZHUb21T1Sycd/92C1XKUSEa8C/bAqcemTJdiDrzxi3w
   ke9b7w3YAA78rvfpudTUvot4pLE9hwOQLMkr91sOmCjgk6hRZ0FMeFK1I
   nUJTd2hdiraDiX2YzuzHlDZ7njZ6/h2ac/7t7gXMHYcN6tq6Cqh+k2U0Y
   Y9aU9rzB+eNJATRqHKNQpJ3whBbdMeNApikzs6aup2r6Qgyy97d5zVEiQ
   kEX5ucBfFrWuK/VIsnb/GSSqLK1djVTEzyImnRYMNWWfeYUqErTcxgxar
   nufj0vZB0d4RlKS6o+FnvioDGng0gpqGu5BVh633VQhsjxRda3l1BS1SE
   w==;
X-CSE-ConnectionGUID: zlmavc13Q/6/MKTaELOtfQ==
X-CSE-MsgGUID: +6ioKSAIRseWeS7jSHOxaQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="35778890"
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="35778890"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2024 00:01:59 -0700
X-CSE-ConnectionGUID: xX9dpccoQfuljbLCf59VfA==
X-CSE-MsgGUID: EvYNJMgrQauRR3P1fSDofw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="67951014"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa006.fm.intel.com with ESMTP; 14 Sep 2024 00:01:56 -0700
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
Subject: [kvm-unit-tests patch v6 17/18] x86: pmu: Adjust lower boundary of branch-misses event
Date: Sat, 14 Sep 2024 10:17:27 +0000
Message-Id: <20240914101728.33148-18-dapeng1.mi@linux.intel.com>
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

Since the IBPB command is added to force to trigger a branch miss at
least, the lower boundary of branch misses event is increased to 1 by
default. For these CPUs without IBPB support, adjust dynamically the
lower boundary to 0 to avoid false positive.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 279d418d..c7848fd1 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -90,12 +90,12 @@ struct pmu_event {
 	{"llc references", 0x4f2e, 1, 2*N},
 	{"llc misses", 0x412e, 1, 1*N},
 	{"branches", 0x00c4, 1*N, 1.1*N},
-	{"branch misses", 0x00c5, 0, 0.1*N},
+	{"branch misses", 0x00c5, 1, 0.1*N},
 }, amd_gp_events[] = {
 	{"core cycles", 0x0076, 1*N, 50*N},
 	{"instructions", 0x00c0, 10*N, 10.2*N},
 	{"branches", 0x00c2, 1*N, 1.1*N},
-	{"branch misses", 0x00c3, 0, 0.1*N},
+	{"branch misses", 0x00c3, 1, 0.1*N},
 }, fixed_events[] = {
 	{"fixed 0", MSR_CORE_PERF_FIXED_CTR0, 10*N, 10.2*N},
 	{"fixed 1", MSR_CORE_PERF_FIXED_CTR0 + 1, 1*N, 30*N},
@@ -111,6 +111,7 @@ enum {
 	INTEL_REF_CYCLES_IDX	= 2,
 	INTEL_LLC_MISSES_IDX	= 4,
 	INTEL_BRANCHES_IDX	= 5,
+	INTEL_BRANCH_MISS_IDX	= 6,
 };
 
 /*
@@ -120,6 +121,7 @@ enum {
 enum {
 	AMD_INSTRUCTIONS_IDX    = 1,
 	AMD_BRANCHES_IDX	= 2,
+	AMD_BRANCH_MISS_IDX	= 3,
 };
 
 char *buf;
@@ -184,7 +186,8 @@ static inline void loop(u64 cntrs)
 }
 
 static void adjust_events_range(struct pmu_event *gp_events,
-				int instruction_idx, int branch_idx)
+				int instruction_idx, int branch_idx,
+				int branch_miss_idx)
 {
 	/*
 	 * If HW supports GLOBAL_CTRL MSR, enabling and disabling PMCs are
@@ -205,6 +208,17 @@ static void adjust_events_range(struct pmu_event *gp_events,
 		gp_events[branch_idx].min = LOOP_BRANCHES;
 		gp_events[branch_idx].max = LOOP_BRANCHES;
 	}
+
+	/*
+	 * For CPUs without IBPB support, no way to force to trigger a
+	 * branch miss and the measured branch misses is possible to be
+	 * 0. Thus overwrite the lower boundary of branch misses event
+	 * to 0 to avoid false positive.
+	 */
+	if (!has_ibpb()) {
+		/* branch misses event */
+		gp_events[branch_miss_idx].min = 0;
+	}
 }
 
 volatile uint64_t irq_received;
@@ -918,6 +932,7 @@ int main(int ac, char **av)
 {
 	int instruction_idx;
 	int branch_idx;
+	int branch_miss_idx;
 
 	setup_vm();
 	handle_irq(PMI_VECTOR, cnt_overflow);
@@ -934,6 +949,7 @@ int main(int ac, char **av)
 		gp_events_size = sizeof(intel_gp_events)/sizeof(intel_gp_events[0]);
 		instruction_idx = INTEL_INSTRUCTIONS_IDX;
 		branch_idx = INTEL_BRANCHES_IDX;
+		branch_miss_idx = INTEL_BRANCH_MISS_IDX;
 
 		/*
 		 * For legacy Intel CPUS without clflush/clflushopt support,
@@ -950,9 +966,10 @@ int main(int ac, char **av)
 		gp_events = (struct pmu_event *)amd_gp_events;
 		instruction_idx = AMD_INSTRUCTIONS_IDX;
 		branch_idx = AMD_BRANCHES_IDX;
+		branch_miss_idx = AMD_BRANCH_MISS_IDX;
 		report_prefix_push("AMD");
 	}
-	adjust_events_range(gp_events, instruction_idx, branch_idx);
+	adjust_events_range(gp_events, instruction_idx, branch_idx, branch_miss_idx);
 
 	printf("PMU version:         %d\n", pmu.version);
 	printf("GP counters:         %d\n", pmu.nr_gp_counters);
-- 
2.40.1


