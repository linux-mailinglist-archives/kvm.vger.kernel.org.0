Return-Path: <kvm+bounces-25500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E8D6965FCA
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 13:00:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7324A1C23C77
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 11:00:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 116A018EFFB;
	Fri, 30 Aug 2024 10:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YuSClkX1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92622192D6C;
	Fri, 30 Aug 2024 10:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725015569; cv=fail; b=VQ3mvL3mLJ6IBhPawkSea4OxYfv5hWOBeA4I6Xe4pswm4pqWwlnMoLIijRbN3CFpqsul40MYHEEleyXMIaZhcpB/zA7OAn2s5D3N97LWeVr7tHDqKwhXO5rdou84IiVORugMKkmkqTimCrLkEvtsbe9O/mxDrbyLVY7yCcqqqR4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725015569; c=relaxed/simple;
	bh=BjCE2IXi+eCIR9+jAl5ssp06P2II3arGbQjk+SEgNBU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nvNFwjwIsNxe0TOIk33+9ANp6VoXZpJvMZC1jITKuvY3k2iXmd3goxkwIuFdJ3tsIh8ImLBOkdv2KeuhvyIxUxwuJ7x/RuZtO8pDxWsgiQTwb48MX41eyXv7nVLM8oowK3xtq6wIkHdfDA/qaaW0dzRVTERiDi3caPgPFpxIhwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YuSClkX1; arc=fail smtp.client-ip=40.107.237.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ColBTrsYsgFKkaZzeoQjbX/YwM96VAnWn58+b74+992qU/jZZ8l+zSqI8No8OCvS5aF4DdhnTSzpiVF1GSAVH+4vcYQcZhxfO7sxPSS7dqIjSeFoojf/W1gGxFlbVivpy8gNuvGPn/KFmeVUDLQ171zERQ/IPDkRva2PdMTsKnm3KScZMO3HRr5r9S/zdlbzsYbTvOll5ICPaw9osPYVKdYFesKJZQYOkizdZLP1LAsNgexiy0rA/hyK8B9QFF34CYlpVgngonnwGFAv4Fp4orM7sQQKphBdVXEitutFWGtnSdED/+9EyhxipvNUxCJXvyvIsmTPrrVl3Hcor6Vs3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fp67rwtDEa6y7plVm9B7RQAtIKtBV8z4b4+Z4RpFf4c=;
 b=ZQ9VH9oB3HWRN1/ymNarzQgy59+rxeAmvvk2OHwgwf6BeEUirR7RfKnST7tk/ljSutUiF62LXCkyCI8jOxA6yawBR/hSXusFqgag9DOSHPxuQf7zaksIyZgg/r5LT90bKFzCc91srySF7elRdhuLvQFc+3RDFvqhllxhgbu6z1o186+g+5y7zEeriqPbxJhdk3IdlUvCDXwbZ+tFi2tejq+bglVEkAwQ+Ysl6j0Y+4wkTkxmM0BvQ3xvE5jWsQsMgsOUKXZKGZzvDn/HCEHJFrKe49Ef5Q610giYj0YKypUoLUtgsl3suGi8jtZnN5wv8vAsGOoLMcUOA98o3T0iEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fp67rwtDEa6y7plVm9B7RQAtIKtBV8z4b4+Z4RpFf4c=;
 b=YuSClkX17+TKLICiHJ9iWLIWeE0XIeb0p8aO4pNDrWrS8B/HScMJ8Dw1nUDhzVhq6ii0ze0yLxx3h9LxPgiNWrpaE3C7vIg8ozl9mFtfWwR+NZu2E2j4uN2FHXWPyuMzznLBEYhb3nJMtFlflLEQnqZp7asoS4WYGXjt96RjknQG26sGCljWIEOGZbvssueuwjGy4fH/g7FVx3SpaS9UAetUEie/M2CEWZRdhXHLq6W5+pv4KGuL3g1lKSPWCgdoXOjaTK+C25qMhqszyBHdcdt5eT97jUzolmClGBsiICfND0QQgwUxA+UwQi9JClaMSfvSYEnLbubdUlxXpMpCgA==
