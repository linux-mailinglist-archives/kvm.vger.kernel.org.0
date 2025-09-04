Return-Path: <kvm+bounces-56731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DBE6B430E0
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:10:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C3F2202019
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 04:10:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6326E26A0E0;
	Thu,  4 Sep 2025 04:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kWTkzlQ2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313DB23815C;
	Thu,  4 Sep 2025 04:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756958928; cv=fail; b=bFw36U3CXzYIuyYCeI0ajbeOnjmJj4KcWOTkh4NNO5WAxdaaLwscNJmMKZz/eCxeoSCAco3GQGtUmyZnh5jvRKvOM3O4jPOpipCszh/pjkqQFTbNAuaL4q/VY4w15boAc3C+u/b3LSscQ40bhdgcMbO6I7hKvVYHL6QiRQRAe6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756958928; c=relaxed/simple;
	bh=666Q32X7I9ZKmI6dIKXmgjwWwveBIi1IP3cFIRfuwfU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gHZKo6wb0o99uAIWqA7SWEt+D9oLHH3q1R8GI9V3ThhSS2ATu0dH/OLD6HEwjZtU1JhvgtgoPVyskfrNObD3OYs6mMwsPdPdAWXS5/YlLRjNXeakbqwqpw+ABQv4IOgNd65eS2sd5Q3SETPxbDJonqhqvTcogLyYAzCCPIwAh0M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kWTkzlQ2; arc=fail smtp.client-ip=40.107.244.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L9ydYLXHTAeUb59Phu2IQs5LGel2GQYD6hnBaGnuhD2YESMALEou9XUXrTypLXbXp0BzuzT+dxZ3sfDPEcqnEhjwxfvuX6Pzk+dr3skOknw1kmhf603TzL/I2kwR9BKQoKgfJkT9xTiKIF4oTs0lyhOMo0Kx/xAQOGCj5uuS23Rri5NXii8JRFPIpIkLjO9hxfxQ3D8zmRUzUH6U00zj7xaM24AvRje6mzQQv8OOuxRFtTihQGPUYwxaLDxPpn9IfN8Y+eM3FGK052DgHcwPfIlSZ+BmYpvxfk9s0zT6WNTwQlp7+n89itm0tPtfdpIKMwek4lMLIkNg7LI3pZuhDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PbolfrunMHeC6TYEJqZsnaqMg4ZrwH+CCYtdr2nFAsk=;
 b=yL/ZPupP7fxW24zY0WFDs/gUmhVU3c3IftW2TP2G/WwBO8awFewOAdOwlLCffUaWfaaNcLulJwMhzSht5xdy0XqJKQTGfO3L1hH6tm05y2ynzt8gpxMxS+xH6Xr1952fLva6yawxHbx3Djm9hDAeI5dTzLKkUutx0XzWVL2wf5cGRsLO5QDfHlEhXNvAWJjM5ac2mtWxGRqpflXQSaek02OMYIwxbZDnzFGBfW6IECOdGu2Ywqdqn8GyXQx5U5rzBPHBSzamgEDhoLcGUuNQcf4HjM3fbICKk8PvyIDokrbNJYK6IqY11kkreSreOpsnHMlJZsfrkmI/bb8w7tF+ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PbolfrunMHeC6TYEJqZsnaqMg4ZrwH+CCYtdr2nFAsk=;
 b=kWTkzlQ2Y/PNsHcstzMbUX4N1qQ2UPThWS8NiPMt05oiP9hhg3SBuNxR4ixebkREGmXdVreTg5odxcMBoA56bZy2v+IQBa9Uh+wiuwG6b6Qi4sOi4pduzG78EC6ie+DgK8i4WvUXYC831w8hQFr6Gqk03sI7DhzghgjDdhbL3/ILlxOxIK9N1u5zFP2ffactK7qizBX3ZVLOEyJXz0Pynpl59rzezIStsCvMaNzTHHDbWwBRBJH6GadjsojhmgiVq+AKFMa7N9dUcovySa4mYhUrsmPkaI0wAl2hgtJtTKPPFlffqGZYnMs4ZlvSKTlyIpGi2fZ/HW3l84d+JnU8eQ==
