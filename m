Return-Path: <kvm+bounces-27250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7370A97E1A4
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 14:51:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39F552813F3
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 12:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E4049475;
	Sun, 22 Sep 2024 12:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="B80vG2Rn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2051.outbound.protection.outlook.com [40.107.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16F5321D
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 12:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727009438; cv=fail; b=NTuPmfcu7lYKaO/bvynayrpUCEn4oyxPqyduuGyjWJ3HB7XuAnPGnfSxFCHkJ0/qQ3IUruE0fak1bfheq/qu/zw8R/j7C5IBIOVRU+H5pnCAhhTCnhF0WuDtCqOCRRXdbUyqEj3bEKbvcDMHoG5QnskEVvZOUgIYtwjNYXzxfc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727009438; c=relaxed/simple;
	bh=zwOqDFNxAwmPTFe/jiPwyXD4ZPFK3OZYQtggKJAz0Uk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G/15wBY0Nq/modNM0EwIi62uZtUJRYjt5C6U9+VnZa4TAVaxC5zH1BozS/woORP5ez3PR7T3/nGZ+hDIHNA6Eh4Cftd16pyxIeYNH0nZIRbkL6U8x/+YPpZklfeQnh1IvIcetgVE7RT9l8zARiQ6Ds5nyi+ziX/SYSseoin6B3M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=B80vG2Rn; arc=fail smtp.client-ip=40.107.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OJahA80M8O5Ht0RPvbY214DUowsPmko39BfxSbBwJDF584BPiKezryEUB45z8EC227gvoJkosayoily2SUacgOzj87dUD7aCeuH61PlTrtOtIrlv3du+MlQxwQ95SVQ6QqJmj/vq9GuOnixj0TzUbhX9/FsOG2uE1jPTEDsUuNnihQowac0n/ZKTXpczJoumINH+DB/FZaVGGmi7/R5fkf3axicBbBkjIkCzH+xJg7qYWdMPqKH80ZB/LbvbOHUStRF77CANzOzl2peZsDcjht5G4I9wYxSdmQyZjcU2nbeO9i8erpVsyjehzm2eWgffGiIOPUNOx80kcxcestlY3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t5Se6NOULlWwT9b5/k8yOVdePxylOx55yZeC547knhY=;
 b=xozk9X0wiHBsAqriDYDxYLQbhDoqhYZr+S7j23S6W0r1epbgy2SuzNGBbfm2d2uddgzj9+zOLYELLExYYM2YBI3XmoKHacaCamLuuzgdMdrNm4WnZtrp0nMqA1f5b9gUMmMY/imdBPw3YF4KifgilOqPAN09XhpRm3dJdl/gL1/xaPz9AiRXxq8y5dwZ34M0e+6haNXjrqlTuAofH7qIfK3yP8GPp+TIovWCvLrNfmioZ6k4YeLIbsIaYRZx5roqvaS2t+NFvxPdiaM9V79nsCHGGSYk/Wvdkk8BUs7hI4dnGGdDt6VoqNlNFEv0y6kA++5RbZcNZ28gjj85DSvSiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t5Se6NOULlWwT9b5/k8yOVdePxylOx55yZeC547knhY=;
 b=B80vG2Rn4n5mkRtdrCV5g7X840e5mSo5LeoBtcr+MIldwldBAGiOoW2aHqEB+HuxOq64bd/zHR5u7d329ZBEHE5qGVbyzNRYXuLx9kuYrfydj2+mgiN2hHC3yc0f6pFGCI4dVxWK8Zo8tYLgveM6jsVMS7B36MiJTrM7wVuD74TvKjZ8mJdzpWYvjyiIjHqW2ddQxLFyZZCH0BfqDJoo+SUx86NXSGkA5TBZvwCi/KChM+hTcFY1TkruaX/V//2gPmCWfX6sjJJ/Wpzew0DDs+JmM2Or/5l8tT0qIppgFAugApoekUo4zyZFSslmIX131X26Mq+E8eIbATaTmF9i5Q==
