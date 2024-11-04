Return-Path: <kvm+bounces-30508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 947429BB5A2
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:18:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 197C31F224D8
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9325FEEBA;
	Mon,  4 Nov 2024 13:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QzZJl+pn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC4A33FE
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726325; cv=none; b=GQoafFBpQTDvwQg3L/YspCS8Yk/aFio0xTvL77SSm0JGYjLMKKW1rO5yYJNvtEIBJOUpRoV/CRxbYpLVAyylOzMbb4kbnc33jANkteFhalMkgfHO/2OpJJUAXldX2TjDhVB9Rp4TgYyEicaKhjUNt1Q/Iv4AWNUCg/x1mFdpO1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726325; c=relaxed/simple;
	bh=1qUnkso4ARRv59bwgKav8ae18iHCNhQFaR7poKIS/7U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JKCXO5OtiM7FVc0WoZ+bzvYm+MEhMHrPWuKapv0jtO3zcUfUnh8Oax3W+Tuy6swPS0uQJl85ZrkxnTCsLJZK2e8oeCcR3cqux8u6xj2NKXSkj1Iq8MKyo3WDXmNTxN96zwp9ATTCbXfijTTfPL3ZXHh0Ol6ylrCKqlaUvdWuMsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QzZJl+pn; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726324; x=1762262324;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1qUnkso4ARRv59bwgKav8ae18iHCNhQFaR7poKIS/7U=;
  b=QzZJl+pnZTx2LRTj1yyAF+804XO00urXDV2eFtRGl7YWCt2hfyLGjltk
   NCPs+on0LS/qMF0VHqzhT753Uvx0YatOOSb/WyAu0VW7IOnRjgxDT4/9y
   NDcPJgLxyyotDO6IQVUHdIo8wX4bNnLhgPUZ6F6eBEsFeLokE+orLLumZ
   zqMzqcggyfhh7Z70ICQsKXDLOwJjFkxQF5XYIt3I8sOnnIjR2lyAD0Hpc
   RLELcjWXwFpQyI2lN4MxvU25Vd0dyRuyQX6SE5jZCNRSgjUL39rQhUH0x
   uhbefDVRcFvR31GsQalsidiBXIB5hmv67GokKqnOo1oVIzke8HnNX2dOT
   A==;
X-CSE-ConnectionGUID: 6uDaiqSxSPGVfMMMvhrXqA==
X-CSE-MsgGUID: ootEl8EwTpmT9rWhLrdzEg==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="41003693"
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="41003693"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:18:43 -0800
X-CSE-ConnectionGUID: TKHWWIZcRsqOg7vvEG88Dg==
X-CSE-MsgGUID: +RhqVKseQxu6GDUDrkJQQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="83999456"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa010.fm.intel.com with ESMTP; 04 Nov 2024 05:18:43 -0800
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
	will@kernel.org
Subject: [PATCH v4 00/13] Make set_dev_pasid op supporting domain replacement
Date: Mon,  4 Nov 2024 05:18:29 -0800
Message-Id: <20241104131842.13303-1-yi.l.liu@intel.com>
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

v4:
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

Lu Baolu (1):
  iommu/vt-d: Add set_dev_pasid callback for nested domain

Yi Liu (11):
  iommu: Pass old domain to set_dev_pasid op
  iommu/vt-d: Add a helper to flush cache for updating present pasid
    entry
  iommu/vt-d: Refactor the pasid setup helpers
  iommu/vt-d: Add pasid replace helpers
  iommu/vt-d: Prepare intel_iommu_set_dev_pasid() handle replacement
  iommu/vt-d: Make intel_iommu_set_dev_pasid() to handle domain
    replacement
  iommu/vt-d: Limit intel_iommu_set_dev_pasid() for paging domain
  iommu/vt-d: Make identity_domain_set_dev_pasid() to handle domain
    replacement
  iommu/vt-d: Consolidate the dev_pasid code in
    intel_svm_set_dev_pasid()
  iommu/vt-d: Fail SVA domain replacement
  iommu: Make set_dev_pasid op support domain replacement

 drivers/iommu/amd/amd_iommu.h                 |   3 +-
 drivers/iommu/amd/pasid.c                     |   6 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |   5 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  12 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   2 +-
 drivers/iommu/intel/iommu.c                   | 137 +++++--
 drivers/iommu/intel/iommu.h                   |  13 +
 drivers/iommu/intel/nested.c                  |  43 ++
 drivers/iommu/intel/pasid.c                   | 374 ++++++++++++++----
 drivers/iommu/intel/pasid.h                   |  43 ++
 drivers/iommu/intel/svm.c                     |  32 +-
 drivers/iommu/iommu.c                         |   3 +-
 include/linux/iommu.h                         |   5 +-
 13 files changed, 530 insertions(+), 148 deletions(-)

-- 
2.34.1


