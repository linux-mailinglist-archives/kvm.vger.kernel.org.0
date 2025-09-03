Return-Path: <kvm+bounces-56712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCB8EB42C9C
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 00:12:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9366C564DDE
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 22:12:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E40130DEB4;
	Wed,  3 Sep 2025 22:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uhG5KVoZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A422F0693
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 22:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756937511; cv=fail; b=PrTW5fEAJJLi0U9FL0OCvOfnURR97bWjteG/+QYv2vCr9hLAt35GPwsJPNFJ8zMPUL4a7qTqRqrYUrMhmvD8pGmPjuUAkbEVwqL6OHZCCf0gQlZKAAz8AWarsuqW/ent3IJm0zln8HX26oyogklTajDVKKUre7qZ3ETy5BuO8Nw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756937511; c=relaxed/simple;
	bh=DcByKXPGBeOQS5bo7qXzTWAtiCWFLNK0PD2be+HFtpY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZSjbexoHUazFSOZTaoTBFigwhfjEUSZvMtpAVylhpQhnpYU87LOptwSGlcuaizTRG4gqnsdlbea2C3MnXIbd4ctLs/o/y2VsBRMeClTA3fazt2FFxyPo3al5LkbiK6Bk0XfEpXptLmaWHDxz6wUxm1yqS7oPZINIoePHLXiCJr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uhG5KVoZ; arc=fail smtp.client-ip=40.107.94.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rOGntsKooRkHc5luWK7SjVgYIMK1FKACqQpFSDf5XBmkTdRzra2bgvlxkXPYvKhPhJtDeyPpWTe73fj8v61hWomuZADsCmqWZeblJj7oYYfHj9z5EEcsb0z1IX8phaI/kzB0pMp4bDBJOx4sDsqPd2jsvxmvVtxVCvI2HMWEZlj00eUgYWcNosCjLPnAwyB9I9VGbGEFxrGpSt3WkPw+ewIxFNwbEufPivorQFsfYKrjw/w7Ke/AjfV71JgZeO/C+gIz0AfHitaRmSjr7m7uR6fCinosBMHNMHMU4xyhxmXvYWkSgexNEb4XpydNoTdjDksXbqX3iUAHyKmJFddmKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dDn+dz8PgmVLuEas/JRw/GkOaqgLDGuVHrFHy63JSyw=;
 b=ln8iJZ+OYPFSK7/Azcyrbfx5eHRgpz8TyvyIFSSKOSgEvmEj7vtBAIw0OhhBmyP4rPQD5/lcHCfKQ+VU7gnf/++z3726BHB+70LAF43hUtpDXsGy6LWj58Ldidkp5ZcuxSi8DKShvHbXafJSrJZdYC+7ArYSbHyQOLLbUgx2AXJ/yVQP8UdUtjWqVdlUk97bxSA3kii2TKoFlYX9glK3actddX1XukxWXrcHT/KXZLR3maZZ9XXR9MPKzc1YiyXJocg1DcFbQQlE3/F0kpV7M/xqBCUTySc/B7JLs5JVpEtFcyc/hENNBKSm95DwbfagYt6zfK99q14eNeZLl5a/TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDn+dz8PgmVLuEas/JRw/GkOaqgLDGuVHrFHy63JSyw=;
 b=uhG5KVoZP//+MKlJyYfU6Fm6b9Re6FZcJteLRSpC8TkdIsj16p5ywTGVxPySxDwxMdnKoDCgMN42/2jXlpTod5np48dWb3rmLDDtDVgFbQgk1hGwRJ1F+rvGNAyaV6HaNMKQ6eEWKw+PYe51F0hhsnibX/Z3GOdCFvN8ZRiWJ3BCXzlqLQTSGymqvTBVNEgWe2bwmKu7YZ8wFA57ylQYBGJU2oLqIx1MZO5pjwDXEVvFzT0QLoYq9p5IV4bInjMJ2iQSSWWu6VDkgiBSaJMggftaxEmp8SSjYNBe24xwh/O/TvKb7CTJXyv/HzP5Ic1pAoy/b75mxADkj//6SCotWw==
