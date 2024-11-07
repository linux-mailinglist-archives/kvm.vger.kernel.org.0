Return-Path: <kvm+bounces-31099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19D7A9C0599
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 13:22:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D4991C22358
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 12:22:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CF4320EA2B;
	Thu,  7 Nov 2024 12:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f7o8Q35r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7071DEFDC
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 12:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730982158; cv=none; b=Aqa+uaYQoBvTxFLbWZwLgygRb4zL2atoEdUgk456s/kvjY1wpR9Nq0J6h0H6fpvEN1iVKBnaB9/QoEufy8Q9uHccR2apv9DTz7Kn9EWSJ4kfOZrIUzbakOHYaPiNEFGQVTpwnfp16bABR8KB1SxP50vkRAf0UQZo97p2bPnIKm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730982158; c=relaxed/simple;
	bh=vKcPy8x+xr12gREMVAeGy3EcoRHRvUaDxzF6iVUvqrA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fh0olR26hPY5fN4PcZ8qTF3y0y6Kw7XjEx/VnwxDLDBwfFCX9t7D0/XpU9d9w4u7xyKgQ21duqyGBOCF1AL9bZukgXRZkNKoTU+Ap/9lWjQfFXrEn4w1kdagzLEf1OOyn4BS7gz/JfGfzzBTZZ7k/HqB+oRpkkzHcmPl6dKN6BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f7o8Q35r; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730982156; x=1762518156;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vKcPy8x+xr12gREMVAeGy3EcoRHRvUaDxzF6iVUvqrA=;
  b=f7o8Q35rOA0jGN5sYcoGOK7yJ0jsexqCNOgNlxDLEL+fhwHoCBjoGmi2
   7xj+ncZXgT7nOsNx+T8ARTKZ4yrm2KXOr/bEcOT0KBhLxu/34jeze4S4h
   iJ4NYhb9+Ha5A/yxAAs4V0ILW4EPBXsuP+7dK4qQ+pXwNXXdpPkwkKhI7
   KsvggwQMS+wFWzTmfiruiQnFgh535jy147ilw/jLClX+oGbZn7vcbCEFD
   1JK65c/J4Vy4MuERgz/I+DmNPtgk1FDfJ3hoQ5vdh5iaaNSMg0CLDsYXx
   q+w4DKMRVH6c4r7uz6pK+2w5B6znWT1heWWB5rmwfLh1e+/UlqN3T5YDa
   w==;
X-CSE-ConnectionGUID: hUfVZHaYTj+mjZ4nzOk+PA==
X-CSE-MsgGUID: pzJKMVhVQzCrRlyRocZ1Vg==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="34744565"
X-IronPort-AV: E=Sophos;i="6.12,265,1728975600"; 
   d="scan'208";a="34744565"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 04:22:35 -0800
X-CSE-ConnectionGUID: 3QSCXFx0TdCJC1wNlVNYdg==
X-CSE-MsgGUID: +ouvf0DwQeqTUuJxgyhT+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,265,1728975600"; 
   d="scan'208";a="90180540"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa004.jf.intel.com with ESMTP; 07 Nov 2024 04:22:36 -0800
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
Subject: [PATCH v6 00/13] Make set_dev_pasid op supporting domain replacement
Date: Thu,  7 Nov 2024 04:22:21 -0800
Message-Id: <20241107122234.7424-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This splits the preparation works of the iommu and the Intel iommu driver
out from the iommufd pasid attach/replace series. [1]

To support domain replacement, the definition of the set_dev_pasid op
needs to be enhanced. Meanwhile, the existing set_dev_pasid callbacks
should be extended as well to suit the new definition.

This series first passes the old domain to the set_dev_pasid op, and prepares
the Intel iommu set_dev_pasid callbacks (paging domain, identity domain, and
sva domain) for the new definition, add the missing set_dev_pasid callback
for the nested domain, makes ARM SMMUv3 set_dev_pasid op to suit the new
set_dev_pasid op definition, and in the end, claims the set_dev_pasid op support
domain replacement. The AMD set_dev_pasid callback is extended to fail if the
caller tries to do the domain replacement to meet the new definition of
set_dev_pasid op. AMD iommu driver would support it later per Vasant [2].

[1] https://lore.kernel.org/linux-iommu/20240412081516.31168-1-yi.l.liu@intel.com/
[2] https://lore.kernel.org/linux-iommu/fa9c4fc3-9365-465e-8926-b4d2d6361b9c@amd.com/

This is based on Joerg's next branch. Base commit: 75bc266cd1a6

