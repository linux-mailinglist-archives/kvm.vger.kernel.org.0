Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93B3483A29
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 02:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbiADB6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jan 2022 20:58:04 -0500
Received: from mga17.intel.com ([192.55.52.151]:26935 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230422AbiADB6D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jan 2022 20:58:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641261483; x=1672797483;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1tuR1LSiRxsYU08hzaXZ9BRXFngD8ZvuXHVKt0Sdq/Y=;
  b=QizU3MZJQfibGom3tyGo5Q9TK7iqN1x8kK2sohQKZLDlZYb1SjRtlNGj
   y8ca24K/u1lZZIc5d9uxJB08GM2QsI/56kkhbscg8HywsA3MiTNKQIj8H
   LmZjWNHUZ9zEf3qOsewmDMuN10jHLfBVDEmbK1lBhFGFRQToipz9NEOWM
   9gMZTE0ZaOs70JCV8LZaVxE2R6oNO6XS3Uu4NvPzuhusuaPMlQJysP8pi
   OzcRTAms2kaTjLhPxZr73tNBaZ25xiVetnklam2u/56/J1hsqAibalHlO
   uCvTySCp9kXBuyh+mA8xgwfVxdHzkcULDgLCYhjhzgMXiWAwLMNcIt3w8
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10216"; a="222813349"
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="222813349"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 17:58:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="667573263"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 03 Jan 2022 17:57:55 -0800
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
Subject: [PATCH v5 05/14] amba: Add driver dma ownership management
Date:   Tue,  4 Jan 2022 09:56:35 +0800
Message-Id: <20220104015644.2294354-6-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
References: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
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

The device driver may set a new flag (no_kernel_api_dma) to skip calling
iommu_device_use_dma_api() during the binding process. For instance, the
userspace framework drivers (vfio etc.) which need to manually claim
their own dma ownership when assigning the device to userspace.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/amba/bus.h |  1 +
 drivers/amba/bus.c       | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index edfcf7a14dcd..a4f374e2fd35 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -79,6 +79,7 @@ struct amba_driver {
 	void			(*remove)(struct amba_device *);
 	void			(*shutdown)(struct amba_device *);
 	const struct amba_id	*id_table;
+	bool no_kernel_api_dma;
 };
 
 /*
diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 850a0a8973c6..42b20ecfa50c 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -22,6 +22,7 @@
 #include <linux/of_irq.h>
 #include <linux/of_device.h>
 #include <linux/acpi.h>
+#include <linux/iommu.h>
 
 #include <asm/irq.h>
 
@@ -255,9 +256,16 @@ static void amba_shutdown(struct device *dev)
 
 static int amba_dma_configure(struct device *dev)
 {
+	struct amba_driver *drv = to_amba_driver(dev->driver);
 	enum dev_dma_attr attr;
 	int ret = 0;
 
+	if (!drv->no_kernel_api_dma) {
+		ret = iommu_device_use_dma_api(dev);
+		if (ret)
+			return ret;
+	}
+
 	if (dev->of_node) {
 		ret = of_dma_configure(dev, dev->of_node, true);
 	} else if (has_acpi_companion(dev)) {
@@ -265,9 +273,20 @@ static int amba_dma_configure(struct device *dev)
 		ret = acpi_dma_configure(dev, attr);
 	}
 
+	if (ret && !drv->no_kernel_api_dma)
+		iommu_device_unuse_dma_api(dev);
+
 	return ret;
 }
 
+static void amba_dma_cleanup(struct device *dev)
+{
+	struct amba_driver *drv = to_amba_driver(dev->driver);
+
+	if (!drv->no_kernel_api_dma)
+		iommu_device_unuse_dma_api(dev);
+}
+
 #ifdef CONFIG_PM
 /*
  * Hooks to provide runtime PM of the pclk (bus clock).  It is safe to
@@ -337,6 +356,7 @@ struct bus_type amba_bustype = {
 	.remove		= amba_remove,
 	.shutdown	= amba_shutdown,
 	.dma_configure	= amba_dma_configure,
+	.dma_cleanup	= amba_dma_cleanup,
 	.pm		= &amba_pm,
 };
 EXPORT_SYMBOL_GPL(amba_bustype);
-- 
2.25.1

