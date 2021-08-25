Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C1D3F716F
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 11:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239534AbhHYJG4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 05:06:56 -0400
Received: from inva021.nxp.com ([92.121.34.21]:48428 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239536AbhHYJGv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 05:06:51 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 55F6F201621;
        Wed, 25 Aug 2021 11:06:05 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 49020200C06;
        Wed, 25 Aug 2021 11:06:05 +0200 (CEST)
Received: from fsr-ub1864-111.ea.freescale.net (fsr-ub1864-111.ea.freescale.net [10.171.82.141])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E9E78203BA;
        Wed, 25 Aug 2021 11:06:04 +0200 (CEST)
From:   Diana Craciun <diana.craciun@oss.nxp.com>
To:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>, linux-arm-kernel@lists.infradead.org,
        Diana Craciun <diana.craciun@oss.nxp.com>
Subject: [PATCH 2/2] vfio/fsl-mc: Add per device reset support
Date:   Wed, 25 Aug 2021 12:05:38 +0300
Message-Id: <20210825090538.4860-2-diana.craciun@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210825090538.4860-1-diana.craciun@oss.nxp.com>
References: <20210825090538.4860-1-diana.craciun@oss.nxp.com>
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
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 90cad109583b..46126d41dc32 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -155,6 +155,33 @@ static int vfio_fsl_mc_open(struct vfio_device *core_vdev)
 	return ret;
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
+		int err;
+		u16 token;
+
+		err = fsl_mc_obj_open(mc_dev->mc_io, 0, mc_dev->obj_desc.id,
+				      mc_dev->obj_desc.type,
+				      &token);
+		if (err)
+			return err;
+		ret = fsl_mc_obj_reset(mc_dev->mc_io, 0, token);
+		err = fsl_mc_obj_close(mc_dev->mc_io, 0, token);
+		if (err)
+			return err;
+	}
+	return ret;
+}
+
 static void vfio_fsl_mc_release(struct vfio_device *core_vdev)
 {
 	struct vfio_fsl_mc_device *vdev =
@@ -171,10 +198,7 @@ static void vfio_fsl_mc_release(struct vfio_device *core_vdev)
 		vfio_fsl_mc_regions_cleanup(vdev);
 
 		/* reset the device before cleaning up the interrupts */
-		ret = dprc_reset_container(mc_cont->mc_io, 0,
-		      mc_cont->mc_handle,
-			  mc_cont->obj_desc.id,
-			  DPRC_RESET_OPTION_NON_RECURSIVE);
+		ret = vfio_fsl_mc_reset_device(vdev);
 
 		if (ret) {
 			dev_warn(&mc_cont->dev, "VFIO_FLS_MC: reset device has failed (%d)\n",
@@ -302,18 +326,7 @@ static long vfio_fsl_mc_ioctl(struct vfio_device *core_vdev,
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

