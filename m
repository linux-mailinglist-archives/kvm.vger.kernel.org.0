Return-Path: <kvm+bounces-30831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5940B9BDD2D
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 03:49:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B2621F21F1D
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 02:49:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6F7B18FC9F;
	Wed,  6 Nov 2024 02:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bNu0WIYz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE46A47
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 02:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730861392; cv=none; b=M0piEa5DvixPX7Mqmi29n4A9z+y8JGD8oePqWUOdejCIkTHU1Pn5tFyxqoMjGPjAkAzyyBpTsjeVTfotGNPZWIfEOEO18MEgK4UgeupEK8fntukIqVIdLPCrNUl2x4+RHSK0uRZYPZUmGssdSdhUtkGwCHq+w0jSNVrMXyfvnr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730861392; c=relaxed/simple;
	bh=7mHTbnUklJ/WxI1mhOHUVBJLHOP4R6PTTfU5+MgjIaU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dPuldaX6TSu5oGGNeySiHrTijmO19nsx08n/F2J7/MuqcWFRwRNQX/4+w2ylko5jL1JhGx0VeM9gbiDtiWLT/Fyn2M7vuLvj6I6P6ff9RIyvJ3JGdOVTndWXgt35fl69hnCPHZnbvR753uAW7Mta7MLZ66GcHoNFidUWkYv7CAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bNu0WIYz; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730861391; x=1762397391;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7mHTbnUklJ/WxI1mhOHUVBJLHOP4R6PTTfU5+MgjIaU=;
  b=bNu0WIYzH5U+Srbl/rhXpufjTtxelyJZ2VlJd9jNchrr24OYtnIKG/Gf
   GMqiJOtCDHNvvfU5YMLhONwF0SW2pmXEuRAtWTjbRLNl0dkQbLaDqokTO
   Pe1Ve2/GIai7Jj6TiMMzj+7+Z1GQziHeY5F2MJxZjjYNbQwP5uwepmiT1
   1pkQPdBaiISwujiNjJTygHp29MZcr1P0x2+j4TgDgTwSyiQMARqfYGipD
   FPyBu4aWMQLGOB12JARWC9Ckz0yVepkxuNQ1l9mQw7myvJ+c6KXLK2FHs
   fpzlaj+CQINsr4nZlqKN0Y6rBit85/HWl9qtvSwcfhyTyzIP+nCY3jpsg
   w==;
X-CSE-ConnectionGUID: He53Fdj8ShmUuFgUZkAvMw==
X-CSE-MsgGUID: 9UTv0SEoTYeCluHYteZq1g==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30492192"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30492192"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 18:49:50 -0800
X-CSE-ConnectionGUID: K2/Uw2lRQueNgRX4yeYC/g==
X-CSE-MsgGUID: 4P0vK2jrQ3Or/fH5RjinCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="115077968"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 05 Nov 2024 18:49:46 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Tao Su <tao1.su@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v5 00/11] i386: miscellaneous cleanup
Date: Wed,  6 Nov 2024 11:07:17 +0800
Message-Id: <20241106030728.553238-1-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Paolo and all,

Is it necessary to include the first patch (AVX10 cleanup/fix) in v9.2?

Others are for v10.0.

Compared with v4 [1],
 * patch 1 (AVX10 fix) and patch 9 (RAPL cleanup) are newly added.
 * rebased on commit 9a7b0a8618b1 ("Merge tag 'pull-aspeed-20241104' of
   https://github.com/legoater/qemu into staging").


Background and Introduction
===========================

This series picks cleanup from my previous kvmclock [2] (as other
renaming attempts were temporarily put on hold).

In addition, this series also include the cleanup on a historically
workaround, recent comment of coco interface [3] and error handling
corner cases in kvm_arch_init().

Avoiding the fragmentation of these misc cleanups, I consolidated them
all in one series and was able to tackle them in one go!

[1]: https://lore.kernel.org/qemu-devel/20240716161015.263031-1-zhao1.liu@intel.com/
[2]: https://lore.kernel.org/qemu-devel/20240329101954.3954987-1-zhao1.liu@linux.intel.com/
[3]: https://lore.kernel.org/qemu-devel/2815f0f1-9e20-4985-849c-d74c6cdc94ae@intel.com/

Thanks and Best Regards,
Zhao
---
Zhao Liu (11):
  i386/cpu: Mark avx10_version filtered when prefix is NULL
  target/i386/kvm: Add feature bit definitions for KVM CPUID
  target/i386/kvm: Remove local MSR_KVM_WALL_CLOCK and
    MSR_KVM_SYSTEM_TIME definitions
  target/i386/kvm: Only save/load kvmclock MSRs when kvmclock enabled
  target/i386/kvm: Save/load MSRs of kvmclock2
    (KVM_FEATURE_CLOCKSOURCE2)
  target/i386/kvm: Drop workaround for KVM_X86_DISABLE_EXITS_HTL typo
  target/i386/confidential-guest: Fix comment of
    x86_confidential_guest_kvm_type()
  target/i386/kvm: Clean up return values of MSR filter related
    functions
  target/i386/kvm: Return -1 when kvm_msr_energy_thread_init() fails
  target/i386/kvm: Clean up error handling in kvm_arch_init()
  target/i386/kvm: Replace ARRAY_SIZE(msr_handlers) with
    KVM_MSR_FILTER_MAX_RANGES

 hw/i386/kvm/clock.c              |   5 +-
 target/i386/confidential-guest.h |   2 +-
 target/i386/cpu.c                |   6 +-
 target/i386/cpu.h                |  25 ++++
 target/i386/kvm/kvm.c            | 211 +++++++++++++++++--------------
 5 files changed, 145 insertions(+), 104 deletions(-)

-- 
2.34.1


