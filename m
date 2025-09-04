Return-Path: <kvm+bounces-56730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CEBFB430DE
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:10:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E61717B8A7
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 04:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C222261B64;
	Thu,  4 Sep 2025 04:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OlgmxosW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2047.outbound.protection.outlook.com [40.107.96.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6041E244670;
	Thu,  4 Sep 2025 04:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756958927; cv=fail; b=ALKXexUETWjdP4MmK6FHz1M31l/AzT7/7Ku7cW9yiRm5VcfHXGpJGBSo17pzUCv2rT0GbggpyBItFpWJ56ZZ1rt/43L2VpqmyQbdMeMSbvbDHqq1tlwaLy3tqsDbHE7XjaDFho7ltKSyyNiq+0SelssoWrg4HVrjpYKOGCiRAIM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756958927; c=relaxed/simple;
	bh=k/jIZGT0gXqIAL5ya1yb6yqw/TdBwp/5NP38RWjkOZs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bqU38ohYPjWbnpKtofhLEhE8NsvYxfDaXqMMdtYUCqXzANeZnohLBD/nml0AKSbEAh9R/3xc6nhX6PwA7IHWd8AivCQ4sivs2s1fg1YO2FPxwFtYiRZgmXBMhHUVO+edUHp7TEz0m9HyUYzfnsaPPOd6d9yXgAGPPUJSzqO/A1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OlgmxosW; arc=fail smtp.client-ip=40.107.96.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iq5/RGhHuWYU7unXJxJx7aFA95Yq5ZIFTBHvQo2Qr4fSgKfoJgBnDUh20XQhS2DCWR1cv8nEE8s4a5XP06dI8NZdFBs0exWQrl1ZB0v6LX8NBfXiHskYrgcupDFkTnEI7iTtIbeAkST5b5N9Z7ObGXuVcn8W4XXYgJXFt6ygGYk81KRKw0K0GmU/Qhfe+ooz53/e5WAo3mr0ZGlcCbessg/jFYgK1n7+P38u/4Mq6BkT88iMkC6T3A9W6XnOQehoOQgdH52KoYYgPk8Zgl+Uj+5AchtZ2PQd6GS79F/ELHVwjoN34oFqvYdyPgwfxRuGFbpJonhQS0qnpKfPpeMMDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k1q8yXmp5JWASwLYDzw6tAMWeF+Njs0I2/7BTicMu+M=;
 b=UbPYZf4FvhnhKv6LWC1MqXgnIDmQEwKhXt9pyuel86Hwbc5VpIr5ax6hfHFXAjvt68RgF+Vdhy5HNvT2ah00vzzugowM8QljyPitnIcS94mdqpBJ8uPJGZApqKElhK1g0lyOq85Foa5dQthMeQFmEp5dUHAeq7dFGFW7thi3Fe/MRngM6FhhH0nm7V4lzrUBBM0uk47tWY7QYrzMiqNqA450J/kYUV4CFXeLxgMarMUhLWAfVslE+sd5sPz+NIGOEtRdvU1MYTryP+NaNEA2V/KGbCE/De6GKQS1obTrOvboSSPluSx00k0rpvjHS2SGuQwn5Wx690O9miI7uSppfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1q8yXmp5JWASwLYDzw6tAMWeF+Njs0I2/7BTicMu+M=;
 b=OlgmxosW2HWrO2MBKQlV82g9QjjGA3wysdRLGbKaMbROeZ7kFJCMXuVkHRJnSGoOjzkrkwJ+1OQ2siKJcMfDRtfrC5K4iEP+WJ1pXfWbpiul4HIIOUWHnQ9PUguEtTRndNyMH9t43R4egHcZ9zvX4MPj5gvlnG+SOdxhFQAHTF45+/f3cD1/4yr2nNA8p9zaz0MKY6dAWBf6vfw4/yIyF+4Ww54NxlKimbmt2Lo9VKbY8WIXuLL147hM7a6bc0s7F0sY8YvHmoQIl9u1Lz1ySVwUA1xe++NiZeCQxao3vCGl/shppZ0zNO1ebPyCw4svsdDsaMV03HB2tbKtiKVVhg==
Received: from SA1PR03CA0024.namprd03.prod.outlook.com (2603:10b6:806:2d3::25)
 by IA1PR12MB6164.namprd12.prod.outlook.com (2603:10b6:208:3e8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Thu, 4 Sep
 2025 04:08:36 +0000
Received: from SN1PEPF000252A2.namprd05.prod.outlook.com
 (2603:10b6:806:2d3:cafe::45) by SA1PR03CA0024.outlook.office365.com
 (2603:10b6:806:2d3::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.17 via Frontend Transport; Thu,
 4 Sep 2025 04:08:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF000252A2.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Thu, 4 Sep 2025 04:08:36 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 21:08:30 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 3 Sep 2025 21:08:29 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 21:08:29 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <skolothumtho@nvidia.com>, <kevin.tian@intel.com>,
	<yi.l.liu@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kjaju@nvidia.com>,
	<dnigam@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC 02/14] vfio/nvgrace-gpu: Create auxiliary device for EGM
Date: Thu, 4 Sep 2025 04:08:16 +0000
Message-ID: <20250904040828.319452-3-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A2:EE_|IA1PR12MB6164:EE_
X-MS-Office365-Filtering-Correlation-Id: ea42bfd9-6e0a-4eb9-32c9-08ddeb68b8ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?99/Jh1Q1QOD3oX7YCO/KaypqhQE1ldUY60n8lnAoRPD21z10oPeemwcm37Y+?=
 =?us-ascii?Q?Mco9l5IuF+uh8FY+pwzm40ZUoyEIfK52WFicI3usae5RT6qk/s+tb/H42w5Z?=
 =?us-ascii?Q?ZnWtf87qqz28o+BwRDfOlpKAWdyqbTLRD5JSdKOTLlR0V9DxDCSGa+LjBpWz?=
 =?us-ascii?Q?wyOL9B3TikAibCkAhnkXDbDc370nOqeo3c/xLCknRyPohe9lScyxkw6Yu7It?=
 =?us-ascii?Q?QnH+v7C/xlbG/0Ot4hIBCAEq184mGp1IlHB4PC90uZuaOeoGEpFUFLetgGs3?=
 =?us-ascii?Q?FLpiVEq/TFUFUd7Mr8TMowbrT4HAS4bLDZaFg9bIXQfMhE1dod23Irck2cMR?=
 =?us-ascii?Q?V8R+DJj3bg1uG/0nkN1sMs67Dq2AFmxl1LAeJs81U4oVHhjfcsnD+iIQi7zY?=
 =?us-ascii?Q?xKRu7gJQmGjMZUdjsPaLQGTsszQH7Spk+dVxdESCvs6N+LU33pSJuWu5UMVO?=
 =?us-ascii?Q?Urua5/jKNxChlg7kVUoSkz5WCnUKeiCJz96ww+6b79W3rqFQ9rm0QFWuxpuv?=
 =?us-ascii?Q?w5avPKl0hGWbjo4xblH/GbRgHg1HI6Lj4QAqgSEWSGHex0Ixx4v0HnC62RFK?=
 =?us-ascii?Q?4XnXQa/z8pYqijOtccdjxV9Xj7imYcpZBgf3Ni5zJZQ1RbtOqEA6c+scIUfb?=
 =?us-ascii?Q?C/5xOC/shdpIXO+boBYDqHARug46D/J7oyTPl1TgTyQ/sr3cEXE+wQsSfJEV?=
 =?us-ascii?Q?TXRqs+wUcFBgVVXfeR8bgvQsFS8ou3OOBPuhJWeA2ABY1kevghwFrVTP1Ik9?=
 =?us-ascii?Q?tmp/nmbPD3W5/uB5u8GSW3ZQFF/Qxt1d77fSfgfog12kHYiR5ijNxRMckCVO?=
 =?us-ascii?Q?EqVwGDIHNvMN7dqbwPEcsOdO2kU0eLeuG6oB3OlR6gpTpLT6DZX8HKiNtbPG?=
 =?us-ascii?Q?ks4ufbo6KR2vBzAGIRjK/OobI72ZT/VjAAsnd95wSeT6lcMCaLPqYIPakNax?=
 =?us-ascii?Q?Lj527/BxpgzufIPDGRxJMQLlJEqz731OkU0V+mEiOWYj4NTXXjH6PA7Ke+Gg?=
 =?us-ascii?Q?ayLRjMAxrZWruN4WfmY053+3xPA5CudGlaNAxFEPuOvZFBUMWdCkhHfSdyEO?=
 =?us-ascii?Q?InVT2Y5yTD4rOcGHIrNKx8I3GVwBIvyVJeYF9v5xTTaRcr6ig1JqHh58J++U?=
 =?us-ascii?Q?5v4syD/xr3UXV2tn9dno1gROlcKfSM7VJP/jH5mahfxsZtCjwC5NYTeWXHXw?=
 =?us-ascii?Q?loT2XiR2LCpqw3rJ6azOTEtDIJhLb5Gw1fkvUY1Ne+1LsfSzcc++09MD6ZcU?=
 =?us-ascii?Q?584JS/G8qMVDuSv7QfUG7VY/c0O/P7aaQG9qK0dpXPqxo1l3xamSy8IHDONb?=
 =?us-ascii?Q?+9z1kux4tOLeruh++967OjoHya9iVFYVFI7bF/FOGAYcw9E11qYaFHjmEIJZ?=
 =?us-ascii?Q?BfGnEb8UngkNRn+LKS5lyyX+QR0GFWo6dvdCvjqnS1NoXzg9F+Ko4sHy73T6?=
 =?us-ascii?Q?3fByLVDh6th9neiuy18gBb+dBBlCqsNTlZyYjqt9MJvgVCxNugesG9v5naVA?=
 =?us-ascii?Q?xDhDvu119bHLx5mQq2Qb3cbdH0uvS0lFfQR9?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 04:08:36.2794
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea42bfd9-6e0a-4eb9-32c9-08ddeb68b8ae
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6164

From: Ankit Agrawal <ankita@nvidia.com>

The Extended GPU Memory (EGM) feature enables the GPU access to
the system memory across sockets and physical systems on the
Grace Hopper and Grace Blackwell systems. When the feature is
enabled through SBIOS, part of the system memory is made available
to the GPU for access through EGM path.

The EGM functionality is separate and largely independent from the
core GPU device functionality. However, the EGM region information
of base SPA and size is associated with the GPU on the ACPI tables.
An architecture wih EGM represented as an auxiliary device suits well
in this context.

The parent GPU device creates an EGM auxiliary device to be managed
independently by an auxiliary EGM driver. The EGM region information
is kept as part of the shared struct nvgrace_egm_dev along with the
auxiliary device handle.

Each socket has a separate EGM region and hence a multi-socket system
have multiple EGM regions. Each EGM region has a separate nvgrace_egm_dev
and the nvgrace-gpu keeps the EGM regions as part of a list.

Note that EGM is an optional feature enabled through SBIOS. The EGM
properties are only populated in ACPI tables if the feature is enabled;
they are absent otherwise. The absence of the properties is thus not
considered fatal. The presence of improper set of values however are
considered fatal.

It is also noteworthy that there may also be multiple GPUs present per
socket and have duplicate EGM region information with them. Make sure
the duplicate data does not get added.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 MAINTAINERS                            |  5 +-
 drivers/vfio/pci/nvgrace-gpu/Makefile  |  2 +-
 drivers/vfio/pci/nvgrace-gpu/egm_dev.c | 61 ++++++++++++++++++++++
 drivers/vfio/pci/nvgrace-gpu/egm_dev.h | 17 +++++++
 drivers/vfio/pci/nvgrace-gpu/main.c    | 70 +++++++++++++++++++++++++-
 include/linux/nvgrace-egm.h            | 23 +++++++++
 6 files changed, 175 insertions(+), 3 deletions(-)
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/egm_dev.c
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/egm_dev.h
 create mode 100644 include/linux/nvgrace-egm.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 6dcfbd11efef..dd7df834b70b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26471,7 +26471,10 @@ VFIO NVIDIA GRACE GPU DRIVER
 M:	Ankit Agrawal <ankita@nvidia.com>
 L:	kvm@vger.kernel.org
 S:	Supported
-F:	drivers/vfio/pci/nvgrace-gpu/
+F:	drivers/vfio/pci/nvgrace-gpu/egm_dev.c
+F:	drivers/vfio/pci/nvgrace-gpu/egm_dev.h
+F:	drivers/vfio/pci/nvgrace-gpu/main.c
+F:	include/linux/nvgrace-egm.h
 
 VFIO PCI DEVICE SPECIFIC DRIVERS
 R:	Jason Gunthorpe <jgg@nvidia.com>
diff --git a/drivers/vfio/pci/nvgrace-gpu/Makefile b/drivers/vfio/pci/nvgrace-gpu/Makefile
index 3ca8c187897a..e72cc6739ef8 100644
--- a/drivers/vfio/pci/nvgrace-gpu/Makefile
+++ b/drivers/vfio/pci/nvgrace-gpu/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) += nvgrace-gpu-vfio-pci.o
-nvgrace-gpu-vfio-pci-y := main.o
+nvgrace-gpu-vfio-pci-y := main.o egm_dev.o
diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
new file mode 100644
index 000000000000..f4e27dadf1ef
--- /dev/null
+++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include <linux/vfio_pci_core.h>
+#include "egm_dev.h"
+
+/*
+ * Determine if the EGM feature is enabled. If disabled, there
+ * will be no EGM properties populated in the ACPI tables and this
+ * fetch would fail.
+ */
+int nvgrace_gpu_has_egm_property(struct pci_dev *pdev, u64 *pegmpxm)
+{
+	return device_property_read_u64(&pdev->dev, "nvidia,egm-pxm",
+					pegmpxm);
+}
+
+static void nvgrace_gpu_release_aux_device(struct device *device)
+{
+	struct auxiliary_device *aux_dev = container_of(device, struct auxiliary_device, dev);
+	struct nvgrace_egm_dev *egm_dev = container_of(aux_dev, struct nvgrace_egm_dev, aux_dev);
+
+	kvfree(egm_dev);
+}
+
+struct nvgrace_egm_dev *
+nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
+			      u64 egmpxm)
+{
+	struct nvgrace_egm_dev *egm_dev;
+	int ret;
+
+	egm_dev = kvzalloc(sizeof(*egm_dev), GFP_KERNEL);
+	if (!egm_dev)
+		goto create_err;
+
+	egm_dev->egmpxm = egmpxm;
+	egm_dev->aux_dev.id = egmpxm;
+	egm_dev->aux_dev.name = name;
+	egm_dev->aux_dev.dev.release = nvgrace_gpu_release_aux_device;
+	egm_dev->aux_dev.dev.parent = &pdev->dev;
+
+	ret = auxiliary_device_init(&egm_dev->aux_dev);
+	if (ret)
+		goto free_dev;
+
+	ret = auxiliary_device_add(&egm_dev->aux_dev);
+	if (ret) {
+		auxiliary_device_uninit(&egm_dev->aux_dev);
+		goto create_err;
+	}
+
+	return egm_dev;
+
+free_dev:
+	kvfree(egm_dev);
+create_err:
+	return NULL;
+}
diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
new file mode 100644
index 000000000000..c00f5288f4e7
--- /dev/null
+++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#ifndef EGM_DEV_H
+#define EGM_DEV_H
+
+#include <linux/nvgrace-egm.h>
+
+int nvgrace_gpu_has_egm_property(struct pci_dev *pdev, u64 *pegmpxm);
+
+struct nvgrace_egm_dev *
+nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
+			      u64 egmphys);
+
+#endif /* EGM_DEV_H */
diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 72e7ac1fa309..2cf851492990 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -7,6 +7,8 @@
 #include <linux/vfio_pci_core.h>
 #include <linux/delay.h>
 #include <linux/jiffies.h>
