Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A277C815C
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 11:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbjJMJII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 05:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbjJMJIH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 05:08:07 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87833BE;
        Fri, 13 Oct 2023 02:08:05 -0700 (PDT)
Received: from kwepemm000005.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4S6LCn73bhzLqcp;
        Fri, 13 Oct 2023 17:04:05 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemm000005.china.huawei.com
 (7.193.23.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Fri, 13 Oct
 2023 17:08:02 +0800
From:   Longfang Liu <liulongfang@huawei.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>,
        <jonathan.cameron@huawei.com>
CC:     <bcreeley@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <liulongfang@huawei.com>
Subject: [PATCH v17 1/2] vfio/migration: Add debugfs to live migration driver
Date:   Fri, 13 Oct 2023 17:04:40 +0800
Message-ID: <20231013090441.36417-2-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20231013090441.36417-1-liulongfang@huawei.com>
References: <20231013090441.36417-1-liulongfang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.50.163.32]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm000005.china.huawei.com (7.193.23.27)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are multiple devices, software and operational steps involved
in the process of live migration. An error occurred on any node may
cause the live migration operation to fail.
This complex process makes it very difficult to locate and analyze
the cause when the function fails.

In order to quickly locate the cause of the problem when the
live migration fails, I added a set of debugfs to the vfio
live migration driver.

    +-------------------------------------------+
    |                                           |
    |                                           |
    |                  QEMU                     |
    |                                           |
    |                                           |
    +---+----------------------------+----------+
        |      ^                     |      ^
        |      |                     |      |
        |      |                     |      |
        v      |                     v      |
     +---------+--+               +---------+--+
     |src vfio_dev|               |dst vfio_dev|
     +--+---------+               +--+---------+
        |      ^                     |      ^
        |      |                     |      |
        v      |                     |      |
   +-----------+----+           +-----------+----+
   |src dev debugfs |           |dst dev debugfs |
   +----------------+           +----------------+

The entire debugfs directory will be based on the definition of
the CONFIG_DEBUG_FS macro. If this macro is not enabled, the
interfaces in vfio.h will be empty definitions, and the creation
and initialization of the debugfs directory will not be executed.

   vfio
    |
    +---<dev_name1>
    |    +---migration
    |        +--state
    |
    +---<dev_name2>
         +---migration
             +--state

debugfs will create a public root directory "vfio" file.
then create a dev_name() file for each live migration device.
First, create a unified state acquisition file of "migration"
in this device directory.
Then, create a public live migration state lookup file "state".

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/vfio/Kconfig      | 10 +++++
 drivers/vfio/Makefile     |  1 +
 drivers/vfio/debugfs.c    | 90 +++++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio.h       | 14 ++++++
 drivers/vfio/vfio_main.c  | 14 +++++-
 include/linux/vfio.h      |  7 +++
 include/uapi/linux/vfio.h |  1 +
 7 files changed, 135 insertions(+), 2 deletions(-)
 create mode 100644 drivers/vfio/debugfs.c

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 6bda6dbb4878..ceae52fd7586 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -80,6 +80,16 @@ config VFIO_VIRQFD
 	select EVENTFD
 	default n
 
+config VFIO_DEBUGFS
+	bool "Export VFIO internals in DebugFS"
+	depends on DEBUG_FS
+	help
+	  Allows exposure of VFIO device internals. This option enables
+	  the use of debugfs by VFIO drivers as required. The device can
+	  cause the VFIO code create a top-level debug/vfio directory
+	  during initialization, and then populate a subdirectory with
+	  entries as required.
+
 source "drivers/vfio/pci/Kconfig"
 source "drivers/vfio/platform/Kconfig"
 source "drivers/vfio/mdev/Kconfig"
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index c82ea032d352..d43a699d55b1 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -8,6 +8,7 @@ vfio-$(CONFIG_VFIO_GROUP) += group.o
 vfio-$(CONFIG_IOMMUFD) += iommufd.o
 vfio-$(CONFIG_VFIO_CONTAINER) += container.o
 vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
+vfio-$(CONFIG_VFIO_DEBUGFS) += debugfs.o
 
 obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
 obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
