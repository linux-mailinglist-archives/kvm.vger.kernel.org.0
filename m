Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 922CD7CE434
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 19:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235109AbjJRRQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 13:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235060AbjJRRQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 13:16:28 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57127115;
        Wed, 18 Oct 2023 10:16:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=btC+LOXmSbno2OsIgFJWSs072DVNH9TTLZT57ONCYiblp2G45lcNrFCzYVmynfT8WIYX7SZDdfCCMVeqdz6Vzzb33jpkzCXUSV9fxrt17LFhmtWtzmT6AGdLCJD7wFqAUoO66cluaOFA9g3LqX6GCzJDXGp6Ups+voayQb8PdQ9yu9ToKv43CkWGglz6ylrC7XMKLLwuP3aOSI5tEe6VWTXcmiDyhVNZlAaBhwh6pJCidYM9GVxDsi+RtZdVyGXTZhgDUYpTj/yL2h5l66StsuUvLMtCbd7JjQ33CSzb/leLxJRU+qg5cKviOUMdx9gMuxorhpP2bWDRSZ8ATnOC7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sqfty/jYzKnLc/JEwSMOvq4UGNN3rkOgV9qEyvqXUKk=;
 b=n64CdEgPJ1UDXeKA3Y/TzoDiU3THuBa5cS5t71W1AzjQZEg8xMdm8ACRoGk6yul1+MzeLeqXV2FN7rjYiqaTaZAXx0ljtKxmHcNLfoU4zsfxNZT3s/smP2SDAiQAhl3b92YVOAWDuffmaWIaViBwuk3xpeAEXXZAGPx4LlYLW/ahL+5V7oO4GnFjnyzdCBsRwiM4uRTqmLOjqoZd9+ilS1rRxUi8ksXSjjQzzX/cKZyXLzBu06TsM2T0k6q1wlrKeS1J8ofrqefsOKus9nuPyPVzkQt1cviwNez2Nv8rE0t/UFtAy4FgW3E2BUjLYMw2xhbbek/xLiOpka2JvKk7KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sqfty/jYzKnLc/JEwSMOvq4UGNN3rkOgV9qEyvqXUKk=;
 b=Oez1GLALNnZ7ZOHXzkFw5O4oWPXVqDTzBqlvolwaBEO/3htdDPZd2tcMtzaYBFZWV1rpfBk/D9FHNmATP4ivqTZSlp/uCcf53r9ZfuaCf1e8Z+EkUsDx3eZpsEitmTcuYRT/0QgIrac1W7E9z+dzxOEEVy+Ffvg6pgNVzOUOd6HaPZycGcNSqa6oOqAy05uGb9u5PNqfJAk015DNBwadG1/9SkNegCe5d0U6tc9AX6WzgjqnyFdwTsmthSE4bgtpx82crHK6si5Eq3CTBaoIsmHBhyth5iDLxnBns0WuQrg7lvQ56n8/i0AYGhsVDxi7zj85wj06hA4A80nNh8neow==
