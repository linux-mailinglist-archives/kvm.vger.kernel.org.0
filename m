Return-Path: <kvm+bounces-27251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ED3FB97E1A5
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 14:51:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B2CE1F2137C
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 12:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E460BE6F;
	Sun, 22 Sep 2024 12:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eSXsuVZf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189A5645
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 12:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727009438; cv=fail; b=LOqtke/OjQRYbbRfcp7VABBjrDJNB6Iq8kjBiUydPFLsV4+RTbmeFO5eh3jMgkEC/O5wx0TbATPy7VFvgRE0U1KRmMjOTpkpsthHXqxqRFr9fV8OxFA4Mit/3qBWVEk4fWPQSPwmf3fetutcpiawa5ufPcfysHWVXjvoH+O/mCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727009438; c=relaxed/simple;
	bh=N3PD2eEjIn2yzOXwiid2f/sbIF1lMCn0jPjQINEKnJc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oHpzrYzCX817tf7G3F9PqZT2vsrazgu0n9v4YubzG+UydBybjnAs9FYT6OxLyMH0LKMBIKtqE6fjHyMyfmLvQvUSaeeCWxJD2woDukJ4hSBu497Z7Skgg79SRkhwXb5vc27jxGaMX68Lhl5sG5jjAW/vp9ufYnbcWvAwmGlCOEc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eSXsuVZf; arc=fail smtp.client-ip=40.107.237.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iQSdVEJfIyH5CRh8bnXU5Rxit+yncuNaVO16UdybgYHfgJ/W1ffYi3G/bGSVuSpRL7eD0cMKuUAMr7Y2/Vuf0SB7Q/FY81gEIopTIvJuZXCzdE71c18V+MIXAhiFcY9/+OfxA7CkyzXr4Jq7YgOD/GC+9iaxP0nuKSFWv/ntqAUHnIKThIqRLBTNguAX7BZxf7Z7Wc5aKHKSwBCv+zQNGXxae5rYWcETbh71C3VKP33sv4M0RyNRow2kJZs8iu1reR2PE9jUUusKVSv4omQZk4Guwpj2VDBSzqQ54kG06LdvWuJg2CVB/mGY2sicLX8/zn33iE1kgc0K7O5uM4QyzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nx273nmDeUobuIlmdXJNLUGMxhf++1hApE+yWwM2oPM=;
 b=m1+39mqAWd37tnJRuKpfuMa4DRuthwHP918ABrZCq4rYStS8CZQ21Bozad5nUCvUgYEfyVJBb5aVEr9MrJXuYVPZrndm/N2zl5Q8eo17vGVugA60lvOkDVm+Q2QVMcH3vi97adaEQT/Cocgm52CHSU+8cZMxgRfWcPQ/Z8lhvsSnd4NwBO6DnchGBgGsw2B7ndH//leuydN8lEYwW7dpGTrpTxP6JahHj8kBskMn9UdZwW8BLrXwGV3pqnfnd+DEIMOE51MLm21fT9G/pioAoHkOyKd0ac6GyhDI7n5k0z1I0DmjBdJ05xrK6NBGG6kDjp5apAobgLof8Bs1fB3a+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nx273nmDeUobuIlmdXJNLUGMxhf++1hApE+yWwM2oPM=;
 b=eSXsuVZf8rnHCgb8AayNTh5B2ipvOq0yOY9vNUFZiI0cBfaS2P+rSP1raaT/yNIMoObE5uS0gFre+u5WKUj4MMne4zbQIjYN1pJ4839EumDQMa5kbuNJ2ls1lfwaXNNOuCA/tb7+1oKl/s74ZfhSYpyQNkLkx4DSgw1mH5O3/ubFmh9fwp784naU6PLL+7SoiXKdO8YpbR/AX/TgqPhXIq7EHp5zhjiwuG8eAC/Cck7XVtNA7wPSNgfMg/yf7d+pPGlK9vcw4B3WbqettEoPSqe1PlLbS5/lniCw/hW4mEzb0i8O+Y0mw2HDSlN/nCs89eD+Y0XQoBtJwgvPerkQlw==
