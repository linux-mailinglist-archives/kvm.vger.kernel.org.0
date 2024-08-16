Return-Path: <kvm+bounces-24364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77A8995450B
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 11:03:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB6E8285497
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 09:03:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D50DB1459F6;
	Fri, 16 Aug 2024 09:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OVEOJtrC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351131422D6;
	Fri, 16 Aug 2024 09:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723798960; cv=fail; b=Dz/soKjiPjcniD3UalYvvrlhgC1N4/NtfwqA47cWnx4ofmpllMGmw/mUNxDfFl77OSYQsR/Ik2yGhZieOcgM0jCeeOW0mWxVO+2uCuKzY8XUtKq+AWnZmvOsOihDxUEIiAc672FOo1CpdRmY+z96+1nKeSKqz8K3Ii1sYX3KZDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723798960; c=relaxed/simple;
	bh=oqa9ogSQcJmTyK2S054y45x8kmGxO9+mUUyiMWlq58M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JvrmVMjxOHrbzow422jEfDckmvMJlVPOSOC/Z74KeM3s9CTIh3XcvRCb2e/lqYuuHmZEBVFzO6xASgHht7Rz6ULFcA/+oeWD1+SzMPZsQGrNor60Qx9YweSAG9ybZmMtHUIH8KkM/1nU3CKr66wjkxEZz2w6Z3oP6Xx+eMZvMW8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OVEOJtrC; arc=fail smtp.client-ip=40.107.94.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LMkkPc7vo9f+J87eH0HDYNIEseX/cisCwR8sulZcYW2kNa6K1hngjI/qpDzJNOR3mMoUtqSBqHyPrq887e5d7WvcjNPqcYDEXsNpcu751niuoUv8I53fLaRWH0g0RDUXa8VEi2TKKgG8pCdfPF1R2YLwWlKhNraZS8EuNTsXk89JfPTdX2TgMSd9kBvvHaVcJVHOaTRDM7z61DW7KkPha2IB9VMqk9lcD9RD+l6UFNN5yX/IAohLqyyFFL9P8OvLSaKnqDEqsZRoiv1gNzibxrxujT+ZBBIyZYB5lx56IYnEV2aaK6BwjqMFJqcWltwtYFa/8dpJxiwm44qz3eua4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cif3mJQqYHYaM3UbOWVZFvwomEcqYidBva7Km0ICe/Q=;
 b=a+LBj/HVzlV+vhMzs4asQUaslB5zIqhJIDHCZ69msVaQEAWIseLTXmL74eSNgPSPS7nVq0zhQZTDgChlCkO9yGSruklGhKFTfXtlE1b+8XKaiI4mCo43z8Eow57CS0Xkapc8wj0afrYfp2RYO2GU4mLV32VeF+oQdPOmqphgleJ8AvpFwhwaenJoR4OMQwqIH6kbxe9MisUzWgJaNKmKyPZ9Qubsj/nrqBl17abTtpdJ5PDyryLevPQs7ZR9kngPYgGC+yVUpkkIQfEO2Lju0+lwGmADjBlA4bukx1SIRzZP5UqfcSFzcVpbDRmtxt3ZSfPbTy7rH5FUCQrJekmgAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cif3mJQqYHYaM3UbOWVZFvwomEcqYidBva7Km0ICe/Q=;
 b=OVEOJtrCUSHL39Ks56aD2FKPTTvHR7TA+qsz36W+hJ/h6ozaZ3jDf0TxMfHDT9j0ipnWGZAOTMFc3j/AtRqlbV1r5C0kfQEZqvOM2gbDbb0jTbS+BTB0J3vuQZgk0lR91z+bb+JA6k3xRh87q3GJuwN7IhD7EJZZhWvcGiADWYoryTWYLj2VYfgbC+0aCXClpYXurPAhvljwpzNoA6ACSLUeK7Y+90oekA459x1PIMZY99Lfj+Nz47dewU/SI9bL+ki515YHwDvBwvMXEx4zDM0M4D5vo1X5KwVU8K5yhHQNHz6xHBLfHHdbgpqO7E20075H/KEGarvRXJUecqwhgw==
