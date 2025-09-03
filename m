Return-Path: <kvm+bounces-56670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A6D38B4157D
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 08:49:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 287281B61EA3
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 06:50:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B199B2DF705;
	Wed,  3 Sep 2025 06:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MwHI6Ri7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F8D2DF149;
	Wed,  3 Sep 2025 06:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756882070; cv=none; b=HFwaS5otX3F2kNju1hdOfN2T5uJrCi8a7pNBWOBxK4df3B3101WzeKkmFbwrIf+Ev23wMGuaZmbk4nx1QeOe8+Z8/JjyUgCOW5ZjiAp2N0MJq8UquP98eKeFcCHiz63ytdArdpOpdEoU2B4dH2EJijU8HsaG8K4g19U/zYv+InA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756882070; c=relaxed/simple;
	bh=0hNsv9KESme0CC07v7qNNGShOQXUwWV1Ff+LbnZiLcI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PPe0LcwPRW6x9wb2GNJ3ghgJfioHlsTrp9YkI0YP0jKWqs8cItwRLChzqhErKkFpPuaPCh9ANdhfoyhDRPXnC4FT1IiJtYxIdV+3nzCOiozVZzo9Av5/nCVXZ/Z72ETp49Wu2pUsmqQQfEfoljHTnWHkY4E0WtO53uJaL9AxsLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MwHI6Ri7; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756882069; x=1788418069;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0hNsv9KESme0CC07v7qNNGShOQXUwWV1Ff+LbnZiLcI=;
  b=MwHI6Ri7Z/T2mmv1XU4a0tB7KL3DfOJkFDP6Maxv5k6PEE4sqdBjYh99
   U2kvCCTmnk4zT0TpIVdGVcri7hxuUQBwT4Lw6Tvghxtqb8mTwJJ83FIRZ
   9MKDCbgN8tcpvAjmj+4Lhwe9tRwgt+5fBJ7oVInoJpKabo4mf6EWAtIMN
   jC60VHV/9H7+rWQiY9gNHXQLtDLFmsShgdyFSrqiEF4B8n3/CBGMUt4E1
   ntc0W6kn8GfOgs+DNv+Jaz6RRVeq0GLp8wXza/jo7SHaHyjG6Ftpvvdiw
   8aHqlMjqAoqbe7NbLv5/uEa82fVHE6Bl8XEKRR3EwADnp8GOSWHJ6rzGM
   w==;
X-CSE-ConnectionGUID: N5/kN1YyQfW3HpNQO+v5mQ==
X-CSE-MsgGUID: 8eCz7QzJRIazeB7p+Sg6GA==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="63003829"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="63003829"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 23:47:49 -0700
X-CSE-ConnectionGUID: tM+BjTxgRDaGjDVLC5HbSA==
X-CSE-MsgGUID: 46LiZpr/RYmUuHE5RbFCsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="171656647"
Received: from spr.sh.intel.com ([10.112.230.239])
  by orviesa008.jf.intel.com with ESMTP; 02 Sep 2025 23:47:45 -0700
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
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Yi Lai <yi1.lai@intel.com>
Subject: [kvm-unit-tests patch v3 8/8] x86: pmu_pebs: Support to validate timed PEBS record on GNR/SRF
Date: Wed,  3 Sep 2025 14:46:01 +0800
Message-Id: <20250903064601.32131-9-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250903064601.32131-1-dapeng1.mi@linux.intel.com>
References: <20250903064601.32131-1-dapeng1.mi@linux.intel.com>
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


