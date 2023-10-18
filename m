Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1637CE43C
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 19:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbjJRRQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 13:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbjJRRQO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 13:16:14 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2053.outbound.protection.outlook.com [40.107.95.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA085196;
        Wed, 18 Oct 2023 10:16:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FzURwtcjCtj1tUS6jQQu2UZP/rQ/wgpFf1LES2ttIrN9GmB2/GDYFPq9MIrhIVZdCAEdSptw/Xy4Y6Rq6fanGcuhGNL8ZI6yHyZdU4/u0/8NUrATJ0FoEtNENbgQ56Ujkm7IlYD93PsMnEOVUExhsu60bqy1TpLmm+5E2hCysGg1DH9eCJChNZUZoj7Daj7rPkf6qcl+QEK1s6s8EUjOemvEyNxnO+TQZbU50qa9P6otVZhHUCOXF6nqvTsJAPE43vi8mSE8Dxq9kv5GP4FZ/BPqF4FZoPeKzReFvNV4FjjR9WWyr/WBIq7thZKgm8pnU4g4kWjKZwOTiwiq9HRInA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3YoDCHkpinOQBJC5OCWVs0dAVcWKDrjzxMHgzD+IBkE=;
 b=Re14IwBhCgykmzyR/e15rc46LVMzxobHssDfxI19/UAd0LMN0sm9TacX6KFxPH62OW01VwA0qTdnR+sKjl6sYbe27ydWvbApIe2i6Cdzt57/8sdZ3WTYAIPEgt2rkqcG6kG94qnIK2fjzsPmQcDcevHRtwCBvl86NYKFqIy9S9kVpjb20cmBsP+4e2OwX03IQgsmQ1VYqnU4t/vbl0spxE5agQiwEufcDsBy9SlnTxEZG5gjxGohNgrqf6Ei6hcgPD5mv4D6AKE6XJpRXcxngk8I6Pv5MmgeZUF/boBIjcc3IWABq77M31UXCl+awLri73vCro+TBkN9OavEpLl9sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3YoDCHkpinOQBJC5OCWVs0dAVcWKDrjzxMHgzD+IBkE=;
 b=UH6KZI1lHQerFcNa3JFP4358BSC5d6yAE+g47gVmFRkrn/pP1iUfONZY3MKd1rUTt+vdqKUgfWPPhnPM538bgQDHRcjCU5mG3MUCYMWiWvFBFlLzTnpp3PjADPwZqIctqR2OcNLQt1enUwtU0b4+bI9U825ncyTPHEZ169NhHzI/iQVAYuMKLw9np9SuOQLmeP5HCWr6bMiWO5E9aTj90WwEoByNqsDe9bcfPg3ARQ30LHwoPpnIS54cwI7Cdi6KZL2jhx0G6sscfbpSdqgCmDmqknJv1LknVeV9msDONPooOo9nme3sgYX2op2n5tOLEPKW8BbMb23eCSVnlonqRw==
Received: from CH2PR18CA0027.namprd18.prod.outlook.com (2603:10b6:610:4f::37)
 by CY5PR12MB6155.namprd12.prod.outlook.com (2603:10b6:930:25::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.23; Wed, 18 Oct
 2023 17:16:03 +0000
Received: from DS2PEPF00003447.namprd04.prod.outlook.com
 (2603:10b6:610:4f:cafe::25) by CH2PR18CA0027.outlook.office365.com
 (2603:10b6:610:4f::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36 via Frontend
 Transport; Wed, 18 Oct 2023 17:16:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS2PEPF00003447.mail.protection.outlook.com (10.167.17.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.20 via Frontend Transport; Wed, 18 Oct 2023 17:16:02 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:15:48 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:15:47 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Wed, 18 Oct 2023 10:15:45 -0700
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
Subject: [PATCH vhost v4 06/16] vdpa/mlx5: Decouple cvq iotlb handling from hw mapping code
Date:   Wed, 18 Oct 2023 20:14:45 +0300
Message-ID: <20231018171456.1624030-8-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231018171456.1624030-2-dtatulea@nvidia.com>
References: <20231018171456.1624030-2-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003447:EE_|CY5PR12MB6155:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a9bba6b-8a41-4a77-cc05-08dbcffde81e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZcV/TNpo/gH9Z+tYGkZqWWveR137wA09QBnUA7PxMbr7/XaD5EHfWUqyWfqRFSAnqZH3O+aL/M75MyQem0Y4IEh1ZTXgfKyvuK0hxZooFrBdS2IHI37ebr6xhbyDEbyMrsoqPFn+XpF/WMA0tPvGGRY8dECS1o9j8xiibT3L3tLr85QnSaaIttU8OfCjehhFQO2itmHqD3G7ktblIG6p5B+BNmIwKyEPpbvTbuR+LbtZ9nVW6GXToOEBsmiEU2jDTjUt1kmk10xnUg8WrgJiIY2zxj5FrvW9ypLQreZtHzzmlMWTAbY8l3cd/cMYGIUIBHIsKiHcutqdOowSMsxIjEPFHUtEDaRNja5TODGfBoQh7HH3DwIo55w8LDzJM6ocapcMxNXnjPZF32NHUWd0dwI+gEV1Br0HaycKYgHwVg14J5Tz0s1l7nzJJAuQOJdn5xILAnkPUARHqZzBDaScM0KMPao26t87SgpIEq5V6flpSsk8kCzB+rCqP61LefjpOfJgC/V/BOu5B/I2UoFV3Qez+gCnFW6mUcw8WRWm8NM6k5YiSuXzBKJufiktDFVamVN4jWNtolvIF02Itir9Ssv2ZBopUh762569ETE/E3rLXESCktIY80uwQ5mCRYt77TxU0zx0TwkB4f2K2MZ85SRNLmnQMoUf7FlXlwTeesPQId1FQ5MBD5zuvizRt01MtzRVpETek7gRF3aJISReaZLumxzoyR3q9eMvgXQPryk=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(376002)(396003)(136003)(230922051799003)(82310400011)(64100799003)(186009)(451199024)(1800799009)(36840700001)(46966006)(40470700004)(54906003)(478600001)(70586007)(70206006)(110136005)(82740400003)(47076005)(86362001)(316002)(5660300002)(8676002)(1076003)(8936002)(66574015)(426003)(26005)(336012)(2616005)(4326008)(40460700003)(40480700001)(2906002)(83380400001)(36756003)(36860700001)(7636003)(356005)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 17:16:02.9189
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a9bba6b-8a41-4a77-cc05-08dbcffde81e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF00003447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6155
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The handling of the cvq iotlb is currently coupled with the creation
and destruction of the hardware mkeys (mr).

This patch moves cvq iotlb handling into its own function and shifts it
to a scope that is not related to mr handling. As cvq handling is just a
prune_iotlb + dup_iotlb cycle, put it all in the same "update" function.
Finally, the destruction path is handled by directly pruning the iotlb.

After this move is done the ASID mr code can be collapsed into a single
function.

Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  3 ++
 drivers/vdpa/mlx5/core/mr.c        | 57 +++++++++++-------------------
 drivers/vdpa/mlx5/net/mlx5_vnet.c  |  7 ++--
 3 files changed, 28 insertions(+), 39 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index 3748f027cfe9..554899a80241 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -120,6 +120,9 @@ int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 			unsigned int asid);
 void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev);
 void mlx5_vdpa_destroy_mr_asid(struct mlx5_vdpa_dev *mvdev, unsigned int asid);
+int mlx5_vdpa_update_cvq_iotlb(struct mlx5_vdpa_dev *mvdev,
+				struct vhost_iotlb *iotlb,
+				unsigned int asid);
 int mlx5_vdpa_create_dma_mr(struct mlx5_vdpa_dev *mvdev);
 
 #define mlx5_vdpa_warn(__dev, format, ...)                                                         \
diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 7bd0883b8b25..fcb6ae32e9ed 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -489,14 +489,6 @@ static void destroy_user_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr
 	}
 }
 
