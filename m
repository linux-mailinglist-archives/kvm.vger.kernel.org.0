Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870FA40C30A
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 11:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237559AbhIOJxX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 05:53:23 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3818 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237486AbhIOJxD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 05:53:03 -0400
Received: from fraeml734-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H8b5f1qBVz6H7c0;
        Wed, 15 Sep 2021 17:49:10 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml734-chm.china.huawei.com (10.206.15.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 11:51:34 +0200
Received: from A2006125610.china.huawei.com (10.47.83.177) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 10:51:28 +0100
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <mgurtovoy@nvidia.com>, <linuxarm@huawei.com>,
        <liulongfang@huawei.com>, <prime.zeng@hisilicon.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH v3 4/6] hisi-acc-vfio-pci: add new vfio_pci driver for HiSilicon ACC devices
Date:   Wed, 15 Sep 2021 10:50:35 +0100
Message-ID: <20210915095037.1149-5-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
References: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.47.83.177]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a vendor-specific vfio_pci driver for HiSilicon ACC devices.
This will be extended in subsequent patches to add support for
VFIO live migration feature.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/vfio/pci/Kconfig             |  9 +++
 drivers/vfio/pci/Makefile            |  3 +
 drivers/vfio/pci/hisi_acc_vfio_pci.c | 99 ++++++++++++++++++++++++++++
 3 files changed, 111 insertions(+)
 create mode 100644 drivers/vfio/pci/hisi_acc_vfio_pci.c

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 860424ccda1b..4fed27fa413d 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -43,4 +43,13 @@ config VFIO_PCI_IGD
 
 	  To enable Intel IGD assignment through vfio-pci, say Y.
 endif
+
+config HISI_ACC_VFIO_PCI
+	tristate "VFIO PCI support for HiSilicon ACC devices"
+	depends on ARM64 && VFIO_PCI_CORE
+	help
+	  This provides generic PCI support for HiSilicon ACC devices
+	  using the VFIO framework.
+
+	  If you don't know what to do here, say N.
 endif
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 349d68d242b4..9d90b036cce6 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -7,3 +7,6 @@ obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
 vfio-pci-y := vfio_pci.o
 vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
+
+hisi-acc-vfio-pci-y := hisi_acc_vfio_pci.o
+obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisi-acc-vfio-pci.o
diff --git a/drivers/vfio/pci/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisi_acc_vfio_pci.c
new file mode 100644
index 000000000000..c847bc469644
--- /dev/null
+++ b/drivers/vfio/pci/hisi_acc_vfio_pci.c
@@ -0,0 +1,99 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, HiSilicon Ltd.
+ */
+
+#include <linux/device.h>
+#include <linux/eventfd.h>
+#include <linux/file.h>
+#include <linux/hisi_acc_qm.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/vfio.h>
+#include <linux/vfio_pci_core.h>
+
+static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	int ret;
+
+	ret = vfio_pci_core_enable(vdev);
+	if (ret)
+		return ret;
+
+	vfio_pci_core_finish_enable(vdev);
+
+	return 0;
+}
+
+static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
+	.name		= "hisi-acc-vfio-pci",
+	.open_device	= hisi_acc_vfio_pci_open_device,
+	.close_device	= vfio_pci_core_close_device,
+	.ioctl		= vfio_pci_core_ioctl,
+	.read		= vfio_pci_core_read,
+	.write		= vfio_pci_core_write,
+	.mmap		= vfio_pci_core_mmap,
+	.request	= vfio_pci_core_request,
+	.match		= vfio_pci_core_match,
+};
+
+static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct vfio_pci_core_device *vdev;
+	int ret;
+
+	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
+	if (!vdev)
+		return -ENOMEM;
+
+	vfio_pci_core_init_device(vdev, pdev, &hisi_acc_vfio_pci_ops);
+
+	ret = vfio_pci_core_register_device(vdev);
+	if (ret)
+		goto out_free;
+
+	dev_set_drvdata(&pdev->dev, vdev);
+
+	return 0;
+
+out_free:
+	vfio_pci_core_uninit_device(vdev);
+	kfree(vdev);
+	return ret;
+}
+
+static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
+
+	vfio_pci_core_unregister_device(vdev);
+	vfio_pci_core_uninit_device(vdev);
+	kfree(vdev);
+}
+
+static const struct pci_device_id hisi_acc_vfio_pci_table[] = {
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI, SEC_VF_PCI_DEVICE_ID) },
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI, HPRE_VF_PCI_DEVICE_ID) },
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI, ZIP_VF_PCI_DEVICE_ID) },
+	{ 0, }
+};
+
+MODULE_DEVICE_TABLE(pci, hisi_acc_vfio_pci_table);
+
+static struct pci_driver hisi_acc_vfio_pci_driver = {
+	.name			= "hisi-acc-vfio-pci",
+	.id_table		= hisi_acc_vfio_pci_table,
+	.probe			= hisi_acc_vfio_pci_probe,
+	.remove			= hisi_acc_vfio_pci_remove,
+	.err_handler		= &vfio_pci_core_err_handlers,
+};
+
+module_pci_driver(hisi_acc_vfio_pci_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Liu Longfang <liulongfang@huawei.com>");
+MODULE_AUTHOR("Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>");
+MODULE_DESCRIPTION("HiSilicon VFIO PCI - Generic VFIO PCI driver for HiSilicon ACC device family");
-- 
2.17.1

