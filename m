Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D2D7BD9A7
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 13:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346265AbjJILZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 07:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346357AbjJILZ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 07:25:28 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2074.outbound.protection.outlook.com [40.107.220.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4933B11C;
        Mon,  9 Oct 2023 04:25:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iYb0bmiZCZWRv3iAcPVEflNhhGrwZ1OjGEbafYUYZGe1r5QPmUl7s1ieSejjlEx9A21iTTZ0FW4vvs32p+pX0pxdZ3VQHWa/y4+3+v16zEbbalWnLHyXDkzeIqd7FEBcrFLNGyiyt9LYMNms54bf977SXArkZeWxDzLDwbUa68Uj6esNrL0+dGcazZfjMZC9J9dHnf1br7GHlxqJCY9UWQWjdTfOfFuqC9+aKG53lQYchGEcFSsAUnZITON/M9Kq6TG9KYCuaB5zjSsThUkDorGegXx9EgjInLl6s00NRtzB6brcrLuytQwjb/sxYhyRzEVvhkaVnoakfmJA6XMzOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7jjiNTy8al6/zLsHEFtY10NWCOwo4c2oncU7C5mb/4Q=;
 b=Yvjvla3Jb8OsDg3bLGAklqiXxW9k0eK/Q37CRRJyiTwGk2ArSDBHq2IAvWpOrpxtVmmPFD4eEvlPNs2nSA+FSwK182sqKUilKKn2/QAgNe11Dpq6hp09R4E7BUY5nCbv6uoceGYg5kLYtyrrGx3Li4Cp4RACP7+zDbXxvyyHbEFtN9VV//5rPlnZ2dPfRyMuFfwlFuXbnGxIHVQvCYPLRRdZ3Cowf6RNmWTfl6CkUwirdVPHze/fwjVHTSrpCU+8wBq8Gn3yh1BwnUWUpnWUMFijEKXF0wI7gUlG/rGTA4g3cN7T4YDA/fZm8GZ9sLo/SW7mXqpvkK//RFCAit3z6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7jjiNTy8al6/zLsHEFtY10NWCOwo4c2oncU7C5mb/4Q=;
 b=OiP1unnFlgWkvBiyDlDeLDTLgXoejKcu+yxEyuKg5jjpPdqAQsQxsAguNE8UxUTkXqqEb5acBC+pdORadsT5+aqm0L4/bulka+dfcanqPy8N0HkgQWebPl3GLRswvoStAcd3b6DLn4EOsN1B9o14X6nkY2L+XXoW9K2x2+wR7KTqYRjOoN89kRmWjMYk45WzkWMRDHFSWF7CTQrjT4IA1pSOPjxAYOIkn7u0vFfERQUsYUKbeBy8vOBizdrMVB+hPN90oBVRXzJD9qWkD3kZykDgqx7yMLIAvJybqvRnrdsral8SZo7WxX76dstMtAuYb7iz6ctOV3DvcCnkfqFZOw==
Received: from MN2PR13CA0024.namprd13.prod.outlook.com (2603:10b6:208:160::37)
 by LV2PR12MB5920.namprd12.prod.outlook.com (2603:10b6:408:172::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.41; Mon, 9 Oct
 2023 11:25:15 +0000
Received: from MN1PEPF0000ECD6.namprd02.prod.outlook.com
 (2603:10b6:208:160:cafe::7f) by MN2PR13CA0024.outlook.office365.com
 (2603:10b6:208:160::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.21 via Frontend
 Transport; Mon, 9 Oct 2023 11:25:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000ECD6.mail.protection.outlook.com (10.167.242.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.14 via Frontend Transport; Mon, 9 Oct 2023 11:25:15 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:25:02 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:25:01 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Mon, 9 Oct 2023 04:24:58 -0700
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
Subject: [PATCH vhost v3 12/16] vdpa/mlx5: Improve mr update flow
Date:   Mon, 9 Oct 2023 14:23:57 +0300
Message-ID: <20231009112401.1060447-13-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231009112401.1060447-1-dtatulea@nvidia.com>
References: <20231009112401.1060447-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD6:EE_|LV2PR12MB5920:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d5f6010-9dfb-4f39-beb7-08dbc8ba693c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l/ypnURB6iT7rw4XEPZ6fg+HgjfkVsC/D/Fcej266zdjTReOOtIWCN5MrlxzOzuwiORmzt4xubKTeGkNB5eC5yPO7Q86lNdEr9Kjvja+P6rFIFX3LTEbuqz4xs+OlU7rJ09vpQnF3qXUDv6BZPtSCRKXKTXJsurWkrAiHYWSWjudrJhbLNErIYVgxztatnfkNvrQ5jWpIgJgarDEPIx7MzzFzmidHXkqqBQ+Dg8cc5UpaHRmmNvz3pZmkaLyOMpn3psMxIKvWI6uD/WiCITOWkwnQKr/RDxwOv5osvlj2UZJSZKwtpPH4Z/QQL7nqHcZ4GvMa+wbQjc7wV5uB78Qc5c5QwxvwPqTG25baZALbhPlhN/VpQ315dUwu/WSF5eOo5k7WnoJkHGt7M56pwtmBl09na7bxobyorvJOXyWtTEmR0GZxmc5iA+0vSRZtSwmt3s5C0MR8U1ZkOR5dSRd3KP5oWnetH2ywIIHcvTMowwK0ZO9d+jXBPN7fI3X4385x9iE4y2tC3OsSkUFIIiCVOce4t4QyzTaVsRrk/GdPvEDKZoY22BYp/BVZ32WqVU8mryXQ11yrb6Lkrv2+7PebE43xFJUHBFFBNzvEjze7VjdW6/gkBlWO/Qnuo5y4e5eFULU1bA7Wv3197xwbrs1Hj6JOyEAgPZlhZJsUs3fPqSSU49vko1Pb9vC3kfJ7VxN/kMRpletiWeVwm8ZZwJqNcaMLrG4QZi9QvAceiMmY0Y=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(346002)(39860400002)(376002)(230922051799003)(186009)(451199024)(64100799003)(82310400011)(1800799009)(46966006)(36840700001)(356005)(86362001)(7636003)(36756003)(2906002)(41300700001)(15650500001)(8676002)(5660300002)(8936002)(40480700001)(478600001)(4326008)(1076003)(2616005)(83380400001)(70586007)(70206006)(316002)(82740400003)(110136005)(336012)(426003)(36860700001)(26005)(66574015)(54906003)(47076005)(334744004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2023 11:25:15.6086
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d5f6010-9dfb-4f39-beb7-08dbc8ba693c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: MN1PEPF0000ECD6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5920
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
any). The old mr will be deleted and unlinked from mvdev.

This change paves the way for adding mrs for different ASIDs.

The initialized bool is no longer needed as mr is now a pointer in the
mlx5_vdpa_dev struct which will be NULL when not initialized.

Acked-by: Eugenio Pérez <eperezma@redhat.com>
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
index 256fdd80c321..4a87f9119fca 100644
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

