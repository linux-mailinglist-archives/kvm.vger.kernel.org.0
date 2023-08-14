Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2325577AF29
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 03:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbjHNBVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Aug 2023 21:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbjHNBUa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Aug 2023 21:20:30 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66FF71BD;
        Sun, 13 Aug 2023 18:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691976029; x=1723512029;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oe335Nlu8sc5VS5G7ofG+VOn5WK1MFpLS3mlAGuCpFo=;
  b=AmYB/mjLC5wgRSySM/rffrDcf5e+ITBfHXj28s9lrfuvIj0z52aZKMaA
   Ps5zEFr+Dx4o58D1CYXui18MRMfkVHSRYBasyEQueWuAffbZfMmFWW3VB
   RCf6nmC1zRu2lppk3DaB0TpkASusexmkSBwQ5EavBnJPQcbyQ+IbRKU6E
   qffxK+006HeR1aNTD8alhBGZwvKiWSZ8SPK6jOj2pIeRdsCVoUCMqrDUl
   RO+cq/UhXACCMp4FqzTm4nLwimq5Iv0af/P7xKqo7/IP/epNNJt8GAHbG
   CPDMfRdXeslE6ijCXti9hRQeaFfHXwOYhWiND77DISroTIt5mgp5Cc528
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="375645291"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="375645291"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2023 18:20:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="726842289"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="726842289"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by orsmga007.jf.intel.com with ESMTP; 13 Aug 2023 18:20:25 -0700
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
Subject: [PATCH v2 0/3] iommu: Make pasid array per device
Date:   Mon, 14 Aug 2023 09:17:56 +0800
Message-Id: <20230814011759.102089-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PCI PASID enabling interface guarantees that the address space used
by each PASID is unique. This is achieved by checking that the PCI ACS
path is enabled for the device. If the path is not enabled, then the
PASID feature cannot be used.

    if (!pci_acs_path_enabled(pdev, NULL, PCI_ACS_RR | PCI_ACS_UF))
            return -EINVAL;

The PASID array is not an attribute of the IOMMU group. It is more
natural to store the PASID array in the per-device IOMMU data. This
makes the code clearer and easier to understand.

Please help review and suggest.

Change log:
v2:
 - Add an explict check for single-device group in the domain attaching
   device pasid interface. (Jason)
 - Make assert_pasid_dma_ownership() returns true or false. Refactor the
   code in a way that does not change its exsiting behavior. (Kevin)

v1: https://lore.kernel.org/linux-iommu/20230801063125.34995-1-baolu.lu@linux.intel.com/

Lu Baolu (3):
  iommu: Make single-device group for PASID explicit
  iommu: Consolidate pasid dma ownership check
  iommu: Move pasid array from group to device

 include/linux/iommu.h |   2 +
 drivers/iommu/iommu.c | 102 +++++++++++++++++++-----------------------
 2 files changed, 49 insertions(+), 55 deletions(-)

-- 
2.34.1

