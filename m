Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5112B1522D2
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 00:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgBDXG0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 18:06:26 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48289 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727731AbgBDXGZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 18:06:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580857584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KuRRzmK8sglkXfIDZtK53T9ildVIxJfM1cqHOQwAi6M=;
        b=DAVQEmQ4Nk9wDsRWYkLYDUVnkTyngzuG9qR/9AZW2sR6ZmlQxNjd/4KccWVl73FS12LMv1
        NvWF9hSZrUaX7/99kUlX6JEDbOzRWmHGq4A1o+3ygEHcJvu/Lt9sa31fyA+zmx3/gyw65i
        onjbRVKLTXB6OPoQVMnYBIJ4z7eh7Z0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-Fv_FW6VRN1G9ARGVD2Yj_g-1; Tue, 04 Feb 2020 18:06:20 -0500
X-MC-Unique: Fv_FW6VRN1G9ARGVD2Yj_g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3EC1D1088395;
        Tue,  4 Feb 2020 23:06:19 +0000 (UTC)
Received: from gimli.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED9262116;
        Tue,  4 Feb 2020 23:06:15 +0000 (UTC)
Subject: [RFC PATCH 5/7] vfio/pci: Add sriov_configure support
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        dev@dpdk.org, mtosatti@redhat.com, thomas@monjalon.net,
        bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com, cohuck@redhat.com
Date:   Tue, 04 Feb 2020 16:06:15 -0700
Message-ID: <158085757553.9445.2129792252083813533.stgit@gimli.home>
In-Reply-To: <158085337582.9445.17682266437583505502.stgit@gimli.home>
References: <158085337582.9445.17682266437583505502.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the VF Token interface we can now expect that a vfio userspace
driver must be in collaboration with the PF driver, an unwitting
userspace driver will not be able to get past the GET_DEVICE_FD step
in accessing the device.  We can now move on to actually allowing
SR-IOV to be enabled by vfio-pci on the PF.  Support for this is not
enabled by default in this commit, but it does provide a module option
for this to be enabled (enable_sriov=1).  Enabling VFs is rather
straightforward, except we don't want to risk that a VF might get
autoprobed and bound to other drivers, so a bus notifier is used to
"capture" VFs to vfio-pci using the driver_override support.  We
assume any later action to bind the device to other drivers is
condoned by the system admin and allow it with a log warning.

vfio-pci will disable SR-IOV on a PF before releasing the device,
allowing a VF driver to be assured other drivers cannot take over the
PF and that any other userspace driver must know the shared VF token.
This support also does not provide a mechanism for the PF userspace
driver itself to manipulate SR-IOV.  With this patch SR-IOV can only
be enabled via the host sysfs interface and the PF driver user cannot
create and remove VF.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c         |  113 ++++++++++++++++++++++++++++++++---
 drivers/vfio/pci/vfio_pci_private.h |    2 +
 2 files changed, 104 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index d22a9d7bc32a..026308aa18b5 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -54,6 +54,10 @@ module_param(disable_idle_d3, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(disable_idle_d3,
 		 "Disable using the PCI D3 low power state for idle, unused devices");
 
+static bool enable_sriov;
+module_param(enable_sriov, bool, 0644);
+MODULE_PARM_DESC(enable_sriov, "Enable support for SR-IOV configuration");
+
 static inline bool vfio_vga_disabled(void)
 {
 #ifdef CONFIG_VFIO_PCI_VGA
@@ -1450,6 +1454,34 @@ static const struct vfio_device_ops vfio_pci_ops = {
 
 static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
 static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck);
+static struct pci_driver vfio_pci_driver;
+
+static int vfio_pci_bus_notifier(struct notifier_block *nb,
+				 unsigned long action, void *data)
+{
+	struct vfio_pci_device *vdev = container_of(nb,
+						    struct vfio_pci_device, nb);
+	struct device *dev = data;
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (action == BUS_NOTIFY_ADD_DEVICE &&
+	    pdev->is_virtfn && pdev->physfn == vdev->pdev) {
+		pci_info(vdev->pdev, "Captured SR-IOV VF %s driver_override\n",
+			 pci_name(pdev));
+		pdev->driver_override = kasprintf(GFP_KERNEL, "%s",
+						  vfio_pci_ops.name);
+	} else if (action == BUS_NOTIFY_BOUND_DRIVER &&
+		   pdev->is_virtfn && pdev->physfn == vdev->pdev) {
+		struct pci_driver *drv = pci_dev_driver(pdev);
+
+		if (drv && drv != &vfio_pci_driver)
+			pci_warn(vdev->pdev,
+				 "VF %s bound to driver %s while PF bound to vfio-pci\n",
+				 pci_name(pdev), drv->name);
+	}
+
+	return 0;
+}
 
 static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
@@ -1461,12 +1493,12 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return -EINVAL;
 
 	/*
-	 * Prevent binding to PFs with VFs enabled, this too easily allows
-	 * userspace instance with VFs and PFs from the same device, which
-	 * cannot work.  Disabling SR-IOV here would initiate removing the
-	 * VFs, which would unbind the driver, which is prone to blocking
-	 * if that VF is also in use by vfio-pci.  Just reject these PFs
-	 * and let the user sort it out.
+	 * Prevent binding to PFs with VFs enabled, the VFs might be in use
+	 * by the host or other users.  We cannot capture the VFs if they
+	 * already exist, nor can we track VF users.  Disabling SR-IOV here
+	 * would initiate removing the VFs, which would unbind the driver,
+	 * which is prone to blocking if that VF is also in use by vfio-pci.
+	 * Just reject these PFs and let the user sort it out.
 	 */
 	if (pci_num_vf(pdev)) {
 		pci_warn(pdev, "Cannot bind to PF with SR-IOV enabled\n");
@@ -1514,6 +1546,18 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			kfree(vdev);
 			return -ENOMEM;
 		}
+
+		vdev->nb.notifier_call = vfio_pci_bus_notifier;
+		ret = bus_register_notifier(&pci_bus_type, &vdev->nb);
+		if (ret) {
+			kfree(vdev->vf_token);
+			vfio_pci_reflck_put(vdev->reflck);
+			vfio_del_group_dev(&pdev->dev);
+			vfio_iommu_group_put(group, &pdev->dev);
+			kfree(vdev);
+			return ret;
+		}
+
 		mutex_init(&vdev->vf_token->lock);
 		uuid_gen(&vdev->vf_token->uuid);
 	}
@@ -1547,6 +1591,8 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 {
 	struct vfio_pci_device *vdev;
 
+	pci_disable_sriov(pdev);
+
 	vdev = vfio_del_group_dev(&pdev->dev);
 	if (!vdev)
 		return;
@@ -1557,6 +1603,9 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 		kfree(vdev->vf_token);
 	}
 
+	if (vdev->nb.notifier_call)
+		bus_unregister_notifier(&pci_bus_type, &vdev->nb);
+
 	vfio_pci_reflck_put(vdev->reflck);
 
 	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
@@ -1605,16 +1654,58 @@ static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 	return PCI_ERS_RESULT_CAN_RECOVER;
 }
 
