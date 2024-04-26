Return-Path: <kvm+bounces-16034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AEC28B3489
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 11:53:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E50061F21F61
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 09:53:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1285B13FD9B;
	Fri, 26 Apr 2024 09:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bZ/vdlJN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F4E13F01A
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 09:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714125196; cv=none; b=H5Dtcl1V1Vxz5z1HPfonaGXobPlro0Jn7lFgih6gcjOdeHuvxXmFG8zusdLypDu0hZEVUh6Ha+vXDCKW8ZNkEDS/WwzTeplvGsHAthTfmB206QN+0ABijPT4hTqzFMzjkg+Wg5pRWqmXhskmHtGf1wKjvRsy4JAVnnwOxOkwF7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714125196; c=relaxed/simple;
	bh=E9y0ouKgRHJUrYk5UOAoNkTFABGlYO3ABnD02c+UMAo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fy9Suct4SSGqdAPlkldioKiVc9tybttxotw2OBDrQV2H5OEortq8SLMND+9h0pXh21FaewUkWY+myZAuFZc818PFMcnS5Sv580Oz0zYAmUUD8T8nXQ76TEgxTmAkO/MBwdCji/GkJJ/P7AUA5l6ub/IJXh74+cgd9vIOiU2z8QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bZ/vdlJN; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714125194; x=1745661194;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=E9y0ouKgRHJUrYk5UOAoNkTFABGlYO3ABnD02c+UMAo=;
  b=bZ/vdlJNRZRSd3Yem89mV1xq3Sx+hjW4QlMAEiP7fYVuoTWt9KJLC0Fz
   lF6k1T9X9CQIRRtOPxRUpoMDdz5JcGBaIQRaritXok8RayOb2FntDov38
   KLvg6Y76+Yg/qFtTAgShJuXKmDLmaw+5Tq3y9ukCMD3903H+sUFBOkv3e
   Yv9i8lPj3y7JVpIJJDfzYYzeGB+7K5mE4jMPm7V0UO6ABFUhV+Sq91VdM
   2QK7XvVmXWHQnzCvR9ABk9uH9JxyrGflyxOKumiViGtQ/tGR7w6a5PMgN
   HO6DaA5nLmT+cRT+Di2gfULqfGEfEQiok73M3veJXshzRZ54QJ1Rtht/U
   g==;
X-CSE-ConnectionGUID: QbBOP6F1QHeda6vqxhofQQ==
X-CSE-MsgGUID: etzSV7LiS4iwY4u/hkPL8g==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="9707388"
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="9707388"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 02:53:13 -0700
X-CSE-ConnectionGUID: oXA6v3ANRO2eAg0wjrVjpw==
X-CSE-MsgGUID: LObeRvk2Spat6yC1YZiUZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="25412307"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa008.fm.intel.com with ESMTP; 26 Apr 2024 02:53:10 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH 0/6] target/i386: Misc cleanup on KVM PV defs and outdated comments
Date: Fri, 26 Apr 2024 18:07:09 +0800
Message-Id: <20240426100716.2111688-1-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series picks cleanup from my previous kvmclock [1] (as other
renaming attempts were temporarily put on hold).

In addition, this series also include the cleanup on a historically
workaround and recent comment of coco interface [2].

Avoiding the fragmentation of these misc cleanups, I consolidated them
all in one series and was able to tackle them in one go!

[1]: https://lore.kernel.org/qemu-devel/20240329101954.3954987-1-zhao1.liu@linux.intel.com/
[2]: https://lore.kernel.org/qemu-devel/2815f0f1-9e20-4985-849c-d74c6cdc94ae@intel.com/

Thanks and Best Regards,
Zhao
---
Zhao Liu (6):
  target/i386/kvm: Add feature bit definitions for KVM CPUID
  target/i386/kvm: Remove local MSR_KVM_WALL_CLOCK and
    MSR_KVM_SYSTEM_TIME definitions
  target/i386/kvm: Only Save/load kvmclock MSRs when kvmclock enabled
  target/i386/kvm: Save/load MSRs of kvmclock2
    (KVM_FEATURE_CLOCKSOURCE2)
  target/i386/kvm: Drop workaround for KVM_X86_DISABLE_EXITS_HTL typo
  target/i386/confidential-guest: Fix comment of
    x86_confidential_guest_kvm_type()

 hw/i386/kvm/clock.c              |  5 +--
 target/i386/confidential-guest.h |  2 +-
 target/i386/cpu.h                | 25 +++++++++++++
 target/i386/kvm/kvm.c            | 63 +++++++++++++++++++-------------
 4 files changed, 66 insertions(+), 29 deletions(-)

-- 
2.34.1


