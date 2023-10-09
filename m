Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19ABE7BD9B2
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 13:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346447AbjJIL0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 07:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346395AbjJIL0L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 07:26:11 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2069.outbound.protection.outlook.com [40.107.237.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E591710D5;
        Mon,  9 Oct 2023 04:25:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SVjEKc8B8gPjJPHPgvMjRlmMm1JnVZYepX+pm+U0nowxVkDVTRcK/azGCrPRDsTmsto6Hgu5pdSprTJVtykcFrZzNw4F36aK6c5rd88DO7Jg8/vHgMQAx4RGe/m55QVrZuNYdgpHivcLcRo+p6a3w2ibvgjzQCc23ikFyHEPu9PqoKTpUfFm+MRIVQ3YzUoLQTC2n/rS6LL6e8pKefS6/aJj8s6tVDvNCiFmPq7Y/+Zof8jLYXhNDrNA+k/pyyH8Zi2OTmslpzovwmbyHn4rMh3ZsU4grXcYv2bf7QKNc4y7zfqB1ULC0fw/cp72cbN/r9n0FS8AjzVillW7QGGyeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WUyxh+q8JiTvEHDFg9Oqu+9F9CPr0I46v6fSiFkbajM=;
 b=dJx04D53+G2AoxAMIkrl2MwSxtWjd1SelerBnOqrCtn2EQa+gfIl4rrLtEyMoCQdWOcsvqnZoIVggA3n+lqVfmRkcchgyLN9VfWKOel0HoDb4AXjnLXOIz8H2bwkpI8hVQdwtsHwXIeN0UiaA8+xNVUfpnJe3d22vcpGshVkG3N3aPfdr4lB/hhbdn1mPNr59GtEg/mW8+bXJKAyHMDqdTrr2Vas8iMQhze3AzvJYhV/JF2bdHvDrvXVem6qQC/EDEqjRWo+bjqaST7cRc6r5H2TXLsdEzXZv9IeFVoN/tq0qYMs5GJGYkJAhyCATWa2HR7rXQKEqazNh0kHdPV3gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WUyxh+q8JiTvEHDFg9Oqu+9F9CPr0I46v6fSiFkbajM=;
 b=aHgLa5R+W8/rSGqWwoqw+HFb1FQaUziOsF6OYJeIO0nqrM3apQUBtblmpVdjA+4+ZLCkEgq4726oe/n8NETcadqFQiV37LjK30QuXFmbWe/e6QPw/nO9r8k30cdXCrE+p2ixBZMot20VD92+zUZ9krU0si8DzkfKCkbJ1pqjdM3cbhczHNam1ZX8kFg9eILDS+hwg7U9wKEdfXINC8g1RzGcW3nHsCeYqVIW65Swy+O64d3rYh2PNNKXbcRSXu3oY0xJ8V+nyb6P+8F/JyNaP8M0JvZz5GGvU7iMDhn/wesMno7WFOgDLaaPSxvdzTWqbhKS2k9pVvIX8g6Ytdik3A==
Received: from BLAPR03CA0045.namprd03.prod.outlook.com (2603:10b6:208:32d::20)
 by CH2PR12MB4889.namprd12.prod.outlook.com (2603:10b6:610:68::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.37; Mon, 9 Oct
 2023 11:25:33 +0000
Received: from MN1PEPF0000ECD5.namprd02.prod.outlook.com
 (2603:10b6:208:32d:cafe::a6) by BLAPR03CA0045.outlook.office365.com
 (2603:10b6:208:32d::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36 via Frontend
 Transport; Mon, 9 Oct 2023 11:25:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000ECD5.mail.protection.outlook.com (10.167.242.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.22 via Frontend Transport; Mon, 9 Oct 2023 11:25:33 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:25:16 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:25:16 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Mon, 9 Oct 2023 04:25:13 -0700
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
Subject: [PATCH vhost v3 16/16] vdpa/mlx5: Update cvq iotlb mapping on ASID change
Date:   Mon, 9 Oct 2023 14:24:01 +0300
Message-ID: <20231009112401.1060447-17-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231009112401.1060447-1-dtatulea@nvidia.com>
References: <20231009112401.1060447-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD5:EE_|CH2PR12MB4889:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b1e4f64-b605-486f-d985-08dbc8ba73a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r8pNfuNGDy5RWcA4mthcG8kkb1yHSIvsf4NTVpREDloZWvmkSUqmQacj+DtEKaXYR7iNYYZCxrlxECdyODzMdBpC6E2XQnFBR9jOelDo8f2GifQnMOMSlvWBKONQXczb26sto76hkN2D3a0a36/5QAO4v+PL7uEBG2hKbqSQ2UwBS4TeM1PgdFh9LUkVvrsZTx18u2gLiaPbqIkszan+mVe3qTfXynRf3SRCGiEAr4rrWFxE9IKZf1DXEj1VyV04CPh3OQjYmGyKl18E2b593oIRXxMZSPlDE0gQMz8qYMnIsPEA3dcqz/EEEjW0TZdD4XCZoBVWpOP5bTaOkagg+gr9KZpV6pYpIJKmsiJXy1zcrIafshtoTA/pveGyOQsvgbmL9xZyMEA0N2p6IA9z2tDDYyHEK7A1aq6iU4NX9QMimgagbQwABOx54tr3ggVZPiWCUNF1JBdyABl2MlACF3/ji1Q/+X753pa7lV7PYcz8pGfKiRAdl+oM9DuaMVlnTTVCDjbgeDZvejXF2ktxbk64TkYFWe/c1McALAWioh1cb1eGe/Y17aTcUuPWIhHGO4iD7CMNGIEYxcPdlv+G3T3p6FNUhydnl2HJNWlxen8NZ6LxPbtdD+3+q6nLEPDVy8s6NvAZ857/lIuZY4IVjNtOF8Hd/rrDd2OopbTybsE0CGQejKu4KjJ+UqijCxBojdBtBIdsXtacSU5eqGqEZC96VvJ8LxDkZdfENJw+5DLTHujUUP6xO0fe4+l6C0v2
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(376002)(39860400002)(136003)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(82310400011)(40470700004)(36840700001)(46966006)(6666004)(1076003)(2616005)(40460700003)(36756003)(86362001)(7636003)(40480700001)(82740400003)(356005)(36860700001)(26005)(83380400001)(47076005)(426003)(336012)(66574015)(2906002)(478600001)(41300700001)(8676002)(4326008)(316002)(8936002)(5660300002)(70586007)(110136005)(54906003)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2023 11:25:33.1009
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b1e4f64-b605-486f-d985-08dbc8ba73a9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: MN1PEPF0000ECD5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4889
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

Acked-by: Eugenio Pérez <eperezma@redhat.com>
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
index 4a3df865df40..66530e28f327 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -502,6 +502,8 @@ static void _mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_
 		destroy_user_mr(mvdev, mr);
 	else
 		destroy_dma_mr(mvdev, mr);
+
+	vhost_iotlb_free(mr->iotlb);
 }
 
 void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev,
@@ -561,6 +563,30 @@ static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
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
index 2e0a3ce1c0cf..6abe02310f2b 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -3154,12 +3154,19 @@ static int mlx5_set_group_asid(struct vdpa_device *vdev, u32 group,
 			       unsigned int asid)
 {
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
+	int err = 0;
 
 	if (group >= MLX5_VDPA_NUMVQ_GROUPS)
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

