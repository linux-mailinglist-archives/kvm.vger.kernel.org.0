Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460AB44FCFC
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 03:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236455AbhKOCPH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Nov 2021 21:15:07 -0500
Received: from mga04.intel.com ([192.55.52.120]:50553 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236253AbhKOCNm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Nov 2021 21:13:42 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="232086645"
X-IronPort-AV: E=Sophos;i="5.87,235,1631602800"; 
   d="scan'208";a="232086645"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2021 18:10:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,235,1631602800"; 
   d="scan'208";a="505714581"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 14 Nov 2021 18:10:42 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     Will Deacon <will@kernel.org>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH 04/11] PCI: portdrv: Suppress kernel DMA ownership auto-claiming
Date:   Mon, 15 Nov 2021 10:05:45 +0800
Message-Id: <20211115020552.2378167-5-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IOMMU grouping on PCI necessitates that if we lack isolation on a bridge
then all of the downstream devices will be part of the same IOMMU group
as the bridge. As long as the bridge kernel driver doesn't map and
access any PCI mmio bar, it's safe to bind it to the device in a USER-
owned group. Hence, safe to suppress the kernel DMA ownership auto-
claiming.

The commit 5f096b14d421b ("vfio: Whitelist PCI bridges") permitted a
class of kernel drivers. This is not always safe. For example, the SHPC
system design requires that it must be integrated into a PCI-to-PCI
bridge or a host bridge. The shpchp_core driver relies on the PCI mmio
bar access for the controller functionality. Binding it to the device
belonging to a USER-owned group will allow the user to change the
controller via p2p transactions which is unknown to the hot-plug driver
and could lead to some unpredictable consequences.

Now that we have driver self-declaration of safety we should rely on that.
This change may cause regression on some platforms, since all bridges were
exempted before, but now they have to be manually audited before doing so.
This is actually the desired outcome anyway.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/pci/pcie/portdrv_pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index 35eca6277a96..1285862a9aa8 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -203,6 +203,8 @@ static struct pci_driver pcie_portdriver = {
 	.err_handler	= &pcie_portdrv_err_handler,
 
 	.driver.pm	= PCIE_PORTDRV_PM_OPS,
+
+	.driver.suppress_auto_claim_dma_owner = true,
 };
 
 static int __init dmi_pcie_pme_disable_msi(const struct dmi_system_id *d)
-- 
2.25.1

