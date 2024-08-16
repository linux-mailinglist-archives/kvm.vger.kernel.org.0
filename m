Return-Path: <kvm+bounces-24366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B173A954511
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 11:04:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0C601C2359B
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 09:04:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D70231465A5;
	Fri, 16 Aug 2024 09:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nrJNB2kF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2897B13D890;
	Fri, 16 Aug 2024 09:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723798974; cv=fail; b=BeoqSVGVCJRoWdcA8rncQmqOAH2TxRhIZQjt/nhAMV2rqxs46wEoo6bpWiaM7FcDeIzaRg+NekQFRRuTJpRYWQPte6Dx2E263ehf4R1VtTFiFyBmTqyxkoiA1L9Xop9j33FLupnjGpaqTQC+K0c9fcYoNsCo6jD7vvvbefnBL2A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723798974; c=relaxed/simple;
	bh=l0bbPXQ8k7HmEYHK+4He4JBPX18tCuibNuEJfC6I1kg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WSviC6pmny/A6W3WtHCxwBxCJqt0fkU6uOuefsubs518q0JMi7pe9oFxIyrF04NyH6L0jBjjvoqMoPYhwrXS+ZeAq5KozegghSKsEoQ2Wzlwi/4WEZv7gnFM5P8f00qOONS4Y2C2aMtdxaPXcq02iMPRL2brq+AoyQf56KE+aNE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nrJNB2kF; arc=fail smtp.client-ip=40.107.92.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t1f+v4qxVvKL9u+CeTdlJI1TM7qTzWaaMEAQG4pmqUow3u2ErDSup9fiCD3I7zWY3fBDFul2i9PghZgVA5B9tvA0u1qsKUmj1UU5+QRKjXlmjJ72u/+6dAkou/xsOuzYCm1pAOAC6RPb4IwKRRibJfnoH1O3NAL2D81+fSvEEiDhd7g0twQFAuWNau/aEOKsGKlrB/RRKFtn2xVW8RokGJUFO+HC3aoA0HWWsq1LyHcf4cWFwAZ27M+MAxeqTVrvZ+PsGbAloG0MsuRq49ZZAHtZCy+TMXM0wpVVu/67P0kHSsUYqYoyRnCN4Cx+iik9Uv+2nPxpPaA4zK6o/zFqgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5o9TuZHTKch4YP+m39/zdLvLSSURuCjUWgDv/TqfOQc=;
 b=Cvc7Ct5JTzIWsfe2FXLoCsMIm+npKXKkHcdXK4K+MqjKz0ABI/4A50hMlut4DjMW7g0e7ClF7dpMED2mJ5sJEpSpxXF41Az0W7+tye6IJHgr8c5bix7L6HQR2rH36d8XczV0WmhVqHnAjffvPSlX4NFX1e1Q0NBeu2U2BbtdmbC/Kf4Y0PI+ogmzhYj8O0kr5Cfa71DHG2iGDxZv0BF17bkS/r9SoDAVnhHNKQ7oQZ5KxJW5mc+ZX0SqJ/LphhKhRbU4/0JGcLqw9Grqpfyg1xc0DQ8/7bViIxX39o/i5JIBWUh8MhfVdiDlsnbm/m7EL3Fg+5SpesuSALI0H2y7hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5o9TuZHTKch4YP+m39/zdLvLSSURuCjUWgDv/TqfOQc=;
 b=nrJNB2kFVluyjOqyJzNMbzaBdXqCp5AOrpHwJfXR1Fk4I4w9hZ4DP14sU/0GRucbfHjZpYNuL8DJIGdMZU8tuoqe61Fu9cWqrPReLkEnJQw7Mq7G99yxnFeLT3qoJnexuA32JRv31YJ7fvjWinFRXDphfkDRD5bnVqUMBe/D5gho+vBC7M8hOrnCYCvnAeyjKwYRIzNLtrv+2ZXMAHRstkRREKUsNIx+9WVk6yholPtG4ImU3QkePzf55hFriHch3g8TwfixKax1VNtXAzFmrCrs/4xOgJBlIQMJibYwy9eJAVf7lKUaAb5AclqDXsFKrON6xBzUG/r5xE0gg7RCEQ==
