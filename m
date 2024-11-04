Return-Path: <kvm+bounces-30494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D95E9BB0FD
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 11:24:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 323BB1C2151D
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 10:24:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 472F71B21BA;
	Mon,  4 Nov 2024 10:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tHs/MU3Z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2085.outbound.protection.outlook.com [40.107.244.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77E41B21AC
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 10:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730715824; cv=fail; b=ET9T6rhdDj8/qDwyZ61VHUrKYkXbaa26tzzaTHRBbdRyX9mUpYxS9LVUIhOXRS6n5b7goml4EcCqf9HUkIDFzY54Dxnm/Vk0fub7zB0uHVcJu4M5iL3A6rJak5eyUguszQf2aRnUH4fX8Kw3ybdG7o8Bc1pLceFGoJm6q12djKk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730715824; c=relaxed/simple;
	bh=TlnquUEMaiNoA1F2n/FQWazQwx3Z4UxAsJsyoPMvwrk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aj9UIyAfuPSkZXvD5h2MCr6PdrsiE2V54yuzoMYvsIrrYQksAZCGwn4DiYzjhquisOKUVIbz3rw8hBR8l9TbSMnolmRbC8rTp7FxPF40BcNuD6hyUxsIsNVaTyEgBGSzKAn1VWME5KtgGa+HQkWUfGZgMe8zVGK5UJeGrpF1300=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tHs/MU3Z; arc=fail smtp.client-ip=40.107.244.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FBcDCczIF+V9sx7MRIHhl7wHnC0Ah1SoSX8QP9w6xEWU8R7pOq/rDx/f64Zh51a2kFWOgtX45R7oOByzUwgWobQMLzc4NrJqh2mW8gvTunQ2BHzSjmUMSmvqKMH5ct1MKpIL7zMrEBVuGOoy1EefcrnKh0rm5jb6MOoDLPJLFU4G1U8zxJhNNIMTBPsmn9OdvQXYOAkfD/+Rmqa8JmMFwu/Qaox7QGe2v+Aj8ElYsBy7B4eZA0w/ClHD/nPvH18Nyxp2Vq7PdDHdLk2aLm6VBb04pM3hkf4FCkqxm/4tkMaDVHKKZmphKoUAiZUQn1wNna/gCdXcjHZmrzYwlXfCaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hQD6fRg6+yq5z88itn92cklqXbwBrWMInpiv6fwi59A=;
 b=FJkit+x388Hr8YzIvwjCdmopFgOHxLR6sjW9n7TyRRyOaB5zSf8sNGwnR4YPdz9gxWLjEWWFBEHZ8+Xp0aKU+AXUUUFygDh2PjuyWF6gFHpbzVom3ccnummjr8l+e+UgbUQBF1wLin0c9UDYzBIj46f1NaPsCsFjTbFo6fW1c1OrNFK5/HT5u//6kdc3NzuByNH4WeCn9txyiI6SX3VfhrQRxT13qeFOtBNCUJfUpaRUNJ5AKGWeo5LutnzWhpPnhZiiI3WlFEhThVwt7n3JYfOKUZpY9+/mryok7j1r0Wi6NZ1eivUaX7qTon6Y56E6wkBf2RtPVdFwrT0aC+Z2Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQD6fRg6+yq5z88itn92cklqXbwBrWMInpiv6fwi59A=;
 b=tHs/MU3ZQ4qsQoxT+xRS1upZ3qspaDVibjacGWOKzFWwhuea4Dpvf5aab8wnF1g2qhVS6308if5ukwsrPJ1CIyVqRPzWgowO5bNJHHl1zIOFV0zfYjXmvwP/ANOL6y2nO74lk4iW3eALiKjRHjYbn4nb8WOvvQ/lnNrnpEmDxzuYaQyRKcH4wpBOu+SUepnqCnXjotP2u53ePq1ypGS+aewdsULKt39nUfn+GXpAQUSQbnDDDyBYqgSs3RGpa/fuE0wKb0pTFkWHRViYd3VRStjXPZbIYIVCe1ztKzuGmcIDtwbslMFHY1O89V0XsvjMS9Q5W9f2ae0bvec7xAcqbQ==
Received: from BN0PR03CA0044.namprd03.prod.outlook.com (2603:10b6:408:e7::19)
 by DS0PR12MB6629.namprd12.prod.outlook.com (2603:10b6:8:d3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Mon, 4 Nov
 2024 10:23:33 +0000
Received: from BL6PEPF0001AB4A.namprd04.prod.outlook.com
 (2603:10b6:408:e7:cafe::b5) by BN0PR03CA0044.outlook.office365.com
 (2603:10b6:408:e7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30 via Frontend
 Transport; Mon, 4 Nov 2024 10:23:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF0001AB4A.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Mon, 4 Nov 2024 10:23:33 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 4 Nov 2024
 02:23:28 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 4 Nov 2024 02:23:27 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Mon, 4 Nov 2024 02:23:24 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V1 vfio 7/7] vfio/virtio: Enable live migration once VIRTIO_PCI was configured
Date: Mon, 4 Nov 2024 12:21:31 +0200
Message-ID: <20241104102131.184193-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20241104102131.184193-1-yishaih@nvidia.com>
References: <20241104102131.184193-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4A:EE_|DS0PR12MB6629:EE_
X-MS-Office365-Filtering-Correlation-Id: c8e8845a-d1af-43b2-3129-08dcfcbabc86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9Y8HOQJWoWZbOv1gmV5OGW9ciUfszKjsb+T4Jzpqvuq1H7TsV2F66tSULFp/?=
 =?us-ascii?Q?Fxl+kOS8rocNr5X+AjsMx/P2NKHU/M6Rt9Kx0BWEwaWzDNpS1boqHdeq64rh?=
 =?us-ascii?Q?1xwDxm7yggJYfBzhhpVeRREgNRNq+D18yj3nv3IxxgYcsk3fz5cX1pGgY/ok?=
 =?us-ascii?Q?iGrhaeGr1ahqHzS1ajUOHLryjk3PRc7NXBltLStFWP18T+4ZyJkF7qSOUHA+?=
 =?us-ascii?Q?yYLw16TyNrZS70lEeAjjeh2ByDCnObKaAdHHzV54k6bd1+LxXqljUt3N0bdW?=
 =?us-ascii?Q?Tf/QavkQJ1ovOe9BVKrwHcYOhtVAtJks4524GiXwa506w71qudegj4NtT0fg?=
 =?us-ascii?Q?LRGlBuVyE6dlOpH7cHBzqz4EfXuuh8yslgOlKeoXUzEwijyHWgEHN1KKe3xH?=
 =?us-ascii?Q?4yi7kHs1sIv7rvo21qbp6GVDV0lhr/RwvHaQgTjndsabQA77fcFs38JzaCKy?=
 =?us-ascii?Q?3y/HL9JpjxYi3ecyjBdiMjxg8LAwA/eO19Anencl5fd5pLZEg7YcfV/mOR0s?=
 =?us-ascii?Q?0O3lQN/lq+h43X+tiSKQyai7nOD+MQ5VxyCZHHJZYlIAlk5kVCOnLE5MLF54?=
 =?us-ascii?Q?WOzT5TEs2C/2MK+L1OTyeIVnx30JBIL0Bes4m64dVw6HppiMqAkDbamX27vA?=
 =?us-ascii?Q?rpBpaW2htETeg8n4s2iyRBlSSyt8VPCqJptRbBm+clcRrojiy4Cr3+Rk68bF?=
 =?us-ascii?Q?CsROvjPh+MxqXtT5iNSGrI+6j4sDRpqWlnw7+Efa6HrnMV7wiEeQr+iBtxVi?=
 =?us-ascii?Q?b/7CDKprUnESKe8hEWxUX0Qqt0u7IWAVaA2MCPNRUQsc+lyHbbcssN/VpjOT?=
 =?us-ascii?Q?sNbQKI++7vqvFkk+hn7sCtyg9OpiAz0B3ymMl9q7TVwo8FRJsEQqmj3VS/Xy?=
 =?us-ascii?Q?zq7X5NAh2vUguX5JZyqkjUkfMZikS6zneCL6J+eOzAKiICAy7ADLare+gynV?=
 =?us-ascii?Q?kcwPnR9M5TN2v0XzV+DF8vZOEyQKXhdQzLQA1D9CPmtYiOBrN6M2IAxBlgSU?=
 =?us-ascii?Q?VBg5XtWPd1AvXfY7yHQwQ+aggRPTzli345PllAx41EQWe7eeWIFBZH6Vj8xP?=
 =?us-ascii?Q?rYvODPfgflpFDR0JYtpst5fjeQkvAZUSjQgHUConXeHFt2SbVX93vTA2lVt0?=
 =?us-ascii?Q?a6dda61S0eEtfHMEbBVrPV7RXOM5QlF/aOPtBMWyFmJgVNiJa9His2XTpCyS?=
 =?us-ascii?Q?KHicKyyhlhXvXlWsxtclE+Z7SfP6zJXhCIkxSGNpAZLcXW9oqnQTshSN1fOP?=
 =?us-ascii?Q?OZE0x62APr6vkmi6fOD6blIMMCCUcd6GEdpJAHBk26wQplDGcl4bsgtTbJGZ?=
 =?us-ascii?Q?Db1GCChqjJgXQMBf3Dg67edb6LzoIMcy5MVuH6Uy6ic27Ulios1xqBVqfGOp?=
 =?us-ascii?Q?x+SjNNAgHpUeaop9kzA0hLn6LouLm3p06r1D2Lzr63JLW5TMEQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2024 10:23:33.5232
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c8e8845a-d1af-43b2-3129-08dcfcbabc86
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6629

Now that the driver supports live migration, only the legacy IO
functionality depends on config VIRTIO_PCI_ADMIN_LEGACY.

Move the legacy IO into a separate file to be compiled only once
VIRTIO_PCI_ADMIN_LEGACY was configured and let the live migration
depends only on VIRTIO_PCI.

As part of this, modify the default driver operations (i.e.,
vfio_device_ops) to use the live migration set, and extend it to include
legacy I/O operations if they are compiled and supported.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/virtio/Kconfig     |   4 +-
 drivers/vfio/pci/virtio/Makefile    |   1 +
 drivers/vfio/pci/virtio/common.h    |  19 ++
 drivers/vfio/pci/virtio/legacy_io.c | 420 ++++++++++++++++++++++++++++
 drivers/vfio/pci/virtio/main.c      | 416 ++-------------------------
 5 files changed, 469 insertions(+), 391 deletions(-)
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
index 5704603f0f9d..bca797b82f01 100644
--- a/drivers/vfio/pci/virtio/common.h
+++ b/drivers/vfio/pci/virtio/common.h
@@ -78,6 +78,7 @@ struct virtiovf_migration_file {
 
 struct virtiovf_pci_core_device {
 	struct vfio_pci_core_device core_device;
+#ifdef CONFIG_VIRTIO_PCI_ADMIN_LEGACY
 	u8 *bar0_virtual_buf;
 	/* synchronize access to the virtual buf */
 	struct mutex bar_mutex;
@@ -87,6 +88,7 @@ struct virtiovf_pci_core_device {
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
index e2cdf2d48200..01b237908e7a 100644
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
 
@@ -433,6 +83,7 @@ static const struct vfio_device_ops virtiovf_vfio_pci_lm_ops = {
 	.detach_ioas = vfio_iommufd_physical_detach_ioas,
 };
 
+#ifdef CONFIG_VIRTIO_PCI_ADMIN_LEGACY
 static const struct vfio_device_ops virtiovf_vfio_pci_tran_lm_ops = {
 	.name = "virtio-vfio-pci-trans-lm",
 	.init = virtiovf_pci_init_device,
@@ -451,6 +102,7 @@ static const struct vfio_device_ops virtiovf_vfio_pci_tran_lm_ops = {
 	.attach_ioas = vfio_iommufd_physical_attach_ioas,
 	.detach_ioas = vfio_iommufd_physical_detach_ioas,
 };
+#endif
 
 static const struct vfio_device_ops virtiovf_vfio_pci_ops = {
 	.name = "virtio-vfio-pci",
@@ -471,19 +123,12 @@ static const struct vfio_device_ops virtiovf_vfio_pci_ops = {
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
 
@@ -492,8 +137,12 @@ static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
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
@@ -505,26 +154,13 @@ static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
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
 
-	if (sup_lm && !sup_legacy_io)
-		core_vdev->ops = &virtiovf_vfio_pci_lm_ops;
+#ifdef CONFIG_VIRTIO_PCI_ADMIN_LEGACY
+	if (sup_legacy_io)
+		core_vdev->ops = &virtiovf_vfio_pci_tran_lm_ops;
+#endif
 
 	return 0;
 }
@@ -536,7 +172,7 @@ static int virtiovf_pci_probe(struct pci_dev *pdev,
 	const struct vfio_device_ops *ops;
 	int ret;
 
-	ops = (pdev->is_virtfn) ? &virtiovf_vfio_pci_tran_lm_ops :
+	ops = (pdev->is_virtfn) ? &virtiovf_vfio_pci_lm_ops :
 				  &virtiovf_vfio_pci_ops;
 
 	virtvdev = vfio_alloc_device(virtiovf_pci_core_device, core_device.vdev,
@@ -572,9 +208,9 @@ MODULE_DEVICE_TABLE(pci, virtiovf_pci_table);
 
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


