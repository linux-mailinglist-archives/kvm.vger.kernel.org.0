Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03F881233BA
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 18:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbfLQRkC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 12:40:02 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13168 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbfLQRkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 12:40:02 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5df912d30004>; Tue, 17 Dec 2019 09:39:32 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 17 Dec 2019 09:39:59 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 17 Dec 2019 09:39:59 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Dec
 2019 17:39:59 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 17 Dec 2019 17:39:52 +0000
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
        "Kirti Wankhede" <kwankhede@nvidia.com>
Subject: [PATCH v11 Kernel 3/6] vfio iommu: Implementation of ioctl to for dirty pages tracking.
Date:   Tue, 17 Dec 2019 22:40:48 +0530
Message-ID: <1576602651-15430-4-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1576602651-15430-1-git-send-email-kwankhede@nvidia.com>
References: <1576602651-15430-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576604372; bh=QOnEmR+EkkyOxeGaIH1jBaSXyczDPhA7hX51JeJjvWs=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=OmlvCHUonHtgDtIm0vQQnzqdUAlMt6ndmApLDNzAEM73LOV8r2ulZPKV8iqW4aCeE
         3/NovsASmFyg43oFWzRnLlFDGkuQX8+ZR/fR6HvIDwpF6wM0gW9R9nhok23txc20o5
         MncDH9sqWgoEBytnDehZIe1XTly9iYsUm07O//42eh2NMYW9lw0ZDqrIQ/z+PPqwe8
         THNw6pQy/2/tP7MiUioBYqC/rW0W0bZagNcTcfPKefEfJt0buMgGl5YXCKsfPcBr76
         mEMX1g7yaiPnDAl1jWAFQIyFV20NmCLBgKyLZk1AWj3W3goJvMhke5IkPG3N81hEn+
         7DrL9vEBV/0gQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VFIO_IOMMU_DIRTY_PAGES ioctl performs three operations:
- Start unpinned pages dirty pages tracking while migration is active and
  device is running, i.e. during pre-copy phase.
- Stop unpinned pages dirty pages tracking. This is required to stop
  unpinned dirty pages tracking if migration failed or cancelled during
  pre-copy phase. Unpinned pages tracking is clear.
