Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1ED7CE431
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 19:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbjJRRQS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 13:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbjJRRQM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 13:16:12 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2085.outbound.protection.outlook.com [40.107.244.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A025713D;
        Wed, 18 Oct 2023 10:16:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hejk+cd/VCOpaqrh5zb3UhnRhn+2M3nEBAqw6+j9h1bsZ648YACnyHZWM5MeHiR3V3iziFe8TW+eFXO9yNa56ufqLvLlMfGqNefKelXgkMaT1oJTzoZxdIqO4pdGsoVcmL+HYihgozZTP2Ga3xQWmUUBdEjqr1cG4HQGtqNogQaym8Wuq9fkirSaUwusnfEGgzWxjK3uP0bkP19bQu5GPucKYbT3plEdy6nH4rFs9KxYDL+nUFdfH62R2VS1mD47Mehp6rTyfn23UP2Q41wy/D4bD1tXaoXt8hnV11LuDBZ11bdNY5m9Whrz8oX+lLPCghOBe8EXu1oaA2LkBSyB4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0k7vZDkq8HIAIRoAeeLZ+cqnJ3LV329QdGvZjtWRFo4=;
 b=j1uPbKCiwfImYhOSjvvFgrpHuJJNiUo4KQpbjm7GcLrojsNTLCk2HJPy+AZH5DnEH+G45F75Kca1MM5iEoqRD1U7q8m+zdQRI8h5qVCQOqroUaLidKvsHEzlLL4DjdrtiwufAJvaoN0NOqo8m5VDPH8vExAJ71Eko2KWwq7Aqb3Z1HM7P4/bohjof/5QLQkGHICxJnLBwCe1216/9n76hJKgNxEPIaazidMhtXdJtaXug75F4/gBk0PT7bSPDrg8+UcmSi0GD7pKqxtQDlBzFeRaDZh8VzELgZx21xcbtcPwzfoL6/sPmD/cFcYguS/Hg7oGQpKiWXcYmesDOQ4/yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0k7vZDkq8HIAIRoAeeLZ+cqnJ3LV329QdGvZjtWRFo4=;
 b=FzRWewuXPIGy36nHV8vbHSPZ9td+1WYwWUX5J1OySLuRmlLr0pJclBYCRbr4rLdyCBSobIeEIePedrQf+NllekfC6T7+KgjqVpLqBeT7Z8cehtvmQvyO8Dk7XaoN+KO+HNgZyMmy6aY0XniwFQt5UyAjZEdzR2rRSfa1VLoRjHNum97fMngtqmSmfpp3lfAOOaB7UI8EAzDjJqGuAqpMcNfE2CAyWUPa5IUXh+kfwgQ/gXj/s9hjFX64vhnoZ2bcTLdgxvT+wOXS/nfYV2IGO3QnjscZCyVF0HGv1XksBsxrwojwEncsHrAzU4wsOqC2rcLlBiyLxZ45jWG+hTKSrA==
Received: from CH0PR07CA0017.namprd07.prod.outlook.com (2603:10b6:610:32::22)
 by PH8PR12MB6771.namprd12.prod.outlook.com (2603:10b6:510:1c6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.23; Wed, 18 Oct
 2023 17:16:01 +0000
Received: from DS2PEPF00003443.namprd04.prod.outlook.com
 (2603:10b6:610:32:cafe::1d) by CH0PR07CA0017.outlook.office365.com
 (2603:10b6:610:32::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35 via Frontend
 Transport; Wed, 18 Oct 2023 17:16:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS2PEPF00003443.mail.protection.outlook.com (10.167.17.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.20 via Frontend Transport; Wed, 18 Oct 2023 17:16:00 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:15:44 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:15:44 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Wed, 18 Oct 2023 10:15:41 -0700
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
Subject: [PATCH vhost v4 05/16] vdpa/mlx5: Create helper function for dma mappings
Date:   Wed, 18 Oct 2023 20:14:44 +0300
Message-ID: <20231018171456.1624030-7-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231018171456.1624030-2-dtatulea@nvidia.com>
References: <20231018171456.1624030-2-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003443:EE_|PH8PR12MB6771:EE_
X-MS-Office365-Filtering-Correlation-Id: 91f6820d-03c1-4951-adf2-08dbcffde6d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /op12pZFBzBslVm2Kacjtwul5qfXbh6qy+yXfPkdP+hG8+w0Dgz72vAmz/Risq4OtSpMAM/8rSg5RpFfwgierH8DByqQgUfZWBTS6Eevb+YSkIggGRvc6BgbQrouGfWJx3ZsG8hnd1DBMmg1OaWf9SjG0YRsOg+KPgWvzELV5ycXXQBWvZFyLgim5+NW3s4/JZCJ+kaBRRHU2nluq4yRxKRCrBhkbCe4DQUkzc+6WC4o7VVzdj2c9V/IKnktWsZthl9tHRK9RHWWO9U0f0ntH+6igbAyBZjW2wda8YAhWTj++HOmfPJixvo6M+8V3hgIpv3e6wBx/iRbEyVa/PyD+Q6UoSc5Py5q70/xIWE2LbU8W2t14pGR8IZ6OpCXUMRNm46ZmFmO8laDScdKFRDzmC+/YO3hG4bMhNA7GBJFMtKVKT0X8gJZn542AO/wTh9xDWonHbHIPypaVLIjCiEsnUMYUbHL52hsF6eA6uXQa3mSE23WrLhs7Gi3x2rnSK0f1yANOSKiWBzDFFyyLwCs43jniNq6xC6EYDU3xY34KI1n1I6Xyx5uxLh8l5AwUcVGu+2fJ525q8lg8oRPDi3TkRLCKbXbK6lf+u30Ghj//1Q08EW3IjM/WMsKvPKm7+Wws52JN8Y6xujb8st2wNaXnviHutHF8PTGKeyvRM3vNATHPo8f4ufbRx4PXMRQh+LCiVMZtcuNl4stdZe+RloZUQzLxKjPcRoYVfY6zq7qyAE=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(136003)(39860400002)(346002)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(82310400011)(46966006)(36840700001)(40470700004)(83380400001)(40460700003)(40480700001)(316002)(36756003)(2616005)(86362001)(2906002)(110136005)(1076003)(41300700001)(5660300002)(8936002)(70586007)(4326008)(8676002)(54906003)(70206006)(478600001)(426003)(336012)(356005)(7636003)(26005)(82740400003)(36860700001)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 17:16:00.7671
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91f6820d-03c1-4951-adf2-08dbcffde6d1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF00003443.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6771
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Necessary for upcoming cvq separation from mr allocation.

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h | 1 +
 drivers/vdpa/mlx5/core/mr.c        | 5 +++++
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 4 ++--
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index ca56242972b3..3748f027cfe9 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -120,6 +120,7 @@ int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 			unsigned int asid);
 void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev);
 void mlx5_vdpa_destroy_mr_asid(struct mlx5_vdpa_dev *mvdev, unsigned int asid);
+int mlx5_vdpa_create_dma_mr(struct mlx5_vdpa_dev *mvdev);
 
 #define mlx5_vdpa_warn(__dev, format, ...)                                                         \
 	dev_warn((__dev)->mdev->device, "%s:%d:(pid %d) warning: " format, __func__, __LINE__,     \
diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 5a1971fcd87b..7bd0883b8b25 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -619,3 +619,8 @@ int mlx5_vdpa_handle_set_map(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *io
 
 	return err;
 }
+
+int mlx5_vdpa_create_dma_mr(struct mlx5_vdpa_dev *mvdev)
+{
+	return mlx5_vdpa_create_mr(mvdev, NULL, 0);
+}
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 40a03b08d7cf..65b6a54ad344 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2836,7 +2836,7 @@ static int mlx5_vdpa_reset(struct vdpa_device *vdev)
 	++mvdev->generation;
 
 	if (MLX5_CAP_GEN(mvdev->mdev, umem_uid_0)) {
-		if (mlx5_vdpa_create_mr(mvdev, NULL, 0))
+		if (mlx5_vdpa_create_dma_mr(mvdev))
 			mlx5_vdpa_warn(mvdev, "create MR failed\n");
 	}
 	up_write(&ndev->reslock);
@@ -3441,7 +3441,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 		goto err_mpfs;
 
 	if (MLX5_CAP_GEN(mvdev->mdev, umem_uid_0)) {
-		err = mlx5_vdpa_create_mr(mvdev, NULL, 0);
+		err = mlx5_vdpa_create_dma_mr(mvdev);
 		if (err)
 			goto err_res;
 	}
-- 
2.41.0