Received: from BN9PR03CA0283.namprd03.prod.outlook.com (2603:10b6:408:f5::18)
 by SA1PR12MB6775.namprd12.prod.outlook.com (2603:10b6:806:25a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.24; Sun, 22 Sep
 2024 12:50:29 +0000
Received: from BL6PEPF00020E66.namprd04.prod.outlook.com
 (2603:10b6:408:f5:cafe::73) by BN9PR03CA0283.outlook.office365.com
 (2603:10b6:408:f5::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.27 via Frontend
 Transport; Sun, 22 Sep 2024 12:50:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF00020E66.mail.protection.outlook.com (10.167.249.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 22 Sep 2024 12:50:29 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 22 Sep
 2024 05:50:20 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 22 Sep 2024 05:50:19 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sun, 22 Sep 2024 05:50:19 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <nouveau@lists.freedesktop.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 01/29] nvkm/vgpu: introduce NVIDIA vGPU support prelude
Date: Sun, 22 Sep 2024 05:49:23 -0700
Message-ID: <20240922124951.1946072-2-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240922124951.1946072-1-zhiw@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E66:EE_|SA1PR12MB6775:EE_
X-MS-Office365-Filtering-Correlation-Id: 108d6cd6-6a13-4f75-3757-08dcdb05234c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?snWZ8AbsFsdEGxqV6rkQSqySAyQ4q42yXs0zPj21flskujrIW0SyWJIjRhDA?=
 =?us-ascii?Q?ygvn3xwtODLfk6WNhyrWG0EHr3NCOZTyWr5zpp++WixqlL1iwI1DYmZtA/X0?=
 =?us-ascii?Q?a4faWxLeGH6s/pOCHbH30P4+RWyjP6qRm9NrH+rrvhZsLNHxEX5UsrVTYQIK?=
 =?us-ascii?Q?oPavOnUTbCLwUSHqYUOHbJ5FWMavw0OWmHRVjSiVuoMhWAyoB6MpsKEHPXXZ?=
 =?us-ascii?Q?Rt6qqK2Hic+C6IjuJ5UrVDCNy6kXyhYpd86gE4c/d5P+cEo3WSR0XzUKs+Ah?=
 =?us-ascii?Q?P/pymQAtTR6SCgLuzkCkVnLLhIHHKLQVaQyF8KbUW0335ks0mSizNpR2Zk7e?=
 =?us-ascii?Q?l7TUMUZHQKr7nvlyXws8Rssm/lSRNoRij0iA/zY67A3mQfJRcHU6SPnbxSI/?=
 =?us-ascii?Q?xy8D4cIqsSACQjuxZ0K4aVHHYn4v2UljsFx1ZMUAVDGOoFjc8h3/zjKIolwA?=
 =?us-ascii?Q?PVCj1qpV4gybJCozNLLitsz5o86/DEjJOYNpQvh63RdDXYS+wuBOhbPErILY?=
 =?us-ascii?Q?FiBgunLVu0Y3JrGxG86ijy+/LO8HHljFOuBeDFivDIZF8+eVkPAK9rXfap16?=
 =?us-ascii?Q?rf8c7PN9Bsifo+KZmQBQQLOk6ePIVkRCp7pwz0rt3J9CYBLegbdLgUnnma0u?=
 =?us-ascii?Q?GKLjPPQuAhNt05EPdsoT/pDEuyPYxq+AFGx7VeSAlNTdofjM+cGySIvoqXXg?=
 =?us-ascii?Q?BvgyBumJPRGrTsKqENZA8hyWUhJKgcXQSB9/0kFZSagwpdboBFwLHDgYE+s1?=
 =?us-ascii?Q?XwMLluis3NwNoMndRuO9heomuFvHRGmKtPB+OtuNfxpY6OHlDioH3J6krJ5c?=
 =?us-ascii?Q?9rtBDyD9Edt2/sbupLvjSEAvzr4a+bvNfT8CXs95eWuqpiyiXyQVCPqj3vxb?=
 =?us-ascii?Q?pNbq3ZQgh0hYuvFbNmb3ttlPC/yl0OYCgjTZ56/hPuYSx1wEcTdAN3imqGgJ?=
 =?us-ascii?Q?kyKhPjPYeTAQdA0UGPMaUc5ox1TFBYmGEqoNA2xo4XJGZmBRE1/F7m1EmK7v?=
 =?us-ascii?Q?Gmsr5CKwyf8BOoVRqOLkMol0+++n4g4pN4/Vk1r408tyjD74I20fn4sRXi/8?=
 =?us-ascii?Q?iYXreevpHfdFfEJn80xyLHHL+L5ahoENqOwwUfuzLPdmzl3XXEhcKKUlw+T/?=
 =?us-ascii?Q?WkyKlolEGuwNH2V8lI+I5JjsXTUxzh4Liow8L0EtHEQ+yFf6s8IEsPswqxAG?=
 =?us-ascii?Q?kK6iv8+1NsD75tPnPvjR8kEGmFrsLNofzyySBiUWT/Km0MdM3LsTmalCVyX0?=
 =?us-ascii?Q?bKAwnZpy8yb7T2xcCDrAIM+EBGrmUa8PPCb4AA4bHi4Qj10bi/GTIbQnlRbC?=
 =?us-ascii?Q?+7XBFsfL1Zfaep3I8ofRxB1s56OBrC0RFQaVzZN26CFIBBiJOaw14kkMtmLZ?=
 =?us-ascii?Q?DtGTk/eTQnljf9NigG9AQV28i0pGSiTrDvw3ZugFa37xlTSyHORx4ioyTA/9?=
 =?us-ascii?Q?3yLE8pXMzTUiK2Cpj/WoJweYOd0OEtEc?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 12:50:29.1409
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 108d6cd6-6a13-4f75-3757-08dcdb05234c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E66.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6775

NVIDIA GPU virtualization is a technology that allows multiple virtual
machines (VMs) to share the power of a single GPU, enabling greater
flexibility, efficiency, and cost-effectiveness in data centers and cloud
environments.

The first step of supporting NVIDIA vGPU in nvkm is to introduce the
necessary vGPU data structures and functions to hook into the
(de)initialization path of nvkm.

Introduce NVIDIA vGPU data structures and functions hooking into the
the (de)initialization path of nvkm and support the following patches.

Cc: Neo Jia <cjia@nvidia.com>
Cc: Surath Mitra <smitra@nvidia.com>
Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 .../drm/nouveau/include/nvkm/core/device.h    |  3 +
 .../nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h  | 17 +++++
 drivers/gpu/drm/nouveau/nvkm/Kbuild           |  1 +
 drivers/gpu/drm/nouveau/nvkm/device/pci.c     | 19 +++--
 drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/Kbuild  |  2 +
 .../gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c  | 76 +++++++++++++++++++
 6 files changed, 112 insertions(+), 6 deletions(-)
 create mode 100644 drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
 create mode 100644 drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/Kbuild
 create mode 100644 drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c

diff --git a/drivers/gpu/drm/nouveau/include/nvkm/core/device.h b/drivers/gpu/drm/nouveau/include/nvkm/core/device.h
index fef8ca74968d..497c52f51593 100644
--- a/drivers/gpu/drm/nouveau/include/nvkm/core/device.h
+++ b/drivers/gpu/drm/nouveau/include/nvkm/core/device.h
@@ -3,6 +3,7 @@
 #define __NVKM_DEVICE_H__
 #include <core/oclass.h>
 #include <core/intr.h>
+#include <vgpu_mgr/vgpu_mgr.h>
 enum nvkm_subdev_type;
 
 #include <linux/auxiliary_bus.h>
@@ -80,6 +81,8 @@ struct nvkm_device {
 		bool legacy_done;
 	} intr;
 
+	struct nvkm_vgpu_mgr vgpu_mgr;
+
 	struct auxiliary_device auxdev;
 	const struct nvif_driver_func *driver;
 };
diff --git a/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h b/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
new file mode 100644
index 000000000000..3163fff1085b
--- /dev/null
+++ b/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: MIT */
+#ifndef __NVKM_VGPU_MGR_H__
+#define __NVKM_VGPU_MGR_H__
+
+#define NVIDIA_MAX_VGPUS 2
+
+struct nvkm_vgpu_mgr {
+	bool enabled;
+	struct nvkm_device *nvkm_dev;
+};
+
+bool nvkm_vgpu_mgr_is_supported(struct nvkm_device *device);
+bool nvkm_vgpu_mgr_is_enabled(struct nvkm_device *device);
+int nvkm_vgpu_mgr_init(struct nvkm_device *device);
+void nvkm_vgpu_mgr_fini(struct nvkm_device *device);
+
+#endif
diff --git a/drivers/gpu/drm/nouveau/nvkm/Kbuild b/drivers/gpu/drm/nouveau/nvkm/Kbuild
index 9e1a6ab937e1..d310467487c1 100644
--- a/drivers/gpu/drm/nouveau/nvkm/Kbuild
+++ b/drivers/gpu/drm/nouveau/nvkm/Kbuild
@@ -8,3 +8,4 @@ include $(src)/nvkm/device/Kbuild
 include $(src)/nvkm/falcon/Kbuild
 include $(src)/nvkm/subdev/Kbuild
 include $(src)/nvkm/engine/Kbuild
+include $(src)/nvkm/vgpu_mgr/Kbuild
diff --git a/drivers/gpu/drm/nouveau/nvkm/device/pci.c b/drivers/gpu/drm/nouveau/nvkm/device/pci.c
index b8d2125a9f59..1543902b20e9 100644
--- a/drivers/gpu/drm/nouveau/nvkm/device/pci.c
+++ b/drivers/gpu/drm/nouveau/nvkm/device/pci.c
@@ -1688,6 +1688,9 @@ nvkm_device_pci_remove(struct pci_dev *dev)
 {
 	struct nvkm_device *device = pci_get_drvdata(dev);
 
+	if (nvkm_vgpu_mgr_is_enabled(device))
+		nvkm_vgpu_mgr_fini(device);
+
 	if (device->runpm) {
 		pm_runtime_get_sync(device->dev);
 		pm_runtime_forbid(device->dev);
@@ -1835,12 +1838,6 @@ nvkm_device_pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	}
 
 	quirk_broken_nv_runpm(pdev);
-done:
-	if (ret) {
-		nvkm_device_del(&device);
-		return ret;
-	}
-
 	pci_set_drvdata(pci_dev, &pdev->device);
 
 	if (nvkm_runpm) {
@@ -1852,12 +1849,22 @@ nvkm_device_pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 		}
 	}
 
+	if (nvkm_vgpu_mgr_is_supported(device)) {
+		ret = nvkm_vgpu_mgr_init(&pdev->device);
+		if (ret)
+			goto done;
+	}
+
 	if (device->runpm) {
 		pm_runtime_allow(device->dev);
 		pm_runtime_put(device->dev);
 	}
 
 	return 0;
+
+done:
+	nvkm_device_del(&device);
+	return ret;
 }
 
 static struct pci_device_id
