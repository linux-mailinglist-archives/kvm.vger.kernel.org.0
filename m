Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7D846032A
	for <lists+kvm@lfdr.de>; Sun, 28 Nov 2021 03:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347453AbhK1C4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Nov 2021 21:56:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:12223 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239328AbhK1Cyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Nov 2021 21:54:54 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10181"; a="233296176"
X-IronPort-AV: E=Sophos;i="5.87,270,1631602800"; 
   d="scan'208";a="233296176"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2021 18:51:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,270,1631602800"; 
   d="scan'208";a="652489001"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 27 Nov 2021 18:51:31 -0800
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
Subject: [PATCH v2 05/17] amba: Add driver dma ownership management
Date:   Sun, 28 Nov 2021 10:50:39 +0800
Message-Id: <20211128025051.355578-6-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211128025051.355578-1-baolu.lu@linux.intel.com>
References: <20211128025051.355578-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Multiple amba devices may be placed in the same IOMMU group because
they cannot be isolated from each other. These devices must either be
entirely under kernel control or userspace control, never a mixture. This
checks and sets DMA ownership during driver binding, and release the
ownership during driver unbinding.

Driver may set a new flag (suppress_auto_claim_dma_owner) to disable auto
claiming DMA_OWNER_DMA_API ownership in the binding process. For instance,
the userspace framework drivers (vfio etc.) which need to manually claim
DMA_OWNER_PRIVATE_DOMAIN_USER when assigning a device to userspace.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/amba/bus.h |  1 +
 drivers/amba/bus.c       | 30 +++++++++++++++++++++++++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index edfcf7a14dcd..745c5a60ddd8 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -79,6 +79,7 @@ struct amba_driver {
 	void			(*remove)(struct amba_device *);
 	void			(*shutdown)(struct amba_device *);
 	const struct amba_id	*id_table;
+	bool suppress_auto_claim_dma_owner;
 };
 
 /*
diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 720aa6cdd402..cd0cd9d141ec 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/reset.h>
 #include <linux/of_irq.h>
+#include <linux/iommu.h>
 
 #include <asm/irq.h>
 
@@ -305,6 +306,32 @@ static const struct dev_pm_ops amba_pm = {
 	)
 };
 
+static int amba_dma_configure(struct device *dev)
+{
+	struct amba_driver *drv = to_amba_driver(dev->driver);
+	int ret;
+
+	if (!drv->suppress_auto_claim_dma_owner) {
+		ret = iommu_device_set_dma_owner(dev, DMA_OWNER_DMA_API, NULL);
+		if (ret)
+			return ret;
+	}
+
+	ret = platform_dma_configure(dev);
+	if (ret && !drv->suppress_auto_claim_dma_owner)
+		iommu_device_release_dma_owner(dev, DMA_OWNER_DMA_API);
+
+	return ret;
+}
+
+static void amba_dma_unconfigure(struct device *dev)
+{
+	struct amba_driver *drv = to_amba_driver(dev->driver);
+
+	if (!drv->suppress_auto_claim_dma_owner)
+		iommu_device_release_dma_owner(dev, DMA_OWNER_DMA_API);
+}
+
 /*
  * Primecells are part of the Advanced Microcontroller Bus Architecture,
  * so we call the bus "amba".
@@ -319,7 +346,8 @@ struct bus_type amba_bustype = {
 	.probe		= amba_probe,
 	.remove		= amba_remove,
 	.shutdown	= amba_shutdown,
-	.dma_configure	= platform_dma_configure,
+	.dma_configure	= amba_dma_configure,
+	.dma_unconfigure = amba_dma_unconfigure,
 	.pm		= &amba_pm,
 };
 EXPORT_SYMBOL_GPL(amba_bustype);
-- 
2.25.1

