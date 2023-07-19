Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21F575A201
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 00:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbjGSWfw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 18:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbjGSWfu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 18:35:50 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20615.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::615])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A481FE6;
        Wed, 19 Jul 2023 15:35:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OzKzSs36rxzn0c7QLHHByKvuMXmk6UyCUhMyqJ7CDxEkYC5KzTAP73l/cs5V5utzk45mJK6MP8rd/jPKWY9z716pgXd2o7pmw4net5HzRLOR3DGSb5eBHMc70wPLUV3sQrI0lfoBdqLTWKT2thunB8MjWF8SZS468hTfZ0NoDiDCXI3CofWfmum4aQcI+n1kTLbRBkp+5s9t6NYahBRWs8eqjc+jLe5kf7EbZsffu2xPmjRn2JbNUMj0wDdtfEWZ7ZEFlT8Vd+aiJ7H4r7AR3dvIu5kTOqL5WmnGd+m0q3my4UeeySWfpcGCgYNh236O0F7v/DdsUhoAHQMHixruzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ySOn0UHJNptpXXPBGLj3BDqJ81Vo9WUO8xq2SoXTbbk=;
 b=GeqjCoCE8Wuhw/Ki+OtxcYPpcb/D/0McdKBMALoPoO6bzaa1YB7RAYMBe/N6G1lrWb+b0MTcdIaY+i6kPTReOgjv0+LI5cbMfB4hJB6oCQa0L9ZAIZ3Y+VPvpFbGFGuZWczN1mURQGtDxYa2wQsSgmYoCNAIGdD6e4maXn61qVgBBN82KlmEaKvJj8fcrK7YwDRi9F89Oy1vZPeHrcwb/k+UwVtSmx8PROWILlYxKOAUnVJWx5nG5FJ9qCylkgHRT3M+cFagH80hY/XcQD7HKDXC43egucRZygjMwiti4BwdPRZJ7BxJzd7jk33ZyCPjKyXWJcf7qXW4nJJ4UGaGFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ySOn0UHJNptpXXPBGLj3BDqJ81Vo9WUO8xq2SoXTbbk=;
 b=vlaGXTnWNZ0PNzlZi4yMo1OxTmPGzhfdq/KBbnHEBb5cLqsMjUslKI0vtbWzJ1ZEeShvnQ+qDajVWsh+xgM+KLoM0dD9VfMOjhLPwVhq/uk0uUjyNuMPOTwxCO5UQgSK3j5+doov/B3Kwtu2akLhd4SRkhzGILDL+LFCsOQ9wN8=
Received: from BN8PR07CA0013.namprd07.prod.outlook.com (2603:10b6:408:ac::26)
 by PH7PR12MB8793.namprd12.prod.outlook.com (2603:10b6:510:27a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.24; Wed, 19 Jul
 2023 22:35:43 +0000
Received: from BN8NAM11FT072.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ac:cafe::ab) by BN8PR07CA0013.outlook.office365.com
 (2603:10b6:408:ac::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.24 via Frontend
 Transport; Wed, 19 Jul 2023 22:35:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT072.mail.protection.outlook.com (10.13.176.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6588.34 via Frontend Transport; Wed, 19 Jul 2023 22:35:42 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 19 Jul
 2023 17:35:41 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH v12 vfio 1/7] vfio: Commonize combine_ranges for use in other VFIO drivers
Date:   Wed, 19 Jul 2023 15:35:21 -0700
Message-ID: <20230719223527.12795-2-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230719223527.12795-1-brett.creeley@amd.com>
References: <20230719223527.12795-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT072:EE_|PH7PR12MB8793:EE_
X-MS-Office365-Filtering-Correlation-Id: 239fed58-7562-4a30-cb20-08db88a87c8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bg6/sufR41Mpc/co+8ESVpD6uhYMY/gYewxVOApNqTvL/LlapgD16Zc4Y6rKLwT54aeMd3UCFyBPeCHAOG2Iy0PlFVbHu3eF9gS59dYjzm4sD6I0tGqXmcY533MhC2MI7xdDs01KsWLoQToOPwgnM3qlUSRFh0AisSwE7AwPgoinDexKRjAiaREOxuR+ocboScrnCgbHiomagMInt0/FcXNcMNxmwl8bR7qfM8p9ej45hWHl/EQZ05D9jb6U/XEqEQhqAaMZmd+MsA/t0d6LEnsxf42MSZ6EiH2vuOgxGuB+qnrZMGEwGbntp0G3ZYEA05p2BOgm3Cu5PWVXKQdgehhSrjMxd9/U6MlASxyHtHeQJ4KwhNKmo+krtZten2rNkhD4TzGthrs40xOYFYMXwHgXirOHhXQg+/tEbXNjZ/jWBq8h4fDzZJptCBCly6lI2CCRHGzzSs6t+B8yuuRxStmuOf6jpbxaH5Dy+szH9w7iZ7UjAWk8+9rHTQrV6d1r5LJeMT7gE8RCi1wArdkYAbVcftRUmKv02zRo0E0vDgyg4FPIhtnl8FwI77Bvny3eLIdzcS8NLiFy9PkYDdbdKza9bwrLfSMCKF95llcf64+ZT2trl8TIummwuh4ACGILia7TeUomt39DVFlGFnkKmp378KsrXOIJRjovs2MsncTwFJ3n3PvnBk0GLJDukphzydwu2XxxdcQP/ZViTWa8SN3d2a07FkKjfd3KQ+BOdWwklZBpwVrR5JcUVWg2bBlTP5pPhJsXj5UDKsAhihYwSA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(396003)(136003)(82310400008)(451199021)(46966006)(36840700001)(40470700004)(1076003)(26005)(186003)(336012)(478600001)(70206006)(70586007)(316002)(4326008)(16526019)(41300700001)(86362001)(6666004)(8676002)(8936002)(44832011)(54906003)(110136005)(5660300002)(36756003)(2616005)(426003)(2906002)(36860700001)(40460700003)(83380400001)(47076005)(66899021)(40480700001)(82740400003)(81166007)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2023 22:35:42.8139
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 239fed58-7562-4a30-cb20-08db88a87c8d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT072.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8793
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently only Mellanox uses the combine_ranges function. The
new pds_vfio driver also needs this function. So, move it to
a common location for other vendor drivers to use.

Also, Simon Harmon noticed that RCT ordering was not followed
for vfio_combin_iova_ranges(), so fix that.

Cc: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 48 +------------------------------------
 drivers/vfio/vfio_main.c    | 47 ++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h        |  3 +++
 3 files changed, 51 insertions(+), 47 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index deed156e6165..7f6c51992a15 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -732,52 +732,6 @@ void mlx5fv_cmd_clean_migf_resources(struct mlx5_vf_migration_file *migf)
 	mlx5vf_cmd_dealloc_pd(migf);
 }
 
