Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5EC414744
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 13:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235391AbhIVLHY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 07:07:24 -0400
Received: from inva021.nxp.com ([92.121.34.21]:43102 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235353AbhIVLHU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 07:07:20 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 64C97202638;
        Wed, 22 Sep 2021 13:05:49 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 580E6202652;
        Wed, 22 Sep 2021 13:05:49 +0200 (CEST)
Received: from fsr-ub1864-111.ea.freescale.net (fsr-ub1864-111.ea.freescale.net [10.171.82.141])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 0546F20298;
        Wed, 22 Sep 2021 13:05:48 +0200 (CEST)
From:   Diana Craciun <diana.craciun@oss.nxp.com>
To:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>, linux-arm-kernel@lists.infradead.org,
        Diana Craciun <diana.craciun@oss.nxp.com>
Subject: [PATCH v2 2/2] vfio/fsl-mc: Add per device reset support
Date:   Wed, 22 Sep 2021 14:05:30 +0300
Message-Id: <20210922110530.24736-2-diana.craciun@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210922110530.24736-1-diana.craciun@oss.nxp.com>
References: <20210922110530.24736-1-diana.craciun@oss.nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently when a fsl-mc device is reset, the entire DPRC container
is reset which is very inefficient because the devices within a
container will be reset multiple times.
Add support for individually resetting a device.

Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c | 45 ++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 0ead91bfa838..6d7b2d2571a2 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -65,6 +65,34 @@ static void vfio_fsl_mc_regions_cleanup(struct vfio_fsl_mc_device *vdev)
 	kfree(vdev->regions);
 }
 
+static int vfio_fsl_mc_reset_device(struct vfio_fsl_mc_device *vdev)
+{
+	struct fsl_mc_device *mc_dev = vdev->mc_dev;
+	int ret = 0;
+
+	if (is_fsl_mc_bus_dprc(vdev->mc_dev)) {
+		return dprc_reset_container(mc_dev->mc_io, 0,
+					mc_dev->mc_handle,
+					mc_dev->obj_desc.id,
+					DPRC_RESET_OPTION_NON_RECURSIVE);
+	} else {
+		u16 token;
+
+		ret = fsl_mc_obj_open(mc_dev->mc_io, 0, mc_dev->obj_desc.id,
+				      mc_dev->obj_desc.type,
+				      &token);
+		if (ret)
+			goto out;
+		ret = fsl_mc_obj_reset(mc_dev->mc_io, 0, token);
+		if (ret) {
+			fsl_mc_obj_close(mc_dev->mc_io, 0, token);
+			goto out;
+		}
+		ret = fsl_mc_obj_close(mc_dev->mc_io, 0, token);
+	}
+out:
+	return ret;
+}
 
 static void vfio_fsl_mc_close_device(struct vfio_device *core_vdev)
 {
@@ -78,9 +106,7 @@ static void vfio_fsl_mc_close_device(struct vfio_device *core_vdev)
 	vfio_fsl_mc_regions_cleanup(vdev);
 
 	/* reset the device before cleaning up the interrupts */
-	ret = dprc_reset_container(mc_cont->mc_io, 0, mc_cont->mc_handle,
-				   mc_cont->obj_desc.id,
-				   DPRC_RESET_OPTION_NON_RECURSIVE);
+	ret = vfio_fsl_mc_reset_device(vdev);
 
 	if (WARN_ON(ret))
 		dev_warn(&mc_cont->dev,
@@ -203,18 +229,7 @@ static long vfio_fsl_mc_ioctl(struct vfio_device *core_vdev,
 	}
 	case VFIO_DEVICE_RESET:
 	{
-		int ret;
-		struct fsl_mc_device *mc_dev = vdev->mc_dev;
-
-		/* reset is supported only for the DPRC */
-		if (!is_fsl_mc_bus_dprc(mc_dev))
-			return -ENOTTY;
-
-		ret = dprc_reset_container(mc_dev->mc_io, 0,
-					   mc_dev->mc_handle,
-					   mc_dev->obj_desc.id,
-					   DPRC_RESET_OPTION_NON_RECURSIVE);
-		return ret;
+		return vfio_fsl_mc_reset_device(vdev);
 
 	}
 	default:
-- 
2.17.1

