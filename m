Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E7635B3CB
	for <lists+kvm@lfdr.de>; Sun, 11 Apr 2021 13:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235568AbhDKLsh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Apr 2021 07:48:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51230 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235562AbhDKLse (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 11 Apr 2021 07:48:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618141691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OYVzuNS8qk0TCuVISNmToowhfiWxm/ZPK951/KuGFJY=;
        b=M3RCP+5CUIxoog/PFW/waqQoygyttIbCFR9jutflNh1YXq14VuskHCOu2gvCk2oVDxE0o0
        wdqX6ynIWG6UngzdLu5frE8bM3KEqCiHYnpEz+Utg8RyB34PJcsYoLAVEu5itWn15tJXlv
        2fdiDEuMH6qQSyZIDbTD1uDR7+H+p3o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-B23VX4a6PcK6XwmPR8N4rg-1; Sun, 11 Apr 2021 07:48:07 -0400
X-MC-Unique: B23VX4a6PcK6XwmPR8N4rg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03AA381746C;
        Sun, 11 Apr 2021 11:48:05 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-22.ams2.redhat.com [10.36.112.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA90A5C266;
        Sun, 11 Apr 2021 11:47:51 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        maz@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
        alex.williamson@redhat.com, tn@semihalf.com, zhukeqian1@huawei.com
Cc:     jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com,
        wangxingang5@huawei.com, jean-philippe@linaro.org,
        zhangfei.gao@linaro.org, zhangfei.gao@gmail.com,
        vivek.gautam@arm.com, shameerali.kolothum.thodi@huawei.com,
        yuzenghui@huawei.com, nicoleotsuka@gmail.com,
        lushenming@huawei.com, vsethi@nvidia.com,
        chenxiang66@hisilicon.com, vdumpa@nvidia.com,
        jiangkunkun@huawei.com
Subject: [PATCH v13 04/13] vfio/pci: Add VFIO_REGION_TYPE_NESTED region type
Date:   Sun, 11 Apr 2021 13:46:50 +0200
Message-Id: <20210411114659.15051-5-eric.auger@redhat.com>
In-Reply-To: <20210411114659.15051-1-eric.auger@redhat.com>
References: <20210411114659.15051-1-eric.auger@redhat.com>
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
- update value of VFIO_REGION_TYPE_NESTED
- handle the case where the domain is NULL
- pass an int pointer to iommu_domain_get_attr [Shenming]

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
 drivers/vfio/pci/vfio_pci.c         | 79 +++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h |  6 +++
 drivers/vfio/pci/vfio_pci_rdwr.c    | 44 ++++++++++++++++
 include/uapi/linux/vfio.h           | 35 +++++++++++++
 4 files changed, 164 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 65e7e6b44578..f37cabddf1d6 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -309,6 +309,81 @@ int vfio_pci_set_power_state(struct vfio_pci_device *vdev, pci_power_t state)
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
+	int nested;
+	int ret;
+
+	domain = iommu_get_domain_for_dev(&vdev->pdev->dev);
+	if (!domain)
+		return 0;
+
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
@@ -407,6 +482,10 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 		}
 	}
 
+	ret = vfio_pci_dma_fault_init(vdev);
+	if (ret)
+		goto disable_exit;
+
 	vfio_pci_probe_mmaps(vdev);
 
 	return 0;
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 9cd1882a05af..76cb3bd11375 100644
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
index afa8596c05d2..ca8cc796e254 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -325,6 +325,7 @@ struct vfio_region_info_cap_type {
 #define VFIO_REGION_TYPE_GFX                    (1)
 #define VFIO_REGION_TYPE_CCW			(2)
 #define VFIO_REGION_TYPE_MIGRATION              (3)
+#define VFIO_REGION_TYPE_NESTED			(4)
 
 /* sub-types for VFIO_REGION_TYPE_PCI_* */
 
@@ -349,6 +350,9 @@ struct vfio_region_info_cap_type {
 /* sub-types for VFIO_REGION_TYPE_GFX */
 #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
 
+/* sub-types for VFIO_REGION_TYPE_NESTED */
+#define VFIO_REGION_SUBTYPE_NESTED_DMA_FAULT	(1)
+
 /**
  * struct vfio_region_gfx_edid - EDID region layout.
  *
@@ -995,6 +999,37 @@ struct vfio_device_feature {
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
2.26.3

