Return-Path: <kvm+bounces-27249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B8A997E1A3
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 14:51:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C66DC281497
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 12:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BAD86AA7;
	Sun, 22 Sep 2024 12:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ETTCLKLQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2075.outbound.protection.outlook.com [40.107.223.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE56B2F37
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 12:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727009438; cv=fail; b=COGOJPVmMJ1XooObrAlL0sLox56u5+BAFzWZ2sYOz4yIVvy+cF3CtcpoUzND8tpYLuSRLfOA2ojvvn5MrBbAZfwGllDbIgIcIDihKvswQFe9rTcj+auiZ0KFC2u8Z09nl2NXB6BZEp/FH0PqR/HBqvA01/lcQRDXZBEN5ZQwNNo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727009438; c=relaxed/simple;
	bh=UZqKIIMgTl16rdztC/8Qg9xASFhOKf5zdzk0F6+Yk58=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ie0E9dp1eSzP6u+E8ADJvIbuokZ0VzAgtMq366YKPbwhii65DXlqogrm+EviEY11UsmfeoEupy3a2w/RPG3Ahq3HU98asZ/aiNdfI9IZdfQ1pYlzjNKrOWHSI+hNrK0qs2Wo9GSPifv7SQq/pUWYRnsmAIQfvW3NcxTXrEo35Bw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ETTCLKLQ; arc=fail smtp.client-ip=40.107.223.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kSDel/5+XoQquJsDuKSWVq/D5OzrOARaFfzY5XhMM31pk4unpYkvX8E/wza7kHQ3+uv3SyZMRZ9UDo8zS6BsKpHa8yduFxAkVMF986dSJEclotq4K+zBFrFTLWyLz22lyxR5qhwwOHX7dJKiuZMBqiCiw91D6R5ske8ducc5qG5Gif1jCklIlDHYpbJYzdSP0Lh9yjsNW7W6bpjBCePaamjnQMUj/ggtVPK7dIS7FSXK+3TGyxMA5zOYWZz+w7SajsJz9EGt9FW2rCTTkFkAQ7Hy8uUfmNzcXiPZwJKZHHHdxb2w3aMcQs0nELj2TxkitP4UvohlqbSt25RSy6UcVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=atN0vQ70Ykwkr84OfTt4zIgErURFQak0rcSiUa4BZIQ=;
 b=C5ESgQRAA1kj/xM6/QNtClyJ2gUMKBckbY8SG+TlwVk/vnkcd4tlnvy1FjyMbrpIMqHedjXlirFiMBACBya4ePCP2nZXaXlxx26bsfmIkDSnGGufgJfr9rb1VAmMsXCJTU7uhxnZ5WMS6m5vlkg5XeSlqJCxOAqkfRnKDDYoUUZpoQGsFkSFVjSLQDjc7Ndjiq5x7QVVKxowz/UM7/1uDEJTDKLgmpzcLp2KqWlYxKFA0qk9cugQeQeDe4dxbHOfX28jv6yGfomZyAaAHUlt55qfSipDnjFLsjzxdA8wMHtUDWFmP4P7dvJgqJJtUySCMUdRvM3tXe2dnjkEixEVKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=atN0vQ70Ykwkr84OfTt4zIgErURFQak0rcSiUa4BZIQ=;
 b=ETTCLKLQzG8rb9UpTM5C0vUkcMthNO+TrHlH/xQymdAJDzhJN1fOsA6ZuXWEFuFWLEM1ppf1L0yzwOgle6wW6IUkyK0vj9ir9Dy4WZE5Y2AIdrN4oNKaUY+QNl/hKwqYi/7HIfdcHJCWbiPx/aAAGN9tOMeDDVHDz0inpsSznClWyWYx++yuLQvLJnzq0dPh8tm8Acj+IFic0CHtKY1QclwjDZ8XenMHLMRQKUcGqHVv0KqaJId9wcgJzksaB+OhMQBsL5A0E/BGp1cUr2nn+ClV8DiBVpmEKibCspXl6yVyXjxcJ3GEDl0+YUv1s2rrazBh73aOgqody8ZuR+h0NA==
Received: from BYAPR02CA0044.namprd02.prod.outlook.com (2603:10b6:a03:54::21)
 by CY8PR12MB7267.namprd12.prod.outlook.com (2603:10b6:930:55::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Sun, 22 Sep
 2024 12:50:33 +0000
Received: from CO1PEPF000075F4.namprd03.prod.outlook.com
 (2603:10b6:a03:54:cafe::8d) by BYAPR02CA0044.outlook.office365.com
 (2603:10b6:a03:54::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.30 via Frontend
 Transport; Sun, 22 Sep 2024 12:50:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1PEPF000075F4.mail.protection.outlook.com (10.167.249.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 22 Sep 2024 12:50:33 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 22 Sep
 2024 05:50:24 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 22 Sep 2024 05:50:23 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sun, 22 Sep 2024 05:50:23 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <nouveau@lists.freedesktop.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 07/29] nvkm/gsp: add a notify handler for GSP event GPUACCT_PERFMON_UTIL_SAMPLES
Date: Sun, 22 Sep 2024 05:49:29 -0700
Message-ID: <20240922124951.1946072-8-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F4:EE_|CY8PR12MB7267:EE_
X-MS-Office365-Filtering-Correlation-Id: 63bce7cb-faf2-4aae-f20c-08dcdb0525a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SJl2PdJKQFogIlDl2J9ktEDNklMK9wLfQA7FrRXC7gwh0Dyt0Nv08dFsg/wj?=
 =?us-ascii?Q?33CLv2DFrtAmj2X2PUqwsyTx4gYupUxWDYYJpFzgg3EFfbZ9fevuMGHSH2r1?=
 =?us-ascii?Q?YjpkAT7ef6xwrIO1e9HJuX/sgp6ktfi+LwXPE8GiAx1/zwfogajNOHuFC6Da?=
 =?us-ascii?Q?HVDxrsOeRBBSeTQ022Z1gKEd0dju81RW5VJ+melB1DMaGhqijgu8Dp0ZJSbg?=
 =?us-ascii?Q?LusFG3vXTUnT9Oo1jxvAxHqpGPjCzYg3C9stChq8aVFII8suLthD4ofVI3wT?=
 =?us-ascii?Q?zvCfA/f2wlveuFVgfbnJmkOARV9YJ6NdXJU09pnYU0cyhMFHm3kli2nbdbpC?=
 =?us-ascii?Q?JeT1VRViBcrKGUA9j/1nU8OaVLQEGrRHEocSXD+VpbcRHRgiIE3vKusqjh5E?=
 =?us-ascii?Q?0Nz0lyQk2/YBRvdlzHva8FY9qu6VB7aUY61+Wz2xdygYCink+F9gqW5B5eaT?=
 =?us-ascii?Q?jowKFWIG63Hgcu3N3+fk4nvX5iatRKEjWqjq/zY7BetGCRZInlifXRyRWPvk?=
 =?us-ascii?Q?7Sik8Hg/ubdHek8ChdtqmTKZieDCRaK0L3zn51Obop8/wxIRyP0QXrgAZRUq?=
 =?us-ascii?Q?n8vCSdtEH9piAkL+JfUnjPlZrMultHQLS3rswcsHfhQlr4/UCOxlhSsEIDjC?=
 =?us-ascii?Q?eyftjkVBL9YZ4CGOvvi5KIfZI+mCIVpw+W6lQ62BJVWTF7vkqmhlc5WSST5k?=
 =?us-ascii?Q?aG27OVV7HWIAxz3kdbz4xdMtVz9hPzgaNnU+1BVnAXN+NCv42z9Y4T3M37Mx?=
 =?us-ascii?Q?xrkGlKIfuyMrBJsAmNwM4t98ZC0L+pUP1dVJWJcAMgFVirg4qOlN3Qcg+tgo?=
 =?us-ascii?Q?IbamFkDMR/Za7uRmnk1Ka9RkVVWZlzzHg9HYHroYIlc9Q5RDsQ4UqEBQBsJU?=
 =?us-ascii?Q?cd/zijl88TZbn04yfAUazWiAH8VnSbJP1XaqE7DDb2S/2sWRi8UFnnYcG9sj?=
 =?us-ascii?Q?e+T9PTi6HtdDLA8hMgDWWmEj02uB8fpoI5PCL4e2EQgN08L+kN0fzpGboYlU?=
 =?us-ascii?Q?YqEU0xL9SLUnslSKyjzsUTnyJSb8A/yiwl0Jbc3dMmu4fIQdm/wPoQYY+2za?=
 =?us-ascii?Q?NBzEjuGtCoAozd5NwnclrkCCaGetzjmkpolVPG5ixulPWUohwButryaxKoOH?=
 =?us-ascii?Q?CTszz51DhC7nY9LChTZPwE+ZtQhpUFQfSXjwUwgH+vWyVhQsU7sHp1131WqM?=
 =?us-ascii?Q?3EFCWdVAGQDhkDpK6U+tKX4HQwqpmnTO5DoentkHPu2Q67PWvnY9ivh0u53Z?=
 =?us-ascii?Q?CTO868WrAUz7qkhdw9SdyJZe5vicWDc1EqQfKwQk5Sbq1RwFUYC6JqAU0b29?=
 =?us-ascii?Q?HYxfM8B6tqIETv7V7+vNkW+KCOr/fWScugL0+RrLUEyqwanJHHcIijAZ+kiC?=
 =?us-ascii?Q?P1xmJt4=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 12:50:33.2044
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63bce7cb-faf2-4aae-f20c-08dcdb0525a9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7267

GSP firmware will periodically send GPUACCT_PERFMON_UTIL_SAMPLES event
when vGPU is enabled.

nvkm keeps dumping the entire GSP message queue in dmesg when receives an
unknown GSP message, which is too nosiy.

Add a notify handler to prevent nvkm from dumping the noisy GSP message
due to the unknown GSP message.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
index a7db2a7880dd..3eea6ccb6bd2 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
@@ -2628,6 +2628,7 @@ r535_gsp_oneinit(struct nvkm_gsp *gsp)
 	r535_gsp_msg_ntfy_add(gsp, NV_VGPU_MSG_EVENT_PERF_BRIDGELESS_INFO_UPDATE, NULL, NULL);
 	r535_gsp_msg_ntfy_add(gsp, NV_VGPU_MSG_EVENT_UCODE_LIBOS_PRINT, NULL, NULL);
 	r535_gsp_msg_ntfy_add(gsp, NV_VGPU_MSG_EVENT_GSP_SEND_USER_SHARED_DATA, NULL, NULL);
+	r535_gsp_msg_ntfy_add(gsp, NV_VGPU_MSG_EVENT_GPUACCT_PERFMON_UTIL_SAMPLES, NULL, NULL);
 	ret = r535_gsp_rm_boot_ctor(gsp);
 	if (ret)
 		return ret;
-- 
2.34.1


