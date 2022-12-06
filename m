Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45A1D643EC8
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 09:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbiLFIg0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 03:36:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbiLFIfv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 03:35:51 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A50CB1CC
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 00:35:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GeruKUcepEhLPpAQOrxrT+B5qyj6kIlYwuIeyQZ8qQZrzfA4HCOnZRRAld7czEYGgPWlpURerwml390sfidFhURvmIShh4V3yiquN9/hmRKqaz2jCswhJp061xkvfqnF65dqCcH+iwoki7Z5jEMGiBPKyrXuzz3EBSCwg04c6rLNXuezxEgqNJStvYlMs3KeFjbekljSqszFOG3Zhpti35WMHFRZdUkVc2sO4AnPKkYDYwSX2MPlny+lrfoeY0BRiYy5ENCD751L9NPMshc6A5wdkxHGpiZr0NlCq8uo/rMaO1W9RSzPJ1AQXiIy1iWGrbYR+HnuPw+HLDYQFzF/8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kFBel/HGQBPe+s29hiyVwJUsEQv7X0qc6jIfLi0wJzk=;
 b=OqX31813taYI+Imi7VvGux2cku7BcPHro1wSFVEj4fhSvbRZCl/tsCnaMgjLhGl/rUQ9OjBybv3z2kdteaqIk8jNDOKcgFu5YUqxFtppNblR6HwcoQxrMhJ0AOPfENgNR+oPD9ogzR8AYM8skyh9pB13FFo/oK2yqQoXiDDJAPLC/yWnewdrrNskYe2ardWtjYvwTbVcWJ4+byC2ChD7+qgGpNRmdFlhwjZQEF5ODz1ov6e3aaOJByGG177hUluBwbdvFK7hl8lUn4AcbLdlhPnhuUyOLWoG+sK9TJCMctIZrd/20h6LHbEf3ccpRLBOr551uENG8663AE+F97s7/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kFBel/HGQBPe+s29hiyVwJUsEQv7X0qc6jIfLi0wJzk=;
 b=S93fr00VqzZSUtJBJg7dejNvwNUPl026/CSP1Ayc6xGu6bAlWct4gAIK3UGzj9A//rKQBWTFfvd4rBo4uQx0Wvce/VQNqMVIHWHkbuhz68XwnLFxHhfub6oC0nlXolDixIPAVgs89n5i0DrDjps/1uX5oGjYKZi0XyZ5ErT9MnsbF32kJTv1R8UnGhQcvdAKYFTEJFxTQIMqdppzNzhH+zqGbDqDhR4gQTrmtucHuzVSM4qGRnQIkpvgNq8JJff9onnemEXxHcykqCu5ZEefULRvZRHKNdN6Wnfma/hSqPRJ1WHQRqpK41qszkJkP6PoCh0efpVpgXigoXr/mWJNOQ==
