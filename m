Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48AE312F299
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2020 02:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgACBLD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jan 2020 20:11:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:59866 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgACBLD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jan 2020 20:11:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jan 2020 17:11:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,388,1571727600"; 
   d="scan'208";a="221511337"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.9])
  by orsmga006.jf.intel.com with ESMTP; 02 Jan 2020 17:11:01 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com
Cc:     zhenyuw@linux.intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-gvt@eclists.intel.com,
        pbonzini@redhat.com, kevin.tian@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 1/2] vfio: introduce vfio_iova_rw to read/write a range of IOVAs
Date:   Thu,  2 Jan 2020 20:02:17 -0500
Message-Id: <20200103010217.4201-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200103010055.4140-1-yan.y.zhao@intel.com>
References: <20200103010055.4140-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio_iova_rw will read/write a range of userspace memory (starting form
device iova to iova + len -1) into a kenrel buffer without pinning the
userspace memory.

TODO: vfio needs to mark the iova dirty if vfio_iova_rw(write) is
called.

Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/vfio.c             | 45 ++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c | 81 +++++++++++++++++++++++++++++++++
 include/linux/vfio.h            |  5 ++
 3 files changed, 131 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index c8482624ca34..36e91e647ed5 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1961,6 +1961,51 @@ int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn, int npage)
 }
 EXPORT_SYMBOL(vfio_unpin_pages);
 
+/*
+ * Read/Write a range of userspace IOVAs for a device into/from a kernel
+ * buffer without pinning the userspace memory
+ * @dev [in]  : device
+ * @iova [in] : base IOVA of a userspace buffer
+ * @data [in] : pointer to kernel buffer
+ * @len [in]  : kernel buffer length
+ * @write     : indicate read or write
+ * Return error on failure or 0 on success.
+ */
+int vfio_iova_rw(struct device *dev, unsigned long iova, void *data,
+		   unsigned long len, bool write)
+{
+	struct vfio_container *container;
+	struct vfio_group *group;
+	struct vfio_iommu_driver *driver;
+	int ret = 0;
+
+	if (!dev || !data || len <= 0)
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
+
+	if (likely(driver && driver->ops->iova_rw))
+		ret = driver->ops->iova_rw(container->iommu_data,
+					   iova, data, len, write);
+	else
+		ret = -ENOTTY;
+
+	vfio_group_try_dissolve_container(group);
+out:
+	vfio_group_put(group);
+	return ret;
+}
+EXPORT_SYMBOL(vfio_iova_rw);
+
 static int vfio_register_iommu_notifier(struct vfio_group *group,
 					unsigned long *events,
 					struct notifier_block *nb)
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 2ada8e6cdb88..aee191077235 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -27,6 +27,7 @@
 #include <linux/iommu.h>
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/mmu_context.h>
 #include <linux/rbtree.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/mm.h>
@@ -2326,6 +2327,85 @@ static int vfio_iommu_type1_unregister_notifier(void *iommu_data,
 	return blocking_notifier_chain_unregister(&iommu->notifier, nb);
 }
 
+static int next_segment(unsigned long len, int offset)
+{
+	if (len > PAGE_SIZE - offset)
+		return PAGE_SIZE - offset;
+	else
+		return len;
+}
+
+static int vfio_iommu_type1_rw_iova_seg(struct vfio_iommu *iommu,
+					  unsigned long iova, void *data,
+					  unsigned long seg_len,
+					  unsigned long offset,
+					  bool write)
+{
+	struct mm_struct *mm;
+	unsigned long vaddr;
+	struct vfio_dma *dma;
+	bool kthread = current->mm == NULL;
+	int ret = 0;
+
+	dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
+	if (!dma)
+		return -EINVAL;
+
+	mm = get_task_mm(dma->task);
+
+	if (!mm)
+		return -ENODEV;
+
+	if (kthread)
+		use_mm(mm);
+	else if (current->mm != mm) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	vaddr = dma->vaddr + iova - dma->iova + offset;
+
+	ret = write ? __copy_to_user((void __user *)vaddr,
+			data, seg_len) :
+		__copy_from_user(data, (void __user *)vaddr,
+				seg_len);
+	if (ret)
+		ret = -EFAULT;
+
+	if (kthread)
+		unuse_mm(mm);
+out:
+	mmput(mm);
+	return ret;
+}
+
+static int vfio_iommu_type1_iova_rw(void *iommu_data, unsigned long iova,
+				    void *data, unsigned long len, bool write)
+{
+	struct vfio_iommu *iommu = iommu_data;
+	int offset = iova & ~PAGE_MASK;
+	int seg_len;
+	int ret = 0;
+
+	iova = iova & PAGE_MASK;
+
+	mutex_lock(&iommu->lock);
+	while ((seg_len = next_segment(len, offset)) > 0) {
+		ret = vfio_iommu_type1_rw_iova_seg(iommu, iova, data,
+						   seg_len, offset, write);
+		if (ret)
+			break;
+
+		offset = 0;
+		len -= seg_len;
+		data += seg_len;
+		iova += PAGE_SIZE;
+	}
+
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
 	.name			= "vfio-iommu-type1",
 	.owner			= THIS_MODULE,
@@ -2338,6 +2418,7 @@ static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
 	.unpin_pages		= vfio_iommu_type1_unpin_pages,
 	.register_notifier	= vfio_iommu_type1_register_notifier,
 	.unregister_notifier	= vfio_iommu_type1_unregister_notifier,
+	.iova_rw		= vfio_iommu_type1_iova_rw,
 };
 
 static int __init vfio_iommu_type1_init(void)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e42a711a2800..7bf18a31bbcf 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -82,6 +82,8 @@ struct vfio_iommu_driver_ops {
 					     struct notifier_block *nb);
 	int		(*unregister_notifier)(void *iommu_data,
 					       struct notifier_block *nb);
+	int		(*iova_rw)(void *iommu_data, unsigned long iova,
+				   void *data, unsigned long len, bool write);
 };
 
 extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
@@ -107,6 +109,9 @@ extern int vfio_pin_pages(struct device *dev, unsigned long *user_pfn,
 extern int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn,
 			    int npage);
 
+extern int vfio_iova_rw(struct device *dev, unsigned long iova, void *data,
+			unsigned long len, bool write);
+
 /* each type has independent events */
 enum vfio_notify_type {
 	VFIO_IOMMU_NOTIFY = 0,
-- 
2.17.1

