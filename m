Return-Path: <kvm+bounces-29290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D7FD19A6A9F
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 15:41:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C3561F23632
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 13:41:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17F411F8908;
	Mon, 21 Oct 2024 13:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FNUUdWDh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2E411185;
	Mon, 21 Oct 2024 13:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729518077; cv=fail; b=ZOljvh0ofaR3Rrvs3TY8BIi5XL8l3I9MOI82exMiC4kfAJUZRWK802Yp1m2ua6DzFxIWERNzUuqI4CU0hJrPgDT2fdjyLYb/wl/oa0SxGylhYi5+8FoAcadR+HWcaWBhKeelREAwNho0pWunpvzAN1q3wZtUl2N5c+U5OlD6KlI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729518077; c=relaxed/simple;
	bh=Rf1RHoaCf/6Na474D6SyfsJ9wRZ5SBLjPmdsEE8j3bo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jUzfTeeyOmyj8l5B/EMCQpN/4iV0L9ScTvOjktNYcHPHDUH1XcvnqPERgoawGdob12cfXZPC4uICd0wQ9j/gRP8rqbdSJAOqSsLYSclofhXu7Lq+ljx2V4+rBKrjSPTEZ4/lx5sjr9c0NNxxWYyEY3U80rf2jGXNZiOckUq8xyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FNUUdWDh; arc=fail smtp.client-ip=40.107.94.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=irQJ/aNR9Bnz+QqglvKnOb/yGe29gPQya5JjTRuHPeZ5TkctqCC/w2M20R5Doqltq7PNim91rvO6jUeGokaPiKEUvfbOFHIxplgE2qdyNyeut8sMKUOx/osQBeb3kajncJtOG9sLSNCdaJ6jU5B8mx/zi0nnpMD/PlxKjUKM2CvXzN4KCLg1ueIRBz896KVA1mLaXfm5Ii/edre7xJ0JMBbDqZDG+82X4L3sUzpnjSCQC8hTwXqdXSt8Vzz1i+qdCT5gf5kHZyjBt0VB1lnyxVzUkq5xI1XMmeFCD0mpZ/7UynkI0pVmoKxfz9yUJQ/XfO8PL7hLcXHxqJFtnUIcqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jDNjLU02G8PpOuJ6Z9jxPjx5558biv/L88IuCeaadmo=;
 b=UpD0NPVcigooKU4CwljZ9m8/8Im8YzHReyaAuc2bMelOo5nEcJ0KCLxDzQdb3YIdM0QGShmhM0eoDvB3l5RY3qLMQjYss0pZOEQ60sfJSZwlCw0U0gKCj8DKPtfNTd7FUsYcdHt+C9fhL2lowAAtY6X8QNBJb1z51jxtr1wX0gp8HpyiLrra7mVpJdUMKWi3/qGpxTtE1YWj7vBCLP+MM1q/v1T6xdsBgmwqYjBSqq3OEgmMldnlnoo6UMxSNSK2Uj2hrMZDl4g9aaPa7yRKWlyMyg+ZPLTsiskJT5YOmnR1QJD+ojW+neRonW9Duq0UzK+kNt4859cMCszJXpfD+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDNjLU02G8PpOuJ6Z9jxPjx5558biv/L88IuCeaadmo=;
 b=FNUUdWDhIWgU3K9TC5nMaMO31UqU4hhhXZtGP0YWiw6UF+5tDmuTil77FFtQka7BhXa20c29qn8II9pBIJbGq6LeCQMn3K3qHDoqWCXPu5XA+eLS+ZwIc3yPGb/5IlzUGdL+tz/XtsybWdmxNDQ5+9xitIWbG8WUrJG5445WvOp3kVytd08VQF4BgDEwOhvmLzuSCCBCqMgB1nAQFMgSZh7rrhBRDORmbr29V27hxRTrF8cgfpQHZRc5I1bloKlKQHFLK5wCihHN9KAgsRqS4J+PX7SJTfhTCsEHbCRSNqCjwywVCG7h/4LvXVMyfsgNxqT8uGgZzjZ/5LKYPObWkA==
