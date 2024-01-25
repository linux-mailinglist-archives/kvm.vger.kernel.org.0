Return-Path: <kvm+bounces-6897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C172883B737
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:40:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00D421C218DE
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 02:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47A9F6FC7;
	Thu, 25 Jan 2024 02:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TKyLXL2o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355786FA7
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 02:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706150424; cv=none; b=Ze2+BPJVbRAN0Vgf+8H5tYFExAqSp28VxCKto/DXE/SLUEhNkEAr5DkPBNx7ybXxtoleaLr29is3JcoNc5bRcwOLaOSFCD7+RHWqTImpgjrr9qmtcat/Nc+CsmOQFV/k4eXh5tkiIK4LvBLG6nqfAUkhVy6Klum9snq8F9Rnnl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706150424; c=relaxed/simple;
	bh=3933UFFK4+NnKWVMGTTstsPH7Q7r+J7R/gfhlP4cKH4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IcTKFmpOjBjIwfGQz7vXoRsfVbATU2L1ysNU+C2339AK1j7rIWWR5NxUm616MFbnMbvE03MA1aEA6TFeXco4DLlBi/Bu0XyChOUTgs3q9rvuUy7Z9Yr0RdMDmpsSheuAn7D1jvif33apLYyKQz/tiW6bWb2R3n3BNMbaCqABbnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TKyLXL2o; arc=none smtp.client-ip=192.55.52.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706150422; x=1737686422;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3933UFFK4+NnKWVMGTTstsPH7Q7r+J7R/gfhlP4cKH4=;
  b=TKyLXL2oEuA6P3+i/Sa+kVJz/TvQnVCzU/MjqdJj3NdEl/q/wxGFgdE5
   VmvFL3n3BN+YDXcPGHLn5MrHnWUyqdnjwyVBY4eK+/1sdX+Fgba11n2nV
   0qAiSCzZjYOfd2kQw9Taq47plXwP896DrUo4zCmioD1m1lyVZUuEc7ltj
   auTv7klTB7LHhrDmWiEUXEX9K9nlXbbPthx4dXV5gbjaMDnzcKZFEOTII
   Dp1FKh1fUKz9VjER3OQOaW/h77OuYHhQicD7843ddZayZrVCNXWgelEuI
   YNsLP9WDrN6WO+L08yjfnI8sUe2TK2pYNynSS2jCGwdGPgZypE5HGu4ty
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="401687447"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="401687447"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 18:40:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2120527"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa003.jf.intel.com with ESMTP; 24 Jan 2024 18:40:19 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com
Subject: [PATCH v3 0/3] i386: Minor fixes for building  CPUIDs
Date: Wed, 24 Jan 2024 21:40:13 -0500
Message-Id: <20240125024016.2521244-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The issue that fixed by Patch 1 looks fatal though it doesn't appear on
KVM because KVM always searches with assending order and hit with the
correct cpuid leaf 0.

Patch 2 removes the wrong constraint on CPUID leaf 1f.

Patch 3 fix the build of CPUID leaf 7.

Changes in v3:
- collect Reviewed-by tags;
- rebase to latest master branch
  4a4efae44f19 ("Merge tag 'pull-hex-20240121' of https://github.com/quic/qemu into staging")

v2:
https://lore.kernel.org/qemu-devel/20230613131929.720453-1-xiaoyao.li@intel.com/
Changes in v2:
- Add Patch 3;
- rebase to latest master branch

v1:
https://lore.kernel.org/qemu-devel/20220712021249.3227256-1-xiaoyao.li@intel.com/


Xiaoyao Li (3):
  i386/cpuid: Decrease cpuid_i when skipping CPUID leaf 1F
  i386/cpuid: Remove subleaf constraint on CPUID leaf 1F
  i386/cpuid: Move leaf 7 to correct group

 target/i386/kvm/kvm.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

-- 
2.34.1


