Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086953F7677
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 15:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241527AbhHYNxP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 09:53:15 -0400
Received: from mail-bn7nam10on2073.outbound.protection.outlook.com ([40.107.92.73]:2682
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241520AbhHYNxN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 09:53:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kvEn3veYeNWKjIompB0tWh7K2e9vGB2WZIHnfzxyniTIFrgqMBBZbu5RyLtNj4bM92/OTorTCyGQQAQLjysvmJHNbnhF3ZMQ4weQv/7u0Ted8naYehH6MzblbJw0KoLAH2i4Fy2DjtEG2PisiWm0HIOxoN+i8vBfg57JjixZ1CBUCUyewPu24FdJtawE23W9uxnB0bWhyUDeyPRaz3NBsLC+dcQKvYzfytLM/hiRunbad/9DyyplNgxn/ogEVKgh0GOVFq841qsryPgXZHfAnPEvxPHW/QHzaluQ6c/J53RkcYmPHtsQFfEljFzQ0l6iLODuIGSC+QatuaZ2yoQONw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acghMo7AeJTZCvdKkOWB71Ju2N0iDpebGpBRFBII36s=;
 b=mPYwD0Oqd349HjI/d5ze86dOJSy65Ae70Ue93JoL6SHeYN/NvvTcb+TCJdSAUBghqAaWRIicmhPXticzpxjZBma/7E103c2k8TAVn8ezoNrvDBySJ6MgGNEX0O2CwimcZfkbnPoXpJW88OZON6g7iBMIs9yP8srzdTez4bhu3NgQYPQ9U3vXrIi8OqNLE0+lNHpwg55xUJEyGjutJGnrouNTcJvrL8Ysfpcgjp41Pu+3jb3KmcMNDP3jS9zTsyl7YFp0IfoWVqPym+G5g6/KNhY5eBjYOmuqaYYTNXVNjpXb84pZiEehVToCXLjnn9E7vRnWqkh/YZiINL8XgYXfaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acghMo7AeJTZCvdKkOWB71Ju2N0iDpebGpBRFBII36s=;
 b=JO4wFcVGet9uReKLklNz8IlFKhUsjLiQrW5MldxgylUgdK4eMFBjIidfxtAsKesOeUjd7AeHewZL1CHgywn8VcV/jCxEEa1RrTJXOwMaDzgrCQiEJ8KkBIWwCPe+yZ/lyuUdr36sRqbveZC05/SSo+TUuHO6C8ZQGi0UpAXm2cGWZx4jumPxN+x+P0V/y5GX/3lRB0TXCsFSDcQQWmzSylBNp0txKd8KVNZaqlZP3Fxkilkf+/W9wa9ieU4ux67+y0YTNYAVpnCeNqYEJZ5qecAIwHDzA8uQa7RxZPaMUUK4ev3G5GQP2WXJ+LAmk8xjHZA76tU/mm0ws+LxKcUb7w==
Received: from BN9PR03CA0764.namprd03.prod.outlook.com (2603:10b6:408:13a::19)
 by MN2PR12MB2990.namprd12.prod.outlook.com (2603:10b6:208:cc::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Wed, 25 Aug
 2021 13:52:24 +0000
Received: from BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13a:cafe::b9) by BN9PR03CA0764.outlook.office365.com
 (2603:10b6:408:13a::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend
 Transport; Wed, 25 Aug 2021 13:52:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT035.mail.protection.outlook.com (10.13.177.116) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Wed, 25 Aug 2021 13:52:24 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Aug
 2021 13:52:23 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Aug 2021 06:52:19 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <alex.williamson@redhat.com>, <diana.craciun@oss.nxp.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <masahiroy@kernel.org>, <michal.lkml@markovi.net>
CC:     <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <mgurtovoy@nvidia.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <leonro@nvidia.com>
Subject: [PATCH V4 06/13] vfio/pci: Split the pci_driver code out of vfio_pci_core.c
Date:   Wed, 25 Aug 2021 16:51:32 +0300
Message-ID: <20210825135139.79034-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210825135139.79034-1-yishaih@nvidia.com>
References: <20210825135139.79034-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad21aa42-655f-4f76-7524-08d967cf918a
X-MS-TrafficTypeDiagnostic: MN2PR12MB2990:
X-Microsoft-Antispam-PRVS: <MN2PR12MB29900DA7721CBBF25D391C2CC3C69@MN2PR12MB2990.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YxWT+f7MECMhiFvZX7Md14D9ixrdiaEwlTXi2cOYvhqSkOs/3gsPUTPRBW+hOUtrWyPR0nR4yhSXmEALkI1djq/Kaq/kL+mISGdAds73nBVKettkobEHgRVwQ+x+wfiwR8XaFgbo3uaG9J9NAXcbfj7PD/g4NocJwD1xc3dPB9uC4IKxchqW6N6ImkHM2uAPSL2HiBs+i5Vv7RlRiNzCP7Q8u774bllhJBa0ETDdKWK93CR9VSlQqZtctst5WtJgDbiIUXWciWVxzYvyLJyxKv9ZOFP8jMFb3lGOspBfnJWU8P+u7cqYLqtneAMv0FCouYCTDRMICxRjJ2mCKU5ncSFB6ZLaeZo1Iw2Lksh7BFGbMaKoGXnpMVmmXH2tetITuCsPK+WDWjy2T0m1hIfqHX5b9oYvGkea+8sBkDQzm3RWJJsgTSwmT8qg/yZc1sVGZQtqPKXOGCT0I6GSqyYEgkGHthVjDmHwQEwH1WtSAEJNaLrDiO5wEuFbMTWQXDt3/M6rVIsqVfDFrIrecGwq3LzymQwenulRL53fSrNadAU1DE3gmoGKHhxEa31iAsGCHDYgWc06K2qOvrh2Ig9d7zU3SgBKIAA9glpQlpCo/JHNPLFuD95Pv6ICD2zCbugW5NiBk1E4A4qwE4L2cWfMlo7GYFZ3AFTPWL3l1Ev22Tf7hf6wbS62UAh4r1SqaleC3zbdLoGdtb6FSyBxlVGJkA1UqYY9L/5xthIXSSIyzhg=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(346002)(396003)(36840700001)(46966006)(2616005)(316002)(36860700001)(36906005)(54906003)(86362001)(110136005)(6666004)(82310400003)(1076003)(4326008)(70206006)(70586007)(107886003)(426003)(336012)(356005)(30864003)(7416002)(5660300002)(8936002)(7636003)(36756003)(478600001)(83380400001)(82740400003)(47076005)(2906002)(7696005)(26005)(186003)(8676002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 13:52:24.3479
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad21aa42-655f-4f76-7524-08d967cf918a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2990
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

Split the vfio_pci driver into two logical parts, the 'struct
pci_driver' (vfio_pci.c) which implements "Generic VFIO support for any
PCI device" and a library of code (vfio_pci_core.c) that helps
implementing a struct vfio_device on top of a PCI device.

vfio_pci.ko continues to present the same interface under sysfs and this
change should have no functional impact.

Following patches will turn vfio_pci and vfio_pci_core into a separate
module.

This is a preparation for allowing another module to provide the
pci_driver and allow that module to customize how VFIO is setup, inject
its own operations, and easily extend vendor specific functionality.

At this point the vfio_pci_core still contains a lot of vfio_pci
functionality mixed into it. Following patches will move more of the large
scale items out, but another cleanup series will be needed to get
everything.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/Makefile        |   2 +-
 drivers/vfio/pci/vfio_pci.c      | 223 +++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_core.c | 271 +++++++------------------------
 drivers/vfio/pci/vfio_pci_core.h |  23 +++
 4 files changed, 304 insertions(+), 215 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci.c

diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 66a40488e967..8aa517b4b671 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-vfio-pci-y := vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
+vfio-pci-y := vfio_pci.o vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
 vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
 vfio-pci-$(CONFIG_S390) += vfio_pci_zdev.o
 
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
new file mode 100644
index 000000000000..4e31bd3001ad
--- /dev/null
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -0,0 +1,223 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved
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
+#define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
+#define DRIVER_DESC     "VFIO PCI - User Level meta-driver"
+
+static char ids[1024] __initdata;
+module_param_string(ids, ids, sizeof(ids), 0);
+MODULE_PARM_DESC(ids, "Initial PCI IDs to add to the vfio driver, format is \"vendor:device[:subvendor[:subdevice[:class[:class_mask]]]]\" and multiple comma separated entries can be specified");
+
+static bool enable_sriov;
+#ifdef CONFIG_PCI_IOV
+module_param(enable_sriov, bool, 0644);
+MODULE_PARM_DESC(enable_sriov, "Enable support for SR-IOV configuration.  Enabling SR-IOV on a PF typically requires support of the userspace PF driver, enabling VFs without such support may result in non-functional VFs or PF.");
+#endif
+
+static bool disable_denylist;
+module_param(disable_denylist, bool, 0444);
+MODULE_PARM_DESC(disable_denylist, "Disable use of device denylist. Disabling the denylist allows binding to devices with known errata that may lead to exploitable stability or security issues when accessed by untrusted users.");
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
+	pci_warn(pdev, "%04x:%04x exists in vfio-pci device denylist, driver probing disallowed.\n",
+		 pdev->vendor, pdev->device);
+
+	return true;
+}
+
+static const struct vfio_device_ops vfio_pci_ops = {
+	.name		= "vfio-pci",
+	.open_device	= vfio_pci_core_open_device,
+	.close_device	= vfio_pci_core_close_device,
+	.ioctl		= vfio_pci_core_ioctl,
+	.read		= vfio_pci_core_read,
+	.write		= vfio_pci_core_write,
+	.mmap		= vfio_pci_core_mmap,
+	.request	= vfio_pci_core_request,
+	.match		= vfio_pci_core_match,
+};
+
+static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct vfio_pci_core_device *vdev;
+	int ret;
+
+	if (vfio_pci_is_denylisted(pdev))
+		return -EINVAL;
+
+	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
+	if (!vdev)
+		return -ENOMEM;
+	vfio_pci_core_init_device(vdev, pdev, &vfio_pci_ops);
+
+	ret = vfio_pci_core_register_device(vdev);
+	if (ret)
+		goto out_free;
+	return 0;
+
+out_free:
+	vfio_pci_core_uninit_device(vdev);
+	kfree(vdev);
+	return ret;
+}
+
+static void vfio_pci_remove(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
+
+	vfio_pci_core_unregister_device(vdev);
+	vfio_pci_core_uninit_device(vdev);
+	kfree(vdev);
+}
+
+static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
+{
+	if (!enable_sriov)
+		return -ENOENT;
+
+	return vfio_pci_core_sriov_configure(pdev, nr_virtfn);
+}
+
+static struct pci_driver vfio_pci_driver = {
+	.name			= "vfio-pci",
+	.id_table		= NULL, /* only dynamic ids */
+	.probe			= vfio_pci_probe,
+	.remove			= vfio_pci_remove,
+	.sriov_configure	= vfio_pci_sriov_configure,
+	.err_handler		= &vfio_pci_core_err_handlers,
+};
+
+static void __init vfio_pci_fill_ids(void)
+{
+	char *p, *id;
+	int rc;
+
+	/* no ids passed actually */
+	if (ids[0] == '\0')
+		return;
+
+	/* add ids specified in the module parameter */
+	p = ids;
+	while ((id = strsep(&p, ","))) {
+		unsigned int vendor, device, subvendor = PCI_ANY_ID,
+			subdevice = PCI_ANY_ID, class = 0, class_mask = 0;
+		int fields;
+
+		if (!strlen(id))
+			continue;
+
+		fields = sscanf(id, "%x:%x:%x:%x:%x:%x",
+				&vendor, &device, &subvendor, &subdevice,
+				&class, &class_mask);
+
+		if (fields < 2) {
+			pr_warn("invalid id string \"%s\"\n", id);
+			continue;
+		}
+
+		rc = pci_add_dynid(&vfio_pci_driver, vendor, device,
+				   subvendor, subdevice, class, class_mask, 0);
+		if (rc)
+			pr_warn("failed to add dynamic id [%04x:%04x[%04x:%04x]] class %#08x/%08x (%d)\n",
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
+	ret = vfio_pci_core_init();
+	if (ret)
+		return ret;
+
+	/* Register and scan for devices */
+	ret = pci_register_driver(&vfio_pci_driver);
+	if (ret)
+		goto out;
+
+	vfio_pci_fill_ids();
+
+	if (disable_denylist)
+		pr_warn("device denylist disabled.\n");
+
+	return 0;
+
+out:
+	vfio_pci_core_cleanup();
+	return ret;
+}
+module_init(vfio_pci_init);
+
+static void __exit vfio_pci_cleanup(void)
+{
+	pci_unregister_driver(&vfio_pci_driver);
+	vfio_pci_core_cleanup();
+}
+module_exit(vfio_pci_cleanup);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 94f062818e0c..c0d71f72d4f1 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -8,8 +8,6 @@
  * Author: Tom Lyon, pugs@cisco.com
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/device.h>
 #include <linux/eventfd.h>
 #include <linux/file.h>
@@ -29,14 +27,6 @@
 
 #include "vfio_pci_core.h"
 
-#define DRIVER_VERSION  "0.2"
-#define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
-#define DRIVER_DESC     "VFIO PCI - User Level meta-driver"
-
-static char ids[1024] __initdata;
-module_param_string(ids, ids, sizeof(ids), 0);
-MODULE_PARM_DESC(ids, "Initial PCI IDs to add to the vfio driver, format is \"vendor:device[:subvendor[:subdevice[:class[:class_mask]]]]\" and multiple comma separated entries can be specified");
-
 static bool nointxmask;
 module_param_named(nointxmask, nointxmask, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(nointxmask,
@@ -53,16 +43,6 @@ module_param(disable_idle_d3, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(disable_idle_d3,
 		 "Disable using the PCI D3 low power state for idle, unused devices");
 
-static bool enable_sriov;
-#ifdef CONFIG_PCI_IOV
-module_param(enable_sriov, bool, 0644);
-MODULE_PARM_DESC(enable_sriov, "Enable support for SR-IOV configuration.  Enabling SR-IOV on a PF typically requires support of the userspace PF driver, enabling VFs without such support may result in non-functional VFs or PF.");
-#endif
-
-static bool disable_denylist;
-module_param(disable_denylist, bool, 0444);
-MODULE_PARM_DESC(disable_denylist, "Disable use of device denylist. Disabling the denylist allows binding to devices with known errata that may lead to exploitable stability or security issues when accessed by untrusted users.");
-
 static inline bool vfio_vga_disabled(void)
 {
 #ifdef CONFIG_VFIO_PCI_VGA
@@ -72,44 +52,6 @@ static inline bool vfio_vga_disabled(void)
 #endif
 }
 
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
-	pci_warn(pdev, "%04x:%04x exists in vfio-pci device denylist, driver probing disallowed.\n",
-		 pdev->vendor, pdev->device);
-
-	return true;
-}
-
 /*
  * Our VGA arbiter participation is limited since we don't know anything
  * about the device itself.  However, if the device is the only VGA device
@@ -495,8 +437,6 @@ static void vfio_pci_disable(struct vfio_pci_core_device *vdev)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 }
 
-static struct pci_driver vfio_pci_driver;
-
 static struct vfio_pci_core_device *get_pf_vdev(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *physfn = pci_physfn(vdev->pdev);
@@ -509,7 +449,7 @@ static struct vfio_pci_core_device *get_pf_vdev(struct vfio_pci_core_device *vde
 	if (!pf_dev)
 		return NULL;
 
-	if (pci_dev_driver(physfn) != &vfio_pci_driver) {
+	if (pci_dev_driver(physfn) != pci_dev_driver(vdev->pdev)) {
 		vfio_device_put(pf_dev);
 		return NULL;
 	}
@@ -532,7 +472,7 @@ static void vfio_pci_vf_token_user_add(struct vfio_pci_core_device *vdev, int va
 	vfio_device_put(&pf_vdev->vdev);
 }
 
-static void vfio_pci_core_close_device(struct vfio_device *core_vdev)
+void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -553,7 +493,7 @@ static void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 	mutex_unlock(&vdev->igate);
 }
 
-static int vfio_pci_core_open_device(struct vfio_device *core_vdev)
+int vfio_pci_core_open_device(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -726,8 +666,8 @@ int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
 	return 0;
 }
 
-static long vfio_pci_core_ioctl(struct vfio_device *core_vdev,
-			   unsigned int cmd, unsigned long arg)
+long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
+		unsigned long arg)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1301,8 +1241,8 @@ static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	return -EINVAL;
 }
 
-static ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
-			     size_t count, loff_t *ppos)
+ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
+		size_t count, loff_t *ppos)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1313,8 +1253,8 @@ static ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *bu
 	return vfio_pci_rw(vdev, buf, count, ppos, false);
 }
 
-static ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
-			      size_t count, loff_t *ppos)
+ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
+		size_t count, loff_t *ppos)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1532,7 +1472,7 @@ static const struct vm_operations_struct vfio_pci_mmap_ops = {
 	.fault = vfio_pci_mmap_fault,
 };
 
-static int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
+int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1603,7 +1543,7 @@ static int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_stru
 	return 0;
 }
 
-static void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count)
+void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1719,7 +1659,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 
 #define VF_TOKEN_ARG "vf_token="
 
-static int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf)
+int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1769,18 +1709,6 @@ static int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf)
 	return 1; /* Match */
 }
 
-static const struct vfio_device_ops vfio_pci_ops = {
-	.name		= "vfio-pci",
-	.open_device	= vfio_pci_core_open_device,
-	.close_device	= vfio_pci_core_close_device,
-	.ioctl		= vfio_pci_core_ioctl,
-	.read		= vfio_pci_core_read,
-	.write		= vfio_pci_core_write,
-	.mmap		= vfio_pci_core_mmap,
-	.request	= vfio_pci_core_request,
-	.match		= vfio_pci_core_match,
-};
-
 static int vfio_pci_bus_notifier(struct notifier_block *nb,
 				 unsigned long action, void *data)
 {
@@ -1795,15 +1723,16 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
 		pci_info(vdev->pdev, "Captured SR-IOV VF %s driver_override\n",
 			 pci_name(pdev));
 		pdev->driver_override = kasprintf(GFP_KERNEL, "%s",
-						  vfio_pci_ops.name);
+						  vdev->vdev.ops->name);
 	} else if (action == BUS_NOTIFY_BOUND_DRIVER &&
 		   pdev->is_virtfn && physfn == vdev->pdev) {
 		struct pci_driver *drv = pci_dev_driver(pdev);
 
-		if (drv && drv != &vfio_pci_driver)
+		if (drv && drv != pci_dev_driver(vdev->pdev))
 			pci_warn(vdev->pdev,
-				 "VF %s bound to driver %s while PF bound to vfio-pci\n",
-				 pci_name(pdev), drv->name);
+				 "VF %s bound to driver %s while PF bound to driver %s\n",
+				 pci_name(pdev), drv->name,
+				 pci_dev_driver(vdev->pdev)->name);
 	}
 
 	return 0;
@@ -1871,15 +1800,39 @@ static void vfio_pci_vga_uninit(struct vfio_pci_core_device *vdev)
 					      VGA_RSRC_LEGACY_MEM);
 }
 
