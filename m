Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1915283D77
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 19:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbgJERhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 13:37:21 -0400
Received: from inva020.nxp.com ([92.121.34.13]:52148 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728565AbgJERhC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 13:37:02 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 184191A0943;
        Mon,  5 Oct 2020 19:37:00 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 08FC31A0940;
        Mon,  5 Oct 2020 19:37:00 +0200 (CEST)
Received: from fsr-ub1864-111.ea.freescale.net (fsr-ub1864-111.ea.freescale.net [10.171.82.141])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id B5FBA2032B;
        Mon,  5 Oct 2020 19:36:59 +0200 (CEST)
From:   Diana Craciun <diana.craciun@oss.nxp.com>
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Diana Craciun <diana.craciun@oss.nxp.com>
Subject: [PATCH v6 06/10] vfio/fsl-mc: Added lock support in preparation for interrupt handling
Date:   Mon,  5 Oct 2020 20:36:50 +0300
Message-Id: <20201005173654.31773-7-diana.craciun@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201005173654.31773-1-diana.craciun@oss.nxp.com>
References: <20201005173654.31773-1-diana.craciun@oss.nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Only the DPRC object allocates interrupts from the MSI
interrupt domain. The interrupts are managed by the DPRC in
a pool of interrupts. The access to this pool of interrupts
has to be protected with a lock.
This patch extends the current lock implementation to have a
lock per DPRC.

Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 92 +++++++++++++++++++++--
 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  7 +-
 2 files changed, 90 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 55190a2730fb..b52407c4e1ea 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -17,6 +17,78 @@
 
 static struct fsl_mc_driver vfio_fsl_mc_driver;
 
+static DEFINE_MUTEX(reflck_lock);
+
+static void vfio_fsl_mc_reflck_get(struct vfio_fsl_mc_reflck *reflck)
+{
+	kref_get(&reflck->kref);
+}
+
+static void vfio_fsl_mc_reflck_release(struct kref *kref)
+{
+	struct vfio_fsl_mc_reflck *reflck = container_of(kref,
+						      struct vfio_fsl_mc_reflck,
+						      kref);
+
+	mutex_destroy(&reflck->lock);
+	kfree(reflck);
+	mutex_unlock(&reflck_lock);
+}
+
+static void vfio_fsl_mc_reflck_put(struct vfio_fsl_mc_reflck *reflck)
+{
+	kref_put_mutex(&reflck->kref, vfio_fsl_mc_reflck_release, &reflck_lock);
+}
+
+static struct vfio_fsl_mc_reflck *vfio_fsl_mc_reflck_alloc(void)
+{
+	struct vfio_fsl_mc_reflck *reflck;
+
+	reflck = kzalloc(sizeof(*reflck), GFP_KERNEL);
+	if (!reflck)
+		return ERR_PTR(-ENOMEM);
+
+	kref_init(&reflck->kref);
+	mutex_init(&reflck->lock);
+
+	return reflck;
+}
+
+static int vfio_fsl_mc_reflck_attach(struct vfio_fsl_mc_device *vdev)
+{
+	int ret;
+
+	mutex_lock(&reflck_lock);
+	if (is_fsl_mc_bus_dprc(vdev->mc_dev)) {
+		vdev->reflck = vfio_fsl_mc_reflck_alloc();
+		ret = PTR_ERR_OR_ZERO(vdev->reflck);
+	} else {
+		struct device *mc_cont_dev = vdev->mc_dev->dev.parent;
+		struct vfio_device *device;
+		struct vfio_fsl_mc_device *cont_vdev;
+
+		device = vfio_device_get_from_dev(mc_cont_dev);
+		if (!device) {
+			ret = -ENODEV;
+			goto unlock;
+		}
+
+		cont_vdev = vfio_device_data(device);
+		if (!cont_vdev || !cont_vdev->reflck) {
+			vfio_device_put(device);
+			ret = -ENODEV;
+			goto unlock;
+		}
+		vfio_fsl_mc_reflck_get(cont_vdev->reflck);
+		vdev->reflck = cont_vdev->reflck;
+		vfio_device_put(device);
+	}
+
+unlock:
+	mutex_unlock(&reflck_lock);
+	return ret;
+}
+
 static int vfio_fsl_mc_regions_init(struct vfio_fsl_mc_device *vdev)
 {
 	struct fsl_mc_device *mc_dev = vdev->mc_dev;
@@ -62,7 +134,7 @@ static int vfio_fsl_mc_open(void *device_data)
 	if (!try_module_get(THIS_MODULE))
 		return -ENODEV;
 
-	mutex_lock(&vdev->driver_lock);
+	mutex_lock(&vdev->reflck->lock);
 	if (!vdev->refcnt) {
 		ret = vfio_fsl_mc_regions_init(vdev);
 		if (ret)
@@ -70,12 +142,12 @@ static int vfio_fsl_mc_open(void *device_data)
 	}
 	vdev->refcnt++;
 
-	mutex_unlock(&vdev->driver_lock);
+	mutex_unlock(&vdev->reflck->lock);
 
 	return 0;
 
 err_reg_init:
-	mutex_unlock(&vdev->driver_lock);
+	mutex_unlock(&vdev->reflck->lock);
 	module_put(THIS_MODULE);
 	return ret;
 }
@@ -84,12 +156,12 @@ static void vfio_fsl_mc_release(void *device_data)
 {
 	struct vfio_fsl_mc_device *vdev = device_data;
 
-	mutex_lock(&vdev->driver_lock);
+	mutex_lock(&vdev->reflck->lock);
 
 	if (!(--vdev->refcnt))
 		vfio_fsl_mc_regions_cleanup(vdev);
 
-	mutex_unlock(&vdev->driver_lock);
+	mutex_unlock(&vdev->reflck->lock);
 
 	module_put(THIS_MODULE);
 }
@@ -343,14 +415,18 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 		goto out_group_put;
 	}
 
-	ret = vfio_fsl_mc_init_device(vdev);
+	ret = vfio_fsl_mc_reflck_attach(vdev);
 	if (ret)
 		goto out_group_dev;
 
-	mutex_init(&vdev->driver_lock);
+	ret = vfio_fsl_mc_init_device(vdev);
+	if (ret)
+		goto out_reflck;
 
 	return 0;
 
+out_reflck:
+	vfio_fsl_mc_reflck_put(vdev->reflck);
 out_group_dev:
 	vfio_del_group_dev(dev);
 out_group_put:
@@ -367,7 +443,7 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
 	if (!vdev)
 		return -EINVAL;
 
-	mutex_destroy(&vdev->driver_lock);
+	vfio_fsl_mc_reflck_put(vdev->reflck);
 
 	if (is_fsl_mc_bus_dprc(mc_dev)) {
 		dprc_remove_devices(mc_dev, NULL, 0);
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
index be60f41af30f..d47ef6215429 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
@@ -15,6 +15,11 @@
 #define VFIO_FSL_MC_INDEX_TO_OFFSET(index)	\
 	((u64)(index) << VFIO_FSL_MC_OFFSET_SHIFT)
 
+struct vfio_fsl_mc_reflck {
+	struct kref		kref;
+	struct mutex		lock;
+};
+
 struct vfio_fsl_mc_region {
 	u32			flags;
 	u32			type;
@@ -27,7 +32,7 @@ struct vfio_fsl_mc_device {
 	struct notifier_block        nb;
 	int				refcnt;
 	struct vfio_fsl_mc_region	*regions;
-	struct mutex driver_lock;
+	struct vfio_fsl_mc_reflck   *reflck;
 };
 
 #endif /* VFIO_FSL_MC_PRIVATE_H */
-- 
2.17.1

