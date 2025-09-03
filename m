Return-Path: <kvm+bounces-56706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 481F9B42C94
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 00:12:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA4AC1BC4027
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 22:12:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBB802EF662;
	Wed,  3 Sep 2025 22:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="l7mVepfb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0580A2EDD7B
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 22:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756937500; cv=fail; b=QR8KxaBYOxpGgESTnDteO31IPllyzCltJNo6uz334MNlvkq6phNEOuPec6K38TyA1j0xrj4jgF4wzKW8xCQXBJ1zsnFDwlvlnbEM3pS46nYCrVDx4gus7SiNErm1r3gUUv1aHtM2MgJe98MBhDY35SPAG5unhNFuciv7SgJE8kg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756937500; c=relaxed/simple;
	bh=ANqY7lttTfmpKjzgS6WnKRSRTcKGvQXW0OcIj7cTXoU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PHdXcgSI7kB0NhyxxFj25g8p6PscMYkQQmcgTtIfha5XSCY2Ps1rAxt61uDnY5b3KStOcN6mG/YLIejbXUq7zkMSw9Kf4y8K9rCfPBJm2ovE0BGetZGUU0Bh0jOIqt/X/wquQf2nrnrNRE/CJGK+4g/PU4Kff9wQynlzaTrO95Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=l7mVepfb; arc=fail smtp.client-ip=40.107.92.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YHlMWLS3P8moEfFI/NjJnEWA5pRlp/X9cLFLYoaXBCNdOD5mIQQX2XnFJQCgLdIj5WcRw4Y6TwIgMIbOkFUQrzgHQhY0v0tWgjJZayb4NRZI+xUKKCXfz5YlJN6oWRdP+G1h9zckLSNGDVjFSRvgNuXK2Qkg/ovdh0WB4D/sEFHZhVnBNq1PCLK52DjCXHUumiakuEixsIEf77cGzIy3MWlf8NomBIYq1z+T0LRMVd/hsKmuIuXX1HZUiwNpVeSlPMbiowL8WPBh/AV3wzcXkdW0TPklDrfNd9cwOUu00T1yJGT7D1mgPN3kJr1FiG6XMvHIg5rU+/a+qFvz+GjdlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BtI/koewrZFVanW76O6Lg6Vw73OxoK4Ma1kc5YuuqZE=;
 b=EyuYEtgoQGW0PX8YGVdaFE2lnECOx137qzvjMo3ZXqrFVhqLehPcsw5512U1xgJGyNpB6as0B+VTWlbqxpsFuj/klW5Ax95PCq2N1CCdHq7/eH4laR7L/T8tdV4HWLTTcbRbO75VtY+PCsd5eRB5dWvADwc8/FqFpCUamoiXTID8fxZZkoWtCz6u4mzvd/QP/er07rHK93fydJJeE9df8rVrEzemMVryVatT/QrTntFNOT9eLo4tYTUKpHtKh/wvTNBsw0GxjGeDMZE/n7wu9toNmpHkSKDQxzTcth4/AyzkLinc2dZE6e/f0kVam6noMqRht9DuGVO2eKFKK709+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtI/koewrZFVanW76O6Lg6Vw73OxoK4Ma1kc5YuuqZE=;
 b=l7mVepfbZF4EpV1C/U5Pu9ZkW8l4b8Mkj9wezG+7N5MQ82rwIwW7aeN3XcvvHnD71sxJfD1cjT2X+Muc6do/Wjgakw5lm2+1DsdczfNnrPcGvi3g4X17ePMX6O345y0Mao5SWySxfsXlhfpN9bhi1MRv5hkI7yqrqCjLnHHODI18mX9u956qYhUHkZYOi/2co2SjAE8nkSdO1Ot4tuJh+PlVku3aAFpQWruKaDzP8HeO9ZsWa8Xg6nODiH19MdFyn0ye1IP6gQhmLKq5AYryLCO0/9spFsGr/WkR70t/cuzSUBoqPMYUXhgyLQOvm+57ZQMoKsS9yvMxOMCRAKMQUQ==