- Get dirty pages bitmap. Stop unpinned dirty pages tracking and clear
  unpinned pages information on bitmap read. This ioctl returns bitmap of
  dirty pages, its user space application responsibility to copy content
  of dirty pages from source to destination during migration.

Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
Reviewed-by: Neo Jia <cjia@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 218 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 209 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 2ada8e6cdb88..215aecb25453 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -70,6 +70,7 @@ struct vfio_iommu {
 	unsigned int		dma_avail;
 	bool			v2;
 	bool			nesting;
+	bool			dirty_page_tracking;
 };
 
 struct vfio_domain {
@@ -112,6 +113,7 @@ struct vfio_pfn {
 	dma_addr_t		iova;		/* Device address */
 	unsigned long		pfn;		/* Host pfn */
 	atomic_t		ref_count;
+	bool			unpinned;
 };
 
 struct vfio_regions {
@@ -244,6 +246,32 @@ static void vfio_remove_from_pfn_list(struct vfio_dma *dma,
 	kfree(vpfn);
 }
 
+static void vfio_remove_unpinned_from_pfn_list(struct vfio_dma *dma, bool warn)
+{
+	struct rb_node *n = rb_first(&dma->pfn_list);
+
+	for (; n; n = rb_next(n)) {
+		struct vfio_pfn *vpfn = rb_entry(n, struct vfio_pfn, node);
+
+		if (warn)
+			WARN_ON_ONCE(vpfn->unpinned);
+
+		if (vpfn->unpinned)
+			vfio_remove_from_pfn_list(dma, vpfn);
+	}
+}
+
+static void vfio_remove_unpinned_from_dma_list(struct vfio_iommu *iommu)
+{
+	struct rb_node *n = rb_first(&iommu->dma_list);
+
+	for (; n; n = rb_next(n)) {
+		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
+
+		vfio_remove_unpinned_from_pfn_list(dma, false);
+	}
+}
+
 static struct vfio_pfn *vfio_iova_get_vfio_pfn(struct vfio_dma *dma,
 					       unsigned long iova)
 {
@@ -254,13 +282,17 @@ static struct vfio_pfn *vfio_iova_get_vfio_pfn(struct vfio_dma *dma,
 	return vpfn;
 }
 
-static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn)
+static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn,
+				  bool dirty_tracking)
 {
 	int ret = 0;
 
 	if (atomic_dec_and_test(&vpfn->ref_count)) {
 		ret = put_pfn(vpfn->pfn, dma->prot);
-		vfio_remove_from_pfn_list(dma, vpfn);
+		if (dirty_tracking)
+			vpfn->unpinned = true;
+		else
+			vfio_remove_from_pfn_list(dma, vpfn);
 	}
 	return ret;
 }
@@ -504,7 +536,7 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 }
 
 static int vfio_unpin_page_external(struct vfio_dma *dma, dma_addr_t iova,
-				    bool do_accounting)
+				    bool do_accounting, bool dirty_tracking)
 {
 	int unlocked;
 	struct vfio_pfn *vpfn = vfio_find_vpfn(dma, iova);
@@ -512,7 +544,10 @@ static int vfio_unpin_page_external(struct vfio_dma *dma, dma_addr_t iova,
 	if (!vpfn)
 		return 0;
 
-	unlocked = vfio_iova_put_vfio_pfn(dma, vpfn);
+	if (vpfn->unpinned)
+		return 0;
+
+	unlocked = vfio_iova_put_vfio_pfn(dma, vpfn, dirty_tracking);
 
 	if (do_accounting)
 		vfio_lock_acct(dma, -unlocked, true);
@@ -571,8 +606,12 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 
 		vpfn = vfio_iova_get_vfio_pfn(dma, iova);
 		if (vpfn) {
-			phys_pfn[i] = vpfn->pfn;
-			continue;
+			if (vpfn->unpinned)
+				vfio_remove_from_pfn_list(dma, vpfn);
+			else {
+				phys_pfn[i] = vpfn->pfn;
+				continue;
+			}
 		}
 
 		remote_vaddr = dma->vaddr + iova - dma->iova;
@@ -583,7 +622,8 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 
 		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
 		if (ret) {
-			vfio_unpin_page_external(dma, iova, do_accounting);
+			vfio_unpin_page_external(dma, iova, do_accounting,
+						 false);
 			goto pin_unwind;
 		}
 	}
@@ -598,7 +638,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 
 		iova = user_pfn[j] << PAGE_SHIFT;
 		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
-		vfio_unpin_page_external(dma, iova, do_accounting);
+		vfio_unpin_page_external(dma, iova, do_accounting, false);
 		phys_pfn[j] = 0;
 	}
 pin_done:
@@ -632,7 +672,8 @@ static int vfio_iommu_type1_unpin_pages(void *iommu_data,
 		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
 		if (!dma)
 			goto unpin_exit;
-		vfio_unpin_page_external(dma, iova, do_accounting);
+		vfio_unpin_page_external(dma, iova, do_accounting,
+					 iommu->dirty_page_tracking);
 	}
 
 unpin_exit:
@@ -850,6 +891,88 @@ static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
 	return bitmap;
 }
 
