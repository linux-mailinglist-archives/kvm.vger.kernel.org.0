Return-Path: <kvm+bounces-24716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C47F959B18
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 14:01:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3085AB2B1F6
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 11:54:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC9461AF4F2;
	Wed, 21 Aug 2024 11:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rnYHQEp7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CA01AF4D2;
	Wed, 21 Aug 2024 11:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724240518; cv=fail; b=gcE/zALQ/cMw1hNMAgBoBsE6qbci+zcuomUtnY9/3q/0I07GL8Xft/E9XdWrwOGD+9F5DrDHM0ZDLPPUCMW1y/d6lQ7gKlTn8FSvXDgCtObeWHTFFCrcfOpnfw6t5KbJVI0BCViEQCPSHXXH+dESzTIr4kdSalX5Kju0M21oOX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724240518; c=relaxed/simple;
	bh=7I1TGKYW04eaVAa1LUFTHVzvQtPOy+WP3Rr6YKxUN7c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NRvShSY9XSlLFRFPTwwCPUu4pZ1tpgfCfsnj9fs0E09ZO4ESS+1IBsvKGscEn6ajNthJomnm4TKsqGQshdtooZDtYGrQZ6pnoJ++aVzQchPFnfPSs6l9dppYUpGKl3BprR6gMgiUNPBzkNWIhjUvGt2Nx6P0f2ZrxRWhxZJtzCY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rnYHQEp7; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jJHI/Mxau3EUyqI3LyCgxqd/xsbnMTB376e/z0vkLqT5FZV2eU7FnasNyn2NbAUs2Rr619pVlzJUZh7dW4ROldPXBA6d1LSix/DCykOPT8ze9Zqs/oaIqcVKX1aHWL919A2duVbkZcJPJgPKuFgjGJ2U9DqRuDYq4uBPqfFv+2hWfcjFj87E3zfQ9joGQrf4lpICAV2QEavBhfBhqbLpPWvJRwRTGc02CP98jWjbE/lUrkrwYghhiI0OPyhhVuZxtKIvceRSkGcHsu/G3pCGJs9TTWptFGGTXGB/ruU9jywKBr3bTiuFVQB0RSHvTJhS+oja8QEfsUhS+lEdBumEHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aal0rUukt5H+w8BsXsq9Qi8Qn6hcdXkHNTWV31qp6lg=;
 b=uXElq+rA330y5rwJIvSkL6bm9IAt7FXzifCopuWtpOZ+ytd9t5iqHoxITzwb2v1VYh+xtg64/19eq1vEhzo/ZLzeg3zubzJeq3RG4YLIN4NxEF+RWstDhti4ZByYFmATYCSp9fld1rxGjqeup+aGnGATU3+lvWtIW8YMAI7b8JytJKOdlCNSY1edgRlVbxad3U6MjGH+uFgrRrBp/PRfZgqQsJ8IVKvMaYRXs7xcIaOJGE1AnTaWLoGVORmcPJzwffmUX60M6CBqaqGD5Mz3Iena3SZdTbl/UxER97vmAfqgK+dQxe0A9xJgONK5KtLykbvfNYDG2gebFj/HRCXzyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aal0rUukt5H+w8BsXsq9Qi8Qn6hcdXkHNTWV31qp6lg=;
 b=rnYHQEp7NPc816mI2tSjDulSrEe4rpWJiZVCvNifnIS7jtLMOoFLiew9TfqOrFo7zhqtLxbHGGSWCbCfCLNWCxyN01+8zgMP1Dt3rUqLkZi2NaAZMwnjE0II5hMlo+7ki+jNQSFif+9l1UY3UhFDAb2gSfHIu3nO6XonMXwuAjxbXrKlblOxG72avJX7F/xoFjDqZrQKqLBqKIt/sH+4FHVzIg7SDZm3M4z3BnOBhAinihECBkNcuK8c+yZr6U8gIWHtLxTTzZ2WCBldd9AVFf7vtMzcfAttZjc8lAmrjf4ihk6/fIQ/KQnZlXi6QTOldBKwUwYRNRPot5XXN0CISQ==
