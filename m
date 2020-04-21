Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C721B334E
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 01:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgDUXej (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 19:34:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:36898 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbgDUXei (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 19:34:38 -0400
IronPort-SDR: gUohqOewZhV6j32SsuJNR+vY/NUQxWRteTj4YJVdOFT8s+cz41NbnuullmMTP/2iPQjQxRmk38
 rTgbWLIiIuzA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 16:34:37 -0700
IronPort-SDR: ZYAjYixMVxHs0BuS7CR9a768GC36QrbGrfIo3IG6FMmvuu65RRToBv/27KZP8lrFfysWeYugkb
 CvrCRBIVIeUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="258876497"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga006.jf.intel.com with ESMTP; 21 Apr 2020 16:34:36 -0700
Subject: [PATCH RFC 08/15] vfio/mdev: Add a member for iommu domain in
 mdev_device
From:   Dave Jiang <dave.jiang@intel.com>
To:     vkoul@kernel.org, megha.dey@linux.intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, hpa@zytor.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, jgg@mellanox.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 21 Apr 2020 16:34:36 -0700
Message-ID: <158751207630.36773.14545210630713509626.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

This adds a member to save iommu domain in mdev_device
structure. Whenever an iommu domain is attached to the
mediated device, it must be save here so that a VDCM
(Virtual Device Control Module) could retreive it.

Below member is added in struct mdev_device:
* iommu_domain
  - A place to save the iommu domain attached to this
    mdev.

Below helpers are added to set and get iommu domain in
struct mdev_device.
* mdev_set/get_iommu_domain(domain)
  - A iommu domain which has been attached to the iommu
    device in order to protect and isolate the mediated
    device will be kept in the mdev data structure and
    could be retrieved later.

Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Liu Yi L <yi.l.liu@intel.com>
Suggested-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/vfio/mdev/mdev_core.c    |   16 ++++++++++++++++
 drivers/vfio/mdev/mdev_private.h |    1 +
 include/linux/mdev.h             |   10 ++++++++++
 3 files changed, 27 insertions(+)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index cecc6a6bdbef..15863cf83f3f 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -410,6 +410,22 @@ struct device *mdev_get_iommu_device(struct device *dev)
 }
 EXPORT_SYMBOL(mdev_get_iommu_device);
 
+void mdev_set_iommu_domain(struct device *dev, void *domain)
+{
+	struct mdev_device *mdev = to_mdev_device(dev);
+
+	mdev->iommu_domain = domain;
+}
+EXPORT_SYMBOL(mdev_set_iommu_domain);
+
+void *mdev_get_iommu_domain(struct device *dev)
+{
+	struct mdev_device *mdev = to_mdev_device(dev);
+
+	return mdev->iommu_domain;
+}
+EXPORT_SYMBOL(mdev_get_iommu_domain);
+
 static int __init mdev_init(void)
 {
 	return mdev_bus_register();
diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index c21f1305a76b..c97478b22a02 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -32,6 +32,7 @@ struct mdev_device {
 	struct list_head next;
 	struct kobject *type_kobj;
 	struct device *iommu_device;
+	void *iommu_domain;
 	bool active;
 };
 
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index fa2344e239ef..0d66daaecc67 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -26,6 +26,16 @@ int mdev_set_iommu_device(struct device *dev, struct device *iommu_device);
 
 struct device *mdev_get_iommu_device(struct device *dev);
 
+/*
+ * Called by vfio iommu modules to save the iommu domain after a domain being
+ * attached to the mediated device. The vDCM (virtual device control module)
+ * could call mdev_get_iommu_domain() to retrieve an auxiliary domain attached
+ * to an mdev.
+ */
+void mdev_set_iommu_domain(struct device *dev, void *domain);
+
+void *mdev_get_iommu_domain(struct device *dev);
+
 /**
  * struct mdev_parent_ops - Structure to be registered for each parent device to
  * register the device to mdev module.

