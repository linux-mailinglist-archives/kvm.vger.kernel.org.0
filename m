Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81D6A620A62
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 08:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbiKHHjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 02:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbiKHHjg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 02:39:36 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FF110C9
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 23:38:32 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N60M309WJzmVlh;
        Tue,  8 Nov 2022 15:38:07 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 15:38:18 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <alex.williamson@redhat.com>, <maz@kernel.org>
CC:     <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <linuxarm@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH] KVM: Add system call KVM_VERIFY_MSI to verify MSI vector
Date:   Tue, 8 Nov 2022 16:08:57 +0800
Message-ID: <1667894937-175291-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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

Currently the numbers of MSI vectors come from register PCI_MSI_FLAGS
which should be power-of-2, but in some scenaries it is not the same as
the number that driver requires in guest, for example, a PCI driver wants
to allocate 6 MSI vecotrs in guest, but as the limitation, it will allocate
8 MSI vectors. So it requires 8 MSI vectors in qemu while the driver in
guest only wants to allocate 6 MSI vectors.

When GICv4.1 is enabled, we can see some exception print as following for
above scenaro:
vfio-pci 0000:3a:00.1: irq bypass producer (token 000000008f08224d) registration fails:66311

In order to verify whether a MSI vector is valid, add KVM_VERIFY_MSI to do
that. If there is a mapping, return 0, otherwise return negative value.

This is the kernel part of adding system call KVM_VERIFY_MSI.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 arch/arm64/kvm/vgic/vgic-irqfd.c |  5 +++++
 arch/arm64/kvm/vgic/vgic-its.c   | 36 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h       |  1 +
 include/linux/kvm_host.h         |  2 +-
 include/uapi/linux/kvm.h         |  2 ++
 virt/kvm/kvm_main.c              |  9 +++++++++
 6 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-irqfd.c
index 475059b..2312da6 100644
--- a/arch/arm64/kvm/vgic/vgic-irqfd.c
+++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
@@ -98,6 +98,11 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 	return vgic_its_inject_msi(kvm, &msi);
 }
 
+int kvm_verify_msi(struct kvm *kvm, struct kvm_msi *msi)
+{
+	return vgic_its_verify_msi(kvm, msi);
+}
+
 /**
  * kvm_arch_set_irq_inatomic: fast-path for irqfd injection
  */
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 24d7778..cae6183 100644
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
+		ret = -E_ITS_INT_UNMAPPED_INTERRUPT;
+		goto unlock;
+	}
+
+	vcpu = kvm_get_vcpu(kvm, ite->collection->target_addr);
+	if (!vcpu)
+		ret = -E_ITS_INT_UNMAPPED_INTERRUPT;
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
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 32f259f..7923352 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1597,7 +1597,7 @@ void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
 int kvm_request_irq_source_id(struct kvm *kvm);
 void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
 bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
-
+int kvm_verify_msi(struct kvm *kvm, struct kvm_msi *msi);
 /*
  * Returns a pointer to the memslot if it contains gfn.
  * Otherwise returns NULL.
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0d5d441..72b28f8 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1543,6 +1543,8 @@ struct kvm_s390_ucas_mapping {
 #define KVM_PPC_SVM_OFF		  _IO(KVMIO,  0xb3)
 #define KVM_ARM_MTE_COPY_TAGS	  _IOR(KVMIO,  0xb4, struct kvm_arm_copy_mte_tags)
 
+#define KVM_VERIFY_MSI            _IOW(KVMIO,  0xb5, struct kvm_msi)
+
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e30f1b4..439bdd7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4728,6 +4728,15 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = kvm_send_userspace_msi(kvm, &msi);
 		break;
 	}
+	case KVM_VERIFY_MSI: {
+		struct kvm_msi msi;
+
+		r = -EFAULT;
+		if (copy_from_user(&msi, argp, sizeof(msi)))
+			goto out;
+		r = kvm_verify_msi(kvm, &msi);
+		break;
+	}
 #endif
 #ifdef __KVM_HAVE_IRQ_LINE
 	case KVM_IRQ_LINE_STATUS:
-- 
2.8.1

