Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35CBD252A88
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 11:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgHZJeE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 05:34:04 -0400
Received: from inva020.nxp.com ([92.121.34.13]:42228 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728116AbgHZJd5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 05:33:57 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 821741A1559;
        Wed, 26 Aug 2020 11:33:55 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 766CF1A08FA;
        Wed, 26 Aug 2020 11:33:55 +0200 (CEST)
Received: from fsr-ub1864-111.ea.freescale.net (fsr-ub1864-111.ea.freescale.net [10.171.82.141])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 291A7202CA;
        Wed, 26 Aug 2020 11:33:55 +0200 (CEST)
From:   Diana Craciun <diana.craciun@oss.nxp.com>
To:     alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Diana Craciun <diana.craciun@oss.nxp.com>
Subject: [PATCH v4 10/10] vfio/fsl-mc: Add support for device reset
Date:   Wed, 26 Aug 2020 12:33:15 +0300
Message-Id: <20200826093315.5279-11-diana.craciun@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
References: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently only resetting the DPRC container is supported which
will reset all the objects inside it. Resetting individual
objects is possible from the userspace by issueing commands
towards MC firmware.

Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 27713aa86878..d17c5b3148ad 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -310,7 +310,20 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
 	}
 	case VFIO_DEVICE_RESET:
 	{
-		return -ENOTTY;
+		int ret = 0;
+
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

