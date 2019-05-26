Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 662132AB03
	for <lists+kvm@lfdr.de>; Sun, 26 May 2019 18:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbfEZQMe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 May 2019 12:12:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55462 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728029AbfEZQMd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 May 2019 12:12:33 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3BDD485542;
        Sun, 26 May 2019 16:12:33 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-67.ams2.redhat.com [10.36.116.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5391E5D72A;
        Sun, 26 May 2019 16:12:29 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, jean-philippe.brucker@arm.com,
        will.deacon@arm.com, robin.murphy@arm.com
Cc:     kevin.tian@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com,
        peter.maydell@linaro.org, vincent.stehle@arm.com
Subject: [PATCH v8 25/29] vfio-pci: Add a new VFIO_REGION_TYPE_NESTED region type
Date:   Sun, 26 May 2019 18:10:00 +0200
Message-Id: <20190526161004.25232-26-eric.auger@redhat.com>
In-Reply-To: <20190526161004.25232-1-eric.auger@redhat.com>
References: <20190526161004.25232-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Sun, 26 May 2019 16:12:33 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds two new regions aiming to handle nested mode
translation faults.

The first region (two host kernel pages) is read-only from the
user-space perspective. The first page contains an header
that provides information about the circular buffer located in the
second page. The circular buffer is put in a different page in
the prospect to be mmappable.

The max user API version supported by the kernel is returned
through a dedicated fault region capability.

The prod header contains
- the user API version in use (potentially inferior to the one
  returned in the capability),
- the offset of the queue within the region,
- the producer index relative to the start of the queue
- the max number of fault records,
- the size of each record.

The second region is write-only from the user perspective. It
contains the version of the requested fault ABI and the consumer
index that is updated by the userspace each time this latter has
consumed fault records.

The natural order of operation for the userspace is:
- retrieve the highest supported fault ABI version
- set the requested fault ABI version in the consumer region

Until the ABI version is not set by the userspace, the kernel
cannot return a comprehensive set of information inside the
prod header (entry size and number of entries in the fault queue).

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v4 -> v5
- check cons is not null in vfio_pci_check_cons_fault

v3 -> v4:
- use 2 separate regions, respectively in read and write modes
- add the version capability
---
 drivers/vfio/pci/vfio_pci.c         | 105 ++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h |  17 +++++
 drivers/vfio/pci/vfio_pci_rdwr.c    |  73 +++++++++++++++++++
 include/uapi/linux/vfio.h           |  42 +++++++++++
 4 files changed, 237 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index cab71da46f4a..f75f61127277 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -261,6 +261,106 @@ int vfio_pci_set_power_state(struct vfio_pci_device *vdev, pci_power_t state)
 	return ret;
 }
 