Received: from CH2PR02CA0023.namprd02.prod.outlook.com (2603:10b6:610:4e::33)
 by DM4PR12MB6446.namprd12.prod.outlook.com (2603:10b6:8:be::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.16; Wed, 3 Sep 2025 22:11:30 +0000
Received: from CH3PEPF0000000C.namprd04.prod.outlook.com
 (2603:10b6:610:4e:cafe::be) by CH2PR02CA0023.outlook.office365.com
 (2603:10b6:610:4e::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.16 via Frontend Transport; Wed,
 3 Sep 2025 22:11:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF0000000C.mail.protection.outlook.com (10.167.244.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Wed, 3 Sep 2025 22:11:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:15 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:14 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 15:11:14 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <dakr@kernel.org>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC v2 03/14] vfio/nvidia-vgpu: introduce vGPU type uploading
Date: Wed, 3 Sep 2025 15:11:00 -0700
Message-ID: <20250903221111.3866249-4-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000C:EE_|DM4PR12MB6446:EE_
X-MS-Office365-Filtering-Correlation-Id: 78936c95-46e0-4892-bb85-08ddeb36d5f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M3VlZHBCc2pGdEIzR3Y2Ujh5OS9pVndJcGFoa2w5Uk9mc1lWQWFQTnJJZXM2?=
 =?utf-8?B?SUNDekdpUU01bUd5SFIyVlBsbURnQktmaGdPT1lOazFXQ3ZEcGdDZTZsZXJ6?=
 =?utf-8?B?anBwWkVHKzI0bk1GTkthSWJrMlNoVDRnNC9BNlNQS1ZCL3VLVzlNNHVsWVBW?=
 =?utf-8?B?bXFSMnRRTnJlVko1TDErSU1CSzlpaGV4QVd5N3U0SElTWWdJdUtaZXpxUzFq?=
 =?utf-8?B?RDJmUEdubU5BN2h1L2s4SndUb0QzR3o4YUQxNTZLQW1kMG45ZG02dUhwTmFC?=
 =?utf-8?B?SER1YjdpT2cvTFlFUXRPK0E1YkxuU1h0b2o2eXFieTFISno0bmlzY1FSci9o?=
 =?utf-8?B?aURyajVWTGU1eEZCMDNzZmVXWkdBTGh0NURvNVRIOWRpQktqRzF3SmFPNTRW?=
 =?utf-8?B?K2pSYU9TeEZld0hHNU5EOCt1R1hlN2ZVK1Q0dWdiV0dtQnB4ODhaOCtPa1Nl?=
 =?utf-8?B?dTVmdVJER05KUm92MnV6dS9RSjd3YXpyNW5idk80bkdCSzVKdE9pS3lrVzFX?=
 =?utf-8?B?bFRkNnI0OGR6QjhDUGN2RnU1bnQzeFMwZm5rcGtmMEdIRStuLzNVd2lVTjA4?=
 =?utf-8?B?aTlseDQrM09iTHlSbHNCKzIrbDNIemV5WGg4ZC9HaEZ6S2ZUSGk3ZVgzK1Bl?=
 =?utf-8?B?NG9pTTNTZ0xiTGVtdzdCekNXWHphdk12ZDNKNEFjR2tjL2U4MFZLWG5uL2JD?=
 =?utf-8?B?dXBnMVpUbytDeUI2U3A3YzVGNkp1WTBPOW1CMlFyak1KQy95eWdKQUFXTGZ3?=
 =?utf-8?B?UElMeXA3ZVNCSmNyL1orajI3aW83VVRvWmlpeVRkeEdiYTQrY05RZjdOTmZC?=
 =?utf-8?B?MVI4eklCQ2tCK25BZTBtbExyamdXS3ErV29wYW5XaTlVRGlFbVhwdWJMVmdH?=
 =?utf-8?B?d0dEWTBEUlRFdm5DRzFBYXpxQmp0NGFwVWZvZUV4MnVlY0llaXFIYVBMc3pL?=
 =?utf-8?B?Wk5RL0xNK25tK3hhTGFkKzZibERxZGh0YjhNbG5zZzJWV3d1NHBjYi84bUVM?=
 =?utf-8?B?Y1Z5Mlk1K2QwL0dQUzhNMllLMEc1S1ZHdlNXSkJkSWFmWW5jMGtvYVp4RU9y?=
 =?utf-8?B?STRqdG8rMEt2WFhyTVZ0Wml3am1abkg1MFpVK1UxU0tLaDlJVVZTZ2R2SXo5?=
 =?utf-8?B?dkVFNlZPTG9yUnh4Q1RFdEZnL2pWV3piSFhCQjEzSTRDb0JBMGRUUkxIOGNX?=
 =?utf-8?B?UG5MWkxlV290Z1o1NTVWQml3Q3h6T2NFQVZoa0hGMGpGYUFHQXpyMzRlV2FT?=
 =?utf-8?B?TkRTeEdENGU2Tzc3cTdDem1qTnVqSDM4ZVhLWnZQUEJrMENOeWpwQS9xLzB4?=
 =?utf-8?B?OUxTRUZUKzFrL0kxVG9qV0NMRlVzOVJ1anQxQ3F4ODI2NE1FTVJ2SEpXSC9H?=
 =?utf-8?B?YWMxNXNZcG8ra1lKSkRNYlN0Ly8vZm9jaGJvbGdsanhxOVhjR2RQd3MrVWdm?=
 =?utf-8?B?dVBrbzJNSmI3SkV3ZkYwcUNCZzdWUm80dXE3K2hhOWdXSVZ6L29XK3ZHUENR?=
 =?utf-8?B?WXVxTWVXb2IzOW9BaU1HZGd4a1pYVHNFZ3BIeU5pYkNvUkNoK1I4UnU3U1V0?=
 =?utf-8?B?TW83bjhzRXJQNldRMW4zL1pGbXhKaUZrT1JXVzlWN1A3bm9aMnFKTlY5a1dH?=
 =?utf-8?B?TlU4cjdvQ2dRb3FNSlptMmRTMjd5Q3VPcEg4NGxsOWNrWnQ2K2p5bWRtTEht?=
 =?utf-8?B?VkNuVlBTVEVXaXovY1UwdkxhZXVwanpuNHhPcG10SnJ5SFFVdnpYWGh3M1dP?=
 =?utf-8?B?Y1BlQzJjU2ZNMEV5UE1HWkpWenZMOTlHUTB0cVcvME5kVDBzMUdRVXpCb2pI?=
 =?utf-8?B?R1VGQ1ViV1czTUhuMzNWYWgzZ2pocjhuVnR5SEVSeWFqY1NLNE1MM0FxMGlu?=
 =?utf-8?B?cWJpT3pYOVdhWFJjeDZEVjJRVm9ET1RLUjg5aU9veVNKdi95SkhMVW5WT0Fi?=
 =?utf-8?B?ODNpenNvY2pmSTh2MDlHS1JuS2ZEZzN3NWl6ZU5wVFZ2NklmbUprOFZNQUo5?=
 =?utf-8?B?VTExOHdUa2R3aUE4Y0lDNWQ4M2UwbVIzLzRKN210ZGlJS01KbmdsVUx6cmlH?=
 =?utf-8?B?MG9mUEd4cDl5aTEzRTQzc3NNNVZxOVFicDJ0Zz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 22:11:30.5351
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 78936c95-46e0-4892-bb85-08ddeb36d5f6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6446

Each type of vGPU is designed to meet specific requirements, from
supporting multiple users with demanding graphics applications to
powering AI workloads in virtualized environments.

To create a vGPU associated with a vGPU type, the vGPU type specs are
required to be uploaded to GSP firmware.

Intorduce vGPU metadata uploading framework to check and upload vGPU
types from the vGPU metadata file when vGPU is enabled.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/nvidia-vgpu/Makefile         |   4 +-
 drivers/vfio/pci/nvidia-vgpu/debug.h          |   3 +
 .../vfio/pci/nvidia-vgpu/include/nvrm/gsp.h   |  18 +
 .../pci/nvidia-vgpu/include/nvrm/nvtypes.h    |  26 ++
 drivers/vfio/pci/nvidia-vgpu/metadata.c       | 319 ++++++++++++++++++
 drivers/vfio/pci/nvidia-vgpu/metadata.h       |  89 +++++
 .../vfio/pci/nvidia-vgpu/metadata_vgpu_type.c | 153 +++++++++
 drivers/vfio/pci/nvidia-vgpu/pf.h             |  12 +
 drivers/vfio/pci/nvidia-vgpu/vgpu.c           |   5 +-
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c       |   7 +
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h       |  27 ++
 11 files changed, 660 insertions(+), 3 deletions(-)
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/gsp.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/nvtypes.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/metadata.c
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/metadata.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/metadata_vgpu_type.c

diff --git a/drivers/vfio/pci/nvidia-vgpu/Makefile b/drivers/vfio/pci/nvidia-vgpu/Makefile
index 14ff08175231..94ba4ed4e131 100644
--- a/drivers/vfio/pci/nvidia-vgpu/Makefile
+++ b/drivers/vfio/pci/nvidia-vgpu/Makefile
@@ -1,3 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
+subdir-ccflags-y += -I$(src)/include
+
 obj-$(CONFIG_NVIDIA_VGPU_VFIO_PCI) += nvidia_vgpu_vfio_pci.o
-nvidia_vgpu_vfio_pci-y := vgpu_mgr.o vgpu.o
+nvidia_vgpu_vfio_pci-y := vgpu_mgr.o vgpu.o metadata.o metadata_vgpu_type.o
diff --git a/drivers/vfio/pci/nvidia-vgpu/debug.h b/drivers/vfio/pci/nvidia-vgpu/debug.h
index 19a2ecd8863e..7cf92c9060ae 100644
--- a/drivers/vfio/pci/nvidia-vgpu/debug.h
+++ b/drivers/vfio/pci/nvidia-vgpu/debug.h
@@ -9,6 +9,9 @@
 #define vgpu_mgr_debug(v, f, a...) \
 	pci_dbg((v)->handle.pf_pdev, "nvidia-vgpu-mgr: "f, ##a)
 
+#define vgpu_mgr_error(v, f, a...) \
+	pci_err((v)->handle.pf_pdev, "nvidia-vgpu-mgr: "f, ##a)
+
 #define vgpu_debug(v, f, a...) ({ \
 	typeof(v) __v = (v); \
 	pci_dbg(__v->pdev, "nvidia-vgpu %d: "f, __v->info.id, ##a); \
diff --git a/drivers/vfio/pci/nvidia-vgpu/include/nvrm/gsp.h b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/gsp.h
new file mode 100644
index 000000000000..c3fb7b299533
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/gsp.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: MIT */
+#ifndef __NVRM_GSP_H__
+#define __NVRM_GSP_H__
+
+#include <nvrm/nvtypes.h>
+
+/* Excerpt of RM headers from https://github.com/NVIDIA/open-gpu-kernel-modules/tree/570 */
+
+#define NV2080_CTRL_CMD_GSP_GET_FEATURES (0x20803601)
+
+typedef struct NV2080_CTRL_GSP_GET_FEATURES_PARAMS {
+	NvU32  gspFeatures;
+	NvBool bValid;
+	NvBool bDefaultGspRmGpu;
+	NvU8   firmwareVersion[GSP_MAX_BUILD_VERSION_LENGTH];
+} NV2080_CTRL_GSP_GET_FEATURES_PARAMS;
+
+#endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/include/nvrm/nvtypes.h b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/nvtypes.h
new file mode 100644
index 000000000000..5445ba15500f
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/nvtypes.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: MIT */
+#ifndef __NVRM_NVTYPES_H__
+#define __NVRM_NVTYPES_H__
+
+#define NV_ALIGN_BYTES(a) __attribute__ ((__aligned__(a)))
+#define NV_DECLARE_ALIGNED(f, a) f __attribute__ ((__aligned__(a)))
+
+typedef u32 NvV32;
+
+typedef u8 NvU8;
+typedef u16 NvU16;
+typedef u32 NvU32;
+typedef u64 NvU64;
+
+typedef void* NvP64;
+
+typedef NvU8 NvBool;
+typedef NvU32 NvHandle;
+typedef NvU64 NvLength;
+
+typedef NvU64 RmPhysAddr;
+
+typedef NvU32 NV_STATUS;
+
+typedef union {} rpc_generic_union;
+#endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/metadata.c b/drivers/vfio/pci/nvidia-vgpu/metadata.c
new file mode 100644
index 000000000000..8e2c326c43f4
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/metadata.c
@@ -0,0 +1,319 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright © 2025 NVIDIA Corporation
+ */
+
+#include <linux/crc32.h>
+#include <linux/firmware.h>
+
+#include "debug.h"
+#include "vgpu_mgr.h"
+#include "metadata.h"
+
+#include <nvrm/gsp.h>
+
+/* Sanity checks on main headers */
+static int check_main_headers(struct nvidia_vgpu_mgr *vgpu_mgr, const struct firmware *fw)
+{
+	struct metadata_hdr *hdr = (struct metadata_hdr *)fw->data;
+	struct metadata_blob_hdr *blob;
+	u32 crc;
+
+	if (fw->size <= sizeof(*hdr)) {
+		vgpu_mgr_error(vgpu_mgr, "metadata: file is too small\n");
+		return -EINVAL;
+	}
+
+	crc = crc32_le(0xffffffff, fw->data + 16, fw->size - 16);
+	if (crc != hdr->crc32) {
+		vgpu_mgr_error(vgpu_mgr, "metadata: invalid CRC\n");
+		return -EINVAL;
+	}
+
+	if (memcmp(&hdr->identifier, METADATA_IDR, sizeof(hdr->identifier))) {
+		vgpu_mgr_error(vgpu_mgr, "metadata: invalid identifier\n");
+		return -EINVAL;
+	}
+
+	if (!hdr->num_blobs ||
+	    (hdr->num_blobs > (fw->size - sizeof(*hdr)) / sizeof(*blob))) {
+		vgpu_mgr_error(vgpu_mgr, "metadata: invalid num_blobs\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int get_running_gsp_build_version(struct nvidia_vgpu_mgr *vgpu_mgr,
+					 char *running_gsp_build_version)
+{
+	NV2080_CTRL_GSP_GET_FEATURES_PARAMS *ctrl;
+
+	ctrl = nvidia_vgpu_mgr_rm_ctrl_rd(vgpu_mgr, &vgpu_mgr->gsp_client,
+			NV2080_CTRL_CMD_GSP_GET_FEATURES, sizeof(*ctrl));
+	if (IS_ERR(ctrl))
+		return PTR_ERR(ctrl);
+
+	memcpy(running_gsp_build_version, ctrl->firmwareVersion, GSP_MAX_BUILD_VERSION_LENGTH);
+
+	nvidia_vgpu_mgr_rm_ctrl_done(vgpu_mgr, &vgpu_mgr->gsp_client, ctrl);
+
+	vgpu_mgr_debug(vgpu_mgr, "running GSP build version %s\n", running_gsp_build_version);
+
+	return 0;
+}
+
+struct version {
+	u64 vgpu_major;
+	u64 vgpu_minor;
+	const char *gsp_build_version;
+};
+
+static struct version supported_version_list[] = {
+	{ 18, 1, "570.144" },
+};
+
+/* check supported versions */
+static int check_versions(struct nvidia_vgpu_mgr *vgpu_mgr, const struct firmware *fw,
+			  char *running_gsp_build_version)
+{
+	struct metadata_hdr *hdr = (struct metadata_hdr *)fw->data;
+	unsigned int i;
+
+	/*
+	 * The running GSP metadata supports vGPU (or we won't be here).
+	 * Check if the vGPU metadata file matches with the version of GSP metadata.
+	 */
+	if (strncmp(running_gsp_build_version, hdr->gsp_build_version,
+		    GSP_MAX_BUILD_VERSION_LENGTH)) {
+		vgpu_mgr_error(vgpu_mgr, "unexpected metadata GSP version %s, running %s\n",
+			       hdr->gsp_build_version, running_gsp_build_version);
+		return -EINVAL;
+	}
+
+	/* Check vGPU release version. */
+	for (i = 0; i < ARRAY_SIZE(supported_version_list); i++) {
+		struct version *v = supported_version_list + i;
+
+		if (strncmp(v->gsp_build_version, hdr->gsp_build_version,
+			    GSP_MAX_BUILD_VERSION_LENGTH))
+			continue;
+
+		if (v->vgpu_major == hdr->vgpu_major && v->vgpu_minor == hdr->vgpu_minor)
+			break;
+	}
+
+	if (i == ARRAY_SIZE(supported_version_list)) {
+		vgpu_mgr_error(vgpu_mgr, "unexpected metadata vGPU %llu.%llu GSP %s, running %s\n",
+			       hdr->vgpu_major, hdr->vgpu_minor, hdr->gsp_build_version,
+			       running_gsp_build_version);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+#define for_each_blob(hdr, blob, i) \
+	for (i = 0, blob = (typeof(blob))hdr->data; i < hdr->num_blobs; \
+	     i++, blob = ((void *)blob) + blob->size)
+
+/* Sanity check on blob headers */
+static int check_blob_headers(struct nvidia_vgpu_mgr *vgpu_mgr, const struct firmware *fw)
+{
+	struct metadata_hdr *hdr = (struct metadata_hdr *)fw->data;
+	struct metadata_blob_hdr *blob;
+	unsigned int i;
+
+	for_each_blob(hdr, blob, i) {
+		vgpu_mgr_debug(vgpu_mgr, "check blob header %u type 0x%llx size 0x%llx\n",
+			       i, blob->type, blob->size);
+
+		if (blob->type >= METADATA_BLOB_MAX) {
+			vgpu_mgr_error(vgpu_mgr, "unknown blob type 0x%llx\n", blob->type);
+			return -EINVAL;
+		}
+
+		if (blob->size <= sizeof(*blob) ||
+		    (blob->size > (fw->size - ((void *)blob - (void *)fw->data)))) {
+			vgpu_mgr_error(vgpu_mgr, "invalid blob_size 0x%llx\n", blob->size);
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+typedef int (*blob_handler_t)(struct nvidia_vgpu_mgr *vgpu_mgr, void *blob, u64 blob_size);
+
+struct blob_handler_fn {
+	blob_handler_t check;
+	blob_handler_t setup;
+	blob_handler_t post_setup;
+	blob_handler_t clean;
+};
+
+struct blob_handler_fn blob_handlers[] = {
+	[METADATA_BLOB_VGPU_TYPE] = {
+		.check = nvidia_vgpu_metadata_check_vgpu_type,
+		.setup = nvidia_vgpu_metadata_setup_vgpu_type,
+		.post_setup = nvidia_vgpu_metadata_post_setup_vgpu_type,
+		.clean = nvidia_vgpu_metadata_clean_vgpu_type,
+	},
+};
+
+/* Check blobs in this metadata file */
+static int check_blobs(struct nvidia_vgpu_mgr *vgpu_mgr, const struct firmware *fw)
+{
+	struct metadata_hdr *hdr = (struct metadata_hdr *)fw->data;
+	struct metadata_blob_hdr *blob;
+	unsigned int i;
+	int ret;
+
+	for_each_blob(hdr, blob, i) {
+		ret = blob_handlers[blob->type].check(vgpu_mgr, blob->data, blob->size);
+		if (ret) {
+			vgpu_mgr_error(vgpu_mgr, "metadata: blob is invalid, type: 0x%llx\n",
+				       blob->type);
+			return ret;
+		}
+	}
+	return 0;
+}
+
+/* Setup blobs in this metadata file */
+static int setup_blobs(struct nvidia_vgpu_mgr *vgpu_mgr, const struct firmware *fw)
+{
+	struct metadata_hdr *hdr = (struct metadata_hdr *)fw->data;
+	struct metadata_blob_hdr *blob;
+	unsigned int i;
+	int ret;
+
+	for_each_blob(hdr, blob, i) {
+		ret = blob_handlers[blob->type].setup(vgpu_mgr, blob->data, blob->size);
+		if (ret) {
+			vgpu_mgr_error(vgpu_mgr, "metadata: fail to setup blob, type: 0x%llx\n",
+				       blob->type);
+			return ret;
+		}
+	}
+	return 0;
+}
+
+/* Final setup after installing all the blobs */
+static int post_setup_blobs(struct nvidia_vgpu_mgr *vgpu_mgr, const struct firmware *fw)
+{
+	struct metadata_hdr *hdr = (struct metadata_hdr *)fw->data;
+	unsigned int i;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(blob_handlers); i++) {
+		ret = blob_handlers[i].post_setup(vgpu_mgr, NULL, 0);
+		if (ret) {
+			vgpu_mgr_error(vgpu_mgr, "metadata: fail to post setup blob, type: 0x%x\n",
+				       i);
+			return ret;
+		}
+	}
+
+	vgpu_mgr->vgpu_major = hdr->vgpu_major;
+	vgpu_mgr->vgpu_minor = hdr->vgpu_minor;
+
+	return 0;
+}
+
+/* Clean all the installed blobs */
+static void clean_blobs(struct nvidia_vgpu_mgr *vgpu_mgr)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(blob_handlers); i++)
+		blob_handlers[i].clean(vgpu_mgr, NULL, 0);
+}
+
+/**
+ * nvidia_vgpu_mgr_clean_metadata - clean vGPU metadata
+ * @vgpu_mgr: the vGPU manager.
+ */
+void nvidia_vgpu_mgr_clean_metadata(struct nvidia_vgpu_mgr *vgpu_mgr)
+{
+	clean_blobs(vgpu_mgr);
+
+	vgpu_mgr_debug(vgpu_mgr, "clean vgpu metadata\n");
+}
+
+/**
+ * nvidia_vgpu_mgr_setup_metadata - setup vGPU metadata
+ * @vgpu_mgr: the vGPU manager.
+ *
+ * Returns: zero on success, others on failure.
+ */
+int nvidia_vgpu_mgr_setup_metadata(struct nvidia_vgpu_mgr *vgpu_mgr)
+{
+	u8 running_gsp_build_version[GSP_MAX_BUILD_VERSION_LENGTH];
+	char *path;
+	const struct firmware *fw;
+	int ret = 0;
+
+	ret = get_running_gsp_build_version(vgpu_mgr, running_gsp_build_version);
+	if (ret)
+		return ret;
+
+	path = kvzalloc(PATH_MAX, GFP_KERNEL);
+	if (!path)
+		return -ENOMEM;
+
+	snprintf(path, PATH_MAX, METADATA_PATH "vgpu-%s.bin",
+		 running_gsp_build_version);
+
+	vgpu_mgr_debug(vgpu_mgr, "request vgpu metadata %s\n", path);
+
+	ret = request_firmware(&fw, path, &vgpu_mgr->handle.pf_pdev->dev);
+
+	kvfree(path);
+
+	if (ret)
+		return ret;
+
+	vgpu_mgr_debug(vgpu_mgr, "check main headers\n");
+
+	ret = check_main_headers(vgpu_mgr, fw);
+	if (ret)
+		goto out_free_fw;
+
+	vgpu_mgr_debug(vgpu_mgr, "check versions\n");
+
+	ret = check_versions(vgpu_mgr, fw, running_gsp_build_version);
+	if (ret)
+		goto out_free_fw;
+
+	vgpu_mgr_debug(vgpu_mgr, "check blob headers\n");
+
+	ret = check_blob_headers(vgpu_mgr, fw);
+	if (ret)
+		goto out_free_fw;
+
+	vgpu_mgr_debug(vgpu_mgr, "check blobs\n");
+
+	ret = check_blobs(vgpu_mgr, fw);
+	if (ret)
+		goto out_free_fw;
+
+	vgpu_mgr_debug(vgpu_mgr, "setup blobs\n");
+
+	ret = setup_blobs(vgpu_mgr, fw);
+	if (ret)
+		goto out_free_fw;
+
+	vgpu_mgr_debug(vgpu_mgr, "post-setup blobs\n");
+
+	ret = post_setup_blobs(vgpu_mgr, fw);
+	if (ret) {
+		clean_blobs(vgpu_mgr);
+		goto out_free_fw;
+	}
+
+	vgpu_mgr_debug(vgpu_mgr, "metadata loaded, vgpu major %llu vgpu minor %llu\n",
+		       vgpu_mgr->vgpu_major, vgpu_mgr->vgpu_minor);
+
+out_free_fw:
+	release_firmware(fw);
+	return ret;
+}
diff --git a/drivers/vfio/pci/nvidia-vgpu/metadata.h b/drivers/vfio/pci/nvidia-vgpu/metadata.h
new file mode 100644
index 000000000000..c55da3e8e44f
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/metadata.h
@@ -0,0 +1,89 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright © 2025 NVIDIA Corporation
+ */
+#ifndef __NVIDIA_VGPU_METADATA_H__
+#define __NVIDIA_VGPU_METADATA_H__
+
+#define METADATA_PATH "nvidia/"
+#define METADATA_IDR "NVVGPUMT"
+
+enum {
+	METADATA_BLOB_VGPU_TYPE = 0,
+	METADATA_BLOB_MAX,
+};
+
+#define GSP_MAX_BUILD_VERSION_LENGTH (0x0000040)
+
+#define METADATA_VGPU_FEATURE_SIZE 128
+
+/**
+ * struct metadata_hdr - vGPU metafile main header
+ *
+ * @identifier: identifier to check
+ * @crc32: crc32 of the metafile
+ * @vgpu_major: vGPU major version
+ * @vgpu_minor: vGPU minor version
+ * @vgpu_features: vGPU features in a specific version
+ * @gsp_build_version: GSP build version for this vGPU version
+ * @num_blobs: total blob amount
+ * @data: blob data
+ */
+struct metadata_hdr {
+	u64 identifier; /* "NVVGPUMT" */
+	u32 crc32;
+	u32 padding;
+	u64 vgpu_major;
+	u64 vgpu_minor;
+	u8 vgpu_features[METADATA_VGPU_FEATURE_SIZE];
+	u8 gsp_build_version[GSP_MAX_BUILD_VERSION_LENGTH];
+	u64 num_blobs;
+	unsigned char data[];
+};
+
+/**
+ * struct metadata_blob_hdr - vGPU metafile blob section header
+ *
+ * @type: blob type
+ * @size: blob size
+ * @data: blob data
+ */
+struct metadata_blob_hdr {
+	u64 type;
+	u64 size;
+	unsigned char data[];
+};
+
+/**
+ * struct vgpu_type_blob_hdr - vGPU metafile vGPU type blob header
+ *
+ * @device_id: supported device ID
+ * @gsp_rmctrl_vgpu_info_offset: vgpu info offset in rmctrl part
+ * @gsp_rmctrl_vgpu_info_szie: vgpu info size in rmctrl part
+ * @kernel_struct_size: kernel struct size
+ * @num_kernel_struct: amount of kernel structs
+ * @gsp_rmctrl_cmd: GSP rmctrl command
+ * @gsp_rmctrl_size: GSP rmctl size
+ * @data: blob data
+ */
+struct vgpu_type_blob_hdr {
+	u64 device_id;
+	u64 gsp_rmctrl_vgpu_info_offset;
+	u64 gsp_rmctrl_vgpu_info_size;
+
+	u64 kernel_struct_size;
+	u64 num_kernel_structs;
+	u64 gsp_rmctrl_cmd;
+	u64 gsp_rmctrl_size;
+	unsigned char data[];
+};
+
+int nvidia_vgpu_metadata_check_vgpu_type(struct nvidia_vgpu_mgr *vgpu_mgr,
+					 void *blob, u64 blob_size);
+int nvidia_vgpu_metadata_setup_vgpu_type(struct nvidia_vgpu_mgr *vgpu_mgr, void *blob,
+					 u64 blob_size);
+int nvidia_vgpu_metadata_post_setup_vgpu_type(struct nvidia_vgpu_mgr *vgpu_mgr, void *blob,
+					      u64 blob_size);
+int nvidia_vgpu_metadata_clean_vgpu_type(struct nvidia_vgpu_mgr *vgpu_mgr, void *blob,
+					 u64 blob_size);
+#endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/metadata_vgpu_type.c b/drivers/vfio/pci/nvidia-vgpu/metadata_vgpu_type.c
new file mode 100644
index 000000000000..013fbc90c6de
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/metadata_vgpu_type.c
@@ -0,0 +1,153 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright © 2025 NVIDIA Corporation
+ */
+
+#include "debug.h"
+#include "vgpu_mgr.h"
+#include "metadata.h"
+
+#include <nvrm/gsp.h>
+
+/**
+ * nvidia_vgpu_metadata_check_vgpu_type - check vGPU type blobs
+ * @vgpu_mgr: the vGPU manager
+ * @blob: the blob header
+ * @blob_size: the blob size
+ *
+ * Returns: zero on success, others on errors.
+ */
+int nvidia_vgpu_metadata_check_vgpu_type(struct nvidia_vgpu_mgr *vgpu_mgr,
+					 void *blob, u64 blob_size)
+{
+	struct vgpu_type_blob_hdr *hdr = blob;
+	u64 size;
+
+	vgpu_mgr_debug(vgpu_mgr, "check vgpu type blob for device 0x%llx\n", hdr->device_id);
+
+	if (!hdr->device_id || !hdr->num_kernel_structs || !hdr->kernel_struct_size ||
+	    !hdr->gsp_rmctrl_cmd || !hdr->gsp_rmctrl_size) {
+		vgpu_mgr_error(vgpu_mgr, "metadata: vgpu type blob header is invalid\n");
+		return -EINVAL;
+	}
+
+	size = sizeof(struct metadata_blob_hdr);
+	size += sizeof(*hdr);
+	size += hdr->kernel_struct_size;
+	size += hdr->gsp_rmctrl_size;
+
+	if (size != blob_size) {
+		vgpu_mgr_error(vgpu_mgr, "metadata: vgpu type blob size mismatch\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int send_gsp_rmctrl(struct nvidia_vgpu_mgr *vgpu_mgr, struct vgpu_type_blob_hdr *hdr)
+{
+	void *ctrl;
+	int ret;
+
+	vgpu_mgr_debug(vgpu_mgr, "send rmctrl cmd 0x%llx size 0x%llx\n", hdr->gsp_rmctrl_cmd,
+		       hdr->gsp_rmctrl_size);
+
+	ctrl = nvidia_vgpu_mgr_rm_ctrl_get(vgpu_mgr, &vgpu_mgr->gsp_client,
+					   hdr->gsp_rmctrl_cmd, hdr->gsp_rmctrl_size);
+	if (IS_ERR(ctrl))
+		return PTR_ERR(ctrl);
+
+	memcpy(ctrl, hdr->data + hdr->kernel_struct_size, hdr->gsp_rmctrl_size);
+
+	ret = nvidia_vgpu_mgr_rm_ctrl_wr(vgpu_mgr, &vgpu_mgr->gsp_client, ctrl);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+/**
+ * nvidia_vgpu_metadata_setup_vgpu_type - setup vGPU type blob
+ * @vgpu_mgr: the vGPU manager
+ * @blob: the blob header
+ * @blob_size: the blob size
+ *
+ * Returns: zero on success, others on errors.
+ */
+int nvidia_vgpu_metadata_setup_vgpu_type(struct nvidia_vgpu_mgr *vgpu_mgr, void *blob,
+					 u64 blob_size)
+{
+	struct vgpu_type_blob_hdr *hdr = blob;
+	u64 size, copy_size;
+	int ret;
+	void *p;
+	int i;
+
+	/* Not for this device, skip */
+	if (hdr->device_id != vgpu_mgr->handle.pf_pdev->device)
+		return 0;
+
+	vgpu_mgr_debug(vgpu_mgr, "setup vgpu type blob for device 0x%llx\n", hdr->device_id);
+
+	vgpu_mgr->vgpu_types = kvrealloc(vgpu_mgr->vgpu_types, hdr->kernel_struct_size, GFP_KERNEL);
+	if (!vgpu_mgr->vgpu_types)
+		return -ENOMEM;
+
+	ret = send_gsp_rmctrl(vgpu_mgr, hdr);
+	if (ret) {
+		kvfree(vgpu_mgr->vgpu_types);
+		vgpu_mgr->vgpu_types = NULL;
+		return ret;
+	}
+
+	size = hdr->kernel_struct_size / hdr->num_kernel_structs;
+	copy_size = min(size, sizeof(struct nvidia_vgpu_type));
+	p = hdr->data;
+
+	for (i = 0; i < hdr->num_kernel_structs; i++, p += size) {
+		memcpy(vgpu_mgr->vgpu_types + i, p, copy_size);
+
+		vgpu_mgr_debug(vgpu_mgr, "setup vgpu type %u %s for device 0x%llx\n",
+			       vgpu_mgr->vgpu_types[i].vgpu_type,
+			       vgpu_mgr->vgpu_types[i].vgpu_type_name, hdr->device_id);
+	}
+
+	vgpu_mgr->num_vgpu_types = hdr->num_kernel_structs;
+	return 0;
+}
+
+/**
+ * nvidia_vgpu_metadata_post_setup_vgpu_type - vGPU type post setup
+ *
+ * @vgpu_mgr: the vGPU manager
+ * @blob: the blob header
+ * @blob_size: the blob size
+ *
+ * Returns: zero on success, others on failure.
+ */
+int nvidia_vgpu_metadata_post_setup_vgpu_type(struct nvidia_vgpu_mgr *vgpu_mgr, void *blob,
+					      u64 blob_size)
+{
+	if (WARN_ON(!vgpu_mgr->vgpu_types || !vgpu_mgr->num_vgpu_types)) {
+		vgpu_mgr_error(vgpu_mgr, "metadata: no available vgpu type blob\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/**
+ * nvidia_vgpu_metadata_clean_vgpu_type - clean vGPU type
+ *
+ * @vgpu_mgr: the vGPU manager
+ * @blob: the blob header
+ * @blob_size: the blob size
+ *
+ * Returns: zero on success, others on failure.
+ */
+int nvidia_vgpu_metadata_clean_vgpu_type(struct nvidia_vgpu_mgr *vgpu_mgr, void *blob,
+					 u64 blob_size)
+{
+	kvfree(vgpu_mgr->vgpu_types);
+	vgpu_mgr->vgpu_types = NULL;
+	vgpu_mgr->num_vgpu_types = 0;
+	return 0;
+}
diff --git a/drivers/vfio/pci/nvidia-vgpu/pf.h b/drivers/vfio/pci/nvidia-vgpu/pf.h
index 044bc3aef5a6..19f0aca56d12 100644
--- a/drivers/vfio/pci/nvidia-vgpu/pf.h
+++ b/drivers/vfio/pci/nvidia-vgpu/pf.h
@@ -73,4 +73,16 @@ static inline int nvidia_vgpu_mgr_init_handle(struct pci_dev *pdev,
 #define nvidia_vgpu_mgr_get_gsp_client_handle(m, c) \
 	((m)->handle.ops->get_gsp_client_handle(c))
 
+#define nvidia_vgpu_mgr_rm_ctrl_get(m, g, c, s) \
+	((m)->handle.ops->rm_ctrl_get(g, c, s))
+
+#define nvidia_vgpu_mgr_rm_ctrl_wr(m, g, c) \
+	((m)->handle.ops->rm_ctrl_wr(g, c))
+
+#define nvidia_vgpu_mgr_rm_ctrl_rd(m, g, c, s) \
+	((m)->handle.ops->rm_ctrl_rd(g, c, s))
+
+#define nvidia_vgpu_mgr_rm_ctrl_done(m, g, c) \
+	((m)->handle.ops->rm_ctrl_done(g, c))
+
 #endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu.c b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
index 79e6a9f16f74..cbb51b939f0b 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
@@ -75,7 +75,7 @@ int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu)
 	struct nvidia_vgpu_info *info = &vgpu->info;
 	int ret;
 
-	if (WARN_ON(!info->gfid || !info->dbdf))
+	if (WARN_ON(!info->gfid || !info->dbdf || !info->vgpu_type))
 		return -EINVAL;
 
 	if (WARN_ON(!vgpu->vgpu_mgr || !vgpu->pdev))
@@ -86,7 +86,8 @@ int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu)
 
 	vgpu->info = *info;
 
-	vgpu_debug(vgpu, "create vgpu on vgpu_mgr %px\n", vgpu->vgpu_mgr);
+	vgpu_debug(vgpu, "create vgpu %s on vgpu_mgr %px\n",
+		   info->vgpu_type->vgpu_type_name, vgpu->vgpu_mgr);
 
 	ret = register_vgpu(vgpu);
 	if (ret)
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
index 1455ca51eca1..a7f8a00f96bf 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
@@ -16,6 +16,7 @@ static void vgpu_mgr_release(struct kref *kref)
 	if (WARN_ON(atomic_read(&vgpu_mgr->num_vgpus)))
 		return;
 
+	nvidia_vgpu_mgr_clean_metadata(vgpu_mgr);
 	nvidia_vgpu_mgr_free_gsp_client(vgpu_mgr, &vgpu_mgr->gsp_client);
 	kvfree(vgpu_mgr);
 }
@@ -150,6 +151,10 @@ static int pf_attach_handle_fn(void *handle, struct nvidia_vgpu_vfio_handle_data
 	if (ret)
 		goto fail_init_vgpu_mgr;
 
+	ret = nvidia_vgpu_mgr_setup_metadata(vgpu_mgr);
+	if (ret)
+		goto fail_setup_metadata;
+
 	attach_vgpu_mgr(vgpu_mgr, handle_data);
 
 	ret = attach_data->init_vfio_fn(vgpu_mgr, attach_data->init_vfio_fn_data);
@@ -162,6 +167,8 @@ static int pf_attach_handle_fn(void *handle, struct nvidia_vgpu_vfio_handle_data
 
 fail_init_fn:
 	detach_vgpu_mgr(handle_data);
+	nvidia_vgpu_mgr_clean_metadata(vgpu_mgr);
+fail_setup_metadata:
 fail_init_vgpu_mgr:
 	nvidia_vgpu_mgr_free_gsp_client(vgpu_mgr, &vgpu_mgr->gsp_client);
 fail_alloc_gsp_client:
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
index 98dcbb682b92..0519b595378f 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
@@ -7,6 +7,21 @@
 
 #include "pf.h"
 
+#define NVIDIA_VGPU_TYPE_NAME_MAX 32
+
+struct nvidia_vgpu_type {
+	u32 vgpu_type;
+	char vgpu_type_name[NVIDIA_VGPU_TYPE_NAME_MAX];
+	u64 vdev_id;
+	u64 pdev_id;
+	u64 fb_length;
+	u64 gsp_heap_size;
+	u64 bar1_length;
+	u32 max_instance;
+	u32 ecc_supported;
+	u64 fb_reservation;
+};
+
 /**
  * struct nvidia_vgpu_info - vGPU information
  *
@@ -18,6 +33,7 @@ struct nvidia_vgpu_info {
 	int id;
 	u32 gfid;
 	u32 dbdf;
+	struct nvidia_vgpu_type *vgpu_type;
 };
 
 /**
@@ -48,10 +64,14 @@ struct nvidia_vgpu {
  * @handle: the driver handle
  * @total_avail_chids: total available channel IDs
  * @total_fbmem_size: total FB memory size
+ * @vgpu_major: vGPU major version
+ * @vgpu_minor: vGPU minor version
  * @vgpu_list_lock: lock to protect vGPU list
  * @vgpu_list_head: list head of vGPU list
  * @num_vgpus: number of vGPUs in the vGPU list
  * @gsp_client: the GSP client
+ * @vgpu_types: installed vGPU types
+ * @num_vgpu_types: number of installed vGPU types
  */
 struct nvidia_vgpu_mgr {
 	struct kref refcount;
@@ -61,12 +81,17 @@ struct nvidia_vgpu_mgr {
 	u32 total_avail_chids;
 	u64 total_fbmem_size;
 
+	u64 vgpu_major;
+	u64 vgpu_minor;
+
 	/* lock for vGPU list */
 	struct mutex vgpu_list_lock;
 	struct list_head vgpu_list_head;
 	atomic_t num_vgpus;
 
 	struct nvidia_vgpu_gsp_client gsp_client;
+	struct nvidia_vgpu_type *vgpu_types;
+	unsigned int num_vgpu_types;
 };
 
 #define nvidia_vgpu_mgr_for_each_vgpu(vgpu, vgpu_mgr) \
@@ -78,5 +103,7 @@ void nvidia_vgpu_mgr_release(struct nvidia_vgpu_mgr *vgpu_mgr);
 
 int nvidia_vgpu_mgr_destroy_vgpu(struct nvidia_vgpu *vgpu);
 int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu);
+int nvidia_vgpu_mgr_setup_metadata(struct nvidia_vgpu_mgr *vgpu_mgr);
+void nvidia_vgpu_mgr_clean_metadata(struct nvidia_vgpu_mgr *vgpu_mgr);
 
 #endif
-- 
2.34.1


