Return-Path: <kvm+bounces-15192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 474828AA766
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 05:47:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EEF04284AFA
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 03:47:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0DF42BAFB;
	Fri, 19 Apr 2024 03:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ikeXhYwS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA29E2AF17;
	Fri, 19 Apr 2024 03:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713498356; cv=none; b=QnJG9oS8fRiVDMbTOErJbkpOcs6zVbD6CRnePKHjc8T7sbgUUV0jdZn7BxuKgG/otz3HHl9FT/x0okNzv7bfuc60y/PpO/U7F0e51bHkPKq1mzmNfeJY3HrnhcaHSN3039zg1gWB+B1VnfZUwzhjWrpSMC6LZgJddgsAt7Wq0SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713498356; c=relaxed/simple;
	bh=Qsmg2ffUGXqjYUoa6KnIqYzBA5c7umCrK37g6zMvxy8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GFFZK8/dqTdMWuYMyhagb4cr5yI9ehQQ6AJqwFgOitrUBVm0wkb+3ITa6Lk2/cQm+Fjuih42doP2QUIJJdac/B+gw80fTMstHkJUPwN80mXUZiq7tr1hQyJwYjhcKk0ThLrAByKihTorzP6vNt0L5r7nkHgJV+XlPgZYYlrYgLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ikeXhYwS; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713498355; x=1745034355;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Qsmg2ffUGXqjYUoa6KnIqYzBA5c7umCrK37g6zMvxy8=;
  b=ikeXhYwSMJwKP+dmHi/JT9S0OtDHbuy++AdzSxeGr3zLJ93NfWBb97vb
   4DO2pjVPFB/YzTQGbz9zStxFImeMmxA7tdFGRYvZFclzp43EO3kKQm/EX
   EkPdCOiJaum+a6nYLyjvNirOE1m70xgC7XyFcY3kap9HIBPT+GCWfDtb/
   TtXpXP7+rb9mDVL1zDLEUiVZN2fUJTcdMnmCyl6J49GQ4TzjdwsbnaZ8/
   Wuv+ZRuoY03hLzjEKFCs+q7crFavS3+dYKK2xoqwqUz8VHMLHrazJd1Yl
   mvPLKqY+DDYJzczsXbMh1UXNltx+YblCrSt4gkABVOMuvA4vDMUnZp5Jf
   g==;
X-CSE-ConnectionGUID: qAc2q0AHQpq9B8Ifo+vSxA==
X-CSE-MsgGUID: Myia6YNlSXusML20p7DLpA==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="31565450"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="31565450"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 20:45:54 -0700
X-CSE-ConnectionGUID: W1VyNyMfRJe7HdPoKvzNzw==
X-CSE-MsgGUID: 5O11IwgkTKuehBxMZyagnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="54410163"
Received: from unknown (HELO dmi-pnp-i7.sh.intel.com) ([10.239.159.155])
  by fmviesa001.fm.intel.com with ESMTP; 18 Apr 2024 20:45:51 -0700
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
Subject: [kvm-unit-tests Patch v4 07/17] x86: pmu: Fix cycles event validation failure
Date: Fri, 19 Apr 2024 11:52:23 +0800
Message-Id: <20240419035233.3837621-8-dapeng1.mi@linux.intel.com>
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

When running pmu test on SPR, sometimes the following failure is
reported.

PMU version:         2
GP counters:         8
GP counter width:    48
Mask length:         8
Fixed counters:      3
Fixed counter width: 48
1000000 <= 55109398 <= 50000000
FAIL: Intel: core cycles-0
1000000 <= 18279571 <= 50000000
PASS: Intel: core cycles-1
1000000 <= 12238092 <= 50000000
PASS: Intel: core cycles-2
1000000 <= 7981727 <= 50000000
PASS: Intel: core cycles-3
1000000 <= 6984711 <= 50000000
PASS: Intel: core cycles-4
1000000 <= 6773673 <= 50000000
PASS: Intel: core cycles-5
1000000 <= 6697842 <= 50000000
PASS: Intel: core cycles-6
1000000 <= 6747947 <= 50000000
PASS: Intel: core cycles-7

The count of the "core cycles" on first counter would exceed the upper
boundary and leads to a failure, and then the "core cycles" count would
drop gradually and reach a stable state.

That looks reasonable. The "core cycles" event is defined as the 1st
event in xxx_gp_events[] array and it is always verified at first.
when the program loop() is executed at the first time it needs to warm
up the pipeline and cache, such as it has to wait for cache is filled.
All these warm-up work leads to a quite large core cycles count which
may exceeds the verification range.

To avoid the false positive of cycles event caused by warm-up,
explicitly introduce a warm-up state before really starting
verification.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index 461a4090d475..43ef7ecbcaea 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -591,11 +591,27 @@ static void check_tsx_cycles(void)
 	report_prefix_pop();
 }
 
+static void warm_up(void)
+{
+	int i = 8;
+
+	/*
+	 * Since cycles event is always run as the first event, there would be
+	 * a warm-up state to warm up the cache, it leads to the measured cycles
+	 * value may exceed the pre-defined cycles upper boundary and cause
+	 * false positive. To avoid this, introduce an warm-up state before
+	 * the real verification.
+	 */
+	while (i--)
+		loop();
+}
+
 static void check_counters(void)
 {
 	if (is_fep_available())
 		check_emulated_instr();
 
+	warm_up();
 	check_gp_counters();
 	check_fixed_counters();
 	check_rdpmc();
-- 
2.34.1