+void vfio_pci_fault_release(struct vfio_pci_device *vdev,
+			    struct vfio_pci_region *region)
+{
+}
+
+static const struct vfio_pci_fault_abi fault_abi_versions[] = {
+	[0] = {
+		.entry_size = sizeof(struct iommu_fault),
+	},
+};
+
+#define NR_FAULT_ABIS ARRAY_SIZE(fault_abi_versions)
+
+static int vfio_pci_fault_prod_add_capability(struct vfio_pci_device *vdev,
+		struct vfio_pci_region *region, struct vfio_info_cap *caps)
+{
+	struct vfio_region_info_cap_fault cap = {
+		.header.id = VFIO_REGION_INFO_CAP_PRODUCER_FAULT,
+		.header.version = 1,
+		.version = NR_FAULT_ABIS,
+	};
+	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
+}
+
+static const struct vfio_pci_regops vfio_pci_fault_cons_regops = {
+	.rw		= vfio_pci_fault_cons_rw,
+	.release	= vfio_pci_fault_release,
+};
+
+static const struct vfio_pci_regops vfio_pci_fault_prod_regops = {
+	.rw		= vfio_pci_fault_prod_rw,
+	.release	= vfio_pci_fault_release,
+	.add_capability = vfio_pci_fault_prod_add_capability,
+};
+
+static int vfio_pci_init_fault_region(struct vfio_pci_device *vdev)
+{
+	struct vfio_region_fault_prod *header;
+	int ret;
+
+	mutex_init(&vdev->fault_queue_lock);
+
+	vdev->fault_pages = kzalloc(3 * PAGE_SIZE, GFP_KERNEL);
+	if (!vdev->fault_pages)
+		return -ENOMEM;
+
+	ret = vfio_pci_register_dev_region(vdev,
+		VFIO_REGION_TYPE_NESTED,
+		VFIO_REGION_SUBTYPE_NESTED_FAULT_PROD,
+		&vfio_pci_fault_prod_regops, 2 * PAGE_SIZE,
+		VFIO_REGION_INFO_FLAG_READ, vdev->fault_pages);
+	if (ret)
+		goto out;
+
+	ret = vfio_pci_register_dev_region(vdev,
+		VFIO_REGION_TYPE_NESTED,
+		VFIO_REGION_SUBTYPE_NESTED_FAULT_CONS,
+		&vfio_pci_fault_cons_regops,
+		sizeof(struct vfio_region_fault_cons),
+		VFIO_REGION_INFO_FLAG_WRITE,
+		vdev->fault_pages + 2 * PAGE_SIZE);
+	if (ret)
+		goto out;
+
+	header = (struct vfio_region_fault_prod *)vdev->fault_pages;
+	header->version = -1;
+	header->offset = PAGE_SIZE;
+	return 0;
+out:
+	kfree(vdev->fault_pages);
+	return ret;
+}
+
+int vfio_pci_check_cons_fault(struct vfio_pci_device *vdev,
+			     struct vfio_region_fault_cons *cons_header)
+{
+	struct vfio_region_fault_prod *prod_header =
+		(struct vfio_region_fault_prod *)vdev->fault_pages;
+
+	if (cons_header->version > NR_FAULT_ABIS)
+		return -EINVAL;
+
+	if (!vdev->fault_abi) {
+		vdev->fault_abi = cons_header->version;
+		prod_header->entry_size =
+			fault_abi_versions[vdev->fault_abi - 1].entry_size;
+		prod_header->nb_entries = PAGE_SIZE / prod_header->entry_size;
+		return 0;
+	}
+
+	/* Fault ABI is set */
+	if (cons_header->version != vdev->fault_abi)
+		return -EINVAL;
+
+	if (cons_header->cons && cons_header->cons >= prod_header->nb_entries)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int vfio_pci_enable(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
@@ -359,6 +459,10 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 		}
 	}
 
+	ret = vfio_pci_init_fault_region(vdev);
+	if (ret)
+		goto disable_exit;
+
 	vfio_pci_probe_mmaps(vdev);
 
 	return 0;
@@ -1374,6 +1478,7 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 
 	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
 	kfree(vdev->region);
+	kfree(vdev->fault_pages);
 	mutex_destroy(&vdev->ioeventfds_lock);
 
 	if (!disable_idle_d3)
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 1812cf22fc4f..8e0a55682d3f 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -122,9 +122,12 @@ struct vfio_pci_device {
 	int			ioeventfds_nr;
 	struct eventfd_ctx	*err_trigger;
 	struct eventfd_ctx	*req_trigger;
+	struct mutex		fault_queue_lock;
+	int			fault_abi;
 	struct list_head	dummy_resources_list;
 	struct mutex		ioeventfds_lock;
 	struct list_head	ioeventfds_list;
+	u8			*fault_pages;
 };
 
 #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
@@ -153,6 +156,18 @@ extern ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
 extern long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
 			       uint64_t data, int count, int fd);
 
+struct vfio_pci_fault_abi {
+	u32 entry_size;
+};
+
+extern size_t vfio_pci_fault_cons_rw(struct vfio_pci_device *vdev,
+				     char __user *buf, size_t count,
+				     loff_t *ppos, bool iswrite);
+
+extern size_t vfio_pci_fault_prod_rw(struct vfio_pci_device *vdev,
+				     char __user *buf, size_t count,
+				     loff_t *ppos, bool iswrite);
+
 extern int vfio_pci_init_perm_bits(void);
 extern void vfio_pci_uninit_perm_bits(void);
 
@@ -166,6 +181,8 @@ extern int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
 
 extern int vfio_pci_set_power_state(struct vfio_pci_device *vdev,
 				    pci_power_t state);
+extern int vfio_pci_check_cons_fault(struct vfio_pci_device *vdev,
+				     struct vfio_region_fault_cons *header);
 
 #ifdef CONFIG_VFIO_PCI_IGD
 extern int vfio_pci_igd_init(struct vfio_pci_device *vdev);
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index a6029d0a5524..67cd9363f4e7 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -277,6 +277,79 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
 	return done;
 }
 
