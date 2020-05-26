Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4941D6F40
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 05:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgERDG0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 23:06:26 -0400
Received: from mga06.intel.com ([134.134.136.31]:39772 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726639AbgERDG0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 23:06:26 -0400
IronPort-SDR: bXB6AeMxhvwiK9dC5jY/JRLc3Z7xfq/fIcezBTm/K6dEsDpF9gr7VFae/p7Zp/loP/vNg3tBjc
 qpIEnAHcmFaw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2020 20:06:26 -0700
IronPort-SDR: ZodtljUh9+7MSzGOSifcMary7mu0dRa+dQOFzSBH2T0ZlWSnK8HGJjF9JydYxVA7Q3evPo+gpa
 +Opeg/vPxmkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,405,1583222400"; 
   d="scan'208";a="411106816"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga004.jf.intel.com with ESMTP; 17 May 2020 20:06:22 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        xin.zeng@intel.com, hang.yuan@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [QEMU RFC PATCH v4] hw/vfio/pci: remap bar region irq
Date:   Sun, 17 May 2020 22:56:18 -0400
Message-Id: <20200518025618.14659-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200518025245.14425-1-yan.y.zhao@intel.com>
References: <20200518025245.14425-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Added an irq type VFIO_IRQ_TYPE_REMAP_BAR_REGION to
dynamically query and remap BAR regions.

QEMU decodes the index of the BARs by reading cnt of eventfd.
If bit n is set, the corresponding BAR will be requeried and
its subregions will be remapped according to the its new flags.

rely on [1] "vfio: Add a funtion to return a specific irq capabilities"
[1] https://www.mail-archive.com/qemu-devel@nongnu.org/msg621645.html

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 hw/vfio/common.c              | 50 ++++++++++++++++++++++++
 hw/vfio/pci.c                 | 90 +++++++++++++++++++++++++++++++++++++++++++
 hw/vfio/pci.h                 |  2 +
 include/hw/vfio/vfio-common.h |  2 +
 linux-headers/linux/vfio.h    | 11 ++++++
 5 files changed, 155 insertions(+)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index a041c3b..cf24293 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -1284,6 +1284,56 @@ void vfio_region_unmap(VFIORegion *region)
     }
 }
 
+/*
+ * re-query a region's flags,
+ * and update its mmap'd subregions.
+ * It does not support change a region's size.
+ */
+void vfio_region_reset_mmap(VFIODevice *vbasedev, VFIORegion *region, int index)
+{
+    struct vfio_region_info *new;
+
+    if (!region->mem) {
+        return;
+    }
+
+    if (vfio_get_region_info(vbasedev, index, &new)) {
+        goto out;
+    }
+
+    if (region->size != new->size) {
+        error_report("vfio: resetting of region size is not supported");
+        goto out;
+    }
+
+    if (region->flags == new->flags) {
+        goto out;
+    }
+
+    /* ummap old mmap'd subregions, if any */
+    vfio_region_unmap(region);
+    region->nr_mmaps = 0;
+    g_free(region->mmaps);
+    region->mmaps = NULL;
+
+    /* setup new mmap'd subregions*/
+    region->flags = new->flags;
+    if (vbasedev->no_mmap ||
+            !(region->flags & VFIO_REGION_INFO_FLAG_MMAP)) {
+        goto out;
+    }
+
+    if (vfio_setup_region_sparse_mmaps(region, new)) {
+        region->nr_mmaps = 1;
+        region->mmaps = g_new0(VFIOMmap, region->nr_mmaps);
+        region->mmaps[0].offset = 0;
+        region->mmaps[0].size = region->size;
+    }
+    vfio_region_mmap(region);
+out:
+    g_free(new);
+}
+
 void vfio_region_exit(VFIORegion *region)
 {
     int i;
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index c70f153..12998c5 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -2883,6 +2883,94 @@ static void vfio_unregister_req_notifier(VFIOPCIDevice *vdev)
     vdev->req_enabled = false;
 }
 
