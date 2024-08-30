Return-Path: <kvm+bounces-25498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11174965FC4
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 13:00:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB177283344
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 11:00:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A67A5192581;
	Fri, 30 Aug 2024 10:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="M75mCLYL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2051.outbound.protection.outlook.com [40.107.237.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F1018FDB3;
	Fri, 30 Aug 2024 10:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725015562; cv=fail; b=NBn+pIXbCpqwZaYRRrgKuyZQmyRZkvaFnvhoedGm82VFPVLoumTyRKmFx3mSTwhnB72Db8/M6kp9OhaF0LFOHb0Ymxaxw7s4aZlXDV3KhRCKkM/jep4FRHj0OkfF6AlQJgwpB1fOB/pHkdlESsR+q/F4yZH2tlnBNfzPubJnPkA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725015562; c=relaxed/simple;
	bh=JhYwu9b2jQ5taeRpJIv4YfqwMBmO2TEq/EcPU1sEI8c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kR+zFGXDqnHYebvU7f5amZpau/Mkw4qL4dGtQywZrAA9EvhM6ycQETU7lnjGZ331UUCkIJejs3U4jKNyeZyEDijxWboWYQfYll/Bs5K+2sVTJOO088SRpfTDIcZ5b4fAE6ChmzudpN/6rSLra6iH48LtdH/D5hUm6SOCGCE7qUM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=M75mCLYL; arc=fail smtp.client-ip=40.107.237.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FTMXIwanUIMFHDNwUj1wpgAHeG5T0X90v+l8k5Iox9Pf6eQIlDVhRg8Ip3U06PuYw6IqIDvdy04YILZJI/4yqPkmrScB5BhjrAW/4sqAosSwG/oQB3m8FDUmpSdsLGRVKeADisE2hSJ4NS15km8LKpkJhJfHJyvlPBKd/ygAhHdsOHHbBfNM4GMEOpZ2Rm99DKFkBFJzCkcTuK9LR5KjY+9sN+8M3dN6yB/b5Md3WFRhdzJL1ImT9JC+FM3sw7bt5PokR9efe096pguW6ZbZPQarFvTD84d3OCJtLryfAKLmuDyfUncSiWnbJ8L/o2RMHpaMSEaPKkXydmP4KqAdSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lI4VPs6YjSGudOBwsqJySD9gzp3FRPAJISfUi3TigDs=;
 b=iHC/XDhtoGkttSZqoPJtmubMCy/usxwoMmx4AKDOEd1G6BR17hC4M2aema3hMoHQtdVA1ofViZa3cIL4C1GCbledTO6ttTPxZPM9yz2sqwjxwj9R8nDh7riGfj/E1fV6Dcw1kmRQi7rvCUZVplSjczhSkw1cwSJBR9w4v64yGNcYegN0USxQ1OB+ArMrkRnMlvH/43ai7QpsskIWxB7KmOGREI4XqDuB61hReEuR6zByNhyHGbuxdkTKIcW5WwdyuUn0eQFxZlTHp52em6ZHOfvj5/zVnOum8JQzhn6djIjQt99m3NsKMgdAdTR5BZVGGoN1CezDVDR/cFSH7hQEcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lI4VPs6YjSGudOBwsqJySD9gzp3FRPAJISfUi3TigDs=;
 b=M75mCLYL954KjPROJegPoPSYD3I34+hfbAoZvjtfro8IIaZuhUd2kzlDwA7gK98PZgAvkOw8NH8+OxveXX0wMJwy6a/d1jXNAaeLBODo/SmwbYpTgmYXBG7vU2ERjKtI1hduH2AiGzC3yFlYCCuUsGkebSZiFkm9gAu82PeY752LfmAoBua1fJNFHodDJxeJtVxkMW7J7APs4Oa6gp8IJCMKWLqPVc/GMq30JMHfweS2mJDcNCxSdgsuhjqqHxpMDYmagmxDQHeaLHY+X0H2Kyq5Vj1uKlJz2Ezq6pr4LtmPxcq7DFhVn41pNUkLnDKP8Lcep3aKec7yPBzzTWL7jA==
