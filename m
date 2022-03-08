Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48CB34D0F65
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 06:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343677AbiCHFrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 00:47:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343788AbiCHFrp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 00:47:45 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDE73BBF7;
        Mon,  7 Mar 2022 21:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646718409; x=1678254409;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FFVFu1/gLNtyq5Heu6S1wXB406UqdvSLzskp+SBaVXQ=;
  b=PEavtUqrb176/V+Rf2x0g8PiWuKoszYoDciwJ2iYpT5lHAW4cQPn+u+I
   hFmP0kfL4B+tuQCAHT2qZNJ81fq9dZe0YkEG6CI753/iLTkxeuAl4sYns
   JeqOY5JT6DXpj+EMgQ0q1GfO5Icmy89Ntim8/HtLgk4P2yITdaNuGD1BI
   bbp4IkAjE9/JgrBETTh7Wlb8HFprzfTC76PMQQJgQvobLzGciSvJ49lBA
   +OZ56pRid2o/EX1dyHZjD5vvMRGoSppj27HB+I956rlYi8aTVsYaMy1aU
   mXOtCRmE6PrVUK7Oht0mjKhb1Z3+ciBmZ9No5jw0PJy7RU8Z7tTk3PSgu
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="234553173"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="234553173"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 21:46:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="537430218"
Received: from allen-box.sh.intel.com ([10.239.159.48])
  by orsmga007.jf.intel.com with ESMTP; 07 Mar 2022 21:46:42 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v8 06/11] PCI: portdrv: Set driver_managed_dma
Date:   Tue,  8 Mar 2022 13:44:16 +0800
Message-Id: <20220308054421.847385-7-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308054421.847385-1-baolu.lu@linux.intel.com>
References: <20220308054421.847385-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If a switch lacks ACS P2P Request Redirect, a device below the switch can
bypass the IOMMU and DMA directly to other devices below the switch, so
all the downstream devices must be in the same IOMMU group as the switch
itself.

The existing VFIO framework allows the portdrv driver to be bound to the
bridge while its downstream devices are assigned to user space. The
pci_dma_configure() marks the IOMMU group as containing only devices
with kernel drivers that manage DMA. Avoid this default behavior for the
portdrv driver in order for compatibility with the current VFIO usage.

We achieve this by setting ".driver_managed_dma = true" in pci_driver
structure. It is safe because the portdrv driver meets below criteria:

- This driver doesn't use DMA, as you can't find any related calls like
  pci_set_master() or any kernel DMA API (dma_map_*() and etc.).
- It doesn't use MMIO as you can't find ioremap() or similar calls. It's
  tolerant to userspace possibly also touching the same MMIO registers
  via P2P DMA access.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/pcie/portdrv_pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index 35eca6277a96..6b2adb678c21 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -202,6 +202,8 @@ static struct pci_driver pcie_portdriver = {
 
 	.err_handler	= &pcie_portdrv_err_handler,
 
+	.driver_managed_dma = true,
+
 	.driver.pm	= PCIE_PORTDRV_PM_OPS,
 };
 
-- 
2.25.1

