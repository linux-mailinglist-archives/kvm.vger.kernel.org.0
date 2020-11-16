Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02B92B4211
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 12:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbgKPLCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 06:02:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23559 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729600AbgKPLCW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 06:02:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605524539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uU/eOILpC8fI5SMvD9y2bzuR1RT81WoFsvk84JGwHLY=;
        b=HCSI797DiJ2fBUEo5FZXSohdg9BMDGHabKnlRxG+aevwEbGPRFWX1iEWv68pImDkjjqbRH
        wVYn8cWk2Y21Y7sHOOuceUQNWdSoxibd09MbDLcoR13g4MujHZ9B1HSm8AeQoExLVz4COk
        yqiT4sczpwtGOs0eK1YP+bGoK2Q8i8A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-Gqq4QMFTMA6CXvxshjTENA-1; Mon, 16 Nov 2020 06:02:16 -0500
X-MC-Unique: Gqq4QMFTMA6CXvxshjTENA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDBDC8015FA;
        Mon, 16 Nov 2020 11:02:13 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-230.ams2.redhat.com [10.36.113.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 41BC35C5AF;
        Mon, 16 Nov 2020 11:02:03 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com,
        alex.williamson@redhat.com
Cc:     jean-philippe@linaro.org, zhangfei.gao@linaro.org,
        zhangfei.gao@gmail.com, vivek.gautam@arm.com,
        shameerali.kolothum.thodi@huawei.com,
        jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com, tn@semihalf.com,
        nicoleotsuka@gmail.com, yuzenghui@huawei.com
Subject: [PATCH v11 12/13] vfio/pci: Register a DMA fault response region
Date:   Mon, 16 Nov 2020 12:00:29 +0100
Message-Id: <20201116110030.32335-13-eric.auger@redhat.com>
In-Reply-To: <20201116110030.32335-1-eric.auger@redhat.com>
References: <20201116110030.32335-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for vSVA, let's register a DMA fault response region,
where the userspace will push the page responses and increment the
head of the buffer. The kernel will pop those responses and inject them
on iommu side.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c         | 114 +++++++++++++++++++++++++---
 drivers/vfio/pci/vfio_pci_private.h |   5 ++
 drivers/vfio/pci/vfio_pci_rdwr.c    |  39 ++++++++++
 include/uapi/linux/vfio.h           |  32 ++++++++
 4 files changed, 181 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 65a83fd0e8c0..e9a904ce3f0d 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -318,9 +318,20 @@ static void vfio_pci_dma_fault_release(struct vfio_pci_device *vdev,
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
@@ -333,14 +344,14 @@ static int vfio_pci_dma_fault_mmap(struct vfio_pci_device *vdev,
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
 
@@ -349,13 +360,29 @@ static int vfio_pci_dma_fault_mmap(struct vfio_pci_device *vdev,
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
@@ -383,6 +410,14 @@ static int vfio_pci_dma_fault_add_capability(struct vfio_pci_device *vdev,
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
 static const struct vfio_pci_regops vfio_pci_dma_fault_regops = {
 	.rw		= vfio_pci_dma_fault_rw,
 	.release	= vfio_pci_dma_fault_release,
@@ -390,6 +425,13 @@ static const struct vfio_pci_regops vfio_pci_dma_fault_regops = {
 	.add_capability = vfio_pci_dma_fault_add_capability,
 };
 
+static const struct vfio_pci_regops vfio_pci_dma_fault_response_regops = {
+	.rw		= vfio_pci_dma_fault_response_rw,
+	.release	= vfio_pci_dma_fault_response_release,
+	.mmap		= vfio_pci_dma_fault_response_mmap,
+	.add_capability = vfio_pci_dma_fault_add_capability,
+};
+
 int vfio_pci_iommu_dev_fault_handler(struct iommu_fault *fault, void *data)
 {
 	struct vfio_pci_device *vdev = (struct vfio_pci_device *)data;
@@ -500,6 +542,55 @@ static int vfio_pci_dma_fault_init(struct vfio_pci_device *vdev)
 	return ret;
 }
 
+#define DMA_FAULT_RESPONSE_RING_LENGTH 512
+
+static int vfio_pci_dma_fault_response_init(struct vfio_pci_device *vdev)
+{
+	struct vfio_region_dma_fault_response *header;
+	struct iommu_domain *domain;
+	size_t size;
+	bool nested;
+	int ret;
+
+	domain = iommu_get_domain_for_dev(&vdev->pdev->dev);
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
@@ -602,6 +693,10 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 	if (ret)
 		goto disable_exit;
 
+	ret = vfio_pci_dma_fault_response_init(vdev);
+	if (ret)
+		goto disable_exit;
+
 	vfio_pci_probe_mmaps(vdev);
 
 	return 0;
@@ -2227,6 +2322,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 	mutex_init(&vdev->vma_lock);
 	INIT_LIST_HEAD(&vdev->vma_list);
+	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 	init_rwsem(&vdev->memory_lock);
 
 	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index e180b5435c8f..035634521cd0 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -144,7 +144,9 @@ struct vfio_pci_device {
 	struct eventfd_ctx	*err_trigger;
 	struct eventfd_ctx	*req_trigger;
 	u8			*fault_pages;
+	u8			*fault_response_pages;
 	struct mutex		fault_queue_lock;
+	struct mutex		fault_response_queue_lock;
 	struct list_head	dummy_resources_list;
 	struct mutex		ioeventfds_lock;
 	struct list_head	ioeventfds_list;
@@ -189,6 +191,9 @@ extern long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
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
index 1e5c82f9d14d..5d106db7a4c5 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -345,6 +345,7 @@ struct vfio_region_info_cap_type {
 
 #define VFIO_REGION_TYPE_NESTED			(2)
 #define VFIO_REGION_SUBTYPE_NESTED_DMA_FAULT	(1)
+#define VFIO_REGION_SUBTYPE_NESTED_DMA_FAULT_RESPONSE	(2)
 
 /**
  * struct vfio_region_gfx_edid - EDID region layout.
@@ -1022,6 +1023,17 @@ struct vfio_region_info_cap_fault {
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
@@ -1042,6 +1054,26 @@ struct vfio_region_dma_fault {
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
2.21.3