-static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+void vfio_pci_core_init_device(struct vfio_pci_core_device *vdev,
+			       struct pci_dev *pdev,
+			       const struct vfio_device_ops *vfio_pci_ops)
 {
-	struct vfio_pci_core_device *vdev;
+	vfio_init_group_dev(&vdev->vdev, &pdev->dev, vfio_pci_ops);
+	vdev->pdev = pdev;
+	vdev->irq_type = VFIO_PCI_NUM_IRQS;
+	mutex_init(&vdev->igate);
+	spin_lock_init(&vdev->irqlock);
+	mutex_init(&vdev->ioeventfds_lock);
+	INIT_LIST_HEAD(&vdev->dummy_resources_list);
+	INIT_LIST_HEAD(&vdev->ioeventfds_list);
+	mutex_init(&vdev->vma_lock);
+	INIT_LIST_HEAD(&vdev->vma_list);
+	init_rwsem(&vdev->memory_lock);
+}
+
+void vfio_pci_core_uninit_device(struct vfio_pci_core_device *vdev)
+{
+	mutex_destroy(&vdev->igate);
+	mutex_destroy(&vdev->ioeventfds_lock);
+	mutex_destroy(&vdev->vma_lock);
+	vfio_uninit_group_dev(&vdev->vdev);
+	kfree(vdev->region);
+	kfree(vdev->pm_save);
+}
+
+int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
+{
+	struct pci_dev *pdev = vdev->pdev;
 	struct iommu_group *group;
 	int ret;
 
-	if (vfio_pci_is_denylisted(pdev))
-		return -EINVAL;
-
 	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
 		return -EINVAL;
 
@@ -1900,24 +1853,6 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!group)
 		return -EINVAL;
 
