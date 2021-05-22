Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C0538D26B
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 02:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhEVAWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 20:22:05 -0400
Received: from mga18.intel.com ([134.134.136.126]:45251 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231127AbhEVAVl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 20:21:41 -0400
IronPort-SDR: 88YNDiG8RHe89cArKMcHk0QwSUM03GFmGHvUcjMwvPWz+Ml/fwwv6EAQVUeMkKajKbdBkUH3lL
 xnKrGc+Kiawg==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="188993269"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="188993269"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:20:14 -0700
IronPort-SDR: to1My5qmEvSohnpclJdCrp3nNpyO6VwnPjebJPJ0HQALJmy5xS59L82d/RZr8QWrabQLKO1TUZ
 zmChe4XT0+FA==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="631991888"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:20:14 -0700
Subject: [PATCH v6 11/20] vfio/mdev: idxd: Add basic driver setup for idxd
 mdev
From:   Dave Jiang <dave.jiang@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, jgg@mellanox.com
Cc:     megha.dey@intel.com, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com,
        dan.j.williams@intel.com, eric.auger@redhat.com,
        pbonzini@redhat.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 21 May 2021 17:20:13 -0700
Message-ID: <162164281350.261970.10539208268885731071.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the basic registration and initialization for the mdev idxd driver.
To register with the mdev framework, the driver must register the
pci_dev. Add the registration as part of the idxd mdev driver probe.
The host init is setup to be called on the first wq device probe. And
when the last wq device releases the driver, the unregistration also
happens.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/Kconfig           |    1 
 drivers/dma/idxd/device.c     |    2 +
 drivers/dma/idxd/idxd.h       |   10 ++++
 drivers/dma/idxd/init.c       |   39 +++++++++++++++++
 drivers/vfio/mdev/idxd/mdev.c |   95 +++++++++++++++++++++++++++++++++++++++++
 drivers/vfio/mdev/idxd/vdev.c |    3 -
 6 files changed, 147 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 84f996dd339d..390227027878 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -281,6 +281,7 @@ config INTEL_IDXD
 	depends on PCI && X86_64
 	depends on PCI_MSI
 	depends on SBITMAP
+	depends on IMS_MSI_ARRAY
 	select DMA_ENGINE
 	help
 	  Enable support for the Intel(R) data accelerators present
diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 2ea6015e0d53..cef41a273cc1 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -1257,6 +1257,7 @@ int drv_enable_wq(struct idxd_wq *wq)
 	mutex_unlock(&wq->wq_lock);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(drv_enable_wq);
 
 void __drv_disable_wq(struct idxd_wq *wq)
 {
@@ -1283,6 +1284,7 @@ void drv_disable_wq(struct idxd_wq *wq)
 	__drv_disable_wq(wq);
 	mutex_unlock(&wq->wq_lock);
 }
+EXPORT_SYMBOL_GPL(drv_disable_wq);
 
 int idxd_device_drv_probe(struct device *dev)
 {
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index cbb046c2921f..4d2532175705 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -11,6 +11,7 @@
 #include <linux/idr.h>
 #include <linux/pci.h>
 #include <linux/perf_event.h>
+#include <linux/mdev.h>
 #include "registers.h"
 
 #define IDXD_DRIVER_VERSION	"1.00"
@@ -60,6 +61,7 @@ static const char idxd_dsa_drv_name[] = "dsa";
 static const char idxd_dev_drv_name[] = "idxd";
 static const char idxd_dmaengine_drv_name[] = "dmaengine";
 static const char idxd_user_drv_name[] = "user";
+static const char idxd_mdev_drv_name[] = "mdev";
 
 struct idxd_irq_entry {
 	struct idxd_device *idxd;
@@ -297,6 +299,10 @@ struct idxd_device {
 	int *int_handles;
 
 	struct idxd_pmu *idxd_pmu;
+
+	struct kref mdev_kref;
+	struct mutex kref_lock; /* lock for the mdev_kref */
+	bool mdev_host_init;
 };
 
 /* IDXD software descriptor */
@@ -587,6 +593,10 @@ int idxd_cdev_get_major(struct idxd_device *idxd);
 int idxd_wq_add_cdev(struct idxd_wq *wq);
 void idxd_wq_del_cdev(struct idxd_wq *wq);
 
+/* mdev host */
+int idxd_mdev_host_init(struct idxd_device *idxd, struct mdev_driver *drv);
+void idxd_mdev_host_release(struct kref *kref);
+
 /* perfmon */
 #if IS_ENABLED(CONFIG_INTEL_IDXD_PERFMON)
 int perfmon_pmu_init(struct idxd_device *idxd);
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 16ff37be2d26..809ca1827772 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -63,6 +63,41 @@ static struct pci_device_id idxd_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, idxd_pci_tbl);
 
+int idxd_mdev_host_init(struct idxd_device *idxd, struct mdev_driver *drv)
+{
+	struct device *dev = &idxd->pdev->dev;
+	int rc;
+
+	if (!idxd->ims_size)
+		return -EOPNOTSUPP;
+
+	rc = iommu_dev_enable_feature(dev, IOMMU_DEV_FEAT_AUX);
+	if (rc < 0) {
+		dev_warn(dev, "Failed to enable aux-domain: %d\n", rc);
+		return rc;
+	}
+
+	rc = mdev_register_device(dev, drv);
+	if (rc < 0) {
+		iommu_dev_disable_feature(dev, IOMMU_DEV_FEAT_AUX);
+		return rc;
+	}
+
+	idxd->mdev_host_init = true;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(idxd_mdev_host_init);
+
+void idxd_mdev_host_release(struct kref *kref)
+{
+	struct idxd_device *idxd = container_of(kref, struct idxd_device, mdev_kref);
+	struct device *dev = &idxd->pdev->dev;
+
+	mdev_unregister_device(dev);
+	iommu_dev_disable_feature(dev, IOMMU_DEV_FEAT_AUX);
+}
+EXPORT_SYMBOL_GPL(idxd_mdev_host_release);
+
 static int idxd_setup_interrupts(struct idxd_device *idxd)
 {
 	struct pci_dev *pdev = idxd->pdev;
@@ -352,6 +387,9 @@ static int idxd_setup_internals(struct idxd_device *idxd)
 		goto err_wkq_create;
 	}
 
+	kref_init(&idxd->mdev_kref);
+	mutex_init(&idxd->kref_lock);
+
 	return 0;
 
  err_wkq_create:
@@ -741,6 +779,7 @@ static void idxd_remove(struct pci_dev *pdev)
 
 	dev_dbg(&pdev->dev, "%s called\n", __func__);
 	idxd_shutdown(pdev);
+	kref_put_mutex(&idxd->mdev_kref, idxd_mdev_host_release, &idxd->kref_lock);
 	if (device_pasid_enabled(idxd))
 		idxd_disable_system_pasid(idxd);
 	idxd_unregister_devices(idxd);
diff --git a/drivers/vfio/mdev/idxd/mdev.c b/drivers/vfio/mdev/idxd/mdev.c
index 90ff7cedb8b4..25cd62b803f8 100644
--- a/drivers/vfio/mdev/idxd/mdev.c
+++ b/drivers/vfio/mdev/idxd/mdev.c
@@ -16,6 +16,7 @@
 #include <linux/intel-svm.h>
 #include <linux/kvm_host.h>
 #include <linux/eventfd.h>
+#include <linux/irqchip/irq-ims-msi.h>
 #include <uapi/linux/idxd.h>
 #include "registers.h"
 #include "idxd.h"
@@ -40,5 +41,99 @@ int idxd_mdev_get_pasid(struct mdev_device *mdev, struct vfio_device *vdev, u32
 	return 0;
 }
 
+static struct mdev_driver idxd_vdcm_driver = {
+	.driver = {
+		.name = "idxd-mdev",
+		.owner = THIS_MODULE,
+		.mod_name = KBUILD_MODNAME,
+	},
+};
+
+static int idxd_mdev_drv_probe(struct device *dev)
+{
+	struct idxd_wq *wq = confdev_to_wq(dev);
+	struct idxd_device *idxd = wq->idxd;
+	int rc;
+
+	if (!is_idxd_wq_mdev(wq))
+		return -ENODEV;
+
+	rc = drv_enable_wq(wq);
+	if (rc < 0)
+		return rc;
+
+	/*
+	 * The kref count starts at 1 on initialization. So the first device gets
+	 * probed, we want to setup the mdev and do the host initialization. The
+	 * follow on probes the driver want to just take a kref. On the remove side, once
+	 * the kref hits 0, the driver will do the host cleanup and unregister from the
+	 * mdev framework.
+	 */
+	mutex_lock(&idxd->kref_lock);
+	if (!idxd->mdev_host_init) {
+		rc = idxd_mdev_host_init(idxd, &idxd_vdcm_driver);
+		if (rc < 0) {
+			mutex_unlock(&idxd->kref_lock);
+			drv_disable_wq(wq);
+			dev_warn(dev, "mdev device init failed!\n");
+			return -ENXIO;
+		}
+		idxd->mdev_host_init = true;
+	} else {
+		kref_get(&idxd->mdev_kref);
+	}
+	mutex_unlock(&idxd->kref_lock);
+
+	get_device(dev);
+	dev_info(dev, "wq %s enabled\n", dev_name(dev));
+	return 0;
+}
+
+static void idxd_mdev_drv_remove(struct device *dev)
+{
+	struct idxd_wq *wq = confdev_to_wq(dev);
+	struct idxd_device *idxd = wq->idxd;
+
+	drv_disable_wq(wq);
+	dev_info(dev, "wq %s disabled\n", dev_name(dev));
+	kref_put_mutex(&idxd->mdev_kref, idxd_mdev_host_release, &idxd->kref_lock);
+	put_device(dev);
+}
+
+static struct idxd_device_driver idxd_mdev_driver = {
+	.probe = idxd_mdev_drv_probe,
+	.remove = idxd_mdev_drv_remove,
+	.name = idxd_mdev_drv_name,
+};
+
+static int __init idxd_mdev_init(void)
+{
+	int rc;
+
+	rc = idxd_driver_register(&idxd_mdev_driver);
+	if (rc < 0)
+		return rc;
+
+	rc = mdev_register_driver(&idxd_vdcm_driver);
+	if (rc < 0) {
+		idxd_driver_unregister(&idxd_mdev_driver);
+		return rc;
+	}
+
+	return 0;
+}
+
+static void __exit idxd_mdev_exit(void)
+{
+	mdev_unregister_driver(&idxd_vdcm_driver);
+	idxd_driver_unregister(&idxd_mdev_driver);
+}
+
+module_init(idxd_mdev_init);
+module_exit(idxd_mdev_exit);
+
 MODULE_IMPORT_NS(IDXD);
+MODULE_SOFTDEP("pre: idxd");
 MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Intel Corporation");
+MODULE_ALIAS_IDXD_DEVICE(0);
diff --git a/drivers/vfio/mdev/idxd/vdev.c b/drivers/vfio/mdev/idxd/vdev.c
index d2416765ce7e..67da4c122a96 100644
--- a/drivers/vfio/mdev/idxd/vdev.c
+++ b/drivers/vfio/mdev/idxd/vdev.c
@@ -989,6 +989,3 @@ static void vidxd_do_command(struct vdcm_idxd *vidxd, u32 val)
 		break;
 	}
 }
-
-MODULE_IMPORT_NS(IDXD);
-MODULE_LICENSE("GPL v2");


