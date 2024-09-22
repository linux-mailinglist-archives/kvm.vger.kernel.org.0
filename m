Return-Path: <kvm+bounces-27275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A5DD897E1BC
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 14:53:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 600DC2811D5
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 12:53:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55DBC59164;
	Sun, 22 Sep 2024 12:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NjzO66JU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2077.outbound.protection.outlook.com [40.107.95.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AC879DE
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 12:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727009471; cv=fail; b=jTGz+3weMkHEJP+/GDeKaZKPpU2B3mWofnIjxwL3xlvp40JH5RXVTnMH5sIYb659QMYChEJ3Jiin65NBvuHxBtnOjvfQp4143G0528/TrfXDXH2LanZWsMrNqcYLBmzrLz2ZKWUT2L37L85scUnVvCFqx7SMv7WG87OGxmJLWRQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727009471; c=relaxed/simple;
	bh=PIfzpcDhoynjzPHCW7yuWS0S2PkK1aRM4LUBT70tR+k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HZRjc7f8kiWzy9FewFtl6SUhICp5KZxhZPF0rZmTUE9P07S3/+R5hZfvjJtUxtQIuVc49gdM6WdHmg1Ee1qZIguIZv2VtrcFGmSboPRLZE15hRbpGJ144WWvDrw4C7ocxTmr4+SMm94dsjZBh26jo71r9q3oQh64wzE3UC7VMt8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NjzO66JU; arc=fail smtp.client-ip=40.107.95.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pvJ7/sJKrISjXHaKEn1xQiLmP4jFdv8l1G+Do5/S0qTnWWiur2UgUjHJR6hnHReSqWnfOkinA3PhJ4Sj2TV0ClDHxInKawEC9AjU6K9pn+W/WD7N3nyBL/hMUgjKkAXRQku8G6mEagCQybHtT4RnVLPmYSSyVlKWzFfv8LU75SMliOU5MXmeEL3ZWJQLnHCJ5S3EwZEeiDiQ1ci4gMC1qcmFPjKVDwyD3BLhZ5/k+g1gKiWVcu9q/8fgZME1M740D+K/ZRt6dCkuNc3FBcgf04UgoayyTjwy/alBnS5ux6NmFaBAsG8CvRPOGXF4xMUxVRwWmv1G4yGEEfZgX/WKug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BleeluwThKtArWNEFfcTK34nznhGQWdAt359OAmj5hM=;
 b=pBdKjTzh+cdhqa3cQCu9SiHLSBLo7lkXuM30olG4Hpj1t0mrrD8+BzuOgJ94hTQ4xoCBN3jtJzn1LjsRMfqPSnbk1X1Wl4ZOo45TEGURs0CaDAgJS4b03YQzf9Xbuy08VsXfE5eeev214qFOyXAWYqJweA4k5kY7Yuyz6H8WVLQNEbY6TAe/xzvavKvWfF/mHSbjV8P8W0T84nlqx1QevNvFI6ozjuWrxM/C/+nw+EZ6eR78gnM9GQPAeiH6pXs4D0V3vwcuj5xxf94gP4sYPMhUpah/URbbpDZQRnKepwqWBIsU8+31ZkD5B/R5egnHzsrWk2teCZ8PSkNI6JxEzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BleeluwThKtArWNEFfcTK34nznhGQWdAt359OAmj5hM=;
 b=NjzO66JU53OZAiBvM6B/UrE6a+ApkHWAdWRxZB914PxEJNz9x2DEMydHU9cZfCrK8KL0ftyTY1mQjyjPkkIsCawMqJmVTIvXjFwXaXarBS23JLFHjOqyLkfE7RNC3rf2iX0+R2AxEO/MxwhwjQZVMGcrJ5D8Deq4MvrPcJRqWQMrx01WEov7tREeTzP9OTRNApHtZCc8FA+mm+QWbX8hM9CN6pjX+yez/iw8NhT0f0fVTq6wCfql0GIaufB3z97PJU2wUJA0hGYTzFrVO+H+WrYPfXQ47CPuB/kf+xjpEeb2NVOx5YAmjSwj+/AJa+nwzCLOEfYLW2cwoEDKiSWZmw==
Received: from MN2PR11CA0027.namprd11.prod.outlook.com (2603:10b6:208:23b::32)
 by PH7PR12MB5655.namprd12.prod.outlook.com (2603:10b6:510:138::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.24; Sun, 22 Sep
 2024 12:51:00 +0000
Received: from BL6PEPF00020E63.namprd04.prod.outlook.com
 (2603:10b6:208:23b:cafe::76) by MN2PR11CA0027.outlook.office365.com
 (2603:10b6:208:23b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.29 via Frontend
 Transport; Sun, 22 Sep 2024 12:50:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF00020E63.mail.protection.outlook.com (10.167.249.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 22 Sep 2024 12:50:59 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 22 Sep
 2024 05:50:38 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 22 Sep 2024 05:50:38 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sun, 22 Sep 2024 05:50:37 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <nouveau@lists.freedesktop.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 28/29] vfio/vgpu_mgr: introduce vGPU host RPC channel
Date: Sun, 22 Sep 2024 05:49:50 -0700
Message-ID: <20240922124951.1946072-29-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240922124951.1946072-1-zhiw@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E63:EE_|PH7PR12MB5655:EE_
X-MS-Office365-Filtering-Correlation-Id: bc7552e1-411c-44b5-0c59-08dcdb053556
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bHhiRkE5RXoxL2NURTZ2dm1sYVdFdDNpdnlveHlQS3ZsaXF1ZVZvUjY5aXpB?=
 =?utf-8?B?S3RBM2xLM3V0WGhHMGhzVm5TMHNmM0RWOW51SkwzUGc4aW9pdnd6S2w2UVpQ?=
 =?utf-8?B?Z082dGlGMkxtaHJXdTJ5bmVPQnJTZ1F2VjlCTTlNdWk2RVZYR0FISFNEVlZ2?=
 =?utf-8?B?a0VMY09HRUVYUFUyaHBabmtRRkZNVzNpdVcyZmJ1d1BSZnFXM3dyUjJvSnl1?=
 =?utf-8?B?NVg2dTFlbHpnUGVER2VoeDJLYXlGREU0WVhBWm0zd0JGRGE2dEFpcGxZc1I0?=
 =?utf-8?B?c1hBMmpyOExDWENOR1o5dUQwdyswUXBlM1FybDBvemx0MW42Y3p2bmhUR0xM?=
 =?utf-8?B?M1hVWDFSeXA4Mlp2QnJzNXJaQXBOaEZSdXYyeXpmOEYxU3lKLy9FaCtwcXJn?=
 =?utf-8?B?ck80MGNlMUZCdEhFV00vd05obXFDSDlId3gzdm9xSkxQN1htZmtSN2ZWT3JG?=
 =?utf-8?B?Tkw2SWxQVmJMb2Jndlk1cTN6YWhNYjluamRuY2RlNFBObXV6aEYvdmV3eDFl?=
 =?utf-8?B?UzRMTldST1N5QThwZTlOQ0V5SytHUVgwOHF3Nkx1emZJelR2bFltQitMQndh?=
 =?utf-8?B?Y09yY1lSUjkxMEJLOXZKeDVjVS9UcFFpaEhJSFo2QTBmVlIza0szeWNZVkpo?=
 =?utf-8?B?dXI4cVgwUE5vVzhkUUxPOUNtb2loWDB1WGRrMVdvT1BxeGFUa1VOY1hPQXhW?=
 =?utf-8?B?SkFPdjQ5QnBYemhpZFF3eEp3VE90STBqaXNRRGRmSnhtVkVRTlB3ZTFlR0tk?=
 =?utf-8?B?TWhicFVZUmNSemFSUTMzT0VaZVhEMVdPb0hCKzQxN3ZTVzljcUZkS2lRT1ZW?=
 =?utf-8?B?Sm81QTVPai9TYVVJWGhhMGxkcnNBam1EalBabGdEODZhcTJDb0ZvbllpN1hs?=
 =?utf-8?B?UHFWYUJOSFhRZHVpY0VnTTZjL0tVWUdqRlAwUFpZRWdGVTgyaDVJclR4d0hG?=
 =?utf-8?B?LytxbE5DcSt5dG01YjhxbkRhUHZiYnVKdjZubVZMa1hLQ2lvaUlaK0tDWUxl?=
 =?utf-8?B?WnlKNlVqbjB3VFdPcjA4bGZza2JFR0IxN0VEWld5aWk4WjF1a1J1OERkNUxi?=
 =?utf-8?B?NldLT0FQTEdkTVRGZU5zVWM0LysrNTJSYk41eU5ibzRrb3dPODlEZCtGQlhk?=
 =?utf-8?B?TUlnZGhhQ3V2ejcwdzRIYW40UWtZWTR4Ty9zZHRYTldWdTl5Mm1XZ3RRLytk?=
 =?utf-8?B?aCtTVGEzY0xnVjYwV0lFWGR3WFBwc0ZaZkIyVUF1WXNRd081RWNBZ3JhNkhW?=
 =?utf-8?B?ajlSenNaS2hNWUt5dkdORTR6OWppWjJwSElBSm9URGlXMTFQRGlOaVF2cVdq?=
 =?utf-8?B?UnpTU3h4YS82R3hsNTVoRUVNL0Q4Z0Z3NUFQSEgwZHJMclQ3L1NEbHJ5ZlBE?=
 =?utf-8?B?Sm92SGYvMEszN0V2QUZWV2E5SHBMMHA1MWRoSUhTZlJBWnJSdVZaYURrejZs?=
 =?utf-8?B?SHdHNGE1a1huK3NkdWVLMUlxNGJ0SHVnMXBEb2FObnBjalY3bXJQOHN0dXJm?=
 =?utf-8?B?eWZRRGtrL25idnlJK3IzeldFTyt0Q0RXeXBIRGR6NXFTZjU4NUl5Njh2QUNV?=
 =?utf-8?B?ZjA4emo1MERyOVZYYThhcjEzYWxoRGF4WGdrcmE2NFBGWTk1YnhoMzZ5c09K?=
 =?utf-8?B?enJjZ3lRZ0lyUkZpemRSMkFHb2phdXpRcVliQ3FHWGR0dGJPQWZtbFlnaWJv?=
 =?utf-8?B?bmVuNUZiZlRTcDBYbUY2YTV0SG1HTkRzcms0Z3U0dHJmR2lnN2paMTY5eEVj?=
 =?utf-8?B?NnZNNng4Smt4TWpRZHpsdFNhVUVQdUkyS3RVemZ1UG9xa25YWk9RNUpvK3du?=
 =?utf-8?B?aGEzWmpFU25Ta1V2blc2THlGcTV5TDlxS0YyZkVtSllUOG5JV0tSNGR3cmpU?=
 =?utf-8?Q?zyuRP8pE6T3zJ?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 12:50:59.3887
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc7552e1-411c-44b5-0c59-08dcdb053556
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E63.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5655

A newly created vGPU requires some runtime configuration to be uploaded
before moving on.

Introduce the vGPU host RPCs manipulation APIs to send vGPU RPCs.
Send vGPU RPCs to upload the runtime configuration of a vGPU.

Cc: Neo Jia <cjia@nvidia.com>
Cc: Surath Mitra <smitra@nvidia.com>
Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/nvidia-vgpu/Makefile         |   2 +-
 drivers/vfio/pci/nvidia-vgpu/debug.h          |  18 ++
 .../nvidia/inc/ctrl/ctrl0000/ctrl0000system.h |  30 +++
 .../nvrm/common/sdk/nvidia/inc/dev_vgpu_gsp.h | 213 +++++++++++++++
 .../common/sdk/nvidia/inc/nv_vgpu_types.h     |  51 ++++
 .../common/sdk/vmioplugin/inc/vmioplugin.h    |  26 ++
 drivers/vfio/pci/nvidia-vgpu/rpc.c            | 242 ++++++++++++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu.c           |  11 +
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c       |  31 +++
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h       |  21 ++
 10 files changed, 644 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/debug.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/ctrl/ctrl0000/ctrl0000system.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/dev_vgpu_gsp.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/nv_vgpu_types.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/vmioplugin/inc/vmioplugin.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/rpc.c

diff --git a/drivers/vfio/pci/nvidia-vgpu/Makefile b/drivers/vfio/pci/nvidia-vgpu/Makefile
index bd65fa548ea1..fade9d49df97 100644
--- a/drivers/vfio/pci/nvidia-vgpu/Makefile
+++ b/drivers/vfio/pci/nvidia-vgpu/Makefile
@@ -2,4 +2,4 @@
 ccflags-y += -I$(srctree)/$(src)/include
 
 obj-$(CONFIG_NVIDIA_VGPU_MGR) += nvidia-vgpu-mgr.o
-nvidia-vgpu-mgr-y := vgpu_mgr.o vgpu.o vgpu_types.o
+nvidia-vgpu-mgr-y := vgpu_mgr.o vgpu.o vgpu_types.o rpc.o
diff --git a/drivers/vfio/pci/nvidia-vgpu/debug.h b/drivers/vfio/pci/nvidia-vgpu/debug.h
new file mode 100644
index 000000000000..bc1c4273f089
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/debug.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/*
+ * Copyright © 2024 NVIDIA Corporation
+ */
+
+#ifndef __NVIDIA_VGPU_DEBUG_H__
+#define __NVIDIA_VGPU_DEBUG_H__
+
+#define nv_vgpu_dbg(v, f, a...) \
+	pci_dbg(v->pdev, "nvidia-vgpu %d: "f, v->info.id, ##a)
+
+#define nv_vgpu_info(v, f, a...) \
+	pci_info(v->pdev, "nvidia-vgpu %d: "f, v->info.id, ##a)
+
+#define nv_vgpu_err(v, f, a...) \
+	pci_err(v->pdev, "nvidia-vgpu %d: "f, v->info.id, ##a)
+
+#endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/ctrl/ctrl0000/ctrl0000system.h b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/ctrl/ctrl0000/ctrl0000system.h
new file mode 100644
index 000000000000..871c498fb666
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/ctrl/ctrl0000/ctrl0000system.h
@@ -0,0 +1,30 @@
+#ifndef __src_common_sdk_nvidia_inc_ctrl_ctrl0000_ctrl0000system_h__
+#define __src_common_sdk_nvidia_inc_ctrl_ctrl0000_ctrl0000system_h__
+
+/* Excerpt of RM headers from https://github.com/NVIDIA/open-gpu-kernel-modules/tree/535.113.01 */
+
+/*
+ * SPDX-FileCopyrightText: Copyright (c) 2005-2024 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+ * SPDX-License-Identifier: MIT
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ */
+
+#define NV0000_CTRL_CMD_SYSTEM_GET_VGX_SYSTEM_INFO_BUFFER_SIZE 256U
+#endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/dev_vgpu_gsp.h b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/dev_vgpu_gsp.h
new file mode 100644
index 000000000000..8f3ea48ef10d
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/dev_vgpu_gsp.h
@@ -0,0 +1,213 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/*
+ * Copyright © 2024 NVIDIA Corporation
+ */
+#ifndef __src_common_sdk_nvidia_inc_vgpu_dev_nv_vgpu_gsp_h__
+#define __src_common_sdk_nvidia_inc_vgpu_dev_nv_vgpu_gsp_h__
+
+#include "nv_vgpu_types.h"
+
+#define GSP_PLUGIN_BOOTLOADED 0x4E654A6F
+
+/******************************************************************************/
+/* GSP Control buffer shared between CPU Plugin and GSP Plugin - START        */
+/******************************************************************************/
+
+/*    GSP Plugin heap memory layout
+      +--------------------------------+ offset = 0
+      |         CONTROL BUFFER         |
+      +--------------------------------+
+      |        RESPONSE BUFFER         |
+      +--------------------------------+
+      |         MESSAGE BUFFER         |
+      +--------------------------------+
+      |        MIGRATION BUFFER        |
+      +--------------------------------+
+      |    GSP PLUGIN ERROR BUFFER     |
+      +--------------------------------+
+      |    INIT TASK LOG BUFFER        |
+      +--------------------------------+
+      |    VGPU TASK LOG BUFFER        |
+      +--------------------------------+
+      |      MEMORY AVAILABLE FOR      |
+      | GSP PLUGIN INTERNAL HEAP USAGE |
+      +--------------------------------+
+ */
+#define VGPU_CPU_GSP_CTRL_BUFF_VERSION              0x1
+#define VGPU_CPU_GSP_CTRL_BUFF_REGION_SIZE          4096
+#define VGPU_CPU_GSP_RESPONSE_BUFF_REGION_SIZE      4096
+#define VGPU_CPU_GSP_MESSAGE_BUFF_REGION_SIZE       4096
+#define VGPU_CPU_GSP_MIGRATION_BUFF_REGION_SIZE     (2 * 1024 * 1024)
+#define VGPU_CPU_GSP_ERROR_BUFF_REGION_SIZE         4096
+#define VGPU_CPU_GSP_INIT_TASK_LOG_BUFF_REGION_SIZE (128 * 1024)
+#define VGPU_CPU_GSP_VGPU_TASK_LOG_BUFF_REGION_SIZE (256 * 1024)
+#define VGPU_CPU_GSP_COMMUNICATION_BUFF_TOTAL_SIZE  (VGPU_CPU_GSP_CTRL_BUFF_REGION_SIZE          + \
+		VGPU_CPU_GSP_RESPONSE_BUFF_REGION_SIZE      + \
+		VGPU_CPU_GSP_MESSAGE_BUFF_REGION_SIZE       + \
+		VGPU_CPU_GSP_MIGRATION_BUFF_REGION_SIZE     + \
+		VGPU_CPU_GSP_ERROR_BUFF_REGION_SIZE         + \
+		VGPU_CPU_GSP_INIT_TASK_LOG_BUFF_REGION_SIZE + \
+		VGPU_CPU_GSP_VGPU_TASK_LOG_BUFF_REGION_SIZE)
+
+//
+// Control buffer: CPU Plugin -> GSP Plugin
+// CPU Plugin - Write only
+// GSP Plugin - Read only
+//
+typedef union {
+	NvU8 buf[VGPU_CPU_GSP_CTRL_BUFF_REGION_SIZE];
+	struct {
+		volatile NvU32  version;                        // Version of format
+		volatile NvU32  message_type;                   // Task to be performed by GSP Plugin
+		volatile NvU32  message_seq_num;                // Incrementing sequence number to identify the RPC packet
+		volatile NvU64  response_buff_offset;           // Buffer used to send data from GSP Plugin -> CPU Plugin
+		volatile NvU64  message_buff_offset;            // Buffer used to send RPC data between CPU and GSP Plugin
+		volatile NvU64  migration_buff_offset;          // Buffer used to send migration data between CPU and GSP Plugin
+		volatile NvU64  error_buff_offset;              // Buffer used to send error data from GSP Plugin -> CPU Plugin
+		volatile NvU32  migration_buf_cpu_access_offset;// CPU plugin GET/PUT offset of migration buffer
+		volatile NvBool is_migration_in_progress;       // Is migration active or cancelled
+		volatile NvU32  error_buff_cpu_get_idx;         // GET pointer into ERROR Buffer for CPU Plugin
+		volatile NvU32 attached_vgpu_count;
+		volatile struct {
+			NvU32 vgpu_type_id;
+			NvU32 host_gpu_pci_id;
+			NvU32 pci_dev_id;
+			NvU8  vgpu_uuid[VM_UUID_SIZE];
+		} host_info[VMIOPD_MAX_INSTANCES];
+	};
+} VGPU_CPU_GSP_CTRL_BUFF_REGION;
+
+//
+// Specify actions intended on getting
+// notification from CPU Plugin -> GSP plugin
+//
+typedef enum {
+	NV_VGPU_CPU_RPC_MSG_VERSION_NEGOTIATION = 1,
+	NV_VGPU_CPU_RPC_MSG_SETUP_CONFIG_PARAMS_AND_INIT,
+	NV_VGPU_CPU_RPC_MSG_RESET,
+	NV_VGPU_CPU_RPC_MSG_MIGRATION_STOP_WORK,
+	NV_VGPU_CPU_RPC_MSG_MIGRATION_CANCEL_STOP,
+	NV_VGPU_CPU_RPC_MSG_MIGRATION_SAVE_STATE,
+	NV_VGPU_CPU_RPC_MSG_MIGRATION_CANCEL_SAVE,
+	NV_VGPU_CPU_RPC_MSG_MIGRATION_RESTORE_STATE,
+	NV_VGPU_CPU_RPC_MSG_MIGRATION_RESTORE_DEFERRED_STATE,
+	NV_VGPU_CPU_RPC_MSG_MIGRATION_RESUME_WORK,
+	NV_VGPU_CPU_RPC_MSG_CONSOLE_VNC_STATE,
+	NV_VGPU_CPU_RPC_MSG_VF_BAR0_REG_ACCESS,
+	NV_VGPU_CPU_RPC_MSG_UPDATE_BME_STATE,
+	NV_VGPU_CPU_RPC_MSG_GET_GUEST_INFO,
+	NV_VGPU_CPU_RPC_MSG_MAX,
+} MESSAGE;
+
+//
+// Params structure for NV_VGPU_CPU_RPC_MSG_VERSION_NEGOTIATION
+//
+typedef struct {
+	volatile NvU32 version_cpu;        /* Sent by CPU Plugin */
+	volatile NvU32 version_negotiated; /* Updated by GSP Plugin */
+} NV_VGPU_CPU_RPC_DATA_VERSION_NEGOTIATION;
+
+//
+// Host CPU arch
+//
+typedef enum {
+	NV_VGPU_HOST_CPU_ARCH_AARCH64 = 1,
+	NV_VGPU_HOST_CPU_ARCH_X86_64,
+} NV_VGPU_HOST_CPU_ARCH;
+
+//
+// Params structure for NV_VGPU_CPU_RPC_MSG_COPY_CONFIG_PARAMS
+//
+typedef struct {
+	volatile NvU8   vgpu_uuid[VM_UUID_SIZE];
+	volatile NvU32  dbdf;
+	volatile NvU32  driver_vm_vf_dbdf;
+	volatile NvU32  vgpu_device_instance_id;
+	volatile NvU32  vgpu_type;
+	volatile NvU32  vm_pid;
+	volatile NvU32  swizz_id;
+	volatile NvU32  num_channels;
+	volatile NvU32  num_plugin_channels;
+	volatile NvU32  vmm_cap;
+	volatile NvU32  migration_feature;
+	volatile NvU32  hypervisor_type;
+	volatile NvU32  host_cpu_arch;
+	volatile NvU64  host_page_size;
+	volatile NvBool rev1[2];
+	volatile NvBool enable_uvm;
+	volatile NvBool linux_interrupt_optimization;
+	volatile NvBool vmm_migration_supported;
+	volatile NvBool rev2;
+	volatile NvBool enable_console_vnc;
+	volatile NvBool use_non_stall_linux_events;
+	volatile NvU32  rev3;
+} NV_VGPU_CPU_RPC_DATA_COPY_CONFIG_PARAMS;
+
+// Params structure for NV_VGPU_CPU_RPC_MSG_UPDATE_BME_STATE
+typedef struct {
+	volatile NvBool enable;
+	volatile NvBool allowed;
+} NV_VGPU_CPU_RPC_DATA_UPDATE_BME_STATE;
+//
+// Message Buffer:
+// CPU Plugin - Read/Write
+// GSP Plugin - Read/Write
+//
+typedef union {
+	NvU8 buf[VGPU_CPU_GSP_MESSAGE_BUFF_REGION_SIZE];
+	NV_VGPU_CPU_RPC_DATA_VERSION_NEGOTIATION    version_data;
+	NV_VGPU_CPU_RPC_DATA_COPY_CONFIG_PARAMS     config_data;
+	NV_VGPU_CPU_RPC_DATA_UPDATE_BME_STATE       bme_state;
+} VGPU_CPU_GSP_MSG_BUFF_REGION;
+
+typedef struct {
+	volatile NvU64                          sequence_update_start;
+	volatile NvU64                          sequence_update_end;
+	volatile NvU32                          effective_fb_page_size;
+	volatile NvU32                          rect_width;
+	volatile NvU32                          rect_height;
+	volatile NvU32                          surface_width;
+	volatile NvU32                          surface_height;
+	volatile NvU32                          surface_size;
+	volatile NvU32                          surface_offset;
+	volatile NvU32                          surface_format;
+	volatile NvU32                          surface_kind;
+	volatile NvU32                          surface_pitch;
+	volatile NvU32                          surface_type;
+	volatile NvU8                           surface_block_height;
+	volatile vmiop_bool_t                   is_blanking_enabled;
+	volatile vmiop_bool_t                   is_flip_pending;
+	volatile vmiop_bool_t                   is_free_pending;
+	volatile vmiop_bool_t                   is_memory_blocklinear;
+} VGPU_CPU_GSP_DISPLAYLESS_SURFACE;
+
+//
+// GSP Plugin Response Buffer:
+// CPU Plugin - Read only
+// GSP Plugin - Write only
+//
+typedef union {
+	NvU8 buf[VGPU_CPU_GSP_RESPONSE_BUFF_REGION_SIZE];
+	struct {
+		// Updated by GSP Plugin once task is complete
+		volatile NvU32                              message_seq_num_processed;
+		// Updated by GSP on completion of RPC
+		volatile NvU32                              result_code;
+		volatile NvU32                              guest_rpc_version;
+		// GSP plugin GET/PUT offset pointer of migration buffer
+		volatile NvU32                              migration_buf_gsp_access_offset;
+		// Current state of migration
+		volatile NvU32                              migration_state_save_complete;
+		// Console VNC surface information
+		volatile VGPU_CPU_GSP_DISPLAYLESS_SURFACE   surface[VMIOPD_MAX_HEADS];
+		// PUT pointer into ERROR Buffer for GSP Plugin
+		volatile NvU32                              error_buff_gsp_put_idx;
+		// Updated grid license state as received from guest
+		volatile NvU32                              grid_license_state;
+	};
+} VGPU_CPU_GSP_RESPONSE_BUFF_REGION;
+
+/******************************************************************************/
+/* GSP Control buffer shared between CPU Plugin and GSP Plugin - END          */
+/******************************************************************************/
+#endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/nv_vgpu_types.h b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/nv_vgpu_types.h
new file mode 100644
index 000000000000..903a5840366c
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/nv_vgpu_types.h
@@ -0,0 +1,51 @@
+#ifndef __src_common_sdk_nvidia_inc_nv_vgpu_types_h__
+#define __src_common_sdk_nvidia_inc_nv_vgpu_types_h__
+
+/* Excerpt of RM headers from https://github.com/NVIDIA/open-gpu-kernel-modules/tree/535.113.01 */
+
+/*
+ * SPDX-FileCopyrightText: Copyright (c) 2016-2024 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+ * SPDX-License-Identifier: MIT
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ */
+
+#define VM_UUID_SIZE            16
+#define INVALID_VGPU_DEV_INST   0xFFFFFFFFU
+#define MAX_VGPU_DEVICES_PER_VM 16U
+
+/* This enum represents the current state of guest dependent fields */
+typedef enum GUEST_VM_INFO_STATE {
+	GUEST_VM_INFO_STATE_UNINITIALIZED = 0,
+	GUEST_VM_INFO_STATE_INITIALIZED = 1,
+} GUEST_VM_INFO_STATE;
+
+/* This enum represents types of VM identifiers */
+typedef enum VM_ID_TYPE {
+	VM_ID_DOMAIN_ID = 0,
+	VM_ID_UUID = 1,
+} VM_ID_TYPE;
+
+/* This structure represents VM identifier */
+typedef union VM_ID {
+	NvU8 vmUuid[VM_UUID_SIZE];
+	NV_DECLARE_ALIGNED(NvU64 vmId, 8);
+} VM_ID;
+
+#endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/vmioplugin/inc/vmioplugin.h b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/vmioplugin/inc/vmioplugin.h
new file mode 100644
index 000000000000..58a473309e42
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/vmioplugin/inc/vmioplugin.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/*
+ * Copyright © 2024 NVIDIA Corporation
+ */
+#ifndef __src_common_sdk_vmioplugin_inc_vmioplugin_h__
+#define __src_common_sdk_vmioplugin_inc_vmioplugin_h__
+
+#define VMIOPD_MAX_INSTANCES 16
+#define VMIOPD_MAX_HEADS     4
+
+/**
+ * Boolean type.
+ */
+
+enum vmiop_bool_e {
+	vmiop_false = 0,        /*!< Boolean false */
+	vmiop_true = 1          /*!< Boolean true */
+};
+
+/**
+ * Boolean type.
+ */
+
+typedef enum vmiop_bool_e vmiop_bool_t;
+
+#endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/rpc.c b/drivers/vfio/pci/nvidia-vgpu/rpc.c
new file mode 100644
index 000000000000..c316941f4b97
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/rpc.c
@@ -0,0 +1,242 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/*
+ * Copyright © 2024 NVIDIA Corporation
+ */
+
+#include <linux/delay.h>
+#include <linux/kernel.h>
+
+#include <nvrm/nvtypes.h>
+#include <nvrm/common/sdk/nvidia/inc/ctrl/ctrl0000/ctrl0000system.h>
+#include <nvrm/common/sdk/vmioplugin/inc/vmioplugin.h>
+#include <nvrm/common/sdk/nvidia/inc/dev_vgpu_gsp.h>
+#include <nvrm/common/sdk/nvidia/inc/ctrl/ctrla081.h>
+
+#include "debug.h"
+#include "vgpu_mgr.h"
+
+static void trigger_doorbell(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+
+	u32 v = vgpu->info.gfid * 32 + 17;
+
+	writel(v, vgpu_mgr->bar0_vaddr + 0x00B80000 + 0x2200);
+	readl(vgpu_mgr->bar0_vaddr + 0x00B80000 + 0x2200);
+}
+
+static void send_rpc_request(struct nvidia_vgpu *vgpu, u32 msg_type,
+			    void *data, u64 size)
+{
+	struct nvidia_vgpu_rpc *rpc = &vgpu->rpc;
+	VGPU_CPU_GSP_CTRL_BUFF_REGION *ctrl_buf = rpc->ctrl_buf;
+
+	if (data && size)
+		memcpy_toio(rpc->msg_buf, data, size);
+
+	ctrl_buf->message_type = msg_type;
+
+	rpc->msg_seq_num++;
+	ctrl_buf->message_seq_num = rpc->msg_seq_num;
+
+	trigger_doorbell(vgpu);
+}
+
+static int wait_for_response(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_rpc *rpc = &vgpu->rpc;
+	VGPU_CPU_GSP_RESPONSE_BUFF_REGION *resp_buf = rpc->resp_buf;
+
+	u64 timeout = 120 * 1000000; /* 120s */
+
+	do {
+		if (resp_buf->message_seq_num_processed == rpc->msg_seq_num)
+			break;
+
+		usleep_range(1, 2);
+	} while (--timeout);
+
+	return timeout ? 0 : -ETIMEDOUT;
+}
+
+static int recv_rpc_response(struct nvidia_vgpu *vgpu, void *data,
+			     u64 size, u32 *result)
+{
+	struct nvidia_vgpu_rpc *rpc = &vgpu->rpc;
+	VGPU_CPU_GSP_RESPONSE_BUFF_REGION *resp_buf = rpc->resp_buf;
+	int ret;
+
+	ret = wait_for_response(vgpu);
+	if (result)
+		*result = resp_buf->result_code;
+
+	if (ret)
+		return ret;
+
+	if (data && size)
+		memcpy_fromio(data, rpc->msg_buf, size);
+
+	return 0;
+}
+
+int nvidia_vgpu_rpc_call(struct nvidia_vgpu *vgpu, u32 msg_type,
+			 void *data, u64 size)
+{
+	struct nvidia_vgpu_rpc *rpc = &vgpu->rpc;
+	u32 result;
+	int ret;
+
+	if (WARN_ON(msg_type >= NV_VGPU_CPU_RPC_MSG_MAX) ||
+		   (size > VGPU_CPU_GSP_MESSAGE_BUFF_REGION_SIZE) ||
+		   ((size != 0) && (data == NULL)))
+		return -EINVAL;
+
+	mutex_lock(&rpc->lock);
+
+	send_rpc_request(vgpu, msg_type, data, size);
+	ret = recv_rpc_response(vgpu, data, size, &result);
+
+	mutex_unlock(&rpc->lock);
+	if (ret || result) {
+		nv_vgpu_err(vgpu, "fail to recv RPC: result %u\n",
+			    result);
+		return -EINVAL;
+	}
+	return ret;
+}
+
+void nvidia_vgpu_clean_rpc(struct nvidia_vgpu *vgpu)
+{
+}
+
+static void init_rpc_buf_pointers(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_mgmt *mgmt = &vgpu->mgmt;
+	struct nvidia_vgpu_rpc *rpc = &vgpu->rpc;
+
+	rpc->ctrl_buf = mgmt->ctrl_vaddr;
+	rpc->resp_buf = rpc->ctrl_buf + VGPU_CPU_GSP_CTRL_BUFF_REGION_SIZE;
+	rpc->msg_buf = rpc->resp_buf + VGPU_CPU_GSP_RESPONSE_BUFF_REGION_SIZE;
+	rpc->migration_buf = rpc->msg_buf + VGPU_CPU_GSP_MESSAGE_BUFF_REGION_SIZE;
+	rpc->error_buf = rpc->migration_buf + VGPU_CPU_GSP_MIGRATION_BUFF_REGION_SIZE;
+}
+
+static void init_ctrl_buf_offsets(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_rpc *rpc = &vgpu->rpc;
+	VGPU_CPU_GSP_CTRL_BUFF_REGION *ctrl_buf;
+	u64 offset = 0;
+
+	ctrl_buf = rpc->ctrl_buf;
+
+	ctrl_buf->version = VGPU_CPU_GSP_CTRL_BUFF_VERSION;
+
+	offset = VGPU_CPU_GSP_CTRL_BUFF_REGION_SIZE;
+	ctrl_buf->response_buff_offset = offset;
+
+	offset += VGPU_CPU_GSP_RESPONSE_BUFF_REGION_SIZE;
+	ctrl_buf->message_buff_offset = offset;
+
+	offset += VGPU_CPU_GSP_MESSAGE_BUFF_REGION_SIZE;
+	ctrl_buf->migration_buff_offset = offset;
+
+	offset += VGPU_CPU_GSP_MIGRATION_BUFF_REGION_SIZE;
+	ctrl_buf->error_buff_offset = offset;
+}
+
+static int wait_vgpu_plugin_task_bootloaded(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_rpc *rpc = &vgpu->rpc;
+	VGPU_CPU_GSP_CTRL_BUFF_REGION *ctrl_buf = rpc->ctrl_buf;
+
+	u64 timeout = 10 * 1000000; /* 10 s */
+
+	do {
+		if (ctrl_buf->message_seq_num == GSP_PLUGIN_BOOTLOADED)
+			break;
+
+		usleep_range(1, 2);
+	} while (--timeout);
+
+	return timeout ? 0 : -ETIMEDOUT;
+}
+
+static int negotiate_rpc_version(struct nvidia_vgpu *vgpu)
+{
+	return nvidia_vgpu_rpc_call(vgpu, NV_VGPU_CPU_RPC_MSG_VERSION_NEGOTIATION,
+				    NULL, 0);
+}
+
+unsigned char config_params[] = {
+	0x24, 0xef, 0x8f, 0xf7, 0x3e, 0xd5, 0x11, 0xef, 0xae, 0x36, 0x97, 0x58,
+	0xb1, 0xcb, 0x0c, 0x87, 0x04, 0xc1, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x14, 0x00, 0xd0, 0xc1, 0x65, 0x03, 0x00, 0x00, 0xa1, 0x0e, 0x00, 0x00,
+	0xff, 0xff, 0xff, 0xff, 0x40, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00,
+	0x02, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00
+};
+
+static int send_config_params_and_init(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+	NV_VGPU_CPU_RPC_DATA_COPY_CONFIG_PARAMS params = {0};
+	NVA081_CTRL_VGPU_INFO *info = (NVA081_CTRL_VGPU_INFO *)
+				      vgpu->vgpu_type;
+
+	memcpy(&params, config_params, sizeof(config_params));
+
+	params.dbdf = vgpu->info.dbdf;
+	params.vgpu_device_instance_id =
+		nvidia_vgpu_mgr_get_gsp_client_handle(vgpu_mgr, &vgpu->gsp_client);
+	params.vgpu_type = info->vgpuType;
+	params.vm_pid = 0;
+	params.swizz_id = 0;
+	params.num_channels = vgpu->chid.num_chid;
+	params.num_plugin_channels = vgpu->chid.num_plugin_channels;
+
+	return nvidia_vgpu_rpc_call(vgpu, NV_VGPU_CPU_RPC_MSG_SETUP_CONFIG_PARAMS_AND_INIT,
+				    &params, sizeof(params));
+}
+
+/**
+ * nvidia_vgpu_setup_rpc - setup the vGPU host RPC channel and send runtime
+ * configuration.
+ * @vgpu: the vGPU instance.
+ * @vgpu_type: the vGPU type of the vGPU instance.
+ *
+ * Returns: 0 on success, others on failure.
+ */
+int nvidia_vgpu_setup_rpc(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_rpc *rpc = &vgpu->rpc;
+	int ret;
+
+	mutex_init(&rpc->lock);
+
+	init_rpc_buf_pointers(vgpu);
+	init_ctrl_buf_offsets(vgpu);
+
+	ret = wait_vgpu_plugin_task_bootloaded(vgpu);
+	if (ret) {
+		nv_vgpu_err(vgpu, "waiting bootload timeout!\n");
+		return ret;
+	}
+
+	ret = negotiate_rpc_version(vgpu);
+	if (ret) {
+		nv_vgpu_err(vgpu, "fail to negotiate rpc version!\n");
+		return ret;
+	}
+
+	ret = send_config_params_and_init(vgpu);
+	if (ret) {
+		nv_vgpu_err(vgpu, "fail to init vgpu plugin task!\n");
+		return ret;
+	}
+
+	nv_vgpu_dbg(vgpu, "vGPU RPC initialization is done.\n");
+
+	return 0;
+}
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu.c b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
index e06d5155bb38..93d27db30a41 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
@@ -8,6 +8,9 @@
 #include <nvrm/nvtypes.h>
 #include <nvrm/common/sdk/nvidia/inc/ctrl/ctrla081.h>
 #include <nvrm/common/sdk/nvidia/inc/ctrl/ctrl2080/ctrl2080vgpumgrinternal.h>
+#include <nvrm/common/sdk/nvidia/inc/ctrl/ctrl0000/ctrl0000system.h>
+#include <nvrm/common/sdk/vmioplugin/inc/vmioplugin.h>
+#include <nvrm/common/sdk/nvidia/inc/dev_vgpu_gsp.h>
 
 #include "vgpu_mgr.h"
 
@@ -240,6 +243,7 @@ int nvidia_vgpu_mgr_destroy_vgpu(struct nvidia_vgpu *vgpu)
 	if (!atomic_cmpxchg(&vgpu->status, 1, 0))
 		return -ENODEV;
 
+	nvidia_vgpu_clean_rpc(vgpu);
 	WARN_ON(shutdown_vgpu_plugin_task(vgpu));
 	WARN_ON(cleanup_vgpu_plugin_task(vgpu));
 	nvidia_vgpu_mgr_free_gsp_client(vgpu_mgr, &vgpu->gsp_client);
@@ -299,10 +303,17 @@ int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu, u8 *vgpu_type)
 	if (ret)
 		goto err_bootload_vgpu_plugin_task;
 
+	ret = nvidia_vgpu_setup_rpc(vgpu);
+	if (ret)
+		goto err_setup_rpc;
+
 	atomic_set(&vgpu->status, 1);
 
 	return 0;
 
+err_setup_rpc:
+	shutdown_vgpu_plugin_task(vgpu);
+	cleanup_vgpu_plugin_task(vgpu);
 err_bootload_vgpu_plugin_task:
 	nvidia_vgpu_mgr_free_gsp_client(vgpu_mgr, &vgpu->gsp_client);
 err_alloc_gsp_client:
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
index dcb314b14f91..e84cf4a845d4 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
@@ -7,11 +7,35 @@
 
 DEFINE_MUTEX(vgpu_mgr_attach_lock);
 
+static void unmap_pf_mmio(struct nvidia_vgpu_mgr *vgpu_mgr)
+{
+	iounmap(vgpu_mgr->bar0_vaddr);
+}
+
+static int map_pf_mmio(struct nvidia_vgpu_mgr *vgpu_mgr)
+{
+	struct pci_dev *pdev = vgpu_mgr->pdev;
+	resource_size_t start, size;
+	void *vaddr;
+
+	start = pci_resource_start(pdev, 0);
+	size = pci_resource_len(pdev, 0);
+
+	vaddr = ioremap(start, size);
+	if (!vaddr)
+		return -ENOMEM;
+
+	vgpu_mgr->bar0_vaddr = vaddr;
+
+	return 0;
+}
+
 static void vgpu_mgr_release(struct kref *kref)
 {
 	struct nvidia_vgpu_mgr *vgpu_mgr =
 		container_of(kref, struct nvidia_vgpu_mgr, refcount);
 
+	unmap_pf_mmio(vgpu_mgr);
 	nvidia_vgpu_mgr_free_gsp_client(vgpu_mgr, &vgpu_mgr->gsp_client);
 	nvidia_vgpu_mgr_detach_handle(&vgpu_mgr->handle);
 	kvfree(vgpu_mgr);
@@ -83,6 +107,8 @@ struct nvidia_vgpu_mgr *nvidia_vgpu_mgr_get(struct pci_dev *dev)
 	kref_init(&vgpu_mgr->refcount);
 	mutex_init(&vgpu_mgr->vgpu_id_lock);
 
+	vgpu_mgr->pdev = dev->physfn;
+
 	ret = nvidia_vgpu_mgr_alloc_gsp_client(vgpu_mgr,
 					       &vgpu_mgr->gsp_client);
 	if (ret)
@@ -92,9 +118,14 @@ struct nvidia_vgpu_mgr *nvidia_vgpu_mgr_get(struct pci_dev *dev)
 	if (ret)
 		goto fail_init_vgpu_types;
 
+	ret = map_pf_mmio(vgpu_mgr);
+	if (ret)
+		goto fail_map_pf_mmio;
+
 	mutex_unlock(&vgpu_mgr_attach_lock);
 	return vgpu_mgr;
 
+fail_map_pf_mmio:
 fail_init_vgpu_types:
 	nvidia_vgpu_mgr_free_gsp_client(vgpu_mgr, &vgpu_mgr->gsp_client);
 fail_alloc_gsp_client:
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
index 6f05b285484c..af922d8e539c 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
@@ -28,6 +28,16 @@ struct nvidia_vgpu_mgmt {
 	void __iomem *vgpu_task_log_vaddr;
 };
 
+struct nvidia_vgpu_rpc {
+	struct mutex lock;
+	u32 msg_seq_num;
+	void __iomem *ctrl_buf;
+	void __iomem *resp_buf;
+	void __iomem *msg_buf;
+	void __iomem *migration_buf;
+	void __iomem *error_buf;
+};
+
 struct nvidia_vgpu {
 	struct mutex lock;
 	atomic_t status;
@@ -41,6 +51,7 @@ struct nvidia_vgpu {
 	struct nvidia_vgpu_mem *fbmem_heap;
 	struct nvidia_vgpu_chid chid;
 	struct nvidia_vgpu_mgmt mgmt;
+	struct nvidia_vgpu_rpc rpc;
 };
 
 struct nvidia_vgpu_mgr {
@@ -55,6 +66,9 @@ struct nvidia_vgpu_mgr {
 	u32 num_vgpu_types;
 
 	struct nvidia_vgpu_gsp_client gsp_client;
+
+	struct pci_dev *pdev;
+	void __iomem *bar0_vaddr;
 };
 
 struct nvidia_vgpu_mgr *nvidia_vgpu_mgr_get(struct pci_dev *dev);
@@ -65,4 +79,11 @@ int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu, u8 *vgpu_type);
 
 int nvidia_vgpu_mgr_init_vgpu_types(struct nvidia_vgpu_mgr *vgpu_mgr);
 
+int nvidia_vgpu_rpc_call(struct nvidia_vgpu *vgpu, u32 msg_type,
+			 void *data, u64 size);
+void nvidia_vgpu_clean_rpc(struct nvidia_vgpu *vgpu);
+int nvidia_vgpu_setup_rpc(struct nvidia_vgpu *vgpu);
+
+int nvidia_vgpu_mgr_reset_vgpu(struct nvidia_vgpu *vgpu);
+
 #endif
-- 
2.34.1


