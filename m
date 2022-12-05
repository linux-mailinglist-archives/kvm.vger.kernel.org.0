Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C50A4642AAB
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 15:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbiLEOtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 09:49:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbiLEOth (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 09:49:37 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6ADC1C429
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 06:49:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JLrGrPZZyuJBi7Saae41BdUC82x4o9Pk6V6fGv8rsQMm3c/uY5tB41onviLMwkggkeVd7BN2+71LAyWhbgIXGNL269L94bcgz+CQCET25k7XwzmES98f9W0cTXW5DazDVWXHBo0f06fqMBYoAOsA8r2kRWyT/sm23uGWkH5eU06CSzg86UswISU7kCHPsVRKmS27hsAxo/ffB61jm5QHysDs18LC0JZh/zHQwTXgkTAkEqkiBsfVjUh388ujl7WmW5lsAN0j/vL6IOH/3AVvzU5oFZVoq/PdUBxANzfO1dQkXWbFWFjbm4dlyvdAUMk0J1zhhnWr4HrARwEbRMrGKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kFBel/HGQBPe+s29hiyVwJUsEQv7X0qc6jIfLi0wJzk=;
 b=kfqAGQMRgNaNxPGGdY+Ow4KtjbvTaoUZtr1VfhBswiGCnRkvAWbflZ1N3Fax/yoYipFxmjVD8BeB73FbPXbLQP89govrmuYMBXJoqg5F8i+ohobC6af6A5YvDUp9lM3fgOc+JVlMqDmwSt8gZ/XIqTzJf7hqBC5KEcJXXBTh4uuxjVHYw7IGLuT/rrx2NFpqbCM/WPJdnU++oI9rkUKaUuERPeHG3uwJgo5YgMxRywmVV6h2Ha/jEPAnej738HZJ3Wdbn6N+PIMEw566wMVfI7r/Q6IexDDPnD7hUjPjlp4/k57I1bR8UZqRzRjsbU+cZOo9WGMzj6/ZR9L6kPnpPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kFBel/HGQBPe+s29hiyVwJUsEQv7X0qc6jIfLi0wJzk=;
 b=mTLZiureQFUCH3jk1xHwj+rCkGCrDjYSJm8Uoej50D0UYV/UK8TnUFTLhU7WGAymVAj9SlNWvJhMm4To8uY3Dc/XcpVcJugOuEGC11FxYLzNzsnK91akcB4zBFN+O8heRkAyzd2L3+m1KWEu0oUr7ZWZNCkZKcuamBcBHJKn5wnDDh4JSiwY9BVuWF4fr1wTnsqQFCvIsdZ017hyOKLkfzMKaBbDBzZZaA9iZMPudUOcpgI7hnp1F2E6nyb2XqFtdRz5dX5S+t2NCe8+/YgeDHnzteAr3n1UZFHhbl7veJl6g1exKStfN30DUI9jjQMEAW6JFzlKUd24uwEfFmVRAw==
Received: from CY5PR15CA0106.namprd15.prod.outlook.com (2603:10b6:930:7::8) by
 CH3PR12MB8212.namprd12.prod.outlook.com (2603:10b6:610:120::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 14:49:29 +0000
Received: from CY4PEPF0000B8E8.namprd05.prod.outlook.com
 (2603:10b6:930:7:cafe::fa) by CY5PR15CA0106.outlook.office365.com
 (2603:10b6:930:7::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Mon, 5 Dec 2022 14:49:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000B8E8.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.11 via Frontend Transport; Mon, 5 Dec 2022 14:49:28 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 06:49:18 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 06:49:18 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Mon, 5 Dec
 2022 06:49:14 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V3 vfio 04/14] vfio/mlx5: Refactor PD usage
Date:   Mon, 5 Dec 2022 16:48:28 +0200
Message-ID: <20221205144838.245287-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221205144838.245287-1-yishaih@nvidia.com>
References: <20221205144838.245287-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8E8:EE_|CH3PR12MB8212:EE_
X-MS-Office365-Filtering-Correlation-Id: 740f3677-a28a-4a20-b5ee-08dad6cfe95a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bk5eZUFv9izQnludnxTBSfihUU8rNVBLIMtKt2RVRzRoRULJdhfu9/E1cD69kXymusN4b8WsD0fH0hFSBA2yHYKs/c0BvG+yVBn/M7BCPtnrEuE5FnQlCBG+aV0YDKhDUVsJiAy28lXMcYBJcS3+ziufZIvFVH5xRs1SsKrYLpzvUH4qWOmvRVEOHKHRkNH1Q71fCYBZezbCqInoPtI6esWsfagxfNrwhVLaxa4aKS3YGnLoEvEdSqADPYLiZrmGr/SxF7jkQEg/5uBhtsI/KGaYtuB1dxc56we6L1Xf3q0nMjRAQP45jnrfZ20qT3HP34TeSUz4PVkGnR+2Rk7PiSGVx5RhilBypQJnwt1hxHMHK9Zw7Z2JH296i/0Y/ZC5H3MPnwnWpjuHKH2t3YJ/Kv/o0dRGGYEfPO8IKLHVWFWjYZZiNc9vYwUh6tPMtWhjYPpSxYLIU2jpohMIKMVdWERZrUHMp3+ss2hMHTrwvis+hN88UHqYN8zj8Kl9LvqmSUDjohXHLNNMOXrhII7bTZOsEdE7wbjeD7t7MCgqxZkwtsrw71eKvxURzKIr0pUkqr6CohKOnt5eKQmlYvfMB0VoEgpGfHE6PNaXzb48ZQfCHS1aV06HY1FdQVXTvJsRwvmP0bQVllS2/R4VdPwYIIvyd7qb5tobezd5Xk/Qpp3dnINJPXDcE2w2LyX17hxfby/bxV3zHb2Ush7A2WCYCQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(136003)(376002)(451199015)(46966006)(40470700004)(36840700001)(83380400001)(36860700001)(356005)(86362001)(7636003)(82740400003)(5660300002)(41300700001)(40460700003)(8936002)(2906002)(4326008)(82310400005)(8676002)(40480700001)(186003)(26005)(7696005)(336012)(47076005)(426003)(1076003)(6666004)(54906003)(316002)(110136005)(6636002)(2616005)(70586007)(478600001)(70206006)(66899015)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 14:49:28.6550
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 740f3677-a28a-4a20-b5ee-08dad6cfe95a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8E8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8212
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