Received: from DM6PR02CA0071.namprd02.prod.outlook.com (2603:10b6:5:177::48)
 by LV2PR12MB5800.namprd12.prod.outlook.com (2603:10b6:408:178::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 08:35:34 +0000
Received: from DS1PEPF0000E64E.namprd02.prod.outlook.com
 (2603:10b6:5:177:cafe::ae) by DM6PR02CA0071.outlook.office365.com
 (2603:10b6:5:177::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Tue, 6 Dec 2022 08:35:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS1PEPF0000E64E.mail.protection.outlook.com (10.167.18.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Tue, 6 Dec 2022 08:35:34 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 6 Dec 2022
 00:35:25 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 6 Dec 2022 00:35:25 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 6 Dec 2022 00:35:22 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V4 vfio 04/14] vfio/mlx5: Refactor PD usage
Date:   Tue, 6 Dec 2022 10:34:28 +0200
Message-ID: <20221206083438.37807-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221206083438.37807-1-yishaih@nvidia.com>
References: <20221206083438.37807-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E64E:EE_|LV2PR12MB5800:EE_
X-MS-Office365-Filtering-Correlation-Id: a5e69488-5e26-4026-b154-08dad764d806
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rzrTjaZTf8IjIbZs/KweEVllR+NgQxw6zOMyI6+cdie30EknempykpORNOlL6nTjT1xdmUI0Y5Afdtdx/0KPQ9Y0dsofqR62WUgSEnnAMJzPbKxMqCHaLwUeTtdY9KMRaHNGPL82DyOj4zDD1ONvzCPyaROotagIGmCuqblBxOipr1CiKHVYntxgqoIzWxFhp9+AVhuRjd85dhg1G/Y34QNS87Hc+AJSWk73cG/HXjn9kRwO8+AE8lRbkZm4oZct9H2kJJ4IVrC+NX/vPC13dT3Kw/UIimQsFx6As+dtRQi3cx73zbRdiVpk3CGCXwl/MagsBGXzQFA+Z5Wj/nEc213RwnT5oVxeTxRHMmSVtGf+BLYiPT7MHcDfTx1pTzpt8yOLhZnzgOLz1qW+RPGwZGNn8iGxs/RS0bF4CWTVcGGxztLNV5OSdy4OBHPw2rTN3qfTDVggXm2HzhYH0daSqnUtAGIvrbckaF2gevPjgZYcO1/O7Y89+Ms97H8Qq1flPT0qELf/iedxH1b64coxnEj/7c8TH23qBIEni3NnubVfRoGbwimDEfLS2fxLdlgDjsmajyt8cUNbYl4uj4hHlH/Ssy0LLUkKjhWyTY741gtE6XJm7bcfM5kjFWMorN+iBuqmo1aN0Dd1PUCIalD1PfNnXeNWrQfVJgmKDjhdxtdKHE7UAFJuoCtR6y2xRqG5etgCC3PfJitnJ1lRGLZ9iA==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(136003)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(336012)(66899015)(2906002)(40480700001)(426003)(47076005)(5660300002)(41300700001)(8936002)(1076003)(36860700001)(82310400005)(7696005)(316002)(8676002)(478600001)(4326008)(2616005)(70206006)(70586007)(36756003)(7636003)(83380400001)(356005)(86362001)(110136005)(6636002)(82740400003)(26005)(186003)(40460700003)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 08:35:34.5958
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5e69488-5e26-4026-b154-08dad764d806
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E64E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5800
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch refactors PD usage such as its life cycle will be as of the
migration file instead of allocating/destroying it upon each SAVE/LOAD
command.

This is a preparation step towards the PRE_COPY series where multiple
images will be SAVED/LOADED and a single PD can be simply reused.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 53 ++++++++++++++++++++++++------------
 drivers/vfio/pci/mlx5/cmd.h  |  5 +++-
 drivers/vfio/pci/mlx5/main.c | 44 ++++++++++++++++++++++--------
 3 files changed, 71 insertions(+), 31 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 55ee8036f59c..a97eac49e3d6 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -279,7 +279,6 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
 
 	mlx5_core_destroy_mkey(mdev, async_data->mkey);
 	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE, 0);
-	mlx5_core_dealloc_pd(mdev, async_data->pdn);
 	kvfree(async_data->out);
 	complete(&migf->save_comp);
 	fput(migf->filp);
@@ -314,7 +313,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	u32 in[MLX5_ST_SZ_DW(save_vhca_state_in)] = {};
 	struct mlx5vf_async_data *async_data;
 	struct mlx5_core_dev *mdev;
-	u32 pdn, mkey;
+	u32 mkey;
 	int err;
 
 	lockdep_assert_held(&mvdev->state_mutex);
@@ -326,16 +325,12 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	if (err)
 		return err;
 
-	err = mlx5_core_alloc_pd(mdev, &pdn);
-	if (err)
-		return err;
-
 	err = dma_map_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE,
 			      0);
 	if (err)
 		goto err_dma_map;
 
