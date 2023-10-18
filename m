Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C1B7CE43E
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 19:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235146AbjJRRR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 13:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235402AbjJRRQk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 13:16:40 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2047.outbound.protection.outlook.com [40.107.244.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7F8189;
        Wed, 18 Oct 2023 10:16:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsyAf+op9S9BBb9bqex+8v6EERwV5yXMgWErn813SY5rDY768Q/YM8dytFvW9mGPnswqe8Ic7DstwJ2SNHO/JK/TrkswYLxdlA/v1kOyBB9poKXSRSrq9/DPk4E4CV1S/nFgD4onFR+A6LKIrQZ76mmbEelXKJ+wrXdFJ4VMdFX0K33hEAWyhsEwsAwkElmC5GbE6cYGiCDzDALUEM5g8avLss5xZeFIaOxc4rIzzaXJU94qkOyqXe3lXQWOeSct6CZ3TDepHicvE3v+u+K3Okw87ZSFuS6GG/a+8VXaSRNMi/6+iBLgD0vNKfYAr9UqgzKTpzD3YoJDfV3agxpAtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j+yKp2e1QHrSlE2/K+1Q9nARtdxnRNsDTO9eHQUcPRA=;
 b=AmRcUJYc8JAEhUhTsl8A49UVaSvInguozEh3CGGwdvr+tFGDaUWHn97OoRvZAthNLXbQmDFHdW91X2OSv9eLrJ9C/Twe52RyFvaamrzj4Wa5hz3Tb33bAbjIBlg5uOyg2seK75pRmdlkrdBm8XhLmsSQrkJufhXOD3EbuCG6qZaa17QB/j2B7jtUO2k80WoO8+094hK8PF4JuzkeCLvZ16a8cg9SwHt55m8iq1hYb6EwpWUao8hyyX19FgPw6TZpiLQktLkryUrDU11kZ2OXRckEnjK4gm+UxJrd2t5F2mTiyxAeyNoxYTwFsTvDVU5EIxFdrmVJaEcYL6J6SwWVXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j+yKp2e1QHrSlE2/K+1Q9nARtdxnRNsDTO9eHQUcPRA=;
 b=IrmamJsFjnIQg7D62DgfvfluJVuD7b+TwKTQSC/DgE+0aSJvVrhXn8WaH4LwH2pPIhRT83C5EJQO7OnPaBuo2vIK3/T+8RrbdR3LJz+oHn1xeIttx+9vvA10bW/ej94zUNAbWPnAmu1q9wSmQhLOVdSjja3GznBgNrJFrshUYy9tjVy1s++WIhEKSYKmjDKFlwBoHnD535fyfSWMjDQhHgznp3+L+WGj9CCi362e0P6tqrSMU1SbODseJ54YVj/aro8wcPPmb2O1tY1PgVAYnGvObc6uOo4Y+B1ab+95nibIM6PiwOjXvbsbfHZgh38h9WJ81FYJHFpWbaf21BOonQ==
Received: from CY8P220CA0034.NAMP220.PROD.OUTLOOK.COM (2603:10b6:930:47::15)
 by MN0PR12MB6367.namprd12.prod.outlook.com (2603:10b6:208:3d3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Wed, 18 Oct
 2023 17:16:23 +0000
Received: from CY4PEPF0000FCC5.namprd03.prod.outlook.com
 (2603:10b6:930:47:cafe::25) by CY8P220CA0034.outlook.office365.com
 (2603:10b6:930:47::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.30 via Frontend
 Transport; Wed, 18 Oct 2023 17:16:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000FCC5.mail.protection.outlook.com (10.167.242.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.22 via Frontend Transport; Wed, 18 Oct 2023 17:16:22 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:16:09 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:16:08 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Wed, 18 Oct 2023 10:16:05 -0700
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
Subject: [PATCH vhost v4 12/16] vdpa/mlx5: Improve mr update flow
Date:   Wed, 18 Oct 2023 20:14:51 +0300
Message-ID: <20231018171456.1624030-14-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231018171456.1624030-2-dtatulea@nvidia.com>
References: <20231018171456.1624030-2-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC5:EE_|MN0PR12MB6367:EE_
X-MS-Office365-Filtering-Correlation-Id: 34232203-ccbe-4cb1-fa0f-08dbcffdf3ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dUPA8LAZ+cXKhaCogU8k1Wwz3OSZYsXwpY/39z0byjSt0VDW/Km+ILR1RjL1UyTerXGBLBt1Nz35wZudSBdwPtQIVuKa8k/UPWusdtujMb5l1FtEM0uGg5V3Xz9fWjb2UOHjoGmf3i+LCZ/WSizclzrIvX1LPlmg+2PIrHv7ghc8vjk0VYZfrF7qab2omxFwHd2PcYYuUi7yEkU4kHsGyy30zl0yhTaTAN4QTvYtgvKSazYrgoWWjm/wr80JQTY4GOLt62Io6nIbgeLleewt/lwKAhLzuTc9Jllo6v5bSMq9jZXQneGuyWS/ADOA9wR2FyZLcz2q23adDG73rKW/kroRUMfeXTWrw0ECnu1G4Ls68ECorWqj7+z9FRhaw6q/ms59gw8WORXbfG1i9vl0h4t476DDp3rGQCY2dG+SNTIhUCXJ+sjXHljQgnSw+IVaC8gC72wFurr8LKC6e2OAkAXAACNJtG8pKe8TPO4vcLvHjTqWMVlIrYnjG/tEg0tih+un/bLYZtE9KUazRE0xJHVEhXDNbB6tQ9LjwghcBstMMMsPxywGMoYklF7nRZV37FEJaniby8jEbvSdN9rqGUmfQABeFRHmF49nA+R1AdMzut22W7QAmRVFXdC2ToPIC4MQo2RCTivI6jiE0+e2yt9U3cK0NTa9bts4zakruc1j/BqceUbcDyqF1o8nwCiKFSmKGSaP50mD4N+vbIq593nEdMWRuqPwapNN/LoR874Te8UVqjfmrihS311ygSt7MYxl4KcjFXhJ5j3h41q6Bg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(396003)(39860400002)(346002)(230922051799003)(451199024)(186009)(82310400011)(1800799009)(64100799003)(36840700001)(40470700004)(46966006)(40480700001)(40460700003)(70206006)(6666004)(70586007)(54906003)(110136005)(478600001)(83380400001)(36860700001)(47076005)(356005)(336012)(82740400003)(316002)(26005)(86362001)(1076003)(426003)(66574015)(2616005)(7636003)(36756003)(5660300002)(8936002)(8676002)(41300700001)(2906002)(4326008)(15650500001)(334744004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 17:16:22.6808
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 34232203-ccbe-4cb1-fa0f-08dbcffdf3ea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000FCC5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6367
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current flow for updating an mr works directly on mvdev->mr which
makes it cumbersome to handle multiple new mr structs.

This patch makes the flow more straightforward by having
mlx5_vdpa_create_mr return a new mr which will update the old mr (if
any). The old mr will be deleted and unlinked from mvdev. For the case
when the iotlb is empty (not NULL), the old mr will be cleared.

This change paves the way for adding mrs for different ASIDs.

The initialized bool is no longer needed as mr is now a pointer in the
mlx5_vdpa_dev struct which will be NULL when not initialized.

Acked-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h | 14 +++--
 drivers/vdpa/mlx5/core/mr.c        | 87 ++++++++++++++++--------------
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 53 +++++++++---------
 3 files changed, 82 insertions(+), 72 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index 9c6ac42c21e1..bbe4335106bd 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -31,8 +31,6 @@ struct mlx5_vdpa_mr {
 	struct list_head head;
 	unsigned long num_directs;
 	unsigned long num_klms;
-	/* state of dvq mr */
-	bool initialized;
 
 	bool user_mr;
 };
@@ -91,7 +89,7 @@ struct mlx5_vdpa_dev {
 	u16 max_idx;
 	u32 generation;
 
-	struct mlx5_vdpa_mr mr;
+	struct mlx5_vdpa_mr *mr;
 	/* serialize mr access */
 	struct mutex mr_mtx;
 	struct mlx5_control_vq cvq;
@@ -114,14 +112,14 @@ void mlx5_vdpa_free_resources(struct mlx5_vdpa_dev *mvdev);
 int mlx5_vdpa_create_mkey(struct mlx5_vdpa_dev *mvdev, u32 *mkey, u32 *in,
 			  int inlen);
 int mlx5_vdpa_destroy_mkey(struct mlx5_vdpa_dev *mvdev, u32 mkey);
-int mlx5_vdpa_handle_set_map(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
-			     bool *change_map, unsigned int asid);
-int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
-			struct mlx5_vdpa_mr *mr,
-			struct vhost_iotlb *iotlb);
+struct mlx5_vdpa_mr *mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
+					 struct vhost_iotlb *iotlb);
 void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev);
 void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev,
 			  struct mlx5_vdpa_mr *mr);
+void mlx5_vdpa_update_mr(struct mlx5_vdpa_dev *mvdev,
+			 struct mlx5_vdpa_mr *mr,
+			 unsigned int asid);
 int mlx5_vdpa_update_cvq_iotlb(struct mlx5_vdpa_dev *mvdev,
 				struct vhost_iotlb *iotlb,
 				unsigned int asid);
diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index abd6a6fb122f..00eff5a07152 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -495,30 +495,51 @@ static void destroy_user_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr
 
 static void _mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr)
 {
-	if (!mr->initialized)
-		return;
-
 	if (mr->user_mr)
 		destroy_user_mr(mvdev, mr);
 	else
 		destroy_dma_mr(mvdev, mr);
-
-	mr->initialized = false;
 }
 
 void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev,
 			  struct mlx5_vdpa_mr *mr)
 {
+	if (!mr)
+		return;
+
 	mutex_lock(&mvdev->mr_mtx);
 
 	_mlx5_vdpa_destroy_mr(mvdev, mr);
 
+	if (mvdev->mr == mr)
+		mvdev->mr = NULL;
+
+	mutex_unlock(&mvdev->mr_mtx);
+
+	kfree(mr);
+}
+
+void mlx5_vdpa_update_mr(struct mlx5_vdpa_dev *mvdev,
+			 struct mlx5_vdpa_mr *new_mr,
+			 unsigned int asid)
+{
+	struct mlx5_vdpa_mr *old_mr = mvdev->mr;
+
+	mutex_lock(&mvdev->mr_mtx);
+
+	mvdev->mr = new_mr;
+	if (old_mr) {
+		_mlx5_vdpa_destroy_mr(mvdev, old_mr);
+		kfree(old_mr);
+	}
+
 	mutex_unlock(&mvdev->mr_mtx);
+
 }
 
 void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
 {
-	mlx5_vdpa_destroy_mr(mvdev, &mvdev->mr);
+	mlx5_vdpa_destroy_mr(mvdev, mvdev->mr);
 	prune_iotlb(mvdev);
 }
 
