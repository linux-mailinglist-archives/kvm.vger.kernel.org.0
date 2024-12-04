Return-Path: <kvm+bounces-33009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A3DF69E3A1F
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 13:39:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F2E20B35060
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 12:29:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CED191A76A4;
	Wed,  4 Dec 2024 12:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aNLsk5aH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0B61AA78E
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 12:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733315373; cv=none; b=eZ8XoGjXecrFl18S+MeEuL/5CDO9SmQRfPPJ0ynofby70RaLVIdgl+nwIBVwtReccJlVm3VK/lI6Cgxuok48aCKg3bJ5yQzuG6QTVcPUlgZW6xX3AvL3rUonlYm2lG7Q3r5+8utLkOPlnfHT7qGsB1Q61BFBLOHg1BLwdO0RHyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733315373; c=relaxed/simple;
	bh=V+nUknRrLTJ0CW1BpdALPJwFkKmg8YyTovXwmu0gyFs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=U9+CLQFz6Cy3G86ViPMdetnPUe7vRc9nBXAwzwyzrW+hxReX2eX47MeTjbvGg0M+nZOMTTqeTB99InH4JF2Y2AKLb8xx8yNSZuohZ5mdIYxgAkdIuemqFxpFs+RcvpEr+QqgqdW6hCQEiWjezxh1onASwBLX5O5NCPVb/SKjYoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aNLsk5aH; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733315372; x=1764851372;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=V+nUknRrLTJ0CW1BpdALPJwFkKmg8YyTovXwmu0gyFs=;
  b=aNLsk5aHVMidMZG2KobXg8mP+JsbJEC2CBJinaoj4/Yq4ybh/CIXlE/k
   K3DX82b5Rl7yT/w1twNmu4AWerlegJpq7eoMkhmmJo23UNzvyKXf0b6B5
   yxdAFadIhLzSOfnQZ/94arHceMxpHOh74OeDYU1vME/kwxd1dStocvvjr
   l0j6Gja7tyVQCSSRmCTSHd8I92Y18kfY2eSFipBF15C3P8GDq0XUw08Qf
   LXAEWwFn0eY0rhu0gYSt1cSnEQ3P6onkmqIyND2aIyHJsBH6raUD9HZPM
   JNf77r29PZq5hAbQovFwupk2/DrzfADApYgs5n1YRN/ugcqQwah2FlhAU
   g==;
X-CSE-ConnectionGUID: g+dfYBNsRSygZJBxaBh5ig==
X-CSE-MsgGUID: 6aWoePpbRGyQx5RkJe1Mog==
X-IronPort-AV: E=McAfee;i="6700,10204,11276"; a="32937870"
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="32937870"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2024 04:29:31 -0800
X-CSE-ConnectionGUID: GJwp4111SDyxNWqxEmoJnA==
X-CSE-MsgGUID: baIjgCm0R8ORHcG/DCBRig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="93599058"
Received: from unknown (HELO 984fee00a4c6.jf.intel.com) ([10.165.58.231])
  by orviesa010.jf.intel.com with ESMTP; 04 Dec 2024 04:29:31 -0800
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com
Cc: eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	vasant.hegde@amd.com,
	will@kernel.org
Subject: [PATCH v6 0/7] Support attaching PASID to the blocked_domain
Date: Wed,  4 Dec 2024 04:29:21 -0800
Message-Id: <20241204122928.11987-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During the review of iommufd pasid series, Kevin and Jason suggested
attaching PASID to the blocked domain hence replacing the usage of
remove_dev_pasid() op [1]. This makes sense as it makes the PASID path
aligned with the RID path which attaches the RID to the blocked_domain
when it is to be blocked. To do it, it requires passing the old domain
to the iommu driver. This has been done in [2].

This series makes the Intel iommu driver, ARM SMMUv3 driver and AMD iommu
driver support attaching PASID to the blocked domain. And in the end remove
the remove_dev_pasid op from iommu_ops.

[1] https://lore.kernel.org/linux-iommu/20240816130202.GB2032816@nvidia.com/
[2] https://lore.kernel.org/linux-iommu/20241108021406.173972-1-baolu.lu@linux.intel.com/

v6:
 - Add Jason's r-b on patch 01.
 - Rebased on top of 6.13-rc1

v5: https://lore.kernel.org/linux-iommu/20241113134613.7173-1-yi.l.liu@intel.com/
 - Fix an issue spotted by Baolu in patch 01 of v4. The new version lifts the
   group check to be the first check, hence it can ensure a valid iommu_ops
   returned dev_iommu_ops(). Per this changes, it also removes the duplicated
   dev_has_iommu() check as group check can replace it. Due to the changes,
   drop the r-b tags on this patch.
 - Add Baolu's r-b tag.

v4: https://lore.kernel.org/linux-iommu/20241108120427.13562-1-yi.l.liu@intel.com/
 - Remove unnecessary braces in patch 02 (Vasant)
 - Minor tweaks to patch 01 and 03 (Kevin)
 - Add r-b tags from Jason, Vasant, Kevin

v3: https://lore.kernel.org/linux-iommu/20241104132033.14027-1-yi.l.liu@intel.com/
 - Add a patch to check remove_dev_pasid() in iommu_attach_device_pasid()
 - Split patch 01 of v2 into two patches, drop the r-b of this patch due the
   split.
 - Add AMD iommu blocked domain pasid support (Jason)
 - Remove the remove_dev_pasid op as all the iommu drivers that support pasid
   attach have supported attaching pasid to blocked domain.

v2: https://lore.kernel.org/linux-iommu/20241018055824.24880-1-yi.l.liu@intel.com/#t
 - Add Kevin's r-b
 - Adjust the order of patch 03 of v1, it should be the first patch (Baolu)

v1: https://lore.kernel.org/linux-iommu/20240912130653.11028-1-yi.l.liu@intel.com/

Regards,
	Yi Liu

Jason Gunthorpe (1):
  iommu/arm-smmu-v3: Make the blocked domain support PASID

Yi Liu (6):
  iommu: Prevent pasid attach if no ops->remove_dev_pasid
  iommu: Consolidate the ops->remove_dev_pasid usage into a helper
  iommu: Detaching pasid by attaching to the blocked_domain
  iommu/vt-d: Make the blocked domain support PASID
  iommu/amd: Make the blocked domain support PASID
  iommu: Remove the remove_dev_pasid op

 drivers/iommu/amd/iommu.c                   | 10 +++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 12 +++----
 drivers/iommu/intel/iommu.c                 | 15 ++++++---
 drivers/iommu/iommu.c                       | 35 +++++++++++++--------
 include/linux/iommu.h                       |  5 ---
 5 files changed, 48 insertions(+), 29 deletions(-)

-- 
2.34.1


