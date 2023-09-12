Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B9E79D1B0
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 15:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbjILNDf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 09:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235641AbjILNC6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 09:02:58 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E345B212A;
        Tue, 12 Sep 2023 06:02:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kvFUvkCbpvMOgFWRPmdNB+JamoVj2EocbzalPtQLeApPXflPKIhTiSFIvRuxQZOOxZ30HlYRNKZqawRagmKasbsYxDW0RNp9X+4AlNkbc/tCv6hU1nOvl9VciQ9Ve04nolIRbbrQTIcJhhvuvAqpnBB2ARGjvJCxBvzqhwh0xuUol0RTx79KLU4Kof1GCQuQhADoGy91BvzHHYuHWvEk4qHxYh43IL8lsFj1nd6GSBjFqUV6nKdCZAQDIhYupy+mHtspDg5A+uTEano9In3qK0/Pm3SQFgRJGuKSdwwSUfTKRu+mtx8mamouBEKprAwIcWP0KERcpEspTdNMM7VCKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fXRIT8ryr5kBPFME5qPj62np+gmzhtOb4SnWhboQOGA=;
 b=QJ4cXXZ9MF4U2M9rCm+vtTDXfkW+bVOtvb4AQ8y/LVFCPaqckukDo5p9BCB4NUzPv6fQ4ScESxbQdB47FVYkPi0aTWNykApsZnudW1SlRPYbOFVXvHmJy8x3nIjZKe3GFhHPgNQuYvBWGE6qkWcsH2QSUbo3+qh6Zbe8IKAY1tmb3wwczJHvvuY4HbfdiDgnZCBodBzML+PNiayg79zJpTKcxat4oYwXl0l5bz+NejwLE7CL1pxnd1N7A7riAzyZEFx/2Aty1i2m9IlgIBfiBEiUzdKeZo7ngkM+rCZ7ojAnCci8PWlQy/G+oaTTAfvxsPySoN13u4wCDplhgxSFAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXRIT8ryr5kBPFME5qPj62np+gmzhtOb4SnWhboQOGA=;
 b=cLoHyntDUICAfBnC6Bh+NzuZDnkOxNINQza+xMNTz2MpJmc821YbSiYBTLoCrdDWfJjXfaABGc8TAdiC71Z0WlWrdWAScnQ3zZFgU/DQ8WZrbK6kO7yBG31VDArm86qnRqkLEdLamenLRz8lODO2z5zEwiB5EV0i5iM7TBky8WPTCtIW7HXLQZWBzzzFzcHU+jlXkwIYl8KRIsWQpcZrP8i3bMxHJE0/QdZeSEw3bllEYSUhLHse4dPWYS6OZaZuln1982Qz06cvMbuFp8uEu9+dAO0bpxsH/Z3DFcOUO5uklZD5YC/DZ/hlUis/lOh+xYCTdYx7VTpPrQAJKkIyUw==
