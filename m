Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2828483A1A
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 02:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbiADB5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jan 2022 20:57:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:44328 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232024AbiADB5t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jan 2022 20:57:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641261469; x=1672797469;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xdp+gaxXZn/4YHXphQ37hzTT8Ienm3tZy4Mchv890U0=;
  b=a9bsV0yMZeWVQuTeIyn0oM6N4QqtvmhX4hrVh80PXvhUR6HLGycba824
   OctxDKaUAfv8t2XEAVsYu3J5FgCfzwaDY345h7SUE9/dlkY2QYqIdvd+p
   0vXpCJ2A98qtBpvqqIJwzhB+SRN6TsvnE6E08HayQAacpuwVNnCTO+d9f
   EVGN0lBdXjIQmdG4sRGzYbPCyuZqOqu2r6MrJciLZBanhoqE602EAMdIW
   hv0lzlNhcEtMBSKkEypuza5Ydm93fkiZPi+zRyh99dm5/EosiGF/MfQjZ
   LXEazb3QjbTdHQ3xBgdxvOb3QwBYMFAcovdSDP4kr3AdCzBMrNxNhz1pb
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10216"; a="266404965"
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="266404965"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 17:57:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="667573215"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 03 Jan 2022 17:57:43 -0800
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
Subject: [PATCH v5 03/14] amba: Stop sharing platform_dma_configure()
Date:   Tue,  4 Jan 2022 09:56:33 +0800
Message-Id: <20220104015644.2294354-4-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
References: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Stop sharing platform_dma_configure() helper as they are about to have
their specific bus dma_configure callbacks.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/platform_device.h |  2 --
 drivers/amba/bus.c              | 19 ++++++++++++++++++-
 drivers/base/platform.c         |  3 +--
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 7c96f169d274..17fde717df68 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -328,8 +328,6 @@ extern int platform_pm_restore(struct device *dev);
 #define platform_pm_restore		NULL
 #endif
 
-extern int platform_dma_configure(struct device *dev);
-
 #ifdef CONFIG_PM_SLEEP
 #define USE_PLATFORM_PM_SLEEP_OPS \
 	.suspend = platform_pm_suspend, \
diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 720aa6cdd402..850a0a8973c6 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -20,6 +20,8 @@
 #include <linux/platform_device.h>
 #include <linux/reset.h>
 #include <linux/of_irq.h>
+#include <linux/of_device.h>
+#include <linux/acpi.h>
 
 #include <asm/irq.h>
 
@@ -251,6 +253,21 @@ static void amba_shutdown(struct device *dev)
 		drv->shutdown(to_amba_device(dev));
 }
 
+static int amba_dma_configure(struct device *dev)
+{
+	enum dev_dma_attr attr;
+	int ret = 0;
+
+	if (dev->of_node) {
+		ret = of_dma_configure(dev, dev->of_node, true);
+	} else if (has_acpi_companion(dev)) {
+		attr = acpi_get_dma_attr(to_acpi_device_node(dev->fwnode));
+		ret = acpi_dma_configure(dev, attr);
+	}
+
+	return ret;
+}
+
 #ifdef CONFIG_PM
 /*
  * Hooks to provide runtime PM of the pclk (bus clock).  It is safe to
@@ -319,7 +336,7 @@ struct bus_type amba_bustype = {
 	.probe		= amba_probe,
 	.remove		= amba_remove,
 	.shutdown	= amba_shutdown,
-	.dma_configure	= platform_dma_configure,
+	.dma_configure	= amba_dma_configure,
 	.pm		= &amba_pm,
 };
 EXPORT_SYMBOL_GPL(amba_bustype);
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 598acf93a360..b4d36b46ab2e 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -1449,8 +1449,7 @@ static void platform_shutdown(struct device *_dev)
 		drv->shutdown(dev);
 }
 
-
-int platform_dma_configure(struct device *dev)
+static int platform_dma_configure(struct device *dev)
 {
 	enum dev_dma_attr attr;
 	int ret = 0;
-- 
2.25.1

