Return-Path: <kvm+bounces-25502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A2CA7965FD0
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 13:01:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D084283BAA
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 11:01:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 573F519ABB3;
	Fri, 30 Aug 2024 10:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="a4gil+eT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2089.outbound.protection.outlook.com [40.107.100.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26FF19007F;
	Fri, 30 Aug 2024 10:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725015579; cv=fail; b=SoZOcqZslLPZLb78c1MnAGFlzcrGZCuF57PYsPV1vDwqwDJnyOV+JSyN+Or/43/U1rsjiFef8L4jSy73u8aa2JRuDzTcbJ+QmwZ2Z/udlRyf/h6QsIF2zsd3a98cMxmwP6zZNWPIHBTq+L5WtBnyyVtK8xMmd4mFnTovCoe3ugA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725015579; c=relaxed/simple;
	bh=oUd524XZ03agGn80Re3RZoCUm1QgbxORyOfezmtmWes=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h0dY7Wkknj67MDsZjQlRaPyZjpIScKA8tP0cw6MhaWsPY/mSwP7YMlKAq/y1ZLhfX9E5bRo5k0umftwO2woM0MtoZus9YQG6voWI/wuZlGzk6hBKJN5DQ7DaVSmyacCUMx6XFnq3FYWTZAkIsbJ8HRMqcMEOHrpyQjC6YXaMsrE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=a4gil+eT; arc=fail smtp.client-ip=40.107.100.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GNQw7nliBHKSpxs9MQ1iowM/SuNC1iQjV74cbuXTOqjY1l7gJTpUjQMKh1EGvV8H7XB6PlOTjV2Irwfb+2t2zttqJrb+L224qeJyL0cq4LPuJs/K+RKD133cRj2SuEu3hbb60OQeJXgMV1Nn6QbBIKWLeUluqda8vNn0Rjqe9JCkpV5/j0biGXA1uey8g2PSVldJn62U/hT2p4QVfDHI4uYdOZJ05hG8FPjCYFvGkaF2+HPfKE41GewglLKDOi47QEXyk23D3L8XCUgkjG7VsEnEZHV+0KiAJs3OlRDy1DEaeot38/MupYqS0wCAVYfSs7ANvPfELtgmU3ddN12aYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kHe6hjjzB+AuYFTfA0Obn2d8V3Yt/lz1NalluwisKig=;
 b=XCoGisIyJ4uGbHt/sRd5gDJ/EKIkAmyynnxEx9OKMmaxnu3o87HFMKS/fk7OYIsGP97YhLi/hMwaao2kD3GSZbMb9grpr6/KoUPZNOCmJGvB1oLy8C3BCec/XLEts2rXqgnAWMmegbTho7Qbe8GS8anuhWfxYa/J5FR91be83lWJ+0WHkhHaL+WL+mRjgq6xGb1zWzKfoBrRV4gX1jcf1yHgZhBvUbwT7eAxcts6uCpOd1oLj1/VjmBT1eyDdLL5o2QMAHlaEMWZN5hx13HEecCqNG5LAX1iCocL4IszMldDyN/0gVEcetrW9Ri+o3ihEDS7WvgRtjAcas3TDE+DEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kHe6hjjzB+AuYFTfA0Obn2d8V3Yt/lz1NalluwisKig=;
 b=a4gil+eTzAbIA7KKqA88w9V49nImnyEetbzzJ+1xYk9NNO60NS3pBkBOHA69+6aY1HKVxks/rT4V64lcjatVWCqwc0P0/5gtqwPrGw0trkFUUF+oHgRtyYwnD8jOYB3uSzLIaE3kifzqicrI1GMHoLtDOHc5rnNYBcDmL/cdSRhe9yWJN4W0aXbg4qU+7Pu1Ue29FlAEcTnRbzc+aano9kJeYu/9wb8TpB46iVwS5GBdc/Hv5AUOv1cnWlPNufR5qHtN1q4/3b1wVH9PiRtqRlJ72tcDH6M8lmSgTyAcK80vFHrD2hMxWH2LyerzwY1JLXFUMQILeKvnZqmDTpjKAA==
