Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3273F3763F4
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 12:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236961AbhEGKiE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 06:38:04 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:18788 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236951AbhEGKiC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 06:38:02 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Fc6JH3bzHzCr5J;
        Fri,  7 May 2021 18:34:23 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.224) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Fri, 7 May 2021 18:36:51 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Cornelia Huck" <cohuck@redhat.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Tian Kevin <kevin.tian@intel.com>
CC:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>,
        <yuzenghui@huawei.com>, <lushenming@huawei.com>
Subject: [RFC PATCH v2 3/3] vfio/iommu_type1: Add support for manual dirty log clear
Date:   Fri, 7 May 2021 18:36:08 +0800
Message-ID: <20210507103608.39440-4-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210507103608.39440-1-zhukeqian1@huawei.com>
References: <20210507103608.39440-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kunkun Jiang <jiangkunkun@huawei.com>

In the past, we clear dirty log immediately after sync dirty
log to userspace. This may cause redundant dirty handling if
userspace handles dirty log iteratively:

After vfio clears dirty log, new dirty log starts to generate.
These new dirty log will be reported to userspace even if they
are generated before userspace handles the same dirty page.
That's to say, we should minimize the time gap of dirty log
clearing and dirty log handling.

This adds two user interfaces. Note that user should clear dirty
log before handle corresponding dirty pages.
1. GET_BITMAP_NOCLEAR: get dirty log without clear.
2. CLEAR_BITMAP: manually clear dirty log.

Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 114 ++++++++++++++++++++++++++++++--
 include/uapi/linux/vfio.h       |  36 +++++++++-
 2 files changed, 142 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 12fe1cf9113e..9efd2586f1d0 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -78,6 +78,7 @@ struct vfio_iommu {
 	bool			v2;
 	bool			nesting;
 	bool			dirty_page_tracking;
+	bool			dirty_log_get_no_clear;
 	bool			container_open;
 };
 
@@ -1240,6 +1241,76 @@ static int vfio_iommu_dirty_log_sync(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static int vfio_iova_dirty_log_clear(u64 __user *bitmap,
+				     struct vfio_iommu *iommu,
+				     dma_addr_t iova, size_t size,
+				     size_t pgsize)
+{
+	struct vfio_dma *dma;
+	struct rb_node *n;
+	dma_addr_t start_iova, end_iova, riova;
+	unsigned long pgshift = __ffs(pgsize);
+	unsigned long bitmap_size;
+	unsigned long *bitmap_buffer = NULL;
+	bool clear_valid;
+	int rs, re, start, end, dma_offset;
+	int ret = 0;
+
+	bitmap_size = DIRTY_BITMAP_BYTES(size >> pgshift);
+	bitmap_buffer = kvmalloc(bitmap_size, GFP_KERNEL);
+	if (!bitmap_buffer) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (copy_from_user(bitmap_buffer, bitmap, bitmap_size)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
+		dma = rb_entry(n, struct vfio_dma, node);
+		if ((dma->iova + dma->size - 1) < iova)
+			continue;
+		if (dma->iova > iova + size - 1)
+			break;
+
+		start_iova = max(iova, dma->iova);
+		end_iova = min(iova + size, dma->iova + dma->size);
+
+		/* Similar logic as the tail of vfio_iova_dirty_bitmap */
+
+		clear_valid = false;
+		start = (start_iova - iova) >> pgshift;
+		end = (end_iova - iova) >> pgshift;
+		bitmap_for_each_set_region(bitmap_buffer, rs, re, start, end) {
+			clear_valid = true;
+			riova = iova + (rs << pgshift);
+			dma_offset = (riova - dma->iova) >> pgshift;
+			bitmap_clear(dma->bitmap, dma_offset, re - rs);
+		}
+
+		if (clear_valid)
+			vfio_dma_populate_bitmap(dma, pgsize);
+
+		if (clear_valid && iommu->num_non_pinned_groups &&
+		    dma->iommu_mapped && !iommu->num_non_hwdbm_domains) {
+			ret = vfio_iommu_dirty_log_clear(iommu, start_iova,
+					end_iova - start_iova, bitmap_buffer,
+					iova, pgshift);
+			if (ret) {
+				pr_warn("dma dirty log clear failed!\n");
+				goto out;
+			}
+		}
+
+	}
+
+out:
+	kfree(bitmap_buffer);
+	return ret;
+}
+
 static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 			      struct vfio_dma *dma, dma_addr_t base_iova,
 			      size_t pgsize)
@@ -1285,8 +1356,11 @@ static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 			 DIRTY_BITMAP_BYTES(nbits + shift)))
 		return -EFAULT;
 
-	/* Recover the bitmap if it'll be used to clear hardware dirty log */
-	if (shift && iommu_hwdbm_dirty)
+	/*
+	 * Recover the bitmap if it'll be used to clear hardware dirty log, or
+	 * user wants to clear the dirty bitmap manually.
+	 */
+	if (shift && (iommu_hwdbm_dirty || iommu->dirty_log_get_no_clear))
 		bitmap_shift_right(dma->bitmap, dma->bitmap, shift,
 				   nbits + shift);
 
@@ -1328,6 +1402,10 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 		if (ret)
 			return ret;
 
