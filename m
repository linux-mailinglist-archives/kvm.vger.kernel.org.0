Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E08460333
	for <lists+kvm@lfdr.de>; Sun, 28 Nov 2021 03:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350738AbhK1C5Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Nov 2021 21:57:16 -0500
Received: from mga12.intel.com ([192.55.52.136]:14879 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239793AbhK1CzO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Nov 2021 21:55:14 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10181"; a="215825055"
X-IronPort-AV: E=Sophos;i="5.87,270,1631602800"; 
   d="scan'208";a="215825055"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2021 18:51:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,270,1631602800"; 
   d="scan'208";a="652489040"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 27 Nov 2021 18:51:52 -0800
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
        Li Yang <leoyang.li@nxp.com>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v2 08/17] PCI: portdrv: Suppress kernel DMA ownership auto-claiming
Date:   Sun, 28 Nov 2021 10:50:42 +0800
Message-Id: <20211128025051.355578-9-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211128025051.355578-1-baolu.lu@linux.intel.com>
References: <20211128025051.355578-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IOMMU grouping on PCI necessitates that if we lack isolation on a bridge
then all of the downstream devices will be part of the same IOMMU group
as the bridge. The existing vfio framework allows the portdrv driver to
be bound to the bridge while its downstream devices are assigned to user
space. The pci_dma_configure() marks the iommu_group as containing only
devices with kernel drivers that manage DMA. Avoid this default behavior
for the portdrv driver in order for compatibility with the current vfio
policy.

The commit 5f096b14d421b ("vfio: Whitelist PCI bridges") extended above
policy to all kernel drivers of bridge class. This is not always safe.
For example, The shpchp_core driver relies on the PCI MMIO access for the
controller functionality. With its downstream devices assigned to the
userspace, the MMIO might be changed through user initiated P2P accesses
without any notification. This might break the kernel driver integrity
and lead to some unpredictable consequences.

For any bridge driver, in order to avoiding default kernel DMA ownership
claiming, we should consider:

 1) Does the bridge driver use DMA? Calling pci_set_master() or
    a dma_map_* API is a sure indicate the driver is doing DMA

 2) If the bridge driver uses MMIO, is it tolerant to hostile
    userspace also touching the same MMIO registers via P2P DMA
    attacks?

Conservatively if the driver maps an MMIO region at all, we can say that
it fails the test.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/pci/pcie/portdrv_pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index 35eca6277a96..c66a83f2c987 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -202,6 +202,8 @@ static struct pci_driver pcie_portdriver = {
 
 	.err_handler	= &pcie_portdrv_err_handler,
 
+	.suppress_auto_claim_dma_owner = true,
+
 	.driver.pm	= PCIE_PORTDRV_PM_OPS,
 };
 
-- 
2.25.1

