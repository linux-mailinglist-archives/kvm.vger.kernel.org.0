Return-Path: <kvm+bounces-25501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BC9A965FCC
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 13:01:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0C1E1C23CA8
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 11:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5D3618FDD7;
	Fri, 30 Aug 2024 10:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="d++812bh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E9F18FDC8;
	Fri, 30 Aug 2024 10:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725015578; cv=fail; b=J8MRK2C2rkSzA8b5XmV2gZymivTgjNsHXzm6CH7RVnCM7cm8gUtus3VSBFcK0v8N4m4esRvxeVdTZn61SyReVnWhMiz7VFpDWAEc/iPJ058gjHZ4yW55mf0r4y9nXDqzuLld1tNftGZs8EkBwqfkhLQwtnVV/31wnif82nHATIM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725015578; c=relaxed/simple;
	bh=dWyAh5q+A86sqyF5vvoIzv96ciGvmPJDdWjeWGh7QkA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IU8Xy2A9+4TTJ0/raxA7HgP5HD+Vu+LS0U1VmoOqHgxsKAU8Rw2cJLBUqU+jjp06QW/gLdRmdH7WY0Lo7zdLbBjZQWIj/VAYGYbHhrFcXblOC4a5dSjxsg97sYBOYBzsbmwTU+TCiVWM3kpxalr29yGH5T1pRpRinn8mE4ClofQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=d++812bh; arc=fail smtp.client-ip=40.107.93.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TnbKFDfs56W/NjZNmMBdKH+bBcshdbPD6TFJU1dL156UL3efh61Br4IUlmg9TIDq6Ft5mRHSES+w4uN+KcuTMvgeWkd90n+c3zPyBxEVs7k1QWGCYQuYbVPniyEnZhqPJJmlylqwk8HkrXmt85jNn8SeL0p2gDDiCsPQHUHpxQC37jJHS44VaFHKYPplqqPcujt4ZkRAUZ5Q9g6DOx1a05NHUfTdAyzmfY7Bvc2BpV82kqT06X0mtY59wygGk6Bljc1/qFzPYBtf3+LyKpiTfDO8Q+xIMxczs72zYL8tk2u7tZCHJsFT8Ynip3fCRYLNwZrRtuLrwx4frh2S9VoLxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yNNUbO7FmxX7S/l+kTnT8/Y/EDXjNREHAi7SYJ31JjI=;
 b=GdajGvObd7Q9lpuZMh1n7t1gA67Lb5cyIUS9NlbFmmoe57giibsF1YAuadtNceaLFKL/14S+RdsN/KNMyqAcbNnWVNokc71PonwWwKaRbT3QlExfq68bPo9lDDPW+YExjOMET46LVEz4raNIYsJuKcW248EfXrjtL1n86ztv73lyPxMA2VV9Is0hBiLzYT3wJa/oRrkaezA8YMU+89bKBijYsa/O6p6r38+CfoUDUZTFzyIP4EJrQQxOQhIBrMy8xbm33X1bPWE26n6IXI1AuS4kWL0vRDfpBG4aR1myC7dN33GNGss7o/N+f58/XoLgBJQAW1zuEG4RMsYlWQJKAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yNNUbO7FmxX7S/l+kTnT8/Y/EDXjNREHAi7SYJ31JjI=;
 b=d++812bhEwiKbLzWGAuB3L6q5jvigKd8e0ZHTwNt/2FytJ/NyyKixRiMR8UnzH0HIGKng9QgXX59Nl8RgSXH2la4a89Uu2pztjmNBN83RCXwnSz1zyyAXMhpncX8xAXObmZ3Ltu7bdLFwWURiadpWzr9ikR2UtgBJFyYAdR7C0D3/juP7R1nE7vqIRUnER4dwhUvLgLE8mfiIeAU1bW1SmCqJMN/GB9TpgcyYcYWNsG/JrzVFucTtyaaAEnUFENcdaEQhnN8gfHnoYaY4ctAya3Y9UTbxIrZyA4dzRIzkDp+bLWkQRc/RdbaQ+WxwdXSnCepP/vXYSPOdBwBtPSZoQ==
