Return-Path: <kvm+bounces-65572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D59DCB0ABC
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 18:09:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CC3D630FE00A
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 17:03:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE05632FA28;
	Tue,  9 Dec 2025 16:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Jy7aucls"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010061.outbound.protection.outlook.com [52.101.46.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7522329E71;
	Tue,  9 Dec 2025 16:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765299189; cv=fail; b=Gzsa+LyQySbl118Gvu/ho5P6drIC1aoH2oBboET1erX5LhMzFpREhxJW73fFIEsEW1r27lN4BhatxZ/LA0YtQuti615qIl90Thf9KogAqeQPLo/oMr1l4sZdKkpZtox6e3KHO7j7KL2eD/3jVrqEGMYK5ReA8YesaR283lv1aIQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765299189; c=relaxed/simple;
	bh=gEEgQIOd9mT5oUTGlU3t3r/uaZai0pOuZ5Mm/9+SoJ4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eToi3pE5Rn/oxzZhSgP1m/4aRH0Ctahuc3VMYNjzqrjn5E2QjvENe8aQnGnvc+n05zuIclrzNxM4x2It8I7I6JyEzYUEhxW1pCFmoSq/wCGdCg4kvu6C6Pq0W0khspNk1ebQITDaggU/buGBQy7/tf0ymN9NgEmfeweul1Ra/9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Jy7aucls; arc=fail smtp.client-ip=52.101.46.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sx54D8Pa+dZ8TmIv4bgc0awgGTFiXt0w3wsBavpL3LgJ4YPDagi2OGTeLdL3bKesFq/CYzFmVh9+KBrRw6+3mxLNzkoTqm9syOBTYaoclrY7bTpJms0RtD90xuMbeOI4my+SdmoV9JSn8XGvYd8BPSLR6kgTzsda7nukwAlow7BxTFWy0J/xp48InI0P7yqRJzvb8PlAXl/eiVhoQmS5FHkh1aWE15Rwa/iQrB4TStV5idKwwyl0yB/JKA2xWafInCkta+sksOZt7e9jAL/Dq0a1FkxPqCvgT1YXk/WQcbCU7+hSqke2mw687PJyYkUEDZh2sSVk5mJVLr3JdQ7d7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kvYlUtczBtqzbs2dwfStWNHxVT4etEGFP5Sf8DJBnJg=;
 b=qjHZZOTzpi5yqVpEBzTaWO76k4qeaxE5Y9+lf6wJBZmvDvbIm10uXQezYyzDMgE0b3M/hpTj2qjcyBsMgiBsXYgIDHDI0AKL8/v6pm6JO+O/Lrs+rF1DqBMUp7Dyq8Yvl09PdDLqmAHWdf8mbtMyW5zDnbOsSYnJMKQImhwnAp2OAXSDUOJypZvXDu8UOp8+S5Ike0BemUlJvf22U/QAaOurgcV08eaE0TmWbQt+ZA5e0hKNAh/5mLA3RoG7Lu0ooCetei23J6qB/CyOlwkdv3Cpta5fIm+BwoXwgioEGwt6/roJujPtpuqSaTfYS+Hy00PU+JIjECSX6aklNHAwAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kvYlUtczBtqzbs2dwfStWNHxVT4etEGFP5Sf8DJBnJg=;
 b=Jy7auclsb5tfZ5DOj/q8gmU8Vhdr+vlWec313PiDpENjIUiqpJv39ZNS86l1rV0YR24YW9VRc+8n/b9JaKy6zpDZNi6iZgllxlGWqWizI5J04jYMpBhDi7G538WhAi8r3ouc9HQPup1NKiOxDwOfcMQYjlTQeYGImX/Vv5t7XR1lzupdC9wNueiI+BB66Giz9OkTjETX+L3grF9aU3HS6O7RBxAh5zo8UYf4/kaPf3SI0YrI2MNoiLgVOHx52U9fRC8XaYvAfUbakcdQjY6Up8Ut1y+vkF5X1lCXDoOc4EuXHVyS53nafmu8Cm9jIv6AwkQBLqwi52SoItbAD9Kkwg==
