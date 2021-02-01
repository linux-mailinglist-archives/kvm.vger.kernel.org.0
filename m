Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E8830AC97
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 17:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbhBAQ3c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 11:29:32 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18215 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhBAQ30 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 11:29:26 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60182c3c0002>; Mon, 01 Feb 2021 08:28:44 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 16:28:43 +0000
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Mon, 1 Feb 2021 16:28:39 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <jgg@nvidia.com>, <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alex.williamson@redhat.com>
CC:     <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <gmataev@nvidia.com>, <cjia@nvidia.com>,
        <mjrosato@linux.ibm.com>, <yishaih@nvidia.com>, <aik@ozlabs.ru>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 2/9] vfio-pci: introduce vfio_pci_core subsystem driver
Date:   Mon, 1 Feb 2021 16:28:21 +0000
Message-ID: <20210201162828.5938-3-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210201162828.5938-1-mgurtovoy@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612196924; bh=9d0yweuqNZWfN+x+sRLvSxhX+yDBOEfeuNGarXcfmcI=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        b=K86eiQJjY3R4Do7xeUWvgVbFfnUo70I4XoWQRsRNVY6dF2qjP3WKXNqHu3V9hPS5I
         UzV+epyBvPHhQ/+h30DsyNMzV2HXunrwXy4vr5sW7BV2TlhIA0LNV1F+TKhLJMAEpp
         dmp4vitT7nLiQ2H4+PqUjIKLx417EttdLcTr1CgN/AzWB6L9+9lAJBbcQH8sMLeo6Z
         7ghvkdgRugGZLhuyf+a+/PhmUIAZAE8wZV3X4nWNGAHqNQ/2Lmd9Jgh8EgT+zaBFDd
         cw+VMsZ2cSOy9TVYxFzoy32GPR5f2onAAX3gUOgmBdHq//jjws8d3Atx5Sh4SfWI+F
         IlHMqbl2o8F0Q==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split the vfio_pci driver into two parts, the 'struct pci_driver'
(vfio_pci) and a library of code (vfio_pci_core) that helps creating a
VFIO device on top of a PCI device.

As before vfio_pci.ko continues to present the same interface under
sysfs and this change should have no functional impact.

vfio_pci_core exposes an interface that is similar to a typical
Linux subsystem, in that a pci_driver doing probe() can setup a number
of details and then create the VFIO char device.

Allowing another module to provide the pci_driver allows that module
to customize how VFIO is setup, inject its own operations, and easily
extend vendor specific functionality.

This is complementary to how VFIO's mediated devices work. Instead of
custome device lifecycle managmenet and a special bus drivers using
this approach will rely on the normal driver core lifecycle (eg
bind/unbind) management and this is optimized to effectively support
customization that is only making small modifications to what vfio_pci
would do normally.

This approach is also a pluggable alternative for the hard wired
CONFIG_VFIO_PCI_IG and CONFIG_VFIO_PCI_NVLINK2 "drivers" that are
built into vfio-pci. Using this work all of that code can be moved to
a dedicated device-specific modules and cleanly split out of the
generic vfio_pci driver.

Below is an example for adding new driver to vfio pci subsystem:
	+----------------------------------+
	|                                  |
	|           VFIO                   |
	|                                  |
	+----------------------------------+

	+----------------------------------+
	|                                  |
	|           VFIO_PCI_CORE          |
	|                                  |
	+----------------------------------+

	+----------------+ +---------------+
	|                | |               |
	|  VFIO_PCI      | | MLX5_VFIO_PCI |
	|                | |               |
	+----------------+ +---------------+

In this way mlx5_vfio_pci will use vfio_pci_core to register to vfio
subsystem and also use the generic PCI functionality exported from it.
Additionally it will add the needed vendor specific logic for HW
specific features such as Live Migration.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/pci/Kconfig            |  24 +-
 drivers/vfio/pci/Makefile           |  13 +-
 drivers/vfio/pci/vfio_pci.c         | 202 ++++++++++++++
 drivers/vfio/pci/vfio_pci_config.c  |  56 ++--
 drivers/vfio/pci/vfio_pci_core.c    | 392 ++++++++++------------------
 drivers/vfio/pci/vfio_pci_core.h    |  45 ++++
 drivers/vfio/pci/vfio_pci_igd.c     |   2 +-
 drivers/vfio/pci/vfio_pci_intrs.c   |  22 +-
 drivers/vfio/pci/vfio_pci_nvlink2.c |  24 +-
 drivers/vfio/pci/vfio_pci_private.h |   4 +-
 drivers/vfio/pci/vfio_pci_rdwr.c    |  14 +-
 drivers/vfio/pci/vfio_pci_zdev.c    |   2 +-
 12 files changed, 471 insertions(+), 329 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci.c
 create mode 100644 drivers/vfio/pci/vfio_pci_core.h

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 40a223381ab6..b958a48f63a0 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
-config VFIO_PCI
-	tristate "VFIO support for PCI devices"
+config VFIO_PCI_CORE
+	tristate "VFIO core support for PCI devices"
 	depends on VFIO && PCI && EVENTFD
 	select VFIO_VIRQFD
 	select IRQ_BYPASS_MANAGER
@@ -10,9 +10,17 @@ config VFIO_PCI
=20
 	  If you don't know what to do here, say N.
=20
+config VFIO_PCI
+	tristate "VFIO support for PCI devices"
+	depends on VFIO_PCI_CORE
+	help
+	  This provides a generic PCI support using the VFIO framework.
+
+	  If you don't know what to do here, say N.
+
 config VFIO_PCI_VGA
 	bool "VFIO PCI support for VGA devices"
-	depends on VFIO_PCI && X86 && VGA_ARB
+	depends on VFIO_PCI_CORE && X86 && VGA_ARB
 	help
 	  Support for VGA extension to VFIO PCI.  This exposes an additional
 	  region on VGA devices for accessing legacy VGA addresses used by
@@ -21,16 +29,16 @@ config VFIO_PCI_VGA
 	  If you don't know what to do here, say N.
=20
 config VFIO_PCI_MMAP
-	depends on VFIO_PCI
+	depends on VFIO_PCI_CORE
 	def_bool y if !S390
=20
 config VFIO_PCI_INTX
-	depends on VFIO_PCI
+	depends on VFIO_PCI_CORE
 	def_bool y if !S390
=20
 config VFIO_PCI_IGD
 	bool "VFIO PCI extensions for Intel graphics (GVT-d)"
-	depends on VFIO_PCI && X86
+	depends on VFIO_PCI_CORE && X86
 	default y
 	help
 	  Support for Intel IGD specific extensions to enable direct
@@ -42,13 +50,13 @@ config VFIO_PCI_IGD
=20
 config VFIO_PCI_NVLINK2
 	def_bool y
-	depends on VFIO_PCI && PPC_POWERNV
+	depends on VFIO_PCI_CORE && PPC_POWERNV
 	help
 	  VFIO PCI support for P9 Witherspoon machine with NVIDIA V100 GPUs
=20
 config VFIO_PCI_ZDEV
 	bool "VFIO PCI ZPCI device CLP support"
-	depends on VFIO_PCI && S390
+	depends on VFIO_PCI_CORE && S390
 	default y
 	help
 	  Enabling this option exposes VFIO capabilities containing hardware
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index d5555d350b9b..3f2a27e222cd 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -1,8 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0-only
=20
-vfio-pci-y :=3D vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_=
config.o
-vfio-pci-$(CONFIG_VFIO_PCI_IGD) +=3D vfio_pci_igd.o
-vfio-pci-$(CONFIG_VFIO_PCI_NVLINK2) +=3D vfio_pci_nvlink2.o
-vfio-pci-$(CONFIG_VFIO_PCI_ZDEV) +=3D vfio_pci_zdev.o
-
+obj-$(CONFIG_VFIO_PCI_CORE) +=3D vfio-pci-core.o
 obj-$(CONFIG_VFIO_PCI) +=3D vfio-pci.o
