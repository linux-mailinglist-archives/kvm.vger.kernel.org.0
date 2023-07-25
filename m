Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBA37762499
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 23:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbjGYVlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 17:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjGYVlX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 17:41:23 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7861BE9;
        Tue, 25 Jul 2023 14:41:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SzxUYGJEz+OhU7bT8sbIs+CeIljabIr7WwY2IfaFJmMniJ7FzgpvaQfZG7njtS8BWhDxEDqIbn5f1mcs/DNTTErMnmeDbXv4y4kg3Gv6D7V3/XUshXbfu4R/a11RAZ6NI8ef0F2A5N0dDWJSy1z8HDur/apQCuQ4HSjTcEFJK2UOuEaToy4AnmFPnISQOHPZQZjsqlNyR9m+g1HFiEJjunjkOuqRa8kaIlGQ4jH/cePzH7epB76Ti9Tx8nj5BVxsnF0o5wK+8nSdHIunohByg5uJY+AjjyOGDBL6faBJ4PUow7KwNd07ShyZQGIiQg+h62LvCKVyzntaMPvGONgrNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NEvmPJh/ATiAdRd/TeHn5tx/6T3+Z0voC+dcxZEhODA=;
 b=VOnO1OeNloTcAsLswSy6cr32PUu7pKcgCE+VF8NLlB8OcGExP0MmkLMbMIjhUAJeFf6tSCL8NbaX3hZSjJM9LRzeLQQ28drhB+wXLKiiwEwb7ZAAZcoHROTkhKDXL3nKl040eKnH1iouu55bS6ehzgkGo97TH8FXbiRSEA/G8fx+BtHmK9fFYQ6PcUb9h+2ZZDnRmVdnU+6WnN8IrgpLLdIgICGCjrICMbwKkH1hn1Zfe7QULNIdgfVaIJiqSjACzQvQ5rFj7rwn5MICXwZo9UFlTrAcsLG18D+MFZmrV8UR/KKwiDVqBZiOBepKlbdkZZaclW60RxzVi7CRR70nRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NEvmPJh/ATiAdRd/TeHn5tx/6T3+Z0voC+dcxZEhODA=;
 b=JkLeLrdcJiVYVCy+OE7C/fj/TOE1uAVtXMOPRGZNk7HlzItm5oU5i9D6JoMFtcBne8kAPwx6bCxjm4STA3lkstNsPrW1TKTETllZieVOvC/TaKiZgGz/CP5aFSaldCn92x9v8cm8kSCTuIcEfgl6Xcez/+yNUiHbO175F7TfkRk=
Received: from BN9P220CA0010.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::15)
 by SA3PR12MB7859.namprd12.prod.outlook.com (2603:10b6:806:305::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Tue, 25 Jul
 2023 21:41:20 +0000
Received: from BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13e:cafe::fa) by BN9P220CA0010.outlook.office365.com
 (2603:10b6:408:13e::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33 via Frontend
 Transport; Tue, 25 Jul 2023 21:41:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT055.mail.protection.outlook.com (10.13.177.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6631.29 via Frontend Transport; Tue, 25 Jul 2023 21:41:19 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 25 Jul
 2023 16:40:38 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <simon.horman@corigine.com>, <brett.creeley@amd.com>,
        <shannon.nelson@amd.com>
Subject: [PATCH v13 vfio 1/7] vfio: Commonize combine_ranges for use in other VFIO drivers
Date:   Tue, 25 Jul 2023 14:40:19 -0700
Message-ID: <20230725214025.9288-2-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230725214025.9288-1-brett.creeley@amd.com>
References: <20230725214025.9288-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT055:EE_|SA3PR12MB7859:EE_
X-MS-Office365-Filtering-Correlation-Id: d163fa2a-db72-4599-1bf4-08db8d57e237
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /8cp2OCiOoMWliHkqUwFMnL92ELK9tDYjwngk2EArOkpnG7OMIHDsrbnCwmdfzc4w+oPNBJZ8YBEbUlOyEo+vx/laja8+N7qoL69BrlEzjaBpQuLxA68tVUcH7WnDTnkyBkPq1jgeidt/gXNA0QFO9a3xPB7gbqhPvwDb1vtA/LzU2JVADRpcbRqadO50+31xXxM2R0Hvr7YoqSDguDsLJDqGloPWUy5ugtFnQ25dZUGfGf/TB3GNSN/t/HUOX+beLORDwNdmPRZ7Y5BhaoTDUON+a0xyCOGKXzwgYEvfOO0hpPBdOp0Qa97qE6hvZJwFyUp+U+wVRFyILhEaFq0ywehJsLNkHH1NsEUHQyHZKucFOSyauIHxnuZhJUvwgKw9tlgVNHqRS+KHQitLX7KLQxEju59h2VDgqLfdUXi95eEbatJHUz5t4nSTwMHxMUgnVN7vmS0QJU8nJefdeD7whfpVn8rI6e9zaRmsdL021kTBR2H2lo0lTzf1ACuZ0ZgASetuDRrnaY3lNTENUN4XoBKP4zc6rYAz34WgwrCYVThk5UjPY+ImqoSl1MpAjd+TRP49sFeYUUImEsgQNZziOL+U5+5c3wvjBJXGfPQEMTccuHRbPmjrqTuerajeuRGSl8NTnVCk+2C9rOOPV8Iw4ScoOrdDeZk2A4K7fYwgmbEtqCCR8GSB/mCYEO9UJWu+xlQiiE5dlIuxrBH6tmatRCzYpxgPFY2+3W3HSlSci5f1lnd6SBQoqUvNDh/PTIeAw8m9ABpwtpDJw5Pgaq+fA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(396003)(136003)(346002)(82310400008)(451199021)(46966006)(40470700004)(36840700001)(86362001)(478600001)(6666004)(82740400003)(70206006)(70586007)(356005)(54906003)(81166007)(110136005)(4326008)(316002)(66899021)(36860700001)(47076005)(41300700001)(8676002)(83380400001)(2906002)(36756003)(2616005)(426003)(8936002)(40460700003)(336012)(16526019)(186003)(44832011)(40480700001)(26005)(1076003)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 21:41:19.9522
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d163fa2a-db72-4599-1bf4-08db8d57e237
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7859
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
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

