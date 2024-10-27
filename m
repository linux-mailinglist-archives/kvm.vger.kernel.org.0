Return-Path: <kvm+bounces-29761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 624A79B1D22
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 11:09:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21A42280ED0
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 10:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F53C145B14;
	Sun, 27 Oct 2024 10:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sMqLDEwf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E4B13D8A4
	for <kvm@vger.kernel.org>; Sun, 27 Oct 2024 10:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730023753; cv=fail; b=twwXyccTyQctCzfnH5p+T2NwZcgA7ctuiLR+bKVDc84/hSPCrWTWNjXWAN4jIWEBLfQAWwFcgxvyDvJO5Z2zcsirg+o+c9VGF/3dE5GZ2JwbarHQNwzgbwRiN5cx/sNw5IN8cWQM6TBACNcGYoSE67pVy8H8wtYsopUHmmhXkbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730023753; c=relaxed/simple;
	bh=AizV0GEcTnQ4JaV6R/oobrDoPtCdA/eY4MuE0Ttjo90=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U6UDkS/50Klosf20yTwDEICvKNtILQ9u3laeQVfTkX2wFvJdUrN+dKY6dI+yZP0NQP2c+My0GlRCIzArMqyIY+pJ/L97VNe5ZniPWqv2N0SlNcs1rSrdifULFy07nyD58XWxRbHzsXWe3WL+gBMLTNB/Qjw5KI4SMZhTsWLBWsM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sMqLDEwf; arc=fail smtp.client-ip=40.107.223.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lyHM4YmVBF/McJkFa7zWejkgNz5Zr8EEFoMF2lqi/tA1TXSzixhmgnA2aK2AVogx/xQ7SYoDWfVItG1Dt75jjVllFcJJ4e87BOjEYA0vdXJz/dxvNz8bEUGnMMVAwcoPWtO4TlZlOjCHZ061Pbb9kCuQ6W7RvUlF9FopKlrdl/+8gRe6xzETinn0DH+ChFgmUF5zS/+XrPWUq4WNOi7bYXADtXodElFx2MHoc+RYSYdLgg5N9oFIjy3bFYaqHH1nFgFjBmm02LWDoQhayrCSj/u0H72vmwNl9cEvluORb2zM0SGn4/1dy5Zez0QCp2+kpbDRP+QWtzYtWqeQiBul+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E0iLKvPOWi9CWdqpZv8gzB5sMzFhrCBGjIDtTO3hlKw=;
 b=Vvtr883l06RGS5fE6a0l4byw3EFYTbbb9p+kQ5jqrgI1uM6mPTkO30Cb7/r2MfZZvYFxY/kPqzQiPy8ASYHikg4De4eD9qXx5PKmFwIHrpalJuLkhWAKyeheDgaSfxctGi+vYijVDPB0oVioPZNWdU2BsR9Vxk8ItY7CN7zMPOlfICIVwc49nZWRCMvjV2j1IFxYMp1prDPjeV9jOncJt2nXPeNeMn2ZiY6o+FIRk4R5vUsqAnWe2jOb99GUgQxvsETUza3ff4r3BcM5YLUWjYkWS/6EVj26fAegpXBhw/Z8JYwsgY586swJEw+WWYCGAQGe9760oxQYFEgX7pV/hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E0iLKvPOWi9CWdqpZv8gzB5sMzFhrCBGjIDtTO3hlKw=;
 b=sMqLDEwfVyTj+X56maBLbN15W+GbJjwrowbx212vtwIJtFdIJtN6YQkCeuhBhKieR4BpCDSYzR1D0KcAbhX1NwIL//OzlFVGD7R5+lFynLCIMm7TzBQO34fIgUEsPkLSPCBReYBNyC8ySvqn0bmi8JtivZsFdUHnwH9hd8IlemNCF0KUDDsyRWdHpFr3xw3A3TLa3n6Naxkt8lN8SZxJDv1wBgfxmteTbaQxTT+3v0sdVwb47SLAnSGXFQvtfGZ08qWsWzdCvKiaeAbbYUQ/+oihkdHcI/7zHP5zGFJAen5zwny8eaJikhKQ5/J9o9ayYNfXQ9m5GBfRRnuGITVeog==
