Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E501CA50C
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 09:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgEHHU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 03:20:59 -0400
Received: from inva021.nxp.com ([92.121.34.21]:59314 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727076AbgEHHUu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 03:20:50 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 0E6342012D5;
        Fri,  8 May 2020 09:20:49 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 01C6F2012CD;
        Fri,  8 May 2020 09:20:49 +0200 (CEST)
Received: from fsr-ub1864-111.ea.freescale.net (fsr-ub1864-111.ea.freescale.net [10.171.82.141])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 75C0F204BD;
        Fri,  8 May 2020 09:20:48 +0200 (CEST)
From:   Diana Craciun <diana.craciun@oss.nxp.com>
To:     alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, laurentiu.tudor@nxp.com,
        bharatb.linux@gmail.com, Diana Craciun <diana.craciun@oss.nxp.com>,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>
Subject: [PATCH v2 9/9] vfio/fsl-mc: Add read/write support for fsl-mc devices
Date:   Fri,  8 May 2020 10:20:39 +0300
Message-Id: <20200508072039.18146-10-diana.craciun@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200508072039.18146-1-diana.craciun@oss.nxp.com>
References: <20200508072039.18146-1-diana.craciun@oss.nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The software uses a memory-mapped I/O command interface (MC portals) to
communicate with the MC hardware. This command interface is used to
discover, enumerate, configure and remove DPAA2 objects. The DPAA2
objects use MSIs, so the command interface needs to be emulated
such that the correct MSI is configured in the hardware (the guest
has the virtual MSIs).

This patch is adding read/write support for fsl-mc devices. The mc
commands are emulated by the userspace. The host is just passing
the correct command to the hardware.

Also the current patch limits userspace to write complete
64byte command once and read 64byte response by one ioctl.

Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 122 +++++++++++++++++++++-
 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |   1 +
 2 files changed, 121 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index ec8ab85d54d6..bf11bcbfd09c 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <linux/vfio.h>
 #include <linux/fsl/mc.h>
+#include <linux/delay.h>
 
 #include "vfio_fsl_mc_private.h"
 
@@ -116,6 +117,11 @@ static int vfio_fsl_mc_regions_init(struct vfio_fsl_mc_device *vdev)
 
 static void vfio_fsl_mc_regions_cleanup(struct vfio_fsl_mc_device *vdev)
 {
+	int i;
+
+	for (i = 0; i < vdev->num_regions; i++)
+		iounmap(vdev->regions[i].ioaddr);
+
 	vdev->num_regions = 0;
 	kfree(vdev->regions);
 }
@@ -309,13 +315,125 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
 static ssize_t vfio_fsl_mc_read(void *device_data, char __user *buf,
 				size_t count, loff_t *ppos)
 {
-	return -EINVAL;
+	struct vfio_fsl_mc_device *vdev = device_data;
+	unsigned int index = VFIO_FSL_MC_OFFSET_TO_INDEX(*ppos);
+	loff_t off = *ppos & VFIO_FSL_MC_OFFSET_MASK;
+	struct vfio_fsl_mc_region *region;
+	u64 data[8];
+	int i;
+
+	/* Read ioctl supported only for DPRC and DPMCP device */
+	if (strcmp(vdev->mc_dev->obj_desc.type, "dprc") &&
+	    strcmp(vdev->mc_dev->obj_desc.type, "dpmcp"))
+		return -EINVAL;
+
+	if (index >= vdev->num_regions)
+		return -EINVAL;
+
+	region = &vdev->regions[index];
+
+	if (!(region->flags & VFIO_REGION_INFO_FLAG_READ))
+		return -EINVAL;
+
+	if (!region->ioaddr) {
+		region->ioaddr = ioremap(region->addr, region->size);
+		if (!region->ioaddr)
+			return -ENOMEM;
+	}
+
+	if (count != 64 || off != 0)
+		return -EINVAL;
+
+	for (i = 7; i >= 0; i--)
+		data[i] = readq(region->ioaddr + i * sizeof(uint64_t));
+
+	if (copy_to_user(buf, data, 64))
+		return -EFAULT;
+
+	return count;
+}
+
+#define MC_CMD_COMPLETION_TIMEOUT_MS    5000
+#define MC_CMD_COMPLETION_POLLING_MAX_SLEEP_USECS    500
+
+static int vfio_fsl_mc_send_command(void __iomem *ioaddr, uint64_t *cmd_data)
+{
+	int i;
+	enum mc_cmd_status status;
+	unsigned long timeout_usecs = MC_CMD_COMPLETION_TIMEOUT_MS * 1000;
+
+	/* Write at command parameter into portal */
+	for (i = 7; i >= 1; i--)
+		writeq_relaxed(cmd_data[i], ioaddr + i * sizeof(uint64_t));
+
+	/* Write command header in the end */
+	writeq(cmd_data[0], ioaddr);
+
+	/* Wait for response before returning to user-space
+	 * This can be optimized in future to even prepare response
+	 * before returning to user-space and avoid read ioctl.
+	 */
+	for (;;) {
+		u64 header;
+		struct mc_cmd_header *resp_hdr;
+
+		header = cpu_to_le64(readq_relaxed(ioaddr));
+
+		resp_hdr = (struct mc_cmd_header *)&header;
+		status = (enum mc_cmd_status)resp_hdr->status;
+		if (status != MC_CMD_STATUS_READY)
+			break;
+
+		udelay(MC_CMD_COMPLETION_POLLING_MAX_SLEEP_USECS);
+		timeout_usecs -= MC_CMD_COMPLETION_POLLING_MAX_SLEEP_USECS;
+		if (timeout_usecs == 0)
+			return -ETIMEDOUT;
+	}
+
+	return 0;
 }
 
 static ssize_t vfio_fsl_mc_write(void *device_data, const char __user *buf,
 				 size_t count, loff_t *ppos)
 {
-	return -EINVAL;
+	struct vfio_fsl_mc_device *vdev = device_data;
+	unsigned int index = VFIO_FSL_MC_OFFSET_TO_INDEX(*ppos);
+	loff_t off = *ppos & VFIO_FSL_MC_OFFSET_MASK;
+	struct vfio_fsl_mc_region *region;
+	u64 data[8];
+	int ret;
+
+	/* Write ioctl supported only for DPRC and DPMCP device */
+	if (strcmp(vdev->mc_dev->obj_desc.type, "dprc") &&
+	    strcmp(vdev->mc_dev->obj_desc.type, "dpmcp"))
+		return -EINVAL;
+
+	if (index >= vdev->num_regions)
+		return -EINVAL;
+
+	region = &vdev->regions[index];
+
+	if (!(region->flags & VFIO_REGION_INFO_FLAG_WRITE))
+		return -EINVAL;
+
+	if (!region->ioaddr) {
+		region->ioaddr = ioremap(region->addr, region->size);
+		if (!region->ioaddr)
+			return -ENOMEM;
+	}
+
+	if (count != 64 || off != 0)
+		return -EINVAL;
+
+	if (copy_from_user(&data, buf, 64))
+		return -EFAULT;
+
+	ret = vfio_fsl_mc_send_command(region->ioaddr, data);
+	if (ret)
+		return ret;
+
+	return count;
+
 }
 
 static int vfio_fsl_mc_mmap_mmio(struct vfio_fsl_mc_region region,
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
index be0cdc35b40c..dfd2a2bc0b22 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
@@ -34,6 +34,7 @@ struct vfio_fsl_mc_region {
 	u32			type;
 	u64			addr;
 	resource_size_t		size;
+	void __iomem		*ioaddr;
 };
 
 struct vfio_fsl_mc_device {
-- 
2.17.1