Received: from PH1PEPF000132F8.NAMP220.PROD.OUTLOOK.COM (2603:10b6:518:1::29)
 by PH8PR12MB8605.namprd12.prod.outlook.com (2603:10b6:510:1cc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Fri, 30 Aug
 2024 10:59:15 +0000
Received: from CY4PEPF0000E9D6.namprd05.prod.outlook.com
 (2a01:111:f403:f912::5) by PH1PEPF000132F8.outlook.office365.com
 (2603:1036:903:47::3) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21 via Frontend
 Transport; Fri, 30 Aug 2024 10:59:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9D6.mail.protection.outlook.com (10.167.241.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 30 Aug 2024 10:59:14 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 30 Aug
 2024 03:59:03 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 30 Aug
 2024 03:59:02 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Fri, 30 Aug 2024 03:58:59 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, <virtualization@lists.linux.dev>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Cosmin Ratiu <cratiu@nvidia.com>
Subject: [PATCH vhost v2 1/7] vdpa/mlx5: Create direct MKEYs in parallel
Date: Fri, 30 Aug 2024 13:58:32 +0300
Message-ID: <20240830105838.2666587-3-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240830105838.2666587-2-dtatulea@nvidia.com>
References: <20240830105838.2666587-2-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D6:EE_|PH8PR12MB8605:EE_
X-MS-Office365-Filtering-Correlation-Id: 470f05b3-dbdd-46fa-7a3c-08dcc8e2c983
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Jgan9NRarsWUntPqiRdx40hOyp9ea7e8V62zjYCsW9wexXExm41WVUU8KPms?=
 =?us-ascii?Q?zIcX4gaF/H3zQjklDauYtx1GLT8Jb3Ue95nK5fUoH0gG/77Woujnraz2W8iP?=
 =?us-ascii?Q?NQSzo1aoHsiNR184obzzvQ//fFwzm1saeuVZdvTpaDI/ZySEjxYLBEwID0jg?=
 =?us-ascii?Q?mx3HjlPbiied8PO2jTOu9PB1QFAmdZo/C/nCRBTzNLCwmqp0Jqy5lEerWorQ?=
 =?us-ascii?Q?11cP81UfbpVZXNdfckQzBpS0YksTccpUxuq5IBp/IX/kJRuTUXdwze7P95JH?=
 =?us-ascii?Q?OmuKLzlGGKarTBgZCa0/WuSswmLRoCoK2emREq0whb2gkBRssEe8kYtKQML6?=
 =?us-ascii?Q?ajlkKtTUi7D/5+yCjH8vGuEQDC2aqnqwBNpBWp7Z95d98S+mPTEWnP0N3/gu?=
 =?us-ascii?Q?T1kZDAfztxH7Dc83GAuT0tiCh9eLfgHHRPiK+PLIcGu/6QX6ysCePHHykQdy?=
 =?us-ascii?Q?QKTM/oYX2c2q7rTd/A7CqpcNwBWyYpSTP9cyS3oiau2t8KS0RMzliErhr4Mg?=
 =?us-ascii?Q?atglbDDaJ7tWUH4egX5TpCYOO7SUMS/DryZgzQQ1NdRLv1RfOncSsv1GZ2eJ?=
 =?us-ascii?Q?iQ+wz8uq3+IyR2O6ZFkK9xbIfGEQISYh8fZUjK5fIcgupIeduq1BWlLW4lwn?=
 =?us-ascii?Q?LoQlwo2sZJLEYfm/E3HCi4qrTcYTmV11txsO9WwVBAwEZ+6tTEBEZLPWF+2p?=
 =?us-ascii?Q?bA3SO0fPf1srMeIwkyRC3A46g9Nuj3H/eOWkt2g4uhPB9PUB3bE3SJTsfNuD?=
 =?us-ascii?Q?eKXn05SkJmdWhvO4r16p+X6leoVAqpl3XIZUFszX4Ur3ZgpXMJ/wHXc2lSnW?=
 =?us-ascii?Q?vc+52C/ghaIYLAx3ggGPhFdiXWvxWeJoegcatv/z/ScqOdvLv6st7T0+ECoe?=
 =?us-ascii?Q?BGF9qEJIiIJn+Q9bKcrvpCXvAmMCWsf0V93tUTrXT1vIIyqdO0OaGGlRMImJ?=
 =?us-ascii?Q?rkffC2Oxe/XuExcQG6/avJuTThx3bbjM+Xbf3TJ7EFWeq0HtIb2/2UIHt1Xk?=
 =?us-ascii?Q?aPknuZ7I8iDHhVOjXdKp/6i5r9aKNaIXeqD1WCwWJo0ei50U8fKBnSCz5u3l?=
 =?us-ascii?Q?N5fP3ycSiugrWHmAID+ZW2N+cDNHgeKg13jDsPMJAzpi+gGJst7FeMf/eTPu?=
 =?us-ascii?Q?/q45Mebk5Ia5rSX9ghOZKeYEWL+T7USDZOyHPKNl5gQzguf72CDtFtQd1qTN?=
 =?us-ascii?Q?HGz3HK6njC19yrnQqLGiDCfdO5kROo7pWe6Y6ehTSr06DMUTuRsaFavtCxIj?=
 =?us-ascii?Q?Jw02Q1q5l835vXs/V2wAzapD+qzY24ZO+FvhTg2LswveZYQR7ZmwF//S+wTU?=
 =?us-ascii?Q?xPkOFrT+bAY63xFM70kZkI+8lXtD2+uRAhHsnTxO2GONA4bpARUnHjJG4dD0?=
 =?us-ascii?Q?RNOC1W25xD76M67pygH8YbmTpPIZ3vtvlr7A+HjzOhot3GE1GS4B1TWMds01?=
 =?us-ascii?Q?pm/843vlChWWLyFZsPcz8ZnZuaHB42tQ?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 10:59:14.7362
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 470f05b3-dbdd-46fa-7a3c-08dcc8e2c983
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8605

Use the async interface to issue MTT MKEY creation.
Extra care is taken at the allocation of FW input commands
due to the MTT tables having variable sizes depending on
MR.

The indirect MKEY is still created synchronously at the
end as the direct MKEYs need to be filled in.

This makes create_user_mr() 3-5x faster, depending on
the size of the MR.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
---
 drivers/vdpa/mlx5/core/mr.c | 120 +++++++++++++++++++++++++++++-------
 1 file changed, 98 insertions(+), 22 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 4758914ccf86..e72fb11e353d 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -49,17 +49,18 @@ static void populate_mtts(struct mlx5_vdpa_direct_mr *mr, __be64 *mtt)
 	}
 }
 
