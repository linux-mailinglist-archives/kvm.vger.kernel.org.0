Return-Path: <kvm+bounces-24720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CB7B959AE2
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 13:56:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33C1A2831A8
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 11:56:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2565F1B5ED4;
	Wed, 21 Aug 2024 11:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RMRECfKC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD801B5EB4;
	Wed, 21 Aug 2024 11:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724240536; cv=fail; b=CmLhkqSj0OuF7RzW9NEFs5L1+Jg8zf0gKrZr6U49lBrMFFUU8aCHTX5D+eTnFNNQtGvxVQZIljeUrgt593OIeyJZQ2Xu8NeqhLNezZ0kr6Tvr229Iv0WPHcTuukRJj9FIrtYJSdamcmxzpfDFJhm/FRojUCyKHFdUQLG9rOh8PQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724240536; c=relaxed/simple;
	bh=5uGpCs1fWERSSPpGQIGuNCPxX/YeG+aOuuHcltw749k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r9yHQxNqPy5VTM3v28tcMZfWWtLqdsmkVReQm1waCugB8S9tshR82wzhEp39/huB7kuHmPOaK7x0eEdPQwEoHt6fzi399XHLAKVG0Bik/I7ZNpEMIV93+5i6sMEF5/rkJO+0eMmHhfYzqj9ifMHT5ez8NUfQzWiuIx2WZLNj/Zk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RMRECfKC; arc=fail smtp.client-ip=40.107.243.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m2wZ5e7c2blVbZArdKMn8nL/i5OUcQbZ4m1wWGSNxwPkOqMZgZW95oqked0nBGQpkDWEndsVjWf62AQkoAZ+qkrISNz3C/thTpn27iTUtN1eaxhfT6CV+G0xIc2kU4yrGqCy7Ucww+OSDolrlABdBqqhJa75H3Ro29R61tvToRHY1gyOZIIq/4F9WwceTifhUIdWgTjCIvVFBa+lVvy82GTgDvGtxWzpE9+B2N0QsRn8b1923lO2flhaIsQLVv44gNIfFIV3y9CWnZEu+UrXUvgfClXSfRJOmbp8ZhdTHEZA3oPghrbEyE1Ef4y9/KjtgU88kIZsyUIm7Tmf3qhuHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MpRZbz6kEMX2/5Kzufx6uJYes/rX50gatEiwGsclbvI=;
 b=ib9SyHPRe7RMRuaAMWMFR8YPFVPG5XjSy7Z3zg9P2Qs+sU+omXpPDV8Mk5DOg02HA1h0Djz5Wm8NLiZPL31FoDKNrfgADe81h30942w/unrtyw+2uFHerTjh1ZLOTjtt3eICCT/Sh8DKbnFAqHJktKCaMXoDDub0xT1VNTUuJxnpKTixJPB2EIYz7nNbPh6wgeMyQ/RPawoSiJuIwJoirysJlHVtfh7A7oAir2xSZWfu31/ndkiDJXdn5kfEG6NK10z7Bo94gWYcHxG5pNLyHXMXye9wNqgdwBbixvMol2st504A0MuiE90KzrR72PQEQQz/Vzp28WHgBPhBUJQa4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MpRZbz6kEMX2/5Kzufx6uJYes/rX50gatEiwGsclbvI=;
 b=RMRECfKC3hNWHA9qak76YUaxB4HM7zH9Wp80m0J2vgWsBorRP+f74YIXAjR+ZOWvaQ1zbX0Mt+rfSxQWdb9GOYfPVcoOVhKm5df206UMP0Uis+jIVfww1GPz14oVVMDJGLnOXAGiy8i2zqWlpfGMx1q6g05Pt5Ht1mDmqB+9mp53ph5etOnV2ixQalLL0dtC6waBJVqF0jueAaiBLkqYmAnYwLAPdWKlgAn354hyEz+8hnBstinaIcvTCdyl1uA1KG9cBMY7ArZqyg+c+a7yvbyqU7xAXYhR5hZP1oibahgR0Q3w0TQhWTS49dtZfseZxQBYTUhDbZVnMjmBTIhJcA==
