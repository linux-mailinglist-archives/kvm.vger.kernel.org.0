Return-Path: <kvm+bounces-56709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BBA7B42C99
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 00:12:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89CBC3AA2E6
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 22:12:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B1822FD7C3;
	Wed,  3 Sep 2025 22:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MeIwvL53"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626082ECD39
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 22:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756937506; cv=fail; b=llkZSYKqE6FKBWIAOcjdRPMr1hW7lFvrD423GhgzCBRsIS3+pxbE1liH5mpNStZ5IuwPUv4IDGdJqFv/Jte8ka3abMvTIQCFGRR9Ks67X5ypIbiPg9SxXbXeSil2SMfhznoYiliKK2rO4Jm959XnYE5jQay4Vv0JsDz8cALA9oQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756937506; c=relaxed/simple;
	bh=KLKzK2gni+rJ9pc9MwN4h+rSiNXgky076Bda/2/WckM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WTQlNG7E8ipGjtchPoSsym2L1dDozLYfhNTINjJXYQMdw3RIbfbepzoHsHE44pYLRq9tpq1lMZDVKH7Kxd4jXtZd+FXHviRUz2iGhXqJIwYODCFCabsRPrE+o/Ht5YpMvMT7h1c7RbktyNkC/QXVB38IRMMDBXMfKJBhpyOuZZs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MeIwvL53; arc=fail smtp.client-ip=40.107.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HV3lF3zvUPSgRuwOf6ufE3JaDUKEuLKfm7/yLpCgPz+bfWvhq+mXgnwWaCFT/wRCaM9XFTmmBNNu6TE9Bn15014OaQ8nOKkin5t4k1DB8yfaAzfSg8DX+svz4p/HOiSNvBe0Y70pNapcqfeFT+OwwpvNIk1nJeC5poBlF1b3aDD3KQVt+zWrrhnWpJN1b4xlv3S6QtQzNPzhJnBbCJNQmCZkoZcYXGLPGKcg3oZ9gJ0p6b3N6DAwSWn76gHaJ4mjr814KLYR7iBice3Hhivc+dI5HDa7Uiwi3khQKf/O8hoYpyMI5a4yjL0Utraut5PIIJzmdOwyOpRkUOwaTTVPPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qRzSd9pvYYus0bDX1i1UwFWsGxJs/fssitHftfwsTx4=;
 b=GWOZxzc6RGcPcPJ0VRowHZcHR1aDY6h6B8U+xD2cZviLR1sNxPutvFvz82PC+KYL6EunQ+5u5NKnjP+rMjNiGNjKUEmjO5gsgJJ4eDLPD2Kj1KfhfiItMlxpctHuWRG0BgZZ2UPl3GjkJRPL25oBMKE9KFat9gD0Iaze1gWHUNC8dvkKK4gkea7Fg0uhB2xF9PUa4q0+myZzIyWdlqX0Occk7fcR0LFAo7Qh7M1L54oxxUVe3/2ch1YGdQt4cKcItU6Jr6Cc+wRhwpB5o47F8gcGzHk4yovRIyaRjsg+xnFn4oi1AHFk1PgsSuerPjI09wAutpeQZFp1vZUm6fWJFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRzSd9pvYYus0bDX1i1UwFWsGxJs/fssitHftfwsTx4=;
 b=MeIwvL53d0tpIymVfri7hYA9gprdPX4OlyZFgHhPKM4vhkksjoiC4RqP3nKZWa/h6EKYYburUpEFQEDgYMjRAjIwZnBCiBdbDb2LasgZC2CDXh0f4bgrP3ZvqHwon96JDH52MOlwm+FW+TPq5ZWlRrmzQFhZ2D2lMvc5/TzVfK7NRXhpTI4UIEnS6C1QMyFsBuN+XS6OMwkQMk9a45iWFpnsmEfqJscrQnW55Vh1HMcRzv9R/RG0V2GPzwpr37OA4kul7tKWO6jvDN2vk6pgKVuu9OPLuBIoqjUxOckPJuYDkBMCryFZn2EaEM8C6BS0GGfpzEdNUXy/dAsQ+JxpeA==
