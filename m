Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1AB410A32
	for <lists+kvm@lfdr.de>; Sun, 19 Sep 2021 08:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbhISGnD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Sep 2021 02:43:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:2289 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234571AbhISGnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Sep 2021 02:43:01 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10111"; a="223030120"
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="223030120"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2021 23:41:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="510701852"
Received: from yiliu-dev.bj.intel.com (HELO iov-dual.bj.intel.com) ([10.238.156.135])
  by fmsmga008.fm.intel.com with ESMTP; 18 Sep 2021 23:41:29 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, hch@lst.de,
        jasowang@redhat.com, joro@8bytes.org
Cc:     jean-philippe@linaro.org, kevin.tian@intel.com, parav@mellanox.com,
        lkml@metux.net, pbonzini@redhat.com, lushenming@huawei.com,
        eric.auger@redhat.com, corbet@lwn.net, ashok.raj@intel.com,
        yi.l.liu@intel.com, yi.l.liu@linux.intel.com, jun.j.tian@intel.com,
        hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: [RFC 01/20] iommu/iommufd: Add /dev/iommu core
Date:   Sun, 19 Sep 2021 14:38:29 +0800
Message-Id: <20210919063848.1476776-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210919063848.1476776-1-yi.l.liu@intel.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

/dev/iommu aims to provide a unified interface for managing I/O address
spaces for devices assigned to userspace. This patch adds the initial
framework to create a /dev/iommu node. Each open of this node returns an
iommufd. And this fd is the handle for userspace to initiate its I/O
address space management.

One open:
- We call this feature as IOMMUFD in Kconfig in this RFC. However this
  name is not clear enough to indicate its purpose to user. Back to 2010
  vfio even introduced a /dev/uiommu [1] as the predecessor of its
  container concept. Is that a better name? Appreciate opinions here.

[1] https://lore.kernel.org/kvm/4c0eb470.1HMjondO00NIvFM6%25pugs@cisco.com/

Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/iommu/Kconfig           |   1 +
 drivers/iommu/Makefile          |   1 +
 drivers/iommu/iommufd/Kconfig   |  11 ++++
 drivers/iommu/iommufd/Makefile  |   2 +
 drivers/iommu/iommufd/iommufd.c | 112 ++++++++++++++++++++++++++++++++
 5 files changed, 127 insertions(+)
 create mode 100644 drivers/iommu/iommufd/Kconfig
 create mode 100644 drivers/iommu/iommufd/Makefile
 create mode 100644 drivers/iommu/iommufd/iommufd.c

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 07b7c25cbed8..a83ce0acd09d 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -136,6 +136,7 @@ config MSM_IOMMU
 
 source "drivers/iommu/amd/Kconfig"
 source "drivers/iommu/intel/Kconfig"
+source "drivers/iommu/iommufd/Kconfig"
 
 config IRQ_REMAP
 	bool "Support for Interrupt Remapping"
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index c0fb0ba88143..719c799f23ad 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -29,3 +29,4 @@ obj-$(CONFIG_HYPERV_IOMMU) += hyperv-iommu.o
 obj-$(CONFIG_VIRTIO_IOMMU) += virtio-iommu.o
 obj-$(CONFIG_IOMMU_SVA_LIB) += iommu-sva-lib.o io-pgfault.o
 obj-$(CONFIG_SPRD_IOMMU) += sprd-iommu.o
+obj-$(CONFIG_IOMMUFD) += iommufd/
diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
new file mode 100644
index 000000000000..9fb7769a815d
--- /dev/null
+++ b/drivers/iommu/iommufd/Kconfig
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config IOMMUFD
+	tristate "I/O Address Space management framework for passthrough devices"
+	select IOMMU_API
+	default n
+	help
+	  provides unified I/O address space management framework for
+	  isolating untrusted DMAs via devices which are passed through
+	  to userspace drivers.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
new file mode 100644
index 000000000000..54381a01d003
--- /dev/null
+++ b/drivers/iommu/iommufd/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_IOMMUFD) += iommufd.o
diff --git a/drivers/iommu/iommufd/iommufd.c b/drivers/iommu/iommufd/iommufd.c
new file mode 100644
index 000000000000..710b7e62988b
--- /dev/null
+++ b/drivers/iommu/iommufd/iommufd.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * I/O Address Space Management for passthrough devices
+ *
+ * Copyright (C) 2021 Intel Corporation
+ *
+ * Author: Liu Yi L <yi.l.liu@intel.com>
+ */
+
+#define pr_fmt(fmt)    "iommufd: " fmt
+
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/miscdevice.h>
+#include <linux/mutex.h>
+#include <linux/iommu.h>
+
+/* Per iommufd */
+struct iommufd_ctx {
+	refcount_t refs;
+};
+
+static int iommufd_fops_open(struct inode *inode, struct file *filep)
+{
+	struct iommufd_ctx *ictx;
+	int ret = 0;
+
+	ictx = kzalloc(sizeof(*ictx), GFP_KERNEL);
+	if (!ictx)
+		return -ENOMEM;
+
+	refcount_set(&ictx->refs, 1);
+	filep->private_data = ictx;
+
+	return ret;
+}
+
+static void iommufd_ctx_put(struct iommufd_ctx *ictx)
+{
+	if (refcount_dec_and_test(&ictx->refs))
+		kfree(ictx);
+}
+
+static int iommufd_fops_release(struct inode *inode, struct file *filep)
+{
+	struct iommufd_ctx *ictx = filep->private_data;
+
+	filep->private_data = NULL;
+
+	iommufd_ctx_put(ictx);
+
+	return 0;
+}
+
+static long iommufd_fops_unl_ioctl(struct file *filep,
+				   unsigned int cmd, unsigned long arg)
+{
+	struct iommufd_ctx *ictx = filep->private_data;
+	long ret = -EINVAL;
+
+	if (!ictx)
+		return ret;
+
+	switch (cmd) {
+	default:
+		pr_err_ratelimited("unsupported cmd %u\n", cmd);
+		break;
+	}
+	return ret;
+}
+
+static const struct file_operations iommufd_fops = {
+	.owner		= THIS_MODULE,
+	.open		= iommufd_fops_open,
+	.release	= iommufd_fops_release,
+	.unlocked_ioctl	= iommufd_fops_unl_ioctl,
+};
+
+static struct miscdevice iommu_misc_dev = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "iommu",
+	.fops = &iommufd_fops,
+	.nodename = "iommu",
+	.mode = 0666,
+};
+
+static int __init iommufd_init(void)
+{
+	int ret;
+
+	ret = misc_register(&iommu_misc_dev);
+	if (ret) {
+		pr_err("failed to register misc device\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static void __exit iommufd_exit(void)
+{
+	misc_deregister(&iommu_misc_dev);
+}
+
+module_init(iommufd_init);
+module_exit(iommufd_exit);
+
+MODULE_AUTHOR("Liu Yi L <yi.l.liu@intel.com>");
+MODULE_DESCRIPTION("I/O Address Space Management for passthrough devices");
+MODULE_LICENSE("GPL v2");
-- 
2.25.1