Received: from BY5PR03CA0012.namprd03.prod.outlook.com (2603:10b6:a03:1e0::22)
 by CH2PR12MB4166.namprd12.prod.outlook.com (2603:10b6:610:78::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.6; Tue, 9 Dec
 2025 16:52:52 +0000
Received: from SJ1PEPF00002312.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0:cafe::b8) by BY5PR03CA0012.outlook.office365.com
 (2603:10b6:a03:1e0::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.14 via Frontend Transport; Tue,
 9 Dec 2025 16:52:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002312.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 9 Dec 2025 16:52:51 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:52:28 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:52:27 -0800
Received: from nvidia-4028GR-scsim.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 9 Dec 2025 08:52:20 -0800
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
Subject: [RFC v2 13/15] vfio/pci: introduce CXL device awareness
Date: Tue, 9 Dec 2025 22:20:17 +0530
Message-ID: <20251209165019.2643142-14-mhonap@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002312:EE_|CH2PR12MB4166:EE_
X-MS-Office365-Filtering-Correlation-Id: c2c78d13-2cf5-4309-9aea-08de37436405
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?02MgoSwtP1wFlIadi7GmXhkwGuAiNUdQQ3Mn2WrTydLaGuF0d8mUAYk2W0O6?=
 =?us-ascii?Q?x92scuGZc2SmOQCvr5lWEUC6FYwfVwE4AZO6vpfJWokOJyx1onXBbgxqj7Sw?=
 =?us-ascii?Q?IVLQDC0KFgdLJ2aoN9kj10nmU8ZdpdP36frqa1piP8XcL3w7KOXtDBa/voUI?=
 =?us-ascii?Q?8t6ErFiglMDMz4Rs2mI+Hdacj1NWII9RljLUMnFVe6rdwEYA/+kdi3SyiOVm?=
 =?us-ascii?Q?OUBzKfJ0uRgdavkBhGpZiy1NaHWFYNdBY+vuidnLpjE7PIUExuFQA9/afPNe?=
 =?us-ascii?Q?/rI0gotuzxXzbkmq2b5JNrn0AX+/cCtmBPFM+RMr/sA9n+/AzLD1DkDmtMZ+?=
 =?us-ascii?Q?x0IE9oUYXgVOpKutZpe7n0r68qSmRH2Yt14dbko98M+v5TdLPgGWHHsXCsqq?=
 =?us-ascii?Q?QiCGaYQhlA6DK4hzNKiQCZM2I/Ei2JaxMScHMndm7zxcmBliB6xMOM3myi9d?=
 =?us-ascii?Q?omksgnxE/Ejy8S3HB+anDt1EFz4c9D6jVQ/Te1hc+gdViTL/qybtc//NqiUZ?=
 =?us-ascii?Q?07YtVKyuTi2YDfEHqtdtb9s9At8I5o30dp5kD8zv8Ndr3VLhRhhSVyU7BKB/?=
 =?us-ascii?Q?1nXR8FjyKL9pVp5BDi8VYY5HsSZLheV+Sa4bENtWB/+0id6EQM5oRo0lm/na?=
 =?us-ascii?Q?Pn2GGT6aAhG6TsTPFA2Xa3XNOAqHP7k5ywyG/OFbCxa5wyPFWlEcxPHwnxTd?=
 =?us-ascii?Q?L7AYOPUj2VTGXRsw2MeesJ67XjqSSSVNre+QRkHuc1xTs1s3BuftnjW4ZlBE?=
 =?us-ascii?Q?Bm0djXcEOOK37LZghx0AlatoGlLVf28a8bXmlaTvoGaCl7pSecpKhtbg2sh3?=
 =?us-ascii?Q?sU8XQC+qMwWOrYelBo986N+CBPKyj568gj4fi5txYpAe5Zp1xm2I2Ki9LgBI?=
 =?us-ascii?Q?8JAKrJ87iCCEL68Zn2jm0cYofNavKJOIaw+hmri45t1mKI117dh1/9wN7V8G?=
 =?us-ascii?Q?yCT2cU3KPdkGgMtrHQlBOHBEHqmKGvfyW8IDaIyN6Tb/3hzUCzKB5yNjBcd1?=
 =?us-ascii?Q?CJHq+Qg5IGExwc2S7I/WiMQW1RkXL3JhZzsdW2wJM01Aw4naLpEqFwq83m5i?=
 =?us-ascii?Q?Sk4vCWWVB2oL6hyRkzb2zFLPicl5rc5iMu+at6mXTUwivEGu2mwD8TigrYyI?=
 =?us-ascii?Q?ifrWMirxCKfMKC4omiDNldqH9eWpwUZwV8zve3AgofN5GUyt5wMGgXphZG9g?=
 =?us-ascii?Q?EqK5Yn8X1xWYmSl+SgxAsFCywdrOOhddkTGD5iomvbJDcdA3hwuH6rRWbpAV?=
 =?us-ascii?Q?z30z745zQTHkrK7ZyL/XnoBJwf7HW5RZWIUAbGVDeRI7g5lj/iGEgeQr2y/1?=
 =?us-ascii?Q?iucZXzowqi44EZ8WV3eT9aoNeJJakLHvlIfUsM4IhK+orltIZlkzdtnDhpTV?=
 =?us-ascii?Q?iJ2cUhtiXE6rqJvLe2EsVSkWxbjOKrw5enp4rBWF/3RvNXDZftGQDBhpEEp1?=
 =?us-ascii?Q?Gg2FURmZwrWHP4GkINKdCl8Po0QJhVOwv8hZf2Z00O9Wu1v0jQQALwMgGOH4?=
 =?us-ascii?Q?ZVcML/AQMtRiVjEvFYxDi1cbUUhMIBfX3q8+JZ2Lz4WV9YoX/X0riaZulooG?=
 =?us-ascii?Q?F0ZUqcEz6RukFczxy1zXIdSCFOQ3HA1Z8GKbJgYT?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 16:52:51.2078
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2c78d13-2cf5-4309-9aea-08de37436405
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002312.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4166

From: Zhi Wang <zhiw@nvidia.com>

CXL device programming interfaces are built upon PCI interfaces. Thus
the vfio-pci-core can be leveraged to handle a CXL device.

However, CXL device also has difference with PCI devicce:

- No INTX support, only MSI/MSIX is supported.
- Reset is done via CXL reset. FLR only reset CXL.io.

Introduce the CXL device awareness to the vfio-pci-core. Expose a new
VFIO device flags to the userspace to identify the VFIO device is a CXL
device. Disable INTX support in the vfio-pci-core. Disable FLR reset for
the CXL device as the kernel CXL core hasn't support CXL reset yet.
Disable mmap support on the CXL MMIO BAR in vfio-pci-core.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Manish Honap <mhonap@nvidia.com>
---
 drivers/vfio/pci/vfio_cxl_core.c | 18 +++++++++++++++++
 drivers/vfio/pci/vfio_pci_core.c | 33 ++++++++++++++++++++++++++++----
 drivers/vfio/pci/vfio_pci_rdwr.c | 11 ++++++++---
 include/linux/vfio_pci_core.h    |  3 +++
 include/uapi/linux/vfio.h        | 10 ++++++++++
 5 files changed, 68 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/vfio_cxl_core.c b/drivers/vfio/pci/vfio_cxl_core.c
index c0bdf55997da..84e4f42d97de 100644
--- a/drivers/vfio/pci/vfio_cxl_core.c
+++ b/drivers/vfio/pci/vfio_cxl_core.c
@@ -25,6 +25,19 @@
 #define DRIVER_AUTHOR "Zhi Wang <zhiw@nvidia.com>"
 #define DRIVER_DESC "core driver for VFIO based CXL devices"
 
+static void init_cxl_cap(struct vfio_cxl_core_device *cxl)
+{
+	struct vfio_pci_core_device *pci = &cxl->pci_core;
+	struct vfio_device_info_cap_cxl *cap = &pci->cxl_cap;
+
+	cap->header.id = VFIO_DEVICE_INFO_CAP_CXL;
+	cap->header.version = 1;
+	cap->hdm_count = cxl->hdm_count;
+	cap->hdm_reg_offset = cxl->comp_reg_offset + cxl->hdm_reg_offset;
+	cap->hdm_reg_size = cxl->hdm_reg_size;
+	cap->hdm_reg_bar_index = cxl->comp_reg_bar;
+}
+
 /* Standard CXL-type 2 driver initialization sequence */
 static int enable_cxl(struct vfio_cxl_core_device *cxl, u16 dvsec,
 		      struct vfio_cxl_dev_info *info)
@@ -74,6 +87,8 @@ static int enable_cxl(struct vfio_cxl_core_device *cxl, u16 dvsec,
 	if (IS_ERR(cxl_core->cxlmd))
 		return PTR_ERR(cxl_core->cxlmd);
 
+	init_cxl_cap(cxl);
+
 	cxl_core->region.noncached = info->noncached_region;
 
 	return 0;
@@ -266,6 +281,9 @@ int vfio_cxl_core_enable(struct vfio_cxl_core_device *cxl,
 	if (ret)
 		return ret;
 
+	pci->is_cxl = true;
+	pci->comp_reg_bar = cxl->comp_reg_bar;
+
 	ret = vfio_pci_core_enable(pci);
 	if (ret)
 		goto err_pci_core_enable;
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 502880e927fc..5f8334748841 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -483,7 +483,12 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 		goto out_power;
 
 	/* If reset fails because of the device lock, fail this path entirely */
-	ret = pci_try_reset_function(pdev);
+	if (!vdev->is_cxl)
+		ret = pci_try_reset_function(pdev);
+	else
+		/* TODO: CXL reset support is on-going. */
+		ret = -ENODEV;
+
 	if (ret == -EAGAIN)
 		goto out_disable_device;
 
@@ -618,8 +623,12 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 		if (!vdev->barmap[bar])
 			continue;
 		pci_iounmap(pdev, vdev->barmap[bar]);
-		pci_release_selected_regions(pdev, 1 << bar);
 		vdev->barmap[bar] = NULL;
+
+		if (vdev->is_cxl && i == vdev->comp_reg_bar)
+			continue;
+
+		pci_release_selected_regions(pdev, 1 << bar);
 	}
 
 	list_for_each_entry_safe(dummy_res, tmp,
@@ -960,6 +969,15 @@ static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
 	if (vdev->reset_works)
 		info.flags |= VFIO_DEVICE_FLAGS_RESET;
 
+	if (vdev->is_cxl) {
+		ret = vfio_info_add_capability(&caps, &vdev->cxl_cap.header,
+					       sizeof(vdev->cxl_cap));
+		if (ret)
+			return ret;
+
+		info.flags |= VFIO_DEVICE_FLAGS_CXL;
+	}
+
 	info.num_regions = VFIO_PCI_NUM_REGIONS + vdev->num_regions;
 	info.num_irqs = VFIO_PCI_NUM_IRQS;
 
@@ -1752,14 +1770,21 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 	 * we need to request the region and the barmap tracks that.
 	 */
 	if (!vdev->barmap[index]) {
+		int bars;
+
+		if (vdev->is_cxl && vdev->comp_reg_bar == index)
+			bars = 0;
+		else
+			bars = 1 << index;
+
 		ret = pci_request_selected_regions(pdev,
-						   1 << index, "vfio-pci");
+						   bars, "vfio-pci");
 		if (ret)
 			return ret;
 
 		vdev->barmap[index] = pci_iomap(pdev, index, 0);
 		if (!vdev->barmap[index]) {
-			pci_release_selected_regions(pdev, 1 << index);
+			pci_release_selected_regions(pdev, bars);
 			return -ENOMEM;
 		}
 	}
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 6192788c8ba3..057cd0c69f2a 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -201,19 +201,24 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_do_io_rw);
 int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
 {
 	struct pci_dev *pdev = vdev->pdev;
-	int ret;
+	int bars, ret;
 	void __iomem *io;
 
 	if (vdev->barmap[bar])
 		return 0;
 
-	ret = pci_request_selected_regions(pdev, 1 << bar, "vfio");
+	if (vdev->is_cxl && vdev->comp_reg_bar == bar)
+		bars = 0;
+	else
+		bars = 1 << bar;
+
+	ret = pci_request_selected_regions(pdev, bars, "vfio");
 	if (ret)
 		return ret;
 
 	io = pci_iomap(pdev, bar, 0);
 	if (!io) {
-		pci_release_selected_regions(pdev, 1 << bar);
+		pci_release_selected_regions(pdev, bars);
 		return -ENOMEM;
 	}
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 8293910e0a96..0a354c7788b3 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -82,6 +82,9 @@ struct vfio_pci_core_device {
 	bool			needs_pm_restore:1;
 	bool			pm_intx_masked:1;
 	bool			pm_runtime_engaged:1;
+	bool                    is_cxl:1;
+	int                     comp_reg_bar;
+	struct vfio_device_info_cap_cxl cxl_cap;
 	struct pci_saved_state	*pci_saved_state;
 	struct pci_saved_state	*pm_save;
 	int			ioeventfds_nr;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 95be987d2ed5..0a9968cd6601 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -214,6 +214,7 @@ struct vfio_device_info {
 #define VFIO_DEVICE_FLAGS_FSL_MC (1 << 6)	/* vfio-fsl-mc device */
 #define VFIO_DEVICE_FLAGS_CAPS	(1 << 7)	/* Info supports caps */
 #define VFIO_DEVICE_FLAGS_CDX	(1 << 8)	/* vfio-cdx device */
+#define VFIO_DEVICE_FLAGS_CXL   (1 << 9)        /* Device supports CXL */
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
 	__u32   cap_offset;	/* Offset within info struct of first cap */
@@ -256,6 +257,15 @@ struct vfio_device_info_cap_pci_atomic_comp {
 	__u32 reserved;
 };
 
+#define VFIO_DEVICE_INFO_CAP_CXL                6
+struct vfio_device_info_cap_cxl {
+	struct vfio_info_cap_header header;
+	__u8 hdm_count;
+	__u8 hdm_reg_bar_index;
+	__u64 hdm_reg_size;
+	__u64 hdm_reg_offset;
+};
+
 /**
  * VFIO_DEVICE_GET_REGION_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 8,
  *				       struct vfio_region_info)
-- 
2.25.1


