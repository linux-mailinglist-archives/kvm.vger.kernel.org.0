Return-Path: <kvm+bounces-52445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AF33B0541E
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 10:08:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 883683B2504
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 08:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF0222741D4;
	Tue, 15 Jul 2025 08:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ISDMLG4S"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE8F27381A;
	Tue, 15 Jul 2025 08:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752566872; cv=none; b=arMkLtWCPjwJ/rlnExpLRvArlVgLONGNuZS93GyRYCdtjK2vZflFGLmhIuXjY64fsDOVOUQ32YYI+a7nomH76WeEjiEiuURV7qfROl/rEAXaEhBcgHGt4my1uMsKeweBGWMH0Lp4keU9+5jV8gPw9rjD36xDoUfspX3jnQvm+Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752566872; c=relaxed/simple;
	bh=aoyrrBSutaf1r36W7cylJGLxb4FhlsuFm1FNtQ3xk4M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GLRlIlnHe6g/koAkOJJA2PI6z3NtfvNs3ZDjIIWNOns6jxZMw2HV3DaCvl3nwh8Y4KzYs+UxxNjou9XoffHwHV9GeWIIBxYPzCL8JLyEqEoOPIR5awCi3UxzLbi7PPPN8cDFAdIjaf0WfF01L70PO51AgIB0DJGoMi/zQCtC4jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ISDMLG4S; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752566870; x=1784102870;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aoyrrBSutaf1r36W7cylJGLxb4FhlsuFm1FNtQ3xk4M=;
  b=ISDMLG4SFQBKkukCNETS9cLUjxL9IrN7otaZOsf3nlZZFHIZEXZnC1Ay
   cvpv5jNM+e8whVSCbE5Ve6Zm5BG9YsAds0+hphH5FihCupf157e5hdRqF
   HYSaP+wON72VSvLjyc9B7p554+W3ftKkMUOztLa9QLRPhpWVQKer7bZ12
   8H4OSxqJ5G2yaaoB8+yKjvQl1huRcXcmdjJW44HKzsAgkiDeuASja1265
   Q0vgPkIW1BSmYx1ot+lqPrBmdTdP2PjgDebVTj638CNAaJZzLWvJnLvkP
   Q7Fu0Lw5FyPSDel+4OsU08kIzxp7UQZTLgyfF694reYb3MjPj7a7G1zdt
   g==;
X-CSE-ConnectionGUID: 5QI1bMflRZ6HKEXe10QEAQ==
X-CSE-MsgGUID: JDcap36QSZqerMMwCo+63Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="66135075"
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="66135075"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 01:07:49 -0700
X-CSE-ConnectionGUID: YD7zH9HVSCCIM1TpJcLlrA==
X-CSE-MsgGUID: wr36XeqoQimOOyQrQLaU4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="161471306"
Received: from emr.sh.intel.com ([10.112.229.56])
  by orviesa003.jf.intel.com with ESMTP; 15 Jul 2025 01:07:46 -0700
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
Subject: [PATCH 0/3] Fix PMU kselftests errors on SRF and CWF 
Date: Sat, 12 Jul 2025 17:25:18 +0000
Message-ID: <20250712172522.187414-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This small patchset fixes PMU kselftest errors on Sierra Forest (SRF) and
Clearwater Forest (CWF).

Patch 1/3 adds validation support for newly introduced 5 architectural
events on CWF. Without this patch, pmu_counter_test asserts failure
 "New architectural event(s) detected; please update this test".

On Intel Atom platforms, the PMU events "Instruction Retired" or
"Branch Instruction Retired" may be overcounted for some certain
instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
and complex SGX/SMX/CSTATE instructions/flows[1].

In details, for the Atom platforms before Sierra Forest (including
Sierra Forest), Both 2 events "Instruction Retired" and
"Branch Instruction Retired" would be overcounted on these certain
instructions, but for Clearwater Forest only "Instruction Retired" event
is overcounted on these instructions.

As this overcount issue, pmu_counters_test and pmu_event_filter_test
would fail on the precise event count validation for these 2 events on
Atom platforms.

To work around this Atom platform overcount issue, Patches 2-3/3 relax
the precise event count validation if the platform is detected to have
the overcount issue.

Tests:
  * PMU kselftests (pmu_counters_test/pmu_event_filter_test/
    vmx_pmu_caps_test) passed on GNR/SRF/CWF platforms.

Ref:
  [1] https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details

Dapeng Mi (2):
  KVM: Selftests: Validate more arch-events in pmu_counters_test
  KVM: selftests: Relax branches event count check for event_filter test

dongsheng (1):
  KVM: selftests: Relax precise event count validation as overcount
    issue

 tools/testing/selftests/kvm/include/x86/pmu.h | 19 ++++++++
 .../selftests/kvm/include/x86/processor.h     |  7 ++-
 tools/testing/selftests/kvm/lib/x86/pmu.c     | 43 +++++++++++++++++++
 .../selftests/kvm/x86/pmu_counters_test.c     | 39 ++++++++++++++---
 .../selftests/kvm/x86/pmu_event_filter_test.c |  9 +++-
 5 files changed, 108 insertions(+), 9 deletions(-)


base-commit: 772d50d9b87bec08b56ecee0a880d6b2ee5c7da5
-- 
2.43.0


