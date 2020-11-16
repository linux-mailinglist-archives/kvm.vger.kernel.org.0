Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D772B4200
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 12:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbgKPLBX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 06:01:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21258 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728876AbgKPLBX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 06:01:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605524481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gpzRsckk7Rt2fJxcWz45xi3X49OYparWhN62RSrkrnw=;
        b=afdREvODY556jPsDMJbrk5z6XSHwNAYKMcQEw4X1ceXiO4syfHXtx0N3EHardz6LiEFJVB
        Pc7P2h1AdbqboqsPbuidGjPZQ899R8ewDdV4z5Ir+RHGBAAMbr0N/W3zjsKCNvrIZXVQzt
        pT1425CnN0C/+jSopF7tNx50F+UooLA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-OlJP81G1PyONVtlfc5uU-w-1; Mon, 16 Nov 2020 06:01:17 -0500
X-MC-Unique: OlJP81G1PyONVtlfc5uU-w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45B096D252;
        Mon, 16 Nov 2020 11:01:14 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-230.ams2.redhat.com [10.36.113.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDB195C882;
        Mon, 16 Nov 2020 11:01:09 +0000 (UTC)
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
Subject: [PATCH v11 04/13] vfio/pci: Add VFIO_REGION_TYPE_NESTED region type
Date:   Mon, 16 Nov 2020 12:00:21 +0100
Message-Id: <20201116110030.32335-5-eric.auger@redhat.com>
In-Reply-To: <20201116110030.32335-1-eric.auger@redhat.com>
References: <20201116110030.32335-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new specific DMA_FAULT region aiming to exposed nested mode
translation faults. This region only is exposed if the device
is attached to a nested domain.

The region has a ring buffer that contains the actual fault
records plus a header allowing to handle it (tail/head indices,
max capacity, entry size). At the moment the region is dimensionned
for 512 fault records.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v11 -> v12:
- set fault_pages to NULL after free
- check new_tail >= header->nb_entries (Zenghui)

v10 -> v11:
- rename vfio_pci_init_dma_fault_region into
  vfio_pci_dma_fault_init
- free fault_pages in vfio_pci_dma_fault_release
- only register the region if the device is attached
  to a nested domain

v8 -> v9:
- Use a single region instead of a prod/cons region

v4 -> v5
- check cons is not null in vfio_pci_check_cons_fault

v3 -> v4:
- use 2 separate regions, respectively in read and write modes
- add the version capability
---
 drivers/vfio/pci/vfio_pci.c         | 76 +++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h |  6 +++
 drivers/vfio/pci/vfio_pci_rdwr.c    | 44 +++++++++++++++++
 include/uapi/linux/vfio.h           | 34 +++++++++++++
 4 files changed, 160 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index e6190173482c..7546a81e7fb6 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -311,6 +311,78 @@ int vfio_pci_set_power_state(struct vfio_pci_device *vdev, pci_power_t state)
 	return ret;
 }
 
+static void vfio_pci_dma_fault_release(struct vfio_pci_device *vdev,
+				       struct vfio_pci_region *region)
+{
+	kfree(vdev->fault_pages);
+}
+
+static int vfio_pci_dma_fault_add_capability(struct vfio_pci_device *vdev,
+					     struct vfio_pci_region *region,
+					     struct vfio_info_cap *caps)
+{
+	struct vfio_region_info_cap_fault cap = {
+		.header.id = VFIO_REGION_INFO_CAP_DMA_FAULT,
+		.header.version = 1,
+		.version = 1,
+	};
+	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
+}
+
+static const struct vfio_pci_regops vfio_pci_dma_fault_regops = {
+	.rw		= vfio_pci_dma_fault_rw,
+	.release	= vfio_pci_dma_fault_release,
+	.add_capability = vfio_pci_dma_fault_add_capability,
+};
+
+#define DMA_FAULT_RING_LENGTH 512
+
+static int vfio_pci_dma_fault_init(struct vfio_pci_device *vdev)
+{
+	struct vfio_region_dma_fault *header;
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
+	mutex_init(&vdev->fault_queue_lock);
+
+	/*
+	 * We provision 1 page for the header and space for
+	 * DMA_FAULT_RING_LENGTH fault records in the ring buffer.
+	 */
+	size = ALIGN(sizeof(struct iommu_fault) *
+		     DMA_FAULT_RING_LENGTH, PAGE_SIZE) + PAGE_SIZE;
+
+	vdev->fault_pages = kzalloc(size, GFP_KERNEL);
+	if (!vdev->fault_pages)
+		return -ENOMEM;
+
+	ret = vfio_pci_register_dev_region(vdev,
+		VFIO_REGION_TYPE_NESTED,
+		VFIO_REGION_SUBTYPE_NESTED_DMA_FAULT,
+		&vfio_pci_dma_fault_regops, size,
+		VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE,
+		vdev->fault_pages);
+	if (ret)
+		goto out;
+
+	header = (struct vfio_region_dma_fault *)vdev->fault_pages;
+	header->entry_size = sizeof(struct iommu_fault);
+	header->nb_entries = DMA_FAULT_RING_LENGTH;
+	header->offset = sizeof(struct vfio_region_dma_fault);
+	return 0;
+out:
+	kfree(vdev->fault_pages);
+	vdev->fault_pages = NULL;
+	return ret;
+}
+
 static int vfio_pci_enable(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
@@ -409,6 +481,10 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 		}
 	}
 
