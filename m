Return-Path: <kvm+bounces-31734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D5FDF9C6E63
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 12:57:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92C7D281B7A
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 11:57:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7460205AD3;
	Wed, 13 Nov 2024 11:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sb+XJfW4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEEB200C94
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 11:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731498810; cv=fail; b=HfoVCa/OcW2hTakD1OWNm9jYtg+hKd0f1TAXi2456ckhcwjJcAYBfAzkDrL3lHwg8WayKSMEPBJpyPEzp650ecvAfcTn/+0JWGLTYhwY1Za1OSwUBs9W4NGzGUOFI5IagQZQjPf2HJqSEMGC8W8ui5MiytMzWUZO6+oMefcoR3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731498810; c=relaxed/simple;
	bh=xbi/rAN564yv73rDVjPnGYviuv/7tzCL2povQWhBOqI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gow8O2fJx3xut2fm90DzQbyFwR6ckHHVSJ9AF2metpIzyt2suTdDXx/VTOiwNePN/5epDEBcif5GQvB3f1l/XkWxXJgAqocQdw4R/Fh7ggrwao9zSJoxC7b5uONvCV8KG01EOraq59XYSuiTjXWZekqvWKdp4Ui+MsMbQ+DfNYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sb+XJfW4; arc=fail smtp.client-ip=40.107.243.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tQbZVenW8B/WiMsEXKkbIb3X1utrlWoXFbOK9irgMfbIu8ULzCGGGJJk33yx0q4zEiIxXSnywFG4XFbX1f72QOfAfnY5+BYUM7cJX6JS7T6kvwLG+jnddbSUXRBl+R/gD8OvEEE6ayyc4wpPlXPhXhqVVSl8HIqBVlE5dkCa+fPCZxrUCMtYBOnYaM4beYg2fMKAMMc/yKl1xMNnlCyxxX2WQIZpNO9tiyQOKaJNNc+woL3/JTwDaI8fZG9X6XF4dmSYyAQjJyxS6bIWsCcUxS/iLWpiUAf99xekopOrYLSGorcPimcim9/ATCq5LMwo8/nLy3LoR7iTkKF21rytvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tc35ZbhiG9XbcVesmk5U7VillT2nU/txSmLz9VsakcI=;
 b=LPDxvda+cxka6nxjdHsjnNBWuwCx/QZE9XjAlzSiorhX+Jy/WMga1xssNjFfPWdALIq3Zux5e7u0PqROJn34m1iOc4Njl+MltBYaR9fkbJlzw2kVJERjGObdX0xzV0G5loJn5jQxNdj4sRivvSMH0JuIiA4dhlyucUPJAqh0NwzaO6ZlN2XVfmNDbRXgSUsZLAmPP0vD6FZzurwd842TWMKFXiDNssv07S2FgeNh8z4/eK1TQgJOBNNajV7Fho3MaAdDZvSQ7bTwXSWhDrcMtxOLpHmHOa6359rQJrFdcg9HpejZyiS93apDqdGub78dTkiglXFTlGQPHZSdZO1khw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tc35ZbhiG9XbcVesmk5U7VillT2nU/txSmLz9VsakcI=;
 b=sb+XJfW4huQhcNulyQ6QHJtVtAggwn0Wma7F/owOuQHYn8vwbm3CYWf1J5jmcWaFgxSvxbDDSsOIBhijceHSYLQ9acijOm/exohCW6xYHvU0XZ/NESUBfmptKXPkDOI7Z0WoEiMfY8bvzw4WFgyH73wwYa4CBYD+aEO3ZeDuhyIh61kW9RPpk9dEz/sSNN5hYJbqni9OPttFTpqP1H1ljuTTFdfu/KxhGQQDw6TLSJgH1RT9iqLLRWECSMG1dx64baIVn6nwQ9sp9AIsq2z7RHE2jDW05uOzY+Cezv7v7TMhuEQxF4iHuMiefuI901UzOusWFLDbVsTnNHEi0HUuMA==
