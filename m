Return-Path: <kvm+bounces-56713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AAB11B42C9D
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 00:12:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 656A93ACAAB
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 22:12:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13BFD31DDB7;
	Wed,  3 Sep 2025 22:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JXVazMrc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A922F1FC0
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 22:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756937512; cv=fail; b=nG8PpGjt/+d2VDwXHAuXVyLErs9cjfuhzDPieCG/pjOF/9CR8KgyEAJJQVx8BQAoPxzOriaB14FibQGGSFLUXoOjyeedO2878GIakoM58fbgP8nI3x3orwj40odF5o2Sx9D0vBmIEYve6yexBFf5KFBMjQUIr/9hAVr3tvhRaHo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756937512; c=relaxed/simple;
	bh=rXQbWKlN5NndRtdVvfPCBFlHDT+pcpfLx8wygY+HfPw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fqvCIRomTi7rMfS5p4FtiFNcGnXFhwE8gvfA4o2/H/IyRmHJzx33Z/SyI9aMbsNzUnymA3VQ6luKUoWalsxkzJ23bAnctvkxxyRtX8X9h5h23N/1aLwFhZzO4xB8H7ycGwgBRr5ykmLShWjjfYh2cQPrnojN5udCcM3g7VNoKuM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JXVazMrc; arc=fail smtp.client-ip=40.107.92.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BPv//O1RXWk2mGhdqLkkHzmRIWeMcXtI+63yVg269VOF3m5i+GVoLy0L2CeiywxsT+IHbsW+ag5g6I0rOUhXpc59uV8I4Rtg0A/VawhokrvD0prIuhcbwsLcKPVt1F6o25Jc/mQZBbbggR/fiM1/hPuju1BlDqOxcPib0W8eczWGNQxtmos+TVGD0IDbhi1MKtWCyTz/erYzZaUw6+eaqsohxuM3+aBpDfEguJV7lJt1Y8A7MIVra8qeF8lKY6Xri+7vuuRyU7t9Z0UPsSGazvqBu/FSyXTHRjSWmvK6dxla8/46Vp52fIKplHGtJ9mZCxXckyPTJBOabZPVEkKnQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=do36Xdj7qozzKHoc8TJttpEDhCVjns0QAT6oZzPudzA=;
 b=Fu60wse5snaLVszmq84VEhgqrBIv3fJpZL/yP87Ubo1hQ7TDHvULd1Bn7QgB98YqLChaVnfpQaR0iYahLYKw+YOdTRQfXkMto5sqHYWWu+HcHQn8B187Ve/d6aGiWFTUfNNwzlQUQwqWhx5NTJ5noj3nF7r1aFt6zfBWeJBWvjHtXelxuw1JvkfwXWWarU20ayp4ehlEJ6rb0DSaH4XKgw+HjjLHo1axVSXLtq0TeIThhcuGGwxTLukqSKD7jheiQiPwSQdEUcJazsOLLozXsngQVZnmwoloVIw8DZKKbl4VLHfRt9DLGtSjdcbkaGyMq7L3WuOAY4GEUR1HVZQAvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=do36Xdj7qozzKHoc8TJttpEDhCVjns0QAT6oZzPudzA=;
 b=JXVazMrctDRuJUaItUh20s9+3oVos+2WgTr8IolT7yJfEXb1XNnSHG6hqMCv5k2gS4U4S/5dIIwf6DSHkNo6rCpt8z8WM4kdjSJgJ23RnsQTcdnYrT/fRZBIzzjJ3H19Ov4B+T3LJvI/N3auSigMq5x46GmU3WLd93IkCmTFHzWxD3nSpowg3EBXDhrSkd7/xIDJasU4d89yh+Ve+TTNnXX1K90+PLR8Y8xxkUHrRHBq1Yq1RMnc1DSjXMPGnJjMGManMy0Fr5edqIt9YQSDZwb/3B2AgRTyM7/wSo+3P/WpimYPvvRYyMOnLEshujBJCSluPe0Uq7824YYHYV/DBw==
