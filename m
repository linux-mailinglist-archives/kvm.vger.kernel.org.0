Return-Path: <kvm+bounces-20878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20955924DB0
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 04:17:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 549EB1C24B3E
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 02:17:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E04361FFB;
	Wed,  3 Jul 2024 02:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FRjS16e2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C8F7F7FB;
	Wed,  3 Jul 2024 02:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972798; cv=none; b=kG4YvUoDxNRu85ge3Uz91Rm3rJsww5v8EHGfJG9k7H7dUF/PrIg2W9q5REdFoZmavsbsMlwdr0X9vLfiU2wO098SHVgqakzWBOXpqtIirX7MU1X75taKKeaD+yfzkAEPtrlKcOdxbBzmSjWyCBicuG2vUqHM5mXELv3zme0ZdF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972798; c=relaxed/simple;
	bh=EsSYbw1fuhkoGtZEXGpFBIGsk6gKUJSdriMbXjiW8/Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hyPlSEJCxnJJaW7nG3Fyfl72wFiMFao4ruq1+8JT2FPoflm4yBznJI5yFzKaHchyNzYzrVh3o15/frf1Hznh/ctU0Xke+XRCgnEvD5r+wiD6SUrp6jFvHwoJ/8MbIhXZygNC7L2x6oUIIht12nqwuXCTfP9e14E0+s36OTeWyRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FRjS16e2; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719972797; x=1751508797;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EsSYbw1fuhkoGtZEXGpFBIGsk6gKUJSdriMbXjiW8/Y=;
  b=FRjS16e24ny+CYyR5vidMIs1/UOsjcjDo1EzryRe3lhMRrjGso5koF9N
   XJn00vYOrF+gmB6z8ifYxzGjHLlzc/MoFo2f1pbAULHZNVql+YrhiRXHw
   ZMvbZewdDyY1TMRzOlLVepRFx+DlTOSsC6YmZdK7/MGH5neL4KDOwh5vC
   /ZGD7oe6smCLWvlIb73pL3eoHRJWbE5l752KyGF01Yak5/eHnDMbF2pUK
   tQrq1ie2taiBPgqJaGuG0d6h8PCAcu7sz52C/0YjVJgGDiI7uwG9tCAeH
   Q8sUvpOyYvePYzMwI8q1luuDyVGd63rUOVSXoj85C3PhC65yUY1+R+DD9
   w==;
X-CSE-ConnectionGUID: zDEI6B2cSoOQxz7SPt+HNg==
X-CSE-MsgGUID: ddMRgbTsTg6cEfJbPCoSIg==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="17311131"
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="17311131"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:13:17 -0700
X-CSE-ConnectionGUID: yzNWfzGyTt2Ie6cgaGg6kg==
X-CSE-MsgGUID: r3uUIS/MSyqiftxw4TSiqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="46148833"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa010.fm.intel.com with ESMTP; 02 Jul 2024 19:13:14 -0700
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
Subject: [Patch v5 16/18] x86: pmu: Adjust lower boundary of branch-misses event
Date: Wed,  3 Jul 2024 09:57:10 +0000
Message-Id: <20240703095712.64202-17-dapeng1.mi@linux.intel.com>
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

Since the IBPB command is added to force to trigger a branch miss at
least, the lower boundary of branch misses event is increased to 1 by
default. For these CPUs without IBPB support, adjust dynamically the
lower boundary to 0 to avoid false positive.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 498b18d0..4026deab 100644
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
@@ -183,7 +185,8 @@ static inline void loop(u64 cntrs)
 }
 
 static void adjust_events_range(struct pmu_event *gp_events,
-				int instruction_idx, int branch_idx)
+				int instruction_idx, int branch_idx,
+				int branch_miss_idx)
 {
 	/*
 	 * If HW supports GLOBAL_CTRL MSR, enabling and disabling PMCs are
@@ -198,6 +201,17 @@ static void adjust_events_range(struct pmu_event *gp_events,
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
@@ -903,6 +917,7 @@ int main(int ac, char **av)
 {
 	int instruction_idx;
 	int branch_idx;
+	int branch_miss_idx;
 
 	setup_vm();
 	handle_irq(PMI_VECTOR, cnt_overflow);
@@ -919,6 +934,7 @@ int main(int ac, char **av)
 		gp_events_size = sizeof(intel_gp_events)/sizeof(intel_gp_events[0]);
 		instruction_idx = INTEL_INSTRUCTIONS_IDX;
 		branch_idx = INTEL_BRANCHES_IDX;
+		branch_miss_idx = INTEL_BRANCH_MISS_IDX;
 
 		/*
 		 * For legacy Intel CPUS without clflush/clflushopt support,
@@ -935,9 +951,10 @@ int main(int ac, char **av)
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