+	ret = vfio_pci_dma_fault_init(vdev);
+	if (ret)
+		goto disable_exit;
+
 	vfio_pci_probe_mmaps(vdev);
 
 	return 0;
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 5c90e560c5c7..1d9b0f648133 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -134,6 +134,8 @@ struct vfio_pci_device {
 	int			ioeventfds_nr;
 	struct eventfd_ctx	*err_trigger;
 	struct eventfd_ctx	*req_trigger;
+	u8			*fault_pages;
+	struct mutex		fault_queue_lock;
 	struct list_head	dummy_resources_list;
 	struct mutex		ioeventfds_lock;
 	struct list_head	ioeventfds_list;
@@ -170,6 +172,10 @@ extern ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
 extern long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
 			       uint64_t data, int count, int fd);
 
+extern size_t vfio_pci_dma_fault_rw(struct vfio_pci_device *vdev,
+				    char __user *buf, size_t count,
+				    loff_t *ppos, bool iswrite);
+
 extern int vfio_pci_init_perm_bits(void);
 extern void vfio_pci_uninit_perm_bits(void);
 
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index a0b5fc8e46f4..164120607469 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -356,6 +356,50 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
 	return done;
 }
 
+size_t vfio_pci_dma_fault_rw(struct vfio_pci_device *vdev, char __user *buf,
+			     size_t count, loff_t *ppos, bool iswrite)
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
+	mutex_lock(&vdev->fault_queue_lock);
+
+	if (iswrite) {
+		struct vfio_region_dma_fault *header =
+			(struct vfio_region_dma_fault *)base;
+		u32 new_tail;
+
+		if (pos != 0 || count != 4) {
+			ret = -EINVAL;
+			goto unlock;
+		}
+
+		if (copy_from_user((void *)&new_tail, buf, count))
+			goto unlock;
+
+		if (new_tail >= header->nb_entries) {
+			ret = -EINVAL;
+			goto unlock;
+		}
+		header->tail = new_tail;
+	} else {
+		if (copy_to_user(buf, base + pos, count))
+			goto unlock;
+	}
+	*ppos += count;
+	ret = count;
+unlock:
+	mutex_unlock(&vdev->fault_queue_lock);
+	return ret;
+}
+
 static void vfio_pci_ioeventfd_do_write(struct vfio_pci_ioeventfd *ioeventfd,
 					bool test_mem)
 {
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index b352e76cfb71..629dfb38d9e7 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -343,6 +343,9 @@ struct vfio_region_info_cap_type {
 /* sub-types for VFIO_REGION_TYPE_GFX */
 #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
 
+#define VFIO_REGION_TYPE_NESTED			(2)
+#define VFIO_REGION_SUBTYPE_NESTED_DMA_FAULT	(1)
+
 /**
  * struct vfio_region_gfx_edid - EDID region layout.
  *
@@ -988,6 +991,37 @@ struct vfio_device_feature {
  */
 #define VFIO_DEVICE_FEATURE_PCI_VF_TOKEN	(0)
 
+/*
+ * Capability exposed by the DMA fault region
+ * @version: ABI version
+ */
+#define VFIO_REGION_INFO_CAP_DMA_FAULT	6
+
+struct vfio_region_info_cap_fault {
+	struct vfio_info_cap_header header;
+	__u32 version;
+};
+
+/*
+ * DMA Fault Region Layout
+ * @tail: index relative to the start of the ring buffer at which the
+ *        consumer finds the next item in the buffer
+ * @entry_size: fault ring buffer entry size in bytes
+ * @nb_entries: max capacity of the fault ring buffer
+ * @offset: ring buffer offset relative to the start of the region
+ * @head: index relative to the start of the ring buffer at which the
+ *        producer (kernel) inserts items into the buffers
+ */
+struct vfio_region_dma_fault {
+	/* Write-Only */
+	__u32   tail;
+	/* Read-Only */
+	__u32   entry_size;
+	__u32	nb_entries;
+	__u32	offset;
+	__u32   head;
+};
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.21.3

