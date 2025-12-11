Return-Path: <kvm+bounces-65693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C64E5CB4C92
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:43:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BF19A3011F9E
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 05:43:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91EE3288502;
	Thu, 11 Dec 2025 05:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cNc5G96/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E958288C0E
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765431804; cv=none; b=Cp0poZaaI631xh872MxG/I6dr9hZ77yG7TXyBimxbl2rYEDs8UvUj9Rw+uDqo/ePid5msvHkYzAnPEr/m4UKRoIwDBrR0Lvvbl3iLBS3j0qdE9cTGt3WMXuIYlxm9E0doCnECncH4aUFFP89nze3PupNv+t+wBf43fVj6POMV14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765431804; c=relaxed/simple;
	bh=pXFlcf+ppR4o/U0dw6I5BODUXd5sp7/Yj1QR7z9CnuQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Xwn0Ba8AbU/A1pw/WApOu+0alNOkKOFv9E9uZeuKkSt/HluFNNA4VwumKZWq+rj50gK8Ngt28i+siyo1phFKT3A9IBP2n/47p2JEJ+9ilIV+9QNxYAfE1+3MXY1/DHztAqcRKUzdvSWHxqRGKCXoCKMmEnOQTO1gFhcLLhsi2dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cNc5G96/; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765431803; x=1796967803;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pXFlcf+ppR4o/U0dw6I5BODUXd5sp7/Yj1QR7z9CnuQ=;
  b=cNc5G96/jMV/jLDclUbvmJu+VchPAJ4rRejja7WFBq6H6A5VwbyBI8Go
   gfnQVpg3ukSZQp7iF4a78KW+JS12abqwHaWeCnuU+m03UOvv8zh1AvDxe
   KAxwzlyPdLigT1mJMF9dD00InAy3Uc85RvHNnY1532VEtlnc3FnvR0bR/
   IZFW8O+iXx46GIH0a2rFj1Fr4KSLa7kRknfrnstGVVeJhQxSSMymc/JFi
   SAG0cEhHiKR1YL7jsft2LySDw+2YhsryPd1q9RFDKydaoGhkPxVNF3ior
   y7oomy8H/YWQM1guZMiLhYN1vJ/mJlHpLUhLL0fgNn1vaM2ZFXfZSUieQ
   w==;
X-CSE-ConnectionGUID: hoDDBg9fR0mljSDKbjId6A==
X-CSE-MsgGUID: kmf9q3+GQeeP3o0XBx2QKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="66409797"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="66409797"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 21:43:22 -0800
X-CSE-ConnectionGUID: yxu5aCrBSQekia2n3OGaDQ==
X-CSE-MsgGUID: nrYeIYWSTzSpC0BafUwIEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227365980"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 10 Dec 2025 21:43:18 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>,
	Xin Li <xin@zytor.com>,
	John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v5 00/22] i386: Support CET for KVM
