Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F39647143C
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 15:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbhLKO1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Dec 2021 09:27:20 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:32912 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhLKO1T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Dec 2021 09:27:19 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JB9865f6Lzcbl1;
        Sat, 11 Dec 2021 22:27:02 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 11 Dec 2021 22:27:17 +0800
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 11 Dec 2021 22:27:16 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <pbonzini@redhat.com>, <alex.williamson@redhat.com>,
        <mst@redhat.com>, <mtosatti@redhat.com>
CC:     <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <arei.gonglei@huawei.com>, Longpeng <longpeng2@huawei.com>
Subject: [PATCH 2/2] kvm/msi: do explicit commit when adding msi routes
Date:   Sat, 11 Dec 2021 22:27:03 +0800
Message-ID: <20211211142703.1941-3-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
In-Reply-To: <20211211142703.1941-1-longpeng2@huawei.com>
References: <20211211142703.1941-1-longpeng2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml100016.china.huawei.com (7.185.36.216)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Longpeng <longpeng2@huawei.com>

We invoke commit operation for each addition to msi route table, this
is not efficient if we are adding lots of routes in some cases (e.g.
the resume phase of vfio migration [1]).

This patch moves the call to kvm_irqchip_commit_routes() to the callers,
so the callers can decide how to optimize.

[1] https://lists.gnu.org/archive/html/qemu-devel/2021-11/msg00967.html

Signed-off-by: Longpeng <longpeng2@huawei.com>
---
 accel/kvm/kvm-all.c    | 7 ++++---
 accel/stubs/kvm-stub.c | 2 +-
 hw/misc/ivshmem.c      | 5 ++++-
 hw/vfio/pci.c          | 5 ++++-
 hw/virtio/virtio-pci.c | 4 +++-
 include/sysemu/kvm.h   | 4 ++--
 target/i386/kvm/kvm.c  | 4 +++-
 7 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index eecd8031cf..ba35477272 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1955,10 +1955,11 @@ int kvm_irqchip_send_msi(KVMState *s, MSIMessage msg)
     return kvm_set_irq(s, route->kroute.gsi, 1);
 }
 
-int kvm_irqchip_add_msi_route(KVMState *s, int vector, PCIDevice *dev)
+int kvm_irqchip_add_msi_route(KVMRouteChange *c, int vector, PCIDevice *dev)
 {
     struct kvm_irq_routing_entry kroute = {};
     int virq;
+    KVMState *s = c->s;
     MSIMessage msg = {0, 0};
 
     if (pci_available && dev) {
@@ -1998,7 +1999,7 @@ int kvm_irqchip_add_msi_route(KVMState *s, int vector, PCIDevice *dev)
 
     kvm_add_routing_entry(s, &kroute);
     kvm_arch_add_msi_route_post(&kroute, vector, dev);
-    kvm_irqchip_commit_routes(s);
+    c->changes++;
 
     return virq;
 }
@@ -2156,7 +2157,7 @@ int kvm_irqchip_send_msi(KVMState *s, MSIMessage msg)
     abort();
 }
 
-int kvm_irqchip_add_msi_route(KVMState *s, int vector, PCIDevice *dev)
+int kvm_irqchip_add_msi_route(KVMRouteChange *c, int vector, PCIDevice *dev)
 {
     return -ENOSYS;
 }
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index 5319573e00..ae6e8e9aa7 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -81,7 +81,7 @@ int kvm_on_sigbus(int code, void *addr)
 }
 
 #ifndef CONFIG_USER_ONLY
-int kvm_irqchip_add_msi_route(KVMState *s, int vector, PCIDevice *dev)
+int kvm_irqchip_add_msi_route(KVMRouteChange *c, int vector, PCIDevice *dev)
 {
     return -ENOSYS;
 }
