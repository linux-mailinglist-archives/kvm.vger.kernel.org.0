Return-Path: <kvm+bounces-52820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C21D9B09947
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 03:40:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DEC281C4481D
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 01:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E02D5191F89;
	Fri, 18 Jul 2025 01:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FSASnYCk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBC411712;
	Fri, 18 Jul 2025 01:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752802798; cv=none; b=sQDNLpXFsVP1dq8j66SR4zPhoOfEb/PzmX5AQX+8nd6JdypAeG+UVU5lAtOiQ+fLRv03jziUpao/Q3KqiYf47GOuNJvLnIIk36ArhHAN/zJ1lHNguKk6j8qh2BuHXCYE2NlTr4bd6bh3awO8dOy5k6xifRpz30KwWc1utDRFKA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752802798; c=relaxed/simple;
	bh=b7Scx0c4FIXqLHCwV/J83ac2TyeQmKQik1nURspK84w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cArdCSzhblB1JjIlJSG8YrOa00PeAcK/utfRQ/CGjHYCKwKWpCIqpsYW+ep3pxWr6djDitSqqN2stDXd6/ZTq4MPokNDjFIEVtm6JXWKebpZvpfrflMXYVEvrEGEhd/XTkt0IRQZvfNyMAZZHJnXsWKg3CBIZkasaZ4nyKENkjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FSASnYCk; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752802797; x=1784338797;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=b7Scx0c4FIXqLHCwV/J83ac2TyeQmKQik1nURspK84w=;
  b=FSASnYCk3skCD+hUnWAXv/hjDNfudFkcP8LpRknQbQDP8xzf2ByQ0aml
   KHWjzcZti3qVAH8KE8iBtGor2ZVJ6JNWmNyixO3Wc6E1LoCdnUGYjQreb
   M+DpLBh/IKUUe48tIzINtnRg3ZZtdOw16NtA5LJHihzsCtaCm+Sq25H9b
   XxjW51iWkL1SyXRhfH6TXrGUbjpCfQA4LVOU08NPSlZPFM3YDRZDwIFs0
   EqZBPpFqg0SKDoMAVDLh9FZW8YKHFxJvfyZQg90u//r2Cy/JR9jFMuDMX
   4LaYlJ9NRLIPULlR3Y2WfwcVtRLz+2zkjM6DZz1Vq7VC4WbpoDOfq0GAm
   w==;
X-CSE-ConnectionGUID: XMTe+eLBS0GK+f4zAH60xw==
X-CSE-MsgGUID: wtNiG5RfQGWzodyDxNSRCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="54951436"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="54951436"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 18:39:56 -0700
X-CSE-ConnectionGUID: 3IRjcnOnRIqfZeHOFPLj2w==
X-CSE-MsgGUID: dxn41eaqQ1ujsDp+gB+Erg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="188918337"
Received: from spr.sh.intel.com ([10.112.229.196])
  by fmviesa001.fm.intel.com with ESMTP; 17 Jul 2025 18:39:53 -0700
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
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests patch v2 0/7] Fix pmu test errors on GNR/SRF/CWF
Date: Fri, 18 Jul 2025 09:39:08 +0800
Message-Id: <20250718013915.227452-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

Changes:
  * Fix the flaws on x86_model() helper (Xiaoyao).
  * Fix the pmu_pebs error on GNR/SRF.

Tests:
  * pmu tests passed on SPR/GNR/SRF/CWF.
  * pmu_lbr tests is skiped on SPR/GNR/SRF/CWF since mediated vPMU based
    arch-LBR support is not upstreamed yet.
  * pmu_pebs test passed on SPR/GNR/SRF and skiped on CWF since CWF
    introduces architectural PEBS and mediated vPMU based arch-PEBS
    support is not upstreamed yet.

History:
  * v1: https://lore.kernel.org/all/20250712174915.196103-1-dapeng1.mi@linux.intel.com/

Refs:
  [1] https://lore.kernel.org/all/20250717090302.11316-1-dapeng1.mi@linux.intel.com/
  [2] https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details


Dapeng Mi (2):
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
 x86/pmu.c           | 93 +++++++++++++++++++++++++++++++++++++++------
 x86/pmu_pebs.c      |  9 +++--
 4 files changed, 119 insertions(+), 16 deletions(-)


base-commit: 525bdb5d65d51a367341f471eb1bcd505d73c51f
-- 
2.34.1


