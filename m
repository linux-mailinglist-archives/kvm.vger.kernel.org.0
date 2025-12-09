Return-Path: <kvm+bounces-65568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A435CB0A8C
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 18:03:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CF348301C7C7
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 17:03:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7662432ED22;
	Tue,  9 Dec 2025 16:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Gy629Slz"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010029.outbound.protection.outlook.com [52.101.46.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8ABA32BF44;
	Tue,  9 Dec 2025 16:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765299164; cv=fail; b=WI5iotdH/J+mKVGGM54BgmSZ6JcG1ZutTrpgFsxriCUNuFrxzNQONERL4NWJaf5o9WvbWq+vpAWJQT4DkHjS9ww6yYqBNyQ9DUO9XjyFEP4ZkVzhBLYA/yao4Dl5/tS8FO5xkozYsVaKj3HLdFWigjCPnp0YTnWhwmar6trQqdE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765299164; c=relaxed/simple;
	bh=0g2KKSMYLp/0w+cM3CWahM9nY9LmLSKwljkV0K4IJqM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gaCTZDKTFr8iAVrOj4Vn4Jt+c8KbtvQ4pH6+oIPqEq400azVpR2WuJ4T1zxtsCvKYwmtg050Hl1A7m3CsMPWwmVDHaS6GkZMdBfwPUXnsC+RxFfmNDrqWOv1W4KRagDzK5xjP1Ox8l2RFDNVS8GN3Xzf887G9TvbsSu6HFv0ryM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Gy629Slz; arc=fail smtp.client-ip=52.101.46.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o8IjZKYSpE63VkZDBv71io6E/mF1yl//+LHmktZDlwMH0e3w/XVxEybO4n/nN+pspETmkvk9JtechXEfDkkIWWlJWASrVY1yBEJ2d0XjvjXHhMam1Tideeze05khjchFhz7afxtjXjQJ7ESuxCIPxY80pbDeDbZZRn8iQxrnVusvm590a2Yu5mKu5ZKBRg+Zf8WMQPtJpbfQC5UWg5TrpMu8WLfLmX/cMJXcsofVqoqLOU1iHq5PeSW8QocrMTN06BZ79WCH3PsBgfUZvWj7CJpOvCokaidNJsRmw+CR7Y5qa5+voxe9ewnbkVPH8kqpoGhmIuSYkz+Oc2kPEb97iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lls0t5ubKBx4HUwjc8FgLmA/tTMMnUI74JJVYfZ7nB4=;
 b=AWApEB07EdKg1o/PRtSc5tdddoLNdCU2Cq479F9AJdHE8xbKiusfCkD8DqWapeNJ6C3sce3yRI2usPAYvzEf0s8ZaaZPysoU54gelVAXRnJrO++asY3SKfUmLjG5P66iGwoQCCd9P+cd6nA4bQYjide1/sxMy7PzGr/CC1u+hpbDPqjs9qccpeS5B7eKP2ldposdjN0OUKYyPpUWFQUhnPoNky5TVgokPoFAifksy3jm0+i4qM+gu9p0NuX0dGJqV2d62KdiHXBQooYHD5S2yFbZmvTJmAp00Q3VB9tSNwKpZJ4lnMYJwSDEeLjZRKtDYPmbauphfkeeokxuHkQE/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lls0t5ubKBx4HUwjc8FgLmA/tTMMnUI74JJVYfZ7nB4=;
 b=Gy629SlzlyJwfuEb9RzfcaTiMxIO6trKW8wg3F21dqLh2C7Z0ruPzWNis2y+m/qFrOKUtbhsq7FeGzKW6xa13LunE9Iw+xkb58vkX6XI3msszf27KxKHJ9b8FeYDJ5o4Sxy9bjaBHnIkkgPo2bb6dPLk4TwBRErMeEpzIkZaeY9uVVa4bx4LNh/UkJGFGO9f/sbCk+9y8rfRHkuFmDX9hv4kCZ2eeYbW/5SpiolWAKnayo/w8FWs7AK1boCa46u9VHyY8Unx7/egHej3H7ACVRxrSmYfXhOMA8XvVtGcsI0aXmTMlZTRz6I96SHeRnX/b+JIqDg93kCiVUjhwbQbTQ==