Received: from MN2PR04CA0026.namprd04.prod.outlook.com (2603:10b6:208:d4::39)
 by MW4PR12MB7263.namprd12.prod.outlook.com (2603:10b6:303:226::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 13:41:12 +0000
Received: from BN2PEPF000044AA.namprd04.prod.outlook.com
 (2603:10b6:208:d4:cafe::7c) by MN2PR04CA0026.outlook.office365.com
 (2603:10b6:208:d4::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.26 via Frontend
 Transport; Mon, 21 Oct 2024 13:41:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF000044AA.mail.protection.outlook.com (10.167.243.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.14 via Frontend Transport; Mon, 21 Oct 2024 13:41:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 21 Oct
 2024 06:40:54 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 21 Oct
 2024 06:40:54 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Mon, 21 Oct 2024 06:40:50 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, <virtualization@lists.linux.dev>,
	Si-Wei Liu <si-wei.liu@oracle.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Gal Pressman <gal@nvidia.com>, Parav Pandit
	<parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	<stable@vger.kernel.org>
Subject: [PATCH vhost 1/2] vdpa/mlx5: Fix PA offset with unaligned starting iotlb map
Date: Mon, 21 Oct 2024 16:40:39 +0300
Message-ID: <20241021134040.975221-2-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AA:EE_|MW4PR12MB7263:EE_
X-MS-Office365-Filtering-Correlation-Id: 66cacbac-bf91-4b5b-a6f3-08dcf1d606c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TP7Z3vVDh6hOFfgoWMpl26eN5qCmdSfp943kCNlmkHEt3qglS2rwKhIywyWV?=
 =?us-ascii?Q?VxjM5Qf+R2Fjz+/8QJbSiC2acdrKyZhhQwVJU45FnidzQYw8HJFyTQpBJgLs?=
 =?us-ascii?Q?pFzsHJt5MPxZrInvFpI7tsw8+hPF2BXdoRkve2UB+PwiCz4IFf1IoKYSoQx5?=
 =?us-ascii?Q?lDDJl3prgJi3+gWwnSkBJ7oCrcV3vQF7F6wbw/Pr5hpm+/kuE2EUTZmT74R3?=
 =?us-ascii?Q?rLopgR/D3AwgaZvxP79RadO+hRgPQi2aww24RaO3IDmVnpk8LXU4AdGwsZZl?=
 =?us-ascii?Q?D2OJNkLVrFCdAbvTytM+l3ODLfhk3DwjDmTVy3gPB579fAgui85iTCLfvQq/?=
 =?us-ascii?Q?ATRoF2tLu65S1QtfkN+Tf5EbZ4/nPXzSiAAUUYZmMBegtyIzIdmMe3G3IcGD?=
 =?us-ascii?Q?nmwQ40dwRkIbSKSKcjiPsRoxqy3ysmTMVfTZIUh8zvI9jtYSDihN1heVEZ5o?=
 =?us-ascii?Q?dFuYMnuqNnYnNl/iKQFgzCtpOLeFpNa+0mZUk1ddseh99+SmQSqL1S3Oz47F?=
 =?us-ascii?Q?Yc8VszNZQIs7B4dePPE7SqR4Aim99a6HBMeUjI3mLxZyHr4cNlMWmmcp36u1?=
 =?us-ascii?Q?zlULlHj2xNZ2yTeSuK4MhT7vEmNNX240gp+coPFjVpTAvXvyXrDrDKS91+ts?=
 =?us-ascii?Q?hqpL7x1d+K8my5jTiZ8SmcqFcllBvx4hnOd8lygFCqamBIuDWJUfkMP3gKma?=
 =?us-ascii?Q?WNzuR5dtaAnu7yxWM4rulC87c5HeyrobpygWP0HO2SIr+uQBHsN+7p0mH/A+?=
 =?us-ascii?Q?DCX/tIQ4d+U8HAuquWISh7+82sIoMfZhgbgbhDntENoJ9rwpgco4SaJifw8I?=
 =?us-ascii?Q?d7X4WYkqDV6rTAzVrd3ymZCG6ysxdV99nSHY194lM6eX9LG65yj0+LJUQc44?=
 =?us-ascii?Q?rdL0FcNmSA2JsyTtaFF8N22P2av4Gb5Trfgi6SayPQqT+y59eVOclD5HtTqt?=
 =?us-ascii?Q?YtFv7Cpkh6L7M7ALk9AcfzFERJBYlYVpvbC5NqAoxn+YfrPogCH8URtz307E?=
 =?us-ascii?Q?1qNy6idRzJAcZoAw+yzCP2o1XwO8+qIEwJck9vem52f+GLgPyf/9+vzV3Bq3?=
 =?us-ascii?Q?6HcxyIKOuz+VP96AcbzRJ7iZj4QL7crMlWMwD4GpJ3Pj5pZZeWeLIE8yg9fO?=
 =?us-ascii?Q?eusmMfZZw6duUB1nvGNh+amJDSyEBEdHHV77xxLP958ZUkdpopepUvEPLAHw?=
 =?us-ascii?Q?8ZaTPvf6MLbZS6WOsxpXQy5iNdsIx7X+3iDgnD94CRUY3obk/9UYDSC8n1jd?=
 =?us-ascii?Q?Xu6pVqzCyyr1AQKe0GPUjUt+kEztI8yYRG08dmzXR/yrjalUszC7yu4wlvon?=
 =?us-ascii?Q?Hngu5vnxOx9fXuZG+NXLjeX3OQycFN6X6pGrxm9/pHuQfmGhoZv39MYARRmS?=
 =?us-ascii?Q?Ig9PWObN4egtemKtdW389NLhwBY1B8eb+c6/wdisyBw1tswRhw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 13:41:11.6583
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66cacbac-bf91-4b5b-a6f3-08dcf1d606c4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7263

From: Si-Wei Liu <si-wei.liu@oracle.com>

When calculating the physical address range based on the iotlb and mr
[start,end) ranges, the offset of mr->start relative to map->start
is not taken into account. This leads to some incorrect and duplicate
mappings.

For the case when mr->start < map->start the code is already correct:
the range in [mr->start, map->start) was handled by a different
iteration.

Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
Cc: stable@vger.kernel.org
Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/core/mr.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 2dd21e0b399e..7d0c83b5b071 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -373,7 +373,7 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
 	struct page *pg;
 	unsigned int nsg;
 	int sglen;
-	u64 pa;
+	u64 pa, offset;
 	u64 paend;
 	struct scatterlist *sg;
 	struct device *dma = mvdev->vdev.dma_dev;
@@ -396,8 +396,10 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
 	sg = mr->sg_head.sgl;
 	for (map = vhost_iotlb_itree_first(iotlb, mr->start, mr->end - 1);
 	     map; map = vhost_iotlb_itree_next(map, mr->start, mr->end - 1)) {
-		paend = map->addr + maplen(map, mr);
-		for (pa = map->addr; pa < paend; pa += sglen) {
+		offset = mr->start > map->start ? mr->start - map->start : 0;
+		pa = map->addr + offset;
+		paend = map->addr + offset + maplen(map, mr);
+		for (; pa < paend; pa += sglen) {
 			pg = pfn_to_page(__phys_to_pfn(pa));
 			if (!sg) {
 				mlx5_vdpa_warn(mvdev, "sg null. start 0x%llx, end 0x%llx\n",
-- 
2.46.1


