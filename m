Return-Path: <kvm+bounces-24717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FC51959ADA
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 13:55:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 319AF1F235E2
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 11:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C1D01B2EEC;
	Wed, 21 Aug 2024 11:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="poMIRyW0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30E71B1D64;
	Wed, 21 Aug 2024 11:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724240524; cv=fail; b=fXxL+d4RSVzKw1/y3Fzky+XiPUBtYda6uDM83lVgXVevY6Enap0NyFN0qIx87U/XaCo3M5RfJEg4mrAZCpxr1Lhb/jTT0TyaSY4PYPlLWoiUUfpl51AxCBALFsfdTDqXvgPqneuk3v5TPV8o+KWHcfTNaCUOSFuwoIxwzqRc1xQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724240524; c=relaxed/simple;
	bh=8IMf4Sex1IUf18nsEg7339WEtdRcI2DWTUMuWmug1vA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UAv/zUdc9E5gMQP5tHjYiv9v+Dq7+wPEqASirVPR0+gMudqj8oQB+SCC/arReJ7xF4a8Y/Re3LWXrISMNIVCu5OrAcVQp+haSLYzanesuL6h3Ai/oIuoBGM/TnwByC1weMregWbmOMsrcjFTjGoZnVd1P9dWOrR7mJjXtJufs4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=poMIRyW0; arc=fail smtp.client-ip=40.107.244.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iJNjmLb/3tI7dhyOwwTcYtUgNYUl/gjj4aovb2E/Ku7tQzycHWLbGyDDIxAXGMHOPClprHdxfDFlkkvqFV0srmGPTlOtbGfNITKxbZseWBWn6uyuaVquXnxp4BQHQFfye7lJvim55FqVsAYC7nQOZeTYcetO0lagOF3fuexFNvmub6B9JuD8o9G8Zz1OgxFg+1tK8WtReueSKQ/VTbm703A2dNTh7ff9xOepS8d1fR/IU/4rw49l5LuVpg4LAcWpg1DnagPif9n3RPwtcYRJl1vqvsgSCACiorD7V8vqK5UTl9L6O75FljgQ4g8kLyNh510sQAtMt3p/Gjx0uAuyiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dezIsVnCW5rqORGKntVGu1gn2mFX2ipsFBXuwgM+QMc=;
 b=xvlyAdTFChlH3pXQI0b6iaWLRoF71yTU+kys+rLGBkCrSVr7aSJoFCxR2tWQpd9Bvt4GLhZsB3XcZ5d84tQqJwweM721r51+nYwcZ6oPkSVuBdkVWu9Z0a/7BvVkrb3xhSn0xG+21igxU50gmP6zn6W3yvvhFmFqTNp4i2U2H86GPhoxRlnil+BHwlYlwg4/T112rnlUk4TaJLPhlafOmvJMFhboI7qOjtTaMQUX3PaoYABUqDIX0WaPfK/ItaekLMGPTXY64xg2hkFE0rXM9cXQkxaWzIGzOY2vB5+9ogPGKk9GfdniIpi1O1u4pr1jcgu+WcdmgrUqwg3c2ck75w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dezIsVnCW5rqORGKntVGu1gn2mFX2ipsFBXuwgM+QMc=;
 b=poMIRyW0SFW1ADu1eOcc/JAQUmLDPbNB0e4XysoF4xpFZE/yKYmxvoHI+VXMcfC2CnR9F+39hBwobi6F7fWvtNid6I6NNqfr3un5sLAE/6RHeHWhpoWfO1BbHRN4e1x8vn/atGYxnAaCsuFFzys3Q41CGDGY3B2SG5fo9PH9695qzByogimPAMZYUK7IEalIREP640AtbHDDL00SBGwpAq01Iudy81KvaccmwurhN8fDbv63nWQqtkxDapvsOugL6xHxnQM981fsr/7oqohVjO3TVnauVgVCmfJqj74Qa01DQsFwxdqox9EN5GOhXfpHwBvhc8u7GrMWifXe3viAAQ==
