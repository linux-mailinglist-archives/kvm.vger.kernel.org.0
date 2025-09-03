Return-Path: <kvm+bounces-56711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 092EDB42C9B
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 00:12:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0196564DC1
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 22:12:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2FA3306D20;
	Wed,  3 Sep 2025 22:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NT/uPqKr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE942F067A
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 22:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756937508; cv=fail; b=dwUCmDavSZ7By8AebBw1wQIBDHYq3RiooNLHLD/eC5wfXqQnILYiSMdPxKMEwRwbDvV0FSYgxeS0y/up5rPNQBrtoqniNmtBaKg57WqIw0yhjcuz23ba+JzLy+7X9kc64juf9S4MGCtK2kwHu6Tfd7n4WkAaRrehBd+zZLPCTiU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756937508; c=relaxed/simple;
	bh=fp/JzpOeqtiGgKYjOP6EjTk4ZJUX3j7cnitTBgXjLiU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=edDXPP5GlEtcW7ut5AKCVfpAs+DYl1RuxbOp/RobpNfw5mIfT5P/Zm8spy2Jg4FCNG62b1DkfpfoapKtr8/jDnQWzzusIQI8rmcvNcU70C4hfiUHzEbuSI8PUCaHaljiBeJ2nY3t87fEAlgSZ2N8Zyx8W7LbQlIrJY7kpdGY3vc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NT/uPqKr; arc=fail smtp.client-ip=40.107.223.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sttZV4rBxAKFE9TMNx6yGSKO0YWa+0wajOuhunfcShLf0fyp3w7i77W5yzizoAUDy4Z69O8gdNGHTNLpRDpaVi7FfKviO4ocoXyTgmboY+89kLWMN6X5TiEwz9+NcYgqQ1TnULTzrgg3f2PAuDwfrwp4+pjH2vpRHgzNyq7YsWmfMfheeTSwIBJJ/ifcEErij1cEphWpRElnQkEepxRP+YTdBdlqmpmmS+XTdqMRkUCkfn2LDv6kk9sJKSJNoEi/Zrwfb8UICoYKLo+TzIUmTSeezWcBqxMYJmDgxDo1ykY4NFAefoTsTAvFyDlKevnhhW/Jes/iqz3FT6YgQZGSCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4zsaXR/vOjr8+mpJYOKaXTIZb2X8dHs2cSSAUeMbAz4=;
 b=D5CONepsgzWLA7W7SNbjt81V91ZVbWxtzNq07G1lYQkeYGaApuMayVku/q+gSz+9SVHefhwzxfKOuieC7eWUMQAboC2Q3TrsWN+iLGf9SEIINCjFED1yq+z+CbSqmhPu4ydmoRPIbpIh3i0KBdRZw+HTrXsF3EzQJw7XWPQ9vu3SgTJ55HIbJ8JkWozYqoYI5d8VTffiDiGH5sgyrzW67J4aGQBAbwheJZ5ArHIOa2OOTF5OCQ9luxoPH2vlYo7JwC1uxEiZpIFu7uL2mvzemnIo94YgGvOie9STi50mMqup9yEzJPwQP/Ov7xiPQ+5EDugdxDGOOJITfzWVzySTvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4zsaXR/vOjr8+mpJYOKaXTIZb2X8dHs2cSSAUeMbAz4=;
 b=NT/uPqKr4qGxJfEIPR1uviRo27flQ+Sp1MFKu4siJ4Q7pI0/MZ5eAcQapZrzE1jx4nyXXLF5q3gUKmbMnPGV8UKAodZ4blXg3YUujpDiS4wo7FRaPL7+fMlNLcmtsdUjbdmznKnxWrYsfSJp+RLpW/Z06xzBOgViHDquId4gVJvi7+bkojCa0hRLwEhA5/1EeuYyN/532FfYXczbJSzJNsXNi2T1snwv7CfPy6E1sa5s0FOtRsOwRgTHASw8n1Rl7aRGWPzikNla4ng4LxSNgdT+PUJ4gEDhP79jHSc/VM0xsRVQTb5P+dLfSGRgixgbI/q5nv/3jV0Tbt3FqnvVgg==