Received: from CH2PR02CA0025.namprd02.prod.outlook.com (2603:10b6:610:4e::35)
 by CH3PR12MB8330.namprd12.prod.outlook.com (2603:10b6:610:12c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Wed, 3 Sep
 2025 22:11:31 +0000
Received: from CH3PEPF0000000C.namprd04.prod.outlook.com
 (2603:10b6:610:4e:cafe::61) by CH2PR02CA0025.outlook.office365.com
 (2603:10b6:610:4e::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.28 via Frontend Transport; Wed,
 3 Sep 2025 22:11:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF0000000C.mail.protection.outlook.com (10.167.244.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Wed, 3 Sep 2025 22:11:31 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:16 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:16 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 15:11:15 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <dakr@kernel.org>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC v2 05/14] vfio/nvidia-vgpu: allocate vGPU FB memory when creating vGPUs
Date: Wed, 3 Sep 2025 15:11:02 -0700
Message-ID: <20250903221111.3866249-6-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000C:EE_|CH3PR12MB8330:EE_
X-MS-Office365-Filtering-Correlation-Id: 2316d714-18cf-4adc-a4af-08ddeb36d64c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cXBUZlpTNitUdzRSWGx0cGVXbU8vVmt4YktXRC8vM05GTTN2WGFIWDFlejRr?=
 =?utf-8?B?YzhneGs2NmpJWFhMQ0hJK0xKL0N2aEVHNmVraFFOcDd1ak9FV3dTZlBQeGlv?=
 =?utf-8?B?aTlBTS80b3FOODRyTFNiMUFpTy8rNUVMOCtvV2VDZVFsK1JvN1RlaFJYQlJq?=
 =?utf-8?B?MmNDaWpWMS9RRXEzWDQ3dG5Uck1qMU5Qd0laLzE5REZqTVBBNVY0ekFVa1JL?=
 =?utf-8?B?U25KeFMrdGZCeENvSEJZdWQrckF2SmZTampVb0dHbmFLVDZVK3lla0czMTZS?=
 =?utf-8?B?blgvbHdCREdLMHJvYkRLd0YwOWdmQkhBWjBNRFMvZlNTUjdkeGlycndya0pv?=
 =?utf-8?B?ZjJRUTduVWFFYVNsekUwV2lSeFFMY1g0cG5jMTE1S1pjcjQxbkxRNEtwRS9o?=
 =?utf-8?B?SDRrbU9IZHpXdUVEZU5VRVVGcXJVMXdOUW9Ldy82RXQraEVETmlVOEZQUFZS?=
 =?utf-8?B?Z05WSWRmam1ZYWExM2F4Mk4vS1hKSUdObTMxbUpYaXVaWlRTUUU1Ti84RllU?=
 =?utf-8?B?N1VhQUYyYSt4NTR4NzhLNWF1VWhIcXRJZWo1dm00UjNna1pibXlEMDBrUGx6?=
 =?utf-8?B?RkdQaVNEbmV5UGIvbzJxTlFzVVhiTHJlVldLVCs4MmZkZFNqWkU3NFIxM2Z1?=
 =?utf-8?B?Y3N6SHJiemVuMStDSSs0Zkw3Rm1tNFluYm1FNnBhWnpraUpYQm83YWQrenRQ?=
 =?utf-8?B?RExLLzR6SytYZTJuc1N0V2V0bUVKbHZ3Tm44dFpHWDJVcjJuYWkzd3RVWWta?=
 =?utf-8?B?TFdMRnZXbEQrV3NGazdZVElYUTJWWkpmS25IcGp5LzVkbDBUcWFTTUZRUkVW?=
 =?utf-8?B?RVdEVXBlZ0VuNFZkZ20xZWpQbnh3UGp5UVlPYklPbWhsNnNmR2lDU00rV3Jm?=
 =?utf-8?B?RjJnN005d2ZUWCthTlgyZzhHaEJUSzAxMXAzZUhRSmROMFB6eDkvdGdGcDNR?=
 =?utf-8?B?R053NS9za1FEenZDdHowZ3h5YVBvWVlhUTREalBKZmJXZ0FpTDdDbDFSVzFv?=
 =?utf-8?B?SFI0T0hqZis5OG0wNkFsZWlLVlV2QVQ2TDVoYVhsVVdKdTB3d1lGK2lORVJU?=
 =?utf-8?B?SkdRdDNGZVlYdlZLN2pueTNuUkRmSW8wVkxybG43Z21pWS9kbXNXYTBBeUY0?=
 =?utf-8?B?TmxIbjVjVmsvRDFFYy8wRU53ajFpa3luOHFXRmlBMVgwSXNqQlF1bGhKb0o4?=
 =?utf-8?B?b3RJclo0bUtqV0ttSGlyK3kxT2RCR05QcmtQLytCbE5xYnRtSU9VVTB0Kzh2?=
 =?utf-8?B?Q2lTVEZydXNtUFlEM2NJVTN4LzNaR0I5SUdWNjFFN1BSRUQ0c0JmQWJ3UHhq?=
 =?utf-8?B?Sk12TjQxQWp0YXp6WTdMcHk4bTF3aXpPRHhOY0E1YmhEU1lOdXlpNEZZS0lO?=
 =?utf-8?B?SVhzYUd1UmplWDhGZFdGdHp6cGMxM2F3cTFsQVIwc2ZNaGpvZEoxM3l5b0dK?=
 =?utf-8?B?QjJxTnR6VVJpMUJ6aHBZV0xhTC9jNGdzMWViMDJLQjlTdit1RnhuNjd1S1Vi?=
 =?utf-8?B?dVY4VlNvN0syOGdUSzFsbDdpcVZhYWMxZXlpbnJpZDhGRjlyaWtEODEvdU9u?=
 =?utf-8?B?dDFUK3U5dFFmTTZ6eldLZ2Z5NEQxTTU4TDJzUVU3MFVHODBMOFI2cmxyY2dv?=
 =?utf-8?B?TG4zSHFrVG5RSDFPU3hNOFBwY2Fud1J1MlpvdEM1SG93aExwOWdGb2RIdXNa?=
 =?utf-8?B?U0hlR1JRVnozeEhLd1dOVGw3RmlhV3F1SlFuME9UYWpiMitrTjBKamlVRHhU?=
 =?utf-8?B?MlZpcW9GNmtKWTJoUW5TNVBNY1lBTHFtblhzNUJibDlmaHM2akltc0FnVXBi?=
 =?utf-8?B?Z2Z5RWl3Tjg0UHNVaTJxbG0wblRneTYzekJKbXlJR2tGZkJnODRlNFVRY0Vv?=
 =?utf-8?B?NVNVMUFsS3VUdEJuUFFHcEs5YkJqaEFpK2E3M2IwN3B2UWs2d2ZJVjNwZU1K?=
 =?utf-8?B?azdRNTBYcnoyQjRwaTdMd2M0OG9kS2Q0WjFXUFoxbFRBTGU1b3dZU2d3Wms2?=
 =?utf-8?B?MjAxUlN4Z1c3MEVTZHMvYVk3cytMclBINlJtTTVwOWtHYzcrRnk3RkJGc3B4?=
 =?utf-8?B?cGZibGwyeDFLREZUeklqVEVzdU01OVBiVWc4QT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 22:11:31.1345
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2316d714-18cf-4adc-a4af-08ddeb36d64c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8330

Creating a vGPU requires allocating a portion of the FB memory from the
NVKM. The size of the FB memory that a vGPU requires is from the vGPU
type.

Acquire the size of the required FB memory from the vGPU type. Allocate
the FB memory from NVKM when creating a vGPU.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/nvidia-vgpu/debug.h          |  5 ++
 .../vfio/pci/nvidia-vgpu/include/nvrm/ecc.h   | 45 ++++++++++++
 .../vfio/pci/nvidia-vgpu/include/nvrm/vmmu.h  | 39 +++++++++++
 drivers/vfio/pci/nvidia-vgpu/pf.h             |  8 +++
 drivers/vfio/pci/nvidia-vgpu/vgpu.c           | 70 +++++++++++++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c       | 56 ++++++++++++++-
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h       |  8 +++
 7 files changed, 229 insertions(+), 2 deletions(-)
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/ecc.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/vmmu.h

diff --git a/drivers/vfio/pci/nvidia-vgpu/debug.h b/drivers/vfio/pci/nvidia-vgpu/debug.h
index 7cf92c9060ae..db9288752384 100644
--- a/drivers/vfio/pci/nvidia-vgpu/debug.h
+++ b/drivers/vfio/pci/nvidia-vgpu/debug.h
@@ -17,4 +17,9 @@
 	pci_dbg(__v->pdev, "nvidia-vgpu %d: "f, __v->info.id, ##a); \
 })
 
+#define vgpu_error(v, f, a...) ({ \
+	typeof(v) __v = (v); \
+	pci_err(__v->pdev, "nvidia-vgpu %d: "f, __v->info.id, ##a); \
+})
+
 #endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/include/nvrm/ecc.h b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/ecc.h
