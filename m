Return-Path: <kvm+bounces-31262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 687A59C1CC1
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 13:18:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DBD981F23EBC
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 12:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC5501E7C2E;
	Fri,  8 Nov 2024 12:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ArSlH5Ao"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A9E1E6DE1
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 12:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731068270; cv=none; b=qvwh8tOorIL93QfDJJih8c6VxVeov06sxVCNQaQw/GLdESK4IkihOkA90T815XTorvO1lfKxw2kPJB5L/YNYiRyIig5foeG1S1tVTJ+UZ1y7AR9ZPFrprkNb9im5H//R9ZGiFe+pUF8MnQ6Xcg5UiqWidzZX/oDbOdWZmiRFJyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731068270; c=relaxed/simple;
	bh=mSPtipbEVs7O5ulaADkUIZYSWoT2bEYJKW6PYIRtl/0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bJD65e/uRpEZoY3XoOJclAIGErwvX3fpj34ZrWzs9knA/MmMFLrHDDfjgwPMUVvCAEqCvJ2jFzWwlgDj6Cea6QiOtdeFGW8SViS46vCI4DKarzZYJ32jq+e21VU31vymrX3/l1YKSzzARfsId3rOfM9328BIfUzbAuj86npogg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ArSlH5Ao; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731068268; x=1762604268;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mSPtipbEVs7O5ulaADkUIZYSWoT2bEYJKW6PYIRtl/0=;
  b=ArSlH5AoRHu6wFrMIT2y8zuw4QAZQ6AIL3xFe1r7hjUFIfY+j+aiE9jD
   V8tZ1avVtSRUAN/ALU9DbDodKSvTt0/p2c/aX2nBAKvdRkN1CloriZqyu
   l3QSYFagsuhR1JFIP5SBIAkbCKqbJAasAwAkQc8l4i3UKkF/eaRbOMYRz
   98LZ0Zl4mjnj0zXSi6W02IvilIaTFZwN+bij8w7/n8ZZA5Ifg8q54KxIK
   QZRkrz16S7D6fa/iPFa3V4Zj08GdGAFXQKwjWU3Zyu2tf0PVfiJQGAI+j
   i5/PP68ipz+aG02zS7J9QJ0sBjRM9+iXMg0ZXCDczzNa9S902mFK9H54O
   w==;
X-CSE-ConnectionGUID: Qpe/X6UhQEiufQ9tGuqPKg==
X-CSE-MsgGUID: zvE3HFAISMGfjugsBTTdiQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="41560802"
X-IronPort-AV: E=Sophos;i="6.12,137,1728975600"; 
   d="scan'208";a="41560802"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2024 04:17:47 -0800
X-CSE-ConnectionGUID: eLheq2afQBmP5C13OixfUQ==
X-CSE-MsgGUID: PUH/MDBDSAKONsuotv1fvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,137,1728975600"; 
   d="scan'208";a="85865438"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa010.fm.intel.com with ESMTP; 08 Nov 2024 04:17:47 -0800
From: Yi Liu <yi.l.liu@intel.com>
To: alex.williamson@redhat.com,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com
Cc: joro@8bytes.org,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	vasant.hegde@amd.com,
	will@kernel.org
Subject: [PATCH v5 0/5] vfio-pci support pasid attach/detach
Date: Fri,  8 Nov 2024 04:17:37 -0800
Message-Id: <20241108121742.18889-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds the pasid attach/detach uAPIs for userspace to attach/detach
a PASID of a device to/from a given ioas/hwpt. Only vfio-pci driver is
enabled in this series. After this series, PASID-capable devices bound
with vfio-pci can report PASID capability to userspace and VM to enable
PASID usages like Shared Virtual Addressing (SVA).

Based on the discussion about reporting the vPASID to VM [1], it's agreed
that we will let the userspace VMM to synthesize the vPASID capability.
The VMM needs to figure out a hole to put the vPASID cap. This includes
the hidden bits handling for some devices. While, it's up to the userspace,
it's not the focus of this series.