Received: from CH0PR04CA0007.namprd04.prod.outlook.com (2603:10b6:610:76::12)
 by MN0PR12MB5764.namprd12.prod.outlook.com (2603:10b6:208:377::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 10:59:30 +0000
Received: from CH2PEPF0000009D.namprd02.prod.outlook.com
 (2603:10b6:610:76:cafe::20) by CH0PR04CA0007.outlook.office365.com
 (2603:10b6:610:76::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28 via Frontend
 Transport; Fri, 30 Aug 2024 10:59:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH2PEPF0000009D.mail.protection.outlook.com (10.167.244.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 30 Aug 2024 10:59:29 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 30 Aug
 2024 03:59:14 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 30 Aug
 2024 03:59:13 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Fri, 30 Aug 2024 03:59:10 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, <virtualization@lists.linux.dev>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Cosmin Ratiu <cratiu@nvidia.com>
Subject: [PATCH vhost v2 4/7] vdpa/mlx5: Extract mr members in own resource struct
Date: Fri, 30 Aug 2024 13:58:35 +0300
Message-ID: <20240830105838.2666587-6-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009D:EE_|MN0PR12MB5764:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d9812b3-7e43-48a9-685c-08dcc8e2d278
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NnY5UmFOQ1dUVmgxRHdYVUxCbXZBSkxBU0JOOEp4MS9rRXJWSTRSUTZOSThJ?=
 =?utf-8?B?YW03NDdsMjNvOVpxSG9JeXFIdHlteWZuKzVMYTl3Ulh5NHJ1NzBSOHBwY0Iw?=
 =?utf-8?B?K1R5OWxvYllUNkFmTVZaT3JscThRVm1idHlQcmY0Nkc4Qi9LWFJnWURVQnhr?=
 =?utf-8?B?MjJ3b3BqZ2tOQVg4bXhWeUh5U1paYmE2MHl6UmtoRU9XK0xHdGRMRVphQmF2?=
 =?utf-8?B?RHNDbzdEOEpvUlNTbmZuOE92SllZdzBBMTNEU3J1R2NnUzhDWi8wNUh1WllH?=
 =?utf-8?B?akxUNnE3MDRmMDZZbDdTV1J6aUprSURHNUNmbkVqUG1oa2hoa3pKSDE1ZHVO?=
 =?utf-8?B?bXpianRqajJaRjhXYkN0ai9OK2hqT0E5UjRYV0Q0VVFTZXJEcTVPenVCN2xh?=
 =?utf-8?B?U2VRWXVDT1NmSWE4amtZUm5hS0Y0TUpnaE1Cbnd2WC9DbExFZk95OWFIYURW?=
 =?utf-8?B?TGNJZnd1QXVrVjZWc2t1bFlRTytpeEpYZXo3TE5ITnBidzZXUDhvdVlVS052?=
 =?utf-8?B?VHF2RitBcHhQcG5JWlZ1bFpyalF4Y1FrU2h3YkFtTWNHTWU1VGd0N3BwTDhx?=
 =?utf-8?B?ejF0Y3N4NmgxTlBmcnEwSlQ5TUZzTXBqNThVRnBnaG0yTkV6bFdHUnVqMmJM?=
 =?utf-8?B?aTV5c0k2NXlqN1RTMHF3ZzNwTjNURS9pSllDWnNlVTF4QU5tbDc2NzYvWnpn?=
 =?utf-8?B?ZlFDa25vT1R2d2pqVWxPMlFWaXF1c09JRmZUdmNWUnZ4RlRvTHpnWW1UeGRo?=
 =?utf-8?B?ZGJWMGhSY3BkU2hXOU9qSnZlaWgxNGtVMTVmcFVueGcxUG5TTmdwb1ZNSldi?=
 =?utf-8?B?MXRSUmE4TXVpU2EvcWowQmEvZ1lHVW14L2J3eHA5TXNwL2VNQi96bnIvZGM4?=
 =?utf-8?B?RkdFYkg4RVBjQ3Izd2Evcll4STd3OXhnWWRDeWpjWGFrd3lIVXNvZEZ3cHN5?=
 =?utf-8?B?VUdUTS9EWjN1dHJRcGlFUitjdDIxSmpqUXIzWVJYVDdSSzZiNlRmblhJZ0l5?=
 =?utf-8?B?eWxiZVFPZUtWd0xnU1pUNzVFbDZ0ODRIWnJ2S3BCY1ZPK0M2TWp6Y2ZvMTZj?=
 =?utf-8?B?YUZuRGF1V0VXUVJMcHFmNjhRdi9leEsvSm04YUprN3VXQmJ1bktuSDFqUjZN?=
 =?utf-8?B?UjFScVlxangwK0F1U1B3bGRaaUl4bWlMWVY5Ulc1RUJZQ2p6QVlhSTJLVDBL?=
 =?utf-8?B?MTdCbklIWG43OU4yUERJeFFSY2dldVpuczF4NGV5WkNUeHUrTDdsRHRNV3Bp?=
 =?utf-8?B?K0h3U2ppUUowazRRdzdpcnV6c2dBTVJrTy94VXhxdXRjeEpadHdYVGFvUHR4?=
 =?utf-8?B?Z1orNzhUMGhUT1BnMUpRbFRMd2Foa1ZXMkJLZjhNR2pOakREUWM5UVIvS3Vr?=
 =?utf-8?B?bFBUR042aWRxRjQyM0NwdlkxSW92cEQ2NnNtWHpOU1FVU0tLY2gyNHZZK0RP?=
 =?utf-8?B?QnpWNk1lUkUvTlQ1RldXMzVTR0x3WmxGc1JpdkpwNGROK00zV21ZZk9UdHhW?=
 =?utf-8?B?d1FTeDlLQTBMWVVpQVhrK09ZaWhhVTUwUHNSTmxRK21aV0ozd0NKUmVOdHli?=
 =?utf-8?B?a1Vnai9IcXhqNWNIdjZWVmsxTlZxSEF1eVRzU2Y4SzVGZlRyWlFpd3o1SVBE?=
 =?utf-8?B?VTJyREtsbCswUmRqNks4NjRDSHJsQUZCR2FJc29IM0RGTzNTdGF4b094eDNN?=
 =?utf-8?B?THlCYlduS3c1RFFRNHF2UEl1ZjJHZ0JuQUYyazFzZjJtWm1TVEZpTE1pTHMw?=
 =?utf-8?B?RDZwMDVwT1lFVHIyeDlncm54dmtZbEwxa1pMOTkvanZJa1hQUkdEcHJWRjRZ?=
 =?utf-8?B?aTdDVTlwWGlaL1dFTmxTV0lHdDN5MEJ0TFdyM2h1WU02cWFYRE5YOEJZT0Ey?=
 =?utf-8?B?S1NGSDVZUmJYWnJVbW9vZlN6UFZ4SHpzN0lNdkVscmVWZFhDV3RKNGZ6RURE?=
 =?utf-8?Q?alYYnMI57gkUUULC9Yk1f1Xmt/DfltE8?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 10:59:29.7475
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d9812b3-7e43-48a9-685c-08dcc8e2d278
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5764

Group all mapping related resources into their own structure.

Upcoming patches will add more members in this new structure.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
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
index 50bb2cc95ea2..95087d7ae78a 100644
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


