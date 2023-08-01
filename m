Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E40076A93A
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 08:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbjHAGe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 02:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231713AbjHAGeV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 02:34:21 -0400
Received: from mgamail.intel.com (unknown [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1712708;
        Mon, 31 Jul 2023 23:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690871642; x=1722407642;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=38X/UQN2S8KMhUmc07Z43oFl0p6G/FE1mEl9dZQsBt4=;
  b=UD/pRQUvZ9z1C2ODw2rxCzoiBm7gA5Y2o/dT9rOfPUsSiAt4T3bQX2T5
   lYJbitr75AtEHsYaR0PK8pZ3oIcH0oeSSkcv+XZRSnPKig/YRB+tUjqKS
   yWLfqWb/umyl8vOzlB0hyh4QTinPTrXSj1lLCDO8nRGvLPAEbUAktmZ/H
   qjnV2xY+tEHHwaKg8UAzHLisSr0Q9ebInlOu+R0GmQbLPnA0qwUSq84tg
   6Nx0FKkPQhfv6JFras0OSkruRS1ASf+5OKnHPX0hUZGGWX3D75SULCCSh
   k5evLaDttFvby75alPVLpK1wdpEMtJteCmVba3gb064XjdY2+hEdLEume
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="372839955"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="372839955"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 23:33:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="798537908"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="798537908"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga004.fm.intel.com with ESMTP; 31 Jul 2023 23:33:34 -0700
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
Subject: [PATCH 0/2] iommu: Make pasid array per device
Date:   Tue,  1 Aug 2023 14:31:23 +0800
Message-Id: <20230801063125.34995-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
makes the code clearer and easier to understand. No functional changes
are intended.

Please help review and suggest.

Lu Baolu (2):
  iommu: Consolidate pasid dma ownership check
  iommu: Move pasid array from group to device

 include/linux/iommu.h |   2 +
 drivers/iommu/iommu.c | 105 +++++++++++++++++-------------------------
 2 files changed, 43 insertions(+), 64 deletions(-)

-- 
2.34.1

