Return-Path: <kvm+bounces-56662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 46ACAB41568
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 08:47:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8691F17B479
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 06:47:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 587E82D8773;
	Wed,  3 Sep 2025 06:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jAXoheZo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D8C259C9C;
	Wed,  3 Sep 2025 06:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756882041; cv=none; b=Dr1ZhtwEZihYcF9X8hRtHjd8wy7O5B85i7iOqOWLGkH5hIGErDb8rbmE0Te81GDaDkTU00UoughYha1s+dYWsGXJvNUDYFhk5iCvYHPiHfxmRjyTxdGAo8MFB4I4falUEEP7Ty4tH8SQ7Pv4lXNxld/A3Qg6vy5KyyHJgEPXino=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756882041; c=relaxed/simple;
	bh=YPfYqxUugwaL92OOZv09TWNuVHCjvkeL6gZWX/wZxLE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HhQ1HaAgCU8bPMbvAk4KC/2Yh6fdVVbbdthvStEQIe5YP7haj2rRp9tWal6krbWQX3/Wm/3MDw/tyhIyU2VNicp3o+K9Ws4yNcux6vTMBszks4Am3ePXYncLYSc04mm+PFtMptzL4NRApe+yHx8rwWYuuLbEce/YqOR+BAhhYKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jAXoheZo; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756882040; x=1788418040;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YPfYqxUugwaL92OOZv09TWNuVHCjvkeL6gZWX/wZxLE=;
  b=jAXoheZoJZrDWqrPREpVwykGzsx3cT76pUlTQ58w61qjWpKhKbXMpOuG
   g7TezIESFW9HeNxawU0BUzMX7iP7iqGnR9WR/PfyQ58uHvByf2VPVaPs7
   4l1n369hCx9DncdtoS+iwMzqHSXGd6AjzfT6StuSp6MiB//uQ2XhmtRMm
   8Jz3MeAoHk/JNF54tUhnxsrosqekJn/nf8ETEKsi4Bi3GVW1vUIAyd0xR
   nmUb+ptQp8EsgIUZRmUTm1OtA+wWAQWjtQvwuzMZqhtKSfx7v+BC6S0cJ
   R0M7a6Unu+AwaTSVA3c5RNwn6Mo0H3yAyF/JF0StOwCB2WI+ybtiL2DWc
   g==;
X-CSE-ConnectionGUID: kwJlREY9RAKRvwbISP/twA==
X-CSE-MsgGUID: wppCsrCDR8KY44pFI9BqoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="63003761"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="63003761"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 23:47:19 -0700
X-CSE-ConnectionGUID: 8YSm5TURTNKhvuFTZBhaog==
X-CSE-MsgGUID: QboIzRoJRzehElud3c6WXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="171656524"
Received: from spr.sh.intel.com ([10.112.230.239])
  by orviesa008.jf.intel.com with ESMTP; 02 Sep 2025 23:47:15 -0700
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
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests patch v3 0/8] Fix pmu test errors on GNR/SRF/CWF
Date: Wed,  3 Sep 2025 14:45:53 +0800
Message-Id: <20250903064601.32131-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes:
v2 -> v3:
  * Fix the emulated instrunction validation error on SRF/CWF. (Patch 5/8)
v1 -> v2:
  * Fix the flaws on x86_model() helper (Xiaoyao).
  * Fix the pmu_pebs error on GNR/SRF.

This patchset fixes the pmu test errors on Granite Rapids (GNR), Sierra
Forest (SRF) and Clearwater Forest (CWF).

GNR and SRF start to support the timed PEBS. Timed PEBS adds a new
"retired latency" field in basic info group to show the timing info and
the PERF_CAPABILITIES[17] called "PEBS_TIMING_INFO" bit is added
to indicated whether timed PEBS is supported. KVM module doesn't need to
do any specific change to support timed PEBS except a perf change adding
PERF_CAP_PEBS_TIMING_INFO flag into PERF_CAP_PEBS_MASK[1]. The patch 7/7
supports timed PEBS validation in pmu_pebs test.

On Intel Atom platforms, the PMU events "Instruction Retired" or
"Branch Instruction Retired" may be overcounted for some certain
instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
and complex SGX/SMX/CSTATE instructions/flows[2].

In details, for the Atom platforms before Sierra Forest (including
Sierra Forest), Both 2 events "Instruction Retired" and
"Branch Instruction Retired" would be overcounted on these certain
instructions, but for Clearwater Forest only "Instruction Retired" event
is overcounted on these instructions.

As the overcount issue, pmu test would fail to validate the precise
count for these 2 events on SRF and CWF. Patches 1-4/7 detects if the
platform has this overcount issue, if so relax the precise count
validation for these 2 events.

Besides it looks more LLC references are needed on SRF/CWF, so adjust
the "LLC references" event count range.

Tests:
  * pmu tests passed on SPR/GNR/SRF/CWF.
  * pmu_lbr tests is skiped on SPR/GNR/SRF/CWF since mediated vPMU based
    arch-LBR support is not upstreamed yet.
  * pmu_pebs test passed on SPR/GNR/SRF and skiped on CWF since CWF
    introduces architectural PEBS and mediated vPMU based arch-PEBS
    support is not upstreamed yet.

History:
  * v2: https://lore.kernel.org/all/20250718013915.227452-1-dapeng1.mi@linux.intel.com/
  * v1: https://lore.kernel.org/all/20250712174915.196103-1-dapeng1.mi@linux.intel.com/

Refs:
  [1] https://lore.kernel.org/all/20250717090302.11316-1-dapeng1.mi@linux.intel.com/
  [2] https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details

Dapeng Mi (3):
  x86/pmu: Relax precise count check for emulated instructions tests
  x86: pmu_pebs: Remove abundant data_cfg_match calculation
  x86: pmu_pebs: Support to validate timed PEBS record on GNR/SRF

dongsheng (5):
  x86/pmu: Add helper to detect Intel overcount issues
  x86/pmu: Relax precise count validation for Intel overcounted
    platforms
  x86/pmu: Fix incorrect masking of fixed counters
  x86/pmu: Handle instruction overcount issue in overflow test
  x86/pmu: Expand "llc references" upper limit for broader compatibility

 lib/x86/pmu.h       |  6 +++
 lib/x86/processor.h | 27 +++++++++++++
 x86/pmu.c           | 95 ++++++++++++++++++++++++++++++++++++++-------
 x86/pmu_pebs.c      |  9 +++--
 4 files changed, 120 insertions(+), 17 deletions(-)


base-commit: 525bdb5d65d51a367341f471eb1bcd505d73c51f
-- 
2.34.1


