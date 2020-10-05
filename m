Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0948283D7B
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 19:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbgJERhg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 13:37:36 -0400
Received: from inva021.nxp.com ([92.121.34.21]:44668 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728492AbgJERhB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 13:37:01 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 4CD762015AD;
        Mon,  5 Oct 2020 19:36:59 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 49C822007BB;
        Mon,  5 Oct 2020 19:36:59 +0200 (CEST)
Received: from fsr-ub1864-111.ea.freescale.net (fsr-ub1864-111.ea.freescale.net [10.171.82.141])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id EAFD12032B;
        Mon,  5 Oct 2020 19:36:58 +0200 (CEST)
From:   Diana Craciun <diana.craciun@oss.nxp.com>
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Diana Craciun <diana.craciun@oss.nxp.com>,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>
Subject: [PATCH v6 04/10] vfio/fsl-mc: Implement VFIO_DEVICE_GET_REGION_INFO ioctl call
Date:   Mon,  5 Oct 2020 20:36:48 +0300
Message-Id: <20201005173654.31773-5-diana.craciun@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201005173654.31773-1-diana.craciun@oss.nxp.com>
References: <20201005173654.31773-1-diana.craciun@oss.nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expose to userspace information about the memory regions.

Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 79 ++++++++++++++++++++++-
 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h | 18 ++++++
 2 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 161c2cbe07dc..05dace5ddc2c 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -17,16 +17,71 @@
 
 static struct fsl_mc_driver vfio_fsl_mc_driver;
 
+static int vfio_fsl_mc_regions_init(struct vfio_fsl_mc_device *vdev)
+{
+	struct fsl_mc_device *mc_dev = vdev->mc_dev;
+	int count = mc_dev->obj_desc.region_count;
+	int i;
+
+	vdev->regions = kcalloc(count, sizeof(struct vfio_fsl_mc_region),
+				GFP_KERNEL);
+	if (!vdev->regions)
+		return -ENOMEM;
+
+	for (i = 0; i < count; i++) {
+		struct resource *res = &mc_dev->regions[i];
+
+		vdev->regions[i].addr = res->start;
+		vdev->regions[i].size = resource_size(res);
+		vdev->regions[i].flags = 0;
+		vdev->regions[i].type = mc_dev->regions[i].flags & IORESOURCE_BITS;
+	}
+
+	return 0;
+}
+
+static void vfio_fsl_mc_regions_cleanup(struct vfio_fsl_mc_device *vdev)
+{
+	kfree(vdev->regions);
+}
+
 static int vfio_fsl_mc_open(void *device_data)
 {
+	struct vfio_fsl_mc_device *vdev = device_data;
+	int ret;
+
 	if (!try_module_get(THIS_MODULE))
 		return -ENODEV;
 
+	mutex_lock(&vdev->driver_lock);
+	if (!vdev->refcnt) {
+		ret = vfio_fsl_mc_regions_init(vdev);
+		if (ret)
+			goto err_reg_init;
+	}
+	vdev->refcnt++;
+
+	mutex_unlock(&vdev->driver_lock);
+
 	return 0;
+
+err_reg_init:
+	mutex_unlock(&vdev->driver_lock);
+	module_put(THIS_MODULE);
+	return ret;
 }
 
 static void vfio_fsl_mc_release(void *device_data)
 {
+	struct vfio_fsl_mc_device *vdev = device_data;
+
+	mutex_lock(&vdev->driver_lock);
+
+	if (!(--vdev->refcnt))
+		vfio_fsl_mc_regions_cleanup(vdev);
+
+	mutex_unlock(&vdev->driver_lock);
+
 	module_put(THIS_MODULE);
 }
 
@@ -59,7 +114,25 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
 	}
 	case VFIO_DEVICE_GET_REGION_INFO:
 	{
-		return -ENOTTY;
+		struct vfio_region_info info;
+
+		minsz = offsetofend(struct vfio_region_info, offset);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz)
+			return -EINVAL;
+
+		if (info.index >= mc_dev->obj_desc.region_count)
+			return -EINVAL;
+
+		/* map offset to the physical address  */
+		info.offset = VFIO_FSL_MC_INDEX_TO_OFFSET(info.index);
+		info.size = vdev->regions[info.index].size;
+		info.flags = vdev->regions[info.index].flags;
+
+		return copy_to_user((void __user *)arg, &info, minsz);
 	}
 	case VFIO_DEVICE_GET_IRQ_INFO:
 	{
@@ -210,6 +283,8 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 	if (ret)
 		goto out_group_dev;
 
+	mutex_init(&vdev->driver_lock);
+
 	return 0;
 
 out_group_dev:
@@ -228,6 +303,8 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
 	if (!vdev)
 		return -EINVAL;
 
+	mutex_destroy(&vdev->driver_lock);
+
 	if (is_fsl_mc_bus_dprc(mc_dev)) {
 		dprc_remove_devices(mc_dev, NULL, 0);
 		dprc_cleanup(mc_dev);
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
index 37d61eaa58c8..be60f41af30f 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
@@ -7,9 +7,27 @@
 #ifndef VFIO_FSL_MC_PRIVATE_H
 #define VFIO_FSL_MC_PRIVATE_H
 
+#define VFIO_FSL_MC_OFFSET_SHIFT    40
+#define VFIO_FSL_MC_OFFSET_MASK (((u64)(1) << VFIO_FSL_MC_OFFSET_SHIFT) - 1)
+
+#define VFIO_FSL_MC_OFFSET_TO_INDEX(off) ((off) >> VFIO_FSL_MC_OFFSET_SHIFT)
+
+#define VFIO_FSL_MC_INDEX_TO_OFFSET(index)	\
+	((u64)(index) << VFIO_FSL_MC_OFFSET_SHIFT)
+
+struct vfio_fsl_mc_region {
+	u32			flags;
+	u32			type;
+	u64			addr;
+	resource_size_t		size;
+};
+
 struct vfio_fsl_mc_device {
 	struct fsl_mc_device		*mc_dev;
 	struct notifier_block        nb;
+	int				refcnt;
+	struct vfio_fsl_mc_region	*regions;
+	struct mutex driver_lock;
 };
 
 #endif /* VFIO_FSL_MC_PRIVATE_H */
-- 
2.17.1

