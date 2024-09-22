Return-Path: <kvm+bounces-27248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CC4E97E1A2
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 14:50:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B917C2813DD
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 12:50:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED6B55228;
	Sun, 22 Sep 2024 12:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gg+5YNgx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2050.outbound.protection.outlook.com [40.107.236.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6568E2CA7
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 12:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727009437; cv=fail; b=bxHODtVmguPP+GL46m/KN5QSm9lISefRly7rVBtc8jNfv7g7rYsG4BtcLFoyByh8YYuwEe2LBB1kYBjchQwNLaB3uHwBpJ5DcftKUD7O1uUdGOHu++VjpBwB5tbTIDjrGnl7jHvmhfsb2uROwllkMaKRs/QOar+CowKoQuaKkfI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727009437; c=relaxed/simple;
	bh=sCNz+ZGh+rCMZ9tifjvFxo+/23kwlYpW7wfCu9LqW/k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IgfCr0ejp1OAmYjIfCkkv+xrH51lDUbOErGs1G5DVJ5GmQDJxEyiCJwZFfyVF6VF9Jxox4DF11K6j51IuKbxJ1MI+KJ2D7T+GnYqvWX3hdgUi/6VQ10ukyG/UAmGWxOVBxHlnOkwMzhmcMRoyBReIlGgVcrrZYbfmjqO9SGcJhw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gg+5YNgx; arc=fail smtp.client-ip=40.107.236.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q5iX5T6hm2BeOuEyM9qfPaiHBLbPB7Jv0Lq2J47qcLMqyLNZprzB6l08WmxTZQKzhJ2sB0XMyge17JggGG6egO2QKFw0EznfXJtZ0t+zOYQrNfRCWS9K+uV7bmB2oBQoEbFbjtA29vmnb4oEtDeR7J4WbtKJn5YzYzUkC+u5OIcIIsxJj7sSgIfLjq705iWB1q3bWpNQVnu6D0mJYoVAJ9l6Hf5rrGkmxGPZ2FWegk6M5ni5pt0bxIh9GBK3Yd3f/RmteyhEWWCq/RmmAT8oR5PMrycFYFGEriKL2nNqNl3T7weDNfR8P6/u/FMF4BZdSsqW64Cpb+DqoVPcwgt0ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B76wO9woObFjAo5fjIDfWpTEn9+rDOcfspKJJKsnWKA=;
 b=E9ARcp4MPyswUZnnCxEhN8sdnBbE8qb0FYE66oLUrznjGbkU3AkEIZa5yr99NcgYgYhvfqk0bFzbsR15BKPucf99RtHPb81Kv5bWp9FXcgGwcyx2MkuzR+AktxHKX5jA0L8mWibS5xJxn9tsRYoUm/CNHk8/jLpspugD0y7qzbEimtzUSi1hQGzHBEOa1FJ0CrsoDhnj/Jz0b5QUCG+uX31gPyha2+ESpyUPT19ntH56CGCgxTdPWanA6x7MHNDLaSu1sX/qPOjBUCMHj70Wq+7EDx4WAhbIwEjheyWXVpmIlvP9U7d1TjCQoU9OesKo+8mfuyw5c7ZVzU/O4M5hFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B76wO9woObFjAo5fjIDfWpTEn9+rDOcfspKJJKsnWKA=;
 b=gg+5YNgxSXFO9U7uMZy6blJ7YudvbcMSVREUbB0Yt5GEZDO3fxBavzA5T9TZAYUMbzzlfAWTWboBojTaUWIngUg9Rw1xnGJx5Z0ee6q9s6RD2RBB7zeupbvo+b3EIcZkvMTTKPtSOanetpiA8Uav1ZJYwdc/oWnyK32UKqUFB1qxhGUiKKYIg/yjFaML+DI1jn2r48+J7jZyiRz+lh1h8aTdD0oPTcAJJk0omsnyOSbGX83NyBeSbjjohKQVdmCHq+L/WnmOp3cwqvnJl8f64YhL/hI2bfWIUZGZhPsCU3kFOOrXbJaHyV0YusdOXNp2v14QvhfhKCYRUPaP9fXbvw==
Received: from BYAPR02CA0044.namprd02.prod.outlook.com (2603:10b6:a03:54::21)
 by IA0PR12MB7751.namprd12.prod.outlook.com (2603:10b6:208:430::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.24; Sun, 22 Sep
 2024 12:50:31 +0000
Received: from CO1PEPF000075F4.namprd03.prod.outlook.com
 (2603:10b6:a03:54:cafe::b6) by BYAPR02CA0044.outlook.office365.com
 (2603:10b6:a03:54::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.30 via Frontend
 Transport; Sun, 22 Sep 2024 12:50:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1PEPF000075F4.mail.protection.outlook.com (10.167.249.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 22 Sep 2024 12:50:30 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 22 Sep
 2024 05:50:22 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 22 Sep 2024 05:50:21 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sun, 22 Sep 2024 05:50:21 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <nouveau@lists.freedesktop.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 04/29] nvkm/vgpu: set the VF partition count when NVIDIA vGPU is enabled
Date: Sun, 22 Sep 2024 05:49:26 -0700
Message-ID: <20240922124951.1946072-5-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F4:EE_|IA0PR12MB7751:EE_
X-MS-Office365-Filtering-Correlation-Id: 218d2e56-2df3-4ebb-2bc4-08dcdb05241e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?J99FfgnkxePME4EdxBmarsA2VFSUad9Nd9L6FuIuZbdNt9wcQ6AbAan5NWoS?=
 =?us-ascii?Q?A843M2MPALx8UiwH0VHjM3su80ObYsSYyED9X4xxQqrIxadTfWD/ED9gHQi3?=
 =?us-ascii?Q?197k+H/Cklf8UEXnCf4zQxm4ZY+7xZwIzWWwEcximMCS994YJ1VQvPea7CaS?=
 =?us-ascii?Q?GKwQDitH6lvkgQ+9ExLwb/UlUXDv5nPDl5F5B5crCfrIg7r4se37/16CyfQd?=
 =?us-ascii?Q?x5iFpYxkVhrW+xyO3fqYFud+7BbKzFij+3jaH7+Mz/Jnj0eQlZfO1XKfK5Am?=
 =?us-ascii?Q?rtQFLLRQ67g/LU6RPP05b0CVRAZyQ0Aoq/BD+tGLCH2FW5Ywzdi4xl2o42vg?=
 =?us-ascii?Q?811F2rNHyENBMNA0s07vCRmJNZFAy+W+d0KYUTeX34F3q0jw94Va09/2jSXr?=
 =?us-ascii?Q?Dj4KqeWkg0i+9RM2YnrFeLVFVpXEsaCrBLwscP21QfMuNWag7fAJY8+ri4xB?=
 =?us-ascii?Q?hvC14XjX3tW8CzBQCJhUM5KypXnk+koqQLm5AOMD/Yb/UJtTzPRRt8Cp4MUK?=
 =?us-ascii?Q?henIm5HYEUqiVFkvFWMa2wcPSct+x+mvQ/hsNVc5oEh/WOWa12XasYvZ55ap?=
 =?us-ascii?Q?kBGEtQaj8qVF+dgpazcUeUyvInQ6Ne8UJDFs0Qcenw2FK0VqSDT+dsnaKyCD?=
 =?us-ascii?Q?5+eooivjouNM2W31g4qRagwsDfZrhpF4p4mRkfHzQI/QqymHtL1QbETsb/Of?=
 =?us-ascii?Q?Fi8RfUZPv90zFRTQvHFQA/aiTqJdlBxU9ZTcsDbTcsge0aX/XzHvmKVeJaIl?=
 =?us-ascii?Q?xNKUi+6i4mo6D2DJhOoSFKk8H6ityoujNmIhcBhnKTDG7UtywRcnMWOGlATF?=
 =?us-ascii?Q?TBxVC8o6A30qV4OluSUfsFJgGeA0Tx3dzlLaPyc2/FTbMKnzOPQUNCehKd8h?=
 =?us-ascii?Q?Og7AGsyjRUTQUvJIpoZF+HYdAcikhr4fGpNSUV4WSJ3m5zwxIyrTz/Z2Hgm4?=
 =?us-ascii?Q?YH0HLAm2MWtEAqc5m1GwvQHLVuJQ1CNcvKv3V54UMRXeo/s7tt8CGLN7vlE/?=
 =?us-ascii?Q?u0RI7BeWli1DZA99CoJYbQZIwXljMqIXT1s9v1uy47BbXFwazC1vOUl66aWG?=
 =?us-ascii?Q?QQozU8zNYLCwq/J/UkL6ElhgGpBCT9JJVaZeIlP2X3w5gAJXyvSgvyw55U3p?=
 =?us-ascii?Q?AKtn1jnEXGhRdPlG/KoovUYkDgLVmaifboU0PndJgGLR2NDeHcfT8Mc4WoCB?=
 =?us-ascii?Q?SwDxDuexh+Dn+G+5UUkTydvdvZHR360BGgMXf1ObMag8QLOhsppu39xpPwYO?=
 =?us-ascii?Q?hQrqoHqeSgd/5E2d4ODSikN9E0Pyd4dXc3OUxyUnPEyDtgC6G+Q2JqA0FiVF?=
 =?us-ascii?Q?jycWPail4R/TMMFk1Z+f530/QxDHAHxeCBfn7ef4sMxBg/6Quw27b/nXs8jk?=
 =?us-ascii?Q?d03NWk/N79rNJjdLQO6dpZIMy/Gr?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 12:50:30.6263
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 218d2e56-2df3-4ebb-2bc4-08dcdb05241e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7751

GSP firmware needs to know the number of max-supported vGPUs when
initialization.

The field of VF partition count in the GSP WPR2 is required to be set
according to the number of max-supported vGPUs.

Set the VF partition count in the GSP WPR2 when NVKM is loading the GSP
firmware and initializes the GSP WPR2, if vGPU is enabled.

Cc: Neo Jia <cjia@nvidia.com>
Cc: Surath Mitra <smitra@nvidia.com>
Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/gpu/drm/nouveau/include/nvkm/subdev/gsp.h | 1 +
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c    | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/include/nvkm/subdev/gsp.h b/drivers/gpu/drm/nouveau/include/nvkm/subdev/gsp.h
index 3fbc57b16a05..f52143df45c1 100644
--- a/drivers/gpu/drm/nouveau/include/nvkm/subdev/gsp.h
+++ b/drivers/gpu/drm/nouveau/include/nvkm/subdev/gsp.h
@@ -61,6 +61,7 @@ struct nvkm_gsp {
 			} frts, boot, elf, heap;
 			u64 addr;
 			u64 size;
+			u8 vf_partition_count;
 		} wpr2;
 		struct {
 			u64 addr;
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
index a38a6abcac6f..14fc152d6859 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
@@ -2037,6 +2037,7 @@ r535_gsp_wpr_meta_init(struct nvkm_gsp *gsp)
 	meta->vgaWorkspaceOffset = gsp->fb.bios.vga_workspace.addr;
 	meta->vgaWorkspaceSize = gsp->fb.bios.vga_workspace.size;
 	meta->bootCount = 0;
+	meta->gspFwHeapVfPartitionCount = gsp->fb.wpr2.vf_partition_count;
 	meta->partitionRpcAddr = 0;
 	meta->partitionRpcRequestOffset = 0;
 	meta->partitionRpcReplyOffset = 0;
@@ -2640,6 +2641,7 @@ r535_gsp_oneinit(struct nvkm_gsp *gsp)
 
 	if (nvkm_vgpu_mgr_is_supported(device)) {
 		gsp->fb.wpr2.heap.size = SZ_256M;
+		gsp->fb.wpr2.vf_partition_count = NVIDIA_MAX_VGPUS;
 	} else {
 
 		u32 fb_size_gb = DIV_ROUND_UP_ULL(gsp->fb.size, 1 << 30);
-- 
2.34.1


