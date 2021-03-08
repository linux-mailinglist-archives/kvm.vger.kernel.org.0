Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E88331990
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 22:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhCHVsR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 16:48:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28983 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230342AbhCHVrv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 16:47:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615240070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mcBBJ8/DsjCOp6AAjE3kwckspOlsAATYaDIZrfP5u90=;
        b=NTpl24m7z52Cr5Ds9l1lJRpX8ID21vxVerG/zhTqHMy0shcmsDvZmBmTVEiJqOMByDxqi8
        AKNr1HJnF7WbsgNVJw7CX1+SU+XCYt2GfoLzypUuH6Hle8MbtXlJh/E1+o79E/kpo4RYjQ
        3fxi0BWhhgm+zeXnni0Npd4IJf0i1K4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-3kgx176DMxihEZ4wTVoImw-1; Mon, 08 Mar 2021 16:47:48 -0500
X-MC-Unique: 3kgx176DMxihEZ4wTVoImw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6839107B018;
        Mon,  8 Mar 2021 21:47:47 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E613918B42;
        Mon,  8 Mar 2021 21:47:40 +0000 (UTC)
Subject: [PATCH v1 02/14] vfio: Update vfio_add_group_dev() API
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Mon, 08 Mar 2021 14:47:40 -0700
Message-ID: <161524006056.3480.3931750068527641030.stgit@gimli.home>
In-Reply-To: <161523878883.3480.12103845207889888280.stgit@gimli.home>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
User-Agent: StGit/0.21-2-g8ef5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rather than an errno, return a pointer to the opaque vfio_device
to allow the bus driver to call into vfio-core without additional
lookups and references.  Note that bus drivers are still required
to use vfio_del_group_dev() to teardown the vfio_device.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 Documentation/driver-api/vfio.rst            |    6 +++---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c            |    6 ++++--
 drivers/vfio/mdev/vfio_mdev.c                |    5 ++++-
 drivers/vfio/pci/vfio_pci.c                  |    7 +++++--
 drivers/vfio/platform/vfio_platform_common.c |    7 +++++--
 drivers/vfio/vfio.c                          |   23 ++++++++++-------------
 include/linux/vfio.h                         |    6 +++---
 7 files changed, 34 insertions(+), 26 deletions(-)

diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
index f1a4d3c3ba0b..03e978eb8ec7 100644
--- a/Documentation/driver-api/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -252,9 +252,9 @@ into VFIO core.  When devices are bound and unbound to the driver,
 the driver should call vfio_add_group_dev() and vfio_del_group_dev()
 respectively::
 
-	extern int vfio_add_group_dev(struct device *dev,
-				      const struct vfio_device_ops *ops,
-				      void *device_data);
+	extern struct vfio_device *vfio_add_group_dev(struct device *dev,
+					const struct vfio_device_ops *ops,
+					void *device_data);
 
 	extern void *vfio_del_group_dev(struct device *dev);
 
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
index b52eea128549..ebae3871b155 100644
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
+	return PTR_ERR_OR_ZERO(device);
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
index abdf8d52a911..34d32f16246a 100644
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
+			return ERR_CAST(group);
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

