Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337BD304A1D
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 21:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730368AbhAZFPB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:15:01 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:11860 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbhAYJ3Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 04:29:24 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DPP6m5ltjz7Zgy;
        Mon, 25 Jan 2021 17:03:44 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.186.182) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Mon, 25 Jan 2021 17:04:46 +0800
From:   Shenming Lu <lushenming@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>,
        <lushenming@huawei.com>
Subject: [RFC PATCH v1 2/4] vfio: Add a page fault handler
Date:   Mon, 25 Jan 2021 17:04:00 +0800
Message-ID: <20210125090402.1429-3-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
In-Reply-To: <20210125090402.1429-1-lushenming@huawei.com>
References: <20210125090402.1429-1-lushenming@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.186.182]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VFIO manages the passthrough DMA mapping itself. In order to support
IOPF for VFIO devices, we need to add a VFIO page fault handler to
serve the reported page faults from the IOMMU driver.

Signed-off-by: Shenming Lu <lushenming@huawei.com>
---
 drivers/vfio/vfio.c             | 35 ++++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c | 58 +++++++++++++++++++++++++++++++++
 include/linux/vfio.h            |  5 +++
 3 files changed, 98 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 4ad8a35667a7..ff7797260d0f 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -2349,6 +2349,41 @@ struct iommu_domain *vfio_group_iommu_domain(struct vfio_group *group)
 }
 EXPORT_SYMBOL_GPL(vfio_group_iommu_domain);
 
+int vfio_iommu_dev_fault_handler(struct iommu_fault *fault, void *data)
+{
+	struct device *dev = (struct device *)data;
+	struct vfio_container *container;
+	struct vfio_group *group;
+	struct vfio_iommu_driver *driver;
+	int ret;
+
+	if (!dev)
+		return -EINVAL;
+
+	group = vfio_group_get_from_dev(dev);
+	if (!group)
+		return -ENODEV;
+
+	ret = vfio_group_add_container_user(group);
+	if (ret)
+		goto out;
+
+	container = group->container;
+	driver = container->iommu_driver;
+	if (likely(driver && driver->ops->dynamic_dma_map))
+		ret = driver->ops->dynamic_dma_map(container->iommu_data,
+						   fault, dev);
+	else
+		ret = -ENOTTY;
+
+	vfio_group_try_dissolve_container(group);
+
+out:
+	vfio_group_put(group);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_iommu_dev_fault_handler);
+
 /**
  * Module/class support
  */
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index f1d4de5ab094..ac6f00c97897 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -145,6 +145,8 @@ struct vfio_regions {
 #define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
 
 #define IOMMU_MAPPED_BITMAP_BYTES(n) DIRTY_BITMAP_BYTES(n)
+#define IOMMU_MAPPED_BITMAP_GET(dma, i)	((dma->iommu_mapped_bitmap[i / BITS_PER_LONG]	\
+					 >> (i % BITS_PER_LONG)) & 0x1)
 
 static int put_pfn(unsigned long pfn, int prot);
 
@@ -2992,6 +2994,61 @@ static int vfio_iommu_type1_dma_rw(void *iommu_data, dma_addr_t user_iova,
 	return ret;
 }
 
+static int vfio_iommu_type1_dynamic_dma_map(void *iommu_data,
+					    struct iommu_fault *fault,
+					    struct device *dev)
+{
+	struct vfio_iommu *iommu = iommu_data;
+	dma_addr_t iova = ALIGN_DOWN(fault->prm.addr, PAGE_SIZE);
+	struct vfio_dma *dma;
+	int access_flags = 0;
+	unsigned long bit_offset, vaddr, pfn;
+	enum iommu_page_response_code status = IOMMU_PAGE_RESP_INVALID;
+	struct iommu_page_response resp = {0};
+
+	if (fault->type != IOMMU_FAULT_PAGE_REQ)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&iommu->lock);
+
+	dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
+	if (!dma)
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
+	if (IOMMU_MAPPED_BITMAP_GET(dma, bit_offset))
+		goto out_success;
+
+	vaddr = iova - dma->iova + dma->vaddr;
+	if (vfio_pin_page_external(dma, vaddr, &pfn, true))
+		goto out_invalid;
+
+	if (vfio_iommu_map(iommu, iova, pfn, 1, dma->prot)) {
+		vfio_unpin_page_external(dma, iova, true);
+		goto out_invalid;
+	}
+
+	bitmap_set(dma->iommu_mapped_bitmap, bit_offset, 1);
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
 static struct iommu_domain *
 vfio_iommu_type1_group_iommu_domain(void *iommu_data,
 				    struct iommu_group *iommu_group)
@@ -3028,6 +3085,7 @@ static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
 	.register_notifier	= vfio_iommu_type1_register_notifier,
 	.unregister_notifier	= vfio_iommu_type1_unregister_notifier,
 	.dma_rw			= vfio_iommu_type1_dma_rw,
+	.dynamic_dma_map	= vfio_iommu_type1_dynamic_dma_map,
 	.group_iommu_domain	= vfio_iommu_type1_group_iommu_domain,
 };
 
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index f45940b38a02..6d535f029f21 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -90,6 +90,9 @@ struct vfio_iommu_driver_ops {
 					       struct notifier_block *nb);
 	int		(*dma_rw)(void *iommu_data, dma_addr_t user_iova,
 				  void *data, size_t count, bool write);
+	int		(*dynamic_dma_map)(void *iommu_data,
+					   struct iommu_fault *fault,
+					   struct device *dev);
 	struct iommu_domain *(*group_iommu_domain)(void *iommu_data,
 						   struct iommu_group *group);
 };
@@ -153,6 +156,8 @@ extern int vfio_unregister_notifier(struct device *dev,
 struct kvm;
 extern void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm);
 
+extern int vfio_iommu_dev_fault_handler(struct iommu_fault *fault, void *data);
+
 /*
  * Sub-module helpers
  */
-- 
2.19.1

