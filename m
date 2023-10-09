Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C1E7BD9A6
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 13:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346212AbjJILZu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 07:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346304AbjJILZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 07:25:25 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8683410B;
        Mon,  9 Oct 2023 04:25:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S+A2PJFcPjRoJEqL8KdMONbWa9KzJj5sDW5A75269KwKIySoNq1Vi9bnVezRb5JgSIzZ/x9RyGflZKKMONsFXEQjtXIdRGEhBGqsayKj2oLhOafq5wVpexFxr9VdO99A+oCwSaXgGJ4YFCKxYHKy0eE8wXsEDF0YvqSeqXtkxraagOEVH98/yewh/Pf6+Rf+gQpo/S9xXa7AEewBF3okGLsT6W44b9Sz7ZTDWnd0oQdEumvIswkIcnzsiG01SOOZpxpbXrGzCx2z9e0gDp778aV0Z8c/cjRoyrU8iBXOuxHC74WFvLW8iEHRyxS57xN4OqpF05KWHkbWpobvq7NaFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wy1kaZQzU+m3/SX/tOV5uK0InINX2soflKNDLMzJf7k=;
 b=JWJIPnVbhm/F59/++MNrhM2qj5dwXEZuVim3DiAsFbKspVJuOJQFGapDz7Bb7yAY8GMEBXCa9FkM3ovhE1KjtGf6bHolHgu7ZcDkFAIeegJWvGu5Um1zmJtoP6oSa+8KA2NiaQ2kgyqd7PigW7qqpCMk+t5pTJEoyhpKD9orj+Dr2joSN9Q4DtVvWIpRMfVM/d88ZfyLiP9cAyUnrJzmtfG0lPoU04E2UF4+a48yk8w6l3GTx08liFj7HektxpmB96GSOFmeXUpPMKcmGDLBqXZrZbefkJix0rxM4u8n8t3utVqB3MbqHRPlrr52T2ASGbs5s3LVTGYY7r+C3cZ9yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wy1kaZQzU+m3/SX/tOV5uK0InINX2soflKNDLMzJf7k=;
 b=Eg//R/Hm6vAtS62YUqU1L8bsrGGSMqw/k8I4M8UfE/MxKcw6T5KVqvVv8LAj6sD6HL4tvBnBIXhOgixZL54S7cjY5YuA9kEuKLjdzyQdYzhkt/FQ5n4BeUYBCUKT4M4IdNJgxcHJV7BDe7l0SpEzb/ojyYsI2Sy0n5t7ODc2YdVAvIkwzq2Mux+FftNqnEsJLJl4k/CktWKe5HlQMspTCO0/mHPN+g1GKzZat2xVTNQ9sCMbfyWR7czagBF4CM5RWRx67EZxC8lzRWjk9/8CJa8b7YZ+SfEoqiqWElxfIOy+vlLfPFgmuVqdd7of+w/oVWfphxLDxYK8BYicSsnSxQ==
Received: from BLAPR03CA0050.namprd03.prod.outlook.com (2603:10b6:208:32d::25)
 by IA0PR12MB7750.namprd12.prod.outlook.com (2603:10b6:208:431::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.37; Mon, 9 Oct
 2023 11:25:14 +0000
Received: from MN1PEPF0000ECD5.namprd02.prod.outlook.com
 (2603:10b6:208:32d:cafe::fa) by BLAPR03CA0050.outlook.office365.com
 (2603:10b6:208:32d::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.37 via Frontend
 Transport; Mon, 9 Oct 2023 11:25:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000ECD5.mail.protection.outlook.com (10.167.242.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.22 via Frontend Transport; Mon, 9 Oct 2023 11:25:14 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:24:58 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:24:57 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Mon, 9 Oct 2023 04:24:54 -0700
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
Subject: [PATCH vhost v3 11/16] vdpa/mlx5: Move mr mutex out of mr struct
Date:   Mon, 9 Oct 2023 14:23:56 +0300
Message-ID: <20231009112401.1060447-12-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231009112401.1060447-1-dtatulea@nvidia.com>
References: <20231009112401.1060447-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD5:EE_|IA0PR12MB7750:EE_
X-MS-Office365-Filtering-Correlation-Id: 1037588c-8da1-43b0-564d-08dbc8ba6886
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WiMISNbywyjp7ySCHohJd641a1v0sXTZ7inHtLvE+SSsIkyVaNtoAp3zS5V6HIvwN1GHA7FPQGhr5a1AOzpUkAD7DimohuDeRcr/IH0+5GqMA6pnWvu33cf9zARYYRjNlFKvtC+Wh5KducIdTmy8P2JDA5MtxL3l8gsl1S7itkh96QyeC+NiATPhkBxYqGgfVRiaD6ZAOw40p2DIo4F64pmwrq0+gVrJGVxBqTif9YFfyC4BFntEkusyjn2NQ9qes1NzMzXCt2yDyA1smkGWC2GRrPl7jXU3guE5BiyDllOGfVzonNi2QoBvnC9u5c7RIssL9FV4OKbiWcWYGFcud4Vdlx1sO58JsyASae7F1tnvKxwkIdF/cHnJlFjGZylk4iNsoltknRPQG1ljlZM4JlJ9LbBdMzzSzoPBpmBiLEt6+/D8QULdcTCK/4iQgSECpf6exjWznso1V3LQtRB2eEcDAsuDKeJKxeerlAY0pXs4CO/hMkfPmNTZOwYF6FnHo4PrjLs9FAQEJ7YrdC4Asm16ePWnzIDnZgiJuTmGs9pY8wKQoP08kYEftWfhYnNl88Jp3uSF2hzO53Y4b5eYngCsm9PxqpXGlODzY8DcAvGR9f7iSbTWWQ0ZMPWi2BzW3BYcqSmzgTUYCvLWYcWucXKqmu36rTMfZHojJC0zzLqmY19oIQGL6+SInn2pilqH/xMs4AwRzJI8h3Xdd178n/fADuRBEWGnDZYVBruhIzupfA7ehkhjKNjvReygxf9Y
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(136003)(396003)(39860400002)(376002)(230922051799003)(186009)(64100799003)(451199024)(1800799009)(82310400011)(46966006)(36840700001)(40470700004)(86362001)(7636003)(356005)(36756003)(66899024)(40480700001)(82740400003)(2906002)(478600001)(41300700001)(8936002)(5660300002)(4326008)(8676002)(1076003)(83380400001)(426003)(336012)(2616005)(40460700003)(316002)(36860700001)(70586007)(70206006)(54906003)(110136005)(26005)(47076005)(66574015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2023 11:25:14.4132
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1037588c-8da1-43b0-564d-08dbc8ba6886
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: MN1PEPF0000ECD5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7750
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

