Return-Path: <kvm+bounces-41781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 753C6A6D496
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 08:08:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0AE587A4D13
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 07:07:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A5282505AA;
	Mon, 24 Mar 2025 07:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QtSybYKG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277BE2500DA
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 07:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742800123; cv=none; b=G5K/eR9D4zr1RMmS8zX3OCG4Xg501kHe7pD27bHQb0y6BMKyGNr8Xy9op7zGOs14zLQehEVmMmhzALhMTKD98UKRdA8kBBWkDxcPw/dgC/M+KvGNNdQq4dGk6yitLSVREWWN4yIkdknNKPV3ICqYJHWcVeDCa0wQ69IrzKymYYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742800123; c=relaxed/simple;
	bh=ANkPs0h4mhk6jy/bkiJEEPbEptITE5hW4KH1EhFBtXk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DKj8kHH/e0KrZfBLRGAY+qO6YOs4LyXEzVkzTAZpi3E8K8FJsJJbyyOYqJFU7x4syR7aBBh/3DcUFVxWM8XGwWoYW9LCCtFpECONKm8JWniZHrIv9vM2xBFq5fEFsbhv5ONElA1f9Tw5QoJmjgyxemdlFM48qlErC0Fd2BBTrB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QtSybYKG; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742800121; x=1774336121;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ANkPs0h4mhk6jy/bkiJEEPbEptITE5hW4KH1EhFBtXk=;
  b=QtSybYKGbipfYnXYBRB/Pczsj5N9QMtc7gxo5px1PKUi7/DsojxkqT6o
   yGdUr8qwFEq7qWd0lKHab/1yjEBPHsWXpY/tF0saV7hVSn53NsDYPzGMx
   nGuSSruPmDneK3OoIws5qPeRJpEwwn2vGq0qHA2iStBLUPtTQAfUl+XkC
   Ks9wsaUPxZuoVuxn4hVzK2W3aKg7Be1+lWa8/5My5phCVpXjQ1psRLtjM
   pxHXGKWVxxxtfBQVicRWxIINzikPJMFVFYF/s00Ky/U9ExASFUahdZdVb
   57g+HXo09WnVN1838JJTilZMHAAhtQU8KzWIE5NmY4FSP9BmepIDTrf/t
   w==;
X-CSE-ConnectionGUID: 3Fh4khAkSPKfHS5Mk1gdog==
X-CSE-MsgGUID: TkwTvFkqTsSqLd6WDp7LSg==
X-IronPort-AV: E=McAfee;i="6700,10204,11382"; a="31588449"
X-IronPort-AV: E=Sophos;i="6.14,271,1736841600"; 
   d="scan'208";a="31588449"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2025 00:08:40 -0700
X-CSE-ConnectionGUID: cBOFxVkVTkytqH8YnZ3tnA==
X-CSE-MsgGUID: //Xcw+dXToqFsjpHLZzwQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,271,1736841600"; 
   d="scan'208";a="123944311"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa007.fm.intel.com with ESMTP; 24 Mar 2025 00:08:37 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Mingwei Zhang <mizhang@google.com>,
	Das Sandipan <Sandipan.Das@amd.com>,
	Shukla Manali <Manali.Shukla@amd.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH 0/3] Enable x86 mediated vPMU
Date: Mon, 24 Mar 2025 12:37:09 +0000
Message-Id: <20250324123712.34096-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This small patch series enables the newly introduced KVM x86 mediated
vPMU solution. As KVM maintainer's suggestion, KVM mediated vPMU is
disabled by default unless user explicitly calls KVM_CAP_PMU_CAPABILITY
ioctl to enable it.

As for mediated vPMU, it's a new pass-through vPMU solution which is
designed to replace the legacy perf-based vPMU which has several
drawbacks, such as high performance overhead, hard to support new PMU
features, etc. Most of PMU MSRs except EVENTSELx are passed through to
guest in mediated vPMU. Currently the latest mediated vPMU patch series
is v3[1], the v4 patchset would be sent soon.

In this series, patch 1/3 introduces a helper
kvm_arch_pre_create_vcpu() which would be called before creating vCPU.
This patch comes from Xiaoyao's "QEMU TDX support" patchset[2]. Patch
2/3 leverages the patch 1/3 introduced helper to call
KVM_CAP_PMU_CAPABILITY ioctl to enable/disable KVM vPMU (mediated vPMU).
This patch is similar with patch 4/10 of Dongli's
"target/i386/kvm/pmu: PMU Enhancement, Bugfix and Cleanup" patchset[3],
but can be considered as an enhanced version. Patch 3/3 provides support
for newly introduced VMCS bit SAVE_IA32_PERF_GLOBAL_CTRL.

Tests:
  * Tests on Sapphire Rapids platform, both mediated vPMU and legacy
    perf-based vPMU can be enabled/disabled with "+/-pmu" option.

Ref:
[1] https://lore.kernel.org/all/20240801045907.4010984-1-mizhang@google.com/
[2] https://lore.kernel.org/all/20250124132048.3229049-8-xiaoyao.li@intel.com/
[3] https://lore.kernel.org/all/20250302220112.17653-5-dongli.zhang@oracle.com/  

Dapeng Mi (2):
  target/i386: Call KVM_CAP_PMU_CAPABILITY iotcl to enable/disable PMU
  target/i386: Support VMX_VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL

Xiaoyao Li (1):
  kvm: Introduce kvm_arch_pre_create_vcpu()

 accel/kvm/kvm-all.c        |  5 +++++
 include/system/kvm.h       |  1 +
 target/arm/kvm.c           |  5 +++++
 target/i386/cpu.c          | 12 ++++++++----
 target/i386/cpu.h          |  1 +
 target/i386/kvm/kvm.c      | 22 ++++++++++++++++++++++
 target/loongarch/kvm/kvm.c |  5 +++++
 target/mips/kvm.c          |  5 +++++
 target/ppc/kvm.c           |  5 +++++
 target/riscv/kvm/kvm-cpu.c |  5 +++++
 target/s390x/kvm/kvm.c     |  5 +++++
 11 files changed, 67 insertions(+), 4 deletions(-)


base-commit: 71119ed3651622e1c531d1294839e9f3341adaf5
-- 
2.40.1


