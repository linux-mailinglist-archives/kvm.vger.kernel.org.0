Return-Path: <kvm+bounces-27256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 738D997E1AA
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 14:51:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E7A5F1F213B6
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 12:51:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78635208C4;
	Sun, 22 Sep 2024 12:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KgF4QpkT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AB2653
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 12:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727009445; cv=fail; b=ke+LEwAOjoTpK/Gb7UhzAc7dRFsbSgkMIrg5ohhKbjm6iqkkogw4nvw2300LjbRV9uBSGzoIMpYBdne+8dNrmv/MaiCbh35Yp2ZA+BRKz5r4lKCyPQSQoTx87GPrpdV5kKfmVcU+v/H6OwPlF5DK7XHJkfnI3Hu/mVtmrgiBr/o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727009445; c=relaxed/simple;
	bh=0UkU5Ks/BhKyoiot64Tg+oNUo+iul+QHPPJdYV4LCKc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iPCJyQRMYueU7nEJi4GpQT6PnRksMhpBAz0ldBt33lDTeERYR7p2pyGTNFAI/GGzRNEF7SjBUHyT/d0Q+FaaRLBm7j+sL8fB6vtfj/uqNRxbBjNtkwMl+hsj+z3G2Tg11XlYihZVSiNG6KEDxcn6pVJfvaiAcfggQKt2SQUXiUg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KgF4QpkT; arc=fail smtp.client-ip=40.107.237.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hclqAQJ14Hnl8Bl0HG7Y8RsgUIb9DYRy6y7CPKxGUA4O1aSM3vW3Mw9LeHdMwrtNYxJBxseanG2+6y3nafco1c0LD6an1Ed9j7AGlBhyorQ2EFXaJ4To6HXpUgkMKyjy1bcYFYbMzMQZLZcswpwLqG3b84vZJTUoO46Zz1RzbGvVB/tX1xAD/K5W/IO2ADQN5hV/A640Ha6FGfklLOvCsl4HuBIFicd9nsnF+LT5OJ6nqKDtoKQJbIRuIRFSdBIdnR3fhjHVq7Es7fYOuxrnE4i5BDXWbuEANQZi5SuoYq/rdlq17TmB6LZ5xTuont7X7xnNqNz5iPVuDzSBrZwV2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jqta6mOUHgbsTQz9ROpc3QRS94a2Cx+ZesDw9BiyDhE=;
 b=upul8Pi1hqzjVJND6RSj6X2vjVTWsG/C1SWWTmLrgyYRcXJz4VumkKAmuZEXcusfZT/J8F11XYmSwC4v/abv/7uXFYByaxEeOhw0ktE8eayUEOxqLZdFhg2MV18ojygNeqapY3QsdPaGPIJcvNkOOjmOitROjAh0HYvvDqYn0+HlTARfS/ZbXXSL3X1eaNH50SfKTYAbbbZdeA+CX12pgji8pBTXUJlFtIEwNqxHsvcYKst3iymq+Xj9ChReHZod3v5zTqnqCIIz1+3atD8TiUJ2Uh/FECbgjpdZg7QFXGyxfAsWF1JDSP94Kn52z8FyjI1rqPbQN/99p26UQePJFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jqta6mOUHgbsTQz9ROpc3QRS94a2Cx+ZesDw9BiyDhE=;
 b=KgF4QpkTMlEJ6fr3UglW4X5nwUyzHiQUydp4+jHJT1BppzEKoN6RZuVApLPeD30vJwFe9XeTYxaTILp9Q9c7Fzkp1RkXfZLFxe+88oaNpfHRmUh4ItywkrdhdOsWwpYxK/GpgHIPYpHXY/EXHpxgei2FDFB0Gd6IFdnBkoelIAzxfuBRsNIG1cSViMlBBkLSaYdZaSloX9gZzFCkprloYAnmScb6/83B38RYgV+8+WWAVmCc4gND41WU3QLV4EJ3M06qmD7wZLIvXOkO2OzoOHLazM3lfCR9LuVaO4VNvMn7DO12M/9qHQveB7UhCtOzAsVxGbZ2XeXNUDIXqitKmw==
