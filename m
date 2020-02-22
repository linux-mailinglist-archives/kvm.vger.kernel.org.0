Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2023168D58
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2020 09:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgBVICA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Feb 2020 03:02:00 -0500
Received: from mga05.intel.com ([192.55.52.43]:63018 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726836AbgBVIB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Feb 2020 03:01:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Feb 2020 00:01:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,471,1574150400"; 
   d="scan'208";a="240547668"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga006.jf.intel.com with ESMTP; 22 Feb 2020 00:01:56 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com
Cc:     pbonzini@redhat.com, mst@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        yi.l.liu@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v3.1 06/22] vfio/pci: init HostIOMMUContext per-container
Date:   Sat, 22 Feb 2020 00:07:07 -0800
Message-Id: <1582358843-51931-7-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1582358843-51931-1-git-send-email-yi.l.liu@intel.com>
References: <1582358843-51931-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After confirming dual stage DMA translation support with kernel by
checking VFIO_TYPE1_NESTING_IOMMU, VFIO inits HostIOMMUContet instance
and exposes it to PCI layer. Thus vIOMMU emualtors may make use of
such capability by leveraging the ops provided by HostIOMMUContext.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/vfio/common.c              | 11 +++++++++++
 hw/vfio/pci.c                 | 21 +++++++++++++++++++++
 include/hw/vfio/vfio-common.h |  2 ++
 3 files changed, 34 insertions(+)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index be1a9e5..9ab62a6 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -1179,10 +1179,15 @@ static int vfio_get_iommu_type(VFIOContainer *container,
     return -EINVAL;
 }
 
+static struct HostIOMMUOps vfio_host_icx_ops = {
+/* To be added later */
+};
+
 static int vfio_init_container(VFIOContainer *container, int group_fd,
                                Error **errp)
 {
     int iommu_type, ret;
+    uint64_t flags = 0;
 
     iommu_type = vfio_get_iommu_type(container, errp);
     if (iommu_type < 0) {
@@ -1210,6 +1215,11 @@ static int vfio_init_container(VFIOContainer *container, int group_fd,
         return -errno;
     }
 
+    if (iommu_type == VFIO_TYPE1_NESTING_IOMMU) {
+        host_iommu_ctx_init(&container->host_icx,
+                            flags, &vfio_host_icx_ops);
+    }
+
     container->iommu_type = iommu_type;
     return 0;
 }
@@ -1456,6 +1466,7 @@ static void vfio_disconnect_container(VFIOGroup *group)
         }
 
         trace_vfio_disconnect_container(container->fd);
+        host_iommu_ctx_destroy(&container->host_icx);
         close(container->fd);
         g_free(container);
 
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 5e75a95..df79675 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -2712,11 +2712,20 @@ static void vfio_unregister_req_notifier(VFIOPCIDevice *vdev)
     vdev->req_enabled = false;
 }
 
+static HostIOMMUContext *vfio_host_dma_iommu(PCIDevice *pdev)
+{
+    VFIOPCIDevice *vdev = PCI_VFIO(pdev);
+    VFIOContainer *container = vdev->vbasedev.group->container;
+
+    return &container->host_icx;
+}
+
 static void vfio_realize(PCIDevice *pdev, Error **errp)
 {
     VFIOPCIDevice *vdev = PCI_VFIO(pdev);
     VFIODevice *vbasedev_iter;
     VFIOGroup *group;
+    VFIOContainer *container;
     char *tmp, *subsys, group_path[PATH_MAX], *group_name;
     Error *err = NULL;
     ssize_t len;
@@ -3028,6 +3037,11 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
     vfio_register_req_notifier(vdev);
     vfio_setup_resetfn_quirk(vdev);
 
+    container = vdev->vbasedev.group->container;
+    if (container->host_icx.ops) {
+        pci_device_setup_iommu(pdev, vfio_host_dma_iommu);
+    }
+
     return;
 
 out_deregister:
@@ -3072,9 +3086,16 @@ static void vfio_instance_finalize(Object *obj)
 static void vfio_exitfn(PCIDevice *pdev)
 {
     VFIOPCIDevice *vdev = PCI_VFIO(pdev);
+    VFIOContainer *container;
 
     vfio_unregister_req_notifier(vdev);
     vfio_unregister_err_notifier(vdev);
+
+    container = vdev->vbasedev.group->container;
+    if (container->host_icx.ops) {
+        pci_device_unset_iommu(pdev);
+    }
+
     pci_device_set_intx_routing_notifier(&vdev->pdev, NULL);
     if (vdev->irqchip_change_notifier.notify) {
         kvm_irqchip_remove_change_notifier(&vdev->irqchip_change_notifier);
diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index fd56420..36abe04 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -26,6 +26,7 @@
 #include "qemu/notify.h"
 #include "ui/console.h"
 #include "hw/display/ramfb.h"
+#include "hw/iommu/host_iommu_context.h"
 #ifdef CONFIG_LINUX
 #include <linux/vfio.h>
 #endif
@@ -71,6 +72,7 @@ typedef struct VFIOContainer {
     MemoryListener listener;
     MemoryListener prereg_listener;
     unsigned iommu_type;
+    HostIOMMUContext host_icx;
     Error *error;
     bool initialized;
     unsigned long pgsizes;
-- 
2.7.4