+		/* Do not clear dirty automatically when require no clear */
+		if (iommu->dirty_log_get_no_clear)
+			continue;
+
 		/* Clear iommu dirty log to re-enable dirty log tracking */
 		if (iommu->num_non_pinned_groups && dma->iommu_mapped &&
 		    !iommu->num_non_hwdbm_domains) {
@@ -2920,6 +2998,10 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
 		if (!iommu)
 			return 0;
 		return vfio_domains_have_iommu_cache(iommu);
+	case VFIO_DIRTY_LOG_MANUAL_CLEAR:
+		if (!iommu)
+			return 0;
+		return 1;
 	default:
 		return 0;
 	}
@@ -3175,7 +3257,9 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 	struct vfio_iommu_type1_dirty_bitmap dirty;
 	uint32_t mask = VFIO_IOMMU_DIRTY_PAGES_FLAG_START |
 			VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP |
-			VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP;
+			VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP |
+			VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP_NOCLEAR |
+			VFIO_IOMMU_DIRTY_PAGES_FLAG_CLEAR_BITMAP;
 	unsigned long minsz;
 	int ret = 0;
 
@@ -3217,7 +3301,9 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 		}
 		mutex_unlock(&iommu->lock);
 		return 0;
-	} else if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP) {
+	} else if (dirty.flags & (VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP |
+			VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP_NOCLEAR |
+			VFIO_IOMMU_DIRTY_PAGES_FLAG_CLEAR_BITMAP)) {
 		struct vfio_iommu_type1_dirty_bitmap_get range;
 		unsigned long pgshift;
 		size_t data_size = dirty.argsz - minsz;
@@ -3260,13 +3346,27 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 			goto out_unlock;
 		}
 
-		if (iommu->dirty_page_tracking)
+		if (!iommu->dirty_page_tracking) {
+			ret = -EINVAL;
+			goto out_unlock;
+		}
+
+		if (dirty.flags & (VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP |
+			VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP_NOCLEAR)) {
+
+			iommu->dirty_log_get_no_clear = !!(dirty.flags &
+				VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP_NOCLEAR);
+
 			ret = vfio_iova_dirty_bitmap(range.bitmap.data,
 						     iommu, range.iova,
 						     range.size,
 						     range.bitmap.pgsize);
-		else
-			ret = -EINVAL;
+		} else {
+			ret = vfio_iova_dirty_log_clear(range.bitmap.data,
+							iommu, range.iova,
+							range.size,
+							range.bitmap.pgsize);
+		}
 out_unlock:
 		mutex_unlock(&iommu->lock);
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 34b1f53a3901..0d4281fe9e41 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -52,6 +52,16 @@
 /* Supports the vaddr flag for DMA map and unmap */
 #define VFIO_UPDATE_VADDR		10
 
+/*
+ * The vfio_iommu driver may support user clears dirty log manually, which means
+ * dirty log can be requested to not cleared automatically after dirty log is
+ * copied to userspace, it's user's duty to clear dirty log.
+ *
+ * Note: please refer to VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP_NOCLEAR and
+ * VFIO_IOMMU_DIRTY_PAGES_FLAG_CLEAR_BITMAP.
+ */
+#define VFIO_DIRTY_LOG_MANUAL_CLEAR	11
+
 /*
  * The IOCTL interface is designed for extensibility by embedding the
  * structure length (argsz) and flags into structures passed between
@@ -1158,8 +1168,30 @@ struct vfio_iommu_type1_dma_unmap {
  * actual bitmap. If dirty pages logging is not enabled, an error will be
  * returned.
  *
- * Only one of the flags _START, _STOP and _GET may be specified at a time.
+ * The VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP_NOCLEAR flag is almost same as
+ * VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP, except that it requires underlying
+ * dirty bitmap is not cleared automatically. The user can clear it manually by
+ * calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_FLAG_CLEAR_BITMAP flag set.
  *
+ * Calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_FLAG_CLEAR_BITMAP flag set,
+ * instructs the IOMMU driver to clear the dirty status of pages in a bitmap
+ * for IOMMU container for a given IOVA range. The user must specify the IOVA
+ * range, the bitmap and the pgsize through the structure
+ * vfio_iommu_type1_dirty_bitmap_get in the data[] portion. This interface
+ * supports clearing a bitmap of the smallest supported pgsize only and can be
+ * modified in future to clear a bitmap of any specified supported pgsize. The
+ * user must provide a memory area for the bitmap memory and specify its size
+ * in bitmap.size. One bit is used to represent one page consecutively starting
+ * from iova offset. The user should provide page size in bitmap.pgsize field.
+ * A bit set in the bitmap indicates that the page at that offset from iova is
+ * cleared the dirty status, and dirty tracking is re-enabled for that page. The
+ * caller must set argsz to a value including the size of structure
+ * vfio_iommu_dirty_bitmap_get, but excluing the size of the actual bitmap. If
+ * dirty pages logging is not enabled, an error will be returned. Note: user
+ * should clear dirty log before handle corresponding dirty pages.
+ *
+ * Only one of the flags _START, _STOP, _GET, _GET_NOCLEAR_, and _CLEAR may be
+ * specified at a time.
  */
 struct vfio_iommu_type1_dirty_bitmap {
 	__u32        argsz;
@@ -1167,6 +1199,8 @@ struct vfio_iommu_type1_dirty_bitmap {
 #define VFIO_IOMMU_DIRTY_PAGES_FLAG_START	(1 << 0)
 #define VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP	(1 << 1)
 #define VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP	(1 << 2)
+#define VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP_NOCLEAR	(1 << 3)
+#define VFIO_IOMMU_DIRTY_PAGES_FLAG_CLEAR_BITMAP	(1 << 4)
 	__u8         data[];
 };
 
-- 
2.19.1