-	err = _create_mkey(mdev, pdn, migf, NULL, &mkey);
+	err = _create_mkey(mdev, migf->pdn, migf, NULL, &mkey);
 	if (err)
 		goto err_create_mkey;
 
@@ -357,7 +352,6 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	migf->total_length = 0;
 	get_file(migf->filp);
 	async_data->mkey = mkey;
-	async_data->pdn = pdn;
 	err = mlx5_cmd_exec_cb(&migf->async_ctx, in, sizeof(in),
 			       async_data->out,
 			       out_size, mlx5vf_save_callback,
@@ -375,7 +369,6 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 err_create_mkey:
 	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE, 0);
 err_dma_map:
-	mlx5_core_dealloc_pd(mdev, pdn);
 	complete(&migf->save_comp);
 	return err;
 }
@@ -386,7 +379,7 @@ int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	struct mlx5_core_dev *mdev;
 	u32 out[MLX5_ST_SZ_DW(load_vhca_state_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(load_vhca_state_in)] = {};
-	u32 pdn, mkey;
+	u32 mkey;
 	int err;
 
 	lockdep_assert_held(&mvdev->state_mutex);
@@ -400,15 +393,11 @@ int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	}
 
 	mdev = mvdev->mdev;
-	err = mlx5_core_alloc_pd(mdev, &pdn);
-	if (err)
-		goto end;
-
 	err = dma_map_sgtable(mdev->device, &migf->table.sgt, DMA_TO_DEVICE, 0);
 	if (err)
-		goto err_reg;
+		goto end;
 
-	err = _create_mkey(mdev, pdn, migf, NULL, &mkey);
+	err = _create_mkey(mdev, migf->pdn, migf, NULL, &mkey);
 	if (err)
 		goto err_mkey;
 
@@ -424,13 +413,41 @@ int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	mlx5_core_destroy_mkey(mdev, mkey);
 err_mkey:
 	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_TO_DEVICE, 0);
-err_reg:
-	mlx5_core_dealloc_pd(mdev, pdn);
 end:
 	mutex_unlock(&migf->lock);
 	return err;
 }
 
+int mlx5vf_cmd_alloc_pd(struct mlx5_vf_migration_file *migf)
+{
+	int err;
+
+	lockdep_assert_held(&migf->mvdev->state_mutex);
+	if (migf->mvdev->mdev_detach)
+		return -ENOTCONN;
+
+	err = mlx5_core_alloc_pd(migf->mvdev->mdev, &migf->pdn);
+	return err;
+}
+
+void mlx5vf_cmd_dealloc_pd(struct mlx5_vf_migration_file *migf)
+{
+	lockdep_assert_held(&migf->mvdev->state_mutex);
+	if (migf->mvdev->mdev_detach)
+		return;
+
+	mlx5_core_dealloc_pd(migf->mvdev->mdev, migf->pdn);
+}
+
+void mlx5fv_cmd_clean_migf_resources(struct mlx5_vf_migration_file *migf)
+{
+	lockdep_assert_held(&migf->mvdev->state_mutex);
+
+	WARN_ON(migf->mvdev->mdev_detach);
+
+	mlx5vf_cmd_dealloc_pd(migf);
+}
+
 static void combine_ranges(struct rb_root_cached *root, u32 cur_nodes,
 			   u32 req_nodes)
 {
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 8ffa7699872c..ba760f956d53 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -16,7 +16,6 @@ struct mlx5vf_async_data {
 	struct mlx5_async_work cb_work;
 	struct work_struct work;
 	int status;
-	u32 pdn;
 	u32 mkey;
 	void *out;
 };
@@ -27,6 +26,7 @@ struct mlx5_vf_migration_file {
 	u8 disabled:1;
 	u8 is_err:1;
 
+	u32 pdn;
 	struct sg_append_table table;
 	size_t total_length;
 	size_t allocated_length;
@@ -127,6 +127,9 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 			       struct mlx5_vf_migration_file *migf);
 int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 			       struct mlx5_vf_migration_file *migf);
