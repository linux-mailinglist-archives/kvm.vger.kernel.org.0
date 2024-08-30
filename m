Return-Path: <kvm+bounces-25499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A3354965FC6
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 13:00:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22C311F23238
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 11:00:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8768215C147;
	Fri, 30 Aug 2024 10:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Frcrs5qE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11DB1922F4;
	Fri, 30 Aug 2024 10:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725015563; cv=fail; b=Z5ptBufXAbCn1l8MhNLu6WcB09/sVHcvcRDEdxNaNQgIpPul+qIaklXpBXWMFmiahx9CjwdfysChz6VBfJjHZS/Ndnlya7ZNkei4oOrSWkKf4/clyKYHHdBE/2SI/mOuc+HQDz039B8sKOQgGru1cjaiSxLDIEwaVEwcYFGUtq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725015563; c=relaxed/simple;
	bh=JTYCyqAffPOq1r8bi0XVVsYkShwrQ7IXml5fZY7VTY4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gz41jbYdY3pP70hT0R6AFul2IsySR2bcNnwERtH2Df1yGffvTN3u6cMx9VNzmVti47Q0e9PaTWUR3AZLZHyiwNp/Xq/9dijfRd/bwqdX+ppD65bAPcGyQWpHmeR66a2IFy8hFGdRh3SPnV9RPQGaS3yqkutcAcoJRMRZxoth87A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Frcrs5qE; arc=fail smtp.client-ip=40.107.243.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WM50P9zLx9mqkNwigFGQ9AmfQM7c9MpKCS8ztnBVhHKKLzlXcFE0Oo4VuZVpzxHOxJygNv2GMOw7PZDlacdz9omCL1SU6pl5kG1kBKPl9M4OGPX3srMa/C52+v6z7PG/4/MuQxjSwClRPk02i5HrJllDUyQXLwaRvTprK+W10jMIE0DsEQiVMQJzhUW9oXcz/M82fdkipx644IEW01MrS8H5UwKn9fA8geBiki/aQnQ+GjyXXZ1I8Ikj3kmQSyOLLtLybA0lhlYjKFLzED3PnFi7ZKH1G64IFenuyh+g97ui5i57AJV0QzWazgIx9y24TwrtMdHiJKlTdm4IEsjPkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uUhQYi8mfaMvGBOBT7NFXWVPvHHkvNWaiyy39e/q70c=;
 b=PMubnBsVlBB7t37TSCGt+E8jB+WZTzJfqgOptMz1y2WjHh9W+vFJcR7xAhipsDC+o5WKAa90kak5CVhLvjBH6QYPckx5EyleOSz8wuka6vvTm8jlbToWjyJhTe/1+e3Irmqy/cx0+sy03TkcjGvxyJfgoCCZQyUqETqKakSO+OTmAcQ8QhF4sAEkA4Jx9e1rdMPmSIiy2WUg/UQ4b5pOP19+KLagTMBffUG61A21xVb0sFV2O7Ga+rXhe3Fgbn77VPxSIQanQiNXyKWe9Cng2ZQtAqbEaaxRSq+1K8BjwGTnWcarFkRifGqsmAnWju2gBG3lULM58MebdRLTnDksxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUhQYi8mfaMvGBOBT7NFXWVPvHHkvNWaiyy39e/q70c=;
 b=Frcrs5qEeJ/WStny0yD1MN4SjnCTEMI+lFM7DD7MQzaAS2SlUx+cDG5jiGdAKaBIi3cANj0HCe97XJ+DEZ6077NLRNKhuXo9b995fR7nXOY626TIj504iD2IE/Mzg0WMs8dXGXK9iKFqSMpC9vkWDy64GqjHY7vv04KxWLwy0tQVi5GpfCt6AESL7XmdSUHLSa2K5OgQrpHRDumTcmAVtSdyN4lQ414svgtyiQR9zhu9qsKkOyvyHzH6MqS1FFCF4WHHLHN+WGG4/WXeuTkzJL+yPJXsVfyHBymlZVvPl6gcKebZDstzslManFXRNpwglXcGYmMFRPhTrvSYO+SClg==
