Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D8444FCED
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 03:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236271AbhKOCNm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Nov 2021 21:13:42 -0500
Received: from mga06.intel.com ([134.134.136.31]:51230 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236259AbhKOCNf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Nov 2021 21:13:35 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="294186331"
X-IronPort-AV: E=Sophos;i="5.87,235,1631602800"; 
   d="scan'208";a="294186331"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2021 18:10:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,235,1631602800"; 
   d="scan'208";a="505714551"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 14 Nov 2021 18:10:31 -0800
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
Subject: [PATCH 02/11] driver core: Set DMA ownership during driver bind/unbind
Date:   Mon, 15 Nov 2021 10:05:43 +0800
Message-Id: <20211115020552.2378167-3-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This extends really_probe() to allow checking for dma ownership conflict
during the driver binding process. By default, the DMA_OWNER_KERNEL is
claimed for the bound driver before calling its .probe() callback. If this
operation fails (e.g. the iommu group of the target device already has the
DMA_OWNER_USER set), the binding process is aborted to avoid breaking the
security contract for devices in the iommu group.

Without this change, the vfio driver has to listen to a bus BOUND_DRIVER
event and then BUG_ON() in case of dma ownership conflict. This leads to
bad user experience since careless driver binding operation may crash the
system if the admin overlooks the group restriction.

Aside from bad design, this leads to a security problem as a root user,
even with lockdown=integrity, can force the kernel to BUG.

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
 include/linux/device/driver.h |  7 ++++++-
 drivers/base/dd.c             | 12 ++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/linux/device/driver.h b/include/linux/device/driver.h
index a498ebcf4993..25d39c64c4d9 100644
--- a/include/linux/device/driver.h
+++ b/include/linux/device/driver.h
@@ -54,6 +54,10 @@ enum probe_type {
  * @owner:	The module owner.
  * @mod_name:	Used for built-in modules.
  * @suppress_bind_attrs: Disables bind/unbind via sysfs.
+ * @suppress_auto_claim_dma_owner: Disable auto claiming of kernel DMA owner.
+ *		Drivers which don't require DMA or want to manually claim the
+ *		owner type (e.g. userspace driver frameworks) could set this
+ *		flag.
  * @probe_type:	Type of the probe (synchronous or asynchronous) to use.
  * @of_match_table: The open firmware table.
  * @acpi_match_table: The ACPI match table.
@@ -99,7 +103,8 @@ struct device_driver {
 	struct module		*owner;
 	const char		*mod_name;	/* used for built-in modules */
 
-	bool suppress_bind_attrs;	/* disables bind/unbind via sysfs */
+	bool suppress_bind_attrs:1;	/* disables bind/unbind via sysfs */
+	bool suppress_auto_claim_dma_owner:1;
 	enum probe_type probe_type;
 
 	const struct of_device_id	*of_match_table;
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 68ea1f949daa..ab3333351f19 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -28,6 +28,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/pinctrl/devinfo.h>
 #include <linux/slab.h>
+#include <linux/iommu.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -566,6 +567,12 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 		goto done;
 	}
 
+	if (!drv->suppress_auto_claim_dma_owner) {
+		ret = iommu_device_set_dma_owner(dev, DMA_OWNER_KERNEL, NULL);
+		if (ret)
+			return ret;
+	}
+
 re_probe:
 	dev->driver = drv;
 
@@ -673,6 +680,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 		dev->pm_domain->dismiss(dev);
 	pm_runtime_reinit(dev);
 	dev_pm_set_driver_flags(dev, 0);
+	if (!drv->suppress_auto_claim_dma_owner)
+		iommu_device_release_dma_owner(dev, DMA_OWNER_KERNEL);
 done:
 	return ret;
 }
@@ -1215,6 +1224,9 @@ static void __device_release_driver(struct device *dev, struct device *parent)
 		pm_runtime_reinit(dev);
 		dev_pm_set_driver_flags(dev, 0);
 
+		if (!drv->suppress_auto_claim_dma_owner)
+			iommu_device_release_dma_owner(dev, DMA_OWNER_KERNEL);
+
 		klist_remove(&dev->p->knode_driver);
 		device_pm_check_callbacks(dev);
 		if (dev->bus)
-- 
2.25.1

