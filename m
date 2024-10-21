Return-Path: <kvm+bounces-29291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EC6A79A6AA2
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 15:42:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DF301F22F89
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 13:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E32151F9403;
	Mon, 21 Oct 2024 13:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KxTN4t4l"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9D31F8EFF;
	Mon, 21 Oct 2024 13:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729518081; cv=fail; b=ZXZm8F2WOc0V+oEoDV/GGEq5nxId6Yi9OaHahBaQZVA+u+86E+JdGwzdgZPIWKGYGO2wVvknJtVpd4oW9M5llvonkj3CtPKQNWbGqCh+YRtXyaPxZZumQ3miCs79EHLqW8n9cOD4+nq74Hd3VR9aOPkuqPVxNqv5LmhEhfx8e14=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729518081; c=relaxed/simple;
	bh=xrRRikhqvPyy5Vv3acnh5jRxnJ3CkacGq4Xq8EZdx9I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=evdq7Fxtq41rFqHZjwJv6GvqKno81J/UvSDYEMtXwLAk3D9bXuQmdj6qDT3szPjT5yrbQdkmvFd+hXZKFNXLeekMbDV29hbAbYQUjNeF3t9Oj5+VK3qjEbITfgP4sPCzxBqO64UVXFSp2aqPSXtVtTRpTDCcZt3AqY/0nqEfa9k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KxTN4t4l; arc=fail smtp.client-ip=40.107.237.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YftiulqBK2KYyjD+cpxMvZkRkY1M2GirEQQf7jCOdRLXkgry/fVDjPPEOMuEOpqUm6lJjJzQWC4HTBxs+29B1IKMKboZVdMvHkzkywddFiBNH3zIfuouGdi5+quk4mxFWQPqg5p7euspfg+5/hK2Io/SUczys2fpk5jRuC6m/PAc9wj8mIkoFmMgndpUDLLT8A7xvJInYvHkkwdwCFrsBoRsLJ8m90BUy+eUM6t4d8eCSqlrSvzDWZT9FPTcdG8wwZAzhrXeBQkniEHPx3Pf8GMjEJSsVrND5B+tUmHjS3LDAsMUHCsLYku7T78nLlEU8VKBQiUU+l0PmLOrdNKQVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0HdS+0ODh3Mj8EkgoOiXEfHPfYf4+5ZG7Xpgrtzf08g=;
 b=x20h7XOMrZe9v7C44qPrRsNMuz/x7vg5nSw3aK7SeoGejfZ/PBQcMS3eiTlJNz0oAvhY0Fnwc3s4Cs+yeTfB9BsrZmtVk0aTEQ6YVk3UgM20PkN8Iv6dsbQi8yt9a+BigkB3hPFb/RRphkzwkfcfzO3u9HXwCb1nDyghdk2HTVhkFUeD/qTfzhWd67/+hlPvJzWYrMtnUMWtB3vpYqVO43BBDG4R/AzS2XCsCso+kFxtqNuhXwnliRzd00EV2c9JhS+h/ncCgqmft2K6EltsbLSgmaG/aJLybd1tcnTYhOx2jb2AVs6AvFzwQLKmxrwUgR/CqA87ryRFbLWqhn7kGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HdS+0ODh3Mj8EkgoOiXEfHPfYf4+5ZG7Xpgrtzf08g=;
 b=KxTN4t4l5/TdvLp5hOmpVjkQwaT6PuYNoS3ChZK6GqzmI17u1CQV8DvgG37jHGT2fH1GrJqHz8ev7SjU1i31j+WsQCiI0NjeK8hUvdZeeb1+P4S6zHRVsB/Y2bPef8HRLkSE5/bZs1x8POuIDj7FBTmNOCoFND/aKDNFBT0q6jzj/N1c+6w0LHBSJs7L6gE+8Bp0WfcmL/RMudO29xjaPX2FwfFAcCAzirtWN8HX+9ayRoAqFLwT42oNncwSfXIPlMxnTCVIVpaXIuspf2dopdPXq78xpTVrELtNSXrZK+lUTR936/DEjP2mFoLjm6CqIjiDENyYNuNgd1FVShElEw==
