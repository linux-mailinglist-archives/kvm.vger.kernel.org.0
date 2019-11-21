Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87FEB107196
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 12:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbfKVLmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 06:42:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:15269 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727770AbfKVLmO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 06:42:14 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 03:42:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,229,1571727600"; 
   d="scan'208";a="358110486"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by orsmga004.jf.intel.com with ESMTP; 22 Nov 2019 03:42:11 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com
Cc:     kevin.tian@intel.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@intel.com, joro@8bytes.org, jean-philippe.brucker@arm.com,
        peterx@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v3 03/10] vfio_pci: refine vfio_pci_driver reference in vfio_pci.c
Date:   Thu, 21 Nov 2019 19:23:40 +0800
Message-Id: <1574335427-3763-4-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574335427-3763-1-git-send-email-yi.l.liu@intel.com>
References: <1574335427-3763-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch replaces the vfio_pci_driver reference in vfio_pci.c with
pci_dev_driver(vdev->pdev) which is more helpful to make the functions
be generic to module types.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index b04e43a..2096e66 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1460,24 +1460,25 @@ static void vfio_pci_reflck_get(struct vfio_pci_reflck *reflck)
 
 static int vfio_pci_reflck_find(struct pci_dev *pdev, void *data)
 {
-	struct vfio_pci_reflck **preflck = data;
+	struct vfio_pci_device *vdev = data;
+	struct vfio_pci_reflck **preflck = &vdev->reflck;
 	struct vfio_device *device;
-	struct vfio_pci_device *vdev;
+	struct vfio_pci_device *tmp;
 
 	device = vfio_device_get_from_dev(&pdev->dev);
 	if (!device)
 		return 0;
 
-	if (pci_dev_driver(pdev) != &vfio_pci_driver) {
+	if (pci_dev_driver(pdev) != pci_dev_driver(vdev->pdev)) {
 		vfio_device_put(device);
 		return 0;
 	}
 
-	vdev = vfio_device_data(device);
+	tmp = vfio_device_data(device);
 
-	if (vdev->reflck) {
-		vfio_pci_reflck_get(vdev->reflck);
-		*preflck = vdev->reflck;
+	if (tmp->reflck) {
+		vfio_pci_reflck_get(tmp->reflck);
+		*preflck = tmp->reflck;
 		vfio_device_put(device);
 		return 1;
 	}
@@ -1494,7 +1495,7 @@ static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev)
 
 	if (pci_is_root_bus(vdev->pdev->bus) ||
 	    vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_reflck_find,
-					  &vdev->reflck, slot) <= 0)
+					  vdev, slot) <= 0)
 		vdev->reflck = vfio_pci_reflck_alloc();
 
 	mutex_unlock(&reflck_lock);
@@ -1519,6 +1520,7 @@ static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck)
 
 struct vfio_devices {
 	struct vfio_device **devices;
+	struct vfio_pci_device *vdev;
 	int cur_index;
 	int max_index;
 };
@@ -1527,7 +1529,7 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
 {
 	struct vfio_devices *devs = data;
 	struct vfio_device *device;
-	struct vfio_pci_device *vdev;
+	struct vfio_pci_device *tmp;
 
 	if (devs->cur_index == devs->max_index)
 		return -ENOSPC;
@@ -1536,15 +1538,15 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
 	if (!device)
 		return -EINVAL;
 
-	if (pci_dev_driver(pdev) != &vfio_pci_driver) {
+	if (pci_dev_driver(pdev) != pci_dev_driver(devs->vdev->pdev)) {
 		vfio_device_put(device);
 		return -EBUSY;
 	}
 
-	vdev = vfio_device_data(device);
+	tmp = vfio_device_data(device);
 
 	/* Fault if the device is not unused */
-	if (vdev->refcnt) {
+	if (tmp->refcnt) {
 		vfio_device_put(device);
 		return -EBUSY;
 	}
@@ -1590,6 +1592,7 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
 	if (!devs.devices)
 		return;
 
+	devs.vdev = vdev;
 	if (vfio_pci_for_each_slot_or_bus(vdev->pdev,
 					  vfio_pci_get_unused_devs,
 					  &devs, slot))
@@ -1634,7 +1637,7 @@ static void __exit vfio_pci_cleanup(void)
 	vfio_pci_uninit_perm_bits();
 }
 
-static void __init vfio_pci_fill_ids(char *ids)
+static void __init vfio_pci_fill_ids(char *ids, struct pci_driver *driver)
 {
 	char *p, *id;
 	int rc;
@@ -1662,7 +1665,7 @@ static void __init vfio_pci_fill_ids(char *ids)
 			continue;
 		}
 
-		rc = pci_add_dynid(&vfio_pci_driver, vendor, device,
+		rc = pci_add_dynid(driver, vendor, device,
 				   subvendor, subdevice, class, class_mask, 0);
 		if (rc)
 			pr_warn("failed to add dynamic id [%04x:%04x[%04x:%04x]] class %#08x/%08x (%d)\n",
@@ -1689,7 +1692,7 @@ static int __init vfio_pci_init(void)
 	if (ret)
 		goto out_driver;
 
-	vfio_pci_fill_ids(ids);
+	vfio_pci_fill_ids(ids, &vfio_pci_driver);
 
 	return 0;
 
-- 
2.7.4

