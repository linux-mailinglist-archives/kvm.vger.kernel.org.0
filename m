Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED1D27C071
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 11:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgI2JE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 05:04:27 -0400
Received: from inva020.nxp.com ([92.121.34.13]:47872 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727922AbgI2JEA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 05:04:00 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4DB5F1A1247;
        Tue, 29 Sep 2020 11:03:58 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 403C91A034B;
        Tue, 29 Sep 2020 11:03:58 +0200 (CEST)
Received: from fsr-ub1864-111.ea.freescale.net (fsr-ub1864-111.ea.freescale.net [10.171.82.141])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id DF2292032C;
        Tue, 29 Sep 2020 11:03:57 +0200 (CEST)
From:   Diana Craciun <diana.craciun@oss.nxp.com>
To:     alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     bharatb.linux@gmail.com, linux-kernel@vger.kernel.org,
        eric.auger@redhat.com, Diana Craciun <diana.craciun@oss.nxp.com>,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>
Subject: [PATCH v5 05/10] vfio/fsl-mc: Allow userspace to MMAP fsl-mc device MMIO regions
Date:   Tue, 29 Sep 2020 12:03:34 +0300
Message-Id: <20200929090339.17659-6-diana.craciun@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200929090339.17659-1-diana.craciun@oss.nxp.com>
References: <20200929090339.17659-1-diana.craciun@oss.nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow userspace to mmap device regions for direct access of
fsl-mc devices.

Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c | 68 ++++++++++++++++++++++++++++++-
 1 file changed, 66 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 802f3a00337f..7ceadb801082 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -30,11 +30,20 @@ static int vfio_fsl_mc_regions_init(struct vfio_fsl_mc_device *vdev)
 
 	for (i = 0; i < count; i++) {
 		struct resource *res = &mc_dev->regions[i];
+		int no_mmap = is_fsl_mc_bus_dprc(mc_dev);
 
 		vdev->regions[i].addr = res->start;
 		vdev->regions[i].size = resource_size(res);
-		vdev->regions[i].flags = 0;
 		vdev->regions[i].type = mc_dev->regions[i].flags & IORESOURCE_BITS;
+		/*
+		 * Only regions addressed with PAGE granularity may be
+		 * MMAPed securely.
+		 */
+		if (!no_mmap && !(vdev->regions[i].addr & ~PAGE_MASK) &&
+				!(vdev->regions[i].size & ~PAGE_MASK))
+			vdev->regions[i].flags |=
+					VFIO_REGION_INFO_FLAG_MMAP;
+
 	}
 
 	return 0;
@@ -163,9 +172,64 @@ static ssize_t vfio_fsl_mc_write(void *device_data, const char __user *buf,
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
+	if (index >= mc_dev->obj_desc.region_count)
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

