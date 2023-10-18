Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2DF7CE441
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 19:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235348AbjJRRRQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 13:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235337AbjJRRQh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 13:16:37 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1332310C3;
        Wed, 18 Oct 2023 10:16:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MXxYSf60JY0aXF3lsU03Y5CUP15zTk7Q7oq7FacUJHAg/AQprZ9Cr2kXbhsv43n8FrwZvwcU0yx31VB9n4tkKW0vF8Qz7rP1RV8Z1/Hhn5nfFKOTDDVEZnCrYPYI9aZJfKoBEUNL0X6gMJgxemwPfa7bUJq8FRxTbL9+rFKTRnYTwHOPcrhY/cRXO2hiJiVeS0R5pD899XYASrvz5FX/tnmAf7cazKs+D0DcuMurBwPKjCl6uIIYD3XoSOgUdxiDqjI3rDkeebkwATIaCGgkhUiA04+3d3Q1zPj8VApcLUGVKQAjHnT78cxvTno4jHAdl6XDzEAzYH+IomhXK30WlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qb2hZXT5+/f8Ri3WhuaZoK6JttuOpOqJz8f5tpo4KeM=;
 b=iNxjNVuFcXgjxWmU2+ujfPKil9V6Fiy+1ueFpiXo093K57PKgHYYERXtjZfsg1NymTMvhWsX7hKs2h5Rq1pXRg7apVjCuaAW6xqJn6D7ZbRhyki6ELdqbJEAu0fOg24bq/32E411zD9uQikT590uQAZGeuFZ91VPODxzpZOcDHzKTWHSgWUiumLuBZ0ihO7i5bGIPNflSCSnhklK7mNl2QWMZ5zB0Vhe2Qe6w4TZCzmpOHEhW4lRmhtT4VHXEjpDbbd6jjO2aRlIgc7pjZTG2dHojOiebarWNNRxHVxQ4lquzhCEWaA6OYssPhq41J0NuUYXLm0+9Ygt/MWbw4pgmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qb2hZXT5+/f8Ri3WhuaZoK6JttuOpOqJz8f5tpo4KeM=;
 b=Nn1ur1k79NC5ruhUQwoIb+Pc8oXhdlGuzRbnsZ39KNyfMjmd7mDCPSIHTz6DPcbzV3o5zlX66Ga5i42rCfeBVrJe5Bzed975egex200/pmper2gYP/ndb1Yk4glmpFdlEDomFshBe3WJRIuttsPD8Q2zileR6Ze6TiWvtRca2320rHjJqzqpzkEeiejDNfBOaHJUufocyjsHyksi3Mlqw566big+ReC+dIWMFb9PWyjED/TmkZb5gjjxEGFTY8VXiq4/5krWHndLxtK6Ogh7aQe+Zc2nm3LjcpnMCxH0LLTpC94ctwGR3crotqU0PBKtY4VklSO6nwjk7ysv0P+NVA==
