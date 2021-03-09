Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FAE331F2D
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 07:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbhCIGW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 01:22:59 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:13582 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhCIGWa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 01:22:30 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DvlSn6hNnz17Hqm;
        Tue,  9 Mar 2021 14:20:41 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.184.135) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Tue, 9 Mar 2021 14:22:21 +0800
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
Subject: [RFC PATCH v2 4/6] vfio: VFIO_IOMMU_ENABLE_IOPF
Date:   Tue, 9 Mar 2021 14:22:05 +0800
Message-ID: <20210309062207.505-5-lushenming@huawei.com>
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

Since enabling IOPF for devices may lead to a slow ramp up of
performance, we add an VFIO_IOMMU_ENABLE_IOPF ioctl to make it
configurable. And the IOPF enabling of a VFIO device includes
setting IOMMU_DEV_FEAT_IOPF and registering the VFIO page fault
handler. Note that VFIO_IOMMU_DISABLE_IOPF is not supported
since there may be inflight page faults when disabling.

Signed-off-by: Shenming Lu <lushenming@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 139 +++++++++++++++++++++++++++++++-
 include/uapi/linux/vfio.h       |   6 ++
 2 files changed, 142 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 167d52c1468b..3997473be4a7 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -71,6 +71,7 @@ struct vfio_iommu {
 	struct rb_root		dma_list;
 	struct blocking_notifier_head notifier;
 	struct mmu_notifier	mn;
+	struct mm_struct	*mm;
 	unsigned int		dma_avail;
 	unsigned int		vaddr_invalid_count;
 	uint64_t		pgsize_bitmap;
@@ -81,6 +82,7 @@ struct vfio_iommu {
 	bool			dirty_page_tracking;
 	bool			pinned_page_dirty_scope;
 	bool			container_open;
+	bool			iopf_enabled;
 };
 
 struct vfio_domain {
@@ -2278,6 +2280,62 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
 	list_splice_tail(iova_copy, iova);
 }
 
+static int dev_disable_iopf(struct device *dev, void *data)
+{
+	int *enabled_dev_cnt = data;
+
+	if (enabled_dev_cnt && *enabled_dev_cnt <= 0)
+		return -1;
+
+	iommu_unregister_device_fault_handler(dev);
+	iommu_dev_disable_feature(dev, IOMMU_DEV_FEAT_IOPF);
+
+	if (enabled_dev_cnt)
+		(*enabled_dev_cnt)--;
+
+	return 0;
+}
+
+static int dev_enable_iopf(struct device *dev, void *data)
+{
+	int *enabled_dev_cnt = data;
+	struct iommu_domain *domain;
+	int nested;
+	u32 flags;
+	int ret;
+
+	ret = iommu_dev_enable_feature(dev, IOMMU_DEV_FEAT_IOPF);
+	if (ret)
+		return ret;
+
+	domain = iommu_get_domain_for_dev(dev);
+	if (!domain) {
+		ret = -ENODEV;
+		goto out_disable;
+	}
+
+	ret = iommu_domain_get_attr(domain, DOMAIN_ATTR_NESTING, &nested);
+	if (ret)
+		goto out_disable;
+
+	if (nested)
+		flags = IOPF_REPORT_NESTED | IOPF_REPORT_NESTED_L2_CONCERNED;
+	else
+		flags = IOPF_REPORT_FLAT;
+
+	ret = iommu_register_device_fault_handler(dev,
+				vfio_iommu_dev_fault_handler, flags, dev);
+	if (ret)
+		goto out_disable;
+
+	(*enabled_dev_cnt)++;
+	return 0;
+
+out_disable:
+	iommu_dev_disable_feature(dev, IOMMU_DEV_FEAT_IOPF);
+	return ret;
+}
+
 static int vfio_iommu_type1_attach_group(void *iommu_data,
 					 struct iommu_group *iommu_group)
 {
@@ -2291,6 +2349,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	struct iommu_domain_geometry geo;
 	LIST_HEAD(iova_copy);
 	LIST_HEAD(group_resv_regions);
+	int iopf_enabled_dev_cnt = 0;
 
 	mutex_lock(&iommu->lock);
 
@@ -2368,6 +2427,13 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	if (ret)
 		goto out_domain;
 
+	if (iommu->iopf_enabled) {
+		ret = iommu_group_for_each_dev(iommu_group, &iopf_enabled_dev_cnt,
+					       dev_enable_iopf);
+		if (ret)
+			goto out_detach;
+	}
+
 	/* Get aperture info */
 	iommu_domain_get_attr(domain->domain, DOMAIN_ATTR_GEOMETRY, &geo);
 
@@ -2449,9 +2515,11 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	vfio_test_domain_fgsp(domain);
 
 	/* replay mappings on new domains */
-	ret = vfio_iommu_replay(iommu, domain);
-	if (ret)
-		goto out_detach;
+	if (!iommu->iopf_enabled) {
+		ret = vfio_iommu_replay(iommu, domain);
+		if (ret)
+			goto out_detach;
+	}
 
 	if (resv_msi) {
 		ret = iommu_get_msi_cookie(domain->domain, resv_msi_base);
@@ -2482,6 +2550,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	iommu_domain_free(domain->domain);
 	vfio_iommu_iova_free(&iova_copy);
 	vfio_iommu_resv_free(&group_resv_regions);
+	iommu_group_for_each_dev(iommu_group, &iopf_enabled_dev_cnt,
+				 dev_disable_iopf);
 out_free:
 	kfree(domain);
 	kfree(group);
@@ -2643,6 +2713,10 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 		if (!group)
 			continue;
 
+		if (iommu->iopf_enabled)
+			iommu_group_for_each_dev(iommu_group, NULL,
+						 dev_disable_iopf);
+
 		vfio_iommu_detach_group(domain, group);
 		update_dirty_scope = !group->pinned_page_dirty_scope;
 		list_del(&group->next);
@@ -2761,6 +2835,11 @@ static void vfio_iommu_type1_release(void *iommu_data)
 
 	vfio_iommu_iova_free(&iommu->iova_list);
 
+	if (iommu->iopf_enabled) {
+		mmu_notifier_unregister(&iommu->mn, iommu->mm);
+		mmdrop(iommu->mm);
+	}
+
 	kfree(iommu);
 }
 
@@ -3164,6 +3243,58 @@ static const struct mmu_notifier_ops vfio_iommu_type1_mn_ops = {
 	.invalidate_range	= mn_invalidate_range,
 };
 
+static int vfio_iommu_type1_enable_iopf(struct vfio_iommu *iommu)
+{
+	struct vfio_domain *d;
+	struct vfio_group *g;
+	int enabled_dev_cnt = 0;
+	int ret;
+
+	if (!current->mm)
+		return -ENODEV;
+
+	mutex_lock(&iommu->lock);
+
+	mmgrab(current->mm);
+	iommu->mm = current->mm;
+	iommu->mn.ops = &vfio_iommu_type1_mn_ops;
+	ret = mmu_notifier_register(&iommu->mn, current->mm);
+	if (ret)
+		goto out_drop;
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		list_for_each_entry(g, &d->group_list, next) {
+			ret = iommu_group_for_each_dev(g->iommu_group,
+					&enabled_dev_cnt, dev_enable_iopf);
+			if (ret)
+				goto out_unwind;
+		}
+	}
+
+	iommu->iopf_enabled = true;
+	goto out_unlock;
+
+out_unwind:
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		list_for_each_entry(g, &d->group_list, next) {
+			if (iommu_group_for_each_dev(g->iommu_group,
+					&enabled_dev_cnt, dev_disable_iopf))
+				goto out_unregister;
+		}
+	}
+
+out_unregister:
+	mmu_notifier_unregister(&iommu->mn, current->mm);
+
+out_drop:
+	iommu->mm = NULL;
+	mmdrop(current->mm);
+
+out_unlock:
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -3180,6 +3311,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		return vfio_iommu_type1_unmap_dma(iommu, arg);
 	case VFIO_IOMMU_DIRTY_PAGES:
 		return vfio_iommu_type1_dirty_pages(iommu, arg);
+	case VFIO_IOMMU_ENABLE_IOPF:
+		return vfio_iommu_type1_enable_iopf(iommu);
 	default:
 		return -ENOTTY;
 	}
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 8ce36c1d53ca..5497036bebdc 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1208,6 +1208,12 @@ struct vfio_iommu_type1_dirty_bitmap_get {
 
 #define VFIO_IOMMU_DIRTY_PAGES             _IO(VFIO_TYPE, VFIO_BASE + 17)
 
+/*
+ * IOCTL to enable IOPF for the container.
+ * Called right after VFIO_SET_IOMMU.
+ */
+#define VFIO_IOMMU_ENABLE_IOPF             _IO(VFIO_TYPE, VFIO_BASE + 18)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.19.1

