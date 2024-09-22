Return-Path: <kvm+bounces-27266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F8BC97E1B4
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 14:52:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEC762814D7
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 12:52:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E2B346450;
	Sun, 22 Sep 2024 12:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SzHBoD70"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5872AD33
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 12:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727009454; cv=fail; b=FMoXyhBMxaRklMI8a7Ad2zNR5WCJcjcSGqdDcXaV3aJUmwp9Tx3CgJ6WfnDcdVATWdEoMVIpRxKs+Z2RzwiRvNCSlmYYkeKvCTvOSfFUY7w7I8I+yw0F1Ab080i6Jn13kY5k/Jk91mtDkiKeXrbtWkdTPPDK9uu/QivIBxUFQ7w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727009454; c=relaxed/simple;
	bh=3zHkSPwBeY2OG33JdP2Tigc5oRE8cSo99YV/Z+gVswQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y07bpYa/gzXf0LXAnrCrHfya7J92YZVxh4vPByQjimQyiHNv6i2/5cDWMtVgKD3XEorPrjO7aM3Qnr5eMwA++qkLrl3MBPNG3n71uyEvsdkqhNuu2YygN/6sVOnMxG2p8SZny5uf2tMGNuhr+GF1l5t8/pexUyAJVUvxN/EjXPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SzHBoD70; arc=fail smtp.client-ip=40.107.220.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MQ7LUhDWPzvgVLz3IYtSNUUqb0DpQ4MBxGmmapFhKVcfX8KIW7l7A/7qeXPEu0MTd1kivpR6UvuWe1MWV+ZlsbX5V/QpVMVyHwioDvrO8za1CMeAqcddoKCCtVsqOtCdu6XiPlXAtTkb2TBLKyHCm8LE3VLPnJeHQL59qI2KEpifTD0mVhWGDn+0NTgx9FeJscOyAjosve0MVr0zF+HSR+BgK09gR35v+3en5UOP4T5WCbEHWFJBrYtvIHin/SjypTRz69VXmPpfhLhH3wxHdOsgaEgeS/5M35WjQsNf+9BG7hSE+WM9YET8iWrn0/oBKaDGxzQPlenxPWFLOID4Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tO7GDRY2U3uvpaqhcosC9SNjelzDMHBPuhdAWI2kBe8=;
 b=muiL1H9d94HlYJ07MbRGeEdljAwDwQAVVN0HyJ0GB8S98Y56gVm4Xq83o0458C5a7NNJt9DQaJLYPIjK64w/KmDU8ofjjFtq87qrJYCJ3zJBaxzdNz4hezItfBClpgMH2QTjwCFe8+Grr68RqHOreKlrcSpgYjyUkLHCcAEESeybZJ8MAVhX/MTZi62eVqa73TtXmi2cVV8tDUdXhlTJtaSFBwlC4zUIzeN7Swxu+CaujIFKbEVlxfY8i0YpIeWi9KxEDr8gr1keKUPPv9Vo74sUff/UOWsoD6Ok9Pns9y+yIi5tEyur3/AB8kO208nHQGPWJVC4yleYkVPfiENG+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tO7GDRY2U3uvpaqhcosC9SNjelzDMHBPuhdAWI2kBe8=;
 b=SzHBoD70EBFwDOsSI/wb3QowlJSXHvVey/SCc1t80o42yZOiEmVbMzRqqp9UpzEB648et8jdak0nj/WZ9SMasOW6SIyBVVhb1dvUCAN/PHIH0vLWOO6NoynrVH696ATE6ZnyHbt4btt782gc9p6DICpytqLNuSFQSGzi5StbIazyjm/PDqOSK2ME9w99lxJPizyvLBel339TTeiVKckUPwvqpHMbGoGggTOLewS5H8jJXqxEW6VyM6c9NUIlEmrNY0lsDvCvfjTeFDbOmywzJoqN7HcGrC/74CaBCVWHBGYbeRkEh1PYLp3ZcqeKvc4oWf/w78vFKJ5tkptJgAHXug==
