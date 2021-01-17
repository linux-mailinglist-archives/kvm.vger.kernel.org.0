Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DE82F9476
	for <lists+kvm@lfdr.de>; Sun, 17 Jan 2021 19:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbhAQSQw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Jan 2021 13:16:52 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15751 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729893AbhAQSQ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Jan 2021 13:16:29 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60047ed50000>; Sun, 17 Jan 2021 10:15:49 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 17 Jan
 2021 18:15:48 +0000
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Sun, 17 Jan 2021 18:15:44 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <jgg@nvidia.com>, <liranl@nvidia.com>, <oren@nvidia.com>,
        <tzahio@nvidia.com>, <leonro@nvidia.com>, <yarong@nvidia.com>,
        <aviadye@nvidia.com>, <shahafs@nvidia.com>, <artemp@nvidia.com>,
        <kwankhede@nvidia.com>, <ACurrid@nvidia.com>, <gmataev@nvidia.com>,
        <cjia@nvidia.com>, Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 2/3] vfio-pci: introduce vfio_pci_core subsystem driver
Date:   Sun, 17 Jan 2021 18:15:33 +0000
Message-ID: <20210117181534.65724-3-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210117181534.65724-1-mgurtovoy@nvidia.com>
References: <20210117181534.65724-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610907349; bh=IHWJGxN14hMCL5d5/RLkTkpAGSxERlTZ4oWpLjoWwOA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        b=aaHL0f5pOU/mRnIBd3MUKmZL0weN5VQRp9bx52MyyN3KbqJ9TlQ0jHxX6FWNdnpNp
         Ka+KEjarPIJmO2zdeMkxaWc709ChFDqoXiFbzOSH63JMgCK9vct0RQzknHFu+s6T46
         JzNnNHUYTTHZRIJcRBQFbslb5EBLtAetbt/p9XpdY7sG/JMWM5eWuFxhUP52mIAPq3
         /IO4xebCEjk3JP9yqs+A673AXE10F3XT01YrJwMaPDuyG6L/+6B+rxNsaRDzs8BkS8
         nBptK6etfc19HzUpWd/yC8KQmKb7fzoiSqPRv8VCig4yl/IpKTQPwguZFgPD16y+Ib
         OpY/tb4Bu0FKQ==
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
 drivers/vfio/pci/Kconfig            |  12 +-
 drivers/vfio/pci/Makefile           |  13 +-
 drivers/vfio/pci/vfio_pci.c         | 220 ++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_core.c    | 255 +++++++---------------------
 drivers/vfio/pci/vfio_pci_private.h |  21 +++
 5 files changed, 321 insertions(+), 200 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci.c

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 40a223381ab6..5f90be27fba0 100644
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
@@ -10,6 +10,14 @@ config VFIO_PCI
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
 	depends on VFIO_PCI && X86 && VGA_ARB
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
index 000000000000..4e115a136930
--- /dev/null
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -0,0 +1,220 @@
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
+#include <linux/pci.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/vfio.h>
+#include <linux/vgaarb.h>
+#include <linux/nospec.h>
+#include <linux/sched/mm.h>
+
+#include "vfio_pci_private.h"
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
+static const struct vfio_device_ops vfio_pci_ops =3D {
+	.name		=3D "vfio-pci",
+	.open		=3D vfio_pci_core_open,
+	.release	=3D vfio_pci_core_release,
+	.ioctl		=3D vfio_pci_core_ioctl,
+	.read		=3D vfio_pci_core_read,
+	.write		=3D vfio_pci_core_write,
+	.mmap		=3D vfio_pci_core_mmap,
+	.request	=3D vfio_pci_core_request,
+	.match		=3D vfio_pci_core_match,
+};
+
+static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id=
 *id)