Received: from CH0PR04CA0008.namprd04.prod.outlook.com (2603:10b6:610:76::13)
 by DS7PR12MB6312.namprd12.prod.outlook.com (2603:10b6:8:93::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.20; Fri, 30 Aug 2024 10:59:33 +0000
Received: from CH2PEPF0000009D.namprd02.prod.outlook.com
 (2603:10b6:610:76:cafe::1f) by CH0PR04CA0008.outlook.office365.com
 (2603:10b6:610:76::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20 via Frontend
 Transport; Fri, 30 Aug 2024 10:59:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH2PEPF0000009D.mail.protection.outlook.com (10.167.244.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 30 Aug 2024 10:59:33 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 30 Aug
 2024 03:59:17 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 30 Aug
 2024 03:59:17 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Fri, 30 Aug 2024 03:59:14 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, <virtualization@lists.linux.dev>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Cosmin Ratiu <cratiu@nvidia.com>
Subject: [PATCH vhost v2 5/7] vdpa/mlx5: Rename mr_mtx -> lock
Date: Fri, 30 Aug 2024 13:58:36 +0300
Message-ID: <20240830105838.2666587-7-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009D:EE_|DS7PR12MB6312:EE_
X-MS-Office365-Filtering-Correlation-Id: 01dc9583-d321-40d1-1580-08dcc8e2d46d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aVlWYmIyZ0FCQUt3cVJXaC9Nazh4WUE1RXg1d01XM3R2WGdNMkppWFlDbGZr?=
 =?utf-8?B?ZUFucEdTbG93anVJQy96SVVjdjViWENnNGtCY3QwdFcvd3ViU1kzKzJrQnh5?=
 =?utf-8?B?UVp2WlJLZWpXRGQwbDhMelUzUGYvU2xDZ2lyWWpCeDRXbkhxM3poNzdQdDV6?=
 =?utf-8?B?b0w5cEFici9DbzQrdGNiQUpzQTRTSEoxOUxCSGVXQ2xtQmViWUUzVnVHKzFC?=
 =?utf-8?B?YUZieURDRkk0aGU2SkF3S0xMVW9mQTkrTk9UcUpFMkZnUEtpS1BCLzVmUXEx?=
 =?utf-8?B?bUhCSGRzeE01Vm9lY3ZtREZSSlNscGxYZ0RDYnZMTnp4VnZyZnRKbUt3L0Nk?=
 =?utf-8?B?ejBwV2ZvaXAyVzRNR3QvYkJVODlQRE1ZT1NnNDlZNHFXMk8zZEhPQTR3Ymxw?=
 =?utf-8?B?TS9WaEMzcTVxanR3OURmSWdWYnJCZDBzNW8zdk5CQlh0Yy9lc3BJOEFMbUZW?=
 =?utf-8?B?UTdzaFhaWEYwZGh1S1c2NXQyR1kxcUdvdWprR3I1aURLK0VOS3h4Zkdjc3ZB?=
 =?utf-8?B?QmtxbE9vdjhTQmlhTkcwZUlDaWUvOTA3TFcraGlLOEVjOU82dll0Y1RUeGs0?=
 =?utf-8?B?UHJ4ajVXb1dRaVVRZVcvSjhiQ3M0a3hoYlNqcUNNUExkd0tzNVBaTU9UNzlk?=
 =?utf-8?B?T2dzbXNEZXVUaGozamZvRHVXUzMzQ1FxeG1SdDZ3VkxsVE5IWWt5SGM0aWw1?=
 =?utf-8?B?VkYzREdLbWFLTXZsait2UlB1MFYvSlNvV3JTVEpMdzhHcW9KQ1V5NHJiNjd2?=
 =?utf-8?B?VURvY0NhY3o1ZVlBcWMzeGUzVWFpYldMWkEvVllhMFVSbWdkMmpoNHkyVDYr?=
 =?utf-8?B?VEVKRlpRRUp4WDV4NlV5YWFnVnRrNC9yQVNicjBWRDB0ZlRJTnZSTXlNL3FX?=
 =?utf-8?B?MXNtZSs3aHFScGd5bnpUOXh4RXlGSkxEYnFrTFE4K2lkVEVVN0NFci84MEI4?=
 =?utf-8?B?azdTLzVIdUdHbldRZnNTU1dWeTRpcFlYQnFxVlNFdHJJaUpycGROUzNyWU5n?=
 =?utf-8?B?RVEyTWU5aUJnYllzd0l5eFFjcCttcGJtSkd1YkFvTTVzdnE1ZU5VVEUrdEdl?=
 =?utf-8?B?VnBZOXFrRVh1Ym93dnU2TXBQekhmd0RHcUpsMGMxR2g5UXpVWWd4ZWRhejd3?=
 =?utf-8?B?ZjRGbHJOUXBzRnFVQ1RZNzFHL0NMTS9ESDFlR0RnT0l3OXcreG10d2xHSzFX?=
 =?utf-8?B?dFJjbmVUUlh5SnVYTFlwZmZaY0ZxYTA3UU5lczB1UkVkWUVnTWFHL1lHL0Y0?=
 =?utf-8?B?OUYwMzNrcWZDVW1FdVlIendYbGpzRmtHZlVmUnB2SmlmTlVBSUxhcnRpbFBs?=
 =?utf-8?B?R2xlOUlPb3ZScnY5Z0JLYTRHMWdyZExDTkxwNHU5NUhyRFFOcDNvSzFuZCtL?=
 =?utf-8?B?K2Vpb0FrSVJoL1h6aUNJeHEvTk9NT05rTzhWL1dHRXNmbXVPSW5BUUZhUHNG?=
 =?utf-8?B?aVlPUk5EOHV4WFVqOEdublVTcm80K2pjcE5NQXBScEs0NUZienYyUnRDRmk4?=
 =?utf-8?B?b2VDV1dieklrMGNyK1FUWCsvRW04Z0tydmgxL1RGVFBTa2dreFhmdXU3UXNk?=
 =?utf-8?B?VVZjR0x4d3NaVTBIc1ZpRDNNMjJ3MEZveGNURiszQ3pMa014cWJleVJZSGJk?=
 =?utf-8?B?Um9IT1ZZNEVhMS9sbWxQWWtSMWFHM0pJRndpMkFXckpWOGNRWFM5bllEWW1L?=
 =?utf-8?B?R0FSRFM0b2dHd29XbGhvZThjTlJqTTJMMHVCREk5a3NkbGZwa2ljZWZIWTRa?=
 =?utf-8?B?d2h0OUhDc3p6Qk5LelNkYS9mdUlKZnRjcCtsSWg0ZjVBbkZnMnNybzhOV3lS?=
 =?utf-8?B?SDk5VTJrKzJkb1NoaWo0eHF5Q3M1VFFhQm4xMGRxM1h2eTlYNnFVbEhxZmts?=
 =?utf-8?B?QUo1WVYvcFdydlVEYjJrY2JJcy8wWFlPOXVTWVlGMVV4enljWUpLaVZhR2NP?=
 =?utf-8?Q?jCuRAbn+iBlA2Lz8qIJVefSxGC/9lFN5?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 10:59:33.0288
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01dc9583-d321-40d1-1580-08dcc8e2d46d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6312

Now that the mr resources have their own namespace in the
struct, give the lock a clearer name.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  2 +-
 drivers/vdpa/mlx5/core/mr.c        | 20 ++++++++++----------
 drivers/vdpa/mlx5/core/resources.c |  6 +++---
 drivers/vdpa/mlx5/net/mlx5_vnet.c  |  4 ++--
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index 5ae6deea2a8a..89b564cecddf 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -87,7 +87,7 @@ struct mlx5_vdpa_mr_resources {
 	struct mlx5_vdpa_mr *mr[MLX5_VDPA_NUM_AS];
 	unsigned int group2asid[MLX5_VDPA_NUMVQ_GROUPS];
 	struct list_head mr_list_head;
-	struct mutex mr_mtx;
+	struct mutex lock;
 };
 
 struct mlx5_vdpa_dev {
diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 95087d7ae78a..e0412297bae5 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -666,9 +666,9 @@ static void _mlx5_vdpa_put_mr(struct mlx5_vdpa_dev *mvdev,
 void mlx5_vdpa_put_mr(struct mlx5_vdpa_dev *mvdev,
 		      struct mlx5_vdpa_mr *mr)
 {
-	mutex_lock(&mvdev->mres.mr_mtx);
+	mutex_lock(&mvdev->mres.lock);
 	_mlx5_vdpa_put_mr(mvdev, mr);
-	mutex_unlock(&mvdev->mres.mr_mtx);
+	mutex_unlock(&mvdev->mres.lock);
 }
 
 static void _mlx5_vdpa_get_mr(struct mlx5_vdpa_dev *mvdev,
@@ -683,9 +683,9 @@ static void _mlx5_vdpa_get_mr(struct mlx5_vdpa_dev *mvdev,
 void mlx5_vdpa_get_mr(struct mlx5_vdpa_dev *mvdev,
 		      struct mlx5_vdpa_mr *mr)
 {
-	mutex_lock(&mvdev->mres.mr_mtx);
+	mutex_lock(&mvdev->mres.lock);
 	_mlx5_vdpa_get_mr(mvdev, mr);
-	mutex_unlock(&mvdev->mres.mr_mtx);
+	mutex_unlock(&mvdev->mres.lock);
 }
 
 void mlx5_vdpa_update_mr(struct mlx5_vdpa_dev *mvdev,
@@ -694,19 +694,19 @@ void mlx5_vdpa_update_mr(struct mlx5_vdpa_dev *mvdev,
 {
 	struct mlx5_vdpa_mr *old_mr = mvdev->mres.mr[asid];
 
-	mutex_lock(&mvdev->mres.mr_mtx);
+	mutex_lock(&mvdev->mres.lock);
 
 	_mlx5_vdpa_put_mr(mvdev, old_mr);
 	mvdev->mres.mr[asid] = new_mr;
 
-	mutex_unlock(&mvdev->mres.mr_mtx);
+	mutex_unlock(&mvdev->mres.lock);
 }
 
 static void mlx5_vdpa_show_mr_leaks(struct mlx5_vdpa_dev *mvdev)
 {
 	struct mlx5_vdpa_mr *mr;
 
-	mutex_lock(&mvdev->mres.mr_mtx);
+	mutex_lock(&mvdev->mres.lock);
 
 	list_for_each_entry(mr, &mvdev->mres.mr_list_head, mr_list) {
 
@@ -715,7 +715,7 @@ static void mlx5_vdpa_show_mr_leaks(struct mlx5_vdpa_dev *mvdev)
 				       mr, mr->mkey, refcount_read(&mr->refcount));
 	}
 
-	mutex_unlock(&mvdev->mres.mr_mtx);
+	mutex_unlock(&mvdev->mres.lock);
 
 }
 
@@ -779,9 +779,9 @@ struct mlx5_vdpa_mr *mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
-	mutex_lock(&mvdev->mres.mr_mtx);
+	mutex_lock(&mvdev->mres.lock);
 	err = _mlx5_vdpa_create_mr(mvdev, mr, iotlb);
-	mutex_unlock(&mvdev->mres.mr_mtx);
+	mutex_unlock(&mvdev->mres.lock);
 
 	if (err)
 		goto out_err;
diff --git a/drivers/vdpa/mlx5/core/resources.c b/drivers/vdpa/mlx5/core/resources.c
index 3e3b3049cb08..fe2ca3458f6c 100644
--- a/drivers/vdpa/mlx5/core/resources.c
+++ b/drivers/vdpa/mlx5/core/resources.c
@@ -256,7 +256,7 @@ int mlx5_vdpa_alloc_resources(struct mlx5_vdpa_dev *mvdev)
 		mlx5_vdpa_warn(mvdev, "resources already allocated\n");
 		return -EINVAL;
 	}
-	mutex_init(&mvdev->mres.mr_mtx);
+	mutex_init(&mvdev->mres.lock);
 	res->uar = mlx5_get_uars_page(mdev);
 	if (IS_ERR(res->uar)) {
 		err = PTR_ERR(res->uar);
@@ -301,7 +301,7 @@ int mlx5_vdpa_alloc_resources(struct mlx5_vdpa_dev *mvdev)
 err_uctx:
 	mlx5_put_uars_page(mdev, res->uar);
 err_uars:
-	mutex_destroy(&mvdev->mres.mr_mtx);
+	mutex_destroy(&mvdev->mres.lock);
 	return err;
 }
 
@@ -318,7 +318,7 @@ void mlx5_vdpa_free_resources(struct mlx5_vdpa_dev *mvdev)
 	dealloc_pd(mvdev, res->pdn, res->uid);
 	destroy_uctx(mvdev, res->uid);
 	mlx5_put_uars_page(mvdev->mdev, res->uar);
-	mutex_destroy(&mvdev->mres.mr_mtx);
+	mutex_destroy(&mvdev->mres.lock);
 	res->valid = false;
 }
 
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 3e55a7f1afcd..8a51c492a62a 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -3639,10 +3639,10 @@ static int mlx5_set_group_asid(struct vdpa_device *vdev, u32 group,
 
 	mvdev->mres.group2asid[group] = asid;
 
-	mutex_lock(&mvdev->mres.mr_mtx);
+	mutex_lock(&mvdev->mres.lock);
 	if (group == MLX5_VDPA_CVQ_GROUP && mvdev->mres.mr[asid])
 		err = mlx5_vdpa_update_cvq_iotlb(mvdev, mvdev->mres.mr[asid]->iotlb, asid);
-	mutex_unlock(&mvdev->mres.mr_mtx);
+	mutex_unlock(&mvdev->mres.lock);
 
 	return err;
 }
-- 
2.45.1


