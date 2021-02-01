Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3358430ACA3
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 17:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbhBAQ3m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 11:29:42 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18256 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbhBAQ3e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 11:29:34 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60182c460001>; Mon, 01 Feb 2021 08:28:54 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 16:28:54 +0000
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Mon, 1 Feb 2021 16:28:49 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <jgg@nvidia.com>, <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alex.williamson@redhat.com>
CC:     <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <gmataev@nvidia.com>, <cjia@nvidia.com>,
        <mjrosato@linux.ibm.com>, <yishaih@nvidia.com>, <aik@ozlabs.ru>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 4/9] mlx5-vfio-pci: add new vfio_pci driver for mlx5 devices
Date:   Mon, 1 Feb 2021 16:28:23 +0000
Message-ID: <20210201162828.5938-5-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210201162828.5938-1-mgurtovoy@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612196934; bh=RAHP2ASTM/BLykC/BcLBJEeO0tfIjXdQEbZ9Djfh6cg=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        b=SontuV59JUGM5N0mL0CEMSORudCJgoQuMqyzxMpyL537LQytQPr5br4daSRMDeYZL
         rBdNyo1G0UNvK+43ZmWyPxKONl2xVGDhyTjGP9c1OYPU1fSMEaJx141XkShyofNslE
         xvOfxhXGnhMGDLY1jNShWFp1saewYeJJ5dnBehQJl2D+S9B+hDHW57rdCAKuAYq2JL
         Qhmaqe+bxcy5Bl1o4iU1UH92+W+N0a5WXmtkFl9pniswxQTcP8rhTKE3VfxrY6hI/Y
         6tsBxRsTr0mNaTybOzZiLrI2hxb/PE6v46dyirR5o36FePCtu7aIEjkPgRlXrL6KmU
         UFsb1SGBN7l4A==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This driver will register to PCI bus and Auxiliary bus. In case the
probe of both devices will succeed, we'll have a vendor specific VFIO
PCI device. mlx5_vfio_pci use vfio_pci_core to register and create a
VFIO device and use auxiliary_device to get the needed extension from
the vendor device driver. If one of the probe() functions will fail, the
VFIO char device will not be created. For now, only register and bind
the auxiliary_device to the pci_device in case we have a match between
the auxiliary_device id to the pci_device BDF. Later, vendor specific
features such as live migration will be added and will be available to
the virtualization software.

Note: Although we've created the mlx5-vfio-pci.ko, the binding to
vfio-pci.ko will still work as before. It's fully backward compatible.
Of course, the extended vendor functionality will not exist in case one
will bind the device to the generic vfio_pci.ko.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/pci/Kconfig         |  10 ++
 drivers/vfio/pci/Makefile        |   3 +
 drivers/vfio/pci/mlx5_vfio_pci.c | 253 +++++++++++++++++++++++++++++++
 include/linux/mlx5/vfio_pci.h    |  36 +++++
 4 files changed, 302 insertions(+)
 create mode 100644 drivers/vfio/pci/mlx5_vfio_pci.c
 create mode 100644 include/linux/mlx5/vfio_pci.h

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index b958a48f63a0..dcb164d7d641 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -65,3 +65,13 @@ config VFIO_PCI_ZDEV
 	  for zPCI devices passed through via VFIO on s390.
=20
 	  Say Y here.
+
+config MLX5_VFIO_PCI
+	tristate "VFIO support for MLX5 PCI devices"
+	depends on VFIO_PCI_CORE && MLX5_CORE
+	select AUXILIARY_BUS
+	help
+	  This provides a generic PCI support for MLX5 devices using the VFIO
+	  framework.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 3f2a27e222cd..9f67edca31c5 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -2,6 +2,7 @@
=20
 obj-$(CONFIG_VFIO_PCI_CORE) +=3D vfio-pci-core.o
 obj-$(CONFIG_VFIO_PCI) +=3D vfio-pci.o
