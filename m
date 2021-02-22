Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86C7321D71
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 17:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhBVQwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 11:52:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59050 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231292AbhBVQwZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 11:52:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614012658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3d+4akFeShefY1mDCC6qtlOmhNGy6H9oh3THeYy9xOs=;
        b=UaBeGAP4EmLflcrj3Vp9QOS56MMHg4tuXG4YTrADpiXtgHnSddPQFlSdwRZFQSlB1JOfm/
        AGC//hlM69Fv/AYVNdymNC9gbHmvZIMK01KhRIRMerBwUm68pBd59CcBhvNB6nafctVgxn
        ZEenjO4FLo8BcmSvqjKPRi/aU8DwWII=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-wIHTWIsqOzuklEt-q2uO8g-1; Mon, 22 Feb 2021 11:50:55 -0500
X-MC-Unique: wIHTWIsqOzuklEt-q2uO8g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34D45CC621;
        Mon, 22 Feb 2021 16:50:54 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB1225D71D;
        Mon, 22 Feb 2021 16:50:47 +0000 (UTC)
Subject: [RFC PATCH 02/10] vfio: Update vfio_add_group_dev() API
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Mon, 22 Feb 2021 09:50:47 -0700
Message-ID: <161401264735.16443.5908636631567017543.stgit@gimli.home>
In-Reply-To: <161401167013.16443.8389863523766611711.stgit@gimli.home>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
User-Agent: StGit/0.21-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rather than an errno, return a pointer to the opaque vfio_device
to allow the bus driver to call into vfio-core without additional
lookups and references.  Note that bus drivers are still required
to use vfio_del_group_dev() to teardown the vfio_device.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c            |    6 ++++--
 drivers/vfio/mdev/vfio_mdev.c                |    5 ++++-
 drivers/vfio/pci/vfio_pci.c                  |    7 +++++--
 drivers/vfio/platform/vfio_platform_common.c |    7 +++++--
 drivers/vfio/vfio.c                          |   23 ++++++++++-------------
 include/linux/vfio.h                         |    6 +++---
 6 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index f27e25112c40..a4c2d0b9cd51 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -592,6 +592,7 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 	struct iommu_group *group;
 	struct vfio_fsl_mc_device *vdev;
 	struct device *dev = &mc_dev->dev;
+	struct vfio_device *device;
 	int ret;
 
 	group = vfio_iommu_group_get(dev);
@@ -608,8 +609,9 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 
 	vdev->mc_dev = mc_dev;
 
-	ret = vfio_add_group_dev(dev, &vfio_fsl_mc_ops, vdev);
-	if (ret) {
+	device = vfio_add_group_dev(dev, &vfio_fsl_mc_ops, vdev);
+	if (IS_ERR(device)) {
+		ret = PTR_ERR(device);
 		dev_err(dev, "VFIO_FSL_MC: Failed to add to vfio group\n");
 		goto out_group_put;
 	}
diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index b52eea128549..32901b265864 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -124,8 +124,11 @@ static const struct vfio_device_ops vfio_mdev_dev_ops = {
 static int vfio_mdev_probe(struct device *dev)
 {
 	struct mdev_device *mdev = to_mdev_device(dev);
+	struct vfio_device *device;
 
-	return vfio_add_group_dev(dev, &vfio_mdev_dev_ops, mdev);
+	device = vfio_add_group_dev(dev, &vfio_mdev_dev_ops, mdev);
+
+	return IS_ERR(device) ? PTR_ERR(device) : 0;
 }
 
 static void vfio_mdev_remove(struct device *dev)
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 65e7e6b44578..f0a1d05f0137 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1926,6 +1926,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct vfio_pci_device *vdev;
 	struct iommu_group *group;
+	struct vfio_device *device;
 	int ret;
 
 	if (vfio_pci_is_denylisted(pdev))
@@ -1968,9 +1969,11 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&vdev->vma_list);
 	init_rwsem(&vdev->memory_lock);
 
-	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
-	if (ret)
+	device = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
+	if (IS_ERR(device)) {
+		ret = PTR_ERR(device);
 		goto out_free;
+	}
 
 	ret = vfio_pci_reflck_attach(vdev);
 	if (ret)
diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index fb4b385191f2..ff41fe0b758e 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -657,6 +657,7 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 			       struct device *dev)
 {
 	struct iommu_group *group;
+	struct vfio_device *device;
 	int ret;
 
 	if (!vdev)
@@ -685,9 +686,11 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 		goto put_reset;
 	}
 
-	ret = vfio_add_group_dev(dev, &vfio_platform_ops, vdev);
-	if (ret)
+	device = vfio_add_group_dev(dev, &vfio_platform_ops, vdev);
+	if (IS_ERR(device)) {
+		ret = PTR_ERR(device);
 		goto put_iommu;
+	}
 
 	mutex_init(&vdev->igate);
 
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 464caef97aff..067cd843961c 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -848,8 +848,9 @@ static int vfio_iommu_group_notifier(struct notifier_block *nb,
 /**
  * VFIO driver API
  */
-int vfio_add_group_dev(struct device *dev,
-		       const struct vfio_device_ops *ops, void *device_data)
+struct vfio_device *vfio_add_group_dev(struct device *dev,
+				       const struct vfio_device_ops *ops,
+				       void *device_data)
 {
 	struct iommu_group *iommu_group;
 	struct vfio_group *group;
@@ -857,14 +858,14 @@ int vfio_add_group_dev(struct device *dev,
 
 	iommu_group = iommu_group_get(dev);
 	if (!iommu_group)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	group = vfio_group_get_from_iommu(iommu_group);
 	if (!group) {
 		group = vfio_create_group(iommu_group);
 		if (IS_ERR(group)) {
 			iommu_group_put(iommu_group);
-			return PTR_ERR(group);
+			return (struct vfio_device *)group;
 		}
 	} else {
 		/*
@@ -880,23 +881,19 @@ int vfio_add_group_dev(struct device *dev,
 			 iommu_group_id(iommu_group));
 		vfio_device_put(device);
 		vfio_group_put(group);
-		return -EBUSY;
+		return ERR_PTR(-EBUSY);
 	}
 
 	device = vfio_group_create_device(group, dev, ops, device_data);
-	if (IS_ERR(device)) {
-		vfio_group_put(group);
-		return PTR_ERR(device);
-	}
 
 	/*
-	 * Drop all but the vfio_device reference.  The vfio_device holds
-	 * a reference to the vfio_group, which holds a reference to the
-	 * iommu_group.
+	 * Drop all but the vfio_device reference.  The vfio_device, if
+	 * !IS_ERR() holds a reference to the vfio_group, which holds a
+	 * reference to the iommu_group.
 	 */
 	vfio_group_put(group);
 
-	return 0;
+	return device;
 }
 EXPORT_SYMBOL_GPL(vfio_add_group_dev);
 
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index b7e18bde5aa8..b784463000d4 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -48,9 +48,9 @@ struct vfio_device_ops {
 extern struct iommu_group *vfio_iommu_group_get(struct device *dev);
 extern void vfio_iommu_group_put(struct iommu_group *group, struct device *dev);
 
-extern int vfio_add_group_dev(struct device *dev,
-			      const struct vfio_device_ops *ops,
-			      void *device_data);
+extern struct vfio_device *vfio_add_group_dev(struct device *dev,
+					const struct vfio_device_ops *ops,
+					void *device_data);
 
 extern void *vfio_del_group_dev(struct device *dev);
 extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);

