Return-Path: <kvm+bounces-56708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B00C5B42C97
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 00:12:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E77E564DB1
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 22:12:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F15212EBDF9;
	Wed,  3 Sep 2025 22:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Br/472XT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4377E2ECD21
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 22:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756937505; cv=fail; b=deDZzZqRTR0VMqndlmE/p3XMoHc9h9PQHHREkkDUyAKewAg7XLumT6QBu0HRoUKimWBIa90jQn3yNxDts56zgKOFTp/GcQ3CzWQ3UQ++yryphr92bDF1zhZc/XN8kIWCon3q8rKC0TqQkuBgfgVwG9Yj4505EAHN3hXpc0cg+CA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756937505; c=relaxed/simple;
	bh=1hXKCQqf6sBbUCJjeR8wRgHCiC2MAFOakFCphnd3sxc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=egQAJ3fUV9WqSWr30T10CDIeW+HeQoXNhS9qegsIHLH9hDBv41NNa3IPd5z6jJYuFlIAgufhUIZBjKBRJw5IhVCMGtJShmPZnQfBrdzR95NNFySbmEnkPu+Vg5c98pjWdDIzYMCxoNjayKr7ww8PSGy3Csizp2g6mn3szfisbDU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Br/472XT; arc=fail smtp.client-ip=40.107.223.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SdlvRA9qx5I9f8M+e/0qG/L9dnAE3P7YfdT4vM0XaghO/ED1I7O7w2ZhS/3wRx+PqS+R6dj6+9mojskCltqiFB7X5bGxE6yEUBZaFEK11xKmy8Qb2OSmhv/el86pBQ6lFyuAwI4NUMNPG+zcheSv26zVrnqzWABzU7WyCpLstQad/lX2GiEMmd42+S87uNQO0oUmm0jl0d9lxAlS9e87rYdkCh9v3t7NolDPE71tDk0RZZWDOGoJCNdyEKJm7XEXYDUhmMA+EQM/TYQVWqeslaANW6E5HbJ8GddQMvgL+qW9U4r6SQAOmagXooUthv1nbDLmoWlNJs4UZFzopStpPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d8xUg6RsoU/o2l35gJbENlILBRClF4GpYPP0YDmWoYo=;
 b=HSJMpKehaI9i/8gRY3c0yXXThcdpTCB5JyZiBTZnA7Mj/EsTvTMulqYBIT8AmG4ZdTkRY0S9Ogro911cYK7kfZBX92xUOupXdzzMjt8mLtwL58RHGbXveJ+A/xw1S6THJFDeLv9PqGWThKpzDWUDi8d8GvcEGAaCQnIbhsAGybHxlhBnwv2xExnnsmsINKwbg8crwIUcFw3t2yD3UczpkA18K90fdVDz2P8cBmlyI632rTDEIYNFAA5XHtvTl7BJ4y0d8QvAL2THqH8g9YqrKvxJ0jWmKoqycQzG8w0RbFDFgVV2m7ctbBDhRh1Ow730qZngHFKR3l1IMmHp+L/iJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d8xUg6RsoU/o2l35gJbENlILBRClF4GpYPP0YDmWoYo=;
 b=Br/472XTU4p4i/6i9UOjyYUZSCJ4Sh3Q5Xv6ntHvWLuZI2UYOS76OKasFR5bltnvweMNHqvYkRCC7VEBw3g2P4dg7XTUa4T1JS4cMWhOitjmoZ41oU4JIA5oGRsIW54jBcq2Ni0wTEBuDP6GeyhbGhIo+62u9tlz65Ooif3TzuBpX+XsTgL4vtqlLzYiChatlU7AjxKSuAmkowRzGxs2sPieWYmYA2tEyyyxDGGoom3vahAU0ym1UwupGxjrXgrYUSoFU2lBj0ERFPbnrBoUAbXEz4VkzsNtSmsTsDwCjPrPTGafIkWXEcse843H0In1g+YCAFEfXXsOi6YxoQcKfA==
