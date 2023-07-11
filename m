Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB81474E2F4
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 03:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbjGKBIi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 21:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjGKBIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 21:08:37 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC6A194;
        Mon, 10 Jul 2023 18:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689037716; x=1720573716;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=X6HARK8d7O3/CsqjXmQ+dxc6FJwEi+B6duwTtCj4/ZQ=;
  b=B/oUzrvksvmPaANnyqdUm2329rW6ukl7R/AnkPGVyZhs9ksuYlAhjOn5
   RQY9cbOe8fNM4yFGp2qc1zh63H5QOwHbGjdkryBMRM5LXPTnBB2jiw9k4
   r0Puv/H3/iIp4HWNrRRbiGO5xeRXTbMqe9XrgtSlaKaOQ91XxUNTxudYw
   BBYtJjt7AB+0uH4uKfp7ma67KtpIXhyPro85P5xZuPKVlabXUWHHZ5yPj
   6iyYiwpuEOEwFlMPK4I2ovZ62bwCVNMnQhol/BuzBunPkdFUhkqnx9F4q
   dA0BhF7PcqKjObe3ZihFQM5Y6MfLRSorwgm0lYcK4adW7sZ7+9l2csePB
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="344816038"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="344816038"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2023 18:08:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="810999790"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="810999790"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Jul 2023 18:08:32 -0700
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
Subject: [PATCH 0/9] iommu: Prepare to deliver page faults to user space
Date:   Tue, 11 Jul 2023 09:06:33 +0800
Message-Id: <20230711010642.19707-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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

- Removing include/uapi/linux/iommu.h.
- Removing iommu_[un]register_device_fault_handler().
- Making fault_param always available between iommu device probe and
  release.
- Using fault cookie to store temporary data used for processing faults.

This is also available at github [2]. I would appreciate your feedback
on this series.

[1] https://lore.kernel.org/linux-iommu/20230530053724.232765-1-baolu.lu@linux.intel.com/
[2] https://github.com/LuBaolu/intel-iommu/commits/preparatory-io-pgfault-delivery-v1

Best regards,
baolu

Lu Baolu (9):
  iommu: Move iommu fault data to linux/iommu.h
  iommu: Add device parameter to iopf handler
  iommu: Add common code to handle IO page faults
  iommu: Change the return value of dev_iommu_get()
  iommu: Make fault_param generic
  iommu: Remove iommu_[un]register_device_fault_handler()
  iommu: Add helper to set iopf handler for domain
  iommu: Add iommu page fault cookie helpers
  iommu: Use fault cookie to store iopf_param

 include/linux/iommu.h                         | 206 +++++++++++++++---
 drivers/iommu/iommu-sva.h                     |   8 +-
 include/uapi/linux/iommu.h                    | 161 --------------
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  13 +-
 drivers/iommu/intel/iommu.c                   |  18 +-
 drivers/iommu/io-pgfault.c                    |  55 +++--
 drivers/iommu/iommu-sva.c                     |   2 +-
 drivers/iommu/iommu.c                         | 199 ++++++++---------
 MAINTAINERS                                   |   1 -
 9 files changed, 320 insertions(+), 343 deletions(-)
 delete mode 100644 include/uapi/linux/iommu.h

-- 
2.34.1

