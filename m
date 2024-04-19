Return-Path: <kvm+bounces-15201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 71E178AA77B
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 05:50:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0001EB249A0
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 03:50:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55E467E794;
	Fri, 19 Apr 2024 03:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MOgLMGag"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3190810A1D;
	Fri, 19 Apr 2024 03:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713498382; cv=none; b=utW51BilPB/6kT1hGkaSiRIopxY4CnZJ5qvmWi/vsNd7AtVo8V2oAuX/06p/X4YWMBg9KNqn1fkpSZri+YXhgktdCloPF2YWBbZv8vD5mEea9g2Q4YAv24d5RPCg8t4LCm6Y4T5ZpVpbZqUt2GxY1SYPIFChd2RhUcu7/kvFMos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713498382; c=relaxed/simple;
	bh=mh1oCzu7/w0SZXmYy/roGGDEmggIS6f3yEtq/Sb39JI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jPn7P74uWfYlmSR3jZxzTKAYG8QkXmJ9+LP5H9EoY9BciMO3kCYF5bc1npfyxS1L0knTmI1a4CUfFK/+6kkbNhrLmo9dfk6VY3AZRrNM51AlfmBCdTGQZ16cIpev46ETRL60W0et/jLPAkYMxBPP7eO5JiI1QJ1UeuGLVDeItW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MOgLMGag; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713498381; x=1745034381;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mh1oCzu7/w0SZXmYy/roGGDEmggIS6f3yEtq/Sb39JI=;
  b=MOgLMGag/8YTxi2Ag1Ax6LL/bAfPmAxPt+ap/YzqEPxC6/Ljou0qJycj
   4WuZKB8sLhgU5SSp150ZAADsvocGpTlV4luLvsmZ20Hk9P3+B8MfOvmBo
   IzekD50TgVVOovKFVVkVUmCmNKlrdzzlRvO5RX9wzQdUV6ed9/yx2+DbZ
   RHbRsomEx3I/8Yd2j+mrdRdXbCTXjAZPdPn3+yd+uZY29f1vnGzRk+UK+
   ArwtDvRoszTZx5Ljfk4QXUNyi//MXLiCwZwtOhDu0nGA1MC3cUKZ2BPc3
   vLKbqm7NnmOTueeZI4vaBFuXJer91UURkc7QZ9ERO5xSvsume61C1onmL
   g==;
X-CSE-ConnectionGUID: CePLvaFITY69WAn2iOBJsw==
X-CSE-MsgGUID: +Y9Pf1thSr6+w2petu086w==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="31565511"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="31565511"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 20:46:21 -0700
X-CSE-ConnectionGUID: iLnSHLUHTkmCCHQVQu//rQ==
X-CSE-MsgGUID: XBQvYtMDTBSmvkEiGqvnZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="54410323"
Received: from unknown (HELO dmi-pnp-i7.sh.intel.com) ([10.239.159.155])
  by fmviesa001.fm.intel.com with ESMTP; 18 Apr 2024 20:46:18 -0700
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
Subject: [kvm-unit-tests Patch v4 16/17] x86: pmu: Adjust lower boundary of branch-misses event
Date: Fri, 19 Apr 2024 11:52:32 +0800
Message-Id: <20240419035233.3837621-17-dapeng1.mi@linux.intel.com>
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

Since the IBPB command is added to force to trigger a branch miss at
least, the lower boundary of branch misses event is increased to 1 by
default. For these CPUs without IBPB support, adjust dynamically the
lower boundary to 0 to avoid false positive.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 0b3dd1ba1766..e0da522c004b 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -73,12 +73,12 @@ struct pmu_event {
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
@@ -94,6 +94,7 @@ enum {
 	INTEL_REF_CYCLES_IDX	= 2,
 	INTEL_LLC_MISSES_IDX	= 4,
 	INTEL_BRANCHES_IDX	= 5,
+	INTEL_BRANCH_MISS_IDX	= 6,
 };
 
 /*
@@ -103,6 +104,7 @@ enum {
 enum {
 	AMD_INSTRUCTIONS_IDX    = 1,
 	AMD_BRANCHES_IDX	= 2,
+	AMD_BRANCH_MISS_IDX	= 3,
 };
 
 char *buf;
@@ -166,7 +168,8 @@ static inline void loop(u64 cntrs)
 }
 
 static void adjust_events_range(struct pmu_event *gp_events,
-				int instruction_idx, int branch_idx)
+				int instruction_idx, int branch_idx,
+				int branch_miss_idx)
 {
 	/*
 	 * If HW supports GLOBAL_CTRL MSR, enabling and disabling PMCs are
@@ -181,6 +184,17 @@ static void adjust_events_range(struct pmu_event *gp_events,
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
@@ -885,6 +899,7 @@ int main(int ac, char **av)
 {
 	int instruction_idx;
 	int branch_idx;
+	int branch_miss_idx;
 
 	setup_vm();
 	handle_irq(PMI_VECTOR, cnt_overflow);
@@ -901,6 +916,7 @@ int main(int ac, char **av)
 		gp_events_size = sizeof(intel_gp_events)/sizeof(intel_gp_events[0]);
 		instruction_idx = INTEL_INSTRUCTIONS_IDX;
 		branch_idx = INTEL_BRANCHES_IDX;
+		branch_miss_idx = INTEL_BRANCH_MISS_IDX;
 
 		/*
 		 * For legacy Intel CPUS without clflush/clflushopt support,
@@ -917,9 +933,10 @@ int main(int ac, char **av)
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
2.34.1


