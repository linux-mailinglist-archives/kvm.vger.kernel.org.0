Return-Path: <kvm+bounces-3799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F253808100
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 07:48:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29E291F21256
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 06:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E073134C8;
	Thu,  7 Dec 2023 06:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WOEO+DRv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5ED137;
	Wed,  6 Dec 2023 22:47:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701931674; x=1733467674;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TiGWAFZ8wUXfH4a/f6Y2gaB+BMEAe3q7aJwlZyWhLdU=;
  b=WOEO+DRvq5Jb2PszcoiMHOZf0lPOOvwiG89KBH+wlpNrIv1HO1/X26ui
   cMm2V/v5tXT6ZhzBH1MwrYbZf8HGN3YBsTzc/NahUEWvOCVl+Q3AKAdvW
   5fP0ketN+MIGGNMq5diM2iXRgmxTfo+NhvXPUGI2mtpze6kz/U3zhRRFs
   1+fLMCo4vGJPVF4plga8ZUILzvhvicipgmSj+INgaoTqtHfZos83UYnEj
   zXLcidA1xx+6FlrIU05QDVCj2zoz1ONMUV9eaH2ubtxV70X/iaj+UDb+I
   IQumftfIoc/T6PtBelAFa9VW7EcLGY+C58B4xqTfQ80iYH/cv3MH/Af2I
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="1014877"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="1014877"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 22:47:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="771611314"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="771611314"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by orsmga002.jf.intel.com with ESMTP; 06 Dec 2023 22:47:48 -0800
From: Lu Baolu <baolu.lu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>
Cc: Yi Liu <yi.l.liu@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Longfang Liu <liulongfang@huawei.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v8 00/12] iommu: Prepare to deliver page faults to user space
Date: Thu,  7 Dec 2023 14:42:56 +0800
Message-Id: <20231207064308.313316-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a user-managed page table is attached to an IOMMU, it is necessary
to deliver IO page faults to user space so that they can be handled
appropriately. One use case for this is nested translation, which is
currently being discussed in the mailing list.

I have posted a RFC series [1] that describes the implementation of
delivering page faults to user space through IOMMUFD. This series has
received several comments on the IOMMU refactoring, which I am trying to
address in this series.

The major refactoring includes:

- [PATCH 01 ~ 04] Move include/uapi/linux/iommu.h to
  include/linux/iommu.h. Remove the unrecoverable fault data definition.
- [PATCH 05 ~ 06] Remove iommu_[un]register_device_fault_handler().
- [PATCH 07 ~ 10] Separate SVA and IOPF. Make IOPF a generic page fault
  handling framework.
- [PATCH 11 ~ 12] Improve iopf framework for iommufd use.

This is also available at github [2].

[1] https://lore.kernel.org/linux-iommu/20230530053724.232765-1-baolu.lu@linux.intel.com/
[2] https://github.com/LuBaolu/intel-iommu/commits/preparatory-io-pgfault-delivery-v8

Change log:

v8:
 - Drop PATCH 12/12 as it is no longer necessary to drain page requests page requests
   during PASID translation changes.
 - Separate PATCH 11/12 into two distinct patches. The first patch refines locking
   scheme for protecting per-device fault data, while the second patch replaces
   mutex with RCU to enhance locking efficiency.
 - PATCH 01 ~ 10 are in good shapes now.

v7: https://lore.kernel.org/linux-iommu/20231115030226.16700-1-baolu.lu@linux.intel.com/
 - Rebase to v6.7-rc1.
 - Export iopf_group_response() for global use.
 - Release lock when calling iopf handler.
 - The whole series has been verified to work for SVA case on Intel
   platforms by Zhao Yan. Add her Tested-by to affected patches.

v6: https://lore.kernel.org/linux-iommu/20230928042734.16134-1-baolu.lu@linux.intel.com/
 - [PATCH 09/12] Check IS_ERR() against the iommu domain. [Jingqi/Jason]
 - [PATCH 12/12] Rename the comments and name of iopf_queue_flush_dev(),
   no functionality changes. [Kevin]
 - All patches rebased on the latest iommu/core branch.

v5: https://lore.kernel.org/linux-iommu/20230914085638.17307-1-baolu.lu@linux.intel.com/
 - Consolidate per-device fault data management. (New patch 11)
 - Improve iopf_queue_flush_dev(). (New patch 12)

v4: https://lore.kernel.org/linux-iommu/20230825023026.132919-1-baolu.lu@linux.intel.com/
 - Merge iommu_fault_event and iopf_fault. They are duplicate.
 - Move iommu_report_device_fault() and iommu_page_response() to
   io-pgfault.c.
 - Move iommu_sva_domain_alloc() to iommu-sva.c.
 - Add group->domain and use it directly in sva fault handler.
 - Misc code refactoring and refining.

v3: https://lore.kernel.org/linux-iommu/20230817234047.195194-1-baolu.lu@linux.intel.com/
 - Convert the fault data structures from uAPI to kAPI.
 - Merge iopf_device_param into iommu_fault_param.
 - Add debugging on domain lifetime for iopf.
 - Remove patch "iommu: Change the return value of dev_iommu_get()".
 - Remove patch "iommu: Add helper to set iopf handler for domain".
 - Misc code refactoring and refining.

v2: https://lore.kernel.org/linux-iommu/20230727054837.147050-1-baolu.lu@linux.intel.com/
 - Remove unrecoverable fault data definition as suggested by Kevin.
 - Drop the per-device fault cookie code considering that doesn't make
   much sense for SVA.
 - Make the IOMMU page fault handling framework generic. So that it can
   available for use cases other than SVA.

v1: https://lore.kernel.org/linux-iommu/20230711010642.19707-1-baolu.lu@linux.intel.com/

Lu Baolu (12):
  iommu: Move iommu fault data to linux/iommu.h
  iommu/arm-smmu-v3: Remove unrecoverable faults reporting
  iommu: Remove unrecoverable fault data
  iommu: Cleanup iopf data structure definitions
  iommu: Merge iopf_device_param into iommu_fault_param
  iommu: Remove iommu_[un]register_device_fault_handler()
  iommu: Merge iommu_fault_event and iopf_fault
  iommu: Prepare for separating SVA and IOPF
  iommu: Make iommu_queue_iopf() more generic
  iommu: Separate SVA and IOPF
  iommu: Refine locking for per-device fault data management
  iommu: Use refcount for fault data access

 include/linux/iommu.h                         | 267 +++++++++---
 drivers/iommu/intel/iommu.h                   |   2 +-
 drivers/iommu/iommu-sva.h                     |  71 ---
 include/uapi/linux/iommu.h                    | 161 -------
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  14 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  51 +--
 drivers/iommu/intel/iommu.c                   |  25 +-
 drivers/iommu/intel/svm.c                     |   6 +-
 drivers/iommu/io-pgfault.c                    | 412 +++++++++++-------
 drivers/iommu/iommu-sva.c                     |  67 ++-
 drivers/iommu/iommu.c                         | 233 ----------
 MAINTAINERS                                   |   1 -
 drivers/iommu/Kconfig                         |   4 +
 drivers/iommu/Makefile                        |   3 +-
 drivers/iommu/intel/Kconfig                   |   1 +
 15 files changed, 551 insertions(+), 767 deletions(-)
 delete mode 100644 drivers/iommu/iommu-sva.h
 delete mode 100644 include/uapi/linux/iommu.h

-- 
2.34.1