Received: from PH7PR03CA0030.namprd03.prod.outlook.com (2603:10b6:510:339::35)
 by MW6PR12MB8866.namprd12.prod.outlook.com (2603:10b6:303:24c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Wed, 13 Nov
 2024 11:53:22 +0000
Received: from SA2PEPF000015C7.namprd03.prod.outlook.com
 (2603:10b6:510:339:cafe::1b) by PH7PR03CA0030.outlook.office365.com
 (2603:10b6:510:339::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.16 via Frontend
 Transport; Wed, 13 Nov 2024 11:53:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF000015C7.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Wed, 13 Nov 2024 11:53:21 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 13 Nov
 2024 03:53:07 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 13 Nov
 2024 03:53:06 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Wed, 13 Nov
 2024 03:53:03 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V4 vfio 7/7] vfio/virtio: Enable live migration once VIRTIO_PCI was configured
Date: Wed, 13 Nov 2024 13:52:00 +0200
Message-ID: <20241113115200.209269-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20241113115200.209269-1-yishaih@nvidia.com>
References: <20241113115200.209269-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C7:EE_|MW6PR12MB8866:EE_
X-MS-Office365-Filtering-Correlation-Id: 99a15925-c0c6-4eb8-55ed-08dd03d9c5d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gDLm3d3DV6tS9mtSPWKdgRgp1x7SMAG+9tzSB8wZkvHgDsWgVg7H6JR1s5IF?=
 =?us-ascii?Q?XiifexD39dqP2EulpPEPUiKDMoKfznnWQlu7A7p6RZo/ijfQjDsyRZkIE/mz?=
 =?us-ascii?Q?Nwl7a239kKJRKC2Q3RAXnSeTxFEvwqn6XBT7hiQZrT09G4oNVijl5Wozg36h?=
 =?us-ascii?Q?mH6yK/5s0CEntOjwe3nI8dMM5qogLKeqBAfD3rGbBItop5eN+BR19lzGBKCo?=
 =?us-ascii?Q?eEV0E9RC+4RhnlMCI87+it7IyJOd4mAjGH7zzK1FOlFEr1dpY8tobQ/mYEJ9?=
 =?us-ascii?Q?QW6uJz/jPdrCCkJ8cf7tf0TZY/fJ5wMwK/r81YjHg5W/VDfvhLD/aLApYD7F?=
 =?us-ascii?Q?mmSxhseoZzuyzlJy3ugdowhBxF4Ypcdi4bGAHr3BMrOlLzCdrFA5ly51PYiX?=
 =?us-ascii?Q?4jmWyifAcPAK3vCZSYCcrx9TtETg+6P7FOxVhfACOHTC+vj0LRgrNt/0xrsW?=
 =?us-ascii?Q?EyqbLhtph+Hdoxl8/PRn5zXKPtbELx2XXe7N4J7L3cJPDeUvHgk1zvpzpEYE?=
 =?us-ascii?Q?vejo3DW1Dkc70u7TeMURBXcONuzMcdWcy3g7hwLrsA35CVXaWI0qGGLDjIqJ?=
 =?us-ascii?Q?hqrUZPxgMIGeKYik1QLA2z9YPbI9V3fOlWy9yf8lGY8C6iWF7tb5Bqjh5S38?=
 =?us-ascii?Q?rf5rLiGESbesWcCxkxynQ4yqKgERlx2WazVCqQym/zZziBZThamzI4QcmTVt?=
 =?us-ascii?Q?/D3UgjT10OyJ0SjgmmCUIB4FIUDJQikMSR+D9ciOX+zRSzcyr7B953xq2qBm?=
 =?us-ascii?Q?K+IR10YSebOSZCAvDBfrnLHe6xxJIjzIrK/qWwuy6e7TCznWZorzsXOYTnmI?=
 =?us-ascii?Q?FpAdFR6l9hHgOx7sj7ILSsMa/kp3WMPGs3pbkYwFNJXcg/dUWUOjMXHtipPe?=
 =?us-ascii?Q?ae9SEYcpVsgUPBjqnVTLtk31IBTDWpF5X6eIL7ipuRJRg6eBh4IVN6k1I9kE?=
 =?us-ascii?Q?g1dAi4vZiT/YGvsg2tcVTCuN37yVImiNiPRwURrshw9RwuDKfFY4aD11/VzJ?=
 =?us-ascii?Q?YC8Z1vnA5ZGv65A2d/dEPvph9jEoAq6VqbwwZUOM9IrqO8dDVxE+uBh5LiEV?=
 =?us-ascii?Q?a+NP/dNkUtMdRZi5EO3QQC2QzjqBLLZw5RFl9jEsuhxx4eoZn8dsV0ZnFC+R?=
 =?us-ascii?Q?Eld7UHkt9qVBjyodGSbILLI+MXh+mFE7U+CRcTJEDuDRQrKkbCtkcfPSvtGQ?=
 =?us-ascii?Q?ldqaMELltlW2k1WcOk/MS1cEJ10jOwymHkayXzUA38dGnIZp3QjS5VF4muJI?=
 =?us-ascii?Q?pcqyX/4BbTI8pMXVEIbK2dvfqCsOjpG+H5e6rqo06nGAN6ejOJZIpIm0+C+b?=
 =?us-ascii?Q?HyHi2d21Zwrb5NogSRoZlOIVUxbyg4a/hsb1ee+O4hTadKloAMKExb6zIzFJ?=
 =?us-ascii?Q?5ulslTIy32Doss+lMie+pkenQ8Kmx57oMJu1CnMi18N2Lc/U4g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 11:53:21.7173
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99a15925-c0c6-4eb8-55ed-08dd03d9c5d6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8866

Now that the driver supports live migration, only the legacy IO
functionality depends on config VIRTIO_PCI_ADMIN_LEGACY.

As part of that we introduce a bool configuration option as a sub menu
under the driver's main live migration feature named
VIRTIO_VFIO_PCI_ADMIN_LEGACY, to control the legacy IO functionality.

This will let users configuring the kernel, know which features from the
description might be available in the resulting driver.

As of that, move the legacy IO into a separate file to be compiled only
once CONFIG_VIRTIO_VFIO_PCI_ADMIN_LEGACY was configured and let the live
migration depends only on VIRTIO_PCI.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/virtio/Kconfig     |  42 ++-
 drivers/vfio/pci/virtio/Makefile    |   1 +
 drivers/vfio/pci/virtio/common.h    |  19 ++
 drivers/vfio/pci/virtio/legacy_io.c | 418 ++++++++++++++++++++++++++++
 drivers/vfio/pci/virtio/main.c      | 410 ++-------------------------
 5 files changed, 489 insertions(+), 401 deletions(-)
 create mode 100644 drivers/vfio/pci/virtio/legacy_io.c

diff --git a/drivers/vfio/pci/virtio/Kconfig b/drivers/vfio/pci/virtio/Kconfig
index bd80eca4a196..2770f7eb702c 100644
--- a/drivers/vfio/pci/virtio/Kconfig
+++ b/drivers/vfio/pci/virtio/Kconfig
@@ -1,15 +1,31 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config VIRTIO_VFIO_PCI
-        tristate "VFIO support for VIRTIO NET PCI devices"
-        depends on VIRTIO_PCI && VIRTIO_PCI_ADMIN_LEGACY
-        select VFIO_PCI_CORE
-        help
-          This provides support for exposing VIRTIO NET VF devices which support
-          legacy IO access, using the VFIO framework that can work with a legacy
-          virtio driver in the guest.
-          Based on PCIe spec, VFs do not support I/O Space.
-          As of that this driver emulates I/O BAR in software to let a VF be
-          seen as a transitional device by its users and let it work with
-          a legacy driver.
-
-          If you don't know what to do here, say N.
+	tristate "VFIO support for VIRTIO NET PCI VF devices"
+	depends on VIRTIO_PCI
+	select VFIO_PCI_CORE
+	help
+	  This provides migration support for VIRTIO NET PCI VF devices
+	  using the VFIO framework. Migration support requires the
+	  SR-IOV PF device to support specific VIRTIO extensions,
+	  otherwise this driver provides no additional functionality
+	  beyond vfio-pci.
+
+	  Migration support in this driver relies on dirty page tracking
+	  provided by the IOMMU hardware and exposed through IOMMUFD, any
+	  other use cases are dis-recommended.
+
+	  If you don't know what to do here, say N.
+
+config VIRTIO_VFIO_PCI_ADMIN_LEGACY
+	bool "Legacy I/O support for VIRTIO NET PCI VF devices"
+	depends on VIRTIO_VFIO_PCI && VIRTIO_PCI_ADMIN_LEGACY
+	default y
+	help
+	  This extends the virtio-vfio-pci driver to support legacy I/O
+	  access, allowing use of legacy virtio drivers with VIRTIO NET
+	  PCI VF devices. Legacy I/O support requires the SR-IOV PF
+	  device to support and enable specific VIRTIO extensions,
+	  otherwise this driver provides no additional functionality
+	  beyond vfio-pci.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/pci/virtio/Makefile b/drivers/vfio/pci/virtio/Makefile
index bf0ccde6a91a..d9b0bb40d6b3 100644
--- a/drivers/vfio/pci/virtio/Makefile
+++ b/drivers/vfio/pci/virtio/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio-vfio-pci.o
 virtio-vfio-pci-y := main.o migrate.o
+virtio-vfio-pci-$(CONFIG_VIRTIO_VFIO_PCI_ADMIN_LEGACY) += legacy_io.o
diff --git a/drivers/vfio/pci/virtio/common.h b/drivers/vfio/pci/virtio/common.h
index 5704603f0f9d..c7d7e27af386 100644
--- a/drivers/vfio/pci/virtio/common.h
+++ b/drivers/vfio/pci/virtio/common.h
@@ -78,6 +78,7 @@ struct virtiovf_migration_file {
 
 struct virtiovf_pci_core_device {
 	struct vfio_pci_core_device core_device;
+#ifdef CONFIG_VIRTIO_VFIO_PCI_ADMIN_LEGACY
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
 
+#ifdef CONFIG_VIRTIO_VFIO_PCI_ADMIN_LEGACY
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
+bool virtiovf_support_legacy_io(struct pci_dev *pdev);
+int virtiovf_init_legacy_io(struct virtiovf_pci_core_device *virtvdev);
+void virtiovf_release_legacy_io(struct virtiovf_pci_core_device *virtvdev);
+void virtiovf_legacy_io_reset_done(struct pci_dev *pdev);
+#endif
+
 #endif /* VIRTIO_VFIO_COMMON_H */
diff --git a/drivers/vfio/pci/virtio/legacy_io.c b/drivers/vfio/pci/virtio/legacy_io.c
new file mode 100644
index 000000000000..20382ee15fac
--- /dev/null
+++ b/drivers/vfio/pci/virtio/legacy_io.c
@@ -0,0 +1,418 @@
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
+bool virtiovf_support_legacy_io(struct pci_dev *pdev)
+{
+	return virtio_pci_admin_has_legacy_io(pdev) && !virtiovf_bar0_exists(pdev);
+}
+
+int virtiovf_init_legacy_io(struct virtiovf_pci_core_device *virtvdev)
+{
+	struct pci_dev *pdev = virtvdev->core_device.pdev;
+	int ret;
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
index e9ae17209026..d534d48c4163 100644
--- a/drivers/vfio/pci/virtio/main.c
+++ b/drivers/vfio/pci/virtio/main.c
@@ -18,330 +18,6 @@
 
 #include "common.h"
 
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
@@ -353,18 +29,13 @@ static int virtiovf_pci_open_device(struct vfio_device *core_vdev)
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
+#ifdef CONFIG_VIRTIO_VFIO_PCI_ADMIN_LEGACY
+	ret = virtiovf_open_legacy_io(virtvdev);
+	if (ret) {
+		vfio_pci_core_disable(vdev);
+		return ret;
 	}
+#endif
 
 	virtiovf_open_migration(virtvdev);
 	vfio_pci_core_finish_enable(vdev);
@@ -380,66 +51,33 @@ static void virtiovf_pci_close_device(struct vfio_device *core_vdev)
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
+#ifdef CONFIG_VIRTIO_VFIO_PCI_ADMIN_LEGACY
 static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
 {
 	struct virtiovf_pci_core_device *virtvdev = container_of(core_vdev,
 			struct virtiovf_pci_core_device, core_device.vdev);
-	struct pci_dev *pdev;
 	int ret;
 
 	ret = vfio_pci_core_init_dev(core_vdev);
 	if (ret)
 		return ret;
 
-	pdev = virtvdev->core_device.pdev;
 	/*
 	 * The vfio_device_ops.init() callback is set to virtiovf_pci_init_device()
 	 * only when legacy I/O is supported. Now, let's initialize it.
 	 */
-	ret = virtiovf_read_notify_info(virtvdev);
-	if (ret)
-		return ret;
-
-	virtvdev->bar0_virtual_buf_size = VIRTIO_PCI_CONFIG_OFF(true) +
-				virtiovf_get_device_config_size(pdev->device);
-	BUILD_BUG_ON(!is_power_of_2(virtvdev->bar0_virtual_buf_size));
-	virtvdev->bar0_virtual_buf = kzalloc(virtvdev->bar0_virtual_buf_size,
-					     GFP_KERNEL);
-	if (!virtvdev->bar0_virtual_buf)
-		return -ENOMEM;
-	mutex_init(&virtvdev->bar_mutex);
-	return 0;
+	return virtiovf_init_legacy_io(virtvdev);
 }
+#endif
 
 static void virtiovf_pci_core_release_dev(struct vfio_device *core_vdev)
 {
+#ifdef CONFIG_VIRTIO_VFIO_PCI_ADMIN_LEGACY
 	struct virtiovf_pci_core_device *virtvdev = container_of(core_vdev,
 			struct virtiovf_pci_core_device, core_device.vdev);
 
-	kfree(virtvdev->bar0_virtual_buf);
+	virtiovf_release_legacy_io(virtvdev);
+#endif
 	vfio_pci_core_release_dev(core_vdev);
 }
 
@@ -462,6 +100,7 @@ static const struct vfio_device_ops virtiovf_vfio_pci_lm_ops = {
 	.detach_ioas = vfio_iommufd_physical_detach_ioas,
 };
 
+#ifdef CONFIG_VIRTIO_VFIO_PCI_ADMIN_LEGACY
 static const struct vfio_device_ops virtiovf_vfio_pci_tran_lm_ops = {
 	.name = "virtio-vfio-pci-trans-lm",
 	.init = virtiovf_pci_init_device,
@@ -480,6 +119,7 @@ static const struct vfio_device_ops virtiovf_vfio_pci_tran_lm_ops = {
 	.attach_ioas = vfio_iommufd_physical_attach_ioas,
 	.detach_ioas = vfio_iommufd_physical_detach_ioas,
 };
+#endif
 
 static const struct vfio_device_ops virtiovf_vfio_pci_ops = {
 	.name = "virtio-vfio-pci",
@@ -500,13 +140,6 @@ static const struct vfio_device_ops virtiovf_vfio_pci_ops = {
 	.detach_ioas = vfio_iommufd_physical_detach_ioas,
 };
 
-static bool virtiovf_bar0_exists(struct pci_dev *pdev)
-{
-	struct resource *res = pdev->resource;
-
-	return res->flags;
-}
-
 static int virtiovf_pci_probe(struct pci_dev *pdev,
 			      const struct pci_device_id *id)
 {
@@ -517,12 +150,13 @@ static int virtiovf_pci_probe(struct pci_dev *pdev,
 	int ret;
 
 	if (pdev->is_virtfn) {
-		sup_legacy_io = virtio_pci_admin_has_legacy_io(pdev) &&
-				!virtiovf_bar0_exists(pdev);
-		sup_lm = virtio_pci_admin_has_dev_parts(pdev);
+#ifdef CONFIG_VIRTIO_VFIO_PCI_ADMIN_LEGACY
+		sup_legacy_io = virtiovf_support_legacy_io(pdev);
 		if (sup_legacy_io)
 			ops = &virtiovf_vfio_pci_tran_lm_ops;
-		else if (sup_lm)
+#endif
+		sup_lm = virtio_pci_admin_has_dev_parts(pdev);
+		if (sup_lm && !sup_legacy_io)
 			ops = &virtiovf_vfio_pci_lm_ops;
 	}
 
@@ -562,9 +196,9 @@ MODULE_DEVICE_TABLE(pci, virtiovf_pci_table);
 
 static void virtiovf_pci_aer_reset_done(struct pci_dev *pdev)
 {
-	struct virtiovf_pci_core_device *virtvdev = dev_get_drvdata(&pdev->dev);
-
-	virtvdev->pci_cmd = 0;
+#ifdef CONFIG_VIRTIO_VFIO_PCI_ADMIN_LEGACY
+	virtiovf_legacy_io_reset_done(pdev);
+#endif
 	virtiovf_migration_reset_done(pdev);
 }
 
-- 
2.27.0


