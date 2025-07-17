Return-Path: <kvm+bounces-52723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7005EB088E5
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 11:07:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 547AF4E1A23
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 09:05:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 732D128B4E7;
	Thu, 17 Jul 2025 09:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P2Te30JX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A02B28A725;
	Thu, 17 Jul 2025 09:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752743043; cv=none; b=KfZ7hxz413KGU49kpWqeTVZEo+N0sQDxO3qxcoK+Cq7B/w3ACjKy+H6tal4OhQER4vqOhtzdRe4aRlcCIdK3KsseTSwmGk1D1zMSFr1YPenlcgI1+3k4HR/KMF2tNGU2zqKvEpvvmiBxvP31qI9R3nbqxSoqwrucbtR+1Oow0Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752743043; c=relaxed/simple;
	bh=NyON7OC2PRQh07m09nCQOtZyy93Z5ZfhzcqYNoME75M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sguTmr2exCTrvrXyPSFh9yarahsF5Inlq2dIxIsA8ZqmSSepNGTdoxdF9WUSs10QHqlAzt45f4Ti7Rbho6uKHyMr1VnB6KxtTmWA4rTBWxJMlFXKDbGxzkm7VpGQ2dpNgOjskigf0wYMYKPE33EzpjopFAvrkIvXbdGhkReui4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P2Te30JX; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752743042; x=1784279042;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NyON7OC2PRQh07m09nCQOtZyy93Z5ZfhzcqYNoME75M=;
  b=P2Te30JX/7aRc9bI/lojG9YydIXb9IgAKHZtVwaOmuSKx5oV1974W/CF
   ffrLb++PfqD1I6oWzfiQ6K36TwJf5r9RozROYm+JPdeVSoA70g7f12gun
   vPiN6n3CY3xQQmtZgwMx5hYDh8YUzMj66SK5xz7fEWabkzGbC7vIpe0P0
   LP5bV7xUL6bCt7Us4agFNkxYrtNJTSzIm/4XCY3E8+O+G8PfVszpCMRCj
   U0wF/IvgZGz9i18BcUlgrTPDLYCdEDn2ciXpzTyHIipQcp9bVVIOc8+ba
   b7O9/vvIZpgfX/keZW+2wN/jeyHGIkpHNlGFAok2oBLgzFZYRmMIIjx7P
   A==;
X-CSE-ConnectionGUID: n3V2kCX3R5mw6vFeNUHESg==
X-CSE-MsgGUID: XhEKC4A8QeCLUYhvUJJrrA==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="77546783"
X-IronPort-AV: E=Sophos;i="6.16,318,1744095600"; 
   d="scan'208";a="77546783"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 02:04:02 -0700
X-CSE-ConnectionGUID: R3Bc9ouCTd2R+astFhxulw==
X-CSE-MsgGUID: fN+6liQFT/yUwDL1oIAbBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,318,1744095600"; 
   d="scan'208";a="161774005"
Received: from spr.sh.intel.com ([10.112.229.196])
  by fmviesa003.fm.intel.com with ESMTP; 17 Jul 2025 02:03:57 -0700
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
Subject: [PATCH 3/3] perf/x86/intel: Add ICL_FIXED_0_ADAPTIVE bit into INTEL_FIXED_BITS_MASK
Date: Thu, 17 Jul 2025 17:03:02 +0800
Message-Id: <20250717090302.11316-3-dapeng1.mi@linux.intel.com>
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

ICL_FIXED_0_ADAPTIVE is missed to be added into INTEL_FIXED_BITS_MASK,
add it and opportunistically refine fixed counter enabling code.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
 arch/x86/events/intel/core.c      | 10 +++-------
 arch/x86/include/asm/perf_event.h |  6 +++++-
 arch/x86/kvm/pmu.h                |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 1ee4480089aa..b79efae717f7 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2845,8 +2845,8 @@ static void intel_pmu_enable_fixed(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
-	u64 mask, bits = 0;
 	int idx = hwc->idx;
+	u64 bits = 0;
 
 	if (is_topdown_idx(idx)) {
 		struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
@@ -2885,14 +2885,10 @@ static void intel_pmu_enable_fixed(struct perf_event *event)
 
 	idx -= INTEL_PMC_IDX_FIXED;
 	bits = intel_fixed_bits_by_idx(idx, bits);
-	mask = intel_fixed_bits_by_idx(idx, INTEL_FIXED_BITS_MASK);
-
-	if (x86_pmu.intel_cap.pebs_baseline && event->attr.precise_ip) {
+	if (x86_pmu.intel_cap.pebs_baseline && event->attr.precise_ip)
 		bits |= intel_fixed_bits_by_idx(idx, ICL_FIXED_0_ADAPTIVE);
-		mask |= intel_fixed_bits_by_idx(idx, ICL_FIXED_0_ADAPTIVE);
-	}
 
-	cpuc->fixed_ctrl_val &= ~mask;
+	cpuc->fixed_ctrl_val &= ~intel_fixed_bits_by_idx(idx, INTEL_FIXED_BITS_MASK);
 	cpuc->fixed_ctrl_val |= bits;
 }
 
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index f8247ac276c4..49a4d442f3fc 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -35,7 +35,6 @@
 #define ARCH_PERFMON_EVENTSEL_EQ			(1ULL << 36)
 #define ARCH_PERFMON_EVENTSEL_UMASK2			(0xFFULL << 40)
 
-#define INTEL_FIXED_BITS_MASK				0xFULL
 #define INTEL_FIXED_BITS_STRIDE			4
 #define INTEL_FIXED_0_KERNEL				(1ULL << 0)
 #define INTEL_FIXED_0_USER				(1ULL << 1)
@@ -48,6 +47,11 @@
 #define ICL_EVENTSEL_ADAPTIVE				(1ULL << 34)
 #define ICL_FIXED_0_ADAPTIVE				(1ULL << 32)
 
+#define INTEL_FIXED_BITS_MASK					\
+	(INTEL_FIXED_0_KERNEL | INTEL_FIXED_0_USER |		\
+	 INTEL_FIXED_0_ANYTHREAD | INTEL_FIXED_0_ENABLE_PMI |	\
+	 ICL_FIXED_0_ADAPTIVE)
+
 #define intel_fixed_bits_by_idx(_idx, _bits)			\
 	((_bits) << ((_idx) * INTEL_FIXED_BITS_STRIDE))
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index ad89d0bd6005..103604c4b33b 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -13,7 +13,7 @@
 #define MSR_IA32_MISC_ENABLE_PMU_RO_MASK (MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL |	\
 					  MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)
 
-/* retrieve the 4 bits for EN and PMI out of IA32_FIXED_CTR_CTRL */
+/* retrieve a fixed counter bits out of IA32_FIXED_CTR_CTRL */
 #define fixed_ctrl_field(ctrl_reg, idx) \
 	(((ctrl_reg) >> ((idx) * INTEL_FIXED_BITS_STRIDE)) & INTEL_FIXED_BITS_MASK)
 
-- 
2.34.1