@@ -528,52 +549,36 @@ static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
 {
 	int err;
 
-	if (mr->initialized)
-		return 0;
-
 	if (iotlb)
 		err = create_user_mr(mvdev, mr, iotlb);
 	else
 		err = create_dma_mr(mvdev, mr);
 
-	if (err)
-		return err;
-
-	mr->initialized = true;
-
-	return 0;
+	return err;
 }
 
-int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
-			struct mlx5_vdpa_mr *mr,
-			struct vhost_iotlb *iotlb)
+struct mlx5_vdpa_mr *mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
+					 struct vhost_iotlb *iotlb)
 {
+	struct mlx5_vdpa_mr *mr;
 	int err;
 
+	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
+
 	mutex_lock(&mvdev->mr_mtx);
 	err = _mlx5_vdpa_create_mr(mvdev, mr, iotlb);
 	mutex_unlock(&mvdev->mr_mtx);
 
-	return err;
-}
-
-int mlx5_vdpa_handle_set_map(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
-			     bool *change_map, unsigned int asid)
-{
-	struct mlx5_vdpa_mr *mr = &mvdev->mr;
-	int err = 0;
+	if (err)
+		goto out_err;
 
-	*change_map = false;
-	mutex_lock(&mvdev->mr_mtx);
-	if (mr->initialized) {
-		mlx5_vdpa_info(mvdev, "memory map update\n");
-		*change_map = true;
-	}
-	if (!*change_map)
-		err = _mlx5_vdpa_create_mr(mvdev, mr, iotlb);
-	mutex_unlock(&mvdev->mr_mtx);
+	return mr;
 
-	return err;
+out_err:
+	kfree(mr);
+	return ERR_PTR(err);
 }
 
 int mlx5_vdpa_update_cvq_iotlb(struct mlx5_vdpa_dev *mvdev,
@@ -597,11 +602,13 @@ int mlx5_vdpa_update_cvq_iotlb(struct mlx5_vdpa_dev *mvdev,
 
 int mlx5_vdpa_create_dma_mr(struct mlx5_vdpa_dev *mvdev)
 {
-	int err;
+	struct mlx5_vdpa_mr *mr;
 
-	err = mlx5_vdpa_create_mr(mvdev, &mvdev->mr, NULL);
-	if (err)
-		return err;
+	mr = mlx5_vdpa_create_mr(mvdev, NULL);
+	if (IS_ERR(mr))
+		return PTR_ERR(mr);
+
+	mlx5_vdpa_update_mr(mvdev, mr, 0);
 
 	return mlx5_vdpa_update_cvq_iotlb(mvdev, NULL, 0);
 }
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 256fdd80c321..7b878995b6aa 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -873,7 +873,7 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
 	MLX5_SET64(virtio_q, vq_ctx, desc_addr, mvq->desc_addr);
 	MLX5_SET64(virtio_q, vq_ctx, used_addr, mvq->device_addr);
 	MLX5_SET64(virtio_q, vq_ctx, available_addr, mvq->driver_addr);
-	MLX5_SET(virtio_q, vq_ctx, virtio_q_mkey, ndev->mvdev.mr.mkey);
+	MLX5_SET(virtio_q, vq_ctx, virtio_q_mkey, ndev->mvdev.mr->mkey);
 	MLX5_SET(virtio_q, vq_ctx, umem_1_id, mvq->umem1.id);
 	MLX5_SET(virtio_q, vq_ctx, umem_1_size, mvq->umem1.size);
 	MLX5_SET(virtio_q, vq_ctx, umem_2_id, mvq->umem2.id);
@@ -2633,7 +2633,7 @@ static void restore_channels_info(struct mlx5_vdpa_net *ndev)
 }
 
 static int mlx5_vdpa_change_map(struct mlx5_vdpa_dev *mvdev,
-				struct vhost_iotlb *iotlb, unsigned int asid)
+				struct mlx5_vdpa_mr *new_mr, unsigned int asid)
 {
 	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
 	int err;
@@ -2641,27 +2641,18 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_dev *mvdev,
 	suspend_vqs(ndev);
 	err = save_channels_info(ndev);
 	if (err)
-		goto err_mr;
+		return err;
 
 	teardown_driver(ndev);
-	mlx5_vdpa_destroy_mr(mvdev, &mvdev->mr);
-	err = mlx5_vdpa_create_mr(mvdev, &mvdev->mr, iotlb);
-	if (err)
-		goto err_mr;
+
+	mlx5_vdpa_update_mr(mvdev, new_mr, asid);
 
 	if (!(mvdev->status & VIRTIO_CONFIG_S_DRIVER_OK) || mvdev->suspended)
-		goto err_mr;
+		return 0;
 
 	restore_channels_info(ndev);
 	err = setup_driver(mvdev);
-	if (err)
-		goto err_setup;
-
-	return 0;
 
-err_setup:
-	mlx5_vdpa_destroy_mr(mvdev, &mvdev->mr);
-err_mr:
 	return err;
 }
 
