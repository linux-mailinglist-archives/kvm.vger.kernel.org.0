Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE13252A91
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 11:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbgHZJlB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 05:41:01 -0400
Received: from inva021.nxp.com ([92.121.34.21]:56470 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728041AbgHZJdz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 05:33:55 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id AE1A02005C0;
        Wed, 26 Aug 2020 11:33:53 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A1887200038;
        Wed, 26 Aug 2020 11:33:53 +0200 (CEST)
Received: from fsr-ub1864-111.ea.freescale.net (fsr-ub1864-111.ea.freescale.net [10.171.82.141])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 54CD7202CA;
        Wed, 26 Aug 2020 11:33:53 +0200 (CEST)
From:   Diana Craciun <diana.craciun@oss.nxp.com>
To:     alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Diana Craciun <diana.craciun@oss.nxp.com>,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>
Subject: [PATCH v4 05/10] vfio/fsl-mc: Allow userspace to MMAP fsl-mc device MMIO regions
Date:   Wed, 26 Aug 2020 12:33:10 +0300
Message-Id: <20200826093315.5279-6-diana.craciun@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
References: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow userspace to mmap device regions for direct access of
fsl-mc devices.

Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c | 60 +++++++++++++++++++++++++++++--
 1 file changed, 58 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 093b8d68496c..64d5c1fff51f 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -33,7 +33,8 @@ static int vfio_fsl_mc_regions_init(struct vfio_fsl_mc_device *vdev)
 
 		vdev->regions[i].addr = res->start;
 		vdev->regions[i].size = resource_size(res);
-		vdev->regions[i].flags = 0;
+		vdev->regions[i].flags = VFIO_REGION_INFO_FLAG_MMAP;
+		vdev->regions[i].type = mc_dev->regions[i].flags & IORESOURCE_BITS;
 	}
 
 	vdev->num_regions = mc_dev->obj_desc.region_count;
@@ -164,9 +165,64 @@ static ssize_t vfio_fsl_mc_write(void *device_data, const char __user *buf,
 	return -EINVAL;
 }
 
+static int vfio_fsl_mc_mmap_mmio(struct vfio_fsl_mc_region region,
+				 struct vm_area_struct *vma)
+{
+	u64 size = vma->vm_end - vma->vm_start;
+	u64 pgoff, base;
+	u8 region_cacheable;
+
+	pgoff = vma->vm_pgoff &
+		((1U << (VFIO_FSL_MC_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+	base = pgoff << PAGE_SHIFT;
+
+	if (region.size < PAGE_SIZE || base + size > region.size)
+		return -EINVAL;
+
+	region_cacheable = (region.type & FSL_MC_REGION_CACHEABLE) &&
+			   (region.type & FSL_MC_REGION_SHAREABLE);
+	if (!region_cacheable)
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	vma->vm_pgoff = (region.addr >> PAGE_SHIFT) + pgoff;
+
+	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+			       size, vma->vm_page_prot);
+}
+
 static int vfio_fsl_mc_mmap(void *device_data, struct vm_area_struct *vma)
 {
-	return -EINVAL;
+	struct vfio_fsl_mc_device *vdev = device_data;
+	struct fsl_mc_device *mc_dev = vdev->mc_dev;
+	int index;
+
+	index = vma->vm_pgoff >> (VFIO_FSL_MC_OFFSET_SHIFT - PAGE_SHIFT);
+
+	if (vma->vm_end < vma->vm_start)
+		return -EINVAL;
+	if (vma->vm_start & ~PAGE_MASK)
+		return -EINVAL;
+	if (vma->vm_end & ~PAGE_MASK)
+		return -EINVAL;
+	if (!(vma->vm_flags & VM_SHARED))
+		return -EINVAL;
+	if (index >= vdev->num_regions)
+		return -EINVAL;
+
+	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_MMAP))
+		return -EINVAL;
+
+	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_READ)
+			&& (vma->vm_flags & VM_READ))
+		return -EINVAL;
+
+	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_WRITE)
+			&& (vma->vm_flags & VM_WRITE))
+		return -EINVAL;
+
+	vma->vm_private_data = mc_dev;
+
+	return vfio_fsl_mc_mmap_mmio(vdev->regions[index], vma);
 }
 
 static const struct vfio_device_ops vfio_fsl_mc_ops = {
-- 
2.17.1

