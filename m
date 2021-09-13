Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59BA240853D
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 09:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237557AbhIMHUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 03:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235199AbhIMHUw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 03:20:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D63C061574
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 00:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=9Oil5BzlHqRol0pAtcJCXA8lrhvtbtv2zf5zkpsh/V8=; b=b1k+wmCQ3pqRA+EwVFgr2sDQVm
        M5h57cg+gxhWEZym64W6mKyMYw1oC+dLKZ7HOfIkgBssaawsOxTubYyFt0eFZ21HrbGVdXIr1LB+t
        lk0Wk00J2mtR4uSKej8X1c8Ju3VkaTanFGuOZN/KLabumTyhJgf/R+N42m4cEv7OJyJ9+kU7KZ0TO
        PK+saYAfsjXtHFykBjuIHTcfVGxA0FmHhJJ5lTxuKBSfXruNg8iTOODFOkqNMUpJs2yCfsG430dLc
        7gqT92p7i53leSWAkuo5OhrJ3ZLRZh3e09zw1l/NpnAPG7AOh+iij2Q6mXO+IVxa/Gmf4AYpGudt4
        l4GluqtA==;
Received: from 213-225-6-64.nat.highway.a1.net ([213.225.6.64] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mPgDM-00DGG3-NE; Mon, 13 Sep 2021 07:17:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Terrence Xu <terrence.xu@intel.com>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 01/14] vfio: Move vfio_iommu_group_get() to vfio_register_group_dev()
Date:   Mon, 13 Sep 2021 09:15:53 +0200
Message-Id: <20210913071606.2966-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913071606.2966-1-hch@lst.de>
References: <20210913071606.2966-1-hch@lst.de>
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
 drivers/vfio/fsl-mc/vfio_fsl_mc.c            | 17 ++-------
 drivers/vfio/pci/vfio_pci_core.c             | 13 ++-----
 drivers/vfio/platform/vfio_platform_common.c | 13 +------
 drivers/vfio/vfio.c                          | 36 ++++++++------------
 include/linux/vfio.h                         |  3 --
 5 files changed, 19 insertions(+), 63 deletions(-)

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
 
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 68198e0f2a6310..43bab0ca3e682d 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1806,7 +1806,6 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_uninit_device);
 int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
-	struct iommu_group *group;
 	int ret;
 
 	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
@@ -1825,10 +1824,6 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 		return -EBUSY;
 	}
 
-	group = vfio_iommu_group_get(&pdev->dev);
-	if (!group)
-		return -EINVAL;
-
 	if (pci_is_root_bus(pdev->bus)) {
 		ret = vfio_assign_device_set(&vdev->vdev, vdev);
 	} else if (!pci_probe_reset_slot(pdev->slot)) {
@@ -1842,10 +1837,10 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 	}
 
 	if (ret)
-		goto out_group_put;
+		return ret;
 	ret = vfio_pci_vf_init(vdev);
 	if (ret)
-		goto out_group_put;
+		return ret;
 	ret = vfio_pci_vga_init(vdev);
 	if (ret)
 		goto out_vf;
@@ -1876,8 +1871,6 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 		vfio_pci_set_power_state(vdev, PCI_D0);
 out_vf:
 	vfio_pci_vf_uninit(vdev);
-out_group_put:
-	vfio_iommu_group_put(group, &pdev->dev);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_register_device);
@@ -1893,8 +1886,6 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 	vfio_pci_vf_uninit(vdev);
 	vfio_pci_vga_uninit(vdev);
 
-	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
-
 	if (!disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D0);
 }
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
index 3c034fe14ccb03..b39da9b90c95bc 100644
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
@@ -220,18 +212,6 @@ struct iommu_group *vfio_iommu_group_get(struct device *dev)
 
 	return group;
 }
-EXPORT_SYMBOL_GPL(vfio_iommu_group_get);
-
-void vfio_iommu_group_put(struct iommu_group *group, struct device *dev)
-{
-#ifdef CONFIG_VFIO_NOIOMMU
-	if (iommu_group_get_iommudata(group) == &noiommu)
-		iommu_group_remove_device(dev);
-#endif
-
-	iommu_group_put(group);
-}
-EXPORT_SYMBOL_GPL(vfio_iommu_group_put);
 
 #ifdef CONFIG_VFIO_NOIOMMU
 static void *vfio_noiommu_open(unsigned long arg)
@@ -841,7 +821,7 @@ int vfio_register_group_dev(struct vfio_device *device)
 	if (!device->dev_set)
 		vfio_assign_device_set(device, device);
 
-	iommu_group = iommu_group_get(device->dev);
+	iommu_group = vfio_iommu_group_get(device->dev);
 	if (!iommu_group)
 		return -EINVAL;
 
@@ -849,6 +829,10 @@ int vfio_register_group_dev(struct vfio_device *device)
 	if (!group) {
 		group = vfio_create_group(iommu_group);
 		if (IS_ERR(group)) {
+#ifdef CONFIG_VFIO_NOIOMMU
+			if (iommu_group_get_iommudata(iommu_group) == &noiommu)
+				iommu_group_remove_device(device->dev);
+#endif
 			iommu_group_put(iommu_group);
 			return PTR_ERR(group);
 		}
@@ -865,6 +849,10 @@ int vfio_register_group_dev(struct vfio_device *device)
 		dev_WARN(device->dev, "Device already exists on group %d\n",
 			 iommu_group_id(iommu_group));
 		vfio_device_put(existing_device);
+#ifdef CONFIG_VFIO_NOIOMMU
+		if (iommu_group_get_iommudata(iommu_group) == &noiommu)
+			iommu_group_remove_device(device->dev);
+#endif
 		vfio_group_put(group);
 		return -EBUSY;
 	}
@@ -1010,6 +998,10 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 	if (list_empty(&group->device_list))
 		wait_event(group->container_q, !group->container);
 
+#ifdef CONFIG_VFIO_NOIOMMU
+	if (iommu_group_get_iommudata(group) == &noiommu)
+		iommu_group_remove_device(dev);
+#endif
 	/* Matches the get in vfio_register_group_dev() */
 	vfio_group_put(group);
 }
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

