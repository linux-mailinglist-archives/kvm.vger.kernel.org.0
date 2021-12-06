Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6362C468EC8
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 03:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbhLFCDt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Dec 2021 21:03:49 -0500
Received: from mga05.intel.com ([192.55.52.43]:57750 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232560AbhLFCDq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Dec 2021 21:03:46 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10189"; a="323482804"
X-IronPort-AV: E=Sophos;i="5.87,290,1631602800"; 
   d="scan'208";a="323482804"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2021 18:00:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,290,1631602800"; 
   d="scan'208";a="514542278"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 05 Dec 2021 18:00:06 -0800
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
Subject: [PATCH v3 07/18] PCI: Add driver dma ownership management
Date:   Mon,  6 Dec 2021 09:58:52 +0800
Message-Id: <20211206015903.88687-8-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206015903.88687-1-baolu.lu@linux.intel.com>
References: <20211206015903.88687-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Multiple PCI devices may be placed in the same IOMMU group because they
cannot be isolated from each other. These devices must either be entirely
under kernel control or userspace control, never a mixture. This checks
and sets DMA ownership during driver binding, and vice versa, release the
ownership during driver unbinding.

Driver may set a new flag (suppress_auto_claim_dma_owner) to disable auto
claiming DMA_OWNER_DMA_API ownership in the binding process. For instance,
the userspace framework drivers (vfio etc.) which need to manually claim
DMA_OWNER_PRIVATE_DOMAIN_USER when assigning a device to userspace.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/pci.h      |  5 +++++
 drivers/pci/pci-driver.c | 21 +++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 18a75c8e615c..1b29af0ab43b 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -882,6 +882,10 @@ struct module;
  *              created once it is bound to the driver.
  * @driver:	Driver model structure.
  * @dynids:	List of dynamically added device IDs.
+ * @suppress_auto_claim_dma_owner: Disable auto claiming of kernel DMA owner.
+ *		Drivers which don't require DMA or want to manually claim the
+ *		owner type (e.g. userspace driver frameworks) could set this
+ *		flag.
  */
 struct pci_driver {
 	struct list_head	node;
@@ -900,6 +904,7 @@ struct pci_driver {
 	const struct attribute_group **dev_groups;
 	struct device_driver	driver;
 	struct pci_dynids	dynids;
+	bool suppress_auto_claim_dma_owner;
 };
 
 static inline struct pci_driver *to_pci_driver(struct device_driver *drv)
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 588588cfda48..92712645e179 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -20,6 +20,7 @@
 #include <linux/of_device.h>
 #include <linux/acpi.h>
 #include <linux/dma-map-ops.h>
+#include <linux/iommu.h>
 #include "pci.h"
 #include "pcie/portdrv.h"
 
@@ -1590,9 +1591,16 @@ static int pci_bus_num_vf(struct device *dev)
  */
 static int pci_dma_configure(struct device *dev)
 {
+	struct pci_driver *driver = to_pci_driver(dev->driver);
 	struct device *bridge;
 	int ret = 0;
 
+	if (!driver->suppress_auto_claim_dma_owner) {
+		ret = iommu_device_set_dma_owner(dev, DMA_OWNER_DMA_API, NULL);
+		if (ret)
+			return ret;
+	}
+
 	bridge = pci_get_host_bridge_device(to_pci_dev(dev));
 
 	if (IS_ENABLED(CONFIG_OF) && bridge->parent &&
@@ -1605,9 +1613,21 @@ static int pci_dma_configure(struct device *dev)
 	}
 
 	pci_put_host_bridge_device(bridge);
+
+	if (ret && !driver->suppress_auto_claim_dma_owner)
+		iommu_device_release_dma_owner(dev, DMA_OWNER_DMA_API);
+
 	return ret;
 }
 
+static void pci_dma_cleanup(struct device *dev)
+{
+	struct pci_driver *driver = to_pci_driver(dev->driver);
+
+	if (!driver->suppress_auto_claim_dma_owner)
+		iommu_device_release_dma_owner(dev, DMA_OWNER_DMA_API);
+}
+
 struct bus_type pci_bus_type = {
 	.name		= "pci",
 	.match		= pci_bus_match,
@@ -1621,6 +1641,7 @@ struct bus_type pci_bus_type = {
 	.pm		= PCI_PM_OPS_PTR,
 	.num_vf		= pci_bus_num_vf,
 	.dma_configure	= pci_dma_configure,
+	.dma_cleanup	= pci_dma_cleanup,
 };
 EXPORT_SYMBOL(pci_bus_type);
 
-- 
2.25.1

