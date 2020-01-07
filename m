Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23BC113293C
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 15:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbgAGOrD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 09:47:03 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8235 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728118AbgAGOrC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 09:47:02 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 76B47369D94C3378F945;
        Tue,  7 Jan 2020 22:46:59 +0800 (CST)
Received: from localhost (10.177.98.84) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Tue, 7 Jan 2020
 22:46:52 +0800
From:   weiqi <weiqi4@huawei.com>
To:     <alexander.h.duyck@linux.intel.com>, <alex.williamson@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <x86@kernel.org>, wei qi <weiqi4@huawei.com>
Subject: [PATCH 1/2] vfio: add mmap/munmap API for page hinting
Date:   Tue, 7 Jan 2020 22:46:38 +0800
Message-ID: <1578408399-20092-2-git-send-email-weiqi4@huawei.com>
X-Mailer: git-send-email 1.8.4.msysgit.0
In-Reply-To: <1578408399-20092-1-git-send-email-weiqi4@huawei.com>
References: <1578408399-20092-1-git-send-email-weiqi4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.98.84]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: wei qi <weiqi4@huawei.com>

add mmap/munmap API for page hinting.

Signed-off-by: wei qi <weiqi4@huawei.com>
---
 drivers/vfio/vfio.c             | 109 ++++++++++++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c | 157 +++++++++++++++++++++++++++++++++++++++-
 include/linux/vfio.h            |  17 ++++-
 3 files changed, 280 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index c848262..c7e9103 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1866,6 +1866,115 @@ int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr, int num_irqs,
 }
 EXPORT_SYMBOL(vfio_set_irqs_validate_and_prepare);
 
+int vfio_mmap_pages(struct device *dev, unsigned long user_pfn,
+			unsigned long page_size, int prot,
+			unsigned long pfn)
+{
+	struct vfio_container *container;
+	struct vfio_group *group;
+	struct vfio_iommu_driver *driver;
+	int ret;
+
+	if (!dev || !user_pfn || !page_size)
+		return -EINVAL;
+
+	group = vfio_group_get_from_dev(dev);
+	if (!group)
+		return -ENODEV;
+
+	ret = vfio_group_add_container_user(group);
+	if (ret)
+		goto err_pin_pages;
+
+	container = group->container;
+	driver = container->iommu_driver;
+	if (likely(driver && driver->ops->mmap_pages))
+		ret = driver->ops->mmap_pages(container->iommu_data, user_pfn,
+					page_size, prot, pfn);
+	else
+		ret = -ENOTTY;
+
+	vfio_group_try_dissolve_container(group);
+
+err_pin_pages:
+	vfio_group_put(group);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_mmap_pages);
+
+int vfio_munmap_pages(struct device *dev, unsigned long user_pfn,
+			unsigned long page_size)
+{
+	struct vfio_container *container;
+	struct vfio_group *group;
+	struct vfio_iommu_driver *driver;
+	int ret;
+
+	if (!dev || !user_pfn || !page_size)
+		return -EINVAL;
+
+	group = vfio_group_get_from_dev(dev);
+	if (!group)
+		return -ENODEV;
+
+	ret = vfio_group_add_container_user(group);
+	if (ret)
+		goto err_pin_pages;
+
+	container = group->container;
+	driver = container->iommu_driver;
+	if (likely(driver && driver->ops->munmap_pages))
+		ret = driver->ops->munmap_pages(container->iommu_data, user_pfn,
+						page_size);
+	else
+		ret = -ENOTTY;
+
+	vfio_group_try_dissolve_container(group);
+
+err_pin_pages:
+	vfio_group_put(group);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_munmap_pages);
+
+int vfio_dma_find(struct device *dev, unsigned long user_pfn, int npage,
+		unsigned long *phys_pfn)
+{
+	struct vfio_container *container;
+	struct vfio_group *group;
+	struct vfio_iommu_driver *driver;
+	int ret;
+
+	if (!dev || !user_pfn || !npage || !phys_pfn)
+		return -EINVAL;
+
+	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
+		return -E2BIG;
+
+	group = vfio_group_get_from_dev(dev);
+	if (!group)
+		return -ENODEV;
+
+	ret = vfio_group_add_container_user(group);
+	if (ret)
+		goto err_pin_pages;
+
+	container = group->container;
+	driver = container->iommu_driver;
+	if (driver && driver->ops->dma_find)
+		ret = driver->ops->dma_find(container->iommu_data, user_pfn,
+					npage, phys_pfn);
+	else
+		ret = -ENOTTY;
+
+	vfio_group_try_dissolve_container(group);
+
+err_pin_pages:
+	vfio_group_put(group);
+	return ret;
+}
+EXPORT_SYMBOL(vfio_dma_find);
+
 /*
  * Pin a set of guest PFNs and return their associated host PFNs for local
  * domain only.
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 2ada8e6..df115dc 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -414,7 +414,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 		goto out;
 
 	/* Lock all the consecutive pages from pfn_base */