Received: from MW4PR04CA0318.namprd04.prod.outlook.com (2603:10b6:303:82::23)
 by SJ1PR12MB6241.namprd12.prod.outlook.com (2603:10b6:a03:458::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.24; Sun, 22 Sep
 2024 12:50:44 +0000
Received: from CO1PEPF000075ED.namprd03.prod.outlook.com
 (2603:10b6:303:82:cafe::f9) by MW4PR04CA0318.outlook.office365.com
 (2603:10b6:303:82::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24 via Frontend
 Transport; Sun, 22 Sep 2024 12:50:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1PEPF000075ED.mail.protection.outlook.com (10.167.249.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 22 Sep 2024 12:50:44 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 22 Sep
 2024 05:50:32 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 22 Sep 2024 05:50:31 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sun, 22 Sep 2024 05:50:31 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <nouveau@lists.freedesktop.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 19/29] vfio/vgpu_mgr: introdcue vGPU lifecycle management prelude
Date: Sun, 22 Sep 2024 05:49:41 -0700
Message-ID: <20240922124951.1946072-20-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240922124951.1946072-1-zhiw@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075ED:EE_|SJ1PR12MB6241:EE_
X-MS-Office365-Filtering-Correlation-Id: 848d5c2d-f920-449d-8b3c-08dcdb052c24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y2ZteTA4ZnllZ2g1Uk01cDdMUng1NTlnMHNVZ2JMV3BwQTJjOFkzbzA1VGs0?=
 =?utf-8?B?dUlZRmR0SFdQMDRVUGNLZ1ZaeVpaL1Ard2trN0pUemxFMmROckVtWWtFd1dD?=
 =?utf-8?B?WlRPR2c1SDF4SXhaNkFMTEQrMVpES3kwS0Q1MUw0aGEyQnl4UGtzeWUyNEhJ?=
 =?utf-8?B?cVRYZ1F2RDQ4ZHozMk9NOW5SL2MxV09TcVp5aVVxN0x5MjJBVkxGa0tUOFha?=
 =?utf-8?B?Y2ViUUpnN1UxVlgvT0pDc3VQS2ZJTU1QYUYvb25yaTI5SldYc0V0RnB2cG9n?=
 =?utf-8?B?aU04bStKQXp5R2ltTDc5MVVnSzVzRWJpSHN4T1E5YjE1VlRab2tGQy9zeTA1?=
 =?utf-8?B?dURFUWxHV0x3VHVSTWtrcHQxSHNtckN0ckdYemI0L0FEd3Nid0lpRTU0WFFh?=
 =?utf-8?B?ZkZucVVNK3VCV2x6S0NWYWxUSURiN3hDWWhIeTZOWXVjV3pOSDM2M0tUVVVp?=
 =?utf-8?B?eVRoaStKTkt6Q1dsYlVpVm45ajNWNEZ2TU5iczFzVkJDbjYrelNSRmVuWkNy?=
 =?utf-8?B?RitQWGFiR2Q1d04xZXA4ZVpUTzJ5cnN3VHBZZk1kUU1UNnhyd0ZCTXRvQ2ZE?=
 =?utf-8?B?c1BsbzhyNVVJODBtSFdIQVVtWmVrQ3haZDQ3ZStsNjV1ZUNMelNrYkZVRXZj?=
 =?utf-8?B?M0pMWXpKNk8yR1F4MVR3MEg5TkhNd2JsUnJlS1BONExFQ210ZHBVdHF4N0xy?=
 =?utf-8?B?dnkzUjZOeVFwMkszUjRkQ21Mbjk2aC9qakNpRkFpWTRyYWRueTcwbnhFN0Fw?=
 =?utf-8?B?U2xMLzZzYU5ndzlqUDNuNldiMWpSYlVlNzNWZ2I2cU55V04wbGRvRXdBSngy?=
 =?utf-8?B?RnFOZGV2WGU4T3k4czQ2SXMrNThEa0RLSmt0aDJPTDg4NGVBSFJMb3JwL1Zz?=
 =?utf-8?B?Y2hPTGl6NFMxUWJjYnpWQkdHMWplcDVEWTlsRXlGRlRsVzRzaVRjVExyVHlW?=
 =?utf-8?B?MlVac21PZjh3ZnFyV0xUaXBrT2YzZmZFTHlqOUo3ZWl2cVBFcTQvSzBOSm05?=
 =?utf-8?B?WkpnUUVtemE0Z1RVdWdMUVAwVzNXL0FPSHIyMnZudnRmZ0VLUVViOHY2Q0xz?=
 =?utf-8?B?WStlMkFtazFiTjJLYVh2WGVDOWhwaGJmMzNWbWIraVRjMUxTaEF2c09nUzdZ?=
 =?utf-8?B?YzBaTjlReDJnVkFBcWNzWm5HY1JhdUhoTkY5YU9lSnY0N0pvUWVPK2sra3Bj?=
 =?utf-8?B?aVFFQldSMjFyM0s0M1d5UTJuVWtkMjNCWkE3M2cxZFdnanl5NEFCU1hyVnRP?=
 =?utf-8?B?U1JoSEpZemRZR1gxOE1vUy9WL2JtNWVaVlAxZ3RQY1g4Qkg1c01qZmJ0cG41?=
 =?utf-8?B?RWZ3a3cxWTdTODRQVkZGdDhVNExIcnZrVDJtM3RQSENsak5OaXY0bHdzVDZa?=
 =?utf-8?B?S2RHL29ybWlUb0R6S1JUbVdMVit5MzN0NzAzckxiTWxTWFdWSVVSMElSaUxl?=
 =?utf-8?B?SW1LY053a0lzSnFPNnZvOXRzWHRKbHpMYSt1WlFqaWpsbGhrakFrbWRvUENS?=
 =?utf-8?B?aVJuczhpMUdlZWVuV24yNDJQSVZ6RExJQnBQMjlzMDc0U0xMTDVxdWt2VnJw?=
 =?utf-8?B?b1dZbUFjMnE4K2QxZWZaTmhRcEVGemExTGZiRG1MSVA0OCtMeStRR28xbSt2?=
 =?utf-8?B?Ui9pazN5OWFPYm5TZlFqeHlJckZqSjBKWlRabHByR0cxeDVuRy92b0k1azFL?=
 =?utf-8?B?OGJPcjZCKzc2TS9iR213UlFseTRocFljT2lNalFCd0V0ZWNMVkJLdGV5Njln?=
 =?utf-8?B?c1lKSDBpRk8xNGxOVFNHVjNjRHZJV0ZOMXJkWHU1REg4WHc5eWZVT3VzejBk?=
 =?utf-8?B?SUVOYU1Oako5M3ZkWGlqQjJXaGFIWEI2dlZjNGFEU1IrUzNyUzgvWjI0SWJw?=
 =?utf-8?Q?n6UzCwFQbTUnr?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 12:50:44.0897
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 848d5c2d-f920-449d-8b3c-08dcdb052c24
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075ED.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6241

To introduce the routines when creating a vGPU one by one in the
following patches, first, introduce the prelude of the vGPU lifecycle
management as the skeleton.

Introduce NVIDIA vGPU manager core module that hosting the vGPU lifecycle
managemement data structures and routines.

Cc: Neo Jia <cjia@nvidia.com>
Cc: Surath Mitra <smitra@nvidia.com>
Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/Kconfig                |  2 +
 drivers/vfio/pci/Makefile               |  2 +
 drivers/vfio/pci/nvidia-vgpu/Kconfig    | 13 ++++
 drivers/vfio/pci/nvidia-vgpu/Makefile   |  3 +
 drivers/vfio/pci/nvidia-vgpu/nvkm.h     | 46 ++++++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu.c     | 83 +++++++++++++++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c | 99 +++++++++++++++++++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h | 43 +++++++++++
 8 files changed, 291 insertions(+)
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/Kconfig
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/Makefile
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/nvkm.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vgpu.c
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 15821a2d77d2..4b42378afc1a 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -69,4 +69,6 @@ source "drivers/vfio/pci/virtio/Kconfig"
 
 source "drivers/vfio/pci/nvgrace-gpu/Kconfig"
 
+source "drivers/vfio/pci/nvidia-vgpu/Kconfig"
+
 endmenu
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index ce7a61f1d912..88f722c5c161 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -17,3 +17,5 @@ obj-$(CONFIG_PDS_VFIO_PCI) += pds/
 obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio/
 
 obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) += nvgrace-gpu/
+
+obj-$(CONFIG_NVIDIA_VGPU_VFIO_PCI) += nvidia-vgpu/
diff --git a/drivers/vfio/pci/nvidia-vgpu/Kconfig b/drivers/vfio/pci/nvidia-vgpu/Kconfig
new file mode 100644
index 000000000000..a9b28e944902
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/Kconfig
@@ -0,0 +1,13 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config NVIDIA_VGPU_MGR
+	tristate
+
+config NVIDIA_VGPU_VFIO_PCI
+	tristate "VFIO support for the NVIDIA vGPU"
+	select NVIDIA_VGPU_MGR
+	select VFIO_PCI_CORE
+	help
+	  VFIO support for the NVIDIA vGPU is required to assign the vGPU
+	  to userspace using KVM/qemu/etc.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/pci/nvidia-vgpu/Makefile b/drivers/vfio/pci/nvidia-vgpu/Makefile
new file mode 100644
index 000000000000..1d2c0eb1fa5c
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_NVIDIA_VGPU_MGR) += nvidia-vgpu-mgr.o
+nvidia-vgpu-mgr-y := vgpu_mgr.o vgpu.o
diff --git a/drivers/vfio/pci/nvidia-vgpu/nvkm.h b/drivers/vfio/pci/nvidia-vgpu/nvkm.h
new file mode 100644
index 000000000000..4c75431ee1f6
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/nvkm.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/*
+ * Copyright © 2024 NVIDIA Corporation
+ */
+#ifndef __NVIDIA_VGPU_MGR_NVKM_H__
+#define __NVIDIA_VGPU_MGR_NVKM_H__
+
+#include <linux/pci.h>
+#include <drm/nvkm_vgpu_mgr_vfio.h>
+
+struct nvidia_vgpu_mgr_handle {
+	void *pf_drvdata;
+	struct nvkm_vgpu_mgr_vfio_ops *ops;
+	struct nvidia_vgpu_vfio_handle_data data;
+};
+
+static inline int nvidia_vgpu_mgr_get_handle(struct pci_dev *pdev,
+		struct nvidia_vgpu_mgr_handle *h)
+{
+	struct pci_dev *pf_dev;
+
+	if (!pdev->is_virtfn)
+		return -EINVAL;
+
+	pf_dev = pdev->physfn;
+
+	if (strcmp(pf_dev->driver->name, "nvkm"))
+		return -EINVAL;
+
+	h->pf_drvdata = pci_get_drvdata(pf_dev);
+	h->ops = nvkm_vgpu_mgr_get_vfio_ops(h->pf_drvdata);
+	h->ops->get_handle(h->pf_drvdata, &h->data);
+
+	return 0;
+}
+
+#define nvidia_vgpu_mgr_support_is_enabled(h) \
+	(h).ops->vgpu_mgr_is_enabled((h).pf_drvdata)
+
+#define nvidia_vgpu_mgr_attach_handle(h) \
+	(h)->ops->attach_handle((h)->pf_drvdata, &(h)->data)
+
+#define nvidia_vgpu_mgr_detach_handle(h) \
+	(h)->ops->detach_handle((h)->pf_drvdata)
+
+#endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu.c b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
new file mode 100644
index 000000000000..34f6adb9dfe4
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
@@ -0,0 +1,83 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/*
+ * Copyright © 2024 NVIDIA Corporation
+ */
+
+#include "vgpu_mgr.h"
+
+static void unregister_vgpu(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+
+	mutex_lock(&vgpu_mgr->vgpu_id_lock);
+
+	vgpu_mgr->vgpus[vgpu->info.id] = NULL;
+	atomic_dec(&vgpu_mgr->num_vgpus);
+
+	mutex_unlock(&vgpu_mgr->vgpu_id_lock);
+}
+
+static int register_vgpu(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+
+	mutex_lock(&vgpu_mgr->vgpu_id_lock);
+
+	if (vgpu_mgr->vgpus[vgpu->info.id]) {
+		mutex_unlock(&vgpu_mgr->vgpu_id_lock);
+		return -EBUSY;
+	}
+	vgpu_mgr->vgpus[vgpu->info.id] = vgpu;
+	atomic_inc(&vgpu_mgr->num_vgpus);
+
+	mutex_unlock(&vgpu_mgr->vgpu_id_lock);
+	return 0;
+}
+
+/**
+ * nvidia_vgpu_mgr_destroy_vgpu - destroy a vGPU instance
+ * @vgpu: the vGPU instance going to be destroyed.
+ *
+ * Returns: 0 on success, others on failure.
+ */
+int nvidia_vgpu_mgr_destroy_vgpu(struct nvidia_vgpu *vgpu)
+{
+	if (!atomic_cmpxchg(&vgpu->status, 1, 0))
+		return -ENODEV;
+
+	unregister_vgpu(vgpu);
+	return 0;
+}
+EXPORT_SYMBOL(nvidia_vgpu_mgr_destroy_vgpu);
+
+/**
+ * nvidia_vgpu_mgr_create_vgpu - create a vGPU instance
+ * @vgpu: the vGPU instance going to be created.
+ * @vgpu_type: the vGPU type of the vGPU instance.
+ *
+ * The caller must initialize vgpu->vgpu_mgr, gpu->info, vgpu->pdev.
+ *
+ * Returns: 0 on success, others on failure.
+ */
+int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu, u8 *vgpu_type)
+{
+	int ret;
+
+	if (WARN_ON(vgpu->info.id >= NVIDIA_MAX_VGPUS))
+		return -EINVAL;
+
+	if (WARN_ON(!vgpu->vgpu_mgr || !vgpu->info.gfid || !vgpu->info.dbdf))
+		return -EINVAL;
+
+	mutex_init(&vgpu->lock);
+	vgpu->vgpu_type = vgpu_type;
+
+	ret = register_vgpu(vgpu);
+	if (ret)
+		return ret;
+
+	atomic_set(&vgpu->status, 1);
+
+	return 0;
+}
+EXPORT_SYMBOL(nvidia_vgpu_mgr_create_vgpu);
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
new file mode 100644
index 000000000000..dc2a73f95650
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
@@ -0,0 +1,99 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/*
+ * Copyright © 2024 NVIDIA Corporation
+ */
+
+#include "vgpu_mgr.h"
+
+DEFINE_MUTEX(vgpu_mgr_attach_lock);
+
+static void vgpu_mgr_release(struct kref *kref)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr =
+		container_of(kref, struct nvidia_vgpu_mgr, refcount);
+
+	nvidia_vgpu_mgr_detach_handle(&vgpu_mgr->handle);
+	kvfree(vgpu_mgr);
+}
+
+/**
+ * nvidia_vgpu_mgr_put - put the vGPU manager
+ * @vgpu: the vGPU manager to put.
+ *
+ */
+void nvidia_vgpu_mgr_put(struct nvidia_vgpu_mgr *vgpu_mgr)
+{
+	if (!nvidia_vgpu_mgr_support_is_enabled(vgpu_mgr->handle))
+		return;
+
+	mutex_lock(&vgpu_mgr_attach_lock);
+	kref_put(&vgpu_mgr->refcount, vgpu_mgr_release);
+	mutex_unlock(&vgpu_mgr_attach_lock);
+}
+EXPORT_SYMBOL(nvidia_vgpu_mgr_put);
+
+/**
+ * nvidia_vgpu_mgr_get - get the vGPU manager
+ * @dev: the VF pci_dev.
+ *
+ * Returns: pointer to vgpu_mgr on success, IS_ERR() on failure.
+ */
+struct nvidia_vgpu_mgr *nvidia_vgpu_mgr_get(struct pci_dev *dev)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr;
+	struct nvidia_vgpu_mgr_handle handle;
+	int ret;
+
+	mutex_lock(&vgpu_mgr_attach_lock);
+
+	memset(&handle, 0, sizeof(handle));
+
+	ret = nvidia_vgpu_mgr_get_handle(dev, &handle);
+	if (ret) {
+		mutex_unlock(&vgpu_mgr_attach_lock);
+		return ERR_PTR(ret);
+	}
+
+	if (!nvidia_vgpu_mgr_support_is_enabled(handle)) {
+		mutex_unlock(&vgpu_mgr_attach_lock);
+		return ERR_PTR(-ENODEV);
+	}
+
+	if (handle.data.priv) {
+		vgpu_mgr = handle.data.priv;
+		kref_get(&vgpu_mgr->refcount);
+		mutex_unlock(&vgpu_mgr_attach_lock);
+		return vgpu_mgr;
+	}
+
+	vgpu_mgr = kvzalloc(sizeof(*vgpu_mgr), GFP_KERNEL);
+	if (!vgpu_mgr) {
+		ret = -ENOMEM;
+		goto fail_alloc_vgpu_mgr;
+	}
+
+	vgpu_mgr->handle = handle;
+	vgpu_mgr->handle.data.priv = vgpu_mgr;
+
+	ret = nvidia_vgpu_mgr_attach_handle(&handle);
+	if (ret)
+		goto fail_attach_handle;
+
+	kref_init(&vgpu_mgr->refcount);
+	mutex_init(&vgpu_mgr->vgpu_id_lock);
+
+	mutex_unlock(&vgpu_mgr_attach_lock);
+	return vgpu_mgr;
+
+fail_attach_handle:
+	kvfree(vgpu_mgr);
+fail_alloc_vgpu_mgr:
+	mutex_unlock(&vgpu_mgr_attach_lock);
+	vgpu_mgr = ERR_PTR(ret);
+	return vgpu_mgr;
+}
+EXPORT_SYMBOL(nvidia_vgpu_mgr_get);
+
+MODULE_LICENSE("Dual MIT/GPL");
+MODULE_AUTHOR("Zhi Wang <zhiw@nvidia.com>");
+MODULE_DESCRIPTION("NVIDIA VGPU manager - core module to support VFIO PCI driver for NVIDIA vGPU");
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
new file mode 100644
index 000000000000..2efd96644098
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/*
+ * Copyright © 2024 NVIDIA Corporation
+ */
+#ifndef __NVIDIA_VGPU_MGR_H__
+#define __NVIDIA_VGPU_MGR_H__
+
+#include "nvkm.h"
+
+#define NVIDIA_MAX_VGPUS 2
+
+struct nvidia_vgpu_info {
+	int id;
+	u32 gfid;
+	u32 dbdf;
+};
+
+struct nvidia_vgpu {
+	struct mutex lock;
+	atomic_t status;
+	struct pci_dev *pdev;
+
+	u8 *vgpu_type;
+	struct nvidia_vgpu_info info;
+	struct nvidia_vgpu_mgr *vgpu_mgr;
+};
+
+struct nvidia_vgpu_mgr {
+	struct kref refcount;
+	struct nvidia_vgpu_mgr_handle handle;
+
+	struct mutex vgpu_id_lock;
+	struct nvidia_vgpu *vgpus[NVIDIA_MAX_VGPUS];
+	atomic_t num_vgpus;
+};
+
+struct nvidia_vgpu_mgr *nvidia_vgpu_mgr_get(struct pci_dev *dev);
+void nvidia_vgpu_mgr_put(struct nvidia_vgpu_mgr *vgpu_mgr);
+
+int nvidia_vgpu_mgr_destroy_vgpu(struct nvidia_vgpu *vgpu);
+int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu, u8 *vgpu_type);
+
+#endif
-- 
2.34.1


