Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7071761056
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 13:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfGFLTG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jul 2019 07:19:06 -0400
Received: from mga12.intel.com ([192.55.52.136]:5514 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726248AbfGFLTF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jul 2019 07:19:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jul 2019 04:19:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,458,1557212400"; 
   d="scan'208";a="363354990"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by fmsmga005.fm.intel.com with ESMTP; 06 Jul 2019 04:19:02 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v1 05/18] vfio/pci: add pasid alloc/free implementation
Date:   Fri,  5 Jul 2019 19:01:38 +0800
Message-Id: <1562324511-2910-6-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds vfio implementation PCIPASIDOps.alloc_pasid/free_pasid().
These two functions are used to propagate guest pasid allocation and
free requests to host via vfio container ioctl.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
---
 hw/vfio/pci.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index ce3fe96..ab184ad 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -2690,6 +2690,65 @@ static void vfio_unregister_req_notifier(VFIOPCIDevice *vdev)
     vdev->req_enabled = false;
 }
 
+static int vfio_pci_device_request_pasid_alloc(PCIBus *bus,
+                                               int32_t devfn,
+                                               uint32_t min_pasid,
+                                               uint32_t max_pasid)
+{
+    PCIDevice *pdev = bus->devices[devfn];
+    VFIOPCIDevice *vdev = DO_UPCAST(VFIOPCIDevice, pdev, pdev);
+    VFIOContainer *container = vdev->vbasedev.group->container;
+    struct vfio_iommu_type1_pasid_request req;
+    unsigned long argsz;
+    int pasid;
+
+    argsz = sizeof(req);
+    req.argsz = argsz;
+    req.flag = VFIO_IOMMU_PASID_ALLOC;
+    req.min_pasid = min_pasid;
+    req.max_pasid = max_pasid;
+
+    rcu_read_lock();
+    pasid = ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req);
+    if (pasid < 0) {
+        error_report("vfio_pci_device_request_pasid_alloc:"
+                     " request failed, contanier: %p", container);
+    }
+    rcu_read_unlock();
+    return pasid;
+}
+
+static int vfio_pci_device_request_pasid_free(PCIBus *bus,
+                                              int32_t devfn,
+                                              uint32_t pasid)
+{
+    PCIDevice *pdev = bus->devices[devfn];
+    VFIOPCIDevice *vdev = DO_UPCAST(VFIOPCIDevice, pdev, pdev);
+    VFIOContainer *container = vdev->vbasedev.group->container;
+    struct vfio_iommu_type1_pasid_request req;
+    unsigned long argsz;
+    int ret = 0;
+
+    argsz = sizeof(req);
+    req.argsz = argsz;
+    req.flag = VFIO_IOMMU_PASID_FREE;
+    req.pasid = pasid;
+
+    rcu_read_lock();
+    ret = ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req);
+    if (ret != 0) {
+        error_report("vfio_pci_device_request_pasid_free:"
+                     " request failed, contanier: %p", container);
+    }
+    rcu_read_unlock();
+    return ret;
+}
+
+static PCIPASIDOps vfio_pci_pasid_ops = {
+    .alloc_pasid = vfio_pci_device_request_pasid_alloc,
+    .free_pasid = vfio_pci_device_request_pasid_free,
+};
+
 static void vfio_realize(PCIDevice *pdev, Error **errp)
 {
     VFIOPCIDevice *vdev = PCI_VFIO(pdev);
@@ -2991,6 +3050,8 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
     vfio_register_req_notifier(vdev);
     vfio_setup_resetfn_quirk(vdev);
 
+    pci_setup_pasid_ops(pdev, &vfio_pci_pasid_ops);
+
     return;
 
 out_teardown:
-- 
2.7.4

