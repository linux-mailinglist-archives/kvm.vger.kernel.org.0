Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9C41D2044
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 22:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbgEMUiN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 16:38:13 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:11672 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727118AbgEMUiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 16:38:13 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ebc5a690004>; Wed, 13 May 2020 13:36:58 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 13 May 2020 13:38:12 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 13 May 2020 13:38:12 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 May
 2020 20:38:12 +0000
Received: from kwankhede-dev.nvidia.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 13 May 2020 20:38:06 +0000
From:   Kirti Wankhede <kwankhede@nvidia.com>
To:     <alex.williamson@redhat.com>, <cjia@nvidia.com>
CC:     <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: [PATCH Kernel v19 3/8] vfio iommu: Cache pgsize_bitmap in struct vfio_iommu
Date:   Thu, 14 May 2020 01:34:34 +0530
Message-ID: <1589400279-28522-4-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589400279-28522-1-git-send-email-kwankhede@nvidia.com>
References: <1589400279-28522-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589402218; bh=p18Tye1V+UyJHxKzz13RY6bXcoaqy1XoKO753WoD52U=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=MribBTbrxv0kRjXi5aQTTazsokWJI5mqNTjdX9ldshlENNvvH6V+6hX0P0DzimCey
         vMZ27FSCI6trKgQ/VY/cEfGZo6hJeA/uFcAUcR0O29Q5GiFAJEUNLYHR3CBxyRSmP4
         uCDpJ//70FhDjAictwVxSwfsTkqHjTPvzb74GBbcgShgT7mHlFsWAnh0mS73RHAUGF
         ygepTUvWV4fG4jGmaxe8dR4qEY7DwuC8QLR7YFUphFeKY+uLb5jXC2+k5jomlKbltu
         lnKR6eIzxsH+k8mk6+PERLrZ6CpxO7PfaU77MI6HN24B17VZ8ylmmSjcD52qw+ESX0
         geqKLGEXNyPfQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Calculate and cache pgsize_bitmap when iommu->domain_list is updated.
Add iommu->lock protection when cached pgsize_bitmap is accessed.

Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
Reviewed-by: Neo Jia <cjia@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 87 +++++++++++++++++++++++------------------
 1 file changed, 48 insertions(+), 39 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index fa735047b04d..6f09fbabed12 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -69,6 +69,7 @@ struct vfio_iommu {
 	struct rb_root		dma_list;
 	struct blocking_notifier_head notifier;
 	unsigned int		dma_avail;
+	uint64_t		pgsize_bitmap;
 	bool			v2;
 	bool			nesting;
 };
@@ -805,15 +806,14 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 	iommu->dma_avail++;
 }
 
-static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
+static void vfio_pgsize_bitmap(struct vfio_iommu *iommu)
 {
 	struct vfio_domain *domain;
-	unsigned long bitmap = ULONG_MAX;
 
-	mutex_lock(&iommu->lock);
+	iommu->pgsize_bitmap = ULONG_MAX;
+
 	list_for_each_entry(domain, &iommu->domain_list, next)
-		bitmap &= domain->domain->pgsize_bitmap;
-	mutex_unlock(&iommu->lock);
+		iommu->pgsize_bitmap &= domain->domain->pgsize_bitmap;
 
 	/*
 	 * In case the IOMMU supports page sizes smaller than PAGE_SIZE
@@ -823,12 +823,10 @@ static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
 	 * granularity while iommu driver can use the sub-PAGE_SIZE size
 	 * to map the buffer.
 	 */
-	if (bitmap & ~PAGE_MASK) {
-		bitmap &= PAGE_MASK;
-		bitmap |= PAGE_SIZE;
+	if (iommu->pgsize_bitmap & ~PAGE_MASK) {
+		iommu->pgsize_bitmap &= PAGE_MASK;
+		iommu->pgsize_bitmap |= PAGE_SIZE;
 	}
-
-	return bitmap;
 }
 
 static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
@@ -839,19 +837,28 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	size_t unmapped = 0;
 	int ret = 0, retries = 0;
 
-	mask = ((uint64_t)1 << __ffs(vfio_pgsize_bitmap(iommu))) - 1;
+	mutex_lock(&iommu->lock);
+
+	mask = ((uint64_t)1 << __ffs(iommu->pgsize_bitmap)) - 1;
+
+	if (unmap->iova & mask) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	if (!unmap->size || unmap->size & mask) {
+		ret = -EINVAL;
+		goto unlock;
+	}
 
-	if (unmap->iova & mask)
-		return -EINVAL;
-	if (!unmap->size || unmap->size & mask)
-		return -EINVAL;
 	if (unmap->iova + unmap->size - 1 < unmap->iova ||
-	    unmap->size > SIZE_MAX)
-		return -EINVAL;
+	    unmap->size > SIZE_MAX) {
+		ret = -EINVAL;
+		goto unlock;
+	}
 
 	WARN_ON(mask & PAGE_MASK);
 again:
