Return-Path: <kvm+bounces-52827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 33874B09955
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 03:41:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 62FE55A2BF0
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 01:41:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DE501F17E8;
	Fri, 18 Jul 2025 01:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HPA4GaZ9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DE61EDA03;
	Fri, 18 Jul 2025 01:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752802820; cv=none; b=UugzM6zK4NVpOHXzXDvA04UXcraV3/Mt8K5KNSZWaxNGoCfyVYxRATi7aQqhoVtx8WnxFIy+/VSnAZ1MxcOMPTmpI0n17WnMtIma+oHrrnEeXu22kYSTrqagJom6OjPuF96zQcroJZii6+N2ENzCM4/eNhZHMET0R5y5wQbpYiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752802820; c=relaxed/simple;
	bh=0hNsv9KESme0CC07v7qNNGShOQXUwWV1Ff+LbnZiLcI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ku+YRdyd6/VRwfbQBZTzlrYalP6uuYYA9BJHyZo5cjH14582sAATQhYVbftsttcKsVOLm/sEOwmFz8Cb02WXdHrlWFmwqL90YNYNyHSJxUa0iUgheu3lOG1K1v5wEhzZcXnfcOr1s+5ONDN++5pyxrVGLcGXtzMG0zuRKFQ8Jgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HPA4GaZ9; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752802820; x=1784338820;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0hNsv9KESme0CC07v7qNNGShOQXUwWV1Ff+LbnZiLcI=;
  b=HPA4GaZ9bcleXb/R66S5GTCzhyMb9E5d7FhU8XJLd0dcxmmzHmHfzGbp
   vLk3R0YMhMaTnkUQY2NZ7mLWuuG8m9kLQEsWhz2/DLdu5Ff3ORGlYdF5/
   UXE22qwpP7MAdCBXzgGC2vGoWNQB4TVXJ048Px9zkuwyPGH+CSd5w4laL
   9MUFC+ewIdhbEtMXcd9M//x4XP9fJEh6lGkuq54thQr27vnQutJcnI/W2
   XvvUT3lljFepVFe1yzTr5JJYwpOp42Ol8GuVFHgavqQtX+E7+/Uu18H8W
   K/4GCsK7ug7O+aLIyPZSnQGDOlBOJXyD+O8Q/Cc8mHUKTGNIZSxb7M+5o
   A==;
X-CSE-ConnectionGUID: FUGX8D11SY2EXSzZUcbJDA==
X-CSE-MsgGUID: lezntrBPQE+ZYAVEqxaeew==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="54951531"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="54951531"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 18:40:19 -0700
X-CSE-ConnectionGUID: GuyVw/LERkaYaxvH1lFrmQ==
X-CSE-MsgGUID: c4oOsBp/Tm6eklQ9uvmY+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="188918429"
Received: from spr.sh.intel.com ([10.112.229.196])
  by fmviesa001.fm.intel.com with ESMTP; 17 Jul 2025 18:40:15 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Zide Chen <zide.chen@intel.com>,
	Das Sandipan <Sandipan.Das@amd.com>,
	Shukla Manali <Manali.Shukla@amd.com>,
	Yi Lai <yi1.lai@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Kan Liang <kan.liang@linux.intel.com>
Subject: [kvm-unit-tests patch v2 7/7] x86: pmu_pebs: Support to validate timed PEBS record on GNR/SRF
Date: Fri, 18 Jul 2025 09:39:15 +0800
Message-Id: <20250718013915.227452-8-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250718013915.227452-1-dapeng1.mi@linux.intel.com>
References: <20250718013915.227452-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Intel GNR/SRF platform, timed PEBS is introduced. Timed PEBS adds
a new "retired latency" field in basic info group to show the timing
info. IA32_PERF_CAPABILITIES.PEBS_TIMING_INFO[bit 17] is introduced to
indicate whether timed PEBS is supported.

After introducing timed PEBS, the PEBS record format field shrinks to
bits[31:0] and  the bits[47:32] is used to record retired latency.

