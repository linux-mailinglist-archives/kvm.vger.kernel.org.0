Return-Path: <kvm+bounces-26895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D0172978E94
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 09:01:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F0B81F23E4F
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 07:01:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFA0F1CDA2B;
	Sat, 14 Sep 2024 07:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I6kwCkdM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4233E61FFC;
	Sat, 14 Sep 2024 07:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726297273; cv=none; b=EOLTm+Jc2VArN/euCP9jUk2ZR3A5imv71rBjvNFAHOaA0biZv34Fd1mUoWo1opCImJZLr6qGZdQLMAJsSJYQ44KHOc5bRJ9e2kQb8RkYUWA9iR+zL6D58S+Z8Tk4b0BGt9Rl63eZFRJOSulsjCMF8bgO+zcbh61aPhbt5gfZbnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726297273; c=relaxed/simple;
	bh=cqIWvOOX+XrN3/tY6RHoaMPUp//S60KN/bWEkvG3V+A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NTCDRRhEaPML5Tlrc8rcyPmK4r0M+UPPlkQv/zd9N+IaKENIRmOKVL1LW9AE9Dojz3iBYfUaWR2pH/2paQVr7h/xwxDfb2p9A0mxzgSRzqOkIGzkVGeT2V0HcwC/xLDeX5bHzD+trz5F/O1CebzsHa0XmW7DNX7Wm8hlrJUwsWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I6kwCkdM; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726297271; x=1757833271;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cqIWvOOX+XrN3/tY6RHoaMPUp//S60KN/bWEkvG3V+A=;
  b=I6kwCkdMPZWaRg3bVxNk3IBT9u8GbMGyqW9q9/5OsTVOY2R2SUb1JycL
   QctkurubiQSCNY7vvclwff2ddoNslRvbU7P93Ba5+CzWhCR4YnvC+VSHV
   VNjGfuIk0kkIcf3Cek5xeQeJw+pionn5du69CwXP7ia02xlLSZEU8nsUC
   1P6Jy+nQrc8jrg6clUtBPLlmPX7qKhi6lwh5bviF8rh21nHnU1ZotwimZ
   iedy7jsjh2BKmYRGW7PCraA0ybWLVGy9bKuIVerTAwD35vl7Ny94y0M4e
   44dhnBpKBo/MbybRxitafAcOBhLCMgDrVK2kB8rCc7pkwnS2usvJRiioX
   A==;
X-CSE-ConnectionGUID: TV9p/K/mTJGCq5WssTbUcw==
X-CSE-MsgGUID: JGKdyDPcQqCcLb2Z0vbYHQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="35778729"
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="35778729"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2024 00:01:11 -0700
X-CSE-ConnectionGUID: xcO3UL5RSuyB3PldMGxZgw==
X-CSE-MsgGUID: g3/73qBDSmy7IV22QEOEoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="67950635"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa006.fm.intel.com with ESMTP; 14 Sep 2024 00:00:55 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests patch v6 00/18] pmu test bugs fix and improvements
Date: Sat, 14 Sep 2024 10:17:10 +0000
Message-Id: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes:
v5 -> v6:
  * limit maximum fixed counters number to 
    MIN(pmu.nr_fixed_counters, ARRAY_SIZE(fixed_events)) to avoid
    out-of-bound access for fixed_events[]. If supported fixed counters
    number is larger than array size of fixed_events[], print message to
    remind to update test case. (Jim)
  * limit instructions & branches events precise validation for only
    Intel processors. (Sandipan Das)

KUT/pmu test passes on Intel Sapphire Rapids platform.

History:
  v5: https://lore.kernel.org/all/20240703095712.64202-1-dapeng1.mi@linux.intel.com/
  v4: https://lore.kernel.org/all/20240419035233.3837621-1-dapeng1.mi@linux.intel.com/
  v3: https://lore.kernel.org/lkml/20240103031409.2504051-1-dapeng1.mi@linux.intel.com/ 
  v2: https://lore.kernel.org/lkml/20231031092921.2885109-1-dapeng1.mi@linux.intel.com/
  v1: https://lore.kernel.org/lkml/20231024075748.1675382-1-dapeng1.mi@linux.intel.com/

Dapeng Mi (17):
  x86: pmu: Remove blank line and redundant space
  x86: pmu: Refine fixed_events[] names
  x86: pmu: Fix the issue that pmu_counter_t.config crosses cache line
  x86: pmu: Enlarge cnt[] length to 48 in check_counters_many()
  x86: pmu: Print measured event count if test fails
  x86: pmu: Fix potential out of bound access for fixed events
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
 x86/pmu.c     | 427 ++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 346 insertions(+), 86 deletions(-)


base-commit: 17f6f2fd17935eb5e564f621c71244b4a3ddeafb
-- 
2.40.1