Received: from BN9PR03CA0697.namprd03.prod.outlook.com (2603:10b6:408:ef::12)
 by LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.18; Fri, 16 Aug
 2024 09:02:46 +0000
Received: from BN1PEPF00004688.namprd05.prod.outlook.com
 (2603:10b6:408:ef:cafe::44) by BN9PR03CA0697.outlook.office365.com
 (2603:10b6:408:ef::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.33 via Frontend
 Transport; Fri, 16 Aug 2024 09:02:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF00004688.mail.protection.outlook.com (10.167.243.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7849.8 via Frontend Transport; Fri, 16 Aug 2024 09:02:45 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 02:02:34 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 02:02:32 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Fri, 16 Aug 2024 02:02:29 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>,
	<virtualization@lists.linux-foundation.org>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Si-Wei Liu <si-wei.liu@oracle.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Gal Pressman
	<gal@nvidia.com>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH vhost v2 05/10] vdpa/mlx5: Use async API for vq modify commands
Date: Fri, 16 Aug 2024 12:01:54 +0300
Message-ID: <20240816090159.1967650-6-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004688:EE_|LV2PR12MB5869:EE_
X-MS-Office365-Filtering-Correlation-Id: 67a9ee0b-4e6b-494d-3a33-08dcbdd2321f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ibE0rWlxvQOWymwVxfXYBld9iJOSOS3wl2XYjJU+eoP5MURFsUn6wgrjdnC2?=
 =?us-ascii?Q?qqrJ6VszZdngYesTWXed/xEdXZReLwyxPT7b0RHln8a4BFBaZ0uoBHcsbTU9?=
 =?us-ascii?Q?8WmOoANufAUM3DT7OIYnPLsSLS1VdDQ5+20dcTXnjDi4IZdv6Dbnd4rvjNAz?=
 =?us-ascii?Q?U32rGkd9B5aOikTBU+WlG/eUmXI7cUwwByj0C31g1Dx7LLUf4O+o/0UrWwsL?=
 =?us-ascii?Q?kf+olr1C5zyqhw4bGFLnLbNq5O23f005Rl+OeFA5bnB4Wd0fuJMvoRxB8aY2?=
 =?us-ascii?Q?lIObd9cQWYlvh9L/2qRVTGEJEw0fN9i3KKhtlsKzaNZs0c/stcf8uDkbFTSN?=
 =?us-ascii?Q?frRQK6aEV52HgGyeFWYBXAvUDboPCdEnij2D/Zm88EuTOU2dOwMLuAzfUodC?=
 =?us-ascii?Q?f2X7mUzOrzICkDzcj+Pz2Czq7WfCUJPBMYW79pT99/A8+1MmgXoaADSL94yw?=
 =?us-ascii?Q?NKGDybe3lbHQf1oASwjBr2ui9V/kMWPaHz0a7OU7nk4UxLr++Q37jtCkjSRM?=
 =?us-ascii?Q?ESxgaNq2NqO5yKP2skNQW7O+IldypA7HHKZkDwg/otYG6LPz82BSMTN7epf9?=
 =?us-ascii?Q?8VWeLCDAVjQVKAUtxJFeU82BhGhG4acP0/knsKPoaASeqG40DNVLbFRbVynx?=
 =?us-ascii?Q?6mO1ysColtHgIa9H8XkYc2So88SnrFfrv8oF6hJr7wpS7qspQqnOY+qUl1rj?=
 =?us-ascii?Q?nJqAXhQUqe52lM8++lLarQbjSjJDeNqJNMHeFQvx9JDINnD/x5khCu+Wrfl4?=
 =?us-ascii?Q?Y+rNiqfml/QIEKRiZgO9lda7W7JYXp/gc6qSvxX8laIpxrXlTeYBbtTp71e2?=
 =?us-ascii?Q?1K4qSQ3UteuRIbkwfcTv1jqfV6hlC4gBXY/GmzK4EO0NopSX35tOCwZ8/iZK?=
 =?us-ascii?Q?2tCgmbCRPLgnAsdOCOzbKEaYKTyv4I0cIu6gj2X05qzepVga0FCGkE/hr25b?=
 =?us-ascii?Q?C5FblhLzzK0E/Ar7cI7LDfzU3Qiji17jciPz52ZcPXkEMuzqA6h0x9c88EMu?=
 =?us-ascii?Q?A9+ERE0VjCA7WdOSkNSnDTb5OUtYOg/wO+onZDmzCzhmbAX8dCwFpZAsqDh9?=
 =?us-ascii?Q?W7NNDhqC1AqsyqTQevkZ3en0v8GHtIC/wQ/C0WbSGhCh+Hvl7gjX9DgIwiGr?=
 =?us-ascii?Q?kQONIlm7xABRbIC9vXPIRlaK8KTbUrhSBHQbi01e9VYHDVx7w8CJXeAWMmC3?=
 =?us-ascii?Q?Dzq2OkmeP2uizhgYfTwuN/fmAfP+Kybt7UnmmjGf2Xcl8BAqIWrP3R8G0GwO?=
 =?us-ascii?Q?8/+iUqWEp/kDCCw09BL/1dPypCU6/kEz8qD4eMzZ5A2EfDSw2EIf6kA+NhNW?=
 =?us-ascii?Q?eAhVaJ6xui1JPa0T7BNvA8aXM588tfjEmyVu9Ycs00daEBZgUX89ysCXOe+f?=
 =?us-ascii?Q?PqM4g7U+y76lMMAbf3ZVtpFh6bInJCGKBXqkrt63Z+GH2JqAyQW6hhs4phz2?=
 =?us-ascii?Q?wpot5to1EkL1w/fJJn8q5pksAMtzlyHj?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 09:02:45.9113
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67a9ee0b-4e6b-494d-3a33-08dcbdd2321f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004688.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5869

Switch firmware vq modify command to be issued via the async API to
allow future parallelization. The new refactored function applies the
modify on a range of vqs and waits for their execution to complete.

For now the command is still used in a serial fashion. A later patch
will switch to modifying multiple vqs in parallel.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 154 ++++++++++++++++++++----------
 1 file changed, 106 insertions(+), 48 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 413b24398ef2..9be7a88d71a7 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1189,6 +1189,11 @@ struct mlx5_virtqueue_query_mem {
 	u8 out[MLX5_ST_SZ_BYTES(query_virtio_net_q_out)];
 };
 
+struct mlx5_virtqueue_modify_mem {
+	u8 in[MLX5_ST_SZ_BYTES(modify_virtio_net_q_in)];
+	u8 out[MLX5_ST_SZ_BYTES(modify_virtio_net_q_out)];
+};
+
 static void fill_query_virtqueue_cmd(struct mlx5_vdpa_net *ndev,
 				     struct mlx5_vdpa_virtqueue *mvq,
 				     struct mlx5_virtqueue_query_mem *cmd)
@@ -1298,51 +1303,30 @@ static bool modifiable_virtqueue_fields(struct mlx5_vdpa_virtqueue *mvq)
 	return true;
 }
 
