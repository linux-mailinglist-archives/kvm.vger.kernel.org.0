Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA3E97BD994
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 13:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346309AbjJILZT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 07:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346306AbjJILZL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 07:25:11 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2089.outbound.protection.outlook.com [40.107.101.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D710112F;
        Mon,  9 Oct 2023 04:25:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cBdumJDOlDNfUwpoY7KBpiLJWduF06nxrIIu71b9wo+D6rNzt13Hn6bkdlr6ZVG2KrLdWVaWuDiGYJ6hs6cNnCvKQepjY2vXMs1P5/w19iTcYN+SA3WpZaaULbAIrRAGqUezbiWOsO2ueTVJ+DKVgxtQ8uRwg6rKSkyzC0OJgTiFFoanP6YpNdiw/BuNJdks0ObQDUxG/CpzqC2hVLU/U1FXbEqUrTEy3wrPcqzqPH9vXg6moGqdyqgpTQS4sn2ppkXqTCoN7WuBzugfPYwja/FeV2lZXfLVBjrCYvluPJYpJiY8+SwlDB04dLeULjc796cxLCuiPfgKi2iGZ8VLGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3YoDCHkpinOQBJC5OCWVs0dAVcWKDrjzxMHgzD+IBkE=;
 b=bJUIVHvjxy0HE/Lv/K+Ae8LIEhCEfcxRtbzOBqiOf0r6opqvlRXG1U1Lkppcy8xWXt42zROsESsNISDBqVKcfhgPntLz4KQN3OZllgog6Z2mvGKOxlQ5dNo4TnHfwmNSCiZZWtjzcaVgWCGO1HZ76rvolNibwXwqP0SP/7L/kk/TK4ne6SDMfngezuCtzUYzoyltagWmGATF7KC0aJqPlp7+vksoUGloCYUqHf7GN9rVnoSbmmReoRvk0HJJ3r8PA9IYcstsFP/vDnx0MXOpnZGSmZ24SE2SUiMVgfPDkjjJNYVgMrY3lEhuOUlSKR3eWomZTxxFvJG+VdhqRmMEhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3YoDCHkpinOQBJC5OCWVs0dAVcWKDrjzxMHgzD+IBkE=;
 b=SdljBuoGdSS5da2eAYp0JmpjDPUIvjbo9nXosvgwPbnEDp3hYQ+hbRpF6vxO28cuim1u7w/mEaOeSbUIatt40oC22T8wSOyL0w+jngHDondBU0wFFmFZ7G4RMapgL9y9kP9tOxHli9tl0spUjYOjGBYxBgWDLzxSdDWW/QBJtVMZ3r9VoV+bz0mGIsgLqfwP6MxYeOBFHR0kGM+TWc7yJpi5jeSFhmimocgkPWZV6KK8PYSGRCyQ761mwBjAiQxrRk5dRjoYc1sYvzj6LgOJ6ecw1tl4A5ek/Q0H2tN/1jr+herWT43+xWwDuRtPpjJ5VN6BZc2ceL28hFQ8YZTwag==
Received: from PH8PR20CA0017.namprd20.prod.outlook.com (2603:10b6:510:23c::17)
 by PH7PR12MB7844.namprd12.prod.outlook.com (2603:10b6:510:27b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36; Mon, 9 Oct
 2023 11:24:59 +0000
Received: from SN1PEPF0002BA4B.namprd03.prod.outlook.com
 (2603:10b6:510:23c:cafe::42) by PH8PR20CA0017.outlook.office365.com
 (2603:10b6:510:23c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36 via Frontend
 Transport; Mon, 9 Oct 2023 11:24:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002BA4B.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.14 via Frontend Transport; Mon, 9 Oct 2023 11:24:59 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:24:40 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:24:39 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Mon, 9 Oct 2023 04:24:36 -0700
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
Subject: [PATCH vhost v3 06/16] vdpa/mlx5: Decouple cvq iotlb handling from hw mapping code
Date:   Mon, 9 Oct 2023 14:23:51 +0300
Message-ID: <20231009112401.1060447-7-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231009112401.1060447-1-dtatulea@nvidia.com>
References: <20231009112401.1060447-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4B:EE_|PH7PR12MB7844:EE_
X-MS-Office365-Filtering-Correlation-Id: cc8d5458-f813-400b-f140-08dbc8ba5f4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ck4vLrhzJNjydA9vZJZxurot9e+CnEh79o6FYA4OpalJPVsF2/up/d9Zv3bpzfQTXVJeAzzR2jYmoguyiX91nhsBA3V3OwssH52T+4xCwQHaKCdlVT24yA6LwhezqJp8M3sQgXzw9V9Z4L9ENF2ySPS6si/ec3TpNcl3eIbgy04ZtXr6wHoL3JpvOjcBsHFKw/F7SQionHw2+RCUlcYadOPE1p50sBrkq9NjcdRm1AGZXot1L3vdlzg0VFZAgxzWgSK4OtVUVwBlDHjKFXyQGwYuYaowimV76/QxNbMiboa2XL7ieW5F901CS20AqRiDkcl6SgX1J+R3Sxvj5uCIyCahIsapIMP2ZUCL/9ZcrQbmzGbLok7zHMyFynv8w3aNhQkS4AOwru2ILffxj3jFXlURemqAIkewtllUTM04eEd2HqYQ9vvbu/N85ARmVQvOkktUuvBsrAjqWijmHWtBhIp3+aawJAP8jfSE4CVryUAK1ZIWxYubCgQ/tDY3NYQChM8N9a5owiFtXIiUfQUMRXP/Uknky19MGLX1MJRnb+fLtezoa0k8I+d0SsYoyrNDfBPFFhRVKiYABkH1OxCaaWW7OpxZgTgJ6OT/u93rcAFYYqt7cObOFgNT/U+GgoUvfwNdGkMQcw6vcz6UXuThAb7bQeOghHbNwhZwx+oBttPLdTEbvHkPF6WdwoL2mca38sOSUCZpnRCHHfexQkO50gKPj4EwI5MmjAx7cpCf+AU=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(346002)(39860400002)(136003)(230922051799003)(64100799003)(451199024)(1800799009)(82310400011)(186009)(40470700004)(46966006)(36840700001)(7636003)(356005)(86362001)(36756003)(40480700001)(2906002)(82740400003)(478600001)(41300700001)(8936002)(5660300002)(4326008)(8676002)(6666004)(83380400001)(1076003)(426003)(336012)(2616005)(40460700003)(316002)(36860700001)(70586007)(70206006)(54906003)(110136005)(26005)(47076005)(66574015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2023 11:24:59.0132
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc8d5458-f813-400b-f140-08dbc8ba5f4e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF0002BA4B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7844
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The handling of the cvq iotlb is currently coupled with the creation
and destruction of the hardware mkeys (mr).

This patch moves cvq iotlb handling into its own function and shifts it
to a scope that is not related to mr handling. As cvq handling is just a
prune_iotlb + dup_iotlb cycle, put it all in the same "update" function.
Finally, the destruction path is handled by directly pruning the iotlb.

After this move is done the ASID mr code can be collapsed into a single
function.

Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  3 ++
 drivers/vdpa/mlx5/core/mr.c        | 57 +++++++++++-------------------
 drivers/vdpa/mlx5/net/mlx5_vnet.c  |  7 ++--
 3 files changed, 28 insertions(+), 39 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index 3748f027cfe9..554899a80241 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -120,6 +120,9 @@ int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 			unsigned int asid);
 void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev);
 void mlx5_vdpa_destroy_mr_asid(struct mlx5_vdpa_dev *mvdev, unsigned int asid);
+int mlx5_vdpa_update_cvq_iotlb(struct mlx5_vdpa_dev *mvdev,
+				struct vhost_iotlb *iotlb,
+				unsigned int asid);
 int mlx5_vdpa_create_dma_mr(struct mlx5_vdpa_dev *mvdev);
 
 #define mlx5_vdpa_warn(__dev, format, ...)                                                         \
diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 7bd0883b8b25..fcb6ae32e9ed 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -489,14 +489,6 @@ static void destroy_user_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr
 	}
 }
 
