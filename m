Return-Path: <kvm+bounces-15185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEE3A8AA758
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 05:45:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 192931C20ED1
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 03:45:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27CF68F62;
	Fri, 19 Apr 2024 03:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kRCnWglV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD3A1FB4;
	Fri, 19 Apr 2024 03:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713498336; cv=none; b=uqf1j9jqoJXQKTzlIhLiWC+b/QJ1pbJmpcWlOk4pWYPH7CaJ6yxxzBuwgG74MzNvzTmWoJshkvboqEXRzCJaym8/3CGtPouLybzJIZYjZcqKMO1Gf1bilaAwpHJlmfa0kAACKnqN628IqmNw2UDsPZZFakXu/MElHVMo3KlHoeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713498336; c=relaxed/simple;
	bh=sXzM59yBbqpFokcZIBxyheUel0wZXEjiik4VkhNlXoQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=b77VuwWfhMu4Gy7PYaN9TD7B8bMuuwpwk3JGc5cV0Rl8/YBEMI/aaDwX5rPrFLgn/7F7mCU6Q0p6TGyYxDm1TWO3C3knic6Pe3vLq6EN33SD6VSBYmKu/mqkfiouFlGudyTq61Cbng1gsPhVxu9FnxbxgKmXEiG0UHG2JEMcEGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kRCnWglV; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713498335; x=1745034335;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sXzM59yBbqpFokcZIBxyheUel0wZXEjiik4VkhNlXoQ=;
  b=kRCnWglVg3WyGHmIvMMTbFv8vTcZXQuV0g0zgTlddwqrJuVqAUOcHyiL
   P+qFhMLqrX2yREwBKOE3N4uWjVEte0ylidhqvZctV3FD0uN7+eynNWT+V
   GhrIIP+FlhRsWdUtblmA+tFwZyL0vRK0mYJprvniV5dZBHzlJENTDBD6p
   GBrDL+WxbTBO3UKszHjwigCqLwXUURaAQvS1Q1U34bF6JKkwVmHn74LH5
   c1WWfjNQU7n5fgyVEnJqWSsNB0Zi1j1H2g/otGKu0DoalSZ5YfEK1VNcA
   DciaXnwo+A/66bZtq8l1sgug78w3x+Q4ivKRNLaHlUFLSkzBfIfOZ7lsp
   Q==;
X-CSE-ConnectionGUID: E3BX4x7XQ9qNbcDgr2Q6Ag==
X-CSE-MsgGUID: kdDkkTPnSWiorn3xOIG/BQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="31565392"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="31565392"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 20:45:34 -0700
X-CSE-ConnectionGUID: vZOzMT0BToqnS5GV7iXiVw==
X-CSE-MsgGUID: yHvj+3F3QV+kqBmBMoSnLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="54410091"
Received: from unknown (HELO dmi-pnp-i7.sh.intel.com) ([10.239.159.155])
  by fmviesa001.fm.intel.com with ESMTP; 18 Apr 2024 20:45:31 -0700
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
Subject: [kvm-unit-tests Patch v4 00/17] pmu test bugs fix and improvements
Date: Fri, 19 Apr 2024 11:52:16 +0800
Message-Id: <20240419035233.3837621-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes:
v3 -> v4:
  * Fix the new found issue that pmu_counter_t.config crosses cache 
    lines (patch 04)
  * Fix the cycles event false positive by introducing a warm-up phase
    instead of switching cycles events order in v3 (patch 07)
  * Use macro to replace hard-coded events index (Mingwei)(patches 08~10)
  * Simply the asm code to enable/disable GLOBAL_CTRL MSR in whole asm
    blob (patch 11)
  * Handle legacy CPUs without clflush/clflushopt/IBPB support 
    (patches 14, 16)
  * Optimize emulated instruction validation (patch 17)

All changes pass validation on Intel Sapphire Rapids and Emerald Rapids
platforms against latest kvm-x86/next code (2d181d84af38). No tests on
AMD platforms since no AMD platform on hand. Any tests on AMD platform
are appreciated.

History:
  v3: https://lore.kernel.org/lkml/20240103031409.2504051-1-dapeng1.mi@linux.intel.com/ 
  v2: https://lore.kernel.org/lkml/20231031092921.2885109-1-dapeng1.mi@linux.intel.com/
  v1: https://lore.kernel.org/lkml/20231024075748.1675382-1-dapeng1.mi@linux.intel.com/


Dapeng Mi (16):
  x86: pmu: Remove blank line and redundant space
  x86: pmu: Refine fixed_events[] names
  x86: pmu: Fix the issue that pmu_counter_t.config crosses cache line
  x86: pmu: Enlarge cnt[] length to 48 in check_counters_many()
  x86: pmu: Add asserts to warn inconsistent fixed events and counters
  x86: pmu: Fix cycles event validation failure
  x86: pmu: Use macro to replace hard-coded branches event index
  x86: pmu: Use macro to replace hard-coded ref-cycles event index
  x86: pmu: Use macro to replace hard-coded instructions event index
  x86: pmu: Enable and disable PMCs in loop() asm blob
  x86: pmu: Improve instruction and branches events verification
  x86: pmu: Improve LLC misses event verification
  x86: pmu: Adjust lower boundary of llc-misses event to 0 for legacy
    CPUs
  x86: pmu: Add IBPB indirect jump asm blob
  x86: pmu: Adjust lower boundary of branch-misses event
  x86: pmu: Optimize emulated instruction validation

Xiong Zhang (1):
  x86: pmu: Remove duplicate code in pmu_init()

 lib/x86/pmu.c |   5 -
 x86/pmu.c     | 386 ++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 308 insertions(+), 83 deletions(-)


base-commit: e96011b32944b1ecca5967674ae243067588d1e7
-- 
2.34.1


