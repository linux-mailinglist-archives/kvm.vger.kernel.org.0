Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E57779D1BB
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 15:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbjILNER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 09:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235439AbjILNDq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 09:03:46 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2065.outbound.protection.outlook.com [40.107.244.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D2B1995;
        Tue, 12 Sep 2023 06:02:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYVK0BuVY238Ml2Y893Q/5ZF+4BCZFDzhEL7HtllZOJs2XQWGW/LxDmo1RyLlspZepVfq7HMdnk9MAAzIzvtrAA8ytnjux1/kt8R2v72auK26cEemK0RSW2UcEwStmogU2el7b/HbRbb0zQ2tWiDtQ4kWl2BkvzlREoLO8TRN1rMmvnb0UrBe9pdC+a9iIJIR6xACu71fwyH5X5hGtMynl0TPJ2qCnIDSqKYz9dzLN/s/ddAGhBcBB/do37gZ6Dlds1THkd1FpMUnO+MvAqx5reI/bR0bNwIovb/DRBCtUBuRndCbE5+ToywrXA3cgDTIJrn/grsyXxKLnfqXIf44g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IbzEYzYz2NazStJX9GiuEg+WlWBdx9elE3xiMUBokJI=;
 b=eh7qb/6ovpuUKH5UTersI/08hqlSARjov/XAR/gySxDW73ISLACTdPBM8k+3churwlpGwEhzUimHZ2ykh3bsHg50RgZ1pAxUpshgTd8su9YDAile0Vl/sbjjYjf3yzr0sQvNvrH14ixAbf6WZi3S+Bwc8PLeMPdAZGhEmzWvI9q3Y7lpcVGaWPKTR8/kseS3pEeBGtucYD8kSOBaxUSXlWN1u4+d/ty/9/cY1rcJQ+J/0c1dSg8Kzf0zfriXeTEx8i1aM4HXoK4X33JRZtLeMOZK6pfVqOVkGdjeNzifSrdZxRpKw6R3o/B+dODD/8IFTvg8+AkYhoiPncJRpQ/VhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IbzEYzYz2NazStJX9GiuEg+WlWBdx9elE3xiMUBokJI=;
 b=RFTuX/oidd6oOlACineoOIb9b1hLb6ycCHb79e1lYEq9zMhdP2g7S0xWzePZYFWt960FycJUJPBSQPJwJqNS5+th+JiScj/DulV28joiM2Yj70ptEFitMOivvx/84XoG8up4RMI6C7IUHQo50WwXG6CaTXa4jgqdqqNg1D14x4yLlj8iazcWkIXyNMBGFYVa3ndw6+oc9KfAb2j6nWSzEjI4LhlpF3dDroPvhpePrnOf/qDiy5H7zjjElGzW8ZecFV8MSl8TQ7NgQSxjDnLB06nHiPxAGt5OCUkC0mmWIXbrY1WnYD7Rno/y0M9mqhtfW+5+ZwT3UQ6uXSn5dEkjAA==
Received: from BYAPR04CA0027.namprd04.prod.outlook.com (2603:10b6:a03:40::40)
 by DS7PR12MB5792.namprd12.prod.outlook.com (2603:10b6:8:77::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.31; Tue, 12 Sep
 2023 13:02:54 +0000
Received: from CO1PEPF000042AC.namprd03.prod.outlook.com
 (2603:10b6:a03:40:cafe::bd) by BYAPR04CA0027.outlook.office365.com
 (2603:10b6:a03:40::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.19 via Frontend
 Transport; Tue, 12 Sep 2023 13:02:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000042AC.mail.protection.outlook.com (10.167.243.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.11 via Frontend Transport; Tue, 12 Sep 2023 13:02:53 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 12 Sep 2023
 06:02:35 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 12 Sep
 2023 06:02:35 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.37 via
 Frontend Transport; Tue, 12 Sep 2023 06:02:32 -0700
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
Subject: [PATCH 15/16] vdpa/mlx5: Update cvq iotlb mapping on ASID change
Date:   Tue, 12 Sep 2023 16:01:25 +0300
Message-ID: <20230912130132.561193-16-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912130132.561193-1-dtatulea@nvidia.com>
References: <20230912130132.561193-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AC:EE_|DS7PR12MB5792:EE_
X-MS-Office365-Filtering-Correlation-Id: bdb3d417-7b44-49bb-4cd1-08dbb390939a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7OJqDtRvoTsmV5nTsPpKvo4yLqnv8z6j77ndo1w5lQqU8di84c/U96R7N/cLdhqCZp0BKJ2/G70gNl2K8B2VGvdXsrQWca5w7PR0YWYPvGWJ7/r3l1y9jJaQg/iohlA7R10vHWkpo2bRSHWT6iM/3hj8KHYqbmL9X8jHidb0rcXbu/kZccixKWBjFCf7clp+xc3/+bznDwmjMgvGnQA47vdgSyBtENSt+iA+Wg+dI+h0Fl685osetwUvsnwvIBr16EVU0QuXgzmDT76eotn4cIONpRh5sYXNI1ngLNJLVeBwYiTar86gs459oIVuYue38flTuEUn25K4xSwdCto8/G7ezE1GGe98emKFKd0H8x8DZTOc2WXu6ASLJL8csNBRrC6/js9KX7cbhX/bD7qUvJvoPqOtDuHwWJ7pzw9QBLvL3F7MLIEGIfqr1rprSHjp2CF5GL9alXUBZ21hQuL29BW/M4I1LSKaSHnsUeDMRMGHCgz4iPZsvJ98iV7MSTwCKnBsQp4nHIQ+WrfGc6/VX81L3cWAHkYxXJID0ZNE3zIilxTdV4GL1d/rElWp07taU2axuNbM4NRNtQLSRtTpSukXWDySdOb1vd7y8C78SxiKKUpmShZioiqj24K8TlWy1eCmXvJWrp2tkoEmUXIBSvkJhMtv+Uky/8VwVD++279fQzsu9HTWXO3C4tzUr/AUxovnlRQAbGYIKT8NDUZ1rsp6bSpXFJ8oyNHZSPSUCrcmHL1LlW+M/7VQTAc6UY1J
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(39860400002)(376002)(346002)(1800799009)(186009)(82310400011)(451199024)(40470700004)(36840700001)(46966006)(40480700001)(6666004)(1076003)(2616005)(26005)(86362001)(2906002)(8676002)(4326008)(40460700003)(41300700001)(8936002)(110136005)(36756003)(70206006)(316002)(70586007)(356005)(54906003)(5660300002)(82740400003)(478600001)(426003)(83380400001)(36860700001)(7636003)(47076005)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 13:02:53.5301
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bdb3d417-7b44-49bb-4cd1-08dbb390939a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF000042AC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5792
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For the following sequence:
- cvq group is in ASID 0
- .set_map(1, cvq_iotlb)
- .set_group_asid(cvq_group, 1)

... the cvq mapping from ASID 0 will be used. This is not always correct
behaviour.

This patch adds support for the above mentioned flow by saving the iotlb
on each .set_map and updating the cvq iotlb with it on a cvq group change.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  2 ++
 drivers/vdpa/mlx5/core/mr.c        | 26 ++++++++++++++++++++++++++
 drivers/vdpa/mlx5/net/mlx5_vnet.c  |  9 ++++++++-
 3 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index ae09296f4270..db988ced5a5d 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -32,6 +32,8 @@ struct mlx5_vdpa_mr {
 	unsigned long num_directs;
 	unsigned long num_klms;
 
+	struct vhost_iotlb *iotlb;
+
 	bool user_mr;
 };
 
diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index a4135c16b5bf..403c08271489 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -499,6 +499,8 @@ static void _mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_
 		destroy_user_mr(mvdev, mr);
 	else
 		destroy_dma_mr(mvdev, mr);
+
+	vhost_iotlb_free(mr->iotlb);
 }
 
 void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev,
@@ -558,6 +560,30 @@ static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
 	else
 		err = create_dma_mr(mvdev, mr);
 
+	if (err)
+		return err;
+
+	mr->iotlb = vhost_iotlb_alloc(0, 0);
+	if (!mr->iotlb) {
+		err = -ENOMEM;
+		goto err_mr;
+	}
+
+	err = dup_iotlb(mr->iotlb, iotlb);
+	if (err)
+		goto err_iotlb;
+
+	return 0;
+
+err_iotlb:
+	vhost_iotlb_free(mr->iotlb);
+
+err_mr:
+	if (iotlb)
+		destroy_user_mr(mvdev, mr);
+	else
+		destroy_dma_mr(mvdev, mr);
+
 	return err;
 }
 
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index c5e9c84988cc..606938e2acbc 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -3154,12 +3154,19 @@ static int mlx5_set_group_asid(struct vdpa_device *vdev, u32 group,
 			       unsigned int asid)
 {
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
+	int err = 0;
 
 	if (group >= MLX5_VDPA_NUMVQ_GROUPS || asid >= MLX5_VDPA_NUM_AS)
 		return -EINVAL;
 
 	mvdev->group2asid[group] = asid;
-	return 0;
+
+	mutex_lock(&mvdev->mr_mtx);
+	if (group == MLX5_VDPA_CVQ_GROUP && mvdev->mr[asid])
+		err = mlx5_vdpa_update_cvq_iotlb(mvdev, mvdev->mr[asid]->iotlb, asid);
+	mutex_unlock(&mvdev->mr_mtx);
+
+	return err;
 }
 
 static const struct vdpa_config_ops mlx5_vdpa_ops = {
-- 
2.41.0