diff --git a/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/Kbuild b/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/Kbuild
new file mode 100644
index 000000000000..244e967d4edc
--- /dev/null
+++ b/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/Kbuild
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: MIT
+nvkm-y += nvkm/vgpu_mgr/vgpu_mgr.o
diff --git a/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c b/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c
new file mode 100644
index 000000000000..a506414e5ba2
--- /dev/null
+++ b/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: MIT */
+#include <core/device.h>
+#include <core/pci.h>
+#include <vgpu_mgr/vgpu_mgr.h>
+
+static bool support_vgpu_mgr = false;
+module_param_named(support_vgpu_mgr, support_vgpu_mgr, bool, 0400);
+
+static inline struct pci_dev *nvkm_to_pdev(struct nvkm_device *device)
+{
+	struct nvkm_device_pci *pci = container_of(device, typeof(*pci),
+						   device);
+
+	return pci->pdev;
+}
+
+/**
+ * nvkm_vgpu_mgr_is_supported - check if a platform support vGPU
+ * @device: the nvkm_device pointer
+ *
+ * Returns: true on supported platform which is newer than ADA Lovelace
+ * with SRIOV support.
+ */
+bool nvkm_vgpu_mgr_is_supported(struct nvkm_device *device)
+{
+	struct pci_dev *pdev = nvkm_to_pdev(device);
+
+	if (!support_vgpu_mgr)
+		return false;
+
+	return device->card_type == AD100 &&  pci_sriov_get_totalvfs(pdev);
+}
+
+/**
+ * nvkm_vgpu_mgr_is_enabled - check if vGPU support is enabled on a PF
+ * @device: the nvkm_device pointer
+ *
+ * Returns: true if vGPU enabled.
+ */
+bool nvkm_vgpu_mgr_is_enabled(struct nvkm_device *device)
+{
+	return device->vgpu_mgr.enabled;
+}
+
+/**
+ * nvkm_vgpu_mgr_init - Initialize the vGPU manager support
+ * @device: the nvkm_device pointer
+ *
+ * Returns: 0 on success, -ENODEV on platforms that are not supported.
+ */
+int nvkm_vgpu_mgr_init(struct nvkm_device *device)
+{
+	struct nvkm_vgpu_mgr *vgpu_mgr = &device->vgpu_mgr;
+
+	if (!nvkm_vgpu_mgr_is_supported(device))
+		return -ENODEV;
+
+	vgpu_mgr->nvkm_dev = device;
+	vgpu_mgr->enabled = true;
+
+	pci_info(nvkm_to_pdev(device),
+		 "NVIDIA vGPU mananger support is enabled.\n");
+
+	return 0;
+}
+
+/**
+ * nvkm_vgpu_mgr_fini - De-initialize the vGPU manager support
+ * @device: the nvkm_device pointer
+ */
+void nvkm_vgpu_mgr_fini(struct nvkm_device *device)
+{
+	struct nvkm_vgpu_mgr *vgpu_mgr = &device->vgpu_mgr;
+
+	vgpu_mgr->enabled = false;
+}
-- 
2.34.1