diff --git a/drivers/vfio/debugfs.c b/drivers/vfio/debugfs.c
new file mode 100644
index 000000000000..ae53d6110f47
--- /dev/null
+++ b/drivers/vfio/debugfs.c
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2023, HiSilicon Ltd.
+ */
+
+#include <linux/device.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/vfio.h>
+#include "vfio.h"
+
+static struct dentry *vfio_debugfs_root;
+
+static int vfio_device_state_read(struct seq_file *seq, void *data)
+{
+	struct device *vf_dev = seq->private;
+	struct vfio_device *vdev = container_of(vf_dev, struct vfio_device, device);
+	enum vfio_device_mig_state state;
+	int ret;
+
+	BUILD_BUG_ON(VFIO_DEVICE_STATE_NR !=
+		VFIO_DEVICE_STATE_PRE_COPY_P2P + 1);
+
+	ret = vdev->mig_ops->migration_get_state(vdev, &state);
+	if (ret)
+		return -EINVAL;
+
+	switch (state) {
+	case VFIO_DEVICE_STATE_ERROR:
+		seq_printf(seq, "%s\n", "ERROR");
+		break;
+	case VFIO_DEVICE_STATE_STOP:
+		seq_printf(seq, "%s\n", "STOP");
+		break;
+	case VFIO_DEVICE_STATE_RUNNING:
+		seq_printf(seq, "%s\n", "RUNNING");
+		break;
+	case VFIO_DEVICE_STATE_STOP_COPY:
+		seq_printf(seq, "%s\n", "STOP_COPY");
+		break;
+	case VFIO_DEVICE_STATE_RESUMING:
+		seq_printf(seq, "%s\n", "RESUMING");
+		break;
+	case VFIO_DEVICE_STATE_RUNNING_P2P:
+		seq_printf(seq, "%s\n", "RUNNING_P2P");
+		break;
+	case VFIO_DEVICE_STATE_PRE_COPY:
+		seq_printf(seq, "%s\n", "PRE_COPY");
+		break;
+	case VFIO_DEVICE_STATE_PRE_COPY_P2P:
+		seq_printf(seq, "%s\n", "PRE_COPY_P2P");
+		break;
+	default:
+		seq_printf(seq, "%s\n", "Invalid");
+	}
+
+	return 0;
+}
+
+void vfio_device_debugfs_init(struct vfio_device *vdev)
+{
+	struct device *dev = &vdev->device;
+
+	vdev->debug_root = debugfs_create_dir(dev_name(vdev->dev), vfio_debugfs_root);
+
+	if (vdev->mig_ops) {
+		struct dentry *vfio_dev_migration = NULL;
+
+		vfio_dev_migration = debugfs_create_dir("migration", vdev->debug_root);
+		debugfs_create_devm_seqfile(dev, "state", vfio_dev_migration,
+					  vfio_device_state_read);
+	}
+}
+
+void vfio_device_debugfs_exit(struct vfio_device *vdev)
+{
+	debugfs_remove_recursive(vdev->debug_root);
+}
+
+void vfio_debugfs_create_root(void)
+{
+	vfio_debugfs_root = debugfs_create_dir("vfio", NULL);
+}
+
+void vfio_debugfs_remove_root(void)
+{
+	debugfs_remove_recursive(vfio_debugfs_root);
+	vfio_debugfs_root = NULL;
+}
+
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 307e3f29b527..bde84ad344e5 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -448,4 +448,18 @@ static inline void vfio_device_put_kvm(struct vfio_device *device)
 }
 #endif
 
+#ifdef CONFIG_VFIO_DEBUGFS
+void vfio_debugfs_create_root(void);
+void vfio_debugfs_remove_root(void);
+
+void vfio_device_debugfs_init(struct vfio_device *vdev);
+void vfio_device_debugfs_exit(struct vfio_device *vdev);
+#else
+static inline void vfio_debugfs_create_root(void) { }
+static inline void vfio_debugfs_remove_root(void) { }
+
+static inline void vfio_device_debugfs_init(struct vfio_device *vdev) { }
+static inline void vfio_device_debugfs_exit(struct vfio_device *vdev) { }
+#endif /* CONFIG_VFIO_DEBUGFS */
+
 #endif
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index e31e1952d7b8..9aec4c22f051 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -309,7 +309,6 @@ static int __vfio_register_dev(struct vfio_device *device,
 
 	/* Refcounting can't start until the driver calls register */
 	refcount_set(&device->refcount, 1);
-
 	vfio_device_group_register(device);
 
 	return 0;
@@ -320,7 +319,15 @@ static int __vfio_register_dev(struct vfio_device *device,
 
 int vfio_register_group_dev(struct vfio_device *device)
 {
-	return __vfio_register_dev(device, VFIO_IOMMU);
+	int ret;
+
+	ret = __vfio_register_dev(device, VFIO_IOMMU);
+	if (ret)
+		return ret;
+
+	vfio_device_debugfs_init(device);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(vfio_register_group_dev);
 
@@ -378,6 +385,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 		}
 	}
 
+	vfio_device_debugfs_exit(device);
 	/* Balances vfio_device_set_group in register path */
 	vfio_device_remove_group(device);
 }
@@ -1676,6 +1684,7 @@ static int __init vfio_init(void)
 	if (ret)
 		goto err_alloc_dev_chrdev;
 
+	vfio_debugfs_create_root();
 	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 	return 0;
 
@@ -1691,6 +1700,7 @@ static int __init vfio_init(void)
 
 static void __exit vfio_cleanup(void)
 {
+	vfio_debugfs_remove_root();
 	ida_destroy(&vfio.device_ida);
 	vfio_cdev_cleanup();
 	class_destroy(vfio.device_class);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 454e9295970c..769d7af86225 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -69,6 +69,13 @@ struct vfio_device {
 	u8 iommufd_attached:1;
 #endif
 	u8 cdev_opened:1;
+#ifdef CONFIG_DEBUG_FS
+	/*
+	 * debug_root is a static property of the vfio_device
+	 * which must be set prior to registering the vfio_device.
+	 */
+	struct dentry *debug_root;
+#endif
 };
 
 /**
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 7f5fb010226d..2b68e6cdf190 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1219,6 +1219,7 @@ enum vfio_device_mig_state {
 	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
 	VFIO_DEVICE_STATE_PRE_COPY = 6,
 	VFIO_DEVICE_STATE_PRE_COPY_P2P = 7,
+	VFIO_DEVICE_STATE_NR,
 };
 
 /**
-- 
2.24.0

