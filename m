Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8CF359357
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 05:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbhDIDpg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 23:45:36 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16423 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233173AbhDIDpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 23:45:05 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FGkVZ6mXCzlWqh;
        Fri,  9 Apr 2021 11:43:02 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.184.135) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Fri, 9 Apr 2021 11:44:41 +0800
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
Subject: [RFC PATCH v3 6/8] vfio/type1: No need to statically pin and map if IOPF enabled
Date:   Fri, 9 Apr 2021 11:44:18 +0800
Message-ID: <20210409034420.1799-7-lushenming@huawei.com>
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

If IOPF enabled for the VFIO container, there is no need to statically
pin and map the entire DMA range, we can do it on demand. And unmap
according to the IOPF mapped bitmap when removing vfio_dma.

Note that we still mark all pages dirty even if IOPF enabled, we may
add IOPF-based fine grained dirty tracking support in the future.

Signed-off-by: Shenming Lu <lushenming@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 38 +++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 7df5711e743a..dcc93c3b258c 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -175,6 +175,7 @@ struct vfio_iopf_group {
 #define IOPF_MAPPED_BITMAP_GET(dma, i)	\
 			      ((dma->iopf_mapped_bitmap[(i) / BITS_PER_LONG]	\
 			       >> ((i) % BITS_PER_LONG)) & 0x1)
+#define IOPF_MAPPED_BITMAP_BYTES(n)	DIRTY_BITMAP_BYTES(n)
 
 #define WAITED 1
 
@@ -959,7 +960,8 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 	 * already pinned and accounted. Accouting should be done if there is no
 	 * iommu capable domain in the container.
 	 */
-	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);
+	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu) ||
+			iommu->iopf_enabled;
 
 	for (i = 0; i < npage; i++) {
 		struct vfio_pfn *vpfn;
@@ -1048,7 +1050,8 @@ static int vfio_iommu_type1_unpin_pages(void *iommu_data,
 
 	mutex_lock(&iommu->lock);
 
-	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);
+	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu) ||
+			iommu->iopf_enabled;
 	for (i = 0; i < npage; i++) {
 		struct vfio_dma *dma;
 		dma_addr_t iova;
@@ -1169,7 +1172,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 	if (!dma->size)
 		return 0;
 
-	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
+	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu) || iommu->iopf_enabled)
 		return 0;
 
 	/*
@@ -1306,11 +1309,20 @@ static void vfio_unmap_partial_iopf(struct vfio_iommu *iommu,
 	}
 }
 
+static void vfio_dma_clean_iopf(struct vfio_iommu *iommu, struct vfio_dma *dma)
+{
+	vfio_unmap_partial_iopf(iommu, dma, dma->iova, dma->iova + dma->size);
+
+	kfree(dma->iopf_mapped_bitmap);
+}
+
 static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 {
 	WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list));
 	vfio_unmap_unpin(iommu, dma, true);
 	vfio_unlink_dma(iommu, dma);
+	if (iommu->iopf_enabled)
+		vfio_dma_clean_iopf(iommu, dma);
 	put_task_struct(dma->task);
 	vfio_dma_bitmap_free(dma);
 	if (dma->vaddr_invalid) {
@@ -1359,7 +1371,8 @@ static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 	 * mark all pages dirty if any IOMMU capable device is not able
 	 * to report dirty pages and all pages are pinned and mapped.
 	 */
-	if (iommu->num_non_pinned_groups && dma->iommu_mapped)
+	if (iommu->num_non_pinned_groups &&
+	    (dma->iommu_mapped || iommu->iopf_enabled))
 		bitmap_set(dma->bitmap, 0, nbits);
 
 	if (shift) {
@@ -1772,6 +1785,16 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 		goto out_unlock;
 	}
 
+	if (iommu->iopf_enabled) {
+		dma->iopf_mapped_bitmap = kvzalloc(IOPF_MAPPED_BITMAP_BYTES(
+						size >> PAGE_SHIFT), GFP_KERNEL);
+		if (!dma->iopf_mapped_bitmap) {
+			ret = -ENOMEM;
+			kfree(dma);
+			goto out_unlock;
+		}
+	}
+
 	iommu->dma_avail--;
 	dma->iova = iova;
 	dma->vaddr = vaddr;
@@ -1811,8 +1834,11 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	/* Insert zero-sized and grow as we map chunks of it */
 	vfio_link_dma(iommu, dma);
 
-	/* Don't pin and map if container doesn't contain IOMMU capable domain*/
-	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
+	/*
+	 * Don't pin and map if container doesn't contain IOMMU capable domain,
+	 * or IOPF enabled for the container.
+	 */
+	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu) || iommu->iopf_enabled)
 		dma->size = size;
 	else
 		ret = vfio_pin_map_dma(iommu, dma, size);
-- 
2.19.1

