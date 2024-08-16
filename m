Return-Path: <kvm+bounces-24365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2155095450F
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 11:04:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D13F1F24824
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 09:04:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60F8C13D882;
	Fri, 16 Aug 2024 09:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qKxOK18Z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2070.outbound.protection.outlook.com [40.107.212.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B565F145FFE;
	Fri, 16 Aug 2024 09:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723798971; cv=fail; b=mi227UfNuwunB4zmTWjjAkqe/KfMaObsnGICFskI7LDjGN0JdCEGQ8UPaIz1FfIiLAcfpehbPtGnsytYdiNxSRQEgiy9OeymrpB7Ye3wm8YXW7eUO2HPDzDvkb+WnjX/5bbBKXgrwHSElXC58pJGS/9z4dbidqyB7Rjvn5qEmV0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723798971; c=relaxed/simple;
	bh=rOOyQEt5A0483eq2sWBmVGwOnJCQyKlO28avQYJ5doo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TuBpCMgzAMbNpwndW5cqMDl2uxFvLSW03yHwN9dVWG1eTvZqiHM9uxaAxxdAoAl/gFqf0xlgr0tK9Ku7JYYjNlcKymvqZRB2JBsHu3OckQ7To9Ai79TGSSTfo/DdTF7ZnwMdsY+gHPaze5a3v1YgsuUQaCZ2odTquqWyPgHJlZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qKxOK18Z; arc=fail smtp.client-ip=40.107.212.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WpfwC0Xk9xls075qIsYTyBUjpmUHARA4At6OlHKunXk87Spu1ICe0Af6a4IxLCLyjbVc2KOMhHqLj14uGRZcmP/QIEr/ozuciykgvTpT1JkJSmcOtREyiW29ek/O5JPpUUuctE5K9FDXQ2PB15nwmC3NtYgVqunMx0df5uberYEsMO8wM0PJxWpedE2IDmr7ioBM90MKo+rGmZRm4TOtuFJN50ANH3KNom0XoiLGsqdTXr1BX/ui3hl9TBdp24rnnu+QVNeT4lu1zdRKANUzhNyYlad2+qe0RmLUX+89qzIg4IIx3pt21HduoSDKdLg7H6CnIewq33ZKX7estA6bGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+EYvEhhmxCGT0SxNpePBKSdpiklmOT3hHt52Br7Bdhg=;
 b=MCGe4W8cB09s7O9ZSMkcV3GcMNpdULrMedXfb4T5Q7VTXmBIW6GC/MUnqLIbG58KOSwbNg1Qr40ZFfgTQm1CzMlQUVLkomHsgdwurvRtNmb+NC+1TKSZvCyB1Ot7cU0/576TkqoZf7Qyl0dJstMNBoIFVJtBSQyiUrGTPxjey4UiI09jRJNTloUdBw8tDa6ihRixPYcdo5AU9M5wsilg83v9kdhJOXDnfsN6wN+y/ZKgqS8/h5g7kvKcGfVLNoGDHZyWrxYHCkgmibhJWPBylC1TvXyRR6LIUF5TSSjBUOKe/8ZLPRJIpSSng0eIPoxUGhDBmQX9koRazXCMKxLHpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+EYvEhhmxCGT0SxNpePBKSdpiklmOT3hHt52Br7Bdhg=;
 b=qKxOK18ZkfsBJFRUGAUvOvwFr5laweAw+rTTC2vnCkRHSzx4bu+jin/a66aHcBWWpB4ZPZGqEcFLpFwBJBwFGfLf1CxNwfKuhtf7+QSYDaIo4MLbg+bZNf5cbsOoBhwZMlPefLpvZsYXa8og2M08jZw28h09B4WpUcTDE+bIrAepIHRePMFcoNre0NF6+j4mCJZ3bqsJAiruuoMjNPn/cqzTCXTr9SM1xSGX1OCv29lnI9wA6gFhvXy/7rGgYvet9ryrbDKAPFkNmZt0q00lAfdR452vSw5284WgkQY+ruCQAEfu8CcIS+sdH9Gcq9f8Ti9uqx8HB5POb9yDHmEusw==
Received: from BN9PR03CA0779.namprd03.prod.outlook.com (2603:10b6:408:13a::34)
 by CH3PR12MB8073.namprd12.prod.outlook.com (2603:10b6:610:126::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Fri, 16 Aug
 2024 09:02:43 +0000
Received: from BN1PEPF00004689.namprd05.prod.outlook.com
 (2603:10b6:408:13a:cafe::59) by BN9PR03CA0779.outlook.office365.com
 (2603:10b6:408:13a::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.33 via Frontend
 Transport; Fri, 16 Aug 2024 09:02:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF00004689.mail.protection.outlook.com (10.167.243.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7849.8 via Frontend Transport; Fri, 16 Aug 2024 09:02:42 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 02:02:29 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 02:02:28 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Fri, 16 Aug 2024 02:02:24 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>,
	<virtualization@lists.linux-foundation.org>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Si-Wei Liu <si-wei.liu@oracle.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Gal Pressman
	<gal@nvidia.com>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH vhost v2 04/10] vdpa/mlx5: Use async API for vq query command
Date: Fri, 16 Aug 2024 12:01:53 +0300
Message-ID: <20240816090159.1967650-5-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004689:EE_|CH3PR12MB8073:EE_
X-MS-Office365-Filtering-Correlation-Id: d417a54c-2c63-41e3-e80d-08dcbdd23060
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ApkDwYMWGe1fMsUqOTcaXiNxe0LXlFsKwjcrny++VncIJIpdzQquAFx7NZ2S?=
 =?us-ascii?Q?oqx6hD4/EwV2/hjXhDVj/9J6NpwujarSZH4eT08RZJ41sTDxmJAVqyrG1Z+5?=
 =?us-ascii?Q?jBkFEBUZTt2HgUPNjHdNda0YtC2quceARx6sSc97PwiX75CivbSHhA9XgM1m?=
 =?us-ascii?Q?J1p9dyaNX9LXL+86mzhGSwwNEo9a2KX0gO6xgauJjYkVmVUuWXPVeZmKoBbl?=
 =?us-ascii?Q?ugk73zaL5TzN/Brpk4I5tqeo6ifmJTTIKJGZdJblaq9X1/rzSQW+ZIi/yzoN?=
 =?us-ascii?Q?iWw3glawLV3A/8gB6nozw2SuUJV15ThR5Vp4esqYic8hFKODq/8hTNKDpa/0?=
 =?us-ascii?Q?mlGHOVQ1Wi1ZXsEPF8NgFBEL2mqruTqa14zr6VFt8tT6SkX+ACNvgUnT6OJ+?=
 =?us-ascii?Q?S7jAwr7px6eqC9AYBQMpy9x7N2LRKuHxZO2sPQtNcuG+bj5EuuwnZSH0FUvg?=
 =?us-ascii?Q?gEVw2OcWM8FleCSFFqDcL4lhprVT7PCMUnonEPxKP6qJ0FDD/lFeLPJMuZfW?=
 =?us-ascii?Q?yDRYZ4HlIVXEEmYqaDKYf0pVsgxEtK9PFoFWdpHuq5FMaeOOb2Q7CZjRqcJw?=
 =?us-ascii?Q?zQ0RTHWIYkDglU1wItRjRUPWq2NSGdHQghudfLkeNKaASlIM4OWqe3A5AL/P?=
 =?us-ascii?Q?+nCX3RNyJMZYAdp6UUS49tMfcf/DcczAzW0RWiaSLwGmnvy7GBsl3NxGlAGQ?=
 =?us-ascii?Q?iR16kSBrgC4OhDBg9Le0c30Bf9pW3YbU53aWMXLcfkE/wHmDXL/XeEAadnxd?=
 =?us-ascii?Q?h/Mku5Pz+K4lwdrhHluAIJ7TBH9IrbR5a5sxPZqSyyKccY6O93ChBtAR0gPq?=
 =?us-ascii?Q?rkf/tBae2U2pV/vkk9bjHOx38DBcmpaNFTzZS1L8668CQrBjHg5tOtbEuIzo?=
 =?us-ascii?Q?wr78llVWsPKmWsFdE5R7kkf6bybVHAeCArRy+GmSVg8mdaqI2DQPwZzzCqLF?=
 =?us-ascii?Q?bUEcZ0bNYzuG/L3eGKzXR8Y+VrxxjsQUmcHvDmuLwoPVuFV0SEPWHyMKZKcz?=
 =?us-ascii?Q?Z2/ZfiR1rLPBbXjZ9NU6QzGBndhmqB0C8K2Sr9KL3PQjPzFuNmNzVs6C7uV8?=
 =?us-ascii?Q?NYheW9UX+7Fs/hwKt/WE8zrLWz/wEy8uiQKFyqwHkf1ynBpZiEZpOq5nqQAG?=
 =?us-ascii?Q?UTFbjUIPAQ1By56rhpcUxzawti3DJs8tT1w4bX0Db5zUscJSEGjrcZo5vUs4?=
 =?us-ascii?Q?v6IrHkNCc1pL1jlAZrqVCQF3ybUctW8yNfIr9x20U+XcRoIe2FYJjPrrSxXc?=
 =?us-ascii?Q?YzGQPy41Wl/D5BfmUUc7n8ZSn0pDO9TeVe14b6VxBICfGlTAlh6KgWKMHEGX?=
 =?us-ascii?Q?oGaPAgsl8Uz/UhiY3f0fdlRvw89CucA1+XOfmzWZk6LNMDl2PR/+0OuhoJdA?=
 =?us-ascii?Q?UdRcK5Djr18O0DbxeHS6A2z4eID+XQCpyOt+vqYnNO123JBYZrvzyl41QJva?=
 =?us-ascii?Q?+dnYllQwJu7rYLQtKSay09YOmGRXwLBt?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 09:02:42.9081
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d417a54c-2c63-41e3-e80d-08dcbdd23060
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004689.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8073

Switch firmware vq query command to be issued via the async API to
allow future parallelization.

For now the command is still serial but the infrastructure is there
to issue commands in parallel, including ratelimiting the number
of issued async commands to firmware.

A later patch will switch to issuing more commands at a time.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h |   2 +
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 101 ++++++++++++++++++++++-------
 2 files changed, 78 insertions(+), 25 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index b34e9b93d56e..24fa00afb24f 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -103,6 +103,8 @@ struct mlx5_vdpa_dev {
 	struct workqueue_struct *wq;
 	unsigned int group2asid[MLX5_VDPA_NUMVQ_GROUPS];
 	bool suspended;
+
+	struct mlx5_async_ctx async_ctx;
 };
 
 struct mlx5_vdpa_async_cmd {
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 12133e5d1285..413b24398ef2 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1184,40 +1184,87 @@ struct mlx5_virtq_attr {
 	u16 used_index;
 };
 
-static int query_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq,
-			   struct mlx5_virtq_attr *attr)
-{
-	int outlen = MLX5_ST_SZ_BYTES(query_virtio_net_q_out);
-	u32 in[MLX5_ST_SZ_DW(query_virtio_net_q_in)] = {};
-	void *out;
-	void *obj_context;
-	void *cmd_hdr;
-	int err;
-
-	out = kzalloc(outlen, GFP_KERNEL);
-	if (!out)
-		return -ENOMEM;
+struct mlx5_virtqueue_query_mem {
+	u8 in[MLX5_ST_SZ_BYTES(query_virtio_net_q_in)];
+	u8 out[MLX5_ST_SZ_BYTES(query_virtio_net_q_out)];
+};
 
-	cmd_hdr = MLX5_ADDR_OF(query_virtio_net_q_in, in, general_obj_in_cmd_hdr);
+static void fill_query_virtqueue_cmd(struct mlx5_vdpa_net *ndev,
+				     struct mlx5_vdpa_virtqueue *mvq,
+				     struct mlx5_virtqueue_query_mem *cmd)
+{
+	void *cmd_hdr = MLX5_ADDR_OF(query_virtio_net_q_in, cmd->in, general_obj_in_cmd_hdr);
 
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, opcode, MLX5_CMD_OP_QUERY_GENERAL_OBJECT);
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, obj_type, MLX5_OBJ_TYPE_VIRTIO_NET_Q);
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, obj_id, mvq->virtq_id);
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, uid, ndev->mvdev.res.uid);
-	err = mlx5_cmd_exec(ndev->mvdev.mdev, in, sizeof(in), out, outlen);
-	if (err)
-		goto err_cmd;
+}
+
+static void query_virtqueue_end(struct mlx5_vdpa_net *ndev,
+				struct mlx5_virtqueue_query_mem *cmd,
+				struct mlx5_virtq_attr *attr)
+{
+	void *obj_context = MLX5_ADDR_OF(query_virtio_net_q_out, cmd->out, obj_context);
 
-	obj_context = MLX5_ADDR_OF(query_virtio_net_q_out, out, obj_context);
 	memset(attr, 0, sizeof(*attr));
 	attr->state = MLX5_GET(virtio_net_q_object, obj_context, state);
 	attr->available_index = MLX5_GET(virtio_net_q_object, obj_context, hw_available_index);
 	attr->used_index = MLX5_GET(virtio_net_q_object, obj_context, hw_used_index);
-	kfree(out);
-	return 0;
+}
 