Received: from SA9PR13CA0145.namprd13.prod.outlook.com (2603:10b6:806:27::30)
 by MN2PR12MB4421.namprd12.prod.outlook.com (2603:10b6:208:26c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Thu, 4 Sep
 2025 04:08:39 +0000
Received: from SN1PEPF0002529D.namprd05.prod.outlook.com
 (2603:10b6:806:27:cafe::44) by SA9PR13CA0145.outlook.office365.com
 (2603:10b6:806:27::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.12 via Frontend Transport; Thu,
 4 Sep 2025 04:08:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF0002529D.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Thu, 4 Sep 2025 04:08:39 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 21:08:31 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 3 Sep 2025 21:08:31 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 21:08:31 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <skolothumtho@nvidia.com>, <kevin.tian@intel.com>,
	<yi.l.liu@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kjaju@nvidia.com>,
	<dnigam@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC 05/14] vfio/nvgrace-egm: Introduce module to manage EGM
Date: Thu, 4 Sep 2025 04:08:19 +0000
Message-ID: <20250904040828.319452-6-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250904040828.319452-1-ankita@nvidia.com>
References: <20250904040828.319452-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529D:EE_|MN2PR12MB4421:EE_
X-MS-Office365-Filtering-Correlation-Id: 1254e421-24ef-4206-7b6e-08ddeb68ba87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5VMO9Ioo1eZlon+0n/4VBKS3CRghnuPs0L9jSEIvNDXjGTsikI7h/op9syMw?=
 =?us-ascii?Q?wIFlbMNL2BfW06r1NXd5PYYNL/OaXYNgDoZedc/WLZinDKlYe7W+JfnP4yzK?=
 =?us-ascii?Q?AMJEjlF8AYvVF8wHkEM/lEUFKwrh1tHEJKf+Dmt4eeZTT6UfJrjF7+6Ql0PV?=
 =?us-ascii?Q?J3/PNISmkE7YltFez7NHoKoDN7kCaAQTTTFI0jkN73Bn60TwPzGA4dfw7J0Z?=
 =?us-ascii?Q?rDJoSHwBGjxcCe5vnHW8gz8tYVelQx5/XSSxlfOwICDPR4KFQFTcLgqdUlkI?=
 =?us-ascii?Q?bLpV+TUR/B4NvVN3l4O95XdA3FJx9qcdF2Huh6Ppc6/VKAbk5ZKak57mkMlR?=
 =?us-ascii?Q?jt8yeDfirftB+QgD6s3Czrai5EkW5nfsJSpQWGXnEP9sBDmmOcozMYOTVoP2?=
 =?us-ascii?Q?LFk8i6ReYO+9Q8KwgdnOxebPENGY7dVryN7ZfJQ+QduZ96NOrfB2mB/waG+r?=
 =?us-ascii?Q?L4BynfVLZBpQl78E3DFf/og+xi9/LtGZ1cMJp1HYKJYZs2Wgw3TeqlOIfWLc?=
 =?us-ascii?Q?f8ASM5WnjiiVP+6MU18BQ+jJeeddzZvovjDKW2Er1aVO60eBVICjW3U4Hfch?=
 =?us-ascii?Q?irTFa1veSfSzJvuTc7vk3I68Z92sdvLLGeEIJJTEwVkIFIPk9LXmKQT8AX5q?=
 =?us-ascii?Q?Jv/fhOWnJRlDPshRJzVWqggV5F+Qirf476M0WG6R4DNAO6Ecw8JZrhwTiD0U?=
 =?us-ascii?Q?ujiulE5s6xmMiMQ9Ty5p5LQSP/KIk9nl+eJiV6XveZ+jPyIrUvpzPNJTVjP4?=
 =?us-ascii?Q?mRTA2h8WzZYiGLb2ehohhlrMYix2sMR1yRENjgeSwgvqFu3Vfhba/JGKP0If?=
 =?us-ascii?Q?Gc3MPPSObuiTsqbfO9Ma+Y9tXoXfHZWafGarteHgJ+N8pJhCmSzXMAmIK9ob?=
 =?us-ascii?Q?lEM2ah264jMbjjStDI6hoWTYTgATot6v3DF3JKLKefBcVE9NaArv53BzDsKj?=
 =?us-ascii?Q?KRT9ZzE8lqFci0sFQn2aN6tEWC78EBLmBX6wKCCg/8ACYKgwBWquXT28F2eu?=
 =?us-ascii?Q?9wB+CwqJ4zwSqItliJozsBjVBP9MCEBpjBxmto7pi0OW6KUogP5z+QFPhymL?=
 =?us-ascii?Q?Fmmy6WAjsm23ObgVbBwBwPj7LLW0wosHGGHnLvDusYA/ayHPXqePWmf6LSOu?=
 =?us-ascii?Q?aQ0jjPaREEWMPqgRU1dEQ1FNJDLEtvociCz5h4Nn7UGrJAb3fqglUBpFhb56?=
 =?us-ascii?Q?fRjwgIjTbThSJEEsnC8Az/Dw3hjgWPPeqzLSSxqgCI8wUSg5XMwM3xlWGOsI?=
 =?us-ascii?Q?VCesa8YBcrci5YXDgbNCoQtB5ssCFcUHyOLzbhzGdcAoE5gls3tYlkt6T/fR?=
 =?us-ascii?Q?RjrMaqbLulZUfVKObhVG8SchebS57x1hz5gAjxXHIoqZucT1YhYE+j4gF7AN?=
 =?us-ascii?Q?xvEma585eggPivH8u94hWTrb6myMNuVV7FkMMpjrHC+jwq3TfygW3gfkRSrs?=
 =?us-ascii?Q?UOvVDSx3GqZYSlVUeKQwpsGzSBZbJ2w35e4AQ+5tYpQgA2Chg5f/wU6uovEj?=
 =?us-ascii?Q?x0IYx5ND81NJRsL1kVkLeJ2PzdxZSrZm5PA3?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 04:08:39.3707
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1254e421-24ef-4206-7b6e-08ddeb68ba87
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4421

From: Ankit Agrawal <ankita@nvidia.com>

The Extended GPU Memory (EGM) feature that enables the GPU to access
the system memory allocations within and across nodes through high
bandwidth path on Grace Based systems. The GPU can utilize the
system memory located on the same socket or from a different socket
or even on a different node in a multi-node system [1].

When the EGM mode is enabled through SBIOS, the host system memory is
partitioned into 2 parts: One partition for the Host OS usage
called Hypervisor region, and a second Hypervisor-Invisible (HI) region
for the VM. Only the hypervisor region is part of the host EFI map
and is thus visible to the host OS on bootup. Since the entire VM
sysmem is eligible for EGM allocations within the VM, the HI partition
is interchangeably called as EGM region in the series. This HI/EGM region
range base SPA and size is exposed through the ACPI DSDT properties.

Whilst the EGM region is accessible on the host, it is not added to
the kernel. The HI region is assigned to a VM by mapping the QEMU VMA
to the SPA using remap_pfn_range().

The following figure shows the memory map in the virtualization
environment.

|---- Sysmem ----|                  |--- GPU mem ---|  VM Memory
|                |                  |               |
|IPA <-> SPA map |                  |IPA <-> SPA map|
|                |                  |               |
|--- HI / EGM ---|-- Host Mem --|   |--- GPU mem ---|  Host Memory

Introduce a new nvgrace-egm auxiliary driver module to manage and
map the HI/EGM region in the Grace Blackwell systems. This binds to
the auxiliary device created by the parent nvgrace-gpu (in-tree
module for device assignment) / nvidia-vgpu-vfio (out-of-tree open
source module for SRIOV vGPU) to manage the EGM region for the VM.
Note that there is a unique EGM region per socket and the auxiliary
device gets created for every region. The parent module fetches the
EGM region information from the ACPI tables and populate to the data
structures shared with the auxiliary nvgrace-egm module.

nvgrace-egm module handles the following:
1. Fetch the EGM memory properties (base HPA, length, proximity domain)
from the parent device shared EGM region structure.
2. Create a char device that can be used as memory-backend-file by Qemu
for the VM and implement file operations. The char device is /dev/egmX,
where X is the PXM node ID of the EGM being mapped fetched in 1.
3. Zero the EGM memory on first device open().
4. Map the QEMU VMA to the EGM region using remap_pfn_range.
5. Cleaning up state and destroying the chardev on device unbind.
6. Handle presence of retired ECC pages on the EGM region.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 MAINTAINERS                           |  6 ++++++
 drivers/vfio/pci/nvgrace-gpu/Kconfig  | 11 +++++++++++
 drivers/vfio/pci/nvgrace-gpu/Makefile |  3 +++
 drivers/vfio/pci/nvgrace-gpu/egm.c    | 22 ++++++++++++++++++++++
 drivers/vfio/pci/nvgrace-gpu/main.c   |  1 +
 5 files changed, 43 insertions(+)
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/egm.c

diff --git a/MAINTAINERS b/MAINTAINERS
index dd7df834b70b..ec6bc10f346d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26476,6 +26476,12 @@ F:	drivers/vfio/pci/nvgrace-gpu/egm_dev.h
 F:	drivers/vfio/pci/nvgrace-gpu/main.c
 F:	include/linux/nvgrace-egm.h
 
+VFIO NVIDIA GRACE EGM DRIVER
+M:	Ankit Agrawal <ankita@nvidia.com>
+L:	kvm@vger.kernel.org
+S:	Supported
+F:	drivers/vfio/pci/nvgrace-gpu/egm.c
+
 VFIO PCI DEVICE SPECIFIC DRIVERS
 R:	Jason Gunthorpe <jgg@nvidia.com>
 R:	Yishai Hadas <yishaih@nvidia.com>
diff --git a/drivers/vfio/pci/nvgrace-gpu/Kconfig b/drivers/vfio/pci/nvgrace-gpu/Kconfig
index a7f624b37e41..d5773bbd22f5 100644
--- a/drivers/vfio/pci/nvgrace-gpu/Kconfig
+++ b/drivers/vfio/pci/nvgrace-gpu/Kconfig
@@ -1,8 +1,19 @@
 # SPDX-License-Identifier: GPL-2.0-only
+config NVGRACE_EGM
+	tristate "EGM driver for NVIDIA Grace Hopper and Blackwell Superchip"
+	depends on ARM64 || (COMPILE_TEST && 64BIT)
+	help
+	  Extended GPU Memory (EGM) support for the GPU in the NVIDIA Grace
+	  based chips required to avail the CPU memory as additional
+	  cross-node/cross-socket memory for GPU using KVM/qemu.
+
+	  If you don't know what to do here, say N.
+
 config NVGRACE_GPU_VFIO_PCI
 	tristate "VFIO support for the GPU in the NVIDIA Grace Hopper Superchip"
 	depends on ARM64 || (COMPILE_TEST && 64BIT)
 	select VFIO_PCI_CORE
+	select NVGRACE_EGM
 	help
 	  VFIO support for the GPU in the NVIDIA Grace Hopper Superchip is
 	  required to assign the GPU device to userspace using KVM/qemu/etc.
diff --git a/drivers/vfio/pci/nvgrace-gpu/Makefile b/drivers/vfio/pci/nvgrace-gpu/Makefile
index e72cc6739ef8..d0d191be56b9 100644
--- a/drivers/vfio/pci/nvgrace-gpu/Makefile
+++ b/drivers/vfio/pci/nvgrace-gpu/Makefile
@@ -1,3 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) += nvgrace-gpu-vfio-pci.o
 nvgrace-gpu-vfio-pci-y := main.o egm_dev.o
+
+obj-$(CONFIG_NVGRACE_EGM) += nvgrace-egm.o
+nvgrace-egm-y := egm.o
diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
new file mode 100644
index 000000000000..999808807019
--- /dev/null
+++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include <linux/vfio_pci_core.h>
+
+static int __init nvgrace_egm_init(void)
+{
+	return 0;
+}
+
+static void __exit nvgrace_egm_cleanup(void)
+{
+}
+
+module_init(nvgrace_egm_init);
+module_exit(nvgrace_egm_cleanup);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Ankit Agrawal <ankita@nvidia.com>");
+MODULE_DESCRIPTION("NVGRACE EGM - Module to support Extended GPU Memory on NVIDIA Grace Based systems");
diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 7486a1b49275..b1ccd1ac2e0a 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -1125,3 +1125,4 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ankit Agrawal <ankita@nvidia.com>");
 MODULE_AUTHOR("Aniket Agashe <aniketa@nvidia.com>");
 MODULE_DESCRIPTION("VFIO NVGRACE GPU PF - User Level driver for NVIDIA devices with CPU coherently accessible device memory");
+MODULE_SOFTDEP("pre: nvgrace-egm");
-- 
2.34.1


