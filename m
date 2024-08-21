Return-Path: <kvm+bounces-24719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B0F11959ADF
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 13:56:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 457331F242AE
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 11:56:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 367561B531A;
	Wed, 21 Aug 2024 11:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TkMH2Iqf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE01B1B3B2E;
	Wed, 21 Aug 2024 11:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724240529; cv=fail; b=F9KoUkYZBrsZ4/S+GY6DL7q1bx3FJ1Xi4vj1YWC1Fxg845aK/aMitzNL/TbkT51EKWLtO2HdIB1cvQODE3Vo1eD9ow+OaDqMlXdeRPzxjEzH0WGU/vmqmArPvRaDhB8EYxHyuo5bcNOeV8VX/GAoJA2T+wIaeRUx2+d186j+2zU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724240529; c=relaxed/simple;
	bh=4urm2+xcIRqLKwfdspf4ZmxKI84/zfqAObIZJDJGjgE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RQvBDaOpgKr1J2SvEdKWDKp0/pO33zNhY/xwBLrq9hYgmyOUQT9Wm5TLt/3yCVxXM7DMiLZBkMPqt3EjBrbkqRUcCG41SQbc89sY0KYdwDRNygbse2slJCzWYyz+2F9ZzE83Ztal/ncFP8fuQtQRWqJRvu2f+jZ3zvohmWSKKfo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TkMH2Iqf; arc=fail smtp.client-ip=40.107.220.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oU0qX8OHjaM6iRjFtrdaRDRbUfCpYih+GFRkQQ8PuovIeXvLe4ikQQNDBTznAp+EZMi3sP9bw83nX4g2zNdezShSXKGmQFMhWFNf4d4CAj3qXQn/Tdvk4qHOstWHb82ADNPzfy/oaTKyAlrL8Qzs3b8v3canKG8YuPmEb0FIRm03C7LL1JhoHfRPosfBn3Ysl8YHAV5zxZZobJiWf5OsJtFN3FiM/gEj+Mh0kWzxpoLKpyLHlYFdm3cPx/mJt+aRDdaJZP1GSaLsmZm7BzWYBZmSVqpnP+BBGlGlnj0pebC32ZzKTOWAPd5hVxqFjxs4868vQj+YVSW6leTY4oybNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7EhGLrQKQnd7+m/Rm1T92MW0R30h1AOUmHsPkIzt9k4=;
 b=V1/7WtR6WDTIAa+zF0RWrxWX7GIBFhv/52qDcSAWLfyzAHMsigRdfClyJNXCVOK3rJyrV/fqwG8m62zVRjPrrl0reR9yn7jjQkaD9vmiM2uHEfXTW7Fj2awKOzwJTmkn+j9MGOM4lrr1mM13Qv3epvpaD3igqQbAiy4sm+o4IKL0H6PYjoljUiy4WixfRFy5VxH8L+IIvXOyTZHworA5oTnwifWnlDh6j54WXsLbzo8M7KSNcwxdvdfQ1s1yP+3xEdGthOo1kP5gxrImy21EEXZEi/q/W+doe5zFhYUypWbCgFhLmEYLC/7lAEa2i0qBsQYqzv9eZ3W4lyTaA7AanQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7EhGLrQKQnd7+m/Rm1T92MW0R30h1AOUmHsPkIzt9k4=;
 b=TkMH2Iqfi5sq3CLk0SQl9g5rQMgDIosD8k5eYkNOVbplTIPjW3nuCQLR8JU5rTKn1/E1RBhqT9B2SPJ1HFeI2T6xpRQK2xzFe4w7Ty/3Q7NcpaQKHmY76V5Fq4XAlDRafZR/VLR2YHzvYbimKafirLR4qQIaZyYGs2Llr9iowtWBxoyxQLtFbVGJde2uDHVGKpSYngACziJG+goNH/bnzj0ql02ZWSGUmCGUK7U9M8y8Ej1giVQk8os8DuQcKyKJil9G0UqqGfjjZS/NpA3r5FxMBWByxpcHURkujs4sAdW1aX7O3jbXflEJ8VPa7P7+w+Nnr6z8e2miiWGVpI98GQ==
Received: from BN9PR03CA0276.namprd03.prod.outlook.com (2603:10b6:408:f5::11)
 by DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.18; Wed, 21 Aug
 2024 11:42:01 +0000