Received: from CY5PR22CA0073.namprd22.prod.outlook.com (2603:10b6:930:80::21)
 by SA1PR12MB5614.namprd12.prod.outlook.com (2603:10b6:806:228::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 12 Sep
 2023 13:02:33 +0000
Received: from CY4PEPF0000E9D6.namprd05.prod.outlook.com
 (2603:10b6:930:80:cafe::ce) by CY5PR22CA0073.outlook.office365.com
 (2603:10b6:930:80::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.19 via Frontend
 Transport; Tue, 12 Sep 2023 13:02:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9D6.mail.protection.outlook.com (10.167.241.80) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.17 via Frontend Transport; Tue, 12 Sep 2023 13:02:33 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 12 Sep 2023
 06:02:22 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 12 Sep
 2023 06:02:22 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.37 via
 Frontend Transport; Tue, 12 Sep 2023 06:02:19 -0700
From:   Dragos Tatulea <dtatulea@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     Dragos Tatulea <dtatulea@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, <kvm@vger.kernel.org>
Subject: [PATCH 11/16] vdpa/mlx5: Improve mr update flow
Date:   Tue, 12 Sep 2023 16:01:21 +0300
Message-ID: <20230912130132.561193-12-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912130132.561193-1-dtatulea@nvidia.com>
References: <20230912130132.561193-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D6:EE_|SA1PR12MB5614:EE_
X-MS-Office365-Filtering-Correlation-Id: cae35a76-a799-479b-2283-08dbb39087bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0qhYQpHjrJOrEWhVG54uGvLNjuFRnoE2HKWgKBHipMj78ET9Ww/X2sk04CAIIsKe7i/Jj1LpPJAWxoJuGZKwccXgmp6XgtyYc4EOcswsv+rgQuEhCx4G7TghCpk94yICC3IQf8bYOxqYgD12vBjRh8bDwK+SnpBUtY+hEcPzKp03uZW017Bo/CJ9qwqgA9JOh2KQDN41LAXQOd5jTVURtBynt+fThgoov4E3lhVbhOw3aLOwxamsql63KbcLDo6PCbDYAQIXL/fB7aCIypch2UK3wwyiNQQUfTWRp0ZLbQRO+gwDQOLihyIKKCKCHbfnc3/5ROgMGHdWqpL3omQRUrwBGA7TN2VzYZuZ8CZQ0t11actArXEsdBavPNZi0EgMEJ8aLtAAADCc3Bf6fa0qbqTqHMATiQZ6e8R/v3C6vkz299CN9QZO2vd5jDIB023+i8ngoC/5Bj8hqrbxqIpDYDYZQ0TPdLzBa3MgCecNELLW1fAZ0C0YMdNlLTKDE23x8AU2tm+8AzKYYIIKh3i2h84351Wv5iDsW3yTwh2fmyQbywdKAK8HX+KSxilYYNGAVwuquE4LjYTG+qcid30uUS9SDMjpoC38ssGXLt6Uvx/7XhZT0PwmJkAGc+GqFi7pUXRYJ0bTNw0MkHdUkwmfawCsOaXOJotiR7SDRrYHS1Tttr5cZ4qMqbojKsRX/r2EqsEgc6/Cg3Y88BRZ7QGnRkHS7UKMkeKTX6yaujOsxo8l1nF0+kPUsqZ6jygk9G3nNDLv2JTPyaRLntBMvCq2sA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(396003)(136003)(346002)(1800799009)(186009)(82310400011)(451199024)(40470700004)(36840700001)(46966006)(356005)(6666004)(83380400001)(478600001)(336012)(1076003)(426003)(15650500001)(5660300002)(54906003)(41300700001)(316002)(4326008)(2906002)(8936002)(70586007)(70206006)(8676002)(2616005)(26005)(40460700003)(36860700001)(47076005)(36756003)(86362001)(40480700001)(82740400003)(110136005)(7636003)(334744004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 13:02:33.5476
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cae35a76-a799-479b-2283-08dbb39087bd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5614
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current flow for updating an mr works directly on mvdev->mr which
makes it cumbersome to handle multiple new mr structs.

This patch makes the flow more straightforward by having
mlx5_vdpa_create_mr return a new mr which will update the old mr (if
any). The old mr will be deleted and unlinked from mvdev.

This change paves the way for adding mrs for different ASIDs.

The initialized bool is no longer needed as mr is now a pointer in the
mlx5_vdpa_dev struct which will be NULL when not initialized.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h | 14 +++--
 drivers/vdpa/mlx5/core/mr.c        | 87 ++++++++++++++++--------------
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 46 ++++++++--------
 3 files changed, 76 insertions(+), 71 deletions(-)

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
index 4793b6a7ab54..376581f4a750 100644
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
 
@@ -2875,26 +2866,35 @@ static u32 mlx5_vdpa_get_generation(struct vdpa_device *vdev)
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
+	new_mr = mlx5_vdpa_create_mr(mvdev, iotlb);
+	if (IS_ERR(new_mr)) {
+		err = PTR_ERR(new_mr);
+		mlx5_vdpa_warn(mvdev, "create map failed(%d)\n", err);
 		return err;
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