Received: from SJ0PR13CA0181.namprd13.prod.outlook.com (2603:10b6:a03:2c3::6)
 by DS2PR12MB9662.namprd12.prod.outlook.com (2603:10b6:8:27d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Tue, 9 Dec
 2025 16:52:32 +0000
Received: from SJ1PEPF00002317.namprd03.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::a8) by SJ0PR13CA0181.outlook.office365.com
 (2603:10b6:a03:2c3::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.7 via Frontend Transport; Tue, 9
 Dec 2025 16:52:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002317.mail.protection.outlook.com (10.167.242.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 9 Dec 2025 16:52:32 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:52:05 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:52:04 -0800
Received: from nvidia-4028GR-scsim.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 9 Dec 2025 08:51:57 -0800
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
Subject: [RFC v2 10/15] vfio/cxl: introduce the register emulation framework
Date: Tue, 9 Dec 2025 22:20:14 +0530
Message-ID: <20251209165019.2643142-11-mhonap@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002317:EE_|DS2PR12MB9662:EE_
X-MS-Office365-Filtering-Correlation-Id: 2927f263-d89f-4954-7616-08de374358be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uZ4rI/IFAWUFkyb4rYgyxmD4I3D4lecOE7H609iSBZsu4asGlOIUjIS8mpfu?=
 =?us-ascii?Q?YNGc8MblVjsQAMpLNtTC5U5LhRxOpqAe7OmqC4YHLo2xMYy2z8xRyzx0at9D?=
 =?us-ascii?Q?nR1VINPnoZRPQGizkf7ZScFTSRxMt57IovJTMVfWcoALcTf/XJCnEfC5ORLX?=
 =?us-ascii?Q?0pUhx7nBnRhWnAZxWC2XJIG21Z+gZywrL/laWEuJTZtM6sZw/gJYHjLR5SHh?=
 =?us-ascii?Q?cU0VJLenXddielD1ovKVpO1JchiegjItjIfdvL1E8YlKL3USiAvPwsnEwDah?=
 =?us-ascii?Q?vW5OH8Xj7qKkjKQCCfmJjy2TQJ+6+ewtgTrXDkI0hiTgQXnPAw/ynJIWuvC1?=
 =?us-ascii?Q?XoSZon0d8MZiR3JKZb+TwgqlEmMm+eie21kBMHRC6u/BqJRemcAYXvHGFmUd?=
 =?us-ascii?Q?FS4fVFSOrwfxzi9Z8jN0a9baTKYZM1e2Sw6XwerfFGJI+HlwlDVdM8Iz1ZGW?=
 =?us-ascii?Q?iQ+P8aPlqr8BiIs46+rh8+FqZp7glZwKHNzszHSbjIfF5VrbOAH0fEbtzTXX?=
 =?us-ascii?Q?ruV4Xc6lacrzDN3sNqARo1J6ZEHyDPAtohnPP+KLMLfpzuXPAE2sSwQuEOAR?=
 =?us-ascii?Q?op0VHR3Emv520WCXLHiaj0mP9NHee3Gm1q83WMT8JgWJxYP+3dD4EwfVhyZN?=
 =?us-ascii?Q?3QGrKUDEDMMPOQGUFk674b1U1IHtCuFXclkNfXdLDL9/ftUC6WKnM7yMO1aq?=
 =?us-ascii?Q?TfccRIRSISRlVEu67kel0lxwIWNVuz9ewwx5/9Z1/qQx51hUb5qnBxuMz60T?=
 =?us-ascii?Q?6vJtYAboYnzBSYNoZVmyx3QaEZ89f2/ajhWjTqoEvhsmzFfwHbprNlRha4Ds?=
 =?us-ascii?Q?lxu3/eHJT2j+mb7AWJvZkPdL2mBuQC+t3o2GXmM57jKRtS3JsrjbkUf2EL3S?=
 =?us-ascii?Q?4369newFNK7ZQDaSnq1omE/AClxKRBa7RS0Czs2My6O7ADrIBBncUnSFx2I8?=
 =?us-ascii?Q?4CeVLFI5SHQptWSeewK7P0tnqRY/0yZy0ps8VcbIpLiO/dks+xj+1MKOsX9j?=
 =?us-ascii?Q?HFfhY+anrqKJkz3movX7MXm+BP3dbaxZB67yNlk7TFW3j9ubgXv49HeZSwcd?=
 =?us-ascii?Q?1ge4lOI/MMd65pvT9aVBridxyqUy6mFdJ/B+I4Xr+zJcy6iIB9zf9iCyPmlC?=
 =?us-ascii?Q?rpcQTKfCLojr5Y1WyUwKbdbc4yr9yUlsN4MGfielxb0GVnlRgxACvVErjU8c?=
 =?us-ascii?Q?71Jp1A3ggJKLiuQctFLXEVhSyI7Sy6k9ysko3LJE4WUh985X6WqP1pR29jG6?=
 =?us-ascii?Q?Z8fYbmvxI63WDzGvwUaQ7XUm7sz/ZPNRqEIAYJ3b96PlPbhehPSn46PLdyea?=
 =?us-ascii?Q?g2SI1kIVFyY8sYC2ZEMG6/mlrfyrnqs/HR5qrg0ednjFq0Zv6nSJ5RWgvpgv?=
 =?us-ascii?Q?CIo6JKVJA7isDeuIKAHfP/0BsRORPiAJyJU0rMIFFz7XQaQHrmAj5HZOnQ3s?=
 =?us-ascii?Q?vDIF5USnBM3d8kkQeTgAAjIkDmofe5dM8hX/ADNVREoZLBqUxsTIpSuhYkVQ?=
 =?us-ascii?Q?ZbWvp0hvhBujJRMHg9tg6CLJlM89aku8euNVn3egXylKLmtIu2Pn4j3f9Fvb?=
 =?us-ascii?Q?uEXmjwIq9uMkvCzfmvl7pJX7nD0T0Pj7uoqwg+p7?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 16:52:32.3135
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2927f263-d89f-4954-7616-08de374358be
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002317.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9662

From: Manish Honap <mhonap@nvidia.com>

CXL devices have the CXL DVSEC registers in its configuration space
and CXL MMIO registers in its CXL MMIO BAR.

When passing a CXL type-2 device to a VM, the CXL DVSEC registers in the
configuration space and the HDM registers in the CXL MMIO BAR should be
emulated.

Introduce an emulation framework to handle the CXL device configuration
emulation and the CXL MMIO registers emulation.

Co-developed-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Manish Honap <mhonap@nvidia.com>
---
 drivers/vfio/pci/Makefile             |   2 +-
 drivers/vfio/pci/vfio_cxl_core.c      | 281 +++++++++++++++++++++++++-
 drivers/vfio/pci/vfio_cxl_core_emu.c  | 184 +++++++++++++++++
 drivers/vfio/pci/vfio_cxl_core_priv.h |  17 ++
 include/linux/vfio_pci_core.h         |  29 +++
 5 files changed, 509 insertions(+), 4 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_cxl_core_emu.c
 create mode 100644 drivers/vfio/pci/vfio_cxl_core_priv.h

diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index b51221b94b0b..452b7387f9fb 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -8,7 +8,7 @@ vfio-pci-y := vfio_pci.o
 vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
 
-vfio-cxl-core-y := vfio_cxl_core.o
+vfio-cxl-core-y := vfio_cxl_core.o vfio_cxl_core_emu.o
 obj-$(CONFIG_VFIO_CXL_CORE) += vfio-cxl-core.o
 
 obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
diff --git a/drivers/vfio/pci/vfio_cxl_core.c b/drivers/vfio/pci/vfio_cxl_core.c
index 460f1ee910af..cb75e9f668a7 100644
--- a/drivers/vfio/pci/vfio_cxl_core.c
+++ b/drivers/vfio/pci/vfio_cxl_core.c
@@ -20,6 +20,7 @@
 #include <linux/uaccess.h>
 
 #include "vfio_pci_priv.h"
+#include "vfio_cxl_core_priv.h"
 
 #define DRIVER_AUTHOR "Zhi Wang <zhiw@nvidia.com>"
 #define DRIVER_DESC "core driver for VFIO based CXL devices"
@@ -119,6 +120,119 @@ static void discover_precommitted_region(struct vfio_cxl_core_device *cxl)
 	cxl_core->region.precommitted = true;
 }
 
+static int find_bar(struct pci_dev *pdev, u64 *offset, int *bar, u64 size)
+{
+	u64 start, end, flags;
+	int index, i;
+
+	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
+		index = i + PCI_STD_RESOURCES;
+		flags = pci_resource_flags(pdev, index);
+
+		start = pci_resource_start(pdev, index);
+		end = pci_resource_end(pdev, index);
+
+		if (*offset >= start && *offset + size - 1 <= end)
+			break;
+
+		if (flags & IORESOURCE_MEM_64)
+			i++;
+	}
+
+	if (i == PCI_STD_NUM_BARS)
+		return -ENODEV;
+
+	*offset = *offset - start;
+	*bar = index;
+
+	return 0;
+}
+
+static int find_comp_regs(struct vfio_cxl_core_device *cxl)
+{
+	struct vfio_pci_core_device *pci = &cxl->pci_core;
+	struct pci_dev *pdev = pci->pdev;
+	u64 offset;
+	int ret, bar;
+
+	ret = cxl_find_comp_regblock_offset(pdev, &offset);
+	if (ret)
+		return ret;
+
+	ret = find_bar(pdev, &offset, &bar, SZ_64K);
+	if (ret)
+		return ret;
+
+	cxl->comp_reg_bar = bar;
+	cxl->comp_reg_offset = offset;
+	cxl->comp_reg_size = SZ_64K;
+	return 0;
+}
+
+static void clean_virt_regs(struct vfio_cxl_core_device *cxl)
+{
+	kvfree(cxl->comp_reg_virt);
+	kvfree(cxl->config_virt);
+}
+
+static void reset_virt_regs(struct vfio_cxl_core_device *cxl)
+{
+	memcpy(cxl->config_virt, cxl->initial_config_virt, cxl->config_size);
+	memcpy(cxl->comp_reg_virt, cxl->initial_comp_reg_virt, cxl->comp_reg_size);
+}
+
+static int setup_virt_regs(struct vfio_cxl_core_device *cxl)
+{
+	struct vfio_pci_core_device *pci = &cxl->pci_core;
+	struct pci_dev *pdev = pci->pdev;
+	u64 offset = cxl->comp_reg_offset;
+	int bar = cxl->comp_reg_bar;
+	u64 size = cxl->comp_reg_size;
+	void *regs;
+	unsigned int i;
+
+	regs = kvzalloc(size * 2, GFP_KERNEL);
+	if (!regs)
+		return -ENOMEM;
+
+	cxl->comp_reg_virt = regs;
+	cxl->initial_comp_reg_virt = regs + size;
+
+	regs = ioremap(pci_resource_start(pdev, bar) + offset, size);
+	if (!regs) {
+		kvfree(cxl->comp_reg_virt);
+		return -EFAULT;
+	}
+
+	for (i = 0; i < size; i += 4)
+		*(u32 *)(cxl->initial_comp_reg_virt + i) =
+			cpu_to_le32(readl(regs + i));
+
+	iounmap(regs);
+
+	regs = kvzalloc(pdev->cfg_size * 2, GFP_KERNEL);
+	if (!regs) {
+		kvfree(cxl->comp_reg_virt);
+		return -ENOMEM;
+	}
+
+	cxl->config_virt = regs;
+	cxl->initial_config_virt = regs + pdev->cfg_size;
+	cxl->config_size = pdev->cfg_size;
+
+	regs = cxl->initial_config_virt + cxl->dvsec;
+
+	for (i = 0; i < 0x40; i += 4) {
+		u32 val;
+
+		pci_read_config_dword(pdev, cxl->dvsec + i, &val);
+		*(u32 *)(regs + i) = cpu_to_le32(val);
+	}
+
+	reset_virt_regs(cxl);
+	return 0;
+}
+
 int vfio_cxl_core_enable(struct vfio_cxl_core_device *cxl,
 			 struct vfio_cxl_dev_info *info)
 {
@@ -133,6 +247,8 @@ int vfio_cxl_core_enable(struct vfio_cxl_core_device *cxl,
 	if (!dvsec)
 		return -ENODEV;
 
+	cxl->dvsec = dvsec;
+
 	cxl_core = devm_cxl_dev_state_create(&pdev->dev, CXL_DEVTYPE_DEVMEM,
 					     pdev->dev.id, dvsec, struct vfio_cxl,
 					     cxlds, false);
@@ -141,20 +257,37 @@ int vfio_cxl_core_enable(struct vfio_cxl_core_device *cxl,
 		return -ENOMEM;
 	}
 
-	ret = vfio_pci_core_enable(pci);
+	ret = find_comp_regs(cxl);
+	if (ret)
+		return -ENODEV;
+
+	ret = setup_virt_regs(cxl);
 	if (ret)
 		return ret;
 
+	ret = vfio_pci_core_enable(pci);
+	if (ret)
+		goto err_pci_core_enable;
+
 	ret = enable_cxl(cxl, dvsec, info);
 	if (ret)
-		goto err;
+		goto err_enable_cxl;
+
+	ret = vfio_cxl_core_setup_register_emulation(cxl);
+	if (ret)
+		goto err_register_emulation;
 
 	discover_precommitted_region(cxl);
 
 	return 0;
 
-err:
+err_register_emulation:
+	disable_cxl(cxl);
+err_pci_core_enable:
+	clean_virt_regs(cxl);
+err_enable_cxl:
 	vfio_pci_core_disable(pci);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(vfio_cxl_core_enable);
@@ -169,7 +302,9 @@ EXPORT_SYMBOL_GPL(vfio_cxl_core_finish_enable);
 
 static void disable_device(struct vfio_cxl_core_device *cxl)
 {
+	vfio_cxl_core_clean_register_emulation(cxl);
 	disable_cxl(cxl);
+	clean_virt_regs(cxl);
 }
 
 void vfio_cxl_core_disable(struct vfio_cxl_core_device *cxl)
@@ -383,6 +518,20 @@ ssize_t vfio_cxl_core_read(struct vfio_device *core_vdev, char __user *buf,
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	struct vfio_cxl_core_device *cxl =
+		container_of(vdev, struct vfio_cxl_core_device, pci_core);
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+
+	if (!count)
+		return 0;
+
+	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
+		return vfio_cxl_core_config_rw(core_vdev, buf, count, ppos,
+					       false);
+
+	if (index == cxl->comp_reg_bar)
+		return vfio_cxl_core_mmio_bar_rw(core_vdev, buf, count, ppos,
+						 false);
 
 	return vfio_pci_rw(vdev, buf, count, ppos, false);
 }
@@ -393,11 +542,137 @@ ssize_t vfio_cxl_core_write(struct vfio_device *core_vdev, const char __user *bu
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	struct vfio_cxl_core_device *cxl =
+		container_of(vdev, struct vfio_cxl_core_device, pci_core);
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+
+	if (!count)
+		return 0;
+
+	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
+		return vfio_cxl_core_config_rw(core_vdev, (char __user *)buf,
+					       count, ppos, true);
+
+	if (index == cxl->comp_reg_bar)
+		return vfio_cxl_core_mmio_bar_rw(core_vdev, (char __user *)buf,
+						 count, ppos, true);
 
 	return vfio_pci_rw(vdev, (char __user *)buf, count, ppos, true);
 }
 EXPORT_SYMBOL_GPL(vfio_cxl_core_write);
 
+static int comp_reg_bar_get_region_info(struct vfio_pci_core_device *pci,
+					void __user *uarg)
+{
+	struct vfio_cxl_core_device *cxl =
+		container_of(pci, struct vfio_cxl_core_device, pci_core);
+	struct pci_dev *pdev = pci->pdev;
+	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
+	struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
+	struct vfio_region_info_cap_sparse_mmap *sparse;
+	struct vfio_region_info info;
+	u64 start, end, len;
+	u32 size;
+	int ret;
+
+	if (copy_from_user(&info, uarg, minsz))
+		return -EFAULT;
+
+	if (info.argsz < minsz)
+		return -EINVAL;
+
+	start = pci_resource_start(pdev, cxl->comp_reg_bar);
+	end = pci_resource_end(pdev, cxl->comp_reg_bar) - start;
+	len = pci_resource_len(pdev, cxl->comp_reg_bar);
+
+	if (!cxl->comp_reg_offset ||
+	    cxl->comp_reg_offset + cxl->comp_reg_size == end) {
+		size = struct_size(sparse, areas, 1);
+
+		sparse = kzalloc(size, GFP_KERNEL);
+		if (!sparse)
+			return -ENOMEM;
+
+		sparse->nr_areas = 1;
+		sparse->areas[0].offset = cxl->comp_reg_offset ? 0 : cxl->comp_reg_size;
+		sparse->areas[0].size = len - cxl->comp_reg_size;
+	} else {
+		size = struct_size(sparse, areas, 2);
+
+		sparse = kzalloc(size, GFP_KERNEL);
+		if (!sparse)
+			return -ENOMEM;
+
+		sparse->nr_areas = 2;
+
+		sparse->areas[0].offset = 0;
+		sparse->areas[0].size = cxl->comp_reg_offset;
+
+		sparse->areas[1].offset = sparse->areas[0].size + cxl->comp_reg_size;
+		sparse->areas[1].size = len - sparse->areas[0].size - cxl->comp_reg_size;
+	}
+
+	sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
+	sparse->header.version = 1;
+
+	ret = vfio_info_add_capability(&caps, &sparse->header, size);
+	kfree(sparse);
+	if (ret)
+		return ret;
+
+	info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+	info.size = len;
+	info.flags = VFIO_REGION_INFO_FLAG_READ |
+		VFIO_REGION_INFO_FLAG_WRITE |
+		VFIO_REGION_INFO_FLAG_MMAP;
+
+	if (caps.size) {
+		info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
+		if (info.argsz < sizeof(info) + caps.size) {
+			info.argsz = sizeof(info) + caps.size;
+			info.cap_offset = 0;
+		} else {
+			vfio_info_cap_shift(&caps, sizeof(info));
+			if (copy_to_user(uarg + sizeof(info), caps.buf,
+					 caps.size)) {
+				kfree(caps.buf);
+				return -EFAULT;
+			}
+			info.cap_offset = sizeof(info);
+		}
+		kfree(caps.buf);
+	}
+
+	return copy_to_user(uarg, &info, minsz) ? -EFAULT : 0;
+}
+
+long vfio_cxl_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
+			 unsigned long arg)
+{
+	struct vfio_pci_core_device *pci =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	struct vfio_cxl_core_device *cxl =
+		container_of(pci, struct vfio_cxl_core_device, pci_core);
+	void __user *uarg = (void __user *)arg;
+
+	if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
+		struct vfio_region_info info;
+		unsigned long minsz = offsetofend(struct vfio_region_info, offset);
+
+		if (copy_from_user(&info, (void *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz)
+			return -EINVAL;
+
+		if (info.index == cxl->comp_reg_bar)
+			return comp_reg_bar_get_region_info(pci, uarg);
+	}
+
+	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
+}
+EXPORT_SYMBOL_GPL(vfio_cxl_core_ioctl);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/vfio/pci/vfio_cxl_core_emu.c b/drivers/vfio/pci/vfio_cxl_core_emu.c
new file mode 100644
index 000000000000..a0674bacecd7
--- /dev/null
+++ b/drivers/vfio/pci/vfio_cxl_core_emu.c
@@ -0,0 +1,184 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include "vfio_cxl_core_priv.h"
+
+void vfio_cxl_core_clean_register_emulation(struct vfio_cxl_core_device *cxl)
+{
+	struct list_head *pos, *n;
+
+	list_for_each_safe(pos, n, &cxl->config_regblocks_head)
+		kfree(list_entry(pos, struct vfio_emulated_regblock, list));
+	list_for_each_safe(pos, n, &cxl->mmio_regblocks_head)
+		kfree(list_entry(pos, struct vfio_emulated_regblock, list));
+}
+
+int vfio_cxl_core_setup_register_emulation(struct vfio_cxl_core_device *cxl)
+{
+	INIT_LIST_HEAD(&cxl->config_regblocks_head);
+	INIT_LIST_HEAD(&cxl->mmio_regblocks_head);
+
+	return 0;
+}
+
+static struct vfio_emulated_regblock *
+find_regblock(struct list_head *head, u64 offset, u64 size)
+{
+	struct vfio_emulated_regblock *block;
+	struct list_head *pos;
+
+	list_for_each(pos, head) {
+		block = list_entry(pos, struct vfio_emulated_regblock, list);
+
+		if (block->range.start == ALIGN_DOWN(offset,
+						     range_len(&block->range)))
+			return block;
+	}
+	return NULL;
+}
+
+static ssize_t emulate_read(struct list_head *head, struct vfio_device *vdev,
+			    char __user *buf, size_t count, loff_t *ppos)
+{
+	struct vfio_pci_core_device *pci =
+		container_of(vdev, struct vfio_pci_core_device, vdev);
+	struct vfio_cxl_core_device *cxl =
+		container_of(pci, struct vfio_cxl_core_device, pci_core);
+	struct vfio_emulated_regblock *block;
+	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	ssize_t ret;
+	u32 v;
+
+	block = find_regblock(head, pos, count);
+	if (!block || !block->read)
+		return vfio_pci_rw(pci, buf, count, ppos, false);
+
+	if (WARN_ON_ONCE(!IS_ALIGNED(pos, range_len(&block->range))))
+		return -EINVAL;
+
+	if (count > range_len(&block->range))
+		count = range_len(&block->range);
+
+	ret = block->read(cxl, &v, pos, count);
+	if (ret < 0)
+		return ret;
+
+	if (copy_to_user(buf, &v, count))
+		return -EFAULT;
+
+	return count;
+}
+
+static ssize_t emulate_write(struct list_head *head, struct vfio_device *vdev,
+			     char __user *buf, size_t count, loff_t *ppos)
+{
+	struct vfio_pci_core_device *pci =
+		container_of(vdev, struct vfio_pci_core_device, vdev);
+	struct vfio_cxl_core_device *cxl =
+		container_of(pci, struct vfio_cxl_core_device, pci_core);
+	struct vfio_emulated_regblock *block;
+	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	ssize_t ret;
+	u32 v;
+
+	block = find_regblock(head, pos, count);
+	if (!block || !block->write)
+		return vfio_pci_rw(pci, buf, count, ppos, true);
+
+	if (WARN_ON_ONCE(!IS_ALIGNED(pos, range_len(&block->range))))
+		return -EINVAL;
+
+	if (count > range_len(&block->range))
+		count = range_len(&block->range);
+
+	if (copy_from_user(&v, buf, count))
+		return -EFAULT;
+
+	ret = block->write(cxl, &v, pos, count);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+ssize_t vfio_cxl_core_config_rw(struct vfio_device *vdev, char __user *buf,
+				size_t count, loff_t *ppos, bool write)
+{
+	struct vfio_pci_core_device *pci =
+		container_of(vdev, struct vfio_pci_core_device, vdev);
+	struct vfio_cxl_core_device *cxl =
+		container_of(pci, struct vfio_cxl_core_device, pci_core);
+	size_t done = 0;
+	ssize_t ret = 0;
+	loff_t tmp, pos = *ppos;
+
+	while (count) {
+		tmp = pos;
+
+		if (count >= 4 && IS_ALIGNED(pos, 4))
+			ret = 4;
+		else if (count >= 2 && IS_ALIGNED(pos, 2))
+			ret = 2;
+		else
+			ret = 1;
+
+		if (write)
+			ret = emulate_write(&cxl->config_regblocks_head,
+					    vdev, buf, ret, &tmp);
+		else
+			ret = emulate_read(&cxl->config_regblocks_head,
+					   vdev, buf, ret, &tmp);
+		if (ret < 0)
+			return ret;
+
+		count -= ret;
+		done += ret;
+		buf += ret;
+		pos += ret;
+	}
+
+	*ppos += done;
+	return done;
+}
+
+ssize_t vfio_cxl_core_mmio_bar_rw(struct vfio_device *vdev, char __user *buf,
+				  size_t count, loff_t *ppos, bool write)
+{
+	struct vfio_pci_core_device *pci =
+		container_of(vdev, struct vfio_pci_core_device, vdev);
+	struct vfio_cxl_core_device *cxl =
+		container_of(pci, struct vfio_cxl_core_device, pci_core);
+	size_t done = 0;
+	ssize_t ret = 0;
+	loff_t tmp, pos = *ppos;
+
+	while (count) {
+		tmp = pos;
+
+		if (count >= 4 && IS_ALIGNED(pos, 4))
+			ret = 4;
+		else if (count >= 2 && IS_ALIGNED(pos, 2))
+			ret = 2;
+		else
+			ret = 1;
+
+		if (write)
+			ret = emulate_write(&cxl->mmio_regblocks_head,
+					    vdev, buf, ret, &tmp);
+		else
+			ret = emulate_read(&cxl->mmio_regblocks_head,
+					   vdev, buf, ret, &tmp);
+		if (ret < 0)
+			return ret;
+
+		count -= ret;
+		done += ret;
+		buf += ret;
+		pos += ret;
+	}
+
+	*ppos += done;
+	return done;
+}
diff --git a/drivers/vfio/pci/vfio_cxl_core_priv.h b/drivers/vfio/pci/vfio_cxl_core_priv.h
new file mode 100644
index 000000000000..b5d96e3872d2
--- /dev/null
+++ b/drivers/vfio/pci/vfio_cxl_core_priv.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef VFIO_CXL_CORE_PRIV_H
+#define VFIO_CXL_CORE_PRIV_H
+
+#include <linux/vfio_pci_core.h>
+
+#include "vfio_pci_priv.h"
+
+void vfio_cxl_core_clean_register_emulation(struct vfio_cxl_core_device *cxl);
+int vfio_cxl_core_setup_register_emulation(struct vfio_cxl_core_device *cxl);
+
+ssize_t vfio_cxl_core_config_rw(struct vfio_device *vdev, char __user *buf,
+				size_t count, loff_t *ppos, bool write);
+ssize_t vfio_cxl_core_mmio_bar_rw(struct vfio_device *vdev, char __user *buf,
+				  size_t count, loff_t *ppos, bool write);
+
+#endif
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index a6885b48f26f..12ded67c7db7 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -117,13 +117,40 @@ struct vfio_cxl {
 	struct vfio_cxl_region region;
 };
 
+struct vfio_cxl_core_device;
+
+struct vfio_emulated_regblock {
+	struct range range;
+	ssize_t (*read)(struct vfio_cxl_core_device *cxl, void *buf,
+			u64 offset, u64 size);
+	ssize_t (*write)(struct vfio_cxl_core_device *cxl, void *buf,
+			 u64 offset, u64 size);
+	struct list_head list;
+};
+
 struct vfio_cxl_core_device {
 	struct vfio_pci_core_device pci_core;
 	struct vfio_cxl *cxl_core;
 
+	struct list_head config_regblocks_head;
+	struct list_head mmio_regblocks_head;
+
+	void *initial_comp_reg_virt;
+	void *comp_reg_virt;
+	u64 comp_reg_size;
+
+	void *initial_config_virt;
+	void *config_virt;
+	u64 config_size;
+
+	u16 dvsec;
+
 	u32 hdm_count;
 	u64 hdm_reg_offset;
 	u64 hdm_reg_size;
+
+	int comp_reg_bar;
+	u64 comp_reg_offset;
 };
 
 struct vfio_cxl_dev_info {
@@ -222,5 +249,7 @@ ssize_t vfio_cxl_core_read(struct vfio_device *core_vdev, char __user *buf,
 			   size_t count, loff_t *ppos);
 ssize_t vfio_cxl_core_write(struct vfio_device *core_vdev, const char __user *buf,
 			    size_t count, loff_t *ppos);
+long vfio_cxl_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
+			 unsigned long arg);
 
 #endif /* VFIO_PCI_CORE_H */
-- 
2.25.1