new file mode 100644
index 000000000000..d2a8316a0f12
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/ecc.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Copyright © 2025 NVIDIA Corporation
+ */
+#ifndef __NVRM_ECC_H__
+#define __NVRM_ECC_H__
+
+#include <nvrm/nvtypes.h>
+
+/* Excerpt of RM headers from https://github.com/NVIDIA/open-gpu-kernel-modules/tree/570.124.04 */
+
+typedef struct NV2080_CTRL_GPU_QUERY_ECC_EXCEPTION_STATUS {
+    NV_DECLARE_ALIGNED(NvU64 count, 8);
+} NV2080_CTRL_GPU_QUERY_ECC_EXCEPTION_STATUS;
+
+typedef struct NV2080_CTRL_GPU_QUERY_ECC_UNIT_STATUS {
+    NvBool enabled;
+    NvBool scrubComplete;
+    NvBool supported;
+    NV_DECLARE_ALIGNED(NV2080_CTRL_GPU_QUERY_ECC_EXCEPTION_STATUS dbe, 8);
+    NV_DECLARE_ALIGNED(NV2080_CTRL_GPU_QUERY_ECC_EXCEPTION_STATUS dbeNonResettable, 8);
+    NV_DECLARE_ALIGNED(NV2080_CTRL_GPU_QUERY_ECC_EXCEPTION_STATUS sbe, 8);
+    NV_DECLARE_ALIGNED(NV2080_CTRL_GPU_QUERY_ECC_EXCEPTION_STATUS sbeNonResettable, 8);
+} NV2080_CTRL_GPU_QUERY_ECC_UNIT_STATUS;
+
+typedef struct NV0080_CTRL_GR_ROUTE_INFO {
+    NvU32 flags;
+    NV_DECLARE_ALIGNED(NvU64 route, 8);
+} NV0080_CTRL_GR_ROUTE_INFO;
+
+typedef NV0080_CTRL_GR_ROUTE_INFO NV2080_CTRL_GR_ROUTE_INFO;
+
+#define NV2080_CTRL_GPU_ECC_UNIT_COUNT (0x00000024U)
+
+#define NV2080_CTRL_CMD_GPU_QUERY_ECC_STATUS (0x2080012fU)
+
+typedef struct NV2080_CTRL_GPU_QUERY_ECC_STATUS_PARAMS {
+    NV_DECLARE_ALIGNED(NV2080_CTRL_GPU_QUERY_ECC_UNIT_STATUS units[NV2080_CTRL_GPU_ECC_UNIT_COUNT], 8);
+    NvBool bFatalPoisonError;
+    NvU8   uncorrectableError;
+    NvU32  flags;
+    NV_DECLARE_ALIGNED(NV2080_CTRL_GR_ROUTE_INFO grRouteInfo, 8);
+} NV2080_CTRL_GPU_QUERY_ECC_STATUS_PARAMS;
+
+#endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/include/nvrm/vmmu.h b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/vmmu.h
new file mode 100644
index 000000000000..fb1f100deac4
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/vmmu.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: MIT */
+
+/* Copyright (c) 2025, NVIDIA CORPORATION. All rights reserved. */
+
+#ifndef __NVRM_VMMU_H__
+#define __NVRM_VMMU_H__
+
+#include <nvrm/nvtypes.h>
+
+/* Excerpt of RM headers from https://github.com/NVIDIA/open-gpu-kernel-modules/tree/570.124.04 */
+
+/*
+ * NV2080_CTRL_CMD_GPU_GET_VMMU_SEGMENT_SIZE
+ *
+ * This command returns the VMMU page size
+ *
+ *   vmmuSegmentSize
+ *     Output parameter.
+ *     Returns the VMMU segment size (in bytes)
+ *
+ * Possible status values returned are:
+ *   NV_OK
+ *   NV_ERR_NOT_SUPPORTED
+ */
+#define NV2080_CTRL_CMD_GPU_GET_VMMU_SEGMENT_SIZE  (0x2080017eU) /* finn: Evaluated from "(FINN_NV20_SUBDEVICE_0_GPU_INTERFACE_ID << 8) | NV2080_CTRL_GPU_GET_VMMU_SEGMENT_SIZE_PARAMS_MESSAGE_ID" */
+
+#define NV2080_CTRL_GPU_GET_VMMU_SEGMENT_SIZE_PARAMS_MESSAGE_ID (0x7EU)
+
+typedef struct NV2080_CTRL_GPU_GET_VMMU_SEGMENT_SIZE_PARAMS {
+	NV_DECLARE_ALIGNED(NvU64 vmmuSegmentSize, 8);
+} NV2080_CTRL_GPU_GET_VMMU_SEGMENT_SIZE_PARAMS;
+
+#define NV2080_CTRL_GPU_VMMU_SEGMENT_SIZE_32MB     0x02000000U
+#define NV2080_CTRL_GPU_VMMU_SEGMENT_SIZE_64MB     0x04000000U
+#define NV2080_CTRL_GPU_VMMU_SEGMENT_SIZE_128MB    0x08000000U
+#define NV2080_CTRL_GPU_VMMU_SEGMENT_SIZE_256MB    0x10000000U
+#define NV2080_CTRL_GPU_VMMU_SEGMENT_SIZE_512MB    0x20000000U
+
+#endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/pf.h b/drivers/vfio/pci/nvidia-vgpu/pf.h
index b8008d8ee434..ce2728ce969b 100644
--- a/drivers/vfio/pci/nvidia-vgpu/pf.h
+++ b/drivers/vfio/pci/nvidia-vgpu/pf.h
@@ -95,4 +95,12 @@ static inline int nvidia_vgpu_mgr_init_handle(struct pci_dev *pdev,
 	__m->handle.ops->free_chids(__m->handle.pf_drvdata, o, s); \
 })
 
