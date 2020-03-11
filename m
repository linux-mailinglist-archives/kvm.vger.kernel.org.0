Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01207182455
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 22:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387484AbgCKV7X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 17:59:23 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53642 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387487AbgCKV7W (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Mar 2020 17:59:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583963961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ge3zFYqD4WTeTZkA9NRw4yoofJjMSVffWhtRm9bmEFs=;
        b=G/5ipPqvzEXgbQXubjNJtqlU+kY2wMuAW8zEiM2Z6PjxQk9wjQTeZjIeXJNWB6gh3gz8VG
        1A+TGQsxnW2qFa17ZHyNnQat4WnM0xYxqbO5m1HH0DiOnrYD8MXWrwX1NyPi5EgF0JKglc
        eHS5t/guAg13R5o6rSuvsUtT/OqlqXg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-1uQDeSaMNOOKR958PrCnNg-1; Wed, 11 Mar 2020 17:59:17 -0400
X-MC-Unique: 1uQDeSaMNOOKR958PrCnNg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6BEF18A5500;
        Wed, 11 Mar 2020 21:59:15 +0000 (UTC)
Received: from gimli.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8750827180;
        Wed, 11 Mar 2020 21:59:12 +0000 (UTC)
Subject: [PATCH v3 5/7] vfio/pci: Add sriov_configure support
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        dev@dpdk.org, mtosatti@redhat.com, thomas@monjalon.net,
        bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com, cohuck@redhat.com, kevin.tian@intel.com
Date:   Wed, 11 Mar 2020 15:59:12 -0600
Message-ID: <158396395214.5601.11207416598267070486.stgit@gimli.home>
In-Reply-To: <158396044753.5601.14804870681174789709.stgit@gimli.home>
References: <158396044753.5601.14804870681174789709.stgit@gimli.home>
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
driver itself to manipulate SR-IOV through the vfio API.  With this
patch SR-IOV can only be enabled via the host sysfs interface and the
PF driver user cannot create or remove VFs.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c         |  106 +++++++++++++++++++++++++++++++----
 drivers/vfio/pci/vfio_pci_private.h |    2 +
 2 files changed, 97 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 6c28860f768a..df6bae75c8dd 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -54,6 +54,12 @@ module_param(disable_idle_d3, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(disable_idle_d3,
 		 "Disable using the PCI D3 low power state for idle, unused devices");
 
+static bool enable_sriov;
+#ifdef CONFIG_PCI_IOV
+module_param(enable_sriov, bool, 0644);
+MODULE_PARM_DESC(enable_sriov, "Enable support for SR-IOV configuration.  Enabling SR-IOV on a PF typically requires support of the userspace PF driver, enabling VFs without such support may result in non-functional VFs or PF.");
+#endif
+
 static inline bool vfio_vga_disabled(void)
 {
 #ifdef CONFIG_VFIO_PCI_VGA
@@ -1535,6 +1541,35 @@ static const struct vfio_device_ops vfio_pci_ops = {
 
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
+	struct pci_dev *physfn = pci_physfn(pdev);
+
+	if (action == BUS_NOTIFY_ADD_DEVICE &&
+	    pdev->is_virtfn && physfn == vdev->pdev) {
+		pci_info(vdev->pdev, "Captured SR-IOV VF %s driver_override\n",
+			 pci_name(pdev));
+		pdev->driver_override = kasprintf(GFP_KERNEL, "%s",
+						  vfio_pci_ops.name);
+	} else if (action == BUS_NOTIFY_BOUND_DRIVER &&
+		   pdev->is_virtfn && physfn == vdev->pdev) {
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
@@ -1546,12 +1581,12 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -1599,6 +1634,18 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -1632,6 +1679,8 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 {
 	struct vfio_pci_device *vdev;
 
+	pci_disable_sriov(pdev);
+
 	vdev = vfio_del_group_dev(&pdev->dev);
 	if (!vdev)
 		return;
@@ -1642,6 +1691,9 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 		kfree(vdev->vf_token);
 	}
 
+	if (vdev->nb.notifier_call)
+		bus_unregister_notifier(&pci_bus_type, &vdev->nb);
+
 	vfio_pci_reflck_put(vdev->reflck);
 
 	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
@@ -1690,16 +1742,48 @@ static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 	return PCI_ERS_RESULT_CAN_RECOVER;
 }
 
+static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
+{
+	struct vfio_pci_device *vdev;
+	struct vfio_device *device;
+	int ret = 0;
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
+	if (nr_virtfn == 0)
+		pci_disable_sriov(pdev);
+	else
+		ret = pci_enable_sriov(pdev, nr_virtfn);
+
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
index 76c11c915949..36ec69081ecd 100644
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

