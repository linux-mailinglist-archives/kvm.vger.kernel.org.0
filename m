Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 234E579FF48
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236620AbjINJAJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236018AbjINJAI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:00:08 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF96CC7;
        Thu, 14 Sep 2023 02:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694682004; x=1726218004;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uN8KuX2E3zT70MY15JenTBxvRQFNjaVLVn3Ku4Z23X0=;
  b=lLFwGLrVlzl50eM+8Kin1RCV5TQtlgkiHhAwrURn5olD+gLq1vXwTVns
   peQIcnXO5qOmMlB7w40OJfJj49CNoM8RgPgJPiN+lCZYeDr7LXhj3O3kC
   EE9nxFnjh2LYiLeiQrI/QA4T5VqcIG1vEwjnaZpJvcSMIlmSuR+tffkib
   R+6kokgPAJfPS8VXKUt5Bp6haTx1N6WLL9nBlpezqGOjbt7u6bOQ0KZPQ
   MjeFV6GOrMKAIZIlY63SHlDP3uVni8Cqg80VFZMa97muJYqgN1L6a5mk5
   MQxFeKeAl54FdO3fxilzc+wtcc0A6/FXqRbbBkMFCBbuuPYBCeLMHIpG2
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="465266285"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="465266285"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 01:59:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="859612707"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="859612707"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga002.fm.intel.com with ESMTP; 14 Sep 2023 01:59:42 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
Cc:     Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v5 00/12] iommu: Prepare to deliver page faults to user space
Date:   Thu, 14 Sep 2023 16:56:26 +0800
Message-Id: <20230914085638.17307-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

This is also available at github [2]. I would appreciate your feedback
on this series.

[1] https://lore.kernel.org/linux-iommu/20230530053724.232765-1-baolu.lu@linux.intel.com/
[2] https://github.com/LuBaolu/intel-iommu/commits/preparatory-io-pgfault-delivery-v5

Change log:
v5:
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
  iommu: Consolidate per-device fault data management
  iommu: Improve iopf_queue_flush_dev()

 include/linux/iommu.h                         | 258 ++++++++---
 drivers/iommu/intel/iommu.h                   |   2 +-
 drivers/iommu/iommu-sva.h                     |  71 ---
 include/uapi/linux/iommu.h                    | 161 -------
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  14 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  51 +--
 drivers/iommu/intel/iommu.c                   |  25 +-
 drivers/iommu/intel/svm.c                     |   8 +-
 drivers/iommu/io-pgfault.c                    | 424 ++++++++++++------
 drivers/iommu/iommu-sva.c                     |  82 +++-
 drivers/iommu/iommu.c                         | 233 ----------
 MAINTAINERS                                   |   1 -
 drivers/iommu/Kconfig                         |   4 +
 drivers/iommu/Makefile                        |   3 +-
 drivers/iommu/intel/Kconfig                   |   1 +
 15 files changed, 571 insertions(+), 767 deletions(-)
 delete mode 100644 drivers/iommu/iommu-sva.h
 delete mode 100644 include/uapi/linux/iommu.h

-- 
2.34.1

