Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D57927CE432
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 19:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbjJRRQl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 13:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235146AbjJRRQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 13:16:28 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2077.outbound.protection.outlook.com [40.107.243.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3BED4F;
        Wed, 18 Oct 2023 10:16:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RODKhLcytcyJmaRu1MEW/3wFEeBr+qRc1ykeaFRtAyiampr2eQARjgrD9pO2G9NZQ8lQC7lL9e3y0FW1YQMjeVUHj6qJZe0CeDLEgnRAGuqCeR6JPAC2npLdHQIyyqKyf/xnZnLEcc2tO3VBcq/ViSQTxRqDhAEuVwBXL0K4J7rXO6P9PcQW8epXbB+kX5GY58+h2t0fzX4cEdZDi2LwnqVrB8SiltHF6HmVdshV2sl3A38Bco9QHIzqMnR6EyYLLvw5q41F38Sk86a9/v64IJ8z+lPXLV25qzjY+/ezHz9Vw/Nt+xRB+54J8HGvoxR3wXy35YEGrzbbOrJZiN+/Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=elzKdMTRh3uezwMcgzMejLd/DLpkMeh3g8HOvOAJXm0=;
 b=PTfAczDB5IutLYWhcuL1J25MtESt5vBfnjRezGDhrQDisu7R8E1w9jMiuRlqs+dk/bWlSl87wBdnEer8x/2npWQVOFS9dbW8ReNw4p5o8DhgyAwEWLNHLaUhhIvcTnzlLBHCLpyrhHZ/GqQeQesbeKjsTeuclk8wpHlu6x8ln54pjwryXcJI4de7C2DlHLmvPQZWrL6f4QDS/RWMP8dddFR8nbpX+3R0zqfQtm9ZNWJyf8/lewl8+yEEOiAD+D9HrV0b0cryhHvTjGZZpYP/8BKdlONewbaZuBlJmmbObeP6fl59jbVN8nDol047IkNn4xQnVJ4Xj/vrqFTrxAc0ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=elzKdMTRh3uezwMcgzMejLd/DLpkMeh3g8HOvOAJXm0=;
 b=KUTXn69/fiQrTcGUbeWTKJUCpB+Xjs3LTyFzwlli6YGtU0epVfL2J41TFVQHGhH07SB151l+v35q85aNm5OXcmgONi+RrtvAPF+0eHzybZ85yW2HIPKrkL72AXsyQ+YCn6cAhtx0VQQDc7bSiBryLyu7DtYvVCy4vKQppNKn0+pApCuRr4Y1oTOtbgtwPJvqtygQTSAV06klydaWm9Z9IBq1wpr8J9gVC3H1JjY3JV85mlSaH/P+dQOS85yk6ff9INO8Qj38yjg8Hgc+EnNvLG8R4KUZ6WrKTYnJlO2GFxu4vZ9KQKNhAm2fMfHhY+ga/Wua+YyLk7vbg4ClZTjKfQ==
Received: from CH2PR17CA0015.namprd17.prod.outlook.com (2603:10b6:610:53::25)
 by SA0PR12MB4573.namprd12.prod.outlook.com (2603:10b6:806:9c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.24; Wed, 18 Oct
 2023 17:16:09 +0000
Received: from DS2PEPF00003442.namprd04.prod.outlook.com
 (2603:10b6:610:53:cafe::6c) by CH2PR17CA0015.outlook.office365.com
 (2603:10b6:610:53::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21 via Frontend
 Transport; Wed, 18 Oct 2023 17:16:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS2PEPF00003442.mail.protection.outlook.com (10.167.17.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.21 via Frontend Transport; Wed, 18 Oct 2023 17:16:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:15:55 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:15:54 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Wed, 18 Oct 2023 10:15:52 -0700
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
Subject: [PATCH vhost v4 08/16] vdpa/mlx5: Collapse "dvq" mr add/delete functions
Date:   Wed, 18 Oct 2023 20:14:47 +0300
Message-ID: <20231018171456.1624030-10-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231018171456.1624030-2-dtatulea@nvidia.com>
References: <20231018171456.1624030-2-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003442:EE_|SA0PR12MB4573:EE_
X-MS-Office365-Filtering-Correlation-Id: a8802d4e-9112-4cfe-0908-08dbcffdeb9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +LwgzQrvSPtrOmmiOo4wqw5eAgP1JlQGuBRoI092gF3A2sGkqiKj9+GOXD/4Qwq7FiXc9+vXGnH2sMI4fMCImifaLCUKlpcRws9HbfpAtyI9nOjvvZmqMS33AhoI1zCsl2sL9vsoOfYiz17mDLc8A2JnjXze28BH3JRbKqoZ6mHlYGSX7FAP76FC01sJUkbpqXN0+OGpWe7K7A13B0F/LiSwHP8AFXE5TMURoZ/2OAw1878//0+TjHn84BfAEAJS3qB5+KepmyerERt6wU5DUq02k05zARPlZQyhF2c1cSqKqoIllqkeGuu3UYx6WxWmsY/d9uEdFWr5vXV3tDEt4noA4j05kxQ29/3t5fioNdGwjR+eBEi88IxuBuUNSGRrRIGX2EByoxHfUFS19qUwD8sj0D3WG4AkAnjy7MdbOPuRyzGSdaHSkpe38Bc3U28SybYVnd17if6q40/uzWGJZmbKVNJi5JQXaDatp8wX0GwqQmn98HEA+SwNxl4zTJKOv8fpah0BKlHp5RbGlx29MZfS7Fe69IZ7hXft+roFRwxNivQ2hm3ZgzABtvGo/f7xiYblr8yRLDtqjhGtr+vxVwB6TQWeFxoVoO7hIXKSCLxHwIuZ0G0MOzm0J460H/Ljxu66IoVabK3p7BLvgFE5W7N2efVNWV2b+EgXG+lvMKpGwv2997OmVoAZArJG++5BpvXyLHqt5aI1IZoT5q4UFZ0ka9+0HCR3FKchhuXiuYilo5cb8wsFLR+KunpKlwwC
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(136003)(346002)(376002)(230922051799003)(186009)(1800799009)(451199024)(82310400011)(64100799003)(46966006)(36840700001)(40470700004)(83380400001)(40460700003)(40480700001)(36756003)(2616005)(316002)(1076003)(2906002)(86362001)(110136005)(70206006)(41300700001)(54906003)(5660300002)(4326008)(8676002)(8936002)(70586007)(478600001)(6666004)(336012)(426003)(66574015)(7636003)(356005)(26005)(82740400003)(36860700001)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 17:16:08.8172
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a8802d4e-9112-4cfe-0908-08dbcffdeb9e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF00003442.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4573
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the cvq code is out of mlx5_vdpa_create/destroy_mr, the "dvq"
functions can be folded into their callers.

Having "dvq" in the naming will no longer be accurate in the downstream
patches.

Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/core/mr.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 587300e7c18e..fde00497f4ad 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -489,7 +489,7 @@ static void destroy_user_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr
 	}
 }
 
-static void _mlx5_vdpa_destroy_dvq_mr(struct mlx5_vdpa_dev *mvdev, unsigned int asid)
+static void _mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, unsigned int asid)
 {
 	struct mlx5_vdpa_mr *mr = &mvdev->mr;
 
@@ -513,7 +513,7 @@ void mlx5_vdpa_destroy_mr_asid(struct mlx5_vdpa_dev *mvdev, unsigned int asid)
 
 	mutex_lock(&mr->mkey_mtx);
 
-	_mlx5_vdpa_destroy_dvq_mr(mvdev, asid);
+	_mlx5_vdpa_destroy_mr(mvdev, asid);
 
 	mutex_unlock(&mr->mkey_mtx);
 }
@@ -524,9 +524,9 @@ void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev)
 	prune_iotlb(mvdev);
 }
 
-static int _mlx5_vdpa_create_dvq_mr(struct mlx5_vdpa_dev *mvdev,
-				    struct vhost_iotlb *iotlb,
-				    unsigned int asid)
+static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
+				struct vhost_iotlb *iotlb,
+				unsigned int asid)
 {
 	struct mlx5_vdpa_mr *mr = &mvdev->mr;
 	int err;
@@ -550,12 +550,6 @@ static int _mlx5_vdpa_create_dvq_mr(struct mlx5_vdpa_dev *mvdev,
 	return 0;
 }
 
-static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
-				struct vhost_iotlb *iotlb, unsigned int asid)
-{
-	return _mlx5_vdpa_create_dvq_mr(mvdev, iotlb, asid);
-}
-
 int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 			unsigned int asid)
 {
-- 
2.41.0

