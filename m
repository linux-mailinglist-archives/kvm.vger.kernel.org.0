Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBFC79D1AC
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 15:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235562AbjILNDX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 09:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235502AbjILNC4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 09:02:56 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565531FF0;
        Tue, 12 Sep 2023 06:02:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTJy5hfrqeQEzV8+zFZkV4vMho9DRTNL6cjwH2+XcVkPJGSVa46VuEsCRl10LZLbe/hWvy8PYn22lVCkMejpWZqchFWIkOSLTYbnfDrA6STprn6orDxo/uouqzaVeLiZCHFn6D/yPirD7jSonbeqUBv/sIAWHQpHySkGn4UaLHh2azVdrTB5QOdVDWFXsWKg7aDMxiF84CDP1ClrY9PJYMmqDjUd6zyz2zyUBnOKQ3oxMa6B+HHgbqxym/1FDNORuUbLbkhOfWcBTnQBtAIosXyIhwZ9v3hMGcMOdKE1ba57+WQQQufJfVyGQ+BL81xuMoTFQQ9adWCj/vGn3DCFrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7yjPT8J+kgExEytkS7FIkpYmqtcbAp6EKHKyE5r0RWI=;
 b=HfLs7hKWMAHjfkP9+v1/ZG0DgQA1un8FMe1VuuH/9VG2xoC4NUaexMzhQCGAcVfp8SlAYj1bV3A1NRaC6XtyYhgyM2W1b1YEMT2hjSU42fKFoC9R9RMf85MjMxF7KhjKXbM72yZ3gG8AvKsXhQGm4CvTAA3TofWbX8EidXzAsQiKQNmNXb97CnmtF7d1fBglgeiRnGTktxWavKsp4V7evCdEz9qZnhV8bndDqRsB+BFtf/YMxyV+7dOqMPk0orV5U6OoWeB+Xi26p7nrZOb3vAyDevV32/eDl+alsMiXNuE4V7Mq5JvHEcTeE7kHbuIC01o1TKejusB/pwOpQR5FkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7yjPT8J+kgExEytkS7FIkpYmqtcbAp6EKHKyE5r0RWI=;
 b=HZA2WY/j06WqE3USPRb+T8xMn0wcvRgSDImGPEm7J0PJLV19g4x1oSYM48hghbFT/sQBep8pdzx9ipE7AjDl7Xq5vmoUH4/lTQIxC62DkKb5X0K5MK4LggTDtjXHOlEBgpD8UJ7i26K6OFU+vxmAeYdumHbOkpE5hSvfOY0dd2Edi8fmx1HxLDv/cdPY/ym580ip6DCsC0lURmpNMBEYqBywl8pOOGRBpSUstOqFcch20CdBndWnhzf8wScYjCSjwmzf29rzS7kNU0CnM5ot5yL1wrD8AAuA6Bygc/kevRHkMdeYifq8L1hF+v6bDL/m37ikkqG0m4YNXqiOkuoRxQ==
