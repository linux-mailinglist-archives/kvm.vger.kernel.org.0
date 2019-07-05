Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C663461059
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 13:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfGFLTO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jul 2019 07:19:14 -0400
Received: from mga12.intel.com ([192.55.52.136]:5514 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbfGFLTO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jul 2019 07:19:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jul 2019 04:19:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,458,1557212400"; 
   d="scan'208";a="363355011"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by fmsmga005.fm.intel.com with ESMTP; 06 Jul 2019 04:19:11 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v1 08/18] vfio/pci: add vfio bind/unbind_gpasid implementation
Date:   Fri,  5 Jul 2019 19:01:41 +0800
Message-Id: <1562324511-2910-9-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds vfio implementation PCIPASIDOps.bind_gpasid/unbind_pasid().
These two functions are used to propagate guest pasid bind and unbind
requests to host via vfio container ioctl.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/vfio/pci.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index ab184ad..892b46c 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -2744,9 +2744,63 @@ static int vfio_pci_device_request_pasid_free(PCIBus *bus,
     return ret;
 }
 
+static void vfio_pci_device_bind_gpasid(PCIBus *bus, int32_t devfn,
+                                     struct gpasid_bind_data *g_bind_data)
+{
+    PCIDevice *pdev = bus->devices[devfn];
+    VFIOPCIDevice *vdev = DO_UPCAST(VFIOPCIDevice, pdev, pdev);
+    VFIOContainer *container = vdev->vbasedev.group->container;
+    struct vfio_iommu_type1_bind *bind;
+    struct vfio_iommu_type1_bind_guest_pasid *bind_guest_pasid;
+    unsigned long argsz;
+
+    argsz = sizeof(*bind) + sizeof(*bind_guest_pasid);
+    bind = g_malloc0(argsz);
+    bind->argsz = argsz;
+    bind->bind_type = VFIO_IOMMU_BIND_GUEST_PASID;
+    bind_guest_pasid = (struct vfio_iommu_type1_bind_guest_pasid *) &bind->data;
+    bind_guest_pasid->bind_data = *g_bind_data;
+
+    rcu_read_lock();
+    if (ioctl(container->fd, VFIO_IOMMU_BIND, bind) != 0) {
+        error_report("vfio_pci_device_bind_gpasid:"
+                     " bind failed, contanier: %p", container);
+    }
+    rcu_read_unlock();
+    g_free(bind);
+}
+
+static void vfio_pci_device_unbind_gpasid(PCIBus *bus, int32_t devfn,
+                                     struct gpasid_bind_data *g_bind_data)
+{
+    PCIDevice *pdev = bus->devices[devfn];
+    VFIOPCIDevice *vdev = DO_UPCAST(VFIOPCIDevice, pdev, pdev);
+    VFIOContainer *container = vdev->vbasedev.group->container;
+    struct vfio_iommu_type1_bind *bind;
+    struct vfio_iommu_type1_bind_guest_pasid *bind_guest_pasid;
+    unsigned long argsz;
+
+    argsz = sizeof(*bind) + sizeof(*bind_guest_pasid);
+    bind = g_malloc0(argsz);
+    bind->argsz = argsz;
+    bind->bind_type = VFIO_IOMMU_BIND_GUEST_PASID;
+    bind_guest_pasid = (struct vfio_iommu_type1_bind_guest_pasid *) &bind->data;
+    bind_guest_pasid->bind_data = *g_bind_data;
+
+    rcu_read_lock();
+    if (ioctl(container->fd, VFIO_IOMMU_UNBIND, bind) != 0) {
+        error_report("vfio_pci_device_unbind_gpasid:"
+                     " unbind failed, contanier: %p", container);
+    }
+    rcu_read_unlock();
+    g_free(bind);
+}
+
 static PCIPASIDOps vfio_pci_pasid_ops = {
     .alloc_pasid = vfio_pci_device_request_pasid_alloc,
     .free_pasid = vfio_pci_device_request_pasid_free,
+    .bind_gpasid = vfio_pci_device_bind_gpasid,
+    .unbind_gpasid = vfio_pci_device_unbind_gpasid,
 };
 
 static void vfio_realize(PCIDevice *pdev, Error **errp)
-- 
2.7.4

