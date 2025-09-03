Return-Path: <kvm+bounces-56666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EF212B41575
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 08:48:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 565331B60D33
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 06:49:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 351AB2DC34A;
	Wed,  3 Sep 2025 06:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jehl0DtD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AE32DC335;
	Wed,  3 Sep 2025 06:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756882056; cv=none; b=mWSRGdsbboB74EjXtc04dwkM8Zfx1iCH6cT0X3kl1QGtdVo0McBBrMf0I0TprMhI5kt9qIuzXmfrxfZiivBVbAQ5yDtJg8/jZUEdrqMJYWacHy+t62CotKiVCm6I9X5FnXB98YXWihlGvQBoAwDX5JEHxLlcRH/7x/OGLwpSXxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756882056; c=relaxed/simple;
	bh=S7lk8W1qOqN6f2hlk12G1kiNj2WSIVk7J9ru7MHfT5M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=csWmIw99Bg25QHBEm7HS1mzjAhGGNqb4DwQYTCob+v+okPoBYkQ3yaSttr510fh7KrXakBfSjlyzV49qeGR1DFJRWoJVQvZRoG78uRo5ruQ+hCut3FtT8qBwD1+QPK/+z814ULPpZYHJSrwqiBkDhpkRBtIkqtesFzIL5DY4q9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jehl0DtD; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756882055; x=1788418055;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S7lk8W1qOqN6f2hlk12G1kiNj2WSIVk7J9ru7MHfT5M=;
  b=Jehl0DtDILmfGRZmG/BYj+kWqsIl8fafkJDvx4s0HZ6/CghYQ1s3wCg+
   3YQCY93FI7ruywijGu+B3qZ95VdkLo2ZmXgXilx3z6wmg8OpArwtPFF6V
   1oI/I+XGqox/rZy0A3A8RXcVKI75rbajxG/Ff7z4FSLg9oS5x3BCEgez/
   XqB5a2HnYpZ3CMnrbD4VhubpXXslk7KSDolOV+wd7/WhpnzFdi2nQeJEh
   7HLfRjqTOM9aPv6A0PF842h3z4FhrldMi3YvAJeU8qpxQPZ7AoNAxjo5C
   0piKbfyob5c11NY1ra59/rOeK/Z8lN7ehswp1p9HpWAzup/7YMS0byRBz
   Q==;
X-CSE-ConnectionGUID: J28ZRZziR1e/GFd8NQVZwA==
X-CSE-MsgGUID: 3Iz14ZRNS2eJ6YqNMMaEMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="63003795"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="63003795"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 23:47:34 -0700
X-CSE-ConnectionGUID: LpA9vQ6+TqS217Norf3d6w==
X-CSE-MsgGUID: etATi+9KTgCK8HyQ7dDLrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="171656577"
Received: from spr.sh.intel.com ([10.112.230.239])
  by orviesa008.jf.intel.com with ESMTP; 02 Sep 2025 23:47:30 -0700
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
	dongsheng <dongsheng.x.zhang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yi Lai <yi1.lai@intel.com>
Subject: [kvm-unit-tests patch v3 4/8] x86/pmu: Handle instruction overcount issue in overflow test
Date: Wed,  3 Sep 2025 14:45:57 +0800
Message-Id: <20250903064601.32131-5-dapeng1.mi@linux.intel.com>
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
2.34.1


