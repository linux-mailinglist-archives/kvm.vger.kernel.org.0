Return-Path: <kvm+bounces-31254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 739989C1C9A
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 13:04:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A61D91C22E06
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 12:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7629F38DC8;
	Fri,  8 Nov 2024 12:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KeZbZb/X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C4E1E47CE
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 12:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731067473; cv=none; b=b6aBZnnXAN3NDxSWyTk6e2qS+FU8mwUxdQFVsbZ5Smqsor3jWN+vuVe9mJUCpmxkjWzist3O3beQnTObao11QXPgKSlvNGsx18f1Hau+96mmr5nMwqLIslE0M8BU1HKquJPnAD/O2zKII+BT41+CyaThYNxjlVzmTlXDxvG98pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731067473; c=relaxed/simple;
	bh=BvuhGDkQ5Q/eUzXO09pJmHXIx5K3lL48DuqpFV4pfes=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uXzyF64f2cScQ3K3auYk+QmYhyFsxQd/dFMJRLuGpg8cnGnUuH9gQNR/B7diwf5mDQgQEynCyf7BXFXsxiiKQx5JGYj6tV3IQQTxudZRu0chQL4bCCAHrZmrjFfMZI+fa82pnALBn95rWQhs4Ydwz9f2yUU5+/4bgpP/KSkZGmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KeZbZb/X; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731067472; x=1762603472;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BvuhGDkQ5Q/eUzXO09pJmHXIx5K3lL48DuqpFV4pfes=;
  b=KeZbZb/XSo5Lgy3M5wbHneSbohWvTMXWz1D9Y65UN8tHDOosMeW1kMnW
   wQQ0hj8a7q5M6jNcQI+boQQlQdAGeAKssbKm5UxExRBXx/hdP/EkT8hgV
   ag/vOXgfmP2zN6im6CETy6lj7X/Xpr2YAz78Jcwh7Iw7aGIsINijD9vSc
   YTGR/rIitz+ez3YXCxM4RoOf87FtVFMs6thhaO8DeHxLoTwtHAd4dj/Rm
   n9bi5L559yca7vs822Qonrn1nAI51y4W75bMm7y30nY4AZEyc6iVyjXqJ
   CN/Dk15DUOSJSgymL6hfti6nKyMu8wOyV+DcuDFSK9U+Z7U9PWlfl8TkS
   Q==;
X-CSE-ConnectionGUID: QuH+zKldRnOt7HpJbZ0XRw==
X-CSE-MsgGUID: 2J/PeSd9Ru63vbNyFpgqrQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31116397"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31116397"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2024 04:04:30 -0800
X-CSE-ConnectionGUID: fv3my8bwRAe5kGPUoDC7kg==
X-CSE-MsgGUID: rPOg7a+GSmagIiPRkInLkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,137,1728975600"; 
   d="scan'208";a="85679015"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa008.fm.intel.com with ESMTP; 08 Nov 2024 04:04:29 -0800
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com
Cc: alex.williamson@redhat.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	vasant.hegde@amd.com,
	willy@infradead.org
Subject: [PATCH v4 0/7] Support attaching PASID to the blocked_domain
Date: Fri,  8 Nov 2024 04:04:20 -0800
Message-Id: <20241108120427.13562-1-yi.l.liu@intel.com>
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
[2] https://lore.kernel.org/linux-iommu/20241104131842.13303-1-yi.l.liu@intel.com/

v4:
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

 drivers/iommu/amd/iommu.c                   | 10 +++++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 12 ++++-----
 drivers/iommu/intel/iommu.c                 | 15 ++++++++---
 drivers/iommu/iommu.c                       | 28 +++++++++++++--------
 include/linux/iommu.h                       |  5 ----
 5 files changed, 44 insertions(+), 26 deletions(-)

-- 
2.34.1