-static void _mlx5_vdpa_destroy_cvq_mr(struct mlx5_vdpa_dev *mvdev, unsigned int asid)
-{
-	if (mvdev->group2asid[MLX5_VDPA_CVQ_GROUP] != asid)
-		return;
-
-	prune_iotlb(mvdev);
-}
-
 static void _mlx5_vdpa_destroy_dvq_mr(struct mlx5_vdpa_dev *mvdev, unsigned int asid)
 {
 	struct mlx5_vdpa_mr *mr = &mvdev->mr;
@@ -522,25 +514,14 @@ void mlx5_vdpa_destroy_mr_asid(struct mlx5_vdpa_dev *mvdev, unsigned int asid)
 	mutex_lock(&mr->mkey_mtx);
 
 	_mlx5_vdpa_destroy_dvq_mr(mvdev, asid);
-	_mlx5_vdpa_destroy_cvq_mr(mvdev, asid);
 
 	mutex_unlock(&mr->mkey_mtx);
 }
 
 void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev)
 {
-	mlx5_vdpa_destroy_mr_asid(mvdev, mvdev->group2asid[MLX5_VDPA_CVQ_GROUP]);
 	mlx5_vdpa_destroy_mr_asid(mvdev, mvdev->group2asid[MLX5_VDPA_DATAVQ_GROUP]);
-}
-
-static int _mlx5_vdpa_create_cvq_mr(struct mlx5_vdpa_dev *mvdev,
-				    struct vhost_iotlb *iotlb,
-				    unsigned int asid)
-{
-	if (mvdev->group2asid[MLX5_VDPA_CVQ_GROUP] != asid)
-		return 0;
-
-	return dup_iotlb(mvdev, iotlb);
+	prune_iotlb(mvdev);
 }
 
 static int _mlx5_vdpa_create_dvq_mr(struct mlx5_vdpa_dev *mvdev,
@@ -572,22 +553,7 @@ static int _mlx5_vdpa_create_dvq_mr(struct mlx5_vdpa_dev *mvdev,
 static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
 				struct vhost_iotlb *iotlb, unsigned int asid)
 {
-	int err;
-
-	err = _mlx5_vdpa_create_dvq_mr(mvdev, iotlb, asid);
-	if (err)
-		return err;
-
-	err = _mlx5_vdpa_create_cvq_mr(mvdev, iotlb, asid);
-	if (err)
-		goto out_err;
-
-	return 0;
-
-out_err:
-	_mlx5_vdpa_destroy_dvq_mr(mvdev, asid);
-
-	return err;
+	return _mlx5_vdpa_create_dvq_mr(mvdev, iotlb, asid);
 }
 
 int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
@@ -620,7 +586,24 @@ int mlx5_vdpa_handle_set_map(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *io
 	return err;
 }
 
+int mlx5_vdpa_update_cvq_iotlb(struct mlx5_vdpa_dev *mvdev,
+				struct vhost_iotlb *iotlb,
+				unsigned int asid)
+{
+	if (mvdev->group2asid[MLX5_VDPA_CVQ_GROUP] != asid)
+		return 0;
+
+	prune_iotlb(mvdev);
+	return dup_iotlb(mvdev, iotlb);
+}
+
 int mlx5_vdpa_create_dma_mr(struct mlx5_vdpa_dev *mvdev)
 {
-	return mlx5_vdpa_create_mr(mvdev, NULL, 0);
+	int err;
+
+	err = mlx5_vdpa_create_mr(mvdev, NULL, 0);
+	if (err)
+		return err;
+
+	return mlx5_vdpa_update_cvq_iotlb(mvdev, NULL, 0);
 }
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 65b6a54ad344..aa4896662699 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2884,10 +2884,13 @@ static int set_map_data(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 		return err;
 	}
 
-	if (change_map)
+	if (change_map) {
 		err = mlx5_vdpa_change_map(mvdev, iotlb, asid);
+		if (err)
+			return err;
+	}
 
-	return err;
+	return mlx5_vdpa_update_cvq_iotlb(mvdev, iotlb, asid);
 }
 
 static int mlx5_vdpa_set_map(struct vdpa_device *vdev, unsigned int asid,
-- 
2.41.0