This series first adds the helpers for pasid attach in vfio core and then
extends the device cdev attach/detach ioctls for pasid attach/detach. In the
end of this series, the IOMMU_GET_HW_INFO ioctl is extended to report the
PCI PASID capability to the userspace. Userspace should check this before
using any PASID related uAPIs provided by VFIO, which is the agreement in [2].
This series depends on the iommufd pasid attach/detach series [3].

The completed code can be found at [4], tested with a hacky Qemu branch [5].

[1] https://lore.kernel.org/kvm/BN9PR11MB5276318969A212AD0649C7BE8CBE2@BN9PR11MB5276.namprd11.prod.outlook.com/
[2] https://lore.kernel.org/kvm/4f2daf50-a5ad-4599-ab59-bcfc008688d8@intel.com/
[3] https://lore.kernel.org/linux-iommu/20241104132513.15890-1-yi.l.liu@intel.com/
[4] https://github.com/yiliu1765/iommufd/tree/iommufd_pasid
[5] https://github.com/yiliu1765/qemu/tree/wip/zhenzhong/iommufd_nesting_rfcv2-test-pasid

Change log:

v5:
 - Fix a wrong return value (Alex)
 - Fix the polic of setting the xend array per flag extension (Alex)
 - A separate patch to generalize the code of copy user data (Alex)

v4: https://lore.kernel.org/kvm/20241104132732.16759-1-yi.l.liu@intel.com/
 - Add acked-by for the ida patch from Matthew
 - Add r-b from Kevin and Jason on patch 01, 02 and 04 of v3
 - Add common code to copy user data for the user struct with new fields
 - Extend the VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT to support pasid, patch 03
   is updated per this change. Hence drop r-b of it. (Kevin, Alex)
 - Add t-b from Zhangfei for patch 4 of v3
 - Nits from Vasant

v3: https://lore.kernel.org/linux-iommu/20240912131729.14951-1-yi.l.liu@intel.com/
 - Misc enhancement on patch 01 of v2 (Alex, Jason)
 - Add Jason's r-b to patch 03 of v2
 - Drop the logic that report PASID via VFIO_DEVICE_FEATURE ioctl
 - Extend IOMMU_GET_HW_INFO to report PASID support (Kevin, Jason, Alex)

v2: https://lore.kernel.org/kvm/20240412082121.33382-1-yi.l.liu@intel.com/
 - Use IDA to track if PASID is attached or not in VFIO. (Jason)
 - Fix the issue of calling pasid_at[de]tach_ioas callback unconditionally (Alex)
 - Fix the wrong data copy in vfio_df_ioctl_pasid_detach_pt() (Zhenzhong)
 - Minor tweaks in comments (Kevin)

v1: https://lore.kernel.org/kvm/20231127063909.129153-1-yi.l.liu@intel.com/
 - Report PASID capability via VFIO_DEVICE_FEATURE (Alex)

rfc: https://lore.kernel.org/linux-iommu/20230926093121.18676-1-yi.l.liu@intel.com/

Regards,
	Yi Liu

Yi Liu (5):
  ida: Add ida_find_first_range()
  vfio-iommufd: Support pasid [at|de]tach for physical VFIO devices
  vfio: VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT support pasid
  vfio: Generalize the logic of copying user data for struct with
    extension
  iommufd: Extend IOMMU_GET_HW_INFO to report PASID capability

 drivers/iommu/iommufd/device.c | 24 +++++++++++-
 drivers/pci/ats.c              | 33 ++++++++++++++++
 drivers/vfio/device_cdev.c     | 62 +++++++++++++++++++++---------
 drivers/vfio/iommufd.c         | 50 ++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci.c    |  2 +
 drivers/vfio/vfio.h            | 18 +++++++++
 drivers/vfio/vfio_main.c       | 55 ++++++++++++++++++++++++++
 include/linux/idr.h            | 11 ++++++
 include/linux/pci-ats.h        |  3 ++
 include/linux/vfio.h           | 11 ++++++
 include/uapi/linux/iommufd.h   | 14 ++++++-
 include/uapi/linux/vfio.h      | 29 +++++++++-----
 lib/idr.c                      | 67 ++++++++++++++++++++++++++++++++
 lib/test_ida.c                 | 70 ++++++++++++++++++++++++++++++++++
 14 files changed, 419 insertions(+), 30 deletions(-)

-- 
2.34.1