+{
+	struct vfio_pci_device *vdev;
+
+	if (vfio_pci_is_denylisted(pdev))
+		return -EINVAL;
+
+	vdev =3D vfio_create_pci_device(pdev, &vfio_pci_ops, NULL);
+	if (IS_ERR(vdev))
+		return PTR_ERR(vdev);
+
+	return 0;
+}
+
+static void vfio_pci_remove(struct pci_dev *pdev)
+{
+	vfio_destroy_pci_device(pdev);
+}
+
+static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
+						  pci_channel_state_t state)
+{
+	return vfio_pci_core_aer_err_detected(pdev, state);
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
+	.error_detected =3D vfio_pci_aer_err_detected,
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
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_c=
ore.c
index 706de3ef94bb..e87f828faf71 100644
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
@@ -515,8 +463,6 @@ static void vfio_pci_disable(struct vfio_pci_device *vd=
ev)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 }
=20
-static struct pci_driver vfio_pci_driver;
-
 static struct vfio_pci_device *get_pf_vdev(struct vfio_pci_device *vdev,
 					   struct vfio_device **pf_dev)
 {
@@ -529,7 +475,7 @@ static struct vfio_pci_device *get_pf_vdev(struct vfio_=
pci_device *vdev,
 	if (!*pf_dev)
 		return NULL;
=20
-	if (pci_dev_driver(physfn) !=3D &vfio_pci_driver) {
+	if (pci_dev_driver(physfn) !=3D pci_dev_driver(vdev->pdev)) {
 		vfio_device_put(*pf_dev);
 		return NULL;
 	}
@@ -553,7 +499,7 @@ static void vfio_pci_vf_token_user_add(struct vfio_pci_=
device *vdev, int val)
 	vfio_device_put(pf_dev);
 }
=20
-static void vfio_pci_release(void *device_data)
+void vfio_pci_core_release(void *device_data)
 {
 	struct vfio_pci_device *vdev =3D device_data;
=20
@@ -580,8 +526,9 @@ static void vfio_pci_release(void *device_data)
=20
 	module_put(THIS_MODULE);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_release);
=20
-static int vfio_pci_open(void *device_data)
+int vfio_pci_core_open(void *device_data)
 {
 	struct vfio_pci_device *vdev =3D device_data;
 	int ret =3D 0;
@@ -606,6 +553,7 @@ static int vfio_pci_open(void *device_data)
 		module_put(THIS_MODULE);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_open);
=20
 static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_ty=
pe)
 {
@@ -797,8 +745,8 @@ struct vfio_devices {
 	int max_index;
 };
=20
-static long vfio_pci_ioctl(void *device_data,
-			   unsigned int cmd, unsigned long arg)
+long vfio_pci_core_ioctl(void *device_data, unsigned int cmd,
+		unsigned long arg)
 {
 	struct vfio_pci_device *vdev =3D device_data;
 	unsigned long minsz;
@@ -1403,12 +1351,12 @@ static long vfio_pci_ioctl(void *device_data,
=20
 	return -ENOTTY;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
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
@@ -1436,23 +1384,27 @@ static ssize_t vfio_pci_rw(void *device_data, char =
__user *buf,
 	return -EINVAL;
 }
=20
-static ssize_t vfio_pci_read(void *device_data, char __user *buf,
-			     size_t count, loff_t *ppos)
+ssize_t vfio_pci_core_read(void *device_data, char __user *buf,
+		size_t count, loff_t *ppos)
 {
+	struct vfio_pci_device *vdev =3D device_data;
 	if (!count)
 		return 0;
=20
-	return vfio_pci_rw(device_data, buf, count, ppos, false);
+	return vfio_pci_rw(vdev, buf, count, ppos, false);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_read);
=20
-static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
-			      size_t count, loff_t *ppos)
+ssize_t vfio_pci_core_write(void *device_data,
+		const char __user *buf, size_t count, loff_t *ppos)
 {
+	struct vfio_pci_device *vdev =3D device_data;
 	if (!count)
 		return 0;
=20
-	return vfio_pci_rw(device_data, (char __user *)buf, count, ppos, true);
+	return vfio_pci_rw(vdev, (char __user *)buf, count, ppos, true);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_write);
=20
 /* Return 1 on zap and vma_lock acquired, 0 on contention (only with @try)=
 */
 static int vfio_pci_zap_and_vma_lock(struct vfio_pci_device *vdev, bool tr=
y)
@@ -1648,7 +1600,8 @@ static const struct vm_operations_struct vfio_pci_mma=
p_ops =3D {
 	.fault =3D vfio_pci_mmap_fault,
 };
=20
-static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
+int vfio_pci_core_mmap(void *device_data,
+		struct vm_area_struct *vma)
 {
 	struct vfio_pci_device *vdev =3D device_data;
 	struct pci_dev *pdev =3D vdev->pdev;
@@ -1715,8 +1668,9 @@ static int vfio_pci_mmap(void *device_data, struct vm=
_area_struct *vma)
=20
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_mmap);
=20
-static void vfio_pci_request(void *device_data, unsigned int count)
+void vfio_pci_core_request(void *device_data, unsigned int count)
 {
 	struct vfio_pci_device *vdev =3D device_data;
 	struct pci_dev *pdev =3D vdev->pdev;
@@ -1736,6 +1690,7 @@ static void vfio_pci_request(void *device_data, unsig=
ned int count)
=20
 	mutex_unlock(&vdev->igate);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_request);
=20
 static int vfio_pci_validate_vf_token(struct vfio_pci_device *vdev,
 				      bool vf_token, uuid_t *uuid)
@@ -1832,7 +1787,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci=
_device *vdev,
=20
 #define VF_TOKEN_ARG "vf_token=3D"
=20
-static int vfio_pci_match(void *device_data, char *buf)
+int vfio_pci_core_match(void *device_data, char *buf)
 {
 	struct vfio_pci_device *vdev =3D device_data;
 	bool vf_token =3D false;
@@ -1880,18 +1835,7 @@ static int vfio_pci_match(void *device_data, char *b=
uf)
=20
 	return 1; /* Match */
 }
-
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
-};
+EXPORT_SYMBOL_GPL(vfio_pci_core_match);
=20
 static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
 static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck);
@@ -1910,12 +1854,12 @@ static int vfio_pci_bus_notifier(struct notifier_bl=
ock *nb,
 		pci_info(vdev->pdev, "Captured SR-IOV VF %s driver_override\n",
 			 pci_name(pdev));
 		pdev->driver_override =3D kasprintf(GFP_KERNEL, "%s",
-						  vfio_pci_ops.name);
+						  vdev->vfio_pci_ops->name);
 	} else if (action =3D=3D BUS_NOTIFY_BOUND_DRIVER &&
 		   pdev->is_virtfn && physfn =3D=3D vdev->pdev) {
 		struct pci_driver *drv =3D pci_dev_driver(pdev);
=20
-		if (drv && drv !=3D &vfio_pci_driver)
+		if (drv && drv !=3D pci_dev_driver(vdev->pdev))
 			pci_warn(vdev->pdev,
 				 "VF %s bound to driver %s while PF bound to vfio-pci\n",
 				 pci_name(pdev), drv->name);
@@ -1924,17 +1868,16 @@ static int vfio_pci_bus_notifier(struct notifier_bl=
ock *nb,
 	return 0;
 }
=20
-static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id=
 *id)
