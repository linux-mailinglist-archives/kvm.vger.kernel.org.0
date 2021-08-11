Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7E53E9468
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 17:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbhHKPST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 11:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbhHKPST (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 11:18:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C36C061765
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 08:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=6D78YXdgenGTinZV115jt+RkOjOa9nQmLmQxdTlVbZI=; b=UWsAyIRncoVp1rmJ7Z2WCnIw//
        +7h7qIjLJV5LH9vTE6vxAPjJ2jJAqMY5FEc9F3+gGWOYIOCA1IzWWE+iurSCmmcwOASLnuUICRt/X
        6t98TXNwlDsPOKFftHslvEoH7TATHWspVuF2J8AeThapgXjBhjCSv5OVV4J1UJxcOmxzHRGAGeJCY
        tQz5rz3BwJqI7Snkddbw4zFHtKVFyb7nIfU5SUAWfHOcNK8A8doDD+OUtpvDu4Di3InY3qlC36q9L
        eV2coa8wxySGlAS2A0pXLJFZ8/JTBPqh2+iiRP6b2kk9CvB8D0kWwumsK2scC6XuAakiryRtkbwPF
        Pg8ptz9w==;
Received: from [2001:4bb8:184:6215:ac7b:970b:bd9c:c36c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDpxE-00DYCX-Vs; Wed, 11 Aug 2021 15:15:59 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 01/14] vfio: Move vfio_iommu_group_get() to vfio_register_group_dev()
Date:   Wed, 11 Aug 2021 17:14:47 +0200
Message-Id: <20210811151500.2744-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210811151500.2744-1-hch@lst.de>
References: <20210811151500.2744-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

We don't need to hold a reference to the group in the driver as well as
obtain a reference to the same group as the first thing
vfio_register_group_dev() does.

Since the drivers never use the group move this all into the core code.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c            | 17 ++-----------
 drivers/vfio/pci/vfio_pci.c                  | 15 ++----------
 drivers/vfio/platform/vfio_platform_common.c | 13 +---------
 drivers/vfio/vfio.c                          | 25 ++++++--------------
 include/linux/vfio.h                         |  3 ---
 5 files changed, 12 insertions(+), 61 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 0ead91bfa83867..9e838fed560339 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -505,22 +505,13 @@ static void vfio_fsl_uninit_device(struct vfio_fsl_mc_device *vdev)
 
 static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 {
-	struct iommu_group *group;
 	struct vfio_fsl_mc_device *vdev;
 	struct device *dev = &mc_dev->dev;
 	int ret;
 
-	group = vfio_iommu_group_get(dev);
-	if (!group) {
-		dev_err(dev, "VFIO_FSL_MC: No IOMMU group\n");
-		return -EINVAL;
-	}
-
 	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
-	if (!vdev) {
-		ret = -ENOMEM;
-		goto out_group_put;
-	}
+	if (!vdev)
+		return -ENOMEM;
 
 	vfio_init_group_dev(&vdev->vdev, dev, &vfio_fsl_mc_ops);
 	vdev->mc_dev = mc_dev;
@@ -556,8 +547,6 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 out_uninit:
 	vfio_uninit_group_dev(&vdev->vdev);
 	kfree(vdev);
-out_group_put:
-	vfio_iommu_group_put(group, dev);
 	return ret;
 }
 
@@ -574,8 +563,6 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
 
 	vfio_uninit_group_dev(&vdev->vdev);
 	kfree(vdev);
-	vfio_iommu_group_put(mc_dev->dev.iommu_group, dev);
-
 	return 0;
 }
 
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index a4f44ea52fa324..b01c1c6cf1f5e6 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1875,7 +1875,6 @@ static void vfio_pci_vga_uninit(struct vfio_pci_device *vdev)
 static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct vfio_pci_device *vdev;
-	struct iommu_group *group;
 	int ret;
 
 	if (vfio_pci_is_denylisted(pdev))
@@ -1897,15 +1896,9 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return -EBUSY;
 	}
 
-	group = vfio_iommu_group_get(&pdev->dev);
-	if (!group)
-		return -EINVAL;
-
 	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
-	if (!vdev) {
-		ret = -ENOMEM;
-		goto out_group_put;
-	}
+	if (!vdev)
+		return -ENOMEM;
 
 	vfio_init_group_dev(&vdev->vdev, &pdev->dev, &vfio_pci_ops);
 	vdev->pdev = pdev;
@@ -1971,8 +1964,6 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	vfio_uninit_group_dev(&vdev->vdev);
 	kfree(vdev->pm_save);
 	kfree(vdev);
-out_group_put:
-	vfio_iommu_group_put(group, &pdev->dev);
 	return ret;
 }
 
@@ -1988,8 +1979,6 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 	vfio_uninit_group_dev(&vdev->vdev);
 	vfio_pci_vga_uninit(vdev);
 
-	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
-
 	if (!disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D0);
 
diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 6af7ce7d619c25..256f55b84e70a0 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -642,7 +642,6 @@ static int vfio_platform_of_probe(struct vfio_platform_device *vdev,
 int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 			       struct device *dev)
 {
-	struct iommu_group *group;
 	int ret;
 
 	vfio_init_group_dev(&vdev->vdev, dev, &vfio_platform_ops);
@@ -663,24 +662,15 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 		goto out_uninit;
 	}
 
