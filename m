Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A362ECCD9
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 10:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbhAGJac (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 04:30:32 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10556 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbhAGJab (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 04:30:31 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DBLWb5xgWzMGSd;
        Thu,  7 Jan 2021 17:28:27 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Thu, 7 Jan 2021 17:29:29 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
CC:     Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>
Subject: [PATCH 1/5] vfio/iommu_type1: Fixes vfio_dma_populate_bitmap to avoid dirty lose
Date:   Thu, 7 Jan 2021 17:28:57 +0800
Message-ID: <20210107092901.19712-2-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210107092901.19712-1-zhukeqian1@huawei.com>
References: <20210107092901.19712-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Defer checking whether vfio_dma is of fully-dirty in update_user_bitmap
is easy to lose dirty log. For example, after promoting pinned_scope of
vfio_iommu, vfio_dma is not considered as fully-dirty, then we may lose
dirty log that occurs before vfio_iommu is promoted.

The key point is that pinned-dirty is not a real dirty tracking way, it
can't continuously track dirty pages, but just restrict dirty scope. It
is essentially the same as fully-dirty. Fully-dirty is of full-scope and
pinned-dirty is of pinned-scope.

So we must mark pinned-dirty or fully-dirty after we start dirty tracking
or clear dirty bitmap, to ensure that dirty log is marked right away.

Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty pages tracking")
Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index bceda5e8baaa..b0a26e8e0adf 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -224,7 +224,7 @@ static void vfio_dma_bitmap_free(struct vfio_dma *dma)
 	dma->bitmap = NULL;
 }
 
-static void vfio_dma_populate_bitmap(struct vfio_dma *dma, size_t pgsize)
+static void vfio_dma_populate_bitmap_pinned(struct vfio_dma *dma, size_t pgsize)
 {
 	struct rb_node *p;
 	unsigned long pgshift = __ffs(pgsize);
@@ -236,6 +236,25 @@ static void vfio_dma_populate_bitmap(struct vfio_dma *dma, size_t pgsize)
 	}
 }
 
+static void vfio_dma_populate_bitmap_full(struct vfio_dma *dma, size_t pgsize)
+{
+	unsigned long pgshift = __ffs(pgsize);
+	unsigned long nbits = dma->size >> pgshift;
+
+	bitmap_set(dma->bitmap, 0, nbits);
+}
+
+static void vfio_dma_populate_bitmap(struct vfio_iommu *iommu,
+				     struct vfio_dma *dma)
+{
+	size_t pgsize = (size_t)1 << __ffs(iommu->pgsize_bitmap);
+
+	if (iommu->pinned_page_dirty_scope)
+		vfio_dma_populate_bitmap_pinned(dma, pgsize);
+	else if (dma->iommu_mapped)
+		vfio_dma_populate_bitmap_full(dma, pgsize);
+}
+
 static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu)
 {
 	struct rb_node *n;
@@ -257,7 +276,7 @@ static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu)
 			}
 			return ret;
 		}
-		vfio_dma_populate_bitmap(dma, pgsize);
+		vfio_dma_populate_bitmap(iommu, dma);
 	}
 	return 0;
 }
@@ -987,13 +1006,6 @@ static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 	unsigned long shift = bit_offset % BITS_PER_LONG;
 	unsigned long leftover;
 
-	/*
-	 * mark all pages dirty if any IOMMU capable device is not able
-	 * to report dirty pages and all pages are pinned and mapped.
-	 */
-	if (!iommu->pinned_page_dirty_scope && dma->iommu_mapped)
-		bitmap_set(dma->bitmap, 0, nbits);
-
 	if (shift) {
 		bitmap_shift_left(dma->bitmap, dma->bitmap, shift,
 				  nbits + shift);
@@ -1019,7 +1031,6 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 	struct vfio_dma *dma;
 	struct rb_node *n;
 	unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
-	size_t pgsize = (size_t)1 << pgshift;
 	int ret;
 
 	/*
@@ -1055,7 +1066,7 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 		 * pages which are marked dirty by vfio_dma_rw()
 		 */
 		bitmap_clear(dma->bitmap, 0, dma->size >> pgshift);
-		vfio_dma_populate_bitmap(dma, pgsize);
+		vfio_dma_populate_bitmap(iommu, dma);
 	}
 	return 0;
 }
-- 
2.19.1

