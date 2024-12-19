Return-Path: <kvm+bounces-34151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DE6CF9F7C7B
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 14:35:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC9887A2883
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 13:35:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EC6D221447;
	Thu, 19 Dec 2024 13:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AnPiVozH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FBF1171C
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 13:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734615339; cv=none; b=kgDzzF0yxnGyZzTQoFWcJefxVE6GVhTUXS929qlZqKA8liNUDyd2JFO2D+OvzSO49XpA8hq16u4ENN5bWinfEVAlXRjHZPKLP2vPGvrRP3LuRDyZkOOfRaQlbNvRiUkbTX6MSsb2S6eBbFyO9ixczLJF9Jib5dx+/d++VCrTq2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734615339; c=relaxed/simple;
	bh=a+kcOotsu2remWG9hdB3RZ6ij2v048zKRIQZ8lT5s5c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RhBeSJoC5gASoUumVk6UcvNyKGPn+Xrp7xpSNqiXbxnblngvzwjrmxh02DE5nwMYgPg/Lm5CHXK9bUOsKSRQ6JcGYJvZBWm3LhKQhhZMPYgYMnb/cLcJZh0Z/u/WxPuYOgrwr0LEwvbX5+pDyCxHrEVtheXYd4fJS2Ym7mCMoAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AnPiVozH; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734615337; x=1766151337;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=a+kcOotsu2remWG9hdB3RZ6ij2v048zKRIQZ8lT5s5c=;
  b=AnPiVozHnVHZqnqjJOG+SSDBzhobmyHg4npfBXopNl3Mt1gIb4dk28Xg
   gbw4RKVq2CT4NrCX3Ry4qG+Xk6MeJyTfLE0ykqpCcq7t4oARk4KVISs/k
   U+kNfnLZFyyfqSMJWr+YXIGC1LBhYFOU7gFy5ezcwd7SIQTiTF1EO76RY
   8l9BbazGbN/ckWnqeFPaIFz6WVPTYoPVAp46voXrKAkE2nPBzq+XFDy59
   SR6k+A0WPOcPIYb66Feh8CFtpoYM42Ib3oRUqZqHL4Vb3b1Up6gZ5JiwY
   f1bRPh3n2lKOsVOEB1UX/NJz46W0RAiRubMcamL+vibkpstg9aJoYp5yy
   A==;
X-CSE-ConnectionGUID: neyfx1IVSXWszK0sl4Hgqg==
X-CSE-MsgGUID: bKIuntzARK6BXoZO4ehJhQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11290"; a="60504295"
X-IronPort-AV: E=Sophos;i="6.12,247,1728975600"; 
   d="scan'208";a="60504295"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2024 05:35:37 -0800
X-CSE-ConnectionGUID: AsP+Wx8LQyO00bArTpNsnQ==
X-CSE-MsgGUID: hsDpbw3yQQ+WogtqeZIxZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="103197872"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa005.jf.intel.com with ESMTP; 19 Dec 2024 05:35:36 -0800
From: Yi Liu <yi.l.liu@intel.com>
To: alex.williamson@redhat.com,
	kevin.tian@intel.com
Cc: jgg@nvidia.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	yi.l.liu@intel.com,
	chao.p.peng@linux.intel.com,
	zhenzhong.duan@intel.com,
	willy@infradead.org,
	zhangfei.gao@linaro.org,
	vasant.hegde@amd.com
Subject: [PATCH v6 0/5] vfio-pci support pasid attach/detach
Date: Thu, 19 Dec 2024 05:35:29 -0800
Message-Id: <20241219133534.16422-1-yi.l.liu@intel.com>
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
[3] https://lore.kernel.org/linux-iommu/20241219132746.16193-1-yi.l.liu@intel.com/
[4] https://github.com/yiliu1765/iommufd/tree/iommufd_pasid
[5] https://github.com/yiliu1765/qemu/tree/wip/zhenzhong/iommufd_nesting_rfcv2-test-pasid

Change log:

v6:
 - Drop the vfio_copy_user_data() generalization as it is not totally clear
   what it would cover. (Alex)
 - Reworked the patch 03 of v5 a bit. e.g. lift the pasid_{at|de}tach_ioas op test
   before the second user data copy; make 'if (xend > minsz)' to be 'if (xend)'
   and remove the comment accordingly. This is because we don't generalize
   the user data copy now, so xend is either 0 or non-zero, no need to check
   against minsz.
 - Make the IOMMU_GET_HW_INFO report out_max_pasid_log2 by checking the
   dev->iommu->max_pasids. This is because iommu drivers enables PASID
   as long as it supports. So checking it is enough. Also, it is more friendly
   to non-PCI PASID supports compared with reading the PCI config space to
   check if PASID is enabled.
 - Add selftest coverage for reporting max_pasid_log2 in IOMMU_HW_INFO ioctl.

v5: https://lore.kernel.org/kvm/20241108121742.18889-1-yi.l.liu@intel.com/
 - Fix a wrong return value (Alex)
 - Fix the policy of setting the xend array per flag extension (Alex)
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
  iommufd: Extend IOMMU_GET_HW_INFO to report PASID capability
  iommufd/selftest: Add coverage for reporting max_pasid_log2 via
    IOMMU_HW_INFO

 drivers/iommu/iommufd/device.c                | 33 ++++++++-
 drivers/pci/ats.c                             | 33 +++++++++
 drivers/vfio/device_cdev.c                    | 60 +++++++++++++---
 drivers/vfio/iommufd.c                        | 50 +++++++++++++
 drivers/vfio/pci/vfio_pci.c                   |  2 +
 include/linux/idr.h                           | 11 +++
 include/linux/pci-ats.h                       |  3 +
 include/linux/vfio.h                          | 11 +++
 include/uapi/linux/iommufd.h                  | 14 +++-
 include/uapi/linux/vfio.h                     | 29 +++++---
 lib/idr.c                                     | 67 ++++++++++++++++++
 lib/test_ida.c                                | 70 +++++++++++++++++++
 tools/testing/selftests/iommu/iommufd.c       | 18 +++++
 .../selftests/iommu/iommufd_fail_nth.c        |  3 +-
 tools/testing/selftests/iommu/iommufd_utils.h | 17 +++--
 15 files changed, 396 insertions(+), 25 deletions(-)

-- 
2.34.1