Received: from CH0PR03CA0010.namprd03.prod.outlook.com (2603:10b6:610:b0::15)
 by SJ1PR12MB6123.namprd12.prod.outlook.com (2603:10b6:a03:45a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22; Fri, 30 Aug
 2024 10:59:17 +0000
Received: from CH2PEPF0000009A.namprd02.prod.outlook.com
 (2603:10b6:610:b0:cafe::e0) by CH0PR03CA0010.outlook.office365.com
 (2603:10b6:610:b0::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28 via Frontend
 Transport; Fri, 30 Aug 2024 10:59:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH2PEPF0000009A.mail.protection.outlook.com (10.167.244.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 30 Aug 2024 10:59:17 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 30 Aug
 2024 03:59:07 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 30 Aug
 2024 03:59:06 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Fri, 30 Aug 2024 03:59:03 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, <virtualization@lists.linux.dev>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Cosmin Ratiu <cratiu@nvidia.com>
Subject: [PATCH vhost v2 2/7] vdpa/mlx5: Delete direct MKEYs in parallel
Date: Fri, 30 Aug 2024 13:58:33 +0300
Message-ID: <20240830105838.2666587-4-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240830105838.2666587-2-dtatulea@nvidia.com>
References: <20240830105838.2666587-2-dtatulea@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009A:EE_|SJ1PR12MB6123:EE_
X-MS-Office365-Filtering-Correlation-Id: dc065363-0d0d-4ebd-77e2-08dcc8e2cadb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?emZ5MUZqQXNrZjU0bWFmeFlkUUd3SHpWV0lZZHNac2FVOG8rUGNzUmp5S3JZ?=
 =?utf-8?B?YURYYkJ6SkFYaFhGb0dNVFpZTkY5Q0JUTVp1ckpEOSszcHIzUDdjNTRYM2Vw?=
 =?utf-8?B?dXJzVkRrd3JCaENEazM1RHVFTDhOK2w0UHpLRi84OWhRS0NCYUFnRW1BeWlS?=
 =?utf-8?B?VUJJTkNIaTIwS3cySGVZUmJvYStjS1R6Ky83Nk0zdXRqWVhydXdlSHhBTkcx?=
 =?utf-8?B?L1lLSU5pclRzNFRmVFNRbjltUGQyRm01djRaaWRlVXlqOUhONHJKRGVkdzA2?=
 =?utf-8?B?T0NvVENwMHRXVlRXLzVWcyswd2Mra2s2cWdFMkVtbldoNEh0b3MvZ1hzNUo0?=
 =?utf-8?B?UVBqMEtadFg2Y3ZHTjdkbFBjU2pEaVhEU1pmQm9Xenl0Tk8zeFlCdFg1bTh3?=
 =?utf-8?B?UlhMNVBnZnNJTUVFd3o3U0F5QzJWWnV4VnJpNEgzZEZIWmY1MmRrcDRrTjNx?=
 =?utf-8?B?T29IVlRsUXZnaU81THJyOXpOOHg2dGRaVFRVbi8zME5TQS9VYi9aZG1yVmRu?=
 =?utf-8?B?cyszSlpnOFNyRGFDaDJHSS9lbE1sS3RqRHFMaGJKY0VFSjFPdnNIMnJiLzhG?=
 =?utf-8?B?R05mdy8wb1dlTkFtWUxVRytIYW9WVjc3dmxGZWkrZVpZREtmcU03OTRPaVR3?=
 =?utf-8?B?MkNiYXNkZCtFYU1RdjRiU0hiL2xNamZYVkRWSGdRaENpZ3hJS0FyV2RqRnBp?=
 =?utf-8?B?eDJxVW1wVWMyd01JQzg4ZDNEU3UzU0RpSDE5cDY0OHR1ZmQ5ekRKT1Y3S2FT?=
 =?utf-8?B?N0RTTC9DSkRhRWR3Rktyazd1NUlWQmJIeENuSGlla0htTGFyQXI2NWZLWi9y?=
 =?utf-8?B?QzliUDRFd1JjZ3lnMFFoejhjL1ZHKzQ5NGRpd0E1Rlk2RlQxMVJvQk9UNDZV?=
 =?utf-8?B?ekduMk9PVklDVU1qQlZvRGRNOHdSenAxayttSWVKS2llZ1pYMnYzUzd5VWhL?=
 =?utf-8?B?YS9Bc2FhQVVDTENEWVdOODBxTElqRzA1VmRPcTJZWk9jWmsxNUNKd3VvN0E4?=
 =?utf-8?B?dzdPemJkeHBLcDYxNTRMcWMvQmFvSnhjUENaa2lQKyttM1lDMHgwSnNFV2Vx?=
 =?utf-8?B?MDhIRTJXWlhSUGg3anZkTzhJRzlMSEcwY1BTNFdQSHFsaUt1bUlVZzRBckRq?=
 =?utf-8?B?Y0ZCMmY0SGRPZWUraVBobjQ1UmZJK0xqcUhtV1prSlVwekFoMmNoMHRsUndH?=
 =?utf-8?B?SGNGNStvWDFpcVJJMW0xK0c4aHhvdmlZNHVSbGIreXgxZXV5b3NJc3piTith?=
 =?utf-8?B?eXE4RmROQ2ZHNFEwc0VGRnFWRE1jbllNeWdWQW5YeGZIQlBadzAyQlZ3cm5a?=
 =?utf-8?B?MGxiUlJSYisrb0J6R0cwRk1IeCthMGxISWt6eEZLTWZiNlRTam9RWHlMb0ps?=
 =?utf-8?B?OHI5amxZaGRxZVBDK3JWWlBmbTVGUVFKemxtL0JzcmF2RldiSENQUjVSZFBu?=
 =?utf-8?B?K0l6UnhubkdOYlkwT2VKR08rQTg0cDQyVWJndHFVQ3UrN3RzZFR6enRvZDF2?=
 =?utf-8?B?RzRyN0xrWmdxc2hFdHd0anNPUmhydkFzYm4zV2kxcC9kcEpEcFlzdTA2U1hC?=
 =?utf-8?B?eld1cmcraTdhL1hxa1RBR3ZtalJEcFVDMXpkYU5tUWVObG5VUjZvOTJTK0JO?=
 =?utf-8?B?dm1lOVJVZFZIUFpTZFEraktHNE93T0JsOCtJMVlWVXR1ZVp1WEhMQUlyV2gx?=
 =?utf-8?B?bSt4UTEzdkw3ZjdHaDh5SURsZEhialczeXorM29nU0N6RHpRSWFSTFNGUGUz?=
 =?utf-8?B?eFJJSGVUeTlkQ2t4aGh4K1hxVlBaeHpGZVFaZnJRTlovTGpnMGl5NlZUOGVm?=
 =?utf-8?B?OEdqM3QzK0pBYzdlOWNQS1JSQ2wvM2s0N1dSVjR4aW9ZZGVycjJKT1ozV3FP?=
 =?utf-8?B?d0kyS2l0YTY3VUkvaS9lQ1RabnVRRU1pZjFhY2JMYjBqZWdna24wR2pwemVX?=
 =?utf-8?Q?hOPZIGRwE1w+9CD5zmNBz4rYMDAGOgva?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 10:59:17.0218
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc065363-0d0d-4ebd-77e2-08dcc8e2cadb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6123

Use the async interface to issue MTT MKEY deletion.

This makes destroy_user_mr() on average 8x times faster.
This number is also dependent on the size of the MR being
deleted.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vdpa/mlx5/core/mr.c | 64 +++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index e72fb11e353d..64bcae2bae8a 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -55,6 +55,11 @@ struct mlx5_create_mkey_mem {
 	__be64 mtt[];
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
@@ -257,6 +273,53 @@ static int create_direct_keys(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *
 	return err;
 }
 
+DEFINE_FREE(free_cmds, struct mlx5_vdpa_async_cmd *, kvfree(_T))
+DEFINE_FREE(free_cmd_mem, struct mlx5_destroy_mkey_mem *, kvfree(_T))
+
+static int destroy_direct_keys(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr)
+{
+	struct mlx5_destroy_mkey_mem *cmd_mem __free(free_cmd_mem) = NULL;
+	struct mlx5_vdpa_async_cmd *cmds __free(free_cmds) = NULL;
+	struct mlx5_vdpa_direct_mr *dmr;
+	int err = 0;
+	int i = 0;
+
+	cmds = kvcalloc(mr->num_directs, sizeof(*cmds), GFP_KERNEL);
+	cmd_mem = kvcalloc(mr->num_directs, sizeof(*cmd_mem), GFP_KERNEL);
+	if (!cmds || !cmd_mem)
+		return -ENOMEM;
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
+		return err;
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
+	return err;
+}
+
 static int create_indirect_key(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr)
 {
 	int inlen;
@@ -565,6 +628,7 @@ static void destroy_user_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr
 	struct mlx5_vdpa_direct_mr *n;
 
 	destroy_indirect_key(mvdev, mr);
+	destroy_direct_keys(mvdev, mr);
 	list_for_each_entry_safe_reverse(dmr, n, &mr->head, list) {
 		list_del_init(&dmr->list);
 		unmap_direct_mr(mvdev, dmr);
-- 
2.45.1


