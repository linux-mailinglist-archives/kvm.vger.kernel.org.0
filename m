Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951FC483A2E
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 02:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbiADB6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jan 2022 20:58:13 -0500
Received: from mga07.intel.com ([134.134.136.100]:62142 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230481AbiADB6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jan 2022 20:58:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641261493; x=1672797493;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nfsc1wnBIJ3PlGkbBCL1BGTH9CgBawUsNa+Z9Z5uOzU=;
  b=iqBiMZqVozcWKbeiW0w/Rz3prNWj+UfJEewQSBjoMKIu55jXXoV7s9EF
   cARkV5vyAo2zagFTEXdglsUa4MWql1IQ3JLDhxiOpsSsO7bg6TmfE8xr/
   l0aceQHHAHxdk9zW20RtiGGOvjvUfmgUx1F3bhlqOT/hSRE0O7GgJZbCu
   fzoOVFFLG4RLOMQOSvry3t965ET5V8x9geDst+sUqz62P4/cHLkSoZAtn
   9jquXvfkLvpO/C1nSmUvYHD8kVw1iw8CUVpst4bQFnT+NcFPhdD3aoBeP
   fmkATQXE9HMKKAYyMUnchJyHyUvJJcM4XHtHDZajoDCuuwbKMoWXtKeRD
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10216"; a="305494264"
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="305494264"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 17:58:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="667573270"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 03 Jan 2022 17:58:02 -0800
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
Subject: [PATCH v5 06/14] bus: fsl-mc: Add driver dma ownership management
Date:   Tue,  4 Jan 2022 09:56:36 +0800
Message-Id: <20220104015644.2294354-7-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
References: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Multiple fsl-mc devices may be placed in the same IOMMU group because
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
 include/linux/fsl/mc.h          |  5 +++++
 drivers/bus/fsl-mc/fsl-mc-bus.c | 26 ++++++++++++++++++++++++--
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/include/linux/fsl/mc.h b/include/linux/fsl/mc.h
index e026f6c48b49..e85a5f18104d 100644
--- a/include/linux/fsl/mc.h
+++ b/include/linux/fsl/mc.h
@@ -32,6 +32,10 @@ struct fsl_mc_io;
  * @shutdown: Function called at shutdown time to quiesce the device
  * @suspend: Function called when a device is stopped
  * @resume: Function called when a device is resumed
+ * @no_kernel_api_dma: Device driver doesn't use kernel DMA API for DMA.
+ *		Drivers which don't require DMA or want to manually claim the
+ *		owner type (e.g. userspace driver frameworks) could set this
+ *		flag.
  *
  * Generic DPAA device driver object for device drivers that are registered
  * with a DPRC bus. This structure is to be embedded in each device-specific
@@ -45,6 +49,7 @@ struct fsl_mc_driver {
 	void (*shutdown)(struct fsl_mc_device *dev);
 	int (*suspend)(struct fsl_mc_device *dev, pm_message_t state);
 	int (*resume)(struct fsl_mc_device *dev);
+	bool no_kernel_api_dma;
 };
 
 #define to_fsl_mc_driver(_drv) \
diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
index 8fd4a356a86e..9ee85f43822a 100644
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
+	if (!mc_drv->no_kernel_api_dma) {
+		ret = iommu_device_use_dma_api(dev);
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
+	if (ret && !mc_drv->no_kernel_api_dma)
+		iommu_device_unuse_dma_api(dev);
+
+	return ret;
+}
+
+static void fsl_mc_dma_cleanup(struct device *dev)
+{
+	struct fsl_mc_driver *mc_drv = to_fsl_mc_driver(dev->driver);
 
-	return acpi_dma_configure_id(dev, DEV_DMA_COHERENT, &input_id);
+	if (!mc_drv->no_kernel_api_dma)
+		iommu_device_unuse_dma_api(dev);
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
-- 
2.25.1

