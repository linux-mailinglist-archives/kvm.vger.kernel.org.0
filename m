Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B259283D71
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 19:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgJERhI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 13:37:08 -0400
Received: from inva020.nxp.com ([92.121.34.13]:52188 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728479AbgJERhD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 13:37:03 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 9343F1A0952;
        Mon,  5 Oct 2020 19:37:01 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 86EF91A094A;
        Mon,  5 Oct 2020 19:37:01 +0200 (CEST)
Received: from fsr-ub1864-111.ea.freescale.net (fsr-ub1864-111.ea.freescale.net [10.171.82.141])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 3FF202033F;
        Mon,  5 Oct 2020 19:37:01 +0200 (CEST)
From:   Diana Craciun <diana.craciun@oss.nxp.com>
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Diana Craciun <diana.craciun@oss.nxp.com>
Subject: [PATCH v6 10/10] vfio/fsl-mc: Add support for device reset
Date:   Mon,  5 Oct 2020 20:36:54 +0300
Message-Id: <20201005173654.31773-11-diana.craciun@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201005173654.31773-1-diana.craciun@oss.nxp.com>
References: <20201005173654.31773-1-diana.craciun@oss.nxp.com>
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
 drivers/vfio/fsl-mc/vfio_fsl_mc.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index d95568cd8021..d009f873578c 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -217,6 +217,10 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
 			return -EINVAL;
 
 		info.flags = VFIO_DEVICE_FLAGS_FSL_MC;
+
+		if (is_fsl_mc_bus_dprc(mc_dev))
+			info.flags |= VFIO_DEVICE_FLAGS_RESET;
+
 		info.num_regions = mc_dev->obj_desc.region_count;
 		info.num_irqs = mc_dev->obj_desc.irq_count;
 
@@ -299,7 +303,19 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
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

