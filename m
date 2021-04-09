Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D6F359354
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 05:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbhDIDpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 23:45:09 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15641 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbhDIDo7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 23:44:59 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FGkTL29g4znYts;
        Fri,  9 Apr 2021 11:41:58 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.184.135) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Fri, 9 Apr 2021 11:44:36 +0800
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
CC:     Kevin Tian <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>,
        <lushenming@huawei.com>
Subject: [RFC PATCH v3 3/8] vfio/type1: Add an MMU notifier to avoid pinning
Date:   Fri, 9 Apr 2021 11:44:15 +0800
Message-ID: <20210409034420.1799-4-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
In-Reply-To: <20210409034420.1799-1-lushenming@huawei.com>
References: <20210409034420.1799-1-lushenming@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.184.135]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To avoid pinning pages when they are mapped in IOMMU page tables, we
add an MMU notifier to tell the addresses which are no longer valid
and try to unmap them.

Signed-off-by: Shenming Lu <lushenming@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 112 +++++++++++++++++++++++++++++++-
 1 file changed, 109 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index ab0ff60ee207..1cb9d1f2717b 100644
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
@@ -1204,6 +1206,72 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 	return unlocked;
 }
 
+/* Unmap the IOPF mapped pages in the specified range. */
+static void vfio_unmap_partial_iopf(struct vfio_iommu *iommu,
+				    struct vfio_dma *dma,
+				    dma_addr_t start, dma_addr_t end)
+{
+	struct iommu_iotlb_gather *gathers;
+	struct vfio_domain *d;
+	int i, num_domains = 0;
+
+	list_for_each_entry(d, &iommu->domain_list, next)
+		num_domains++;
+
+	gathers = kzalloc(sizeof(*gathers) * num_domains, GFP_KERNEL);
+	if (gathers) {
+		for (i = 0; i < num_domains; i++)
+			iommu_iotlb_gather_init(&gathers[i]);
+	}
+
+	while (start < end) {
+		unsigned long bit_offset;
+		size_t len;
+
+		bit_offset = (start - dma->iova) >> PAGE_SHIFT;
+
+		for (len = 0; start + len < end; len += PAGE_SIZE) {
+			if (!IOPF_MAPPED_BITMAP_GET(dma,
+					bit_offset + (len >> PAGE_SHIFT)))
+				break;
+		}
+
+		if (len) {
+			i = 0;
+			list_for_each_entry(d, &iommu->domain_list, next) {
+				size_t unmapped;
+
+				if (gathers)
+					unmapped = iommu_unmap_fast(d->domain,
+								    start, len,
+								    &gathers[i++]);
+				else
+					unmapped = iommu_unmap(d->domain,
+							       start, len);
+
+				if (WARN_ON(unmapped != len))
+					goto out;
+			}
+
+			bitmap_clear(dma->iopf_mapped_bitmap,
+				     bit_offset, len >> PAGE_SHIFT);
+
+			cond_resched();
+		}
+
+		start += (len + PAGE_SIZE);
+	}
+
+out:
+	if (gathers) {
+		i = 0;
+		list_for_each_entry(d, &iommu->domain_list, next)
+			iommu_iotlb_sync(d->domain, &gathers[i++]);
+
+		kfree(gathers);
+	}
+}
+
 static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 {
 	WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list));
@@ -3197,17 +3265,18 @@ static int vfio_iommu_type1_dma_map_iopf(struct iommu_fault *fault, void *data)
 
 	vaddr = iova - dma->iova + dma->vaddr;
 
-	if (vfio_pin_page_external(dma, vaddr, &pfn, true))
+	if (vfio_pin_page_external(dma, vaddr, &pfn, false))
 		goto out_invalid;
 
 	if (vfio_iommu_map(iommu, iova, pfn, 1, dma->prot)) {
-		if (put_pfn(pfn, dma->prot))
-			vfio_lock_acct(dma, -1, true);
+		put_pfn(pfn, dma->prot);
 		goto out_invalid;
 	}
 
 	bitmap_set(dma->iopf_mapped_bitmap, bit_offset, 1);
 
+	put_pfn(pfn, dma->prot);
+
 out_success:
 	status = IOMMU_PAGE_RESP_SUCCESS;
 
@@ -3220,6 +3289,43 @@ static int vfio_iommu_type1_dma_map_iopf(struct iommu_fault *fault, void *data)
 	return 0;
 }
 
+static void mn_invalidate_range(struct mmu_notifier *mn, struct mm_struct *mm,
+				unsigned long start, unsigned long end)
+{
+	struct vfio_iommu *iommu = container_of(mn, struct vfio_iommu, mn);
+	struct rb_node *n;
+	int ret;
+
+	mutex_lock(&iommu->lock);
+
+	ret = vfio_wait_all_valid(iommu);
+	if (WARN_ON(ret < 0))
+		return;
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