-static int create_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr *mr)
+struct mlx5_create_mkey_mem {
+	u8 out[MLX5_ST_SZ_BYTES(create_mkey_out)];
+	u8 in[MLX5_ST_SZ_BYTES(create_mkey_in)];
+	__be64 mtt[];
+};
+
+static void fill_create_direct_mr(struct mlx5_vdpa_dev *mvdev,
+				  struct mlx5_vdpa_direct_mr *mr,
+				  struct mlx5_create_mkey_mem *mem)
 {
-	int inlen;
+	void *in = &mem->in;
 	void *mkc;
-	void *in;
-	int err;
-
-	inlen = MLX5_ST_SZ_BYTES(create_mkey_in) + roundup(MLX5_ST_SZ_BYTES(mtt) * mr->nsg, 16);
-	in = kvzalloc(inlen, GFP_KERNEL);
-	if (!in)
-		return -ENOMEM;
 
 	MLX5_SET(create_mkey_in, in, uid, mvdev->res.uid);
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
@@ -76,18 +77,25 @@ static int create_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct
 	MLX5_SET(create_mkey_in, in, translations_octword_actual_size,
 		 get_octo_len(mr->end - mr->start, mr->log_size));
 	populate_mtts(mr, MLX5_ADDR_OF(create_mkey_in, in, klm_pas_mtt));
-	err = mlx5_vdpa_create_mkey(mvdev, &mr->mr, in, inlen);
-	kvfree(in);
-	if (err) {
-		mlx5_vdpa_warn(mvdev, "Failed to create direct MR\n");
-		return err;
-	}
 
-	return 0;
+	MLX5_SET(create_mkey_in, in, opcode, MLX5_CMD_OP_CREATE_MKEY);
+	MLX5_SET(create_mkey_in, in, uid, mvdev->res.uid);
+}
+
+static void create_direct_mr_end(struct mlx5_vdpa_dev *mvdev,
+				 struct mlx5_vdpa_direct_mr *mr,
+				 struct mlx5_create_mkey_mem *mem)
+{
+	u32 mkey_index = MLX5_GET(create_mkey_out, mem->out, mkey_index);
+
+	mr->mr = mlx5_idx_to_mkey(mkey_index);
 }
 
 static void destroy_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr *mr)
 {
+	if (!mr->mr)
+		return;
+
 	mlx5_vdpa_destroy_mkey(mvdev, mr->mr);
 }
 
