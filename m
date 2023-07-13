Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1D3751561
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 02:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbjGMAh6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 20:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbjGMAh4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 20:37:56 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96051FFC;
        Wed, 12 Jul 2023 17:37:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hGSxEPuir6AQhjZEOgOhFtrYdNJTFyAy8hzBOombBLxGzL+tFtsvhb+w8G22yExxxP6ntn8fcV2MBVv7dbURhA7D7lSugx3eGFlWAbv8VcKd44lRUsvamXlpzc+pi1H0a9BgJ6UsaiNw1/bwyF34UTGewOeqyuHoLGFL478YH3i3Yq8yCvbO/hB5ujJbTVMcAp3/EQwC75DlrEhzhxpx8dEnQ9ez63fZAIqNq/mAyuQkEvFpmCMnzCXzwTARxDzXPOE7Ha+RrNtuaUsdr2jiGVOjxpcGjiq6xJ59Z/FDfOlyUz5pXa5GlFFQyaWmfeYm7N8oxnInm1Tc2z+trhYgWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ySOn0UHJNptpXXPBGLj3BDqJ81Vo9WUO8xq2SoXTbbk=;
 b=hljVt+8KpZnVj00Er8zxHiPr4KeHjbUJWiP2V7EBDr0P9/4mjCmwdC8Jj3T4uOCQDSf/VvPzEp7kCIHSu2aL/4zcv/eg8gpplMMH1Bpn0H56zp/ifU7znoiVfvTRjf3JaqF+MFEq2gr5aLjlDLmSxvN2irVeLsl7SEETZZOMNGV/YtigynTR2jRNU4mh4TVwGMXSJcq/uHRoT9elU8NkqVXG2tzG8pblMxu5/d/68Hmb7vO1DxHFON9uBfUDp3gyebMiFA4Ty8VpP95t4sqaiDukKGXI73n7c7DAmMYumQpXOzroEHih9yTAeIc9/mcTV34ayqVp8wTyjAVwh0vrIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ySOn0UHJNptpXXPBGLj3BDqJ81Vo9WUO8xq2SoXTbbk=;
 b=AaTRALcGW23skyILVR7eohhT8Tf5ttDrzDQAYCxE4PWgGX2tkLzGNJHwiHNHdrItAtJ8TfIkQfbdwddfr4Tw+S19LKWGyKusG9pA7ianr0RJD1Ll68/oR1bUjdA4j8Z4hN9Nrkqrh5tu7NWR2pvudFrQeoq3sOEz9or6vW3OuaM=
Received: from MW4PR04CA0370.namprd04.prod.outlook.com (2603:10b6:303:81::15)
 by DM4PR12MB8474.namprd12.prod.outlook.com (2603:10b6:8:181::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Thu, 13 Jul
 2023 00:37:47 +0000
Received: from CO1NAM11FT076.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::4c) by MW4PR04CA0370.outlook.office365.com
 (2603:10b6:303:81::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.22 via Frontend
 Transport; Thu, 13 Jul 2023 00:37:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT076.mail.protection.outlook.com (10.13.174.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6588.20 via Frontend Transport; Thu, 13 Jul 2023 00:37:46 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 12 Jul
 2023 19:37:44 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH v11 vfio 1/7] vfio: Commonize combine_ranges for use in other VFIO drivers
Date:   Wed, 12 Jul 2023 17:37:21 -0700
Message-ID: <20230713003727.11226-2-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230713003727.11226-1-brett.creeley@amd.com>
References: <20230713003727.11226-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT076:EE_|DM4PR12MB8474:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b74fc17-8e41-46ef-4094-08db833960dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RczBM2ACfLK0r7JFnj67k2nKqA8p4AOOu66gVMboY8QSVNifyYOVRJvkeMXw3FBqo12fMjhN96VXNdv+UIdKX3Lx14wpwetQN1tGdqkgP9hCUJZvO6l6QAvcn7MJZEldNXMaBdXtU03QzpzTcMvyiAuqed06Z2fdHfibWbqVV+axD9YYzXjFBUGH0iTcX2//DANChhLtEZPjEoE0/pb79Bx1/z7NZ2+0gAKyeIGYJeDGKor/ey2sufoKId4q9nzlIuu/HtGLuFvzb3Wd8vB58V/kWQ34hVNgJKaY/hzj2u8GsYdPr7iZ4fxZHkMxs/EJjU/3zFF6xxmYKLw1pBwlfbAa7sTkL5BRrSxN1AqzauepKfOwnDv69Dw2kdJ0pnQSN/kWzZuBTzO5ObrHva/1eMtuinlyHsYOSyPh2URwaX76WIniZE9Sd4tcdOFfeQW2MaorIX/1R3kd0HENVYLo1RBkAeb7Xyxa5altCFIpQhfn6zLmEuID1qx5apqTn4qTrkdCpcKbuvKqopPuVuETCgZwLtshbzoYHdqZ9W15UTtLMTOE5GZm2haDoSNt5XIhExNOARPZSR2L7h6lyVL0hE/s+iLYFZVi6qFepn5dDXOP4f6+DXZ88QXFw9IBgiMnTpGkAVWAU1uklayQJ1n32u4tGTiACM20+H+CWd1aNBgom88b+Q+R0t1aPK3pbVx9VFVuPH5pjdF0V07cvrAVggO6jvDHEmdDnvnDcbOQ6ri+JOK5dY9vfhde+P18Q8vxXHZ5144OpvY/IxAy8xToVA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(376002)(39860400002)(451199021)(36840700001)(46966006)(40470700004)(6666004)(478600001)(83380400001)(47076005)(2616005)(26005)(1076003)(186003)(16526019)(336012)(40480700001)(426003)(36756003)(40460700003)(36860700001)(316002)(82310400005)(2906002)(41300700001)(82740400003)(81166007)(356005)(70586007)(4326008)(70206006)(44832011)(8936002)(86362001)(8676002)(5660300002)(110136005)(54906003)(66899021)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2023 00:37:46.2916
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b74fc17-8e41-46ef-4094-08db833960dc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT076.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8474
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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

