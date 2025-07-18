Return-Path: <kvm+bounces-52814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93DF7B098DF
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 02:20:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61FE33A4394
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 00:19:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 267BF29CE6;
	Fri, 18 Jul 2025 00:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KKtgBOzC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299E24C6E;
	Fri, 18 Jul 2025 00:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752797997; cv=none; b=VaGKIdreS0Qgpistf6NTypggIGV4NP+sms8zlbF/tP5um4Ikgs0Kag/pRGCvEsnpklQ3izx8k5fAZYHYr+ZojoiDicbc1LY0WwWRbyxnY+10x325t9H8fwWlJqYjAlBzKBn/Pr0GC3kRkOPYT6kQSn9XIBrMzzvGw219gKtRyPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752797997; c=relaxed/simple;
	bh=wXuVBFO/hHuSYPGU3psgtXtd9650vEzC7CPCy/E1+F8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jJwEoc8G+LBxYja8sANB6ocKUPWU1EQWF2JLSRH2N/PaPtLy1l8sc0OSbw0vxVqyX0j0QHX4bk0OoEUOb93A908io0KPQBJ1s/vSOhU92+iSvpUHY7LHIJxFr2ovsnJMkoRoJtlVa7qPchE5zW5y1FuTu3Xe2WixqE20X7DwHxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KKtgBOzC; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752797996; x=1784333996;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wXuVBFO/hHuSYPGU3psgtXtd9650vEzC7CPCy/E1+F8=;
  b=KKtgBOzC1C2IY1B2r3ktL76MjrKt/9QkYuJJt6cJxA4vsfAuLVrXHZFd
   J8/R4DVg5elB4xiDIq6Io/4Coi8mFBTAUI4AsQJBZefGoSLB7L+0c8h+P
   fgu8ur277F5/kC/z5TrFyfsAk1YXwY75AgdwtPC57+vYQKdnIhqom+3Iq
   YyOLdbSnhk8/51ebZ2UJtQA7iugIgDcVgLm3YOiZnQOuVRrgzXDSfB2UQ
   Hfg3STl1WCr4/CeLp44zxzzSytO+6Wl1+AdCXrjUI2E6irdgOfUzFxkSR
   N8fDuV4eu7buWZE9sCBZyivKs0mKOBAIDlBgSerUUyUo9ryVlsteVD392
   Q==;
X-CSE-ConnectionGUID: hmJ5PqTOQWybeAOg/c7XDQ==
X-CSE-MsgGUID: 3J9v6v9JTQS21W/+j6RKtQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="65780084"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="65780084"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 17:19:55 -0700
X-CSE-ConnectionGUID: wYJVFfPjQnOyuiZYib+N6A==
X-CSE-MsgGUID: X8I7RK5+QHWzJNJztQvFtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="157322769"
Received: from spr.sh.intel.com ([10.112.229.196])
  by orviesa010.jf.intel.com with ESMTP; 17 Jul 2025 17:19:50 -0700
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
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH v2 0/5] Fix PMU kselftests errors on GNR/SRF/CWF
Date: Fri, 18 Jul 2025 08:19:00 +0800
Message-Id: <20250718001905.196989-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series fixes KVM PMU kselftests errors encountered on Granite
Rapids (GNR), Sierra Forest (SRF) and Clearwater Forest (CWF).

GNR and SRF starts to support the timed PEBS. Timed PEBS adds a new
"retired latency" field in basic info group to show the timing info and
the PERF_CAPABILITIES[17] called "PEBS_TIMING_INFO" bit is added
to indicated whether timed PEBS is supported. KVM module doesn't need to
do any specific change to support timed PEBS except a perf change adding
PERF_CAP_PEBS_TIMING_INFO flag into PERF_CAP_PEBS_MASK[1]. The patch 2/5
adds timed PEBS support in vmx_pmu_caps_test and fix the error as the
PEBS caps field mismatch.

CWF introduces 5 new architectural events (4 level-1 topdown metrics
events and LBR inserts event). The patch 3/5 adds support for these 5
arch-events and fixes the error that caused by mismatch between HW real
supported arch-events number with NR_INTEL_ARCH_EVENTS.

On Intel Atom platforms, the PMU events "Instruction Retired" or
"Branch Instruction Retired" may be overcounted for some certain
instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
and complex SGX/SMX/CSTATE instructions/flows[2].

In details, for the Atom platforms before Sierra Forest (including
Sierra Forest), Both 2 events "Instruction Retired" and
"Branch Instruction Retired" would be overcounted on these certain
instructions, but for Clearwater Forest only "Instruction Retired" event
is overcounted on these instructions.

As this overcount issue, pmu_counters_test and pmu_event_filter_test
would fail on the precise event count validation for these 2 events on
Atom platforms.

To work around this Atom platform overcount issue, Patches 4-5/5 looses
the precise count validation separately for pmu_counters_test and
pmu_event_filter_test.

BTW, this patch series doesn't depend on the mediated vPMU support.

Changes:
  * Add error fix for vmx_pmu_caps_test on GNR/SRF (patch 2/5).
  * Opportunistically fix a typo (patch 1/5).

Tests:
  * PMU kselftests (pmu_counters_test/pmu_event_filter_test/
    vmx_pmu_caps_test) passed on Intel SPR/GNR/SRF/CWF platforms.

History:
  * v1: https://lore.kernel.org/all/20250712172522.187414-1-dapeng1.mi@linux.intel.com/

Ref:
  [1] https://lore.kernel.org/all/20250717090302.11316-1-dapeng1.mi@linux.intel.com/
  [2] https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details

Dapeng Mi (4):
  KVM: x86/pmu: Correct typo "_COUTNERS" to "_COUNTERS"
  KVM: selftests: Add timing_info bit support in vmx_pmu_caps_test
  KVM: Selftests: Validate more arch-events in pmu_counters_test
  KVM: selftests: Relax branches event count check for event_filter test

dongsheng (1):
  KVM: selftests: Relax precise event count validation as overcount
    issue

 arch/x86/include/asm/kvm_host.h               |  8 ++--
 arch/x86/kvm/vmx/pmu_intel.c                  |  6 +--
 tools/testing/selftests/kvm/include/x86/pmu.h | 19 ++++++++
 .../selftests/kvm/include/x86/processor.h     |  7 ++-
 tools/testing/selftests/kvm/lib/x86/pmu.c     | 43 +++++++++++++++++++
 .../selftests/kvm/x86/pmu_counters_test.c     | 39 ++++++++++++++---
 .../selftests/kvm/x86/pmu_event_filter_test.c |  9 +++-
 .../selftests/kvm/x86/vmx_pmu_caps_test.c     |  3 +-
 8 files changed, 117 insertions(+), 17 deletions(-)


base-commit: 772d50d9b87bec08b56ecee0a880d6b2ee5c7da5
-- 
2.34.1


