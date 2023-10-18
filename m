Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 363DE7CE43D
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 19:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbjJRRRE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 13:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbjJRRQa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 13:16:30 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32D413D;
        Wed, 18 Oct 2023 10:16:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=khJOpENTdd3MTcuP4EGZz3oxsfIotYaX3M3SlSxmPlRs2bd6IHNVezF+SY5z56blb0pO7h6pOeclUnSdRdWBMtOxWdtgtdyvX9fRvGVOqCCPSp//ljEGAkuZcnd4z0uecy9ty4d5lreeBXzeQSzENDx3EfSdQj5pfbkg5RvKTOefkeXd4X8d1ZzGwzFYri+u+i7k/Vc25wqM+SMujFAW50KIcRV+s0K5LM8r84K13BUxGhYHdLTDGsigLiS32I3OSiQmYC7SGjaXejsQz2FCyrP/hjQV2DYGaTRGUW9EMPgd5qvtQuiW3qCeFZzriXYzyvrmCoRckk9XkXQN46POPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XmILL87kEXieQsFyA46Z/A2SnEkDR6phjuffw0L8hYk=;
 b=MF+j7+RKZs8aGoU0ScZPV9hzh52FnwzcJdJRiZ+EkfHB9/vV8XSTdEwUV58pndJK+TJ1f8vJLR4wGOm+VQ6ymmBQKORrcEJv8U77xo3jYt5wHKnCHZcXmn4+s+nfHo3irmoAQxXzwiRm4Zecb6S2dh+aXb4pceBoSFbRHUZ71yZwxk2QsfdsflENdMJgc141eb7NY5+gofD6LA4DCf6RzR0PyA7DL0IRJmj8b3r9UrRNgChxo0ju1tvi8A6bxdGeRcnz+EcuO+33Ibyktaff/Xktzoh4eEuZ3u2Vn+4UN9mBO3Ftsvb7VljI/y83TcZvQP2/t8mP3QxRkABk28klKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XmILL87kEXieQsFyA46Z/A2SnEkDR6phjuffw0L8hYk=;
 b=MKly6PPV9EtsnmXliLkOQxWB9Ns59Jq09zFbCkbnm/y48+cxmzonufoWzA6CT/tkcI46lInqpyVMQFfDBjI59eCGnu5BsjcMXUU9s8Fi72I1uF807z6ZgJRDTO7HG7I5vbiD3M6qa9ne4pnnGEsHFJrgDwG1ykcl9N3pMlQN6Ks869W2lHgH94bvBtcZNbqU2nausRctqmocL979BqHKfIfJdYO4oe97MZGOeeCu9EQ69veqQVedhXOivwyoQ/vHr7VDnpCRVCmx39fYLUfcxFbVhivIXZeigwtt2OU0Ae8K7kbbbUeUqy4A0a/3Jdh0WGFmPFgQewhsZ4GxMtFiNA==
Received: from CY5PR22CA0075.namprd22.prod.outlook.com (2603:10b6:930:80::18)
 by MW6PR12MB7085.namprd12.prod.outlook.com (2603:10b6:303:238::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21; Wed, 18 Oct
 2023 17:16:11 +0000
Received: from CY4PEPF0000FCBE.namprd03.prod.outlook.com
 (2603:10b6:930:80:cafe::f7) by CY5PR22CA0075.outlook.office365.com
 (2603:10b6:930:80::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.24 via Frontend
 Transport; Wed, 18 Oct 2023 17:16:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000FCBE.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.23 via Frontend Transport; Wed, 18 Oct 2023 17:16:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:15:58 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:15:58 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Wed, 18 Oct 2023 10:15:55 -0700
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
Subject: [PATCH vhost v4 09/16] vdpa/mlx5: Rename mr destroy functions
Date:   Wed, 18 Oct 2023 20:14:48 +0300
Message-ID: <20231018171456.1624030-11-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231018171456.1624030-2-dtatulea@nvidia.com>
References: <20231018171456.1624030-2-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCBE:EE_|MW6PR12MB7085:EE_
X-MS-Office365-Filtering-Correlation-Id: 59c047f1-d340-4bfb-1f95-08dbcffded36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oosKnh16ICDOtiiBOlH1EWiZ1cPFqU7msq/3X4G+GI7q/buNgHYspwp5ZpPIZFhY2nJvwRrVU9Lm98s3H98fsLjFhxYOS/7IzxGw7bLBzZgRh0H7/Vl+nrcRM3vPuPfqkYgE/2qRzKQHC0UYK4kZZYyW2dggJbtUo8gsQngRQTrzHesQcHEjqY2P+xQEvAMwdvaculY8ybIRRZXS7w28SaXb9j9fRUrKog9xUW+x+dE/d33rZC4Mhs93S8nwqSb2HKfVUVhOywG7V13jhlK+4O5vy4VwQ06pt1nSK1ihaCvc6S9AyXOW1b8fAhfUouupBM6+5LYpIsjnOJh4XEhfWOSBfrdB8dAmfuU1PiZNyD2fcmx8OLapTs5KUOwnAtRAOH0nk9LKAWKUXjcn06b7mqRYVphLIfnQlI4mn1n/TOPrBi+FsGKTzY+NvfU64wYvl++cxKRWStDN4dMCr6mkLOq31Zh7kasPuq2vxXPq1j1YclKImXtgkcYNfBF9H9rO6tJDEoCgXTZZdYx7qaksMIKfqyoCl2A+17w7dBWmJnVTZiX80gqrTfgEdH4KMwP9IC7uybjlpkVbXuKOODKLAV+pD2NvnglkY3BwqE0kimaxc62xWacSV5/5Kf0PjRq4LAOgjKCXHz6WC4CSYDSV1MwckjgVg70/V0FTnFphqFx9LuQufl5E1Ug/jp1UavMzvRSGoDPLVjIc8MYYs3azIm8sVcsghuNu5k46b1zXD+nwUQVVW4Lv9OeXzzNoJ/Al
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(136003)(346002)(376002)(230922051799003)(82310400011)(186009)(1800799009)(64100799003)(451199024)(46966006)(40470700004)(36840700001)(40480700001)(36756003)(40460700003)(110136005)(316002)(54906003)(7636003)(86362001)(82740400003)(356005)(83380400001)(336012)(426003)(66574015)(478600001)(8936002)(1076003)(26005)(2616005)(6666004)(2906002)(36860700001)(70586007)(70206006)(41300700001)(47076005)(5660300002)(4326008)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 17:16:11.5073
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59c047f1-d340-4bfb-1f95-08dbcffded36
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000FCBE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7085
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make mlx5_destroy_mr symmetric to mlx5_create_mr.

Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  4 ++--
 drivers/vdpa/mlx5/core/mr.c        |  6 +++---
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 12 ++++++------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index 554899a80241..e1e6e7aba50e 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -118,8 +118,8 @@ int mlx5_vdpa_handle_set_map(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *io
 			     bool *change_map, unsigned int asid);
 int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 			unsigned int asid);
-void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev);
-void mlx5_vdpa_destroy_mr_asid(struct mlx5_vdpa_dev *mvdev, unsigned int asid);
+void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev);
+void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, unsigned int asid);
 int mlx5_vdpa_update_cvq_iotlb(struct mlx5_vdpa_dev *mvdev,
 				struct vhost_iotlb *iotlb,
 				unsigned int asid);
diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index fde00497f4ad..00dcce190a1f 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -507,7 +507,7 @@ static void _mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, unsigned int asid
 	mr->initialized = false;
 }
 
-void mlx5_vdpa_destroy_mr_asid(struct mlx5_vdpa_dev *mvdev, unsigned int asid)
+void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, unsigned int asid)
 {
 	struct mlx5_vdpa_mr *mr = &mvdev->mr;
 
@@ -518,9 +518,9 @@ void mlx5_vdpa_destroy_mr_asid(struct mlx5_vdpa_dev *mvdev, unsigned int asid)
 	mutex_unlock(&mr->mkey_mtx);
 }
 
-void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev)
+void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
 {
-	mlx5_vdpa_destroy_mr_asid(mvdev, mvdev->group2asid[MLX5_VDPA_DATAVQ_GROUP]);
+	mlx5_vdpa_destroy_mr(mvdev, mvdev->group2asid[MLX5_VDPA_DATAVQ_GROUP]);
 	prune_iotlb(mvdev);
 }
 
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index aa4896662699..ab196c43694c 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2644,7 +2644,7 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_dev *mvdev,
 		goto err_mr;
 
 	teardown_driver(ndev);
-	mlx5_vdpa_destroy_mr_asid(mvdev, asid);
+	mlx5_vdpa_destroy_mr(mvdev, asid);
 	err = mlx5_vdpa_create_mr(mvdev, iotlb, asid);
 	if (err)
 		goto err_mr;
@@ -2660,7 +2660,7 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_dev *mvdev,
 	return 0;
 
 err_setup:
-	mlx5_vdpa_destroy_mr_asid(mvdev, asid);
+	mlx5_vdpa_destroy_mr(mvdev, asid);
 err_mr:
 	return err;
 }
@@ -2797,7 +2797,7 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
 err_driver:
 	unregister_link_notifier(ndev);
 err_setup:
-	mlx5_vdpa_destroy_mr(&ndev->mvdev);
+	mlx5_vdpa_destroy_mr_resources(&ndev->mvdev);
 	ndev->mvdev.status |= VIRTIO_CONFIG_S_FAILED;
 err_clear:
 	up_write(&ndev->reslock);
@@ -2824,7 +2824,7 @@ static int mlx5_vdpa_reset(struct vdpa_device *vdev)
 	unregister_link_notifier(ndev);
 	teardown_driver(ndev);
 	clear_vqs_ready(ndev);
-	mlx5_vdpa_destroy_mr(&ndev->mvdev);
+	mlx5_vdpa_destroy_mr_resources(&ndev->mvdev);
 	ndev->mvdev.status = 0;
 	ndev->mvdev.suspended = false;
 	ndev->cur_num_vqs = 0;
@@ -2944,7 +2944,7 @@ static void mlx5_vdpa_free(struct vdpa_device *vdev)
 	ndev = to_mlx5_vdpa_ndev(mvdev);
 
 	free_resources(ndev);
-	mlx5_vdpa_destroy_mr(mvdev);
+	mlx5_vdpa_destroy_mr_resources(mvdev);
 	if (!is_zero_ether_addr(ndev->config.mac)) {
 		pfmdev = pci_get_drvdata(pci_physfn(mvdev->mdev->pdev));
 		mlx5_mpfs_del_mac(pfmdev, ndev->config.mac);
@@ -3474,7 +3474,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 err_res2:
 	free_resources(ndev);
 err_mr:
-	mlx5_vdpa_destroy_mr(mvdev);
+	mlx5_vdpa_destroy_mr_resources(mvdev);
 err_res:
 	mlx5_vdpa_free_resources(&ndev->mvdev);
 err_mpfs:
-- 
2.41.0

