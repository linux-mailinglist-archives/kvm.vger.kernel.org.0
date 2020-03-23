Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A886218FB40
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 18:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgCWRT5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 13:19:57 -0400
Received: from inva021.nxp.com ([92.121.34.21]:57104 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727113AbgCWRTb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 13:19:31 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 4603820183C;
        Mon, 23 Mar 2020 18:19:29 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 390812012E7;
        Mon, 23 Mar 2020 18:19:29 +0100 (CET)
Received: from fsr-ub1864-111.ea.freescale.net (fsr-ub1864-111.ea.freescale.net [10.171.82.141])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id A83612035C;
        Mon, 23 Mar 2020 18:19:28 +0100 (CET)
From:   Diana Craciun <diana.craciun@oss.nxp.com>
To:     kvm@vger.kernel.org, alex.williamson@redhat.com,
        laurentiu.tudor@nxp.com, linux-arm-kernel@lists.infradead.org,
        bharatb.yadav@gmail.com
Cc:     linux-kernel@vger.kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>
Subject: [PATCH 4/9] vfio/fsl-mc: Implement VFIO_DEVICE_GET_REGION_INFO ioctl call
Date:   Mon, 23 Mar 2020 19:19:06 +0200
Message-Id: <20200323171911.27178-5-diana.craciun@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200323171911.27178-1-diana.craciun@oss.nxp.com>
References: <20200323171911.27178-1-diana.craciun@oss.nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expose to userspace information about the memory regions.

Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 77 ++++++++++++++++++++++-
 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h | 19 ++++++
 2 files changed, 95 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index ab1cde375fc6..094df3aa3710 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -15,16 +15,71 @@
 
 #include "vfio_fsl_mc_private.h"
 
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
+		vdev->regions[i].size = PAGE_ALIGN((resource_size(res)));
+		vdev->regions[i].flags = 0;
+	}
+
+	vdev->num_regions = mc_dev->obj_desc.region_count;
+	return 0;
+}
+
+static void vfio_fsl_mc_regions_cleanup(struct vfio_fsl_mc_device *vdev)
+{
+	vdev->num_regions = 0;
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
 
@@ -58,7 +113,26 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
 	}
 	case VFIO_DEVICE_GET_REGION_INFO:
 	{
-		return -EINVAL;
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
+		if (info.index >= vdev->num_regions)
+			return -EINVAL;
+
+		/* map offset to the physical address  */
+		info.offset = VFIO_FSL_MC_INDEX_TO_OFFSET(info.index);
+		info.size = vdev->regions[info.index].size;
+		info.flags = vdev->regions[info.index].flags;
+
+		return copy_to_user((void __user *)arg, &info, minsz);
+
 	}
 	case VFIO_DEVICE_GET_IRQ_INFO:
 	{
@@ -165,6 +239,7 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 		vfio_iommu_group_put(group, dev);
 		return ret;
 	}
+	mutex_init(&vdev->driver_lock);
 
 	return ret;
 }
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
index b92858a003c0..764e2cf2c70d 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
@@ -7,8 +7,27 @@
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
+	int				refcnt;
+	u32				num_regions;
+	struct vfio_fsl_mc_region	*regions;
+	struct mutex driver_lock;
 };
 
 #endif /* VFIO_PCI_PRIVATE_H */
-- 
2.17.1

