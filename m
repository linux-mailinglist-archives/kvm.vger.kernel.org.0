Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 161ED79D1A1
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 15:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235560AbjILNCz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 09:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235368AbjILNCl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 09:02:41 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A16171F;
        Tue, 12 Sep 2023 06:02:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OoTOi8l8Azx4HoDXCTWijrwc/hISfVa98YRLex8Wzls1aMEZxYxD27g/8eoWK8jY0UsBCprAlyvJRX8A0mD2Cv4ddyUyjGEe0Vjc38/7nAr/lQFIAPrsg6DRJtQZki1NZ2+ObvuzRDPAmVioMKW2lSlN5uLlE6aOA1d3vBbI6JWsYYCao2RPEww8EEOAyVE7mSkbEHHYJAiDzK2hlDouuEzi5CGHkAbuC18dB2viv+DsDbYVBs+YDNPb4Uvs8dNb9kBOYQTwAmaqaD/X98m8uCZkvjOZVajnYl440ffL70eJ1fsNfiEEpkNk7K0Cm71yLLQQ+zapQv3SIVZLjzRyKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Lxqw3vEum+sAo6sz+mvsLL7IKb6ap0tYsx2z9NbvuI=;
 b=dnFwaQ52tQAMBE9Nv0RM1/CP+9M1Z5YhLy19FwXAfoUMa0jRI86h5FhH2o3iu1InXF0vFH+PFAisVeskqV0+7tQs1YnynCwVJevuVXSG31MxhS4J6Nezem4RT+L4RETF7TOLZUMZ2syAQCutgsaXIsYSPdIkA+bFC8gI7zHTrdMKfldjO/hdc9SGDu86onGkHCGrdJgz+/ZWpXZREp2rcNSBQyT3Ah8eCYjcChFXx64srKSESXZ/V0e/4SSXicRtGgCEtgKBg5OgyjE7aEAeDenAGbmE8ObRpPyq24KEb4s7cMt8B7AFNroF7EDEUYWuN68r8cMABu1RgeM0ga5bHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Lxqw3vEum+sAo6sz+mvsLL7IKb6ap0tYsx2z9NbvuI=;
 b=ZUsTtdVdBSyMO4PZIYVEHeYcKHuWA+My+qx4i6NqfZCxzc3n1GQy2bRz79289dgIl7Nun6mgVjsxBKuMREBMvFVYaCpFD6Ikon3//cNL4m+hD1QhqQ76IVxq95YqdDkIYtAE95E9UO/SQOPuLjetrMy2RMzVlxl+KpEVFY+Lu94YEdx2X5DC8C3wGjY4fy7dZ1do7DdsdM6v7B+EXPpqFTVsBmtA4mEAaoUY6/a5TMSLNQrzmmg3VCO1TKTxBM7PXYg2y95ml2I0EnLBENQVLGOK7Spa2lzlUzr+bbX7o7gpmlC2LqciriDSsmN/Gqwy4yQCnh9pjcZ5T8i/LLsRSg==
Received: from DM6PR14CA0053.namprd14.prod.outlook.com (2603:10b6:5:18f::30)
 by SJ2PR12MB8690.namprd12.prod.outlook.com (2603:10b6:a03:540::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.33; Tue, 12 Sep
 2023 13:02:19 +0000
Received: from CY4PEPF0000E9D9.namprd05.prod.outlook.com
 (2603:10b6:5:18f:cafe::bc) by DM6PR14CA0053.outlook.office365.com
 (2603:10b6:5:18f::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.38 via Frontend
 Transport; Tue, 12 Sep 2023 13:02:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9D9.mail.protection.outlook.com (10.167.241.77) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.17 via Frontend Transport; Tue, 12 Sep 2023 13:02:19 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 12 Sep 2023
 06:02:10 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 12 Sep
 2023 06:02:09 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.37 via
 Frontend Transport; Tue, 12 Sep 2023 06:02:07 -0700
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
Subject: [PATCH 07/16] vdpa/mlx5: Collapse "dvq" mr add/delete functions
Date:   Tue, 12 Sep 2023 16:01:17 +0300
Message-ID: <20230912130132.561193-8-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912130132.561193-1-dtatulea@nvidia.com>
References: <20230912130132.561193-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D9:EE_|SJ2PR12MB8690:EE_
X-MS-Office365-Filtering-Correlation-Id: be287ad6-c996-4521-63dc-08dbb3907f3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 21T2myxIC7T4JtUsISqAWVb6wyDvbGSduxWNiq1DuE97r0r1CABCWMcNpnywp0TuLRGwZ6l/FMmVSIx/hozgA58p1eeIjD8pMRe9rTy7+qg6ArtmXal1Bip6zJCYzr9lIzMgMbrKviQqgsNy2dWtYsdet+BeD5OQ+N1YEKfs1WqqkJQyd9fOzHZAAwkXASs/Ey652ExeT/5PmMEHm0TB4u5pZeMwBDGuaze0swys4NBq9TOibeMspOjnb9NBt7JN0WSromACj2Ex+AW4TLjHLbMeXzLwSKFx0M+DgKjcoXzLt6cdMjkSWH5vSW47ojWyS8izpjr7od+DRRMnrLhYZuBkVo6xydkUA3Zj/Op7AiNk7N5wxm7ui3vdDnt29OTl5JTLueE5Dwk+aovLvXfnQwxNXVgA30MigvpIuAU+DkOGop8MLzGHZKfikDO3JbKVs6+oeAmSHPlerKY5BuEmDOmzfW0a4nKmnltUpYp04AaTJCir17ZiD6BGwPNNfkat+x3hYukeVK5ZZEolKP43f3r7G4etjEnL+vQ9VllKur9SA5rMSxJXYa8CsT2nLMflj6r5PFWfkaVc9TOGGcUHS1+nVUGpMgK1TCkUWBTtuAKPx812ElFrTaoO7yKEkXFiaVacJ91fo7CI7U5MENdINAwKocf5OUnkeUeYdfogNBBJuIEevuXyEM4op1YSXCThatLYtptBMhwyETQmBvxbbE6NTMZo7Ss1jmUnEpfSpohfV3GdzNmo+PLVHDySoMPC
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(346002)(39860400002)(396003)(186009)(451199024)(1800799009)(82310400011)(40470700004)(46966006)(36840700001)(478600001)(8676002)(336012)(40460700003)(36756003)(86362001)(82740400003)(356005)(7636003)(5660300002)(40480700001)(316002)(36860700001)(47076005)(83380400001)(4326008)(8936002)(2906002)(110136005)(426003)(41300700001)(26005)(2616005)(54906003)(6666004)(1076003)(70586007)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 13:02:19.2821
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be287ad6-c996-4521-63dc-08dbb3907f3c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8690
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the cvq code is out of mlx5_vdpa_create/destroy_mr, the "dvq"
functions can be folded into their callers.

Having "dvq" in the naming will no longer be accurate in the downstream
patches.

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

