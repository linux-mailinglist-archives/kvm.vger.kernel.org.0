Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF8BA283D6A
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 19:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbgJERhD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 13:37:03 -0400
Received: from inva020.nxp.com ([92.121.34.13]:52078 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728476AbgJERhA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 13:37:00 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 8A5AD1A094A;
        Mon,  5 Oct 2020 19:36:58 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 7C5691A0940;
        Mon,  5 Oct 2020 19:36:58 +0200 (CEST)
Received: from fsr-ub1864-111.ea.freescale.net (fsr-ub1864-111.ea.freescale.net [10.171.82.141])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 2E1522032B;
        Mon,  5 Oct 2020 19:36:58 +0200 (CEST)
From:   Diana Craciun <diana.craciun@oss.nxp.com>
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Diana Craciun <diana.craciun@oss.nxp.com>,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>
Subject: [PATCH v6 02/10] vfio/fsl-mc: Scan DPRC objects on vfio-fsl-mc driver bind
Date:   Mon,  5 Oct 2020 20:36:46 +0300
Message-Id: <20201005173654.31773-3-diana.craciun@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201005173654.31773-1-diana.craciun@oss.nxp.com>
References: <20201005173654.31773-1-diana.craciun@oss.nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The DPRC (Data Path Resource Container) device is a bus device and has
child devices attached to it. When the vfio-fsl-mc driver is probed
the DPRC is scanned and the child devices discovered and initialized.

Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 91 +++++++++++++++++++++++
 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  1 +
 2 files changed, 92 insertions(+)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index a7a483a1e90b..594760203268 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -15,6 +15,8 @@
 
 #include "vfio_fsl_mc_private.h"
 
+static struct fsl_mc_driver vfio_fsl_mc_driver;
+
 static int vfio_fsl_mc_open(void *device_data)
 {
 	if (!try_module_get(THIS_MODULE))
@@ -84,6 +86,80 @@ static const struct vfio_device_ops vfio_fsl_mc_ops = {
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
+			dev_warn(dev, "VFIO_FSL_MC: Setting driver override for device in dprc %s failed\n",
+				 dev_name(&mc_cont->dev));
+		else
+			dev_info(dev, "VFIO_FSL_MC: Setting driver override for device in dprc %s\n",
+				 dev_name(&mc_cont->dev));
+	} else if (action == BUS_NOTIFY_BOUND_DRIVER &&
+		vdev->mc_dev == mc_cont) {
+		struct fsl_mc_driver *mc_drv = to_fsl_mc_driver(dev->driver);
+
+		if (mc_drv && mc_drv != &vfio_fsl_mc_driver)
+			dev_warn(dev, "VFIO_FSL_MC: Object %s bound to driver %s while DPRC bound to vfio-fsl-mc\n",
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
+	if (ret) {
+		dev_err(&mc_dev->dev, "VFIO_FSL_MC: Failed to setup DPRC (%d)\n", ret);
+		goto out_nc_unreg;
+	}
+
+	ret = dprc_scan_container(mc_dev, false);
+	if (ret) {
+		dev_err(&mc_dev->dev, "VFIO_FSL_MC: Container scanning failed (%d)\n", ret);
+		goto out_dprc_cleanup;
+	}
+
+	return 0;
+
+out_dprc_cleanup:
+	dprc_remove_devices(mc_dev, NULL, 0);
+	dprc_cleanup(mc_dev);
+out_nc_unreg:
+	bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
+	vdev->nb.notifier_call = NULL;
+
+	return ret;
+}
+
 static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 {
 	struct iommu_group *group;
@@ -110,8 +186,15 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 		dev_err(dev, "VFIO_FSL_MC: Failed to add to vfio group\n");
 		goto out_group_put;
 	}
+
+	ret = vfio_fsl_mc_init_device(vdev);
+	if (ret)
+		goto out_group_dev;
+
 	return 0;
 
+out_group_dev:
+	vfio_del_group_dev(dev);
 out_group_put:
 	vfio_iommu_group_put(group, dev);
 	return ret;
@@ -126,6 +209,14 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
 	if (!vdev)
 		return -EINVAL;
 
+	if (is_fsl_mc_bus_dprc(mc_dev)) {
+		dprc_remove_devices(mc_dev, NULL, 0);
+		dprc_cleanup(mc_dev);
+	}
+
+	if (vdev->nb.notifier_call)
+		bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
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