+/* Read-only region */
+size_t vfio_pci_fault_prod_rw(struct vfio_pci_device *vdev, char __user *buf,
+			      size_t count, loff_t *ppos, bool iswrite)
+{
+	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
+	void *base = vdev->region[i].data;
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	int ret = 0;
+
+	if (iswrite)
+		return 0;
+
+	if (!vdev->fault_abi)
+		return -EINVAL;
+
+	if (pos >= vdev->region[i].size)
+		return -EINVAL;
+
+	count = min(count, (size_t)(vdev->region[i].size - pos));
+
+	mutex_lock(&vdev->fault_queue_lock);
+
+	if (copy_to_user(buf, base + pos, count)) {
+		ret = -EFAULT;
+		goto unlock;
+	}
+	*ppos += count;
+	ret = count;
+unlock:
+	mutex_unlock(&vdev->fault_queue_lock);
+	return ret;
+}
+
+
+/* write only */
+size_t vfio_pci_fault_cons_rw(struct vfio_pci_device *vdev, char __user *buf,
+			      size_t count, loff_t *ppos, bool iswrite)
+{
+	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
+	void *base = vdev->region[i].data;
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	struct vfio_region_fault_cons *header;
+	struct vfio_region_fault_cons orig_header =
+		*(struct vfio_region_fault_cons *)base;
+	int ret = 0;
+
+	if (!iswrite)
+		return 0;
+
+	if (pos >= vdev->region[i].size)
+		return -EINVAL;
+
+	count = min(count, (size_t)(vdev->region[i].size - pos));
+
+	mutex_lock(&vdev->fault_queue_lock);
+
+	if (copy_from_user(base + pos, buf, count)) {
+		ret = -EFAULT;
+		goto unlock;
+	}
+	header = (struct vfio_region_fault_cons *)base;
+	ret = vfio_pci_check_cons_fault(vdev, header);
+	if (ret) {
+		*header = orig_header;
+		goto unlock;
+	}
+	*ppos += count;
+	ret = count;
+unlock:
+	mutex_unlock(&vdev->fault_queue_lock);
+	return ret;
+}
+
 static int vfio_pci_ioeventfd_handler(void *opaque, void *unused)
 {
 	struct vfio_pci_ioeventfd *ioeventfd = opaque;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 2774a1ab37ae..13e041b84d48 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -307,6 +307,10 @@ struct vfio_region_info_cap_type {
 #define VFIO_REGION_TYPE_GFX                    (1)
 #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
 
+#define VFIO_REGION_TYPE_NESTED			(2)
+#define VFIO_REGION_SUBTYPE_NESTED_FAULT_PROD	(1)
+#define VFIO_REGION_SUBTYPE_NESTED_FAULT_CONS	(2)
+
 /**
  * struct vfio_region_gfx_edid - EDID region layout.
  *
@@ -701,6 +705,44 @@ struct vfio_device_ioeventfd {
 
 #define VFIO_DEVICE_IOEVENTFD		_IO(VFIO_TYPE, VFIO_BASE + 16)
 
+
+/*
+ * Capability exposed by the Producer Fault Region
+ * @version: max fault ABI version supported by the kernel
+ */
+#define VFIO_REGION_INFO_CAP_PRODUCER_FAULT	6
+
+struct vfio_region_info_cap_fault {
+	struct vfio_info_cap_header header;
+	__u32 version;
+};
+
+/*
+ * Producer Fault Region (Read-Only from user space perspective)
+ * Contains the fault circular buffer and the producer index
+ * @version: version of the fault record uapi
+ * @entry_size: size of each fault record
+ * @offset: offset of the start of the queue
+ * @prod: producer index relative to the start of the queue
+ */
+struct vfio_region_fault_prod {
+	__u32   version;
+	__u32	nb_entries;
+	__u32   entry_size;
+	__u32	offset;
+	__u32   prod;
+};
+
+/*
+ * Consumer Fault Region (Write-Only from the user space perspective)
+ * @version: ABI version requested by the userspace
+ * @cons: consumer index relative to the start of the queue
+ */
+struct vfio_region_fault_cons {
+	__u32 version;
+	__u32 cons;
+};
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.20.1