Received: from BYAPR02CA0039.namprd02.prod.outlook.com (2603:10b6:a03:54::16)
 by IA0PR12MB7508.namprd12.prod.outlook.com (2603:10b6:208:440::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.24; Sun, 22 Sep
 2024 12:50:32 +0000
Received: from CO1PEPF000075F4.namprd03.prod.outlook.com
 (2603:10b6:a03:54:cafe::d9) by BYAPR02CA0039.outlook.office365.com
 (2603:10b6:a03:54::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.30 via Frontend
 Transport; Sun, 22 Sep 2024 12:50:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1PEPF000075F4.mail.protection.outlook.com (10.167.249.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 22 Sep 2024 12:50:31 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 22 Sep
 2024 05:50:22 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 22 Sep 2024 05:50:22 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sun, 22 Sep 2024 05:50:22 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <nouveau@lists.freedesktop.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 05/29] nvkm/vgpu: populate GSP_VF_INFO when NVIDIA vGPU is enabled
Date: Sun, 22 Sep 2024 05:49:27 -0700
Message-ID: <20240922124951.1946072-6-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F4:EE_|IA0PR12MB7508:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ce16585-104c-4c6a-fed3-08dcdb052492
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PUxBJFbJeOf9rK7theTz1g/fZmxWoAuYGMKHibxG1BH5C/jFl6EwTeHNQHgn?=
 =?us-ascii?Q?pq02KT3JlNoIgPdWpgxU6w7y5mZYYtFc1BnN2boP849e2jbhj8AuMOU2HUSQ?=
 =?us-ascii?Q?tUDlYj1I7J1sMB7rUT9dYs+W+MUkZMe7Qto/xZvdfKSm8wJU8cU40dApUpKZ?=
 =?us-ascii?Q?jD1yxBtCtse1oqnLaSc0uB6N0xD7fMDS3kGLaxddKdblpb1/pBn3f8Gi3dsU?=
 =?us-ascii?Q?m/6RPavkmN4cOqd5A88WLjEBMtww1+14og4lMshGkmQk36nomYVi0n6xnJcQ?=
 =?us-ascii?Q?oLbi+xnt6r6egosOWAQXkq53dcklOBRmJKVXYzzXTrGMipdHidNwKY0ZsL42?=
 =?us-ascii?Q?8neBu6/dUiE+onMl6UeRFo8rcRiijzMzEdpxLqkFBY3yAZVaN1StPVBF4ohK?=
 =?us-ascii?Q?OD7rapRcD4pscFuUqQqCUu8stflVr6VRst3ATHXscD1OwjOFlrIjxUexCWc7?=
 =?us-ascii?Q?rynionZXtZe8c5RTSTGYnjMbWhgnfLVenLyGLxhvoBnJI7PV6ZOMAsWFHB4p?=
 =?us-ascii?Q?PIo2ex5n51EPNHDVxG6P4q9wyUA9bikjkbLDS+WStoaCkiZQ2i5QF+M3UD1z?=
 =?us-ascii?Q?zHcSpr1d3Ek2akb7ifrnk9+bYOg8W0GufFRspdsTEpYGxvloaZ7BNp+WO9ic?=
 =?us-ascii?Q?+7LChy0S2VU7rK9PSmhDgGPeDVqVtEoVMqCuboNdcb1dTZGngfnWzmD4eprz?=
 =?us-ascii?Q?OdFPt2oBH71IrZNgpjKW3fzmGKohCwOeZMVG3j3m6LRFbLtdCjuyelMkOAZW?=
 =?us-ascii?Q?gM46CWnpFqakT3N1EqjfFnzJLuUpPMQdVhjzVkHyk+nCY8+FJ9oPXKL+jrE+?=
 =?us-ascii?Q?r+3ILaCl4M/oM+vhMDW4udu7YGRoHAb2Mbk8FKUzmwApMCxOurISj3ffel9m?=
 =?us-ascii?Q?pRO8+HqgeJJKFfznBK1QDxUbRWO7IZBa2kyfJlwruvZ1PQdI4A2+ebdQNUQx?=
 =?us-ascii?Q?Ddr1HVtsbMjEGcTwrrr0svMrniWfWZGWMehLi8Y6/QTVTNlO0K39D/Nmxk2t?=
 =?us-ascii?Q?0BiOB5d90pYeGqXmP28iZlwOAoYAo5rFNL0oFfXuMaoexFDNNq/xWE4ASSpd?=
 =?us-ascii?Q?iP4EHGRK9YNEp9gH5r6ypZFvAXeNxlClUSOvq7a0zaOSsoHVqYhF5WvbpAC3?=
 =?us-ascii?Q?+ZAA1RU46kwxkY/Fq3E4bVoJBD8V3XaNfboUoZ1jrQGCCArVOB8TjW7geMgD?=
 =?us-ascii?Q?Zk+7tHW7IJdeJRiPZNbIUUjxygz7SCa0GPtDFis8H+jdCr6AZGomVcy+JBBc?=
 =?us-ascii?Q?vx1TfxnA3fD24xTQ06XIGC9Ski8USBZXkLokhzBSgW1vaAti2f/hBZ/DMVvx?=
 =?us-ascii?Q?ofF42CyBKLQeHao/bXxr4Tu7opqgujx4uxLIwLw0TusmgMgiSwEIYS5V9XpR?=
 =?us-ascii?Q?e+Wrj6Q=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 12:50:31.3762
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ce16585-104c-4c6a-fed3-08dcdb052492
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7508

GSP firmware needs to know the VF BAR offsets to correctly calculate the
VF events.

The VF BAR information is stored in GSP_VF_INFO, which needs to be
initialized and uploaded together with the GSP_SYSTEM_INFO.

Populate GSP_VF_INFO when nvkm uploads the GSP_SYSTEM_INFO if NVIDIA
vGPU is enabled.

Cc: Surath Mitra <smitra@nvidia.com>
Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 .../nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h  |  2 +
 .../gpu/drm/nouveau/nvkm/subdev/gsp/r535.c    |  3 ++
 .../gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c  | 50 +++++++++++++++++++
 3 files changed, 55 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h b/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
index 9e10e18306b0..6bc10fa40cde 100644
--- a/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
+++ b/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
@@ -21,5 +21,7 @@ bool nvkm_vgpu_mgr_is_supported(struct nvkm_device *device);
 bool nvkm_vgpu_mgr_is_enabled(struct nvkm_device *device);
 int nvkm_vgpu_mgr_init(struct nvkm_device *device);
 void nvkm_vgpu_mgr_fini(struct nvkm_device *device);
+void nvkm_vgpu_mgr_populate_gsp_vf_info(struct nvkm_device *device,
+					void *info);
 
 #endif
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
index 14fc152d6859..49552d7df88f 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
@@ -1717,6 +1717,9 @@ r535_gsp_rpc_set_system_info(struct nvkm_gsp *gsp)
 	info->pciConfigMirrorSize = 0x001000;
 	r535_gsp_acpi_info(gsp, &info->acpiMethodData);
 
+	if (nvkm_vgpu_mgr_is_supported(device))
+		nvkm_vgpu_mgr_populate_gsp_vf_info(device, info);
+
 	return nvkm_gsp_rpc_wr(gsp, info, false);
 }
 
diff --git a/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c b/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c
index 0639596f8a96..d6ddb1f02275 100644
--- a/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c
+++ b/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c
@@ -3,6 +3,10 @@
 #include <core/driver.h>
 #include <nvif/driverif.h>
 #include <core/pci.h>
+
+#include <nvrm/nvtypes.h>
+#include <nvrm/535.113.01/nvidia/inc/kernel/gpu/gsp/gsp_static_config.h>
+
 #include <vgpu_mgr/vgpu_mgr.h>
 
 static bool support_vgpu_mgr = false;
@@ -120,3 +124,49 @@ void nvkm_vgpu_mgr_fini(struct nvkm_device *device)
 	detach_nvkm(vgpu_mgr);
 	vgpu_mgr->enabled = false;
 }
