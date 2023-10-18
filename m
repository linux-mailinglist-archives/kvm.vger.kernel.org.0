Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10ECF7CE437
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 19:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbjJRRRK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 13:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbjJRRQd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 13:16:33 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFC6D59;
        Wed, 18 Oct 2023 10:16:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OSBPaGY/xftjUIJl07onKTkDm6UTUIuA22yZ8DKu+QO1fmqB1Z3vs3BhEElbhrrtzo3lLUUpvNTMUNmmcKF351zWv4ULFbD4IcFiDt1jPF+he16SR1FQcyW5LHbMK/4xHri53tJRAPFLRJu+Sz/dqyA52fxJC40sYQ3lbjLeTU02Dygt58XQlwDNCR2LDbNfQuUoqq4c7NwI2U0/DfrFkaPTPNyzVB7Gw1Zz3mT/oaKfyT4sResMn6R7Om+onhU4mEJ20DI7UZHbjNvqhneUmDyK7t7/Ku45ZBBd1lwmA+w/T51TXlCzDessgNUg9wS00/L2KeQvzDwHL+2x61+6nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q3nj/DFK1Ax7axx5cxRwjydNEVXFy4148fMqcUXwGVE=;
 b=XKWolbvEQhuLIOqx1X0SWef3CQqMCmbkOsFA4RJUDo/cquQd/F2v/SwdF/aHWLwVtZQCvZvMPn209kV6o/7U5BL/y33vczIWbkPvk8k2p5E3XDER7xXq0magLcuHUA3QU1adeRsBUZdo+GY+8X+zSrVNxfO4ymtuRxSl9ndcCSd4xCmI8VqMRBTnPnDZ9zs/ebrxUIjYRJmYEYCiItTSIwmatO9+RDSMH6qD4mgR5069UUEPSniFyOqRN2CqYE8qkJ6m9pbiyiYYKnrRy10kXL5bd+3UXdpenzx3FI4zJRSU4fZG4zsnaKWWbx8wck5B2B+KQAHk1ImTWxcSP9GORg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q3nj/DFK1Ax7axx5cxRwjydNEVXFy4148fMqcUXwGVE=;
 b=r4gTpt2eHep52rYmbHmxrd78dPF6fpprrJYkrKFhzWnUYNoGqC48PE7WgJgFT88mxBN1HeiG+1seQKW5DACABHTVYluDZwd6ehARqE3wYa3vMpIJeuMVujl28k/39+tUZr140P756CUkrxrQDJEYTb3FhWwtsIHG+4+J+TXEELx7Muyw1ruE/kgsGRuzc/w3R7UZIipzZdbjNCeeZMtpChhGSyBYTLpakEDJMnYdrZlewt7lnnT4vX3FuLU18mz/bBPu6WdAXbE4AA2feTFOL2LeJtfmla9YQTumDngJMT3nHgXnHqC8nlOQ3yZGwX9KDLFci2jd5XNoNtrHDo3wTQ==
Received: from CY5PR22CA0061.namprd22.prod.outlook.com (2603:10b6:930:80::6)
 by LV3PR12MB9332.namprd12.prod.outlook.com (2603:10b6:408:20f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Wed, 18 Oct
 2023 17:16:14 +0000
Received: from CY4PEPF0000FCBE.namprd03.prod.outlook.com
 (2603:10b6:930:80:cafe::9f) by CY5PR22CA0061.outlook.office365.com
 (2603:10b6:930:80::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21 via Frontend
 Transport; Wed, 18 Oct 2023 17:16:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000FCBE.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.23 via Frontend Transport; Wed, 18 Oct 2023 17:16:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:16:02 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:16:01 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Wed, 18 Oct 2023 10:15:59 -0700
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
Subject: [PATCH vhost v4 10/16] vdpa/mlx5: Allow creation/deletion of any given mr struct
Date:   Wed, 18 Oct 2023 20:14:49 +0300
Message-ID: <20231018171456.1624030-12-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231018171456.1624030-2-dtatulea@nvidia.com>
References: <20231018171456.1624030-2-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCBE:EE_|LV3PR12MB9332:EE_
X-MS-Office365-Filtering-Correlation-Id: 32c3215f-ec9c-47be-96ca-08dbcffdeed2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bqa1HB4gK7K7RtQe1kOBSWjMF9TBCr1uoYaRicI4QGNh8rgpbsYqAeZT7kwCQF0iZwGanaFJtI83e3bmXUWScQ3Kj14V4Sdr/Tsj3DYbyMqLU5o6UYQhU+/em/S4+JD8754qTgSrvRetdhlT5z6dIJ9qM2f2dsrXq4xxJZrgoHVhm78yKGjk+EEVjKnoDEAWq18mpkW4y7RJlEE9lR/Yy57XoLA97/Z8W8++uGEzNPDDplZ9acD4w1f/fnXQpynC3BOi+x1ep86FfULKSa/ruY+z7/s0Esf9FFAILG2Ofqn4y8wq1TdpBtTwJ8fpOPGt6W4jImrEtBp8LGPl6jb2+46+/poPFEQKyDsry6CxFcHBpoLyHr22tDUQZ7T5UhmTtQekSQaDS+ZmaNXInRl0IGJof9HUW0pLAqVgEWlruuwH0Ay8xcdw1/i81CK2BgR7tOQsvm1Yi2cDPyvsrVimwqzXP79kwS46w8lssiEU0IDLw/9wDQ5Q0kfEims2rQwOFn9oJ8120ZrrvzoEL3vBuNrLJH/4mTh3/im3f6vErRs1xTlAfWQ7useT7WXV1qCyjEIrk4kih75qHIrRIgnDSItRrV97rn1ETAq14IuAQg3nUoy1SAUmHPwsU4BpD7clbdTpAJY8F164tj0TtSmICNTPV8XqkD2ySsTPfgfykw7L7dDe0L9Me30Pj85nxKicBdS66ToPdmYo1UVjgomNHlsVh0N81OZzUN464gIg/HQwEn9HMl1zA+teSafSNAPA
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(39860400002)(346002)(376002)(230922051799003)(1800799009)(451199024)(82310400011)(186009)(64100799003)(40470700004)(36840700001)(46966006)(40480700001)(5660300002)(36860700001)(40460700003)(7636003)(83380400001)(426003)(26005)(36756003)(6666004)(336012)(66574015)(2616005)(86362001)(356005)(47076005)(82740400003)(1076003)(2906002)(41300700001)(110136005)(316002)(478600001)(70206006)(70586007)(8936002)(54906003)(8676002)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 17:16:14.2104
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32c3215f-ec9c-47be-96ca-08dbcffdeed2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000FCBE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9332
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
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
index ab196c43694c..256fdd80c321 100644
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