-	group = vfio_iommu_group_get(dev);
-	if (!group) {
-		dev_err(dev, "No IOMMU group for device %s\n", vdev->name);
-		ret = -EINVAL;
-		goto put_reset;
-	}
-
 	ret = vfio_register_group_dev(&vdev->vdev);
 	if (ret)
-		goto put_iommu;
+		goto put_reset;
 
 	mutex_init(&vdev->igate);
 
 	pm_runtime_enable(dev);
 	return 0;
 
-put_iommu:
-	vfio_iommu_group_put(group, dev);
 put_reset:
 	vfio_platform_put_reset(vdev);
 out_uninit:
@@ -696,7 +686,6 @@ void vfio_platform_remove_common(struct vfio_platform_device *vdev)
 	pm_runtime_disable(vdev->device);
 	vfio_platform_put_reset(vdev);
 	vfio_uninit_group_dev(&vdev->vdev);
-	vfio_iommu_group_put(vdev->vdev.dev->iommu_group, vdev->vdev.dev);
 }
 EXPORT_SYMBOL_GPL(vfio_platform_remove_common);
 
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 3c034fe14ccb03..5bd520f0dc6107 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -169,15 +169,7 @@ static void vfio_release_device_set(struct vfio_device *device)
 	xa_unlock(&vfio_device_set_xa);
 }
 
-/*
- * vfio_iommu_group_{get,put} are only intended for VFIO bus driver probe
- * and remove functions, any use cases other than acquiring the first
- * reference for the purpose of calling vfio_register_group_dev() or removing
- * that symmetric reference after vfio_unregister_group_dev() should use the raw
- * iommu_group_{get,put} functions.  In particular, vfio_iommu_group_put()
- * removes the device from the dummy group and cannot be nested.
- */
-struct iommu_group *vfio_iommu_group_get(struct device *dev)
+static struct iommu_group *vfio_iommu_group_get(struct device *dev)
 {
 	struct iommu_group *group;
 	int __maybe_unused ret;
@@ -220,9 +212,8 @@ struct iommu_group *vfio_iommu_group_get(struct device *dev)
 
 	return group;
 }
-EXPORT_SYMBOL_GPL(vfio_iommu_group_get);
 
-void vfio_iommu_group_put(struct iommu_group *group, struct device *dev)
+static void vfio_iommu_group_put(struct iommu_group *group, struct device *dev)
 {
 #ifdef CONFIG_VFIO_NOIOMMU
 	if (iommu_group_get_iommudata(group) == &noiommu)
@@ -231,7 +222,6 @@ void vfio_iommu_group_put(struct iommu_group *group, struct device *dev)
 
 	iommu_group_put(group);
 }
-EXPORT_SYMBOL_GPL(vfio_iommu_group_put);
 
 #ifdef CONFIG_VFIO_NOIOMMU
 static void *vfio_noiommu_open(unsigned long arg)
@@ -841,7 +831,7 @@ int vfio_register_group_dev(struct vfio_device *device)
 	if (!device->dev_set)
 		vfio_assign_device_set(device, device);
 
-	iommu_group = iommu_group_get(device->dev);
+	iommu_group = vfio_iommu_group_get(device->dev);
 	if (!iommu_group)
 		return -EINVAL;
 
@@ -849,7 +839,7 @@ int vfio_register_group_dev(struct vfio_device *device)
 	if (!group) {
 		group = vfio_create_group(iommu_group);
 		if (IS_ERR(group)) {
-			iommu_group_put(iommu_group);
+			vfio_iommu_group_put(iommu_group, device->dev);
 			return PTR_ERR(group);
 		}
 	} else {
@@ -857,7 +847,7 @@ int vfio_register_group_dev(struct vfio_device *device)
 		 * A found vfio_group already holds a reference to the
 		 * iommu_group.  A created vfio_group keeps the reference.
 		 */
-		iommu_group_put(iommu_group);
+		vfio_iommu_group_put(iommu_group, device->dev);
 	}
 
 	existing_device = vfio_group_get_device(group, device->dev);
@@ -865,7 +855,7 @@ int vfio_register_group_dev(struct vfio_device *device)
 		dev_WARN(device->dev, "Device already exists on group %d\n",
 			 iommu_group_id(iommu_group));
 		vfio_device_put(existing_device);
-		vfio_group_put(group);
+		vfio_iommu_group_put(iommu_group, device->dev);
 		return -EBUSY;
 	}
 
@@ -1010,8 +1000,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 	if (list_empty(&group->device_list))
 		wait_event(group->container_q, !group->container);
 
-	/* Matches the get in vfio_register_group_dev() */
-	vfio_group_put(group);
+	vfio_iommu_group_put(group->iommu_group, device->dev);
 }
 EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
 
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index b53a9557884ada..f7083c2fd0d099 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -71,9 +71,6 @@ struct vfio_device_ops {
 	int	(*match)(struct vfio_device *vdev, char *buf);
 };
 
-extern struct iommu_group *vfio_iommu_group_get(struct device *dev);
-extern void vfio_iommu_group_put(struct iommu_group *group, struct device *dev);
-
 void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
 			 const struct vfio_device_ops *ops);
 void vfio_uninit_group_dev(struct vfio_device *device);
-- 
2.30.2