+obj-$(CONFIG_MLX5_VFIO_PCI) +=3D mlx5-vfio-pci.o
=20
 vfio-pci-core-y :=3D vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio=
_pci_config.o
 vfio-pci-core-$(CONFIG_VFIO_PCI_IGD) +=3D vfio_pci_igd.o
@@ -9,3 +10,5 @@ vfio-pci-core-$(CONFIG_VFIO_PCI_NVLINK2) +=3D vfio_pci_nvl=
ink2.o
 vfio-pci-core-$(CONFIG_VFIO_PCI_ZDEV) +=3D vfio_pci_zdev.o
=20
 vfio-pci-y :=3D vfio_pci.o
+
+mlx5-vfio-pci-y :=3D mlx5_vfio_pci.o
diff --git a/drivers/vfio/pci/mlx5_vfio_pci.c b/drivers/vfio/pci/mlx5_vfio_=
pci.c
new file mode 100644
index 000000000000..4e6b256c74bf
--- /dev/null
+++ b/drivers/vfio/pci/mlx5_vfio_pci.c
@@ -0,0 +1,253 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2020, NVIDIA CORPORATION. All rights reserved.
+ *     Author: Max Gurtovoy <mgurtovoy@nvidia.com>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/device.h>
+#include <linux/eventfd.h>
+#include <linux/file.h>
+#include <linux/interrupt.h>
+#include <linux/iommu.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/notifier.h>
+#include <linux/pci.h>
+#include <linux/pm_runtime.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/vfio.h>
+#include <linux/sched/mm.h>
+#include <linux/mlx5/vfio_pci.h>
+
+#include "vfio_pci_core.h"
+
+#define DRIVER_VERSION  "0.1"
+#define DRIVER_AUTHOR   "Max Gurtovoy <mgurtovoy@nvidia.com>"
+#define DRIVER_DESC     "MLX5 VFIO PCI - User Level meta-driver for NVIDIA=
 MLX5 device family"
