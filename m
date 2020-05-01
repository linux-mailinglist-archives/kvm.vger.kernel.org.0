Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F98D1C1FC5
	for <lists+kvm@lfdr.de>; Fri,  1 May 2020 23:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgEAVjd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 17:39:33 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30762 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726599AbgEAVjb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 1 May 2020 17:39:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588369169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fvupvb0EfdgAlFWrkYXCGwW+ZxDHYS+QLiJaV0iFOGA=;
        b=Z4cAKYGz9Dh3CmLgUkS8TAugWcgcNapx0EsiYYHIyuiOTz7SUPawZa++B9zniDZc6MngeG
        dNDQWrGcKb0Z/zYraMafsJUP0zuSFL7gaVYh7+lwcObZMzlBQSPRWazez1kP1kVr/yoqt+
        RBEPUPHPRpuDT+6iyoe8HOFF6e7hbmc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-LVktGl5ePZGOZ3pl58APUA-1; Fri, 01 May 2020 17:39:26 -0400
X-MC-Unique: LVktGl5ePZGOZ3pl58APUA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 367F0107ACCD;
        Fri,  1 May 2020 21:39:25 +0000 (UTC)
Received: from gimli.home (ovpn-113-95.phx2.redhat.com [10.3.113.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FA506A954;
        Fri,  1 May 2020 21:39:19 +0000 (UTC)
Subject: [PATCH 2/3] vfio-pci: Fault mmaps to enable vma tracking
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, cohuck@redhat.com, jgg@ziepe.ca,
        peterx@redhat.com
Date:   Fri, 01 May 2020 15:39:19 -0600
Message-ID: <158836915917.8433.8017639758883869710.stgit@gimli.home>
In-Reply-To: <158836742096.8433.685478071796941103.stgit@gimli.home>
References: <158836742096.8433.685478071796941103.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rather than calling remap_pfn_range() when a region is mmap'd, setup
a vm_ops handler to support dynamic faulting of the range on access.
This allows us to manage a list of vmas actively mapping the area that
we can later use to invalidate those mappings.  The open callback
invalidates the vma range so that all tracking is inserted in the
fault handler and removed in the close handler.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c         |   76 ++++++++++++++++++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_private.h |    7 +++
 2 files changed, 81 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 6c6b37b5c04e..da2fef666d9c 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1299,6 +1299,70 @@ static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
 	return vfio_pci_rw(device_data, (char __user *)buf, count, ppos, true);
 }
 
+static int vfio_pci_add_vma(struct vfio_pci_device *vdev,
+			    struct vm_area_struct *vma)
+{
+	struct vfio_pci_mmap_vma *mmap_vma;
+
+	mmap_vma = kzalloc(sizeof(*mmap_vma), GFP_KERNEL);
+	if (!mmap_vma)
+		return -ENOMEM;
+
+	mmap_vma->vma = vma;
+
+	mutex_lock(&vdev->vma_lock);
+	list_add(&mmap_vma->vma_next, &vdev->vma_list);
+	mutex_unlock(&vdev->vma_lock);
+
+	return 0;
+}
+
+/*
+ * Zap mmaps on open so that we can fault them in on access and therefore
+ * our vma_list only tracks mappings accessed since last zap.
+ */
+static void vfio_pci_mmap_open(struct vm_area_struct *vma)
+{
+	zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
+}
+
+static void vfio_pci_mmap_close(struct vm_area_struct *vma)
+{
+	struct vfio_pci_device *vdev = vma->vm_private_data;
+	struct vfio_pci_mmap_vma *mmap_vma;
+
+	mutex_lock(&vdev->vma_lock);
+	list_for_each_entry(mmap_vma, &vdev->vma_list, vma_next) {
+		if (mmap_vma->vma == vma) {
+			list_del(&mmap_vma->vma_next);
+			kfree(mmap_vma);
+			break;
+		}
+	}
+	mutex_unlock(&vdev->vma_lock);
+}
+
+static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct vfio_pci_device *vdev = vma->vm_private_data;
+
+	if (vfio_pci_add_vma(vdev, vma))
+		return VM_FAULT_OOM;
+
+	if (remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+			    vma->vm_end - vma->vm_start, vma->vm_page_prot))
+		return VM_FAULT_SIGBUS;
+
+	return VM_FAULT_NOPAGE;
+}
+
+static const struct vm_operations_struct vfio_pci_mmap_ops = {
+	.open = vfio_pci_mmap_open,
+	.close = vfio_pci_mmap_close,
+	.fault = vfio_pci_mmap_fault,
+};
+
 static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 {
 	struct vfio_pci_device *vdev = device_data;
@@ -1357,8 +1421,14 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	vma->vm_pgoff = (pci_resource_start(pdev, index) >> PAGE_SHIFT) + pgoff;
 
-	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
-			       req_len, vma->vm_page_prot);
+	/*
+	 * See remap_pfn_range(), called from vfio_pci_fault() but we can't
+	 * change vm_flags within the fault handler.  Set them now.
+	 */
+	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
+	vma->vm_ops = &vfio_pci_mmap_ops;
+
+	return 0;
 }
 
 static void vfio_pci_request(void *device_data, unsigned int count)
@@ -1608,6 +1678,8 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&vdev->irqlock);
 	mutex_init(&vdev->ioeventfds_lock);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
+	mutex_init(&vdev->vma_lock);
+	INIT_LIST_HEAD(&vdev->vma_list);
 
 	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
 	if (ret)
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 36ec69081ecd..9b25f9f6ce1d 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -92,6 +92,11 @@ struct vfio_pci_vf_token {
 	int			users;
 };
 
+struct vfio_pci_mmap_vma {
+	struct vm_area_struct	*vma;
+	struct list_head	vma_next;
+};
+
 struct vfio_pci_device {
 	struct pci_dev		*pdev;
 	void __iomem		*barmap[PCI_STD_NUM_BARS];
@@ -132,6 +137,8 @@ struct vfio_pci_device {
 	struct list_head	ioeventfds_list;
 	struct vfio_pci_vf_token	*vf_token;
 	struct notifier_block	nb;
+	struct mutex		vma_lock;
+	struct list_head	vma_list;
 };
 
 #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)

