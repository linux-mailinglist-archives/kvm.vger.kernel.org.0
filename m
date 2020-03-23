Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A466818FB45
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 18:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgCWRUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 13:20:07 -0400
Received: from inva020.nxp.com ([92.121.34.13]:50508 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727318AbgCWRTa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 13:19:30 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E38D91A14D4;
        Mon, 23 Mar 2020 18:19:27 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D73871A14A9;
        Mon, 23 Mar 2020 18:19:27 +0100 (CET)
Received: from fsr-ub1864-111.ea.freescale.net (fsr-ub1864-111.ea.freescale.net [10.171.82.141])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 599792035C;
        Mon, 23 Mar 2020 18:19:27 +0100 (CET)
From:   Diana Craciun <diana.craciun@oss.nxp.com>
To:     kvm@vger.kernel.org, alex.williamson@redhat.com,
        laurentiu.tudor@nxp.com, linux-arm-kernel@lists.infradead.org,
        bharatb.yadav@gmail.com
Cc:     linux-kernel@vger.kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>
Subject: [PATCH 2/9] vfio/fsl-mc: Scan DPRC objects on vfio-fsl-mc driver bind
Date:   Mon, 23 Mar 2020 19:19:04 +0200
Message-Id: <20200323171911.27178-3-diana.craciun@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200323171911.27178-1-diana.craciun@oss.nxp.com>
References: <20200323171911.27178-1-diana.craciun@oss.nxp.com>
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
 drivers/vfio/fsl-mc/vfio_fsl_mc.c | 66 +++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 320fb09b5691..5cc533808bc1 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -74,6 +74,34 @@ static int vfio_fsl_mc_mmap(void *device_data, struct vm_area_struct *vma)
 	return -EINVAL;
 }
 
+static int vfio_fsl_mc_init_device(struct vfio_fsl_mc_device *vdev)
+{
+	struct fsl_mc_device *mc_dev = vdev->mc_dev;
+	int ret = 0;
+
+	/* Non-dprc devices share mc_io from parent */
+	if (!is_fsl_mc_bus_dprc(mc_dev)) {
+		struct fsl_mc_device *mc_cont = to_fsl_mc_device(mc_dev->dev.parent);
+
+		mc_dev->mc_io = mc_cont->mc_io;
+		return 0;
+	}
+
+	/* open DPRC, allocate a MC portal */
+	ret = dprc_setup(mc_dev);
+	if (ret < 0) {
+		dev_err(&mc_dev->dev, "Failed to setup DPRC (error = %d)\n", ret);
+		return ret;
+	}
+
+	ret = dprc_scan_container(mc_dev, mc_dev->driver_override, false);
+	if (ret < 0) {
+		dev_err(&mc_dev->dev, "Container scanning failed: %d\n", ret);
+		dprc_cleanup(mc_dev);
+	}
+
+	return 0;
+}
 static const struct vfio_device_ops vfio_fsl_mc_ops = {
 	.name		= "vfio-fsl-mc",
 	.open		= vfio_fsl_mc_open,
@@ -112,9 +140,42 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 		return ret;
 	}
 
+	ret = vfio_fsl_mc_init_device(vdev);
+	if (ret) {
+		vfio_iommu_group_put(group, dev);
+		return ret;
+	}
+
 	return ret;
 }
 
+static int vfio_fsl_mc_device_remove(struct device *dev, void *data)
+{
+	struct fsl_mc_device *mc_dev;
+
+	WARN_ON(!dev);
+	mc_dev = to_fsl_mc_device(dev);
+	if (WARN_ON(!mc_dev))
+		return -ENODEV;
+
+	kfree(mc_dev->driver_override);
+	mc_dev->driver_override = NULL;
+
+	/*
+	 * The device-specific remove callback will get invoked by device_del()
+	 */
+	device_del(&mc_dev->dev);
+	put_device(&mc_dev->dev);
+
+	return 0;
+}
+
+static void vfio_fsl_mc_cleanup_dprc(struct fsl_mc_device *mc_dev)
+{
+	device_for_each_child(&mc_dev->dev, NULL, vfio_fsl_mc_device_remove);
+	dprc_cleanup(mc_dev);
+}
+
 static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
 {
 	struct vfio_fsl_mc_device *vdev;
@@ -124,6 +185,11 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
 	if (!vdev)
 		return -EINVAL;
 
+	if (is_fsl_mc_bus_dprc(mc_dev))
+		vfio_fsl_mc_cleanup_dprc(vdev->mc_dev);
+
+	mc_dev->mc_io = NULL;
+
 	vfio_iommu_group_put(mc_dev->dev.iommu_group, dev);
 	devm_kfree(dev, vdev);
 
-- 
2.17.1

