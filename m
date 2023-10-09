Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1FF7BD9A4
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 13:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346316AbjJILZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 07:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346311AbjJILZT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 07:25:19 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614009D;
        Mon,  9 Oct 2023 04:25:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gyp5TFienEIZqvGWFen12OZuinkxfhojYBRmaa8/0DPe//9GCyHHOjb36qGAZBN9Zo/7yFm6wFzP3M6TPYaQeXWhz63pKzw1iCTzuCL5UZIt04ToKp1AWTzNKBfKpvQoeYY7Ag6PsZGoHPfdqqrb9sKItt0qy0G30vKWbyrv0VQWMaZ0Hs5mdpEwGarFEqvFF+c4I6KH2UMGm9xASati7HMgyutTlBvLFfsEQvZ/H6WumjYDmmDAQnW/AbxA2URH/xLGS9LImOBcknHx7mhdEaIXyts7rAS0M61ENSShBu9yQqM1pAQpLfphyIjQuXsCQKaIhZyqTsFMk48tcJ7+tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ARPpe47gz+MA73Ix9lUbLmF/6h5J92rUxRFMm3wXHY=;
 b=UZRJrijkEOmYcqDuyHVWkDCm/riTTFu6tvESkCYbef5kw9Drdi0KkLl0Miiq0VOVAIKMBPmyWvw4KPsP8QvD91Rw5bHt/DxF6ePAwzYpYCZ1oRuV9BFxxrg6AOKsz7S+Tho2TqpSfr2P4ZswBxUwl2OEAWG3KhzhfvE73PUJN3GjCIYNZd8rZHOglwLAb7dBn9xzjyFiy6vmT/NmsSUqeTQlNhu0CRXuYX8n1jYW7cydtLsxGNBXnHEezSktrrTA0RgD3b5vMjRmoGM2LMqYz8aXaPNoBmEpyCDYBsHde9JpnBg5Q/IumcNTblAmSyLCsre/vG1VwKXrxfcOE7RiIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ARPpe47gz+MA73Ix9lUbLmF/6h5J92rUxRFMm3wXHY=;
 b=tg1Mf7LnrCcUXBAu3lg51wxvMZckyUe5eF/GemL/r++l3g9eu7QnWD7WU1j8GpBNj5g4LVaJ4Eq8f+wGlnPMsAqslsOPF0os7AUKoqLBOje9LlEIlGY0/mKorbsb5PsX8wXe54gdEBFW4jMYEC4kG2hSo4MmLshGaZTyu+yQvmeYiOU8NVtdHT4VBmzqdpQDtbrmcK5esT3CptlWTbOXXcfYe5Ek5sqQXGKc3oNDVU/+ZCBNZ91yQnVwjs5oLjI0by6vfmeWlfapLWLtLk8YSzsSxyLLQjzhs8+VFHZpEPZiXRF5DbxAEDff8+bP/Q+3AyU9wGgczyEyNr7aDYJTlA==
Received: from SA9P223CA0011.NAMP223.PROD.OUTLOOK.COM (2603:10b6:806:26::16)
 by CH3PR12MB9250.namprd12.prod.outlook.com (2603:10b6:610:1ae::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36; Mon, 9 Oct
 2023 11:25:08 +0000
Received: from SN1PEPF0002BA4D.namprd03.prod.outlook.com
 (2603:10b6:806:26:cafe::69) by SA9P223CA0011.outlook.office365.com
 (2603:10b6:806:26::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.37 via Frontend
 Transport; Mon, 9 Oct 2023 11:25:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002BA4D.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.14 via Frontend Transport; Mon, 9 Oct 2023 11:25:07 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:24:54 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:24:54 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Mon, 9 Oct 2023 04:24:51 -0700
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
Subject: [PATCH vhost v3 10/16] vdpa/mlx5: Allow creation/deletion of any given mr struct
Date:   Mon, 9 Oct 2023 14:23:55 +0300
Message-ID: <20231009112401.1060447-11-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231009112401.1060447-1-dtatulea@nvidia.com>
References: <20231009112401.1060447-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4D:EE_|CH3PR12MB9250:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c70b86e-1fbb-4796-78c2-08dbc8ba6485
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cao5gRHOxoh98YTvA4BlZno6sG9qTIB+Ue6j09rpNtSgXfXfaeckcuEGIkhjdfcfKuDJxRFg8I7tTVx1CadBvbPRkBUglqfCicXT9hXT75k0PZXheWns506Jqqj4+NATT5K8Hp3WylQhUasRMkB809RnBby6IYckGtwzaZAc/j7v760qLXW7iHGnjsokQetcp/csT6yBV2oAKAldvrzHIzZrOqZLFLuUdRRn6KEx2OsT8W+giJ29R0HYPnn389G9VaiPCUB2oHpPrNILYD0JCkh6NBol89PFBjSowcr8paAdIKr+JFra4aXmEwX8WlBM5a6shZ617djfi3x2bg4eaJMs9YEvJXJoMnIN3NKq1/qz25revD97Rum3/8Sd6Jym3gilB1YlZz2mFgPL5WoYEuEiKJ8MHANzuAPUm5RjSr+w5/p18srprUjSDgx5mI9QYY8pKhPYpFnRzKSlWb8YZcy0v5i1REe6TZVLh4TZw2jvimFHnpA45YpkGLYscJLwcfeiQPzFtkwJwmJ3RUrDvuw0kgABib0+vGdY5kJqTVyCqTPmusRekc5rh2p7xjO01vGMeZhx6JBJFhLIp2dsMMzcPrR0rPuAHYVhZp+RwHo2stdJcq4rWPsNXl9QCro7mEw3JVWR9STt/MN5iBd564kKc4AtNvse0n2/vMVoqod6nfSNyXy301jM87MRzQVeq4Sg4TYAgO+2rm609enub1b1X1nmD+ryTg/SqMsDlssIyc/ZzLXjeZ70+6vONFwC
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(376002)(136003)(39860400002)(230922051799003)(82310400011)(64100799003)(186009)(1800799009)(451199024)(46966006)(36840700001)(40470700004)(1076003)(2616005)(426003)(336012)(26005)(36860700001)(8676002)(478600001)(66574015)(47076005)(8936002)(83380400001)(2906002)(4326008)(110136005)(54906003)(70206006)(70586007)(41300700001)(316002)(40460700003)(7636003)(356005)(36756003)(82740400003)(40480700001)(86362001)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2023 11:25:07.7591
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c70b86e-1fbb-4796-78c2-08dbc8ba6485
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF0002BA4D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9250
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

