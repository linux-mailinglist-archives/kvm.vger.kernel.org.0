Return-Path: <kvm+bounces-52722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82639B088DA
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 11:05:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8749161277
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 09:05:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C4E828A408;
	Thu, 17 Jul 2025 09:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z26mQW2S"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E744228A1C1;
	Thu, 17 Jul 2025 09:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752743039; cv=none; b=cD2/QAlZ2gdIlQ6/0XnMFSKGcwDoR/0wH6fcPBThFhv35ZKl7IRXUfMglda2FU5L2FHFRExZrVFU+EVKXIP935XRr/L5GjdZn0DN65t4e2BH8ZVOOByeoFyFN2QOYTgOJmAjYHOq1Dnu3xaHgs6+cImrd0KtKE3RpTrJfGnH2xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752743039; c=relaxed/simple;
	bh=3VbdL1DtRyK163VSM5zT9fJNUPREL57ZbKWaW1boGiQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mUUzUZ8z2YJLQ9wUAXgRVnlkBO6dWb8i7y7n1pfbacqNpSrprUFXjTL+N9bEWKT3Oxybu4qZKOH+5rFV4J9sttEWUZHi196c5+lbUCoQS5SAXgkzTv0EyzBJjcgVgZfQ8Langgj+N7WPy1YgCE+XuGh6OOZhc4j0j5sntxRFLr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z26mQW2S; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752743038; x=1784279038;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3VbdL1DtRyK163VSM5zT9fJNUPREL57ZbKWaW1boGiQ=;
  b=Z26mQW2SXCxfW4haT3ovHGFjYQbJsAloVpGnLf+HBXTbh3G45WvnBA8E
   RYAJNYR7W2Y4jxe/ZfZ/wHicJrB6W1CF/poBdkbHLh9JsgbrqmZNKQW7j
   XUu/FWQyjIJM94xhCmXCl4gNDBoJUKHnCHGRjGvz4sRHeZ1VXQzKYToi1
   8Lmy7r2MDnh/9Jw53FNf25mzrl0MEr2C+j6DxidQaq/Pwmd/KJwFXoNBe
   Q1rxTP4AWpBtfJd04qCOKhimGRlIPDDfY12JzKxQ7BYQ16ko/ZwdBFZOL
   mlH/G+KJJq+T0uzlvHtHl6zE0tVFw5dmVlW4C/qKK1NvgXm5U1+5Xt+ld
   w==;
X-CSE-ConnectionGUID: EXmvc/VlS1qSNmEh0oKv1Q==
X-CSE-MsgGUID: K4VcdSf6RviryOI28Ams7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="77546775"
X-IronPort-AV: E=Sophos;i="6.16,318,1744095600"; 
   d="scan'208";a="77546775"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 02:03:57 -0700
X-CSE-ConnectionGUID: TuaGLopIQCqonIQ4vjo5Bw==
X-CSE-MsgGUID: FigQ6XyMSwuAufVr+EuSvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,318,1744095600"; 
   d="scan'208";a="161773983"
Received: from spr.sh.intel.com ([10.112.229.196])
  by fmviesa003.fm.intel.com with ESMTP; 17 Jul 2025 02:03:54 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Eranian Stephane <eranian@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yi Lai <yi1.lai@intel.com>
Subject: [PATCH 2/3] perf/x86/intel: Change macro GLOBAL_CTRL_EN_PERF_METRICS to BIT_ULL(48)
Date: Thu, 17 Jul 2025 17:03:01 +0800
Message-Id: <20250717090302.11316-2-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250717090302.11316-1-dapeng1.mi@linux.intel.com>
References: <20250717090302.11316-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Macro GLOBAL_CTRL_EN_PERF_METRICS is defined to 48 instead of
BIT_ULL(48), it's inconsistent with other similar macros. This leads to
this macro is quite easily used wrongly since users thinks it's a
bit-mask just like other similar macros.

Thus change GLOBAL_CTRL_EN_PERF_METRICS to BIT_ULL(48) and eliminate
this potential misuse.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
 arch/x86/events/intel/core.c      | 8 ++++----
 arch/x86/include/asm/perf_event.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index c2fb729c270e..1ee4480089aa 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -5318,9 +5318,9 @@ static void intel_pmu_check_hybrid_pmus(struct x86_hybrid_pmu *pmu)
 						0, x86_pmu_num_counters(&pmu->pmu), 0, 0);
 
 	if (pmu->intel_cap.perf_metrics)
-		pmu->intel_ctrl |= 1ULL << GLOBAL_CTRL_EN_PERF_METRICS;
+		pmu->intel_ctrl |= GLOBAL_CTRL_EN_PERF_METRICS;
 	else
-		pmu->intel_ctrl &= ~(1ULL << GLOBAL_CTRL_EN_PERF_METRICS);
+		pmu->intel_ctrl &= ~GLOBAL_CTRL_EN_PERF_METRICS;
 
 	intel_pmu_check_event_constraints(pmu->event_constraints,
 					  pmu->cntr_mask64,
@@ -5455,7 +5455,7 @@ static void intel_pmu_cpu_starting(int cpu)
 		rdmsrq(MSR_IA32_PERF_CAPABILITIES, perf_cap.capabilities);
 		if (!perf_cap.perf_metrics) {
 			x86_pmu.intel_cap.perf_metrics = 0;
-			x86_pmu.intel_ctrl &= ~(1ULL << GLOBAL_CTRL_EN_PERF_METRICS);
+			x86_pmu.intel_ctrl &= ~GLOBAL_CTRL_EN_PERF_METRICS;
 		}
 	}
 
@@ -7789,7 +7789,7 @@ __init int intel_pmu_init(void)
 	}
 
 	if (!is_hybrid() && x86_pmu.intel_cap.perf_metrics)
-		x86_pmu.intel_ctrl |= 1ULL << GLOBAL_CTRL_EN_PERF_METRICS;
+		x86_pmu.intel_ctrl |= GLOBAL_CTRL_EN_PERF_METRICS;
 
 	if (x86_pmu.intel_cap.pebs_timing_info)
 		x86_pmu.flags |= PMU_FL_RETIRE_LATENCY;
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 70d1d94aca7e..f8247ac276c4 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -430,7 +430,7 @@ static inline bool is_topdown_idx(int idx)
 #define GLOBAL_STATUS_TRACE_TOPAPMI		BIT_ULL(GLOBAL_STATUS_TRACE_TOPAPMI_BIT)
 #define GLOBAL_STATUS_PERF_METRICS_OVF_BIT	48
 
-#define GLOBAL_CTRL_EN_PERF_METRICS		48
+#define GLOBAL_CTRL_EN_PERF_METRICS		BIT_ULL(48)
 /*
  * We model guest LBR event tracing as another fixed-mode PMC like BTS.
  *
-- 
2.34.1


