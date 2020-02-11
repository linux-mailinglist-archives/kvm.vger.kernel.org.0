Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7C9159CCB
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 00:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbgBKXGI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 18:06:08 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55946 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727967AbgBKXGI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Feb 2020 18:06:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581462366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6+YhMCUhJfXfX82EVb/m7gU3cgSgyfnQKFYJKPPSIiQ=;
        b=fYYeEqHE0SgZ5UBcvo0CI3rbT44xUWH0ZpwhFQsfB1Ka5AydMVqEiLHSTuJnkxEoE0DcIx
        4rct8H0EHjJL2eKxbKISOeymW4q4f8MNDisvlNuFb4eriqPO7qRyqs+bP70SreMSsrqNCL
        rfyZRwGXEWOIFIAEp7HqjDkXB1DrP7Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-TwNvrJ1cOWGTS-GqWjSn7w-1; Tue, 11 Feb 2020 18:06:05 -0500
X-MC-Unique: TwNvrJ1cOWGTS-GqWjSn7w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C54B13E6;
        Tue, 11 Feb 2020 23:06:03 +0000 (UTC)
Received: from gimli.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 629B45C109;
        Tue, 11 Feb 2020 23:06:00 +0000 (UTC)
Subject: [PATCH 5/7] vfio/pci: Add sriov_configure support
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        dev@dpdk.org, mtosatti@redhat.com, thomas@monjalon.net,
        bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com, cohuck@redhat.com
Date:   Tue, 11 Feb 2020 16:06:00 -0700
Message-ID: <158146235998.16827.12675446739944814621.stgit@gimli.home>
In-Reply-To: <158145472604.16827.15751375540102298130.stgit@gimli.home>
References: <158145472604.16827.15751375540102298130.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
 drivers/vfio/pci/vfio_pci.c         |  106 +++++++++++++++++++++++++++++++----
 drivers/vfio/pci/vfio_pci_private.h |    2 +
 2 files changed, 97 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 5414744a3ead..cce6127a9c56 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -54,6 +54,12 @@ module_param(disable_idle_d3, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(disable_idle_d3,
 		 "Disable using the PCI D3 low power state for idle, unused devices");
 
+static bool enable_sriov;
+#ifdef CONFIG_PCI_IOV
+module_param(enable_sriov, bool, 0644);
+MODULE_PARM_DESC(enable_sriov, "Enable support for SR-IOV configuration");
+#endif
+
 static inline bool vfio_vga_disabled(void)
 {
 #ifdef CONFIG_VFIO_PCI_VGA
@@ -1457,6 +1463,35 @@ static const struct vfio_device_ops vfio_pci_ops = {
 
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
@@ -1468,12 +1503,12 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -1521,6 +1556,18 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -1554,6 +1601,8 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 {
 	struct vfio_pci_device *vdev;
 
+	pci_disable_sriov(pdev);
+
 	vdev = vfio_del_group_dev(&pdev->dev);
 	if (!vdev)
 		return;
@@ -1564,6 +1613,9 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 		kfree(vdev->vf_token);
 	}
 
+	if (vdev->nb.notifier_call)
+		bus_unregister_notifier(&pci_bus_type, &vdev->nb);
+
 	vfio_pci_reflck_put(vdev->reflck);
 
 	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
@@ -1612,16 +1664,48 @@ static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
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
index 6da2b4748abf..b651a007334d 100644
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