+
+/* 16k migration data size */
+#define MLX5_MIGRATION_REGION_DATA_SIZE	SZ_16K
+/* Data section offset from migration region */
+#define MLX5_MIGRATION_REGION_DATA_OFFSET  (sizeof(struct vfio_device_migr=
ation_info))
+
+struct mlx5_vfio_pci_migration_info {
+	struct vfio_device_migration_info mig;
+	char data[MLX5_MIGRATION_REGION_DATA_SIZE];
+};
+
+static LIST_HEAD(aux_devs_list);
+static DEFINE_MUTEX(aux_devs_lock);
+
+static struct mlx5_vfio_pci_adev *mlx5_vfio_pci_find_adev(struct pci_dev *=
pdev)
+{
+	struct mlx5_vfio_pci_adev *mvadev, *found =3D NULL;
+
+	mutex_lock(&aux_devs_lock);
+	list_for_each_entry(mvadev, &aux_devs_list, entry) {
+		if (mvadev->madev.adev.id =3D=3D pci_dev_id(pdev)) {
+			found =3D mvadev;
+			break;
+		}
+	}
+	mutex_unlock(&aux_devs_lock);
+
+	return found;
+}
+
+static int mlx5_vfio_pci_aux_probe(struct auxiliary_device *adev,
+		const struct auxiliary_device_id *id)
+{
+	struct mlx5_vfio_pci_adev *mvadev;
+
+	mvadev =3D adev_to_mvadev(adev);
+
+	pr_info("%s aux probing bdf %02x:%02x.%d mdev is %s\n",
+		adev->name,
+		PCI_BUS_NUM(adev->id & 0xffff),
+		PCI_SLOT(adev->id & 0xff),
+		PCI_FUNC(adev->id & 0xff), dev_name(mvadev->madev.mdev->device));
+
+	mutex_lock(&aux_devs_lock);
+	list_add(&mvadev->entry, &aux_devs_list);
+	mutex_unlock(&aux_devs_lock);
+
+	return 0;
+}
+
+static void mlx5_vfio_pci_aux_remove(struct auxiliary_device *adev)
+{
+	struct mlx5_vfio_pci_adev *mvadev =3D adev_to_mvadev(adev);
+	struct vfio_pci_core_device *vpdev =3D dev_get_drvdata(&adev->dev);
+
+	/* TODO: is this the right thing to do ? maybe FLR ? */
+	if (vpdev)
+		pci_reset_function(vpdev->pdev);
+
+	mutex_lock(&aux_devs_lock);
+	list_del(&mvadev->entry);
+	mutex_unlock(&aux_devs_lock);
+}
+
+static const struct auxiliary_device_id mlx5_vfio_pci_aux_id_table[] =3D {
+	{ .name =3D MLX5_ADEV_NAME ".vfio_pci", },
+	{},
+};
+
+MODULE_DEVICE_TABLE(auxiliary, mlx5_vfio_pci_aux_id_table);
+
+static struct auxiliary_driver mlx5_vfio_pci_aux_driver =3D {
+	.name =3D "vfio_pci_ex",
+	.probe =3D mlx5_vfio_pci_aux_probe,
+	.remove =3D mlx5_vfio_pci_aux_remove,
+	.id_table =3D mlx5_vfio_pci_aux_id_table,
+};
+
+static void mlx5_vfio_pci_mig_release(struct vfio_pci_core_device *vpdev,
+		struct vfio_pci_region *region)
+{
+	kfree(region->data);
+}
+
+static size_t mlx5_vfio_pci_mig_rw(struct vfio_pci_core_device *vpdev,
+		char __user *buf, size_t count, loff_t *ppos, bool iswrite)
+{
+	/* TODO: add all migration logic here */
+
+	return -EINVAL;
+}
+
+static struct vfio_pci_regops migraion_ops =3D {
+	.rw =3D mlx5_vfio_pci_mig_rw,
+	.release =3D mlx5_vfio_pci_mig_release,
+};
+
+static int mlx5_vfio_pci_op_init(struct vfio_pci_core_device *vpdev)
+{
+	struct mlx5_vfio_pci_migration_info *vmig;
+	int ret;
+
+	vmig =3D kzalloc(sizeof(*vmig), GFP_KERNEL);
+	if (!vmig)
+		return -ENOMEM;
+
+	ret =3D vfio_pci_register_dev_region(vpdev,
+			VFIO_REGION_TYPE_MIGRATION,
+			VFIO_REGION_SUBTYPE_MIGRATION,
+			&migraion_ops, sizeof(*vmig),
+			VFIO_REGION_INFO_FLAG_READ |
+			VFIO_REGION_INFO_FLAG_WRITE, vmig);
+	if (ret)
+		goto out_free;
+
+	return 0;
+
+out_free:
+	kfree(vmig);
+	return ret;
+}
+
+static const struct vfio_pci_device_ops mlx5_vfio_pci_ops =3D {
+	.name		=3D "mlx5-vfio-pci",
+	.module		=3D THIS_MODULE,
+	.init		=3D mlx5_vfio_pci_op_init,
+};
+
+static int mlx5_vfio_pci_probe(struct pci_dev *pdev, const struct pci_devi=
ce_id *id)
+{
+	struct vfio_pci_core_device *vpdev;
+	struct mlx5_vfio_pci_adev *mvadev;
+
+	mvadev =3D mlx5_vfio_pci_find_adev(pdev);
+	if (!mvadev) {
+		pr_err("failed to find aux device for %s\n",
+		       dev_name(&pdev->dev));
+		return -ENODEV;
+	}
+
+	vpdev =3D vfio_create_pci_device(pdev, &mlx5_vfio_pci_ops, mvadev);
+	if (IS_ERR(vpdev))
+		return PTR_ERR(vpdev);
+
+	dev_set_drvdata(&mvadev->madev.adev.dev, vpdev);
+	return 0;
+}
+
+static void mlx5_vfio_pci_remove(struct pci_dev *pdev)
+{
+	struct mlx5_vfio_pci_adev *mvadev;
+
+	mvadev =3D mlx5_vfio_pci_find_adev(pdev);
+	if (mvadev)
+		dev_set_drvdata(&mvadev->madev.adev.dev, NULL);
+
+	vfio_destroy_pci_device(pdev);
+}
+
+#ifdef CONFIG_PCI_IOV
+static int mlx5_vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virt=
fn)
+{
+	might_sleep();
+
+	/* DO vendor specific stuff here */
+
+	return vfio_pci_core_sriov_configure(pdev, nr_virtfn);
+}
+#endif
+
+static const struct pci_error_handlers mlx5_vfio_err_handlers =3D {
+	.error_detected =3D vfio_pci_core_aer_err_detected,
+};
+
+static const struct pci_device_id mlx5_vfio_pci_table[] =3D {
+	{ PCI_VDEVICE(MELLANOX, 0x6001) }, /* NVMe SNAP controllers */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_REDHAT_QUMRANET, 0x1042,
+			 PCI_VENDOR_ID_MELLANOX, PCI_ANY_ID) }, /* Virtio SNAP controllers */
+	{ 0, }
+};
+
+static struct pci_driver mlx5_vfio_pci_driver =3D {
+	.name			=3D "mlx5-vfio-pci",
+	.id_table		=3D mlx5_vfio_pci_table,
+	.probe			=3D mlx5_vfio_pci_probe,
+	.remove			=3D mlx5_vfio_pci_remove,
+#ifdef CONFIG_PCI_IOV
+	.sriov_configure	=3D mlx5_vfio_pci_sriov_configure,
+#endif
+	.err_handler		=3D &mlx5_vfio_err_handlers,
+};
+
+static void __exit mlx5_vfio_pci_cleanup(void)
+{
+	auxiliary_driver_unregister(&mlx5_vfio_pci_aux_driver);
+	pci_unregister_driver(&mlx5_vfio_pci_driver);
+}
+
+static int __init mlx5_vfio_pci_init(void)
+{
+	int ret;
+
+	ret =3D pci_register_driver(&mlx5_vfio_pci_driver);
+	if (ret)
+		return ret;
+
+	ret =3D auxiliary_driver_register(&mlx5_vfio_pci_aux_driver);
+	if (ret)
+		goto out_unregister;
+
+	return 0;
+
+out_unregister:
+	pci_unregister_driver(&mlx5_vfio_pci_driver);
+	return ret;
+}
+
+module_init(mlx5_vfio_pci_init);
+module_exit(mlx5_vfio_pci_cleanup);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/include/linux/mlx5/vfio_pci.h b/include/linux/mlx5/vfio_pci.h
new file mode 100644
index 000000000000..c1e7b4d6da30
--- /dev/null
+++ b/include/linux/mlx5/vfio_pci.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/*
+ * Copyright (c) 2020 NVIDIA Corporation
+ */
+
+#ifndef _VFIO_PCI_H
+#define _VFIO_PCI_H
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/auxiliary_bus.h>
+#include <linux/mlx5/device.h>
+#include <linux/mlx5/driver.h>
+
+struct mlx5_vfio_pci_adev {
+	struct mlx5_adev	madev;
+
+	/* These fields should not be used outside mlx5_vfio_pci.ko */
+	struct list_head		entry;
+};
+
+static inline struct mlx5_vfio_pci_adev*
+madev_to_mvadev(struct mlx5_adev *madev)
+{
+	return container_of(madev, struct mlx5_vfio_pci_adev, madev);
+}
+
+static inline struct mlx5_vfio_pci_adev*
+adev_to_mvadev(struct auxiliary_device *adev)
+{
+	struct mlx5_adev *madev =3D container_of(adev, struct mlx5_adev, adev);
+
+	return madev_to_mvadev(madev);
+}
+
+#endif
--=20
2.25.4