-static void combine_ranges(struct rb_root_cached *root, u32 cur_nodes,
-			   u32 req_nodes)
-{
-	struct interval_tree_node *prev, *curr, *comb_start, *comb_end;
-	unsigned long min_gap;
-	unsigned long curr_gap;
-
-	/* Special shortcut when a single range is required */
-	if (req_nodes == 1) {
-		unsigned long last;
-
-		curr = comb_start = interval_tree_iter_first(root, 0, ULONG_MAX);
-		while (curr) {
-			last = curr->last;
-			prev = curr;
-			curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
-			if (prev != comb_start)
-				interval_tree_remove(prev, root);
-		}
-		comb_start->last = last;
-		return;
-	}
-
-	/* Combine ranges which have the smallest gap */
-	while (cur_nodes > req_nodes) {
-		prev = NULL;
-		min_gap = ULONG_MAX;
-		curr = interval_tree_iter_first(root, 0, ULONG_MAX);
-		while (curr) {
-			if (prev) {
-				curr_gap = curr->start - prev->last;
-				if (curr_gap < min_gap) {
-					min_gap = curr_gap;
-					comb_start = prev;
-					comb_end = curr;
-				}
-			}
-			prev = curr;
-			curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
-		}
-		comb_start->last = comb_end->last;
-		interval_tree_remove(comb_end, root);
-		cur_nodes--;
-	}
-}
-
 static int mlx5vf_create_tracker(struct mlx5_core_dev *mdev,
 				 struct mlx5vf_pci_core_device *mvdev,
 				 struct rb_root_cached *ranges, u32 nnodes)
@@ -800,7 +754,7 @@ static int mlx5vf_create_tracker(struct mlx5_core_dev *mdev,
 	int i;
 
 	if (num_ranges > max_num_range) {
-		combine_ranges(ranges, nnodes, max_num_range);
+		vfio_combine_iova_ranges(ranges, nnodes, max_num_range);
 		num_ranges = max_num_range;
 	}
 
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index f0ca33b2e1df..3bde62f7e08b 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -865,6 +865,53 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
 	return 0;
 }
 
+void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
+			      u32 req_nodes)
+{
+	struct interval_tree_node *prev, *curr, *comb_start, *comb_end;
+	unsigned long min_gap, curr_gap;
+
+	/* Special shortcut when a single range is required */
+	if (req_nodes == 1) {
+		unsigned long last;
+
+		comb_start = interval_tree_iter_first(root, 0, ULONG_MAX);
+		curr = comb_start;
+		while (curr) {
+			last = curr->last;
+			prev = curr;
+			curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
+			if (prev != comb_start)
+				interval_tree_remove(prev, root);
+		}
+		comb_start->last = last;
+		return;
+	}
+
+	/* Combine ranges which have the smallest gap */
+	while (cur_nodes > req_nodes) {
+		prev = NULL;
+		min_gap = ULONG_MAX;
+		curr = interval_tree_iter_first(root, 0, ULONG_MAX);
+		while (curr) {
+			if (prev) {
+				curr_gap = curr->start - prev->last;
+				if (curr_gap < min_gap) {
+					min_gap = curr_gap;
+					comb_start = prev;
+					comb_end = curr;
+				}
+			}
+			prev = curr;
+			curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
+		}
+		comb_start->last = comb_end->last;
+		interval_tree_remove(comb_end, root);
+		cur_nodes--;
+	}
+}
+EXPORT_SYMBOL_GPL(vfio_combine_iova_ranges);
+
 /* Ranges should fit into a single kernel page */
 #define LOG_MAX_RANGES \
 	(PAGE_SIZE / sizeof(struct vfio_device_feature_dma_logging_range))
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 2c137ea94a3e..f49933b63ac3 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -245,6 +245,9 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 			    enum vfio_device_mig_state new_fsm,
 			    enum vfio_device_mig_state *next_fsm);
 
+void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
+			      u32 req_nodes);
+
 /*
  * External user API
  */
-- 
2.17.1

