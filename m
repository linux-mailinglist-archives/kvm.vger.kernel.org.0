Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 098D218D41B
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 17:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbgCTQUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 12:20:07 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:28276 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727576AbgCTQUE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 12:20:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584721202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2QcW6ZnRzJ2aFmZq2RzXvJ/KIAbDk13HbSmFep2+6wQ=;
        b=cCEntqkTcu+yMksGSX8AXlVBHpm1+7YMoSWAz8T2EPjLdA5soSpEbgsVLW8c0ck2W2mhBb
        X+3HbRSPdWavZGtXB65a++CbDj2wacvULD9IF5uc9DlBJYaxv8lqG2y77jbG2xdllJz8xf
        WuOn16RlZF2H94NH0U0AaldfR4QONp8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-pqPYFjuuPXy6maVl701BMQ-1; Fri, 20 Mar 2020 12:20:00 -0400
X-MC-Unique: pqPYFjuuPXy6maVl701BMQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DFAE108442D;
        Fri, 20 Mar 2020 16:19:55 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6494660BF1;
        Fri, 20 Mar 2020 16:19:51 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, jean-philippe.brucker@arm.com,
        will.deacon@arm.com, robin.murphy@arm.com
Cc:     marc.zyngier@arm.com, peter.maydell@linaro.org,
        zhangfei.gao@gmail.com
Subject: [PATCH v10 04/11] vfio/pci: Add VFIO_REGION_TYPE_NESTED region type
Date:   Fri, 20 Mar 2020 17:19:04 +0100
Message-Id: <20200320161911.27494-5-eric.auger@redhat.com>
In-Reply-To: <20200320161911.27494-1-eric.auger@redhat.com>
References: <20200320161911.27494-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new specific DMA_FAULT region aiming to exposed nested mode
translation faults.

The region has a ring buffer that contains the actual fault
records plus a header allowing to handle it (tail/head indices,
max capacity, entry size). At the moment the region is dimensionned
for 512 fault records.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v8 -> v9:
- Use a single region instead of a prod/cons region

v4 -> v5
- check cons is not null in vfio_pci_check_cons_fault

v3 -> v4:
- use 2 separate regions, respectively in read and write modes
- add the version capability
---
 drivers/vfio/pci/vfio_pci.c         | 68 +++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h | 10 +++++
 drivers/vfio/pci/vfio_pci_rdwr.c    | 45 +++++++++++++++++++
 include/uapi/linux/vfio.h           | 35 +++++++++++++++
 4 files changed, 158 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 379a02c36e37..586b89debed5 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -260,6 +260,69 @@ int vfio_pci_set_power_state(struct vfio_pci_device =
*vdev, pci_power_t state)
 	return ret;
 }
=20
+static void vfio_pci_dma_fault_release(struct vfio_pci_device *vdev,
+				       struct vfio_pci_region *region)
+{
+}
+
+static int vfio_pci_dma_fault_add_capability(struct vfio_pci_device *vde=
v,
+					     struct vfio_pci_region *region,
+					     struct vfio_info_cap *caps)
+{
+	struct vfio_region_info_cap_fault cap =3D {
+		.header.id =3D VFIO_REGION_INFO_CAP_DMA_FAULT,
+		.header.version =3D 1,
+		.version =3D 1,
+	};
+	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
+}
+
+static const struct vfio_pci_regops vfio_pci_dma_fault_regops =3D {
+	.rw		=3D vfio_pci_dma_fault_rw,
+	.release	=3D vfio_pci_dma_fault_release,
+	.add_capability =3D vfio_pci_dma_fault_add_capability,
+};
+
+#define DMA_FAULT_RING_LENGTH 512
+
+static int vfio_pci_init_dma_fault_region(struct vfio_pci_device *vdev)
+{
+	struct vfio_region_dma_fault *header;
+	size_t size;
+	int ret;
+
+	mutex_init(&vdev->fault_queue_lock);
+
+	/*
+	 * We provision 1 page for the header and space for
+	 * DMA_FAULT_RING_LENGTH fault records in the ring buffer.
+	 */
+	size =3D ALIGN(sizeof(struct iommu_fault) *
+		     DMA_FAULT_RING_LENGTH, PAGE_SIZE) + PAGE_SIZE;
+
+	vdev->fault_pages =3D kzalloc(size, GFP_KERNEL);
+	if (!vdev->fault_pages)
+		return -ENOMEM;
+
+	ret =3D vfio_pci_register_dev_region(vdev,
+		VFIO_REGION_TYPE_NESTED,
+		VFIO_REGION_SUBTYPE_NESTED_DMA_FAULT,
+		&vfio_pci_dma_fault_regops, size,
+		VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE,
+		vdev->fault_pages);
+	if (ret)
+		goto out;
+
+	header =3D (struct vfio_region_dma_fault *)vdev->fault_pages;
+	header->entry_size =3D sizeof(struct iommu_fault);
+	header->nb_entries =3D DMA_FAULT_RING_LENGTH;
+	header->offset =3D sizeof(struct vfio_region_dma_fault);
+	return 0;
+out:
+	kfree(vdev->fault_pages);
+	return ret;
+}
+
 static int vfio_pci_enable(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *pdev =3D vdev->pdev;
@@ -358,6 +421,10 @@ static int vfio_pci_enable(struct vfio_pci_device *v=
dev)
 		}
 	}
