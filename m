Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F69C3112E0
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 21:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233727AbhBETMu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 14:12:50 -0500
Received: from mga05.intel.com ([192.55.52.43]:48413 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233591AbhBETLp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 14:11:45 -0500
IronPort-SDR: 7sjZFwh6TebOO1BZG6/ylT6NgjYTbqDkEkFOiOGU2ctB1OPsAd1gt2f7eXVFUHzW/i97awJXFA
 ickffDo0HZ9w==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="266315667"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="266315667"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 12:53:19 -0800
IronPort-SDR: yGfLwh5KGI3BxbgLEyENrsnQ2aQAjVAEa2L1wHDhJ46qjehwkJg1CJCH88EgFG279aUQSi4PS9
 avlkFONKBG5w==
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="394010985"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 12:53:18 -0800
Subject: [PATCH v5 04/14] vfio/mdev: idxd: Add auxialary device plumbing for
 idxd mdev support
From:   Dave Jiang <dave.jiang@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org
Cc:     megha.dey@intel.com, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        jgg@mellanox.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, parav@mellanox.com, netanelg@mellanox.com,
        shahafs@mellanox.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Fri, 05 Feb 2021 13:53:18 -0700
Message-ID: <161255839829.339900.16438737078488315104.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the VFIO mediated device driver as an auxiliary device to the main idxd
driver. This allows the mdev code to be under VFIO mdev subsystem.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 MAINTAINERS                     |    8 ++++
 drivers/dma/idxd/Makefile       |    2 +
 drivers/dma/idxd/idxd.h         |    7 ++++
 drivers/dma/idxd/init.c         |   77 +++++++++++++++++++++++++++++++++++++++
 drivers/vfio/mdev/Kconfig       |    9 +++++
 drivers/vfio/mdev/Makefile      |    1 +
 drivers/vfio/mdev/idxd/Makefile |    4 ++
 drivers/vfio/mdev/idxd/mdev.c   |   75 ++++++++++++++++++++++++++++++++++++++
 8 files changed, 182 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vfio/mdev/idxd/Makefile
 create mode 100644 drivers/vfio/mdev/idxd/mdev.c

diff --git a/MAINTAINERS b/MAINTAINERS
index ae34b0331eb4..71862e759075 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8970,7 +8970,6 @@ INTEL IADX DRIVER
 M:	Dave Jiang <dave.jiang@intel.com>
 L:	dmaengine@vger.kernel.org
 S:	Supported
-F:	Documentation/driver-api/vfio/mdev-idxd.rst
 F:	drivers/dma/idxd/*
 F:	include/uapi/linux/idxd.h
 
@@ -18720,6 +18719,13 @@ F:	drivers/vfio/mdev/
 F:	include/linux/mdev.h
 F:	samples/vfio-mdev/
 
+VFIO MEDIATED DEVICE IDXD DRIVER
+M:	Dave Jiang <dave.jiang@intel.com>
+L:	kvm@vger.kernel.org
+S:	Maintained
+F:	Documentation/driver-api/vfio/mdev-idxd.rst
+F:	drivers/vfio/mdev/idxd/
+
 VFIO PLATFORM DRIVER
 M:	Eric Auger <eric.auger@redhat.com>
 L:	kvm@vger.kernel.org
diff --git a/drivers/dma/idxd/Makefile b/drivers/dma/idxd/Makefile
index 8978b898d777..d91d1718efac 100644
--- a/drivers/dma/idxd/Makefile
+++ b/drivers/dma/idxd/Makefile
@@ -1,2 +1,4 @@
+ccflags-y += -DDEFAULT_SYMBOL_NAMESPACE=IDXD
+
 obj-$(CONFIG_INTEL_IDXD) += idxd.o
 idxd-y := init.o irq.o device.o sysfs.o submit.o dma.o cdev.o
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index a2438b3166db..f02c96164515 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -8,6 +8,7 @@
 #include <linux/percpu-rwsem.h>
 #include <linux/wait.h>
 #include <linux/cdev.h>
+#include <linux/auxiliary_bus.h>
 #include "registers.h"
 
 #define IDXD_DRIVER_VERSION	"1.00"
@@ -221,6 +222,8 @@ struct idxd_device {
 	struct work_struct work;
 
 	int *int_handles;
+
+	struct auxiliary_device *mdev_auxdev;
 };
 
 /* IDXD software descriptor */
@@ -282,6 +285,10 @@ enum idxd_interrupt_type {
 	IDXD_IRQ_IMS,
 };
 
+struct idxd_mdev_aux_drv {
+	        struct auxiliary_driver auxiliary_drv;
+};
+
 static inline int idxd_get_wq_portal_offset(enum idxd_portal_prot prot,
 					    enum idxd_interrupt_type irq_type)
 {
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index ee56b92108d8..fd57f39e4b7d 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -382,6 +382,74 @@ static void idxd_disable_system_pasid(struct idxd_device *idxd)
 	idxd->sva = NULL;
 }
 
+static void idxd_remove_mdev_auxdev(struct idxd_device *idxd)
+{
+	if (!IS_ENABLED(CONFIG_VFIO_MDEV_IDXD))
+		return;
+
+	auxiliary_device_delete(idxd->mdev_auxdev);
+	auxiliary_device_uninit(idxd->mdev_auxdev);
+}
+
+static void idxd_auxdev_release(struct device *dev)
+{
+	struct auxiliary_device *auxdev = to_auxiliary_dev(dev);
+	struct idxd_device *idxd = dev_get_drvdata(dev);
+
+	kfree(auxdev->name);
+	kfree(auxdev);
+	idxd->mdev_auxdev = NULL;
+}
+
+static int idxd_setup_mdev_auxdev(struct idxd_device *idxd)
+{
+	struct auxiliary_device *auxdev;
+	struct device *dev = &idxd->pdev->dev;
+	int rc;
+
+	if (!IS_ENABLED(CONFIG_VFIO_MDEV_IDXD))
+		return 0;
+
+	auxdev = kzalloc(sizeof(*auxdev), GFP_KERNEL);
+	if (!auxdev)
+		return -ENOMEM;
+
+	auxdev->name = kasprintf(GFP_KERNEL, "mdev-%s", idxd_name[idxd->type]);
+	if (!auxdev->name) {
+		rc = -ENOMEM;
+		goto err_name;
+	}
+
+	dev_dbg(&idxd->pdev->dev, "aux dev mdev: %s\n", auxdev->name);
+
+	auxdev->dev.parent = dev;
+	auxdev->dev.release = idxd_auxdev_release;
+	auxdev->id = idxd->id;
+
+	rc = auxiliary_device_init(auxdev);
+	if (rc < 0) {
+		dev_err(dev, "Failed to init aux dev: %d\n", rc);
+		goto err_auxdev;
+	}
+
+	rc = auxiliary_device_add(auxdev);
+	if (rc < 0) {
+		dev_err(dev, "Failed to add aux dev: %d\n", rc);
+		goto err_auxdev;
+	}
+
+	idxd->mdev_auxdev = auxdev;
+	dev_set_drvdata(&auxdev->dev, idxd);
+
+	return 0;
+
+ err_auxdev:
+	kfree(auxdev->name);
+ err_name:
+	kfree(auxdev);
+	return rc;
+}
+
 static int idxd_probe(struct idxd_device *idxd)
 {
 	struct pci_dev *pdev = idxd->pdev;
@@ -434,11 +502,19 @@ static int idxd_probe(struct idxd_device *idxd)
 		goto err_idr_fail;
 	}
 
+	rc = idxd_setup_mdev_auxdev(idxd);
+	if (rc < 0)
+		goto err_auxdev_fail;
+
 	idxd->major = idxd_cdev_get_major(idxd);
 
 	dev_dbg(dev, "IDXD device %d probed successfully\n", idxd->id);
 	return 0;
 
+ err_auxdev_fail:
+	mutex_lock(&idxd_idr_lock);
+	idr_remove(&idxd_idrs[idxd->type], idxd->id);
+	mutex_unlock(&idxd_idr_lock);
  err_idr_fail:
 	idxd_mask_error_interrupts(idxd);
 	idxd_mask_msix_vectors(idxd);
@@ -610,6 +686,7 @@ static void idxd_remove(struct pci_dev *pdev)
 	dev_dbg(&pdev->dev, "%s called\n", __func__);
 	idxd_cleanup_sysfs(idxd);
 	idxd_shutdown(pdev);
+	idxd_remove_mdev_auxdev(idxd);
 	if (device_pasid_enabled(idxd))
 		idxd_disable_system_pasid(idxd);
 	mutex_lock(&idxd_idr_lock);
diff --git a/drivers/vfio/mdev/Kconfig b/drivers/vfio/mdev/Kconfig
index 5da27f2100f9..e9540e43d1f1 100644
--- a/drivers/vfio/mdev/Kconfig
+++ b/drivers/vfio/mdev/Kconfig
@@ -16,3 +16,12 @@ config VFIO_MDEV_DEVICE
 	default n
 	help
 	  VFIO based driver for Mediated devices.
+
+config VFIO_MDEV_IDXD
+	tristate "VFIO Mediated device driver for Intel IDXD"
+	depends on VFIO && VFIO_MDEV && X86_64
+	select AUXILIARY_BUS
+	select IMS_MSI_ARRAY
+	default n
+	help
+	  VFIO based mediated device driver for Intel Accelerator Devices driver.
diff --git a/drivers/vfio/mdev/Makefile b/drivers/vfio/mdev/Makefile
index 101516fdf375..338843fa6110 100644
--- a/drivers/vfio/mdev/Makefile
+++ b/drivers/vfio/mdev/Makefile
@@ -4,3 +4,4 @@ mdev-y := mdev_core.o mdev_sysfs.o mdev_driver.o
 
 obj-$(CONFIG_VFIO_MDEV) += mdev.o
 obj-$(CONFIG_VFIO_MDEV_DEVICE) += vfio_mdev.o
+obj-$(CONFIG_VFIO_MDEV_IDXD) += idxd/
diff --git a/drivers/vfio/mdev/idxd/Makefile b/drivers/vfio/mdev/idxd/Makefile
new file mode 100644
index 000000000000..e8f45cb96117
--- /dev/null
+++ b/drivers/vfio/mdev/idxd/Makefile
@@ -0,0 +1,4 @@
+ccflags-y += -I$(srctree)/drivers/dma/idxd -DDEFAULT_SYMBOL_NAMESPACE=IDXD
+
+obj-$(CONFIG_VFIO_MDEV_IDXD) += idxd_mdev.o
+idxd_mdev-y := mdev.o
diff --git a/drivers/vfio/mdev/idxd/mdev.c b/drivers/vfio/mdev/idxd/mdev.c
new file mode 100644
index 000000000000..8b9a6adeb606
--- /dev/null
+++ b/drivers/vfio/mdev/idxd/mdev.c
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2020 Intel Corporation. All rights rsvd. */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/device.h>
+#include <linux/auxiliary_bus.h>
+#include <uapi/linux/idxd.h>
+#include "registers.h"
+#include "idxd.h"
+
+static int idxd_mdev_host_init(struct idxd_device *idxd)
+{
+	/* FIXME: Fill in later */
+	return 0;
+}
+
+static int idxd_mdev_host_release(struct idxd_device *idxd)
+{
+	/* FIXME: Fill in later */
+	return 0;
+}
+
+static int idxd_mdev_aux_probe(struct auxiliary_device *auxdev,
+			       const struct auxiliary_device_id *id)
+{
+	struct idxd_device *idxd = dev_get_drvdata(&auxdev->dev);
+	int rc;
+
+	rc = idxd_mdev_host_init(idxd);
+	if (rc < 0) {
+		dev_warn(&auxdev->dev, "mdev host init failed: %d\n", rc);
+		return rc;
+	}
+
+	return 0;
+}
+
+static void idxd_mdev_aux_remove(struct auxiliary_device *auxdev)
+{
+	struct idxd_device *idxd = dev_get_drvdata(&auxdev->dev);
+
+	idxd_mdev_host_release(idxd);
+}
+
+static const struct auxiliary_device_id idxd_mdev_auxbus_id_table[] = {
+	{ .name = "idxd.mdev-dsa" },
+	{ .name = "idxd.mdev-iax" },
+	{},
+};
+MODULE_DEVICE_TABLE(auxiliary, idxd_mdev_auxbus_id_table);
+
+static struct idxd_mdev_aux_drv idxd_mdev_aux_drv = {
+	.auxiliary_drv = {
+		.id_table = idxd_mdev_auxbus_id_table,
+		.probe = idxd_mdev_aux_probe,
+		.remove = idxd_mdev_aux_remove,
+	},
+};
+
+static int idxd_mdev_auxdev_drv_register(struct idxd_mdev_aux_drv *drv)
+{
+	return auxiliary_driver_register(&drv->auxiliary_drv);
+}
+
+static void idxd_mdev_auxdev_drv_unregister(struct idxd_mdev_aux_drv *drv)
+{
+	auxiliary_driver_unregister(&drv->auxiliary_drv);
+}
+
+module_driver(idxd_mdev_aux_drv, idxd_mdev_auxdev_drv_register, idxd_mdev_auxdev_drv_unregister);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Intel Corporation");


