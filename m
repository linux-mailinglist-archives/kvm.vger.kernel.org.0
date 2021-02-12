Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD6931A562
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 20:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbhBLT3V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 14:29:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54741 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230390AbhBLT3Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 14:29:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613158070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+QyjDl1YGTxR6RiVnlw4Q0RJP2vN/bwyFH6oNtXuIi0=;
        b=cCKe11xdX7F/1f+a5TwW6iXpk1UzfkRKtNkiFcohzz82mifwnCMvpSIZeMXJH3uaBX4poi
        bb205QP1P8cDFVXEghejLGxQ2EQTml1imwR8TLOXV+VCeQWrbSuPLWz+JusSdsREBgox9c
        TnBv9OoKlliFIsmmG5mcEfXu8epGj5Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-GIBOazs_MQu_WbG5UIIbeA-1; Fri, 12 Feb 2021 14:27:47 -0500
X-MC-Unique: GIBOazs_MQu_WbG5UIIbeA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB2E1C7403;
        Fri, 12 Feb 2021 19:27:45 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A95360BE5;
        Fri, 12 Feb 2021 19:27:39 +0000 (UTC)
Subject: [PATCH 1/3] vfio: Introduce vma ops registration and notifier
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Fri, 12 Feb 2021 12:27:39 -0700
Message-ID: <161315805248.7320.13358719859656681660.stgit@gimli.home>
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

Create an interface through vfio-core where a vfio bus driver (ex.
vfio-pci) can register the vm_operations_struct it uses to map device
memory, along with a set of registration callbacks.  This allows
vfio-core to expose interfaces for IOMMU backends to match a
vm_area_struct to a bus driver and register a notifier for relavant
changes to the device mapping.  For now we define only a notifier
action for closing the device.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio.c  |  120 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h |   20 ++++++++
 2 files changed, 140 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 38779e6fd80c..568f5e37a95f 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -47,6 +47,8 @@ static struct vfio {
 	struct cdev			group_cdev;
 	dev_t				group_devt;
 	wait_queue_head_t		release_q;
+	struct list_head		vm_ops_list;
+	struct mutex			vm_ops_lock;
 } vfio;
 
 struct vfio_iommu_driver {
@@ -2354,6 +2356,121 @@ struct iommu_domain *vfio_group_iommu_domain(struct vfio_group *group)
 }
 EXPORT_SYMBOL_GPL(vfio_group_iommu_domain);
 