-	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
-	if (!vdev) {
-		ret = -ENOMEM;
-		goto out_group_put;
-	}
-
-	vfio_init_group_dev(&vdev->vdev, &pdev->dev, &vfio_pci_ops);
-	vdev->pdev = pdev;
-	vdev->irq_type = VFIO_PCI_NUM_IRQS;
-	mutex_init(&vdev->igate);
-	spin_lock_init(&vdev->irqlock);
-	mutex_init(&vdev->ioeventfds_lock);
-	INIT_LIST_HEAD(&vdev->dummy_resources_list);
-	INIT_LIST_HEAD(&vdev->ioeventfds_list);
-	mutex_init(&vdev->vma_lock);
-	INIT_LIST_HEAD(&vdev->vma_list);
-	init_rwsem(&vdev->memory_lock);
-
 	if (pci_is_root_bus(pdev->bus)) {
 		ret = vfio_assign_device_set(&vdev->vdev, vdev);
 	} else if (!pci_probe_reset_slot(pdev->slot)) {
@@ -1931,10 +1866,10 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	if (ret)
-		goto out_uninit;
+		goto out_group_put;
 	ret = vfio_pci_vf_init(vdev);
 	if (ret)
-		goto out_uninit;
+		goto out_group_put;
 	ret = vfio_pci_vga_init(vdev);
 	if (ret)
 		goto out_vf;
@@ -1966,36 +1901,26 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		vfio_pci_set_power_state(vdev, PCI_D0);
 out_vf:
 	vfio_pci_vf_uninit(vdev);
-out_uninit:
-	vfio_uninit_group_dev(&vdev->vdev);
-	kfree(vdev->pm_save);
-	kfree(vdev);
 out_group_put:
 	vfio_iommu_group_put(group, &pdev->dev);
 	return ret;
 }
 
