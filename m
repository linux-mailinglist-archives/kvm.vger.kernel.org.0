Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9118300207
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 12:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbhAVLB3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 06:01:29 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11125 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727215AbhAVJ1o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 04:27:44 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DMYld4qd8z15vnr;
        Fri, 22 Jan 2021 17:25:49 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Fri, 22 Jan 2021 17:26:48 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <iommu@lists.linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Cornelia Huck" <cohuck@redhat.com>
CC:     Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "James Morse" <james.morse@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>
Subject: [PATCH v3 1/2] vfio/iommu_type1: Populate full dirty when detach non-pinned group
Date:   Fri, 22 Jan 2021 17:26:34 +0800
Message-ID: <20210122092635.19900-2-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210122092635.19900-1-zhukeqian1@huawei.com>
References: <20210122092635.19900-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If a group with non-pinned-page dirty scope is detached with dirty
logging enabled, we should fully populate the dirty bitmaps at the
time it's removed since we don't know the extent of its previous DMA,
nor will the group be present to trigger the full bitmap when the user
retrieves the dirty bitmap.

Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty pages tracking")
Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0b4dedaa9128..161725395f2f 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -236,6 +236,18 @@ static void vfio_dma_populate_bitmap(struct vfio_dma *dma, size_t pgsize)
 	}
 }
 
+static void vfio_iommu_populate_bitmap_full(struct vfio_iommu *iommu)
+{
+	struct rb_node *n;
+	unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
+
+	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
+		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
+
+		bitmap_set(dma->bitmap, 0, dma->size >> pgshift);
+	}
+}
+
 static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu, size_t pgsize)
 {
 	struct rb_node *n;
@@ -2415,8 +2427,11 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 	 * Removal of a group without dirty tracking may allow the iommu scope
 	 * to be promoted.
 	 */
-	if (update_dirty_scope)
+	if (update_dirty_scope) {
 		update_pinned_page_dirty_scope(iommu);
+		if (iommu->dirty_page_tracking)
+			vfio_iommu_populate_bitmap_full(iommu);
+	}
 	mutex_unlock(&iommu->lock);
 }
 
-- 
2.19.1

