Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7571B79D1B3
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 15:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235595AbjILNDw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 09:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235542AbjILNDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 09:03:21 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2082.outbound.protection.outlook.com [40.107.94.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2722698;
        Tue, 12 Sep 2023 06:02:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CjooBXdntTser4g89kS6hPhazYTSIVB7qid/Ff70nLbnC7vE5j9lz3pvVvrgyfcGIvbGnDY5QoMIH0zClMtbi0iWnbd6EV62ByGWQM9EUeEhf78+ZSg26LL/TrzLUuQiYuSQwm9vjGyZeaij0IVKw9mbmBXUC9FkP5i7g/5VGFbGczvQ8b2tcwXJst6oTaX6Ll7OrmDkBzJkXgfYv8texbVs2pmiE4UV+T8flZwJNR7ARDD6L5ER35RK/ZkbwNrtYh9u/4KwA5V1v8FOVYXg6vCaQcR1IoQRxZmYGVc9oKPj8MqI5uwi0fM+lla+7rZcXcjLLsoaiKLUlP8u0qDpgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3xNCgK7QPLEM0uUQZq7t9QWVxx9aTd3m7LPaUOlLG+M=;
 b=f378gNNcrP7AU1x9ykYjkbCfUtP/8ofVe/QbHkTsHZ0rB/dUmOvPbWVN+Bb7m3tK0ThELTDtpecYx6xTdNNh/DXCZzQd3A3TyMDGtu9d3WLsQfkyhjbMmIgSwXpPX/5mlkz+RrYyYv0jFaISEFjQWFRrZOENMyyYJ598Ka0PaRw3gLgeWJlDTDQpa2XhJ81Y6QAVYIqdxysCLLWkSo9JfZ18Xpr4U247rt1JiKNDpaidJo7y98kKekA4WTLq3CRyV60sQEtRPyltcaaeEvyoD146cGAukmTo0JkiGj/iZ5TMQHo0Gk4Gq5aDsKFNshBHFYyoXY3Rg2uxc8jLvFyEiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3xNCgK7QPLEM0uUQZq7t9QWVxx9aTd3m7LPaUOlLG+M=;
 b=aigOziG6jKdc6U5ov6kZta5JpPfMY6/I0IzV/CxnefQ2HodjW6ef9QWj5Cqk1t/M6E3HYO6CwW0zpPc7ftgTPUHmykF+0UMsT1PjM/8fm/Jg/R6Y9xxDt+4+SLIBEQBJVX2+I9MwIevQVzOTXNWqnTQ18cr9y+YdrCPbGfprH+Q+X6gsavcvKSIF4XylTj3Yyv2eZSlSi6LMxd8PUM12mmtYlibqEHcbBs1HU2+CvJlBaMLWClZs17Bzyk6UdsMbIVD9WeTfnxAnTew5KC+9V/scjmsPgjQKbieIujA0kVX6oxlUu5UvIkW3RfIJ6DWoUH9DObXHHY6J92mCvHnc8Q==
Received: from DM6PR02CA0152.namprd02.prod.outlook.com (2603:10b6:5:332::19)
 by IA1PR12MB7518.namprd12.prod.outlook.com (2603:10b6:208:419::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.35; Tue, 12 Sep
 2023 13:02:42 +0000
Received: from CY4PEPF0000E9D7.namprd05.prod.outlook.com
 (2603:10b6:5:332:cafe::8f) by DM6PR02CA0152.outlook.office365.com
 (2603:10b6:5:332::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.19 via Frontend
 Transport; Tue, 12 Sep 2023 13:02:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9D7.mail.protection.outlook.com (10.167.241.78) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.11 via Frontend Transport; Tue, 12 Sep 2023 13:02:41 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 12 Sep 2023
 06:02:26 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 12 Sep
 2023 06:02:25 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.37 via
 Frontend Transport; Tue, 12 Sep 2023 06:02:22 -0700
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
Subject: [PATCH 12/16] vdpa/mlx5: Introduce mr for vq descriptor
Date:   Tue, 12 Sep 2023 16:01:22 +0300
Message-ID: <20230912130132.561193-13-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912130132.561193-1-dtatulea@nvidia.com>
References: <20230912130132.561193-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D7:EE_|IA1PR12MB7518:EE_
X-MS-Office365-Filtering-Correlation-Id: 57883ed3-39c8-4477-bda1-08dbb3908cae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B1YuqfmJcnZQZbcDLJ2hrMaucoIIq1pBmFZDEaoahJBbNjOT+FSSki7VUcBRyz5Uoscfghc9FTxvBvi5k244p4YuzNuQMfLBtSb8IxE1N58kCkleVO7C5b6kRVQrQML+vbOKhcx+JymtOvRRPSRRAyMuyuNQhnEofzLg3qWyjowvYm5AAgBzifAkVwcsnH8EIrDCfMKOGsliAwW5nCSVST76JBRCXccImN07jYoIO39a41inulY7q/gOBlZ1fmk8CqeniYMZcDahyX1nr7xbjfs6qwk6ttANe1XvA/EFa9mlYQqIL9mokZxFzODiX+OmR0Ld+SLE0ztDLMRYhgeX1ZsbIkSMfSV3/KvgeuaVNlsoTtg4Ha05zpmXPXD2Tiqi3pF0zLseGtVVm8prcWRkScwLCz9DLbM9h86Ohxy2vWL+xQ4OIf6OU41LOxSeVHk5KLTO1Mmk0+pH6FWhqBiloTteMOL+VRvY46oSk7hSDX2ZHMdqUFzJHdTFHGjqbWF2oCh3XvW4v1L86gT3F55pJrHrm2CjBRyXEFvSfuFUu6KtrsIAiJI0yWt7r7Dx0bckagXT8DcCFJUKaF+O7/8v709UEunGLv6GUineqZwNrgco42eSD2NdaS5DfZ+1Mza/C/I7nWz2NQoavnOEqaHzTKAa6JOKhhlunFTG8I2GRW01IgBBo/4YOV+yC+zSd/Mm6Kbpovtxs/2T26lu0b0hf0ia5XsyBdmYI1/zSs5GCmI=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(39860400002)(136003)(396003)(82310400011)(451199024)(186009)(1800799009)(36840700001)(46966006)(40470700004)(7636003)(41300700001)(26005)(40480700001)(40460700003)(82740400003)(356005)(86362001)(36756003)(36860700001)(1076003)(2616005)(336012)(2906002)(83380400001)(478600001)(47076005)(426003)(8676002)(5660300002)(4326008)(8936002)(316002)(70586007)(110136005)(70206006)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 13:02:41.7794
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57883ed3-39c8-4477-bda1-08dbb3908cae
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7518
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce the vq descriptor group and ASID 1. Until now .set_map on ASID
1 was only updating the cvq iotlb. From now on it also creates a mkey
for it. The current patch doesn't use it but follow-up patches will
add hardware support for mapping the vq descriptors.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  5 +++--
 drivers/vdpa/mlx5/core/mr.c        | 14 +++++++++-----
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 20 +++++++++++++-------
 3 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index bbe4335106bd..ae09296f4270 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -70,11 +70,12 @@ struct mlx5_vdpa_wq_ent {
 enum {
 	MLX5_VDPA_DATAVQ_GROUP,
 	MLX5_VDPA_CVQ_GROUP,
+	MLX5_VDPA_DATAVQ_DESC_GROUP,
 	MLX5_VDPA_NUMVQ_GROUPS
 };
 
 enum {
-	MLX5_VDPA_NUM_AS = MLX5_VDPA_NUMVQ_GROUPS
+	MLX5_VDPA_NUM_AS = 2
 };
 
 struct mlx5_vdpa_dev {
@@ -89,7 +90,7 @@ struct mlx5_vdpa_dev {
 	u16 max_idx;
 	u32 generation;
 
-	struct mlx5_vdpa_mr *mr;
+	struct mlx5_vdpa_mr *mr[MLX5_VDPA_NUM_AS];
 	/* serialize mr access */
 	struct mutex mr_mtx;
 	struct mlx5_control_vq cvq;
diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 00eff5a07152..3dee6d9bed6b 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -511,8 +511,10 @@ void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev,
 
 	_mlx5_vdpa_destroy_mr(mvdev, mr);
 
-	if (mvdev->mr == mr)
-		mvdev->mr = NULL;
+	for (int i = 0; i < MLX5_VDPA_NUM_AS; i++) {
+		if (mvdev->mr[i] == mr)
+			mvdev->mr[i] = NULL;
+	}
 
 	mutex_unlock(&mvdev->mr_mtx);
 
@@ -523,11 +525,11 @@ void mlx5_vdpa_update_mr(struct mlx5_vdpa_dev *mvdev,
 			 struct mlx5_vdpa_mr *new_mr,
 			 unsigned int asid)
 {
-	struct mlx5_vdpa_mr *old_mr = mvdev->mr;
+	struct mlx5_vdpa_mr *old_mr = mvdev->mr[asid];
 
 	mutex_lock(&mvdev->mr_mtx);
 
-	mvdev->mr = new_mr;
+	mvdev->mr[asid] = new_mr;
 	if (old_mr) {
 		_mlx5_vdpa_destroy_mr(mvdev, old_mr);
 		kfree(old_mr);
@@ -539,7 +541,9 @@ void mlx5_vdpa_update_mr(struct mlx5_vdpa_dev *mvdev,
 
 void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
 {
-	mlx5_vdpa_destroy_mr(mvdev, mvdev->mr);
+	for (int i = 0; i < MLX5_VDPA_NUM_AS; i++)
+		mlx5_vdpa_destroy_mr(mvdev, mvdev->mr[i]);
+
 	prune_iotlb(mvdev);
 }
 
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 376581f4a750..5bb9a7528b08 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -821,6 +821,8 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_virtio_net_q_in);
 	u32 out[MLX5_ST_SZ_DW(create_virtio_net_q_out)] = {};
+	struct mlx5_vdpa_dev *mvdev = &ndev->mvdev;
+	struct mlx5_vdpa_mr *vq_mr;
 	void *obj_context;
 	u16 mlx_features;
 	void *cmd_hdr;
@@ -873,7 +875,9 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
 	MLX5_SET64(virtio_q, vq_ctx, desc_addr, mvq->desc_addr);
 	MLX5_SET64(virtio_q, vq_ctx, used_addr, mvq->device_addr);
 	MLX5_SET64(virtio_q, vq_ctx, available_addr, mvq->driver_addr);
-	MLX5_SET(virtio_q, vq_ctx, virtio_q_mkey, ndev->mvdev.mr->mkey);
+	vq_mr = mvdev->mr[mvdev->group2asid[MLX5_VDPA_DATAVQ_GROUP]];
+	if (vq_mr)
+		MLX5_SET(virtio_q, vq_ctx, virtio_q_mkey, vq_mr->mkey);
 	MLX5_SET(virtio_q, vq_ctx, umem_1_id, mvq->umem1.id);
 	MLX5_SET(virtio_q, vq_ctx, umem_1_size, mvq->umem1.size);
 	MLX5_SET(virtio_q, vq_ctx, umem_2_id, mvq->umem2.id);
@@ -2633,7 +2637,8 @@ static void restore_channels_info(struct mlx5_vdpa_net *ndev)
 }
 
 static int mlx5_vdpa_change_map(struct mlx5_vdpa_dev *mvdev,
-				struct mlx5_vdpa_mr *new_mr, unsigned int asid)
+				struct mlx5_vdpa_mr *new_mr,
+				unsigned int asid)
 {
 	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
 	int err;
@@ -2652,8 +2657,10 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_dev *mvdev,
 
 	restore_channels_info(ndev);
 	err = setup_driver(mvdev);
+	if (err)
+		return err;
 
-	return err;
+	return 0;
 }
 
 /* reslock must be held for this function */
@@ -2869,8 +2876,8 @@ static int set_map_data(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 	struct mlx5_vdpa_mr *new_mr;
 	int err;
 
-	if (mvdev->group2asid[MLX5_VDPA_DATAVQ_GROUP] != asid)
-		goto end;
+	if (asid >= MLX5_VDPA_NUM_AS)
+		return -EINVAL;
 
 	new_mr = mlx5_vdpa_create_mr(mvdev, iotlb);
 	if (IS_ERR(new_mr)) {
@@ -2879,7 +2886,7 @@ static int set_map_data(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 		return err;
 	}
 
-	if (!mvdev->mr) {
+	if (!mvdev->mr[asid]) {
 		mlx5_vdpa_update_mr(mvdev, new_mr, asid);
 	} else {
 		err = mlx5_vdpa_change_map(mvdev, new_mr, asid);
@@ -2889,7 +2896,6 @@ static int set_map_data(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 		}
 	}
 
-end:
 	return mlx5_vdpa_update_cvq_iotlb(mvdev, iotlb, asid);
 
 out_err:
-- 
2.41.0