Received: from BN9PR03CA0353.namprd03.prod.outlook.com (2603:10b6:408:f6::28)
 by SA3PR12MB8802.namprd12.prod.outlook.com (2603:10b6:806:314::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Wed, 21 Aug
 2024 11:41:51 +0000
Received: from BN3PEPF0000B373.namprd21.prod.outlook.com
 (2603:10b6:408:f6:cafe::f) by BN9PR03CA0353.outlook.office365.com
 (2603:10b6:408:f6::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25 via Frontend
 Transport; Wed, 21 Aug 2024 11:41:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF0000B373.mail.protection.outlook.com (10.167.243.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.4 via Frontend Transport; Wed, 21 Aug 2024 11:41:51 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 21 Aug
 2024 04:41:35 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 21 Aug
 2024 04:41:35 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Wed, 21 Aug 2024 04:41:32 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, <virtualization@lists.linux-foundation.org>, "Gal
 Pressman" <gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Cosmin Ratiu <cratiu@nvidia.com>
Subject: [PATCH vhost 2/7] vdpa/mlx5: Delete direct MKEYs in parallel
Date: Wed, 21 Aug 2024 14:40:56 +0300
Message-ID: <20240821114100.2261167-4-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240821114100.2261167-2-dtatulea@nvidia.com>
References: <20240821114100.2261167-2-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B373:EE_|SA3PR12MB8802:EE_
X-MS-Office365-Filtering-Correlation-Id: e426b2b9-deda-4f79-ec88-08dcc1d63f7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jHDjipdrFWpnRDun5/zhXy3kDuqJBmUcvOTZG2IBy0vqabsA55MPsHLslVfZ?=
 =?us-ascii?Q?xBvFR1Us7zUc3hx9IED74yX9+6DSoCJXInFT7I56IUWBHdEcCYD3vwIF1nvI?=
 =?us-ascii?Q?FXWPxzJqMPT/kb7JFGZ8ypzC1kPV31asz++Vao1tLhf6kknDk1+4tWTjyviH?=
 =?us-ascii?Q?SXv7te373vnWnmqGb+o9ldxkynC8X/w8ZGXJSLmnFd6nC7RX60VzcJgMpUfI?=
 =?us-ascii?Q?WQ2hVzJkIw7sFNaw/5c+QElUvWrkdcA08ItMqryFZYOQxrIDEJqQXB13SlyF?=
 =?us-ascii?Q?pV1oWMSITL2+U3RfFbIKflESfdGA1r9B5Hc4yqCM3r9JwOlNeZS7whP84Tx/?=
 =?us-ascii?Q?ZxDStfAa+Uspa4PTMJaeBvwJiNg4bA9c4Xvo1tItwXeUSypM/ZKB26gF96W0?=
 =?us-ascii?Q?AAJbPzhGzf6E+UbeMusZnj5ryiy+jHeWI92RhI08Re+UG5cc3AXMGxGO0yVM?=
 =?us-ascii?Q?GdqhWlg7VX5MBp6n236bFPG4Z270EEOSS3dvifOGrMdiGz2BKu0lGJEa6OWp?=
 =?us-ascii?Q?ivCi+EsT8X+7mv/TNRJ/ynof5QQOafgD0WOMq+fuTS8q4uLwbmoiL8TqldGW?=
 =?us-ascii?Q?mqVu9H22Q3A6fNumavCXzSyg4NQjatmovl4Shwapdgn97js+ZkEqjCzQ6iI2?=
 =?us-ascii?Q?GAguG8flR0ziTxf4Ljq5zdgV2y575kJJuqGvsng2OBN1xIqkU5i9dL+L4EEu?=
 =?us-ascii?Q?ZDBR+eSIU2zVTVugLwDoMOd18slMZueOsdd2HgdcSmYz8VP04BbpzG9hxD9E?=
 =?us-ascii?Q?VILnlqBHK4qn366dMNb9LdTpRlAhYjnOxY8bKaHXiSOASzQVpzoIXdu42TXu?=
 =?us-ascii?Q?v98hoBXwDts5d2iI2iyMOdyCf6/CrH91tNCbPEO8EmwlwtEwUs1BURpIZEId?=
 =?us-ascii?Q?RWG5ptn4Lo4mVzs3UVFuQQvT4jugYJ6Xo519RpDpQ9yliN5lZfmM9aK6XNRz?=
 =?us-ascii?Q?K142sd/F0rDtkwha4plzLOyn3Y4netugCPUHu3t/rePuPH2VHmr0HKgnMPvX?=
 =?us-ascii?Q?F5tvYV+FjRCTcNDzxQx0answwSi8SIiwfGIeBDjfjj6hyl8aWahcokH0/MGI?=
 =?us-ascii?Q?BJWXWHyGlAidWHRdPKq8KEeSBhu7NqfFXOMfHn+4UrJseJAi/3wvbAxCT4HK?=
 =?us-ascii?Q?0PhIU0NCLG+nLj+k0M2K9hGTXYPtwKd+69tQf/BYUaiNG1nsUcEVApPDBymE?=
 =?us-ascii?Q?K4BT3Fe+VJ6YfpgjCndCaTr/TMNYMIGni1StlaiJFqhswh7PdpB0xeCFBYzN?=
 =?us-ascii?Q?28LF4PEBc7a1ItvjkcFg4vkWW3O3wTsG2qMmEmK41hdjVuqtIK5ERK7i5S3u?=
 =?us-ascii?Q?UyKY1Vl6WeO14byhxuG590i5zN02RVX6r7Uug4cX1bNAcBX47uS/adxeH+cC?=
 =?us-ascii?Q?eum0GB3qaXC1ZmjO0Ep157LFUyam5LwNYvqZRU+X92eHVvXSeXgXkx/l3Mu7?=
 =?us-ascii?Q?hlMJmOyTAH+gFeVYdZV5brP8JzZJNtQY?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 11:41:51.0246
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e426b2b9-deda-4f79-ec88-08dcc1d63f7f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B373.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8802

Use the async interface to issue MTT MKEY deletion.

This makes destroy_user_mr() on average 8x times faster.
This number is also dependent on the size of the MR being
deleted.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
---
 drivers/vdpa/mlx5/core/mr.c | 66 +++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 66e6a15f823f..8cedf2969991 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -55,6 +55,11 @@ struct mlx5_create_mkey_mem {
 	DECLARE_FLEX_ARRAY(__be64, mtt);
 };
 
+struct mlx5_destroy_mkey_mem {
+	u8 out[MLX5_ST_SZ_BYTES(destroy_mkey_out)];
+	u8 in[MLX5_ST_SZ_BYTES(destroy_mkey_in)];
+};
+
 static void fill_create_direct_mr(struct mlx5_vdpa_dev *mvdev,
 				  struct mlx5_vdpa_direct_mr *mr,
 				  struct mlx5_create_mkey_mem *mem)
@@ -91,6 +96,17 @@ static void create_direct_mr_end(struct mlx5_vdpa_dev *mvdev,
 	mr->mr = mlx5_idx_to_mkey(mkey_index);
 }
 
+static void fill_destroy_direct_mr(struct mlx5_vdpa_dev *mvdev,
+				   struct mlx5_vdpa_direct_mr *mr,
+				   struct mlx5_destroy_mkey_mem *mem)
+{
+	void *in = &mem->in;
+
+	MLX5_SET(destroy_mkey_in, in, uid, mvdev->res.uid);
+	MLX5_SET(destroy_mkey_in, in, opcode, MLX5_CMD_OP_DESTROY_MKEY);
+	MLX5_SET(destroy_mkey_in, in, mkey_index, mlx5_mkey_to_idx(mr->mr));
+}
+
 static void destroy_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr *mr)
 {
 	if (!mr->mr)
@@ -255,6 +271,55 @@ static int create_direct_keys(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *
 	return err;
 }
 
+static int destroy_direct_keys(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr)
+{
+	struct mlx5_destroy_mkey_mem *cmd_mem;
+	struct mlx5_vdpa_async_cmd *cmds;
+	struct mlx5_vdpa_direct_mr *dmr;
+	int err = 0;
+	int i = 0;
+
+	cmds = kvcalloc(mr->num_directs, sizeof(*cmds), GFP_KERNEL);
+	cmd_mem = kvcalloc(mr->num_directs, sizeof(*cmd_mem), GFP_KERNEL);
+	if (!cmds || !cmd_mem) {
+		err = -ENOMEM;
+		goto done;
+	}
+
+	list_for_each_entry(dmr, &mr->head, list) {
+		cmds[i].out = cmd_mem[i].out;
+		cmds[i].outlen = sizeof(cmd_mem[i].out);
+		cmds[i].in = cmd_mem[i].in;
+		cmds[i].inlen = sizeof(cmd_mem[i].in);
+		fill_destroy_direct_mr(mvdev, dmr, &cmd_mem[i]);
+		i++;
+	}
+
+	err = mlx5_vdpa_exec_async_cmds(mvdev, cmds, mr->num_directs);
+	if (err) {
+
+		mlx5_vdpa_err(mvdev, "error issuing MTT mkey deletion for direct mrs: %d\n", err);
+		goto done;
+	}
+
+	i = 0;
+	list_for_each_entry(dmr, &mr->head, list) {
+		struct mlx5_vdpa_async_cmd *cmd = &cmds[i++];
+
+		dmr->mr = 0;
+		if (cmd->err) {
+			err = err ? err : cmd->err;
+			mlx5_vdpa_err(mvdev, "error deleting MTT mkey [0x%llx, 0x%llx]: %d\n",
+				dmr->start, dmr->end, cmd->err);
+		}
+	}
+
+done:
+	kvfree(cmd_mem);
+	kvfree(cmds);
+	return err;
+}
+
 static int create_indirect_key(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr)
 {
 	int inlen;
@@ -563,6 +628,7 @@ static void destroy_user_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr
 	struct mlx5_vdpa_direct_mr *n;
 
 	destroy_indirect_key(mvdev, mr);
+	destroy_direct_keys(mvdev, mr);
 	list_for_each_entry_safe_reverse(dmr, n, &mr->head, list) {
 		list_del_init(&dmr->list);
 		unmap_direct_mr(mvdev, dmr);
-- 
2.45.1