-static void vfio_pci_remove(struct pci_dev *pdev)
+void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 {
-	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
+	struct pci_dev *pdev = vdev->pdev;
 
 	pci_disable_sriov(pdev);
 
 	vfio_unregister_group_dev(&vdev->vdev);
 
 	vfio_pci_vf_uninit(vdev);
-	vfio_uninit_group_dev(&vdev->vdev);
 	vfio_pci_vga_uninit(vdev);
 
 	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
 
 	if (!disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D0);
-
-	mutex_destroy(&vdev->ioeventfds_lock);
-	kfree(vdev->region);
-	kfree(vdev->pm_save);
-	kfree(vdev);
 }
 
 static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
@@ -2022,16 +1947,11 @@ static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 	return PCI_ERS_RESULT_CAN_RECOVER;
 }
 
-static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
+int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 {
 	struct vfio_device *device;
 	int ret = 0;
 
-	might_sleep();
-
-	if (!enable_sriov)
-		return -ENOENT;
-
 	device = vfio_device_get_from_dev(&pdev->dev);
 	if (!device)
 		return -ENODEV;
@@ -2046,19 +1966,10 @@ static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 	return ret < 0 ? ret : nr_virtfn;
 }
 
-static const struct pci_error_handlers vfio_err_handlers = {
+const struct pci_error_handlers vfio_pci_core_err_handlers = {
 	.error_detected = vfio_pci_aer_err_detected,
 };
 
-static struct pci_driver vfio_pci_driver = {
-	.name			= "vfio-pci",
-	.id_table		= NULL, /* only dynamic ids */
-	.probe			= vfio_pci_probe,
-	.remove			= vfio_pci_remove,
-	.sriov_configure	= vfio_pci_sriov_configure,
-	.err_handler		= &vfio_err_handlers,
-};
-
 static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
 			       struct vfio_pci_group_info *groups)
 {
@@ -2239,83 +2150,15 @@ static bool vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
 	return true;
 }
 
