Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD8277CE449
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 19:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbjJRRRv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 13:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235102AbjJRRRY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 13:17:24 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8042C1712;
        Wed, 18 Oct 2023 10:16:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TriHVTKDVLVqL88fTAvEOlBpYHyt3QM49N/I5eKsADbOxRFPXXICUwACO4CQghKO89F0T9bipMWDJEQqWhgxRMDhCOy3yGdl6VXxn0XOiaHkNUqfFYWDKqW/2yFYjPxIWgfTJcLN4xoFwwEwHy1CngBDr8yc9WddEKVbvz/IhjVSzzhV0YcJqSpfwbC8yxYW34t5OkGtBGfymT7vs9hNFKMQ8pUtD3GlRjHZNloBHAI9vYSginQ+51thp9l5KiCmanoaQNIHXcGSADfBYKue2t8iwzl/iO8hhPIWMmANzJZy0+mw8AGjAg09cUr15RF7Zw2wLAB/Z85NM8ziw9Rc9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lN0j2IV51vKRPVldubdAaR1gNfbMIxY1heIdwiqqZ4o=;
 b=jFVngTogCTSvDo16HcOeQ3yzakNZtS2qeX3drtKdrek1YnlKDAM0Dp2k3Jd8ZzZC2j0iEuWs9oLwrVa8OJ9RZ4HDrfxp6uWwCOBA/DEQi1QIMr28bq+QVNRTf2X3TRHi1Qd5oMSilMtWWmXEBA98wDHmsVd9V5JtAbhzRqUNi8vS9VV220Olyo89vsH2xZh6c9YI6ciOGWMUOES985B2gMwSQeXAATa9X7/OlmnFGEwrwIa+ifJfHv492wbLLv4ZhT0D6KGelEN4EK/R3+cSjtVaPbCkHIlEhoE2RVnLZ+Ctb0VgLFOeDTaFhncSq+ba+FE5obzF7bSEmFiBP+689Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lN0j2IV51vKRPVldubdAaR1gNfbMIxY1heIdwiqqZ4o=;
 b=YkPBkZFthU2uBa1dKNAb0MUyGrxYyGVoY96v90Xiqz6wOG0jypmqjLbeKQlHPQDApuIDaZ2gnNgWc2g1pFkaDYJ7nqtgOuupjzZ9oLKnfWuiE9d5JKB29IG7v/PAZ16bY4SGBcj38SCGf1Lb9yfBcSsrtU9jo908x5wkVhM+3wFrFNs7zBUcfillycC28CokfEwRTxOvmgDdPLrresshcO4B2TUuc1Mj352Fwz1pXxknn6UhhMJBFJ7NxwV5JukQWFit/HqjSOqrVLcWne5Vnw7qKxQFLsjJXI5R283Edtbav2O3tTQAhPehAjLWqNduG5KIfvOFkiZ+DPVMqkbgaQ==
Received: from CH0P220CA0017.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:ef::34)
 by CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.44; Wed, 18 Oct
 2023 17:16:33 +0000
