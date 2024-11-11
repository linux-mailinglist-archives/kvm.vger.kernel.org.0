Return-Path: <kvm+bounces-31420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B24179C39EA
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 09:44:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C6F061C21643
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 08:44:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3896C16F0CA;
	Mon, 11 Nov 2024 08:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Y/wJZ53N"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4ACB17DE16
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 08:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731314598; cv=fail; b=kDldd+kkHx5CDrsvB1F9AHQhf8DwyjhZHclHA3s+jJzqu9++LJWk6e+tHtzo8MDMbkMoXQRkIXBcd4+HdViayO0rqAjsHh2njbGZZjKsr4qeJtLOZ/qBtcMb5pqps2MN4PH844RHn81HPmNNAvqoCnrUg6xCAhM1OJB3AvUF+yE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731314598; c=relaxed/simple;
	bh=ZA8dnxhFLTJjLdwjl5zmGj3M5zC9h/8+bZj6RV0Xdo0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AYsKN4hBxI7Zbw4FDe2VfSrXseD8oWa83gTUFjv+r0Ri78gOcsBYB5veIR17YKlVE7zAzqwQIj57IK2Qg+PX8aI4oBoshffLqawE1mROY6Q/toXsA8Tbvi0w0D3CjFRlmKJFEFXB3rrrUcNZyr97Evh4YQcvxCBl910XNkptQ7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Y/wJZ53N; arc=fail smtp.client-ip=40.107.244.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MnwK+ZNb5X0rCilbXM+1THKDDHsnWnpOcc/fI+g/K4rCzP04pKy+tGhjxMh72krOFmvJ5hk9G7aCROyYYtejZjaLh4nixgMtkPDxrWoFaTmNsYPxlvfU3V/xjF45VjuicT4NuMQXZ0CMhXmFshsEM4/eh39pboQcvO93d6zaKx6+WvMCpm8bAIU9RlQYtwbFWxeTOOxaAndazYYXkHqPpEaxOyTcrpzLHW7hbWSj6w2hzOGwdu6+TUK7VEDzyOfsUTDD4DPjAPo0Mdcf9mQ6Z5rPDxLcqirXemNL9oBqt1JKP3r0IhWxN6ZCYfZ58AzKDwDzMXIRFdVwRqSQ/4pGtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nAkgbIhCN/CBkkuFLhZu/jn+KnlCATNIjptZCD/h254=;
 b=skTTpfcAjqdHDGa+gUHqZSCcBTiFmfK36ZQlgIGb/wB3V0H6MoXyRTDliRaGJFFT9qdy7bWO6xcW9I54iqE93xObeEVXssXJ1yHMUWNglQlCqvptENzOgyKkofDX6gcvy1wTvhCY40FFtrdB6aOPML+A8jolISvyiVqM9yuGVpF5Dz72ApTyg3qoHtk1rhGkDMroxwEi9oLh/hn1fPoa+xtWYe9v+TVJoda/g8FgV5j4lGDktuPTG3pCsVi+eGr8GHYQCkcDU21uhLENLePQkHLptTQ2lqMCfLO/Gslh8t0FITxWO2wLZL9/dlZdYKxhCMlbzdnwwzUXsBBEcb2eog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nAkgbIhCN/CBkkuFLhZu/jn+KnlCATNIjptZCD/h254=;
 b=Y/wJZ53NAsqOhYiDJoJFs7SHohZv9pEmVhn5kXQETTZ/e3V/BbASHaQl9IVf4oq0iMcPjFiNEXLZJZ5OFAC38RbaJUguOKufjixBzdPO/XHNoVGlPHJRLsEz3aUJXNN5u1WgF6NIJp2boNvrK8x8HipxKQDXHJFt0UDZ64BFiD8Xd3wyHx1iyvtt9S9ddoxwq/8lIXcb0yyqKC8XbMrE+IbJJotMiu5j14drMO2AnV5z8JzbSLs4tTkxgzcUXM/1Z80KSLxjfTGfzJj2j6r4QkRyTN4VK5W18EitKYtlSKaK8xfrKhoFSXPfF8BMuLG+VWzRBDQA6v0eqL44JYUN5Q==