Received: from MN2PR22CA0019.namprd22.prod.outlook.com (2603:10b6:208:238::24)
 by DS7PR12MB5888.namprd12.prod.outlook.com (2603:10b6:8:7b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.27; Fri, 30 Aug
 2024 10:59:21 +0000
Received: from CH2PEPF000000A0.namprd02.prod.outlook.com
 (2603:10b6:208:238:cafe::d7) by MN2PR22CA0019.outlook.office365.com
 (2603:10b6:208:238::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.29 via Frontend
 Transport; Fri, 30 Aug 2024 10:59:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH2PEPF000000A0.mail.protection.outlook.com (10.167.244.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 30 Aug 2024 10:59:21 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 30 Aug
 2024 03:59:10 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 30 Aug
 2024 03:59:10 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Fri, 30 Aug 2024 03:59:07 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, <virtualization@lists.linux.dev>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Cosmin Ratiu <cratiu@nvidia.com>
Subject: [PATCH vhost v2 3/7] vdpa/mlx5: Rename function
Date: Fri, 30 Aug 2024 13:58:34 +0300
Message-ID: <20240830105838.2666587-5-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000000A0:EE_|DS7PR12MB5888:EE_
X-MS-Office365-Filtering-Correlation-Id: a685ae5a-e078-4f9f-834c-08dcc8e2cd4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aVrepsfhCe7Fz19scTi+nXVg5YdgjmWyXhDV3r3RSqXyQKGopJ0KR/5Usrew?=
 =?us-ascii?Q?qMUIGABMqhNBVuGT7LvyDGxqh8Sem7Kfk1/QDCns/PDcm44VovV815soiLvM?=
 =?us-ascii?Q?PZBiqBOpOnRpJMXm/0jzOptISW2ebnwm5QCqKS9NcYJl1MX1kqeTWSM+Kz3H?=
 =?us-ascii?Q?S/+dN7I4lEo6ZGCYKSYviI/LJclcOFUB43/QRu2x/D+iWXgwv06gNGVZMONj?=
 =?us-ascii?Q?PJtdff9lYOQi7UvkJ265Ih/n0hU56owqrMQ0ykrEgPPY8RD9lXGJB0ExPdnd?=
 =?us-ascii?Q?t0JLXdFB1m1PHDkwLphR6QO0hcgFKrUk4dCfKFzT7xpprgvFdPY37WbiL5mv?=
 =?us-ascii?Q?ydkiz1SDThbF47vDW40ePvZhDxD8aiaGjgHi1WStVu2q3PWxhQHgBnymwnmI?=
 =?us-ascii?Q?RhUk/brfXu4FhfNh7CUSd1bjDW+fZWJMy9RF1m/YwMbNzY7JtU+gswquTP6V?=
 =?us-ascii?Q?rmR9l4chyrpjYnDXBZm8ZqtIg/zbswHPK482zt9Yw65gDy66JiknNS7k55xo?=
 =?us-ascii?Q?3cGwRjB0S277ecmolPq+iAN1yKhIDb2BAie7ssuwll1XDFaLJW1SuOi3Yl6L?=
 =?us-ascii?Q?9bdguTiFxOzeBj4dPkwOniD6MfOYknxYT17V0KAOb5l7Jlj/SWX9h02EIh5X?=
 =?us-ascii?Q?sHTQLGKgnqpyVhRQ0LDhtKs9EBkQ25W09GfzaQ8e5UYNBsBXLCF9JXnvXnCY?=
 =?us-ascii?Q?4UkTqkBtNU2RGxI222lz/1sedUZRoJmuJh/eFbO+dHKNAQOt+oM4UcZ2ao0t?=
 =?us-ascii?Q?Qb5zHJC/jdnthSAO6dDHVMKI/cslcr3NGe4e6vO87JHSDtOgr1doighygGBW?=
 =?us-ascii?Q?aSSHf9EpCZmeh29k/Pkq3mTFAbcTic180gVOUToyRsxxNQBGyRn02+k+Xg9i?=
 =?us-ascii?Q?AfHnvfq2SbtSRrGWIbvFmZKFUcvIil6Cj63O+hmGS3R7mvAVhh0M6Ym5vapO?=
 =?us-ascii?Q?TwjMmephXHsTo5XZCBKncsV42jgzM0poT7NVqb4F0yoM+MR7gBZiiKFlDNLH?=
 =?us-ascii?Q?6VV/SIPeV/SAkI/Hc9B+F4uBXg6FbVt/mTtj00zf2ALLwtV7yTUGfBF1WG0a?=
 =?us-ascii?Q?ZAHt9BzfDyIb54+GHnKmMDgBNo4+NbeN5sq/upJLlKUR73dVbDEumpo4qpUD?=
 =?us-ascii?Q?sbV7duW9Z10paRo02Pq/it1iZBWYVNOe5KBKmgMK0UM2iOKHhCuJkEHoXMxi?=
 =?us-ascii?Q?+u8SPSwbzukTYPBok87OyRSirSIFBHhJ6AQ68quZTkzVRQn56WKqFLd/85DF?=
 =?us-ascii?Q?nB/zZY99HLS12mZJ/eQL+ZPPnWC3kq6Ntvp22TNWDyi9BtvJpejqaBERdTCz?=
 =?us-ascii?Q?kTXEXim6n8agihqw++rgF0K479LoxMgo/sxuM8MDIZMn/ui2e4r575jvMTAm?=
 =?us-ascii?Q?isXhLd0lZ4IW03xPn1rkOGdQCA+s2DMkFHdxgkwmbOrhkVJL89w0wGGLvCmE?=
 =?us-ascii?Q?xkLt2iqDmIqGwDxwqfXguxYyt2uKoXp2?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 10:59:21.1025
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a685ae5a-e078-4f9f-834c-08dcc8e2cd4c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000000A0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5888

A followup patch will use this name for something else.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h | 2 +-
 drivers/vdpa/mlx5/core/mr.c        | 2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index 24fa00afb24f..4d217d18239c 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -135,7 +135,7 @@ int mlx5_vdpa_create_mkey(struct mlx5_vdpa_dev *mvdev, u32 *mkey, u32 *in,
 int mlx5_vdpa_destroy_mkey(struct mlx5_vdpa_dev *mvdev, u32 mkey);
 struct mlx5_vdpa_mr *mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
 					 struct vhost_iotlb *iotlb);
-void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev);
+void mlx5_vdpa_clean_mrs(struct mlx5_vdpa_dev *mvdev);
 void mlx5_vdpa_get_mr(struct mlx5_vdpa_dev *mvdev,
 		      struct mlx5_vdpa_mr *mr);
 void mlx5_vdpa_put_mr(struct mlx5_vdpa_dev *mvdev,
diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 64bcae2bae8a..50bb2cc95ea2 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -719,7 +719,7 @@ static void mlx5_vdpa_show_mr_leaks(struct mlx5_vdpa_dev *mvdev)
 
 }
 
-void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
+void mlx5_vdpa_clean_mrs(struct mlx5_vdpa_dev *mvdev)
 {
 	for (int i = 0; i < MLX5_VDPA_NUM_AS; i++)
 		mlx5_vdpa_update_mr(mvdev, NULL, i);
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 822092eccb32..cf2b77ebc72b 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -3223,7 +3223,7 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
 err_driver:
 	unregister_link_notifier(ndev);
 err_setup:
-	mlx5_vdpa_destroy_mr_resources(&ndev->mvdev);
+	mlx5_vdpa_clean_mrs(&ndev->mvdev);
 	ndev->mvdev.status |= VIRTIO_CONFIG_S_FAILED;
 err_clear:
 	up_write(&ndev->reslock);
@@ -3275,7 +3275,7 @@ static int mlx5_vdpa_compat_reset(struct vdpa_device *vdev, u32 flags)
 	}
 
 	if (flags & VDPA_RESET_F_CLEAN_MAP)
-		mlx5_vdpa_destroy_mr_resources(&ndev->mvdev);
+		mlx5_vdpa_clean_mrs(&ndev->mvdev);
 	ndev->mvdev.status = 0;
 	ndev->mvdev.suspended = false;
 	ndev->cur_num_vqs = MLX5V_DEFAULT_VQ_COUNT;
@@ -3433,7 +3433,7 @@ static void mlx5_vdpa_free(struct vdpa_device *vdev)
 	ndev = to_mlx5_vdpa_ndev(mvdev);
 
 	free_fixed_resources(ndev);
-	mlx5_vdpa_destroy_mr_resources(mvdev);
+	mlx5_vdpa_clean_mrs(mvdev);
 	if (!is_zero_ether_addr(ndev->config.mac)) {
 		pfmdev = pci_get_drvdata(pci_physfn(mvdev->mdev->pdev));
 		mlx5_mpfs_del_mac(pfmdev, ndev->config.mac);
@@ -4008,7 +4008,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 err_res2:
 	free_fixed_resources(ndev);
 err_mr:
-	mlx5_vdpa_destroy_mr_resources(mvdev);
+	mlx5_vdpa_clean_mrs(mvdev);
 err_res:
 	mlx5_vdpa_free_resources(&ndev->mvdev);
 err_mpfs:
-- 
2.45.1


