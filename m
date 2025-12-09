Return-Path: <kvm+bounces-65564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6289ACB0A31
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 17:52:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 96DF03019650
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 16:52:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ED2B3002CD;
	Tue,  9 Dec 2025 16:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="k1tIBDyT"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010060.outbound.protection.outlook.com [52.101.193.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C949C32A3E1;
	Tue,  9 Dec 2025 16:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765299126; cv=fail; b=kUwK0qn2SUy8SM5v2bYZfLJ4og4IbK8VDPxs/o9EAvlLCGamAeJjF8WmfsSDyJIgJySe2gm8ggWsATU81aQZHn2+8oI9TuTB3dLtTDKcjfuqvWIEaBS0X9cMTe8T8td1ws8ps4Pn2d7MV9JVEJXFDYeE9OwPDdWZiSKB50UgDuo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765299126; c=relaxed/simple;
	bh=951ka7Sk4LrVp47oo15Y6iLyfZBLsHOdeqKZOVra0/4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QsRQNz19l4dVVoXTUfXEroTUlguHuKT8RwP4ItdDingVG3/filyh+GTnxVShshVjPNYrREESSyZMKzzhxB//ds4RuWI6Np/zg1EamRIPyDY23u7DZW323zpB0IWuKTBi63TXt4zS4Fi3cVjwSui3hNHoHR/WdKxAQaywTTtYd1Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=k1tIBDyT; arc=fail smtp.client-ip=52.101.193.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rt5BObmMPt7aIzYiur8ybUt59ID8kOCBKQBZVofXMkFTP5SGnwA+flk5GgnY+dXRNiXM+c20x7BrcaXvWdlbZ+Pn16ppCa9pNfi9fdfBFZVUsGcxEkE/WI/0eVPF53QnlHDM2u8mMHxfHYViMzOo/CkTfA+D02WNznZ361QHrfe5r4IHLIYqZRlJvS+HTDH7C0AiABibfmDInwW87g+2oE3A73SfzOMAhaPlQ81rBmVcHJg3NeH+WFXtTO+/TbpDMXKRfAZjUQ1BhBSTux6pJYSiOLuGw+1JWp5JYeohsCbAyNsVkmUiHbFcKbcEwdjIl0Sf7h3MXOYUC9Dw31w56A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j2i2s/RJrKAMrWW2J6u99rhQrB0igXe2skrHZz/+78s=;
 b=Nno83CUY00cXuSPunNj+QGlhjgpT/vC7SQAbssCE/nDzHTj/3AHFFsvN1W1a4IPLfTrBD0zWor5azLY8nrAnS7kwIMFbGpHfS3xNuP7Xs5lZ3jthSYnd+Pl+STGFQGvXpyznXspJFr2lM9FIXt/TZ0w5p1uBYoHTzmliAgpedhTV+AaoodpuppPjPmCHXSNwoXSxsOyDw0Ki+GLHcQz0eNCLt5Tw5YbDI4eYH1FCq7tteSyfPHAJr8AZFUg2YfA9esqyKLsJQjBuy3sb7x7WKMtAKHNHaOHcNKdcNbm6N5VxCrHQK0Zwy2cmxO1mqLqOUF91z0hTOEUoARojzrdcIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j2i2s/RJrKAMrWW2J6u99rhQrB0igXe2skrHZz/+78s=;
 b=k1tIBDyTlOL3kqHNk6KHvk6jIufMDYuhD8bl7gX/Or5Iwo4EoQ40ynD0i/kVBywmUjnhEyeXl36BF7Yh03ZBCSYXpVhDwptL15SSwfWAkV2CqTpvKyPWf+NWi5Y2gImSdfgfbC5MnjJYAA7e0C1h3G306w0DzXuSYCR0yqFNOZlAgNp9AWsxrxnV48YTe5U4yJsxO/rZRlaDW3ksuu6GaKgGZKF212eGjAskCW3ShwyYc/62a793qw4US6U4A8ppoLU7ViQ7vM2iigELzx8O3I8EuSoeJMbRXQ7EYORVD2/Cn5NJWgI+fx2SSUcuB4WHVazT9AQGUM9aBvU6N24StQ==
Received: from SJ0PR03CA0365.namprd03.prod.outlook.com (2603:10b6:a03:3a1::10)
 by MW6PR12MB7085.namprd12.prod.outlook.com (2603:10b6:303:238::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.6; Tue, 9 Dec
 2025 16:51:58 +0000
Received: from SJ1PEPF00002315.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::a2) by SJ0PR03CA0365.outlook.office365.com
 (2603:10b6:a03:3a1::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.14 via Frontend Transport; Tue,
 9 Dec 2025 16:51:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002315.mail.protection.outlook.com (10.167.242.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 9 Dec 2025 16:51:58 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:51:35 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:51:34 -0800
Received: from nvidia-4028GR-scsim.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 9 Dec 2025 08:51:27 -0800
From: <mhonap@nvidia.com>
To: <aniketa@nvidia.com>, <ankita@nvidia.com>, <alwilliamson@nvidia.com>,
	<vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
	<skolothumtho@nvidia.com>, <alejandro.lucero-palau@amd.com>,
	<dave@stgolabs.net>, <jonathan.cameron@huawei.com>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <dan.j.williams@intel.com>, <jgg@ziepe.ca>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>
CC: <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <kjaju@nvidia.com>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <kvm@vger.kernel.org>, <mhonap@nvidia.com>
Subject: [RFC v2 06/15] vfio/cxl: introduce vfio-cxl core preludes
Date: Tue, 9 Dec 2025 22:20:10 +0530
Message-ID: <20251209165019.2643142-7-mhonap@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251209165019.2643142-1-mhonap@nvidia.com>
References: <20251209165019.2643142-1-mhonap@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002315:EE_|MW6PR12MB7085:EE_
X-MS-Office365-Filtering-Correlation-Id: 39568ebc-c8ef-4b81-b160-08de374344a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BcHHhdRWmCzEejDiqxO6R9cZTHM84D1ykzDY3MBU4amQD7vV2C9Y1xU/XcRI?=
 =?us-ascii?Q?fYQ9y7eTV8Cz5EEowUrBrJOPz+LP9vTJVEX3L4jFJZy88XuDGyRBPQYHDVPr?=
 =?us-ascii?Q?0yxQ4DAgbF0YXOkuFyZEHQ35v2MCu/v+RpoDYKbJ8neFHbHWssSPAy1Ttslt?=
 =?us-ascii?Q?GiY2FSziejAHEnEfXDGfcX5s+Mv1bK0vzsopYVUpKjUt2JtH7HNquTACcmz/?=
 =?us-ascii?Q?cszLJxe1OeKeDmY3mWHv7IzDRaQCyxX1MKDklp/zHHmtKsvvJPT/mmRLSoWv?=
 =?us-ascii?Q?ayh+mpiv+RRmKbBA1txvZY2yWPrPZ20Qm/m0V0VplIYyhZvKOW/wr9y+43ZV?=
 =?us-ascii?Q?cdIO39oH/7UfihqKPE5ndH0QUuL19QJ/n7co6SHgxLldKpx1E+vbk3hRAz91?=
 =?us-ascii?Q?N0vdJrvEeoZcT0CMO9DS+TlAmgaM/Aqv9LMl4Qr/kcOMXzf+DtfJxOdCuYGj?=
 =?us-ascii?Q?6l7clsPK0f9QWHGlLqZgPpY9OZOu7MC3tsCOB6zabpCJWoaF6xImNDZL4w6B?=
 =?us-ascii?Q?6XpdWK7qD9grXnsf3eGrGhVQAGfkB0aAAN9xHZMDhZDnOMHAYS38Q4gWf58m?=
 =?us-ascii?Q?dOO98P19OwqSiDu8dKYWglXodg25sPuKDifW3sQf426de/itbAkRx8Blk1Uy?=
 =?us-ascii?Q?EBZ76tdWSQDi8p5uA7hnKLR4989Wqra/E6IuB6dxZua2ZwRVvM/NQ7m8JOYt?=
 =?us-ascii?Q?IXv7kscQJHvOJpe6NNUkAh50TvJlpnaZSDtjf1KPuE7KQuHHAlF2M6iTy3zI?=
 =?us-ascii?Q?rc8lCvGL+LU5FN1AdHCYwAfLs3EcxLs/Qhm6EJwwH/CmgfkubDxFqrmmpH2/?=
 =?us-ascii?Q?/UshLZYHxMyquELoW1oz5XScbyvDIfXw2a66ZBKxIWpRe0Fq2gzCQa73vqrq?=
 =?us-ascii?Q?H81kedkuBWuXTuM8vLISvG4PSiQeyXqfZ8tl82dhxLXBUw6oxow5a6KJxCwJ?=
 =?us-ascii?Q?odjfm+6mIfbrmbDgPUbGT14i8swEpc7ewMpb1Fot/cyu84AdkfEXvRF48+IP?=
 =?us-ascii?Q?cJq+JJk10JAVKPBWnp6+WqWBP38lZ80+Rbxp5QPk19XWUl4g0DiUPNtlmhJX?=
 =?us-ascii?Q?AkWrH31JiQpZKIi+PSaJ0ZSzREwD4Hy5Sc+IFLR8W8IbNUdRDmQEgESBP2qi?=
 =?us-ascii?Q?wknzxDTeZ3ZcwNW4aBTOpye+PseR/lD/cclRRR917dvCVxPzoEgTU61qIWH7?=
 =?us-ascii?Q?cXSQ6Nn21WH8QMqWiNkv3+AlBA31cLSFpMw8/wmohl02E1apgrevenJNvntz?=
 =?us-ascii?Q?f1n67pamkgzpspj6LXdHx85Pxx2XTxzQvCRYRxXXvfth/oR9d+AnjoponYOn?=
 =?us-ascii?Q?cFqGawu8t6uH/cvahVwvWM0mLZ6Lf9baGngk5F7qet6G96n4hxAMZ7PZGR9e?=
 =?us-ascii?Q?vTEpKvjy0mxgMbegqa9f/tiPzWnt11Z9D/Zm86Qs72jpRQp8dAM/dbt39HII?=
 =?us-ascii?Q?NPZZr639qGJyeRSJPTJ4t6JlzdMc53p6oHhUcpaqiyrguMtKC26vZl60dZrc?=
 =?us-ascii?Q?0zWn/Q7DsGuc/A8qJgzSovRCKlC3kklcUn+XZxPrinC41qufGdMu/Tdzjixc?=
 =?us-ascii?Q?T3Y7lP+Cn7lJWrATPgPRiajRllXU9QjgRtCXJz97?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 16:51:58.5914
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39568ebc-c8ef-4b81-b160-08de374344a1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002315.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7085

From: Manish Honap <mhonap@nvidia.com>

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

Introduce vfio-cxl core preludes to hold all the common functions used
by VFIO variant drivers to support CXL device passthrough.

Co-developed-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Manish Honap <mhonap@nvidia.com>
---
 drivers/vfio/pci/Kconfig         |  10 ++
 drivers/vfio/pci/Makefile        |   3 +
 drivers/vfio/pci/vfio_cxl_core.c | 238 +++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    |  50 +++++++
 4 files changed, 301 insertions(+)
 create mode 100644 drivers/vfio/pci/vfio_cxl_core.c

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 2b0172f54665..2f441d118f1c 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -7,6 +7,16 @@ config VFIO_PCI_CORE
 	select VFIO_VIRQFD
 	select IRQ_BYPASS_MANAGER
 
+config VFIO_CXL_CORE
+	tristate "VFIO CXL core"
+	select VFIO_PCI_CORE
+	depends on CXL_BUS
+	help
+	  Support for the generic PCI VFIO-CXL bus driver which can
+	  connect CXL devices to the VFIO framework.
+
+	  If you don't know what to do here, say N.
+
 config VFIO_PCI_INTX
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
index 000000000000..cf53720c0cb7
--- /dev/null
+++ b/drivers/vfio/pci/vfio_cxl_core.c
@@ -0,0 +1,238 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES. All rights reserved
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
+/* Standard CXL-type 2 driver initialization sequence */
+static int enable_cxl(struct vfio_cxl_core_device *cxl, u16 dvsec,
+		      struct vfio_cxl_dev_info *info)
+{
+	struct vfio_pci_core_device *pci = &cxl->pci_core;
+	struct vfio_cxl *cxl_core = cxl->cxl_core;
+	struct pci_dev *pdev = pci->pdev;
+	u64 offset, size, count;
+	int ret;
+
+	ret = cxl_pci_setup_regs(pdev, CXL_REGLOC_RBI_COMPONENT,
+				 &cxl_core->cxlds.reg_map);
+	if (ret) {
+		pci_err(pdev, "VFIO-CXL: CXL component registers not found\n");
+		return ret;
+	}
+
+	ret = cxl_get_hdm_reg_info(&cxl_core->cxlds, &count, &offset, &size);
+	if (ret)
+		return ret;
+
+	if (WARN_ON(!count || !size))
+		return -ENODEV;
+
+	cxl->hdm_count = count;
+	cxl->hdm_reg_offset = offset;
+	cxl->hdm_reg_size = size;
+
+	if (!info->no_media_ready) {
+		ret = cxl_await_range_active(&cxl_core->cxlds);
+		if (ret)
+			return -ENODEV;
+
+		cxl_core->cxlds.media_ready = true;
+	} else {
+		/* Some devices don't have media ready support. E.g. AMD SFC. */
+		cxl_core->cxlds.media_ready = true;
+	}
+
+	if (cxl_set_capacity(&cxl_core->cxlds, SZ_256M)) {
+		pci_err(pdev, "dpa capacity setup failed\n");
+		return -ENODEV;
+	}
+
+	cxl_core->cxlmd = devm_cxl_add_memdev(&pdev->dev,
+					      &cxl_core->cxlds, NULL);
+	if (IS_ERR(cxl_core->cxlmd))
+		return PTR_ERR(cxl_core->cxlmd);
+
+	cxl_core->region.noncached = info->noncached_region;
+
+	return 0;
+}
+
+static void disable_cxl(struct vfio_cxl_core_device *cxl)
+{
+	struct vfio_cxl *cxl_core = cxl->cxl_core;
+
+	WARN_ON(cxl_core->region.region);
+
+	if (!cxl->hdm_count)
+		return;
+
+	if (cxl_core->cxled) {
+		cxl_decoder_detach(NULL, cxl_core->cxled, 0, DETACH_INVALIDATE);
+		cxl_dpa_free(cxl_core->cxled);
+	}
+
+	if (cxl_core->cxlrd)
+		cxl_put_root_decoder(cxl_core->cxlrd);
+}
+
+int vfio_cxl_core_enable(struct vfio_cxl_core_device *cxl,
+			 struct vfio_cxl_dev_info *info)
+{
+	struct vfio_pci_core_device *pci = &cxl->pci_core;
+	struct pci_dev *pdev = pci->pdev;
+	struct vfio_cxl *cxl_core = cxl->cxl_core;
+	u16 dvsec;
+	int ret;
+
+	dvsec = pci_find_dvsec_capability(pdev, PCI_VENDOR_ID_CXL,
+					  PCI_DVSEC_CXL_DEVICE);
+	if (!dvsec)
+		return -ENODEV;
+
+	cxl_core = devm_cxl_dev_state_create(&pdev->dev, CXL_DEVTYPE_DEVMEM,
+					     pdev->dev.id, dvsec, struct vfio_cxl,
+					     cxlds, false);
+	if (!cxl_core) {
+		pci_err(pdev, "VFIO-CXL: CXL state creation failed");
+		return -ENOMEM;
+	}
+
+	ret = vfio_pci_core_enable(pci);
+	if (ret)
+		return ret;
+
+	ret = enable_cxl(cxl, dvsec, info);
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	vfio_pci_core_disable(pci);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_cxl_core_enable);
+
+void vfio_cxl_core_finish_enable(struct vfio_cxl_core_device *cxl)
+{
+	struct vfio_pci_core_device *pci = &cxl->pci_core;
+
+	vfio_pci_core_finish_enable(pci);
+}
+EXPORT_SYMBOL_GPL(vfio_cxl_core_finish_enable);
+
+static void disable_device(struct vfio_cxl_core_device *cxl)
+{
+	disable_cxl(cxl);
+}
+
+void vfio_cxl_core_disable(struct vfio_cxl_core_device *cxl)
+{
+	disable_device(cxl);
+	vfio_pci_core_disable(&cxl->pci_core);
+}
+EXPORT_SYMBOL_GPL(vfio_cxl_core_disable);
+
+void vfio_cxl_core_close_device(struct vfio_device *vdev)
+{
+	struct vfio_pci_core_device *pci =
+		container_of(vdev, struct vfio_pci_core_device, vdev);
+	struct vfio_cxl_core_device *cxl = vfio_pci_core_to_cxl(pci);
+
+	disable_device(cxl);
+	vfio_pci_core_close_device(vdev);
+}
+EXPORT_SYMBOL_GPL(vfio_cxl_core_close_device);
+
+static int get_hpa_and_request_dpa(struct vfio_cxl_core_device *cxl, u64 size)
+{
+	u64 max;
+	struct vfio_cxl *cxl_core = cxl->cxl_core;
+
+	cxl_core->cxlrd = cxl_get_hpa_freespace(cxl_core->cxlmd, 1,
+						CXL_DECODER_F_RAM |
+						CXL_DECODER_F_TYPE2,
+						&max);
+	if (IS_ERR(cxl_core->cxlrd))
+		return PTR_ERR(cxl_core->cxlrd);
+
+	if (max < size)
+		return -ENOSPC;
+
+	cxl_core->cxled = cxl_request_dpa(cxl_core->cxlmd, CXL_PARTMODE_RAM, size);
+	if (IS_ERR(cxl_core->cxled))
+		return PTR_ERR(cxl_core->cxled);
+
+	return 0;
+}
+
+int vfio_cxl_core_create_cxl_region(struct vfio_cxl_core_device *cxl, u64 size)
+{
+	struct cxl_region *region;
+	struct range range;
+	int ret;
+	struct vfio_cxl *cxl_core = cxl->cxl_core;
+
+	if (WARN_ON(cxl_core->region.region))
+		return -EEXIST;
+
+	ret = get_hpa_and_request_dpa(cxl, size);
+	if (ret)
+		return ret;
+
+	region = cxl_create_region(cxl_core->cxlrd, &cxl_core->cxled, true);
+	if (IS_ERR(region)) {
+		ret = PTR_ERR(region);
+		cxl_dpa_free(cxl_core->cxled);
+		return ret;
+	}
+
+	cxl_get_region_range(region, &range);
+
+	cxl_core->region.addr = range.start;
+	cxl_core->region.size = size;
+	cxl_core->region.region = region;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_cxl_core_create_cxl_region);
+
+void vfio_cxl_core_destroy_cxl_region(struct vfio_cxl_core_device *cxl)
+{
+	struct vfio_cxl *cxl_core = cxl->cxl_core;
+
+	if (!cxl_core->region.region)
+		return;
+
+	cxl_decoder_detach(NULL, cxl_core->cxled, 0, DETACH_INVALIDATE);
+	cxl_put_root_decoder(cxl_core->cxlrd);
+	cxl_dpa_free(cxl_core->cxled);
+	cxl_core->region.region = NULL;
+}
+EXPORT_SYMBOL_GPL(vfio_cxl_core_destroy_cxl_region);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_IMPORT_NS("CXL");
+MODULE_SOFTDEP("pre: cxl_core cxl_port cxl_acpi cxl-mem");
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index f541044e42a2..a343b91d2580 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -15,6 +15,8 @@
 #include <linux/types.h>
 #include <linux/uuid.h>
 #include <linux/notifier.h>
+#include <cxl/cxl.h>
+#include <cxl/pci.h>
 
 #ifndef VFIO_PCI_CORE_H
 #define VFIO_PCI_CORE_H
@@ -96,6 +98,40 @@ struct vfio_pci_core_device {
 	struct rw_semaphore	memory_lock;
 };
 
+struct vfio_cxl_region {
+	struct cxl_region *region;
+	u64 size;
+	u64 addr;
+	bool noncached;
+};
+
+struct vfio_cxl {
+	struct cxl_dev_state cxlds;
+	struct cxl_memdev *cxlmd;
+	struct cxl_root_decoder *cxlrd;
+	struct cxl_port *endpoint;
+	struct cxl_endpoint_decoder *cxled;
+
+	struct vfio_cxl_region region;
+};
+
+struct vfio_cxl_core_device {
+	struct vfio_pci_core_device pci_core;
+	struct vfio_cxl *cxl_core;
+
+	u32 hdm_count;
+	u64 hdm_reg_offset;
+	u64 hdm_reg_size;
+};
+
+struct vfio_cxl_dev_info {
+	unsigned long *dev_caps;
+	struct resource dpa_res;
+	struct resource ram_res;
+	bool no_media_ready;
+	bool noncached_region;
+};
+
 /* Will be exported for vfio pci drivers usage */
 int vfio_pci_core_register_dev_region(struct vfio_pci_core_device *vdev,
 				      unsigned int type, unsigned int subtype,
@@ -161,4 +197,18 @@ VFIO_IOREAD_DECLARATION(32)
 VFIO_IOREAD_DECLARATION(64)
 #endif
 
+static inline struct vfio_cxl_core_device *
+vfio_pci_core_to_cxl(struct vfio_pci_core_device *pci)
+{
+	return container_of(pci, struct vfio_cxl_core_device, pci_core);
+}
+
+int vfio_cxl_core_enable(struct vfio_cxl_core_device *cxl,
+			 struct vfio_cxl_dev_info *info);
+void vfio_cxl_core_finish_enable(struct vfio_cxl_core_device *cxl);
+void vfio_cxl_core_disable(struct vfio_cxl_core_device *cxl);
+void vfio_cxl_core_close_device(struct vfio_device *vdev);
+int vfio_cxl_core_create_cxl_region(struct vfio_cxl_core_device *cxl, u64 size);
+void vfio_cxl_core_destroy_cxl_region(struct vfio_cxl_core_device *cxl);
+
 #endif /* VFIO_PCI_CORE_H */
-- 
2.25.1