+
+/**
+ * nvkm_vgpu_mgr_populate_vf_info - populate GSP_VF_INFO when vGPU
+ * is enabled
+ * @device: the nvkm_device pointer
+ * @info: GSP_VF_INFO data structure
+ */
+void nvkm_vgpu_mgr_populate_gsp_vf_info(struct nvkm_device *device,
+					void *info)
+{
+	struct pci_dev *pdev = nvkm_to_pdev(device);
+	GspSystemInfo *gsp_info = info;
+	GSP_VF_INFO *vf_info = &gsp_info->gspVFInfo;
+	u32 lo, hi;
+	u16 v;
+	int pos;
+
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_SRIOV);
+
+	pci_read_config_word(pdev, pos + PCI_SRIOV_TOTAL_VF, &v);
+	vf_info->totalVFs = v;
+
+	pci_read_config_word(pdev, pos + PCI_SRIOV_VF_OFFSET, &v);
+	vf_info->firstVFOffset = v;
+
+	pci_read_config_dword(pdev, pos + PCI_SRIOV_BAR, &lo);
+	vf_info->FirstVFBar0Address = lo & 0xFFFFFFF0;
+
+	pci_read_config_dword(pdev, pos + PCI_SRIOV_BAR + 4, &lo);
+	pci_read_config_dword(pdev, pos + PCI_SRIOV_BAR + 8, &hi);
+
+	vf_info->FirstVFBar1Address = (((u64)hi) << 32) + (lo & 0xFFFFFFF0);
+
+	pci_read_config_dword(pdev, pos + PCI_SRIOV_BAR + 12, &lo);
+	pci_read_config_dword(pdev, pos + PCI_SRIOV_BAR + 16, &hi);
+
+	vf_info->FirstVFBar2Address = (((u64)hi) << 32) + (lo & 0xFFFFFFF0);
+
+#define IS_BAR_64(i) (((i) & 0x00000006) == 0x00000004)
+
+	v = nvkm_rd32(device, 0x88000 + 0xbf4);
+	vf_info->b64bitBar1 = IS_BAR_64(v);
+
+	v = nvkm_rd32(device, 0x88000 + 0xbfc);
+	vf_info->b64bitBar2 = IS_BAR_64(v);
+}
-- 
2.34.1