Received: from BYAPR04CA0030.namprd04.prod.outlook.com (2603:10b6:a03:40::43)
 by SJ2PR12MB8110.namprd12.prod.outlook.com (2603:10b6:a03:4fc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Tue, 12 Sep
 2023 13:02:30 +0000
Received: from CO1PEPF000042AC.namprd03.prod.outlook.com
 (2603:10b6:a03:40:cafe::ca) by BYAPR04CA0030.outlook.office365.com
 (2603:10b6:a03:40::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.37 via Frontend
 Transport; Tue, 12 Sep 2023 13:02:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000042AC.mail.protection.outlook.com (10.167.243.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.11 via Frontend Transport; Tue, 12 Sep 2023 13:02:28 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 12 Sep 2023
 06:02:16 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 12 Sep
 2023 06:02:16 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.37 via
 Frontend Transport; Tue, 12 Sep 2023 06:02:13 -0700
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
Subject: [PATCH 09/16] vdpa/mlx5: Allow creation/deletion of any given mr struct
Date:   Tue, 12 Sep 2023 16:01:19 +0300
Message-ID: <20230912130132.561193-10-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912130132.561193-1-dtatulea@nvidia.com>
References: <20230912130132.561193-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AC:EE_|SJ2PR12MB8110:EE_
X-MS-Office365-Filtering-Correlation-Id: 59e9e39f-f358-4b24-3e6e-08dbb39084a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HfGHdsU5ECE9T0k0RBTEpmFPUIgeDViFe0tf6dQseKmwwvqSRydiUBqnxd8id0oPm/6kXpaqPEzow12YC/CWE9zayyb/kKHQU0IKcKFEhzzYTBziGByR0RMAR5IoYEM6FSeTl8eCh28orqLwaJroxU7uZyJvT92mLZzGov+0kbGrinHaCW02WnJb6oOwZPwr7dbYh+dzuIu9s7xRkmZoZtNFzzIu0zP16EJaTKvUTc0neicpGSfwoUrNFoY4jzQwNt0i8JtZ2+Xmj/AnnjV+H5RLKamFTjFvVPZ1aMrFfHcUBoaJw5k+5oDU8fCC9nbJ3ieWGPP2HnlioqaOeZyDhahbSyKNjX08DxaAMiYM2IXWa9EDVFOQH3SKgB/sPy5iIA0i2QnOgtvB1yn2QDQOup4T568v48+BWSsNgePH9q/JuLp59sQ4mhxf7ioiHHMHzXfUf/jN1ArSC1N1hQgmrM/8rV0Siynd5ownifnKSVsTotbCQWgq6lluZNIbO/fdDKEz/ihMe373KCWShIqY0yjYlo6EWXLt6Sz0x05IjX0MSQ4wC61rWwoMGKJ+2bwffpjZb0hzO4hTePbwERTgJUD/zLZ+oPNRF7mCu24QDHh70sSMl/jJyfNBOvFV50GS/Kv3sO9EQK4RwjYHtIwW47jUUb/nr+l5xTfhqyAVt/9UYFKAyBeCLM8AE03cm6eET7nANiPIM3ziPw/ogiCBXWnd9Xx05IcXh8ppWK6Mr+jJpS1Mhnjzcy61FCz7w630
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(39860400002)(376002)(136003)(186009)(1800799009)(82310400011)(451199024)(36840700001)(40470700004)(46966006)(41300700001)(40460700003)(316002)(7636003)(82740400003)(2906002)(478600001)(36756003)(86362001)(356005)(110136005)(54906003)(70586007)(70206006)(40480700001)(1076003)(2616005)(5660300002)(83380400001)(8936002)(8676002)(26005)(4326008)(47076005)(336012)(426003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 13:02:28.3579
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59e9e39f-f358-4b24-3e6e-08dbb39084a5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF000042AC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8110
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adapts the mr creation/deletion code to be able to work with
any given mr struct pointer. All the APIs are adapted to take an extra
parameter for the mr.

mlx5_vdpa_create/delete_mr doesn't need a ASID parameter anymore. The
check is done in the caller instead (mlx5_set_map).

This change is needed for a followup patch which will introduce an
additional mr for the vq descriptor data.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  8 +++--
 drivers/vdpa/mlx5/core/mr.c        | 53 ++++++++++++++----------------
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 10 ++++--
 3 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index e1e6e7aba50e..01d4ee58ccb1 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -116,10 +116,12 @@ int mlx5_vdpa_create_mkey(struct mlx5_vdpa_dev *mvdev, u32 *mkey, u32 *in,
 int mlx5_vdpa_destroy_mkey(struct mlx5_vdpa_dev *mvdev, u32 mkey);
 int mlx5_vdpa_handle_set_map(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 			     bool *change_map, unsigned int asid);
-int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
-			unsigned int asid);
+int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
+			struct mlx5_vdpa_mr *mr,
+			struct vhost_iotlb *iotlb);
 void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev);
-void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, unsigned int asid);
+void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev,
+			  struct mlx5_vdpa_mr *mr);
 int mlx5_vdpa_update_cvq_iotlb(struct mlx5_vdpa_dev *mvdev,
 				struct vhost_iotlb *iotlb,
 				unsigned int asid);
diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 00dcce190a1f..6f29e8eaabb1 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -301,10 +301,13 @@ static void unmap_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct
 	sg_free_table(&mr->sg_head);
 }
 
-static int add_direct_chain(struct mlx5_vdpa_dev *mvdev, u64 start, u64 size, u8 perm,
+static int add_direct_chain(struct mlx5_vdpa_dev *mvdev,
+			    struct mlx5_vdpa_mr *mr,
+			    u64 start,
+			    u64 size,
+			    u8 perm,
 			    struct vhost_iotlb *iotlb)
 {
-	struct mlx5_vdpa_mr *mr = &mvdev->mr;
 	struct mlx5_vdpa_direct_mr *dmr;
 	struct mlx5_vdpa_direct_mr *n;
 	LIST_HEAD(tmp);
@@ -354,9 +357,10 @@ static int add_direct_chain(struct mlx5_vdpa_dev *mvdev, u64 start, u64 size, u8
  * indirect memory key that provides access to the enitre address space given
  * by iotlb.
  */
-static int create_user_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb)
+static int create_user_mr(struct mlx5_vdpa_dev *mvdev,
+			  struct mlx5_vdpa_mr *mr,
+			  struct vhost_iotlb *iotlb)
 {
-	struct mlx5_vdpa_mr *mr = &mvdev->mr;
 	struct mlx5_vdpa_direct_mr *dmr;
 	struct mlx5_vdpa_direct_mr *n;
 	struct vhost_iotlb_map *map;
@@ -384,7 +388,7 @@ static int create_user_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb
 								       LOG_MAX_KLM_SIZE);
 					mr->num_klms += nnuls;
 				}
-				err = add_direct_chain(mvdev, ps, pe - ps, pperm, iotlb);
+				err = add_direct_chain(mvdev, mr, ps, pe - ps, pperm, iotlb);
 				if (err)
 					goto err_chain;
 			}
@@ -393,7 +397,7 @@ static int create_user_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb
 			pperm = map->perm;
 		}
 	}