+#include <linux/nvgrace-egm.h>
+#include "egm_dev.h"
 
 /*
  * The device memory usable to the workloads running in the VM is cached
@@ -60,6 +62,63 @@ struct nvgrace_gpu_pci_core_device {
 	bool has_mig_hw_bug;
 };
 
+static struct list_head egm_dev_list;
+
+static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
+{
+	struct nvgrace_egm_dev_entry *egm_entry;
+	u64 egmpxm;
+	int ret = 0;
+
+	/*
+	 * EGM is an optional feature enabled in SBIOS. If disabled, there
+	 * will be no EGM properties populated in the ACPI tables and this
+	 * fetch would fail. Treat this failure as non-fatal and return
+	 * early.
+	 */
+	if (nvgrace_gpu_has_egm_property(pdev, &egmpxm))
+		goto exit;
+
+	egm_entry = kvzalloc(sizeof(*egm_entry), GFP_KERNEL);
+	if (!egm_entry)
+		return -ENOMEM;
+
+	egm_entry->egm_dev =
+		nvgrace_gpu_create_aux_device(pdev, NVGRACE_EGM_DEV_NAME,
+					      egmpxm);
+	if (!egm_entry->egm_dev) {
+		kvfree(egm_entry);
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	list_add_tail(&egm_entry->list, &egm_dev_list);
+
+exit:
+	return ret;
+}
+
+static void nvgrace_gpu_destroy_egm_aux_device(struct pci_dev *pdev)
+{
+	struct nvgrace_egm_dev_entry *egm_entry, *temp_egm_entry;
+	u64 egmpxm;
+
+	if (nvgrace_gpu_has_egm_property(pdev, &egmpxm))
+		return;
+
+	list_for_each_entry_safe(egm_entry, temp_egm_entry, &egm_dev_list, list) {
+		/*
+		 * Free the EGM region corresponding to the input GPU
+		 * device.
+		 */
+		if (egm_entry->egm_dev->egmpxm == egmpxm) {
+			auxiliary_device_destroy(&egm_entry->egm_dev->aux_dev);
+			list_del(&egm_entry->list);
+			kvfree(egm_entry);
+		}
+	}
+}
+
 static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
 {
 	struct nvgrace_gpu_pci_core_device *nvdev =
@@ -965,14 +1024,20 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
 						    memphys, memlength);
 		if (ret)
 			goto out_put_vdev;