Received: from BL1P221CA0039.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:5b5::17)
 by MW6PR12MB8757.namprd12.prod.outlook.com (2603:10b6:303:239::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Wed, 3 Sep
 2025 22:11:33 +0000
Received: from BL02EPF00021F69.namprd02.prod.outlook.com
 (2603:10b6:208:5b5:cafe::43) by BL1P221CA0039.outlook.office365.com
 (2603:10b6:208:5b5::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.17 via Frontend Transport; Wed,
 3 Sep 2025 22:11:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF00021F69.mail.protection.outlook.com (10.167.249.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Wed, 3 Sep 2025 22:11:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:14 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:13 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 15:11:13 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <dakr@kernel.org>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC v2 01/14] vfio/nvidia-vgpu: introduce vGPU lifecycle management prelude
Date: Wed, 3 Sep 2025 15:10:58 -0700
Message-ID: <20250903221111.3866249-2-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F69:EE_|MW6PR12MB8757:EE_
X-MS-Office365-Filtering-Correlation-Id: 8170e89b-4555-476f-67ba-08ddeb36d77b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QzhBaExDZmZuSmFXVUFTcllYeUZMdFdSb2VFcTNlZS9Ib0hWbTdmRm9YdTRU?=
 =?utf-8?B?NkVCRUh6OUxLdkJNcUdPRS8wdElhTFZ3c1VXc1djSnk1cEk0SXdMQ29UdjQ0?=
 =?utf-8?B?bjZRbXdEc2pVR2doV2NRK2pqazgxaDF4TVU2bkNvSkF4RmJHZVBBSlpzYW1T?=
 =?utf-8?B?LzRYNHNUWVhYU0RlNStkeFNGU2pTVXZSN0s1NEk4LytXSFdYUlFLbTJVNjR5?=
 =?utf-8?B?RWhETWVqQ2EwODNVV0N4dHJHVUp1R3llOTFybzh5VUg1MXJqRStxRWRScTZv?=
 =?utf-8?B?dTRST3JCRGRkVUw4SXMyRUtnb3JzWTNycVJZcE5IOURYY0tBaTdlbE5adTM5?=
 =?utf-8?B?dDhaeGxJSXdaYmNiMkRqSk5SSkFLbG1qak55Qk9KbXpXdm5LMWxFMm10Z3h3?=
 =?utf-8?B?UkZhMS8vYTNEZGNvMnlnOTlqQmE2Sjl4eTl1S1h0bmpqUXpHZDdQMENXV3or?=
 =?utf-8?B?a00rTTRMamVVS1Y3N3YveE5VSDJpeC9SUElNZmYrVDBOaC9DNUFoVHJLdFAr?=
 =?utf-8?B?QXBIakQrdDBOSmMxU3luWEh2MW4zRnN1OEU5djlGZ2hiNkZTdXpzWGpZd1I5?=
 =?utf-8?B?N0RjR3czcHgrRnlkVTlnL3ZWZzhERmdUbkt3cHMwU1l6TFIvWjVzRDRsTFRp?=
 =?utf-8?B?blBnbTRGcWcwUnBLaXlRVjh3Wk1Pa2NVbjQwaTRHenkrbUlaNlhWU25Ec2F2?=
 =?utf-8?B?MFo0cmtsZGI3VytJK2NQdGZDRFNJTmtyeTZ5YlZsc1ZRemdSU1crNGZSSHkx?=
 =?utf-8?B?dmNJaFdNeGtkNVMwQnQxM2QzRHVXZGs4T3pmMmtHdVcvd3pqVHZYa0cyY3Zo?=
 =?utf-8?B?a3h4NTZoRFp1WUc5WUt2SFY5YTQyeEk5MGRjNUNOU2NYSEF5OVVLT0thenk2?=
 =?utf-8?B?b2dCR095Q3FVa3doSmw5L3o4elZWaDV3NitTSk51bDQyRi9yeCs5QUhXeVpx?=
 =?utf-8?B?VnNQUjBzeUdUVEs4dFlMd3dySlpUeUVxcXJOY09KMjB2TG1yeDl1QTFMK1Y5?=
 =?utf-8?B?aW5MMUduampTQVFLODljNVNQZ2Y1cUFmeWZqUWpiT09NREdHMmRaanF4TjRq?=
 =?utf-8?B?NHVhRFFDdDgram1wM0lSQXlHTGpDSjNReTI0MGx6bFZPcUlrMEtGMUhkZjAz?=
 =?utf-8?B?R3ViMGR5MmpQU2NaZlhXZHNwQUdEQ2RpNVVzVVZ5RjJXWlJaMG9MdVppVmh2?=
 =?utf-8?B?RjlhZWI4dmdiMnhEanlNcVdTQW4vc1VrSXZ3U3dDZlpmd1Z3S0NUM2dmaVdj?=
 =?utf-8?B?RjNBRW1lQXJuUTN6T2tYODBoS3BCVlFLL2JybU5Ybmdlc2VUWDJtdm5PbXlF?=
 =?utf-8?B?VDY0MlJyZUc5TitBY0tYM3BaSk1sbm54azBkZFlhRXY2U0NSSUQ1aWhVOVNt?=
 =?utf-8?B?SlVJTTFVc0tZb2ZSQSt6YjlGWXY3OW9KdVhQcUdXOGR2VXNOdzYrb3U1Zm9U?=
 =?utf-8?B?TjVCaEQyUDBHYmZGN0lMeEM4ajA0WGMyWDc3blJ4WjlhdFdFWlFqOFlvSGxV?=
 =?utf-8?B?NEpIbEZUcWN0d2RtSmg0Z1RrQXdEMGx4SmQ4VGxmV0RWRXdPTVpmTFdGaHZI?=
 =?utf-8?B?WjVkUXRjOTlQbXh4ajFLTXh1WEhpci9BbFlLL0Z2djBZWVloN0lYY1p1TXRX?=
 =?utf-8?B?cityMUtGcVNDRERycDh2MXZuUkFlN29PcFVTU3VwaUt2eFNuK1F1cXlvcVhk?=
 =?utf-8?B?WXIra29CUWxLY1YvcEdtRHZjTU9KM0g2eU1UakhHelBqOU81czVRNlFaOXFX?=
 =?utf-8?B?TFJXcTRqVTkzSkFBaytiTUtvK1o5VWJVQ0ZkeC9hN3ByM1h5S2JNN3pTcGhY?=
 =?utf-8?B?WmN6a2RsVmxZMEJRanZzOVFOZFBwSW41OWRQbC96V0VNWDk0RHovN002cGRZ?=
 =?utf-8?B?MTU2OC9OaTJVZUtHQVp1MERyWU1PM0xDWk1QVERYcmt2ZFgxT2pwZkxHeitT?=
 =?utf-8?B?Q1RteS84YzEvakJRaER0ck94aUpmRlBSdHhZRmFSaFpBLzFMcHluQkRPOVd3?=
 =?utf-8?B?ai95bHhJNDU1S0tQLzkxRU5pWFBJUitpWEdFUzE0UVZZNjFTSy9DNHdaSG1M?=
 =?utf-8?Q?pnIYST?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 22:11:33.0570
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8170e89b-4555-476f-67ba-08ddeb36d77b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F69.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8757

To introduce the routines when creating a vGPU one by one in the
following patches, first, introduce the prelude of the vGPU lifecycle
management as the skeleton.

Introduce the vGPU lifecycle managemement data structures and routines.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/Kconfig                |   2 +
 drivers/vfio/pci/Makefile               |   2 +
 drivers/vfio/pci/nvidia-vgpu/Kconfig    |  15 ++
 drivers/vfio/pci/nvidia-vgpu/Makefile   |   3 +
 drivers/vfio/pci/nvidia-vgpu/debug.h    |  17 +++
 drivers/vfio/pci/nvidia-vgpu/pf.h       |  65 ++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu.c     | 101 +++++++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c | 193 ++++++++++++++++++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h |  79 ++++++++++
 9 files changed, 477 insertions(+)
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/Kconfig
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/Makefile
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/debug.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/pf.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vgpu.c
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 2b0172f54665..4bb2ddb120cc 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -65,6 +65,8 @@ source "drivers/vfio/pci/virtio/Kconfig"
 
 source "drivers/vfio/pci/nvgrace-gpu/Kconfig"
 
+source "drivers/vfio/pci/nvidia-vgpu/Kconfig"
+
 source "drivers/vfio/pci/qat/Kconfig"
 
 endmenu
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index cf00c0a7e55c..0e56f2e7ea36 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -18,4 +18,6 @@ obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio/
 
 obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) += nvgrace-gpu/
 
+obj-$(CONFIG_NVIDIA_VGPU_VFIO_PCI) += nvidia-vgpu/
+
 obj-$(CONFIG_QAT_VFIO_PCI) += qat/
diff --git a/drivers/vfio/pci/nvidia-vgpu/Kconfig b/drivers/vfio/pci/nvidia-vgpu/Kconfig
new file mode 100644
index 000000000000..3a0dab70e31d
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/Kconfig
@@ -0,0 +1,15 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config NVIDIA_VGPU_VFIO_PCI
+	tristate "VFIO support for the NVIDIA vGPU"
+	select VFIO_PCI_CORE
+	help
+	  This option enables VFIO (Virtual Function I/O) support for
+	  NVIDIA virtual GPUs (vGPU). It allows the assignment of a virtual
+	  GPU instance to userspace applications via VFIO, typically used
+	  with hypervisors such as KVM and device emulators like QEMU.
+
+          The NVIDIA vGPU allows a physical GPU to be partitioned into
+	  multiple virtual GPUs, each of which can be passed to a virtual
+	  machine as a PCI device using the standard VFIO infrastructure.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/pci/nvidia-vgpu/Makefile b/drivers/vfio/pci/nvidia-vgpu/Makefile
new file mode 100644
index 000000000000..14ff08175231
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_NVIDIA_VGPU_VFIO_PCI) += nvidia_vgpu_vfio_pci.o
+nvidia_vgpu_vfio_pci-y := vgpu_mgr.o vgpu.o
diff --git a/drivers/vfio/pci/nvidia-vgpu/debug.h b/drivers/vfio/pci/nvidia-vgpu/debug.h
new file mode 100644
index 000000000000..19a2ecd8863e
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/debug.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright © 2025 NVIDIA Corporation
+ */
+
+#ifndef __NVIDIA_VGPU_DEBUG_H__
+#define __NVIDIA_VGPU_DEBUG_H__
+
+#define vgpu_mgr_debug(v, f, a...) \
+	pci_dbg((v)->handle.pf_pdev, "nvidia-vgpu-mgr: "f, ##a)
+
+#define vgpu_debug(v, f, a...) ({ \
+	typeof(v) __v = (v); \
+	pci_dbg(__v->pdev, "nvidia-vgpu %d: "f, __v->info.id, ##a); \
+})
+
+#endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/pf.h b/drivers/vfio/pci/nvidia-vgpu/pf.h
new file mode 100644
index 000000000000..e8a11dd29427
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/pf.h
@@ -0,0 +1,65 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright © 2025 NVIDIA Corporation
+ */
+#ifndef __NVIDIA_VGPU_PF_H__
+#define __NVIDIA_VGPU_PF_H__
+
+#include <linux/pci.h>
+#include <drm/nvidia_vgpu_vfio_pf_intf.h>
+
+struct nvidia_vgpu_mgr_handle {
+	void *pf_drvdata;
+	struct pci_dev *pf_pdev;
+	struct nvidia_vgpu_vfio_ops *ops;
+};
+
+static inline int nvidia_vgpu_mgr_init_handle(struct pci_dev *pdev,
+					      struct nvidia_vgpu_mgr_handle *h)
+{
+	struct pci_dev *pf_pdev;
+
+	if (!pdev->is_virtfn)
+		return -EINVAL;
+
+	pf_pdev = pdev->physfn;
+
+	h->ops = NULL;
+	h->pf_pdev = pf_pdev;
+	h->pf_drvdata = pci_get_drvdata(pf_pdev);
+
+	if (strcmp(pf_pdev->driver->name, "NovaCore")) {
+		pr_err("Cannot find an available PF driver!\n");
+		return -EINVAL;
+	}
+
+	h->ops = nova_vgpu_get_vfio_ops(h->pf_drvdata);
+	return 0;
+}
+
+#define nvidia_vgpu_mgr_support_is_enabled(h) ({ \
+	typeof(h) __h = (h); \
+	__h->ops->vgpu_is_enabled(__h->pf_drvdata); \
+})
+
+#define nvidia_vgpu_mgr_attach_handle(h, data) ({ \
+	typeof(h) __h = (h); \
+	__h->ops->attach_handle(__h->pf_drvdata, data); \
+})
+
+#define nvidia_vgpu_mgr_detach_handle(h) ({ \
+	typeof(h) __h = (h); \
+	__h->ops->detach_handle(__h->pf_drvdata); \
+})
+
+#define nvidia_vgpu_mgr_get_avail_chids(m) ({ \
+	typeof(m) __m = (m); \
+	__m->handle.ops->get_avail_chids(__m->handle.pf_drvdata); \
+})
+
+#define nvidia_vgpu_mgr_get_total_fbmem_size(m) ({ \
+	typeof(m) __m = (m); \
+	__m->handle.ops->get_total_fbmem_size(__m->handle.pf_drvdata); \
+})
+
+#endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu.c b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
new file mode 100644
index 000000000000..79e6a9f16f74
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright © 2025 NVIDIA Corporation
+ */
+
+#include "debug.h"
+#include "vgpu_mgr.h"
+
+static void unregister_vgpu(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+
+	mutex_lock(&vgpu_mgr->vgpu_list_lock);
+
+	list_del(&vgpu->vgpu_list);
+	atomic_dec(&vgpu_mgr->num_vgpus);
+
+	mutex_unlock(&vgpu_mgr->vgpu_list_lock);
+
+	vgpu_debug(vgpu, "unregistered\n");
+}
+
+static int register_vgpu(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+	struct nvidia_vgpu *p;
+
+	mutex_lock(&vgpu_mgr->vgpu_list_lock);
+
+	nvidia_vgpu_mgr_for_each_vgpu(p, vgpu_mgr) {
+		if (WARN_ON(p->info.id == vgpu->info.id)) {
+			mutex_unlock(&vgpu_mgr->vgpu_list_lock);
+			return -EBUSY;
+		}
+	}
+
+	list_add_tail(&vgpu->vgpu_list, &vgpu_mgr->vgpu_list_head);
+	atomic_inc(&vgpu_mgr->num_vgpus);
+
+	mutex_unlock(&vgpu_mgr->vgpu_list_lock);
+
+	vgpu_debug(vgpu, "registered\n");
+	return 0;
+}
+
+/**
+ * nvidia_vgpu_mgr_destroy_vgpu - destroy a vGPU instance
+ * @vgpu: the vGPU instance going to be destroyed.
+ *
+ * Returns: 0 on success, others on failure.
+ */
+int nvidia_vgpu_mgr_destroy_vgpu(struct nvidia_vgpu *vgpu)
+{
+	if (!atomic_cmpxchg(&vgpu->status, 1, 0))
+		return -ENODEV;
+
+	unregister_vgpu(vgpu);
+
+	vgpu_debug(vgpu, "destroyed\n");
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nvidia_vgpu_mgr_destroy_vgpu);
+
+/**
+ * nvidia_vgpu_mgr_create_vgpu - create a vGPU instance
+ * @vgpu: the vGPU instance going to be created.
+ *
+ * The caller must initialize vgpu->vgpu_mgr, vgpu->pdev and vgpu->info.
+ *
+ * Returns: 0 on success, others on failure.
+ */
+int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_info *info = &vgpu->info;
+	int ret;
+
+	if (WARN_ON(!info->gfid || !info->dbdf))
+		return -EINVAL;
+
+	if (WARN_ON(!vgpu->vgpu_mgr || !vgpu->pdev))
+		return -EINVAL;
+
+	mutex_init(&vgpu->lock);
+	INIT_LIST_HEAD(&vgpu->vgpu_list);
+
+	vgpu->info = *info;
+
+	vgpu_debug(vgpu, "create vgpu on vgpu_mgr %px\n", vgpu->vgpu_mgr);
+
+	ret = register_vgpu(vgpu);
+	if (ret)
+		return ret;
+
+	atomic_set(&vgpu->status, 1);
+
+	vgpu_debug(vgpu, "created\n");
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nvidia_vgpu_mgr_create_vgpu);
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
new file mode 100644
index 000000000000..3ef81b89c748
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
@@ -0,0 +1,193 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright © 2025 NVIDIA Corporation
+ */
+
+#include "debug.h"
+#include "vgpu_mgr.h"
+
+static void vgpu_mgr_release(struct kref *kref)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr =
+		container_of(kref, struct nvidia_vgpu_mgr, refcount);
+
+	vgpu_mgr_debug(vgpu_mgr, "release\n");
+
+	if (WARN_ON(atomic_read(&vgpu_mgr->num_vgpus)))
+		return;
+
+	kvfree(vgpu_mgr);
+}
+
+static void detach_vgpu_mgr(struct nvidia_vgpu_vfio_handle_data *handle_data)
+{
+	handle_data->vfio.private_data = NULL;
+}
+
+static void pf_detach_handle_fn(void *handle, struct nvidia_vgpu_vfio_handle_data *handle_data)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = handle_data->vfio.private_data;
+
+	vgpu_mgr_debug(vgpu_mgr, "put\n");
+
+	if (kref_put(&vgpu_mgr->refcount, vgpu_mgr_release))
+		detach_vgpu_mgr(handle_data);
+}
+
+/**
+ * nvidia_vgpu_mgr_release - release the vGPU manager
+ * @vgpu_mgr: the vGPU manager to release.
+ */
+void nvidia_vgpu_mgr_release(struct nvidia_vgpu_mgr *vgpu_mgr)
+{
+	if (!nvidia_vgpu_mgr_support_is_enabled(&vgpu_mgr->handle))
+		return;
+
+	nvidia_vgpu_mgr_detach_handle(&vgpu_mgr->handle);
+}
+EXPORT_SYMBOL(nvidia_vgpu_mgr_release);
+
+static struct nvidia_vgpu_mgr *alloc_vgpu_mgr(struct nvidia_vgpu_mgr_handle *handle)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr;
+
+	vgpu_mgr = kvzalloc(sizeof(*vgpu_mgr), GFP_KERNEL);
+	if (!vgpu_mgr)
+		return ERR_PTR(-ENOMEM);
+
+	vgpu_mgr->handle = *handle;
+
+	kref_init(&vgpu_mgr->refcount);
+	mutex_init(&vgpu_mgr->vgpu_list_lock);
+	INIT_LIST_HEAD(&vgpu_mgr->vgpu_list_head);
+	atomic_set(&vgpu_mgr->num_vgpus, 0);
+
+	return vgpu_mgr;
+}
+
+static const char *pf_events_string[NVIDIA_VGPU_PF_EVENT_MAX] = {
+	[NVIDIA_VGPU_PF_DRIVER_EVENT_SRIOV_CONFIGURE] = "SRIOV configure",
+	[NVIDIA_VGPU_PF_DRIVER_EVENT_DRIVER_UNBIND] = "driver unbind",
+};
+
+static int pf_event_notify_fn(void *priv, unsigned int event, void *data)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = priv;
+
+	if (WARN_ON(event >= NVIDIA_VGPU_PF_EVENT_MAX))
+		return -EINVAL;
+
+	vgpu_mgr_debug(vgpu_mgr, "handle PF event %s\n", pf_events_string[event]);
+
+	/* more to come. */
+	return 0;
+}
+
+static void attach_vgpu_mgr(struct nvidia_vgpu_mgr *vgpu_mgr,
+			    struct nvidia_vgpu_vfio_handle_data *handle_data)
+{
+	handle_data->vfio.handle = vgpu_mgr->handle.pf_drvdata;
+	handle_data->vfio.module = THIS_MODULE;
+	handle_data->vfio.private_data = vgpu_mgr;
+	handle_data->vfio.pf_event_notify_fn = pf_event_notify_fn;
+	handle_data->vfio.pf_detach_handle_fn = pf_detach_handle_fn;
+}
+
+static int init_vgpu_mgr(struct nvidia_vgpu_mgr *vgpu_mgr)
+{
+	vgpu_mgr->total_avail_chids = nvidia_vgpu_mgr_get_avail_chids(vgpu_mgr);
+	vgpu_mgr->total_fbmem_size = nvidia_vgpu_mgr_get_total_fbmem_size(vgpu_mgr);
+
+	vgpu_mgr_debug(vgpu_mgr, "total avail chids %u\n", vgpu_mgr->total_avail_chids);
+	vgpu_mgr_debug(vgpu_mgr, "total fbmem size 0x%llx\n", vgpu_mgr->total_fbmem_size);
+
+	return 0;
+}
+
+static int setup_pf_driver_caps(struct nvidia_vgpu_mgr *vgpu_mgr, unsigned long *caps)
+{
+	/* more to come */
+	return 0;
+}
+
+static int pf_attach_handle_fn(void *handle, struct nvidia_vgpu_vfio_handle_data *handle_data,
+			       struct nvidia_vgpu_vfio_attach_handle_data *attach_data)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr;
+	int ret;
+
+	/* PF driver is unbinding */
+	if (handle_data->pf.driver_is_unbound)
+		return -ENODEV;
+
+	if (handle_data->vfio.private_data) {
+		vgpu_mgr = handle_data->vfio.private_data;
+
+		ret = attach_data->init_vfio_fn(vgpu_mgr, attach_data->init_vfio_fn_data);
+		if (ret)
+			return ret;
+
+		kref_get(&vgpu_mgr->refcount);
+		vgpu_mgr_debug(vgpu_mgr, "use existing %px\n", vgpu_mgr);
+		return 0;
+	}
+
+	vgpu_mgr = alloc_vgpu_mgr(attach_data->vgpu_mgr_handle);
+	if (IS_ERR(vgpu_mgr))
+		return PTR_ERR(vgpu_mgr);
+
+	ret = setup_pf_driver_caps(vgpu_mgr, handle_data->pf.driver_caps);
+	if (ret)
+		goto fail_setup_pf_driver_caps;
+
+	ret = init_vgpu_mgr(vgpu_mgr);
+	if (ret)
+		goto fail_init_vgpu_mgr;
+
+	attach_vgpu_mgr(vgpu_mgr, handle_data);
+
+	ret = attach_data->init_vfio_fn(vgpu_mgr, attach_data->init_vfio_fn_data);
+	if (ret)
+		goto fail_init_fn;
+
+	vgpu_mgr_debug(vgpu_mgr, "created new %px\n", vgpu_mgr);
+
+	return 0;
+
+fail_init_fn:
+	detach_vgpu_mgr(handle_data);
+fail_init_vgpu_mgr:
+fail_setup_pf_driver_caps:
+	kvfree(vgpu_mgr);
+	return ret;
+}
+
+/**
+ * nvidia_vgpu_mgr_setup - setup the vGPU manager
+ * @dev: the VF pci_dev.
+ * @init_fn: the init function of VFIO interfaces
+ * @init_fn_data: the init function data of VFIO interfaces
+ * Returns: zero on success, others on failure.
+ */
+int nvidia_vgpu_mgr_setup(struct pci_dev *dev, int (*init_vfio_fn)(void *priv, void *data),
+			  void *init_vfio_fn_data)
+{
+	struct nvidia_vgpu_mgr_handle handle = {0};
+	struct nvidia_vgpu_vfio_attach_handle_data attach_handle_data;
+	int ret;
+
+	ret = nvidia_vgpu_mgr_init_handle(dev, &handle);
+	if (ret)
+		return ret;
+
+	if (!nvidia_vgpu_mgr_support_is_enabled(&handle))
+		return -ENODEV;
+
+	attach_handle_data.pf_attach_handle_fn = pf_attach_handle_fn;
+	attach_handle_data.init_vfio_fn = init_vfio_fn;
+	attach_handle_data.init_vfio_fn_data = init_vfio_fn_data;
+	attach_handle_data.vgpu_mgr_handle = &handle;
+
+	return nvidia_vgpu_mgr_attach_handle(&handle, &attach_handle_data);
+}
+EXPORT_SYMBOL(nvidia_vgpu_mgr_setup);
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
new file mode 100644
index 000000000000..9fe25b2d8ec1
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
@@ -0,0 +1,79 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright © 2025 NVIDIA Corporation
+ */
+#ifndef __NVIDIA_VGPU_MGR_H__
+#define __NVIDIA_VGPU_MGR_H__
+
+#include "pf.h"
+
+/**
+ * struct nvidia_vgpu_info - vGPU information
+ *
+ * @id: vGPU ID
+ * @gfid: VF function ID
+ * @dbdf: VF BDF
+ */
+struct nvidia_vgpu_info {
+	int id;
+	u32 gfid;
+	u32 dbdf;
+};
+
+/**
+ * struct nvidia_vgpu - per-vGPU state
+ *
+ * @lock: per-vGPU lock
+ * @pdev: PCI device
+ * @status: vGPU status
+ * @vgpu_list: list node to the vGPU list
+ * @info: vGPU info
+ * @vgpu_mgr: pointer to vGPU manager
+ */
+struct nvidia_vgpu {
+	/* Per-vGPU lock */
+	struct mutex lock;
+	struct pci_dev *pdev;
+	atomic_t status;
+	struct list_head vgpu_list;
+
+	struct nvidia_vgpu_info info;
+	struct nvidia_vgpu_mgr *vgpu_mgr;
+};
+
+/**
+ * struct nvidia_vgpu_mgr - the vGPU manager
+ *
+ * @refcount: the reference count
+ * @handle: the driver handle
+ * @total_avail_chids: total available channel IDs
+ * @total_fbmem_size: total FB memory size
+ * @vgpu_list_lock: lock to protect vGPU list
+ * @vgpu_list_head: list head of vGPU list
+ * @num_vgpus: number of vGPUs in the vGPU list
+ */
+struct nvidia_vgpu_mgr {
+	struct kref refcount;
+	struct nvidia_vgpu_mgr_handle handle;
+
+	/* core driver configurations */
+	u32 total_avail_chids;
+	u64 total_fbmem_size;
+
+	/* lock for vGPU list */
+	struct mutex vgpu_list_lock;
+	struct list_head vgpu_list_head;
+	atomic_t num_vgpus;
+};
+
+#define nvidia_vgpu_mgr_for_each_vgpu(vgpu, vgpu_mgr) \
+	list_for_each_entry((vgpu), &(vgpu_mgr)->vgpu_list_head, vgpu_list)
+
+int nvidia_vgpu_mgr_setup(struct pci_dev *dev, int (*init_vfio_fn)(void *priv, void *data),
+			  void *init_vfio_fn_data);
+void nvidia_vgpu_mgr_release(struct nvidia_vgpu_mgr *vgpu_mgr);
+
+int nvidia_vgpu_mgr_destroy_vgpu(struct nvidia_vgpu *vgpu);
+int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu);
+
+#endif
-- 
2.34.1


