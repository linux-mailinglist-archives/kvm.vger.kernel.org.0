Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9057CE439
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 19:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbjJRRRh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 13:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235252AbjJRRRE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 13:17:04 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFFE1A2;
        Wed, 18 Oct 2023 10:16:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VpRj7sFrdqTJF2zTAcRS2tugm6DZx6p7nxYr3PlHDgfX0eoiiNc1o4QYowH3HqaygueV/Szx/J/6bADTqfXpSMkz1+XcgSzeeF9kVOreQe9ldyP9cZ4tdwZIAUgSA+57072/ftT26IDL3Hvtl5N/YbEmr67VJlC3W2D+DYqp2zCZY9dl+jFPdqVvkFaf5aeEnREnKrFpqx2t8xQrlR5z5ZjC8oc0Hdz5o5cUmW/f8jyAFFirazbvyxbJg7NIs5gr8NVKBNo/T6Y03RaGGw405vl6St0t6FKxec3SorkLSo38duw9wSfH9JPDuQARkd/JJ0LWqcqL/vhTk/BGJV0nFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g/riwkRSoi1nVotT7iLhK2hAguH78ZBh8oaLsGcPRlY=;
 b=ktq4HaNCBVPcivo0+Q9ccTnfFQ0QOr/k9PbElV1KdpYRUQKV+Z6lC8osSxN/gjZF/1lZcBYXoB6SGVspgK9oKbLiQcRFf8eM51t0myeo3u1Rc2C0CFrdMVgidmp/h+tcHj+X1rU395h4kZjvEgJrwMK4x/tAoiC4X/h3eWwkG/u0Q3ydmDq+A2h0fP3/Rd+jEPU5eBuvWFRay1MZFyHiW9S8r+U4+lCa4O4ao4hnuSlEjZVlPSmGMfvoM18CX8ZTD89N2Cus28jQDtP4f8QSXpexSD5zOmMMX8dLPbWUzcKEgKEkxuoDrSRcdQvb8Kg27JhjvGaQ5xvOUTFNgxw44Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/riwkRSoi1nVotT7iLhK2hAguH78ZBh8oaLsGcPRlY=;
 b=Bp4AuE4Ixc4c8pHb2s38uxHpa7yRmGloy97Wrzb23CjJEsa26gdLKZofy7EWGyKoFfazyRExlSyA/VC2HWo/n7q0MxnDTsb2hW+QQmB+z0OmktY/MFqFB1a/1wmSnsHoVbMh7OWZ6ZLiGSTsu/A0EpRYur6P7NVKEUssWNrMCRvTzdotDW6PsrXXyWiFKlW/rkam3jTZUo5mNezRktoYM0G7Vgv3J/NhvqNvps/cOS9TZ7YjFsYo3UZjY+kTrc7XfY5kOWJNk1zylItMc/OYmgfkEKWW1a9wfDfM6KUmNP/jVc7PuHU17LhY2oncFoC2hLC/O89HUV6QerDd/g8xEA==
Received: from CY5P221CA0143.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:6a::13)
 by SA0PR12MB4527.namprd12.prod.outlook.com (2603:10b6:806:73::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Wed, 18 Oct
 2023 17:16:26 +0000
Received: from CY4PEPF0000FCBF.namprd03.prod.outlook.com
 (2603:10b6:930:6a:cafe::bb) by CY5P221CA0143.outlook.office365.com
 (2603:10b6:930:6a::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35 via Frontend
 Transport; Wed, 18 Oct 2023 17:16:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000FCBF.mail.protection.outlook.com (10.167.242.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.23 via Frontend Transport; Wed, 18 Oct 2023 17:16:25 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:16:12 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:16:12 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Wed, 18 Oct 2023 10:16:09 -0700
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
Subject: [PATCH vhost v4 13/16] vdpa/mlx5: Introduce mr for vq descriptor
Date:   Wed, 18 Oct 2023 20:14:52 +0300
Message-ID: <20231018171456.1624030-15-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231018171456.1624030-2-dtatulea@nvidia.com>
References: <20231018171456.1624030-2-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCBF:EE_|SA0PR12MB4527:EE_
X-MS-Office365-Filtering-Correlation-Id: cd83ee9a-e141-43fa-95b0-08dbcffdf5bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KcKMgssP9vdVKuyhJMCqPmzmE3aNah2+q5ca8h0ifg3WWRaXJPAujkOAEndDlYZKotHAjQwotDxcFWc6Xf8AQbHckJi//p2fd7GEZfy1OuixDoC7iq1RhpX63WY9fCp7YHidIOIMY6/kB6H0QnYEQPPha63naQmMAbw8/YNy3QFSpaah4aGFyW2yAJPUgJTNVotSQwAsgxzDBSYLv1ZI7BDqCjD+VdzUlYAP5vbMBv8Cum9U5n/eQuvOAgKzHv48pAEA8+mK9cTpbXgGeZBZic7KhLqZP5/iuF2fmyjX4o/TcGYdIjU+gAGfi8QDOB6nPL2mMG6kz1cxRaM++MoKhfdhq8m73favLjB/wQ+oOrQTV2SpRk7Kem/CZtrB70WVtPqwWMAD1FyrsqonK6wSeZMabpUGxte/cdhGLMrBuBQvWi5rVFpqXms/nbM2wVm2rYv0mizshfQl4hbxrwyUO5ufQn1sOZ1jUJHyCjFPU7DouoiaT37a6HQ1dt0K0tKcd2HrQ8QecXBIAaR0W+K7u7vj1tQIxeRq47vWNvtvKtr7hoYzOfn9JcRo3zLhAK5edvISQ+gsP9oYWYpKCA5nAlP2YTrPNXG9O5ah+KoXjEK50MMv4NZAkX0Luw0V4aLPioYbC2H5+rEc2qsHZIogdkEznGFBmWbqrzVbe3Eu+qPfqkf3IOLel+tbGtbKkFnCJXXvg2K2waeiEZrdu5Nmle5g6grVogYbNNSkq2iGKgg=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(39860400002)(136003)(396003)(230922051799003)(451199024)(1800799009)(82310400011)(186009)(64100799003)(36840700001)(40470700004)(46966006)(40460700003)(1076003)(26005)(6666004)(426003)(4326008)(2616005)(83380400001)(336012)(36860700001)(66574015)(8936002)(8676002)(316002)(5660300002)(47076005)(41300700001)(2906002)(478600001)(82740400003)(110136005)(70206006)(54906003)(70586007)(86362001)(7636003)(356005)(36756003)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 17:16:25.7881
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd83ee9a-e141-43fa-95b0-08dbcffdf5bb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000FCBF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4527
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

Acked-by: Jason Wang <jasowang@redhat.com>
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
index 7b878995b6aa..ea76c0b4b78e 100644
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
 
 	if (vhost_iotlb_itree_first(iotlb, 0, U64_MAX)) {
 		new_mr = mlx5_vdpa_create_mr(mvdev, iotlb);
@@ -2884,7 +2891,7 @@ static int set_map_data(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 		new_mr = NULL;
 	}
 
-	if (!mvdev->mr) {
+	if (!mvdev->mr[asid]) {
 		mlx5_vdpa_update_mr(mvdev, new_mr, asid);
 	} else {
 		err = mlx5_vdpa_change_map(mvdev, new_mr, asid);
@@ -2894,7 +2901,6 @@ static int set_map_data(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 		}
 	}
 
-end:
 	return mlx5_vdpa_update_cvq_iotlb(mvdev, iotlb, asid);
 
 out_err:
-- 
2.41.0

