Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD93B32330D
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 22:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234396AbhBWVLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 16:11:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29864 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234288AbhBWVJ7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 16:09:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614114509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KqFeqgTbob/s/PUsdHWvzrNlEYoPz5xOjIwBMf8S8ls=;
        b=E5wishwQGa7jrvojsetw0lNlQQVZcBp3r4NP83rX8XyVuNOQaVBw4RzyrfTdGgPcfPHXxM
        D+A6no69QUMFyTu0lZHQbtKhRCeL69zJ0DB6vT5ykl5XoYeLi0Vykz0TKEgki4BiEZ+HLO
        etTSjnSMbjdZ825IvscVKDP5tPsQEfo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-rYkZ8BHcPUucOfjLfZKd3g-1; Tue, 23 Feb 2021 16:08:15 -0500
X-MC-Unique: rYkZ8BHcPUucOfjLfZKd3g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5208619611A9;
        Tue, 23 Feb 2021 21:08:12 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-114-34.ams2.redhat.com [10.36.114.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F06D5D9D0;
        Tue, 23 Feb 2021 21:08:01 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        maz@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
        alex.williamson@redhat.com, tn@semihalf.com, zhukeqian1@huawei.com
Cc:     jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com,
        wangxingang5@huawei.com, jiangkunkun@huawei.com,
        jean-philippe@linaro.org, zhangfei.gao@linaro.org,
        zhangfei.gao@gmail.com, vivek.gautam@arm.com,
        shameerali.kolothum.thodi@huawei.com, yuzenghui@huawei.com,
        nicoleotsuka@gmail.com, lushenming@huawei.com, vsethi@nvidia.com
Subject: [PATCH v12 12/13] vfio/pci: Register a DMA fault response region
Date:   Tue, 23 Feb 2021 22:06:24 +0100
Message-Id: <20210223210625.604517-13-eric.auger@redhat.com>
In-Reply-To: <20210223210625.604517-1-eric.auger@redhat.com>
References: <20210223210625.604517-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for vSVA, let's register a DMA fault response region,
where the userspace will push the page responses and increment the
head of the buffer. The kernel will pop those responses and inject them
on iommu side.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v11 -> v12:
- use DMA_FAULT_RESPONSE cap [Shameer]
- struct vfio_pci_device dma_fault_response_wq field introduced in
  this patch
- return 0 if the domain is NULL
- pass an int pointer to iommu_domain_get_attr
---
 drivers/vfio/pci/vfio_pci.c         | 125 ++++++++++++++++++++++++++--
 drivers/vfio/pci/vfio_pci_private.h |   6 ++
 drivers/vfio/pci/vfio_pci_rdwr.c    |  39 +++++++++
 include/uapi/linux/vfio.h           |  32 +++++++
 4 files changed, 193 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index f3fa6d4318ae..9f1f5008e556 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -316,9 +316,20 @@ static void vfio_pci_dma_fault_release(struct vfio_pci_device *vdev,
 	kfree(vdev->fault_pages);
 }
 
-static int vfio_pci_dma_fault_mmap(struct vfio_pci_device *vdev,
-				   struct vfio_pci_region *region,
-				   struct vm_area_struct *vma)
+static void
+vfio_pci_dma_fault_response_release(struct vfio_pci_device *vdev,
+				    struct vfio_pci_region *region)
+{
+	if (vdev->dma_fault_response_wq)
+		destroy_workqueue(vdev->dma_fault_response_wq);
+	kfree(vdev->fault_response_pages);
+	vdev->fault_response_pages = NULL;
+}
+
+static int __vfio_pci_dma_fault_mmap(struct vfio_pci_device *vdev,
+				     struct vfio_pci_region *region,
+				     struct vm_area_struct *vma,
+				     u8 *pages)
 {
 	u64 phys_len, req_len, pgoff, req_start;
 	unsigned long long addr;
@@ -331,14 +342,14 @@ static int vfio_pci_dma_fault_mmap(struct vfio_pci_device *vdev,
 		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
 	req_start = pgoff << PAGE_SHIFT;
 
-	/* only the second page of the producer fault region is mmappable */
+	/* only the second page of the fault region is mmappable */
 	if (req_start < PAGE_SIZE)
 		return -EINVAL;
 
 	if (req_start + req_len > phys_len)
 		return -EINVAL;
 
-	addr = virt_to_phys(vdev->fault_pages);
+	addr = virt_to_phys(pages);
 	vma->vm_private_data = vdev;
 	vma->vm_pgoff = (addr >> PAGE_SHIFT) + pgoff;
 
@@ -347,13 +358,29 @@ static int vfio_pci_dma_fault_mmap(struct vfio_pci_device *vdev,
 	return ret;
 }
 
-static int vfio_pci_dma_fault_add_capability(struct vfio_pci_device *vdev,
-					     struct vfio_pci_region *region,
-					     struct vfio_info_cap *caps)
+static int vfio_pci_dma_fault_mmap(struct vfio_pci_device *vdev,
+				   struct vfio_pci_region *region,
+				   struct vm_area_struct *vma)
+{
+	return __vfio_pci_dma_fault_mmap(vdev, region, vma, vdev->fault_pages);
+}
+
+static int
+vfio_pci_dma_fault_response_mmap(struct vfio_pci_device *vdev,
+				struct vfio_pci_region *region,
+				struct vm_area_struct *vma)
+{
+	return __vfio_pci_dma_fault_mmap(vdev, region, vma, vdev->fault_response_pages);
+}
+
+static int __vfio_pci_dma_fault_add_capability(struct vfio_pci_device *vdev,
+					       struct vfio_pci_region *region,
+					       struct vfio_info_cap *caps,
+					       u32 cap_id)
 {
 	struct vfio_region_info_cap_sparse_mmap *sparse = NULL;
 	struct vfio_region_info_cap_fault cap = {
-		.header.id = VFIO_REGION_INFO_CAP_DMA_FAULT,
+		.header.id = cap_id,
 		.header.version = 1,
 		.version = 1,
 	};
@@ -381,6 +408,23 @@ static int vfio_pci_dma_fault_add_capability(struct vfio_pci_device *vdev,
 	return ret;
 }
 
+static int vfio_pci_dma_fault_add_capability(struct vfio_pci_device *vdev,
+					     struct vfio_pci_region *region,
+					     struct vfio_info_cap *caps)
+{
+	return __vfio_pci_dma_fault_add_capability(vdev, region, caps,
+						   VFIO_REGION_INFO_CAP_DMA_FAULT);
+}
+
+static int
+vfio_pci_dma_fault_response_add_capability(struct vfio_pci_device *vdev,
+					   struct vfio_pci_region *region,
+					   struct vfio_info_cap *caps)
+{
+	return __vfio_pci_dma_fault_add_capability(vdev, region, caps,
+						   VFIO_REGION_INFO_CAP_DMA_FAULT_RESPONSE);
+}
+
 static const struct vfio_pci_regops vfio_pci_dma_fault_regops = {
 	.rw		= vfio_pci_dma_fault_rw,
 	.release	= vfio_pci_dma_fault_release,
@@ -388,6 +432,13 @@ static const struct vfio_pci_regops vfio_pci_dma_fault_regops = {
 	.add_capability = vfio_pci_dma_fault_add_capability,
 };
 
+static const struct vfio_pci_regops vfio_pci_dma_fault_response_regops = {
+	.rw		= vfio_pci_dma_fault_response_rw,
+	.release	= vfio_pci_dma_fault_response_release,
+	.mmap		= vfio_pci_dma_fault_response_mmap,
+	.add_capability = vfio_pci_dma_fault_response_add_capability,
+};
+
 static int
 vfio_pci_iommu_dev_fault_handler(struct iommu_fault *fault, void *data)
 {
@@ -501,6 +552,57 @@ static int vfio_pci_dma_fault_init(struct vfio_pci_device *vdev)
 	return ret;
 }
 
+#define DMA_FAULT_RESPONSE_RING_LENGTH 512
+
+static int vfio_pci_dma_fault_response_init(struct vfio_pci_device *vdev)
+{
+	struct vfio_region_dma_fault_response *header;
+	struct iommu_domain *domain;
+	int nested, ret;
+	size_t size;
+
+	domain = iommu_get_domain_for_dev(&vdev->pdev->dev);
+	if (!domain)
+		return 0;
+
+	ret = iommu_domain_get_attr(domain, DOMAIN_ATTR_NESTING, &nested);
+	if (ret || !nested)
+		return ret;
+
+	mutex_init(&vdev->fault_response_queue_lock);
+
+	/*
+	 * We provision 1 page for the header and space for
+	 * DMA_FAULT_RING_LENGTH fault records in the ring buffer.
+	 */
+	size = ALIGN(sizeof(struct iommu_page_response) *
+		     DMA_FAULT_RESPONSE_RING_LENGTH, PAGE_SIZE) + PAGE_SIZE;
+
+	vdev->fault_response_pages = kzalloc(size, GFP_KERNEL);
+	if (!vdev->fault_response_pages)
+		return -ENOMEM;
+
+	ret = vfio_pci_register_dev_region(vdev,
+		VFIO_REGION_TYPE_NESTED,
+		VFIO_REGION_SUBTYPE_NESTED_DMA_FAULT_RESPONSE,
+		&vfio_pci_dma_fault_response_regops, size,
+		VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE |
+		VFIO_REGION_INFO_FLAG_MMAP,
+		vdev->fault_response_pages);
+	if (ret)
+		goto out;
+
+	header = (struct vfio_region_dma_fault_response *)vdev->fault_response_pages;
+	header->entry_size = sizeof(struct iommu_page_response);
+	header->nb_entries = DMA_FAULT_RESPONSE_RING_LENGTH;
+	header->offset = PAGE_SIZE;
+
+	return 0;
+out:
+	vdev->fault_response_pages = NULL;
+	return ret;
+}
+
 static int vfio_pci_enable(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
@@ -603,6 +705,10 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 	if (ret)
 		goto disable_exit;
 
+	ret = vfio_pci_dma_fault_response_init(vdev);
+	if (ret)
+		goto disable_exit;
+
 	vfio_pci_probe_mmaps(vdev);
 
 	return 0;
@@ -2230,6 +2336,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 	mutex_init(&vdev->vma_lock);
 	INIT_LIST_HEAD(&vdev->vma_list);
+	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 	init_rwsem(&vdev->memory_lock);
 
 	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index e180b5435c8f..82a883c101c9 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -144,7 +144,10 @@ struct vfio_pci_device {
 	struct eventfd_ctx	*err_trigger;
 	struct eventfd_ctx	*req_trigger;
 	u8			*fault_pages;
+	u8			*fault_response_pages;
+	struct workqueue_struct *dma_fault_response_wq;
 	struct mutex		fault_queue_lock;
+	struct mutex		fault_response_queue_lock;
 	struct list_head	dummy_resources_list;
 	struct mutex		ioeventfds_lock;
 	struct list_head	ioeventfds_list;
@@ -189,6 +192,9 @@ extern long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
 extern size_t vfio_pci_dma_fault_rw(struct vfio_pci_device *vdev,
 				    char __user *buf, size_t count,
 				    loff_t *ppos, bool iswrite);
+extern size_t vfio_pci_dma_fault_response_rw(struct vfio_pci_device *vdev,
+					     char __user *buf, size_t count,
+					     loff_t *ppos, bool iswrite);
 
 extern int vfio_pci_init_perm_bits(void);
 extern void vfio_pci_uninit_perm_bits(void);
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 164120607469..efde0793360b 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -400,6 +400,45 @@ size_t vfio_pci_dma_fault_rw(struct vfio_pci_device *vdev, char __user *buf,
 	return ret;
 }
 
+size_t vfio_pci_dma_fault_response_rw(struct vfio_pci_device *vdev, char __user *buf,
+				      size_t count, loff_t *ppos, bool iswrite)
+{
+	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	void *base = vdev->region[i].data;
+	int ret = -EFAULT;
+
+	if (pos >= vdev->region[i].size)
+		return -EINVAL;
+
+	count = min(count, (size_t)(vdev->region[i].size - pos));
+
+	if (iswrite) {
+		struct vfio_region_dma_fault_response *header =
+			(struct vfio_region_dma_fault_response *)base;
+		uint32_t  new_head;
+
+		if (pos != 0 || count != 4)
+			return -EINVAL;
+
+		if (copy_from_user((void *)&new_head, buf, count))
+			return -EFAULT;
+
+		if (new_head >= header->nb_entries)
+			return -EINVAL;
+
+		mutex_lock(&vdev->fault_response_queue_lock);
+		header->head = new_head;
+		mutex_unlock(&vdev->fault_response_queue_lock);
+	} else {
+		if (copy_to_user(buf, base + pos, count))
+			return -EFAULT;
+	}
+	*ppos += count;
+	ret = count;
+	return ret;
+}
+
 static void vfio_pci_ioeventfd_do_write(struct vfio_pci_ioeventfd *ioeventfd,
 					bool test_mem)
 {
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index f0eea0f9305a..30dfaa473495 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -346,6 +346,7 @@ struct vfio_region_info_cap_type {
 
 /* sub-types for VFIO_REGION_TYPE_NESTED */
 #define VFIO_REGION_SUBTYPE_NESTED_DMA_FAULT	(1)
+#define VFIO_REGION_SUBTYPE_NESTED_DMA_FAULT_RESPONSE	(2)
 
 /**
  * struct vfio_region_gfx_edid - EDID region layout.
@@ -1024,6 +1025,17 @@ struct vfio_region_info_cap_fault {
 	__u32 version;
 };
 
+/*
+ * Capability exposed by the DMA fault response region
+ * @version: ABI version
+ */
+#define VFIO_REGION_INFO_CAP_DMA_FAULT_RESPONSE	7
+
+struct vfio_region_info_cap_fault_response {
+	struct vfio_info_cap_header header;
+	__u32 version;
+};
+
 /*
  * DMA Fault Region Layout
  * @tail: index relative to the start of the ring buffer at which the
@@ -1044,6 +1056,26 @@ struct vfio_region_dma_fault {
 	__u32   head;
 };
 
+/*
+ * DMA Fault Response Region Layout
+ * @head: index relative to the start of the ring buffer at which the
+ *        producer (userspace) insert responses into the buffer
+ * @entry_size: fault ring buffer entry size in bytes
+ * @nb_entries: max capacity of the fault ring buffer
+ * @offset: ring buffer offset relative to the start of the region
+ * @tail: index relative to the start of the ring buffer at which the
+ *        consumer (kernel) finds the next item in the buffer
+ */
+struct vfio_region_dma_fault_response {
+	/* Write-Only */
+	__u32   head;
+	/* Read-Only */
+	__u32   entry_size;
+	__u32	nb_entries;
+	__u32	offset;
+	__u32   tail;
+};
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.26.2