Received: from BN9PR03CA0748.namprd03.prod.outlook.com (2603:10b6:408:110::33)
 by MN2PR12MB4287.namprd12.prod.outlook.com (2603:10b6:208:1dd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.23; Wed, 3 Sep
 2025 22:11:39 +0000
Received: from BL02EPF00021F6E.namprd02.prod.outlook.com
 (2603:10b6:408:110:cafe::89) by BN9PR03CA0748.outlook.office365.com
 (2603:10b6:408:110::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.17 via Frontend Transport; Wed,
 3 Sep 2025 22:11:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF00021F6E.mail.protection.outlook.com (10.167.249.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Wed, 3 Sep 2025 22:11:38 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:19 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:18 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 15:11:18 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <dakr@kernel.org>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC v2 09/14] vfio/nvidia-vgpu: bootload the new vGPU
Date: Wed, 3 Sep 2025 15:11:06 -0700
Message-ID: <20250903221111.3866249-10-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250903221111.3866249-1-zhiw@nvidia.com>
References: <20250903221111.3866249-1-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6E:EE_|MN2PR12MB4287:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f859944-48c3-400f-65f8-08ddeb36dae5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4ib2daRos5FMqT5QLsK9OIHBg/fD2xAAHhH7RR206HfQNB0eVIJLau+lDygQ?=
 =?us-ascii?Q?Jg0riplx7Dbz5eIuVkkAhaveY0+/R1XLNWIJwTf8I1FWO0mIwi82BevMgtt/?=
 =?us-ascii?Q?GKzZjR4S7lJp/MH/2HZbmmetEPugmUD6jImHksD0bJMXnFssQaT/n1UjxPpW?=
 =?us-ascii?Q?hUksb8SpiaCCo0UUA+ijZswlO2WtLqmjsUCjug/KDk+ERaxWUJDjxN3Bnre9?=
 =?us-ascii?Q?c6jSYELSTB2Qx82zoSo+KVSzmVScsvwhw1ZQN5bhVp0IUytCbvzKiZjU/7Ha?=
 =?us-ascii?Q?lvfeiyHqUpPlXUjYg7AGsdbjj5YWaXRB9sTSRp7WwqawuuDeOMR9wFZJYpRE?=
 =?us-ascii?Q?Ved/eEEWylK3JVthHgBIJTZHUMNmpcqR6GcSzLZghswTxWbgdvYMVCHH538R?=
 =?us-ascii?Q?R3eKhHoiTGyhNqLOMKPfleL0/vPBgzoVB/DmsWBhP95qHgncqISE8svSGMcN?=
 =?us-ascii?Q?GhJz6WfdxjHIdgIEstEHYp/+cvNvPR40WkR0kawK3zoln9GsZ9lneL2WKRal?=
 =?us-ascii?Q?1sIhUtND2nn3Eier4hI2aQhr96hsLi8uOiZFJTxzPfLSfah175cibDVnRQ2N?=
 =?us-ascii?Q?eCnZ3eECMeayQcE7RIvwzgNCT9kx8pUN6o458gc6noODCCqaysqDD1S1UIbI?=
 =?us-ascii?Q?uQNZkjsLiCoFt3M71KeJfmxW8J0GtPe3v/Kqr7KILLv0O77ebQg24wkIyqnx?=
 =?us-ascii?Q?nW7IJHEzPpOo+nJ1ImiXV/Xb+TljwHYiMQgiD5fIJs8zGJxiwQaCT6gwVx3q?=
 =?us-ascii?Q?Qmf1bbPbAaIyzbworvmtEf8Dfkl1a6M+BVrqPvCvIOFteSHRDNxIjl5ruU5Q?=
 =?us-ascii?Q?LFMeoC76TwBSZbEwmxjijAZcU14h4hQVLt3prCdBAv5cuQqGgxa7LTimeG4M?=
 =?us-ascii?Q?ap+pTfu2TkLvpORvXtwwNJaHtiqxetJElKqahp3+WAUfQ4xzx2Ex4dTcgJzF?=
 =?us-ascii?Q?9td09lCtL7JZXOBR9qt3iReMCCPXaR2dZdmHbhMY6UoVAaXZQShmPauFbefk?=
 =?us-ascii?Q?i+RvKcs/lXFjqqlcds5F7pamQqz7MUoqdrkG/oKf9ij5tKGWrIXt9cy6grE/?=
 =?us-ascii?Q?qYmhQbTCl3hMqAc7jl+XmlArSt6IeYKh78h4bynfhpMvjngonY3f6ePeUkWJ?=
 =?us-ascii?Q?KQnRLWhU89xcMooJK4CRTb1TivGTZFZGrpStux4NLh5fnru9R/SIqP5sjOW5?=
 =?us-ascii?Q?W12BFQqOmc2xHR3PaeZ4uxzlg0RA4tkmdDFvDVC1ETz9oN23vHtE/C6ghIkz?=
 =?us-ascii?Q?wiuz5NrWelwkBomdEzE4+IZGhZEdHRgCN4hC4ZE0qMk9yzCwvJtk8V97a1es?=
 =?us-ascii?Q?LV6R7doM2/am0DOMDWoxGIQWS2Aba7iPsk4hcfJ0BYhNpK183AW9w4KyoHzg?=
 =?us-ascii?Q?ZQP9OTAxG3sWKm2XcB/zJBuvQ9ydLyEaMqpJoisWvcQCeiMwW58kij0dXtw6?=
 =?us-ascii?Q?UEc90P8SNDAC4ZPr7Cd+lQ+1j9N0HJ5JCqZlmT6GNMONl1u068ca9gQkIl1m?=
 =?us-ascii?Q?CjLAMDFZsMyAGv6o6b5SZniiLIHfYGxibS4hgsF/gSmyQW0TxDNj2BnQvg?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 22:11:38.7962
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f859944-48c3-400f-65f8-08ddeb36dae5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4287

All the resources that required by a new vGPU has been set up. It is time
to activate it.

Send the NV2080_CTRL_CMD_VGPU_MGR_INTERNAL_BOOTLOAD_GSP_VGPU_PLUGIN_TASK
GSP RPC to activate the new vGPU.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 .../pci/nvidia-vgpu/include/nvrm/bootload.h   | 58 +++++++++++
 drivers/vfio/pci/nvidia-vgpu/pf.h             | 10 ++
 drivers/vfio/pci/nvidia-vgpu/vgpu.c           | 97 +++++++++++++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c       | 36 ++++++-
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h       |  2 +
 5 files changed, 202 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/bootload.h

diff --git a/drivers/vfio/pci/nvidia-vgpu/include/nvrm/bootload.h b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/bootload.h
new file mode 100644
index 000000000000..ec0cb03f27e8
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/bootload.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: MIT */
+
+/* Copyright (c) 2025, NVIDIA CORPORATION. All rights reserved. */
+
+#ifndef __NVRM_BOOTLOAD_H__
+#define __NVRM_BOOTLOAD_H__
+
+#include <nvrm/nvtypes.h>
+
+/* Excerpt of RM headers from https://github.com/NVIDIA/open-gpu-kernel-modules/tree/570.124.04 */
+
+#define NV2080_CTRL_CMD_VGPU_MGR_INTERNAL_BOOTLOAD_GSP_VGPU_PLUGIN_TASK (0x20804001)
+
+#define NV2080_CTRL_MAX_VMMU_SEGMENTS                                   384
+
+/* Must match NV2080_ENGINE_TYPE_LAST from cl2080.h */
+#define NV2080_GPU_MAX_ENGINES                                          0x54
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
+	NV_DECLARE_ALIGNED(NvU64 kernelLogBuffOffset, 8);
+	NV_DECLARE_ALIGNED(NvU64 kernelLogBuffSize, 8);
+	NV_DECLARE_ALIGNED(NvU64 migRmHeapMemoryPhysAddr, 8);
+	NV_DECLARE_ALIGNED(NvU64 migRmHeapMemoryLength, 8);
+	NvBool bDeviceProfilingEnabled;
+} NV2080_CTRL_VGPU_MGR_INTERNAL_BOOTLOAD_GSP_VGPU_PLUGIN_TASK_PARAMS;
+
+#define NV2080_CTRL_CMD_VGPU_MGR_INTERNAL_SHUTDOWN_GSP_VGPU_PLUGIN_TASK (0x20804002)
+
+typedef struct NV2080_CTRL_VGPU_MGR_INTERNAL_SHUTDOWN_GSP_VGPU_PLUGIN_TASK_PARAMS {
+	NvU32 gfid;
+} NV2080_CTRL_VGPU_MGR_INTERNAL_SHUTDOWN_GSP_VGPU_PLUGIN_TASK_PARAMS;
+
+#define NV2080_CTRL_CMD_VGPU_MGR_INTERNAL_VGPU_PLUGIN_CLEANUP (0x20804008)
+
+typedef struct NV2080_CTRL_VGPU_MGR_INTERNAL_VGPU_PLUGIN_CLEANUP_PARAMS {
+	NvU32 gfid;
+} NV2080_CTRL_VGPU_MGR_INTERNAL_VGPU_PLUGIN_CLEANUP_PARAMS;
+
+#endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/pf.h b/drivers/vfio/pci/nvidia-vgpu/pf.h
index 167296ba7e3d..d081d8e718e1 100644
--- a/drivers/vfio/pci/nvidia-vgpu/pf.h
+++ b/drivers/vfio/pci/nvidia-vgpu/pf.h
@@ -109,4 +109,14 @@ static inline int nvidia_vgpu_mgr_init_handle(struct pci_dev *pdev,
 #define nvidia_vgpu_mgr_bar1_unmap_mem(m, mem) \
 	((m)->handle.ops->bar1_unmap_mem(mem))
 
+#define nvidia_vgpu_mgr_get_engine_bitmap_size(m) ({ \
+	typeof(m) __m = (m); \
+	__m->handle.ops->get_engine_bitmap_size(__m->handle.pf_drvdata); \
+})
+
+#define nvidia_vgpu_mgr_get_engine_bitmap(m, bitmap) ({ \
+	typeof(m) __m = (m); \
+	__m->handle.ops->get_engine_bitmap(__m->handle.pf_drvdata, bitmap); \
+})
+
 #endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu.c b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