+struct vfio_pci_device *vfio_create_pci_device(struct pci_dev *pdev,
+		const struct vfio_device_ops *vfio_pci_ops,
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
@@ -1946,12 +1889,12 @@ static int vfio_pci_probe(struct pci_dev *pdev, con=
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
@@ -1960,6 +1903,8 @@ static int vfio_pci_probe(struct pci_dev *pdev, const=
 struct pci_device_id *id)
 	}
=20
 	vdev->pdev =3D pdev;
+	vdev->vfio_pci_ops =3D vfio_pci_ops;
+	vdev->dd_data =3D dd_data;
 	vdev->irq_type =3D VFIO_PCI_NUM_IRQS;
 	mutex_init(&vdev->igate);
 	spin_lock_init(&vdev->irqlock);
@@ -1970,7 +1915,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const=
 struct pci_device_id *id)
 	INIT_LIST_HEAD(&vdev->vma_list);
 	init_rwsem(&vdev->memory_lock);
=20
-	ret =3D vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
+	ret =3D vfio_add_group_dev(&pdev->dev, vfio_pci_ops, vdev);
 	if (ret)
 		goto out_free;
=20
@@ -2016,7 +1961,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const=
 struct pci_device_id *id)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 	}
=20
-	return ret;
+	return vdev;
=20
 out_vf_token:
 	kfree(vdev->vf_token);