+#define nvidia_vgpu_mgr_alloc_fbmem(m, info) ({\
+	typeof(m) __m = (m); \
+	__m->handle.ops->alloc_fbmem(__m->handle.pf_drvdata, info); \
+})
+
+#define nvidia_vgpu_mgr_free_fbmem(m, h) \
+	((m)->handle.ops->free_fbmem(h))
+
 #endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu.c b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
index 52b946469043..7025c7e2b9ac 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
@@ -105,7 +105,70 @@ static int setup_chids(struct nvidia_vgpu *vgpu)
 
 	vgpu_debug(vgpu, "alloc guest channel offset %u size %u\n", chid->chid_offset,
 		   chid->num_chid);
+	return 0;
+}
+
+static void clean_fbmem_heap(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+
+	vgpu_debug(vgpu, "free guest FB memory, offset 0x%llx size 0x%llx\n",
+		   vgpu->fbmem_heap->addr, vgpu->fbmem_heap->size);
+
+	nvidia_vgpu_mgr_free_fbmem(vgpu_mgr, vgpu->fbmem_heap);
+	vgpu->fbmem_heap = NULL;
+}
+
+static int get_alloc_fbmem_size(struct nvidia_vgpu *vgpu, u64 *size)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+	struct nvidia_vgpu_info *info = &vgpu->info;
+	struct nvidia_vgpu_type *type = info->vgpu_type;
+	u64 fb_length;
+
+	if (!vgpu_mgr->ecc_enabled) {
+		*size = type->fb_length;
+		return 0;
+	}
+
+	if (!info->vgpu_type->ecc_supported) {
+		vgpu_error(vgpu, "ECC is enabled. vGPU type %s doesn't support ECC!\n",
+			   type->vgpu_type_name);
+		return -ENODEV;
+	}
 