Received: from MN2PR08CA0029.namprd08.prod.outlook.com (2603:10b6:208:239::34)
 by LV8PR12MB9112.namprd12.prod.outlook.com (2603:10b6:408:184::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.23; Sun, 27 Oct
 2024 10:09:05 +0000
Received: from BN2PEPF000055DE.namprd21.prod.outlook.com
 (2603:10b6:208:239:cafe::82) by MN2PR08CA0029.outlook.office365.com
 (2603:10b6:208:239::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25 via Frontend
 Transport; Sun, 27 Oct 2024 10:09:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF000055DE.mail.protection.outlook.com (10.167.245.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.0 via Frontend Transport; Sun, 27 Oct 2024 10:09:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 27 Oct
 2024 03:08:46 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 27 Oct
 2024 03:08:46 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Sun, 27 Oct
 2024 03:08:42 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH vfio 7/7] vfio/virtio: Enable live migration once VIRTIO_PCI was configured
Date: Sun, 27 Oct 2024 12:07:51 +0200
Message-ID: <20241027100751.219214-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20241027100751.219214-1-yishaih@nvidia.com>
References: <20241027100751.219214-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DE:EE_|LV8PR12MB9112:EE_
X-MS-Office365-Filtering-Correlation-Id: b52cb3c4-541a-4ac5-8a6b-08dcf66f6369
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9akOwKSyrhtCZ7Y80yFVRnuI64ESIHaLNz0qGuz2sXToZOJNBEdlrE8qTrnT?=
 =?us-ascii?Q?nBfa9LzAZEmb9bAMPWE6B1k4zh0Gj6w1kjXKgyBtNtQZpMZc013HagcsTL8b?=
 =?us-ascii?Q?R8Xiby4K8qEFw7gdL+OST/hjfYusE+sdv97cJaEOmeSSmosmAG2RZyjh6P69?=
 =?us-ascii?Q?a+ZW3O0ZxS715wkdKI1xRTyWD/pK1YrriRV+z6efkshGGaZmHurW9eIkGnkh?=
 =?us-ascii?Q?n5XMRYI3he8CMsNoIHkOT5IdNahX6ywH0vqwNR+wiXuaVyjOdYBrFfVSCsMH?=
 =?us-ascii?Q?o4j5sHcqBrXX1WLkeLCVKIB2X/q81YkzMX2WzOxoPjPgh4piFfHUhhwB+jKX?=
 =?us-ascii?Q?PZBXaFhyyjMnPdUisXcPKe2nBv42wSqCfg7unfHmEG6zlp/i4IkNxRS8gecX?=
 =?us-ascii?Q?65w5tCwo4lZVZwtt8uY5DWoy/UHaMyeM8blfTp62lOKhy5Klbs84GheQr0wI?=
 =?us-ascii?Q?PSSi/ekzl/GmY7EJ0cCbjGeYIQ9Jw9WvcneqMi5MHnESoJ1BE0asSuWYDriY?=
 =?us-ascii?Q?uUkntAhki+PQ4eGTfXbcCxF0vzCQj6RnqCxI3091B2SqZwETqCuwEbA+MLkp?=
 =?us-ascii?Q?s6PF2O3+qgWMBGRPTJ9XEPkpu4vLeM1KjN4BbwelcQf30e1dpFqG7SkDTsL0?=
 =?us-ascii?Q?KTHWXMS87AyegUKEJV5nppTF+VWipqV3Wm5HMYMVZ80IjFhs9ChBYVSODGhF?=
 =?us-ascii?Q?fE3OJsHbke0RtphbjE63eoIhzRsmAMfFrCZo+EbKBIkHJBwKHAUKHpOLkG4M?=
 =?us-ascii?Q?/rMY/d6lj/M1PVXGWabKbupMQQjR4hP1kBSlx+ELdwkxCN0iodr/VQeGvfxV?=
 =?us-ascii?Q?OpRvTz28vx9Ng33m34ZC02VHfLu8qrMeNx1PDN+vcvwnDdb0+KFT5umrK8WU?=
 =?us-ascii?Q?LVWMllY/LWCtWqIASE7eLzswmI2gc57uav3JyK7YhQGTIwjUtU1Q3AAEaxTz?=
 =?us-ascii?Q?kC66Z89uUJNrwxKjF15A0l+wjbkjzvy+SscebAMkH1kfdLEyqEY1pp+tXmPk?=
 =?us-ascii?Q?RJ202ByivdTlIEMzLqK2u2iFfD3qNRPVaNaYw0SwhWqDqrf0337kECVCgtKO?=
 =?us-ascii?Q?/elmKnwUM/9thTb3JpoBu7XZcRsm94N+2iGWdNZucQ+1QCPxgSFfFCVc6NPw?=
 =?us-ascii?Q?yNcOxfXEYuXr76T3Ye17nx9sA+cF8ghmVhslwIMn55OjO8dSqq7MSRtBz3by?=
 =?us-ascii?Q?I+MMqSIY4uRxFeCYz4b6+CprIIzxNLqrLDNExTNAqaLpYKnNEg07vhh62QCk?=
 =?us-ascii?Q?KYLQNGoQaBB1XKghdGObzj662KPBJ937oXFnJ9qKVylWoe1v2KhTKcToe83T?=
 =?us-ascii?Q?IvlkcJQzRSTwmlKW2jv3uJgtTjfARpadIc9WVNvEf0zmDDXyFfin8e3v6Mei?=
 =?us-ascii?Q?go3Wt3rLsrKKS6FBILVyIulCdROaQIQ1MCleI5JzBQSFys1rgA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2024 10:09:04.8025
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b52cb3c4-541a-4ac5-8a6b-08dcf66f6369
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DE.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9112

Now that the driver supports live migration, only the legacy IO
functionality depends on config VIRTIO_PCI_ADMIN_LEGACY.

Move the legacy IO into a separate file to be compiled only once
VIRTIO_PCI_ADMIN_LEGACY was configured and let the live migration
depends only on VIRTIO_PCI.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/virtio/Kconfig     |   4 +-
 drivers/vfio/pci/virtio/Makefile    |   1 +
 drivers/vfio/pci/virtio/common.h    |  19 ++
 drivers/vfio/pci/virtio/legacy_io.c | 420 ++++++++++++++++++++++++++++
 drivers/vfio/pci/virtio/main.c      | 406 ++-------------------------
 5 files changed, 462 insertions(+), 388 deletions(-)
 create mode 100644 drivers/vfio/pci/virtio/legacy_io.c

diff --git a/drivers/vfio/pci/virtio/Kconfig b/drivers/vfio/pci/virtio/Kconfig
index bd80eca4a196..af1dd9e84a5c 100644
--- a/drivers/vfio/pci/virtio/Kconfig
+++ b/drivers/vfio/pci/virtio/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config VIRTIO_VFIO_PCI
         tristate "VFIO support for VIRTIO NET PCI devices"
-        depends on VIRTIO_PCI && VIRTIO_PCI_ADMIN_LEGACY
+        depends on VIRTIO_PCI
         select VFIO_PCI_CORE
         help
           This provides support for exposing VIRTIO NET VF devices which support
@@ -11,5 +11,7 @@ config VIRTIO_VFIO_PCI
           As of that this driver emulates I/O BAR in software to let a VF be
           seen as a transitional device by its users and let it work with
           a legacy driver.
+          In addition, it provides migration support for VIRTIO NET VF devices
+          using the VFIO framework.
 
           If you don't know what to do here, say N.
diff --git a/drivers/vfio/pci/virtio/Makefile b/drivers/vfio/pci/virtio/Makefile
index bf0ccde6a91a..0032e6db4636 100644
--- a/drivers/vfio/pci/virtio/Makefile
+++ b/drivers/vfio/pci/virtio/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio-vfio-pci.o
 virtio-vfio-pci-y := main.o migrate.o
+virtio-vfio-pci-$(CONFIG_VIRTIO_PCI_ADMIN_LEGACY) += legacy_io.o
diff --git a/drivers/vfio/pci/virtio/common.h b/drivers/vfio/pci/virtio/common.h
index 37796e1d70bc..b9dac49dbc72 100644
--- a/drivers/vfio/pci/virtio/common.h
+++ b/drivers/vfio/pci/virtio/common.h
@@ -77,6 +77,7 @@ struct virtiovf_migration_file {
 
 struct virtiovf_pci_core_device {
 	struct vfio_pci_core_device core_device;
+#ifdef CONFIG_VIRTIO_PCI_ADMIN_LEGACY
 	u8 *bar0_virtual_buf;
 	/* synchronize access to the virtual buf */
 	struct mutex bar_mutex;
@@ -86,6 +87,7 @@ struct virtiovf_pci_core_device {
 	__le16 pci_cmd;
 	u8 bar0_virtual_buf_size;
 	u8 notify_bar;
+#endif
 
 	/* LM related */
 	u8 migrate_cap:1;
@@ -105,4 +107,21 @@ void virtiovf_open_migration(struct virtiovf_pci_core_device *virtvdev);
 void virtiovf_close_migration(struct virtiovf_pci_core_device *virtvdev);
 void virtiovf_migration_reset_done(struct pci_dev *pdev);
 
+#ifdef CONFIG_VIRTIO_PCI_ADMIN_LEGACY
+int virtiovf_open_legacy_io(struct virtiovf_pci_core_device *virtvdev);
+long virtiovf_vfio_pci_core_ioctl(struct vfio_device *core_vdev,
+				  unsigned int cmd, unsigned long arg);
+int virtiovf_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
+				       unsigned int cmd, unsigned long arg);
+ssize_t virtiovf_pci_core_write(struct vfio_device *core_vdev,
+				const char __user *buf, size_t count,
+				loff_t *ppos);
+ssize_t virtiovf_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
+			       size_t count, loff_t *ppos);
+int virtiovf_init_legacy_io(struct virtiovf_pci_core_device *virtvdev,
+			    bool *sup_legacy_io);
+void virtiovf_release_legacy_io(struct virtiovf_pci_core_device *virtvdev);
+void virtiovf_legacy_io_reset_done(struct pci_dev *pdev);
+#endif
+
 #endif /* VIRTIO_VFIO_COMMON_H */
diff --git a/drivers/vfio/pci/virtio/legacy_io.c b/drivers/vfio/pci/virtio/legacy_io.c
new file mode 100644
index 000000000000..52c7515ff020
--- /dev/null
+++ b/drivers/vfio/pci/virtio/legacy_io.c
@@ -0,0 +1,420 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/pci.h>
+#include <linux/pm_runtime.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/vfio.h>
+#include <linux/vfio_pci_core.h>
+#include <linux/virtio_pci.h>
+#include <linux/virtio_net.h>
+#include <linux/virtio_pci_admin.h>
+
+#include "common.h"
+
+static int
+virtiovf_issue_legacy_rw_cmd(struct virtiovf_pci_core_device *virtvdev,
+			     loff_t pos, char __user *buf,
+			     size_t count, bool read)
+{
+	bool msix_enabled =
+		(virtvdev->core_device.irq_type == VFIO_PCI_MSIX_IRQ_INDEX);
+	struct pci_dev *pdev = virtvdev->core_device.pdev;
+	u8 *bar0_buf = virtvdev->bar0_virtual_buf;
+	bool common;
+	u8 offset;
+	int ret;
+
+	common = pos < VIRTIO_PCI_CONFIG_OFF(msix_enabled);
+	/* offset within the relevant configuration area */
+	offset = common ? pos : pos - VIRTIO_PCI_CONFIG_OFF(msix_enabled);
+	mutex_lock(&virtvdev->bar_mutex);
+	if (read) {
+		if (common)
+			ret = virtio_pci_admin_legacy_common_io_read(pdev, offset,
+					count, bar0_buf + pos);
+		else
+			ret = virtio_pci_admin_legacy_device_io_read(pdev, offset,
+					count, bar0_buf + pos);
+		if (ret)
+			goto out;
+		if (copy_to_user(buf, bar0_buf + pos, count))
+			ret = -EFAULT;
+	} else {
+		if (copy_from_user(bar0_buf + pos, buf, count)) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		if (common)
+			ret = virtio_pci_admin_legacy_common_io_write(pdev, offset,
+					count, bar0_buf + pos);
+		else
+			ret = virtio_pci_admin_legacy_device_io_write(pdev, offset,
+					count, bar0_buf + pos);
+	}
+out:
+	mutex_unlock(&virtvdev->bar_mutex);
+	return ret;
+}
+
+static int
+virtiovf_pci_bar0_rw(struct virtiovf_pci_core_device *virtvdev,
+		     loff_t pos, char __user *buf,
+		     size_t count, bool read)
+{
+	struct vfio_pci_core_device *core_device = &virtvdev->core_device;
+	struct pci_dev *pdev = core_device->pdev;
+	u16 queue_notify;
+	int ret;
+
+	if (!(le16_to_cpu(virtvdev->pci_cmd) & PCI_COMMAND_IO))
+		return -EIO;
+
+	if (pos + count > virtvdev->bar0_virtual_buf_size)
+		return -EINVAL;
+
+	ret = pm_runtime_resume_and_get(&pdev->dev);
+	if (ret) {
+		pci_info_ratelimited(pdev, "runtime resume failed %d\n", ret);
+		return -EIO;
+	}
+
+	switch (pos) {
+	case VIRTIO_PCI_QUEUE_NOTIFY:
+		if (count != sizeof(queue_notify)) {
+			ret = -EINVAL;
+			goto end;
+		}
+		if (read) {
+			ret = vfio_pci_core_ioread16(core_device, true, &queue_notify,
+						     virtvdev->notify_addr);
+			if (ret)
+				goto end;
+			if (copy_to_user(buf, &queue_notify,
+					 sizeof(queue_notify))) {
+				ret = -EFAULT;
+				goto end;
+			}
+		} else {
+			if (copy_from_user(&queue_notify, buf, count)) {
+				ret = -EFAULT;
+				goto end;
+			}
+			ret = vfio_pci_core_iowrite16(core_device, true, queue_notify,
+						      virtvdev->notify_addr);
+		}
+		break;
+	default:
+		ret = virtiovf_issue_legacy_rw_cmd(virtvdev, pos, buf, count,
+						   read);
+	}
+
+end:
+	pm_runtime_put(&pdev->dev);
+	return ret ? ret : count;
+}
+
+static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
+					char __user *buf, size_t count,
+					loff_t *ppos)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	size_t register_offset;
+	loff_t copy_offset;
+	size_t copy_count;
+	__le32 val32;
+	__le16 val16;
+	u8 val8;
+	int ret;
+
+	ret = vfio_pci_core_read(core_vdev, buf, count, ppos);
+	if (ret < 0)
+		return ret;
+
+	if (vfio_pci_core_range_intersect_range(pos, count, PCI_DEVICE_ID,
+						sizeof(val16), &copy_offset,
+						&copy_count, &register_offset)) {
+		val16 = cpu_to_le16(VIRTIO_TRANS_ID_NET);
+		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset, copy_count))
+			return -EFAULT;
+	}
+
+	if ((le16_to_cpu(virtvdev->pci_cmd) & PCI_COMMAND_IO) &&
+	    vfio_pci_core_range_intersect_range(pos, count, PCI_COMMAND,
+						sizeof(val16), &copy_offset,
+						&copy_count, &register_offset)) {
+		if (copy_from_user((void *)&val16 + register_offset, buf + copy_offset,
+				   copy_count))
+			return -EFAULT;
+		val16 |= cpu_to_le16(PCI_COMMAND_IO);
+		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
+				 copy_count))
+			return -EFAULT;
+	}
+
+	if (vfio_pci_core_range_intersect_range(pos, count, PCI_REVISION_ID,
+						sizeof(val8), &copy_offset,
+						&copy_count, &register_offset)) {
+		/* Transional needs to have revision 0 */
+		val8 = 0;
+		if (copy_to_user(buf + copy_offset, &val8, copy_count))
+			return -EFAULT;
+	}
+
+	if (vfio_pci_core_range_intersect_range(pos, count, PCI_BASE_ADDRESS_0,
+						sizeof(val32), &copy_offset,
+						&copy_count, &register_offset)) {
+		u32 bar_mask = ~(virtvdev->bar0_virtual_buf_size - 1);
+		u32 pci_base_addr_0 = le32_to_cpu(virtvdev->pci_base_addr_0);
+
+		val32 = cpu_to_le32((pci_base_addr_0 & bar_mask) | PCI_BASE_ADDRESS_SPACE_IO);
+		if (copy_to_user(buf + copy_offset, (void *)&val32 + register_offset, copy_count))
+			return -EFAULT;
+	}
+
+	if (vfio_pci_core_range_intersect_range(pos, count, PCI_SUBSYSTEM_ID,
+						sizeof(val16), &copy_offset,
+						&copy_count, &register_offset)) {
+		/*
+		 * Transitional devices use the PCI subsystem device id as
+		 * virtio device id, same as legacy driver always did.
+		 */
+		val16 = cpu_to_le16(VIRTIO_ID_NET);
+		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
+				 copy_count))
+			return -EFAULT;
+	}
+
+	if (vfio_pci_core_range_intersect_range(pos, count, PCI_SUBSYSTEM_VENDOR_ID,
+						sizeof(val16), &copy_offset,
+						&copy_count, &register_offset)) {
+		val16 = cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET);
+		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
+				 copy_count))
+			return -EFAULT;
+	}
+
+	return count;
+}
+
+ssize_t virtiovf_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
+			       size_t count, loff_t *ppos)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+
+	if (!count)
+		return 0;
+
+	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
+		return virtiovf_pci_read_config(core_vdev, buf, count, ppos);
+
+	if (index == VFIO_PCI_BAR0_REGION_INDEX)
+		return virtiovf_pci_bar0_rw(virtvdev, pos, buf, count, true);
+
+	return vfio_pci_core_read(core_vdev, buf, count, ppos);
+}
+
+static ssize_t virtiovf_pci_write_config(struct vfio_device *core_vdev,
+					 const char __user *buf, size_t count,
+					 loff_t *ppos)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	size_t register_offset;
+	loff_t copy_offset;
+	size_t copy_count;
+
+	if (vfio_pci_core_range_intersect_range(pos, count, PCI_COMMAND,
+						sizeof(virtvdev->pci_cmd),
+						&copy_offset, &copy_count,
+						&register_offset)) {
+		if (copy_from_user((void *)&virtvdev->pci_cmd + register_offset,
+				   buf + copy_offset,
+				   copy_count))
+			return -EFAULT;
+	}
+
+	if (vfio_pci_core_range_intersect_range(pos, count, PCI_BASE_ADDRESS_0,
+						sizeof(virtvdev->pci_base_addr_0),
+						&copy_offset, &copy_count,
+						&register_offset)) {
+		if (copy_from_user((void *)&virtvdev->pci_base_addr_0 + register_offset,
+				   buf + copy_offset,
+				   copy_count))
+			return -EFAULT;
+	}
+
+	return vfio_pci_core_write(core_vdev, buf, count, ppos);
+}
+
+ssize_t virtiovf_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+
+	if (!count)
+		return 0;
+
+	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
+		return virtiovf_pci_write_config(core_vdev, buf, count, ppos);
+
+	if (index == VFIO_PCI_BAR0_REGION_INDEX)
+		return virtiovf_pci_bar0_rw(virtvdev, pos, (char __user *)buf, count, false);
+
+	return vfio_pci_core_write(core_vdev, buf, count, ppos);
+}
+
+int virtiovf_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
+				       unsigned int cmd, unsigned long arg)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
+	void __user *uarg = (void __user *)arg;
+	struct vfio_region_info info = {};
+
+	if (copy_from_user(&info, uarg, minsz))
+		return -EFAULT;
+
+	if (info.argsz < minsz)
+		return -EINVAL;
+
+	switch (info.index) {
+	case VFIO_PCI_BAR0_REGION_INDEX:
+		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+		info.size = virtvdev->bar0_virtual_buf_size;
+		info.flags = VFIO_REGION_INFO_FLAG_READ |
+			     VFIO_REGION_INFO_FLAG_WRITE;
+		return copy_to_user(uarg, &info, minsz) ? -EFAULT : 0;
+	default:
+		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
+	}
+}
+
+long virtiovf_vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
+				  unsigned long arg)
+{
+	switch (cmd) {
+	case VFIO_DEVICE_GET_REGION_INFO:
+		return virtiovf_pci_ioctl_get_region_info(core_vdev, cmd, arg);
+	default:
+		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
+	}
+}
+
+static int virtiovf_set_notify_addr(struct virtiovf_pci_core_device *virtvdev)
+{
+	struct vfio_pci_core_device *core_device = &virtvdev->core_device;
+	int ret;
+
+	/*
+	 * Setup the BAR where the 'notify' exists to be used by vfio as well
+	 * This will let us mmap it only once and use it when needed.
+	 */
+	ret = vfio_pci_core_setup_barmap(core_device,
+					 virtvdev->notify_bar);
+	if (ret)
+		return ret;
+
+	virtvdev->notify_addr = core_device->barmap[virtvdev->notify_bar] +
+			virtvdev->notify_offset;
+	return 0;
+}
+
+int virtiovf_open_legacy_io(struct virtiovf_pci_core_device *virtvdev)
+{
+	if (!virtvdev->bar0_virtual_buf)
+		return 0;
+
+	/*
+	 * Upon close_device() the vfio_pci_core_disable() is called
+	 * and will close all the previous mmaps, so it seems that the
+	 * valid life cycle for the 'notify' addr is per open/close.
+	 */
+	return virtiovf_set_notify_addr(virtvdev);
+}
+
+static int virtiovf_get_device_config_size(unsigned short device)
+{
+	/* Network card */
+	return offsetofend(struct virtio_net_config, status);
+}
+
+static int virtiovf_read_notify_info(struct virtiovf_pci_core_device *virtvdev)
+{
+	u64 offset;
+	int ret;
+	u8 bar;
+
+	ret = virtio_pci_admin_legacy_io_notify_info(virtvdev->core_device.pdev,
+				VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_OWNER_MEM,
+				&bar, &offset);
+	if (ret)
+		return ret;
+
+	virtvdev->notify_bar = bar;
+	virtvdev->notify_offset = offset;
+	return 0;
+}
+
+static bool virtiovf_bar0_exists(struct pci_dev *pdev)
+{
+	struct resource *res = pdev->resource;
+
+	return res->flags;
+}
+
+int virtiovf_init_legacy_io(struct virtiovf_pci_core_device *virtvdev,
+			    bool *sup_legacy_io)
+{
+	struct pci_dev *pdev = virtvdev->core_device.pdev;
+	int ret;
+
+	*sup_legacy_io = virtio_pci_admin_has_legacy_io(pdev) &&
+			!virtiovf_bar0_exists(pdev);
+
+	if (!*sup_legacy_io)
+		return 0;
+
+	ret = virtiovf_read_notify_info(virtvdev);
+	if (ret)
+		return ret;
+
+	virtvdev->bar0_virtual_buf_size = VIRTIO_PCI_CONFIG_OFF(true) +
+				virtiovf_get_device_config_size(pdev->device);
+	BUILD_BUG_ON(!is_power_of_2(virtvdev->bar0_virtual_buf_size));
+	virtvdev->bar0_virtual_buf = kzalloc(virtvdev->bar0_virtual_buf_size,
+					     GFP_KERNEL);
+	if (!virtvdev->bar0_virtual_buf)
+		return -ENOMEM;
+	mutex_init(&virtvdev->bar_mutex);
+	return 0;
+}
+
+void virtiovf_release_legacy_io(struct virtiovf_pci_core_device *virtvdev)
+{
+	kfree(virtvdev->bar0_virtual_buf);
+}
+
+void virtiovf_legacy_io_reset_done(struct pci_dev *pdev)
+{
+	struct virtiovf_pci_core_device *virtvdev = dev_get_drvdata(&pdev->dev);
+
+	virtvdev->pci_cmd = 0;
+}
diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
index e2cdf2d48200..1015f93fb0cc 100644
--- a/drivers/vfio/pci/virtio/main.c
+++ b/drivers/vfio/pci/virtio/main.c
@@ -20,330 +20,6 @@
 
 static int virtiovf_pci_init_device(struct vfio_device *core_vdev);
 