+
+vfio-pci-core-y :=3D vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio=
_pci_config.o
+vfio-pci-core-$(CONFIG_VFIO_PCI_IGD) +=3D vfio_pci_igd.o
+vfio-pci-core-$(CONFIG_VFIO_PCI_NVLINK2) +=3D vfio_pci_nvlink2.o
+vfio-pci-core-$(CONFIG_VFIO_PCI_ZDEV) +=3D vfio_pci_zdev.o
+
+vfio-pci-y :=3D vfio_pci.o
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
new file mode 100644
index 000000000000..fa97420953d8
--- /dev/null
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -0,0 +1,202 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2020, NVIDIA CORPORATION. All rights reserved.
+ *
+ * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
+ *     Author: Alex Williamson <alex.williamson@redhat.com>
+ *
+ * Derived from original vfio:
+ * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
+ * Author: Tom Lyon, pugs@cisco.com
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
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+
+#include "vfio_pci_core.h"
+
+#define DRIVER_VERSION  "0.2"
+#define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
+#define DRIVER_DESC     "VFIO PCI - User Level meta-driver"
+
+static char ids[1024] __initdata;
+module_param_string(ids, ids, sizeof(ids), 0);
+MODULE_PARM_DESC(ids, "Initial PCI IDs to add to the vfio driver, format i=
s \"vendor:device[:subvendor[:subdevice[:class[:class_mask]]]]\" and multip=
le comma separated entries can be specified");
+
+static bool enable_sriov;
+#ifdef CONFIG_PCI_IOV
+module_param(enable_sriov, bool, 0644);
+MODULE_PARM_DESC(enable_sriov, "Enable support for SR-IOV configuration.  =
Enabling SR-IOV on a PF typically requires support of the userspace PF driv=
er, enabling VFs without such support may result in non-functional VFs or P=
F.");
+#endif
+
+static bool disable_denylist;
+module_param(disable_denylist, bool, 0444);
+MODULE_PARM_DESC(disable_denylist, "Disable use of device denylist. Disabl=
ing the denylist allows binding to devices with known errata that may lead =
to exploitable stability or security issues when accessed by untrusted user=
s.");
+
+static bool vfio_pci_dev_in_denylist(struct pci_dev *pdev)
+{
+	switch (pdev->vendor) {
+	case PCI_VENDOR_ID_INTEL:
+		switch (pdev->device) {
+		case PCI_DEVICE_ID_INTEL_QAT_C3XXX:
+		case PCI_DEVICE_ID_INTEL_QAT_C3XXX_VF:
+		case PCI_DEVICE_ID_INTEL_QAT_C62X:
+		case PCI_DEVICE_ID_INTEL_QAT_C62X_VF:
+		case PCI_DEVICE_ID_INTEL_QAT_DH895XCC:
+		case PCI_DEVICE_ID_INTEL_QAT_DH895XCC_VF:
+			return true;
+		default:
+			return false;
+		}
+	}
+
+	return false;
+}
+
+static bool vfio_pci_is_denylisted(struct pci_dev *pdev)
+{
+	if (!vfio_pci_dev_in_denylist(pdev))
+		return false;
+
+	if (disable_denylist) {
+		pci_warn(pdev,
+			 "device denylist disabled - allowing device %04x:%04x.\n",
+			 pdev->vendor, pdev->device);
+		return false;
+	}
+
+	pci_warn(pdev, "%04x:%04x exists in vfio-pci device denylist, driver prob=
ing disallowed.\n",
+		 pdev->vendor, pdev->device);
+
+	return true;
+}
+
+static const struct vfio_pci_device_ops vfio_pci_ops =3D {
+	.name		=3D "vfio-pci",
+	.module		=3D THIS_MODULE,
+};
+
+static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id=
 *id)
+{
+	struct vfio_pci_core_device *vpdev;
+
+	if (vfio_pci_is_denylisted(pdev))
+		return -EINVAL;
+
+	vpdev =3D vfio_create_pci_device(pdev, &vfio_pci_ops, NULL);
+	if (IS_ERR(vpdev))
+		return PTR_ERR(vpdev);
+
+	return 0;
+}
+
+static void vfio_pci_remove(struct pci_dev *pdev)
+{
+	vfio_destroy_pci_device(pdev);
+}
+
+static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
+{
+	might_sleep();
+
+	if (!enable_sriov)
+		return -ENOENT;
+
+	return vfio_pci_core_sriov_configure(pdev, nr_virtfn);
+}
+
+static const struct pci_error_handlers vfio_err_handlers =3D {
+	.error_detected =3D vfio_pci_core_aer_err_detected,
+};
+
+static struct pci_driver vfio_pci_driver =3D {
+	.name			=3D "vfio-pci",
+	.id_table		=3D NULL, /* only dynamic ids */
+	.probe			=3D vfio_pci_probe,
+	.remove			=3D vfio_pci_remove,
+	.sriov_configure	=3D vfio_pci_sriov_configure,
+	.err_handler		=3D &vfio_err_handlers,
+};
+
+static void __exit vfio_pci_cleanup(void)
+{
+	pci_unregister_driver(&vfio_pci_driver);
+}
+
+static void __init vfio_pci_fill_ids(void)
+{
+	char *p, *id;
+	int rc;
+
+	/* no ids passed actually */
+	if (ids[0] =3D=3D '\0')
+		return;
+
+	/* add ids specified in the module parameter */
+	p =3D ids;
+	while ((id =3D strsep(&p, ","))) {
+		unsigned int vendor, device, subvendor =3D PCI_ANY_ID,
+			subdevice =3D PCI_ANY_ID, class =3D 0, class_mask =3D 0;
+		int fields;
+
+		if (!strlen(id))
+			continue;
+
+		fields =3D sscanf(id, "%x:%x:%x:%x:%x:%x",
+				&vendor, &device, &subvendor, &subdevice,
+				&class, &class_mask);
+
+		if (fields < 2) {
+			pr_warn("invalid id string \"%s\"\n", id);
+			continue;
+		}
+
+		rc =3D pci_add_dynid(&vfio_pci_driver, vendor, device,
+				   subvendor, subdevice, class, class_mask, 0);
+		if (rc)
+			pr_warn("failed to add dynamic id [%04x:%04x[%04x:%04x]] class %#08x/%0=
8x (%d)\n",
+				vendor, device, subvendor, subdevice,
+				class, class_mask, rc);
+		else
+			pr_info("add [%04x:%04x[%04x:%04x]] class %#08x/%08x\n",
+				vendor, device, subvendor, subdevice,
+				class, class_mask);
+	}
+}
+
+static int __init vfio_pci_init(void)
+{
+	int ret;
+
+	/* Register and scan for devices */
+	ret =3D pci_register_driver(&vfio_pci_driver);
+	if (ret)
+		return ret;
+
+	vfio_pci_fill_ids();
+
+	if (disable_denylist)
+		pr_warn("device denylist disabled.\n");
+
+	return 0;
+}
+
+module_init(vfio_pci_init);
+module_exit(vfio_pci_cleanup);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci=
_config.c
index a402adee8a21..105fbae9c035 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -183,7 +183,7 @@ static int vfio_default_config_read(struct vfio_pci_dev=
ice *vdev, int pos,
=20
 	/* Any non-virtualized bits? */
 	if (cpu_to_le32(~0U >> (32 - (count * 8))) !=3D virt) {
-		struct pci_dev *pdev =3D vdev->pdev;
+		struct pci_dev *pdev =3D vdev->vpdev.pdev;
 		__le32 phys_val =3D 0;
 		int ret;
=20
@@ -224,7 +224,7 @@ static int vfio_default_config_write(struct vfio_pci_de=
vice *vdev, int pos,
=20
 	/* Non-virtualzed and writable bits go to hardware */
 	if (write & ~virt) {
-		struct pci_dev *pdev =3D vdev->pdev;
+		struct pci_dev *pdev =3D vdev->vpdev.pdev;
 		__le32 phys_val =3D 0;
 		int ret;
=20
@@ -250,7 +250,7 @@ static int vfio_direct_config_read(struct vfio_pci_devi=
ce *vdev, int pos,
 {
 	int ret;
=20
-	ret =3D vfio_user_config_read(vdev->pdev, pos, val, count);
+	ret =3D vfio_user_config_read(vdev->vpdev.pdev, pos, val, count);
 	if (ret)
 		return ret;
=20
@@ -275,7 +275,7 @@ static int vfio_raw_config_write(struct vfio_pci_device=
 *vdev, int pos,
 {
 	int ret;
=20
-	ret =3D vfio_user_config_write(vdev->pdev, pos, val, count);
+	ret =3D vfio_user_config_write(vdev->vpdev.pdev, pos, val, count);
 	if (ret)
 		return ret;
=20
@@ -288,7 +288,7 @@ static int vfio_raw_config_read(struct vfio_pci_device =
*vdev, int pos,
 {
 	int ret;
=20
-	ret =3D vfio_user_config_read(vdev->pdev, pos, val, count);
+	ret =3D vfio_user_config_read(vdev->vpdev.pdev, pos, val, count);
 	if (ret)
 		return ret;
=20
@@ -398,7 +398,7 @@ static inline void p_setd(struct perm_bits *p, int off,=
 u32 virt, u32 write)
 /* Caller should hold memory_lock semaphore */
 bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	u16 cmd =3D le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
=20
 	/*
@@ -415,7 +415,7 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_device *=
vdev)
  */
 static void vfio_bar_restore(struct vfio_pci_device *vdev)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	u32 *rbar =3D vdev->rbar;
 	u16 cmd;
 	int i;
@@ -462,7 +462,7 @@ static __le32 vfio_generate_bar_flags(struct pci_dev *p=
dev, int bar)
  */
 static void vfio_bar_fixup(struct vfio_pci_device *vdev)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	int i;
 	__le32 *vbar;
 	u64 mask;
@@ -524,7 +524,7 @@ static int vfio_basic_config_read(struct vfio_pci_devic=
e *vdev, int pos,
 	count =3D vfio_default_config_read(vdev, pos, count, perm, offset, val);
=20
 	/* Mask in virtual memory enable */
-	if (offset =3D=3D PCI_COMMAND && vdev->pdev->no_command_memory) {
+	if (offset =3D=3D PCI_COMMAND && vdev->vpdev.pdev->no_command_memory) {
 		u16 cmd =3D le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
 		u32 tmp_val =3D le32_to_cpu(*val);
=20
@@ -543,7 +543,7 @@ static bool vfio_need_bar_restore(struct vfio_pci_devic=
e *vdev)
=20
 	for (; pos <=3D PCI_BASE_ADDRESS_5; i++, pos +=3D 4) {
 		if (vdev->rbar[i]) {
-			ret =3D pci_user_read_config_dword(vdev->pdev, pos, &bar);
+			ret =3D pci_user_read_config_dword(vdev->vpdev.pdev, pos, &bar);
 			if (ret || vdev->rbar[i] !=3D bar)
 				return true;
 		}
@@ -556,7 +556,7 @@ static int vfio_basic_config_write(struct vfio_pci_devi=
ce *vdev, int pos,
 				   int count, struct perm_bits *perm,
 				   int offset, __le32 val)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	__le16 *virt_cmd;
 	u16 new_cmd =3D 0;
 	int ret;
@@ -751,7 +751,7 @@ static int vfio_vpd_config_write(struct vfio_pci_device=
 *vdev, int pos,
 				 int count, struct perm_bits *perm,
 				 int offset, __le32 val)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	__le16 *paddr =3D (__le16 *)(vdev->vconfig + pos - offset + PCI_VPD_ADDR)=
;
 	__le32 *pdata =3D (__le32 *)(vdev->vconfig + pos - offset + PCI_VPD_DATA)=
;
 	u16 addr;
@@ -853,13 +853,13 @@ static int vfio_exp_config_write(struct vfio_pci_devi=
ce *vdev, int pos,
=20
 		*ctrl &=3D ~cpu_to_le16(PCI_EXP_DEVCTL_BCR_FLR);
=20
-		ret =3D pci_user_read_config_dword(vdev->pdev,
+		ret =3D pci_user_read_config_dword(vdev->vpdev.pdev,
 						 pos - offset + PCI_EXP_DEVCAP,
 						 &cap);
=20
 		if (!ret && (cap & PCI_EXP_DEVCAP_FLR)) {
 			vfio_pci_zap_and_down_write_memory_lock(vdev);
-			pci_try_reset_function(vdev->pdev);
+			pci_try_reset_function(vdev->vpdev.pdev);
 			up_write(&vdev->memory_lock);
 		}
 	}
@@ -880,9 +880,9 @@ static int vfio_exp_config_write(struct vfio_pci_device=
 *vdev, int pos,
 	if (readrq !=3D (le16_to_cpu(*ctrl) & PCI_EXP_DEVCTL_READRQ)) {
 		readrq =3D 128 <<
 			((le16_to_cpu(*ctrl) & PCI_EXP_DEVCTL_READRQ) >> 12);
-		readrq =3D max(readrq, pcie_get_mps(vdev->pdev));
+		readrq =3D max(readrq, pcie_get_mps(vdev->vpdev.pdev));
=20
-		pcie_set_readrq(vdev->pdev, readrq);
+		pcie_set_readrq(vdev->vpdev.pdev, readrq);
 	}
=20
 	return count;
@@ -935,13 +935,13 @@ static int vfio_af_config_write(struct vfio_pci_devic=
e *vdev, int pos,
=20
 		*ctrl &=3D ~PCI_AF_CTRL_FLR;
=20
-		ret =3D pci_user_read_config_byte(vdev->pdev,
+		ret =3D pci_user_read_config_byte(vdev->vpdev.pdev,
 						pos - offset + PCI_AF_CAP,
 						&cap);
=20
 		if (!ret && (cap & PCI_AF_CAP_FLR) && (cap & PCI_AF_CAP_TP)) {
 			vfio_pci_zap_and_down_write_memory_lock(vdev);
-			pci_try_reset_function(vdev->pdev);
+			pci_try_reset_function(vdev->vpdev.pdev);
 			up_write(&vdev->memory_lock);
 		}
 	}
@@ -1141,7 +1141,7 @@ static int vfio_msi_config_write(struct vfio_pci_devi=
ce *vdev, int pos,
=20
 		/* Write back to virt and to hardware */
 		*pflags =3D cpu_to_le16(flags);
-		ret =3D pci_user_write_config_word(vdev->pdev,
+		ret =3D pci_user_write_config_word(vdev->vpdev.pdev,
 						 start + PCI_MSI_FLAGS,
 						 flags);
 		if (ret)
@@ -1191,7 +1191,7 @@ static int init_pci_cap_msi_perm(struct perm_bits *pe=
rm, int len, u16 flags)
 /* Determine MSI CAP field length; initialize msi_perms on 1st call per vd=
ev */
 static int vfio_msi_cap_len(struct vfio_pci_device *vdev, u8 pos)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	int len, ret;
 	u16 flags;
=20
@@ -1224,7 +1224,7 @@ static int vfio_msi_cap_len(struct vfio_pci_device *v=
dev, u8 pos)
 /* Determine extended capability length for VC (2 & 9) and MFVC */
 static int vfio_vc_cap_len(struct vfio_pci_device *vdev, u16 pos)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	u32 tmp;
 	int ret, evcc, phases, vc_arb;
 	int len =3D PCI_CAP_VC_BASE_SIZEOF;
@@ -1265,7 +1265,7 @@ static int vfio_vc_cap_len(struct vfio_pci_device *vd=
ev, u16 pos)
=20
 static int vfio_cap_len(struct vfio_pci_device *vdev, u8 cap, u8 pos)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	u32 dword;
 	u16 word;
 	u8 byte;
@@ -1340,7 +1340,7 @@ static int vfio_cap_len(struct vfio_pci_device *vdev,=
 u8 cap, u8 pos)
=20
 static int vfio_ext_cap_len(struct vfio_pci_device *vdev, u16 ecap, u16 ep=
os)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	u8 byte;
 	u32 dword;
 	int ret;
@@ -1415,7 +1415,7 @@ static int vfio_ext_cap_len(struct vfio_pci_device *v=
dev, u16 ecap, u16 epos)
 static int vfio_fill_vconfig_bytes(struct vfio_pci_device *vdev,
 				   int offset, int size)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	int ret =3D 0;
=20
 	/*
@@ -1461,7 +1461,7 @@ static int vfio_fill_vconfig_bytes(struct vfio_pci_de=
vice *vdev,
=20
 static int vfio_cap_init(struct vfio_pci_device *vdev)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	u8 *map =3D vdev->pci_config_map;
 	u16 status;
 	u8 pos, *prev, cap;
@@ -1551,7 +1551,7 @@ static int vfio_cap_init(struct vfio_pci_device *vdev=
)
=20
 static int vfio_ecap_init(struct vfio_pci_device *vdev)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	u8 *map =3D vdev->pci_config_map;
 	u16 epos;
 	__le32 *prev =3D NULL;
@@ -1671,7 +1671,7 @@ static const struct pci_device_id known_bogus_vf_intx=
_pin[] =3D {
  */
 int vfio_config_init(struct vfio_pci_device *vdev)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	u8 *map, *vconfig;
 	int ret;
=20
@@ -1805,7 +1805,7 @@ static size_t vfio_pci_cap_remaining_dword(struct vfi=
o_pci_device *vdev,
 static ssize_t vfio_config_do_rw(struct vfio_pci_device *vdev, char __user=
 *buf,
 				 size_t count, loff_t *ppos, bool iswrite)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	struct perm_bits *perm;
 	__le32 val =3D 0;
 	int cap_start =3D 0, offset;
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_c=
ore.c
index 706de3ef94bb..d5bf01132c23 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -32,11 +32,7 @@
=20
 #define DRIVER_VERSION  "0.2"
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
-#define DRIVER_DESC     "VFIO PCI - User Level meta-driver"
-
-static char ids[1024] __initdata;
-module_param_string(ids, ids, sizeof(ids), 0);
-MODULE_PARM_DESC(ids, "Initial PCI IDs to add to the vfio driver, format i=
s \"vendor:device[:subvendor[:subdevice[:class[:class_mask]]]]\" and multip=
le comma separated entries can be specified");
+#define DRIVER_DESC "core driver for VFIO based PCI devices"
=20
 static bool nointxmask;
 module_param_named(nointxmask, nointxmask, bool, S_IRUGO | S_IWUSR);
@@ -54,16 +50,6 @@ module_param(disable_idle_d3, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(disable_idle_d3,
 		 "Disable using the PCI D3 low power state for idle, unused devices");
=20
-static bool enable_sriov;
-#ifdef CONFIG_PCI_IOV
-module_param(enable_sriov, bool, 0644);
-MODULE_PARM_DESC(enable_sriov, "Enable support for SR-IOV configuration.  =
Enabling SR-IOV on a PF typically requires support of the userspace PF driv=
er, enabling VFs without such support may result in non-functional VFs or P=
F.");
-#endif
-
-static bool disable_denylist;
-module_param(disable_denylist, bool, 0444);
-MODULE_PARM_DESC(disable_denylist, "Disable use of device denylist. Disabl=
ing the denylist allows binding to devices with known errata that may lead =
to exploitable stability or security issues when accessed by untrusted user=
s.");
-
 static inline bool vfio_vga_disabled(void)
 {
 #ifdef CONFIG_VFIO_PCI_VGA
@@ -73,44 +59,6 @@ static inline bool vfio_vga_disabled(void)
 #endif
 }
=20
-static bool vfio_pci_dev_in_denylist(struct pci_dev *pdev)
-{
-	switch (pdev->vendor) {
-	case PCI_VENDOR_ID_INTEL:
-		switch (pdev->device) {
-		case PCI_DEVICE_ID_INTEL_QAT_C3XXX:
-		case PCI_DEVICE_ID_INTEL_QAT_C3XXX_VF:
-		case PCI_DEVICE_ID_INTEL_QAT_C62X:
-		case PCI_DEVICE_ID_INTEL_QAT_C62X_VF:
-		case PCI_DEVICE_ID_INTEL_QAT_DH895XCC:
-		case PCI_DEVICE_ID_INTEL_QAT_DH895XCC_VF:
-			return true;
-		default:
-			return false;
-		}
-	}
-
-	return false;
-}
-
-static bool vfio_pci_is_denylisted(struct pci_dev *pdev)
-{
-	if (!vfio_pci_dev_in_denylist(pdev))
-		return false;
-
-	if (disable_denylist) {
-		pci_warn(pdev,
-			 "device denylist disabled - allowing device %04x:%04x.\n",
-			 pdev->vendor, pdev->device);
-		return false;
-	}
-
-	pci_warn(pdev, "%04x:%04x exists in vfio-pci device denylist, driver prob=
ing disallowed.\n",
-		 pdev->vendor, pdev->device);
-
-	return true;
-}
-
 /*
  * Our VGA arbiter participation is limited since we don't know anything
  * about the device itself.  However, if the device is the only VGA device
@@ -122,7 +70,7 @@ static bool vfio_pci_is_denylisted(struct pci_dev *pdev)
 static unsigned int vfio_pci_set_vga_decode(void *opaque, bool single_vga)
 {
 	struct vfio_pci_device *vdev =3D opaque;
-	struct pci_dev *tmp =3D NULL, *pdev =3D vdev->pdev;
+	struct pci_dev *tmp =3D NULL, *pdev =3D vdev->vpdev.pdev;
 	unsigned char max_busnr;
 	unsigned int decodes;
=20
@@ -164,7 +112,7 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_device=
 *vdev)
 	for (i =3D 0; i < PCI_STD_NUM_BARS; i++) {
 		int bar =3D i + PCI_STD_RESOURCES;
=20
-		res =3D &vdev->pdev->resource[bar];
+		res =3D &vdev->vpdev.pdev->resource[bar];
=20
 		if (!IS_ENABLED(CONFIG_VFIO_PCI_MMAP))
 			goto no_mmap;
@@ -260,7 +208,7 @@ static bool vfio_pci_nointx(struct pci_dev *pdev)
=20
 static void vfio_pci_probe_power_state(struct vfio_pci_device *vdev)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	u16 pmcsr;
=20
 	if (!pdev->pm_cap)
@@ -280,7 +228,7 @@ static void vfio_pci_probe_power_state(struct vfio_pci_=
device *vdev)
  */
 int vfio_pci_set_power_state(struct vfio_pci_device *vdev, pci_power_t sta=
te)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	bool needs_restore =3D false, needs_save =3D false;
 	int ret;
=20
@@ -311,7 +259,7 @@ int vfio_pci_set_power_state(struct vfio_pci_device *vd=
ev, pci_power_t state)
=20
 static int vfio_pci_enable(struct vfio_pci_device *vdev)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	int ret;
 	u16 cmd;
 	u8 msix_pos;
@@ -378,7 +326,6 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev=
)
 	if (!vfio_vga_disabled() && vfio_pci_is_vga(pdev))
 		vdev->has_vga =3D true;
=20
-
 	if (vfio_pci_is_vga(pdev) &&
 	    pdev->vendor =3D=3D PCI_VENDOR_ID_INTEL &&
 	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
@@ -407,6 +354,12 @@ static int vfio_pci_enable(struct vfio_pci_device *vde=
v)
 		}
 	}
=20
+	if (vdev->vpdev.vfio_pci_ops->init) {
+		ret =3D vdev->vpdev.vfio_pci_ops->init(&vdev->vpdev);
+		if (ret)
+			goto disable_exit;
+	}
+
 	vfio_pci_probe_mmaps(vdev);
=20
 	return 0;
@@ -418,7 +371,7 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev=
)
=20
 static void vfio_pci_disable(struct vfio_pci_device *vdev)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	struct vfio_pci_dummy_resource *dummy_res, *tmp;
 	struct vfio_pci_ioeventfd *ioeventfd, *ioeventfd_tmp;
 	int i, bar;
@@ -515,21 +468,19 @@ static void vfio_pci_disable(struct vfio_pci_device *=
vdev)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 }
=20
-static struct pci_driver vfio_pci_driver;
-
 static struct vfio_pci_device *get_pf_vdev(struct vfio_pci_device *vdev,
 					   struct vfio_device **pf_dev)
 {
-	struct pci_dev *physfn =3D pci_physfn(vdev->pdev);
+	struct pci_dev *physfn =3D pci_physfn(vdev->vpdev.pdev);
=20
-	if (!vdev->pdev->is_virtfn)
+	if (!vdev->vpdev.pdev->is_virtfn)
 		return NULL;
=20
 	*pf_dev =3D vfio_device_get_from_dev(&physfn->dev);
 	if (!*pf_dev)
 		return NULL;
=20
-	if (pci_dev_driver(physfn) !=3D &vfio_pci_driver) {
+	if (pci_dev_driver(physfn) !=3D pci_dev_driver(vdev->vpdev.pdev)) {
 		vfio_device_put(*pf_dev);
 		return NULL;
 	}
@@ -553,7 +504,7 @@ static void vfio_pci_vf_token_user_add(struct vfio_pci_=
device *vdev, int val)
 	vfio_device_put(pf_dev);
 }
=20
-static void vfio_pci_release(void *device_data)
+static void vfio_pci_core_release(void *device_data)
 {
 	struct vfio_pci_device *vdev =3D device_data;
=20
@@ -561,7 +512,7 @@ static void vfio_pci_release(void *device_data)
=20
 	if (!(--vdev->refcnt)) {
 		vfio_pci_vf_token_user_add(vdev, -1);
-		vfio_spapr_pci_eeh_release(vdev->pdev);
+		vfio_spapr_pci_eeh_release(vdev->vpdev.pdev);
 		vfio_pci_disable(vdev);
=20
 		mutex_lock(&vdev->igate);
@@ -578,15 +529,15 @@ static void vfio_pci_release(void *device_data)
=20
 	mutex_unlock(&vdev->reflck->lock);
=20
-	module_put(THIS_MODULE);
+	module_put(vdev->vpdev.vfio_pci_ops->module);
 }
=20
-static int vfio_pci_open(void *device_data)
+static int vfio_pci_core_open(void *device_data)
 {
 	struct vfio_pci_device *vdev =3D device_data;
 	int ret =3D 0;
=20
-	if (!try_module_get(THIS_MODULE))
+	if (!try_module_get(vdev->vpdev.vfio_pci_ops->module))
 		return -ENODEV;
=20
 	mutex_lock(&vdev->reflck->lock);
@@ -596,14 +547,14 @@ static int vfio_pci_open(void *device_data)
 		if (ret)
 			goto error;
=20
-		vfio_spapr_pci_eeh_open(vdev->pdev);
+		vfio_spapr_pci_eeh_open(vdev->vpdev.pdev);
 		vfio_pci_vf_token_user_add(vdev, 1);
 	}
 	vdev->refcnt++;
 error:
 	mutex_unlock(&vdev->reflck->lock);
 	if (ret)
-		module_put(THIS_MODULE);
+		module_put(vdev->vpdev.vfio_pci_ops->module);
 	return ret;
 }
=20
@@ -613,19 +564,19 @@ static int vfio_pci_get_irq_count(struct vfio_pci_dev=
ice *vdev, int irq_type)
 		u8 pin;
=20
 		if (!IS_ENABLED(CONFIG_VFIO_PCI_INTX) ||
-		    vdev->nointx || vdev->pdev->is_virtfn)
+		    vdev->nointx || vdev->vpdev.pdev->is_virtfn)
 			return 0;
=20
-		pci_read_config_byte(vdev->pdev, PCI_INTERRUPT_PIN, &pin);
+		pci_read_config_byte(vdev->vpdev.pdev, PCI_INTERRUPT_PIN, &pin);
=20
 		return pin ? 1 : 0;
 	} else if (irq_type =3D=3D VFIO_PCI_MSI_IRQ_INDEX) {
 		u8 pos;
 		u16 flags;
=20
-		pos =3D vdev->pdev->msi_cap;
+		pos =3D vdev->vpdev.pdev->msi_cap;
 		if (pos) {
-			pci_read_config_word(vdev->pdev,
+			pci_read_config_word(vdev->vpdev.pdev,
 					     pos + PCI_MSI_FLAGS, &flags);
 			return 1 << ((flags & PCI_MSI_FLAGS_QMASK) >> 1);
 		}
@@ -633,15 +584,15 @@ static int vfio_pci_get_irq_count(struct vfio_pci_dev=
ice *vdev, int irq_type)
 		u8 pos;
 		u16 flags;
=20
-		pos =3D vdev->pdev->msix_cap;
+		pos =3D vdev->vpdev.pdev->msix_cap;
 		if (pos) {
-			pci_read_config_word(vdev->pdev,
+			pci_read_config_word(vdev->vpdev.pdev,
 					     pos + PCI_MSIX_FLAGS, &flags);
=20
 			return (flags & PCI_MSIX_FLAGS_QSIZE) + 1;
 		}
 	} else if (irq_type =3D=3D VFIO_PCI_ERR_IRQ_INDEX) {
-		if (pci_is_pcie(vdev->pdev))
+		if (pci_is_pcie(vdev->vpdev.pdev))
 			return 1;
 	} else if (irq_type =3D=3D VFIO_PCI_REQ_IRQ_INDEX) {
 		return 1;
@@ -797,8 +748,8 @@ struct vfio_devices {
 	int max_index;
 };
=20
-static long vfio_pci_ioctl(void *device_data,
-			   unsigned int cmd, unsigned long arg)
+static long vfio_pci_core_ioctl(void *device_data, unsigned int cmd,
+		unsigned long arg)
 {
 	struct vfio_pci_device *vdev =3D device_data;
 	unsigned long minsz;
@@ -836,7 +787,7 @@ static long vfio_pci_ioctl(void *device_data,
 			int ret =3D vfio_pci_info_zdev_add_caps(vdev, &caps);
=20
 			if (ret && ret !=3D -ENODEV) {
-				pci_warn(vdev->pdev, "Failed to setup zPCI info capabilities\n");
+				pci_warn(vdev->vpdev.pdev, "Failed to setup zPCI info capabilities\n")=
;
 				return ret;
 			}
 		}
@@ -863,7 +814,7 @@ static long vfio_pci_ioctl(void *device_data,
 			-EFAULT : 0;
=20
 	} else if (cmd =3D=3D VFIO_DEVICE_GET_REGION_INFO) {
-		struct pci_dev *pdev =3D vdev->pdev;
+		struct pci_dev *pdev =3D vdev->vpdev.pdev;
 		struct vfio_region_info info;
 		struct vfio_info_cap caps =3D { .buf =3D NULL, .size =3D 0 };
 		int i, ret;
@@ -1023,7 +974,7 @@ static long vfio_pci_ioctl(void *device_data,
 		case VFIO_PCI_REQ_IRQ_INDEX:
 			break;
 		case VFIO_PCI_ERR_IRQ_INDEX:
-			if (pci_is_pcie(vdev->pdev))
+			if (pci_is_pcie(vdev->vpdev.pdev))
 				break;
 			fallthrough;
 		default:
@@ -1085,7 +1036,7 @@ static long vfio_pci_ioctl(void *device_data,
 			return -EINVAL;
=20
 		vfio_pci_zap_and_down_write_memory_lock(vdev);
-		ret =3D pci_try_reset_function(vdev->pdev);
+		ret =3D pci_try_reset_function(vdev->vpdev.pdev);
 		up_write(&vdev->memory_lock);
=20
 		return ret;
@@ -1108,13 +1059,13 @@ static long vfio_pci_ioctl(void *device_data,
 		hdr.flags =3D 0;
=20
 		/* Can we do a slot or bus reset or neither? */
-		if (!pci_probe_reset_slot(vdev->pdev->slot))
+		if (!pci_probe_reset_slot(vdev->vpdev.pdev->slot))
 			slot =3D true;
-		else if (pci_probe_reset_bus(vdev->pdev->bus))
+		else if (pci_probe_reset_bus(vdev->vpdev.pdev->bus))
 			return -ENODEV;
=20
 		/* How many devices are affected? */
-		ret =3D vfio_pci_for_each_slot_or_bus(vdev->pdev,
+		ret =3D vfio_pci_for_each_slot_or_bus(vdev->vpdev.pdev,
 						    vfio_pci_count_devs,
 						    &fill.max, slot);
 		if (ret)
@@ -1138,7 +1089,7 @@ static long vfio_pci_ioctl(void *device_data,
=20
 		fill.devices =3D devices;
=20
-		ret =3D vfio_pci_for_each_slot_or_bus(vdev->pdev,
+		ret =3D vfio_pci_for_each_slot_or_bus(vdev->vpdev.pdev,
 						    vfio_pci_fill_devs,
 						    &fill, slot);
=20
@@ -1181,9 +1132,9 @@ static long vfio_pci_ioctl(void *device_data,
 			return -EINVAL;
=20
 		/* Can we do a slot or bus reset or neither? */
-		if (!pci_probe_reset_slot(vdev->pdev->slot))
+		if (!pci_probe_reset_slot(vdev->vpdev.pdev->slot))
 			slot =3D true;
-		else if (pci_probe_reset_bus(vdev->pdev->bus))
+		else if (pci_probe_reset_bus(vdev->vpdev.pdev->bus))
 			return -ENODEV;
=20
 		/*
@@ -1192,7 +1143,7 @@ static long vfio_pci_ioctl(void *device_data,
 		 * could be.  Note groups can have multiple devices so
 		 * one group per device is the max.
 		 */
-		ret =3D vfio_pci_for_each_slot_or_bus(vdev->pdev,
+		ret =3D vfio_pci_for_each_slot_or_bus(vdev->vpdev.pdev,
 						    vfio_pci_count_devs,
 						    &count, slot);
 		if (ret)
@@ -1255,7 +1206,7 @@ static long vfio_pci_ioctl(void *device_data,
 		 * Test whether all the affected devices are contained
 		 * by the set of groups provided by the user.
 		 */
-		ret =3D vfio_pci_for_each_slot_or_bus(vdev->pdev,
+		ret =3D vfio_pci_for_each_slot_or_bus(vdev->vpdev.pdev,
 						    vfio_pci_validate_devs,
 						    &info, slot);
 		if (ret)
@@ -1275,7 +1226,7 @@ static long vfio_pci_ioctl(void *device_data,
 		 * the vma_lock for each device, and only then get each
 		 * memory_lock.
 		 */
-		ret =3D vfio_pci_for_each_slot_or_bus(vdev->pdev,
+		ret =3D vfio_pci_for_each_slot_or_bus(vdev->vpdev.pdev,
 					    vfio_pci_try_zap_and_vma_lock_cb,
 					    &devs, slot);
 		if (ret)
@@ -1295,7 +1246,7 @@ static long vfio_pci_ioctl(void *device_data,
 		}
=20
 		/* User has access, do the reset */
-		ret =3D pci_reset_bus(vdev->pdev);
+		ret =3D pci_reset_bus(vdev->vpdev.pdev);
=20
 hot_reset_release:
 		for (i =3D 0; i < devs.cur_index; i++) {
@@ -1404,11 +1355,10 @@ static long vfio_pci_ioctl(void *device_data,
 	return -ENOTTY;
 }
=20
-static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
+static ssize_t vfio_pci_rw(struct vfio_pci_device *vdev, char __user *buf,
 			   size_t count, loff_t *ppos, bool iswrite)
 {
 	unsigned int index =3D VFIO_PCI_OFFSET_TO_INDEX(*ppos);
-	struct vfio_pci_device *vdev =3D device_data;
=20
 	if (index >=3D VFIO_PCI_NUM_REGIONS + vdev->num_regions)
 		return -EINVAL;
@@ -1436,22 +1386,26 @@ static ssize_t vfio_pci_rw(void *device_data, char =
__user *buf,
 	return -EINVAL;
 }
=20
-static ssize_t vfio_pci_read(void *device_data, char __user *buf,
-			     size_t count, loff_t *ppos)
+static ssize_t vfio_pci_core_read(void *device_data, char __user *buf,
+		size_t count, loff_t *ppos)
 {
+	struct vfio_pci_device *vdev =3D device_data;
+
 	if (!count)
 		return 0;
=20
-	return vfio_pci_rw(device_data, buf, count, ppos, false);
+	return vfio_pci_rw(vdev, buf, count, ppos, false);
 }
=20
-static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
-			      size_t count, loff_t *ppos)
+static ssize_t vfio_pci_core_write(void *device_data,
+		const char __user *buf, size_t count, loff_t *ppos)
 {
+	struct vfio_pci_device *vdev =3D device_data;
+
 	if (!count)
 		return 0;
=20
-	return vfio_pci_rw(device_data, (char __user *)buf, count, ppos, true);
+	return vfio_pci_rw(vdev, (char __user *)buf, count, ppos, true);
 }
=20
 /* Return 1 on zap and vma_lock acquired, 0 on contention (only with @try)=
 */
@@ -1555,9 +1509,9 @@ u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_d=
evice *vdev)
 	u16 cmd;
=20
 	down_write(&vdev->memory_lock);
-	pci_read_config_word(vdev->pdev, PCI_COMMAND, &cmd);
+	pci_read_config_word(vdev->vpdev.pdev, PCI_COMMAND, &cmd);
 	if (!(cmd & PCI_COMMAND_MEMORY))
-		pci_write_config_word(vdev->pdev, PCI_COMMAND,
+		pci_write_config_word(vdev->vpdev.pdev, PCI_COMMAND,
 				      cmd | PCI_COMMAND_MEMORY);
=20
 	return cmd;
@@ -1565,7 +1519,7 @@ u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_d=
evice *vdev)
=20
 void vfio_pci_memory_unlock_and_restore(struct vfio_pci_device *vdev, u16 =
cmd)
 {
-	pci_write_config_word(vdev->pdev, PCI_COMMAND, cmd);
+	pci_write_config_word(vdev->vpdev.pdev, PCI_COMMAND, cmd);
 	up_write(&vdev->memory_lock);
 }
=20
@@ -1648,10 +1602,10 @@ static const struct vm_operations_struct vfio_pci_m=
map_ops =3D {
 	.fault =3D vfio_pci_mmap_fault,
 };
=20
-static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
+static int vfio_pci_core_mmap(void *device_data, struct vm_area_struct *vm=
a)
 {
 	struct vfio_pci_device *vdev =3D device_data;
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	unsigned int index;
 	u64 phys_len, req_len, pgoff, req_start;
 	int ret;
@@ -1716,10 +1670,10 @@ static int vfio_pci_mmap(void *device_data, struct =
vm_area_struct *vma)
 	return 0;
 }
=20
-static void vfio_pci_request(void *device_data, unsigned int count)
+static void vfio_pci_core_request(void *device_data, unsigned int count)
 {
 	struct vfio_pci_device *vdev =3D device_data;
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
=20
 	mutex_lock(&vdev->igate);
=20
@@ -1740,6 +1694,7 @@ static void vfio_pci_request(void *device_data, unsig=
ned int count)
 static int vfio_pci_validate_vf_token(struct vfio_pci_device *vdev,
 				      bool vf_token, uuid_t *uuid)
 {
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	/*
 	 * There's always some degree of trust or collaboration between SR-IOV
 	 * PF and VFs, even if just that the PF hosts the SR-IOV capability and
@@ -1765,10 +1720,10 @@ static int vfio_pci_validate_vf_token(struct vfio_p=
ci_device *vdev,
 	 *
 	 * If the VF token is provided but unused, an error is generated.
 	 */
-	if (!vdev->pdev->is_virtfn && !vdev->vf_token && !vf_token)
+	if (!pdev->is_virtfn && !vdev->vf_token && !vf_token)
 		return 0; /* No VF token provided or required */
=20
-	if (vdev->pdev->is_virtfn) {
+	if (pdev->is_virtfn) {
 		struct vfio_device *pf_dev;
 		struct vfio_pci_device *pf_vdev =3D get_pf_vdev(vdev, &pf_dev);
 		bool match;
@@ -1777,14 +1732,14 @@ static int vfio_pci_validate_vf_token(struct vfio_p=
ci_device *vdev,
 			if (!vf_token)
 				return 0; /* PF is not vfio-pci, no VF token */
=20
-			pci_info_ratelimited(vdev->pdev,
+			pci_info_ratelimited(pdev,
 				"VF token incorrectly provided, PF not bound to vfio-pci\n");
 			return -EINVAL;
 		}
=20
 		if (!vf_token) {
 			vfio_device_put(pf_dev);
-			pci_info_ratelimited(vdev->pdev,
+			pci_info_ratelimited(pdev,
 				"VF token required to access device\n");
 			return -EACCES;
 		}
@@ -1796,7 +1751,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci=
_device *vdev,
 		vfio_device_put(pf_dev);
=20
 		if (!match) {
-			pci_info_ratelimited(vdev->pdev,
+			pci_info_ratelimited(pdev,
 				"Incorrect VF token provided for device\n");
 			return -EACCES;
 		}
@@ -1805,14 +1760,14 @@ static int vfio_pci_validate_vf_token(struct vfio_p=
ci_device *vdev,
 		if (vdev->vf_token->users) {
 			if (!vf_token) {
 				mutex_unlock(&vdev->vf_token->lock);
-				pci_info_ratelimited(vdev->pdev,
+				pci_info_ratelimited(pdev,
 					"VF token required to access device\n");
 				return -EACCES;
 			}
=20
 			if (!uuid_equal(uuid, &vdev->vf_token->uuid)) {
 				mutex_unlock(&vdev->vf_token->lock);
-				pci_info_ratelimited(vdev->pdev,
+				pci_info_ratelimited(pdev,
 					"Incorrect VF token provided for device\n");
 				return -EACCES;
 			}
@@ -1822,7 +1777,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci=
_device *vdev,
=20
 		mutex_unlock(&vdev->vf_token->lock);
 	} else if (vf_token) {
-		pci_info_ratelimited(vdev->pdev,
+		pci_info_ratelimited(pdev,
 			"VF token incorrectly provided, not a PF or VF\n");
 		return -EINVAL;
 	}
@@ -1832,18 +1787,19 @@ static int vfio_pci_validate_vf_token(struct vfio_p=
ci_device *vdev,
=20
 #define VF_TOKEN_ARG "vf_token=3D"
=20
-static int vfio_pci_match(void *device_data, char *buf)
+static int vfio_pci_core_match(void *device_data, char *buf)
 {
 	struct vfio_pci_device *vdev =3D device_data;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	bool vf_token =3D false;
 	uuid_t uuid;
 	int ret;
=20
-	if (strncmp(pci_name(vdev->pdev), buf, strlen(pci_name(vdev->pdev))))
+	if (strncmp(pci_name(pdev), buf, strlen(pci_name(pdev))))
 		return 0; /* No match */
=20
-	if (strlen(buf) > strlen(pci_name(vdev->pdev))) {
-		buf +=3D strlen(pci_name(vdev->pdev));
+	if (strlen(buf) > strlen(pci_name(pdev))) {
+		buf +=3D strlen(pci_name(pdev));
=20
 		if (*buf !=3D ' ')
 			return 0; /* No match: non-whitespace after name */
@@ -1881,16 +1837,16 @@ static int vfio_pci_match(void *device_data, char *=
buf)
 	return 1; /* Match */
 }
=20
-static const struct vfio_device_ops vfio_pci_ops =3D {
-	.name		=3D "vfio-pci",
-	.open		=3D vfio_pci_open,
-	.release	=3D vfio_pci_release,
-	.ioctl		=3D vfio_pci_ioctl,
-	.read		=3D vfio_pci_read,
-	.write		=3D vfio_pci_write,
-	.mmap		=3D vfio_pci_mmap,
-	.request	=3D vfio_pci_request,
-	.match		=3D vfio_pci_match,
+static const struct vfio_device_ops vfio_pci_core_ops =3D {
+	.name		=3D "vfio-pci-core",
+	.open		=3D vfio_pci_core_open,
+	.release	=3D vfio_pci_core_release,
+	.ioctl		=3D vfio_pci_core_ioctl,
+	.read		=3D vfio_pci_core_read,
+	.write		=3D vfio_pci_core_write,
+	.mmap		=3D vfio_pci_core_mmap,
+	.request	=3D vfio_pci_core_request,
+	.match		=3D vfio_pci_core_match,
 };
=20
 static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
@@ -1906,17 +1862,18 @@ static int vfio_pci_bus_notifier(struct notifier_bl=
ock *nb,
 	struct pci_dev *physfn =3D pci_physfn(pdev);
=20
 	if (action =3D=3D BUS_NOTIFY_ADD_DEVICE &&
-	    pdev->is_virtfn && physfn =3D=3D vdev->pdev) {
-		pci_info(vdev->pdev, "Captured SR-IOV VF %s driver_override\n",
+	    pdev->is_virtfn && physfn =3D=3D vdev->vpdev.pdev) {
+		pci_info(vdev->vpdev.pdev,
+			 "Captured SR-IOV VF %s driver_override\n",
 			 pci_name(pdev));
 		pdev->driver_override =3D kasprintf(GFP_KERNEL, "%s",
-						  vfio_pci_ops.name);
+						  vdev->vpdev.vfio_pci_ops->name);
 	} else if (action =3D=3D BUS_NOTIFY_BOUND_DRIVER &&
-		   pdev->is_virtfn && physfn =3D=3D vdev->pdev) {
+		   pdev->is_virtfn && physfn =3D=3D vdev->vpdev.pdev) {
 		struct pci_driver *drv =3D pci_dev_driver(pdev);
=20
-		if (drv && drv !=3D &vfio_pci_driver)
-			pci_warn(vdev->pdev,
+		if (drv && drv !=3D pci_dev_driver(vdev->vpdev.pdev))
+			pci_warn(vdev->vpdev.pdev,
 				 "VF %s bound to driver %s while PF bound to vfio-pci\n",
 				 pci_name(pdev), drv->name);
 	}
@@ -1924,17 +1881,16 @@ static int vfio_pci_bus_notifier(struct notifier_bl=
ock *nb,
 	return 0;
 }
=20
-static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id=
 *id)
+struct vfio_pci_core_device *vfio_create_pci_device(struct pci_dev *pdev,
+		const struct vfio_pci_device_ops *vfio_pci_ops,
+		void *dd_data)
 {
 	struct vfio_pci_device *vdev;
 	struct iommu_group *group;
 	int ret;
=20
-	if (vfio_pci_is_denylisted(pdev))
-		return -EINVAL;
-
 	if (pdev->hdr_type !=3D PCI_HEADER_TYPE_NORMAL)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
=20
 	/*
 	 * Prevent binding to PFs with VFs enabled, the VFs might be in use
@@ -1946,12 +1902,12 @@ static int vfio_pci_probe(struct pci_dev *pdev, con=
st struct pci_device_id *id)
 	 */
 	if (pci_num_vf(pdev)) {
 		pci_warn(pdev, "Cannot bind to PF with SR-IOV enabled\n");
-		return -EBUSY;
+		return ERR_PTR(-EBUSY);
 	}
=20
 	group =3D vfio_iommu_group_get(&pdev->dev);
 	if (!group)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
=20
 	vdev =3D kzalloc(sizeof(*vdev), GFP_KERNEL);
 	if (!vdev) {
@@ -1959,7 +1915,9 @@ static int vfio_pci_probe(struct pci_dev *pdev, const=
 struct pci_device_id *id)
 		goto out_group_put;
 	}
=20
-	vdev->pdev =3D pdev;
+	vdev->vpdev.pdev =3D pdev;
+	vdev->vpdev.vfio_pci_ops =3D vfio_pci_ops;
+	vdev->vpdev.dd_data =3D dd_data;
 	vdev->irq_type =3D VFIO_PCI_NUM_IRQS;
 	mutex_init(&vdev->igate);
 	spin_lock_init(&vdev->irqlock);
@@ -1970,7 +1928,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const=
 struct pci_device_id *id)
 	INIT_LIST_HEAD(&vdev->vma_list);
 	init_rwsem(&vdev->memory_lock);
=20
-	ret =3D vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
+	ret =3D vfio_add_group_dev(&pdev->dev, &vfio_pci_core_ops, vdev);
 	if (ret)
 		goto out_free;
=20
@@ -2016,7 +1974,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const=
 struct pci_device_id *id)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 	}
=20
-	return ret;
+	return &vdev->vpdev;
=20
 out_vf_token:
 	kfree(vdev->vf_token);
@@ -2028,10 +1986,11 @@ static int vfio_pci_probe(struct pci_dev *pdev, con=
st struct pci_device_id *id)
 	kfree(vdev);
 out_group_put:
 	vfio_iommu_group_put(group, &pdev->dev);
-	return ret;
+	return ERR_PTR(ret);
 }
+EXPORT_SYMBOL_GPL(vfio_create_pci_device);
=20
-static void vfio_pci_remove(struct pci_dev *pdev)
+void vfio_destroy_pci_device(struct pci_dev *pdev)
 {
 	struct vfio_pci_device *vdev;
=20
@@ -2069,9 +2028,10 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 				VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM);
 	}
 }
+EXPORT_SYMBOL_GPL(vfio_destroy_pci_device);
=20
-static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
-						  pci_channel_state_t state)
+pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
+		pci_channel_state_t state)
 {
 	struct vfio_pci_device *vdev;
 	struct vfio_device *device;
@@ -2097,18 +2057,14 @@ static pci_ers_result_t vfio_pci_aer_err_detected(s=
truct pci_dev *pdev,
=20
 	return PCI_ERS_RESULT_CAN_RECOVER;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_aer_err_detected);
=20
-static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
+int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 {
 	struct vfio_pci_device *vdev;
 	struct vfio_device *device;
 	int ret =3D 0;
=20
-	might_sleep();
-
-	if (!enable_sriov)
-		return -ENOENT;
-
 	device =3D vfio_device_get_from_dev(&pdev->dev);
 	if (!device)
 		return -ENODEV;
@@ -2128,19 +2084,7 @@ static int vfio_pci_sriov_configure(struct pci_dev *=
pdev, int nr_virtfn)
=20
 	return ret < 0 ? ret : nr_virtfn;
 }
-
-static const struct pci_error_handlers vfio_err_handlers =3D {
-	.error_detected =3D vfio_pci_aer_err_detected,
-};
-
-static struct pci_driver vfio_pci_driver =3D {
-	.name			=3D "vfio-pci",
-	.id_table		=3D NULL, /* only dynamic ids */
-	.probe			=3D vfio_pci_probe,
-	.remove			=3D vfio_pci_remove,
-	.sriov_configure	=3D vfio_pci_sriov_configure,
-	.err_handler		=3D &vfio_err_handlers,
-};
+EXPORT_SYMBOL_GPL(vfio_pci_core_sriov_configure);
=20
 static DEFINE_MUTEX(reflck_lock);
=20
@@ -2173,13 +2117,13 @@ static int vfio_pci_reflck_find(struct pci_dev *pde=
v, void *data)
 	if (!device)
 		return 0;
=20
-	if (pci_dev_driver(pdev) !=3D &vfio_pci_driver) {
+	vdev =3D vfio_device_data(device);
+
+	if (pci_dev_driver(pdev) !=3D pci_dev_driver(vdev->vpdev.pdev)) {
 		vfio_device_put(device);
 		return 0;
 	}
=20
-	vdev =3D vfio_device_data(device);
-
 	if (vdev->reflck) {
 		vfio_pci_reflck_get(vdev->reflck);
 		*preflck =3D vdev->reflck;
@@ -2193,12 +2137,12 @@ static int vfio_pci_reflck_find(struct pci_dev *pde=
v, void *data)
=20
 static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev)
 {
-	bool slot =3D !pci_probe_reset_slot(vdev->pdev->slot);
+	bool slot =3D !pci_probe_reset_slot(vdev->vpdev.pdev->slot);
=20
 	mutex_lock(&reflck_lock);
=20
-	if (pci_is_root_bus(vdev->pdev->bus) ||
-	    vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_reflck_find,
+	if (pci_is_root_bus(vdev->vpdev.pdev->bus) ||
+	    vfio_pci_for_each_slot_or_bus(vdev->vpdev.pdev, vfio_pci_reflck_find,
 					  &vdev->reflck, slot) <=3D 0)
 		vdev->reflck =3D vfio_pci_reflck_alloc();
=20
@@ -2235,13 +2179,13 @@ static int vfio_pci_get_unused_devs(struct pci_dev =
*pdev, void *data)
 	if (!device)
 		return -EINVAL;
=20
-	if (pci_dev_driver(pdev) !=3D &vfio_pci_driver) {
+	vdev =3D vfio_device_data(device);
+
+	if (pci_dev_driver(pdev) !=3D pci_dev_driver(vdev->vpdev.pdev)) {
 		vfio_device_put(device);
 		return -EBUSY;
 	}
=20
-	vdev =3D vfio_device_data(device);
-
 	/* Fault if the device is not unused */
 	if (vdev->refcnt) {
 		vfio_device_put(device);
@@ -2265,13 +2209,13 @@ static int vfio_pci_try_zap_and_vma_lock_cb(struct =
pci_dev *pdev, void *data)
 	if (!device)
 		return -EINVAL;
=20
-	if (pci_dev_driver(pdev) !=3D &vfio_pci_driver) {
+	vdev =3D vfio_device_data(device);
+
+	if (pci_dev_driver(pdev) !=3D pci_dev_driver(vdev->vpdev.pdev)) {
 		vfio_device_put(device);
 		return -EBUSY;
 	}
=20
-	vdev =3D vfio_device_data(device);
-
 	/*
 	 * Locking multiple devices is prone to deadlock, runaway and
 	 * unwind if we hit contention.
@@ -2308,12 +2252,12 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_=
device *vdev)
 	bool slot =3D false;
 	struct vfio_pci_device *tmp;
=20
-	if (!pci_probe_reset_slot(vdev->pdev->slot))
+	if (!pci_probe_reset_slot(vdev->vpdev.pdev->slot))
 		slot =3D true;
-	else if (pci_probe_reset_bus(vdev->pdev->bus))
+	else if (pci_probe_reset_bus(vdev->vpdev.pdev->bus))
 		return;
=20
-	if (vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_count_devs,
+	if (vfio_pci_for_each_slot_or_bus(vdev->vpdev.pdev, vfio_pci_count_devs,
 					  &i, slot) || !i)
 		return;
=20
@@ -2322,7 +2266,7 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_de=
vice *vdev)
 	if (!devs.devices)
 		return;
=20
-	if (vfio_pci_for_each_slot_or_bus(vdev->pdev,
+	if (vfio_pci_for_each_slot_or_bus(vdev->vpdev.pdev,
 					  vfio_pci_get_unused_devs,
 					  &devs, slot))
 		goto put_devs;
@@ -2331,7 +2275,7 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_de=
vice *vdev)
 	for (i =3D 0; i < devs.cur_index; i++) {
 		tmp =3D vfio_device_data(devs.devices[i]);
 		if (tmp->needs_reset) {
-			ret =3D pci_reset_bus(vdev->pdev);
+			ret =3D pci_reset_bus(vdev->vpdev.pdev);
 			break;
 		}
 	}
@@ -2360,81 +2304,19 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_=
device *vdev)
 	kfree(devs.devices);
 }
=20
-static void __exit vfio_pci_cleanup(void)
+static void __exit vfio_pci_core_cleanup(void)
 {
-	pci_unregister_driver(&vfio_pci_driver);
 	vfio_pci_uninit_perm_bits();
 }
=20
-static void __init vfio_pci_fill_ids(void)
+static int __init vfio_pci_core_init(void)
 {
-	char *p, *id;
-	int rc;
-
-	/* no ids passed actually */
-	if (ids[0] =3D=3D '\0')
-		return;
-
-	/* add ids specified in the module parameter */
-	p =3D ids;
-	while ((id =3D strsep(&p, ","))) {
-		unsigned int vendor, device, subvendor =3D PCI_ANY_ID,
-			subdevice =3D PCI_ANY_ID, class =3D 0, class_mask =3D 0;
-		int fields;
-
-		if (!strlen(id))
-			continue;
-
-		fields =3D sscanf(id, "%x:%x:%x:%x:%x:%x",
-				&vendor, &device, &subvendor, &subdevice,
-				&class, &class_mask);
-
-		if (fields < 2) {
-			pr_warn("invalid id string \"%s\"\n", id);
-			continue;
-		}
-
-		rc =3D pci_add_dynid(&vfio_pci_driver, vendor, device,
-				   subvendor, subdevice, class, class_mask, 0);
-		if (rc)
-			pr_warn("failed to add dynamic id [%04x:%04x[%04x:%04x]] class %#08x/%0=
8x (%d)\n",
-				vendor, device, subvendor, subdevice,
-				class, class_mask, rc);
-		else
-			pr_info("add [%04x:%04x[%04x:%04x]] class %#08x/%08x\n",
-				vendor, device, subvendor, subdevice,
-				class, class_mask);
-	}
-}
-
-static int __init vfio_pci_init(void)
-{
-	int ret;
-
 	/* Allocate shared config space permision data used by all devices */
-	ret =3D vfio_pci_init_perm_bits();
-	if (ret)
-		return ret;
-
-	/* Register and scan for devices */
-	ret =3D pci_register_driver(&vfio_pci_driver);
-	if (ret)
-		goto out_driver;
-
-	vfio_pci_fill_ids();
-
-	if (disable_denylist)
-		pr_warn("device denylist disabled.\n");
-
-	return 0;
-
-out_driver:
-	vfio_pci_uninit_perm_bits();
-	return ret;
+	return vfio_pci_init_perm_bits();
 }
=20
-module_init(vfio_pci_init);
-module_exit(vfio_pci_cleanup);
+module_init(vfio_pci_core_init);
+module_exit(vfio_pci_core_cleanup);
=20
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/vfio/pci/vfio_pci_core.h b/drivers/vfio/pci/vfio_pci_c=
ore.h
new file mode 100644
index 000000000000..9833935af735
--- /dev/null
+++ b/drivers/vfio/pci/vfio_pci_core.h
@@ -0,0 +1,45 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2020, NVIDIA CORPORATION. All rights reserved.
+ *     Author: Max Gurtovoy <mgurtovoy@nvidia.com>
+ *
+ * Derived from original vfio:
+ * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
+ *     Author: Alex Williamson <alex.williamson@redhat.com>
+ */
+
+#include <linux/pci.h>
+#include <linux/vfio.h>
+
+#ifndef VFIO_PCI_CORE_H
+#define VFIO_PCI_CORE_H
+
+struct vfio_pci_device_ops;
+
+struct vfio_pci_core_device {
+	struct pci_dev				*pdev;
+	const struct vfio_pci_device_ops	*vfio_pci_ops;
+	void					*dd_data;
+};
+
+/**
+ * struct vfio_pci_device_ops - VFIO PCI device callbacks
+ *
+ * @init: Called when userspace creates new file descriptor for device
+ */
+struct vfio_pci_device_ops {
+	struct module	*module;
+	char		*name;
+	int		(*init)(struct vfio_pci_core_device *vpdev);
+};
+
+/* Exported functions */
+struct vfio_pci_core_device *vfio_create_pci_device(struct pci_dev *pdev,
+		const struct vfio_pci_device_ops *vfio_pci_ops,
+		void *dd_data);
+void vfio_destroy_pci_device(struct pci_dev *pdev);
+int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn);
+pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
+		pci_channel_state_t state);
+
+#endif /* VFIO_PCI_CORE_H */
diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_ig=
d.c
index 53d97f459252..0cab3c2d35f6 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -59,7 +59,7 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_dev=
ice *vdev)
 	void *base;
 	int ret;
=20
-	ret =3D pci_read_config_dword(vdev->pdev, OPREGION_PCI_ADDR, &addr);
+	ret =3D pci_read_config_dword(vdev->vpdev.pdev, OPREGION_PCI_ADDR, &addr)=
;
 	if (ret)
 		return ret;
=20
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_=
intrs.c
index 869dce5f134d..8222a0c7cc32 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -35,7 +35,7 @@ static void vfio_send_intx_eventfd(void *opaque, void *un=
used)
=20
 void vfio_pci_intx_mask(struct vfio_pci_device *vdev)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	unsigned long flags;
=20
 	spin_lock_irqsave(&vdev->irqlock, flags);
@@ -74,7 +74,7 @@ void vfio_pci_intx_mask(struct vfio_pci_device *vdev)
 static int vfio_pci_intx_unmask_handler(void *opaque, void *unused)
 {
 	struct vfio_pci_device *vdev =3D opaque;
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	unsigned long flags;
 	int ret =3D 0;
=20
@@ -122,11 +122,11 @@ static irqreturn_t vfio_intx_handler(int irq, void *d=
ev_id)
 	spin_lock_irqsave(&vdev->irqlock, flags);
=20
 	if (!vdev->pci_2_3) {
-		disable_irq_nosync(vdev->pdev->irq);
+		disable_irq_nosync(vdev->vpdev.pdev->irq);
 		vdev->ctx[0].masked =3D true;
 		ret =3D IRQ_HANDLED;
 	} else if (!vdev->ctx[0].masked &&  /* may be shared */
-		   pci_check_and_mask_intx(vdev->pdev)) {
+		   pci_check_and_mask_intx(vdev->vpdev.pdev)) {
 		vdev->ctx[0].masked =3D true;
 		ret =3D IRQ_HANDLED;
 	}
@@ -144,7 +144,7 @@ static int vfio_intx_enable(struct vfio_pci_device *vde=
v)
 	if (!is_irq_none(vdev))
 		return -EINVAL;
=20
-	if (!vdev->pdev->irq)
+	if (!vdev->vpdev.pdev->irq)
 		return -ENODEV;
=20
 	vdev->ctx =3D kzalloc(sizeof(struct vfio_pci_irq_ctx), GFP_KERNEL);
@@ -161,7 +161,7 @@ static int vfio_intx_enable(struct vfio_pci_device *vde=
v)
 	 */
 	vdev->ctx[0].masked =3D vdev->virq_disabled;
 	if (vdev->pci_2_3)
-		pci_intx(vdev->pdev, !vdev->ctx[0].masked);
+		pci_intx(vdev->vpdev.pdev, !vdev->ctx[0].masked);
=20
 	vdev->irq_type =3D VFIO_PCI_INTX_IRQ_INDEX;
=20
@@ -170,7 +170,7 @@ static int vfio_intx_enable(struct vfio_pci_device *vde=
v)
=20
 static int vfio_intx_set_signal(struct vfio_pci_device *vdev, int fd)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	unsigned long irqflags =3D IRQF_SHARED;
 	struct eventfd_ctx *trigger;
 	unsigned long flags;
@@ -246,7 +246,7 @@ static irqreturn_t vfio_msihandler(int irq, void *arg)
=20
 static int vfio_msi_enable(struct vfio_pci_device *vdev, int nvec, bool ms=
ix)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	unsigned int flag =3D msix ? PCI_IRQ_MSIX : PCI_IRQ_MSI;
 	int ret;
 	u16 cmd;
@@ -288,7 +288,7 @@ static int vfio_msi_enable(struct vfio_pci_device *vdev=
, int nvec, bool msix)
 static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
 				      int vector, int fd, bool msix)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	struct eventfd_ctx *trigger;
 	int irq, ret;
 	u16 cmd;
@@ -387,7 +387,7 @@ static int vfio_msi_set_block(struct vfio_pci_device *v=
dev, unsigned start,
=20
 static void vfio_msi_disable(struct vfio_pci_device *vdev, bool msix)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	int i;
 	u16 cmd;
=20
@@ -672,7 +672,7 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vde=
v, uint32_t flags,
 	case VFIO_PCI_ERR_IRQ_INDEX:
 		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
 		case VFIO_IRQ_SET_ACTION_TRIGGER:
-			if (pci_is_pcie(vdev->pdev))
+			if (pci_is_pcie(vdev->vpdev.pdev))
 				func =3D vfio_pci_set_err_trigger;
 			break;
 		}
diff --git a/drivers/vfio/pci/vfio_pci_nvlink2.c b/drivers/vfio/pci/vfio_pc=
i_nvlink2.c
index 9adcf6a8f888..80f0de332338 100644
--- a/drivers/vfio/pci/vfio_pci_nvlink2.c
+++ b/drivers/vfio/pci/vfio_pci_nvlink2.c
@@ -165,7 +165,7 @@ static int vfio_pci_nvgpu_mmap(struct vfio_pci_device *=
vdev,
 	ret =3D (int) mm_iommu_newdev(data->mm, data->useraddr,
 			vma_pages(vma), data->gpu_hpa, &data->mem);
=20
-	trace_vfio_pci_nvgpu_mmap(vdev->pdev, data->gpu_hpa, data->useraddr,
+	trace_vfio_pci_nvgpu_mmap(vdev->vpdev.pdev, data->gpu_hpa, data->useraddr=
,
 			vma->vm_end - vma->vm_start, ret);
=20
 	return ret;
@@ -222,7 +222,7 @@ int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_de=
vice *vdev)
 	 * PCI config space does not tell us about NVLink presense but
 	 * platform does, use this.
 	 */
-	npu_dev =3D pnv_pci_get_npu_dev(vdev->pdev, 0);
+	npu_dev =3D pnv_pci_get_npu_dev(vdev->vpdev.pdev, 0);
 	if (!npu_dev)
 		return -ENODEV;
=20
@@ -243,7 +243,7 @@ int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_de=
vice *vdev)
 		return -EINVAL;
=20
 	if (of_property_read_u64(npu_node, "ibm,device-tgt-addr", &tgt)) {
-		dev_warn(&vdev->pdev->dev, "No ibm,device-tgt-addr found\n");
+		dev_warn(&vdev->vpdev.pdev->dev, "No ibm,device-tgt-addr found\n");
 		return -EFAULT;
 	}
=20
@@ -255,10 +255,10 @@ int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_=
device *vdev)
 	data->gpu_tgt =3D tgt;
 	data->size =3D reg[1];
=20
-	dev_dbg(&vdev->pdev->dev, "%lx..%lx\n", data->gpu_hpa,
+	dev_dbg(&vdev->vpdev.pdev->dev, "%lx..%lx\n", data->gpu_hpa,
 			data->gpu_hpa + data->size - 1);
=20
-	data->gpdev =3D vdev->pdev;
+	data->gpdev =3D vdev->vpdev.pdev;
 	data->group_notifier.notifier_call =3D vfio_pci_nvgpu_group_notifier;
=20
 	ret =3D vfio_register_notifier(&data->gpdev->dev, VFIO_GROUP_NOTIFY,
@@ -343,7 +343,7 @@ static int vfio_pci_npu2_mmap(struct vfio_pci_device *v=
dev,
=20
 	ret =3D remap_pfn_range(vma, vma->vm_start, data->mmio_atsd >> PAGE_SHIFT=
,
 			req_len, vma->vm_page_prot);
-	trace_vfio_pci_npu2_mmap(vdev->pdev, data->mmio_atsd, vma->vm_start,
+	trace_vfio_pci_npu2_mmap(vdev->vpdev.pdev, data->mmio_atsd, vma->vm_start=
,
 			vma->vm_end - vma->vm_start, ret);
=20
 	return ret;
@@ -394,7 +394,7 @@ int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev=
)
 	struct vfio_pci_npu2_data *data;
 	struct device_node *nvlink_dn;
 	u32 nvlink_index =3D 0, mem_phandle =3D 0;
-	struct pci_dev *npdev =3D vdev->pdev;
+	struct pci_dev *npdev =3D vdev->vpdev.pdev;
 	struct device_node *npu_node =3D pci_device_to_OF_node(npdev);
 	struct pci_controller *hose =3D pci_bus_to_host(npdev->bus);
 	u64 mmio_atsd =3D 0;
@@ -405,7 +405,7 @@ int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev=
)
 	 * PCI config space does not tell us about NVLink presense but
 	 * platform does, use this.
 	 */
-	if (!pnv_pci_get_gpu_dev(vdev->pdev))
+	if (!pnv_pci_get_gpu_dev(vdev->vpdev.pdev))
 		return -ENODEV;
=20
 	if (of_property_read_u32(npu_node, "memory-region", &mem_phandle))
@@ -427,21 +427,21 @@ int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vd=
ev)
 			&mmio_atsd)) {
 		if (of_property_read_u64_index(hose->dn, "ibm,mmio-atsd", 0,
 				&mmio_atsd)) {
-			dev_warn(&vdev->pdev->dev, "No available ATSD found\n");
+			dev_warn(&vdev->vpdev.pdev->dev, "No available ATSD found\n");
 			mmio_atsd =3D 0;
 		} else {
-			dev_warn(&vdev->pdev->dev,
+			dev_warn(&vdev->vpdev.pdev->dev,
 				 "Using fallback ibm,mmio-atsd[0] for ATSD.\n");
 		}
 	}
=20
 	if (of_property_read_u64(npu_node, "ibm,device-tgt-addr", &tgt)) {
-		dev_warn(&vdev->pdev->dev, "No ibm,device-tgt-addr found\n");
+		dev_warn(&vdev->vpdev.pdev->dev, "No ibm,device-tgt-addr found\n");
 		return -EFAULT;
 	}
=20
 	if (of_property_read_u32(npu_node, "ibm,nvlink-speed", &link_speed)) {
-		dev_warn(&vdev->pdev->dev, "No ibm,nvlink-speed found\n");
+		dev_warn(&vdev->vpdev.pdev->dev, "No ibm,nvlink-speed found\n");
 		return -EFAULT;
 	}
=20
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pc=
i_private.h
index 5c90e560c5c7..82de00508377 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -15,6 +15,8 @@
 #include <linux/uuid.h>
 #include <linux/notifier.h>
=20
+#include "vfio_pci_core.h"
+
 #ifndef VFIO_PCI_PRIVATE_H
 #define VFIO_PCI_PRIVATE_H
=20
@@ -100,7 +102,7 @@ struct vfio_pci_mmap_vma {
 };
=20
 struct vfio_pci_device {
-	struct pci_dev		*pdev;
+	struct vfio_pci_core_device vpdev;
 	void __iomem		*barmap[PCI_STD_NUM_BARS];
 	bool			bar_mmap_supported[PCI_STD_NUM_BARS];
 	u8			*pci_config_map;
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_r=
dwr.c
index a0b5fc8e46f4..d58dc3e863b0 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -202,7 +202,7 @@ static ssize_t do_io_rw(struct vfio_pci_device *vdev, b=
ool test_mem,
=20
 static int vfio_pci_setup_barmap(struct vfio_pci_device *vdev, int bar)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	int ret;
 	void __iomem *io;
=20
@@ -227,13 +227,13 @@ static int vfio_pci_setup_barmap(struct vfio_pci_devi=
ce *vdev, int bar)
 ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
 			size_t count, loff_t *ppos, bool iswrite)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	loff_t pos =3D *ppos & VFIO_PCI_OFFSET_MASK;
 	int bar =3D VFIO_PCI_OFFSET_TO_INDEX(*ppos);
 	size_t x_start =3D 0, x_end =3D 0;
 	resource_size_t end;
 	void __iomem *io;
-	struct resource *res =3D &vdev->pdev->resource[bar];
+	struct resource *res =3D &vdev->vpdev.pdev->resource[bar];
 	ssize_t done;
=20
 	if (pci_resource_start(pdev, bar))
@@ -333,7 +333,7 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, c=
har __user *buf,
 	if (!iomem)
 		return -ENOMEM;
=20
-	ret =3D vga_get_interruptible(vdev->pdev, rsrc);
+	ret =3D vga_get_interruptible(vdev->vpdev.pdev, rsrc);
 	if (ret) {
 		is_ioport ? ioport_unmap(iomem) : iounmap(iomem);
 		return ret;
@@ -346,7 +346,7 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, c=
har __user *buf,
 	 */
 	done =3D do_io_rw(vdev, false, iomem, buf, off, count, 0, 0, iswrite);
=20
-	vga_put(vdev->pdev, rsrc);
+	vga_put(vdev->vpdev.pdev, rsrc);
=20
 	is_ioport ? ioport_unmap(iomem) : iounmap(iomem);
=20
@@ -413,7 +413,7 @@ static void vfio_pci_ioeventfd_thread(void *opaque, voi=
d *unused)
 long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
 			uint64_t data, int count, int fd)
 {
-	struct pci_dev *pdev =3D vdev->pdev;
+	struct pci_dev *pdev =3D vdev->vpdev.pdev;
 	loff_t pos =3D offset & VFIO_PCI_OFFSET_MASK;
 	int ret, bar =3D VFIO_PCI_OFFSET_TO_INDEX(offset);
 	struct vfio_pci_ioeventfd *ioeventfd;
@@ -480,7 +480,7 @@ long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, l=
off_t offset,
 	ioeventfd->pos =3D pos;
 	ioeventfd->bar =3D bar;
 	ioeventfd->count =3D count;
-	ioeventfd->test_mem =3D vdev->pdev->resource[bar].flags & IORESOURCE_MEM;
+	ioeventfd->test_mem =3D vdev->vpdev.pdev->resource[bar].flags & IORESOURC=
E_MEM;
=20
 	ret =3D vfio_virqfd_enable(ioeventfd, vfio_pci_ioeventfd_handler,
 				 vfio_pci_ioeventfd_thread, NULL,
diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_z=
dev.c
index 229685634031..7b20b34b1034 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -117,7 +117,7 @@ static int zpci_pfip_cap(struct zpci_dev *zdev, struct =
vfio_pci_device *vdev,
 int vfio_pci_info_zdev_add_caps(struct vfio_pci_device *vdev,
 				struct vfio_info_cap *caps)
 {
-	struct zpci_dev *zdev =3D to_zpci(vdev->pdev);
+	struct zpci_dev *zdev =3D to_zpci(vdev->vpdev.pdev);
 	int ret;
=20
 	if (!zdev)
--=20
2.25.4