+	/* Re-calculate the FB memory length when ECC is enabled. */
+	fb_length = ALIGN(vgpu_mgr->total_fbmem_size, vgpu_mgr->vmmu_segment_size);
+	fb_length = fb_length / type->max_instance - type->fb_reservation - type->gsp_heap_size;
+	fb_length = min(type->fb_length, fb_length);
+	fb_length = ALIGN_DOWN(fb_length, vgpu_mgr->vmmu_segment_size);
+
+	*size = fb_length;
+	return 0;
+}
+
+static int setup_fbmem_heap(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+	struct nvidia_vgpu_alloc_fbmem_info info = {0};
+	struct nvidia_vgpu_mem *mem;
+	int ret;
+
+	ret = get_alloc_fbmem_size(vgpu, &info.size);
+	if (ret)
+		return ret;
+
+	info.align = vgpu_mgr->vmmu_segment_size;
+
+	vgpu_debug(vgpu, "alloc guest FB memory, size 0x%llx\n", info.size);
+
+	mem = nvidia_vgpu_mgr_alloc_fbmem(vgpu_mgr, &info);
+	if (IS_ERR(mem))
+		return PTR_ERR(mem);
+
+	vgpu_debug(vgpu, "guest FB memory offset 0x%llx size 0x%llx\n", mem->addr, mem->size);
+
+	vgpu->fbmem_heap = mem;
 	return 0;
 }
 