Received: from CY5P221CA0147.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:6a::20)
 by DS7PR12MB9041.namprd12.prod.outlook.com (2603:10b6:8:ea::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Wed, 18 Oct
 2023 17:16:07 +0000
Received: from CY4PEPF0000FCBF.namprd03.prod.outlook.com
 (2603:10b6:930:6a:cafe::e5) by CY5P221CA0147.outlook.office365.com
 (2603:10b6:930:6a::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.23 via Frontend
 Transport; Wed, 18 Oct 2023 17:16:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000FCBF.mail.protection.outlook.com (10.167.242.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.23 via Frontend Transport; Wed, 18 Oct 2023 17:16:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:15:52 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:15:51 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Wed, 18 Oct 2023 10:15:48 -0700
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
Subject: [PATCH vhost v4 07/16] vdpa/mlx5: Take cvq iotlb lock during refresh
Date:   Wed, 18 Oct 2023 20:14:46 +0300
Message-ID: <20231018171456.1624030-9-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231018171456.1624030-2-dtatulea@nvidia.com>
References: <20231018171456.1624030-2-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCBF:EE_|DS7PR12MB9041:EE_
X-MS-Office365-Filtering-Correlation-Id: 81ee4425-fdf7-4ec1-8ce4-08dbcffdeacc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rodFcS3UTwp91jSJLaHsfhaynSqlJZAsI2PldA7T0Z6t6cqMJT+tECEUGf/RwdhYVQTavQ1AvZVNF9YKPe/y6x59ixMHwQfX+0/QeVK6NPRVB0HQ+lYstGwavufnb6PxiJjQaovBe+Vd7FDYmqC9MnJ+qzNi0vZW6m1jGdVVrtImYoJowtd105/YCijlsn66yyycM65UEPhwkgbOHbiZHSqScso3KQS0DEi055mCYG+nVTgF36QT9I4ORQJ7V0+9YpQCIhx7a/pC5wV4VZf5kc2Uck8BFYFCsF1xOMpeOZGAhHS5McZVMJsD+fQFWA/SLwoYml+xZ6yf0VRmoUhhJVE6W4SFJo/crpV36ZLb0d7XOf2uVe6atzNlZv6qEZPelQyAGixzm0Tajrn8ru9pkF9zIfUaiGLfy7Ep81lmuocxz4aM+hf6VRkPDh+zRiLbQgRtMPnzLLmA9JNCEL0liCQEDZ/fZxLy0KWHWJ9WQtwT+x60E42h8Uyko5izrvtabVJspLNcCQy5Em/BC7jskWMMOZQcRUdJJDN+1K4lLS3aw831tC5jqgM2H1HaAigLFgJYX2FLgwWKg6emuGN2R5m5kyJ0XWhz6tNE4l/1vJBjkqEiuT9x2cWVEHEfuSvVgGOygIu0jndOuSefPMP1YJT+WE2C5V/IPinuelS9qom5yM1PyH518Osomb+JRsrpWJaLjjoyNcC8axkSIoLnjbdKBfcGF2E+QDl9DGxybW8xkvEbuIca4owcdFbT2VNRkRRWicvqiv/rcTwOaBWXcdWu1JD2Ul4/AEl+648hzZc=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(396003)(376002)(136003)(230922051799003)(64100799003)(451199024)(186009)(82310400011)(1800799009)(36840700001)(46966006)(40470700004)(70206006)(54906003)(110136005)(36756003)(83380400001)(336012)(426003)(70586007)(47076005)(2906002)(66574015)(316002)(966005)(478600001)(82740400003)(8676002)(8936002)(36860700001)(41300700001)(40460700003)(26005)(356005)(2616005)(4326008)(40480700001)(7636003)(86362001)(1076003)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 17:16:07.4444
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81ee4425-fdf7-4ec1-8ce4-08dbcffdeacc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000FCBF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9041
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The reslock is taken while refresh is called but iommu_lock is more
specific to this resource. So take the iommu_lock during cvq iotlb
refresh.

Based on Eugenio's patch [0].

[0] https://lore.kernel.org/lkml/20230112142218.725622-4-eperezma@redhat.com/

Acked-by: Jason Wang <jasowang@redhat.com>
Suggested-by: Eugenio Pérez <eperezma@redhat.com>
Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/core/mr.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index fcb6ae32e9ed..587300e7c18e 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -590,11 +590,19 @@ int mlx5_vdpa_update_cvq_iotlb(struct mlx5_vdpa_dev *mvdev,
 				struct vhost_iotlb *iotlb,
 				unsigned int asid)
 {
+	int err;
+
 	if (mvdev->group2asid[MLX5_VDPA_CVQ_GROUP] != asid)
 		return 0;
 
+	spin_lock(&mvdev->cvq.iommu_lock);
+
 	prune_iotlb(mvdev);
-	return dup_iotlb(mvdev, iotlb);
+	err = dup_iotlb(mvdev, iotlb);
+
+	spin_unlock(&mvdev->cvq.iommu_lock);
+
+	return err;
 }
 
 int mlx5_vdpa_create_dma_mr(struct mlx5_vdpa_dev *mvdev)
-- 
2.41.0

