Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0583634C8E
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 02:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235580AbiKWBNh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 20:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235566AbiKWBND (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 20:13:03 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A2AE2B60
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 17:11:51 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NH2zv1c38zqScm;
        Wed, 23 Nov 2022 09:07:55 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 09:11:49 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <alex.williamson@redhat.com>, <maz@kernel.org>
CC:     <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <linuxarm@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH v2] vfio/pci: Verify each MSI vector to avoid invalid MSI vectors
Date:   Wed, 23 Nov 2022 09:42:36 +0800
Message-ID: <1669167756-196788-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Currently the number of MSI vectors comes from register PCI_MSI_FLAGS
which should be power-of-2 in qemu, in some scenaries it is not the same as
the number that driver requires in guest, for example, a PCI driver wants
to allocate 6 MSI vecotrs in guest, but as the limitation, it will allocate
8 MSI vectors. So it requires 8 MSI vectors in qemu while the driver in
guest only wants to allocate 6 MSI vectors.

When GICv4.1 is enabled, it iterates over all possible MSIs and enable the
forwarding while the guest has only created some of mappings in the virtual
ITS, so some calls fail. The exception print is as following:
vfio-pci 0000:3a:00.1: irq bypass producer (token 000000008f08224d) registration
fails:66311

To avoid the issue, verify each MSI vector, skip some operations such as
request_irq() and irq_bypass_register_producer() for those invalid MSI vectors.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
I reported the issue at the link:
https://lkml.kernel.org/lkml/87cze9lcut.wl-maz@kernel.org/T/

Change Log:
v1 -> v2:
Verify each MSI vector in kernel instead of adding systemcall according to
Mar's suggestion
---
 arch/arm64/kvm/vgic/vgic-irqfd.c  | 13 +++++++++++++
 arch/arm64/kvm/vgic/vgic-its.c    | 36 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h        |  1 +
 drivers/vfio/pci/vfio_pci_intrs.c | 33 +++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h          |  2 ++
 5 files changed, 85 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-irqfd.c
index 475059b..71f6af57 100644
--- a/arch/arm64/kvm/vgic/vgic-irqfd.c
+++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
@@ -98,6 +98,19 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 	return vgic_its_inject_msi(kvm, &msi);
 }
 
+int kvm_verify_msi(struct kvm *kvm,
+		   struct kvm_kernel_irq_routing_entry *irq_entry)
+{
+	struct kvm_msi msi;
+
+	if (!vgic_has_its(kvm))
+		return -ENODEV;
+
+	kvm_populate_msi(irq_entry, &msi);
+
+	return vgic_its_verify_msi(kvm, &msi);
+}
+
 /**
  * kvm_arch_set_irq_inatomic: fast-path for irqfd injection
  */
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 94a666d..8312a4a 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -767,6 +767,42 @@ int vgic_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi)
 	return 0;
 }
 
+int vgic_its_verify_msi(struct kvm *kvm, struct kvm_msi *msi)
+{
+	struct vgic_its *its;
+	struct its_ite *ite;
+	struct kvm_vcpu *vcpu;
+	int ret = 0;
+
+	if (!irqchip_in_kernel(kvm) || (msi->flags & ~KVM_MSI_VALID_DEVID))
+		return -EINVAL;
+
+	if (!vgic_has_its(kvm))
+		return -ENODEV;
+
+	its = vgic_msi_to_its(kvm, msi);
+	if (IS_ERR(its))
+		return PTR_ERR(its);
+
+	mutex_lock(&its->its_lock);
+	if (!its->enabled) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+	ite = find_ite(its, msi->devid, msi->data);
+	if (!ite || !its_is_collection_mapped(ite->collection)) {
+		ret = E_ITS_INT_UNMAPPED_INTERRUPT;
+		goto unlock;
+	}
+
+	vcpu = kvm_get_vcpu(kvm, ite->collection->target_addr);
+	if (!vcpu)
+		ret = E_ITS_INT_UNMAPPED_INTERRUPT;
+unlock:
+	mutex_unlock(&its->its_lock);
+	return ret;
+}
+
 /*
  * Queries the KVM IO bus framework to get the ITS pointer from the given
  * doorbell address.
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 0c8da72..d452150 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -240,6 +240,7 @@ int kvm_vgic_register_its_device(void);
 void vgic_enable_lpis(struct kvm_vcpu *vcpu);
 void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu);
 int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
+int vgic_its_verify_msi(struct kvm *kvm, struct kvm_msi *msi);
 int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
 int vgic_v3_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			 int offset, u32 *val);
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 40c3d7c..3027805 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -19,6 +19,7 @@
 #include <linux/vfio.h>
 #include <linux/wait.h>
 #include <linux/slab.h>
+#include <linux/kvm_irqfd.h>
 
 #include "vfio_pci_priv.h"
 
@@ -315,6 +316,28 @@ static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msi
 	return 0;
 }
 
+static int vfio_pci_verify_msi_entry(struct vfio_pci_core_device *vdev,
+		struct eventfd_ctx *trigger)
+{
+	struct kvm *kvm = vdev->vdev.kvm;
+	struct kvm_kernel_irqfd *tmp;
+	struct kvm_kernel_irq_routing_entry irq_entry;
+	int ret = -ENODEV;
+
+	spin_lock_irq(&kvm->irqfds.lock);
+	list_for_each_entry(tmp, &kvm->irqfds.items, list) {
+		if (trigger == tmp->eventfd) {
+			ret = 0;
+			break;
+		}
+	}
+	spin_unlock_irq(&kvm->irqfds.lock);
+	if (ret)
+		return ret;
+	irq_entry = tmp->irq_entry;
+	return kvm_verify_msi(kvm, &irq_entry);
+}
+
 static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 				      int vector, int fd, bool msix)
 {
@@ -355,6 +378,16 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 		return PTR_ERR(trigger);
 	}
 
+	if (!msix) {
+		ret = vfio_pci_verify_msi_entry(vdev, trigger);
+		if (ret) {
+			kfree(vdev->ctx[vector].name);
+			eventfd_ctx_put(trigger);
+			if (ret > 0)
+				ret = 0;
+			return ret;
+		}
+	}
 	/*
 	 * The MSIx vector table resides in device memory which may be cleared
 	 * via backdoor resets. We don't allow direct access to the vector
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1cd9a22..3c8f22a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1611,6 +1611,8 @@ void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
 int kvm_request_irq_source_id(struct kvm *kvm);
 void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
 bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
+int kvm_verify_msi(struct kvm *kvm,
+		   struct kvm_kernel_irq_routing_entry *irq_entry);
 
 /*
  * Returns a pointer to the memslot if it contains gfn.
-- 
2.8.1

