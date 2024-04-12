Return-Path: <kvm+bounces-14394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 065F48A28F8
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:15:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3CE85B24366
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:15:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B68650243;
	Fri, 12 Apr 2024 08:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SyegOCkZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2704F1E5
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 08:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712909721; cv=none; b=ZNnE/sM/U5N86qYBsYQEy4jEre9Hydd+duYIlltI7uNDYs/Jw3LIjbLTaAymu7sZJp8rEurUHTYLYfp9lbSOoO8QojTZppHY+aXkFYg6oQdCxYifXvtVEdGLc94GFd/TcE3pM8ekahtAd1rZkevukBbjSts4bQffcnCOThCZznA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712909721; c=relaxed/simple;
	bh=A96vIGe9GCuLDcs7MBzDaJJicC2k0m8+GJjpYjTd4pk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HxqBg03o+t8u2DD8A1XLwT6zwQTmbTUkI0W5Cb+zkuducS2PdMXs1YN3ba1HPjmeCtGwbxHprZ1v5HFu1yl+K3aPPU1+zWKGhP3V0HTy0SSPriq2/uc/qp+UhSmngFH7z1PNQi0TnOcYNFuH64f4DeH+qkBFe/1BHyDwCWoJbBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SyegOCkZ; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712909719; x=1744445719;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=A96vIGe9GCuLDcs7MBzDaJJicC2k0m8+GJjpYjTd4pk=;
  b=SyegOCkZekSscmFSyLuMMN6ao3kMYuOiSI3haMloNsPPCg0MZfWE89Qi
   q9ZfHeIM3YSm9mU4+jVJweOXxdv8mPeD/zxKSuzGXcY54IPlthnHaTc3y
   LSdGVw3OCNWoUkPK0ZMGt13rHFBfkZMW+nK1deDu3ApUr2257bsNPFQQf
   65JXPg1kbIVv3GHZz6y7H6qlBKdhB53J1dGu5yqno1oY7LZRsLD9lkKB9
   YZvnuR7cxsyNZuxO9FXhyCVXwPUeNiMPi43ne6IKTqVL89Q8dYNkMvCUF
   wGnIRna05WoeVXjNxRY+bqmASfvlu4pH6Dvt9Qu9oZraMntJHXS1N+Uxe
   A==;
X-CSE-ConnectionGUID: H5DLyhqNTdSX+rqZgU5Awg==
X-CSE-MsgGUID: zqrZOruyT5m/k0Rrbuf+pg==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8465030"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="8465030"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 01:15:19 -0700
X-CSE-ConnectionGUID: 34iY/ygFTyub4++2MPhAQg==
X-CSE-MsgGUID: fziQ+LEJRoao7FR1w84OLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="52137751"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa002.jf.intel.com with ESMTP; 12 Apr 2024 01:15:17 -0700
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com
Cc: alex.williamson@redhat.com,
	robin.murphy@arm.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	jacob.jun.pan@intel.com
Subject: [PATCH v2 00/12] iommufd support pasid attach/replace
Date: Fri, 12 Apr 2024 01:15:04 -0700
Message-Id: <20240412081516.31168-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

PASID (Process Address Space ID) is a PCIe extension to tag the DMA
transactions out of a physical device, and most modern IOMMU hardwares
have supported PASID granular address translation. So a PASID-capable
device can be attached to multiple hwpts (a.k.a. domains), each attachment
is tagged with a pasid.

This series first fixes the gap of existing set_dev_pasid() callback for
supporting domain replacement, then a missing iommu API to replace domain
for a pasid. Based on the iommu pasid attach/replace/detach APIs, this
series adds iommufd APIs for device drivers to attach/replace/detach pasid
to/from hwpt per userspace's request, and adds selftest to validate the
iommufd APIs.

pasid attach/replace is mandatory on Intel VT-d given the PASID table
locates in the physical address space hence must be managed by the kernel,
both for supporting vSVA and coming SIOV. But it's optional on ARM/AMD
which allow configuring the PASID/CD table either in host physical address
space or nested on top of an GPA address space. This series only add VT-d
support as the minimal requirement.

The completed code can be found in below link [1]. Heads up! The existing
iommufd selftest was broken, there was a fix [2] to it, but not upstreamed
yet. If wants to run iommufd selftest, please apply that fix. Sorry for the
inconvenience.

[1] https://github.com/yiliu1765/iommufd/tree/iommufd_pasid
[2] https://lore.kernel.org/linux-iommu/20240111073213.180020-1-baolu.lu@linux.intel.com/

Change log:

v2:
 - Domain replace for pasid should be handled in set_dev_pasid() callbacks
   instead of remove_dev_pasid and call set_dev_pasid afteward in iommu
   layer (Jason)
 - Make xarray operations more self-contained in iommufd pasid attach/replace/detach
   (Jason)
 - Tweak the dev_iommu_get_max_pasids() to allow iommu driver to populate the
   max_pasids. This makes the iommufd selftest simpler to meet the max_pasids
   check in iommu_attach_device_pasid()  (Jason)

v1: https://lore.kernel.org/kvm/20231127063428.127436-1-yi.l.liu@intel.com/#r
 - Implemnet iommu_replace_device_pasid() to fall back to the original domain
   if this replacement failed (Kevin)
 - Add check in do_attach() to check corressponding attach_fn per the pasid value.

rfc: https://lore.kernel.org/linux-iommu/20230926092651.17041-1-yi.l.liu@intel.com/

Regards,
	Yi Liu

Lu Baolu (1):
  iommu/vt-d: Add set_dev_pasid callback for nested domain

Yi Liu (11):
  iommu: Pass old domain to set_dev_pasid op
  iommu: Introduce a replace API for device pasid
  iommufd: replace attach_fn with a structure
  iommufd: Support attach/replace hwpt per pasid
  iommu: Allow iommu driver to populate the max_pasids
  iommufd/selftest: Add set_dev_pasid and remove_dev_pasid in mock iommu
  iommufd/selftest: Add a helper to get test device
  iommufd/selftest: Add test ops to test pasid attach/detach
  iommufd/selftest: Add coverage for iommufd pasid attach/detach
  iommu/vt-d: Return if no dev_pasid is found in domain
  iommu/vt-d: Make intel_iommu_set_dev_pasid() to handle domain
    replacement

 drivers/iommu/intel/iommu.c                   |  29 ++-
 drivers/iommu/intel/iommu.h                   |   3 +
 drivers/iommu/intel/nested.c                  |  15 ++
 drivers/iommu/intel/svm.c                     |   3 +-
 drivers/iommu/iommu-priv.h                    |   3 +
 drivers/iommu/iommu.c                         | 102 ++++++++-
 drivers/iommu/iommufd/Makefile                |   1 +
 drivers/iommu/iommufd/device.c                |  43 ++--
 drivers/iommu/iommufd/iommufd_private.h       |  23 ++
 drivers/iommu/iommufd/iommufd_test.h          |  30 +++
 drivers/iommu/iommufd/pasid.c                 | 161 ++++++++++++++
 drivers/iommu/iommufd/selftest.c              | 198 ++++++++++++++++-
 include/linux/iommu.h                         |   2 +-
 include/linux/iommufd.h                       |   6 +
 tools/testing/selftests/iommu/iommufd.c       | 207 ++++++++++++++++++
 .../selftests/iommu/iommufd_fail_nth.c        |  28 ++-
 tools/testing/selftests/iommu/iommufd_utils.h |  78 +++++++
 17 files changed, 888 insertions(+), 44 deletions(-)
 create mode 100644 drivers/iommu/iommufd/pasid.c

-- 
2.34.1


