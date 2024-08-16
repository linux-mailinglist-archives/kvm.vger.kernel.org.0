Return-Path: <kvm+bounces-24363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E953954508
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 11:03:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A348285564
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 09:03:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 699471442FE;
	Fri, 16 Aug 2024 09:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ui4w3XRO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2074.outbound.protection.outlook.com [40.107.236.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46EC13FD84;
	Fri, 16 Aug 2024 09:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723798959; cv=fail; b=f4h3VpTfzOoid3AbbpIkceOJYqpQdHGYLbeTOVYKKs7jESeUaGcsWfApZZMRT/s/EYSIKkb00Eh6fydLd+MOJDQrjZfkWZJ/DB4iWPZ/eOXjY/YjtIgwHjdMzWSon63jt/mdDx/mblwqPeDXaZpnNUjgRJkztDFwLUySP+s1f2U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723798959; c=relaxed/simple;
	bh=1aX/5HD1uM1/yrGzz+E9QEV0jPwgKYOms9V3USYM7nk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gGmy4C+LYirvEUprxZxy6xZT+22JG2rg8VjI26xgIWNvIiYO8shln7+qAKoFQwEPrFXnHASCsKd4TkWHUhMZVvDT/cEvUBpAwXjOhYbRALXeG2RT4DCxZxQAKouhGGv+lQDM4oqQ25eSoGo/uuymgFDBcfHNpw+fnhAvkI9GABQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ui4w3XRO; arc=fail smtp.client-ip=40.107.236.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PvPpmPvUuSQCz1H/uqdwNV6Y7Z4dVP9DWqdE2bsd68ko8P9IYsQUJZmyVAYXb3EXIPiLacGUkDAcHOMit7vz3xcOT/InDZrKMjsINws9HyQY9ADnn+Frrp44EOdhdzlgoh/UusIVdDFIZSrKdag/IhHxeUPtjUpq4aQyj5a3qZ7JdiMhd2oBal2ns591gN6p/vfv29WimIlxRDOLbZ/iTY/VuR3N6aHvr5wyBtDYX04KDq4ocKaPTZ8gsQkAYU+5S5BAgXz7CyIkdFjqXvqFueejQYNRY5fbE5MKCCFkOPu4T/gceO/s361ql666u4ri9gwJqWXZRnBQS4RFMeWy6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7HNbJZ4G3eSJS2iWpFc9qT1/7GEIi6is5UB2ZOXeayA=;
 b=tGcS0z9Y0y0SveAM2AWxPoi1inub0zI/EhdW9/WYVcmOi0V5ySMeZfDVgaRMRMJZFX/BF4qpjs4kHXfNsvJSJPrtB9MDgByxARdaWTr6NZp4bC1os6v/omh0cRRCQWP+I44AyzEZe7S3iWc291+4dzwzDlivyPErHY+JNzyrr9b6JP1SspaWf5bUvSEmryWC5IPMg1b5iKVui90KHO0arKDuIUsFw2O4vIoveJeXhTYYzE5Y/j7wA97S0h312HlntgEIYSc+aMZWVxo5F1zVcSMd1jOHk+4yr0jGE8X3J7M9MuIRDIuZO/9GIYC6Y91d+gDSkcjfz2M1CEaamjMzUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7HNbJZ4G3eSJS2iWpFc9qT1/7GEIi6is5UB2ZOXeayA=;
 b=ui4w3XROHr4KiZ5UR7u84ysm4PYg2qaWCMcNdoQERudFbBq1KCJlHPVqkBpBn6awn3DnnbZfmAjWE5EYa451wITn7jZbzeYFQrsCnjZdlHQBRnXIf369tIt78t30NPtqKm9Q4mw1mIPAE3STIKuKIz1RmDV7k5LK+bRNsVIuhvpRvGmmW7cjYxDyj4Avv8clNfH2jPIvpcMAbfN074Ea3ZFbqS8evo38pL/w/UelNlMjtEQ4byeayKjIhVAJMOHYzSZvKt+RIYQIKIzG30UIU9WX6iuNXnnCxw7kVEWRW/Y/brYt6IDw2hsdyX9enx0XCi3F22NbIQe6G26sxd94hw==
Received: from BN9PR03CA0768.namprd03.prod.outlook.com (2603:10b6:408:13a::23)
 by CY8PR12MB7414.namprd12.prod.outlook.com (2603:10b6:930:5e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.20; Fri, 16 Aug
 2024 09:02:30 +0000
Received: from BN1PEPF00004689.namprd05.prod.outlook.com
 (2603:10b6:408:13a:cafe::2a) by BN9PR03CA0768.outlook.office365.com
 (2603:10b6:408:13a::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.33 via Frontend
 Transport; Fri, 16 Aug 2024 09:02:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF00004689.mail.protection.outlook.com (10.167.243.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7849.8 via Frontend Transport; Fri, 16 Aug 2024 09:02:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 02:02:16 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 02:02:15 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Fri, 16 Aug 2024 02:02:12 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>,
	<virtualization@lists.linux-foundation.org>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Si-Wei Liu <si-wei.liu@oracle.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Gal Pressman
	<gal@nvidia.com>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Leon Romanovsky <leonro@nvidia.com>, "Tariq
 Toukan" <tariqt@nvidia.com>
Subject: [PATCH mlx5-vhost v2 01/10] net/mlx5: Support throttled commands from async API
Date: Fri, 16 Aug 2024 12:01:50 +0300
Message-ID: <20240816090159.1967650-2-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240816090159.1967650-1-dtatulea@nvidia.com>
References: <20240816090159.1967650-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004689:EE_|CY8PR12MB7414:EE_
X-MS-Office365-Filtering-Correlation-Id: 4556c9cb-f9bd-4fad-2a3e-08dcbdd2288e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WaGPe/ydXc4eMoQMNaVC4iQfaptMTFoaWIjPuHLi6F1Ya1pfB1x5ELc9uaRW?=
 =?us-ascii?Q?61sqUoMdqtaTPULWd30SWROfBgghhmX1gHIYzh6OwgPq1rw4iZdPx0zZcybv?=
 =?us-ascii?Q?miBeqNrXtC0BDM/M8ofTSH31Hqvu6AYHlppbSBevcT6bE19YIU7s8PUbuAer?=
 =?us-ascii?Q?qdUkkg0X9oB61JW/Cy4t1gS72C3fYFQL60oy2J8JibvOPHXVY3Fv1IwscMtQ?=
 =?us-ascii?Q?xJd9M5nAxzxSI3ujDzs8ZW65+i/pqOm9XO34ULetxsRtTZcdfuAtOpEViSJT?=
 =?us-ascii?Q?0J5Fc3FtZEsYcSc+GTZtuGfAqtaIODTcf0Jya6VqdI7zeITw6JlNl7wjIDCH?=
 =?us-ascii?Q?aQrG5eNcKnTIH0OhRHYyRWMeW322ErKPH2pmmxgIa9RHvTNXedw3bfNhKQEI?=
 =?us-ascii?Q?9NfJ6mI6hdu3AReTj5KFFl2yXq5gEZy+29USC7UgPDatj43mXYqlzLxLVBxT?=
 =?us-ascii?Q?pY5bbshj7mRsC3FP0tyvVvb1iBdjqr6IQV8NaGFCRChAkSxtnRoUfpdQAK4X?=
 =?us-ascii?Q?qOL+UDQ16UVKQjrpcLvmcQAo9OryMOqtloNnqT9r2oW8WWAtNAcI39tia/DS?=
 =?us-ascii?Q?42plrr4llYITB28tV75ZE2fTuwDKk7UiaGnX7+dvztI9KWi/1qb8UWwsGrBL?=
 =?us-ascii?Q?30VP5VQITNo/YGhHcYXQfaKJGhtahfan/bph+wngzFF87SQkfeKcBMzuNF7r?=
 =?us-ascii?Q?aslmy1pLaZF78B2sF/dWjXa0PSt0c0uP3ilgtPRd6Ved7+frV7F4kRYm9Tun?=
 =?us-ascii?Q?ggZw6IhmNVuZOGN6OtxPCw0mlGpcLAOtM2Lpb1AniAN7Kr6AkR8zBChc4f09?=
 =?us-ascii?Q?PAD8NFogdl6IxtHrECIRbl9TyEfm8P7GKNKLq3+Fyud/bWxaPjjt2OnwT4LE?=
 =?us-ascii?Q?sO8jaS9uh2HAXHGfeEZYp1ef4Uw2+qyE7SfcUFl9WRKoV1UQtxljDb5TWq9i?=
 =?us-ascii?Q?Pu2rleBeShU6SeLqO85o1Yrrsuww+Cl5G0rPbSvFCVd9WJxSAXYSEU6eXZzO?=
 =?us-ascii?Q?Ahyi5MEgeeS3TLuUtAaUfD8Y8iclMMPvQ+ZUtjr65tpAe/8mCwGF/t8aBv86?=
 =?us-ascii?Q?D2HK1ddq4l2Wa+nOZhTublY4lgNSh5vywccsgSlR5pXL90dT46D3XoTSV8zB?=
 =?us-ascii?Q?sawM22lpOGlijFvfvVk3Z3h75oJCbO490Tw9X9va7xKC0o41CHNADBqf2dH+?=
 =?us-ascii?Q?2LVUct4dVl0kZupaTTH+hR2ennk9/mGJyo4IC37mKOyzC/VX+RUp1NB+TP+p?=
 =?us-ascii?Q?CevJgshZptlRE59y98RmKYQrM0ex6QBa6j2of3Mf6GTj0qCKS0Iy1HPz8QCO?=
 =?us-ascii?Q?PgxP9jNlKpV1EWqYj+VwHJvnox5UyKFCNIx833whGM918SAZ53plsGt0QeUx?=
 =?us-ascii?Q?r3nB95RZLhJfMozmSdSHH1RLR/A+LZpSXh8a8ECblWE1SZWBganTo/S4bkLJ?=
 =?us-ascii?Q?3ew5DyyE9GJLFv+NkxueoachtsZdy96G?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 09:02:29.8611
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4556c9cb-f9bd-4fad-2a3e-08dcbdd2288e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004689.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7414

Currently, commands that qualify as throttled can't be used via the
async API. That's due to the fact that the throttle semaphore can sleep
but the async API can't.

This patch allows throttling in the async API by using the tentative
variant of the semaphore and upon failure (semaphore at 0) returns EBUSY
to signal to the caller that they need to wait for the completion of
previously issued commands.

Furthermore, make sure that the semaphore is released in the callback.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 21 ++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 20768ef2e9d2..f69c977c1569 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1882,10 +1882,12 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 
 	throttle_op = mlx5_cmd_is_throttle_opcode(opcode);
 	if (throttle_op) {
-		/* atomic context may not sleep */
-		if (callback)
-			return -EINVAL;
-		down(&dev->cmd.vars.throttle_sem);
+		if (callback) {
+			if (down_trylock(&dev->cmd.vars.throttle_sem))
+				return -EBUSY;
+		} else {
+			down(&dev->cmd.vars.throttle_sem);
+		}
 	}
 
 	pages_queue = is_manage_pages(in);
@@ -2091,10 +2093,19 @@ static void mlx5_cmd_exec_cb_handler(int status, void *_work)
 {
 	struct mlx5_async_work *work = _work;
 	struct mlx5_async_ctx *ctx;
+	struct mlx5_core_dev *dev;
+	u16 opcode;
 
 	ctx = work->ctx;
-	status = cmd_status_err(ctx->dev, status, work->opcode, work->op_mod, work->out);
+	dev = ctx->dev;
+	opcode = work->opcode;
+	status = cmd_status_err(dev, status, work->opcode, work->op_mod, work->out);
 	work->user_callback(status, work);
+	/* Can't access "work" from this point on. It could have been freed in
+	 * the callback.
+	 */
+	if (mlx5_cmd_is_throttle_opcode(opcode))
+		up(&dev->cmd.vars.throttle_sem);
 	if (atomic_dec_and_test(&ctx->num_inflight))
 		complete(&ctx->inflight_done);
 }
-- 
2.45.1