Received: from BN3PEPF0000B36F.namprd21.prod.outlook.com
 (2603:10b6:408:f5:cafe::82) by BN9PR03CA0276.outlook.office365.com
 (2603:10b6:408:f5::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.17 via Frontend
 Transport; Wed, 21 Aug 2024 11:42:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF0000B36F.mail.protection.outlook.com (10.167.243.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.4 via Frontend Transport; Wed, 21 Aug 2024 11:42:01 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 21 Aug
 2024 04:41:46 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 21 Aug
 2024 04:41:46 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Wed, 21 Aug 2024 04:41:42 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, <virtualization@lists.linux-foundation.org>, "Gal
 Pressman" <gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Cosmin Ratiu <cratiu@nvidia.com>
Subject: [PATCH vhost 5/7] vdpa/mlx5: Rename mr_mtx -> lock
Date: Wed, 21 Aug 2024 14:40:59 +0300
Message-ID: <20240821114100.2261167-7-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36F:EE_|DM6PR12MB4218:EE_
X-MS-Office365-Filtering-Correlation-Id: 3770dfd0-6188-4f48-a978-08dcc1d645c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ocSnc3ou8O4M712szjSqjNeduHmSX4mSh6QkcUJ79ZChTiYL1MQxHTjLxwqS?=
 =?us-ascii?Q?eD8SX4xYGuMUxik9NHYlGB66YTyWDUmZeGWWmIiAD1BLtsFf0oj6EPZ80YHY?=
 =?us-ascii?Q?xeUFSloF48gDTB2HpSzoPrb0kuZIO1J05vqqnoZZokMZZ18xo7Ka1GMusamo?=
 =?us-ascii?Q?DR4shrtVZB7Ua7bmqVIlH5nG7LeH/tAn25i4Q33q0mUMEY7s+E518UWNUrek?=
 =?us-ascii?Q?ejhRwk3c4xH3xl/jBCWU/IwBE8XyB/BvKEQawDcOWSez76Tqfx0mPdPLqTK4?=
 =?us-ascii?Q?ETW6o1n5SuY4qIk0IpYeSIfdPw8ek/HChm+a4Z2dSVBNzGiZ1Y/FnKi7SBad?=
 =?us-ascii?Q?1OVDFCB7O8BuewPpZuxYrawJUnJ7ifjhaQJIEhLyKC702r59HoO+qYP4Kb7U?=
 =?us-ascii?Q?nb8WRo2GYJ/mX2fkyGzuJs3a8YPWq5RwJUnKBxbOD096tx/E6t6yJ71BxTua?=
 =?us-ascii?Q?Y1BUqG/cQPxO5TA/vVdeTMjxmAJlC6duv6RVLMouHBAjt/cYKhISnnbUNhB0?=
 =?us-ascii?Q?O7ojuChJ+qKztPGF/xAexLiSDkD+V91JDFbZgpa/PJbXT3Xgvf338TQ89P0Z?=
 =?us-ascii?Q?Nr85sH8/ToUTcZroBKIxw8vWVlHQherPhMkjHjxHi4MHSkrDF67OjUVmfbgg?=
 =?us-ascii?Q?8dJRjf+H8D17PzASpi+21TN6wvZqeBoHfEH5W/GlilzxB2hQeY1LFUaMJhwa?=
 =?us-ascii?Q?5NV1bcMk+xxFlENfkyaZK/qo/HhiQ8SLvJL8FSLN/CEorBWW8BIpt/njz31v?=
 =?us-ascii?Q?zDvWde1BnXq4GcAXJJdDzf8R1IElZovjQ0Hc79DW39tnuQqv8VnrHZgAryo0?=
 =?us-ascii?Q?xh9nfvAxhc3CfcI8eh1WusPt5n1+sN5MJprImJtFK8LTz4/yU53SMFbFiTu9?=
 =?us-ascii?Q?Emy0YVGAoTSH+MFuUe4weE0C5ETIi3nxVaL8bsu4jHPtswkcqSSpWyqS1OxL?=
 =?us-ascii?Q?pEoDKcg6T4cDvv3gZ9GbsybMlI3vXJPi1izZGe6F1rstL6Zz5V90r+Jd8X5C?=
 =?us-ascii?Q?HW7NDHRNVMjFgoT/de452fQtZeXib1GjSI8WoAUhnow8riBkIWZw2Ufvv6re?=
 =?us-ascii?Q?wHcTsmtLbzC6cCgvUoojXzyFAaNSm+yck16CjJDpYZ6djZu3LVkLjk91vnFA?=
 =?us-ascii?Q?PSwMHdgDkAhe8PibbwxrrquQXqHKCYSenUGgMgdqch/OQUixsrYJbzNhxPsD?=
 =?us-ascii?Q?CC1PMLm//rQBCmuQxGF1h164KSx2UTqEAsB6ZPTVDB7/NsP5Pj9gk7CEd/Hy?=
 =?us-ascii?Q?+ZqD5pyjgiV6FOeYxARBuWNs8CSTAjVMh9tgZeyN7Ta0j55Knv4ycQQ6WyOL?=
 =?us-ascii?Q?Nc0amvRWzoy+EDA3ECFIxobE56oN+Xp11ZTCne3Byi9DQ6VtRzpvf03O3Eky?=
 =?us-ascii?Q?Lkb70ywKf5bBA8nOg5c1Bh4Z/mUWiiisyeqt1m1RTRJaUjttQtrrwncZ8PRQ?=
 =?us-ascii?Q?DRw0z/Rfs3ZGs3K7OIuBiD30fO09ybYp?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 11:42:01.5480
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3770dfd0-6188-4f48-a978-08dcc1d645c5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36F.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218

Now that the mr resources have their own namespace in the
struct, give the lock a clearer name.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
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
index 2c8660e5c0de..f20f2a8a701d 100644
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