diff --git a/hw/misc/ivshmem.c b/hw/misc/ivshmem.c
index 1ba4a98377..5122e91b72 100644
--- a/hw/misc/ivshmem.c
+++ b/hw/misc/ivshmem.c
@@ -424,16 +424,19 @@ static void ivshmem_add_kvm_msi_virq(IVShmemState *s, int vector,
                                      Error **errp)
 {
     PCIDevice *pdev = PCI_DEVICE(s);
+    KVMRouteChange c;
     int ret;
 
     IVSHMEM_DPRINTF("ivshmem_add_kvm_msi_virq vector:%d\n", vector);
     assert(!s->msi_vectors[vector].pdev);
 
-    ret = kvm_irqchip_add_msi_route(kvm_state, vector, pdev);
+    c = kvm_irqchip_begin_route_changes(kvm_state);
+    ret = kvm_irqchip_add_msi_route(&c, vector, pdev);
     if (ret < 0) {
         error_setg(errp, "kvm_irqchip_add_msi_route failed");
         return;
     }
+    kvm_irqchip_commit_route_changes(&c);
 
     s->msi_vectors[vector].virq = ret;
     s->msi_vectors[vector].pdev = pdev;
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 7b45353ce2..d07a4e99b1 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -412,6 +412,7 @@ static int vfio_enable_vectors(VFIOPCIDevice *vdev, bool msix)
 static void vfio_add_kvm_msi_virq(VFIOPCIDevice *vdev, VFIOMSIVector *vector,
                                   int vector_n, bool msix)
 {
+    KVMRouteChange c;
     int virq;
 
     if ((msix && vdev->no_kvm_msix) || (!msix && vdev->no_kvm_msi)) {
@@ -422,11 +423,13 @@ static void vfio_add_kvm_msi_virq(VFIOPCIDevice *vdev, VFIOMSIVector *vector,
         return;
     }
 
-    virq = kvm_irqchip_add_msi_route(kvm_state, vector_n, &vdev->pdev);
+    c = kvm_irqchip_begin_route_changes(kvm_state);
+    virq = kvm_irqchip_add_msi_route(&c, vector_n, &vdev->pdev);
     if (virq < 0) {
         event_notifier_cleanup(&vector->kvm_interrupt);
         return;
     }
+    kvm_irqchip_commit_route_changes(&c);
 
     if (kvm_irqchip_add_irqfd_notifier_gsi(kvm_state, &vector->kvm_interrupt,
                                        NULL, virq) < 0) {
diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
index 750aa47ec1..fc648c1e54 100644
--- a/hw/virtio/virtio-pci.c
+++ b/hw/virtio/virtio-pci.c
@@ -684,10 +684,12 @@ static int kvm_virtio_pci_vq_vector_use(VirtIOPCIProxy *proxy,
     int ret;
 
     if (irqfd->users == 0) {
-        ret = kvm_irqchip_add_msi_route(kvm_state, vector, &proxy->pci_dev);
+        KVMRouteChange c = kvm_irqchip_begin_route_changes(kvm_state);
+        ret = kvm_irqchip_add_msi_route(&c, vector, &proxy->pci_dev);
         if (ret < 0) {
             return ret;
         }
+        kvm_irqchip_commit_route_changes(&c);
         irqfd->virq = ret;
     }
     irqfd->users++;
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index ef143c2da4..03cb82a475 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -471,7 +471,7 @@ void kvm_init_cpu_signals(CPUState *cpu);
 
 /**
  * kvm_irqchip_add_msi_route - Add MSI route for specific vector
- * @s:      KVM state
+ * @c:      KVMRouteChange instance.
  * @vector: which vector to add. This can be either MSI/MSIX
  *          vector. The function will automatically detect whether
  *          MSI/MSIX is enabled, and fetch corresponding MSI
@@ -480,7 +480,7 @@ void kvm_init_cpu_signals(CPUState *cpu);
  *          as @NULL, an empty MSI message will be inited.
  * @return: virq (>=0) when success, errno (<0) when failed.
  */
-int kvm_irqchip_add_msi_route(KVMState *s, int vector, PCIDevice *dev);
+int kvm_irqchip_add_msi_route(KVMRouteChange *c, int vector, PCIDevice *dev);
 int kvm_irqchip_update_msi_route(KVMState *s, int virq, MSIMessage msg,
                                  PCIDevice *dev);
 void kvm_irqchip_commit_routes(KVMState *s);
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 5a698bde19..1290756308 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4841,16 +4841,18 @@ void kvm_arch_init_irq_routing(KVMState *s)
     kvm_gsi_routing_allowed = true;
 
     if (kvm_irqchip_is_split()) {
+        KVMRouteChange c = kvm_irqchip_begin_route_changes(s);
         int i;
 
         /* If the ioapic is in QEMU and the lapics are in KVM, reserve
            MSI routes for signaling interrupts to the local apics. */
         for (i = 0; i < IOAPIC_NUM_PINS; i++) {
-            if (kvm_irqchip_add_msi_route(s, 0, NULL) < 0) {
+            if (kvm_irqchip_add_msi_route(&c, 0, NULL) < 0) {
                 error_report("Could not enable split IRQ mode.");
                 exit(1);
             }
         }
+        kvm_irqchip_commit_route_changes(&c);
     }
 }
 
-- 
2.23.0

