Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7160304A1E
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 21:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730431AbhAZFPE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:15:04 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:11861 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbhAYJ3Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 04:29:24 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DPP6s6QTJz7Zny;
        Mon, 25 Jan 2021 17:03:49 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.186.182) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Mon, 25 Jan 2021 17:04:50 +0800
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
Subject: [RFC PATCH v1 4/4] vfio: Allow to pin and map dynamically
Date:   Mon, 25 Jan 2021 17:04:02 +0800
Message-ID: <20210125090402.1429-5-lushenming@huawei.com>
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

If IOPF enabled for the whole VFIO container, there is no need to
statically pin and map the entire DMA range, we can do it on demand.
And unmap and unpin according to the IOPF mapped bitmap when removing
the DMA mapping.

Signed-off-by: Shenming Lu <lushenming@huawei.com>
---
 drivers/vfio/vfio.c             | 20 +++++++++++
 drivers/vfio/vfio_iommu_type1.c | 61 ++++++++++++++++++++++++++++++++-
 include/linux/vfio.h            |  1 +
 3 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index fd885d99ee0f..466959f4d661 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -2404,6 +2404,26 @@ int vfio_iommu_dev_fault_handler(struct iommu_fault *fault, void *data)
 }
 EXPORT_SYMBOL_GPL(vfio_iommu_dev_fault_handler);
 
+/*
+ * Return 0 if enabled.
+ */
+int vfio_device_iopf_enabled(struct device *dev, void *data)
+{
+	struct vfio_device *device;
+	int ret = 0;
+
+	device = vfio_device_get_from_dev(dev);
+	if (!device)
+		return -ENODEV;
+
+	if (!device->iopf_enabled)
+		ret = 1;
+
+	vfio_device_put(device);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_device_iopf_enabled);
+
 /**
  * Module/class support
  */
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index ac6f00c97897..da84155513e4 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -864,6 +864,43 @@ static size_t unmap_unpin_slow(struct vfio_domain *domain,
 	return unmapped;
 }
 
+static long vfio_clear_iommu_mapped_bitmap(struct vfio_iommu *iommu,
+					   struct vfio_dma *dma,
+					   bool do_accounting)
+{
+	dma_addr_t iova = dma->iova;
+	size_t size = dma->size;
+	uint64_t i, npages = size / PAGE_SIZE;
+	long unlocked = 0;
+
+	for (i = 0; i < npages; i++, iova += PAGE_SIZE) {
+		if (IOMMU_MAPPED_BITMAP_GET(dma, i)) {
+			struct vfio_domain *d;
+			phys_addr_t phys;
+
+			d = list_first_entry(&iommu->domain_list,
+					     struct vfio_domain, next);
+			phys = iommu_iova_to_phys(d->domain, iova);
+			if (WARN_ON(!phys))
+				continue;
+
+			list_for_each_entry(d, &iommu->domain_list, next) {
+				iommu_unmap(d->domain, iova, PAGE_SIZE);
+				cond_resched();
+			}
+			vfio_unpin_pages_remote(dma, iova, phys >> PAGE_SHIFT,
+						1, do_accounting);
+
+			bitmap_clear(dma->iommu_mapped_bitmap, i, 1);
+			unlocked++;
+		}
+	}
+
+	if (do_accounting)
+		return 0;
+	return unlocked;
+}
+
 static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 			     bool do_accounting)
 {
@@ -880,6 +917,10 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
 		return 0;
 
+	if (!dma->iommu_mapped)
+		return vfio_clear_iommu_mapped_bitmap(iommu, dma,
+						      do_accounting);
+
 	/*
 	 * We use the IOMMU to track the physical addresses, otherwise we'd
 	 * need a much more complicated tracking system.  Unfortunately that
@@ -1302,6 +1343,23 @@ static bool vfio_iommu_iova_dma_valid(struct vfio_iommu *iommu,
 	return list_empty(iova);
 }
 
+static bool vfio_iommu_iopf_enabled(struct vfio_iommu *iommu)
+{
+	struct vfio_domain *d;
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		struct vfio_group *g;
+
+		list_for_each_entry(g, &d->group_list, next) {
+			if (iommu_group_for_each_dev(g->iommu_group, NULL,
+						     vfio_device_iopf_enabled))
+				return false;
+		}
+	}
+
+	return true;
+}
+
 static int vfio_dma_do_map(struct vfio_iommu *iommu,
 			   struct vfio_iommu_type1_dma_map *map)
 {
@@ -1408,7 +1466,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	vfio_link_dma(iommu, dma);
 
 	/* Don't pin and map if container doesn't contain IOMMU capable domain*/
-	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
+	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu) ||
+	    vfio_iommu_iopf_enabled(iommu))
 		dma->size = size;
 	else
 		ret = vfio_pin_map_dma(iommu, dma, size);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 6d535f029f21..cea1e9fd4bb4 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -157,6 +157,7 @@ struct kvm;
 extern void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm);
 
 extern int vfio_iommu_dev_fault_handler(struct iommu_fault *fault, void *data);
+extern int vfio_device_iopf_enabled(struct device *dev, void *data);
 
 /*
  * Sub-module helpers
-- 
2.19.1

