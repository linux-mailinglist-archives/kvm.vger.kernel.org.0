Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB86B7BD9AB
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 13:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346409AbjJIL0P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 07:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346349AbjJILZl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 07:25:41 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220D5193;
        Mon,  9 Oct 2023 04:25:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=naH19dQcnCle6ulZ4d2QyNUs+cNBX9gqqt+bAkV8WQaqHol8mJKRryGEkIKJe3TK9MpZJ64p5UvE7lKbpVev04ZevOMWv4V2tLDPeaSJD8udXbKuPGJ6sSxaasAToDAEllXZV+Xza9qeugL8/owp/kv0cq81qtS/5ZnPu4UPYbdlrTqurpLSj0u5CrmIKjN7dd1yPRxBcbUkTjW3vzV57FNvUjaZo0OjczGHU0XwE81pGRqUpElsx9m5hLsfTLu+bQn2z2Ps/13qh+f7ZQhMuXSQHokxS7JDzHutmEfbRiZtytZz5dicuSx5TMl/rMj9UrchkS77Y9IK+ILkaf7KcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+AGp+BRV0QlNoxWRv0zqkqDVrcRiRrwcHIbWi2U8fQ=;
 b=F3PH850YGaMja6A/jcLaYTxHzYmmMRXCC6ptnmhGzFYazt2S2th8JiwwM8gHQFl5Oj1lZNMah1cwldQEG6m+aog7h/x8kz0o5LHGDbjoDkfexvrhQ3OR/LsJNXGpJUqQwjKIdtzzu8qvavMCCVg/hNtHEO4xuzZam28m7GJG9QYYpkPfmqL6UhAI6P9tBKRPad2lVP7KVxzwCVs0hWaQPO1ZNTFb3Mxq6+W0bVs1ON43O8s9v5KEvUrYrQVMV7r3eo4xedCwA8wPpxYyG9joDWUvu8HeTfRgRRGYEuEEEM2GEwz/ywd4qjOJyeO8LSJKTnXIb47v7hkavIkOA5ZSzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+AGp+BRV0QlNoxWRv0zqkqDVrcRiRrwcHIbWi2U8fQ=;
 b=Y9/EU3kSvr6sy2hdJk/w1tSAZzeuUBCDb7997Ak2c+myC/cd9EKQ20kB6LHjYQHrIF/oHo7WJ6R/rokjqcdbQeN6Rn0wGlgQIHnacZlXSzD1mCewqwB7aZsJtZFv4mlNXayKEk9/zkjtOZgclnGOlCajcATQI8LgX8947h/guwv9kx24R3a3gbsBAtk5uHhpbWzYB8yIYWEyQT4m1X/iTEaLu9lG+BVGI1k38/BRX1VMYOPwUtdapBRnrgMxgc9Ze6XL7skqneuqWdgR6ii2wtsc5PbF9bZGevNvvbZ5+M7JyuGdAa5YGxfhl0omjf36r9G2+s3TvD2o8T0/obJTrw==
Received: from MN2PR08CA0023.namprd08.prod.outlook.com (2603:10b6:208:239::28)
 by CY8PR12MB7268.namprd12.prod.outlook.com (2603:10b6:930:54::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.30; Mon, 9 Oct
 2023 11:25:22 +0000
Received: from MN1PEPF0000ECD4.namprd02.prod.outlook.com
 (2603:10b6:208:239:cafe::de) by MN2PR08CA0023.outlook.office365.com
 (2603:10b6:208:239::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36 via Frontend
 Transport; Mon, 9 Oct 2023 11:25:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000ECD4.mail.protection.outlook.com (10.167.242.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.14 via Frontend Transport; Mon, 9 Oct 2023 11:25:22 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:25:05 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:25:05 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Mon, 9 Oct 2023 04:25:02 -0700
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
Subject: [PATCH vhost v3 13/16] vdpa/mlx5: Introduce mr for vq descriptor
Date:   Mon, 9 Oct 2023 14:23:58 +0300
Message-ID: <20231009112401.1060447-14-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231009112401.1060447-1-dtatulea@nvidia.com>
References: <20231009112401.1060447-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD4:EE_|CY8PR12MB7268:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e40eb4e-7e37-40a0-9f6b-08dbc8ba6d5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8XC0a6D6orSTMY5p3vwAK/IhqDoAlmPn58AIaGTuHwEp1PynjFWAtvgpFyTxffI3cJzj9X3uJG60uCj67HTczzuCOSoaUxsdlxT/4Ir3WFLEsngYfh7+ZDGMXmu7RLXfXP/XuRf8gVr5znu3FGkd19+r4OlXE7pGmy1btS7AvKtsmw1fS3anOu0k5wVIofcUcccMq2Q1HC+idXLT6CucJuPOKJb4TrEN4/3otcEIJfchJeAiihCvpp2LF4jnKraols12LczlLHomi7T8cMfXjy2ZFUaFcSd00nA0wirDgppcMOXWxtzLjtDulybbkqY/85EsD2RQcLSjUISPEoArULg6asNsMLSCkDtwnLy+F1bw0yUp648bifWbGvxTFIx658Jpjy9KLHHWwXfeH7jEpe+LLyK53JdWrL35HKia843xT439rZpy/4RiDCzdpAPIq4RzLYPpHsrz0m6FliATJXK+ece6Cgx0Y1WdzxHR9Z3xl2l3biZJobpQyFEGXqLhBR45muolx/Q4DlIvO536OdooZSgwtrVJLKaRdn1sLkCmCaa4OYiMj2uQIzaaOp8fEdnvA+FE4xyDNrHwlt8j6UDj4EWCGS0jL2v8/LO5scwqFJ1OKxgbhEij/trcTi1UqdRRjuG5mqo9xA6Y94zSsfkZFTe6qm83Ys7t7ZrleuACoptZe4ni98F/AY8q7TiDZlQ8oixKPh+D2c0zoXc7ePaYXBoN2srpE818F0kwnVE=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(396003)(346002)(136003)(230922051799003)(451199024)(82310400011)(1800799009)(186009)(64100799003)(46966006)(40470700004)(36840700001)(40460700003)(40480700001)(82740400003)(2616005)(7636003)(356005)(26005)(1076003)(336012)(426003)(66574015)(110136005)(54906003)(70206006)(70586007)(6666004)(478600001)(47076005)(36860700001)(83380400001)(86362001)(36756003)(8936002)(8676002)(2906002)(4326008)(5660300002)(316002)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2023 11:25:22.5284
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e40eb4e-7e37-40a0-9f6b-08dbc8ba6d5c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: MN1PEPF0000ECD4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7268
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce the vq descriptor group and mr per ASID. Until now
.set_map on ASID 1 was only updating the cvq iotlb. From now on it also
creates a mkey for it. The current patch doesn't use it but follow-up
patches will add hardware support for mapping the vq descriptors.

Acked-by: Eugenio Pérez <eperezma@redhat.com>
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
index 4a87f9119fca..25bd2c324f5b 100644
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