Received: from BN9PR03CA0349.namprd03.prod.outlook.com (2603:10b6:408:f6::24)
 by LV3PR12MB9353.namprd12.prod.outlook.com (2603:10b6:408:21b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Wed, 21 Aug
 2024 11:41:58 +0000
Received: from BN3PEPF0000B373.namprd21.prod.outlook.com
 (2603:10b6:408:f6:cafe::ad) by BN9PR03CA0349.outlook.office365.com
 (2603:10b6:408:f6::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19 via Frontend
 Transport; Wed, 21 Aug 2024 11:41:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF0000B373.mail.protection.outlook.com (10.167.243.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.4 via Frontend Transport; Wed, 21 Aug 2024 11:41:58 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 21 Aug
 2024 04:41:42 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 21 Aug
 2024 04:41:42 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Wed, 21 Aug 2024 04:41:39 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, <virtualization@lists.linux-foundation.org>, "Gal
 Pressman" <gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Cosmin Ratiu <cratiu@nvidia.com>
Subject: [PATCH vhost 4/7] vdpa/mlx5: Extract mr members in own resource struct
Date: Wed, 21 Aug 2024 14:40:58 +0300
Message-ID: <20240821114100.2261167-6-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B373:EE_|LV3PR12MB9353:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a47666d-1f04-40fc-043a-08dcc1d64409
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8V+axgNGAZpHfxHG+2BzycacDQ1RxHeA5dFqeaJXd2AV3P0d9f6JgZFepBJU?=
 =?us-ascii?Q?sRRmJcxVAczORCXmtw0SOsYbqLAfz14Xto616RpEHJsBPqVUkcqgicanUmRo?=
 =?us-ascii?Q?I98FuUWIlfDrStjIZ1o/0SSxPdpwXdP1FVVE0trvd/Om26ICwO7KZrVBiZLH?=
 =?us-ascii?Q?FJvBV19uwL/lxOrAgHvh6+YfzI1iat9x/eWBELczvj4t2MXIqXrQQ+ZBzgP2?=
 =?us-ascii?Q?G075UMJtZ4fRsM0aFFswyYSf4miE8Rpxfi/OdTWr4pjeO9WpoHzzh/Nr5qEG?=
 =?us-ascii?Q?mt6V9dHlqStpS0ZQeaPGvh1yXkmQSjoiSW9uw46ZagKvsz36uvIewBq1t/Wl?=
 =?us-ascii?Q?xwhtxYThJIKE4IWXu0fXF9dktQwfnoLFyFjYzyeVg3D4vew6eqaUwwHANoAu?=
 =?us-ascii?Q?M4pZq4J1v0mhRKlTzEMDnTGSQeLU2LR9kAyryyAzbSAnGb6HMRO9dMalUIMW?=
 =?us-ascii?Q?mqGUHyKXJHbofLjIB9vxA/JXwIYe+Bjtc7us6qTVSIL8tn2K2GsCdEBwBQDO?=
 =?us-ascii?Q?h8ikyQ0LGWhmqNh2wVCP9twibRc4NTwJuLkIgj3/d0oOJOKpxns4pgoY80Wc?=
 =?us-ascii?Q?jdP+8RAWTywDM3F4g0TVXjVm+p+osA6fsxjUcuvG/DfhhbRy4l8DtLJczJEo?=
 =?us-ascii?Q?ftyMV0NuJ4MToHO/HTLQRUCqNN6iOC890hAHql2DJvxrrMvr44IvSOXLVXUU?=
 =?us-ascii?Q?h17jC7W7eMZlIeseWBOuZiace20lOC2KkB/Wgy6RKeimKU5Ht+lCowkTX41C?=
 =?us-ascii?Q?SHjI8iX2F6+7uoFlBzlCLvs+Oz7l9ZOPkRolm4Db5tpUHztTVPJlTEuzmJVg?=
 =?us-ascii?Q?GCqJiG3VhOu+wNKgiCPnPIHZApCKg3C9WKRkKTIKKXtZNEf7SQRwz69sQPWL?=
 =?us-ascii?Q?4A44H9Kwyj79jhiRu5ecR0T4PgHjIMC9034IxIRFlHGIJa72FHKkDN0leJP7?=
 =?us-ascii?Q?w8uivACCdG0i3IgN54WvW82ZrTwnUjLFjZ5aa/NaXPnLXHgrUGSw9UNqSBBD?=
 =?us-ascii?Q?/wkWluhteHLK/8HY8O/QPwsshGWL9xCHH2XfyrzHq7i7G+WLkDxEfeJpZYDr?=
 =?us-ascii?Q?BjEfkyEoqyiAALuQihiNhUfbVQfeQ2/8WHOi/fByd4Za6n6gTc9z2TRuTtz8?=
 =?us-ascii?Q?qjXBkskKZlagOZ2AA5Rp8I+nnRy884n7HaWs1veHyJ8fe80Wpd+u/L/CPUOG?=
 =?us-ascii?Q?3SWKsJ0b3iYv0tTTqLvXIBw8JYwZgMWwfMwLxPP+FAtqEleFyoi8g4uZMt8c?=
 =?us-ascii?Q?etQ8+QylTs+xVSCG48txxAUMQEX14WIOYeYULvqwHGx6Nv3Vjo9Pit5ux4mj?=
 =?us-ascii?Q?iPtHUdFc2wq168g9Gwty/FOwFsbqX3ZZ9HHzxyxddhAEQ7r5u0KAMCq6ITim?=
 =?us-ascii?Q?JxMbe7Ej8P4Iyj4HsDIAVLAYtFfE4GqJHlTkATMa3pEom+3QgOtoq3UJG4rm?=
 =?us-ascii?Q?F77b+oERkEGi5q4CmAWJKlkMTyHiz3Fs?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 11:41:58.6340
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a47666d-1f04-40fc-043a-08dcc1d64409
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B373.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9353

Group all mapping related resources into their own structure.

Upcoming patches will add more members in this new structure.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h | 13 ++++++-----
 drivers/vdpa/mlx5/core/mr.c        | 30 ++++++++++++-------------
 drivers/vdpa/mlx5/core/resources.c |  6 ++---
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 36 +++++++++++++++---------------
 4 files changed, 44 insertions(+), 41 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index 4d217d18239c..5ae6deea2a8a 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -83,10 +83,18 @@ enum {
 	MLX5_VDPA_NUM_AS = 2
 };
 
+struct mlx5_vdpa_mr_resources {
+	struct mlx5_vdpa_mr *mr[MLX5_VDPA_NUM_AS];
+	unsigned int group2asid[MLX5_VDPA_NUMVQ_GROUPS];
+	struct list_head mr_list_head;
+	struct mutex mr_mtx;
+};
+
 struct mlx5_vdpa_dev {
 	struct vdpa_device vdev;
 	struct mlx5_core_dev *mdev;
 	struct mlx5_vdpa_resources res;
+	struct mlx5_vdpa_mr_resources mres;
 
 	u64 mlx_features;
 	u64 actual_features;
@@ -95,13 +103,8 @@ struct mlx5_vdpa_dev {
 	u16 max_idx;
 	u32 generation;
 
-	struct mlx5_vdpa_mr *mr[MLX5_VDPA_NUM_AS];
-	struct list_head mr_list_head;
-	/* serialize mr access */
-	struct mutex mr_mtx;
 	struct mlx5_control_vq cvq;
 	struct workqueue_struct *wq;
-	unsigned int group2asid[MLX5_VDPA_NUMVQ_GROUPS];
 	bool suspended;
 
 	struct mlx5_async_ctx async_ctx;
diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 149edea09c8f..2c8660e5c0de 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -666,9 +666,9 @@ static void _mlx5_vdpa_put_mr(struct mlx5_vdpa_dev *mvdev,
 void mlx5_vdpa_put_mr(struct mlx5_vdpa_dev *mvdev,
 		      struct mlx5_vdpa_mr *mr)
 {
-	mutex_lock(&mvdev->mr_mtx);
+	mutex_lock(&mvdev->mres.mr_mtx);
 	_mlx5_vdpa_put_mr(mvdev, mr);
-	mutex_unlock(&mvdev->mr_mtx);
+	mutex_unlock(&mvdev->mres.mr_mtx);
 }
 
 static void _mlx5_vdpa_get_mr(struct mlx5_vdpa_dev *mvdev,
@@ -683,39 +683,39 @@ static void _mlx5_vdpa_get_mr(struct mlx5_vdpa_dev *mvdev,
 void mlx5_vdpa_get_mr(struct mlx5_vdpa_dev *mvdev,
 		      struct mlx5_vdpa_mr *mr)
 {
-	mutex_lock(&mvdev->mr_mtx);
+	mutex_lock(&mvdev->mres.mr_mtx);
 	_mlx5_vdpa_get_mr(mvdev, mr);
-	mutex_unlock(&mvdev->mr_mtx);
+	mutex_unlock(&mvdev->mres.mr_mtx);
 }
 
 void mlx5_vdpa_update_mr(struct mlx5_vdpa_dev *mvdev,
 			 struct mlx5_vdpa_mr *new_mr,
 			 unsigned int asid)
 {
-	struct mlx5_vdpa_mr *old_mr = mvdev->mr[asid];
+	struct mlx5_vdpa_mr *old_mr = mvdev->mres.mr[asid];
 
-	mutex_lock(&mvdev->mr_mtx);
+	mutex_lock(&mvdev->mres.mr_mtx);
 
 	_mlx5_vdpa_put_mr(mvdev, old_mr);
-	mvdev->mr[asid] = new_mr;
+	mvdev->mres.mr[asid] = new_mr;
 
-	mutex_unlock(&mvdev->mr_mtx);
+	mutex_unlock(&mvdev->mres.mr_mtx);
 }
 
 static void mlx5_vdpa_show_mr_leaks(struct mlx5_vdpa_dev *mvdev)
 {
 	struct mlx5_vdpa_mr *mr;
 
-	mutex_lock(&mvdev->mr_mtx);
+	mutex_lock(&mvdev->mres.mr_mtx);
 
-	list_for_each_entry(mr, &mvdev->mr_list_head, mr_list) {
+	list_for_each_entry(mr, &mvdev->mres.mr_list_head, mr_list) {
 
 		mlx5_vdpa_warn(mvdev, "mkey still alive after resource delete: "
 				      "mr: %p, mkey: 0x%x, refcount: %u\n",
 				       mr, mr->mkey, refcount_read(&mr->refcount));
 	}
 
-	mutex_unlock(&mvdev->mr_mtx);
+	mutex_unlock(&mvdev->mres.mr_mtx);
 
 }
 
@@ -753,7 +753,7 @@ static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
 	if (err)
 		goto err_iotlb;
 
-	list_add_tail(&mr->mr_list, &mvdev->mr_list_head);
+	list_add_tail(&mr->mr_list, &mvdev->mres.mr_list_head);
 
 	return 0;
 
@@ -779,9 +779,9 @@ struct mlx5_vdpa_mr *mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
-	mutex_lock(&mvdev->mr_mtx);
+	mutex_lock(&mvdev->mres.mr_mtx);
 	err = _mlx5_vdpa_create_mr(mvdev, mr, iotlb);
-	mutex_unlock(&mvdev->mr_mtx);
+	mutex_unlock(&mvdev->mres.mr_mtx);
 
 	if (err)
 		goto out_err;
@@ -801,7 +801,7 @@ int mlx5_vdpa_update_cvq_iotlb(struct mlx5_vdpa_dev *mvdev,
 {
 	int err;
 
-	if (mvdev->group2asid[MLX5_VDPA_CVQ_GROUP] != asid)
+	if (mvdev->mres.group2asid[MLX5_VDPA_CVQ_GROUP] != asid)
 		return 0;
 
 	spin_lock(&mvdev->cvq.iommu_lock);
diff --git a/drivers/vdpa/mlx5/core/resources.c b/drivers/vdpa/mlx5/core/resources.c
index 22ea32fe007b..3e3b3049cb08 100644
--- a/drivers/vdpa/mlx5/core/resources.c
+++ b/drivers/vdpa/mlx5/core/resources.c
@@ -256,7 +256,7 @@ int mlx5_vdpa_alloc_resources(struct mlx5_vdpa_dev *mvdev)
 		mlx5_vdpa_warn(mvdev, "resources already allocated\n");
 		return -EINVAL;
 	}
-	mutex_init(&mvdev->mr_mtx);
+	mutex_init(&mvdev->mres.mr_mtx);
 	res->uar = mlx5_get_uars_page(mdev);
 	if (IS_ERR(res->uar)) {
 		err = PTR_ERR(res->uar);
@@ -301,7 +301,7 @@ int mlx5_vdpa_alloc_resources(struct mlx5_vdpa_dev *mvdev)
 err_uctx:
 	mlx5_put_uars_page(mdev, res->uar);
 err_uars:
-	mutex_destroy(&mvdev->mr_mtx);
+	mutex_destroy(&mvdev->mres.mr_mtx);
 	return err;
 }
 
@@ -318,7 +318,7 @@ void mlx5_vdpa_free_resources(struct mlx5_vdpa_dev *mvdev)
 	dealloc_pd(mvdev, res->pdn, res->uid);
 	destroy_uctx(mvdev, res->uid);
 	mlx5_put_uars_page(mvdev->mdev, res->uar);
-	mutex_destroy(&mvdev->mr_mtx);
+	mutex_destroy(&mvdev->mres.mr_mtx);
 	res->valid = false;
 }
 
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index cf2b77ebc72b..3e55a7f1afcd 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -941,11 +941,11 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev,
 		MLX5_SET64(virtio_q, vq_ctx, used_addr, mvq->device_addr);
 		MLX5_SET64(virtio_q, vq_ctx, available_addr, mvq->driver_addr);
 
-		vq_mr = mvdev->mr[mvdev->group2asid[MLX5_VDPA_DATAVQ_GROUP]];
+		vq_mr = mvdev->mres.mr[mvdev->mres.group2asid[MLX5_VDPA_DATAVQ_GROUP]];
 		if (vq_mr)
 			MLX5_SET(virtio_q, vq_ctx, virtio_q_mkey, vq_mr->mkey);
 
-		vq_desc_mr = mvdev->mr[mvdev->group2asid[MLX5_VDPA_DATAVQ_DESC_GROUP]];
+		vq_desc_mr = mvdev->mres.mr[mvdev->mres.group2asid[MLX5_VDPA_DATAVQ_DESC_GROUP]];
 		if (vq_desc_mr &&
 		    MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, desc_group_mkey_supported))
 			MLX5_SET(virtio_q, vq_ctx, desc_group_mkey, vq_desc_mr->mkey);
@@ -953,11 +953,11 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev,
 		/* If there is no mr update, make sure that the existing ones are set
 		 * modify to ready.
 		 */
-		vq_mr = mvdev->mr[mvdev->group2asid[MLX5_VDPA_DATAVQ_GROUP]];
+		vq_mr = mvdev->mres.mr[mvdev->mres.group2asid[MLX5_VDPA_DATAVQ_GROUP]];
 		if (vq_mr)
 			mvq->modified_fields |= MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_MKEY;
 
-		vq_desc_mr = mvdev->mr[mvdev->group2asid[MLX5_VDPA_DATAVQ_DESC_GROUP]];
+		vq_desc_mr = mvdev->mres.mr[mvdev->mres.group2asid[MLX5_VDPA_DATAVQ_DESC_GROUP]];
 		if (vq_desc_mr)
 			mvq->modified_fields |= MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY;
 	}
@@ -1354,7 +1354,7 @@ static void fill_modify_virtqueue_cmd(struct mlx5_vdpa_net *ndev,
 	}
 
 	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_MKEY) {
-		vq_mr = mvdev->mr[mvdev->group2asid[MLX5_VDPA_DATAVQ_GROUP]];
+		vq_mr = mvdev->mres.mr[mvdev->mres.group2asid[MLX5_VDPA_DATAVQ_GROUP]];
 
 		if (vq_mr)
 			MLX5_SET(virtio_q, vq_ctx, virtio_q_mkey, vq_mr->mkey);
@@ -1363,7 +1363,7 @@ static void fill_modify_virtqueue_cmd(struct mlx5_vdpa_net *ndev,
 	}
 
 	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY) {
-		desc_mr = mvdev->mr[mvdev->group2asid[MLX5_VDPA_DATAVQ_DESC_GROUP]];
+		desc_mr = mvdev->mres.mr[mvdev->mres.group2asid[MLX5_VDPA_DATAVQ_DESC_GROUP]];
 
 		if (desc_mr && MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, desc_group_mkey_supported))
 			MLX5_SET(virtio_q, vq_ctx, desc_group_mkey, desc_mr->mkey);
@@ -1381,8 +1381,8 @@ static void modify_virtqueue_end(struct mlx5_vdpa_net *ndev,
 	struct mlx5_vdpa_dev *mvdev = &ndev->mvdev;
 
 	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_MKEY) {
-		unsigned int asid = mvdev->group2asid[MLX5_VDPA_DATAVQ_GROUP];
-		struct mlx5_vdpa_mr *vq_mr = mvdev->mr[asid];
+		unsigned int asid = mvdev->mres.group2asid[MLX5_VDPA_DATAVQ_GROUP];
+		struct mlx5_vdpa_mr *vq_mr = mvdev->mres.mr[asid];
 
 		mlx5_vdpa_put_mr(mvdev, mvq->vq_mr);
 		mlx5_vdpa_get_mr(mvdev, vq_mr);
@@ -1390,8 +1390,8 @@ static void modify_virtqueue_end(struct mlx5_vdpa_net *ndev,
 	}
 
 	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY) {
-		unsigned int asid = mvdev->group2asid[MLX5_VDPA_DATAVQ_DESC_GROUP];
-		struct mlx5_vdpa_mr *desc_mr = mvdev->mr[asid];
+		unsigned int asid = mvdev->mres.group2asid[MLX5_VDPA_DATAVQ_DESC_GROUP];
+		struct mlx5_vdpa_mr *desc_mr = mvdev->mres.mr[asid];
 
 		mlx5_vdpa_put_mr(mvdev, mvq->desc_mr);
 		mlx5_vdpa_get_mr(mvdev, desc_mr);
@@ -3235,7 +3235,7 @@ static void init_group_to_asid_map(struct mlx5_vdpa_dev *mvdev)
 
 	/* default mapping all groups are mapped to asid 0 */
 	for (i = 0; i < MLX5_VDPA_NUMVQ_GROUPS; i++)
-		mvdev->group2asid[i] = 0;
+		mvdev->mres.group2asid[i] = 0;
 }
 
 static bool needs_vqs_reset(const struct mlx5_vdpa_dev *mvdev)
@@ -3353,7 +3353,7 @@ static int set_map_data(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 		new_mr = NULL;
 	}
 
-	if (!mvdev->mr[asid]) {
+	if (!mvdev->mres.mr[asid]) {
 		mlx5_vdpa_update_mr(mvdev, new_mr, asid);
 	} else {
 		err = mlx5_vdpa_change_map(mvdev, new_mr, asid);
@@ -3637,12 +3637,12 @@ static int mlx5_set_group_asid(struct vdpa_device *vdev, u32 group,
 	if (group >= MLX5_VDPA_NUMVQ_GROUPS)
 		return -EINVAL;
 
-	mvdev->group2asid[group] = asid;
+	mvdev->mres.group2asid[group] = asid;
 
-	mutex_lock(&mvdev->mr_mtx);
-	if (group == MLX5_VDPA_CVQ_GROUP && mvdev->mr[asid])
-		err = mlx5_vdpa_update_cvq_iotlb(mvdev, mvdev->mr[asid]->iotlb, asid);
-	mutex_unlock(&mvdev->mr_mtx);
+	mutex_lock(&mvdev->mres.mr_mtx);
+	if (group == MLX5_VDPA_CVQ_GROUP && mvdev->mres.mr[asid])
+		err = mlx5_vdpa_update_cvq_iotlb(mvdev, mvdev->mres.mr[asid]->iotlb, asid);
+	mutex_unlock(&mvdev->mres.mr_mtx);
 
 	return err;
 }
@@ -3962,7 +3962,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 	if (err)
 		goto err_mpfs;
 
-	INIT_LIST_HEAD(&mvdev->mr_list_head);
+	INIT_LIST_HEAD(&mvdev->mres.mr_list_head);
 
 	if (MLX5_CAP_GEN(mvdev->mdev, umem_uid_0)) {
 		err = mlx5_vdpa_create_dma_mr(mvdev);
-- 
2.45.1


