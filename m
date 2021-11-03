Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033C3443E44
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 09:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhKCIT5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 04:19:57 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:14710 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbhKCITr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 04:19:47 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HkfhS177NzZcbQ;
        Wed,  3 Nov 2021 16:15:04 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 3 Nov 2021 16:17:09 +0800
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 3 Nov 2021 16:17:08 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <alex.williamson@redhat.com>, <pbonzini@redhat.com>
CC:     <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <arei.gonglei@huawei.com>, "Longpeng(Mike)" <longpeng2@huawei.com>
Subject: [PATCH v5 6/6] vfio: defer to commit kvm irq routing when enable msi/msix
Date:   Wed, 3 Nov 2021 16:16:57 +0800
Message-ID: <20211103081657.1945-7-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
In-Reply-To: <20211103081657.1945-1-longpeng2@huawei.com>
References: <20211103081657.1945-1-longpeng2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml100016.china.huawei.com (7.185.36.216)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In migration resume phase, all unmasked msix vectors need to be
setup when loading the VF state. However, the setup operation would
take longer if the VM has more VFs and each VF has more unmasked
vectors.

The hot spot is kvm_irqchip_commit_routes, it'll scan and update
all irqfds that are already assigned each invocation, so more
vectors means need more time to process them.

vfio_pci_load_config
  vfio_msix_enable
    msix_set_vector_notifiers
      for (vector = 0; vector < dev->msix_entries_nr; vector++) {
        vfio_msix_vector_do_use
          vfio_add_kvm_msi_virq
            kvm_irqchip_commit_routes <-- expensive
      }

We can reduce the cost by only committing once outside the loop.
The routes are cached in kvm_state, we commit them first and then
bind irqfd for each vector.

The test VM has 128 vcpus and 8 VF (each one has 65 vectors),
we measure the cost of the vfio_msix_enable for each VF, and
we can see 90+% costs can be reduce.

VF      Count of irqfds[*]  Original        With this patch

1st           65            8               2
2nd           130           15              2
3rd           195           22              2
4th           260           24              3
5th           325           36              2
6th           390           44              3
7th           455           51              3
8th           520           58              4
Total                       258ms           21ms

[*] Count of irqfds
How many irqfds that already assigned and need to process in this
round.

The optimization can be applied to msi type too.

Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
---
 hw/vfio/pci.c | 123 ++++++++++++++++++++++++++++++++++++++++++++--------------
 hw/vfio/pci.h |   1 +
 2 files changed, 95 insertions(+), 29 deletions(-)

diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 69ad081..5b3a86d 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -413,30 +413,37 @@ static int vfio_enable_vectors(VFIOPCIDevice *vdev, bool msix)
 static void vfio_add_kvm_msi_virq(VFIOPCIDevice *vdev, VFIOMSIVector *vector,
                                   int vector_n, bool msix)
 {
-    int virq;
-
     if ((msix && vdev->no_kvm_msix) || (!msix && vdev->no_kvm_msi)) {
         return;
     }
 
-    if (event_notifier_init(&vector->kvm_interrupt, 0)) {
+    vector->virq = kvm_irqchip_add_deferred_msi_route(kvm_state, vector_n,
+                                                      &vdev->pdev);
+}
+
+static void vfio_connect_kvm_msi_virq(VFIOMSIVector *vector)
+{
+    if (vector->virq < 0) {
         return;
     }
 
-    virq = kvm_irqchip_add_msi_route(kvm_state, vector_n, &vdev->pdev);
-    if (virq < 0) {
-        event_notifier_cleanup(&vector->kvm_interrupt);
-        return;
+    if (event_notifier_init(&vector->kvm_interrupt, 0)) {
+        goto fail_notifier;
     }
 
     if (kvm_irqchip_add_irqfd_notifier_gsi(kvm_state, &vector->kvm_interrupt,
-                                       NULL, virq) < 0) {
-        kvm_irqchip_release_virq(kvm_state, virq);
-        event_notifier_cleanup(&vector->kvm_interrupt);
-        return;
+                                           NULL, vector->virq) < 0) {
+        goto fail_kvm;
     }
 
-    vector->virq = virq;
+    return;
+
+fail_kvm:
+    event_notifier_cleanup(&vector->kvm_interrupt);
+fail_notifier:
+    kvm_irqchip_release_virq(kvm_state, vector->virq);
+    vector->virq = -1;
+    return;
 }
 
 static void vfio_remove_kvm_msi_virq(VFIOMSIVector *vector)
@@ -492,6 +499,10 @@ static int vfio_msix_vector_do_use(PCIDevice *pdev, unsigned int nr,
     } else {
         if (msg) {
             vfio_add_kvm_msi_virq(vdev, vector, nr, true);
+            if (!vdev->defer_kvm_irq_routing) {
+                kvm_irqchip_commit_routes(kvm_state);
+                vfio_connect_kvm_msi_virq(vector);
+            }
         }
     }
 
@@ -501,11 +512,13 @@ static int vfio_msix_vector_do_use(PCIDevice *pdev, unsigned int nr,
      * increase them as needed.
      */
     if (vdev->nr_vectors < nr + 1) {
-        vfio_disable_irqindex(&vdev->vbasedev, VFIO_PCI_MSIX_IRQ_INDEX);
         vdev->nr_vectors = nr + 1;
-        ret = vfio_enable_vectors(vdev, true);
-        if (ret) {
-            error_report("vfio: failed to enable vectors, %d", ret);
+        if (!vdev->defer_kvm_irq_routing) {
+            vfio_disable_irqindex(&vdev->vbasedev, VFIO_PCI_MSIX_IRQ_INDEX);
+            ret = vfio_enable_vectors(vdev, true);
+            if (ret) {
+                error_report("vfio: failed to enable vectors, %d", ret);
+            }
         }
     } else {
         Error *err = NULL;
@@ -567,6 +580,30 @@ static void vfio_msix_vector_release(PCIDevice *pdev, unsigned int nr)
     }
 }
 
+static void vfio_prepare_kvm_msi_virq_batch(VFIOPCIDevice *vdev)
+{
+    assert(!vdev->defer_kvm_irq_routing);
+    vdev->defer_kvm_irq_routing = true;
+}
+
+static void vfio_commit_kvm_msi_virq_batch(VFIOPCIDevice *vdev)
+{
+    int i;
+
+    assert(vdev->defer_kvm_irq_routing);
+    vdev->defer_kvm_irq_routing = false;
+
+    if (!vdev->nr_vectors) {
+        return;
+    }
+
+    kvm_irqchip_commit_routes(kvm_state);
+
+    for (i = 0; i < vdev->nr_vectors; i++) {
+        vfio_connect_kvm_msi_virq(&vdev->msi_vectors[i]);
+    }
+}
+
 static void vfio_msix_enable(VFIOPCIDevice *vdev)
 {
     vfio_disable_interrupts(vdev);
@@ -576,26 +613,45 @@ static void vfio_msix_enable(VFIOPCIDevice *vdev)
     vdev->interrupt = VFIO_INT_MSIX;
 
     /*
-     * Some communication channels between VF & PF or PF & fw rely on the
-     * physical state of the device and expect that enabling MSI-X from the
-     * guest enables the same on the host.  When our guest is Linux, the
-     * guest driver call to pci_enable_msix() sets the enabling bit in the
-     * MSI-X capability, but leaves the vector table masked.  We therefore
-     * can't rely on a vector_use callback (from request_irq() in the guest)
-     * to switch the physical device into MSI-X mode because that may come a
-     * long time after pci_enable_msix().  This code enables vector 0 with
-     * triggering to userspace, then immediately release the vector, leaving
-     * the physical device with no vectors enabled, but MSI-X enabled, just
-     * like the guest view.
+     * Setting vector notifiers triggers synchronous vector-use
+     * callbacks for each active vector.  Deferring to commit the KVM
+     * routes once rather than per vector provides a substantial
+     * performance improvement.
      */
-    vfio_msix_vector_do_use(&vdev->pdev, 0, NULL, NULL);
-    vfio_msix_vector_release(&vdev->pdev, 0);
+    vfio_prepare_kvm_msi_virq_batch(vdev);
 
     if (msix_set_vector_notifiers(&vdev->pdev, vfio_msix_vector_use,
                                   vfio_msix_vector_release, NULL)) {
         error_report("vfio: msix_set_vector_notifiers failed");
     }
 
+    vfio_commit_kvm_msi_virq_batch(vdev);
+
+    if (vdev->nr_vectors) {
+        int ret;
+
+        ret = vfio_enable_vectors(vdev, true);
+        if (ret) {
+            error_report("vfio: failed to enable vectors, %d", ret);
+        }
+    } else {
+        /*
+         * Some communication channels between VF & PF or PF & fw rely on the
+         * physical state of the device and expect that enabling MSI-X from the
+         * guest enables the same on the host.  When our guest is Linux, the
+         * guest driver call to pci_enable_msix() sets the enabling bit in the
+         * MSI-X capability, but leaves the vector table masked.  We therefore
+         * can't rely on a vector_use callback (from request_irq() in the guest)
+         * to switch the physical device into MSI-X mode because that may come a
+         * long time after pci_enable_msix().  This code enables vector 0 with
+         * triggering to userspace, then immediately release the vector, leaving
+         * the physical device with no vectors enabled, but MSI-X enabled, just
+         * like the guest view.
+         */
+        vfio_msix_vector_do_use(&vdev->pdev, 0, NULL, NULL);
+        vfio_msix_vector_release(&vdev->pdev, 0);
+    }
+
     trace_vfio_msix_enable(vdev->vbasedev.name);
 }
 
@@ -605,6 +661,13 @@ static void vfio_msi_enable(VFIOPCIDevice *vdev)
 
     vfio_disable_interrupts(vdev);
 
+    /*
+     * Setting vector notifiers needs to enable route for each vector.
+     * Deferring to commit the KVM routes once rather than per vector
+     * provides a substantial performance improvement.
+     */
+    vfio_prepare_kvm_msi_virq_batch(vdev);
+
     vdev->nr_vectors = msi_nr_vectors_allocated(&vdev->pdev);
 retry:
     vdev->msi_vectors = g_new0(VFIOMSIVector, vdev->nr_vectors);
@@ -630,6 +693,8 @@ retry:
         vfio_add_kvm_msi_virq(vdev, vector, i, false);
     }
 
+    vfio_commit_kvm_msi_virq_batch(vdev);
+
     /* Set interrupt type prior to possible interrupts */
     vdev->interrupt = VFIO_INT_MSI;
 
diff --git a/hw/vfio/pci.h b/hw/vfio/pci.h
index 6477751..d3c5177 100644
--- a/hw/vfio/pci.h
+++ b/hw/vfio/pci.h
@@ -171,6 +171,7 @@ struct VFIOPCIDevice {
     bool no_kvm_ioeventfd;
     bool no_vfio_ioeventfd;
     bool enable_ramfb;
+    bool defer_kvm_irq_routing;
     VFIODisplay *dpy;
     Notifier irqchip_change_notifier;
 };
-- 
1.8.3.1

