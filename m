Return-Path: <kvm+bounces-52721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DF47B088D3
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 11:05:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6A9277B6CFE
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 09:03:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3051F289E0F;
	Thu, 17 Jul 2025 09:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OP8S5NDp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861EC287269;
	Thu, 17 Jul 2025 09:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752743036; cv=none; b=UuFYmkeYX08SZHHnGraYQAWUyHDGSw2cDWFNyOyDevoSn3xvvEtahPcbn+zpYy2MYQ2OgA25N6bJVlrzP0xd3trZdIrtd4sBdyswp3+BHS2esb3DEI0/JAG/z0yziQzDcFYjwb2yOAorQ9QXygqzM/2L8Pm4jpJYKiDirSZf+wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752743036; c=relaxed/simple;
	bh=yHsAHKTe/LT2XVTGbt4c9MxoJAn5NuMjTXmAhbh6i1I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tfOlY6BP6risBD8F3k4yWTcXPnHisHutm/5H8InUn+o8dUGXqvZSrEjJwEo3JbuKCOdNIQvxJ13bphVvaknmOlTHe/5vNsqdzxgGuBfaaMFzkKRfIKFUxv+LS+PAAuhDv/FhRADHM50a7fWyTHmPSakhg/+cGqVX0kfszTYMtvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OP8S5NDp; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752743034; x=1784279034;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yHsAHKTe/LT2XVTGbt4c9MxoJAn5NuMjTXmAhbh6i1I=;
  b=OP8S5NDpoP6Rlh/useaBWUyNPsbEj7P1ARlQKipru2KDkBzzc5Y8qa4u
   L3nZ+O0vCucppFYQsT+W/MHiNC97tCJMY32+ZFz/ipk5k7Ma1NNAqe5UZ
   AfktzmCP+RfSSp3p+lNx5oMThuiyhOWrY7LPv7HxrQ9PeJR7o7j1yziWq
   VSaO0hmV+UpkMDgbGk8UC9SGJZmh4XulyxEX8TZI+jhYWuDGIsUxTOMN3
   N/VSfEFijv7i27pZyut2we3dYsnW0j0p7pzRcYXeD5csT8fix0F1AbU72
   jcmSrOI9AC0Twf6vnTo8sqPWY/B3VAQ3mpEm/zu2I0pROhhZ8EN65Hqz3
   g==;
X-CSE-ConnectionGUID: TZpIHp1ZQzeczbcFTzG1JA==
X-CSE-MsgGUID: DwkY0XBUTR6k40y6mbznpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="77546769"
X-IronPort-AV: E=Sophos;i="6.16,318,1744095600"; 
   d="scan'208";a="77546769"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 02:03:54 -0700
X-CSE-ConnectionGUID: p9+G4bpnQTalvtvbS4llTg==
X-CSE-MsgGUID: XwjslSNQR5SvUeY/panbaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,318,1744095600"; 
   d="scan'208";a="161773965"
Received: from spr.sh.intel.com ([10.112.229.196])
  by fmviesa003.fm.intel.com with ESMTP; 17 Jul 2025 02:03:50 -0700
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
Subject: [PATCH 1/3] perf/x86: Add PERF_CAP_PEBS_TIMING_INFO flag
Date: Thu, 17 Jul 2025 17:03:00 +0800
Message-Id: <20250717090302.11316-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IA32_PERF_CAPABILITIES.PEBS_TIMING_INFO[bit 17] is introduced to
indicate whether timed PEBS is supported. Timed PEBS adds a new "retired
latency" field in basic info group to show the timing info. Please find
detailed information about timed PEBS in section 8.4.1 "Timed Processor
Event Based Sampling" of "Intel Architecture Instruction Set Extensions
and Future Features".

This patch adds PERF_CAP_PEBS_TIMING_INFO flag and KVM module leverages
this flag to expose timed PEBS feature to guest.

Moreover, opportunistically refine the indents and make the macros
share consistent indents.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
 arch/x86/include/asm/msr-index.h       | 14 ++++++++------
 tools/arch/x86/include/asm/msr-index.h | 14 ++++++++------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index b7dded3c8113..48b7ed28718c 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -315,12 +315,14 @@
 #define PERF_CAP_PT_IDX			16
 
 #define MSR_PEBS_LD_LAT_THRESHOLD	0x000003f6
-#define PERF_CAP_PEBS_TRAP             BIT_ULL(6)
-#define PERF_CAP_ARCH_REG              BIT_ULL(7)
-#define PERF_CAP_PEBS_FORMAT           0xf00
-#define PERF_CAP_PEBS_BASELINE         BIT_ULL(14)
-#define PERF_CAP_PEBS_MASK	(PERF_CAP_PEBS_TRAP | PERF_CAP_ARCH_REG | \
-				 PERF_CAP_PEBS_FORMAT | PERF_CAP_PEBS_BASELINE)
+#define PERF_CAP_PEBS_TRAP		BIT_ULL(6)
+#define PERF_CAP_ARCH_REG		BIT_ULL(7)
+#define PERF_CAP_PEBS_FORMAT		0xf00
+#define PERF_CAP_PEBS_BASELINE		BIT_ULL(14)
+#define PERF_CAP_PEBS_TIMING_INFO	BIT_ULL(17)
+#define PERF_CAP_PEBS_MASK		(PERF_CAP_PEBS_TRAP | PERF_CAP_ARCH_REG | \
+					 PERF_CAP_PEBS_FORMAT | PERF_CAP_PEBS_BASELINE | \
+					 PERF_CAP_PEBS_TIMING_INFO)
 
 #define MSR_IA32_RTIT_CTL		0x00000570
 #define RTIT_CTL_TRACEEN		BIT(0)
diff --git a/tools/arch/x86/include/asm/msr-index.h b/tools/arch/x86/include/asm/msr-index.h
index b7dded3c8113..48b7ed28718c 100644
--- a/tools/arch/x86/include/asm/msr-index.h
+++ b/tools/arch/x86/include/asm/msr-index.h
@@ -315,12 +315,14 @@
 #define PERF_CAP_PT_IDX			16
 
 #define MSR_PEBS_LD_LAT_THRESHOLD	0x000003f6
-#define PERF_CAP_PEBS_TRAP             BIT_ULL(6)
-#define PERF_CAP_ARCH_REG              BIT_ULL(7)
-#define PERF_CAP_PEBS_FORMAT           0xf00
-#define PERF_CAP_PEBS_BASELINE         BIT_ULL(14)
-#define PERF_CAP_PEBS_MASK	(PERF_CAP_PEBS_TRAP | PERF_CAP_ARCH_REG | \
-				 PERF_CAP_PEBS_FORMAT | PERF_CAP_PEBS_BASELINE)
+#define PERF_CAP_PEBS_TRAP		BIT_ULL(6)
+#define PERF_CAP_ARCH_REG		BIT_ULL(7)
+#define PERF_CAP_PEBS_FORMAT		0xf00
+#define PERF_CAP_PEBS_BASELINE		BIT_ULL(14)
+#define PERF_CAP_PEBS_TIMING_INFO	BIT_ULL(17)
+#define PERF_CAP_PEBS_MASK		(PERF_CAP_PEBS_TRAP | PERF_CAP_ARCH_REG | \
+					 PERF_CAP_PEBS_FORMAT | PERF_CAP_PEBS_BASELINE | \
+					 PERF_CAP_PEBS_TIMING_INFO)
 
 #define MSR_IA32_RTIT_CTL		0x00000570
 #define RTIT_CTL_TRACEEN		BIT(0)

base-commit: 829f5a6308ce11c3edaa31498a825f8c41b9e9aa
-- 
2.34.1


