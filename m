Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D58D620A6D
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 08:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbiKHHkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 02:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233554AbiKHHkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 02:40:18 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934F5BEA
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 23:39:58 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N60Nh0tFVzHvkt;
        Tue,  8 Nov 2022 15:39:32 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 15:39:55 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <alex.williamson@redhat.com>, <maz@kernel.org>
CC:     <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <linuxarm@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH] vfio/pci: Add system call KVM_VERIFY_MSI to verify every MSI vector
Date:   Tue, 8 Nov 2022 16:10:45 +0800
Message-ID: <1667895045-175508-1-git-send-email-chenxiang66@hisilicon.com>
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

To avoid the issue, add system call KVM_VERIFY_MSI to verify whether every
MSI vecotor is valid and adjust the numver of MSI vectors.

This is qemu part of adding system call KVM_VERIFY_MSI.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 accel/kvm/kvm-all.c       | 19 +++++++++++++++++++
 hw/vfio/pci.c             | 13 +++++++++++++
 include/sysemu/kvm.h      |  2 ++
 linux-headers/linux/kvm.h |  1 +
 4 files changed, 35 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f99b0be..19c8b84 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1918,6 +1918,25 @@ int kvm_irqchip_send_msi(KVMState *s, MSIMessage msg)
     return kvm_set_irq(s, route->kroute.gsi, 1);
 }
 
+int kvm_irqchip_verify_msi_route(KVMState *s, int vector, PCIDevice *dev)
+{
+    if (pci_available && dev && kvm_msi_devid_required()) {
+	MSIMessage msg = {0, 0};
+	struct kvm_msi msi;
+
+	msg = pci_get_msi_message(dev, vector);
+	msi.address_lo = (uint32_t)msg.address;
+	msi.address_hi = msg.address >> 32;
+	msi.devid = pci_requester_id(dev);
+	msi.data = le32_to_cpu(msg.data);
+	msi.flags = KVM_MSI_VALID_DEVID;
+	memset(msi.pad, 0, sizeof(msi.pad));
+
+	return kvm_vm_ioctl(s, KVM_VERIFY_MSI, &msi);
+    }
+    return 0;
+}
+
 int kvm_irqchip_add_msi_route(KVMRouteChange *c, int vector, PCIDevice *dev)
 {
     struct kvm_irq_routing_entry kroute = {};
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 939dcc3..8dae0e4 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -660,6 +660,7 @@ static void vfio_msix_enable(VFIOPCIDevice *vdev)
 static void vfio_msi_enable(VFIOPCIDevice *vdev)
 {
     int ret, i;
+    int msi_invalid = 0;
 
     vfio_disable_interrupts(vdev);
 
@@ -671,6 +672,18 @@ static void vfio_msi_enable(VFIOPCIDevice *vdev)
     vfio_prepare_kvm_msi_virq_batch(vdev);
 
     vdev->nr_vectors = msi_nr_vectors_allocated(&vdev->pdev);
+
+    /*
+     * Verify whether every msi interrupt is valid as the number of
+     * MSI vectors comes from PCI device registers which may be not the
+     * same as the number of vectors that driver requires.
+     */
+    for (i = 0; i < vdev->nr_vectors; i++) {
+	ret = kvm_irqchip_verify_msi_route(kvm_state, i, &vdev->pdev);
+	if (ret < 0)
+	    msi_invalid++;
+    }
+    vdev->nr_vectors -= msi_invalid;
 retry:
     vdev->msi_vectors = g_new0(VFIOMSIVector, vdev->nr_vectors);
 
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index e9a97ed..aca6e5b 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -482,6 +482,8 @@ void kvm_cpu_synchronize_state(CPUState *cpu);
 
 void kvm_init_cpu_signals(CPUState *cpu);
 
+int kvm_irqchip_verify_msi_route(KVMState *s, int vector, PCIDevice *dev);
+
 /**
  * kvm_irqchip_add_msi_route - Add MSI route for specific vector
  * @c:      KVMRouteChange instance.
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index ebdafa5..ac59350 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1540,6 +1540,7 @@ struct kvm_s390_ucas_mapping {
 #define KVM_PPC_SVM_OFF		  _IO(KVMIO,  0xb3)
 #define KVM_ARM_MTE_COPY_TAGS	  _IOR(KVMIO,  0xb4, struct kvm_arm_copy_mte_tags)
 
+#define KVM_VERIFY_MSI            _IOW(KVMIO,  0xb5, struct kvm_msi)
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
 
-- 
2.8.1