v6:
 - Fix a 0day compiling issue (Baolu)
 - Refine the pasid replace helpers to compose new pasid entry and do a full
   copy instead of setting each fields in the pasid entry from the pasid table.
   This avoids transit the existing pasid entry multiple times. (Baolu)

v5: https://lore.kernel.org/linux-iommu/20241106154606.9564-1-yi.l.liu@intel.com/
 - Drop the nonsense function description in patch 02 of v4 (Kevin, Baulu)
 - Add the error message as the setup helpers in replace helpers (Kevin)
 - Check old domain id with the domain id in pasid entry within the replace helpers.
   Along with it, iommu_domain_did() is added (Kevin, Baolu)
 - Merge patch 05 and 09 of v4 and name the patch as consolidating the dev_pasid_info
   add/remove (Baolu)
 - Drop patch 10 of v4, hence patch 09 of v5 (Baolu, Kevin, Jason)
 - Add r-b tags from Baolu, Kevin, Vasant
 - Rebase on top of Joerg's next tree (75bc266cd1a6)

v4: https://lore.kernel.org/linux-iommu/20241104131842.13303-1-yi.l.liu@intel.com/
 - Fix a missing input argument modification in patch 01 (Nicolin)
 - Per Baolu's suggestion, this series does not extend the pasid setup helpers to
   handle domain replacement, instead it adds pasid replace helpers, hence
   drop patch 02 of v3 as it is no longer required in this series.
 - Add a new helper to consolidate the cache flush for the modifications to a
   present pasid entry (the fields other than P and SSADE)   (Baolu)
 - Update the set_dev_pasid op of intel identity domain to handle replacement
 - Consolidate the dev_pasid_info code of intel_svm_set_dev_pasid()
 - Add a separate set_dev_pasid callback for nested domain instead of sharing
   intel_iommu_set_dev_pasid()  (Baolu)
 - Drop patch 05 of v3 as Baolu has another patch that touches it.

v3: https://lore.kernel.org/linux-iommu/20241018055402.23277-1-yi.l.liu@intel.com/
 - Add Kevin and Jason's r-b to patch 01, 02, 04, 05 and 06 of v2
 - Add back the patch 03 of v1 to make the pasid setup helpers do all the pasid entry
   modification, hence the set_dev_pasid path is really rollback-less, which is spotted
   by Baolu.
 - Rename prepare_domain_attach_device() (Baolu)
 - Use unsigned int instead of u32 for flags (Baolu)
 - Remove a stale comment in arm_smmu_set_pasid (Will)

v2: https://lore.kernel.org/linux-iommu/20240912130427.10119-1-yi.l.liu@intel.com/
 - Make ARM SMMUv3 set_dev_pasid op support domain replacement (Jason)
 - Drop patch 03 of v1 (Kevin)
 - Multiple tweaks in VT-d driver (Kevin)

v1: https://lore.kernel.org/linux-iommu/20240628085538.47049-1-yi.l.liu@intel.com/

Regards,
        Yi Liu

Jason Gunthorpe (1):
  iommu/arm-smmu-v3: Make set_dev_pasid() op support replace

Yi Liu (12):
  iommu: Pass old domain to set_dev_pasid op
  iommu/vt-d: Add a helper to flush cache for updating present pasid
    entry
  iommu/vt-d: Refactor the pasid setup helpers
  iommu/vt-d: Add pasid replace helpers
  iommu/vt-d: Consolidate the struct dev_pasid_info add/remove
  iommu/vt-d: Add iommu_domain_did() to get did
  iommu/vt-d: Make intel_iommu_set_dev_pasid() to handle domain
    replacement
  iommu/vt-d: Limit intel_iommu_set_dev_pasid() for paging domain
  iommu/vt-d: Make intel_svm_set_dev_pasid() support domain replacement
  iommu/vt-d: Make identity_domain_set_dev_pasid() to handle domain
    replacement
  iommu/vt-d: Add set_dev_pasid callback for nested domain
  iommu: Make set_dev_pasid op support domain replacement

 drivers/iommu/amd/amd_iommu.h                 |   3 +-
 drivers/iommu/amd/pasid.c                     |   6 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |   5 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  12 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   2 +-
 drivers/iommu/intel/iommu.c                   | 174 +++++---
 drivers/iommu/intel/iommu.h                   |  34 ++
 drivers/iommu/intel/nested.c                  |  50 +++
 drivers/iommu/intel/pasid.c                   | 389 ++++++++++++++----
 drivers/iommu/intel/pasid.h                   |  22 +-
 drivers/iommu/intel/svm.c                     |  36 +-
 drivers/iommu/iommu.c                         |   3 +-
 include/linux/iommu.h                         |   5 +-
 13 files changed, 574 insertions(+), 167 deletions(-)

-- 
2.34.1