+
+		ret = nvgrace_gpu_create_egm_aux_device(pdev);
+		if (ret)
+			goto out_put_vdev;
 	}
 
 	ret = vfio_pci_core_register_device(&nvdev->core_device);
 	if (ret)
-		goto out_put_vdev;
+		goto out_reg;
 
 	return ret;
 
+out_reg:
+	nvgrace_gpu_destroy_egm_aux_device(pdev);
 out_put_vdev:
 	vfio_put_device(&nvdev->core_device.vdev);
 	return ret;
@@ -982,6 +1047,7 @@ static void nvgrace_gpu_remove(struct pci_dev *pdev)
 {
 	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
 
+	nvgrace_gpu_destroy_egm_aux_device(pdev);
 	vfio_pci_core_unregister_device(core_device);
 	vfio_put_device(&core_device->vdev);
 }
@@ -1011,6 +1077,8 @@ static struct pci_driver nvgrace_gpu_vfio_pci_driver = {
 
 static int __init nvgrace_gpu_vfio_pci_init(void)
 {
+	INIT_LIST_HEAD(&egm_dev_list);
+
 	return pci_register_driver(&nvgrace_gpu_vfio_pci_driver);
 }
 module_init(nvgrace_gpu_vfio_pci_init);
diff --git a/include/linux/nvgrace-egm.h b/include/linux/nvgrace-egm.h
new file mode 100644
index 000000000000..9575d4ad4338
--- /dev/null
+++ b/include/linux/nvgrace-egm.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#ifndef NVGRACE_EGM_H
+#define NVGRACE_EGM_H
+
+#include <linux/auxiliary_bus.h>
+
+#define NVGRACE_EGM_DEV_NAME "egm"
+
+struct nvgrace_egm_dev {
+	struct auxiliary_device aux_dev;
+	u64 egmpxm;
+};
+
+struct nvgrace_egm_dev_entry {
+	struct list_head list;
+	struct nvgrace_egm_dev *egm_dev;
+};
+
+#endif /* NVGRACE_EGM_H */
-- 
2.34.1