@@ -120,6 +183,7 @@ int nvidia_vgpu_mgr_destroy_vgpu(struct nvidia_vgpu *vgpu)
 	if (!atomic_cmpxchg(&vgpu->status, 1, 0))
 		return -ENODEV;
 
+	clean_fbmem_heap(vgpu);
 	clean_chids(vgpu);
 	unregister_vgpu(vgpu);
 
@@ -164,12 +228,18 @@ int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu)
 	if (ret)
 		goto err_setup_chids;
 
+	ret = setup_fbmem_heap(vgpu);
+	if (ret)
+		goto err_setup_fbmem_heap;
+
 	atomic_set(&vgpu->status, 1);
 
 	vgpu_debug(vgpu, "created\n");
 
 	return 0;
 
+err_setup_fbmem_heap:
+	clean_chids(vgpu);
 err_setup_chids:
 	unregister_vgpu(vgpu);
 
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
index 8565bb881fda..e8b670308b21 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
@@ -6,6 +6,9 @@
 #include "debug.h"
 #include "vgpu_mgr.h"
 
+#include <nvrm/vmmu.h>
+#include <nvrm/ecc.h>
+
 static void clean_vgpu_mgr(struct nvidia_vgpu_mgr *vgpu_mgr)
 {
 	if (vgpu_mgr->use_chid_alloc_bitmap) {
@@ -104,6 +107,39 @@ static void attach_vgpu_mgr(struct nvidia_vgpu_mgr *vgpu_mgr,
 	handle_data->vfio.pf_detach_handle_fn = pf_detach_handle_fn;
 }
 
+static int get_vmmu_segment_size(struct nvidia_vgpu_mgr *vgpu_mgr)
+{
+	NV2080_CTRL_GPU_GET_VMMU_SEGMENT_SIZE_PARAMS *ctrl;
+
+	ctrl = nvidia_vgpu_mgr_rm_ctrl_rd(vgpu_mgr, &vgpu_mgr->gsp_client,
+					  NV2080_CTRL_CMD_GPU_GET_VMMU_SEGMENT_SIZE,
+					  sizeof(*ctrl));
+	if (IS_ERR(ctrl))
+		return PTR_ERR(ctrl);
+
+	vgpu_mgr->vmmu_segment_size = ctrl->vmmuSegmentSize;
+
+	nvidia_vgpu_mgr_rm_ctrl_done(vgpu_mgr, &vgpu_mgr->gsp_client, ctrl);
+
+	return 0;
+}
+
+static int get_ecc_status(struct nvidia_vgpu_mgr *vgpu_mgr)
+{
+	NV2080_CTRL_GPU_QUERY_ECC_STATUS_PARAMS *ctrl;
+
+	ctrl = nvidia_vgpu_mgr_rm_ctrl_rd(vgpu_mgr, &vgpu_mgr->gsp_client,
+					  NV2080_CTRL_CMD_GPU_QUERY_ECC_STATUS,
+					  sizeof(*ctrl));
+	if (IS_ERR(ctrl))
+		return PTR_ERR(ctrl);
+
+	vgpu_mgr->ecc_enabled = ctrl->units[0].enabled;
+
+	nvidia_vgpu_mgr_rm_ctrl_done(vgpu_mgr, &vgpu_mgr->gsp_client, ctrl);
+	return 0;
+}
+
 static int setup_chid_alloc_bitmap(struct nvidia_vgpu_mgr *vgpu_mgr)
 {
 	if (WARN_ON(!vgpu_mgr->use_chid_alloc_bitmap))
@@ -120,11 +156,27 @@ static int setup_chid_alloc_bitmap(struct nvidia_vgpu_mgr *vgpu_mgr)
 
 static int init_vgpu_mgr(struct nvidia_vgpu_mgr *vgpu_mgr)
 {
+	int ret;
+
+	ret = get_vmmu_segment_size(vgpu_mgr);
+	if (ret)
+		return ret;
+
+	ret = get_ecc_status(vgpu_mgr);
+	if (ret)
+		return ret;
+
+	vgpu_mgr_debug(vgpu_mgr, "[GSP RM] VMMU segment size: 0x%llx\n",
+		       vgpu_mgr->vmmu_segment_size);
+	vgpu_mgr_debug(vgpu_mgr, "[GSP RM] ECC enabled: %d\n", vgpu_mgr->ecc_enabled);
+
 	vgpu_mgr->total_avail_chids = nvidia_vgpu_mgr_get_avail_chids(vgpu_mgr);
 	vgpu_mgr->total_fbmem_size = nvidia_vgpu_mgr_get_total_fbmem_size(vgpu_mgr);
 
-	vgpu_mgr_debug(vgpu_mgr, "total avail chids %u\n", vgpu_mgr->total_avail_chids);
-	vgpu_mgr_debug(vgpu_mgr, "total fbmem size 0x%llx\n", vgpu_mgr->total_fbmem_size);
+	vgpu_mgr_debug(vgpu_mgr, "[core driver] total avail chids %u\n",
+		       vgpu_mgr->total_avail_chids);
+	vgpu_mgr_debug(vgpu_mgr, "[core driver] total fbmem size 0x%llx\n",
+		       vgpu_mgr->total_fbmem_size);
 
 	return vgpu_mgr->use_chid_alloc_bitmap ? setup_chid_alloc_bitmap(vgpu_mgr) : 0;
 }
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
index 5a7a6103a677..356779404cc2 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
@@ -59,6 +59,7 @@ struct nvidia_vgpu_chid {
  * @info: vGPU info
  * @vgpu_mgr: pointer to vGPU manager
  * @chid: vGPU channel IDs
+ * @fbmem_heap: allocated FB memory for the vGPU
  */
 struct nvidia_vgpu {
 	/* Per-vGPU lock */
@@ -71,6 +72,7 @@ struct nvidia_vgpu {
 	struct nvidia_vgpu_mgr *vgpu_mgr;
 
 	struct nvidia_vgpu_chid chid;
+	struct nvidia_vgpu_mem *fbmem_heap;
 };
 
 /**
@@ -80,6 +82,8 @@ struct nvidia_vgpu {
  * @handle: the driver handle
  * @total_avail_chids: total available channel IDs
  * @total_fbmem_size: total FB memory size
+ * @vmmu_segment_size: VMMU segment size
+ * @ecc_enabled: ECC is enabled in the GPU
  * @vgpu_major: vGPU major version
  * @vgpu_minor: vGPU minor version
  * @vgpu_list_lock: lock to protect vGPU list
@@ -99,6 +103,10 @@ struct nvidia_vgpu_mgr {
 	u32 total_avail_chids;
 	u64 total_fbmem_size;
 
+	/* GSP RM configurations */
+	u64 vmmu_segment_size;
+	bool ecc_enabled;
+
 	u64 vgpu_major;
 	u64 vgpu_minor;
 
-- 
2.34.1