@@ -179,6 +187,76 @@ static int klm_byte_size(int nklms)
 	return 16 * ALIGN(nklms, 4);
 }
 
+#define MLX5_VDPA_MTT_ALIGN 16
+
+static int create_direct_keys(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr)
+{
+	struct mlx5_vdpa_async_cmd *cmds;
+	struct mlx5_vdpa_direct_mr *dmr;
+	int err = 0;
+	int i = 0;
+
+	cmds = kvcalloc(mr->num_directs, sizeof(*cmds), GFP_KERNEL);
+	if (!cmds)
+		return -ENOMEM;
+
+	list_for_each_entry(dmr, &mr->head, list) {
+		struct mlx5_create_mkey_mem *cmd_mem;
+		int mttlen, mttcount;
+
+		mttlen = roundup(MLX5_ST_SZ_BYTES(mtt) * dmr->nsg, MLX5_VDPA_MTT_ALIGN);
+		mttcount = mttlen / sizeof(cmd_mem->mtt[0]);
+		cmd_mem = kvcalloc(1, struct_size(cmd_mem, mtt, mttcount), GFP_KERNEL);
+		if (!cmd_mem) {
+			err = -ENOMEM;
+			goto done;
+		}
+
+		cmds[i].out = cmd_mem->out;
+		cmds[i].outlen = sizeof(cmd_mem->out);
+		cmds[i].in = cmd_mem->in;
+		cmds[i].inlen = struct_size(cmd_mem, mtt, mttcount);
+
+		fill_create_direct_mr(mvdev, dmr, cmd_mem);
+
+		i++;
+	}
+
+	err = mlx5_vdpa_exec_async_cmds(mvdev, cmds, mr->num_directs);
+	if (err) {
+
+		mlx5_vdpa_err(mvdev, "error issuing MTT mkey creation for direct mrs: %d\n", err);
+		goto done;
+	}
+
+	i = 0;
+	list_for_each_entry(dmr, &mr->head, list) {
+		struct mlx5_vdpa_async_cmd *cmd = &cmds[i++];
+		struct mlx5_create_mkey_mem *cmd_mem;
+
+		cmd_mem = container_of(cmd->out, struct mlx5_create_mkey_mem, out);
+
+		if (!cmd->err) {
+			create_direct_mr_end(mvdev, dmr, cmd_mem);
+		} else {
+			err = err ? err : cmd->err;
+			mlx5_vdpa_err(mvdev, "error creating MTT mkey [0x%llx, 0x%llx]: %d\n",
+				dmr->start, dmr->end, cmd->err);
+		}
+	}
+
+done:
+	for (i = i-1; i >= 0; i--) {
+		struct mlx5_create_mkey_mem *cmd_mem;
+
+		cmd_mem = container_of(cmds[i].out, struct mlx5_create_mkey_mem, out);
+		kvfree(cmd_mem);
+	}
+
+	kvfree(cmds);
+	return err;
+}
+
 static int create_indirect_key(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr)
 {
 	int inlen;
@@ -279,14 +357,8 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
 		goto err_map;
 	}
 
-	err = create_direct_mr(mvdev, mr);
-	if (err)
-		goto err_direct;
-
 	return 0;
 
-err_direct:
-	dma_unmap_sg_attrs(dma, mr->sg_head.sgl, mr->nsg, DMA_BIDIRECTIONAL, 0);
 err_map:
 	sg_free_table(&mr->sg_head);
 	return err;
@@ -401,6 +473,10 @@ static int create_user_mr(struct mlx5_vdpa_dev *mvdev,
 	if (err)
 		goto err_chain;
 
+	err = create_direct_keys(mvdev, mr);
+	if (err)
+		goto err_chain;
+
 	/* Create the memory key that defines the guests's address space. This
 	 * memory key refers to the direct keys that contain the MTT
 	 * translations
-- 
2.45.1