-static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
-			    struct mlx5_vdpa_virtqueue *mvq,
-			    int state)
+static void fill_modify_virtqueue_cmd(struct mlx5_vdpa_net *ndev,
+				      struct mlx5_vdpa_virtqueue *mvq,
+				      int state,
+				      struct mlx5_virtqueue_modify_mem *cmd)
 {
-	int inlen = MLX5_ST_SZ_BYTES(modify_virtio_net_q_in);
-	u32 out[MLX5_ST_SZ_DW(modify_virtio_net_q_out)] = {};
 	struct mlx5_vdpa_dev *mvdev = &ndev->mvdev;
 	struct mlx5_vdpa_mr *desc_mr = NULL;
 	struct mlx5_vdpa_mr *vq_mr = NULL;
-	bool state_change = false;
 	void *obj_context;
 	void *cmd_hdr;
 	void *vq_ctx;
-	void *in;
-	int err;
-
-	if (mvq->fw_state == MLX5_VIRTIO_NET_Q_OBJECT_NONE)
-		return 0;
-
-	if (!modifiable_virtqueue_fields(mvq))
-		return -EINVAL;
 
-	in = kzalloc(inlen, GFP_KERNEL);
-	if (!in)
-		return -ENOMEM;
-
-	cmd_hdr = MLX5_ADDR_OF(modify_virtio_net_q_in, in, general_obj_in_cmd_hdr);
+	cmd_hdr = MLX5_ADDR_OF(modify_virtio_net_q_in, cmd->in, general_obj_in_cmd_hdr);
 
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, opcode, MLX5_CMD_OP_MODIFY_GENERAL_OBJECT);
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, obj_type, MLX5_OBJ_TYPE_VIRTIO_NET_Q);
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, obj_id, mvq->virtq_id);
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, uid, ndev->mvdev.res.uid);
 