+int mlx5vf_cmd_alloc_pd(struct mlx5_vf_migration_file *migf);
+void mlx5vf_cmd_dealloc_pd(struct mlx5_vf_migration_file *migf);
+void mlx5fv_cmd_clean_migf_resources(struct mlx5_vf_migration_file *migf);
 void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev);
 void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev);
 void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work);
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 0d71ebb2a972..1916f7c1468c 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -236,12 +236,15 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
 	migf->filp = anon_inode_getfile("mlx5vf_mig", &mlx5vf_save_fops, migf,
 					O_RDONLY);
 	if (IS_ERR(migf->filp)) {
-		int err = PTR_ERR(migf->filp);
-
-		kfree(migf);
-		return ERR_PTR(err);
+		ret = PTR_ERR(migf->filp);
+		goto end;
 	}
 
+	migf->mvdev = mvdev;
+	ret = mlx5vf_cmd_alloc_pd(migf);
+	if (ret)
+		goto out_free;
+
 	stream_open(migf->filp->f_inode, migf->filp);
 	mutex_init(&migf->lock);
 	init_waitqueue_head(&migf->poll_wait);
@@ -257,20 +260,25 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
 	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev,
 						    &migf->total_length);
 	if (ret)
-		goto out_free;
+		goto out_pd;
 
 	ret = mlx5vf_add_migration_pages(
 		migf, DIV_ROUND_UP_ULL(migf->total_length, PAGE_SIZE));
 	if (ret)
-		goto out_free;
+		goto out_pd;
 
-	migf->mvdev = mvdev;
 	ret = mlx5vf_cmd_save_vhca_state(mvdev, migf);
 	if (ret)
-		goto out_free;
+		goto out_save;
 	return migf;
+out_save:
+	mlx5vf_disable_fd(migf);
+out_pd:
+	mlx5vf_cmd_dealloc_pd(migf);
 out_free:
 	fput(migf->filp);
+end:
+	kfree(migf);
 	return ERR_PTR(ret);
 }
 
@@ -352,6 +360,7 @@ static struct mlx5_vf_migration_file *
 mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
 {
 	struct mlx5_vf_migration_file *migf;
+	int ret;
 
 	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
 	if (!migf)
@@ -360,20 +369,30 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
 	migf->filp = anon_inode_getfile("mlx5vf_mig", &mlx5vf_resume_fops, migf,
 					O_WRONLY);
 	if (IS_ERR(migf->filp)) {
-		int err = PTR_ERR(migf->filp);
-
-		kfree(migf);
-		return ERR_PTR(err);
+		ret = PTR_ERR(migf->filp);
+		goto end;
 	}
+
+	migf->mvdev = mvdev;
+	ret = mlx5vf_cmd_alloc_pd(migf);
+	if (ret)
+		goto out_free;
+
 	stream_open(migf->filp->f_inode, migf->filp);
 	mutex_init(&migf->lock);
 	return migf;
+out_free:
+	fput(migf->filp);
+end:
+	kfree(migf);
+	return ERR_PTR(ret);
 }
 
 void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev)
 {
 	if (mvdev->resuming_migf) {
 		mlx5vf_disable_fd(mvdev->resuming_migf);
+		mlx5fv_cmd_clean_migf_resources(mvdev->resuming_migf);
 		fput(mvdev->resuming_migf->filp);
 		mvdev->resuming_migf = NULL;
 	}
@@ -381,6 +400,7 @@ void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev)
 		mlx5_cmd_cleanup_async_ctx(&mvdev->saving_migf->async_ctx);
 		cancel_work_sync(&mvdev->saving_migf->async_data.work);
 		mlx5vf_disable_fd(mvdev->saving_migf);
+		mlx5fv_cmd_clean_migf_resources(mvdev->saving_migf);
 		fput(mvdev->saving_migf->filp);
 		mvdev->saving_migf = NULL;
 	}
-- 
2.18.1

