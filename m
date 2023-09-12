Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E643879D1AE
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 15:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbjILNDd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 09:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235640AbjILNC6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 09:02:58 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5797212D;
        Tue, 12 Sep 2023 06:02:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDjO4pDodziMpKnofiTFu3BOcH91YvGLvHURIcNvS2U2Jt5Po4RmQDKqjJHO8Lm9lP4oNGiyWVZmZaUSgTFCWSiFF4VRK9BiLV5rp/voUYXyx00f7pPYziKUb7v2ejU1p8NMtK6wfSf4rFiBRyMMYBGZd+mrUCH+EUSXBgd/g5faRFI5tVgUKMq/Fpi7UvDkbMPFS2eJOxjqC1+ZEGO91ZMjiEWT/qKroR36Mgd8bkFqdfv8ivZVzMw63SuITDXPKClpZM/Yxi3WXSKcv5Ru4cH2VV2HfFygxA83uHL0liM62D2DTsra0FjebhvroHJZjcrRGwfmu84UJA0Nrdyh7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pugKhXn1yyJ2eySbGpZefWpS3s+uIziF5TphRI58E5w=;
 b=IrMXdHtS+9F17VWatLjGOHL/a5HT8hV4U9ddAxx4UmHCmN9ia9zeG3QcqmEAmEONyvBSNCUWeit+g1C3MPi47QOW1QuNLp8R0zG3EGeXjWhPydagXfXpWpRfz5LkU6mWsmUzSK9gpkwexDtcEVXVtUGGhJrHFFR/8L2Mo+n0YpGLxJOEK9PMK0wyJvLzwEN33p/SmlfBhDOuxlzXniOezZhwzJygm5RRFiTRkHnFa1r2Z/TzlBAGKgjpun+nSLAYpRtfwICzQNsIeHBietcEqAlg3RNLnxRZHbetKE+pzptDCzzYJLioJfCFdrOjHs51q0ninbdohPAVBkrNAWZZKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pugKhXn1yyJ2eySbGpZefWpS3s+uIziF5TphRI58E5w=;
 b=aCdVsRc36kBd1tjgQ88twWXv4dStZJqf8ZI0xJtQGGpzYjHtZvJqUu5sXu7jBaBW31cGnXeJpmFZWUEzb8dCOzhnbh79Ybxkf1WeMRK5+osONKEDAIbJySvxBcucAZyKLonzPapjsfqHChlyU4KG6kscBAFqwvpTG9kuMP7ER1hdl8bhyZ5o82nmpv5sva/7WmZTtCSLYdhxpj+bJtVNAZcfHMSAuvMij6X3wok+1DQLjZzZkD3GbEUf8NfdpB/2ajcaN6TdN9yME7aNWIMv79Aqt3yB6bGIh0+kQomwc+rOigwXaZ+pptryFGfDfl6UQB4y62TV/KrhZu3MYqG5yw==
Received: from MW4PR03CA0287.namprd03.prod.outlook.com (2603:10b6:303:b5::22)
 by PH7PR12MB8779.namprd12.prod.outlook.com (2603:10b6:510:26b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.31; Tue, 12 Sep
 2023 13:02:34 +0000
Received: from CO1PEPF000042AE.namprd03.prod.outlook.com
 (2603:10b6:303:b5:cafe::4e) by MW4PR03CA0287.outlook.office365.com
 (2603:10b6:303:b5::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.37 via Frontend
 Transport; Tue, 12 Sep 2023 13:02:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000042AE.mail.protection.outlook.com (10.167.243.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.11 via Frontend Transport; Tue, 12 Sep 2023 13:02:33 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 12 Sep 2023
 06:02:19 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 12 Sep
 2023 06:02:19 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.37 via
 Frontend Transport; Tue, 12 Sep 2023 06:02:16 -0700
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
Subject: [PATCH 10/16] vdpa/mlx5: Move mr mutex out of mr struct
Date:   Tue, 12 Sep 2023 16:01:20 +0300
Message-ID: <20230912130132.561193-11-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912130132.561193-1-dtatulea@nvidia.com>
References: <20230912130132.561193-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AE:EE_|PH7PR12MB8779:EE_
X-MS-Office365-Filtering-Correlation-Id: 02f4fbfe-4aa4-4d36-fab3-08dbb39087d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OBhzkaRm+YIZaRq1kLEY0SXCUeR6NErLALH8TObxWZ4JLTBCkJEFt+TnL7OURZXB1UqBq5R+rX2HcHl1yGamQMpYN8uId7I5RZLtJ3//LtNcqPPpkMDzcB1d5NB1XaNWXDeQ++estnwaluP267s7blY50+LU2qosEiBCankhAQXAUFKNcSSZJAVJ7JWi3EzvSRpCh5Um7KdRtPBpWhglFk9cB75y2KN1Sdoj98nHQf5dT1BA1a8OFJKE0FV/Bu08wj68pS46HhLuXM7/Xh7p4LU2jUDxJizZTs9g3+vEDj/FFgP0NGoUr7QDGuDCB8YMf3rsi59UMsjXFHOX828p/ZGyqN9y8j6jEljPjPiJQGbbPGipW4t/j6b3/Ktu3Ceyzjr9o309eX7z0gLRv3SGDEcvGBKtogAVERte9BTvKykSjpLTsvguFrRuMqRuuAHFFx9jE0JvGXwcvf5OWU37ssXYunwewX5YyUkqXWgEQh3qH414oWSRz4b8Af8qU8qwQl/VsMaMkin3yO4YctNbd6RIWQxKGib+/WO/U0JxhUCxIsBx1sq4OoCwDdGtD1AUY6EmNv22aQhHY8xHhBk8ATqatX5a5gVSauLpA8IPdWR0X0u0cVYLS2CBXrAxoUioiIsna1ZxwJRP17TTBLlvB+JnBsUeo1NKfKRme3HSkZZaDVGPeyje6uxORAraYcdUVk35zlfpk5HRw2HGsOCKxo8LXyJnxRho+68X5ECTTwJtFU97XJnu4C2wi6sHL9r1
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(39860400002)(136003)(396003)(186009)(451199024)(1800799009)(82310400011)(40470700004)(46966006)(36840700001)(66899024)(47076005)(70586007)(5660300002)(86362001)(40460700003)(36756003)(7636003)(82740400003)(4326008)(8936002)(356005)(8676002)(36860700001)(54906003)(336012)(83380400001)(2906002)(316002)(41300700001)(40480700001)(70206006)(426003)(1076003)(2616005)(110136005)(6666004)(478600001)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 13:02:33.7220
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02f4fbfe-4aa4-4d36-fab3-08dbb39087d2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF000042AE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8779
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The mutex is named like it is supposed to protect only the mkey but in
reality it is a global lock for all mr resources.

Shift the mutex to it's rightful location (struct mlx5_vdpa_dev) and
give it a more appropriate name.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
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

