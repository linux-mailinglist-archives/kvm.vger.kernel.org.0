Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A154C604A
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 01:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbiB1Axh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 19:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbiB1Axc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 19:53:32 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F038243AE8;
        Sun, 27 Feb 2022 16:52:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646009574; x=1677545574;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TTb5uTpvyMenyURqmVAtinXx9YdD8xnnaNld1DpmwaY=;
  b=XZPTQM9agWj+stgmgpoQ2W8Dt/PCXWWU3fspbLJF4KCiqPgABJkQD7BT
   U6ZjOWpzc2ATH0+POrbMY7ML5ZsB0DzQXbnauV4IVfLsxtsMGQLN0IoTU
   gKLDtIwWp9ltxZfQ7jY+oBY4gmWoR0KwZnlfp/Gn4HtY37kA8zIhp4BrV
   a8rxeVVYbfdr2meXbb4XnYFmcrOT1ky3fSZ33yNZEofwJu3f4qKviwA+p
   M15RZyoG3w7WWtQAuqWaQkl6IwX/g59Q5agwe9wJm5xwi26tYMzHAp52r
   qI+oduZbDdYgedmiHny0xHBBe3wxeht4Yk9zNK/ffTcujAauHjjhnBphI
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="233394893"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="233394893"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 16:52:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="550020162"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 27 Feb 2022 16:52:47 -0800
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
Subject: [PATCH v7 02/11] driver core: Add dma_cleanup callback in bus_type
Date:   Mon, 28 Feb 2022 08:50:47 +0800
Message-Id: <20220228005056.599595-3-baolu.lu@linux.intel.com>
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

The bus_type structure defines dma_configure() callback for bus drivers
to configure DMA on the devices. This adds the paired dma_cleanup()
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

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/device/bus.h | 3 +++
 drivers/base/dd.c          | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/device/bus.h b/include/linux/device/bus.h
index a039ab809753..d8b29ccd07e5 100644
--- a/include/linux/device/bus.h
+++ b/include/linux/device/bus.h
@@ -59,6 +59,8 @@ struct fwnode_handle;
  *		bus supports.
  * @dma_configure:	Called to setup DMA configuration on a device on
  *			this bus.
+ * @dma_cleanup:	Called to cleanup DMA configuration on a device on
+ *			this bus.
  * @pm:		Power management operations of this bus, callback the specific
  *		device driver's pm-ops.
  * @iommu_ops:  IOMMU specific operations for this bus, used to attach IOMMU
@@ -103,6 +105,7 @@ struct bus_type {
 	int (*num_vf)(struct device *dev);
 
 	int (*dma_configure)(struct device *dev);
+	void (*dma_cleanup)(struct device *dev);
 
 	const struct dev_pm_ops *pm;
 
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 9eaaff2f556c..de05c5c60c6b 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -662,6 +662,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 					     BUS_NOTIFY_DRIVER_NOT_BOUND, dev);
+	if (dev->bus && dev->bus->dma_cleanup)
+		dev->bus->dma_cleanup(dev);
 pinctrl_bind_failed:
 	device_links_no_driver(dev);
 	devres_release_all(dev);
@@ -1205,6 +1207,9 @@ static void __device_release_driver(struct device *dev, struct device *parent)
 		else if (drv->remove)
 			drv->remove(dev);
 
+		if (dev->bus && dev->bus->dma_cleanup)
+			dev->bus->dma_cleanup(dev);
+
 		device_links_driver_cleanup(dev);
 
 		devres_release_all(dev);
-- 
2.25.1

