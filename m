Return-Path: <kvm+bounces-30545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D285B9BB614
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:28:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 103E01C21C31
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:28:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B185022092;
	Mon,  4 Nov 2024 13:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X2uVqRHF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51313376F1
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726855; cv=none; b=QlryE5UVh19YW9gnXKteBtRa6jnYn3zUwgNo3Hkg4DET2gTnrfg5pNPUpR+js0soj0Rr90CR/j3z+Wszw/c2VXRsVb49CvsLWDqWV1icKa6exg+I2oNrLKGOZKNjzVjXQ6VwcnYgGJ09k4cddVh0SwT5ipT/Dt3JO00URJJIq6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726855; c=relaxed/simple;
	bh=vMMiMnLwm1pr1E1U0ZFuxUFFBEGE7zRnGFsQvLeGIpI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=df09bjvNfMjPPy31Ldv3JWXNJllogcPTnwZSkS3RxpKEGaNbp6elVPc+f0sb0IPSewwEuS7y8EzExj67XF0F3BJySY9NVGKmb4LDH/kvYGh1WRuTyF3IhM+6zE+GyVghVaKXjqRy3xbbeasqQFiFZ9saBPT4CSv/eqyrvTWiEyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X2uVqRHF; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726855; x=1762262855;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vMMiMnLwm1pr1E1U0ZFuxUFFBEGE7zRnGFsQvLeGIpI=;
  b=X2uVqRHFDdfoFEMCtxuai/823ISXHSwLb7xZMoreepmioQQ2hdNwWxjb
   HnFMt4U6ANrRbfptv1bdR6L93IzyVGPUrIi2uGjBtetarG7rWHr5X2e4l
   nwY0M+hboi70xpd27GtIOhKfmFNDzViQvb71LdrgIX3xmQ9i1wyfFehqP
   srNjouSdNEmksJJU5snp3odwyzmJjQnrsA0Lxt9gwszx9nTjYsvN8PBRd
   QHQ0SziOQGuIR1j056DMKNn+VdEtmbzzkVszYxnIgMIBh4bciZjTCJfMa
   4eo97l2+E+Wby6XOSZKb9atWunU5WSeuBUK6zDriS6q2KkgJCQpbUqXPY
   w==;
X-CSE-ConnectionGUID: i+aXuy6rTgeote5xQ8NGSw==
X-CSE-MsgGUID: X5Sy1RQKQ9yIyseWRdv/XQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="47884557"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="47884557"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:27:34 -0800
X-CSE-ConnectionGUID: ic8el4U6TVy151hCJVWFiA==
X-CSE-MsgGUID: hm0xrezXTWOMp0k+Ed77Ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="84100895"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 04 Nov 2024 05:27:34 -0800
From: Yi Liu <yi.l.liu@intel.com>
To: alex.williamson@redhat.com,
	jgg@nvidia.com,
	kevin.tian@intel.com
Cc: joro@8bytes.org,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com,
	vasant.hegde@amd.com,
	willy@infradead.org
Subject: [PATCH v4 0/4] vfio-pci support pasid attach/detach
Date: Mon,  4 Nov 2024 05:27:28 -0800
Message-Id: <20241104132732.16759-1-yi.l.liu@intel.com>
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
[3] https://lore.kernel.org/linux-iommu/20240912131255.13305-1-yi.l.liu@intel.com/
[4] https://github.com/yiliu1765/iommufd/tree/iommufd_pasid
[5] https://github.com/yiliu1765/qemu/tree/wip/zhenzhong/iommufd_nesting_rfcv2-test-pasid

Change log:

v4:
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

Yi Liu (4):
  ida: Add ida_find_first_range()
  vfio-iommufd: Support pasid [at|de]tach for physical VFIO devices
  vfio: VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT support pasid
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


