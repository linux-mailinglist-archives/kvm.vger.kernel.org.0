Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3A435933D
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 05:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbhDIDo5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 23:44:57 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15636 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbhDIDoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 23:44:55 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FGkTF1XZ0znZ7R;
        Fri,  9 Apr 2021 11:41:53 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.184.135) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Fri, 9 Apr 2021 11:44:34 +0800
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
Subject: [RFC PATCH v3 2/8] vfio/type1: Add a page fault handler
Date:   Fri, 9 Apr 2021 11:44:14 +0800
Message-ID: <20210409034420.1799-3-lushenming@huawei.com>
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

VFIO manages the DMA mapping itself. To support IOPF (on-demand paging)
for VFIO (IOMMU capable) devices, we add a VFIO page fault handler to
serve the reported page faults from the IOMMU driver.

Signed-off-by: Shenming Lu <lushenming@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 114 ++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 45cbfd4879a5..ab0ff60ee207 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -101,6 +101,7 @@ struct vfio_dma {
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
+	unsigned long		*iopf_mapped_bitmap;
 };
 
 struct vfio_batch {
@@ -141,6 +142,16 @@ struct vfio_regions {
 	size_t len;
 };
 
+/* A global IOPF enabled group list */
+static struct rb_root iopf_group_list = RB_ROOT;
+static DEFINE_MUTEX(iopf_group_list_lock);
+
+struct vfio_iopf_group {
+	struct rb_node		node;
+	struct iommu_group	*iommu_group;
+	struct vfio_iommu	*iommu;
+};
+
 #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
 					(!list_empty(&iommu->domain_list))
 
@@ -157,6 +168,10 @@ struct vfio_regions {
 #define DIRTY_BITMAP_PAGES_MAX	 ((u64)INT_MAX)
 #define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
 
+#define IOPF_MAPPED_BITMAP_GET(dma, i)	\
+			      ((dma->iopf_mapped_bitmap[(i) / BITS_PER_LONG]	\
+			       >> ((i) % BITS_PER_LONG)) & 0x1)
+
 #define WAITED 1
 
 static int put_pfn(unsigned long pfn, int prot);
@@ -416,6 +431,34 @@ static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn)
 	return ret;
 }
 
+/*
+ * Helper functions for iopf_group_list
+ */
+static struct vfio_iopf_group *
+vfio_find_iopf_group(struct iommu_group *iommu_group)
+{
+	struct vfio_iopf_group *iopf_group;
+	struct rb_node *node;
+
+	mutex_lock(&iopf_group_list_lock);
+
+	node = iopf_group_list.rb_node;
+
+	while (node) {
+		iopf_group = rb_entry(node, struct vfio_iopf_group, node);
+
+		if (iommu_group < iopf_group->iommu_group)
+			node = node->rb_left;
+		else if (iommu_group > iopf_group->iommu_group)
+			node = node->rb_right;
+		else
+			break;
+	}
+
+	mutex_unlock(&iopf_group_list_lock);
+	return node ? iopf_group : NULL;
+}
+
 static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
 {
 	struct mm_struct *mm;
@@ -3106,6 +3149,77 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 	return -EINVAL;
 }
 
+/* VFIO I/O Page Fault handler */
+static int vfio_iommu_type1_dma_map_iopf(struct iommu_fault *fault, void *data)
+{
+	struct device *dev = (struct device *)data;
+	struct iommu_group *iommu_group;
+	struct vfio_iopf_group *iopf_group;
+	struct vfio_iommu *iommu;
+	struct vfio_dma *dma;
+	dma_addr_t iova = ALIGN_DOWN(fault->prm.addr, PAGE_SIZE);
+	int access_flags = 0;
+	unsigned long bit_offset, vaddr, pfn;
+	int ret;
+	enum iommu_page_response_code status = IOMMU_PAGE_RESP_INVALID;
+	struct iommu_page_response resp = {0};
+
+	if (fault->type != IOMMU_FAULT_PAGE_REQ)
+		return -EOPNOTSUPP;
+
+	iommu_group = iommu_group_get(dev);
+	if (!iommu_group)
+		return -ENODEV;
+
+	iopf_group = vfio_find_iopf_group(iommu_group);
+	iommu_group_put(iommu_group);
+	if (!iopf_group)
+		return -ENODEV;
+
+	iommu = iopf_group->iommu;
+
+	mutex_lock(&iommu->lock);
+
+	ret = vfio_find_dma_valid(iommu, iova, PAGE_SIZE, &dma);
+	if (ret < 0)
+		goto out_invalid;
+
+	if (fault->prm.perm & IOMMU_FAULT_PERM_READ)
+		access_flags |= IOMMU_READ;
+	if (fault->prm.perm & IOMMU_FAULT_PERM_WRITE)
+		access_flags |= IOMMU_WRITE;
+	if ((dma->prot & access_flags) != access_flags)
+		goto out_invalid;
+
+	bit_offset = (iova - dma->iova) >> PAGE_SHIFT;
+	if (IOPF_MAPPED_BITMAP_GET(dma, bit_offset))
+		goto out_success;
+
+	vaddr = iova - dma->iova + dma->vaddr;
+
+	if (vfio_pin_page_external(dma, vaddr, &pfn, true))
+		goto out_invalid;
+
+	if (vfio_iommu_map(iommu, iova, pfn, 1, dma->prot)) {
+		if (put_pfn(pfn, dma->prot))
+			vfio_lock_acct(dma, -1, true);
+		goto out_invalid;
+	}
+
+	bitmap_set(dma->iopf_mapped_bitmap, bit_offset, 1);
+
+out_success:
+	status = IOMMU_PAGE_RESP_SUCCESS;
+
+out_invalid:
+	mutex_unlock(&iommu->lock);
+	resp.version		= IOMMU_PAGE_RESP_VERSION_1;
+	resp.grpid		= fault->prm.grpid;
+	resp.code		= status;
+	iommu_page_response(dev, &resp);
+	return 0;
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
-- 
2.19.1

