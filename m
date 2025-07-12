Return-Path: <kvm+bounces-52458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 447FAB054FC
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 10:33:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 438F17B9F51
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 08:31:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D7062D5402;
	Tue, 15 Jul 2025 08:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U68rNiPf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BEE2D3737;
	Tue, 15 Jul 2025 08:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752568319; cv=none; b=jdeyzEldweHGAtyO/5Esep1x5nDkbZL7TDfHEeASaTicEex99KXG3Zg7mnGqrZtPx8Vegoo9QdPE22949Wy9GrJx6KZ9TnlW3S8O3qb40v9sVaXOWpJHx4mBszQZNC8SqQ0C1Tr8Qoan1O2TX/oSWGx421ZJgODMtBlLZPghU+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752568319; c=relaxed/simple;
	bh=u3ipQeeF+33UNym7RHJSoeJHycW2i7A3nLZ2wZJmLxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWgCRgt9P8c3sL5TED/D5Ky0Mzj04ah8nVqv5rbEOBptwHnvoOH+/QasQdef+k0NTPHWRlQKY5YJa0cnNCb8Ulc3+roObPG1C3LtiaO1sm7SXJ7rTbt4b2jYlMnHr7FnR8wRrSDuxv6Ir6hbRpcH4Sp7rkgKAMMC8fP1QEzgzok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U68rNiPf; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752568318; x=1784104318;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u3ipQeeF+33UNym7RHJSoeJHycW2i7A3nLZ2wZJmLxM=;
  b=U68rNiPfgeJf+O+mxo2snsUGm+qUDSHKy6o2DWEhiHFmMB3ab384NLi5
   efgupjO4wYQln5npiGkv4N8H15K2uIb1FvAbFY2kN43YNU4ZSk/eQ8/+T
   0ajHwtatFlNyJMZYdud15JiHbsPF3Vnhh9TW8Fyw/rIQHgMLpA5fuMndB
   Xn6vOThq2IGD+f4WEg75AuHJMkI2d9dJj3RD5OUsry5YDjAYO7n8kWPsU
   ccZ+JlRSLYhI2q9ZpZJKN/ZKflT4pk6gb8SNpaOpLTZY+E1i8czesApnX
   bsDgEOqa8zhg5dPog0HYqaJc/XZyXXEArg6qPS+TWbWeKBlAZRxQbRKvg
   w==;
X-CSE-ConnectionGUID: uGFjuvdlQ5qGIFmaymOLpg==
X-CSE-MsgGUID: ITZgW9qyQDmW9EJR+oSHcQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54632115"
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="54632115"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 01:31:55 -0700
X-CSE-ConnectionGUID: wGviGYVxQFOSC56kLauAYA==
X-CSE-MsgGUID: 6QQLg926TlyNN43MCJi3Qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="156572597"
Received: from emr.sh.intel.com ([10.112.229.56])
  by orviesa010.jf.intel.com with ESMTP; 15 Jul 2025 01:31:51 -0700
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
	Dapeng Mi <dapeng1.mi@intel.com>,
	dongsheng <dongsheng.x.zhang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests patch 4/5] x86/pmu: Handle instruction overcount issue in overflow test
Date: Sat, 12 Jul 2025 17:49:14 +0000
Message-ID: <20250712174915.196103-5-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250712174915.196103-1-dapeng1.mi@linux.intel.com>
References: <20250712174915.196103-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: dongsheng <dongsheng.x.zhang@intel.com>

During the execution of __measure(), VM exits (e.g., due to
WRMSR/EXTERNAL_INTERRUPT) may occur. On systems affected by the
instruction overcount issue, each VM-Exit/VM-Entry can erroneously
increment the instruction count by one, leading to false failures in
overflow tests.

To address this, the patch introduces a range-based validation in place
of precise instruction count checks. Additionally, overflow_preset is
now statically set to 1 - LOOP_INSNS, rather than being dynamically
determined via measure_for_overflow().

These changes ensure consistent and predictable behavior aligned with the
intended loop instruction count, while avoiding modifications to the
subsequent status and status-clear testing logic.

The chosen validation range is empirically derived to maintain test
reliability across hardware variations.

Signed-off-by: dongsheng <dongsheng.x.zhang@intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
 x86/pmu.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 44c728a5..c54c0988 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -518,6 +518,21 @@ static void check_counters_many(void)
 
 static uint64_t measure_for_overflow(pmu_counter_t *cnt)
 {
+	/*
+	 * During the execution of __measure(), VM exits (e.g., due to
+	 * WRMSR/EXTERNAL_INTERRUPT) may occur. On systems affected by the
+	 * instruction overcount issue, each VM-Exit/VM-Entry can erroneously
+	 * increment the instruction count by one, leading to false failures
+	 * in overflow tests.
+	 *
+	 * To mitigate this, if the overcount issue is detected, we hardcode
+	 * the overflow preset to (1 - LOOP_INSNS) instead of calculating it
+	 * dynamically. This ensures that an overflow will reliably occur,
+	 * regardless of any overcounting caused by VM exits.
+	 */
+	if (intel_inst_overcount_flags & INST_RETIRED_OVERCOUNT)
+		return 1 - LOOP_INSNS;
+
 	__measure(cnt, 0);
 	/*
 	 * To generate overflow, i.e. roll over to '0', the initial count just
@@ -574,8 +589,12 @@ static void check_counter_overflow(void)
 			cnt.config &= ~EVNTSEL_INT;
 		idx = event_to_global_idx(&cnt);
 		__measure(&cnt, cnt.count);
-		if (pmu.is_intel)
-			report(cnt.count == 1, "cntr-%d", i);
+		if (pmu.is_intel) {
+			if (intel_inst_overcount_flags & INST_RETIRED_OVERCOUNT)
+				report(cnt.count < 14, "cntr-%d", i);
+			else
+				report(cnt.count == 1, "cntr-%d", i);
+		}
 		else
 			report(cnt.count == 0xffffffffffff || cnt.count < 7, "cntr-%d", i);
 
-- 
2.43.0


