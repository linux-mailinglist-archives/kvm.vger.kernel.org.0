Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F35C7CE448
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 19:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbjJRRSG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 13:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232373AbjJRRRe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 13:17:34 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63B1171D;
        Wed, 18 Oct 2023 10:16:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EThE2dydt6oXrjOLoPyYsQlGJtgXpXD98CJVlB+Btnzu+Lx+FBopXGexN3NtkFy6efxrdQcb9NfGHpeaE4GFPV3zl0N40XCCYu86f97lupi/sT3I2Jpy4SnuqYc2EIWuQYPM8qbrTeDz34Y9fhrlPFgAblMhPf3sCejJgKyrzA71i2jub0k48jJngZR604l99QWcCGH/tkq9hvG9ZfJXN4LAiWuBQYi004aZQQwZqpm4x9h4GsQoa1Ixp55qR2mYhVgKqNA+TNNtnMworuf5YshC9KPBFsReU0sUSbKiX0VOUmRrs5nMwCLRuYRi5yBj+24HnGm4XSEqaJCe+jZJvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1BE04TjWBIEmnEIfT4KflUMZCKQcmJpsqNZEqnvGfsQ=;
 b=nUWuZ07mSd8B/UxQckhyAuilNBWhbx/36gAm+v4rUSlkKgIG5Xv0jJ0xVyE/p3gWeSC9za1XLsxSoHxb2r/k2tdca7kOyCH0XQAEMK/AUMhC8CyGInbXvhuvOpxTeIqvR3Npngpl6sIqBJQMJ60984IeJN3rRGbXPTE4qR8dOWtHefgIPcrxi8JB1DF8cU/nAd42Dv+jCTAp1BEImB+6HvuyPj9v636FTXpZDnjovRB5OXUt0m5COOCp7LZ85qHfztjqCL1+lInQQ9fKboSR7itoKt3yq1S5y1LNeqSpGP4uOoazzBH63E/piwbmiwBB29vEHhqDN/GzEBCeFOpRHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1BE04TjWBIEmnEIfT4KflUMZCKQcmJpsqNZEqnvGfsQ=;
 b=EjtSpyscQSl7+4idLTwA/h2aQE3rx7z/BERL5lNmZr0e1ZiU/ymURg+JHLFCQE3xFeFws85ncQ0SsdJ4TlSlGKnX25Zxo9gA3sJ/tUyUhYHwIPQZbg5Jopgi5nE1ImYmFSNF2iV97Du80pgBjovN3XS1ekYcppW6Ly6J+lWQHzfzZuCC2dVLu1NyeQu5obiSCoFfG9seVoHlNqjNDqQ4467bG/mFJsnICXzqkSHiXklSjjGRmkoS3S9ud1YzlLaSR4ddFDcdzzMDpF0kIqxc1CcNOBTPvlAkWCSAJFWn+Ft9u45EuTqHhNZss8Z2pAK9h8DWbqWobkYilSyA6FqHUw==
Received: from CH2PR17CA0026.namprd17.prod.outlook.com (2603:10b6:610:53::36)
 by CYYPR12MB8702.namprd12.prod.outlook.com (2603:10b6:930:c8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.23; Wed, 18 Oct
 2023 17:16:36 +0000
Received: from DS2PEPF00003445.namprd04.prod.outlook.com
 (2603:10b6:610:53:cafe::28) by CH2PR17CA0026.outlook.office365.com
 (2603:10b6:610:53::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21 via Frontend
 Transport; Wed, 18 Oct 2023 17:16:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS2PEPF00003445.mail.protection.outlook.com (10.167.17.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.20 via Frontend Transport; Wed, 18 Oct 2023 17:16:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:16:22 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:16:22 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Wed, 18 Oct 2023 10:16:19 -0700
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
Subject: [PATCH vhost v4 16/16] vdpa/mlx5: Update cvq iotlb mapping on ASID change
Date:   Wed, 18 Oct 2023 20:14:55 +0300
Message-ID: <20231018171456.1624030-18-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231018171456.1624030-2-dtatulea@nvidia.com>
References: <20231018171456.1624030-2-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003445:EE_|CYYPR12MB8702:EE_
X-MS-Office365-Filtering-Correlation-Id: fb129a15-674b-4721-65e9-08dbcffdfbfa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0+D4Zt2S2VMRqoLgjxAYWJDcziees+cNHNFOzz0jKImWmi/rdJL0W2s6NkiMSQ7Us0iw9J7nTbCpPRwcjA3oWp1eGn1GGUNCg36fASqMuWbjVjkBifviA0szgtSh/j4ALB1WtH43sYrCg3BcqRUZ/Bin1ZxFjyRH80ghqtwQh8RFZJWv0Ii2L5g7eZ9d1GOebh9zPbJZB00/vnME/DSqCtxrFR1wlLEh7WvkKoDwiopQ0e7EuJxqB2uClwsYlmEBSWBGd+VgMD+M0kWW9V1DDmt1tjHKQUQoa/uYd+wAvCM5xXBxlJrWeQNUa8ihWBZLzoeeutq9n1F5e56ehVeG8it+huFPBJs9j7zFqlggRzh9Uomewr9QoZ5nXK3SHStyzPYXtYSpzkRWRi7RQ399foXz5J7Y/oimj3jCrbq4kaRZelO1IdYrHqY+vFfMCpIJlviIUu4tzckFrxmcYLQC3qOB/hYG7KnTD8k0bUTatfRVBbKVPtQ9PNZhZQ619V4F7c8leiJJnE+VjaopCmLF7lqHKEN+xwgDwcqEOmcGhMEhfofbNyosRjbe/oWomLBNgzKdPca1PZIVo6STtI1k8FuZ4IvxubMZssyl4VVLApxuGPDq1IytKmb5gHpO+N8uyjilpVpvHa4HWYpzyBkk+0AWpN2PqsjJhBhpyWCR14LREFNb1zlG2cz3mDrWKWiZ9Oh9xDl1nYHv5XUOqcaUW4HncEUK1bSFKKgnljVUPK/oU3AlNi5yaqo7COiPf2/E
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(136003)(39860400002)(376002)(396003)(230922051799003)(186009)(1800799009)(451199024)(82310400011)(64100799003)(46966006)(40470700004)(36840700001)(36860700001)(66574015)(426003)(336012)(26005)(82740400003)(7636003)(356005)(47076005)(40460700003)(83380400001)(41300700001)(54906003)(8936002)(110136005)(70586007)(86362001)(8676002)(4326008)(5660300002)(1076003)(70206006)(316002)(2906002)(478600001)(6666004)(40480700001)(2616005)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 17:16:36.2817
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb129a15-674b-4721-65e9-08dbcffdfbfa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF00003445.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8702
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

Acked-by: Jason Wang <jasowang@redhat.com>
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
index 87dd0ba76899..5774f4adb7c4 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -3159,12 +3159,19 @@ static int mlx5_set_group_asid(struct vdpa_device *vdev, u32 group,
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

