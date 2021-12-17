Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357A8478503
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 07:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbhLQGhv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 01:37:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:16976 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233282AbhLQGhu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 01:37:50 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="226979359"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="226979359"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 22:37:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="519623128"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 16 Dec 2021 22:37:42 -0800
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
Subject: [PATCH v4 02/13] driver core: Set DMA ownership during driver bind/unbind
Date:   Fri, 17 Dec 2021 14:36:57 +0800
Message-Id: <20211217063708.1740334-3-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211217063708.1740334-1-baolu.lu@linux.intel.com>
References: <20211217063708.1740334-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This extends really_probe() to allow checking for dma ownership conflict
during the driver binding process. By default, the DMA_OWNER_DMA_API is
claimed for the bound driver before calling its .probe() callback. If this
operation fails (e.g. the iommu group of the target device already has the
DMA_OWNER_USER set), the binding process is aborted to avoid breaking the
security contract for devices in the iommu group.

Without this change, the vfio driver has to listen to a bus BOUND_DRIVER
event and then BUG_ON() in case of dma ownership conflict. This leads to
bad user experience since careless driver binding operation may crash the
system if the admin overlooks the group restriction. Aside from bad design,
this leads to a security problem as a root user can force the kernel to
BUG() even with lockdown=integrity.

Driver may set a new flag (suppress_auto_claim_dma_owner) to disable auto
claim in the binding process. Examples include kernel drivers (pci_stub,
PCI bridge drivers, etc.) which don't trigger DMA at all thus can be safely
exempted in DMA ownership check and userspace framework drivers (vfio/vdpa
etc.) which need to manually claim DMA_OWNER_USER when assigning a device
to userspace.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/linux-iommu/20210922123931.GI327412@nvidia.com/
Link: https://lore.kernel.org/linux-iommu/20210928115751.GK964074@nvidia.com/
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/device/driver.h |  2 ++
 drivers/base/dd.c             | 37 ++++++++++++++++++++++++++++++-----
 2 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/include/linux/device/driver.h b/include/linux/device/driver.h
index a498ebcf4993..f5bf7030c416 100644
--- a/include/linux/device/driver.h
+++ b/include/linux/device/driver.h
@@ -54,6 +54,7 @@ enum probe_type {
  * @owner:	The module owner.
  * @mod_name:	Used for built-in modules.
  * @suppress_bind_attrs: Disables bind/unbind via sysfs.
+ * @suppress_auto_claim_dma_owner: Disable kernel dma auto-claim.
  * @probe_type:	Type of the probe (synchronous or asynchronous) to use.
  * @of_match_table: The open firmware table.
  * @acpi_match_table: The ACPI match table.
@@ -100,6 +101,7 @@ struct device_driver {
 	const char		*mod_name;	/* used for built-in modules */
 
 	bool suppress_bind_attrs;	/* disables bind/unbind via sysfs */
+	bool suppress_auto_claim_dma_owner;
 	enum probe_type probe_type;
 
 	const struct of_device_id	*of_match_table;
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 68ea1f949daa..b04eec5dcefa 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -28,6 +28,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/pinctrl/devinfo.h>
 #include <linux/slab.h>
+#include <linux/iommu.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -538,6 +539,32 @@ static int call_driver_probe(struct device *dev, struct device_driver *drv)
 	return ret;
 }
 
+static int device_dma_configure(struct device *dev, struct device_driver *drv)
+{
+	int ret;
+
+	if (!dev->bus->dma_configure)
+		return 0;
+
+	ret = dev->bus->dma_configure(dev);
+	if (ret)
+		return ret;
+
+	if (!drv->suppress_auto_claim_dma_owner)
+		ret = iommu_device_set_dma_owner(dev, DMA_OWNER_DMA_API, NULL);
+
+	return ret;
+}
+
+static void device_dma_cleanup(struct device *dev, struct device_driver *drv)
+{
+	if (!dev->bus->dma_configure)
+		return;
+
+	if (!drv->suppress_auto_claim_dma_owner)
+		iommu_device_release_dma_owner(dev, DMA_OWNER_DMA_API);
+}
+
 static int really_probe(struct device *dev, struct device_driver *drv)
 {
 	bool test_remove = IS_ENABLED(CONFIG_DEBUG_TEST_DRIVER_REMOVE) &&
@@ -574,11 +601,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 	if (ret)
 		goto pinctrl_bind_failed;
 
-	if (dev->bus->dma_configure) {
-		ret = dev->bus->dma_configure(dev);
-		if (ret)
-			goto probe_failed;
-	}
+	if (device_dma_configure(dev, drv))
+		goto pinctrl_bind_failed;
 
 	ret = driver_sysfs_add(dev);
 	if (ret) {
@@ -660,6 +684,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 					     BUS_NOTIFY_DRIVER_NOT_BOUND, dev);
+
+	device_dma_cleanup(dev, drv);
 pinctrl_bind_failed:
 	device_links_no_driver(dev);
 	devres_release_all(dev);
@@ -1204,6 +1230,7 @@ static void __device_release_driver(struct device *dev, struct device *parent)
 		else if (drv->remove)
 			drv->remove(dev);
 
+		device_dma_cleanup(dev, drv);
 		device_links_driver_cleanup(dev);
 
 		devres_release_all(dev);
-- 
2.25.1

