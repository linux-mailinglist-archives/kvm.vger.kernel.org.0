Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED8D4C6054
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 01:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbiB1Ax7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 19:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbiB1Ax5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 19:53:57 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86D743ED5;
        Sun, 27 Feb 2022 16:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646009593; x=1677545593;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=32sp41rprgDtZfXrp4ZG7n0ROQqIsw+SnWrJCLelBcs=;
  b=dVCoegqHDttfyo3lv1BblkqrzLKOkDw8Om/fd8xChJ4pjOgG2s/P0QOe
   +5+BHebGO/S7FM2RfkFsF+5NCs6OuoR7TJhL4AAACw52Va/3Qlb9hY4f0
   IjMr6k/JyiD1XJnCsO7L2bWnrw5e+id+ljeLgz+OJBZWnOymuNmfI4Bx6
   YSag6ZQhVf2zd7qEUMf3LeDcTOwse5s0QQ+TkSyYAlydTw7955Eze/O+S
   1zugM7z4nIFgCmifpTcjiWzOnHSXnOmlmytPZzAmTNheKOnu507sbHc1Q
   OiN+P9ywJYTpc3F6+3mfkA6OD3K+KovmFgxViwEPMXviNpfO1ZBXNI/aY
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="251608924"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="251608924"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 16:53:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="550020209"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 27 Feb 2022 16:53:02 -0800
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
Subject: [PATCH v7 04/11] bus: platform,amba,fsl-mc,PCI: Add device DMA ownership management
Date:   Mon, 28 Feb 2022 08:50:49 +0800
Message-Id: <20220228005056.599595-5-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228005056.599595-1-baolu.lu@linux.intel.com>
References: <20220228005056.599595-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The devices on platform/amba/fsl-mc/PCI buses could be bound to drivers
with the device DMA managed by kernel drivers or user-space applications.
Unfortunately, multiple devices may be placed in the same IOMMU group
because they cannot be isolated from each other. The DMA on these devices
must either be entirely under kernel control or userspace control, never
a mixture. Otherwise the driver integrity is not guaranteed because they
could access each other through the peer-to-peer accesses which by-pass
the IOMMU protection.

This checks and sets the default DMA mode during driver binding, and
cleanups during driver unbinding. In the default mode, the device DMA is
managed by the device driver which handles DMA operations through the
kernel DMA APIs (see Documentation/core-api/dma-api.rst).

For cases where the devices are assigned for userspace control through the
userspace driver framework(i.e. VFIO), the drivers(for example, vfio_pci/
vfio_platfrom etc.) may set a new flag (driver_managed_dma) to skip this
default setting in the assumption that the drivers know what they are
doing with the device DMA.

With the IOMMU layer knowing DMA ownership of each device, above problem
can be solved.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Stuart Yoder <stuyoder@gmail.com>
Cc: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/amba/bus.h        |  8 ++++++++
 include/linux/fsl/mc.h          |  8 ++++++++
 include/linux/pci.h             |  8 ++++++++
 include/linux/platform_device.h |  8 ++++++++
 drivers/amba/bus.c              | 20 ++++++++++++++++++++
 drivers/base/platform.c         | 20 ++++++++++++++++++++
 drivers/bus/fsl-mc/fsl-mc-bus.c | 26 ++++++++++++++++++++++++--
 drivers/pci/pci-driver.c        | 21 +++++++++++++++++++++
 8 files changed, 117 insertions(+), 2 deletions(-)

diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index 6c7f47846971..e9cd981be94e 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -79,6 +79,14 @@ struct amba_driver {
 	void			(*remove)(struct amba_device *);
 	void			(*shutdown)(struct amba_device *);
 	const struct amba_id	*id_table;
+	/*
+	 * For most device drivers, no need to care about this flag as long as
+	 * all DMAs are handled through the kernel DMA API. For some special
+	 * ones, for example VFIO drivers, they know how to manage the DMA
+	 * themselves and set this flag so that the IOMMU layer will allow them
+	 * to setup and manage their own I/O address space.
+	 */
+	bool driver_managed_dma;
 };
 
 /*
diff --git a/include/linux/fsl/mc.h b/include/linux/fsl/mc.h
index 7b6c42bfb660..27efef8affb1 100644
--- a/include/linux/fsl/mc.h
+++ b/include/linux/fsl/mc.h
@@ -32,6 +32,13 @@ struct fsl_mc_io;
  * @shutdown: Function called at shutdown time to quiesce the device
  * @suspend: Function called when a device is stopped
  * @resume: Function called when a device is resumed
+ * @driver_managed_dma: Device driver doesn't use kernel DMA API for DMA.
+ *		For most device drivers, no need to care about this flag
+ *		as long as all DMAs are handled through the kernel DMA API.
+ *		For some special ones, for example VFIO drivers, they know
+ *		how to manage the DMA themselves and set this flag so that
+ *		the IOMMU layer will allow them to setup and manage their
+ *		own I/O address space.
  *
  * Generic DPAA device driver object for device drivers that are registered
  * with a DPRC bus. This structure is to be embedded in each device-specific
@@ -45,6 +52,7 @@ struct fsl_mc_driver {
 	void (*shutdown)(struct fsl_mc_device *dev);
 	int (*suspend)(struct fsl_mc_device *dev, pm_message_t state);
 	int (*resume)(struct fsl_mc_device *dev);
+	bool driver_managed_dma;
 };
 
 #define to_fsl_mc_driver(_drv) \
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 8253a5413d7c..b94bce839b83 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -894,6 +894,13 @@ struct module;
  *              created once it is bound to the driver.
  * @driver:	Driver model structure.
  * @dynids:	List of dynamically added device IDs.
+ * @driver_managed_dma: Device driver doesn't use kernel DMA API for DMA.
+ *		For most device drivers, no need to care about this flag
+ *		as long as all DMAs are handled through the kernel DMA API.
+ *		For some special ones, for example VFIO drivers, they know
+ *		how to manage the DMA themselves and set this flag so that
+ *		the IOMMU layer will allow them to setup and manage their
+ *		own I/O address space.
  */
 struct pci_driver {
 	struct list_head	node;
@@ -912,6 +919,7 @@ struct pci_driver {
 	const struct attribute_group **dev_groups;
 	struct device_driver	driver;
 	struct pci_dynids	dynids;
+	bool driver_managed_dma;
 };
 
 static inline struct pci_driver *to_pci_driver(struct device_driver *drv)
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 17fde717df68..b3d9c744f1e5 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -210,6 +210,14 @@ struct platform_driver {
 	struct device_driver driver;
 	const struct platform_device_id *id_table;
 	bool prevent_deferred_probe;
+	/*
+	 * For most device drivers, no need to care about this flag as long as
+	 * all DMAs are handled through the kernel DMA API. For some special
+	 * ones, for example VFIO drivers, they know how to manage the DMA
+	 * themselves and set this flag so that the IOMMU layer will allow them
+	 * to setup and manage their own I/O address space.
+	 */
+	bool driver_managed_dma;
 };
 
 #define to_platform_driver(drv)	(container_of((drv), struct platform_driver, \
diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 8392f4aa251b..cebf03522524 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -22,6 +22,7 @@
 #include <linux/of_irq.h>
 #include <linux/of_device.h>
 #include <linux/acpi.h>
+#include <linux/iommu.h>
 
 #define to_amba_driver(d)	container_of(d, struct amba_driver, drv)
 
@@ -277,9 +278,16 @@ static void amba_shutdown(struct device *dev)
 
 static int amba_dma_configure(struct device *dev)
 {
+	struct amba_driver *drv = to_amba_driver(dev->driver);
 	enum dev_dma_attr attr;
 	int ret = 0;
 
+	if (!drv->driver_managed_dma) {
+		ret = iommu_device_use_default_domain(dev);
+		if (ret)
+			return ret;
+	}
+
 	if (dev->of_node) {
 		ret = of_dma_configure(dev, dev->of_node, true);
 	} else if (has_acpi_companion(dev)) {
@@ -287,9 +295,20 @@ static int amba_dma_configure(struct device *dev)
 		ret = acpi_dma_configure(dev, attr);
 	}
 
+	if (ret && !drv->driver_managed_dma)
+		iommu_device_unuse_default_domain(dev);
+
 	return ret;
 }
 
+static void amba_dma_cleanup(struct device *dev)
+{
+	struct amba_driver *drv = to_amba_driver(dev->driver);
+
+	if (!drv->driver_managed_dma)
+		iommu_device_unuse_default_domain(dev);
+}
+
 #ifdef CONFIG_PM
 /*
  * Hooks to provide runtime PM of the pclk (bus clock).  It is safe to
@@ -359,6 +378,7 @@ struct bus_type amba_bustype = {
 	.remove		= amba_remove,
 	.shutdown	= amba_shutdown,
 	.dma_configure	= amba_dma_configure,
+	.dma_cleanup	= amba_dma_cleanup,
 	.pm		= &amba_pm,
 };
 EXPORT_SYMBOL_GPL(amba_bustype);
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index acbc6eae37b8..ad8ea9453cdb 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -30,6 +30,7 @@
 #include <linux/property.h>
 #include <linux/kmemleak.h>
 #include <linux/types.h>
+#include <linux/iommu.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -1456,9 +1457,16 @@ static void platform_shutdown(struct device *_dev)
 
 static int platform_dma_configure(struct device *dev)
 {
+	struct platform_driver *drv = to_platform_driver(dev->driver);
 	enum dev_dma_attr attr;
 	int ret = 0;
 
+	if (!drv->driver_managed_dma) {
+		ret = iommu_device_use_default_domain(dev);
+		if (ret)
+			return ret;
+	}
+
 	if (dev->of_node) {
 		ret = of_dma_configure(dev, dev->of_node, true);
 	} else if (has_acpi_companion(dev)) {
@@ -1466,9 +1474,20 @@ static int platform_dma_configure(struct device *dev)
 		ret = acpi_dma_configure(dev, attr);
 	}
 
+	if (ret && !drv->driver_managed_dma)
+		iommu_device_unuse_default_domain(dev);
+
 	return ret;
 }
 
+static void platform_dma_cleanup(struct device *dev)
+{
+	struct platform_driver *drv = to_platform_driver(dev->driver);
+
+	if (!drv->driver_managed_dma)
+		iommu_device_unuse_default_domain(dev);
+}
+
 static const struct dev_pm_ops platform_dev_pm_ops = {
 	SET_RUNTIME_PM_OPS(pm_generic_runtime_suspend, pm_generic_runtime_resume, NULL)
 	USE_PLATFORM_PM_SLEEP_OPS
@@ -1483,6 +1502,7 @@ struct bus_type platform_bus_type = {
 	.remove		= platform_remove,
 	.shutdown	= platform_shutdown,
 	.dma_configure	= platform_dma_configure,
+	.dma_cleanup	= platform_dma_cleanup,
 	.pm		= &platform_dev_pm_ops,
 };
 EXPORT_SYMBOL_GPL(platform_bus_type);
diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
index 8fd4a356a86e..eca3406a14ce 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -140,15 +140,36 @@ static int fsl_mc_dma_configure(struct device *dev)
 {
 	struct device *dma_dev = dev;
 	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
+	struct fsl_mc_driver *mc_drv = to_fsl_mc_driver(dev->driver);
 	u32 input_id = mc_dev->icid;
+	int ret;
+
+	if (!mc_drv->driver_managed_dma) {
+		ret = iommu_device_use_default_domain(dev);
+		if (ret)
+			return ret;
+	}
 
 	while (dev_is_fsl_mc(dma_dev))
 		dma_dev = dma_dev->parent;
 
 	if (dev_of_node(dma_dev))
-		return of_dma_configure_id(dev, dma_dev->of_node, 0, &input_id);
+		ret = of_dma_configure_id(dev, dma_dev->of_node, 0, &input_id);
+	else
+		ret = acpi_dma_configure_id(dev, DEV_DMA_COHERENT, &input_id);
+
+	if (ret && !mc_drv->driver_managed_dma)
+		iommu_device_unuse_default_domain(dev);
+
+	return ret;
+}
+
+static void fsl_mc_dma_cleanup(struct device *dev)
+{
+	struct fsl_mc_driver *mc_drv = to_fsl_mc_driver(dev->driver);
 
-	return acpi_dma_configure_id(dev, DEV_DMA_COHERENT, &input_id);
+	if (!mc_drv->driver_managed_dma)
+		iommu_device_unuse_default_domain(dev);
 }
 
 static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
@@ -312,6 +333,7 @@ struct bus_type fsl_mc_bus_type = {
 	.match = fsl_mc_bus_match,
 	.uevent = fsl_mc_bus_uevent,
 	.dma_configure  = fsl_mc_dma_configure,
+	.dma_cleanup = fsl_mc_dma_cleanup,
 	.dev_groups = fsl_mc_dev_groups,
 	.bus_groups = fsl_mc_bus_groups,
 };
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 588588cfda48..893a8707c179 100644
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
 
+	if (!driver->driver_managed_dma) {
+		ret = iommu_device_use_default_domain(dev);
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
+	if (ret && !driver->driver_managed_dma)
+		iommu_device_unuse_default_domain(dev);
+
 	return ret;
 }
 
+static void pci_dma_cleanup(struct device *dev)
+{
+	struct pci_driver *driver = to_pci_driver(dev->driver);
+
+	if (!driver->driver_managed_dma)
+		iommu_device_unuse_default_domain(dev);
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