Received: from CH0PR04CA0024.namprd04.prod.outlook.com (2603:10b6:610:76::29)
 by SJ2PR12MB8064.namprd12.prod.outlook.com (2603:10b6:a03:4cc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Wed, 3 Sep
 2025 22:11:34 +0000
Received: from CH3PEPF0000000B.namprd04.prod.outlook.com
 (2603:10b6:610:76:cafe::6f) by CH0PR04CA0024.outlook.office365.com
 (2603:10b6:610:76::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.17 via Frontend Transport; Wed,
 3 Sep 2025 22:11:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF0000000B.mail.protection.outlook.com (10.167.244.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Wed, 3 Sep 2025 22:11:33 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:20 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:19 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 15:11:19 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <dakr@kernel.org>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>, Timur Tabi
	<ttabi@nvidia.com>
Subject: [RFC v2 10/14] vfio/nvidia-vgpu: introduce vGPU host RPC channel
Date: Wed, 3 Sep 2025 15:11:07 -0700
Message-ID: <20250903221111.3866249-11-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250903221111.3866249-1-zhiw@nvidia.com>
References: <20250903221111.3866249-1-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000B:EE_|SJ2PR12MB8064:EE_
X-MS-Office365-Filtering-Correlation-Id: ae41289e-7d58-4b78-6a2c-08ddeb36d7d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?THhObU9RTG9HTHFMUStpSUt6UW0rbnRhL0x4TmlvYUZVUHZMSDN3SWNBczMy?=
 =?utf-8?B?c25RSEhNYm1NV05jWHVRZkVCMlIyazl6UmVtNThPa05OQTUzUG5hUW1LOTNT?=
 =?utf-8?B?NHJEODJwTlZyWitoZXV4Rklua29yaWFia3BNY2IzdS8wVmJMNlBUWEo2U3U3?=
 =?utf-8?B?dEQwcHEzdXNjQWs3YlBEU0tnWUU0em9ZTUFZZFYrN0hRODkrMWt6THRmakRk?=
 =?utf-8?B?UDVpZWVQVUtYZlpFTnFNZzJ6cnI3eEVJTzd5MHI1S1lJSWxUTzlzdDhjemFM?=
 =?utf-8?B?UWEwb0UwZ3RUNUF2TlVqSzl5aXVxcFppcjgvRkdMWGU1UXpxWjlWT3JVV0xW?=
 =?utf-8?B?SXpBbkl3QjZXN2NpV2xUdWhxN09tS3VpckR6U1ZueWxOTWhyWVJxYUpnY1NW?=
 =?utf-8?B?TC9CbW10YXVhVUY1WW5XUjhUaVhvd3hUNHpPbzBKWW5BOVBDaklUQ1dHSER2?=
 =?utf-8?B?UjYreWRsaUhGakJ1dityRno0WS9wcTU3WFdTSEsxMXBTWUNlRWJneE95Wm9l?=
 =?utf-8?B?Z3pNY1FOTXdRa3IzUDhpU0RaWEJMRVJpbzZlb0xtREhuS0lhdm5rVG81aTRy?=
 =?utf-8?B?ckpXRG5lUFR1aWZ6Mkx6L01kV1liMnN3UTU0L2Y4NjM2UlZVNStsRmJHd2tO?=
 =?utf-8?B?MnhKZEpLUG1zU1N6Z2lKcERTS3FqQXFac3h4eVZXSGFpUjB6aHlnem9PYU0y?=
 =?utf-8?B?d1Y1M1ZYL25zUFAwOFpoM0dnL1p1ZlhiamM4dmR3S2JOdXRHTU1Mc0MxeUMv?=
 =?utf-8?B?UEVpUnJYY1JKUnpIeHlXTDIrekVuRGo0SWkwUnhJclV2STZzaEFRZGx3WjE3?=
 =?utf-8?B?cDNhNXQyY29lUEdCVjFmZUtZZGNOc2Y2M0lRaEk4aUwwRFN6TnMxMXphc1I4?=
 =?utf-8?B?dkh1N3B5SDA1dWpZUzVYbzVEYVlQUlNhblpKMS9xYkx3U1F5Ry9hSGtQWS9F?=
 =?utf-8?B?UnZzcjN2QmdxbTAxa3AwRVBIQXZteFVKRVc2OU11azFpeTNDNnBuTWFMZEtE?=
 =?utf-8?B?YWJJN3daUHVtN1Y4c0tWdFNJdnFic1FnNGxuRWQ2UDFuR2labEc4NkZLcHND?=
 =?utf-8?B?MnhwZzdieVFFSll6YXhaakk1Q2REeUZQbzFMeEw5YmZsNXREMjdFK0tub3NS?=
 =?utf-8?B?OUxiZE1kUGsvU1dTQ24xUG5rc0Y5bU1BalhrdHBxL2wrQUdjb1pwTDVmcHpv?=
 =?utf-8?B?T21UNlMzOURRN0NhOEc3eGsxYm5QY2loSEd2VldRTjZMTVRFL0w0ZTZsRHhX?=
 =?utf-8?B?OTBLKytXb3l0czNwMC9UakhOanNjQllTQ2VnQ0tGbUFXZjd1ZlpPb0JuVHNT?=
 =?utf-8?B?Y1cxZ1RnSHptQ25Od0VJRjU5V3RzNWVpWkF6c0U2QXMvSXFQT2l2YzVEWWMy?=
 =?utf-8?B?dTNISDBsenZBeDZ4MEhrUkVuMGFGZGh1WVNyUzJ0YkNURURXNzBuNEJkZEFL?=
 =?utf-8?B?bkF2WDd4a0tDZ2NvcGowTmZGanZaSXYrdytraGVPWlFlT2ZhdnR4Ull6ZC9t?=
 =?utf-8?B?TWlTazQzc1JlN3p2eE1YL3BrSzNtTlF1TXBPcjRBRStyVngwa2s3UG9zZ1N3?=
 =?utf-8?B?OG0rMmhpZEJ6bWQ3SGpxRUtRL2YwN0t5R0kzRUFKUkFCVnVDNmpOZ2RZV0tz?=
 =?utf-8?B?RkhGQzF1RER4ZnBMQTRKSDF6VlV1WkJaRC9SWWc0VEpCdHB3SUFqSDlIOERv?=
 =?utf-8?B?ZFQ2d0xmWkFBL3dibEZwUzlZeVN6UnBXeFczZXFncFc0S2ZlOG5DRm9GUytU?=
 =?utf-8?B?Qjk0NXhTR3AxOFZodnZyZzV1a3VhbmNXMGdWSldBUmRDNDZ5VU1MK2dZUVlE?=
 =?utf-8?B?N2Q4MDFObU5VYjZ4N3BzZnRSNVJzK0ZIbUtvR1d4amx3dkx5WElnbkIvSFFn?=
 =?utf-8?B?TDQrTnlYb0dVR3kzTmZhMWJzQ0xyZzk0Rm95aXNBa2ZuN2M4T29HVllqR3Mw?=
 =?utf-8?B?OWJVQjIrTUIxbmZhZzN4emxxQW11d3J2Q1hDZnNtSndkVHFsbC9IbldPeGxR?=
 =?utf-8?B?T0N5ekZnKzh3eGN6R2ZjZ0pVY0hERjFhRlBKN3dSVHl6a2x6OWZ0RzZpUng2?=
 =?utf-8?B?dytkTEhMVzVOOE9nV1NaK2RpVFFCcHF1ZGpBZz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 22:11:33.6726
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae41289e-7d58-4b78-6a2c-08ddeb36d7d4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8064

A newly created vGPU requires some runtime configuration to be uploaded
before moving on.

Introduce the vGPU host RPCs manipulation APIs to send vGPU RPCs.
Send vGPU RPCs to upload the runtime configuration of a vGPU.

Cc: Timur Tabi <ttabi@nvidia.com>
Cc: Aniket Agashe <aniketa@nvidia.com>
Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/nvidia-vgpu/Makefile         |   2 +-
 .../nvidia-vgpu/include/nvrm/nv_vgpu_types.h  |  34 +++
 .../vfio/pci/nvidia-vgpu/include/nvrm/vgpu.h  | 182 +++++++++++++
 drivers/vfio/pci/nvidia-vgpu/rpc.c            | 254 ++++++++++++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu.c           |   8 +
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c       |  31 +++
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h       |  22 ++
 7 files changed, 532 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/nv_vgpu_types.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/vgpu.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/rpc.c

diff --git a/drivers/vfio/pci/nvidia-vgpu/Makefile b/drivers/vfio/pci/nvidia-vgpu/Makefile
index 94ba4ed4e131..91e57c65ca27 100644
--- a/drivers/vfio/pci/nvidia-vgpu/Makefile
+++ b/drivers/vfio/pci/nvidia-vgpu/Makefile
@@ -2,4 +2,4 @@
 subdir-ccflags-y += -I$(src)/include
 
 obj-$(CONFIG_NVIDIA_VGPU_VFIO_PCI) += nvidia_vgpu_vfio_pci.o
-nvidia_vgpu_vfio_pci-y := vgpu_mgr.o vgpu.o metadata.o metadata_vgpu_type.o
+nvidia_vgpu_vfio_pci-y := vgpu_mgr.o vgpu.o metadata.o metadata_vgpu_type.o rpc.o
diff --git a/drivers/vfio/pci/nvidia-vgpu/include/nvrm/nv_vgpu_types.h b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/nv_vgpu_types.h
new file mode 100644
index 000000000000..fc067caf5dea
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/nv_vgpu_types.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: MIT */
+
+/* Copyright (c) 2025, NVIDIA CORPORATION. All rights reserved. */
+
+#ifndef __NVRM_VGPU_TYPES_H__
+#define __NVRM_VGPU_TYPES_H__
+
+/* Excerpt of RM headers from https://github.com/NVIDIA/open-gpu-kernel-modules/tree/570.124.04 */
+
+#include <nvrm/nvtypes.h>
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
diff --git a/drivers/vfio/pci/nvidia-vgpu/include/nvrm/vgpu.h b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/vgpu.h
new file mode 100644
index 000000000000..d28af74e9603
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/vgpu.h
@@ -0,0 +1,182 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Copyright © 2025 NVIDIA Corporation
+ */
+#ifndef __NVRM_VGPU_H__
+#define __NVRM_VGPU_H__
+
+#include <nvrm/nv_vgpu_types.h>
+
+#define VMIOPD_MAX_INSTANCES 16
+#define VMIOPD_MAX_HEADS     4
+
+#define GSP_PLUGIN_BOOTLOADED 0x4E654A6F
+
+/*
+ *   GSP Plugin heap memory layout
+ * +--------------------------------+ offset = 0
+ * |         CONTROL BUFFER         |
+ * +--------------------------------+
+ * |        RESPONSE BUFFER         |
+ * +--------------------------------+
+ * |         MESSAGE BUFFER         |
+ * +--------------------------------+
+ * |        MIGRATION BUFFER        |
+ * +--------------------------------+
+ * |    GSP PLUGIN ERROR BUFFER     |
+ * +--------------------------------+
+ * |    INIT TASK LOG BUFFER        |
+ * +--------------------------------+
+ * |    VGPU TASK LOG BUFFER        |
+ * +--------------------------------+
+ * |       KERNEL LOG BUFFER        |
+ * +--------------------------------+
+ * |      MEMORY AVAILABLE FOR      |
+ * | GSP PLUGIN INTERNAL HEAP USAGE |
+ * +--------------------------------+
+ */
+#define VGPU_CPU_GSP_CTRL_BUFF_VERSION              0x1
+#define VGPU_CPU_GSP_CTRL_BUFF_REGION_SIZE          4096
+#define VGPU_CPU_GSP_RESPONSE_BUFF_REGION_SIZE      4096
+#define VGPU_CPU_GSP_MESSAGE_BUFF_REGION_SIZE       4096
+#define VGPU_CPU_GSP_MIGRATION_BUFF_REGION_SIZE     (2 * 1024 * 1024)
+#define VGPU_CPU_GSP_ERROR_BUFF_REGION_SIZE         4096
+#define VGPU_CPU_GSP_INIT_TASK_LOG_BUFF_REGION_SIZE (128 * 1024)
+#define VGPU_CPU_GSP_VGPU_TASK_LOG_BUFF_REGION_SIZE (256 * 1024)
+#define VGPU_CPU_GSP_KERNEL_TASK_LOG_BUFF_REGION_SIZE (64 * 1024)
+#define VGPU_CPU_GSP_COMMUNICATION_BUFF_TOTAL_SIZE  (VGPU_CPU_GSP_CTRL_BUFF_REGION_SIZE + \
+		VGPU_CPU_GSP_RESPONSE_BUFF_REGION_SIZE + \
+		VGPU_CPU_GSP_MESSAGE_BUFF_REGION_SIZE + \
+		VGPU_CPU_GSP_MIGRATION_BUFF_REGION_SIZE + \
+		VGPU_CPU_GSP_ERROR_BUFF_REGION_SIZE + \
+		VGPU_CPU_GSP_INIT_TASK_LOG_BUFF_REGION_SIZE + \
+		VGPU_CPU_GSP_VGPU_TASK_LOG_BUFF_REGION_SIZE + \
+		VGPU_CPU_GSP_KERNEL_TASK_LOG_BUFF_REGION_SIZE)
+
+typedef union {
+	NvU8 buf[VGPU_CPU_GSP_CTRL_BUFF_REGION_SIZE];
+	struct {
+		NvU32  version;
+		NvU32  message_type;
+		NvU32  message_seq_num;
+		NvU64  response_buff_offset;
+		NvU64  message_buff_offset;
+		NvU64  migration_buff_offset;
+		NvU64  error_buff_offset;
+		NvU32  migration_buf_cpu_access_offset;
+		NvBool is_migration_in_progress;
+		NvU32  error_buff_cpu_get_idx;
+		NvU32 attached_vgpu_count;
+		struct {
+			NvU32 vgpu_type_id;
+			NvU32 host_gpu_pci_id;
+			NvU32 pci_dev_id;
+			NvU8  vgpu_uuid[VM_UUID_SIZE];
+		} host_info[VMIOPD_MAX_INSTANCES];
+	};
+} VGPU_CPU_GSP_CTRL_BUFF_REGION;
+
+enum {
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
+};
+
+typedef struct {
+	NvU32 version_cpu;
+	NvU32 version_negotiated;
+} NV_VGPU_CPU_RPC_DATA_VERSION_NEGOTIATION;
+
+typedef struct {
+	NvU8   vgpu_uuid[VM_UUID_SIZE];
+	NvU32  dbdf;
+	NvU32  driver_vm_vf_dbdf;
+	NvU32  vgpu_device_instance_id;
+	NvU32  vgpu_type;
+	NvU32  vm_pid;
+	NvU32  swizz_id;
+	NvU32  num_channels;
+	NvU32  num_plugin_channels;
+	NvU32  vmm_cap;
+	NvU32  migration_feature;
+	NvU32  hypervisor_type;
+	NvU32  host_cpu_arch;
+	NvU64  host_page_size;
+	NvBool rev1[3];
+	NvBool enable_uvm;
+	NvBool linux_interrupt_optimization;
+	NvBool vmm_migration_supported;
+	NvBool rev2;
+	NvBool enable_console_vnc;
+	NvBool use_non_stall_linux_events;
+	NvBool rev3[3];
+	NvU16  placement_id;
+	NvU32  rev4;
+	NvU32  channel_usage_threshold_percentage;
+	NvBool rev5;
+	NvU32  rev6;
+	NvBool rev7;
+} NV_VGPU_CPU_RPC_DATA_COPY_CONFIG_PARAMS;
+
+typedef struct {
+	NvBool enable;
+	NvBool allowed;
+} NV_VGPU_CPU_RPC_DATA_UPDATE_BME_STATE;
+
+typedef union {
+	NvU8 buf[VGPU_CPU_GSP_MESSAGE_BUFF_REGION_SIZE];
+	NV_VGPU_CPU_RPC_DATA_VERSION_NEGOTIATION    version_data;
+	NV_VGPU_CPU_RPC_DATA_UPDATE_BME_STATE       bme_state;
+} VGPU_CPU_GSP_MSG_BUFF_REGION;
+
+typedef struct {
+	NvU64 sequence_update_start;
+	NvU64 sequence_update_end;
+	NvU32 effective_fb_page_size;
+	NvU32 rect_width;
+	NvU32 rect_height;
+	NvU32 surface_width;
+	NvU32 surface_height;
+	NvU32 surface_size;
+	NvU32 surface_offset;
+	NvU32 surface_format;
+	NvU32 surface_kind;
+	NvU32 surface_pitch;
+	NvU32 surface_type;
+	NvU8  surface_block_height;
+	NvBool is_blanking_enabled;
+	NvBool is_flip_pending;
+	NvBool is_free_pending;
+	NvBool is_memory_blocklinear;
+} VGPU_CPU_GSP_DISPLAYLESS_SURFACE;
+
+typedef union {
+	NvU8 buf[VGPU_CPU_GSP_RESPONSE_BUFF_REGION_SIZE];
+	struct {
+		NvU32  message_seq_num_received;
+		NvU32  message_seq_num_processed;
+		NvU32  result_code;
+		NvU32  guest_rpc_version;
+		NvU32  migration_buf_gsp_access_offset;
+		NvU32  migration_state_save_complete;
+		VGPU_CPU_GSP_DISPLAYLESS_SURFACE surface[VMIOPD_MAX_HEADS];
+		NvU32  error_buff_gsp_put_idx;
+		NvU32  grid_license_state;
+		NvU32  guest_os_type;
+		NvU32  frl_config;
+	};
+} VGPU_CPU_GSP_RESPONSE_BUFF_REGION;
+
+#endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/rpc.c b/drivers/vfio/pci/nvidia-vgpu/rpc.c
new file mode 100644
index 000000000000..1d326e194872
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/rpc.c
@@ -0,0 +1,254 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright © 2025 NVIDIA Corporation
+ */
+
+#include <linux/delay.h>
+#include <linux/kernel.h>
+
+#include <nvrm/vgpu.h>
+
+#include "debug.h"
+#include "vgpu_mgr.h"
+
+#define NV_VIRTUAL_FUNCTION_PRIV_DOORBELL (0xb80000 + 0x2200)
+
+static void trigger_doorbell(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+
+	u32 v = vgpu->info.gfid * 32 + 17;
+
+	writel(v, vgpu_mgr->bar0_vaddr + NV_VIRTUAL_FUNCTION_PRIV_DOORBELL);
+	readl(vgpu_mgr->bar0_vaddr + NV_VIRTUAL_FUNCTION_PRIV_DOORBELL);
+}
+
+static void send_rpc_request(struct nvidia_vgpu *vgpu, u32 msg_type,
+			     void *data, u64 size)
+{
+	struct nvidia_vgpu_rpc *rpc = &vgpu->rpc;
+	VGPU_CPU_GSP_CTRL_BUFF_REGION *ctrl_buf = rpc->ctrl_buf;
+
+	if (data && size)
+		memcpy_toio(rpc->msg_buf, data, size);
+
+	writel(msg_type, &ctrl_buf->message_type);
+
+	rpc->msg_seq_num++;
+	writel(rpc->msg_seq_num, &ctrl_buf->message_seq_num);
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
+		if (readl(&resp_buf->message_seq_num_processed) == rpc->msg_seq_num)
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
+/**
+ * nvidia_vgpu_rpc_call - vGPU host RPC call.
+ * @vgpu: the vGPU instance.
+ * @msg_type: the RPC message.
+ * @data: the RPC data.
+ * @size: the RPC size.
+ *
+ * Returns: zero on success, others on failure.
+ */
+int nvidia_vgpu_rpc_call(struct nvidia_vgpu *vgpu, u32 msg_type,
+			 void *data, u64 size)
+{
+	struct nvidia_vgpu_rpc *rpc = &vgpu->rpc;
+	u32 result;
+	int ret;
+
+	if (WARN_ON(msg_type >= NV_VGPU_CPU_RPC_MSG_MAX) ||
+	    size > VGPU_CPU_GSP_MESSAGE_BUFF_REGION_SIZE ||
+	    (size != 0 && !data))
+		return -EINVAL;
+
+	mutex_lock(&rpc->lock);
+
+	send_rpc_request(vgpu, msg_type, data, size);
+	ret = recv_rpc_response(vgpu, data, size, &result);
+
+	mutex_unlock(&rpc->lock);
+	if (ret || result) {
+		vgpu_error(vgpu, "fail to recv RPC: result %u\n",
+			   result);
+		return -EINVAL;
+	}
+	return ret;
+}
+
+/**
+ * nvidia_vgpu_clean_rpc - clean vGPU host RPCl
+ * @vgpu: the vGPU instance.
+ */
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
+	writel(VGPU_CPU_GSP_CTRL_BUFF_VERSION, &ctrl_buf->version);
+
+	offset = VGPU_CPU_GSP_CTRL_BUFF_REGION_SIZE;
+	writeq(offset, &ctrl_buf->response_buff_offset);
+
+	offset += VGPU_CPU_GSP_RESPONSE_BUFF_REGION_SIZE;
+	writeq(offset, &ctrl_buf->message_buff_offset);
+
+	offset += VGPU_CPU_GSP_MESSAGE_BUFF_REGION_SIZE;
+	writeq(offset, &ctrl_buf->migration_buff_offset);
+
+	offset += VGPU_CPU_GSP_MIGRATION_BUFF_REGION_SIZE;
+	writeq(offset, &ctrl_buf->error_buff_offset);
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
+		if (readl(&ctrl_buf->message_seq_num) == GSP_PLUGIN_BOOTLOADED)
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
+/* Initial snapshot of config params */
+static const unsigned char config_params[] = {
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
+	struct nvidia_vgpu_info *info = &vgpu->info;
+	NV_VGPU_CPU_RPC_DATA_COPY_CONFIG_PARAMS params = {0};
+
+	memcpy(&params, config_params, sizeof(config_params));
+
+	params.dbdf = vgpu->info.dbdf;
+	params.vgpu_device_instance_id =
+		nvidia_vgpu_mgr_get_gsp_client_handle(vgpu_mgr, &vgpu->gsp_client);
+	params.vgpu_type = info->vgpu_type->vgpu_type;
+	params.vm_pid = vgpu->info.vm_pid;
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
+ *
+ * Returns: zero on success, others on failure.
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
+		vgpu_error(vgpu, "host_rpc: waiting bootload timeout\n");
+		return ret;
+	}
+
+	vgpu_debug(vgpu, "bootloaded\n");
+
+	ret = negotiate_rpc_version(vgpu);
+	if (ret) {
+		vgpu_error(vgpu, "host_rpc: fail to negotiate rpc version\n");
+		return ret;
+	}
+
+	ret = send_config_params_and_init(vgpu);
+	if (ret) {
+		vgpu_error(vgpu, "host_rpc: fail to init vgpu plugin task\n");
+		return ret;
+	}
+
+	vgpu_debug(vgpu, "active\n");
+
+	return 0;
+}
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu.c b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
index 5778365c051f..9e8ea77bbcc5 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
@@ -332,6 +332,7 @@ int nvidia_vgpu_mgr_destroy_vgpu(struct nvidia_vgpu *vgpu)
 	if (!atomic_cmpxchg(&vgpu->status, 1, 0))
 		return -ENODEV;
 
+	nvidia_vgpu_clean_rpc(vgpu);
 	WARN_ON(shutdown_vgpu_plugin_task(vgpu));
 	WARN_ON(cleanup_vgpu_plugin_task(vgpu));
 	nvidia_vgpu_mgr_free_gsp_client(vgpu_mgr, &vgpu->gsp_client);
@@ -399,12 +400,19 @@ int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu)
 	if (ret)
 		goto err_bootload_vgpu_plugin_task;
 
+	ret = nvidia_vgpu_setup_rpc(vgpu);
+	if (ret)
+		goto err_setup_rpc;
+
 	atomic_set(&vgpu->status, 1);
 
 	vgpu_debug(vgpu, "created\n");
 
 	return 0;
 
+err_setup_rpc:
+	shutdown_vgpu_plugin_task(vgpu);
+	cleanup_vgpu_plugin_task(vgpu);
 err_bootload_vgpu_plugin_task:
 	nvidia_vgpu_mgr_free_gsp_client(vgpu_mgr, &vgpu->gsp_client);
 err_alloc_gsp_client:
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
index 6338dd9c86b6..6f53bd7ca940 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
@@ -9,6 +9,29 @@
 #include <nvrm/vmmu.h>
 #include <nvrm/ecc.h>
 
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
 static void clean_vgpu_mgr(struct nvidia_vgpu_mgr *vgpu_mgr)
 {
 	if (vgpu_mgr->use_chid_alloc_bitmap) {
@@ -30,6 +53,7 @@ static void vgpu_mgr_release(struct kref *kref)
 	if (WARN_ON(atomic_read(&vgpu_mgr->num_vgpus)))
 		return;
 
+	unmap_pf_mmio(vgpu_mgr);
 	nvidia_vgpu_mgr_clean_metadata(vgpu_mgr);
 	clean_vgpu_mgr(vgpu_mgr);
 	nvidia_vgpu_mgr_free_gsp_client(vgpu_mgr, &vgpu_mgr->gsp_client);
@@ -73,6 +97,7 @@ static struct nvidia_vgpu_mgr *alloc_vgpu_mgr(struct nvidia_vgpu_mgr_handle *han
 		return ERR_PTR(-ENOMEM);
 
 	vgpu_mgr->handle = *handle;
+	vgpu_mgr->pdev = handle->pf_pdev;
 
 	kref_init(&vgpu_mgr->refcount);
 	mutex_init(&vgpu_mgr->vgpu_list_lock);
@@ -295,6 +320,10 @@ static int pf_attach_handle_fn(void *handle, struct nvidia_vgpu_vfio_handle_data
 	if (ret)
 		goto fail_setup_metadata;
 
+	ret = map_pf_mmio(vgpu_mgr);
+	if (ret)
+		goto fail_map_pf_mmio;
+
 	attach_vgpu_mgr(vgpu_mgr, handle_data);
 
 	ret = attach_data->init_vfio_fn(vgpu_mgr, attach_data->init_vfio_fn_data);
@@ -307,6 +336,8 @@ static int pf_attach_handle_fn(void *handle, struct nvidia_vgpu_vfio_handle_data
 
 fail_init_fn:
 	detach_vgpu_mgr(handle_data);
+	unmap_pf_mmio(vgpu_mgr);
+fail_map_pf_mmio:
 	nvidia_vgpu_mgr_clean_metadata(vgpu_mgr);
 fail_setup_metadata:
 	clean_vgpu_mgr(vgpu_mgr);
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
index 323acf52068e..fe475f8b2882 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
@@ -58,6 +58,17 @@ struct nvidia_vgpu_mgmt {
 	void __iomem *kernel_log_vaddr;
 };
 
+struct nvidia_vgpu_rpc {
+	/* RPC channel lock */
+	struct mutex lock;
+	u32 msg_seq_num;
+	void __iomem *ctrl_buf;
+	void __iomem *resp_buf;
+	void __iomem *msg_buf;
+	void __iomem *migration_buf;
+	void __iomem *error_buf;
+};
+
 /**
  * struct nvidia_vgpu - per-vGPU state
  *
@@ -71,6 +82,7 @@ struct nvidia_vgpu_mgmt {
  * @chid: vGPU channel IDs
  * @fbmem_heap: allocated FB memory for the vGPU
  * @mgmt: vGPU mgmt heap
+ * @rpc: vGPU host RPC
  */
 struct nvidia_vgpu {
 	/* Per-vGPU lock */
@@ -86,6 +98,7 @@ struct nvidia_vgpu {
 	struct nvidia_vgpu_chid chid;
 	struct nvidia_vgpu_mem *fbmem_heap;
 	struct nvidia_vgpu_mgmt mgmt;
+	struct nvidia_vgpu_rpc rpc;
 };
 
 /**
@@ -112,6 +125,8 @@ struct nvidia_vgpu {
  * @num_vgpu_types: number of installed vGPU types
  * @use_alloc_bitmap: use chid allocator for the PF driver doesn't support chid allocation
  * @chid_alloc_bitmap: chid allocator bitmap
+ * @pdev: the PCI device pointer
+ * @bar0_vaddr: the virtual address of BAR0
  */
 struct nvidia_vgpu_mgr {
 	struct kref refcount;
@@ -147,6 +162,9 @@ struct nvidia_vgpu_mgr {
 
 	bool use_chid_alloc_bitmap;
 	void *chid_alloc_bitmap;
+
+	struct pci_dev *pdev;
+	void __iomem *bar0_vaddr;
 };
 
 #define nvidia_vgpu_mgr_for_each_vgpu(vgpu, vgpu_mgr) \
@@ -160,5 +178,9 @@ int nvidia_vgpu_mgr_destroy_vgpu(struct nvidia_vgpu *vgpu);
 int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu);
 int nvidia_vgpu_mgr_setup_metadata(struct nvidia_vgpu_mgr *vgpu_mgr);
 void nvidia_vgpu_mgr_clean_metadata(struct nvidia_vgpu_mgr *vgpu_mgr);
+int nvidia_vgpu_rpc_call(struct nvidia_vgpu *vgpu, u32 msg_type,
+			 void *data, u64 size);
+void nvidia_vgpu_clean_rpc(struct nvidia_vgpu *vgpu);
+int nvidia_vgpu_setup_rpc(struct nvidia_vgpu *vgpu);
 
 #endif
-- 
2.34.1