-static void __exit vfio_pci_cleanup(void)
+/* This will become the __exit function of vfio_pci_core.ko */
+void vfio_pci_core_cleanup(void)
 {
-	pci_unregister_driver(&vfio_pci_driver);
 	vfio_pci_uninit_perm_bits();
 }
 
-static void __init vfio_pci_fill_ids(void)
+/* This will become the __init function of vfio_pci_core.ko */
+int __init vfio_pci_core_init(void)
 {
-	char *p, *id;
-	int rc;
-
-	/* no ids passed actually */
-	if (ids[0] == '\0')
-		return;
-
-	/* add ids specified in the module parameter */
-	p = ids;
-	while ((id = strsep(&p, ","))) {
-		unsigned int vendor, device, subvendor = PCI_ANY_ID,
-			subdevice = PCI_ANY_ID, class = 0, class_mask = 0;
-		int fields;
-
-		if (!strlen(id))
-			continue;
-
-		fields = sscanf(id, "%x:%x:%x:%x:%x:%x",
-				&vendor, &device, &subvendor, &subdevice,
-				&class, &class_mask);
-
-		if (fields < 2) {
-			pr_warn("invalid id string \"%s\"\n", id);
-			continue;
-		}
-
-		rc = pci_add_dynid(&vfio_pci_driver, vendor, device,
-				   subvendor, subdevice, class, class_mask, 0);
-		if (rc)
-			pr_warn("failed to add dynamic id [%04x:%04x[%04x:%04x]] class %#08x/%08x (%d)\n",
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
 	/* Allocate shared config space permission data used by all devices */
-	ret = vfio_pci_init_perm_bits();
-	if (ret)
-		return ret;
-
-	/* Register and scan for devices */
-	ret = pci_register_driver(&vfio_pci_driver);
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
-
-module_init(vfio_pci_init);
-module_exit(vfio_pci_cleanup);
-
-MODULE_VERSION(DRIVER_VERSION);
-MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR(DRIVER_AUTHOR);
-MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/vfio/pci/vfio_pci_core.h b/drivers/vfio/pci/vfio_pci_core.h
index 17ad048752b6..7dbdd4dda5c0 100644
--- a/drivers/vfio/pci/vfio_pci_core.h
+++ b/drivers/vfio/pci/vfio_pci_core.h
@@ -206,4 +206,27 @@ static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 }
 #endif
 
+/* Will be exported for vfio pci drivers usage */
+void vfio_pci_core_cleanup(void);
+int vfio_pci_core_init(void);
+void vfio_pci_core_close_device(struct vfio_device *core_vdev);
+int vfio_pci_core_open_device(struct vfio_device *core_vdev);
+void vfio_pci_core_init_device(struct vfio_pci_core_device *vdev,
+			       struct pci_dev *pdev,
+			       const struct vfio_device_ops *vfio_pci_ops);
+int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev);
+void vfio_pci_core_uninit_device(struct vfio_pci_core_device *vdev);
+void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev);
+int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn);
+extern const struct pci_error_handlers vfio_pci_core_err_handlers;
+long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
+		unsigned long arg);
+ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
+		size_t count, loff_t *ppos);
+ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
+		size_t count, loff_t *ppos);
+int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma);
+void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count);
+int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
+
 #endif /* VFIO_PCI_CORE_H */
-- 
2.18.1

