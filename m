Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A8A252A96
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 11:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbgHZJlX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 05:41:23 -0400
Received: from inva021.nxp.com ([92.121.34.21]:56392 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727994AbgHZJdy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 05:33:54 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 899BB2007AF;
        Wed, 26 Aug 2020 11:33:52 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 7C76C2007A9;
        Wed, 26 Aug 2020 11:33:52 +0200 (CEST)
Received: from fsr-ub1864-111.ea.freescale.net (fsr-ub1864-111.ea.freescale.net [10.171.82.141])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 2E2F8202CA;
        Wed, 26 Aug 2020 11:33:52 +0200 (CEST)
From:   Diana Craciun <diana.craciun@oss.nxp.com>
To:     alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Diana Craciun <diana.craciun@oss.nxp.com>,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>
Subject: [PATCH v4 02/10] vfio/fsl-mc: Scan DPRC objects on vfio-fsl-mc driver bind
Date:   Wed, 26 Aug 2020 12:33:07 +0300
Message-Id: <20200826093315.5279-3-diana.craciun@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
References: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The DPRC (Data Path Resource Container) device is a bus device and has
child devices attached to it. When the vfio-fsl-mc driver is probed
the DPRC is scanned and the child devices discovered and initialized.

Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 84 +++++++++++++++++++++++
 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  1 +
 2 files changed, 85 insertions(+)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 8b53c2a25b32..85e007be3a5d 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -15,6 +15,8 @@
 
 #include "vfio_fsl_mc_private.h"
 
+static struct fsl_mc_driver vfio_fsl_mc_driver;
+
 static int vfio_fsl_mc_open(void *device_data)
 {
 	if (!try_module_get(THIS_MODULE))
@@ -84,6 +86,72 @@ static const struct vfio_device_ops vfio_fsl_mc_ops = {
 	.mmap		= vfio_fsl_mc_mmap,
 };
 
+static int vfio_fsl_mc_bus_notifier(struct notifier_block *nb,
+				    unsigned long action, void *data)
+{
+	struct vfio_fsl_mc_device *vdev = container_of(nb,
+					struct vfio_fsl_mc_device, nb);
+	struct device *dev = data;
+	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
+	struct fsl_mc_device *mc_cont = to_fsl_mc_device(mc_dev->dev.parent);
+
+	if (action == BUS_NOTIFY_ADD_DEVICE &&
+	    vdev->mc_dev == mc_cont) {
+		mc_dev->driver_override = kasprintf(GFP_KERNEL, "%s",
+						    vfio_fsl_mc_ops.name);
+		if (!mc_dev->driver_override)
+			dev_warn(dev, "Setting driver override for device in dprc %s failed\n",
+			     dev_name(&mc_cont->dev));
+		dev_info(dev, "Setting driver override for device in dprc %s\n",
+			 dev_name(&mc_cont->dev));
+	} else if (action == BUS_NOTIFY_BOUND_DRIVER &&
+		vdev->mc_dev == mc_cont) {
+		struct fsl_mc_driver *mc_drv = to_fsl_mc_driver(dev->driver);
+
+		if (mc_drv && mc_drv != &vfio_fsl_mc_driver)
+			dev_warn(dev, "Object %s bound to driver %s while DPRC bound to vfio-fsl-mc\n",
+				 dev_name(dev), mc_drv->driver.name);
+	}
+
+	return 0;
+}
+
+static int vfio_fsl_mc_init_device(struct vfio_fsl_mc_device *vdev)
+{
+	struct fsl_mc_device *mc_dev = vdev->mc_dev;
+	int ret;
+
+	/* Non-dprc devices share mc_io from parent */
+	if (!is_fsl_mc_bus_dprc(mc_dev)) {
+		struct fsl_mc_device *mc_cont = to_fsl_mc_device(mc_dev->dev.parent);
+
+		mc_dev->mc_io = mc_cont->mc_io;
+		return 0;
+	}
+
+	vdev->nb.notifier_call = vfio_fsl_mc_bus_notifier;
+	ret = bus_register_notifier(&fsl_mc_bus_type, &vdev->nb);
+	if (ret)
+		return ret;
+
+	/* open DPRC, allocate a MC portal */
+	ret = dprc_setup(mc_dev);
+	if (ret < 0) {
+		dev_err(&mc_dev->dev, "Failed to setup DPRC (error = %d)\n", ret);
+		bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
+		return ret;
+	}
+
+	ret = dprc_scan_container(mc_dev, false);
+	if (ret < 0) {
+		dev_err(&mc_dev->dev, "Container scanning failed: %d\n", ret);
+		dprc_cleanup(mc_dev);
+		bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
+	}
+
+	return ret;
+}
+
 static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 {
 	struct iommu_group *group;
@@ -112,6 +180,12 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 		return ret;
 	}
 
+	ret = vfio_fsl_mc_init_device(vdev);
+	if (ret < 0) {
+		vfio_iommu_group_put(group, dev);
+		return ret;
+	}
+
 	return ret;
 }
 
@@ -124,6 +198,16 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
 	if (!vdev)
 		return -EINVAL;
 
+	if (vdev->nb.notifier_call)
+		bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
+
+	if (is_fsl_mc_bus_dprc(mc_dev)) {
+		dprc_remove_devices(mc_dev, NULL, 0);
+		dprc_cleanup(mc_dev);
+	}
+
+	mc_dev->mc_io = NULL;
+
 	vfio_iommu_group_put(mc_dev->dev.iommu_group, dev);
 
 	return 0;
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
index e79cc116f6b8..37d61eaa58c8 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
@@ -9,6 +9,7 @@
 
 struct vfio_fsl_mc_device {
 	struct fsl_mc_device		*mc_dev;
+	struct notifier_block        nb;
 };
 
 #endif /* VFIO_FSL_MC_PRIVATE_H */
-- 
2.17.1

