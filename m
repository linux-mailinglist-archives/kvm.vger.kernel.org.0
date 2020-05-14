Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5560A1D36FE
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 18:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgENQwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 12:52:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27717 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726133AbgENQwT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 12:52:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589475138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GJr5VOZxnNPDuW/xaOk1/yOTjDcTO3AEiWZBbm2RhiE=;
        b=PGGkY3t6XP8Jve/i7Pz1E1eKhfb27J4R9Mc2DHWxT2hYsgps/Ug0RrsBq9pJFPBBmy082g
        R2hShQzpmoy9LjjhuPk42eBBwnJHsMe26xFD4XW0QUHy6OCkJVxRy3eOSg1WBUTn/8JdXG
        tbg0lhWp4MA1X/BEfOKjy/skfR6oJrQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-e2QCNjFQNPitQcJmcn4oCA-1; Thu, 14 May 2020 12:52:16 -0400
X-MC-Unique: e2QCNjFQNPitQcJmcn4oCA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 776D180183C;
        Thu, 14 May 2020 16:52:15 +0000 (UTC)
Received: from gimli.home (ovpn-113-111.phx2.redhat.com [10.3.113.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D9BF15D9CA;
        Thu, 14 May 2020 16:52:09 +0000 (UTC)
Subject: [PATCH 2/2] vfio: Introduce strict PFNMAP mappings
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, cohuck@redhat.com, jgg@ziepe.ca,
        peterx@redhat.com
Date:   Thu, 14 May 2020 10:52:09 -0600
Message-ID: <158947512947.12590.4756232870747830161.stgit@gimli.home>
In-Reply-To: <158947414729.12590.4345248265094886807.stgit@gimli.home>
References: <158947414729.12590.4345248265094886807.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We can't pin PFNMAP IOMMU mappings like we can standard page-backed
mappings, therefore without an invalidation mechanism we can't know
if we should have revoked a user's mapping.  Now that we have an
invalidation callback mechanism we can create an interface for vfio
bus drivers to indicate their support for invalidation by registering
supported vm_ops functions with vfio-core.  A vfio IOMMU backend
driver can then test a vma against the registered vm_ops with this
support to determine whether to allow such a mapping.  The type1
backend then adopts a new 'strict_mmio_maps' module option, enabled
by default, restricting IOMMU mapping of PFNMAP vmas to only those
supporting invalidation callbacks.  vfio-pci is updated to register
vfio_pci_mmap_ops as supporting this feature.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c     |    7 ++++
 drivers/vfio/vfio.c             |   62 +++++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c |    9 +++++-
 include/linux/vfio.h            |    4 +++
 4 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 100fe5f6bc22..dbfe6a11aa74 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -2281,6 +2281,7 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
 
 static void __exit vfio_pci_cleanup(void)
 {
+	vfio_unregister_vma_inv_ops(&vfio_pci_mmap_ops);
 	pci_unregister_driver(&vfio_pci_driver);
 	vfio_pci_uninit_perm_bits();
 }
@@ -2340,10 +2341,16 @@ static int __init vfio_pci_init(void)
 	if (ret)
 		goto out_driver;
 
+	ret = vfio_register_vma_inv_ops(&vfio_pci_mmap_ops);
+	if (ret)
+		goto out_inv_ops;
+
 	vfio_pci_fill_ids();
 
 	return 0;
 
+out_inv_ops:
+	pci_unregister_driver(&vfio_pci_driver);
 out_driver:
 	vfio_pci_uninit_perm_bits();
 	return ret;
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 0fff057b7cd9..0f0a9d3b38aa 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -47,6 +47,8 @@ static struct vfio {
 	struct cdev			group_cdev;
 	dev_t				group_devt;
 	wait_queue_head_t		release_q;
+	struct list_head		vma_inv_ops_list;
+	struct mutex			vma_inv_ops_lock;
 } vfio;
 
 struct vfio_iommu_driver {
@@ -98,6 +100,11 @@ struct vfio_device {
 	void				*device_data;
 };
 
+struct vfio_vma_inv_ops {
+	const struct vm_operations_struct	*ops;
+	struct list_head			ops_next;
+};
+
 #ifdef CONFIG_VFIO_NOIOMMU
 static bool noiommu __read_mostly;
 module_param_named(enable_unsafe_noiommu_mode,
@@ -2332,6 +2339,58 @@ int vfio_unregister_notifier(struct device *dev, enum vfio_notify_type type,
 }
 EXPORT_SYMBOL(vfio_unregister_notifier);
 
+int vfio_register_vma_inv_ops(const struct vm_operations_struct *ops)
+{
+	struct vfio_vma_inv_ops *inv_ops;
+
+	inv_ops = kmalloc(sizeof(*inv_ops), GFP_KERNEL);
+	if (!inv_ops)
+		return -ENOMEM;
+
+	inv_ops->ops = ops;
+
+	mutex_lock(&vfio.vma_inv_ops_lock);
+	list_add(&inv_ops->ops_next, &vfio.vma_inv_ops_list);
+	mutex_unlock(&vfio.vma_inv_ops_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(vfio_register_vma_inv_ops);
+
+void vfio_unregister_vma_inv_ops(const struct vm_operations_struct *ops)
+{
+	struct vfio_vma_inv_ops *inv_ops;
+
+	mutex_lock(&vfio.vma_inv_ops_lock);
+	list_for_each_entry(inv_ops, &vfio.vma_inv_ops_list, ops_next) {
+		if (inv_ops->ops == ops) {
+			list_del(&inv_ops->ops_next);
+			kfree(inv_ops);
+			break;
+		}
+	}
+	mutex_unlock(&vfio.vma_inv_ops_lock);
+}
+EXPORT_SYMBOL(vfio_unregister_vma_inv_ops);
+
+bool vfio_vma_has_inv_ops(struct vm_area_struct *vma)
+{
+	struct vfio_vma_inv_ops *inv_ops;
+	bool ret = false;
+
+	mutex_lock(&vfio.vma_inv_ops_lock);
+	list_for_each_entry(inv_ops, &vfio.vma_inv_ops_list, ops_next) {
+		if (inv_ops->ops == vma->vm_ops) {
+			ret = true;
+			break;
+		}
+	}
+	mutex_unlock(&vfio.vma_inv_ops_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_vma_has_inv_ops);
+
 /**
  * Module/class support
  */
@@ -2355,8 +2414,10 @@ static int __init vfio_init(void)
 	idr_init(&vfio.group_idr);
 	mutex_init(&vfio.group_lock);
 	mutex_init(&vfio.iommu_drivers_lock);
+	mutex_init(&vfio.vma_inv_ops_lock);
 	INIT_LIST_HEAD(&vfio.group_list);
 	INIT_LIST_HEAD(&vfio.iommu_drivers_list);
+	INIT_LIST_HEAD(&vfio.vma_inv_ops_list);
 	init_waitqueue_head(&vfio.release_q);
 
 	ret = misc_register(&vfio_dev);
@@ -2403,6 +2464,7 @@ static int __init vfio_init(void)
 static void __exit vfio_cleanup(void)
 {
 	WARN_ON(!list_empty(&vfio.group_list));
+	WARN_ON(!list_empty(&vfio.vma_inv_ops_list));
 
 #ifdef CONFIG_VFIO_NOIOMMU
 	vfio_unregister_iommu_driver(&vfio_noiommu_ops);
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 62ba6bd8a486..8d6286d89230 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -61,6 +61,11 @@ module_param_named(dma_entry_limit, dma_entry_limit, uint, 0644);
 MODULE_PARM_DESC(dma_entry_limit,
 		 "Maximum number of user DMA mappings per container (65535).");
 
+static bool strict_mmio_maps = true;
+module_param_named(strict_mmio_maps, strict_mmio_maps, bool, 0644);
+MODULE_PARM_DESC(strict_mmio_maps,
+		 "Restrict DMA mappings of MMIO to those provided by vfio bus drivers supporting invalidation (true).");
+
 struct vfio_iommu {
 	struct list_head	domain_list;
 	struct list_head	iova_list;
@@ -375,7 +380,9 @@ static int vaddr_get_pfn(struct vfio_dma *dma, struct mm_struct *mm,
 
 	if (vma && vma->vm_flags & VM_PFNMAP) {
 		if ((dma->pfnmap_vma && dma->pfnmap_vma != vma) ||
-		    (!dma->pfnmap_vma && vaddr != dma->vaddr)) {
+		    (!dma->pfnmap_vma && (vaddr != dma->vaddr ||
+					  (strict_mmio_maps &&
+					   !vfio_vma_has_inv_ops(vma))))) {
 			ret = -EPERM;
 			goto done;
 		}
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 13abfecc1530..edc393f1287d 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -149,6 +149,10 @@ extern int vfio_unregister_notifier(struct device *dev,
 				    enum vfio_notify_type type,
 				    struct notifier_block *nb);
 
+extern int vfio_register_vma_inv_ops(const struct vm_operations_struct *ops);
+extern void vfio_unregister_vma_inv_ops(const struct vm_operations_struct *ops);
+extern bool vfio_vma_has_inv_ops(struct vm_area_struct *vma);
+
 struct kvm;
 extern void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm);
 