Received: from BN9PR03CA0274.namprd03.prod.outlook.com (2603:10b6:408:f5::9)
 by MN0PR12MB6245.namprd12.prod.outlook.com (2603:10b6:208:3c3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Wed, 21 Aug
 2024 11:42:07 +0000
Received: from BN3PEPF0000B36F.namprd21.prod.outlook.com
 (2603:10b6:408:f5:cafe::2b) by BN9PR03CA0274.outlook.office365.com
 (2603:10b6:408:f5::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25 via Frontend
 Transport; Wed, 21 Aug 2024 11:42:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF0000B36F.mail.protection.outlook.com (10.167.243.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.4 via Frontend Transport; Wed, 21 Aug 2024 11:42:06 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 21 Aug
 2024 04:41:53 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 21 Aug
 2024 04:41:53 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Wed, 21 Aug 2024 04:41:50 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, <virtualization@lists.linux-foundation.org>, "Gal
 Pressman" <gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Cosmin Ratiu <cratiu@nvidia.com>
Subject: [PATCH vhost 7/7] vdpa/mlx5: Postpone MR deletion
Date: Wed, 21 Aug 2024 14:41:01 +0300
Message-ID: <20240821114100.2261167-9-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36F:EE_|MN0PR12MB6245:EE_
X-MS-Office365-Filtering-Correlation-Id: 132edc63-0aef-4e83-0de0-08dcc1d648f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xR/D4CgvNhFXQpF+KT+2wJDWhV6Np/PfngUBtxzOlfRNCGmirAgCuhkaEfUG?=
 =?us-ascii?Q?UrMYzH5MOq1pO3YNIeSrneFSmk9PomHxvqZFsUvQr2hp3MBUR0Q+GgBk/FXf?=
 =?us-ascii?Q?U0fQSrYprFbEviwAF5QDP/HQaaRw3XLQrWI4nJWEOOqTqp4LSCd0evETeJzG?=
 =?us-ascii?Q?AHjjZI19K3l5995K0ElkGe4ZC+oZrH1fODinQYc45cBAbKaVCfeUrQRNNB/N?=
 =?us-ascii?Q?xH3wyJM0jdD7QWIAzFkI+jE2TX6dJ3daaLUduDbg7wd5mjsHHe4ISEE1mriS?=
 =?us-ascii?Q?ttD0jZOHGiv3ZcrT/a6AEPTXKiIFESe3PixZSpulceZ5kBbpWyoYshq2zwFO?=
 =?us-ascii?Q?xQziv1lG6q/mXcR5WOsxbvmKfoACXN5eHRgtjza9NhlWYUp4FrFaNFvwgo4N?=
 =?us-ascii?Q?MjNrhQ4w2fwmnNMubz2EW4lqeZVB3DYacmEfUyscuXSjRTLgKG7/kqnx1LDt?=
 =?us-ascii?Q?2rOm0ITsKWcy9hjkGTwRZhAcUD1gDlMQmhRAsSW8l8wGjpoaK0TJ6Pu3Jn4d?=
 =?us-ascii?Q?JdcVAVoguAm2bCGJU9MLPpr5HjAhsG2CCeYpviNLP63BwKmEyZ4g7dXpHRHj?=
 =?us-ascii?Q?NGXVeQLBnag8jvBwaX8o1ChA++OUNyUG71mid9QEm480kFHocgpnptcgMkAP?=
 =?us-ascii?Q?zqmGy6Z20NHoHRX3B2ct1+yHLR31BFFjGtH8qfKG3GHrCThpk0uolkdijNto?=
 =?us-ascii?Q?TavPD7VKJNLwKhoTIseTN/HF/Wp/nD0EwyW7znPFEBA2lclNTXczh1vD9Iga?=
 =?us-ascii?Q?U+0a3vyHHiQUAOHOzCiZlHHLIInOUJUCpDraHB2ktzDxyZQkRCj7cr1JosE8?=
 =?us-ascii?Q?K9egwfR3HCMbjy2xTlZftChHKCCjpGp3ao5qqi2xZzKNF3YdvyljuShRGVfY?=
 =?us-ascii?Q?4z5YcYIJ1JNG5Hoo4uyhETJpVNMmyiFaQ0sk6U/rvmh2a9zSACa6Dvt7Xczu?=
 =?us-ascii?Q?ESQnlSPQxP6DLQm7K1BagOWh+yWYEZOQaW+ECYJf4jl6KObmz8DdP3IFZhUb?=
 =?us-ascii?Q?2lz3dw5NZ/DsLlypan3JIOT7eeQjIF43nR0BO7gMBkzQmcvZs+B8/nJFrAtr?=
 =?us-ascii?Q?YNAugVbEAYWQSiD58r0Cu28DN158IC0Zyyx+cgr1Ue50ZL5KBh96dMShakt+?=
 =?us-ascii?Q?JIRVhL08WsOQRZPSx2To3oN96Dakj4QUl73z/fjPwNjQr4vBec6H87zlKhgp?=
 =?us-ascii?Q?QdqjTs1joGJcD/SFaT8odc5NW5v2yGvuVQvIGp1zgZTqCt5MAennDUCimL78?=
 =?us-ascii?Q?yQVP7mPiaVhGXM5uaAU55DgI+IEPqhnb+65bFQKAAA0PTe6CjzOSkeUiqlnQ?=
 =?us-ascii?Q?zMmqgrObx+P3MSgKv7x2VXaNKELFI2P3cGJ7ePUVnvDFaF6+R72Gutm6hVZ8?=
 =?us-ascii?Q?TtQFfpuTxTbImAHjNxB49+QkBUBKpugUksl/DVkClE0S0VY+h2CugHafnNQF?=
 =?us-ascii?Q?Qsun4b3Rq8BZxfvdZXRgQG8nl2iP/jfE?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 11:42:06.8918
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 132edc63-0aef-4e83-0de0-08dcc1d648f5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36F.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6245

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
 drivers/vdpa/mlx5/core/mr.c        | 51 ++++++++++++++++++++++++++++--
 drivers/vdpa/mlx5/net/mlx5_vnet.c  |  3 +-
 3 files changed, 60 insertions(+), 4 deletions(-)

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
index ec75f165f832..43fce6b39cf2 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -653,14 +653,46 @@ static void _mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_
 	kfree(mr);
 }
 
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
@@ -848,9 +880,17 @@ int mlx5_vdpa_init_mr_resources(struct mlx5_vdpa_dev *mvdev)
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
 
@@ -858,5 +898,10 @@ void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
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
index 1cadcb05a5c7..ee9482ef51e6 100644
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
@@ -4044,7 +4046,6 @@ static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *
 	destroy_workqueue(wq);
 	mgtdev->ndev = NULL;
 
-	mlx5_cmd_cleanup_async_ctx(&mvdev->async_ctx);
 }
 
 static const struct vdpa_mgmtdev_ops mdev_ops = {
-- 
2.45.1