Received: from DS2PEPF00003446.namprd04.prod.outlook.com (2603:10b6:610:ef::4)
 by CH0P220CA0017.outlook.office365.com (2603:10b6:610:ef::34) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6886.37 via Frontend Transport; Wed, 18 Oct 2023 17:16:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS2PEPF00003446.mail.protection.outlook.com (10.167.17.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.20 via Frontend Transport; Wed, 18 Oct 2023 17:16:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:16:19 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:16:18 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Wed, 18 Oct 2023 10:16:16 -0700
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
Subject: [PATCH vhost v4 15/16] vdpa/mlx5: Make iotlb helper functions more generic
Date:   Wed, 18 Oct 2023 20:14:54 +0300
Message-ID: <20231018171456.1624030-17-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231018171456.1624030-2-dtatulea@nvidia.com>
References: <20231018171456.1624030-2-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003446:EE_|CH3PR12MB9194:EE_
X-MS-Office365-Filtering-Correlation-Id: 383acad4-aaed-419b-0348-08dbcffdfa4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 49+J5IwC7lVsKS+Wt2OrDxPUJrjPYTLrWiBxygjFa1qJvpTu3XzpnaK/+lWcB87TlmkPmu2iKUuxS0KmoeCnr/lC/4dYRHD+7TEAt5xceg/JJcbeEX2JQEPp71eIlrGluNp5CvA3jv+z4pTu4NtM6OFHMJ//Tm5W3dnwWxeGoWkbIFSNj2QcRsR+AEOPOlXyKef42FS96y8r8OYMe2HPJk2LF9yW8caHe1taY/V0vj2NYhJiV54Gcf03ZLXnuIiDe2061y7hhV5mbUaFlS9+CqnjN9+fklPvicm20sCZLzYdeqUVlPxm0mJ1w3HQcdTPhd0lVJahP5OVle9Ht7ZXvF6eZoSppM8nUUGEvZhEViD4xwTnwZRm5ilKgVpahGTCEhAuNE+ulNaEslmgPA8gNz3S4AX4I365lmwksvpOdMZeSoH+x238f9CE4Ya1Mcpmn+hDWkyd93z2WxoEaQgnEsYzrjl5cj17oBj2aWuJPMQJUBt0o3LMpWI6CgY5xAlKvHcU9BhgFTJeCj7MOrjxEfyqpmN3BVxnC91kN6eLZH89rjn+8YgWODk7Y7AxP7g7lKkR3NrQGXH/vbO6eYdT2VNy/b46zXWTeUxYNm3DhH1ZWFunD7kTcWUpppu05NQ613Hx1ZZCvQ9S3QAz+YSIaiy7VityD6mUMEh/NsTHqSu1K0/kdelkOVRd1xUpZwUKnYn0/biTri7zYTbLIayQzZKHjdLn3M8e1d4NJLVXNDm56Ci3oQO/OipHZF+en/OnI12/hOxk1izHtOExR4zobg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(39860400002)(346002)(396003)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(82310400011)(36840700001)(46966006)(40470700004)(110136005)(36756003)(6666004)(26005)(1076003)(336012)(66574015)(47076005)(478600001)(2616005)(36860700001)(54906003)(83380400001)(316002)(70206006)(70586007)(426003)(7636003)(4326008)(8676002)(356005)(8936002)(41300700001)(5660300002)(82740400003)(2906002)(86362001)(40480700001)(40460700003)(41533002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 17:16:33.4455
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 383acad4-aaed-419b-0348-08dbcffdfa4c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF00003446.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9194
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

They will be used in a follow-up patch.

For dup_iotlb, avoid the src == dst case. This is an error.

Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/core/mr.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 3dee6d9bed6b..4a3df865df40 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -454,20 +454,23 @@ static void destroy_dma_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr)
 	mlx5_vdpa_destroy_mkey(mvdev, mr->mkey);
 }
 
-static int dup_iotlb(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *src)
+static int dup_iotlb(struct vhost_iotlb *dst, struct vhost_iotlb *src)
 {
 	struct vhost_iotlb_map *map;
 	u64 start = 0, last = ULLONG_MAX;
 	int err;
 
+	if (dst == src)
+		return -EINVAL;
+
 	if (!src) {
-		err = vhost_iotlb_add_range(mvdev->cvq.iotlb, start, last, start, VHOST_ACCESS_RW);
+		err = vhost_iotlb_add_range(dst, start, last, start, VHOST_ACCESS_RW);
 		return err;
 	}
 
 	for (map = vhost_iotlb_itree_first(src, start, last); map;
 		map = vhost_iotlb_itree_next(map, start, last)) {
-		err = vhost_iotlb_add_range(mvdev->cvq.iotlb, map->start, map->last,
+		err = vhost_iotlb_add_range(dst, map->start, map->last,
 					    map->addr, map->perm);
 		if (err)
 			return err;
@@ -475,9 +478,9 @@ static int dup_iotlb(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *src)
 	return 0;
 }
 
-static void prune_iotlb(struct mlx5_vdpa_dev *mvdev)
+static void prune_iotlb(struct vhost_iotlb *iotlb)
 {
-	vhost_iotlb_del_range(mvdev->cvq.iotlb, 0, ULLONG_MAX);
+	vhost_iotlb_del_range(iotlb, 0, ULLONG_MAX);
 }
 
 static void destroy_user_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr)
@@ -544,7 +547,7 @@ void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
 	for (int i = 0; i < MLX5_VDPA_NUM_AS; i++)
 		mlx5_vdpa_destroy_mr(mvdev, mvdev->mr[i]);
 
-	prune_iotlb(mvdev);
+	prune_iotlb(mvdev->cvq.iotlb);
 }
 
 static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
@@ -596,8 +599,8 @@ int mlx5_vdpa_update_cvq_iotlb(struct mlx5_vdpa_dev *mvdev,
 
 	spin_lock(&mvdev->cvq.iommu_lock);
 
-	prune_iotlb(mvdev);
-	err = dup_iotlb(mvdev, iotlb);
+	prune_iotlb(mvdev->cvq.iotlb);
+	err = dup_iotlb(mvdev->cvq.iotlb, iotlb);
 
 	spin_unlock(&mvdev->cvq.iommu_lock);
 
-- 
2.41.0