+static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
+{
+	struct vfio_pci_device *vdev;
+	struct vfio_device *device;
+	int ret;
+
+	might_sleep();
+
+	if (!enable_sriov)
+		return -ENOENT;
+
+	device = vfio_device_get_from_dev(&pdev->dev);
+	if (!device)
+		return -ENODEV;
+
+	vdev = vfio_device_data(device);
+	if (!vdev) {
+		vfio_device_put(device);
+		return -ENODEV;
+	}
+
+	mutex_lock(&vdev->reflck->lock);
+
+	if (vdev->refcnt) {
+		mutex_unlock(&vdev->reflck->lock);
+		vfio_device_put(device);
+		return -EBUSY;
+	}
+
+	if (nr_virtfn == 0) {
+		pci_disable_sriov(pdev);
+		ret = 0;
+	} else
+		ret = pci_enable_sriov(pdev, nr_virtfn);
+
+	mutex_unlock(&vdev->reflck->lock);
+	vfio_device_put(device);
+
+	return ret < 0 ? ret : nr_virtfn;
+}
+
 static const struct pci_error_handlers vfio_err_handlers = {
 	.error_detected = vfio_pci_aer_err_detected,
 };
 
 static struct pci_driver vfio_pci_driver = {
-	.name		= "vfio-pci",
-	.id_table	= NULL, /* only dynamic ids */
-	.probe		= vfio_pci_probe,
-	.remove		= vfio_pci_remove,
-	.err_handler	= &vfio_err_handlers,
+	.name			= "vfio-pci",
+	.id_table		= NULL, /* only dynamic ids */
+	.probe			= vfio_pci_probe,
+	.remove			= vfio_pci_remove,
+	.sriov_configure	= vfio_pci_sriov_configure,
+	.err_handler		= &vfio_err_handlers,
 };
 
 static DEFINE_MUTEX(reflck_lock);
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 4ca250207ab6..9951e2557f47 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -13,6 +13,7 @@
 #include <linux/irqbypass.h>
 #include <linux/types.h>
 #include <linux/uuid.h>
+#include <linux/notifier.h>
 
 #ifndef VFIO_PCI_PRIVATE_H
 #define VFIO_PCI_PRIVATE_H
@@ -130,6 +131,7 @@ struct vfio_pci_device {
 	struct mutex		ioeventfds_lock;
 	struct list_head	ioeventfds_list;
 	struct vfio_pci_vf_token	*vf_token;
+	struct notifier_block	nb;
 };
 
 #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)