@@ -2875,26 +2866,40 @@ static u32 mlx5_vdpa_get_generation(struct vdpa_device *vdev)
 static int set_map_data(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 			unsigned int asid)
 {
-	bool change_map;
+	struct mlx5_vdpa_mr *new_mr;
 	int err;
 
 	if (mvdev->group2asid[MLX5_VDPA_DATAVQ_GROUP] != asid)
 		goto end;
 
-	err = mlx5_vdpa_handle_set_map(mvdev, iotlb, &change_map, asid);
-	if (err) {
-		mlx5_vdpa_warn(mvdev, "set map failed(%d)\n", err);
-		return err;
+	if (vhost_iotlb_itree_first(iotlb, 0, U64_MAX)) {
+		new_mr = mlx5_vdpa_create_mr(mvdev, iotlb);
+		if (IS_ERR(new_mr)) {
+			err = PTR_ERR(new_mr);
+			mlx5_vdpa_warn(mvdev, "create map failed(%d)\n", err);
+			return err;
+		}
+	} else {
+		/* Empty iotlbs don't have an mr but will clear the previous mr. */
+		new_mr = NULL;
 	}
 
-	if (change_map) {
-		err = mlx5_vdpa_change_map(mvdev, iotlb, asid);
-		if (err)
-			return err;
+	if (!mvdev->mr) {
+		mlx5_vdpa_update_mr(mvdev, new_mr, asid);
+	} else {
+		err = mlx5_vdpa_change_map(mvdev, new_mr, asid);
+		if (err) {
+			mlx5_vdpa_warn(mvdev, "change map failed(%d)\n", err);
+			goto out_err;
+		}
 	}
 
 end:
 	return mlx5_vdpa_update_cvq_iotlb(mvdev, iotlb, asid);
+
+out_err:
+	mlx5_vdpa_destroy_mr(mvdev, new_mr);
+	return err;
 }
 
 static int mlx5_vdpa_set_map(struct vdpa_device *vdev, unsigned int asid,
-- 
2.41.0