=20
+	ret =3D vfio_pci_init_dma_fault_region(vdev);
+	if (ret)
+		goto disable_exit;
+
 	vfio_pci_probe_mmaps(vdev);
=20
 	return 0;
@@ -1383,6 +1450,7 @@ static void vfio_pci_remove(struct pci_dev *pdev)
=20
 	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
 	kfree(vdev->region);
+	kfree(vdev->fault_pages);
 	mutex_destroy(&vdev->ioeventfds_lock);
=20
 	if (!disable_idle_d3)
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_=
pci_private.h
index 8a2c7607d513..a392f50e3a99 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -119,6 +119,8 @@ struct vfio_pci_device {
 	int			ioeventfds_nr;
 	struct eventfd_ctx	*err_trigger;
 	struct eventfd_ctx	*req_trigger;
+	u8			*fault_pages;
+	struct mutex		fault_queue_lock;
 	struct list_head	dummy_resources_list;
 	struct mutex		ioeventfds_lock;
 	struct list_head	ioeventfds_list;
@@ -150,6 +152,14 @@ extern ssize_t vfio_pci_vga_rw(struct vfio_pci_devic=
e *vdev, char __user *buf,
 extern long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offs=
et,
 			       uint64_t data, int count, int fd);
=20
+struct vfio_pci_fault_abi {
+	u32 entry_size;
+};
+
+extern size_t vfio_pci_dma_fault_rw(struct vfio_pci_device *vdev,
+				    char __user *buf, size_t count,
+				    loff_t *ppos, bool iswrite);
+
 extern int vfio_pci_init_perm_bits(void);
 extern void vfio_pci_uninit_perm_bits(void);
=20
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci=
_rdwr.c
index a87992892a9f..4004ab8cad0e 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -274,6 +274,51 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev=
, char __user *buf,
 	return done;
 }
=20
+size_t vfio_pci_dma_fault_rw(struct vfio_pci_device *vdev, char __user *=
buf,
+			     size_t count, loff_t *ppos, bool iswrite)
+{
+	unsigned int i =3D VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIO=
NS;
+	loff_t pos =3D *ppos & VFIO_PCI_OFFSET_MASK;
+	void *base =3D vdev->region[i].data;
+	int ret =3D -EFAULT;
+
+	if (pos >=3D vdev->region[i].size)
+		return -EINVAL;
+
+	count =3D min(count, (size_t)(vdev->region[i].size - pos));
+
+	mutex_lock(&vdev->fault_queue_lock);
+
+	if (iswrite) {
+		struct vfio_region_dma_fault *header =3D
+			(struct vfio_region_dma_fault *)base;
+		u32 new_tail;
+
+		if (pos !=3D 0 || count !=3D 4) {
+			ret =3D -EINVAL;
+			goto unlock;
+		}
+
+		if (copy_from_user((void *)&new_tail, buf, count))
+			goto unlock;
+
+		if (new_tail > header->nb_entries) {
+			ret =3D -EINVAL;
+			goto unlock;
+		}
+		header->tail =3D new_tail;
+	} else {
+		if (copy_to_user(buf, base + pos, count))
+			goto unlock;
+	}
+	*ppos +=3D count;
+	ret =3D count;
+unlock:
+	mutex_unlock(&vdev->fault_queue_lock);
+	return ret;
+}
+
+
 static int vfio_pci_ioeventfd_handler(void *opaque, void *unused)
 {
 	struct vfio_pci_ioeventfd *ioeventfd =3D opaque;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 9f2429eb1958..40d770f80e3d 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -330,6 +330,9 @@ struct vfio_region_info_cap_type {
 /* sub-types for VFIO_REGION_TYPE_GFX */
 #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
=20
+#define VFIO_REGION_TYPE_NESTED			(2)
+#define VFIO_REGION_SUBTYPE_NESTED_DMA_FAULT	(1)
+
 /**
  * struct vfio_region_gfx_edid - EDID region layout.
  *
@@ -708,6 +711,38 @@ struct vfio_device_ioeventfd {
=20
 #define VFIO_DEVICE_IOEVENTFD		_IO(VFIO_TYPE, VFIO_BASE + 16)
=20
+
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
=20
 /**
--=20
2.20.1

