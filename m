Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0234331F37
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 07:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhCIGW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 01:22:57 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:13455 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhCIGW0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 01:22:26 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DvlT45JTXzkWc1;
        Tue,  9 Mar 2021 14:20:56 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.184.135) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Tue, 9 Mar 2021 14:22:17 +0800
From:   Shenming Lu <lushenming@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-api@vger.kernel.org>
CC:     Kevin Tian <kevin.tian@intel.com>, <yi.l.liu@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>,
        <zhukeqian1@huawei.com>, <lushenming@huawei.com>
Subject: [RFC PATCH v2 2/6] vfio: Add an MMU notifier to avoid pinning
Date:   Tue, 9 Mar 2021 14:22:03 +0800
Message-ID: <20210309062207.505-3-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
In-Reply-To: <20210309062207.505-1-lushenming@huawei.com>
References: <20210309062207.505-1-lushenming@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.184.135]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To avoid pinning pages when they are mapped in IOMMU page tables,
we add an MMU notifier to tell the addresses which are no longer
valid and try to unmap them.

Signed-off-by: Shenming Lu <lushenming@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 68 +++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 4bb162c1d649..03ccc11057af 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -40,6 +40,7 @@
 #include <linux/notifier.h>
 #include <linux/dma-iommu.h>
 #include <linux/irqdomain.h>
+#include <linux/mmu_notifier.h>
 
 #define DRIVER_VERSION  "0.2"
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
@@ -69,6 +70,7 @@ struct vfio_iommu {
 	struct mutex		lock;
 	struct rb_root		dma_list;
 	struct blocking_notifier_head notifier;
+	struct mmu_notifier	mn;
 	unsigned int		dma_avail;
 	unsigned int		vaddr_invalid_count;
 	uint64_t		pgsize_bitmap;
@@ -101,6 +103,7 @@ struct vfio_dma {
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
+	unsigned long		*iopf_mapped_bitmap;
 };
 
 struct vfio_batch {
@@ -157,6 +160,10 @@ struct vfio_regions {
 #define DIRTY_BITMAP_PAGES_MAX	 ((u64)INT_MAX)
 #define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
 
+#define IOPF_MAPPED_BITMAP_GET(dma, i)	\
+			      ((dma->iopf_mapped_bitmap[(i) / BITS_PER_LONG]	\
+			       >> ((i) % BITS_PER_LONG)) & 0x1)
+
 #define WAITED 1
 
 static int put_pfn(unsigned long pfn, int prot);
@@ -1149,6 +1156,35 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 	return unlocked;
 }
 
+static void vfio_unmap_partial_iopf(struct vfio_iommu *iommu,
+				    struct vfio_dma *dma,
+				    dma_addr_t start, dma_addr_t end)
+{
+	unsigned long bit_offset;
+	size_t len;
+	struct vfio_domain *d;
+
+	while (start < end) {
+		bit_offset = (start - dma->iova) >> PAGE_SHIFT;
+
+		for (len = 0; start + len < end; len += PAGE_SIZE) {
+			if (!IOPF_MAPPED_BITMAP_GET(dma,
+					bit_offset + (len >> PAGE_SHIFT)))
+				break;
+		}
+
+		if (len) {
+			list_for_each_entry(d, &iommu->domain_list, next)
+				iommu_unmap(d->domain, start, len);
+
+			bitmap_clear(dma->iopf_mapped_bitmap,
+				     bit_offset, len >> PAGE_SHIFT);
+		}
+
+		start += (len + PAGE_SIZE);
+	}
+}
+
 static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 {
 	WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list));
@@ -3096,6 +3132,38 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 	return -EINVAL;
 }
 
+static void mn_invalidate_range(struct mmu_notifier *mn, struct mm_struct *mm,
+				unsigned long start, unsigned long end)
+{
+	struct vfio_iommu *iommu = container_of(mn, struct vfio_iommu, mn);
+	struct rb_node *n;
+
+	mutex_lock(&iommu->lock);
+
+	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
+		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
+		unsigned long start_n, end_n;
+
+		if (end <= dma->vaddr || start >= dma->vaddr + dma->size)
+			continue;
+
+		start_n = ALIGN_DOWN(max_t(unsigned long, start, dma->vaddr),
+				     PAGE_SIZE);
+		end_n = ALIGN(min_t(unsigned long, end, dma->vaddr + dma->size),
+			      PAGE_SIZE);
+
+		vfio_unmap_partial_iopf(iommu, dma,
+					start_n - dma->vaddr + dma->iova,
+					end_n - dma->vaddr + dma->iova);
+	}
+
+	mutex_unlock(&iommu->lock);
+}
+
+static const struct mmu_notifier_ops vfio_iommu_type1_mn_ops = {
+	.invalidate_range	= mn_invalidate_range,
+};
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
-- 
2.19.1

