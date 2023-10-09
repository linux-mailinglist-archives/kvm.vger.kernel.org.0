Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D577BD991
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 13:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346333AbjJILZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 07:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346293AbjJILZK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 07:25:10 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2060.outbound.protection.outlook.com [40.107.212.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FB7115;
        Mon,  9 Oct 2023 04:24:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cOZ6osvtSnIv2VPJQ/dmmWImZIZmjT3b47fURvh0v1IfGP3me2eHvot3duqq9t135d0erDnNPB757UTr0insOCaoMHRMhMsqW9h8Qo4IZHV4mlWM6R6CqFn3m2RsdgfvO/bhhu53LBCpe3Lcp4rA9+fKyPY/KPRGLUQ49VNlahoDRabEyusKAUOVm49I9HTjA40CgKIerLnJhATX1x1pxGOaXaqic+N3r45poTfRWraTOUChj0yEEreBNIzs556dn86V9cJ2Y++v2aZ9b+eJed6r/zNzyGbearyjejqGH3+IRNdxdjEGAoI/0/WYYydhHn5P6DuC/gXiNQEAtPdRLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0k7vZDkq8HIAIRoAeeLZ+cqnJ3LV329QdGvZjtWRFo4=;
 b=SlM1MX3If+1oa0yumFvsmlNmtgi3DScGrsG+rBvkbbMwrokGgWX/CfcFtq0tYxISEAtRSjO1dAn+lMP260dMSjg4X0ozEbFGydJU7d2sHIHB+oBYw6hSGgCUUNWW1fipwBFQT+8NFYCHjEdwQWhA+8TTgkEYoY+OHxgwqyEGhNieWtWBSlUt4v/nSRvxhEZITnrnZoafwSNvnFSUKJ5sPcUBdpEJRIFSXS/VifOYO4UWFw1Q2vb5DAYOI2EzaBnO2go2mfPTK0z9+Z2lR6A9P0+yWAhTOaJjCkuuYoyThCb1IVOok3TrrY6SEtHzLucYQLPd/0SjK61fQOAue7Tdeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0k7vZDkq8HIAIRoAeeLZ+cqnJ3LV329QdGvZjtWRFo4=;
 b=aZd72BvBri3ocRkEetFBtOAJX4xNj3svGZN1DK/VRBqwQOvgfdol/W85sLUfFsm+jsFB5wi1C/IZzCQ9AFZ/bmXo7Guyab9khCo/7bg6eINLrvroGxpL5Mk8M7Eu/5Of3cVVufvHw1O2Zm8HgybwUtZFnuiGCRDn36tooWRwC7BczOI0d+N3GJpRJ0XKZtnkus/2Te7FfNI3I+obGXLCdzpNEEw5pkJVFkPSFzw2qAWqCxqc+Vam0B2yELTAeunR6deu2YUw70SquEcsK4ySyjge7COd+NhlTrmwgSdMJJOuNSGqvAEkQ+Zd1CGPzPoKxCWsFc0Ny+3H9KSPxdR5AQ==
Received: from PH8PR20CA0002.namprd20.prod.outlook.com (2603:10b6:510:23c::6)
 by SA0PR12MB7073.namprd12.prod.outlook.com (2603:10b6:806:2d5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36; Mon, 9 Oct
 2023 11:24:57 +0000
Received: from SN1PEPF0002BA4B.namprd03.prod.outlook.com
 (2603:10b6:510:23c:cafe::65) by PH8PR20CA0002.outlook.office365.com
 (2603:10b6:510:23c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.35 via Frontend
 Transport; Mon, 9 Oct 2023 11:24:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002BA4B.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.14 via Frontend Transport; Mon, 9 Oct 2023 11:24:57 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:24:36 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:24:36 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Mon, 9 Oct 2023 04:24:33 -0700
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
Subject: [PATCH vhost v3 05/16] vdpa/mlx5: Create helper function for dma mappings
Date:   Mon, 9 Oct 2023 14:23:50 +0300
Message-ID: <20231009112401.1060447-6-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231009112401.1060447-1-dtatulea@nvidia.com>
References: <20231009112401.1060447-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4B:EE_|SA0PR12MB7073:EE_
X-MS-Office365-Filtering-Correlation-Id: 844f0bcb-dcc0-4259-752e-08dbc8ba5e2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X4+BdXqnK4QSivMcvtklbKRxX8UmnNcsqbOpBupHYuPSWtlfIkJXLSsYXAv5/e4UtQy++y4LcS1SzIe+sxsKr3cBWPseeCououh1chSpTfVZq6Zp1Ap3Y4Hqq3aTTRah5WMj9CFgbN2MahUVytVsow6IaB5wecGTT73VdytO5dOnFxSedA2uvrzShoYqYpbm5/oyweOBWVTbtqL8aono82dGMX8s+7R3xGafm1Yd1pTQtFwTJhByJjKobxcXt2rLFTybeRybyVXH8BqOrlfA21zz1lG17Kx1sfd+2/On/UX02c8H+qJv9/7ZlWoHHpD2VM/svw0L93vNiy7hEjidKaURYtoDZdkkOrYPyKEPbkf+OFmBtM3MQJWHq96DpUT9J+MjYG08LDA20wwjzKPkID++9GEQLipsPJi4CZD1qurYa7tNqnXi1otiQjd0oN7CMhEjhYiXcvZ8D+ndP35rnV61kGW68tTiPyJ3Hokw/GfPu6wa6goQAnK/h7tr0Nm4IrWA3TSFUvzE6JcxyltgryTQzbohUFdxoccagEvssJaXONtxD1SCrxK56YEqRdX5JKdICu8e++MeHv9+xYyJj0uF/wy7ih6kOCKYl2oaWW8TsdWEW5gblLLn9A9n7nJfHi+NQgKicCK9X1/uF4yVcHk277geaYcjtO2dmenUtOwJNVvesC8ZD1jNIt5sIgrMknamjq/w0612SWpInkS/y5Qqja3ymyB3DDYmFG40Y5o=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(39860400002)(346002)(376002)(136003)(230922051799003)(82310400011)(451199024)(1800799009)(64100799003)(186009)(36840700001)(46966006)(40470700004)(1076003)(2616005)(426003)(336012)(26005)(40460700003)(478600001)(6666004)(8676002)(47076005)(36860700001)(83380400001)(2906002)(4326008)(54906003)(70586007)(70206006)(110136005)(8936002)(41300700001)(316002)(5660300002)(7636003)(356005)(36756003)(82740400003)(40480700001)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2023 11:24:57.1226
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 844f0bcb-dcc0-4259-752e-08dbc8ba5e2e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF0002BA4B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7073
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