-	obj_context = MLX5_ADDR_OF(modify_virtio_net_q_in, in, obj_context);
+	obj_context = MLX5_ADDR_OF(modify_virtio_net_q_in, cmd->in, obj_context);
 	vq_ctx = MLX5_ADDR_OF(virtio_net_q_object, obj_context, virtio_q_context);
 
-	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_STATE) {
-		if (!is_valid_state_change(mvq->fw_state, state, is_resumable(ndev))) {
-			err = -EINVAL;
-			goto done;
-		}
-
+	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_STATE)
 		MLX5_SET(virtio_net_q_object, obj_context, state, state);
-		state_change = true;
-	}
 
 	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_ADDRS) {
 		MLX5_SET64(virtio_q, vq_ctx, desc_addr, mvq->desc_addr);
@@ -1388,38 +1372,36 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 	}
 
 	MLX5_SET64(virtio_net_q_object, obj_context, modify_field_select, mvq->modified_fields);
-	err = mlx5_cmd_exec(ndev->mvdev.mdev, in, inlen, out, sizeof(out));
-	if (err)
-		goto done;
+}
 
-	if (state_change)
-		mvq->fw_state = state;
+static void modify_virtqueue_end(struct mlx5_vdpa_net *ndev,
+				 struct mlx5_vdpa_virtqueue *mvq,
+				 int state)
+{
+	struct mlx5_vdpa_dev *mvdev = &ndev->mvdev;
 
 	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_MKEY) {
+		unsigned int asid = mvdev->group2asid[MLX5_VDPA_DATAVQ_GROUP];
+		struct mlx5_vdpa_mr *vq_mr = mvdev->mr[asid];
+
 		mlx5_vdpa_put_mr(mvdev, mvq->vq_mr);
 		mlx5_vdpa_get_mr(mvdev, vq_mr);
 		mvq->vq_mr = vq_mr;
 	}
 
 	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY) {
+		unsigned int asid = mvdev->group2asid[MLX5_VDPA_DATAVQ_DESC_GROUP];
+		struct mlx5_vdpa_mr *desc_mr = mvdev->mr[asid];
+
 		mlx5_vdpa_put_mr(mvdev, mvq->desc_mr);
 		mlx5_vdpa_get_mr(mvdev, desc_mr);
 		mvq->desc_mr = desc_mr;
 	}
 
-	mvq->modified_fields = 0;
-
-done:
-	kfree(in);
-	return err;
-}
+	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_STATE)
+		mvq->fw_state = state;
 