-err_cmd:
-	kfree(out);
+static int query_virtqueues(struct mlx5_vdpa_net *ndev,
+			    int start_vq,
+			    int num_vqs,
+			    struct mlx5_virtq_attr *attrs)
+{
+	struct mlx5_vdpa_dev *mvdev = &ndev->mvdev;
+	struct mlx5_virtqueue_query_mem *cmd_mem;
+	struct mlx5_vdpa_async_cmd *cmds;
+	int err = 0;
+
+	WARN(start_vq + num_vqs > mvdev->max_vqs, "query vq range invalid [%d, %d), max_vqs: %u\n",
+	     start_vq, start_vq + num_vqs, mvdev->max_vqs);
+
+	cmds = kvcalloc(num_vqs, sizeof(*cmds), GFP_KERNEL);
+	cmd_mem = kvcalloc(num_vqs, sizeof(*cmd_mem), GFP_KERNEL);
+	if (!cmds || !cmd_mem) {
+		err = -ENOMEM;
+		goto done;
+	}
+
+	for (int i = 0; i < num_vqs; i++) {
+		cmds[i].in = &cmd_mem[i].in;
+		cmds[i].inlen = sizeof(cmd_mem[i].in);
+		cmds[i].out = &cmd_mem[i].out;
+		cmds[i].outlen = sizeof(cmd_mem[i].out);
+		fill_query_virtqueue_cmd(ndev, &ndev->vqs[start_vq + i], &cmd_mem[i]);
+	}
+
+	err = mlx5_vdpa_exec_async_cmds(&ndev->mvdev, cmds, num_vqs);
+	if (err) {
+		mlx5_vdpa_err(mvdev, "error issuing query cmd for vq range [%d, %d): %d\n",
+			      start_vq, start_vq + num_vqs, err);
+		goto done;
+	}
+
+	for (int i = 0; i < num_vqs; i++) {
+		struct mlx5_vdpa_async_cmd *cmd = &cmds[i];
+		int vq_idx = start_vq + i;
+
+		if (cmd->err) {
+			mlx5_vdpa_err(mvdev, "query vq %d failed, err: %d\n", vq_idx, err);
+			if (!err)
+				err = cmd->err;
+			continue;
+		}
+
+		query_virtqueue_end(ndev, &cmd_mem[i], &attrs[i]);
+	}
+
+done:
+	kvfree(cmd_mem);
+	kvfree(cmds);
 	return err;
 }
 