-static int
-virtiovf_issue_legacy_rw_cmd(struct virtiovf_pci_core_device *virtvdev,
-			     loff_t pos, char __user *buf,
-			     size_t count, bool read)
-{
-	bool msix_enabled =
-		(virtvdev->core_device.irq_type == VFIO_PCI_MSIX_IRQ_INDEX);
-	struct pci_dev *pdev = virtvdev->core_device.pdev;
-	u8 *bar0_buf = virtvdev->bar0_virtual_buf;
-	bool common;
-	u8 offset;
-	int ret;
-
-	common = pos < VIRTIO_PCI_CONFIG_OFF(msix_enabled);
-	/* offset within the relevant configuration area */
-	offset = common ? pos : pos - VIRTIO_PCI_CONFIG_OFF(msix_enabled);
-	mutex_lock(&virtvdev->bar_mutex);
-	if (read) {
-		if (common)
-			ret = virtio_pci_admin_legacy_common_io_read(pdev, offset,
-					count, bar0_buf + pos);
-		else
-			ret = virtio_pci_admin_legacy_device_io_read(pdev, offset,
-					count, bar0_buf + pos);
-		if (ret)
-			goto out;
-		if (copy_to_user(buf, bar0_buf + pos, count))
-			ret = -EFAULT;
-	} else {
-		if (copy_from_user(bar0_buf + pos, buf, count)) {
-			ret = -EFAULT;
-			goto out;
-		}
-
-		if (common)
-			ret = virtio_pci_admin_legacy_common_io_write(pdev, offset,
-					count, bar0_buf + pos);
-		else
-			ret = virtio_pci_admin_legacy_device_io_write(pdev, offset,
-					count, bar0_buf + pos);
-	}
-out:
-	mutex_unlock(&virtvdev->bar_mutex);
-	return ret;
-}
-
-static int
-virtiovf_pci_bar0_rw(struct virtiovf_pci_core_device *virtvdev,
-		     loff_t pos, char __user *buf,
-		     size_t count, bool read)
-{
-	struct vfio_pci_core_device *core_device = &virtvdev->core_device;
-	struct pci_dev *pdev = core_device->pdev;
-	u16 queue_notify;
-	int ret;
-
-	if (!(le16_to_cpu(virtvdev->pci_cmd) & PCI_COMMAND_IO))
-		return -EIO;
-
-	if (pos + count > virtvdev->bar0_virtual_buf_size)
-		return -EINVAL;
-
-	ret = pm_runtime_resume_and_get(&pdev->dev);
-	if (ret) {
-		pci_info_ratelimited(pdev, "runtime resume failed %d\n", ret);
-		return -EIO;
-	}
-
-	switch (pos) {
-	case VIRTIO_PCI_QUEUE_NOTIFY:
-		if (count != sizeof(queue_notify)) {
-			ret = -EINVAL;
-			goto end;
-		}
-		if (read) {
-			ret = vfio_pci_core_ioread16(core_device, true, &queue_notify,
-						     virtvdev->notify_addr);
-			if (ret)
-				goto end;
-			if (copy_to_user(buf, &queue_notify,
-					 sizeof(queue_notify))) {
-				ret = -EFAULT;
-				goto end;
-			}
-		} else {
-			if (copy_from_user(&queue_notify, buf, count)) {
-				ret = -EFAULT;
-				goto end;
-			}
-			ret = vfio_pci_core_iowrite16(core_device, true, queue_notify,
-						      virtvdev->notify_addr);
-		}
-		break;
-	default:
-		ret = virtiovf_issue_legacy_rw_cmd(virtvdev, pos, buf, count,
-						   read);
-	}
-
-end:
-	pm_runtime_put(&pdev->dev);
-	return ret ? ret : count;
-}
-
-static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
-					char __user *buf, size_t count,
-					loff_t *ppos)
-{
-	struct virtiovf_pci_core_device *virtvdev = container_of(
-		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
-	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
-	size_t register_offset;
-	loff_t copy_offset;
-	size_t copy_count;
-	__le32 val32;
-	__le16 val16;
-	u8 val8;
-	int ret;
-
-	ret = vfio_pci_core_read(core_vdev, buf, count, ppos);
-	if (ret < 0)
-		return ret;
-
-	if (vfio_pci_core_range_intersect_range(pos, count, PCI_DEVICE_ID,
-						sizeof(val16), &copy_offset,
-						&copy_count, &register_offset)) {
-		val16 = cpu_to_le16(VIRTIO_TRANS_ID_NET);
-		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset, copy_count))
-			return -EFAULT;
-	}
-
-	if ((le16_to_cpu(virtvdev->pci_cmd) & PCI_COMMAND_IO) &&
-	    vfio_pci_core_range_intersect_range(pos, count, PCI_COMMAND,
-						sizeof(val16), &copy_offset,
-						&copy_count, &register_offset)) {
-		if (copy_from_user((void *)&val16 + register_offset, buf + copy_offset,
-				   copy_count))
-			return -EFAULT;
-		val16 |= cpu_to_le16(PCI_COMMAND_IO);
-		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
-				 copy_count))
-			return -EFAULT;
-	}
-
-	if (vfio_pci_core_range_intersect_range(pos, count, PCI_REVISION_ID,
-						sizeof(val8), &copy_offset,
-						&copy_count, &register_offset)) {
-		/* Transional needs to have revision 0 */
-		val8 = 0;
-		if (copy_to_user(buf + copy_offset, &val8, copy_count))
-			return -EFAULT;
-	}
-
-	if (vfio_pci_core_range_intersect_range(pos, count, PCI_BASE_ADDRESS_0,
-						sizeof(val32), &copy_offset,
-						&copy_count, &register_offset)) {
-		u32 bar_mask = ~(virtvdev->bar0_virtual_buf_size - 1);
-		u32 pci_base_addr_0 = le32_to_cpu(virtvdev->pci_base_addr_0);
-
-		val32 = cpu_to_le32((pci_base_addr_0 & bar_mask) | PCI_BASE_ADDRESS_SPACE_IO);
-		if (copy_to_user(buf + copy_offset, (void *)&val32 + register_offset, copy_count))
-			return -EFAULT;
-	}
-
-	if (vfio_pci_core_range_intersect_range(pos, count, PCI_SUBSYSTEM_ID,
-						sizeof(val16), &copy_offset,
-						&copy_count, &register_offset)) {
-		/*
-		 * Transitional devices use the PCI subsystem device id as
-		 * virtio device id, same as legacy driver always did.
-		 */
-		val16 = cpu_to_le16(VIRTIO_ID_NET);
-		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
-				 copy_count))
-			return -EFAULT;
-	}
-
-	if (vfio_pci_core_range_intersect_range(pos, count, PCI_SUBSYSTEM_VENDOR_ID,
-						sizeof(val16), &copy_offset,
-						&copy_count, &register_offset)) {
-		val16 = cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET);
-		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
-				 copy_count))
-			return -EFAULT;
-	}
-
-	return count;
-}
-
-static ssize_t
-virtiovf_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
-		       size_t count, loff_t *ppos)
-{
-	struct virtiovf_pci_core_device *virtvdev = container_of(
-		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
-	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
-	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
-
-	if (!count)
-		return 0;
-
-	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
-		return virtiovf_pci_read_config(core_vdev, buf, count, ppos);
-
-	if (index == VFIO_PCI_BAR0_REGION_INDEX)
-		return virtiovf_pci_bar0_rw(virtvdev, pos, buf, count, true);
-
-	return vfio_pci_core_read(core_vdev, buf, count, ppos);
-}
-
-static ssize_t virtiovf_pci_write_config(struct vfio_device *core_vdev,
-					 const char __user *buf, size_t count,
-					 loff_t *ppos)
-{
-	struct virtiovf_pci_core_device *virtvdev = container_of(
-		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
-	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
-	size_t register_offset;
-	loff_t copy_offset;
-	size_t copy_count;
-
-	if (vfio_pci_core_range_intersect_range(pos, count, PCI_COMMAND,
-						sizeof(virtvdev->pci_cmd),
-						&copy_offset, &copy_count,
-						&register_offset)) {
-		if (copy_from_user((void *)&virtvdev->pci_cmd + register_offset,
-				   buf + copy_offset,
-				   copy_count))
-			return -EFAULT;
-	}
-
-	if (vfio_pci_core_range_intersect_range(pos, count, PCI_BASE_ADDRESS_0,
-						sizeof(virtvdev->pci_base_addr_0),
-						&copy_offset, &copy_count,
-						&register_offset)) {
-		if (copy_from_user((void *)&virtvdev->pci_base_addr_0 + register_offset,
-				   buf + copy_offset,
-				   copy_count))
-			return -EFAULT;
-	}
-
-	return vfio_pci_core_write(core_vdev, buf, count, ppos);
-}
-
-static ssize_t
-virtiovf_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
-			size_t count, loff_t *ppos)
-{
-	struct virtiovf_pci_core_device *virtvdev = container_of(
-		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
-	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
-	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
-
-	if (!count)
-		return 0;
-
-	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
-		return virtiovf_pci_write_config(core_vdev, buf, count, ppos);
-
-	if (index == VFIO_PCI_BAR0_REGION_INDEX)
-		return virtiovf_pci_bar0_rw(virtvdev, pos, (char __user *)buf, count, false);
-
-	return vfio_pci_core_write(core_vdev, buf, count, ppos);
-}
-
-static int
-virtiovf_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
-				   unsigned int cmd, unsigned long arg)
-{
-	struct virtiovf_pci_core_device *virtvdev = container_of(
-		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
-	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
-	void __user *uarg = (void __user *)arg;
-	struct vfio_region_info info = {};
-
-	if (copy_from_user(&info, uarg, minsz))
-		return -EFAULT;
-
-	if (info.argsz < minsz)
-		return -EINVAL;
-
-	switch (info.index) {
-	case VFIO_PCI_BAR0_REGION_INDEX:
-		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
-		info.size = virtvdev->bar0_virtual_buf_size;
-		info.flags = VFIO_REGION_INFO_FLAG_READ |
-			     VFIO_REGION_INFO_FLAG_WRITE;
-		return copy_to_user(uarg, &info, minsz) ? -EFAULT : 0;
-	default:
-		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
-	}
-}
-
-static long
-virtiovf_vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
-			     unsigned long arg)
-{
-	switch (cmd) {
-	case VFIO_DEVICE_GET_REGION_INFO:
-		return virtiovf_pci_ioctl_get_region_info(core_vdev, cmd, arg);
-	default:
-		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
-	}
-}
-
-static int
-virtiovf_set_notify_addr(struct virtiovf_pci_core_device *virtvdev)
-{
-	struct vfio_pci_core_device *core_device = &virtvdev->core_device;
-	int ret;
-
-	/*
-	 * Setup the BAR where the 'notify' exists to be used by vfio as well
-	 * This will let us mmap it only once and use it when needed.
-	 */
-	ret = vfio_pci_core_setup_barmap(core_device,
-					 virtvdev->notify_bar);
-	if (ret)
-		return ret;
-
-	virtvdev->notify_addr = core_device->barmap[virtvdev->notify_bar] +
-			virtvdev->notify_offset;
-	return 0;
-}
-
 static int virtiovf_pci_open_device(struct vfio_device *core_vdev)
 {
 	struct virtiovf_pci_core_device *virtvdev = container_of(core_vdev,
@@ -355,18 +31,13 @@ static int virtiovf_pci_open_device(struct vfio_device *core_vdev)
 	if (ret)
 		return ret;
 
-	if (virtvdev->bar0_virtual_buf) {
-		/*
-		 * Upon close_device() the vfio_pci_core_disable() is called
-		 * and will close all the previous mmaps, so it seems that the
-		 * valid life cycle for the 'notify' addr is per open/close.
-		 */
-		ret = virtiovf_set_notify_addr(virtvdev);
-		if (ret) {
-			vfio_pci_core_disable(vdev);
-			return ret;
-		}
+#ifdef CONFIG_VIRTIO_PCI_ADMIN_LEGACY
+	ret = virtiovf_open_legacy_io(virtvdev);
+	if (ret) {
+		vfio_pci_core_disable(vdev);
+		return ret;
 	}
+#endif
 
 	virtiovf_open_migration(virtvdev);
 	vfio_pci_core_finish_enable(vdev);
@@ -382,35 +53,14 @@ static void virtiovf_pci_close_device(struct vfio_device *core_vdev)
 	vfio_pci_core_close_device(core_vdev);
 }
 
-static int virtiovf_get_device_config_size(unsigned short device)
-{
-	/* Network card */
-	return offsetofend(struct virtio_net_config, status);
-}
-
-static int virtiovf_read_notify_info(struct virtiovf_pci_core_device *virtvdev)
-{
-	u64 offset;
-	int ret;
-	u8 bar;
-
-	ret = virtio_pci_admin_legacy_io_notify_info(virtvdev->core_device.pdev,
-				VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_OWNER_MEM,
-				&bar, &offset);
-	if (ret)
-		return ret;
-
-	virtvdev->notify_bar = bar;
-	virtvdev->notify_offset = offset;
-	return 0;
-}
-
 static void virtiovf_pci_core_release_dev(struct vfio_device *core_vdev)
 {
+#ifdef CONFIG_VIRTIO_PCI_ADMIN_LEGACY
 	struct virtiovf_pci_core_device *virtvdev = container_of(core_vdev,
 			struct virtiovf_pci_core_device, core_device.vdev);
 
-	kfree(virtvdev->bar0_virtual_buf);
+	virtiovf_release_legacy_io(virtvdev);
+#endif
 	vfio_pci_core_release_dev(core_vdev);
 }
 
@@ -471,19 +121,12 @@ static const struct vfio_device_ops virtiovf_vfio_pci_ops = {
 	.detach_ioas = vfio_iommufd_physical_detach_ioas,
 };
 
-static bool virtiovf_bar0_exists(struct pci_dev *pdev)
-{
-	struct resource *res = pdev->resource;
-
-	return res->flags;
-}
-
 static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
 {
 	struct virtiovf_pci_core_device *virtvdev = container_of(core_vdev,
 			struct virtiovf_pci_core_device, core_device.vdev);
 	struct pci_dev *pdev;
-	bool sup_legacy_io;
+	bool sup_legacy_io = false;
 	bool sup_lm;
 	int ret;
 
@@ -492,8 +135,12 @@ static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
 		return ret;
 
 	pdev = virtvdev->core_device.pdev;
-	sup_legacy_io = virtio_pci_admin_has_legacy_io(pdev) &&
-				!virtiovf_bar0_exists(pdev);
+#ifdef CONFIG_VIRTIO_PCI_ADMIN_LEGACY
+	ret = virtiovf_init_legacy_io(virtvdev, &sup_legacy_io);
+	if (ret)
+		return ret;
+#endif
+
 	sup_lm = virtio_pci_admin_has_dev_parts(pdev);
 
 	/*
@@ -505,21 +152,6 @@ static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
 		return 0;
 	}
 
-	if (sup_legacy_io) {
-		ret = virtiovf_read_notify_info(virtvdev);
-		if (ret)
-			return ret;
-
-		virtvdev->bar0_virtual_buf_size = VIRTIO_PCI_CONFIG_OFF(true) +
-					virtiovf_get_device_config_size(pdev->device);
-		BUILD_BUG_ON(!is_power_of_2(virtvdev->bar0_virtual_buf_size));
-		virtvdev->bar0_virtual_buf = kzalloc(virtvdev->bar0_virtual_buf_size,
-						     GFP_KERNEL);
-		if (!virtvdev->bar0_virtual_buf)
-			return -ENOMEM;
-		mutex_init(&virtvdev->bar_mutex);
-	}
-
 	if (sup_lm)
 		virtiovf_set_migratable(virtvdev);
 
@@ -572,9 +204,9 @@ MODULE_DEVICE_TABLE(pci, virtiovf_pci_table);
 
 static void virtiovf_pci_aer_reset_done(struct pci_dev *pdev)
 {
-	struct virtiovf_pci_core_device *virtvdev = dev_get_drvdata(&pdev->dev);
-
-	virtvdev->pci_cmd = 0;
+#ifdef CONFIG_VIRTIO_PCI_ADMIN_LEGACY
+	virtiovf_legacy_io_reset_done(pdev);
+#endif
 	virtiovf_migration_reset_done(pdev);
 }
 
-- 
2.27.0