Received: from MW4PR04CA0058.namprd04.prod.outlook.com (2603:10b6:303:6a::33)
 by SJ2PR12MB8944.namprd12.prod.outlook.com (2603:10b6:a03:53e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.26; Mon, 11 Nov
 2024 08:43:11 +0000
Received: from MWH0EPF000971E9.namprd02.prod.outlook.com
 (2603:10b6:303:6a:cafe::c3) by MW4PR04CA0058.outlook.office365.com
 (2603:10b6:303:6a::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28 via Frontend
 Transport; Mon, 11 Nov 2024 08:43:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000971E9.mail.protection.outlook.com (10.167.243.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Mon, 11 Nov 2024 08:43:11 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 11 Nov
 2024 00:42:58 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 11 Nov
 2024 00:42:57 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Mon, 11 Nov
 2024 00:42:54 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V2 vfio 7/7] vfio/virtio: Enable live migration once VIRTIO_PCI was configured
Date: Mon, 11 Nov 2024 10:41:57 +0200
Message-ID: <20241111084157.88044-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20241111084157.88044-1-yishaih@nvidia.com>
References: <20241111084157.88044-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E9:EE_|SJ2PR12MB8944:EE_
X-MS-Office365-Filtering-Correlation-Id: 80055aad-dd90-40e9-e65f-08dd022cdfd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?becklj7gqMzM7RtEeWlJOxjg3RPa2i/rE5Hv9d4RdNRajcu7mCHl6SZhYTLP?=
 =?us-ascii?Q?44NYzfw9VPwCEozkmIUsDQL+PG3anUO06hdslmuRk/SanAq2I/2cJDJuGP3b?=
 =?us-ascii?Q?1fc4ldMgpsLom5wwGaiyg1Us7H13KRFTknnpe6wAMJm+V8uXzmDU/DY5zKen?=
 =?us-ascii?Q?inIpYW5SzMsOuQsu/1i+a1NOeNkkTf3t9wUHMiY7Bo7y/Iqm0qh8eKVqm7YO?=
 =?us-ascii?Q?nmm/JN6idX5SoAtoK0FgLOoXQ0Sy6bwzgt6KqtoKFLGgZ4+UWZ6cdZ/qhgqH?=
 =?us-ascii?Q?05Ugnwu3hJe6+806vRS40rn5BULdcB14Oyd0eUzHlqQAU6RDxet4+hI3O21p?=
 =?us-ascii?Q?P9KuyQwdl8PoAPIbegJfmywFJVY8aQXPJcc40I+8n/cquea6CQvo6sGgvcoo?=
 =?us-ascii?Q?FZbGNQpv1SgSoL28sZMb47m8TNZ709D6LyR9qrJxAQR9Zjf3JWW+rhP7N738?=
 =?us-ascii?Q?pNvHpK/sUGGN1pFvG4qYI3Y4zfqWkO+xwZRA29egkHI2iCjpAPtWHUtIyx0g?=
 =?us-ascii?Q?lVendDHx51HjuxZby2hpc7EFgkKwdSHnlLqAaoE+7Wdf3GE3fd7vreGGotBZ?=
 =?us-ascii?Q?ecPiswlURWdI+3H+12oW5vpQLtAJKJRJVImG1JKTEiJJR87Rspisrcy72rQg?=
 =?us-ascii?Q?k1fzqReEyeT+OPFKxBaOpJKL8MCpBJ9QvL/vT8qeT5Z50sU+dBoJ3O5zaKju?=
 =?us-ascii?Q?V10kRyGGsFF5FVwq57jaE6vv5HLKIyigBCmvOgc+oGEiRglMSw4OeFCaO4qm?=
 =?us-ascii?Q?p8Kgy0n7jUmcXJT0pi1S3lKHdvfxht2o1OjEjFbw9Chw3rhotBKIg9/2UGE8?=
 =?us-ascii?Q?DhmQTpiXuO37Gcm6EGk44tx58COM9ZS30yKCNrz9QVqD8ENgdOo1Hld7Uvfv?=
 =?us-ascii?Q?PWYUbxrEtT0K4PDj66E40D8PCkwtyVwyCLQPtKazgRj5ElRqwSoZIuvnkH1f?=
 =?us-ascii?Q?EKZA3VuKriUeYuRioQdib9EONXYC+dvnNDpuUrZsVFAQRv4+tWP5EDN/TTIp?=
 =?us-ascii?Q?dQz8DqDpeyl7TClAF9feiZd3pdMbPC0HKCEjpZKaptAEcVooS5TJbRyHSPvQ?=
 =?us-ascii?Q?0abi3Mk+fLl78a9nHD9hyVPqcAtl161W2HHrU+PXL3ZV2RSUaMOH+vyd5lgK?=
 =?us-ascii?Q?ub3KFeBcFKA0MdsnPo0CsYs9Igsob5wlVHZUpHnM7nfu3WnVJ3uTyyHD+u1u?=
 =?us-ascii?Q?5G9oLSsZ2LN8/uBKMwlGiB7W80E6UJma/U4/rgNI15ugks/FVeCuG+VTcSso?=
 =?us-ascii?Q?+kDoYwMQm+CMDErM5jXjFq7P89VXb3Hxaz7Pl1NQauX4duYDBJshaCMRkSko?=
 =?us-ascii?Q?fbv8C5REQ/NabW69iLIPhuhHCT7Du7NtkrVDm8HqP3NqxIS/Ss5+Yiv9/iqa?=
 =?us-ascii?Q?AArx2KK1BuTHJH5kgGhpiv1Lszhp4Zvs6FXelad6yq209xdKwQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 08:43:11.2382
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80055aad-dd90-40e9-e65f-08dd022cdfd5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8944

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
 drivers/vfio/pci/virtio/Kconfig     |  43 ++-
 drivers/vfio/pci/virtio/Makefile    |   1 +
 drivers/vfio/pci/virtio/common.h    |  19 ++
 drivers/vfio/pci/virtio/legacy_io.c | 418 ++++++++++++++++++++++++++++
 drivers/vfio/pci/virtio/main.c      | 410 ++-------------------------
 5 files changed, 490 insertions(+), 401 deletions(-)
 create mode 100644 drivers/vfio/pci/virtio/legacy_io.c

diff --git a/drivers/vfio/pci/virtio/Kconfig b/drivers/vfio/pci/virtio/Kconfig
index bd80eca4a196..667ad305ef79 100644
--- a/drivers/vfio/pci/virtio/Kconfig
+++ b/drivers/vfio/pci/virtio/Kconfig
@@ -1,15 +1,32 @@
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
+	select IOMMUFD_DRIVER
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


