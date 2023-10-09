Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F2B7BD9B0
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 13:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346286AbjJIL0o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 07:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346390AbjJIL0L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 07:26:11 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBE01B5;
        Mon,  9 Oct 2023 04:25:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bowwe30t+StjCjy5iQfi4XfLyXhV7dVudffAvh57eHsmxaraCxOB3SsPOSyaBqNyaXMs2Ng7BlSRfnClgT8e9glXOL6X2o4+8MaGOBRS/upFkUGt2GmJ4BVU8OvklErup+9RIwTBmfrqiixPzXSfN+3hSfwSJf6demJsiKSLMwzel9xP0o8M23E1wTbDo9+rm0fh1Dwr+xmoomHVwEn7ixamQGHMnkVRqc4FcyZNeKt3d+ljoN8m5Qaz7jN/nr5kp8DJSuIFQpTFX9c0B+tFK6MHE6yJzyid+s7lGIMPxFzotiBCOtwzWHfndD6pvvyH66W6VEG+yTyoXGUUqj/ArA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n+I3U15Hi59woTFRPbH5j837sff+uPVTo/I0JiXr6qk=;
 b=kunyezStVwuYQHX8GEXZFRmh3bgpDBHVjzU19X35Wg5TrJdBN/FkN7gKERs+rJcIFvvn2GF/kZWPAr1kAoCs06vDoT8rtgBYWS98Kn6NkEbTgudYEq/iMXjoJ+zyZYbWv3SacrRAZhGeJGxqtQGsQa8G/4j6O7VzAunM/Q8EOgNVVfQYYu6tQg5TCR/L37Tekci96IcePIZpUBF/C29LSupj/8vkdkxGzL//9k7ZLtNuxVoC1aWr1LszExCxF0p+IiPXqrORc/m61QF6DSeg13pUlcJ47kPEiZGI69bSEwAqvlYdUgwFCZdQ2IqRrgNWQSxjEaFtLwo4U8VwcDxiiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+I3U15Hi59woTFRPbH5j837sff+uPVTo/I0JiXr6qk=;
 b=Eg+YMQuD97q+R3+Aia9ooJavyDI4h66sZc/nWTPgl6WUNl75srEaA8tJlfdFGKc5wdITrVRgV5UAyms8Xp4LkdnQev4UqG6iw7Q0PO4v5SgcNUZdMrfuf/VeY5mGfqiOVeHyFJz60du9e5rFXKr7TdqdGWGu46ioVbRscBcYxQN24c7yYcf7bskF/OnOGB98Z63sCBv9YHmxTabm1DWj0X+bTizAQ7ZWL2KPpgJz5bHRTkdlx4S62egZ+MkAFckY3LVo88Z7tXRp+8h7xo/ZpLaTBNYUkpb2GSpU9wIpW6BpEhVWoGAGFj/vrdrURIJrcvtzkqogOLO02UAsdquNlg==
