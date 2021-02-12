Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A50A31A564
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 20:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbhBLT3m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 14:29:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52449 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232025AbhBLT30 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 14:29:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613158079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tHqPKCx9QpsLepzPpPyRSDHkZRYjZbHiZsF2Y6qelmQ=;
        b=EPK9fHuMGTjUTp7jUVHrjR1qaddRNxTbg0COHsKJzLg38slRD+7YrBhrPYifMJ7JimHNCL
        KyQb8TeitorpCFpXOdN/s2/HWI8dDrgh6EXk51LKYVwi0lpBg4t9miYp3P9S8DWSZ1d0qH
        3o3Lb4q8dUjQCDHLoCcPJYrNXUp2dcY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-Ws3A7GDeOSaHSXtJczLUCA-1; Fri, 12 Feb 2021 14:27:57 -0500
X-MC-Unique: Ws3A7GDeOSaHSXtJczLUCA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D5E3107ACE6;
        Fri, 12 Feb 2021 19:27:56 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E60A760BE5;
        Fri, 12 Feb 2021 19:27:55 +0000 (UTC)
Subject: [PATCH 2/3] vfio/pci: Implement vm_ops registration
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Fri, 12 Feb 2021 12:27:55 -0700
Message-ID: <161315807103.7320.16122193489358171384.stgit@gimli.home>
In-Reply-To: <161315658638.7320.9686203003395567745.stgit@gimli.home>
References: <161315658638.7320.9686203003395567745.stgit@gimli.home>
User-Agent: StGit/0.21-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio-pci vfio bus driver implements a vm_operations_struct for
managing mmaps to device BARs, therefore given a vma with matching
vm_ops we can create a reference using the existing vfio external user
interfaces and register the provided notifier to receive callbacks
relative to the device.  The close notifier is implemented for when
the device is released, rather than closing the vma to avoid
possibly breaking userspace (ie. mmap -> dma map -> munmap is
currently allowed and maintains the dma mapping to the device).

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/Kconfig            |    1 
 drivers/vfio/pci/vfio_pci.c         |   87 +++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h |    1 
 3 files changed, 89 insertions(+)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 40a223381ab6..4e3059d6206c 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -4,6 +4,7 @@ config VFIO_PCI
 	depends on VFIO && PCI && EVENTFD
 	select VFIO_VIRQFD
 	select IRQ_BYPASS_MANAGER
+	select SRCU
 	help
 	  Support for the PCI VFIO bus driver.  This is required to make
 	  use of PCI drivers using the VFIO framework.
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 706de3ef94bb..dcbdaece80f8 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -560,6 +560,8 @@ static void vfio_pci_release(void *device_data)
 	mutex_lock(&vdev->reflck->lock);
 
 	if (!(--vdev->refcnt)) {
+		srcu_notifier_call_chain(&vdev->vma_notifier,
+					 VFIO_VMA_NOTIFY_CLOSE, NULL);
 		vfio_pci_vf_token_user_add(vdev, -1);
 		vfio_spapr_pci_eeh_release(vdev->pdev);
 		vfio_pci_disable(vdev);
@@ -1969,6 +1971,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mutex_init(&vdev->vma_lock);
 	INIT_LIST_HEAD(&vdev->vma_list);
 	init_rwsem(&vdev->memory_lock);
+	srcu_init_notifier_head(&vdev->vma_notifier);
 
 	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
 	if (ret)
@@ -2362,6 +2365,7 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
 
 static void __exit vfio_pci_cleanup(void)
 {
+	vfio_unregister_vma_ops(&vfio_pci_mmap_ops);
 	pci_unregister_driver(&vfio_pci_driver);
 	vfio_pci_uninit_perm_bits();
 }
@@ -2407,6 +2411,81 @@ static void __init vfio_pci_fill_ids(void)
 	}
 }
 
+struct vfio_pci_vma_obj {
+	struct vfio_pci_device *vdev;
+	struct vfio_group *group;
+	struct vfio_device *device;
+	struct notifier_block *nb;
+};
+
+static void *vfio_pci_register_vma_notifier(struct vm_area_struct *vma,
+					    struct notifier_block *nb)
+{
+	struct vfio_pci_device *vdev = vma->vm_private_data;
+	struct vfio_pci_vma_obj *obj;
+	struct vfio_group *group;
+	struct vfio_device *device;
+	int ret;
+
+	if (!vdev || vma->vm_ops != &vfio_pci_mmap_ops)
+		return ERR_PTR(-EINVAL);
+
+	obj = kmalloc(sizeof(*obj), GFP_KERNEL);
+	if (!obj)
+		return ERR_PTR(-ENOMEM);
+
+	/*
+	 * Get a group and container reference, this prevents the container
+	 * from being torn down while this vma is mapped, ie. device stays
+	 * isolated.
+	 *
+	 * NB. The container must be torn down on device close without
+	 * explicit unmaps, therefore we must notify on close.
+	 */
+	group = vfio_group_get_external_user_from_dev(&vdev->pdev->dev);
+	if (IS_ERR(group)) {
+		kfree(obj);
+		return group;
+	}
+
+	/* Also need device reference to prevent unbind */
+	device = vfio_device_get_from_dev(&vdev->pdev->dev);
+	if (IS_ERR(device)) {
+		vfio_group_put_external_user(group);
+		kfree(obj);
+		return device;
+	}
+
+	/*
+	 * Use the srcu notifier chain variant to avoid AB-BA locking issues
+	 * with the caller, ex. iommu->lock vs nh->rwsem
+	 */
+	ret = srcu_notifier_chain_register(&vdev->vma_notifier, nb);
+	if (ret) {
+		vfio_device_put(device);
+		vfio_group_put_external_user(group);
+		kfree(obj);
+		return ERR_PTR(ret);
+	}
+
+	obj->vdev = vdev;
+	obj->group = group;
+	obj->device = device;
+	obj->nb = nb;
+
+	return obj;
+}
+
+static void vfio_pci_unregister_vma_notifier(void *opaque)
+{
+	struct vfio_pci_vma_obj *obj = opaque;
+
+	srcu_notifier_chain_unregister(&obj->vdev->vma_notifier, obj->nb);
+	vfio_device_put(obj->device);
+	vfio_group_put_external_user(obj->group);
+	kfree(obj);
+}
+
 static int __init vfio_pci_init(void)
 {
 	int ret;
@@ -2421,6 +2500,12 @@ static int __init vfio_pci_init(void)
 	if (ret)
 		goto out_driver;
 
+	ret = vfio_register_vma_ops(&vfio_pci_mmap_ops,
+				    vfio_pci_register_vma_notifier,
+				    vfio_pci_unregister_vma_notifier);
+	if (ret)
+		goto out_vma;
+
 	vfio_pci_fill_ids();
 
 	if (disable_denylist)
@@ -2428,6 +2513,8 @@ static int __init vfio_pci_init(void)
 
 	return 0;
 
+out_vma:
+	pci_unregister_driver(&vfio_pci_driver);
 out_driver:
 	vfio_pci_uninit_perm_bits();
 	return ret;
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 5c90e560c5c7..12c61d099d1a 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -142,6 +142,7 @@ struct vfio_pci_device {
 	struct mutex		vma_lock;
 	struct list_head	vma_list;
 	struct rw_semaphore	memory_lock;
+	struct srcu_notifier_head	vma_notifier;
 };
 
 #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)