@@ -2028,10 +1973,11 @@ static int vfio_pci_probe(struct pci_dev *pdev, con=
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
@@ -2069,9 +2015,10 @@ static void vfio_pci_remove(struct pci_dev *pdev)
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
@@ -2097,18 +2044,14 @@ static pci_ers_result_t vfio_pci_aer_err_detected(s=
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
@@ -2128,19 +2071,7 @@ static int vfio_pci_sriov_configure(struct pci_dev *=
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
@@ -2173,13 +2104,13 @@ static int vfio_pci_reflck_find(struct pci_dev *pde=
v, void *data)
 	if (!device)
 		return 0;
=20
-	if (pci_dev_driver(pdev) !=3D &vfio_pci_driver) {
+	vdev =3D vfio_device_data(device);
+
+	if (pci_dev_driver(pdev) !=3D pci_dev_driver(vdev->pdev)) {
 		vfio_device_put(device);
 		return 0;
 	}
=20
-	vdev =3D vfio_device_data(device);
-
 	if (vdev->reflck) {
 		vfio_pci_reflck_get(vdev->reflck);
 		*preflck =3D vdev->reflck;
@@ -2235,13 +2166,13 @@ static int vfio_pci_get_unused_devs(struct pci_dev =
*pdev, void *data)
 	if (!device)
 		return -EINVAL;
=20
-	if (pci_dev_driver(pdev) !=3D &vfio_pci_driver) {
+	vdev =3D vfio_device_data(device);
+
+	if (pci_dev_driver(pdev) !=3D pci_dev_driver(vdev->pdev)) {
 		vfio_device_put(device);
 		return -EBUSY;
 	}
=20
-	vdev =3D vfio_device_data(device);
-
 	/* Fault if the device is not unused */
 	if (vdev->refcnt) {
 		vfio_device_put(device);
@@ -2265,13 +2196,13 @@ static int vfio_pci_try_zap_and_vma_lock_cb(struct =
pci_dev *pdev, void *data)
 	if (!device)
 		return -EINVAL;
=20
-	if (pci_dev_driver(pdev) !=3D &vfio_pci_driver) {
+	vdev =3D vfio_device_data(device);
+
+	if (pci_dev_driver(pdev) !=3D pci_dev_driver(vdev->pdev)) {
 		vfio_device_put(device);
 		return -EBUSY;
 	}
=20
-	vdev =3D vfio_device_data(device);
-
 	/*
 	 * Locking multiple devices is prone to deadlock, runaway and
 	 * unwind if we hit contention.
@@ -2360,81 +2291,19 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_=
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
-{
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
+static int __init vfio_pci_core_init(void)
 {
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
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pc=
i_private.h
index 5c90e560c5c7..331a8db6b537 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -101,6 +101,7 @@ struct vfio_pci_mmap_vma {
=20
 struct vfio_pci_device {
 	struct pci_dev		*pdev;
+	const struct vfio_device_ops *vfio_pci_ops;
 	void __iomem		*barmap[PCI_STD_NUM_BARS];
 	bool			bar_mmap_supported[PCI_STD_NUM_BARS];
 	u8			*pci_config_map;
@@ -142,6 +143,7 @@ struct vfio_pci_device {
 	struct mutex		vma_lock;
 	struct list_head	vma_list;
 	struct rw_semaphore	memory_lock;
+	void			*dd_data;
 };
=20
 #define is_intx(vdev) (vdev->irq_type =3D=3D VFIO_PCI_INTX_IRQ_INDEX)
@@ -225,4 +227,23 @@ static inline int vfio_pci_info_zdev_add_caps(struct v=
fio_pci_device *vdev,
 }
 #endif
=20
+/* Exported functions */
+struct vfio_pci_device *vfio_create_pci_device(struct pci_dev *pdev,
+		const struct vfio_device_ops *vfio_pci_ops, void *dd_data);
+void vfio_destroy_pci_device(struct pci_dev *pdev);
+int vfio_pci_core_open(void *device_data);
+void vfio_pci_core_release(void *device_data);
+long vfio_pci_core_ioctl(void *device_data, unsigned int cmd,
+		unsigned long arg);
+ssize_t vfio_pci_core_read(void *device_data, char __user *buf, size_t cou=
nt,
+		loff_t *ppos);
+ssize_t vfio_pci_core_write(void *device_data, const char __user *buf,
+		size_t count, loff_t *ppos);
+int vfio_pci_core_mmap(void *device_data, struct vm_area_struct *vma);
+void vfio_pci_core_request(void *device_data, unsigned int count);
+int vfio_pci_core_match(void *device_data, char *buf);
+int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn);
+pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
+		pci_channel_state_t state);
+
 #endif /* VFIO_PCI_PRIVATE_H */
--=20
2.25.4

