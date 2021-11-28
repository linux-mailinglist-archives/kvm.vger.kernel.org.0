Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4807460320
	for <lists+kvm@lfdr.de>; Sun, 28 Nov 2021 03:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244656AbhK1C4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Nov 2021 21:56:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:56404 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232265AbhK1Cyd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Nov 2021 21:54:33 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10181"; a="259712771"
X-IronPort-AV: E=Sophos;i="5.87,270,1631602800"; 
   d="scan'208";a="259712771"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2021 18:51:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,270,1631602800"; 
   d="scan'208";a="652488940"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 27 Nov 2021 18:51:10 -0800
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
Subject: [PATCH v2 02/17] driver core: Add dma_unconfigure callback in bus_type
Date:   Sun, 28 Nov 2021 10:50:36 +0800
Message-Id: <20211128025051.355578-3-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211128025051.355578-1-baolu.lu@linux.intel.com>
References: <20211128025051.355578-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The bus_type structure defines dma_configure() callback for bus drivers
to configure DMA on the devices. This adds the paired dma_unconfigure()
callback and calls it during driver unbinding so that bus drivers can do
some cleanup work.

One use case for this paired DMA callbacks is for the bus driver to check
for DMA ownership conflicts during driver binding, where multiple devices
belonging to a same IOMMU group (the minimum granularity of isolation and
protection) may be assigned to kernel drivers or user space respectively.

Without this change, for example, the vfio driver has to listen to a bus
BOUND_DRIVER event and then BUG_ON() in case of dma ownership conflict.
This leads to bad user experience since careless driver binding operation
may crash the system if the admin overlooks the group restriction. Aside
from bad design, this leads to a security problem as a root user, even with
lockdown=integrity, can force the kernel to BUG.

With this change, the bus driver could check and set the DMA ownership in
driver binding process and fail on ownership conflicts. The DMA ownership
should be released during driver unbinding.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/linux-iommu/20210922123931.GI327412@nvidia.com/
Link: https://lore.kernel.org/linux-iommu/20210928115751.GK964074@nvidia.com/
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/device/bus.h | 3 +++
 drivers/base/dd.c          | 7 ++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/device/bus.h b/include/linux/device/bus.h
index a039ab809753..ef54a71e5f8f 100644
--- a/include/linux/device/bus.h
+++ b/include/linux/device/bus.h
@@ -59,6 +59,8 @@ struct fwnode_handle;
  *		bus supports.
  * @dma_configure:	Called to setup DMA configuration on a device on
  *			this bus.
+ * @dma_unconfigure:	Called to cleanup DMA configuration on a device on
+ *			this bus.
  * @pm:		Power management operations of this bus, callback the specific
  *		device driver's pm-ops.
  * @iommu_ops:  IOMMU specific operations for this bus, used to attach IOMMU
@@ -103,6 +105,7 @@ struct bus_type {
 	int (*num_vf)(struct device *dev);
 
 	int (*dma_configure)(struct device *dev);
+	void (*dma_unconfigure)(struct device *dev);
 
 	const struct dev_pm_ops *pm;
 
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 68ea1f949daa..a37aafff5fde 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -577,7 +577,7 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 	if (dev->bus->dma_configure) {
 		ret = dev->bus->dma_configure(dev);
 		if (ret)
-			goto probe_failed;
+			goto pinctrl_bind_failed;
 	}
 
 	ret = driver_sysfs_add(dev);
@@ -660,6 +660,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 					     BUS_NOTIFY_DRIVER_NOT_BOUND, dev);
+	if (dev->bus->dma_unconfigure)
+		dev->bus->dma_unconfigure(dev);
 pinctrl_bind_failed:
 	device_links_no_driver(dev);
 	devres_release_all(dev);
@@ -1204,6 +1206,9 @@ static void __device_release_driver(struct device *dev, struct device *parent)
 		else if (drv->remove)
 			drv->remove(dev);
 
+		if (dev->bus->dma_unconfigure)
+			dev->bus->dma_unconfigure(dev);
+
 		device_links_driver_cleanup(dev);
 
 		devres_release_all(dev);
-- 
2.25.1

