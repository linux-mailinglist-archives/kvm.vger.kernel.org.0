Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3E0215B0F
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 17:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbgGFPnD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 11:43:03 -0400
Received: from inva021.nxp.com ([92.121.34.21]:36256 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729197AbgGFPmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 11:42:16 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 92D0A2006DB;
        Mon,  6 Jul 2020 17:42:14 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 860D32006D9;
        Mon,  6 Jul 2020 17:42:14 +0200 (CEST)
Received: from fsr-ub1864-111.ea.freescale.net (fsr-ub1864-111.ea.freescale.net [10.171.82.141])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 4004D203C3;
        Mon,  6 Jul 2020 17:42:14 +0200 (CEST)
From:   Diana Craciun <diana.craciun@oss.nxp.com>
To:     alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     bharatb.linux@gmail.com, linux-kernel@vger.kernel.org,
        laurentiu.tudor@nxp.com, Diana Craciun <diana.craciun@nxp.com>
Subject: [PATCH v3 6/9] vfio/fsl-mc: Added lock support in preparation for interrupt handling
Date:   Mon,  6 Jul 2020 18:41:50 +0300
Message-Id: <20200706154153.11477-7-diana.craciun@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200706154153.11477-1-diana.craciun@oss.nxp.com>
References: <20200706154153.11477-1-diana.craciun@oss.nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Diana Craciun <diana.craciun@nxp.com>

Only the DPRC object allocates interrupts from the MSI
interrupt domain. The interrupts are managed by the DPRC in
a pool of interrupts. The access to this pool of interrupts
has to be protected with a lock.
This patch extends the current lock implementation to have a
lock per DPRC.

Signed-off-by: Diana Craciun <diana.craciun@nxp.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 90 +++++++++++++++++++++--
 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  8 +-
 2 files changed, 91 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 37ccc7d2acbc..275c4283e1bc 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -17,6 +17,76 @@
 
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
+	int ret = 0;
+
+	mutex_lock(&reflck_lock);
+	if (is_fsl_mc_bus_dprc(vdev->mc_dev)) {
+		vdev->reflck = vfio_fsl_mc_reflck_alloc();
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
+		if (!cont_vdev->reflck) {
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
@@ -55,7 +125,7 @@ static int vfio_fsl_mc_open(void *device_data)
 	if (!try_module_get(THIS_MODULE))
 		return -ENODEV;
 
-	mutex_lock(&vdev->driver_lock);
+	mutex_lock(&vdev->reflck->lock);
 	if (!vdev->refcnt) {
 		ret = vfio_fsl_mc_regions_init(vdev);
 		if (ret)
@@ -63,12 +133,12 @@ static int vfio_fsl_mc_open(void *device_data)
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
@@ -77,12 +147,12 @@ static void vfio_fsl_mc_release(void *device_data)
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
@@ -325,12 +395,18 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 		return ret;
 	}
 
+	ret = vfio_fsl_mc_reflck_attach(vdev);
+	if (ret) {
+		vfio_iommu_group_put(group, dev);
+		return ret;
+	}
+
 	ret = vfio_fsl_mc_init_device(vdev);
 	if (ret < 0) {
+		vfio_fsl_mc_reflck_put(vdev->reflck);
 		vfio_iommu_group_put(group, dev);
 		return ret;
 	}
-	mutex_init(&vdev->driver_lock);
 
 	return ret;
 }
@@ -374,6 +450,8 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
 	if (vdev->nb.notifier_call)
 		bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
 
+	vfio_fsl_mc_reflck_put(vdev->reflck);
+
 	if (is_fsl_mc_bus_dprc(mc_dev))
 		vfio_fsl_mc_cleanup_dprc(vdev->mc_dev);
 
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
index 818dfd3df4db..3b85d930e060 100644
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
@@ -28,7 +33,8 @@ struct vfio_fsl_mc_device {
 	int				refcnt;
 	u32				num_regions;
 	struct vfio_fsl_mc_region	*regions;
-	struct mutex driver_lock;
+	struct vfio_fsl_mc_reflck   *reflck;
+
 };
 
 #endif /* VFIO_FSL_MC_PRIVATE_H */
-- 
2.17.1