Received: from CY5P221CA0154.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:6a::22)
 by PH8PR12MB7424.namprd12.prod.outlook.com (2603:10b6:510:228::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21; Wed, 18 Oct
 2023 17:16:19 +0000
Received: from CY4PEPF0000FCBF.namprd03.prod.outlook.com
 (2603:10b6:930:6a:cafe::51) by CY5P221CA0154.outlook.office365.com
 (2603:10b6:930:6a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34 via Frontend
 Transport; Wed, 18 Oct 2023 17:16:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000FCBF.mail.protection.outlook.com (10.167.242.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.23 via Frontend Transport; Wed, 18 Oct 2023 17:16:19 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:16:05 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:16:05 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Wed, 18 Oct 2023 10:16:02 -0700
From:   Dragos Tatulea <dtatulea@nvidia.com>
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eugenio Perez Martin <eperezma@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        <virtualization@lists.linux-foundation.org>
CC:     Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v4 11/16] vdpa/mlx5: Move mr mutex out of mr struct
Date:   Wed, 18 Oct 2023 20:14:50 +0300
Message-ID: <20231018171456.1624030-13-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231018171456.1624030-2-dtatulea@nvidia.com>
References: <20231018171456.1624030-2-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCBF:EE_|PH8PR12MB7424:EE_
X-MS-Office365-Filtering-Correlation-Id: baca3d41-04a9-4979-ead1-08dbcffdf1e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8DzHpTO8LBf0AWSFkinLAuAlpXVQJx7pa4BZKxV05WPAi9MZpq0bkiZXNYx9kPbA/POG4BVeWWFY+UpkJIsscyz5dnD6CV/aYnfCd5PwhIwtowhM7Zu3NigdI3r5YC5rRNu2Bmr6eRzz0gdhwQDiz5TU5fNDYqYMoWZIoSzfGNMcbZhVNBcfewtYtD4T70FJoH/VsT7TQXas7+K9sczXdiJI44kVa/zWwF14caZAr0FphLx+5oKLq3NlXfKcu4tN3V7Axo/OckjCN1WuvKGIeDeLlRuZumBnw6EkaBI700RFsnyh9xSQ3gWtmfOcIWyiLJD7scs4loBaSypyHtOmQoZB9R9KDf4BbBW9qdCLsJZwg1I9YczDFiQ/yGFnM+O2MyxeX+bDKyK1rMVOR5KPWYuG3VDC2gwXu16+5MCptOO3dwYgJbBBUNJpyLHECbhZ5Gs/3BAnN/9tERap4yE7L2wtcc9cbWN1rvE8I2+tGq8aVYE0rO0TeMlFjkg59aKFixbRQXO44zc0gjfu1BOZHJt+7E5u/2uzJ6hto02R0eDjmeXI4O/WVS3lXOs15tyEOcDJEa9e60VELs5VhCxPU0T2VCNxzG4ZOrDdfJ0xl8mPPqBzh3kPV2/H/uhf3TxxI00uZII2s8Iafr7+Qu/9Tp+vfJxuvMXjfqMLWwaf2mqHeyBa1LswIao5qvnIXqLv1mrh5z00JYn7+DNMmL05UDwtI6cAZxeDmdAHuJfY+bwRG8HBb1Obfb0fQMf/X3Nb
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(136003)(376002)(396003)(346002)(230922051799003)(82310400011)(186009)(451199024)(64100799003)(1800799009)(46966006)(36840700001)(40470700004)(40460700003)(2616005)(47076005)(1076003)(426003)(66574015)(336012)(26005)(478600001)(36860700001)(8936002)(83380400001)(41300700001)(2906002)(8676002)(4326008)(6666004)(110136005)(5660300002)(70586007)(316002)(70206006)(54906003)(356005)(7636003)(40480700001)(36756003)(82740400003)(86362001)(66899024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 17:16:19.2881
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: baca3d41-04a9-4979-ead1-08dbcffdf1e2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000FCBF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7424
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The mutex is named like it is supposed to protect only the mkey but in
reality it is a global lock for all mr resources.

Shift the mutex to it's rightful location (struct mlx5_vdpa_dev) and
give it a more appropriate name.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  4 ++--
 drivers/vdpa/mlx5/core/mr.c        | 13 +++++++------
 drivers/vdpa/mlx5/core/resources.c |  6 +++---
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index 01d4ee58ccb1..9c6ac42c21e1 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -34,8 +34,6 @@ struct mlx5_vdpa_mr {
 	/* state of dvq mr */
 	bool initialized;
 
-	/* serialize mkey creation and destruction */
-	struct mutex mkey_mtx;
 	bool user_mr;
 };
 
@@ -94,6 +92,8 @@ struct mlx5_vdpa_dev {
 	u32 generation;
 
 	struct mlx5_vdpa_mr mr;
+	/* serialize mr access */
+	struct mutex mr_mtx;
 	struct mlx5_control_vq cvq;
 	struct workqueue_struct *wq;
 	unsigned int group2asid[MLX5_VDPA_NUMVQ_GROUPS];
diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 6f29e8eaabb1..abd6a6fb122f 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -509,11 +509,11 @@ static void _mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_
 void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev,
 			  struct mlx5_vdpa_mr *mr)
 {
-	mutex_lock(&mr->mkey_mtx);
+	mutex_lock(&mvdev->mr_mtx);
 
 	_mlx5_vdpa_destroy_mr(mvdev, mr);
 
-	mutex_unlock(&mr->mkey_mtx);
+	mutex_unlock(&mvdev->mr_mtx);
 }
 
 void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
@@ -550,9 +550,10 @@ int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
 {
 	int err;
 
-	mutex_lock(&mvdev->mr.mkey_mtx);
+	mutex_lock(&mvdev->mr_mtx);
 	err = _mlx5_vdpa_create_mr(mvdev, mr, iotlb);
-	mutex_unlock(&mvdev->mr.mkey_mtx);
+	mutex_unlock(&mvdev->mr_mtx);
+
 	return err;
 }
 
@@ -563,14 +564,14 @@ int mlx5_vdpa_handle_set_map(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *io
 	int err = 0;
 
 	*change_map = false;
-	mutex_lock(&mr->mkey_mtx);
+	mutex_lock(&mvdev->mr_mtx);
 	if (mr->initialized) {
 		mlx5_vdpa_info(mvdev, "memory map update\n");
 		*change_map = true;
 	}
 	if (!*change_map)
 		err = _mlx5_vdpa_create_mr(mvdev, mr, iotlb);
-	mutex_unlock(&mr->mkey_mtx);
+	mutex_unlock(&mvdev->mr_mtx);
 
 	return err;
 }
diff --git a/drivers/vdpa/mlx5/core/resources.c b/drivers/vdpa/mlx5/core/resources.c
index d5a59c9035fb..5c5a41b64bfc 100644
--- a/drivers/vdpa/mlx5/core/resources.c
+++ b/drivers/vdpa/mlx5/core/resources.c
@@ -256,7 +256,7 @@ int mlx5_vdpa_alloc_resources(struct mlx5_vdpa_dev *mvdev)
 		mlx5_vdpa_warn(mvdev, "resources already allocated\n");
 		return -EINVAL;
 	}
-	mutex_init(&mvdev->mr.mkey_mtx);
+	mutex_init(&mvdev->mr_mtx);
 	res->uar = mlx5_get_uars_page(mdev);
 	if (IS_ERR(res->uar)) {
 		err = PTR_ERR(res->uar);
@@ -301,7 +301,7 @@ int mlx5_vdpa_alloc_resources(struct mlx5_vdpa_dev *mvdev)
 err_uctx:
 	mlx5_put_uars_page(mdev, res->uar);
 err_uars:
-	mutex_destroy(&mvdev->mr.mkey_mtx);
+	mutex_destroy(&mvdev->mr_mtx);
 	return err;
 }
 
@@ -318,6 +318,6 @@ void mlx5_vdpa_free_resources(struct mlx5_vdpa_dev *mvdev)
 	dealloc_pd(mvdev, res->pdn, res->uid);
 	destroy_uctx(mvdev, res->uid);
 	mlx5_put_uars_page(mvdev->mdev, res->uar);
-	mutex_destroy(&mvdev->mr.mkey_mtx);
+	mutex_destroy(&mvdev->mr_mtx);
 	res->valid = false;
 }
-- 
2.41.0