-static int modify_virtqueue_state(struct mlx5_vdpa_net *ndev,
-				  struct mlx5_vdpa_virtqueue *mvq,
-				  unsigned int state)
-{
-	mvq->modified_fields |= MLX5_VIRTQ_MODIFY_MASK_STATE;
-	return modify_virtqueue(ndev, mvq, state);
+	mvq->modified_fields = 0;
 }
 
 static int counter_set_alloc(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
@@ -1572,6 +1554,82 @@ static int setup_vq(struct mlx5_vdpa_net *ndev,
 	return err;
 }
 
+static int modify_virtqueues(struct mlx5_vdpa_net *ndev, int start_vq, int num_vqs, int state)
+{
+	struct mlx5_vdpa_dev *mvdev = &ndev->mvdev;
+	struct mlx5_virtqueue_modify_mem *cmd_mem;
+	struct mlx5_vdpa_async_cmd *cmds;
+	int err = 0;
+
+	WARN(start_vq + num_vqs > mvdev->max_vqs, "modify vq range invalid [%d, %d), max_vqs: %u\n",
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
+		struct mlx5_vdpa_async_cmd *cmd = &cmds[i];
+		struct mlx5_vdpa_virtqueue *mvq;
+		int vq_idx = start_vq + i;
+
+		mvq = &ndev->vqs[vq_idx];
+
+		if (!modifiable_virtqueue_fields(mvq)) {
+			err = -EINVAL;
+			goto done;
+		}
+
+		if (mvq->fw_state != state) {
+			if (!is_valid_state_change(mvq->fw_state, state, is_resumable(ndev))) {
+				err = -EINVAL;
+				goto done;
+			}
+
+			mvq->modified_fields |= MLX5_VIRTQ_MODIFY_MASK_STATE;
+		}
+
+		cmd->in = &cmd_mem[i].in;
+		cmd->inlen = sizeof(cmd_mem[i].in);
+		cmd->out = &cmd_mem[i].out;
+		cmd->outlen = sizeof(cmd_mem[i].out);
+		fill_modify_virtqueue_cmd(ndev, mvq, state, &cmd_mem[i]);
+	}
+
+	err = mlx5_vdpa_exec_async_cmds(&ndev->mvdev, cmds, num_vqs);
+	if (err) {
+		mlx5_vdpa_err(mvdev, "error issuing modify cmd for vq range [%d, %d)\n",
+			      start_vq, start_vq + num_vqs);
+		goto done;
+	}
+
+	for (int i = 0; i < num_vqs; i++) {
+		struct mlx5_vdpa_async_cmd *cmd = &cmds[i];
+		struct mlx5_vdpa_virtqueue *mvq;
+		int vq_idx = start_vq + i;
+
+		mvq = &ndev->vqs[vq_idx];
+
+		if (cmd->err) {
+			mlx5_vdpa_err(mvdev, "modify vq %d failed, state: %d -> %d, err: %d\n",
+				      vq_idx, mvq->fw_state, state, err);
+			if (!err)
+				err = cmd->err;
+			continue;
+		}
+
+		modify_virtqueue_end(ndev, mvq, state);
+	}
+
+done:
+	kvfree(cmd_mem);
+	kvfree(cmds);
+	return err;
+}
+
 static int suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
 {
 	struct mlx5_virtq_attr attr;
@@ -1583,7 +1641,7 @@ static int suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mv
 	if (mvq->fw_state != MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY)
 		return 0;
 
-	err = modify_virtqueue_state(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND);
+	err = modify_virtqueues(ndev, mvq->index, 1, MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND);
 	if (err) {
 		mlx5_vdpa_err(&ndev->mvdev, "modify to suspend failed, err: %d\n", err);
 		return err;
@@ -1630,7 +1688,7 @@ static int resume_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq
 		/* Due to a FW quirk we need to modify the VQ fields first then change state.
 		 * This should be fixed soon. After that, a single command can be used.
 		 */
-		err = modify_virtqueue(ndev, mvq, 0);
+		err = modify_virtqueues(ndev, mvq->index, 1, mvq->fw_state);
 		if (err) {
 			mlx5_vdpa_err(&ndev->mvdev,
 				"modify vq properties failed for vq %u, err: %d\n",
@@ -1652,7 +1710,7 @@ static int resume_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq
 		return -EINVAL;
 	}
 
-	err = modify_virtqueue_state(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY);
+	err = modify_virtqueues(ndev, mvq->index, 1, MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY);
 	if (err)
 		mlx5_vdpa_err(&ndev->mvdev, "modify to resume failed for vq %u, err: %d\n",
 			      mvq->index, err);
-- 
2.45.1


