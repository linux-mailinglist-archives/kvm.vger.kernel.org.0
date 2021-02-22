Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA1E321D78
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 17:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbhBVQxS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 11:53:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49312 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231359AbhBVQxC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 11:53:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614012696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cEeUgZ0gYEuJNqC4jH1I44GKM21P1WyDVnv51cT+tDk=;
        b=XWYILxXhRxGcryCeZUYWyIm3UfG0fGg+kf8KGx0Yv5mDV9mmNW3hO0jVAZwqXIujs499EW
        gUMDkuSAnIg0FJa9HTXFlIPJZP1K0PlcDeplfuOto2NJqwf7uxAuv1r15e8JLSoWQnUn38
        IkLN8BWNOMhylBvnPmQpFOb28f7DhO0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-imn9u1fnMvekfwV_Lz63zQ-1; Mon, 22 Feb 2021 11:51:34 -0500
X-MC-Unique: imn9u1fnMvekfwV_Lz63zQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A575F192AB78;
        Mon, 22 Feb 2021 16:51:33 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBA8660C04;
        Mon, 22 Feb 2021 16:51:25 +0000 (UTC)
Subject: [RFC PATCH 05/10] vfio: Create a vfio_device from vma lookup
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Mon, 22 Feb 2021 09:51:25 -0700
Message-ID: <161401268537.16443.2329805617992345365.stgit@gimli.home>
In-Reply-To: <161401167013.16443.8389863523766611711.stgit@gimli.home>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
User-Agent: StGit/0.21-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a vfio bus driver policy where using the exported
vfio_device_vma_open() as the vm_ops.open for a vma indicates
vm_private_data is the struct vfio_device pointer associated
to the vma.  This allows a direct vma to device lookup.

Operating on an active, open vma to the device, we should be
able to directly increment the vfio_device reference.

Implemented only for vfio-pci for now.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c |    6 ++++--
 drivers/vfio/vfio.c         |   24 ++++++++++++++++++++++++
 include/linux/vfio.h        |    2 ++
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 115f10f7b096..f9529bac6c97 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1469,7 +1469,8 @@ void vfio_pci_memory_unlock_and_restore(struct vfio_pci_device *vdev, u16 cmd)
 static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct vfio_pci_device *vdev = vma->vm_private_data;
+	struct vfio_device *device = vma->vm_private_data;
+	struct vfio_pci_device *vdev = vfio_device_data(device);
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 
 	down_read(&vdev->memory_lock);
@@ -1485,6 +1486,7 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 }
 
 static const struct vm_operations_struct vfio_pci_mmap_ops = {
+	.open = vfio_device_vma_open,
 	.fault = vfio_pci_mmap_fault,
 };
 
@@ -1542,7 +1544,7 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 		}
 	}
 
-	vma->vm_private_data = vdev;
+	vma->vm_private_data = vdev->device;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	vma->vm_pgoff = (pci_resource_start(pdev, index) >> PAGE_SHIFT) + pgoff;
 
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index da212425ab30..399c42b77fbb 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -572,6 +572,15 @@ void vfio_device_unmap_mapping_range(struct vfio_device *device,
 }
 EXPORT_SYMBOL_GPL(vfio_device_unmap_mapping_range);
 
+/*
+ * A VFIO bus driver using this open callback will provide a
+ * struct vfio_device pointer in the vm_private_data field.
+ */
+void vfio_device_vma_open(struct vm_area_struct *vma)
+{
+}
+EXPORT_SYMBOL_GPL(vfio_device_vma_open);
+
 /**
  * Device objects - create, release, get, put, search
  */
@@ -927,6 +936,21 @@ struct vfio_device *vfio_device_get_from_dev(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(vfio_device_get_from_dev);
 
+struct vfio_device *vfio_device_get_from_vma(struct vm_area_struct *vma)
+{
+	struct vfio_device *device;
+
+	if (vma->vm_ops->open != vfio_device_vma_open)
+		return ERR_PTR(-ENODEV);
+
+	device = vma->vm_private_data;
+
+	vfio_device_get(device);
+
+	return device;
+}
+EXPORT_SYMBOL_GPL(vfio_device_get_from_vma);
+
 static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
 						     char *buf)
 {
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index f435dfca15eb..188c2f3feed9 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -58,6 +58,8 @@ extern void vfio_device_put(struct vfio_device *device);
 extern void *vfio_device_data(struct vfio_device *device);
 extern void vfio_device_unmap_mapping_range(struct vfio_device *device,
 					    loff_t start, loff_t len);
+extern void vfio_device_vma_open(struct vm_area_struct *vma);
+extern struct vfio_device *vfio_device_get_from_vma(struct vm_area_struct *vma);
 
 /* events for the backend driver notify callback */
 enum vfio_iommu_notify_type {

