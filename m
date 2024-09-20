Return-Path: <kvm+bounces-27233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C81197DAA0
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 00:37:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A07311F22541
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 22:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59BC418E37F;
	Fri, 20 Sep 2024 22:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aJfKteDs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2074.outbound.protection.outlook.com [40.107.236.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A1C18E347;
	Fri, 20 Sep 2024 22:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726871732; cv=fail; b=YRTpHC8fEsFwC90UeGLtizOUBbVF5I27AjhgMtn4QnOcIDImCwj4Z7SWLjZyITWC4FLJAlMfFb/DyPoPrpSps1+fCChOlciC78klnzz1JRe29QuSU8LYANdwQLho898USeSMoDowJbMVAsU4PjlcHGFmPD0C8rDI0DGK9M4heu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726871732; c=relaxed/simple;
	bh=KSVOTVWhQ7FOBawrx6yHcRPfDw6BIR/lcjz14rPP/d0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O1Pm22VTlmF0bao/jHFNtcOC40ZgY0E2nEISc55HMgGNiagupljdFo/J87qPvSTKrZi37W76qkGa9OcLhY1L7gBwCbfTvrn5EjWUoMcw6OGjoOgYBSLu9EYugJVmrhfRGjwj54FXbw/jTpgqGqyFeMhB8gJv2njr9vWiDxeJhB4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aJfKteDs; arc=fail smtp.client-ip=40.107.236.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZvPoCa0OPf9iRiP+eTpqvQuulL62+vPROeVxBB80jnqcFHYgLQDhYI39SXWL0TJBK6SexuFIxfeIT7rqk9iFEV3kjSTXUdooMhcScW6YXvOeaG59QghcPnXp4aQXqVZyoJ0Eq6drZG2v7DDKWwPeAaAKdHYPmNxZk1/BKzchOdoHRnetU2LG8peg3yu5lc1Flit+2GUO7WrpiTS5K3NdZ5pJyWY6gA60Jrn/F+JYqC7eW+/0obViMurrleyo0jSVZJv/Tktq/vfF611Ee9roDAaRwC8oleBIn4UsQT29iyI+fGtP2D35SDFJt71Q1mdBD/S0vVgn84uX6R9VsmzYEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jj6vIJHUIuEGQEoT6g/SGfa4v6kHpkW+QLMs33NhB6w=;
 b=bxhqgAU2f+b9gOd2JzP5Fc/2tR3LO8XX0pRVPDpxATzLv4+3tafhuaUoYIBP4xPkmoQMJF+BT1nc70izUYfEF/yGkq21iiXmCBI2ITaFOYuo38ZcoVHfRmr9lEkP5ClT/nKS4nyPenxjrzP3+WLsAxFGhBGUacUSDPrbMFAPijd24yfIs4MJi+NxcNGvd4LljXiw57A9gyQiojGeJCYmc8izxuR3ZxmyY8UPRLLDx1feHHhdJs0BzeO4jpFFsCr2LzjrRDAS47MzURZezKOiQ3NGY87VQ+xc2Zfwp7EzNy6G/BwuYE4HhU9fm/2amrPoufGFZMclGdHwZyE9xBJpNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jj6vIJHUIuEGQEoT6g/SGfa4v6kHpkW+QLMs33NhB6w=;
 b=aJfKteDsN9bS2lXhLEdkjndT0NLl/yhtjtjp+yNXWTjBUmELWLpTX/V5L6NqVxF86AZjnLqJvhmzeniGBH7Ulhc6i2BJ1tWNdXR+l9ZzG56QxI1DFZsInr5om8LLOlqIWSA03KwQyUxHpbSyQnS7AwCZk5IqdlvV4JZ2yGScBxi3+sCbErzgHhL3HgTgVF9fvn7G/QbsZ1GwmhUBA2riDF7ve6C8E+tPdL7qlfOhoRM527dJTUe9QTzbFEvYNTyxyfuskztN6jRh6B1oAtvVFrMxGWIlgNFRJxoGVkKAR3dgppo73LMXnLcKTo5PfEJdKUIuHbC/2ZBpo47AHblbyQ==
Received: from CY5PR19CA0119.namprd19.prod.outlook.com (2603:10b6:930:64::13)
 by MN0PR12MB5788.namprd12.prod.outlook.com (2603:10b6:208:377::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.22; Fri, 20 Sep
 2024 22:35:23 +0000
Received: from CY4PEPF0000E9D3.namprd03.prod.outlook.com
 (2603:10b6:930:64:cafe::6c) by CY5PR19CA0119.outlook.office365.com
 (2603:10b6:930:64::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.30 via Frontend
 Transport; Fri, 20 Sep 2024 22:35:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9D3.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 20 Sep 2024 22:35:23 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:35:06 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:35:06 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 20 Sep 2024 15:35:05 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <linux-cxl@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<alison.schofield@intel.com>, <dan.j.williams@intel.com>,
	<dave.jiang@intel.com>, <dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<ira.weiny@intel.com>, <vishal.l.verma@intel.com>, <alucerop@amd.com>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 12/13] vfio/cxl: VFIO variant driver for QEMU CXL accel device
Date: Fri, 20 Sep 2024 15:34:45 -0700
Message-ID: <20240920223446.1908673-13-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240920223446.1908673-1-zhiw@nvidia.com>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D3:EE_|MN0PR12MB5788:EE_
X-MS-Office365-Filtering-Correlation-Id: b602c0b5-eaa5-4c8f-3421-08dcd9c48464
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UnuJ4auzK0KCUzTxLahkH4nblPEkaAQwevxzn3jJ6pKocSeCicS/KQqVqlHN?=
 =?us-ascii?Q?u7NxX+L+eFM5mhesUqGl7sk19clkOSspDB6dWd1JesWZ2Au6PjicKIgAwiPy?=
 =?us-ascii?Q?cPMzjLLDnLMf3mtPnZyXOsPnamvki+JFKyEVduqVsWehmo9NcLKzTVpUJqYh?=
 =?us-ascii?Q?nXRTtZcY0ITaeFK6MrJCa0b50Lp+q/lyz0j3louNaRoWPPs/F2NEwlDH9/kA?=
 =?us-ascii?Q?VcaN6FcX64EQfqh5vp+FDlZFIzoEFmx9AJ81BRWLhqN2yzJFF3O9Sj7L6WfU?=
 =?us-ascii?Q?FkFB0D6r3S5SLmZOjsfNd3cCXiEdYIFeYzdQ1ygPXnfPdZvuqBwVze8aV5ja?=
 =?us-ascii?Q?MFmp4UrIWxFM4Enxzcgl5/v6XLome63Oj49chVMfJK7azSlGhBMbLAzhtXTi?=
 =?us-ascii?Q?yytacJuK5rHmXSd0FbRv+Z+CswYqaSOE9Ih00ujt8vHE6/ygJeKq9folAfRa?=
 =?us-ascii?Q?i3ok99Q6ipx9Eyoz1miVLEpZCy8sXGVlhXe1Guug+cK1CH4vxvMz2KvlGa2j?=
 =?us-ascii?Q?DtPNTHj2oYIlhSUA+C3L0JKXwcvm3d7owHKoMgZkWcCGEhlpadSKrW+kouIF?=
 =?us-ascii?Q?77RIoxeieTZ4BRuOnNX+NxO2M0KhsHFgxz2BOX114mTjFAV/LhYFkjh07mqS?=
 =?us-ascii?Q?qfUZn7YcMvwrKDlxlZDb/5JJ06iO35mSYIfmqWehlYE4o3PGsUx/jpMhjBWU?=
 =?us-ascii?Q?TjwKYvGu3Rzsrm4vf48xSOIEs74XBmDj4fc/MsQufhO0rg/5VemNMOSgEatj?=
 =?us-ascii?Q?DlYW0rWxR/T0KbMW+qMOe4GFZN0P9e/BgPzgl2C+Y0/JJvMqnnXZJG/3mQjO?=
 =?us-ascii?Q?oshlU8kBeISu7IGG5x9KbbPYW4x+Y6DMcvKxu1STp06v/bblnJ6nYU6tJK54?=
 =?us-ascii?Q?cfpjm1bcmAMDZUExifv0srGtkSUuQilIeZ1GN6q/RS5oADTgpyDnK9rvjZhG?=
 =?us-ascii?Q?o9jEJHHIHjMsstr5nIl4pyvUSpUA9badviyoVS1QtjOw26AXgFR0YT6gd+ZM?=
 =?us-ascii?Q?HWwCWXSPCFjXJkqKMsevRiSCMEvtPQsg9vss/pDkZoQo53B02ainTn+Ku4k4?=
 =?us-ascii?Q?htmNOY33uWVpaMVT/H4pwyIQtt2tHdeBk/J2cpvb3kRp4WcL8VGXENprCYiv?=
 =?us-ascii?Q?iPL94OcBGJaBsvcJsexvG/+QKNqCPJVsbjoi2BnqWY5rm4KHtoIO5CqWB+pg?=
 =?us-ascii?Q?wxKRp4KB+4eoBh1mqXjpV/L05Xz+ckqf3S+nlqmrlNxTFHZESy9hAm+qHDxi?=
 =?us-ascii?Q?gd1Yfax5kdBiqiOUDKuSSSK27/T2XkVLDykJv3C/HI19TmA1KJYQsuHTuPWz?=
 =?us-ascii?Q?aKU+6jxdn2wcp4Ou1Yr/OpR+SxZ6o4ZCOs31jb6//v50DbN6wwX4u+x7zgs5?=
 =?us-ascii?Q?hYDrgw+vCXxWv1S7lQEjo3fFm8SD+JOwdh8kNvMefWan2dpVFQfd6IuQH3AG?=
 =?us-ascii?Q?XPgDUIAbzSpr29abhtgk2x+y9Z627RqN?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2024 22:35:23.6338
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b602c0b5-eaa5-4c8f-3421-08dcd9c48464
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5788

To demostrate the VFIO CXL core, a VFIO variant driver for QEMU CXL
accel device is introduced, so that people to test can try the patches.

This patch is not meant to be merged.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/Kconfig            |   2 +
 drivers/vfio/pci/Makefile           |   2 +
 drivers/vfio/pci/cxl-accel/Kconfig  |   6 ++
 drivers/vfio/pci/cxl-accel/Makefile |   3 +
 drivers/vfio/pci/cxl-accel/main.c   | 116 ++++++++++++++++++++++++++++
 5 files changed, 129 insertions(+)
 create mode 100644 drivers/vfio/pci/cxl-accel/Kconfig
 create mode 100644 drivers/vfio/pci/cxl-accel/Makefile
 create mode 100644 drivers/vfio/pci/cxl-accel/main.c

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 2196e79b132b..9eebce09ffa2 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -75,4 +75,6 @@ source "drivers/vfio/pci/nvgrace-gpu/Kconfig"
 
 source "drivers/vfio/pci/qat/Kconfig"
 
+source "drivers/vfio/pci/cxl-accel/Kconfig"
+
 endmenu
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index b51221b94b0b..03293b52c5e3 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -22,3 +22,5 @@ obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio/
 obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) += nvgrace-gpu/
 
 obj-$(CONFIG_QAT_VFIO_PCI) += qat/
+
+obj-$(CONFIG_CXL_ACCEL_VFIO_PCI) += cxl-accel/
diff --git a/drivers/vfio/pci/cxl-accel/Kconfig b/drivers/vfio/pci/cxl-accel/Kconfig
new file mode 100644
index 000000000000..c3c9d7ec7fa4
--- /dev/null
+++ b/drivers/vfio/pci/cxl-accel/Kconfig
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config CXL_ACCEL_VFIO_PCI
+	tristate "VFIO support for the QEMU CXL accel device"
+	select VFIO_CXL_CORE
+	help
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/pci/cxl-accel/Makefile b/drivers/vfio/pci/cxl-accel/Makefile
new file mode 100644
index 000000000000..20f190482cc9
--- /dev/null
+++ b/drivers/vfio/pci/cxl-accel/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_CXL_ACCEL_VFIO_PCI) += cxl-accel-vfio-pci.o
+cxl-accel-vfio-pci-y := main.o
diff --git a/drivers/vfio/pci/cxl-accel/main.c b/drivers/vfio/pci/cxl-accel/main.c
new file mode 100644
index 000000000000..1672fb9d9232
--- /dev/null
+++ b/drivers/vfio/pci/cxl-accel/main.c
@@ -0,0 +1,116 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include <linux/sizes.h>
+#include <linux/vfio_pci_core.h>
+
+struct cxl_device {
+	struct vfio_pci_core_device core_device;
+};
+
+static int cxl_open_device(struct vfio_device *vdev)
+{
+	struct vfio_pci_core_device *core_dev =
+		container_of(vdev, struct vfio_pci_core_device, vdev);
+	struct resource res;
+	int ret;
+
+	/* Provide the device infomation to the kernel CXL core.*/
+	/* Device DPA */
+	res = DEFINE_RES_MEM(0, SZ_256M);
+	vfio_cxl_core_set_resource(core_dev, res, CXL_ACCEL_RES_DPA);
+
+	/* Device RAM */
+	res = DEFINE_RES_MEM_NAMED(0, SZ_256M, "ram");
+	vfio_cxl_core_set_resource(core_dev, res, CXL_ACCEL_RES_RAM);
+
+	/* The expected size of the CXL region to be created */
+	vfio_cxl_core_set_region_size(core_dev, SZ_256M);
+	vfio_cxl_core_set_driver_hdm_cap(core_dev);
+
+	/* Initailize the CXL device and enable the vfio-pci-core */
+	ret = vfio_cxl_core_enable(core_dev);
+	if (ret)
+		return ret;
+
+	vfio_cxl_core_finish_enable(core_dev);
+
+	return 0;
+}
+
+static const struct vfio_device_ops cxl_core_ops = {
+	.name		= "cxl-vfio-pci",
+	.init		= vfio_pci_core_init_dev,
+	.release	= vfio_pci_core_release_dev,
+	.open_device	= cxl_open_device,
+	.close_device	= vfio_cxl_core_close_device,
+	.ioctl		= vfio_pci_core_ioctl,
+	.device_feature	= vfio_pci_core_ioctl_feature,
+	.read		= vfio_cxl_core_read,
+	.write		= vfio_cxl_core_write,
+	.mmap		= vfio_pci_core_mmap,
+	.request	= vfio_pci_core_request,
+	.match		= vfio_pci_core_match,
+	.bind_iommufd	= vfio_iommufd_physical_bind,
+	.unbind_iommufd	= vfio_iommufd_physical_unbind,
+	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
+	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
+};
+
+static int cxl_probe(struct pci_dev *pdev,
+			     const struct pci_device_id *id)
+{
+	const struct vfio_device_ops *ops = &cxl_core_ops;
+	struct cxl_device *cxl_device;
+	int ret;
+
+	cxl_device = vfio_alloc_device(cxl_device, core_device.vdev,
+				       &pdev->dev, ops);
+	if (IS_ERR(cxl_device))
+		return PTR_ERR(cxl_device);
+
+	dev_set_drvdata(&pdev->dev, &cxl_device->core_device);
+
+	ret = vfio_pci_core_register_device(&cxl_device->core_device);
+	if (ret)
+		goto out_put_vdev;
+
+	return ret;
+
+out_put_vdev:
+	vfio_put_device(&cxl_device->core_device.vdev);
+	return ret;
+}
+
+static void cxl_remove(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
+
+	vfio_pci_core_unregister_device(core_device);
+	vfio_put_device(&core_device->vdev);
+}
+
+static const struct pci_device_id cxl_vfio_pci_table[] = {
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL, 0xd94) },
+	{}
+};
+
+MODULE_DEVICE_TABLE(pci, cxl_vfio_pci_table);
+
+static struct pci_driver cxl_vfio_pci_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = cxl_vfio_pci_table,
+	.probe = cxl_probe,
+	.remove = cxl_remove,
+	.err_handler = &vfio_pci_core_err_handlers,
+	.driver_managed_dma = true,
+};
+
+module_pci_driver(cxl_vfio_pci_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Zhi Wang <zhiw@nvidia.com>");
+MODULE_DESCRIPTION("VFIO variant driver for QEMU CXL accel device");
+MODULE_IMPORT_NS(CXL);
-- 
2.34.1