Received: from DS7PR03CA0110.namprd03.prod.outlook.com (2603:10b6:5:3b7::25)
 by BL3PR12MB6427.namprd12.prod.outlook.com (2603:10b6:208:3b6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Fri, 16 Aug
 2024 09:02:34 +0000
Received: from DS3PEPF000099DF.namprd04.prod.outlook.com
 (2603:10b6:5:3b7:cafe::d8) by DS7PR03CA0110.outlook.office365.com
 (2603:10b6:5:3b7::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.33 via Frontend
 Transport; Fri, 16 Aug 2024 09:02:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099DF.mail.protection.outlook.com (10.167.17.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7849.8 via Frontend Transport; Fri, 16 Aug 2024 09:02:33 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 02:02:24 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 02:02:24 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Fri, 16 Aug 2024 02:02:20 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>,
	<virtualization@lists.linux-foundation.org>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Si-Wei Liu <si-wei.liu@oracle.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Gal Pressman
	<gal@nvidia.com>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH vhost v2 03/10] vdpa/mlx5: Introduce async fw command wrapper
Date: Fri, 16 Aug 2024 12:01:52 +0300
Message-ID: <20240816090159.1967650-4-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DF:EE_|BL3PR12MB6427:EE_
X-MS-Office365-Filtering-Correlation-Id: c0eba58a-0c9f-4a68-dae3-08dcbdd22ae4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lSD5fIvWNcp5q9+gNnmxqO0jGu0fXYWKES6SG1tNuuDVbo3vQCH7A650X9LO?=
 =?us-ascii?Q?rcNxh5lDw7Y5KGPbARFfu8gbHt+xO6iljPPVReqdgjmgowb35AqSAnAAYOfS?=
 =?us-ascii?Q?122LxNNMvgnYZebNBYr5KRkAe+falQ8Z99uPKypHe01AFLBTaVBc3c/jY6sx?=
 =?us-ascii?Q?nil3S0W5R1AO8fz3kxcvCV8WmuIOolNGyBLhVrFpv2i1XHnMpae5znhNwimD?=
 =?us-ascii?Q?W9p+9oRENfZa+VBda+U8T7ZCPoO3luK2X42RI4FZY0zY2RITR67zbm1bJdm7?=
 =?us-ascii?Q?8aS37OW4fspbNBjhutVqseBLlrWGVOTQDelVmWzvsnbRv7jkV9iVzw8NQzp9?=
 =?us-ascii?Q?b2uqgiITejI5LWiHhmHuIN3KiswIisS3AhSSzonIi6COrv1yvF7GybFnqpLd?=
 =?us-ascii?Q?bCZXBKfyuAFtB/I5RzsGJBamGxy6rOY8E3sQDz7uLUghs/03syIgUvZxBT1d?=
 =?us-ascii?Q?X1EQVJD2APiOgJt9hfOyZJIIDRgZygkBe5WShkYo9tq+fs990dJGyvqAUg5M?=
 =?us-ascii?Q?ixeGMph77Ef711od2XeOyoN1ZLLFyl0WOtZMVPtAKMMfDTSUjP8WW1LrnHTC?=
 =?us-ascii?Q?/PsZgFM+o/qFyQp3dZo7OXMXyz7Y85pk2BoGFvRy5lvo6ZSd1YTqqoxQia5i?=
 =?us-ascii?Q?+DmPqUpQlIKClYzQzvKhekvavduygwtCcEJAfbkybeJLRH8Xw41X7A9MwKxq?=
 =?us-ascii?Q?obPI23cOm2GFv+ipjC9tv+cKGhvjdH2dq/bEAnx7LR7xndzh/shwPOcQoz3J?=
 =?us-ascii?Q?MsGxhMxfdHfo0SaawM9ELNtK7f2VFfyJWT9XX2+Jagh9wh0EwlrrJ280QaaW?=
 =?us-ascii?Q?7H4WRCjtW5t5Nl3T4LXV7ycuLzj+drS5jAQHV9/V9GbVaZYBNvtSPcqtWNvO?=
 =?us-ascii?Q?winO4b4SdRYfGVusTNfwOC6PmlBTQSQhTiQsx6PLT8lCztGY2ypC+SxEhY1n?=
 =?us-ascii?Q?6FE3F/kaA/VnZtVdBhv9ZAMa8kiwKz+Xf63wMlVETW0PgxzkumFWjb0dEWwB?=
 =?us-ascii?Q?rWCqjprCpNawyOjArdJeM9Hn5GBvEdvQQgj5NP44pIvlm/4gfX87/ZnXzrxu?=
 =?us-ascii?Q?iDFQr6PwpSh1pFd4hcAOWS/S9EADQkrD+TZghC5LY697erf1Ug53Y+qL2a27?=
 =?us-ascii?Q?kPLOeXk3SeFgEIdt7NRVyRhx/+exxhpQ/iWNVcnELDjZx3RTCG9nGVVjMO8y?=
 =?us-ascii?Q?2gCAq6kaPYpG0atVbemaGVfdo48HVGZrIRu+k1sLAJWPekikWFJqtPV4b0sN?=
 =?us-ascii?Q?ZxX+BfY2x+P8SzkaY5oG/r5yE/l/yJBlE/+a6d4ezXq5BnEV2AlqwsCWI20/?=
 =?us-ascii?Q?Y0hqDl9ItkBQfuwYy/+Fvg7Hi7i01ofAvUf9biq6U41bW0eVdaullKY+F1oZ?=
 =?us-ascii?Q?oGo7oYv2cZCj/KGVp6PcwE9wQoaHzky6/Sxaxxdp+xZtbQivPtB6TIeP6k4b?=
 =?us-ascii?Q?AsmZOcP1pNeNNFSphPUS18TcSPk9Gwvv?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 09:02:33.9097
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0eba58a-0c9f-4a68-dae3-08dcbdd22ae4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6427

Introduce a new function mlx5_vdpa_exec_async_cmds() which
wraps the mlx5_core async firmware command API in a way
that will be used to parallelize certain operation in this
driver.

The wrapper deals with the case when mlx5_cmd_exec_cb() returns
EBUSY due to the command being throttled.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h | 15 ++++++
 drivers/vdpa/mlx5/core/resources.c | 73 ++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index 424d445ebee4..b34e9b93d56e 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -105,6 +105,18 @@ struct mlx5_vdpa_dev {
 	bool suspended;
 };
 
+struct mlx5_vdpa_async_cmd {
+	int err;
+	struct mlx5_async_work cb_work;
+	struct completion cmd_done;
+
+	void *in;
+	size_t inlen;
+
+	void *out;
+	size_t outlen;
+};
+
 int mlx5_vdpa_create_tis(struct mlx5_vdpa_dev *mvdev, void *in, u32 *tisn);
 void mlx5_vdpa_destroy_tis(struct mlx5_vdpa_dev *mvdev, u32 tisn);
 int mlx5_vdpa_create_rqt(struct mlx5_vdpa_dev *mvdev, void *in, int inlen, u32 *rqtn);
@@ -134,6 +146,9 @@ int mlx5_vdpa_update_cvq_iotlb(struct mlx5_vdpa_dev *mvdev,
 				unsigned int asid);
 int mlx5_vdpa_create_dma_mr(struct mlx5_vdpa_dev *mvdev);
 int mlx5_vdpa_reset_mr(struct mlx5_vdpa_dev *mvdev, unsigned int asid);
+int mlx5_vdpa_exec_async_cmds(struct mlx5_vdpa_dev *mvdev,
+			      struct mlx5_vdpa_async_cmd *cmds,
+			      int num_cmds);
 
 #define mlx5_vdpa_err(__dev, format, ...)                                                          \
 	dev_err((__dev)->mdev->device, "%s:%d:(pid %d) error: " format, __func__, __LINE__,        \
diff --git a/drivers/vdpa/mlx5/core/resources.c b/drivers/vdpa/mlx5/core/resources.c
index 5c5a41b64bfc..22ea32fe007b 100644
--- a/drivers/vdpa/mlx5/core/resources.c
+++ b/drivers/vdpa/mlx5/core/resources.c
@@ -321,3 +321,76 @@ void mlx5_vdpa_free_resources(struct mlx5_vdpa_dev *mvdev)
 	mutex_destroy(&mvdev->mr_mtx);
 	res->valid = false;
 }
+
+static void virtqueue_cmd_callback(int status, struct mlx5_async_work *context)
+{
+	struct mlx5_vdpa_async_cmd *cmd =
+		container_of(context, struct mlx5_vdpa_async_cmd, cb_work);
+
+	cmd->err = mlx5_cmd_check(context->ctx->dev, status, cmd->in, cmd->out);
+	complete(&cmd->cmd_done);
+}
+
+static int issue_async_cmd(struct mlx5_vdpa_dev *mvdev,
+			   struct mlx5_vdpa_async_cmd *cmds,
+			   int issued,
+			   int *completed)
+
+{
+	struct mlx5_vdpa_async_cmd *cmd = &cmds[issued];
+	int err;
+
+retry:
+	err = mlx5_cmd_exec_cb(&mvdev->async_ctx,
+			       cmd->in, cmd->inlen,
+			       cmd->out, cmd->outlen,
+			       virtqueue_cmd_callback,
+			       &cmd->cb_work);
+	if (err == -EBUSY) {
+		if (*completed < issued) {
+			/* Throttled by own commands: wait for oldest completion. */
+			wait_for_completion(&cmds[*completed].cmd_done);
+			(*completed)++;
+
+			goto retry;
+		} else {
+			/* Throttled by external commands: switch to sync api. */
+			err = mlx5_cmd_exec(mvdev->mdev,
+					    cmd->in, cmd->inlen,
+					    cmd->out, cmd->outlen);
+			if (!err)
+				(*completed)++;
+		}
+	}
+
+	return err;
+}
+
+int mlx5_vdpa_exec_async_cmds(struct mlx5_vdpa_dev *mvdev,
+			      struct mlx5_vdpa_async_cmd *cmds,
+			      int num_cmds)
+{
+	int completed = 0;
+	int issued = 0;
+	int err = 0;
+
+	for (int i = 0; i < num_cmds; i++)
+		init_completion(&cmds[i].cmd_done);
+
+	while (issued < num_cmds) {
+
+		err = issue_async_cmd(mvdev, cmds, issued, &completed);
+		if (err) {
+			mlx5_vdpa_err(mvdev, "error issuing command %d of %d: %d\n",
+				      issued, num_cmds, err);
+			break;
+		}
+
+		issued++;
+	}
+
+	while (completed < issued)
+		wait_for_completion(&cmds[completed++].cmd_done);
+
+	return err;
+}
-- 
2.45.1