Received: from BL1PR13CA0375.namprd13.prod.outlook.com (2603:10b6:208:2c0::20)
 by BL1PR12MB5175.namprd12.prod.outlook.com (2603:10b6:208:318::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Mon, 9 Oct
 2023 11:25:31 +0000
Received: from MN1PEPF0000ECDB.namprd02.prod.outlook.com
 (2603:10b6:208:2c0:cafe::19) by BL1PR13CA0375.outlook.office365.com
 (2603:10b6:208:2c0::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.20 via Frontend
 Transport; Mon, 9 Oct 2023 11:25:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000ECDB.mail.protection.outlook.com (10.167.242.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.18 via Frontend Transport; Mon, 9 Oct 2023 11:25:30 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:25:12 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:25:12 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Mon, 9 Oct 2023 04:25:09 -0700
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
Subject: [PATCH vhost v3 15/16] vdpa/mlx5: Make iotlb helper functions more generic
Date:   Mon, 9 Oct 2023 14:24:00 +0300
Message-ID: <20231009112401.1060447-16-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231009112401.1060447-1-dtatulea@nvidia.com>
References: <20231009112401.1060447-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDB:EE_|BL1PR12MB5175:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bf27568-5830-40c9-de08-08dbc8ba724b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SLn3o87QY/dkPzvhaJhBJJ+BOIi5zul4S3GDgvyqeI7oUsTOqJ1RWELdfyUcvf30iP/DHeHjBG9IYvHv/5Jf8MO5blBE/VfFlrZTXwkQNhRuH0enhwyqsADxK1otLRDjsBJ5ZtNwoByi0KDN4q4lXZev1cvnccfJ6NmBmm276JBjDyI5mZMzdZ9cD3fNQ/NpNGswgq0ViJqYenFthbPFoV17G55RZEqQjESjQLhEir7ok0T/Dz8kZ+Y5AZsqrefETEAvGodv8zMtqvT5KwcgZsXtJBm3+kHGZ94TJdHkYn0mb28RLS0wi0GzLnCZA8Psnw/FeuMcl+u3Q24LrsiQnMfnHhEKZZsLh+kzMB50vNoxMq4vhb+vz6ihF60dcxOhlkUPQBCSOF6Uw73N0+Yo/m1NjuYMtefz3mxICX7EaXoM1fYunUdhgOm9N6ak7430/4BIsUbD0L/+zCs7MvJJO5rR+BwH0CZAty9ygTauVMCXNVdCBY3D5hGd3IYQ5qYgmmaeiuZ0AyIlaHdwRU26gd/cnpIkmk+yIExcJIabY5PiaxvjvtCs/SQ3livk/sA2qkmjjXQyw9pS2IOABispJsruyH0A+4cV0kOuACq1NQTwtlM+7YmGNMFizWiJ/WyLtqTcnKpxZCv0WymfMjrtRuk4NE0Ses9h9s4PRo2j8LCXCP2A3/t1CjqT6XwOFROBmpbXA25PGHjdraPbgvioKHHRWw/NVU7uh06IDGPUsbw4tmkwIrxWKht+26KFDtk4WEkJDApImWG2gUhz3CBLUw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(396003)(376002)(39860400002)(230922051799003)(1800799009)(82310400011)(64100799003)(451199024)(186009)(40470700004)(46966006)(36840700001)(7636003)(356005)(86362001)(36756003)(40460700003)(40480700001)(2906002)(478600001)(82740400003)(5660300002)(4326008)(8936002)(8676002)(41300700001)(6666004)(83380400001)(426003)(336012)(2616005)(1076003)(36860700001)(110136005)(70586007)(70206006)(54906003)(316002)(26005)(47076005)(66574015)(41533002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2023 11:25:30.7916
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bf27568-5830-40c9-de08-08dbc8ba724b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: MN1PEPF0000ECDB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5175
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

They will be used in a follow-up patch.

For dup_iotlb, avoid the src == dst case. This is an error.

Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/core/mr.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 3dee6d9bed6b..4a3df865df40 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -454,20 +454,23 @@ static void destroy_dma_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr)
 	mlx5_vdpa_destroy_mkey(mvdev, mr->mkey);
 }
 
-static int dup_iotlb(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *src)
+static int dup_iotlb(struct vhost_iotlb *dst, struct vhost_iotlb *src)
 {
 	struct vhost_iotlb_map *map;
 	u64 start = 0, last = ULLONG_MAX;
 	int err;
 
+	if (dst == src)
+		return -EINVAL;
+
 	if (!src) {
-		err = vhost_iotlb_add_range(mvdev->cvq.iotlb, start, last, start, VHOST_ACCESS_RW);
+		err = vhost_iotlb_add_range(dst, start, last, start, VHOST_ACCESS_RW);
 		return err;
 	}
 
 	for (map = vhost_iotlb_itree_first(src, start, last); map;
 		map = vhost_iotlb_itree_next(map, start, last)) {
-		err = vhost_iotlb_add_range(mvdev->cvq.iotlb, map->start, map->last,
+		err = vhost_iotlb_add_range(dst, map->start, map->last,
 					    map->addr, map->perm);
 		if (err)
 			return err;
@@ -475,9 +478,9 @@ static int dup_iotlb(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *src)
 	return 0;
 }
 
-static void prune_iotlb(struct mlx5_vdpa_dev *mvdev)
+static void prune_iotlb(struct vhost_iotlb *iotlb)
 {
-	vhost_iotlb_del_range(mvdev->cvq.iotlb, 0, ULLONG_MAX);
+	vhost_iotlb_del_range(iotlb, 0, ULLONG_MAX);
 }
 
 static void destroy_user_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr)
@@ -544,7 +547,7 @@ void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
 	for (int i = 0; i < MLX5_VDPA_NUM_AS; i++)
 		mlx5_vdpa_destroy_mr(mvdev, mvdev->mr[i]);
 
-	prune_iotlb(mvdev);
+	prune_iotlb(mvdev->cvq.iotlb);
 }
 
 static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
@@ -596,8 +599,8 @@ int mlx5_vdpa_update_cvq_iotlb(struct mlx5_vdpa_dev *mvdev,
 
 	spin_lock(&mvdev->cvq.iommu_lock);
 
-	prune_iotlb(mvdev);
-	err = dup_iotlb(mvdev, iotlb);
+	prune_iotlb(mvdev->cvq.iotlb);
+	err = dup_iotlb(mvdev->cvq.iotlb, iotlb);
 
 	spin_unlock(&mvdev->cvq.iommu_lock);
 
-- 
2.41.0