Received: from DS7PR03CA0288.namprd03.prod.outlook.com (2603:10b6:5:3ad::23)
 by DS7PR12MB5792.namprd12.prod.outlook.com (2603:10b6:8:77::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 13:41:15 +0000
Received: from DS3PEPF0000C37E.namprd04.prod.outlook.com
 (2603:10b6:5:3ad:cafe::f5) by DS7PR03CA0288.outlook.office365.com
 (2603:10b6:5:3ad::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28 via Frontend
 Transport; Mon, 21 Oct 2024 13:41:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF0000C37E.mail.protection.outlook.com (10.167.23.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.14 via Frontend Transport; Mon, 21 Oct 2024 13:41:15 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 21 Oct
 2024 06:41:00 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 21 Oct
 2024 06:40:59 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Mon, 21 Oct 2024 06:40:56 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, <virtualization@lists.linux.dev>,
	Si-Wei Liu <si-wei.liu@oracle.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Gal Pressman <gal@nvidia.com>, Parav Pandit
	<parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost 2/2] vdpa/mlx5: Fix suboptimal range on iotlb iteration
Date: Mon, 21 Oct 2024 16:40:40 +0300
Message-ID: <20241021134040.975221-3-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20241021134040.975221-1-dtatulea@nvidia.com>
References: <20241021134040.975221-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37E:EE_|DS7PR12MB5792:EE_
X-MS-Office365-Filtering-Correlation-Id: 4122f495-1e9a-452f-1586-08dcf1d608da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZStn1M40ojNvQEqli+4vNg8522gIXy70ceu5E2pLIrOs4SZ6XRa4QdByJiga?=
 =?us-ascii?Q?/pZC/rMHTeuJWiWqaJ1xNu9q07yhvb+QEbqptELxIJLoeTO0vF7s34jFmvcs?=
 =?us-ascii?Q?eKV3ldWpfA/LOTVALDqk+DpOYc6E33qfXAntjqkEru5dPPvsQ44RyohBnuwM?=
 =?us-ascii?Q?DXbkcvil5DeByg0ZbN+Mey3dzXZB1s6AKsWINb6HWJGxAU/7rdCiSpt2DuBm?=
 =?us-ascii?Q?yVfhYHdrbMQDQ20MCpVUHFXMvWj/nIRBvtCwSNmN3PZZoCjBxYyupjWxJ2mK?=
 =?us-ascii?Q?rzaJX6j6CMUoL5V+OqHTVuB5zidb/vqMnCNVzjlTTOzbNJE6NjXV8/3MC4AG?=
 =?us-ascii?Q?rqdFgDyOgL1v6AUQ51WbvpTOa6TmfoUT3ZQiEehQWtWFCGWPnPf1bwT0ci02?=
 =?us-ascii?Q?MwJmDYbZlNI/LM6faNHgbjG+eBnWgs+P3Bp8EjiMzgzIVVQc/o9/YFeJe2nQ?=
 =?us-ascii?Q?NUMjRCq5hmEZsEBVN4jrWL0fNtWz0pWeaeRFGOHbEgzyzZ8IIv3esGFJa34a?=
 =?us-ascii?Q?TBWK7P9ZdIWy+Zd1N2ogwnairJQOUnMnV3MQIDMaEitm2ylHV7asr3MCDhlN?=
 =?us-ascii?Q?DCKduP8BH6kYh4LlRqpCM6WwX31vgHV707H0wMk25ncpy6r4ypNeXSzvzXqN?=
 =?us-ascii?Q?DKUQblqoFlsIT3dmqdYiZPRAJuO/5nl9oNgJbAzfM0fzfXzU/HmAFzXGSog6?=
 =?us-ascii?Q?r1dedvC1szleWMqPJyfVCvTtVv8LoP9lqbf/WjbuagoN+WBvXeypGm2Lg0vN?=
 =?us-ascii?Q?Cb80AOKy5aHM4Pzk0EXGH1knZFvFW1b9E1RzRcO1AzNiPocjX2YtTfYujde7?=
 =?us-ascii?Q?pt8eZ/pI0UtD64OvEgHLKQXLKq86sReTyBZ3/Dfd1JnE+lD9Gyp55KBIKo5M?=
 =?us-ascii?Q?3TaEBSf16/0PRjZDHMHKb3874bpFwOJ0JUzs2S70HclS8Av6kMKM585cIHIV?=
 =?us-ascii?Q?bA4qZkAUTQFsXV0BO9v7kNcUPz1KkcMubOps6buN6NfG3vErH3piQOpgsVl0?=
 =?us-ascii?Q?48hMRtwc5LWatMIcak5FGfbXt1z1aYhY+5bJBFJEuU8VUfiLPJqgGI2KiTmK?=
 =?us-ascii?Q?97mzX/ffJMiDo8F59RvGi70JohLwWs48nm+bh1UDsOM/wEGVelL80MWxwUfI?=
 =?us-ascii?Q?Ww5hkP6oQHnC6TXH68yeWqSqfdkqBOWYfpt2QnODGjGstntJgeUoxg3LM8YW?=
 =?us-ascii?Q?qK6OJ7hWFojIXm0rKoyha9URIB/T6xjbosoaytJt7VJrYnboDq0SvytQbl7l?=
 =?us-ascii?Q?bC1ZcFGXgN6YCKS2GORV/c0C9tR9rBuGebGWKq5w2tzYWspO0neShoL+AVDS?=
 =?us-ascii?Q?L+o+MJz229xMJuMPoO496p9j+TDesblXi+HjzxU8pTg9dnCgrKfIrg6/xPcu?=
 =?us-ascii?Q?LYf1Z8I/oqCOOqZPIdG9E77qHafa9tnCIwW7JTnqimGs1V6yPg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 13:41:15.2010
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4122f495-1e9a-452f-1586-08dcf1d608da
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5792

From: Si-Wei Liu <si-wei.liu@oracle.com>

The starting iova address to iterate iotlb map entry within a range
was set to an irrelevant value when passing to the itree_next()
iterator, although luckily it doesn't affect the outcome of finding
out the granule of the smallest iotlb map size. Fix the code to make
it consistent with the following for-loop.

Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/core/mr.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 7d0c83b5b071..8455f08f5d40 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -368,7 +368,6 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
 	unsigned long lgcd = 0;
 	int log_entity_size;
 	unsigned long size;
-	u64 start = 0;
 	int err;
 	struct page *pg;
 	unsigned int nsg;
@@ -379,10 +378,9 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
 	struct device *dma = mvdev->vdev.dma_dev;
 
 	for (map = vhost_iotlb_itree_first(iotlb, mr->start, mr->end - 1);
-	     map; map = vhost_iotlb_itree_next(map, start, mr->end - 1)) {
+	     map; map = vhost_iotlb_itree_next(map, mr->start, mr->end - 1)) {
 		size = maplen(map, mr);
 		lgcd = gcd(lgcd, size);
-		start += size;
 	}
 	log_entity_size = ilog2(lgcd);
 
-- 
2.46.1


