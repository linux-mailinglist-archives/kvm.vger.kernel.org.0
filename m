Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2C203A5FB
	for <lists+kvm@lfdr.de>; Sun,  9 Jun 2019 15:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbfFINh7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Jun 2019 09:37:59 -0400
Received: from mga03.intel.com ([134.134.136.65]:25056 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728792AbfFINh6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Jun 2019 09:37:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jun 2019 06:37:57 -0700
X-ExtLoop1: 1
Received: from yiliu-dev.bj.intel.com ([10.238.156.125])
  by fmsmga007.fm.intel.com with ESMTP; 09 Jun 2019 06:37:55 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com
Cc:     kevin.tian@intel.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@intel.com, joro@8bytes.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v1 3/9] vfio_pci: refine vfio_pci_driver reference in vfio_pci.c
Date:   Sat,  8 Jun 2019 21:21:05 +0800
Message-Id: <1560000071-3543-4-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560000071-3543-1-git-send-email-yi.l.liu@intel.com>
References: <1560000071-3543-1-git-send-email-yi.l.liu@intel.com>
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
index 2aa8a84..af28e4c 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1445,24 +1445,25 @@ static void vfio_pci_reflck_get(struct vfio_pci_reflck *reflck)
 
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
@@ -1479,7 +1480,7 @@ static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev)
 
 	if (pci_is_root_bus(vdev->pdev->bus) ||
 	    vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_reflck_find,
-					  &vdev->reflck, slot) <= 0)
+					  vdev, slot) <= 0)
 		vdev->reflck = vfio_pci_reflck_alloc();
 
 	mutex_unlock(&reflck_lock);
@@ -1504,6 +1505,7 @@ static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck)
 
 struct vfio_devices {
 	struct vfio_device **devices;
+	struct vfio_pci_device *vdev;
 	int cur_index;
 	int max_index;
 };
@@ -1512,7 +1514,7 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
 {
 	struct vfio_devices *devs = data;
 	struct vfio_device *device;
-	struct vfio_pci_device *vdev;
+	struct vfio_pci_device *tmp;
 
 	if (devs->cur_index == devs->max_index)
 		return -ENOSPC;
@@ -1521,15 +1523,15 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
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
@@ -1575,6 +1577,7 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
 	if (!devs.devices)
 		return;
 
+	devs.vdev = vdev;
 	if (vfio_pci_for_each_slot_or_bus(vdev->pdev,
 					  vfio_pci_get_unused_devs,
 					  &devs, slot))
@@ -1619,7 +1622,7 @@ static void __exit vfio_pci_cleanup(void)
 	vfio_pci_uninit_perm_bits();
 }
 
-static void __init vfio_pci_fill_ids(char *ids)
+static void __init vfio_pci_fill_ids(char *ids, struct pci_driver *driver)
 {
 	char *p, *id;
 	int rc;
@@ -1647,7 +1650,7 @@ static void __init vfio_pci_fill_ids(char *ids)
 			continue;
 		}
 
-		rc = pci_add_dynid(&vfio_pci_driver, vendor, device,
+		rc = pci_add_dynid(driver, vendor, device,
 				   subvendor, subdevice, class, class_mask, 0);
 		if (rc)
 			pr_warn("failed to add dynamic id [%04x:%04x[%04x:%04x]] class %#08x/%08x (%d)\n",
@@ -1674,7 +1677,7 @@ static int __init vfio_pci_init(void)
 	if (ret)
 		goto out_driver;
 
-	vfio_pci_fill_ids(&ids[0]);
+	vfio_pci_fill_ids(&ids[0], &vfio_pci_driver);
 
 	return 0;
 
-- 
2.7.4