Date: Thu, 11 Dec 2025 14:07:39 +0800
Message-Id: <20251211060801.3600039-1-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This the v4 series to support CET (CET-SHSTK & CET-IBT) in QEMU, which
is based on the master branch at the commit 05f36f7c0512c ("Update
version for v10.2.0-rc2 release"). And you can also find the code here:

https://gitlab.com/zhao.liu/qemu/-/tree/i386-all-for-dmr-v2.1-12-10-2025

Compared to v4 [1], v5 continues to use host_cpuid for KVM's xstate
initialization and simplify the migration check for PL0_SSP MSR.

Thanks for your review!

Overview
========

Control-flow enforcement technology includes 2 x86-architectural
features:
 - CET shadow stack (CET-SHSTK or CET-SS).
 - CET indirect branch tracking (CET-IBT).

Intel has implemented both 2 features since Sapphire Rapids (P-core) &
Sierra Forest (E-core).

AMD also implemented shadow stack since Zen3 [2] - this series has
considerred only-shstk case and is supposed to work on AMD platform, but
I hasn't tested this on AMD.

The basic CET support (patch 11-19) includes:
 * CET-S & CET-U supervisor xstates support.
 * CET CPUIDs enumeration.
 * CET MSRs save & load.
 * CET guest SSP register (KVM treats this as a special internal
   register - KVM_REG_GUEST_SSP) save & load.
 * Vmstates for MSRs & guest SSP.

But before CET support, there's a lot of cleanup work needed for
supervisor xstate.

Before CET-S/CET-U, QEMU has already supports arch lbr as the 1st
supervisor xstate. Although arch LBR has not yet been merged into KVM
(still planned), this series cleans up supervisor state-related support
and avoids breaking the current arch LBR in QEMU - that's what patch
2-10 are doing.

Additionally, besides KVM, this series also supports CET for TDX.

Change Log
==========

Changes Since v4:
 - Drop previous patch "i386/kvm: Initialize x86_ext_save_areas[] based
   on KVM support", and continue to use host_cpuid to initialize
   x86_ext_save_areas[].
 - For migration, check whether pl0_ssp is in-use instead of checking
   FRED & CET-SHSTK CPUIDs.
 - Polish commit message of patch 6 "i386/cpu: Use x86_ext_save_areas[]
   for CPUID.0XD subleaves".

Changes Since v3:
 - Fill CPUID 0xD subleaves from KVM CPUID instead of host CPUID for
   non-dynamic xstates (i.e., except AMX xstates for now).
 - Save/restore/migrate MSR_IA32_PL0_SSP for FRED.
 - Fix migratable_flags for FEAT_XSAVE_XSS_LO.
 - Refine commit message for CET TDX support.

[1]: https://lore.kernel.org/qemu-devel/20251118034231.704240-1-zhao1.liu@intel.com/
[2]: https://lore.kernel.org/all/20250908201750.98824-1-john.allen@amd.com/

Thanks and Best Regards,
Zhao
---
Chao Gao (1):
  i386/cpu: Fix supervisor xstate initialization

Chenyi Qiang (1):
  i386/tdx: Add CET SHSTK/IBT into the supported CPUID by XFAM

Xin Li (Intel) (2):
  i386/cpu: Save/restore SSP0 MSR for FRED
  i386/cpu: Migrate MSR_IA32_PL0_SSP for FRED and CET-SHSTK

Yang Weijiang (5):
  i386/cpu: Enable xsave support for CET states
  i386/kvm: Add save/restore support for CET MSRs
  i386/kvm: Add save/restore support for KVM_REG_GUEST_SSP
  i386/machine: Add vmstate for cet-shstk and cet-ibt
  i386/cpu: Advertise CET related flags in feature words

Zhao Liu (13):
  i386/cpu: Clean up indent style of x86_ext_save_areas[]
  i386/cpu: Clean up arch lbr xsave struct and comment
  i386/cpu: Reorganize arch lbr structure definitions
  i386/cpu: Make ExtSaveArea store an array of dependencies
  i386/cpu: Add avx10 dependency for Opmask/ZMM_Hi256/Hi16_ZMM
  i386/cpu: Use x86_ext_save_areas[] for CPUID.0XD subleaves
  i386/cpu: Reorganize dependency check for arch lbr state
  i386/cpu: Drop pmu check in CPUID 0x1C encoding
  i386/cpu: Add missing migratable xsave features
  i386/cpu: Add CET support in CR4
  i386/cpu: Mark cet-u & cet-s xstates as migratable
  i386/cpu: Enable cet-ss & cet-ibt for supported CPU models
  i386/tdx: Fix missing spaces in tdx_xfam_deps[]

 target/i386/cpu.c     | 256 +++++++++++++++++++++++++++++-------------
 target/i386/cpu.h     | 107 ++++++++++++++----
 target/i386/helper.c  |  12 ++
 target/i386/kvm/kvm.c | 117 +++++++++++++++++++
 target/i386/kvm/tdx.c |  20 ++--
 target/i386/machine.c |  75 +++++++++++++
 6 files changed, 478 insertions(+), 109 deletions(-)

-- 
2.34.1