+/*
+ * start_iova is the reference from where bitmaping started. This is called
+ * from DMA_UNMAP where start_iova can be different than iova
+ */
+
+static void vfio_iova_dirty_bitmap(struct vfio_iommu *iommu, dma_addr_t iova,
+				  size_t size, uint64_t pgsize,
+				  dma_addr_t start_iova, unsigned long *bitmap)
+{
+	struct vfio_dma *dma;
+	dma_addr_t i = iova;
+	unsigned long pgshift = __ffs(pgsize);
+
+	while ((dma = vfio_find_dma(iommu, i, pgsize))) {
+		/* mark all pages dirty if all pages are pinned and mapped. */
+		if (dma->iommu_mapped) {
+			dma_addr_t iova_limit;
+
+			iova_limit = (dma->iova + dma->size) < (iova + size) ?
+				     (dma->iova + dma->size) : (iova + size);
+
+			for (; i < iova_limit; i += pgsize) {
+				unsigned int start;
+
+				start = (i - start_iova) >> pgshift;
+
+				__bitmap_set(bitmap, start, 1);
+			}
+			if (i >= iova + size)
+				return;
+		} else {
+			struct rb_node *n = rb_first(&dma->pfn_list);
+			bool found = false;
+
+			for (; n; n = rb_next(n)) {
+				struct vfio_pfn *vpfn = rb_entry(n,
+							struct vfio_pfn, node);
+				if (vpfn->iova >= i) {
+					found = true;
+					break;
+				}
+			}
+
+			if (!found) {
+				i += dma->size;
+				continue;
+			}
+
+			for (; n; n = rb_next(n)) {
+				unsigned int start;
+				struct vfio_pfn *vpfn = rb_entry(n,
+							struct vfio_pfn, node);
+
+				if (vpfn->iova >= iova + size)
+					return;
+
+				start = (vpfn->iova - start_iova) >> pgshift;
+
+				__bitmap_set(bitmap, start, 1);
+
+				i = vpfn->iova + pgsize;
+			}
+		}
+		vfio_remove_unpinned_from_pfn_list(dma, false);
+	}
+}
+
+static long verify_bitmap_size(unsigned long npages, unsigned long bitmap_size)
+{
+	long bsize;
+
+	if (!bitmap_size || bitmap_size > SIZE_MAX)
+		return -EINVAL;
+
+	bsize = ALIGN(npages, BITS_PER_LONG) / sizeof(unsigned long);
+
+	if (bitmap_size < bsize)
+		return -EINVAL;
+
+	return bsize;
+}
+
 static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 			     struct vfio_iommu_type1_dma_unmap *unmap)
 {
@@ -2297,6 +2420,83 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 
 		return copy_to_user((void __user *)arg, &unmap, minsz) ?
 			-EFAULT : 0;
+	} else if (cmd == VFIO_IOMMU_DIRTY_PAGES) {
+		struct vfio_iommu_type1_dirty_bitmap range;
+		uint32_t mask = VFIO_IOMMU_DIRTY_PAGES_FLAG_START |
+				VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP |
+				VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP;
+		int ret;
+
+		if (!iommu->v2)
+			return -EACCES;
+
+		minsz = offsetofend(struct vfio_iommu_type1_dirty_bitmap,
+				    bitmap);
+
+		if (copy_from_user(&range, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (range.argsz < minsz || range.flags & ~mask)
+			return -EINVAL;
+
+		if (range.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_START) {
+			iommu->dirty_page_tracking = true;
+			return 0;
+		} else if (range.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP) {
+			iommu->dirty_page_tracking = false;
+
+			mutex_lock(&iommu->lock);
+			vfio_remove_unpinned_from_dma_list(iommu);
+			mutex_unlock(&iommu->lock);
+			return 0;
+
+		} else if (range.flags &
+				 VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP) {
+			uint64_t iommu_pgmask;
+			unsigned long pgshift = __ffs(range.pgsize);
+			unsigned long *bitmap;
+			long bsize;
+
+			iommu_pgmask =
+			 ((uint64_t)1 << __ffs(vfio_pgsize_bitmap(iommu))) - 1;
+
+			if (((range.pgsize - 1) & iommu_pgmask) !=
+			    (range.pgsize - 1))
+				return -EINVAL;
+
+			if (range.iova & iommu_pgmask)
+				return -EINVAL;
+			if (!range.size || range.size > SIZE_MAX)
+				return -EINVAL;
+			if (range.iova + range.size < range.iova)
+				return -EINVAL;
+
+			bsize = verify_bitmap_size(range.size >> pgshift,
+						   range.bitmap_size);
+			if (bsize < 0)
+				return ret;
+
+			bitmap = kmalloc(bsize, GFP_KERNEL);
+			if (!bitmap)
+				return -ENOMEM;
+
+			ret = copy_from_user(bitmap,
+			     (void __user *)range.bitmap, bsize) ? -EFAULT : 0;
+			if (ret)
+				goto bitmap_exit;
+
+			iommu->dirty_page_tracking = false;
+			mutex_lock(&iommu->lock);
+			vfio_iova_dirty_bitmap(iommu, range.iova, range.size,
+					     range.pgsize, range.iova, bitmap);
+			mutex_unlock(&iommu->lock);
+
+			ret = copy_to_user((void __user *)range.bitmap, bitmap,
+					   range.bitmap_size) ? -EFAULT : 0;
+bitmap_exit:
+			kfree(bitmap);
+			return ret;
+		}
 	}
 
 	return -ENOTTY;
-- 
2.7.0