Received: from CH0PR08CA0012.namprd08.prod.outlook.com (2603:10b6:610:33::17)
 by MN0PR12MB5883.namprd12.prod.outlook.com (2603:10b6:208:37b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Wed, 3 Sep
 2025 22:11:37 +0000
Received: from CH3PEPF00000010.namprd04.prod.outlook.com
 (2603:10b6:610:33:cafe::96) by CH0PR08CA0012.outlook.office365.com
 (2603:10b6:610:33::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.27 via Frontend Transport; Wed,
 3 Sep 2025 22:11:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF00000010.mail.protection.outlook.com (10.167.244.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Wed, 3 Sep 2025 22:11:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:22 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:22 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 15:11:21 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <dakr@kernel.org>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC v2 14/14] vfio/nvidia-vgpu: add a kernel doc to introduce NVIDIA vGPU
Date: Wed, 3 Sep 2025 15:11:11 -0700
Message-ID: <20250903221111.3866249-15-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000010:EE_|MN0PR12MB5883:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d56f0f3-a118-4d7b-1b61-08ddeb36d9e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|30052699003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QnAvMC81cS9JMVhQbzZXMXdxR2lzbUJRcGgyeGlLTURXa2x6R21LNStjVU5J?=
 =?utf-8?B?NUg3WTZqTW42Z0RTekd4cU5ZUjBsNzFHeDMrWjNvOEhGZWgrZmw3TzJZZnAr?=
 =?utf-8?B?NWM1OUJkY2N5WlQraktYY0FwRmptUjNrcHpyRExLZE5KSzgzWERQcHh0L005?=
 =?utf-8?B?dEloczRXdUQwMDZHMTlvb3lFaW45cWdTNHQ5ZjRXTkpHWTFVQlZwL0JLbElC?=
 =?utf-8?B?SnE5K3Z5U0IxWExUSy95eVhKdkxWU1JaQlBMVEZOMExGdUhoZWRzQ21QMmFm?=
 =?utf-8?B?VnBTU1hGdnVnQnp0VWtaTVMzYWxIdHdPRy9OUGc0NFA1Wkh2WUR4UllxZklP?=
 =?utf-8?B?WDA5VmhnZUxUV2xxZ0hzOFNrSStEbEhqbVdqRDZTaS9TdmdNZ0N0OCtyVEZZ?=
 =?utf-8?B?SEtxL1JCYVplL2xNRjlEWGp3NUY5WjFFdUl2UGk5YVVlcW1HU2NIYlYrK2R6?=
 =?utf-8?B?aWxhY0VvaGJXS3l6MSs4TTZuT1Q4eVloOHdlQk1nZm04dXQ1VFJGeEU5UGt6?=
 =?utf-8?B?NnF1NlZBK1pEN09ZMWFOOVhxakFzV1VNY2FvajZINDdicXBBd2NFYVYzVUJX?=
 =?utf-8?B?RlFOc1dVWWNqdnVucDByYmtYZTVWR0pJNDkwd0VIdTNnSjk3ZVQ4UStMSTNR?=
 =?utf-8?B?bmYrWnpoT0I1ZkZlb3VTVCtIOG9XUTkwZVRrNzNNVjluWWVQMWpRc1RienVM?=
 =?utf-8?B?emViVENCUGxPUlRJL28wQTNvWktITHF4MHI2VUVTOW5nVWZ5WGh0b3REL0xh?=
 =?utf-8?B?MGdqTTNiUitzd3RDL1FRQ1dDUUwrWjE1bHNlK1ZJaTQybDZnOSsrekpadXdp?=
 =?utf-8?B?T2NtQnE3VEVieGRnV0JXR1JrUThVRDBlUUlSbnN4MDkva2tjL0V1cXBtMndv?=
 =?utf-8?B?NmM3MG9BbmtYL2dNb1ZyMnFacHdHSVloNk9KQlc1WDE4bTFiUnZsZ3p1dnlp?=
 =?utf-8?B?Y1ZMWGlkTTBxb253NGZPanl5cWtHTE1oWm9kWFF0eU1lbFFPMDhWa1FoU001?=
 =?utf-8?B?NHhDc3lnbmErNDRHa1VaMHpKUWFvb1JHVURJeHpBYklkeUVsV2F6UTFuYzVt?=
 =?utf-8?B?N3Z0Z0dvb0hQNS8xWkltNFdTMGJxS0ZQekVOSmZwbzNya3lDRXArUDB6NHkw?=
 =?utf-8?B?eWtzeGVsa3hZRkVJN2V4dmFlODV4eUdwR2F4K1NPV0QwTmFqcENPVHVkeUYw?=
 =?utf-8?B?MUFmdGVLb1ZZOW5BUm9wMXJqemdEbndOK1dYRituSjJzVUNpTzdYWllieW1n?=
 =?utf-8?B?QVN6Tk56aDAxdmRmTm1DTnNJVFpHZXd4WVlTNlNMTUhLTHVBTllZNDlaZzlR?=
 =?utf-8?B?ZkZOWEVuSmxnTGwxMkNuNlIvbWc0d0YycmNHVzdBUHNqb0tNN3ZoNUp3WGlt?=
 =?utf-8?B?a3FXZ1UrLzBGaGVSM0YrVUVkSXF3TDhObW42MDVqODdlOHl5dVFtc2loUzIw?=
 =?utf-8?B?WDlDUFFNcW9PLy9kalBIMHUrNHRaT0xGbWJyY1lGbnMvQjUrc2RUK0xsUlN4?=
 =?utf-8?B?cU5qR3RiemZKb0I4VXBPL0ErYkRhQWw2UUgxQ0FwSWJNT3Zoa0VQV1V5RFVx?=
 =?utf-8?B?dVhEcUdHN0FIRGExV1Z4TzZ0ME1DVlJVT0lJYzUzbkErWE1vcURvWFZqbVNR?=
 =?utf-8?B?d0I3TnVPZUM4bEk4QkRiSFVnS1VvYWRQMkF4UlpFNW5OaGhFazRpcjZSbWI2?=
 =?utf-8?B?eVBYcVJqTHh1bjhweWhTdTVWU3JMaHlkdytSZDQzY3lmNnBrTlVXZm9RdSt0?=
 =?utf-8?B?YU9Db3BKNFB1RVlMeVdJVUpZWDdHMTZxM0U5WjE0eDMrb1A4ZWdGU3ZFZUx3?=
 =?utf-8?B?Ylo0OVVCT3ZOa0tyRithL0JSQVVCNTlQQWlCR2VOUjJPQ0hOVC83Y0FYTVBI?=
 =?utf-8?B?UjVSQkhJdktNb05rTG9OS3kyUURTTVYxc2pQSWd4VkU4YU4xaEVENG5mN25V?=
 =?utf-8?B?YnRsM3VaS3R3c3BFSE94MzFPdE5UOWdMd3dHTXRUWlgzNnZmbmM0Vm5KMkUz?=
 =?utf-8?B?clFRbDl0YXVRY1B3VWZweGVzdUJUb2ZVS0JWTStjb0RkNWN2Z3FaOWc1VmlM?=
 =?utf-8?B?TlNNUmg5SFUvOTY0TVBOQ29UMkE0NnhoOG9VQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(30052699003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 22:11:37.1266
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d56f0f3-a118-4d7b-1b61-08ddeb36d9e5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000010.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5883

In order to introduce NVIDIA vGPU and the requirements to a core driver,
a kernel doc is introduced to explain the architecture and the
requirements.

Add a kernel doc to introduce NVIDIA vGPU.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 Documentation/gpu/drivers.rst     |   1 +
 Documentation/gpu/nvidia-vgpu.rst | 264 ++++++++++++++++++++++++++++++
 2 files changed, 265 insertions(+)
 create mode 100644 Documentation/gpu/nvidia-vgpu.rst

diff --git a/Documentation/gpu/drivers.rst b/Documentation/gpu/drivers.rst
index 78b80be17f21..abdca636d3ef 100644
--- a/Documentation/gpu/drivers.rst
+++ b/Documentation/gpu/drivers.rst
@@ -11,6 +11,7 @@ GPU Driver Documentation
    mcde
    meson
    nouveau
+   nvidia-vgpu
    pl111
    tegra
    tve200
diff --git a/Documentation/gpu/nvidia-vgpu.rst b/Documentation/gpu/nvidia-vgpu.rst
new file mode 100644
index 000000000000..fb48572c7af2
--- /dev/null
+++ b/Documentation/gpu/nvidia-vgpu.rst
@@ -0,0 +1,264 @@
+.. SPDX-License-Identifier: GPL-2.0-only
+.. include:: <isonum.txt>
+
+=======================
+NVIDIA vGPU VFIO Driver
+=======================
+
+:Copyright: |copy| 2025, NVIDIA CORPORATION. All rights reserved.
+:Author: Zhi Wang <zhiw@nvidia.com>
+
+
+
+Overview
+========
+
+NVIDIA vGPU[1] software enables powerful GPU performance for workloads
+ranging from graphics-rich virtual workstations to data science and AI,
+enabling IT to leverage the management and security benefits of
+virtualization as well as the performance of NVIDIA GPUs required for
+modern workloads. Installed on a physical GPU in a cloud or enterprise
+data center server, NVIDIA vGPU software creates virtual GPUs that can
+be shared across multiple virtual machines.
+
+The vGPU architecture[2] can be illustrated as follow::
+
+         +--------------------+    +--------------------+ +--------------------+ +--------------------+
+         | Hypervisor         |    | Guest VM           | | Guest VM           | | Guest VM           |
+         |                    |    | +----------------+ | | +----------------+ | | +----------------+ |
+         | +----------------+ |    | |Applications... | | | |Applications... | | | |Applications... | |
+         | |  NVIDIA        | |    | +----------------+ | | +----------------+ | | +----------------+ |
+         | |  Virtual GPU   | |    | +----------------+ | | +----------------+ | | +----------------+ |
+         | |  Manager       | |    | |  Guest Driver  | | | |  Guest Driver  | | | |  Guest Driver  | |
+         | +------^---------+ |    | +----------------+ | | +----------------+ | | +----------------+ |
+         |        |           |    +---------^----------+ +----------^---------+ +----------^---------+
+         |        |           |              |                       |                      |
+         |        |           +--------------+-----------------------+----------------------+---------+
+         |        |                          |                       |                      |         |
+         |        |                          |                       |                      |         |
+         +--------+--------------------------+-----------------------+----------------------+---------+
+        +---------v--------------------------+-----------------------+----------------------+----------+
+        | NVIDIA                  +----------v---------+ +-----------v--------+ +-----------v--------+ |
+        | Physical GPU            |   Virtual GPU      | |   Virtual GPU      | |   Virtual GPU      | |
+        |                         +--------------------+ +--------------------+ +--------------------+ |
+        +----------------------------------------------------------------------------------------------+
+
+Each NVIDIA vGPU is analogous to a conventional GPU, having a fixed amount
+of GPU framebuffer, and one or more virtual display outputs or "heads".
+The vGPU’s framebuffer is allocated out of the physical GPU’s framebuffer
+at the time the vGPU is created, and the vGPU retains exclusive use of
+that framebuffer until it is destroyed.
+
+The number of physical GPUs that a board has depends on the board. Each
+physical GPU can support several different types of virtual GPU (vGPU).
+vGPU types have a fixed amount of frame buffer, number of supported
+display heads, and maximum resolutions. They are grouped into different
+series according to the different classes of workload for which they are
+optimized. Each series is identified by the last letter of the vGPU type
+name.
+
+NVIDIA vGPU supports Windows and Linux guest VM operating systems. The
+supported vGPU types depend on the guest VM OS.
+
+Architecture
+============
+::
+
+                                    +--------------------+ +--------------------+ +--------------------+
+                                    | Linux VM           | | Windows VM         | | Guest VM           |
+                                    | +----------------+ | | +----------------+ | | +----------------+ |
+                                    | |Applications... | | | |Applications... | | | |Applications... | |
+                                    | +----------------+ | | +----------------+ | | +----------------+ | ...
+                                    | +----------------+ | | +----------------+ | | +----------------+ |
+                                    | |  Guest Driver  | | | |  Guest Driver  | | | |  Guest Driver  | |
+                                    | +----------------+ | | +----------------+ | | +----------------+ |
+                                    +---------^----------+ +----------^---------+ +----------^---------+
+                                              |                       |                      |
+                                   +--------------------------------------------------------------------+
+                                   |+--------------------+ +--------------------+ +--------------------+|
+                                   ||       QEMU         | |       QEMU         | |       QEMU         ||
+                                   ||                    | |                    | |                    ||
+                                   |+--------------------+ +--------------------+ +--------------------+|
+                                   +--------------------------------------------------------------------+
+                                              |                       |                      |
+        +-----------------------------------------------------------------------------------------------+
+        |                           +----------------------------------------------------------------+  |
+        |                           |                                VFIO                            |  |
+        |                           |                                                                |  |
+        | +-----------------------+ | +-------------------------------------------------------------+|  |
+        | |                       | | |                                                             ||  |
+        | |     nova_core        <--->|                                                             ||  |
+        | +    (core driver)      | | |                  NVIDIA vGPU VFIO Driver                    ||  |
+        | |                       | | |                                                             ||  |
+        | |                       | | +-------------------------------------------------------------+|  |
+        | +--------^--------------+ +----------------------------------------------------------------+  |
+        |          |                          |                       |                      |          |
+        +-----------------------------------------------------------------------------------------------+
+                   |                          |                       |                      |
+        +----------|--------------------------|-----------------------|----------------------|----------+
+        |          v               +----------v---------+ +-----------v--------+ +-----------v--------+ |
+        |  NVIDIA                  |       PCI VF       | |       PCI VF       | |       PCI VF       | |
+        |  Physical GPU            |                    | |                    | |                    | |
+        |                          |   (Virtual GPU)    | |   (Virtual GPU)    | |    (Virtual GPU)   | |
+        |                          +--------------------+ +--------------------+ +--------------------+ |
+        +-----------------------------------------------------------------------------------------------+
+
+Each virtual GPU (vGPU) instance is implemented atop a PCIe Virtual
+Function (VF). The NVIDIA vGPU VFIO driver, in coordination with the
+VFIO framework, operates directly on these VFs to enable key
+functionalities including vGPU type selection, dynamic instantiation and
+destruction of vGPU instances, support for live migration, and warm
+update...
+
+At the low level, the NVIDIA vGPU VFIO driver interfaces with a core
+driver aka nova_core, which provides the necessary abstractions and
+mechanisms to access and manipulate the underlying GPU hardware resources.
+
+Core Driver
+===========
+
+The primary deployment model for cloud service providers (CSPs) and
+enterprise environments is to have a standalone, minimal driver stack
+with the vGPU support and other essential components. Thus, a minimal
+core driver is required to support the NVIDIA vGPU VFIO driver.
+
+Requirements To A Core Driver
+=============================
+
+The NVIDIA vGPU VFIO driver searches the supported core drivers by driver
+names when loading. Once a supported core driver is found, the VFIO driver
+generates a core driver handle for the following interactions with the core
+driver.
+
+With the handle, the VFIO driver first check if the vGPU support is
+enabled in the core driver.
+
+The core driver returns vGPU is supported on this PF if:
+
+- The device advertise SRIOV caps.
+- The device is in the supported device list in the core driver.
+- The GSP microcode loaded by the core driver supports vGPU. Some core
+  drivers, e.g. NVKM, can support multiple version of GSP microcode.
+- The required initialization for vGPU support succeeds.
+
+The core driver handle data is per-PF and shared among VFs. It contains the
+two parts: the core driver part and the VFIO driver part. The core driver
+part contains core driver status, capabilities for the VFIO driver to
+validate. The VFIO driver part contains the data registered to the core
+driver. E.g. event handlers, private data.
+
+If the VFIO driver hasn't been attached with the core driver, the VFIO
+driver attaches the handle data with the core driver. The core driver
+functions are available to the VFIO driver after the attachment.
+
+The core driver is responsible for the locking to protect the handle
+data in attachment/detachment as it can be accessed in multiple paths
+of VFIO driver probing/remove.
+
+Beside the core driver attachment and handle management, the core driver
+is required to provide the following functions to support the VFIO driver:
+
+Enumeration:
+
+- The total FB memory size of the current GPU.
+- The available channel amount.
+- The complete engine bitmap.
+
+GSP RPC manipulation:
+
+- Allocate/de-allocate a GSP client.
+- Get the handle of a GSP client.
+- Allocate/de-allocate RM control.
+- Issue RM controls.
+
+Channel ID Management:
+
+The NVIDIA vGPU VFIO driver expects the core driver manages a reserved
+channel pool that is only meant for vGPU. Other coponents in the core
+driver should have the knowledge about the channel ID from the reserved
+pool is for vGPUs. E.g. reporting channel fault and events to the VFIO
+driver. It requires the following functions:
+
+- Allocate channel IDs from the reserved pool.
+- Free the channel IDs.
+
+FB Memory Management:
+
+- Allocate the FB memory by an allocation info.
+  The allocation info contains the requirements from the VFIO driver
+  besides size. E.g. fixed offset allocation, alignment requirements.
+- Free the FB memory.
+
+FB Memory Mapping:
+
+- Map the FB memory to BAR1 and a channel VMM by a mapping info
+  The mapping info contains the requirements from the VFIO driver. E.g.
+  start offset to map the allocated FB memory, map size, huge page,
+  special memory kind.
+- Unmap the FB memory.
+
+CE Workload Submission:
+
+- CE channel allocation/deallocation.
+- Pushbuf manipulation.
+
+Event forwarding:
+- Nonstall event.
+- SRIOV configuration event.
+- Core driver unbinding event.
+
+vGPU types
+==========
+
+Each type of vGPU is designed to meet specific requirements, from
+supporting multiple users with demanding graphics applications to
+powering AI workloads in virtualized environments.
+
+To create a vGPU associated with a vGPU type, the vGPU type blobs are
+required to be uploaded to GSP firmware. A vGPU metadata file is
+introduced to host the vGPU type blobs and will be loaded by the VFIO
+driver from the userspace when loading.
+
+The vGPU metafile can be found at::
+
+        https://github.com/zhiwang-nvidia/vgpu-tools/tree/metadata
+
+
+Create vGPUs
+============
+
+The VFs can be enabled via (for example 2 VFs)::
+
+        echo 2 > /sys/bus/pci/devices/0000\:c1\:00.0/sriov_numvfs
+
+After the VFIO driver is loaded. A sysfs interface is exposed to select
+the vGPU types::
+
+        cat /sys/devices/pci0000:3a/0000:3a:00.0/0000:3b:00.0/0000:3c:10.0/0000:3e:00.5/nvidia/creatable_vgpu_types
+        ID    : vGPU Name
+        941   : NVIDIA RTX6000-Ada-1Q
+        942   : NVIDIA RTX6000-Ada-2Q
+        943   : NVIDIA RTX6000-Ada-3Q
+        944   : NVIDIA RTX6000-Ada-4Q
+        945   : NVIDIA RTX6000-Ada-6Q
+        946   : NVIDIA RTX6000-Ada-8Q
+        947   : NVIDIA RTX6000-Ada-12Q
+        948   : NVIDIA RTX6000-Ada-16Q
+        949   : NVIDIA RTX6000-Ada-24Q
+        950   : NVIDIA RTX6000-Ada-48Q
+
+A valid vGPU type must be chosen for the VF before using the VFIO device::
+
+        $ echo 941 > /sys/bus/pci/devices/0000\:c1\:00.4/nvidia/current_vgpu_type
+
+To de-select the vGPU type::
+
+        $ echo 0 > /sys/bus/pci/devices/0000\:c1\:00.4/nvidia/current_vgpu_type
+
+Once the vGPU is select, the VFIO device is ready to be used by QEMU. The
+VFIO device must be closed before the user can de-select the vGPU type.
+
+References
+==========
+
+1. See Documentation/driver-api/vfio.rst for more information on VFIO.
-- 
2.34.1