index cf28367ac6a0..5778365c051f 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
@@ -8,6 +8,8 @@
 #include "debug.h"
 #include "vgpu_mgr.h"
 
+#include <nvrm/bootload.h>
+
 static void unregister_vgpu(struct nvidia_vgpu *vgpu)
 {
 	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
@@ -230,6 +232,93 @@ static int setup_mgmt_heap(struct nvidia_vgpu *vgpu)
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
+		return PTR_ERR(ctrl);
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
+	int ret, i;
+
+	vgpu_debug(vgpu, "bootload\n");
+
+	ctrl = nvidia_vgpu_mgr_rm_ctrl_get(vgpu_mgr, &vgpu->gsp_client,
+			NV2080_CTRL_CMD_VGPU_MGR_INTERNAL_BOOTLOAD_GSP_VGPU_PLUGIN_TASK,
+			sizeof(*ctrl));
+	if (IS_ERR(ctrl))
+		return PTR_ERR(ctrl);
+
+	ctrl->dbdf = vgpu->info.dbdf;
+	ctrl->gfid = vgpu->info.gfid;
+	ctrl->vmPid = vgpu->info.vm_pid;
+	ctrl->swizzId = 0;
+	ctrl->numChannels = vgpu->chid.num_chid;
+	ctrl->numPluginChannels = vgpu->chid.num_plugin_channels;
+
+	for_each_set_bit(i, vgpu_mgr->engine_bitmap, NV2080_GPU_MAX_ENGINES)
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
+				      vgpu_mgr->init_task_log_offset;
+	ctrl->initTaskLogBuffSize = vgpu_mgr->init_task_log_size;
+	ctrl->vgpuTaskLogBuffOffset = ctrl->initTaskLogBuffOffset +
+				      ctrl->initTaskLogBuffSize;
+	ctrl->vgpuTaskLogBuffSize = vgpu_mgr->vgpu_task_log_size;
+	ctrl->kernelLogBuffOffset = ctrl->vgpuTaskLogBuffOffset +
+				      ctrl->vgpuTaskLogBuffSize;
+	ctrl->kernelLogBuffSize = vgpu_mgr->kernel_log_size;
+
+	ctrl->bDeviceProfilingEnabled = false;
+
+	ret = nvidia_vgpu_mgr_rm_ctrl_wr(vgpu_mgr, &vgpu->gsp_client,
+					 ctrl);
+	if (ret)
+		return ret;
+
+	vgpu_debug(vgpu, "bootloading\n");
+	return 0;
+}
+
 /**
  * nvidia_vgpu_mgr_destroy_vgpu - destroy a vGPU instance
  * @vgpu: the vGPU instance going to be destroyed.
@@ -243,6 +332,8 @@ int nvidia_vgpu_mgr_destroy_vgpu(struct nvidia_vgpu *vgpu)
 	if (!atomic_cmpxchg(&vgpu->status, 1, 0))
 		return -ENODEV;
 
+	WARN_ON(shutdown_vgpu_plugin_task(vgpu));
+	WARN_ON(cleanup_vgpu_plugin_task(vgpu));
 	nvidia_vgpu_mgr_free_gsp_client(vgpu_mgr, &vgpu->gsp_client);
 	clean_mgmt_heap(vgpu);
 	clean_fbmem_heap(vgpu);
@@ -304,12 +395,18 @@ int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu)
 	if (ret)
 		goto err_alloc_gsp_client;
 
+	ret = bootload_vgpu_plugin_task(vgpu);
+	if (ret)
+		goto err_bootload_vgpu_plugin_task;
+
 	atomic_set(&vgpu->status, 1);
 
 	vgpu_debug(vgpu, "created\n");
 
 	return 0;
 
+err_bootload_vgpu_plugin_task:
+	nvidia_vgpu_mgr_free_gsp_client(vgpu_mgr, &vgpu->gsp_client);
 err_alloc_gsp_client:
 	clean_mgmt_heap(vgpu);
 err_setup_mgmt_heap:
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
index cf5dd9a8e258..6338dd9c86b6 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
@@ -15,6 +15,9 @@ static void clean_vgpu_mgr(struct nvidia_vgpu_mgr *vgpu_mgr)
 		bitmap_free(vgpu_mgr->chid_alloc_bitmap);
 		vgpu_mgr->chid_alloc_bitmap = NULL;
 	}
+
+	kvfree(vgpu_mgr->engine_bitmap);
+	vgpu_mgr->engine_bitmap = NULL;
 }
 
 static void vgpu_mgr_release(struct kref *kref)
@@ -140,6 +143,25 @@ static int get_ecc_status(struct nvidia_vgpu_mgr *vgpu_mgr)
 	return 0;
 }
 
+static int setup_engine_bitmap(struct nvidia_vgpu_mgr *vgpu_mgr)
+{
+	u64 size;
+
+	size = nvidia_vgpu_mgr_get_engine_bitmap_size(vgpu_mgr);
+
+	if (WARN_ON(!size))
+		return -EINVAL;
+
+	vgpu_mgr->engine_bitmap = kvmalloc(ALIGN(size, 8), GFP_KERNEL);
+	if (!vgpu_mgr->engine_bitmap)
+		return -ENOMEM;
+
+	vgpu_mgr_debug(vgpu_mgr, "[core driver] engine bitmap size: 0x%llx\n", size);
+
+	nvidia_vgpu_mgr_get_engine_bitmap(vgpu_mgr, vgpu_mgr->engine_bitmap);
+	return 0;
+}
+
 static int setup_chid_alloc_bitmap(struct nvidia_vgpu_mgr *vgpu_mgr)
 {
 	if (WARN_ON(!vgpu_mgr->use_chid_alloc_bitmap))
@@ -194,6 +216,10 @@ static int init_vgpu_mgr(struct nvidia_vgpu_mgr *vgpu_mgr)
 		       vgpu_mgr->vmmu_segment_size);
 	vgpu_mgr_debug(vgpu_mgr, "[GSP RM] ECC enabled: %d\n", vgpu_mgr->ecc_enabled);
 
+	ret = setup_engine_bitmap(vgpu_mgr);
+	if (ret)
+		return ret;
+
 	vgpu_mgr->total_avail_chids = nvidia_vgpu_mgr_get_avail_chids(vgpu_mgr);
 	vgpu_mgr->total_fbmem_size = nvidia_vgpu_mgr_get_total_fbmem_size(vgpu_mgr);
 
@@ -204,7 +230,15 @@ static int init_vgpu_mgr(struct nvidia_vgpu_mgr *vgpu_mgr)
 
 	init_gsp_rm_constraints(vgpu_mgr);
 
-	return vgpu_mgr->use_chid_alloc_bitmap ? setup_chid_alloc_bitmap(vgpu_mgr) : 0;
+	if (vgpu_mgr->use_chid_alloc_bitmap) {
+		ret = setup_chid_alloc_bitmap(vgpu_mgr);
+		if (ret) {
+			kvfree(vgpu_mgr->engine_bitmap);
+			vgpu_mgr->engine_bitmap = NULL;
+			return ret;
+		}
+	}
+	return 0;
 }
 
 static int setup_pf_driver_caps(struct nvidia_vgpu_mgr *vgpu_mgr, unsigned long *caps)
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
index 84bafea295a0..323acf52068e 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
@@ -34,6 +34,7 @@ struct nvidia_vgpu_info {
 	u32 gfid;
 	u32 dbdf;
 	struct nvidia_vgpu_type *vgpu_type;
+	u32 vm_pid;
 };
 
 /**
@@ -119,6 +120,7 @@ struct nvidia_vgpu_mgr {
 	/* core driver configurations */
 	u32 total_avail_chids;
 	u64 total_fbmem_size;
+	void *engine_bitmap;
 
 	/* GSP RM configurations */
 	u64 vmmu_segment_size;
-- 
2.34.1