-static void _mlx5_vdpa_destroy_cvq_mr(struct mlx5_vdpa_dev *mvdev, unsigned int asid)
-{
-	if (mvdev->group2asid[MLX5_VDPA_CVQ_GROUP] != asid)
-		return;
-
-	prune_iotlb(mvdev);
-}
-
 static void _mlx5_vdpa_destroy_dvq_mr(struct mlx5_vdpa_dev *mvdev, unsigned int asid)
 {
 	struct mlx5_vdpa_mr *mr = &mvdev->mr;
@@ -522,25 +514,14 @@ void mlx5_vdpa_destroy_mr_asid(struct mlx5_vdpa_dev *mvdev, unsigned int asid)
 	mutex_lock(&mr->mkey_mtx);
 
 	_mlx5_vdpa_destroy_dvq_mr(mvdev, asid);
-	_mlx5_vdpa_destroy_cvq_mr(mvdev, asid);
 
 	mutex_unlock(&mr->mkey_mtx);
 }
 
 void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev)
 {
-	mlx5_vdpa_destroy_mr_asid(mvdev, mvdev->group2asid[MLX5_VDPA_CVQ_GROUP]);
 	mlx5_vdpa_destroy_mr_asid(mvdev, mvdev->group2asid[MLX5_VDPA_DATAVQ_GROUP]);
-}
-
-static int _mlx5_vdpa_create_cvq_mr(struct mlx5_vdpa_dev *mvdev,
-				    struct vhost_iotlb *iotlb,
-				    unsigned int asid)
-{
-	if (mvdev->group2asid[MLX5_VDPA_CVQ_GROUP] != asid)
-		return 0;
-
-	return dup_iotlb(mvdev, iotlb);
+	prune_iotlb(mvdev);
 }
 
 static int _mlx5_vdpa_create_dvq_mr(struct mlx5_vdpa_dev *mvdev,
@@ -572,22 +553,7 @@ static int _mlx5_vdpa_create_dvq_mr(struct mlx5_vdpa_dev *mvdev,
 static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
 				struct vhost_iotlb *iotlb, unsigned int asid)
 {
-	int err;
-
-	err = _mlx5_vdpa_create_dvq_mr(mvdev, iotlb, asid);
-	if (err)
-		return err;
-
-	err = _mlx5_vdpa_create_cvq_mr(mvdev, iotlb, asid);
-	if (err)
-		goto out_err;
-
-	return 0;
-
-out_err:
-	_mlx5_vdpa_destroy_dvq_mr(mvdev, asid);
-
-	return err;
+	return _mlx5_vdpa_create_dvq_mr(mvdev, iotlb, asid);
 }
 
 int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
@@ -620,7 +586,24 @@ int mlx5_vdpa_handle_set_map(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *io
 	return err;
 }
 
+int mlx5_vdpa_update_cvq_iotlb(struct mlx5_vdpa_dev *mvdev,
+				struct vhost_iotlb *iotlb,
+				unsigned int asid)
+{
+	if (mvdev->group2asid[MLX5_VDPA_CVQ_GROUP] != asid)
+		return 0;
+
+	prune_iotlb(mvdev);
+	return dup_iotlb(mvdev, iotlb);
+}
+
 int mlx5_vdpa_create_dma_mr(struct mlx5_vdpa_dev *mvdev)
 {
-	return mlx5_vdpa_create_mr(mvdev, NULL, 0);
+	int err;
+
+	err = mlx5_vdpa_create_mr(mvdev, NULL, 0);
+	if (err)
+		return err;
+
+	return mlx5_vdpa_update_cvq_iotlb(mvdev, NULL, 0);
 }
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 65b6a54ad344..aa4896662699 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2884,10 +2884,13 @@ static int set_map_data(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 		return err;
 	}
 
-	if (change_map)
+	if (change_map) {
 		err = mlx5_vdpa_change_map(mvdev, iotlb, asid);
+		if (err)
+			return err;
+	}
 
-	return err;
+	return mlx5_vdpa_update_cvq_iotlb(mvdev, iotlb, asid);
 }
 
 static int mlx5_vdpa_set_map(struct vdpa_device *vdev, unsigned int asid,
-- 
2.41.0