+static void vfio_remap_bar_notifier_handler(void *opaque)
+{
+    VFIOPCIDevice *vdev = opaque;
+    uint64_t bars;
+    ssize_t ret;
+    int i;
+
+    ret = read(vdev->remap_bar_notifier.rfd, &bars, sizeof(bars));
+    if (ret != sizeof(bars)) {
+            return;
+    }
+    for (i = 0; i < PCI_ROM_SLOT; i++) {
+        VFIORegion *region = &vdev->bars[i].region;
+
+        if (!test_bit(i, &bars)) {
+            continue;
+        }
+
+        vfio_region_reset_mmap(&vdev->vbasedev, region, i);
+    }
+
+    /* write 0 to notify kernel that we're done */
+    bars = 0;
+    write(vdev->remap_bar_notifier.wfd, &bars, sizeof(bars));
+}
+
+static void vfio_register_remap_bar_notifier(VFIOPCIDevice *vdev)
+{
+    int ret;
+    struct vfio_irq_info *irq;
+    Error *err = NULL;
+    int32_t fd;
+
+    ret = vfio_get_dev_irq_info(&vdev->vbasedev,
+                                VFIO_IRQ_TYPE_REMAP_BAR_REGION,
+                                VFIO_IRQ_SUBTYPE_REMAP_BAR_REGION,
+                                &irq);
+    if (ret) {
+        return;
+    }
+    ret = event_notifier_init(&vdev->remap_bar_notifier, 0);
+    if (ret) {
+        error_report("vfio: Failed to init event notifier for remap bar irq");
+        return;
+    }
+
+    fd = event_notifier_get_fd(&vdev->remap_bar_notifier);
+    qemu_set_fd_handler(fd, vfio_remap_bar_notifier_handler, NULL, vdev);
+
+    if (vfio_set_irq_signaling(&vdev->vbasedev, irq->index, 0,
+                               VFIO_IRQ_SET_ACTION_TRIGGER, fd, &err)) {
+        error_reportf_err(err, VFIO_MSG_PREFIX, vdev->vbasedev.name);
+        qemu_set_fd_handler(fd, NULL, NULL, vdev);
+        event_notifier_cleanup(&vdev->remap_bar_notifier);
+    } else {
+        vdev->remap_bar_enabled = true;
+    }
+};
+
+static void vfio_unregister_remap_bar_notifier(VFIOPCIDevice *vdev)
+{
+    struct vfio_irq_info *irq;
+    Error *err = NULL;
+    int ret;
+
+    if (!vdev->remap_bar_enabled) {
+        return;
+    }
+
+    ret = vfio_get_dev_irq_info(&vdev->vbasedev,
+                                VFIO_IRQ_TYPE_REMAP_BAR_REGION,
+                                VFIO_IRQ_SUBTYPE_REMAP_BAR_REGION,
+                                &irq);
+    if (ret) {
+        return;
+    }
+
+    if (vfio_set_irq_signaling(&vdev->vbasedev, irq->index, 0,
+                               VFIO_IRQ_SET_ACTION_TRIGGER, -1, &err)) {
+        error_reportf_err(err, VFIO_MSG_PREFIX, vdev->vbasedev.name);
+    }
+    qemu_set_fd_handler(event_notifier_get_fd(&vdev->remap_bar_notifier),
+                        NULL, NULL, vdev);
+    event_notifier_cleanup(&vdev->req_notifier);
+
+    vdev->remap_bar_enabled = false;
+}
+
 static void vfio_realize(PCIDevice *pdev, Error **errp)
 {
     VFIOPCIDevice *vdev = PCI_VFIO(pdev);
@@ -3194,6 +3282,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
 
     vfio_register_err_notifier(vdev);
     vfio_register_req_notifier(vdev);
+    vfio_register_remap_bar_notifier(vdev);
     vfio_setup_resetfn_quirk(vdev);
 
     return;
@@ -3235,6 +3324,7 @@ static void vfio_exitfn(PCIDevice *pdev)
 
     vfio_unregister_req_notifier(vdev);
     vfio_unregister_err_notifier(vdev);
+    vfio_unregister_remap_bar_notifier(vdev);
     pci_device_set_intx_routing_notifier(&vdev->pdev, NULL);
     if (vdev->irqchip_change_notifier.notify) {
         kvm_irqchip_remove_change_notifier(&vdev->irqchip_change_notifier);
diff --git a/hw/vfio/pci.h b/hw/vfio/pci.h
index b148c93..5a1e564 100644
--- a/hw/vfio/pci.h
+++ b/hw/vfio/pci.h
@@ -134,6 +134,7 @@ typedef struct VFIOPCIDevice {
     PCIHostDeviceAddress host;
     EventNotifier err_notifier;
     EventNotifier req_notifier;
+    EventNotifier remap_bar_notifier;
     int (*resetfn)(struct VFIOPCIDevice *);
     uint32_t vendor_id;
     uint32_t device_id;
@@ -157,6 +158,7 @@ typedef struct VFIOPCIDevice {
     uint8_t nv_gpudirect_clique;
     bool pci_aer;
     bool req_enabled;
+    bool remap_bar_enabled;
     bool has_flr;
     bool has_pm_reset;
     bool rom_read_failed;
diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index a6283b7..1c16790 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -188,6 +188,8 @@ int vfio_region_setup(Object *obj, VFIODevice *vbasedev, VFIORegion *region,
 int vfio_region_mmap(VFIORegion *region);
 void vfio_region_mmaps_set_enabled(VFIORegion *region, bool enabled);
 void vfio_region_unmap(VFIORegion *region);
+void vfio_region_reset_mmap(VFIODevice *vbasedev,
+                            VFIORegion *region, int index);
 void vfio_region_exit(VFIORegion *region);
 void vfio_region_finalize(VFIORegion *region);
 void vfio_reset_handler(void *opaque);
diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
index 2598a84..2344ca6 100644
--- a/linux-headers/linux/vfio.h
+++ b/linux-headers/linux/vfio.h
@@ -703,6 +703,17 @@ struct vfio_irq_info_cap_type {
 	__u32 subtype;  /* type specific */
 };
 
+/* Bar Region Query IRQ TYPE */
+#define VFIO_IRQ_TYPE_REMAP_BAR_REGION                 (1)
+
+/* sub-types for VFIO_IRQ_TYPE_REMAP_BAR_REGION */
+/*
+ * This irq notifies userspace to re-query BAR region and remaps the
+ * subregions.
+ */
+#define VFIO_IRQ_SUBTYPE_REMAP_BAR_REGION      (0)
+
+
 /**
  * VFIO_DEVICE_SET_IRQS - _IOW(VFIO_TYPE, VFIO_BASE + 10, struct vfio_irq_set)
  *
-- 
2.7.4