-	mutex_lock(&iommu->lock);
 
 	/*
 	 * vfio-iommu-type1 (v1) - User mappings were coalesced together to
@@ -930,6 +937,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 			blocking_notifier_call_chain(&iommu->notifier,
 						    VFIO_IOMMU_NOTIFY_DMA_UNMAP,
 						    &nb_unmap);
+			mutex_lock(&iommu->lock);
 			goto again;
 		}
 		unmapped += dma->size;
@@ -1045,24 +1053,28 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	if (map->size != size || map->vaddr != vaddr || map->iova != iova)
 		return -EINVAL;
 
-	mask = ((uint64_t)1 << __ffs(vfio_pgsize_bitmap(iommu))) - 1;
-
-	WARN_ON(mask & PAGE_MASK);
-
 	/* READ/WRITE from device perspective */
 	if (map->flags & VFIO_DMA_MAP_FLAG_WRITE)
 		prot |= IOMMU_WRITE;
 	if (map->flags & VFIO_DMA_MAP_FLAG_READ)
 		prot |= IOMMU_READ;
 
-	if (!prot || !size || (size | iova | vaddr) & mask)
-		return -EINVAL;
+	mutex_lock(&iommu->lock);
 
-	/* Don't allow IOVA or virtual address wrap */
-	if (iova + size - 1 < iova || vaddr + size - 1 < vaddr)
-		return -EINVAL;
+	mask = ((uint64_t)1 << __ffs(iommu->pgsize_bitmap)) - 1;
 
-	mutex_lock(&iommu->lock);
+	WARN_ON(mask & PAGE_MASK);
+
+	if (!prot || !size || (size | iova | vaddr) & mask) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	/* Don't allow IOVA or virtual address wrap */
+	if (iova + size - 1 < iova || vaddr + size - 1 < vaddr) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
 
 	if (vfio_find_dma(iommu, iova, size)) {
 		ret = -EEXIST;
@@ -1793,6 +1805,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	}
 
 	list_add(&domain->next, &iommu->domain_list);
+	vfio_pgsize_bitmap(iommu);
 done:
 	/* Delete the old one and insert new iova list */
 	vfio_iommu_iova_insert_copy(iommu, &iova_copy);
@@ -2004,6 +2017,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 			list_del(&domain->next);
 			kfree(domain);
 			vfio_iommu_aper_expand(iommu, &iova_copy);
+			vfio_pgsize_bitmap(iommu);
 		}
 		break;
 	}
@@ -2136,8 +2150,6 @@ static int vfio_iommu_iova_build_caps(struct vfio_iommu *iommu,
 	size_t size;
 	int iovas = 0, i = 0, ret;
 
-	mutex_lock(&iommu->lock);
-
 	list_for_each_entry(iova, &iommu->iova_list, list)
 		iovas++;
 
@@ -2146,17 +2158,14 @@ static int vfio_iommu_iova_build_caps(struct vfio_iommu *iommu,
 		 * Return 0 as a container with a single mdev device
 		 * will have an empty list
 		 */
-		ret = 0;
-		goto out_unlock;
+		return 0;
 	}
 
 	size = sizeof(*cap_iovas) + (iovas * sizeof(*cap_iovas->iova_ranges));
 
 	cap_iovas = kzalloc(size, GFP_KERNEL);
-	if (!cap_iovas) {
-		ret = -ENOMEM;
-		goto out_unlock;
-	}
+	if (!cap_iovas)
+		return -ENOMEM;
 
 	cap_iovas->nr_iovas = iovas;
 
@@ -2169,8 +2178,6 @@ static int vfio_iommu_iova_build_caps(struct vfio_iommu *iommu,
 	ret = vfio_iommu_iova_add_cap(caps, cap_iovas, size);
 
 	kfree(cap_iovas);
-out_unlock:
-	mutex_unlock(&iommu->lock);
 	return ret;
 }
 
@@ -2215,11 +2222,13 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 			info.cap_offset = 0; /* output, no-recopy necessary */
 		}
 
+		mutex_lock(&iommu->lock);
 		info.flags = VFIO_IOMMU_INFO_PGSIZES;
 
-		info.iova_pgsizes = vfio_pgsize_bitmap(iommu);
+		info.iova_pgsizes = iommu->pgsize_bitmap;
 
 		ret = vfio_iommu_iova_build_caps(iommu, &caps);
+		mutex_unlock(&iommu->lock);
 		if (ret)
 			return ret;
 
-- 
2.7.0

