Return-Path: <kvm+bounces-27273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F18E797E1BB
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 14:53:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95FAC2811BF
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 12:53:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 938F557CBB;
	Sun, 22 Sep 2024 12:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="clmClB04"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2068.outbound.protection.outlook.com [40.107.95.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76285579F
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 12:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727009463; cv=fail; b=FfdfD597+tJS5AlTOd5ZE3ZHrH4qsAvgid7qOIW3RiyMCPDKGtbN2V9Mr3C14v0qMuvtuuxgIlvbVPetE/2vgegjZhebcoTusJSgEDxiePgtfWyXDFsAi004e2yfEwi5kNFXT2+l+WDkcSpLoEb+rhxFp5c4BRuolysXOR6n8lg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727009463; c=relaxed/simple;
	bh=DklQhxhCW5x6FdxHtGiK0OVUal8h9o4jpYNMr4GXY+0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=coaD6mcCJGAdzzVYypJN8qOKu+KRiI9BvufE2kt6X+trW8eG152xF2j+Zq8F57O/nkLG/7fuUsUYuOUXD7jOETT4Snz09gXCVE7WjsCN1oS7EreecBtGAQqbw/+whWHkxT/nJI6FcGgxdzeUv3tUxWRF5U9RXoKk3dtJYAGAfME=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=clmClB04; arc=fail smtp.client-ip=40.107.95.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fgpXrMsGBLDxKc6HxbfmCKfYFgfKJN4VZXRfvikzPNBzDTDKKXOLk2sPI7tEK4QrnE4v5kcYNYdLTPHovzNJw4jQ2WcBb2PxHdTk9e1awC+HCUgK+AsVuEVjtvSkW4vwwnSxgk6/S6yZsSGBtELtXQ4kL4AWh2KF0PSZ8DbV5zb8K7w4Et9IOTyMHiJeLabypgandEQk6VvrVrxWBiW0Hp9GfpoWwJoplimKy/OJCUna7JTxh1AQxT/Xpe1PRClG5A167AOyCiov4lCJ5ZSCcINoJEqETFNqs997kJXei58NTkaLT9uAC9VWodAD8jzJl4sDOs2Z3rq4xGof4aqdwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ra+LDNCHYJOxJt2WQhpgZE/Fu8ztPBgzR6AGaxUZU8Q=;
 b=Q3/ytZH/nMm8Ha7lyOcUDIVnuFTwrOUbl5yx7fleIRit3+1mNtNQL7HFLFClwIemqjoPOQvFWwiDkhartq5tgZotrNyChZYjVX7Q6IYK9TSi+boWXVCD2Zsviti0ruYqxRl6wwSHG1H+lVpulupJ8Kx1l3fRYSJacnCu6VSo6+ipdd79zvSmOvnNbPP5v0kM+ZYn5pK6/IUHbH8TKSRFLOvMs+VQBr1+9lX+iroYHS2I7szDrccKNH4gGEc9c8WAk55AUCc6HytKAYxrwktp3wZ3qKX1vZiucuVoXEqkJN9Ng23/4/8YjOTM7Acf4qEoceanhJsIagDTgSK1XD3OrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ra+LDNCHYJOxJt2WQhpgZE/Fu8ztPBgzR6AGaxUZU8Q=;
 b=clmClB04nEmMWq09MOWmIB7lM8tT0wUU1VhBJ+HuUGBoktWg097hw612n60Vd2cwHLF4/InK1hzYo7pfKTc3/AxSvy2/HpwkExYACRy31lsfGOmal6WRGZ7bfW2DFMjnX27ieqgDxFmhQnC7VvEYCupq/MI7v1BuoWadcu84SchyZeVF5Ni+rUJgk3dU5jvjRbEL3r0WKDCh3Pn0/P2ChOyqJKEZhPgr7djh+upeQP/q4KRJ8J2b7oKeaWM4TpgUtn3ndYquOa7lPqTbgBMWvsYwRiSqnsDWDzJukNod9z3rLKKHbwc0JRsWr6yt3U+r5tjSvM3gTGCXV3b8FWgG2Q==
Received: from BY1P220CA0008.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::16)
 by SN7PR12MB7369.namprd12.prod.outlook.com (2603:10b6:806:298::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.24; Sun, 22 Sep
 2024 12:50:55 +0000
Received: from CO1PEPF000075F2.namprd03.prod.outlook.com
 (2603:10b6:a03:59d:cafe::38) by BY1P220CA0008.outlook.office365.com
 (2603:10b6:a03:59d::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.23 via Frontend
 Transport; Sun, 22 Sep 2024 12:50:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1PEPF000075F2.mail.protection.outlook.com (10.167.249.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 22 Sep 2024 12:50:53 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 22 Sep
 2024 05:50:37 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 22 Sep 2024 05:50:37 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sun, 22 Sep 2024 05:50:36 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <nouveau@lists.freedesktop.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 27/29] vfio/vgpu_mgr: bootload the new vGPU
Date: Sun, 22 Sep 2024 05:49:49 -0700
Message-ID: <20240922124951.1946072-28-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F2:EE_|SN7PR12MB7369:EE_
X-MS-Office365-Filtering-Correlation-Id: b9dd9356-c6f3-45e6-fa32-08dcdb0531e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RVmsHHERDBd6bpjPnCXASapwxqEMOkfMNJYk1LN4S3AehMh8w64b5/pz0Sav?=
 =?us-ascii?Q?WvEZlwBmGF9ktz1uL89pwtWdxvtYOqntrL7yau3nkwWooVbmDu0MkQKX6Zik?=
 =?us-ascii?Q?wdD9AJo6AghDNsQb93/0rH7PgnmQGoBNT4HaHeq7BFasAohoBreMdqhPHJ1j?=
 =?us-ascii?Q?vI83TWMMA9eLc5EDGmEZ6Wi80gOApk7zXsS+Y9F4Xk+HQLAuqCSwmDkl44Jc?=
 =?us-ascii?Q?dB3/LiAot16J6p0YbKY8YDF9s9G5n1tP10YdgJ9LhcqDh12Vkeo1lsd039D2?=
 =?us-ascii?Q?Ec0TukdCPqdBlUzfeOlD+ofamY8iJuzmAm0RUAJXy4bh7cT+JhfgCXjF0KHV?=
 =?us-ascii?Q?U9Q8YSZOP/Aw4DXZnOtKb5fp9fnjVe5h7Vf0EFqU4tTaA6oyf+Xqegf8vIus?=
 =?us-ascii?Q?6YrZwFronjaP+jZatF235rjAHpXbJ6tWGdV+rwwBSLKOxUuoWiEMUZFfb2IY?=
 =?us-ascii?Q?QskGVwTpgRIfHQlxJwf5xaaag87lexR0e7M5LuHNZJTAZHtes5244g97en78?=
 =?us-ascii?Q?lWkqKM4DQUfVwt4TirKPoy7WxteoFv0n4RZcffbJPBCqWzUkolPad+g5uUcT?=
 =?us-ascii?Q?b7Fe9Etj0ZaRnUsNMYdm6hqMaE77E6G+Gh2OQLdcQzrN/GDRI/4ck7N/Oer0?=
 =?us-ascii?Q?UFMC824uwY7dGoGuDue73TQFg3hCH6sghMDoIhSZOjDvdv1kfWzA58HAMoar?=
 =?us-ascii?Q?Un+x0a8/Cy6A3W7V1aft0+aztp4TG3dHpFedPfVyWpNXllE7RxVhT6z3H+GZ?=
 =?us-ascii?Q?aOXK7DW4uQNs2ZRtF3A+9Ey4pNagdICJsY0nqz24Ver9JNTDSZMQA/4Mtx6o?=
 =?us-ascii?Q?nqLA6xWqU9P4Esy4lkwpzGsl+3/qQvB2JH8Lpfm36Ri8I5MCwJs6JEaoy18a?=
 =?us-ascii?Q?bo9JTdLlGgJ1ByndCFbC/KdyQ+/XouonaKCqXnBmraKb7AoqtHy5nBFOGmpA?=
 =?us-ascii?Q?3FFGhHpBV0AePYjRaH7yFIoIQy52IjLZTeu3+cN38hxKl5PYBgcxTNn4xTgc?=
 =?us-ascii?Q?SIeFU1umNasgofj3AzGhUCXcYovnQb3PhfkdZSnhSYB2pVmdYGp555r7/5YR?=
 =?us-ascii?Q?YBPZwhdQF9e5rIuWBKA7/XyHHJTHCNBOk+Ku7T9mwdzZ3Fk8utCaXHNXh+yq?=
 =?us-ascii?Q?TH1ozkyp+xrg2Q7r3LW92eDVH3uSdvuHb+0m+Wct8Y4HA0suBW1jDrVqYuCd?=
 =?us-ascii?Q?MPZ9h2s1lpjr8aSktREVK/CuOkwBvVPrXb/eKhMqoNF+gQFDm2WnMm4R4kfy?=
 =?us-ascii?Q?RjwV8CBSOTBHqztTcSkXfV7upJGTwYd+w447Gna/FXPRcIsK6d56T6w/L+cJ?=
 =?us-ascii?Q?/dfPLuCjNn4O+lylhmjC0rF5qmX6jwL17AVbuXLthf52HbDnAdIyJi1g1Myv?=
 =?us-ascii?Q?j37dOol446nPBDvSc7gvUUUAiKyK5e+30kLKWx+lIaynJSAZO6wEMHuSk/3O?=
 =?us-ascii?Q?p7UxVdOFgsubKIziu7o4M2MUP2Rx3C3R?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 12:50:53.7395
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9dd9356-c6f3-45e6-fa32-08dcdb0531e4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7369

All the resources that required by a new vGPU has been set up. It is time
to activate it.

Send the NV2080_CTRL_CMD_VGPU_MGR_INTERNAL_BOOTLOAD_GSP_VGPU_PLUGIN_TASK
GSP RPC to activate the new vGPU.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 .../ctrl/ctrl2080/ctrl2080vgpumgrinternal.h   | 90 ++++++++++++++++++
 drivers/vfio/pci/nvidia-vgpu/nvkm.h           |  3 +
 drivers/vfio/pci/nvidia-vgpu/vgpu.c           | 94 +++++++++++++++++++
 3 files changed, 187 insertions(+)

diff --git a/drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/ctrl/ctrl2080/ctrl2080vgpumgrinternal.h b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/ctrl/ctrl2080/ctrl2080vgpumgrinternal.h
index f44cdc733229..58c6bff72f44 100644
--- a/drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/ctrl/ctrl2080/ctrl2080vgpumgrinternal.h
+++ b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/ctrl/ctrl2080/ctrl2080vgpumgrinternal.h
@@ -59,4 +59,94 @@ typedef struct NV2080_CTRL_VGPU_MGR_INTERNAL_PGPU_ADD_VGPU_TYPE_PARAMS {
 	NV_DECLARE_ALIGNED(NVA081_CTRL_VGPU_INFO vgpuInfo[NVA081_MAX_VGPU_TYPES_PER_PGPU], 8);
 } NV2080_CTRL_VGPU_MGR_INTERNAL_PGPU_ADD_VGPU_TYPE_PARAMS;
 
+/*
+ * NV2080_CTRL_CMD_VGPU_MGR_INTERNAL_BOOTLOAD_GSP_VGPU_PLUGIN_TASK
+ *
+ * This command is used to bootload GSP VGPU plugin task.
+ * Can be called only with SR-IOV and with VGPU_GSP_PLUGIN_OFFLOAD feature.
+ *
+ * dbdf                        - domain (31:16), bus (15:8), device (7:3), function (2:0)
+ * gfid                        - Gfid
+ * vgpuType                    - The Type ID for VGPU profile
+ * vmPid                       - Plugin process ID of vGPU guest instance
+ * swizzId                     - SwizzId
+ * numChannels                 - Number of channels
+ * numPluginChannels           - Number of plugin channels
+ * bDisableSmcPartitionRestore - If set to true, SMC default execution partition
+ *                               save/restore will not be done in host-RM
+ * guestFbPhysAddrList         - list of VMMU segment aligned physical address of guest FB memory
+ * guestFbLengthList           - list of guest FB memory length in bytes
+ * pluginHeapMemoryPhysAddr    - plugin heap memory offset
+ * pluginHeapMemoryLength      - plugin heap memory length in bytes
+ * bDeviceProfilingEnabled     - If set to true, profiling is allowed
+ */
+#define NV2080_CTRL_CMD_VGPU_MGR_INTERNAL_BOOTLOAD_GSP_VGPU_PLUGIN_TASK (0x20804001) /* finn: Evaluated from "(FINN_NV20_SUBDEVICE_0_VGPU_MGR_INTERNAL_INTERFACE_ID << 8) | NV2080_CTRL_VGPU_MGR_INTERNAL_BOOTLOAD_GSP_VGPU_PLUGIN_TASK_PARAMS_MESSAGE_ID" */
+
+#define NV2080_CTRL_MAX_VMMU_SEGMENTS                                   384
+
+/* Must match NV2080_ENGINE_TYPE_LAST from cl2080.h */
+#define NV2080_GPU_MAX_ENGINES                                          0x3e
+
+#define NV2080_CTRL_VGPU_MGR_INTERNAL_BOOTLOAD_GSP_VGPU_PLUGIN_TASK_PARAMS_MESSAGE_ID (0x1U)
+
+typedef struct NV2080_CTRL_VGPU_MGR_INTERNAL_BOOTLOAD_GSP_VGPU_PLUGIN_TASK_PARAMS {
+	NvU32  dbdf;
+	NvU32  gfid;
+	NvU32  vgpuType;
+	NvU32  vmPid;
+	NvU32  swizzId;
+	NvU32  numChannels;
+	NvU32  numPluginChannels;
+	NvU32  chidOffset[NV2080_GPU_MAX_ENGINES];
+	NvBool bDisableDefaultSmcExecPartRestore;
+	NvU32  numGuestFbSegments;
+	NV_DECLARE_ALIGNED(NvU64 guestFbPhysAddrList[NV2080_CTRL_MAX_VMMU_SEGMENTS], 8);
+	NV_DECLARE_ALIGNED(NvU64 guestFbLengthList[NV2080_CTRL_MAX_VMMU_SEGMENTS], 8);
+	NV_DECLARE_ALIGNED(NvU64 pluginHeapMemoryPhysAddr, 8);
+	NV_DECLARE_ALIGNED(NvU64 pluginHeapMemoryLength, 8);
+	NV_DECLARE_ALIGNED(NvU64 ctrlBuffOffset, 8);
+	NV_DECLARE_ALIGNED(NvU64 initTaskLogBuffOffset, 8);
+	NV_DECLARE_ALIGNED(NvU64 initTaskLogBuffSize, 8);
+	NV_DECLARE_ALIGNED(NvU64 vgpuTaskLogBuffOffset, 8);
+	NV_DECLARE_ALIGNED(NvU64 vgpuTaskLogBuffSize, 8);
+	NvBool bDeviceProfilingEnabled;
+} NV2080_CTRL_VGPU_MGR_INTERNAL_BOOTLOAD_GSP_VGPU_PLUGIN_TASK_PARAMS;
+
+/*
+ * NV2080_CTRL_CMD_VGPU_MGR_INTERNAL_SHUTDOWN_GSP_VGPU_PLUGIN_TASK
+ *
+ * This command is used to shutdown GSP VGPU plugin task.
+ * Can be called only with SR-IOV and with VGPU_GSP_PLUGIN_OFFLOAD feature.
+ *
+ * gfid                        - Gfid
+ */
+#define NV2080_CTRL_CMD_VGPU_MGR_INTERNAL_SHUTDOWN_GSP_VGPU_PLUGIN_TASK (0x20804002) /* finn: Evaluated from "(FINN_NV20_SUBDEVICE_0_VGPU_MGR_INTERNAL_INTERFACE_ID << 8) | NV2080_CTRL_VGPU_MGR_INTERNAL_SHUTDOWN_GSP_VGPU_PLUGIN_TASK_PARAMS_MESSAGE_ID" */
+
+#define NV2080_CTRL_VGPU_MGR_INTERNAL_SHUTDOWN_GSP_VGPU_PLUGIN_TASK_PARAMS_MESSAGE_ID (0x2U)
+
+typedef struct NV2080_CTRL_VGPU_MGR_INTERNAL_SHUTDOWN_GSP_VGPU_PLUGIN_TASK_PARAMS {
+	NvU32 gfid;
+} NV2080_CTRL_VGPU_MGR_INTERNAL_SHUTDOWN_GSP_VGPU_PLUGIN_TASK_PARAMS;
+
+/*
+ * NV2080_CTRL_CMD_VGPU_MGR_INTERNAL_VGPU_PLUGIN_CLEANUP
+ *
+ * This command is used to cleanup all the GSP VGPU plugin task allocated resources after its shutdown.
+ * Can be called only with SR-IOV and with VGPU_GSP_PLUGIN_OFFLOAD feature.
+ *
+ * gfid [IN]
+ *  This parameter specifies the gfid of vGPU assigned to VM.
+ *
+ * Possible status values returned are:
+ *   NV_OK
+ *   NV_ERR_NOT_SUPPORTED
+ */
+#define NV2080_CTRL_CMD_VGPU_MGR_INTERNAL_VGPU_PLUGIN_CLEANUP (0x20804008) /* finn: Evaluated from "(FINN_NV20_SUBDEVICE_0_VGPU_MGR_INTERNAL_INTERFACE_ID << 8) | NV2080_CTRL_VGPU_MGR_INTERNAL_VGPU_PLUGIN_CLEANUP_PARAMS_MESSAGE_ID" */
+
+#define NV2080_CTRL_VGPU_MGR_INTERNAL_VGPU_PLUGIN_CLEANUP_PARAMS_MESSAGE_ID (0x8U)
+
+typedef struct NV2080_CTRL_VGPU_MGR_INTERNAL_VGPU_PLUGIN_CLEANUP_PARAMS {
+	NvU32 gfid;
+} NV2080_CTRL_VGPU_MGR_INTERNAL_VGPU_PLUGIN_CLEANUP_PARAMS;
+
 #endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/nvkm.h b/drivers/vfio/pci/nvidia-vgpu/nvkm.h
index 8ad2241f7c5e..8e07422f99e5 100644
--- a/drivers/vfio/pci/nvidia-vgpu/nvkm.h
+++ b/drivers/vfio/pci/nvidia-vgpu/nvkm.h
@@ -88,4 +88,7 @@ static inline int nvidia_vgpu_mgr_get_handle(struct pci_dev *pdev,
 #define nvidia_vgpu_mgr_bar1_unmap_mem(m, mem) \
 	m->handle.ops->bar1_unmap_mem(mem)
 
+#define nvidia_vgpu_mgr_get_engine_bitmap(m, b) \
+	m->handle.ops->get_engine_bitmap(m->handle.pf_drvdata, b)
+
 #endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu.c b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
index 124a1a4593ae..e06d5155bb38 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
@@ -7,6 +7,7 @@
 
 #include <nvrm/nvtypes.h>
 #include <nvrm/common/sdk/nvidia/inc/ctrl/ctrla081.h>
+#include <nvrm/common/sdk/nvidia/inc/ctrl/ctrl2080/ctrl2080vgpumgrinternal.h>
 
 #include "vgpu_mgr.h"
 
@@ -141,6 +142,91 @@ static int setup_mgmt_heap(struct nvidia_vgpu *vgpu)
 	return 0;
 }
 
+static int shutdown_vgpu_plugin_task(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+	NV2080_CTRL_VGPU_MGR_INTERNAL_SHUTDOWN_GSP_VGPU_PLUGIN_TASK_PARAMS *ctrl;
+
+	ctrl = nvidia_vgpu_mgr_rm_ctrl_get(vgpu_mgr, &vgpu->gsp_client,
+			NV2080_CTRL_CMD_VGPU_MGR_INTERNAL_SHUTDOWN_GSP_VGPU_PLUGIN_TASK,
+			sizeof(*ctrl));
+	if (IS_ERR(ctrl))
+		return PTR_ERR(ctrl);;
+
+	ctrl->gfid = vgpu->info.gfid;
+
+	return nvidia_vgpu_mgr_rm_ctrl_wr(vgpu_mgr, &vgpu->gsp_client,
+					  ctrl);
+}
+
+static int cleanup_vgpu_plugin_task(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+	NV2080_CTRL_VGPU_MGR_INTERNAL_VGPU_PLUGIN_CLEANUP_PARAMS *ctrl;
+
+	ctrl = nvidia_vgpu_mgr_rm_ctrl_get(vgpu_mgr, &vgpu->gsp_client,
+			NV2080_CTRL_CMD_VGPU_MGR_INTERNAL_VGPU_PLUGIN_CLEANUP,
+			sizeof(*ctrl));
+	if (IS_ERR(ctrl))
+		return PTR_ERR(ctrl);
+
+	ctrl->gfid = vgpu->info.gfid;
+
+	return nvidia_vgpu_mgr_rm_ctrl_wr(vgpu_mgr, &vgpu->gsp_client,
+					  ctrl);
+}
+
+static int bootload_vgpu_plugin_task(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+	struct nvidia_vgpu_mgmt *mgmt = &vgpu->mgmt;
+	NV2080_CTRL_VGPU_MGR_INTERNAL_BOOTLOAD_GSP_VGPU_PLUGIN_TASK_PARAMS *ctrl;
+	DECLARE_BITMAP(engine_bitmap, NV2080_GPU_MAX_ENGINES);
+	int ret, i;
+
+	ctrl = nvidia_vgpu_mgr_rm_ctrl_get(vgpu_mgr, &vgpu->gsp_client,
+			NV2080_CTRL_CMD_VGPU_MGR_INTERNAL_BOOTLOAD_GSP_VGPU_PLUGIN_TASK,
+			sizeof(*ctrl));
+	if (IS_ERR(ctrl))
+		return PTR_ERR(ctrl);
+
+	ctrl->dbdf = vgpu->info.dbdf;
+	ctrl->gfid = vgpu->info.gfid;
+	ctrl->vmPid = 0;
+	ctrl->swizzId = 0;
+	ctrl->numChannels = vgpu->chid.num_chid;
+	ctrl->numPluginChannels = 0;
+
+	bitmap_clear(engine_bitmap, 0, NV2080_GPU_MAX_ENGINES);
+
+	/* FIXME: nvkm seems not correctly record engines. two engines are missing. */
+	nvidia_vgpu_mgr_get_engine_bitmap(vgpu_mgr, engine_bitmap);
+
+	for_each_set_bit(i, engine_bitmap, NV2080_GPU_MAX_ENGINES)
+		ctrl->chidOffset[i] = vgpu->chid.chid_offset;
+
+	ctrl->bDisableDefaultSmcExecPartRestore = false;
+	ctrl->numGuestFbSegments = 1;
+	ctrl->guestFbPhysAddrList[0] = vgpu->fbmem_heap->addr;
+	ctrl->guestFbLengthList[0] = vgpu->fbmem_heap->size;
+	ctrl->pluginHeapMemoryPhysAddr = mgmt->heap_mem->addr;
+	ctrl->pluginHeapMemoryLength = mgmt->heap_mem->size;
+	ctrl->ctrlBuffOffset = 0;
+	ctrl->initTaskLogBuffOffset = mgmt->heap_mem->addr +
+				      init_task_log_buff_offset();
+	ctrl->initTaskLogBuffSize = init_task_log_buff_size();
+	ctrl->vgpuTaskLogBuffOffset = ctrl->initTaskLogBuffOffset +
+				      ctrl->initTaskLogBuffSize;
+	ctrl->vgpuTaskLogBuffSize = vgpu_task_log_buff_size();
+	ctrl->bDeviceProfilingEnabled = false;
+
+	ret = nvidia_vgpu_mgr_rm_ctrl_wr(vgpu_mgr, &vgpu->gsp_client,
+					 ctrl);
+	if (ret)
+		return ret;
+	return 0;
+}
+
 /**
  * nvidia_vgpu_mgr_destroy_vgpu - destroy a vGPU instance
  * @vgpu: the vGPU instance going to be destroyed.
@@ -154,6 +240,8 @@ int nvidia_vgpu_mgr_destroy_vgpu(struct nvidia_vgpu *vgpu)
 	if (!atomic_cmpxchg(&vgpu->status, 1, 0))
 		return -ENODEV;
 
+	WARN_ON(shutdown_vgpu_plugin_task(vgpu));
+	WARN_ON(cleanup_vgpu_plugin_task(vgpu));
 	nvidia_vgpu_mgr_free_gsp_client(vgpu_mgr, &vgpu->gsp_client);
 	clean_mgmt_heap(vgpu);
 	clean_chids(vgpu);
@@ -207,10 +295,16 @@ int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu, u8 *vgpu_type)
 	if (ret)
 		goto err_alloc_gsp_client;
 
+	ret = bootload_vgpu_plugin_task(vgpu);
+	if (ret)
+		goto err_bootload_vgpu_plugin_task;
+
 	atomic_set(&vgpu->status, 1);
 
 	return 0;
 
+err_bootload_vgpu_plugin_task:
+	nvidia_vgpu_mgr_free_gsp_client(vgpu_mgr, &vgpu->gsp_client);
 err_alloc_gsp_client:
 	clean_mgmt_heap(vgpu);
 err_setup_mgmt_heap:
-- 
2.34.1


