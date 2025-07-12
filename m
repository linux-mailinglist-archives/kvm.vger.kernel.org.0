Return-Path: <kvm+bounces-52454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5432EB054F3
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 10:32:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B5AC67B8BED
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 08:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 529CD2741D4;
	Tue, 15 Jul 2025 08:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="biITL8wI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55D4218AAD;
	Tue, 15 Jul 2025 08:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752568301; cv=none; b=lbcs7BsHXU1aDv5Mh2R5KVi5KFUSqzxx3+LkClR63S2PDFPWezWC40BKHfP2ivfItQZ7lE9UQAclEDfBM/NP62pLO/o38zcOHBJgfyuclFJQkflS8Y4y8XStgl827/KANhGiNZ7F2b73OD7brgierQvgsHq3GH7IuyBRfqqrdXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752568301; c=relaxed/simple;
	bh=GmF9A0uu3R9vARY/nDJM60P6Cx1d4Wo0ZlBrgNqfd84=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XlcUOSVqc5CBnX6uzy+iN+5YUTytH1k5sLP2h7PGiCIDKKrhejZ8Az5RdphwThN+hN1x0TarYX2uWwMu0kpBUI4M4CA00TB6TC3VY5YYNjFvJISEghKcNw/s5Lt5ugkYdivSX6PovIE4q2N3If/eWGbHwF+BCFQ9yykdlnz3i/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=biITL8wI; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752568300; x=1784104300;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GmF9A0uu3R9vARY/nDJM60P6Cx1d4Wo0ZlBrgNqfd84=;
  b=biITL8wIY9WngxTeQ4D1A5Bfb18u5TZ4hm2T6A1jumE6pSBZOeEPrtGc
   q8xG4SFM1imcoKmopxXVQCqH0gSZjtFd3QQnM6Irtid4I8fFP28Ni38/L
   vcYSOjReb5lfaaRvr2NNSDM6cZhb8BaMaaeT4M40X6NocDNm4yVleobye
   9368iyQ7rq/1X6xidGXdg1OyhAeX+8SKJtr5xhVO9IouCQ68hpBsMWUTV
   a94ZvMDKyATWiRourURSDyUvlJi0c01sKOn7U8GSf4C0jbgUdZ4+geK+b
   2JVE4D8ceGzAsHNECEQX7xFf6poL6X7QZMerI8gX7f0Hy+NRPKE5EPdhQ
   g==;
X-CSE-ConnectionGUID: LdIaf76DTMiDvwvoNAugDw==
X-CSE-MsgGUID: gKf4W8etSzKP0GJOPY0LIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54632066"
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="54632066"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 01:31:40 -0700
X-CSE-ConnectionGUID: 4dAzZFJxT2mI/S/bqqC+yA==
X-CSE-MsgGUID: BeFlch+ITxKNun+ncE9GMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="156572560"
Received: from emr.sh.intel.com ([10.112.229.56])
  by orviesa010.jf.intel.com with ESMTP; 15 Jul 2025 01:31:36 -0700
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
Subject: [kvm-unit-tests patch 0/5] Fix pmu test errors on SRF/CWF
Date: Sat, 12 Jul 2025 17:49:10 +0000
Message-ID: <20250712174915.196103-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset fixes the pmu test errors on Atom server like Sierra
Forest (SRF) and Clearwater Forest (CWF).

On Intel Atom platforms, the PMU events "Instruction Retired" or
"Branch Instruction Retired" may be overcounted for some certain
instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
and complex SGX/SMX/CSTATE instructions/flows[1].

In details, for the Atom platforms before Sierra Forest (including
Sierra Forest), Both 2 events "Instruction Retired" and
"Branch Instruction Retired" would be overcounted on these certain
instructions, but for Clearwater Forest only "Instruction Retired" event
is overcounted on these instructions.

As the overcount issue, pmu test would fail to validate the precise
count for these 2 events on SRF and CWF. Patches 1-3/5 detects if the
platform has this overcount issue, if so relax the precise count
validation for these 2 events.

Besides it looks more LLC references are needed on SRF/CWF, so adjust
the "LLC references" event count range.

Tests:
  * pmu test passes on Intel GNR/SRF/CWF platforms.

Ref:
  [1]https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details

dongsheng (5):
  x86/pmu: Add helper to detect Intel overcount issues
  x86/pmu: Relax precise count validation for Intel overcounted
    platforms
  x86/pmu: Fix incorrect masking of fixed counters
  x86/pmu: Handle instruction overcount issue in overflow test
  x86/pmu: Expand "llc references" upper limit for broader compatibility

 lib/x86/processor.h | 17 +++++++++
 x86/pmu.c           | 93 +++++++++++++++++++++++++++++++++++++++------
 2 files changed, 98 insertions(+), 12 deletions(-)


base-commit: 525bdb5d65d51a367341f471eb1bcd505d73c51f
-- 
2.43.0


