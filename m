Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19F5643CE6
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 06:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233777AbiLFF6u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 00:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbiLFF6n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 00:58:43 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABB226540;
        Mon,  5 Dec 2022 21:58:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670306321; x=1701842321;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DUSArCj86hDjg2xcLGooiKx6M0pp7aVHzT7v3JaXbC4=;
  b=B3rS5+iHX+muKncdThZQBiUJQNFsAOofrJlOCSS9cI00IYyYWhGlsEcM
   4rs862f5NXzuQY5laf24D82AXfJ5T019VcX8xfTSsSbZmy1gAlQcVBCHm
   7EhIh247AG+HFCzRv5qViRElmYdLgtukepjwY9U7tAzsnYmGI6YQgT7sY
   8It9e/BdY77IXPU1TO8Lb7YOgps9Fz/j/8h4i5qTtlGNiic8qrfW9giES
   sDeWgRPssitv47HC7GSJdl4uRTer/FvAvo7ruOOwZv6LPEw9hWQ8iakgy
   6QkvQzUdDq1aGdM9SywClX/gUsnwOusUquP43MZLMLz+B/sGlXdevQDcQ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="378706658"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="378706658"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 21:58:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="648211382"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="648211382"
Received: from leirao-pc.bj.intel.com ([10.238.156.101])
  by fmsmga007.fm.intel.com with ESMTP; 05 Dec 2022 21:58:35 -0800
From:   Lei Rao <lei.rao@intel.com>
To:     kbusch@kernel.org, axboe@fb.com, kch@nvidia.com, hch@lst.de,
        sagi@grimberg.me, alex.williamson@redhat.com, cohuck@redhat.com,
        jgg@ziepe.ca, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org
Cc:     eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com,
        Lei Rao <lei.rao@intel.com>
Subject: [RFC PATCH 2/5] nvme-vfio: add new vfio-pci driver for NVMe device
Date:   Tue,  6 Dec 2022 13:58:13 +0800
Message-Id: <20221206055816.292304-3-lei.rao@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221206055816.292304-1-lei.rao@intel.com>
References: <20221206055816.292304-1-lei.rao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

NVMe device has specific live migration implementation.
Add an specific VFIO PCI driver for NVMe device. Its
live migration support will be added in the subsequent
patches.

Signed-off-by: Lei Rao <lei.rao@intel.com>
Signed-off-by: Yadong Li <yadong.li@intel.com>
Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Eddie Dong <eddie.dong@intel.com>
Reviewed-by: Hang Yuan <hang.yuan@intel.com>
---
 drivers/vfio/pci/Kconfig       |  2 +
 drivers/vfio/pci/Makefile      |  2 +
 drivers/vfio/pci/nvme/Kconfig  |  9 ++++
 drivers/vfio/pci/nvme/Makefile |  3 ++
 drivers/vfio/pci/nvme/nvme.c   | 99 ++++++++++++++++++++++++++++++++++
 5 files changed, 115 insertions(+)
 create mode 100644 drivers/vfio/pci/nvme/Kconfig
 create mode 100644 drivers/vfio/pci/nvme/Makefile
 create mode 100644 drivers/vfio/pci/nvme/nvme.c

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index f9d0c908e738..fcd45144d3e3 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -59,4 +59,6 @@ source "drivers/vfio/pci/mlx5/Kconfig"
 
 source "drivers/vfio/pci/hisilicon/Kconfig"
 
+source "drivers/vfio/pci/nvme/Kconfig"
+
 endif
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 24c524224da5..eddc8e889726 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -11,3 +11,5 @@ obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
 obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
 
 obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
+
+obj-$(CONFIG_NVME_VFIO_PCI) += nvme/
diff --git a/drivers/vfio/pci/nvme/Kconfig b/drivers/vfio/pci/nvme/Kconfig
new file mode 100644
index 000000000000..c281fe154007
--- /dev/null
+++ b/drivers/vfio/pci/nvme/Kconfig
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config NVME_VFIO_PCI
+	tristate "VFIO support for NVMe PCI devices"
+	depends on VFIO_PCI_CORE
+	help
+	  This provides generic VFIO PCI support for NVMe device
+	  using the VFIO framework.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/pci/nvme/Makefile b/drivers/vfio/pci/nvme/Makefile
new file mode 100644
index 000000000000..2f4a0ad3d9cf
--- /dev/null
+++ b/drivers/vfio/pci/nvme/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_NVME_VFIO_PCI) += nvme-vfio-pci.o
+nvme-vfio-pci-y := nvme.o
diff --git a/drivers/vfio/pci/nvme/nvme.c b/drivers/vfio/pci/nvme/nvme.c
new file mode 100644
index 000000000000..f1386d8a9287
--- /dev/null
+++ b/drivers/vfio/pci/nvme/nvme.c
@@ -0,0 +1,99 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2022, INTEL CORPORATION. All rights reserved
+ */
+
+#include <linux/device.h>
+#include <linux/eventfd.h>
+#include <linux/file.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/pci.h>
+#include <linux/types.h>
+#include <linux/vfio.h>
+#include <linux/anon_inodes.h>
+#include <linux/kernel.h>
+#include <linux/vfio_pci_core.h>
+
+static int nvmevf_pci_open_device(struct vfio_device *core_vdev)
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
+	return 0;
+}
+
+static const struct vfio_device_ops nvmevf_pci_ops = {
+	.name = "nvme-vfio-pci",
+	.init = vfio_pci_core_init_dev,
+	.release = vfio_pci_core_release_dev,
+	.open_device = nvmevf_pci_open_device,
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
+static int nvmevf_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct vfio_pci_core_device *vdev;
+	int ret;
+
+	vdev = vfio_alloc_device(vfio_pci_core_device, vdev, &pdev->dev,
+				&nvmevf_pci_ops);
+	if (IS_ERR(vdev))
+		return PTR_ERR(vdev);
+
+	dev_set_drvdata(&pdev->dev, vdev);
+	ret = vfio_pci_core_register_device(vdev);
+	if (ret)
+		goto out_put_dev;
+
+	return 0;
+
+out_put_dev:
+	vfio_put_device(&vdev->vdev);
+	return ret;
+}
+
+static void nvmevf_pci_remove(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
+
+	vfio_pci_core_unregister_device(vdev);
+	vfio_put_device(&vdev->vdev);
+}
+
+static const struct pci_device_id nvmevf_pci_table[] = {
+	/* Intel IPU NVMe Virtual Function */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL, 0x1457) },
+	{}
+};
+
+MODULE_DEVICE_TABLE(pci, nvmevf_pci_table);
+
+static struct pci_driver nvmevf_pci_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = nvmevf_pci_table,
+	.probe = nvmevf_pci_probe,
+	.remove = nvmevf_pci_remove,
+	.err_handler = &vfio_pci_core_err_handlers,
+	.driver_managed_dma = true,
+};
+
+module_pci_driver(nvmevf_pci_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Lei Rao <lei.rao@intel.com>");
+MODULE_DESCRIPTION("NVMe VFIO PCI - Generic VFIO PCI driver for NVMe");
-- 
2.34.1