+struct vfio_vma_ops {
+	const struct vm_operations_struct	*vm_ops;
+	vfio_register_vma_nb_t			*reg_fn;
+	vfio_unregister_vma_nb_t		*unreg_fn;
+	struct list_head			next;
+};
+
+int vfio_register_vma_ops(const struct vm_operations_struct *vm_ops,
+			  vfio_register_vma_nb_t *reg_fn,
+			  vfio_unregister_vma_nb_t *unreg_fn)
+{
+	struct vfio_vma_ops *ops;
+	int ret = 0;
+
+	mutex_lock(&vfio.vm_ops_lock);
+	list_for_each_entry(ops, &vfio.vm_ops_list, next) {
+		if (ops->vm_ops == vm_ops) {
+			ret = -EEXIST;
+			goto out;
+		}
+	}
+
+	ops = kmalloc(sizeof(*ops), GFP_KERNEL);
+	if (!ops) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ops->vm_ops = vm_ops;
+	ops->reg_fn = reg_fn;
+	ops->unreg_fn = unreg_fn;
+
+	list_add(&ops->next, &vfio.vm_ops_list);
+out:
+	mutex_unlock(&vfio.vm_ops_lock);
+	return ret;
+
+}
+EXPORT_SYMBOL_GPL(vfio_register_vma_ops);
+
+void vfio_unregister_vma_ops(const struct vm_operations_struct *vm_ops)
+{
+	struct vfio_vma_ops *ops;
+
+	mutex_lock(&vfio.vm_ops_lock);
+	list_for_each_entry(ops, &vfio.vm_ops_list, next) {
+		if (ops->vm_ops == vm_ops) {
+			list_del(&ops->next);
+			kfree(ops);
+			break;
+		}
+	}
+	mutex_unlock(&vfio.vm_ops_lock);
+}
+EXPORT_SYMBOL_GPL(vfio_unregister_vma_ops);
+
+struct vfio_vma_obj {
+	const struct vm_operations_struct *vm_ops;
+	void *opaque;
+};
+
+void *vfio_register_vma_nb(struct vm_area_struct *vma,
+			   struct notifier_block *nb)
+{
+	struct vfio_vma_ops *ops;
+	struct vfio_vma_obj *obj = ERR_PTR(-ENODEV);
+
+	mutex_lock(&vfio.vm_ops_lock);
+	list_for_each_entry(ops, &vfio.vm_ops_list, next) {
+		if (ops->vm_ops == vma->vm_ops) {
+			void *opaque;
+
+			obj = kmalloc(sizeof(*obj), GFP_KERNEL);
+			if (!obj) {
+				obj = ERR_PTR(-ENOMEM);
+				break;
+			}
+
+			obj->vm_ops = ops->vm_ops;
+
+			opaque = ops->reg_fn(vma, nb);
+			if (IS_ERR(opaque)) {
+				kfree(obj);
+				obj = opaque;
+			} else {
+				obj->opaque = opaque;
+			}
+
+			break;
+		}
+	}
+	mutex_unlock(&vfio.vm_ops_lock);
+
+	return obj;
+}
+EXPORT_SYMBOL_GPL(vfio_register_vma_nb);
+
+void vfio_unregister_vma_nb(void *opaque)
+{
+	struct vfio_vma_obj *obj = opaque;
+	struct vfio_vma_ops *ops;
+
+	mutex_lock(&vfio.vm_ops_lock);
+	list_for_each_entry(ops, &vfio.vm_ops_list, next) {
+		if (ops->vm_ops == obj->vm_ops) {
+			ops->unreg_fn(obj->opaque);
+			break;
+		}
+	}
+	mutex_unlock(&vfio.vm_ops_lock);
+
+	kfree(obj);
+}
+EXPORT_SYMBOL_GPL(vfio_unregister_vma_nb);
+
 /**
  * Module/class support
  */
@@ -2377,8 +2494,10 @@ static int __init vfio_init(void)
 	idr_init(&vfio.group_idr);
 	mutex_init(&vfio.group_lock);
 	mutex_init(&vfio.iommu_drivers_lock);
+	mutex_init(&vfio.vm_ops_lock);
 	INIT_LIST_HEAD(&vfio.group_list);
 	INIT_LIST_HEAD(&vfio.iommu_drivers_list);
+	INIT_LIST_HEAD(&vfio.vm_ops_list);
 	init_waitqueue_head(&vfio.release_q);
 
 	ret = misc_register(&vfio_dev);
@@ -2425,6 +2544,7 @@ static int __init vfio_init(void)
 static void __exit vfio_cleanup(void)
 {
 	WARN_ON(!list_empty(&vfio.group_list));
+	WARN_ON(!list_empty(&vfio.vm_ops_list));
 
 #ifdef CONFIG_VFIO_NOIOMMU
 	vfio_unregister_iommu_driver(&vfio_noiommu_ops);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index b7e18bde5aa8..1b5c6179d869 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -137,6 +137,26 @@ extern int vfio_dma_rw(struct vfio_group *group, dma_addr_t user_iova,
 
 extern struct iommu_domain *vfio_group_iommu_domain(struct vfio_group *group);
 
+typedef void *(vfio_register_vma_nb_t)(struct vm_area_struct *vma,
+				       struct notifier_block *nb);
+typedef void (vfio_unregister_vma_nb_t)(void *opaque);
+
+extern int vfio_register_vma_ops(const struct vm_operations_struct *vm_ops,
+				 vfio_register_vma_nb_t *reg_fn,
+				 vfio_unregister_vma_nb_t *unreg_fn);
+
+extern void vfio_unregister_vma_ops(const struct vm_operations_struct *vm_ops);
+
+enum vfio_vma_notify_type {
+	VFIO_VMA_NOTIFY_CLOSE = 0,
+};
+
+extern void *vfio_register_vma_nb(struct vm_area_struct *vma,
+				  struct notifier_block *nb);
+
+extern void vfio_unregister_vma_nb(void *opaque);
+
+
 /* each type has independent events */
 enum vfio_notify_type {
 	VFIO_IOMMU_NOTIFY = 0,

