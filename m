Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBD4215AFB
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 17:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729453AbgGFPmP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 11:42:15 -0400
Received: from inva021.nxp.com ([92.121.34.21]:36180 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729358AbgGFPmP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 11:42:15 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 72BA92004F0;
        Mon,  6 Jul 2020 17:42:13 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 66C2D2004F7;
        Mon,  6 Jul 2020 17:42:13 +0200 (CEST)
Received: from fsr-ub1864-111.ea.freescale.net (fsr-ub1864-111.ea.freescale.net [10.171.82.141])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 10168203C3;
        Mon,  6 Jul 2020 17:42:13 +0200 (CEST)
From:   Diana Craciun <diana.craciun@oss.nxp.com>
To:     alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     bharatb.linux@gmail.com, linux-kernel@vger.kernel.org,
        laurentiu.tudor@nxp.com, Diana Craciun <diana.craciun@oss.nxp.com>,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>
Subject: [PATCH v3 3/9] vfio/fsl-mc: Implement VFIO_DEVICE_GET_INFO ioctl
Date:   Mon,  6 Jul 2020 18:41:47 +0300
Message-Id: <20200706154153.11477-4-diana.craciun@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200706154153.11477-1-diana.craciun@oss.nxp.com>
References: <20200706154153.11477-1-diana.craciun@oss.nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow userspace to get fsl-mc device info (number of regions
and irqs).

Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index ad8d06cceb71..937b6eddc71a 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -33,10 +33,29 @@ static void vfio_fsl_mc_release(void *device_data)
 static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
 			      unsigned long arg)
 {
+	unsigned long minsz;
+	struct vfio_fsl_mc_device *vdev = device_data;
+	struct fsl_mc_device *mc_dev = vdev->mc_dev;
+
 	switch (cmd) {
 	case VFIO_DEVICE_GET_INFO:
 	{
-		return -ENOTTY;
+		struct vfio_device_info info;
+
+		minsz = offsetofend(struct vfio_device_info, num_irqs);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz)
+			return -EINVAL;
+
+		info.flags = VFIO_DEVICE_FLAGS_FSL_MC;
+		info.num_regions = mc_dev->obj_desc.region_count;
+		info.num_irqs = mc_dev->obj_desc.irq_count;
+
+		return copy_to_user((void __user *)arg, &info, minsz) ?
+			-EFAULT : 0;
 	}
 	case VFIO_DEVICE_GET_REGION_INFO:
 	{
-- 
2.17.1

