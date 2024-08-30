Return-Path: <kvm+bounces-25504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC38F965FD8
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 13:02:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66FD41F235FC
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 11:02:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E21B61A4B8F;
	Fri, 30 Aug 2024 10:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Zy3lpdRZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2045.outbound.protection.outlook.com [40.107.93.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551141A287B;
	Fri, 30 Aug 2024 10:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725015585; cv=fail; b=kS9KHDc6cbqUvo8LGkl7+IuwqaAVjt6EKiDGqxTDkvVTA4dpAmLb/MvKkgfNQe0gphOrnXQ4nRU0B7zZjX608p4Rgcj6JKK/OZDi39MoC0OQHRFaOYxIqKJq0227SM40dmXZ8p8/M+mlYAfEg55pJltCPCQxZmiV+A4IEygNZUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725015585; c=relaxed/simple;
	bh=7yOK9FcltC82mZCU7xfVnl3LqAgRYMy5Wc/ISPyR8HQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tm7C6OjCgiRaCyFGAZ4lEa6mieEvs3ms561LMF7BZLUR7iOXo87s40+hgthq6TE4sz53A+ifTFTkn2AJar9onlr6sErAuMCe7A0NPkIKbtdAib3i99e/nZX0ieEWrU362y5HE0+BqHCC/ytm/F3WkyBhqhB0CkoBBdS0aItoijM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Zy3lpdRZ; arc=fail smtp.client-ip=40.107.93.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UQtZlL4ZHpcrrw561gjANG7FkI/XKDhX0uK4QLRd3MSv6fGNDsoHyO+56USvyIIc3aUtHVkwKx2mXsjZlc1q4vxIqFmhqBo6ygEOTfacv3ViweWFQy9u0WK0v48/RvPWqe/i+1SwA4Q9vGkl0//KXk/iL1UQ9aFv10/ZgXGEk158MTwBW9i72A+f0Q8cfQfuIvb5wAqvldc6rJnydd/ZSRNrGQoDz+PvQbGnKmGC/hTzKIsSFWk9cm2FzqncBBqbvhOAb6OdbHILSa2YHQnSH94vTeYqASvGrUHyQ7IGEQj8iemHKhzuaZdwIEDUfobtXIsbO+mM77KIfsF425mIEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=481MRpxXPZFGiUq/tv3DyRO8i2ssxDsL/9RPJ6HgHJ4=;
 b=LVwJOkawHiJRs2h3wSv3xIZt9bDN5V6+WLjTVOgBLSEVURGYloka+cOJZojNeRePVZNCgo/2M7snBy3tpXUr7dKdPJ4zAyqvukJaZAFMRbamArbn9SxPAt90GYhXg0drIDTzFjkZMBspsbERrurC4ntrHJ+tZBDRcJskGlLQjt+Lr1uq+S72vvNbbAq2dgFzSs4q35xDuzUi/aQ4/gDwAlPJTvtL2GQG6VKKPrlOazAoxI2phamUnL93QWDCKCdff/982UVFDVYslHeASpgrsymU0Ho/xd3PFm8VKydr7WVjOjwSj0hQ8r/HH4z4+ABypcZ/pk9S4TxzxWsd0SclnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=481MRpxXPZFGiUq/tv3DyRO8i2ssxDsL/9RPJ6HgHJ4=;
 b=Zy3lpdRZH0ULTJhkY33lkV7+ohdeo58MdeS/b1hONGCKhLLnmQK9cEZ1CyKuJHkcks3tf6Aus6rsPizB/RD9iRKuQZXHYaB8beNW1vQFO7NdqFCEHOHGy9lRUPkmV5eVEd7FHhNe5WndV0QfaD9o7OcFyqpRe2z0aQT+2PVr+ajLGXn296/fvWzpQAx7fs3MkblPm3RXrSBqU0a7pHkS9B2IioOyWAmx85TW6yvgLhu9ev4cwGnhyQjOO8rbWAOPnb9F4cQzejCV+YaleoAbuO56g3vIaHmRm8KetFmEw1XizC/lCxFsMfrToWYxcz16+EctjjYoKAevSqypoOziFg==
Received: from BN9PR03CA0459.namprd03.prod.outlook.com (2603:10b6:408:139::14)
 by SA1PR12MB7200.namprd12.prod.outlook.com (2603:10b6:806:2bb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Fri, 30 Aug
 2024 10:59:39 +0000
Received: from BN2PEPF000044A5.namprd04.prod.outlook.com
 (2603:10b6:408:139:cafe::4) by BN9PR03CA0459.outlook.office365.com
 (2603:10b6:408:139::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20 via Frontend
 Transport; Fri, 30 Aug 2024 10:59:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN2PEPF000044A5.mail.protection.outlook.com (10.167.243.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 30 Aug 2024 10:59:38 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 30 Aug
 2024 03:59:24 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 30 Aug
 2024 03:59:24 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Fri, 30 Aug 2024 03:59:21 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, <virtualization@lists.linux.dev>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Cosmin Ratiu <cratiu@nvidia.com>
Subject: [PATCH vhost v2 7/7] vdpa/mlx5: Postpone MR deletion
Date: Fri, 30 Aug 2024 13:58:38 +0300
Message-ID: <20240830105838.2666587-9-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A5:EE_|SA1PR12MB7200:EE_
X-MS-Office365-Filtering-Correlation-Id: af183d05-a7eb-4083-d25f-08dcc8e2d7b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XF8k4ariKkj64iHhDO66FsSjOwiHW7dtVXnHFcmvW+oXfBSyAk3HAMPKuCzz?=
 =?us-ascii?Q?DUizF7qcTSOt9QPRyMXeWHYapbCtOWOEabMKq0Jp6u/mZ2UQpIhu2YNlEU/M?=
 =?us-ascii?Q?qeHmtVY1r0oxdoTqnxDPUdrdqXkyar6ljkbBK2h+V86eNeKuRDdPaHRZZteL?=
 =?us-ascii?Q?9CjxpvIFcCwMyInmWDSij1G+Gk/N07DQwtpNATa/ZP7eml0/y4/bi4qcgpR3?=
 =?us-ascii?Q?lzNzu3X6QvSWIHSRTeYGdpfzUtdYDsuAGgAe7BrAzlxgG7GaKFa0lazGC0OG?=
 =?us-ascii?Q?71TBX6NyDg5H9yIraWSfu09NJOPTUA9SaG/zYDBsgU1jHduosmlW7xosFUc8?=
 =?us-ascii?Q?t+hmGWKGhhKqovQHUDsSiZ7JLzySwQ7gdC4VK48Nv74pYmdwnwdva5I2+cHG?=
 =?us-ascii?Q?9fV7FikRDB5p5YZR8c+MIP1TBRMhbRVuz2AeNOoJSziRhlK+AUJUl7LB8X4L?=
 =?us-ascii?Q?R2yack85FoFNSl3+78XmjDzpdgt9gKAK/Uv8zs2eEbXQJNXlxU/+Usg6Zu6A?=
 =?us-ascii?Q?MS3+Gp9iMFNM9MXyJAISdqwVFKJQxJbLTmEFb6zxzBwCZxdZ5wWh8iWpj1Kp?=
 =?us-ascii?Q?R1Z8+nXQYrCmKhkGRSKO++QtY0iR7YDgtZC2vR/8Z1iWTy/ebpr9YiKuRix+?=
 =?us-ascii?Q?e/O49vZKdxxfn2JeVOcR/QoDsP5YlpTBrsF+nibTfmIAvZcRqDK9rf+iZe99?=
 =?us-ascii?Q?dGvImvRPZVgwq4zYDv3YQG0UbYkrO5JoJdvDuXRqhp/BMTkl/nnjfKJjehZg?=
 =?us-ascii?Q?qAzq5SELrsZ4gZ6YjjVnkDxuCLmkuC5dHgSCWepYGQGS0TpPZbSv3nV41eM2?=
 =?us-ascii?Q?I2nV6Y5ckwp7bHt7AtDYj5JxQHyWzcPddjabxU51IjGR/AzhDxmBPSaQl5Oq?=
 =?us-ascii?Q?xX/+Otgj6DF0i7+2IfXYNwn8oF5L/h8TzGIGRUGE3dY60SMw30NwvSxu4WDD?=
 =?us-ascii?Q?ltrxJ4m+9nWXSzFsr+sMzEFFV1iK7Rsphk3pO0bYAixB1Z6uIO69741CzuIG?=
 =?us-ascii?Q?pZE9ZUjN+pz7oPCcffLkR/bNYa9ZUo+aT6c+FKmQy8ZBh4NyGO2pnflOdzb4?=
 =?us-ascii?Q?vYurF6WlMtxvuJ9xj/in86d6SI6NiCXNRYl3fthiuI+o6cbemyAFN0SIcMIr?=
 =?us-ascii?Q?WTFKD2wwic0zLuG69fPM/sCWaTdn/4jQFOSOu3FuUiLvGwwvyzvfy0GdE0NT?=
 =?us-ascii?Q?WCkAz/Nkn3L/DKlIjulRrgooXN7h50+bEq7cye7E+5JwzjFMm293D2dfhpZu?=
 =?us-ascii?Q?ihPyqueu0wfq8a4aKy94kBn+LBe1Vjvv+0kTCb+Kqj1m9cRMMmhTGfU3BdaS?=
 =?us-ascii?Q?/5bUL30kMYdfY6hTLiJxShPWJqTifC1FpnKUkw+3X4tD/NjznO+JWJHvh6BW?=
 =?us-ascii?Q?jE9Pw5oklYvCN4ANckew4wa+ge3M/XhcAMyYaohBqRWS/u9f0qkKNQD1NUwJ?=
 =?us-ascii?Q?TVelyHNVn8At7lBtquiyjpwDQmMOq1fg?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 10:59:38.5049
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af183d05-a7eb-4083-d25f-08dcc8e2d7b7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7200

Currently, when a new MR is set up, the old MR is deleted. MR deletion
is about 30-40% the time of MR creation. As deleting the old MR is not
important for the process of setting up the new MR, this operation
can be postponed.

This series adds a workqueue that does MR garbage collection at a later
point. If the MR lock is taken, the handler will back off and
reschedule. The exception during shutdown: then the handler must
not postpone the work.

Note that this is only a speculative optimization: if there is some
mapping operation that is triggered while the garbage collector handler
has the lock taken, this operation it will have to wait for the handler
to finish.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h | 10 ++++++
 drivers/vdpa/mlx5/core/mr.c        | 55 ++++++++++++++++++++++++++++--
 drivers/vdpa/mlx5/net/mlx5_vnet.c  |  4 +--
 3 files changed, 64 insertions(+), 5 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index c3e17bc888e8..2cedf7e2dbc4 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -86,8 +86,18 @@ enum {
 struct mlx5_vdpa_mr_resources {
 	struct mlx5_vdpa_mr *mr[MLX5_VDPA_NUM_AS];
 	unsigned int group2asid[MLX5_VDPA_NUMVQ_GROUPS];
+
+	/* Pre-deletion mr list */
 	struct list_head mr_list_head;
+
+	/* Deferred mr list */
+	struct list_head mr_gc_list_head;
+	struct workqueue_struct *wq_gc;
+	struct delayed_work gc_dwork_ent;
+
 	struct mutex lock;
+
+	atomic_t shutdown;
 };
 
 struct mlx5_vdpa_dev {
diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 0bc99f159046..55755e97a946 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -653,14 +653,50 @@ static void _mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_
 	kfree(mr);
 }
 
+/* There can be multiple .set_map() operations in quick succession.
+ * This large delay is a simple way to prevent the MR cleanup from blocking
+ * .set_map() MR creation in this scenario.
+ */
+#define MLX5_VDPA_MR_GC_TRIGGER_MS 2000
+
+static void mlx5_vdpa_mr_gc_handler(struct work_struct *work)
+{
+	struct mlx5_vdpa_mr_resources *mres;
+	struct mlx5_vdpa_mr *mr, *tmp;
+	struct mlx5_vdpa_dev *mvdev;
+
+	mres = container_of(work, struct mlx5_vdpa_mr_resources, gc_dwork_ent.work);
+
+	if (atomic_read(&mres->shutdown)) {
+		mutex_lock(&mres->lock);
+	} else if (!mutex_trylock(&mres->lock)) {
+		queue_delayed_work(mres->wq_gc, &mres->gc_dwork_ent,
+				   msecs_to_jiffies(MLX5_VDPA_MR_GC_TRIGGER_MS));
+		return;
+	}
+
+	mvdev = container_of(mres, struct mlx5_vdpa_dev, mres);
+
+	list_for_each_entry_safe(mr, tmp, &mres->mr_gc_list_head, mr_list) {
+		_mlx5_vdpa_destroy_mr(mvdev, mr);
+	}
+
+	mutex_unlock(&mres->lock);
+}
+
 static void _mlx5_vdpa_put_mr(struct mlx5_vdpa_dev *mvdev,
 			      struct mlx5_vdpa_mr *mr)
 {
+	struct mlx5_vdpa_mr_resources *mres = &mvdev->mres;
+
 	if (!mr)
 		return;
 
-	if (refcount_dec_and_test(&mr->refcount))
-		_mlx5_vdpa_destroy_mr(mvdev, mr);
+	if (refcount_dec_and_test(&mr->refcount)) {
+		list_move_tail(&mr->mr_list, &mres->mr_gc_list_head);
+		queue_delayed_work(mres->wq_gc, &mres->gc_dwork_ent,
+				   msecs_to_jiffies(MLX5_VDPA_MR_GC_TRIGGER_MS));
+	}
 }
 
 void mlx5_vdpa_put_mr(struct mlx5_vdpa_dev *mvdev,
@@ -848,9 +884,17 @@ int mlx5_vdpa_init_mr_resources(struct mlx5_vdpa_dev *mvdev)
 {
 	struct mlx5_vdpa_mr_resources *mres = &mvdev->mres;
 
-	INIT_LIST_HEAD(&mres->mr_list_head);
+	mres->wq_gc = create_singlethread_workqueue("mlx5_vdpa_mr_gc");
+	if (!mres->wq_gc)
+		return -ENOMEM;
+
+	INIT_DELAYED_WORK(&mres->gc_dwork_ent, mlx5_vdpa_mr_gc_handler);
+
 	mutex_init(&mres->lock);
 
+	INIT_LIST_HEAD(&mres->mr_list_head);
+	INIT_LIST_HEAD(&mres->mr_gc_list_head);
+
 	return 0;
 }
 
@@ -858,5 +902,10 @@ void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
 {
 	struct mlx5_vdpa_mr_resources *mres = &mvdev->mres;
 
+	atomic_set(&mres->shutdown, 1);
+
+	flush_delayed_work(&mres->gc_dwork_ent);
+	destroy_workqueue(mres->wq_gc);
+	mres->wq_gc = NULL;
 	mutex_destroy(&mres->lock);
 }
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index fc86e33e620a..9ccbe1c1ec15 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -3435,6 +3435,8 @@ static void mlx5_vdpa_free(struct vdpa_device *vdev)
 	free_fixed_resources(ndev);
 	mlx5_vdpa_clean_mrs(mvdev);
 	mlx5_vdpa_destroy_mr_resources(&ndev->mvdev);
+	mlx5_cmd_cleanup_async_ctx(&mvdev->async_ctx);
+
 	if (!is_zero_ether_addr(ndev->config.mac)) {
 		pfmdev = pci_get_drvdata(pci_physfn(mvdev->mdev->pdev));
 		mlx5_mpfs_del_mac(pfmdev, ndev->config.mac);
@@ -4042,8 +4044,6 @@ static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *
 	mvdev->wq = NULL;
 	destroy_workqueue(wq);
 	mgtdev->ndev = NULL;
-
-	mlx5_cmd_cleanup_async_ctx(&mvdev->async_ctx);
 }
 
 static const struct vdpa_mgmtdev_ops mdev_ops = {
-- 
2.45.1


