Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93CDB4D2098
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 19:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349742AbiCHSve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 13:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349763AbiCHSvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 13:51:31 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E6353728;
        Tue,  8 Mar 2022 10:50:26 -0800 (PST)
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KCkrG3y2Qz67P7p;
        Wed,  9 Mar 2022 02:49:02 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Tue, 8 Mar 2022 19:50:24 +0100
Received: from A2006125610.china.huawei.com (10.47.82.254) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 18:50:16 +0000
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <linux-pci@vger.kernel.org>, <alex.williamson@redhat.com>,
        <jgg@nvidia.com>, <cohuck@redhat.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <kevin.tian@intel.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH v9 4/9] hisi_acc_vfio_pci: add new vfio_pci driver for HiSilicon ACC devices
Date:   Tue, 8 Mar 2022 18:48:57 +0000
Message-ID: <20220308184902.2242-5-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20220308184902.2242-1-shameerali.kolothum.thodi@huawei.com>
References: <20220308184902.2242-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.47.82.254]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a vendor-specific vfio_pci driver for HiSilicon ACC devices.
This will be extended in subsequent patches to add support for VFIO
live migration feature.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 MAINTAINERS                                   |   7 ++
 drivers/vfio/pci/Kconfig                      |   2 +
 drivers/vfio/pci/Makefile                     |   2 +
 drivers/vfio/pci/hisilicon/Kconfig            |  10 ++
 drivers/vfio/pci/hisilicon/Makefile           |   4 +
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 100 ++++++++++++++++++
 6 files changed, 125 insertions(+)
 create mode 100644 drivers/vfio/pci/hisilicon/Kconfig
 create mode 100644 drivers/vfio/pci/hisilicon/Makefile
 create mode 100644 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 4322b5321891..48e09ca666c2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20305,6 +20305,13 @@ L:	kvm@vger.kernel.org
 S:	Maintained
 F:	drivers/vfio/fsl-mc/
 
+VFIO HISILICON PCI DRIVER
+M:	Longfang Liu <liulongfang@huawei.com>
+M:	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
+L:	kvm@vger.kernel.org
+S:	Maintained
+F:	drivers/vfio/pci/hisilicon/
+
 VFIO MEDIATED DEVICE DRIVERS
 M:	Kirti Wankhede <kwankhede@nvidia.com>
 L:	kvm@vger.kernel.org
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 187b9c259944..4da1914425e1 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -46,4 +46,6 @@ endif
 
 source "drivers/vfio/pci/mlx5/Kconfig"
 
+source "drivers/vfio/pci/hisilicon/Kconfig"
+
 endif
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index ed9d6f2e0555..7052ebd893e0 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -9,3 +9,5 @@ vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
 
 obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
+
+obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
diff --git a/drivers/vfio/pci/hisilicon/Kconfig b/drivers/vfio/pci/hisilicon/Kconfig
new file mode 100644
index 000000000000..dc723bad05c2
--- /dev/null
+++ b/drivers/vfio/pci/hisilicon/Kconfig
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config HISI_ACC_VFIO_PCI
+	tristate "VFIO PCI support for HiSilicon ACC devices"
+	depends on ARM64 || (COMPILE_TEST && 64BIT)
+	depends on VFIO_PCI_CORE
+	help
+	  This provides generic PCI support for HiSilicon ACC devices
+	  using the VFIO framework.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/pci/hisilicon/Makefile b/drivers/vfio/pci/hisilicon/Makefile
new file mode 100644
index 000000000000..c66b3783f2f9
--- /dev/null
+++ b/drivers/vfio/pci/hisilicon/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisi-acc-vfio-pci.o
+hisi-acc-vfio-pci-y := hisi_acc_vfio_pci.o
+
diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
new file mode 100644
index 000000000000..8129c3457b3b
--- /dev/null
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -0,0 +1,100 @@
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
+	.name = "hisi-acc-vfio-pci",
+	.open_device = hisi_acc_vfio_pci_open_device,
+	.close_device = vfio_pci_core_close_device,
+	.ioctl = vfio_pci_core_ioctl,
+	.device_feature = vfio_pci_core_ioctl_feature,
+	.read = vfio_pci_core_read,
+	.write = vfio_pci_core_write,
+	.mmap = vfio_pci_core_mmap,
+	.request = vfio_pci_core_request,
+	.match = vfio_pci_core_match,
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
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_HUAWEI_SEC_VF) },
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_HUAWEI_HPRE_VF) },
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_HUAWEI_ZIP_VF) },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(pci, hisi_acc_vfio_pci_table);
+
+static struct pci_driver hisi_acc_vfio_pci_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = hisi_acc_vfio_pci_table,
+	.probe = hisi_acc_vfio_pci_probe,
+	.remove = hisi_acc_vfio_pci_remove,
+	.err_handler = &vfio_pci_core_err_handlers,
+};
+
+module_pci_driver(hisi_acc_vfio_pci_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Liu Longfang <liulongfang@huawei.com>");
+MODULE_AUTHOR("Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>");
+MODULE_DESCRIPTION("HiSilicon VFIO PCI - Generic VFIO PCI driver for HiSilicon ACC device family");
-- 
2.25.1