-	for (vaddr += PAGE_SIZE, iova += PAGE_SIZE; pinned < npage;
+	for (vaddr += PAGE_SIZE, iova += PAGE_SIZE; (pinned < npage && pinned < 512);
 	     pinned++, vaddr += PAGE_SIZE, iova += PAGE_SIZE) {
 		ret = vaddr_get_pfn(current->mm, vaddr, dma->prot, &pfn);
 		if (ret)
@@ -768,7 +768,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 		phys_addr_t phys, next;
 
 		phys = iommu_iova_to_phys(domain->domain, iova);
-		if (WARN_ON(!phys)) {
+		if (!phys) {
 			iova += PAGE_SIZE;
 			continue;
 		}
@@ -1154,6 +1154,156 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static int vfio_iommu_type1_munmap_pages(void *iommu_data,
+					unsigned long user_pfn,
+					unsigned long page_size)
+{
+	struct vfio_iommu *iommu = iommu_data;
+	struct vfio_domain *domain;
+	struct vfio_dma *dma;
+	dma_addr_t iova = user_pfn  << PAGE_SHIFT;
+	int ret = 0;
+	phys_addr_t phys;
+	size_t unmapped;
+	long unlocked = 0;
+
+	if (!iommu || !user_pfn || !page_size)
+		return -EINVAL;
+
+	/* Supported for v2 version only */
+	if (!iommu->v2)
+		return -EACCES;
+
+	mutex_lock(&iommu->lock);
+	dma = vfio_find_dma(iommu, iova, page_size);
+	if (!dma) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	domain = list_first_entry(&iommu->domain_list,
+			struct vfio_domain, next);
+	phys = iommu_iova_to_phys(domain->domain, iova);
+	if (!phys) {
+		goto out_unlock;
+	} else {
+		unmapped = iommu_unmap(domain->domain, iova, page_size);
+		unlocked = vfio_unpin_pages_remote(dma, iova,
+					phys >> PAGE_SHIFT,
+					unmapped >> PAGE_SHIFT, true);
+	}
+
+out_unlock:
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
+static int vfio_iommu_type1_mmap_pages(void *iommu_data,
+				unsigned long user_pfn,
+				unsigned long page_size, int prot,
+				unsigned long pfn)
+{
+	struct vfio_iommu *iommu = iommu_data;
+	struct vfio_domain *domain;
+	struct vfio_dma *dma;
+	dma_addr_t iova = user_pfn  << PAGE_SHIFT;
+	int ret = 0;
+	size_t unmapped;
+	phys_addr_t phys;
+	long unlocked = 0;
+
+	if (!iommu || !user_pfn || !page_size || !pfn)
+		return -EINVAL;
+
+	/* Supported for v2 version only */
+	if (!iommu->v2)
+		return -EACCES;
+
+	mutex_lock(&iommu->lock);
+
+	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
+		ret = -EACCES;
+		goto out_unlock;
+	}
+
+	dma = vfio_find_dma(iommu, iova, page_size);
+	if (!dma) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	domain = list_first_entry(&iommu->domain_list,
+		struct vfio_domain, next);
+
+	phys = iommu_iova_to_phys(domain->domain, iova);
+	if (phys) {
+		unmapped = iommu_unmap(domain->domain, iova, page_size);
+		unlocked = vfio_unpin_pages_remote(dma, iova,
+					phys >> PAGE_SHIFT,
+					unmapped >> PAGE_SHIFT, false);
+	}
+
+	ret = vfio_iommu_map(iommu, iova, pfn, page_size >> PAGE_SHIFT, prot);
+	if (ret) {
+		pr_warn("%s: gfn: %lx, pfn: %lx, npages：%lu\n", __func__,
+			user_pfn, pfn, page_size >> PAGE_SHIFT);
+	}
+
+out_unlock:
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
+u64 vfio_iommu_iova_to_phys(struct vfio_iommu *iommu, dma_addr_t iova)
+{
+	struct vfio_domain *d;
+	u64 phys;
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		phys = iommu_iova_to_phys(d->domain, iova);
+		if (phys)
+			return phys;
+	}
+	return 0;
+}
+
+static int vfio_iommu_type1_dma_find(void *iommu_data,
+					unsigned long user_pfn,
+					int npage, unsigned long *phys_pfn)
+{
+	struct vfio_iommu *iommu = iommu_data;
+	int i = 0;
+	struct vfio_dma *dma;
+	u64 phys;
+	dma_addr_t iova;
+
+	if (!iommu || !user_pfn)
+		return -EINVAL;
+
+	/* Supported for v2 version only */
+	if (!iommu->v2)
+		return -EACCES;
+
+	 mutex_lock(&iommu->lock);
+
+	iova = user_pfn << PAGE_SHIFT;
+	dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
+	if (!dma)
+		goto unpin_exit;
+
+	if (((user_pfn + npage) << PAGE_SHIFT) <= (dma->iova + dma->size))
+		i = npage;
+	else
+		goto unpin_exit;
+
+	phys = vfio_iommu_iova_to_phys(iommu, iova);
+	*phys_pfn = phys >> PAGE_SHIFT;
+
+unpin_exit:
+	mutex_unlock(&iommu->lock);
+	return i;
+}
+
 static int vfio_bus_type(struct device *dev, void *data)
 {
 	struct bus_type **bus = data;
@@ -2336,6 +2486,9 @@ static int vfio_iommu_type1_unregister_notifier(void *iommu_data,
 	.detach_group		= vfio_iommu_type1_detach_group,
 	.pin_pages		= vfio_iommu_type1_pin_pages,
 	.unpin_pages		= vfio_iommu_type1_unpin_pages,
+	.mmap_pages             = vfio_iommu_type1_mmap_pages,
+	.munmap_pages           = vfio_iommu_type1_munmap_pages,
+	.dma_find		= vfio_iommu_type1_dma_find,
 	.register_notifier	= vfio_iommu_type1_register_notifier,
 	.unregister_notifier	= vfio_iommu_type1_unregister_notifier,
 };
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e42a711..d7df495 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -77,6 +77,15 @@ struct vfio_iommu_driver_ops {
 				     unsigned long *phys_pfn);
 	int		(*unpin_pages)(void *iommu_data,
 				       unsigned long *user_pfn, int npage);
+	int		(*mmap_pages)(void *iommu_data,
+					unsigned long user_pfn,
+					unsigned long page_size,
+					int prot, unsigned long pfn);
+	int		(*munmap_pages)(void *iommu_data,
+					unsigned long user_pfn,
+					unsigned long page_size);
+	int		(*dma_find)(void *iommu_data, unsigned long user_pfn,
+					int npage, unsigned long *phys_pfn);
 	int		(*register_notifier)(void *iommu_data,
 					     unsigned long *events,
 					     struct notifier_block *nb);
@@ -106,7 +115,13 @@ extern int vfio_pin_pages(struct device *dev, unsigned long *user_pfn,
 			  int npage, int prot, unsigned long *phys_pfn);
 extern int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn,
 			    int npage);
-
+extern int vfio_dma_find(struct device *dev, unsigned long user_pfn, int npage,
+			unsigned long *phys_pfn);
+extern int vfio_mmap_pages(struct device *dev, unsigned long user_pfn,
+			unsigned long page_size, int prot,
+			unsigned long pfn);
+extern int vfio_munmap_pages(struct device *dev, unsigned long user_pfn,
+			unsigned long page_size);
 /* each type has independent events */
 enum vfio_notify_type {
 	VFIO_IOMMU_NOTIFY = 0,
-- 
1.8.3.1


