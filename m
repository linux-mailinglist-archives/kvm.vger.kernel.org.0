Return-Path: <kvm+bounces-27226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B886397DA97
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 00:36:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E18FC1C2113D
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 22:36:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E03B018DF89;
	Fri, 20 Sep 2024 22:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ThDQ4eQz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2049.outbound.protection.outlook.com [40.107.93.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBDC18DF69;
	Fri, 20 Sep 2024 22:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726871720; cv=fail; b=tJSie1R74yeZBqKxvLpZHmrjepLYce+cm48D4iNfcqRY58C4Fp4HPZAs3UMYSj/XlFWxExwjrD/L29uLIlSPLCAXe/XZshIlkJUHQnB6FjLPj4z0hMMuocO1vcmHhrrYNahH+/I18k6IimcWz6UjkA1fODYDX3Pqu/X6XDGi/iw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726871720; c=relaxed/simple;
	bh=M0tXuuOTUmKtr2slj/gpiKooYt/SGRosLgIydmlyDj8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I/gX/NU2utoaxldwvSK3VwI8x52KqJBHv+pIVsdqbclfwd2bIJnDW+6/XT9DRcy/6Dx1PFBnfVPV1XCaCjMN1I0SXO/TC/tpjqnl5UtwjTsLid83qMfwayenqdTQDCZEJQ9IBTWnfkZ/dnvtdPN+8GSfMlqLJMoKOBHhI4/H8Y4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ThDQ4eQz; arc=fail smtp.client-ip=40.107.93.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cBhR1zL/Ah9Hnoqcvp4XLne+0esJCDd+NY0axjVHZUbesOAJjin6zUKEhSWQpBR1cp6H3svYjyO1rliankZcRDC20o7PZ853if4srHwi3VBbfW5TKPwjkgxzntZRUsI+SCAx42pugnT50+tb0oTBg4NN2V94ha+lX82OCNBhgEoaj2rdjNLOERnKb6YEsKGNif/doNl2argwexbdlFvAg/WkiVWD8ylZBjjqt1JAegl2LLiVjO6NXAE2DXZpphpOoheAJDu3gvCe/s1PZc9rk72CLZ4DJWtFAloypNYtMX82kwsyW2TXnYiHC9q2vUDu2kpTqL1BYzKi1V1zs6P3BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=63p5Sd9Na6a/+HKoJ0aa+fo4s9+yuIokVvxgLmpdMoE=;
 b=Se+DpEKpqd54tF+EsXkeg9RamkEhf+i9Kd+gKUs9SyJd6AipvZwz/SsO7as+n2pjkJzIzDn/rw0w5npXTTLU1g4IUhA6Cdf3cI+kfZu84XwW2gIYZ0WdScwliUGQ0c5TXpeIPWijMwbL4xn9wrEym/qRoAynIyoo9saHj33FwccGgT01FrfTg8aBQlMDVsTh/TSmdHFIAGp+efzAmF6F7KKe5ZVkGv7qDKzUY845FFmP8tTJH/w8Xklg3tm+BXNUXxpespPcOVJ51I7EA0BHQ71YVijxX0OeRjuehk7qPjwenKTElXsg3Pm2fa7BDa5tluR6hmVUZv7bLKf/u/9cog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63p5Sd9Na6a/+HKoJ0aa+fo4s9+yuIokVvxgLmpdMoE=;
 b=ThDQ4eQzjcR7d5XnRupbEF7y9GMIgvRTvNTlt+f/XCsCQkHymthNxNmU7B5xvoieMt7vDn68jQbjVwZQ52MAqfV5FEleE4bCqZm1RzJJ6K+zhisUepPS5d4pemJP3Lj3K0wu7VKJMM8USsaK/CGRRjlx0gGg/Gb/ZCpSZ1ek/pdcuHIm/yv2XW7TMO4FYSib7my/AEouc6gxqvAyjruIO2lbvWT+LDpZXv0RzO08+yek5arI+W3wZcjqklhmt1a17yl7/IAApsgrgNmn70eDc868v6RL0iIVlMqYDnXsoRt9Q2etW2XibLW/b6T7zqjneVc+2+y788koYyLWT0p9bw==
Received: from SJ0PR13CA0192.namprd13.prod.outlook.com (2603:10b6:a03:2c3::17)
 by SA1PR12MB6701.namprd12.prod.outlook.com (2603:10b6:806:251::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.30; Fri, 20 Sep
 2024 22:35:11 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::c0) by SJ0PR13CA0192.outlook.office365.com
 (2603:10b6:a03:2c3::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24 via Frontend
 Transport; Fri, 20 Sep 2024 22:35:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9D4.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 20 Sep 2024 22:35:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:34:56 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:34:56 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 20 Sep 2024 15:34:55 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <linux-cxl@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<alison.schofield@intel.com>, <dan.j.williams@intel.com>,
	<dave.jiang@intel.com>, <dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<ira.weiny@intel.com>, <vishal.l.verma@intel.com>, <alucerop@amd.com>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 04/13] vfio: introduce vfio-cxl core preludes
Date: Fri, 20 Sep 2024 15:34:37 -0700
Message-ID: <20240920223446.1908673-5-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|SA1PR12MB6701:EE_
X-MS-Office365-Filtering-Correlation-Id: 75265c47-9c5b-484d-8164-08dcd9c47c51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iFBjKkZd6o5JqNHk5v0VgtrygibBG5kDUOIy8XTUhIXGavpH/e1PBlRg73ts?=
 =?us-ascii?Q?QNZbqELq84b1wr3135+hfOWiYNN5pSH8OrGVKrkw8Omwnon971H1pqoJxQjz?=
 =?us-ascii?Q?fjVuMc1LIUv1t6QkVaBz3P2B/zZQHuWR0ds1LRUxWHB8L1Vh3zS3L4owdayy?=
 =?us-ascii?Q?OVZf5IwMHlGQKZcH0NX2t740OT/rjybIiy5t3SmXOf0OwKlCkpwkTI5lAOXl?=
 =?us-ascii?Q?Z/KlVQmn5ztOq8+hYxnIgKF3vJnYU1q80QI5XdNgg4GfBYnNP/zmR3V+Ulf3?=
 =?us-ascii?Q?1FPpzmyoYH6IpZ3jPuyzCUTVrVAh9Z8H0OU4rBABCnbiGlDt+JFu4uduvQ57?=
 =?us-ascii?Q?6nVn8YHrIwVVahy3OSNkkcFMQyrPJ2BVFCbCUDlEcIilG7OST/OVSoyKJTGZ?=
 =?us-ascii?Q?pvHEF36FZFCUBoCaIz9bWAxfqBtjZXDDLXSJ4PnFZJxYkcGnqutCrzKmnFMr?=
 =?us-ascii?Q?jMDicEQLwfUIMUjxq2ai4CPZzwwWe96dSRn3WbZ7i0rc4Ju5ih67Izm4xU1V?=
 =?us-ascii?Q?ctobvR8hFd2F3BMiMFCkF1NZIjkp9eGK3/1x71Wz7JRKweEwsPi68AfvE6MW?=
 =?us-ascii?Q?j+zqLQ0b6fcd86XeYTGvN/LGBR362HiwXt2px8wKnM1OUV1SE7dxTdOI5px8?=
 =?us-ascii?Q?Ds8NiKocA75AVKxneTzWiFX5v9+oFBbVCPuJy9KoGgc0TDdhNJDoVUk8KOmn?=
 =?us-ascii?Q?XPyyEaruXWUymx3PYBnRurflcQ+9bWZFo414UZNRur79oRfsinC8m3ciOwRf?=
 =?us-ascii?Q?h6yjFrjuWsSB2PyXJuqX886/oSpldiIFBO2jRSRHByxriuRJ8nb2IxzB7jEk?=
 =?us-ascii?Q?LNt9jmDguT0CPCiOaDqrLCJMnHbkGxowVoJZXHgfWsTUUBh1081RbumZt1pW?=
 =?us-ascii?Q?ZzyCjQPgBfWaXBMuCd7evWyzFMLMc4pR6xiSqtoiFX5HoyabpHWi9zuU9WbX?=
 =?us-ascii?Q?QeFdns/r45G38aAG8OMUerysgX5JPF/MI7WuKqi9zbuURo122LCQpI0wEsp7?=
 =?us-ascii?Q?DX2Ggu+pbuQpkMac40hl46Mu/el88v3UtOV3cdjhjG8JnL+qqsn/0NoCLQ/K?=
 =?us-ascii?Q?E5yh/kaLss9h8+PujCMgxGLVAvvbQ/BzGLaj8ZzZQvGPD/TxtjvGTtLsb8lh?=
 =?us-ascii?Q?DdG7vn3+9TuPiC0XAIN75Umyu6opjqPTlQhybmlGf90ie+LUCI+yyDD7qS+s?=
 =?us-ascii?Q?U81TUy2eLhmQuOMy0SR0SiIYgbXaZZveg6y8NkejO0wQxJ4MRniQf6iUwdlE?=
 =?us-ascii?Q?3gG+oXQ67v+opugZkwpKzDziOmv/NPRvj7YjmhbkXl7VGAiXTDB+cY8xhm1M?=
 =?us-ascii?Q?O5RgX27YmWFr+dPe4g+nmdZb4DjoFHbfGrpdEKv0hqO2wZf073R//pQ9XbYz?=
 =?us-ascii?Q?wmn5BLsBUC9sYrtb1AVUv686r3xtcAQ4dVzrVCu9RKntc5CYm8jpHtysGPfq?=
 =?us-ascii?Q?bwsVRgU9C5q8M5u4WUvk6s6MOIdVVpry?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2024 22:35:10.0895
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75265c47-9c5b-484d-8164-08dcd9c47c51
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6701

In VFIO, common functions that used by VFIO variant drivers are managed
in a set of "core" functions. E.g. the vfio-pci-core provides the common
functions used by VFIO variant drviers to support PCI device
passhthrough.

Although the CXL type-2 device has a PCI-compatible interface for device
configuration and programming, they still needs special handlings when
initialize the device:

- Probing the CXL DVSECs in the configuration.
- Probing the CXL register groups implemented by the device.
- Configuring the CXL device state required by the kernel CXL core.
- Create the CXL region.
- Special handlings of the CXL MMIO BAR.

Introduce vfio-cxl core predules to hold all the common functions used
by VFIO variant drivers to support CXL device passthrough.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/Kconfig         |   4 +
 drivers/vfio/pci/Makefile        |   3 +
 drivers/vfio/pci/vfio_cxl_core.c | 264 +++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    |  37 +++++
 4 files changed, 308 insertions(+)
 create mode 100644 drivers/vfio/pci/vfio_cxl_core.c

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index bf50ffa10bde..2196e79b132b 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -7,6 +7,10 @@ config VFIO_PCI_CORE
 	select VFIO_VIRQFD
 	select IRQ_BYPASS_MANAGER
 
+config VFIO_CXL_CORE
+	tristate
+	select VFIO_PCI_CORE
+
 config VFIO_PCI_MMAP
 	def_bool y if !S390
 	depends on VFIO_PCI_CORE
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index cf00c0a7e55c..b51221b94b0b 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -8,6 +8,9 @@ vfio-pci-y := vfio_pci.o
 vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
 
+vfio-cxl-core-y := vfio_cxl_core.o
+obj-$(CONFIG_VFIO_CXL_CORE) += vfio-cxl-core.o
+
 obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
 
 obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
diff --git a/drivers/vfio/pci/vfio_cxl_core.c b/drivers/vfio/pci/vfio_cxl_core.c
new file mode 100644
index 000000000000..6a7859333f67
--- /dev/null
+++ b/drivers/vfio/pci/vfio_cxl_core.c
@@ -0,0 +1,264 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES. All rights reserved
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
+#include <linux/pci.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+
+#include "vfio_pci_priv.h"
+
+#define DRIVER_AUTHOR "Zhi Wang <zhiw@nvidia.com>"
+#define DRIVER_DESC "core driver for VFIO based CXL devices"
+
+static int get_hpa_and_request_dpa(struct vfio_pci_core_device *core_dev)
+{
+	struct vfio_cxl *cxl = &core_dev->cxl;
+	struct pci_dev *pdev = core_dev->pdev;
+	u64 max;
+
+	cxl->cxlrd = cxl_get_hpa_freespace(cxl->endpoint, 1,
+					   CXL_DECODER_F_RAM |
+					   CXL_DECODER_F_TYPE2,
+					   &max);
+	if (IS_ERR(cxl->cxlrd)) {
+		pci_err(pdev, "Fail to get HPA space.\n");
+		return PTR_ERR(cxl->cxlrd);
+	}
+
+	if (max < cxl->region.size) {
+		pci_err(pdev, "No enough free HPA space %llu < %llu\n",
+			max, cxl->region.size);
+		return -ENOSPC;
+	}
+
+	cxl->cxled = cxl_request_dpa(cxl->endpoint, true, cxl->region.size,
+				     cxl->region.size);
+	if (IS_ERR(cxl->cxled)) {
+		pci_err(pdev, "Fail to request DPA\n");
+		return PTR_ERR(cxl->cxled);
+	}
+
+	return 0;
+}
+
+static int create_cxl_region(struct vfio_pci_core_device *core_dev)
+{
+	struct vfio_cxl *cxl = &core_dev->cxl;
+	struct pci_dev *pdev = core_dev->pdev;
+	resource_size_t start, end;
+	int ret;
+
+	ret = cxl_accel_request_resource(cxl->cxlds, true);
+	if (ret) {
+		pci_err(pdev, "Fail to request CXL resource\n");
+		return ret;
+	}
+
+	if (!cxl_await_media_ready(cxl->cxlds)) {
+		cxl_accel_set_media_ready(cxl->cxlds);
+	} else {
+		pci_err(pdev, "CXL media is not active\n");
+		return ret;
+	}
+
+	cxl->cxlmd = devm_cxl_add_memdev(&pdev->dev, cxl->cxlds);
+	if (IS_ERR(cxl->cxlmd)) {
+		pci_err(pdev, "Fail to create CXL memdev\n");
+		return PTR_ERR(cxl->cxlmd);
+	}
+
+	cxl->endpoint = cxl_acquire_endpoint(cxl->cxlmd);
+	if (IS_ERR(cxl->endpoint)) {
+		pci_err(pdev, "Fail to acquire CXL endpoint\n");
+		return PTR_ERR(cxl->endpoint);
+	}
+
+	ret = get_hpa_and_request_dpa(core_dev);
+	if (ret)
+		goto out;
+
+	cxl->region.region = cxl_create_region(cxl->cxlrd, &cxl->cxled, 1);
+	if (IS_ERR(cxl->region.region)) {
+		ret = PTR_ERR(cxl->region.region);
+		pci_err(pdev, "Fail to create CXL region\n");
+		cxl_dpa_free(cxl->cxled);
+		goto out;
+	}
+
+	cxl_accel_get_region_params(cxl->region.region, &start, &end);
+
+	cxl->region.addr = start;
+out:
+	cxl_release_endpoint(cxl->cxlmd, cxl->endpoint);
+	return ret;
+}
+
+/* Standard CXL-type 2 driver initialization sequence */
+static int enable_cxl(struct vfio_pci_core_device *core_dev, u16 dvsec)
+{
+	struct vfio_cxl *cxl = &core_dev->cxl;
+	struct pci_dev *pdev = core_dev->pdev;
+	u32 count;
+	u64 offset, size;
+	int ret;
+
+	cxl->cxlds = cxl_accel_state_create(&pdev->dev, cxl->caps);
+	if (IS_ERR(cxl->cxlds))
+		return PTR_ERR(cxl->cxlds);
+
+	cxl_accel_set_dvsec(cxl->cxlds, dvsec);
+	cxl_accel_set_serial(cxl->cxlds, pdev->dev.id);
+
+	cxl_accel_set_resource(cxl->cxlds, cxl->dpa_res, CXL_ACCEL_RES_DPA);
+	cxl_accel_set_resource(cxl->cxlds, cxl->ram_res, CXL_ACCEL_RES_RAM);
+
+	ret = cxl_pci_accel_setup_regs(pdev, cxl->cxlds);
+	if (ret) {
+		pci_err(pdev, "Fail to setup CXL accel regs\n");
+		return ret;
+	}
+
+	ret = cxl_get_hdm_info(cxl->cxlds, &count, &offset, &size);
+	if (ret)
+		return ret;
+
+	if (!count || !size) {
+		pci_err(pdev, "Fail to find CXL HDM reg offset\n");
+		return -ENODEV;
+	}
+
+	cxl->hdm_count = count;
+	cxl->hdm_reg_offset = offset;
+	cxl->hdm_reg_size = size;
+
+	return create_cxl_region(core_dev);
+}
+
+static void disable_cxl(struct vfio_pci_core_device *core_dev)
+{
+	struct vfio_cxl *cxl = &core_dev->cxl;
+
+	if (cxl->region.region)
+		cxl_region_detach(cxl->cxled);
+
+	if (cxl->cxled)
+		cxl_dpa_free(cxl->cxled);
+}
+
+int vfio_cxl_core_enable(struct vfio_pci_core_device *core_dev)
+{
+	struct vfio_cxl *cxl = &core_dev->cxl;
+	struct pci_dev *pdev = core_dev->pdev;
+	u16 dvsec;
+	int ret;
+
+	dvsec = pci_find_dvsec_capability(pdev, PCI_VENDOR_ID_CXL,
+					  CXL_DVSEC_PCIE_DEVICE);
+	if (!dvsec)
+		return -ENODEV;
+
+	if (!cxl->region.size)
+		return -EINVAL;
+
+	ret = vfio_pci_core_enable(core_dev);
+	if (ret)
+		return ret;
+
+	ret = enable_cxl(core_dev, dvsec);
+	if (ret)
+		goto err_enable_cxl_device;
+
+	return 0;
+
+err_enable_cxl_device:
+	vfio_pci_core_disable(core_dev);
+	return ret;
+}
+EXPORT_SYMBOL(vfio_cxl_core_enable);
+
+void vfio_cxl_core_finish_enable(struct vfio_pci_core_device *core_dev)
+{
+	vfio_pci_core_finish_enable(core_dev);
+}
+EXPORT_SYMBOL(vfio_cxl_core_finish_enable);
+
+void vfio_cxl_core_close_device(struct vfio_device *vdev)
+{
+	struct vfio_pci_core_device *core_dev =
+		container_of(vdev, struct vfio_pci_core_device, vdev);
+
+	disable_cxl(core_dev);
+	vfio_pci_core_close_device(vdev);
+}
+EXPORT_SYMBOL(vfio_cxl_core_close_device);
+
+/*
+ * Configure the resource required by the kernel CXL core:
+ * device DPA and device RAM size
+ */
+void vfio_cxl_core_set_resource(struct vfio_pci_core_device *core_dev,
+				struct resource res,
+				enum accel_resource type)
+{
+	struct vfio_cxl *cxl = &core_dev->cxl;
+
+	switch (type) {
+	case CXL_ACCEL_RES_DPA:
+		cxl->dpa_size = res.end - res.start + 1;
+		cxl->dpa_res = res;
+		break;
+
+	case CXL_ACCEL_RES_RAM:
+		cxl->ram_res = res;
+		break;
+
+	default:
+		WARN(1, "invalid resource type: %d\n", type);
+		break;
+	}
+}
+EXPORT_SYMBOL(vfio_cxl_core_set_resource);
+
+/* Configure the expected CXL region size to be created */
+void vfio_cxl_core_set_region_size(struct vfio_pci_core_device *core_dev,
+				   u64 size)
+{
+	struct vfio_cxl *cxl = &core_dev->cxl;
+
+	if (WARN_ON(size > cxl->dpa_size))
+		return;
+
+	if (WARN_ON(cxl->region.region))
+		return;
+
+	cxl->region.size = size;
+}
+EXPORT_SYMBOL(vfio_cxl_core_set_region_size);
+
+/* Configure the driver cap required by the kernel CXL core */
+void vfio_cxl_core_set_driver_hdm_cap(struct vfio_pci_core_device *core_dev)
+{
+	struct vfio_cxl *cxl = &core_dev->cxl;
+
+	cxl->caps |= CXL_ACCEL_DRIVER_CAP_HDM;
+}
+EXPORT_SYMBOL(vfio_cxl_core_set_driver_hdm_cap);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_IMPORT_NS(CXL);
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index fbb472dd99b3..7762d4a3e825 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -15,6 +15,8 @@
 #include <linux/types.h>
 #include <linux/uuid.h>
 #include <linux/notifier.h>
+#include <linux/cxl_accel_mem.h>
+#include <linux/cxl_accel_pci.h>
 
 #ifndef VFIO_PCI_CORE_H
 #define VFIO_PCI_CORE_H
@@ -49,6 +51,31 @@ struct vfio_pci_region {
 	u32				flags;
 };
 
+struct vfio_cxl_region {
+	u64 size;
+	u64 addr;
+	struct cxl_region *region;
+};
+
+struct vfio_cxl {
+	u8 caps;
+	u64 dpa_size;
+
+	u32 hdm_count;
+	u64 hdm_reg_offset;
+	u64 hdm_reg_size;
+
+	struct cxl_dev_state *cxlds;
+	struct cxl_memdev *cxlmd;
+	struct cxl_root_decoder *cxlrd;
+	struct cxl_port *endpoint;
+	struct cxl_endpoint_decoder *cxled;
+	struct resource dpa_res;
+	struct resource ram_res;
+
+	struct vfio_cxl_region region;
+};
+
 struct vfio_pci_core_device {
 	struct vfio_device	vdev;
 	struct pci_dev		*pdev;
@@ -94,6 +121,7 @@ struct vfio_pci_core_device {
 	struct vfio_pci_core_device	*sriov_pf_core_dev;
 	struct notifier_block	nb;
 	struct rw_semaphore	memory_lock;
+	struct vfio_cxl		cxl;
 };
 
 /* Will be exported for vfio pci drivers usage */
@@ -159,4 +187,13 @@ VFIO_IOREAD_DECLARATION(32)
 VFIO_IOREAD_DECLARATION(64)
 #endif
 
+int vfio_cxl_core_enable(struct vfio_pci_core_device *core_dev);
+void vfio_cxl_core_finish_enable(struct vfio_pci_core_device *core_dev);
+void vfio_cxl_core_close_device(struct vfio_device *vdev);
+void vfio_cxl_core_set_resource(struct vfio_pci_core_device *core_dev,
+				struct resource res,
+				enum accel_resource type);
+void vfio_cxl_core_set_region_size(struct vfio_pci_core_device *core_dev,
+				   u64 size);
+void vfio_cxl_core_set_driver_hdm_cap(struct vfio_pci_core_device *core_dev);
 #endif /* VFIO_PCI_CORE_H */
-- 
2.34.1


