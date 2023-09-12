Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B4479D1B9
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 15:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235690AbjILNEB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 09:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235368AbjILNDf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 09:03:35 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2059.outbound.protection.outlook.com [40.107.212.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D31A1737;
        Tue, 12 Sep 2023 06:02:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rp4h7k5hHb3fpmcxICp89z8Z4DS/o69WIM4+6X2abNKd+0YN48yxT9oRFK7pVCb+VMwoaHjIlIMexD5460guNQt8dqgeH1n2C/IAIQJhtZG7YMrWMr3Jthg/iw/YID7uwSOlTN3Au91EytpEPb/KGwEJVdJkdgZe0CQkP0zFA5FZ3F1Azl9zpr1YyHNOXPWOPbpFzrfkzI/cbeR5qGCw7nMt5TN3OuYeJa19mB+nvHaNgKffvYIW41dhEjh6W38kH9CQQ3ttZmWsS9fVD5LSGr2X/u57Ok+oGDrQT5nydRO3wDDkoPWu4/WzQU1hOrZ5YA9Y9xkxKOwJCYhsS2UQ5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KNPxs3nbrHeoqWz3cXqfucMTiEexjBAyJD5k6GXMPaE=;
 b=EiM4atdGPLtRvxQA3q9/qv/PO4hQ6rTZjq2sFkQ/G+eklw5bRzqzthBbUdr54FVa2CfCmEOu5LvycL/ByOdpgJ29QI52knrgsoai6PzvAA5smoCQ4Di8mCrc6ySFWh2qMIe/XRgou3RpNBAmODAYHuAfx4uZ9fRwIu88An8HgUCB2onthKQfQNV1SpulbbufWgiS3GISEhXfG2u0IfpQBNSkGF2Xz29DoALEV+2iUDpckUCdYBY7PAQo3rC9ctNmnnRmrAkvE/j+2S48kGtg4kxLvoZyD86XtVayGpG96TYCl8NJ9jjtPcFUfUqjgWlZonjC0VWcYC5mxl6xJZ9b4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNPxs3nbrHeoqWz3cXqfucMTiEexjBAyJD5k6GXMPaE=;
 b=ik0SEbBw5U5zl/AaDX1WeQgpCUjJlm5iGL7MmlBA1naTZV+e6XsqMvkvb9FDdiVqOPPPN0pqLRz222ru3lu+xDtOPiZ9UoIJRKM7hd9HrdxKUgRe9iPcbDH82Qkw8dzA6UJG5mtjr6z2GnlgcAIKnQJdVT/1GRnG6raEv0h9AaNDLJ5Z+XizuRJ9vIEtKF3GK5AaecVI40ZPPW6Vsm0xqzpeKmX+cZoGOFj2LPFjY8NVECdWmspYqk/uc+Msj5GuU1okQ+1UaH++IYgapvtD8u4Mj/EW9kGSBlkNWCthn1D2QNkvyE+05eB3Zkna8MeTvA6o6PssLxRg7uDgl7zGwg==
Received: from BYAPR04CA0014.namprd04.prod.outlook.com (2603:10b6:a03:40::27)
 by IA1PR12MB8468.namprd12.prod.outlook.com (2603:10b6:208:445::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.35; Tue, 12 Sep
 2023 13:02:51 +0000
Received: from CO1PEPF000042AC.namprd03.prod.outlook.com
 (2603:10b6:a03:40:cafe::e5) by BYAPR04CA0014.outlook.office365.com
 (2603:10b6:a03:40::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.35 via Frontend
 Transport; Tue, 12 Sep 2023 13:02:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000042AC.mail.protection.outlook.com (10.167.243.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.11 via Frontend Transport; Tue, 12 Sep 2023 13:02:50 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 12 Sep 2023
 06:02:32 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 12 Sep
 2023 06:02:32 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.37 via
 Frontend Transport; Tue, 12 Sep 2023 06:02:29 -0700
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
Subject: [PATCH 14/16] vdpa/mlx5: Make iotlb helper functions more generic
Date:   Tue, 12 Sep 2023 16:01:24 +0300
Message-ID: <20230912130132.561193-15-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912130132.561193-1-dtatulea@nvidia.com>
References: <20230912130132.561193-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AC:EE_|IA1PR12MB8468:EE_
X-MS-Office365-Filtering-Correlation-Id: 81531f2c-782f-4b1e-49c1-08dbb3909213
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tvd7791KKpIH6GmsVYkwXEJjfETaVyNeYnkoIEdKMVkUHrDvCNbu2fOV5Gl/8BTSAOXiLeCP5mzbMrkVRbV1AHorHlT+BHGTBGYZGUjfLXM/z6X1IAPkYH9zJ3I5nXV7dx66VIHM/BQVQChXVCWz5FypkUZmb7irdsOuZQRjkoDVHPo6Ke27oWOBO4QR29m02ld/iK+vMmcTFAxqbOWPlUmAOE6Ujsz1PLx/+8IUp0GBFnxf3E1DGHJzD5BdthPqNN62A+/YsWc7Q1OarxgeX8vozihrD6uw+JCRbwo0VWkHtZkQEak0qiKrPKMq8Y+7S1PIbXp0zz4ZCK3f8PEqe9zGJrEks+cPENg7gEMCzw5H0ZVoQOeHw6wq8w70ffeQAyF9Vak9eres9Dj8vfvgnP7X1qmsx/94PmYOYvHqhb6h2QuaDupPmkIuUgN1wKjyeo5zlQOX9UWBo1GfbGvMr74GHjR5ZpmApPcbTgmiTOWyrLBlvKV7L7Pwf+ZzzE6gUkhpH+/J6vZw0BmBm3mks3wVMWi0uflHUlVIDbdSoIQLlzSzNxpyQC6Eb8WR0Xp2CMVgbsMN/zADrNrbAyGtKDPMazRr+oP6gNAon6JnYwrmbbBsK2UjIORrwjKExT1IzuZd6Brm3QReQvp4X4wR55rnCPGN1bSiqiXq/+ZI+o96NQOy6COMzaIVMNu4STQPisUmm9RdbDMQ+Z5ef600dQduvWsqEzkmuWgnoGi+2reDIMvF0LQs/wd1M1C/+UJYAEH1twv3NIY50Wem04QQeQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(136003)(39860400002)(396003)(376002)(82310400011)(186009)(1800799009)(451199024)(46966006)(36840700001)(40470700004)(40460700003)(6666004)(83380400001)(356005)(82740400003)(86362001)(36860700001)(47076005)(36756003)(2616005)(336012)(26005)(1076003)(40480700001)(7636003)(316002)(41300700001)(54906003)(4326008)(70586007)(8936002)(70206006)(110136005)(426003)(8676002)(5660300002)(478600001)(2906002)(41533002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 13:02:50.9519
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81531f2c-782f-4b1e-49c1-08dbb3909213
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF000042AC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8468
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

They will be used in a followup patch.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/core/mr.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 3dee6d9bed6b..a4135c16b5bf 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -454,20 +454,20 @@ static void destroy_dma_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr)
 	mlx5_vdpa_destroy_mkey(mvdev, mr->mkey);
 }
 
-static int dup_iotlb(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *src)
+static int dup_iotlb(struct vhost_iotlb *iotlb, struct vhost_iotlb *src)
 {
 	struct vhost_iotlb_map *map;
 	u64 start = 0, last = ULLONG_MAX;
 	int err;
 
 	if (!src) {
-		err = vhost_iotlb_add_range(mvdev->cvq.iotlb, start, last, start, VHOST_ACCESS_RW);
+		err = vhost_iotlb_add_range(iotlb, start, last, start, VHOST_ACCESS_RW);
 		return err;
 	}
 
 	for (map = vhost_iotlb_itree_first(src, start, last); map;
 		map = vhost_iotlb_itree_next(map, start, last)) {
-		err = vhost_iotlb_add_range(mvdev->cvq.iotlb, map->start, map->last,
+		err = vhost_iotlb_add_range(iotlb, map->start, map->last,
 					    map->addr, map->perm);
 		if (err)
 			return err;
@@ -475,9 +475,9 @@ static int dup_iotlb(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *src)
 	return 0;
 }
 
-static void prune_iotlb(struct mlx5_vdpa_dev *mvdev)
+static void prune_iotlb(struct vhost_iotlb *iotlb)
 {
-	vhost_iotlb_del_range(mvdev->cvq.iotlb, 0, ULLONG_MAX);
+	vhost_iotlb_del_range(iotlb, 0, ULLONG_MAX);
 }
 
 static void destroy_user_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr)
@@ -544,7 +544,7 @@ void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
 	for (int i = 0; i < MLX5_VDPA_NUM_AS; i++)
 		mlx5_vdpa_destroy_mr(mvdev, mvdev->mr[i]);
 
-	prune_iotlb(mvdev);
+	prune_iotlb(mvdev->cvq.iotlb);
 }
 
 static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
@@ -596,8 +596,8 @@ int mlx5_vdpa_update_cvq_iotlb(struct mlx5_vdpa_dev *mvdev,
 
 	spin_lock(&mvdev->cvq.iommu_lock);
 
-	prune_iotlb(mvdev);
-	err = dup_iotlb(mvdev, iotlb);
+	prune_iotlb(mvdev->cvq.iotlb);
+	err = dup_iotlb(mvdev->cvq.iotlb, iotlb);
 
 	spin_unlock(&mvdev->cvq.iommu_lock);
 
-- 
2.41.0

