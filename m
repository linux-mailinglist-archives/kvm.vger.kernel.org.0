Return-Path: <kvm+bounces-8521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 05534850C9A
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 02:28:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5FB45B21A82
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 01:28:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BCF31841;
	Mon, 12 Feb 2024 01:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GL0tqVT5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC55D10E5;
	Mon, 12 Feb 2024 01:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707701298; cv=none; b=r78/u1kIhy7dS6tasOJkPlD37LN93Qbp46KHADb/G7ZxhLu8OmgSGKCNGvjMDXq9ZS/DKtdJEOHSZbmiBjhjjpvwDGl6Gyy78NaNghQjb7SNJl8fhCgdo8J+QTPjtcSsgZRtyg2K9txOewFJtBzKhHVAwxKwaII+mB3tOBQYDVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707701298; c=relaxed/simple;
	bh=Vj9tWBzyhYg01gY2nL8DrgMrR8BhWqQi+l4G443eD+I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Lj7ahlnBc+VRUHNUS2Maa0rV3ujqkiGAVOek64WBeHA1119Uci3bm0p6bPvilF2h+CkrCFveEHPvnidLSwOoqTcPSPtXY9jnmdz5vHalAAfp4fF7Sj094NbzsPT0n0e+jd93JMTqbDgAqIVbWbZqvMQvi1346b4l81HxfZ3DEgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GL0tqVT5; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707701297; x=1739237297;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Vj9tWBzyhYg01gY2nL8DrgMrR8BhWqQi+l4G443eD+I=;
  b=GL0tqVT5qv9E3mkCOEz6hLJ2y3AIfCxXNpKAskVwDV7mP9lxt/FV7l0o
   zglf8U3emXJeQZnMzS+GPH4Qvzznik0hqF7nkUvHKQJ2GPcTcxszkiOD2
   5C8HFJNXmp2RUlI2zs35QaxNQMALqy3qg+65w+HZG/CNA6udtPtHZMjpv
   dncl+79RsyDJqChfIMkvW11nhsQXWjbmQRbMN0wH1R3iOZtjd16NubT/I
   A/4Kco88MeOgVrg94uiwBUsRHhgb//6J2kzYllJ6H1FM1GbsNbV8eFKzX
   aUL98+L2pTOukCBzMa+9pkLTjgfZa38BCRTZeCpGBE9K4lpJ+ORV7N/u+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10981"; a="5502046"
X-IronPort-AV: E=Sophos;i="6.05,261,1701158400"; 
   d="scan'208";a="5502046"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2024 17:28:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,261,1701158400"; 
   d="scan'208";a="7132136"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by orviesa005.jf.intel.com with ESMTP; 11 Feb 2024 17:28:11 -0800
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
	Joel Granados <j.granados@samsung.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v13 00/16] iommu: Prepare to deliver page faults to user space
Date: Mon, 12 Feb 2024 09:22:11 +0800
Message-Id: <20240212012227.119381-1-baolu.lu@linux.intel.com>
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
- [PATCH 11 ~ 16] Improve iopf framework.

This is also available at github [2].

[1] https://lore.kernel.org/linux-iommu/20230530053724.232765-1-baolu.lu@linux.intel.com/
[2] https://github.com/LuBaolu/intel-iommu/commits/preparatory-io-pgfault-delivery-v13

Change log:
v13:
 - Refine the comments for iopf_queue_remove_device().

v12: https://lore.kernel.org/linux-iommu/20240207013325.95182-1-baolu.lu@linux.intel.com/
 - Add Jason and Kevin's Reviewed-by tags.
 - Fix some minor comments.
 - No code change.

v11: https://lore.kernel.org/linux-iommu/20240130080835.58921-1-baolu.lu@linux.intel.com/
 - Cleanup IOMMU_PAGE_RESP_PASID_VALID flag bit.
 - Cleanup code comments.

v10: https://lore.kernel.org/linux-iommu/20240122054308.23901-1-baolu.lu@linux.intel.com/
  - Make iopf_group_response() return void, as nobody can do anything
    with the failure.
  - Make iommu_report_device_fault() automatically respond to
    unhandleable faults and change its return type to void.
  - PATCH 01 ~ 14 are in good shapes now.

v9: https://lore.kernel.org/linux-iommu/20231220012332.168188-1-baolu.lu@linux.intel.com/
  - Protecting the assignment of dev->iommu->fault_param with RCU.
  - Extending the fault parameter's lifetime to the entire path of iopf
    handling.
  - Since iopf_queue_flush_dev() can only be called before
    iopf_queue_remove_device(), there's no need to hold a reference
    count.
  - Improve iopf_queue_remove_device() as per Jason's comments on the
    device removal sequence from the iopf queue. This will likely
    require changes to the iommu drivers, which are supposed to be
    addressed in separate series.
  - Track the iopf_group as a whole instead of the last fault within the
    group to simplify the fault report and response paths.
  - PATCH 01 ~ 11 are in good shapes now.

v8: https://lore.kernel.org/linux-iommu/20231207064308.313316-1-baolu.lu@linux.intel.com/
 - Drop PATCH 12/12 as it is no longer necessary to drain page requests
   page requests during PASID translation changes.
 - Separate PATCH 11/12 into two distinct patches. The first patch
   refines locking scheme for protecting per-device fault data, while
   the second patch replaces mutex with RCU to enhance locking
   efficiency.
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

Lu Baolu (16):
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
  iommu: Improve iopf_queue_remove_device()
  iommu: Track iopf group instead of last fault
  iommu: Make iopf_group_response() return void
  iommu: Make iommu_report_device_fault() return void

 include/linux/iommu.h                         | 262 +++++++---
 drivers/iommu/intel/iommu.h                   |   4 +-
 drivers/iommu/iommu-sva.h                     |  71 ---
 include/uapi/linux/iommu.h                    | 161 ------
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  14 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 103 ++--
 drivers/iommu/intel/iommu.c                   |  28 +-
 drivers/iommu/intel/svm.c                     |  41 +-
 drivers/iommu/io-pgfault.c                    | 473 ++++++++++--------
 drivers/iommu/iommu-sva.c                     |  71 ++-
 drivers/iommu/iommu.c                         | 233 ---------
 MAINTAINERS                                   |   1 -
 drivers/iommu/Kconfig                         |   4 +
 drivers/iommu/Makefile                        |   3 +-
 drivers/iommu/intel/Kconfig                   |   1 +
 15 files changed, 583 insertions(+), 887 deletions(-)
 delete mode 100644 drivers/iommu/iommu-sva.h
 delete mode 100644 include/uapi/linux/iommu.h

-- 
2.34.1


