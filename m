Return-Path: <kvm+bounces-5490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 908B6822762
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 04:09:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5612284C22
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 03:09:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C60B1799B;
	Wed,  3 Jan 2024 03:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RMF0QZJx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCCD17980;
	Wed,  3 Jan 2024 03:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704251372; x=1735787372;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iu8p/P3QhQcocBbNzGCVARnxcO1Moj9wB0O7V477T4A=;
  b=RMF0QZJxefP8LNeWLB3Xi5Oz0ai7yoM/4QBVkFoP27VZMWxDX12IUDMF
   6I4gzB4+RBD0guO5n/HlO/fU/WDihD5dWv798n4wp/YMHiKPxKMwo9wyX
   B+Mso8Jy+DboDM2qthdWJTzgyT5c98uK9WQBKl3gH94TisEAK5uOZ0HzS
   svKsDPH3gsNKZ7tqpuF16y4/sR2jwJYTsUMobWpwZHwFvsc6zzfrlpfSE
   qQUNSmdihFX6J6An2PQwwYzt+7f9J8r4XwDqlYeaiy7lQ8W67+QUKwsag
   HgvlTcKBX2PvQRzZ+Kezcf7puyWeaC+QVo8PMFaDwnexmx1X5OoB8wCbO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="10343114"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="10343114"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2024 19:09:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="729665904"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="729665904"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by orsmga003.jf.intel.com with ESMTP; 02 Jan 2024 19:09:26 -0800
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhang Xiong <xiong.y.zhang@intel.com>,
	Mingwei Zhang <mizhang@google.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests Patch v3 00/11] pmu test bugs fix and improvements
Date: Wed,  3 Jan 2024 11:13:58 +0800
Message-Id: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When running pmu test on Sapphire Rapids, we found sometimes pmu test
reports the following failures.

1. FAIL: Intel: all counters
2. FAIL: Intel: core cycles-0
3. FAIL: Intel: llc misses-4

Further investigation shows these failures are all false alarms rather
than real vPMU issues.

The failure 1 is caused by a bug in check_counters_many() which defines
a cnt[] array with length 10. On Sapphire Rapids KVM supports 8 GP
counters and 3 fixed counters, obviously the total counter number (11)
of Sapphire Rapids exceed current cnt[] length 10, it would cause a out
of memory access and lead to the "all counters" false alarm. Patch
02~03 would fix this issue.

The failure 2 is caused by pipeline and cache warm-up latency.
Currently "core cycles" is the first executed event. When the measured
loop() program is executed at the first time, cache hierarchy and pipeline
are needed to warm up. All these warm-up work consumes so much cycles
that it exceeds the predefined upper boundary and cause the failure.
Patch 04 fixes this issue.

The failure 3 is caused by 0 llc misses count. It's possible and
reasonable that there is no llc misses happened for such simple loop()
asm blob especially along with larger and larger LLC size on new
processors. Patch 09 would fix this issue by introducing clflush
instruction to force LLC miss.

Besides above bug fixes, this patch series also includes several
optimizations.

One important optimization (patch 07~08) is to move
GLOBAL_CTRL enabling/disabling into the loop asm blob, so the precise
count for instructions and branches events can be measured and the
verification can be done against the precise count instead of the rough
count range. This improves the verification accuracy.

Another important optimization (patch 10~11) is to leverage IBPB command
to force to trigger a branch miss, so the lower boundary of branch miss
event can be set to 1 instead of the ambiguous 0. This eliminates the
ambiguity brought from 0.

All these changes are tested on Intel Sapphire Rapids server platform
and the pmu test passes. Since I have no AMD platforms on my hand, these
changes are not verified on AMD platforms yet. If someone can help to
verify these changes on AMD platforms, it's welcome and appreciated.

Changes:
  v2 -> v3:
        fix "core cycles" failure,
        introduce precise verification for instructions/branches,
        leverage IBPB command to optimize branch misses verification,
        drop v2 introduced slots event verification
  v1 -> v2:
        introduce clflush to optimize llc misses verification
        introduce rdrand to optimize branch misses verification

History:
  v2: https://lore.kernel.org/lkml/20231031092921.2885109-1-dapeng1.mi@linux.intel.com/
  v1: https://lore.kernel.org/lkml/20231024075748.1675382-1-dapeng1.mi@linux.intel.com/

Dapeng Mi (10):
  x86: pmu: Enlarge cnt[] length to 64 in check_counters_many()
  x86: pmu: Add asserts to warn inconsistent fixed events and counters
  x86: pmu: Switch instructions and core cycles events sequence
  x86: pmu: Refine fixed_events[] names
  x86: pmu: Remove blank line and redundant space
  x86: pmu: Enable and disable PMCs in loop() asm blob
  x86: pmu: Improve instruction and branches events verification
  x86: pmu: Improve LLC misses event verification
  x86: pmu: Add IBPB indirect jump asm blob
  x86: pmu: Improve branch misses event verification

Xiong Zhang (1):
  x86: pmu: Remove duplicate code in pmu_init()

 lib/x86/pmu.c |   5 --
 x86/pmu.c     | 201 ++++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 171 insertions(+), 35 deletions(-)

-- 
2.34.1


