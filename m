Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B6727C068
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 11:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgI2JEJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 05:04:09 -0400
Received: from inva021.nxp.com ([92.121.34.21]:41342 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727986AbgI2JEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 05:04:01 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 3F89F201191;
        Tue, 29 Sep 2020 11:04:00 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 3D18A2001CE;
        Tue, 29 Sep 2020 11:04:00 +0200 (CEST)
Received: from fsr-ub1864-111.ea.freescale.net (fsr-ub1864-111.ea.freescale.net [10.171.82.141])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id DC1B02032C;
        Tue, 29 Sep 2020 11:03:59 +0200 (CEST)
From:   Diana Craciun <diana.craciun@oss.nxp.com>
To:     alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     bharatb.linux@gmail.com, linux-kernel@vger.kernel.org,
        eric.auger@redhat.com, Diana Craciun <diana.craciun@oss.nxp.com>
Subject: [PATCH v5 10/10] vfio/fsl-mc: Add support for device reset
Date:   Tue, 29 Sep 2020 12:03:39 +0300
Message-Id: <20200929090339.17659-11-diana.craciun@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200929090339.17659-1-diana.craciun@oss.nxp.com>
References: <20200929090339.17659-1-diana.craciun@oss.nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently only resetting the DPRC container is supported which
will reset all the objects inside it. Resetting individual
objects is possible from the userspace by issueing commands
towards MC firmware.

Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 0aff99cdf722..e1b2dea8a5fe 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -299,7 +299,19 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
 	}
 	case VFIO_DEVICE_RESET:
 	{
-		return -ENOTTY;
+		int ret;
+		struct fsl_mc_device *mc_dev = vdev->mc_dev;
+
+		/* reset is supported only for the DPRC */
+		if (!is_fsl_mc_bus_dprc(mc_dev))
+			return -ENOTTY;
+
+		ret = dprc_reset_container(mc_dev->mc_io, 0,
+					   mc_dev->mc_handle,
+					   mc_dev->obj_desc.id,
+					   DPRC_RESET_OPTION_NON_RECURSIVE);
+		return ret;
+
 	}
 	default:
 		return -ENOTTY;
-- 
2.17.1

