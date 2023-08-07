Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4F727730C1
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 22:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjHGU61 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 16:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjHGU6Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 16:58:25 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2053.outbound.protection.outlook.com [40.107.212.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A8810D5;
        Mon,  7 Aug 2023 13:58:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bvVckB0tFADbX+epA7d36xgaLXdoSsgcHxRfKt4W2//S3GGHEXLMzFpLQCbcF1c+2B6rwojJ6cwmsSYpl2n5uIPRQAUPBELVlp+Z6CnwmiwCjMQkZBemUy/sAHP/NrKGDFBapf6tWFKmc3v01NMrqcFYFuOe0BEqbzzg72wWRf4WunaxXxJF2G8fIWwP6KHwCc4eGoh2JckDjLXZ+UB5yOmhbv4v7DSOQo0JOLIKOzhk8uoHVJlB7FxjnXM1Bs2qogsUoLOWegDMdijLv+lU8ojIAfVAxdF8uHXeybB7G/zkHnJVCz2CtmjBs32RhUlI16/Ptd6MP1g5OLUePIAPTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wDpDY5fUS1Lx3GNO79rTy8P0Z2z0ykX5trnYpkdvkUE=;
 b=O7Qhhxl38uGErSibKRCXpIQsWFLEWSFIuCXfML0nL/mFFBg48u53tLZdegWg+MGkOOR8tqEbTfhdQ9exqvm+UEoD3u9x0ccPsQiCGax4UbpgnZ/NLKyxVf0cTB5AAPOJCksJpfkcADkNS38dtZN6P/OJCxzCMPdMhARfKa2AnhwiIXpos/k15xHCp1QqP6VjNU3xQMB8J1Lv66lChQlNvT05lsJUO53yKi2VQGKY3LqokN3CSuDvTUG2MhrbiPzrxDC2ZeHn7QDDqhCosUj8sI/35Xm3pi6R+ct/DroLRuN0J2rJI8xHWqcYXMY/a68vwRVUwvgG7ZSDrFy5DEse3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wDpDY5fUS1Lx3GNO79rTy8P0Z2z0ykX5trnYpkdvkUE=;
 b=WaGRMYbMndyNq+Z39omClV4dp6iAzXQ8hUOczHSiYDjiPawriB++Ni4oRNjt1qePHwc5tUMoivHMcsU8j9x5IOe3Iu7z6rk4yiRRFK1pSQNNOkMxSThGrk9B7TSECWDzcLwvz+wBEuGk22PC4XVawrUAmTaOkXlOMj9avpUy53E=
Received: from BY3PR05CA0050.namprd05.prod.outlook.com (2603:10b6:a03:39b::25)
 by SA0PR12MB4544.namprd12.prod.outlook.com (2603:10b6:806:70::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.25; Mon, 7 Aug
 2023 20:58:17 +0000
Received: from MWH0EPF000989E6.namprd02.prod.outlook.com
 (2603:10b6:a03:39b:cafe::6e) by BY3PR05CA0050.outlook.office365.com
 (2603:10b6:a03:39b::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.16 via Frontend
 Transport; Mon, 7 Aug 2023 20:58:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989E6.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6652.20 via Frontend Transport; Mon, 7 Aug 2023 20:58:20 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 7 Aug
 2023 15:58:17 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <horms@kernel.org>, <brett.creeley@amd.com>,
        <shannon.nelson@amd.com>
Subject: [PATCH v14 vfio 1/8] vfio: Commonize combine_ranges for use in other VFIO drivers
Date:   Mon, 7 Aug 2023 13:57:48 -0700
Message-ID: <20230807205755.29579-2-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230807205755.29579-1-brett.creeley@amd.com>
References: <20230807205755.29579-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E6:EE_|SA0PR12MB4544:EE_
X-MS-Office365-Filtering-Correlation-Id: 53d3d6a6-3dd0-4380-43a8-08db978907e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lf03OCizIM95Lj5ncjsYrSTcWPMlRDPS13jZzQN5g97yUCbKDt3ty1v35nL/oIQBhlovW0hUzpsB67lSKZDAFrsfNe0dj65Jstj0mBK1Jd69ELm6ec+HNqqgV3q2lUXq4qVFrI4wtXTQS5ULplcVo0Q9w4QkmafzyyAXQ78Z4XmowDh/ynfW6JfjqNm5JdXYTOnnfxfAQf1lk1BLJMvsovAyCMlvu1dFV0d0ihTFUE7BsOk1NT1+8v/e26E43AJSDU0+wltrPnnJFinjp6wMnJvLnrTVbNWYMFfVyMQj73My0biPJEr7TcfTGOLjSpp/ZheFREo8NFuVzLquTcMbPHCQGgFu1fqya5gYnv/Y+K/80ftKv+2IA11iq2UO33p3K7jh1RHVSXDdrnpgP+xBagFnUVQ1J9IP9Ks8yeoqWE7DydRCuF3uajeHzI+7x1Wu8v2FqdIQJlDUp4mmQx6/R+R33IdCPetCGsnrLsBrEwvYoqtWm5ZxDXQL0s6dA6utjZYwy9sluFNq66wpqceKtv7LMDgNFiXgFY7M9QlFjAihX+8HCxd5RebQ6guXPHv7/CrxuTUTX3gPqamcofMFf5OCnW59kutY3YuAewgfkBt+Y1ChmrMlyGfeoch9Qq6zgXZ0OOyG+Q/F8MOnxafP+gXQL3p9KYY4kwDxcCswfK4AlDQCBICmXEpTuvHzGvGoCd0RcWXzMna6zVUgVe4hZsifNUZjeYJ+BiOXzIrcV4gV4HcAz8JEdehVW1CBrztNBbaXTiEdKEqId6J0BHDHyQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(39860400002)(396003)(451199021)(186006)(1800799003)(82310400008)(46966006)(40470700004)(36840700001)(66899021)(40480700001)(2616005)(40460700003)(86362001)(6666004)(478600001)(82740400003)(81166007)(1076003)(26005)(36756003)(41300700001)(356005)(5660300002)(8936002)(316002)(8676002)(44832011)(54906003)(110136005)(2906002)(4326008)(70586007)(16526019)(70206006)(336012)(83380400001)(47076005)(36860700001)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2023 20:58:20.0561
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53d3d6a6-3dd0-4380-43a8-08db978907e7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MWH0EPF000989E6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4544
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently only Mellanox uses the combine_ranges function. The
new pds_vfio driver also needs this function. So, move it to
a common location for other vendor drivers to use.

Also, fix RCT ordering while moving/renaming the function.

Cc: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
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
index 902f06e52c48..5417778f2b6b 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -935,6 +935,53 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
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
index 5a1dee983f17..454e9295970c 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -283,6 +283,9 @@ int vfio_mig_get_next_state(struct vfio_device *device,
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

