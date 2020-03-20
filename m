Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE8918D428
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 17:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbgCTQUX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 12:20:23 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:39005 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727724AbgCTQUV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 12:20:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584721220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mhzJgSkCJsNgfAjdjebamfXi6WM/A0Mk2yWVsVfPFeA=;
        b=DAPqlV0zLojrsphrmYJ7UkRSfBPWWm98tzk/OXksc03NhL8LWznEZKiMpKKdM1FnZXgSw8
        A12VuVnguVESfPBYaxi3g2HbzkJUOW9OMu/ewgAMbULrCGj9L7pvwS66EfQGMZ2oQ/ZFCZ
        WCQbB8BF9KyBcNczjkhL1VOR/WtWF8A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-LMNIg5YeMteTqmLbGVuhnw-1; Fri, 20 Mar 2020 12:20:19 -0400
X-MC-Unique: LMNIg5YeMteTqmLbGVuhnw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B1CC100550D;
        Fri, 20 Mar 2020 16:20:17 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 61B9A60BF1;
        Fri, 20 Mar 2020 16:20:12 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, jean-philippe.brucker@arm.com,
        will.deacon@arm.com, robin.murphy@arm.com
Cc:     marc.zyngier@arm.com, peter.maydell@linaro.org,
        zhangfei.gao@gmail.com
Subject: [PATCH v10 06/11] vfio/pci: Allow to mmap the fault queue
Date:   Fri, 20 Mar 2020 17:19:06 +0100
Message-Id: <20200320161911.27494-7-eric.auger@redhat.com>
In-Reply-To: <20200320161911.27494-1-eric.auger@redhat.com>
References: <20200320161911.27494-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The DMA FAULT region contains the fault ring buffer.
There is benefit to let the userspace mmap this area.
Expose this mmappable area through a sparse mmap entry
and implement the mmap operation.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v8 -> v9:
- remove unused index local variable in vfio_pci_fault_mmap
---
 drivers/vfio/pci/vfio_pci.c | 61 +++++++++++++++++++++++++++++++++++--
 1 file changed, 58 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 69595c240baf..3c99f6f3825b 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -266,21 +266,75 @@ static void vfio_pci_dma_fault_release(struct vfio_=
pci_device *vdev,
 {
 }
=20
+static int vfio_pci_dma_fault_mmap(struct vfio_pci_device *vdev,
+				   struct vfio_pci_region *region,
+				   struct vm_area_struct *vma)
+{
+	u64 phys_len, req_len, pgoff, req_start;
+	unsigned long long addr;
+	unsigned int ret;
+
+	phys_len =3D region->size;
+
+	req_len =3D vma->vm_end - vma->vm_start;
+	pgoff =3D vma->vm_pgoff &
+		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+	req_start =3D pgoff << PAGE_SHIFT;
+
+	/* only the second page of the producer fault region is mmappable */
+	if (req_start < PAGE_SIZE)
+		return -EINVAL;
+
+	if (req_start + req_len > phys_len)
+		return -EINVAL;
+
+	addr =3D virt_to_phys(vdev->fault_pages);
+	vma->vm_private_data =3D vdev;
+	vma->vm_pgoff =3D (addr >> PAGE_SHIFT) + pgoff;
+
+	ret =3D remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+			      req_len, vma->vm_page_prot);
+	return ret;
+}
+
 static int vfio_pci_dma_fault_add_capability(struct vfio_pci_device *vde=
v,
 					     struct vfio_pci_region *region,
 					     struct vfio_info_cap *caps)
 {
+	struct vfio_region_info_cap_sparse_mmap *sparse =3D NULL;
 	struct vfio_region_info_cap_fault cap =3D {
 		.header.id =3D VFIO_REGION_INFO_CAP_DMA_FAULT,
 		.header.version =3D 1,
 		.version =3D 1,
 	};
-	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
+	size_t size =3D sizeof(*sparse) + sizeof(*sparse->areas);
+	int ret;
+
+	ret =3D vfio_info_add_capability(caps, &cap.header, sizeof(cap));
+	if (ret)
+		return ret;
+
+	sparse =3D kzalloc(size, GFP_KERNEL);
+	if (!sparse)
+		return -ENOMEM;
+
+	sparse->header.id =3D VFIO_REGION_INFO_CAP_SPARSE_MMAP;
+	sparse->header.version =3D 1;
+	sparse->nr_areas =3D 1;
+	sparse->areas[0].offset =3D PAGE_SIZE;
+	sparse->areas[0].size =3D region->size - PAGE_SIZE;
+
+	ret =3D vfio_info_add_capability(caps, &sparse->header, size);
+	if (ret)
+		kfree(sparse);
+
+	return ret;
 }
=20
 static const struct vfio_pci_regops vfio_pci_dma_fault_regops =3D {
 	.rw		=3D vfio_pci_dma_fault_rw,
 	.release	=3D vfio_pci_dma_fault_release,
+	.mmap		=3D vfio_pci_dma_fault_mmap,
 	.add_capability =3D vfio_pci_dma_fault_add_capability,
 };
=20
@@ -341,7 +395,8 @@ static int vfio_pci_init_dma_fault_region(struct vfio=
_pci_device *vdev)
 		VFIO_REGION_TYPE_NESTED,
 		VFIO_REGION_SUBTYPE_NESTED_DMA_FAULT,
 		&vfio_pci_dma_fault_regops, size,
-		VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE,
+		VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE |
+		VFIO_REGION_INFO_FLAG_MMAP,
 		vdev->fault_pages);
 	if (ret)
 		goto out;
@@ -349,7 +404,7 @@ static int vfio_pci_init_dma_fault_region(struct vfio=
_pci_device *vdev)
 	header =3D (struct vfio_region_dma_fault *)vdev->fault_pages;
 	header->entry_size =3D sizeof(struct iommu_fault);
 	header->nb_entries =3D DMA_FAULT_RING_LENGTH;
-	header->offset =3D sizeof(struct vfio_region_dma_fault);
+	header->offset =3D PAGE_SIZE;
=20
 	ret =3D iommu_register_device_fault_handler(&vdev->pdev->dev,
 					vfio_pci_iommu_dev_fault_handler,
--=20
2.20.1

