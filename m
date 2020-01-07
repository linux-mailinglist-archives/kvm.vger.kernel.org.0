Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4AB81325F4
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 13:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgAGMVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 07:21:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:13867 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728026AbgAGMVK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 07:21:10 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2020 04:21:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,406,1571727600"; 
   d="scan'208";a="422476009"
Received: from iov2.bj.intel.com ([10.238.145.72])
  by fmsmga006.fm.intel.com with ESMTP; 07 Jan 2020 04:21:07 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kevin.tian@intel.com, joro@8bytes.org, peterx@redhat.com,
        baolu.lu@linux.intel.com, Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH v4 03/12] vfio_pci: refine vfio_pci_driver reference in vfio_pci.c
Date:   Tue,  7 Jan 2020 20:01:40 +0800
Message-Id: <1578398509-26453-4-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
References: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
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
 drivers/vfio/pci/vfio_pci.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 009d2df..9140f5e5 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1463,24 +1463,25 @@ static void vfio_pci_reflck_get(struct vfio_pci_reflck *reflck)
 
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
@@ -1497,7 +1498,7 @@ static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev)
 
 	if (pci_is_root_bus(vdev->pdev->bus) ||
 	    vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_reflck_find,
-					  &vdev->reflck, slot) <= 0)
+					  vdev, slot) <= 0)
 		vdev->reflck = vfio_pci_reflck_alloc();
 
 	mutex_unlock(&reflck_lock);
@@ -1522,6 +1523,7 @@ static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck)
 
 struct vfio_devices {
 	struct vfio_device **devices;
+	struct vfio_pci_device *vdev;
 	int cur_index;
 	int max_index;
 };
@@ -1530,7 +1532,7 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
 {
 	struct vfio_devices *devs = data;
 	struct vfio_device *device;
-	struct vfio_pci_device *vdev;
+	struct vfio_pci_device *tmp;
 
 	if (devs->cur_index == devs->max_index)
 		return -ENOSPC;
@@ -1539,15 +1541,15 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
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
@@ -1574,7 +1576,7 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
  */
 static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
 {
-	struct vfio_devices devs = { .cur_index = 0 };
+	struct vfio_devices devs = { .vdev = vdev, .cur_index = 0 };
 	int i = 0, ret = -EINVAL;
 	bool slot = false;
 	struct vfio_pci_device *tmp;
@@ -1637,7 +1639,7 @@ static void __exit vfio_pci_cleanup(void)
 	vfio_pci_uninit_perm_bits();
 }
 
-static void __init vfio_pci_fill_ids(char *ids)
+static void __init vfio_pci_fill_ids(char *ids, struct pci_driver *driver)
 {
 	char *p, *id;
 	int rc;
@@ -1665,7 +1667,7 @@ static void __init vfio_pci_fill_ids(char *ids)
 			continue;
 		}
 
-		rc = pci_add_dynid(&vfio_pci_driver, vendor, device,
+		rc = pci_add_dynid(driver, vendor, device,
 				   subvendor, subdevice, class, class_mask, 0);
 		if (rc)
 			pr_warn("failed to add dynamic id [%04x:%04x[%04x:%04x]] class %#08x/%08x (%d)\n",
@@ -1692,7 +1694,7 @@ static int __init vfio_pci_init(void)
 	if (ret)
 		goto out_driver;
 
-	vfio_pci_fill_ids(ids);
+	vfio_pci_fill_ids(ids, &vfio_pci_driver);
 
 	return 0;
 
-- 
2.7.4