@@ -1542,7 +1589,7 @@ static int suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mv
 		return err;
 	}
 
-	err = query_virtqueue(ndev, mvq, &attr);
+	err = query_virtqueues(ndev, mvq->index, 1, &attr);
 	if (err) {
 		mlx5_vdpa_err(&ndev->mvdev, "failed to query virtqueue, err: %d\n", err);
 		return err;
@@ -2528,7 +2575,7 @@ static int mlx5_vdpa_get_vq_state(struct vdpa_device *vdev, u16 idx, struct vdpa
 		return 0;
 	}
 
-	err = query_virtqueue(ndev, mvq, &attr);
+	err = query_virtqueues(ndev, mvq->index, 1, &attr);
 	if (err) {
 		mlx5_vdpa_err(mvdev, "failed to query virtqueue\n");
 		return err;
@@ -2879,7 +2926,7 @@ static int save_channel_info(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqu
 	int err;
 
 	if (mvq->initialized) {
-		err = query_virtqueue(ndev, mvq, &attr);
+		err = query_virtqueues(ndev, mvq->index, 1, &attr);
 		if (err)
 			return err;
 	}
@@ -3854,6 +3901,8 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 		ndev->rqt_size = 1;
 	}
 
+	mlx5_cmd_init_async_ctx(mdev, &mvdev->async_ctx);
+
 	ndev->mvdev.mlx_features = device_features;
 	mvdev->vdev.dma_dev = &mdev->pdev->dev;
 	err = mlx5_vdpa_alloc_resources(&ndev->mvdev);
@@ -3935,6 +3984,8 @@ static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *
 	mvdev->wq = NULL;
 	destroy_workqueue(wq);
 	mgtdev->ndev = NULL;
+
+	mlx5_cmd_cleanup_async_ctx(&mvdev->async_ctx);
 }
 
 static const struct vdpa_mgmtdev_ops mdev_ops = {
-- 
2.45.1


