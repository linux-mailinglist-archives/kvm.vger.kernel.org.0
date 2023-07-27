Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD0E7764634
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 07:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbjG0Fvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 01:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232047AbjG0Fv1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 01:51:27 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0365D2129;
        Wed, 26 Jul 2023 22:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690437053; x=1721973053;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6tVc4JDa/y31/t4vmR1KpWvG+69Czf6nIN4vbMNzhr0=;
  b=TDEB3WZKcVtubwdJ+2NLBO+x1zaDkLlZSElkKzt9hUCrl+OOkIqMueAo
   p4HjwR+t0oOPDiFgByESvnFSx8YE7Y1DlgZ01KUN7FlEqM6WcaiNS98DP
   v5HcmHI4L4NQGoD/dfWYe4hEKbeQEGO3idkdjZIjD6licmWMimy4p+aSs
   stxjONMZGcVJu7YqLkAJ0j/ze2WhKzOt3R1S5f6eBXsxLNohKI2V7S2bG
   09IyqUPK2fDzvRsC1waPIP+wHuRUYMQgQMruR1h1KPELSM6wz4Dtt+31i
   r3OjlOa39RpoiqEZWgribteyo+cbOigshW5MxghMq2kzWvBQxoAtKPjYl
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="399152454"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="399152454"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 22:50:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="840585249"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="840585249"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jul 2023 22:50:46 -0700
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
Subject: [PATCH v2 00/12] iommu: Prepare to deliver page faults to user space
Date:   Thu, 27 Jul 2023 13:48:25 +0800
Message-Id: <20230727054837.147050-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a user-managed page table is attached to an IOMMU, it is necessary
to deliver IO page faults to user space so that they can be handled
appropriately. One use case for this is nested translation, which is
currently being discussed in the mailing list.

I have posted a RFC series [1] that describes the implementation of
delivering page faults to user space through IOMMUFD. This series has
received several comments on the IOMMU refactoring, which I have
addressed in this series.

The major refactoring includes:

- [PATCH 01 ~ 03] Move include/uapi/linux/iommu.h to
  include/linux/iommu.h. Remove the unrecoverable fault data definition.
- [PATCH 04 ~ 07] Remove iommu_[un]register_device_fault_handler().
- [PATCH 08 ~ 12] Separate SVA and IOPF. Make IOPF a generic page fault
  handling framework. 

This is also available at github [2]. I would appreciate your feedback
on this series.

[1] https://lore.kernel.org/linux-iommu/20230530053724.232765-1-baolu.lu@linux.intel.com/
[2] https://github.com/LuBaolu/intel-iommu/commits/preparatory-io-pgfault-delivery-v2

Change log:
v2:
 - Remove unrecoverable fault data definition as suggested by Kevin.
 - Drop the per-device fault cookie code considering that doesn't make
   much sense for SVA.
 - Make the IOMMU page fault handling framework generic. So that it can
   avaible for use cases other than SVA.

v1: https://lore.kernel.org/linux-iommu/20230711010642.19707-1-baolu.lu@linux.intel.com/

Lu Baolu (12):
  iommu: Move iommu fault data to linux/iommu.h
  iommu/arm-smmu-v3: Remove unrecoverable faults reporting
  iommu: Remove unrecoverable fault data
  iommu: Replace device fault handler with iommu_queue_iopf()
  iommu: Change the return value of dev_iommu_get()
  iommu: Make dev->fault_param static
  iommu: Remove iommu_[un]register_device_fault_handler()
  iommu: Prepare for separating SVA and IOPF
  iommu: Move iopf_handler() to iommu-sva.c
  iommu: Make iommu_queue_iopf() more generic
  iommu: Separate SVA and IOPF in Makefile and Kconfig
  iommu: Add helper to set iopf handler for domain

 include/linux/iommu.h                         | 196 +++++++++++++++---
 drivers/iommu/iommu-sva.h                     |  71 -------
 include/uapi/linux/iommu.h                    | 161 --------------
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  14 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  47 ++---
 drivers/iommu/intel/iommu.c                   |  19 +-
 drivers/iommu/intel/svm.c                     |   1 -
 drivers/iommu/io-pgfault.c                    |  90 +++-----
 drivers/iommu/iommu-sva.c                     |  47 ++++-
 drivers/iommu/iommu.c                         | 153 ++++----------
 MAINTAINERS                                   |   1 -
 drivers/iommu/Kconfig                         |   4 +
 drivers/iommu/Makefile                        |   3 +-
 drivers/iommu/intel/Kconfig                   |   1 +
 14 files changed, 314 insertions(+), 494 deletions(-)
 delete mode 100644 drivers/iommu/iommu-sva.h
 delete mode 100644 include/uapi/linux/iommu.h

-- 
2.34.1