Thus shrink the record format to bits[31:0] accordingly and avoid the
retired latency field is recognized a part of record format to compare
and cause failure on GNR/SRF.

Please find detailed information about timed PEBS in section 8.4.1
"Timed Processor Event Based Sampling" of "Intel Architecture
Instruction Set Extensions and Future Features".

Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
 lib/x86/pmu.h  | 6 ++++++
 x86/pmu_pebs.c | 8 +++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index c7dc68c1..86a7a05f 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -20,6 +20,7 @@
 #define PMU_CAP_LBR_FMT	  0x3f
 #define PMU_CAP_FW_WRITES	(1ULL << 13)
 #define PMU_CAP_PEBS_BASELINE	(1ULL << 14)
+#define PMU_CAP_PEBS_TIMING_INFO	(1ULL << 17)
 #define PERF_CAP_PEBS_FORMAT           0xf00
 
 #define EVNSEL_EVENT_SHIFT	0
@@ -188,4 +189,9 @@ static inline bool pmu_has_pebs_baseline(void)
 	return pmu.perf_cap & PMU_CAP_PEBS_BASELINE;
 }
 
+static inline bool pmu_has_pebs_timing_info(void)
+{
+	return pmu.perf_cap & PMU_CAP_PEBS_TIMING_INFO;
+}
+
 #endif /* _X86_PMU_H_ */
diff --git a/x86/pmu_pebs.c b/x86/pmu_pebs.c
index 2848cc1e..bc37e8e3 100644
--- a/x86/pmu_pebs.c
+++ b/x86/pmu_pebs.c
@@ -277,6 +277,7 @@ static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg, bool use_adaptive
 	unsigned int count = 0;
 	bool expected, pebs_idx_match, pebs_size_match, data_cfg_match;
 	void *cur_record;
+	u64 format_mask;
 
 	expected = (ds->pebs_index == ds->pebs_buffer_base) && !pebs_rec->format_size;
 	if (!(rdmsr(MSR_CORE_PERF_GLOBAL_STATUS) & GLOBAL_STATUS_BUFFER_OVF)) {
@@ -289,6 +290,8 @@ static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg, bool use_adaptive
 		return;
 	}
 
+	/* Record format shrinks to bits[31:0] after timed PEBS is introduced. */
+	format_mask = pmu_has_pebs_timing_info() ? GENMASK_ULL(31, 0) : GENMASK_ULL(47, 0);
 	expected = ds->pebs_index >= ds->pebs_interrupt_threshold;
 	cur_record = (void *)pebs_buffer;
 	do {
@@ -296,8 +299,7 @@ static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg, bool use_adaptive
 		pebs_record_size = pebs_rec->format_size >> RECORD_SIZE_OFFSET;
 		pebs_idx_match = pebs_rec->applicable_counters & bitmask;
 		pebs_size_match = pebs_record_size == get_pebs_record_size(pebs_data_cfg, use_adaptive);
-		data_cfg_match = (pebs_rec->format_size & GENMASK_ULL(47, 0)) ==
-				 (use_adaptive ? pebs_data_cfg : 0);
+		data_cfg_match = (pebs_rec->format_size & format_mask) == (use_adaptive ? pebs_data_cfg : 0);
 		expected = pebs_idx_match && pebs_size_match && data_cfg_match;
 		report(expected,
 		       "PEBS record (written seq %d) is verified (including size, counters and cfg).", count);
@@ -327,7 +329,7 @@ static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg, bool use_adaptive
 			       pebs_record_size, get_pebs_record_size(pebs_data_cfg, use_adaptive));
 		if (!data_cfg_match)
 			printf("FAIL: The pebs_data_cfg (0x%lx) doesn't match with the effective MSR_PEBS_DATA_CFG (0x%lx).\n",
-			       pebs_rec->format_size & 0xffffffffffff, use_adaptive ? pebs_data_cfg : 0);
+			       pebs_rec->format_size & format_mask, use_adaptive ? pebs_data_cfg : 0);
 	}
 }
 
-- 
2.34.1