Received: from BYAPR02CA0060.namprd02.prod.outlook.com (2603:10b6:a03:54::37)
 by MW4PR12MB6873.namprd12.prod.outlook.com (2603:10b6:303:20c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.23; Sun, 22 Sep
 2024 12:50:37 +0000
Received: from CO1PEPF000075F4.namprd03.prod.outlook.com
 (2603:10b6:a03:54:cafe::c4) by BYAPR02CA0060.outlook.office365.com
 (2603:10b6:a03:54::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.29 via Frontend
 Transport; Sun, 22 Sep 2024 12:50:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1PEPF000075F4.mail.protection.outlook.com (10.167.249.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 22 Sep 2024 12:50:37 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 22 Sep
 2024 05:50:27 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 22 Sep 2024 05:50:26 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sun, 22 Sep 2024 05:50:26 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <nouveau@lists.freedesktop.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 11/29] nvkm/vgpu: introduce GSP RM client alloc and free for vGPU
Date: Sun, 22 Sep 2024 05:49:33 -0700
Message-ID: <20240922124951.1946072-12-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F4:EE_|MW4PR12MB6873:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f53b844-1d71-40a4-0de5-08dcdb05284f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vFe2JNNiKXW3aMDezVbTbF8JrkSZ2awQ73t3I0Q3N0XOmZXmW1uLERo1rGR5?=
 =?us-ascii?Q?ToRCGcA8+3l8WcZOx9G8G7jPC0u1fRLTZDD1CI0G1dCDRT5NG/e5wmU+6eVF?=
 =?us-ascii?Q?8n0sLWR2Ut1ad/U5Prms130HqAfW8DPn+ujSUCWB/7f3GbFboA7crOWMkskR?=
 =?us-ascii?Q?uITz+4irs6zorFazFlGk5I2XE0NYaZk8FXfTA1vqEcwBJ24pxS4R1Rinyris?=
 =?us-ascii?Q?Ck3B6meXO2eQA3C16pReJIjGC+xBR+5ZNZTRY3+WZapAH03xUKNJKOGfcCnI?=
 =?us-ascii?Q?wuRksKcqfChTKnDU8ids7HLsiw2HOJGvT9GgZd4s5Fyy8E5pSP9PsgUC4JUO?=
 =?us-ascii?Q?g1KK6oCulCOKwEvxaVMsI1wchkLfhf8yfJgCbgw6BsNiBkj+3kTqLnBDH8MI?=
 =?us-ascii?Q?0Ba1CDnZiQigDDF4quczCq37fbzjkchzr4ohikCXDgGn9dGN43+Z0Xt9udAr?=
 =?us-ascii?Q?qYzu52UwM2+EFX1+7Ld/gv+VdYAgbTC4UfFmN1l1kWwERUhuOZ4+8v4P8eJJ?=
 =?us-ascii?Q?vOvyZuhdYnsNWyuN4GLSjQQTcV4YSa4sZxfDm9XUDy5Hd6Ap/B/TYHZ/EsUp?=
 =?us-ascii?Q?eQUta65kRhxjyGxhlgv1eVzFs3KRkxxdjZmhIwvLQPAeNz4hB/0KsKCqvcLB?=
 =?us-ascii?Q?xEtQzG01NTfh3NDN+TMVONb/+KharbBIDuZJVGN5DKR6u94jL609a0O5RDx2?=
 =?us-ascii?Q?XJSwXmfLMrQM4eNDxMBi52m2LFX0E9vlM9oyrthCoE753mURBXTW3WhMEYYk?=
 =?us-ascii?Q?2WCtujaiHyLfsJecP7wbemlWE9S8xG7rxrzcKY6UUtuod4YMcqzvFo2YvAYN?=
 =?us-ascii?Q?fCGHEvR5xXBQ7urfBZC3aR0GC2we3nLyvAJ3ROyZk7VjvqLGWptPthUXq9UV?=
 =?us-ascii?Q?i/eRNhU2vg275QGUdlZ4LSl3AE3r3OovhuGCabDIs+C0Brb+TpAP55iUDX8E?=
 =?us-ascii?Q?AhiMRkFCMdDmh/iPsClGoNavBExNsDPzhd5C0zQUsIk/jNfrGIj1C0VOxAMj?=
 =?us-ascii?Q?wRS2gMz0+fo4PCKtcSLzQRfeTl7DINVhg2IkxHcUXb7j/Bw6wGb7BxsCPqM/?=
 =?us-ascii?Q?AJ2XMhIjos0jc8W7E3zY1Mkg9NFHlfaC5p07E2mtYM09u3528f0QHRfxzSVM?=
 =?us-ascii?Q?s+1ir7q3b0G2x/JFOPi6CbZm/9Sn1974/7Fj3gRqg+oPrhFEw6Mm4yjhZEVJ?=
 =?us-ascii?Q?GR/aNvuZwFEaL53r3EgCwFMN3kCVs7c8iB9ylcD25fxBYrP9GgPa8HKNs2NF?=
 =?us-ascii?Q?599RZ3OAa4SV1ApTwJ9SReV8SnrjXR0pQk7Zp+VX6OrgK3Cb9O9KKNbhi609?=
 =?us-ascii?Q?66SVZJ1oChXQl/kJpCAM9C5i/6WVVOnuilpGsrjua/YjoBF0fvcrmr9w9vqR?=
 =?us-ascii?Q?RxzHgykgqNH0IovYWI7VCbiHhHfq?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 12:50:37.6419
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f53b844-1d71-40a4-0de5-08dcdb05284f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6873

To talk to the GSP firmware, the first step is allocating a GSP RM client.

NVDIA vGPU VFIO module requires a GSP RM client to obtain system information
and create and configure vGPUs.

Implement the GSP client allocation and free.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c | 58 ++++++++++++++++++++
 include/drm/nvkm_vgpu_mgr_vfio.h             | 10 ++++
 2 files changed, 68 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c b/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c
index e98c9e83ee60..a0b4be2e1085 100644
--- a/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c
+++ b/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: MIT */
 
 #include <core/device.h>
+#include <subdev/gsp.h>
 
 #include <vgpu_mgr/vgpu_mgr.h>
 #include <drm/nvkm_vgpu_mgr_vfio.h>
@@ -43,11 +44,68 @@ static int attach_handle(void *handle,
 	return 0;
 }
 
+static int alloc_gsp_client(void *handle,
+			    struct nvidia_vgpu_gsp_client *client)
+{
+	struct nvkm_device *device = handle;
+	struct nvkm_gsp *gsp = device->gsp;
+	int ret = -ENOMEM;
+
+	client->gsp_device = kzalloc(sizeof(struct nvkm_gsp_device),
+				     GFP_KERNEL);
+	if (!client->gsp_device)
+		return ret;
+
+	client->gsp_client = kzalloc(sizeof(struct nvkm_gsp_client),
+				     GFP_KERNEL);
+	if (!client->gsp_client)
+		goto fail_alloc_client;
+
+	ret = nvkm_gsp_client_device_ctor(gsp, client->gsp_client,
+					  client->gsp_device);
+	if (ret)
+		goto fail_client_device_ctor;
+
+	return 0;
+
+fail_client_device_ctor:
+	kfree(client->gsp_client);
+	client->gsp_client = NULL;
+
+fail_alloc_client:
+	kfree(client->gsp_device);
+	client->gsp_device = NULL;
+
+	return ret;
+}
+
+static void free_gsp_client(struct nvidia_vgpu_gsp_client *client)
+{
+	nvkm_gsp_device_dtor(client->gsp_device);
+	nvkm_gsp_client_dtor(client->gsp_client);
+
+	kfree(client->gsp_device);
+	client->gsp_device = NULL;
+
+	kfree(client->gsp_client);
+	client->gsp_client = NULL;
+}
+
+static u32 get_gsp_client_handle(struct nvidia_vgpu_gsp_client *client)
+{
+	struct nvkm_gsp_client *c = client->gsp_client;
+
+	return c->object.handle;
+}
+
 struct nvkm_vgpu_mgr_vfio_ops nvkm_vgpu_mgr_vfio_ops = {
 	.vgpu_mgr_is_enabled = vgpu_mgr_is_enabled,
 	.get_handle = get_handle,
 	.attach_handle = attach_handle,
 	.detach_handle = detach_handle,
+	.alloc_gsp_client = alloc_gsp_client,
+	.free_gsp_client = free_gsp_client,
+	.get_gsp_client_handle = get_gsp_client_handle,
 };
 
 /**
diff --git a/include/drm/nvkm_vgpu_mgr_vfio.h b/include/drm/nvkm_vgpu_mgr_vfio.h
index 09ecc3dc454f..79920cc27055 100644
--- a/include/drm/nvkm_vgpu_mgr_vfio.h
+++ b/include/drm/nvkm_vgpu_mgr_vfio.h
@@ -10,6 +10,12 @@ struct nvidia_vgpu_vfio_handle_data {
 	void *priv;
 };
 
+/* A combo of handles of RmClient and RmDevice */
+struct nvidia_vgpu_gsp_client {
+	void *gsp_client;
+	void *gsp_device;
+};
+
 struct nvkm_vgpu_mgr_vfio_ops {
 	bool (*vgpu_mgr_is_enabled)(void *handle);
 	void (*get_handle)(void *handle,
@@ -17,6 +23,10 @@ struct nvkm_vgpu_mgr_vfio_ops {
 	int (*attach_handle)(void *handle,
 		             struct nvidia_vgpu_vfio_handle_data *data);
 	void (*detach_handle)(void *handle);
+	int (*alloc_gsp_client)(void *handle,
+				struct nvidia_vgpu_gsp_client *client);
+	void (*free_gsp_client)(struct nvidia_vgpu_gsp_client *client);
+	u32 (*get_gsp_client_handle)(struct nvidia_vgpu_gsp_client *client);
 };
 
 struct nvkm_vgpu_mgr_vfio_ops *nvkm_vgpu_mgr_get_vfio_ops(void *handle);
-- 
2.34.1