-	err = add_direct_chain(mvdev, ps, pe - ps, pperm, iotlb);
+	err = add_direct_chain(mvdev, mr, ps, pe - ps, pperm, iotlb);
 	if (err)
 		goto err_chain;
 
@@ -489,13 +493,8 @@ static void destroy_user_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr
 	}
 }
 
-static void _mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, unsigned int asid)
+static void _mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr)
 {
-	struct mlx5_vdpa_mr *mr = &mvdev->mr;
-
-	if (mvdev->group2asid[MLX5_VDPA_DATAVQ_GROUP] != asid)
-		return;
-
 	if (!mr->initialized)
 		return;
 
@@ -507,38 +506,33 @@ static void _mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, unsigned int asid
 	mr->initialized = false;
 }
 
-void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, unsigned int asid)
+void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev,
+			  struct mlx5_vdpa_mr *mr)
 {
-	struct mlx5_vdpa_mr *mr = &mvdev->mr;
-
 	mutex_lock(&mr->mkey_mtx);
 
-	_mlx5_vdpa_destroy_mr(mvdev, asid);
+	_mlx5_vdpa_destroy_mr(mvdev, mr);
 
 	mutex_unlock(&mr->mkey_mtx);
 }
 
 void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
 {
-	mlx5_vdpa_destroy_mr(mvdev, mvdev->group2asid[MLX5_VDPA_DATAVQ_GROUP]);
+	mlx5_vdpa_destroy_mr(mvdev, &mvdev->mr);
 	prune_iotlb(mvdev);
 }
 
 static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
-				struct vhost_iotlb *iotlb,
-				unsigned int asid)
+				struct mlx5_vdpa_mr *mr,
+				struct vhost_iotlb *iotlb)
 {
-	struct mlx5_vdpa_mr *mr = &mvdev->mr;
 	int err;
 
-	if (mvdev->group2asid[MLX5_VDPA_DATAVQ_GROUP] != asid)
-		return 0;
-
 	if (mr->initialized)
 		return 0;
 
 	if (iotlb)
-		err = create_user_mr(mvdev, iotlb);
+		err = create_user_mr(mvdev, mr, iotlb);
 	else
 		err = create_dma_mr(mvdev, mr);
 
@@ -550,13 +544,14 @@ static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
 	return 0;
 }
 
-int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
-			unsigned int asid)
+int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
+			struct mlx5_vdpa_mr *mr,
+			struct vhost_iotlb *iotlb)
 {
 	int err;
 
 	mutex_lock(&mvdev->mr.mkey_mtx);
-	err = _mlx5_vdpa_create_mr(mvdev, iotlb, asid);
+	err = _mlx5_vdpa_create_mr(mvdev, mr, iotlb);
 	mutex_unlock(&mvdev->mr.mkey_mtx);
 	return err;
 }
@@ -574,7 +569,7 @@ int mlx5_vdpa_handle_set_map(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *io
 		*change_map = true;
 	}
 	if (!*change_map)
-		err = _mlx5_vdpa_create_mr(mvdev, iotlb, asid);
+		err = _mlx5_vdpa_create_mr(mvdev, mr, iotlb);
 	mutex_unlock(&mr->mkey_mtx);
 
 	return err;
@@ -603,7 +598,7 @@ int mlx5_vdpa_create_dma_mr(struct mlx5_vdpa_dev *mvdev)
 {
 	int err;
 
-	err = mlx5_vdpa_create_mr(mvdev, NULL, 0);
+	err = mlx5_vdpa_create_mr(mvdev, &mvdev->mr, NULL);
 	if (err)
 		return err;
 
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 4d759ab96319..4793b6a7ab54 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2644,8 +2644,8 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_dev *mvdev,
 		goto err_mr;
 
 	teardown_driver(ndev);
-	mlx5_vdpa_destroy_mr(mvdev, asid);
-	err = mlx5_vdpa_create_mr(mvdev, iotlb, asid);
+	mlx5_vdpa_destroy_mr(mvdev, &mvdev->mr);
+	err = mlx5_vdpa_create_mr(mvdev, &mvdev->mr, iotlb);
 	if (err)
 		goto err_mr;
 
@@ -2660,7 +2660,7 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_dev *mvdev,
 	return 0;
 
 err_setup:
-	mlx5_vdpa_destroy_mr(mvdev, asid);
+	mlx5_vdpa_destroy_mr(mvdev, &mvdev->mr);
 err_mr:
 	return err;
 }
@@ -2878,6 +2878,9 @@ static int set_map_data(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 	bool change_map;
 	int err;
 
+	if (mvdev->group2asid[MLX5_VDPA_DATAVQ_GROUP] != asid)
+		goto end;
+
 	err = mlx5_vdpa_handle_set_map(mvdev, iotlb, &change_map, asid);
 	if (err) {
 		mlx5_vdpa_warn(mvdev, "set map failed(%d)\n", err);
@@ -2890,6 +2893,7 @@ static int set_map_data(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 			return err;
 	}
 
+end:
 	return mlx5_vdpa_update_cvq_iotlb(mvdev, iotlb, asid);
 }
 
-- 
2.41.0

