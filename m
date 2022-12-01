Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0432563F3EB
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 16:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbiLAPbE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 10:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbiLAPao (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 10:30:44 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A57AA8E6
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 07:30:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZcQ1YMkdNp+UbO4vE4mycrTvQsqCYb0/KYxSBDdvpmwBshljuRtJcDzhQ3WZU8cMslBHimNZ7J7o1znuodRptiW5Pw0RjLISgCP1wVJBRXt5e4z4Kj1PuqrRAeFy6rcOLJpKTY1Lxq8PQOWJoELK6ESg1PhXFctiL1rq2AkVPTaFscNEM9ql5C9pR76aqY9YFyuIyovZhjjN2TsZKZe92mG4reQ5oL7mT7K6WFEzdNthLIjD9TbFGg7JxpbyRrd53SntCrxe8oxtc2Zjzw1+7XWeLn2dIvFfZTdV/l1Y339iKK0kBA/WDrJ4XXW1zuyGnExUvufmUwrHclDupSYzDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JAcpghZcRjZ5mmVfu97I7k1eDhULoHnLM3EYT+G6E0E=;
 b=PMcirb6oyYhmq1u0Yv5FNBFPF6Jc1Ppm9Dsy1EZS4dgkfWP7JBu895RNvso1oYqrqUBD+tO11Esu3WuI73lkinfwtFCx64IFJjIeFzFCnRh+HF+Ni8gfF6ipDfm/pluVQ9iFhTXGxwb5f+lEstwTaAhQHRS7juHK01qv3S9GOfpl3iJ9QHAnNcMCN9xPR0qC/s/+OMVq25LaewAxJkAYudQIZJPfDPvM8EcvIpdZXEj1dGJEvgbSi/qXyRT3Upy/7MjGpRVK5ug4eHY2D+BO6jdocZDXPa0XxAoLdyPe2eOKf7L9jKKgP/9cBDzkQlKxyqKz8aHzCEwNOyW6pyHVQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JAcpghZcRjZ5mmVfu97I7k1eDhULoHnLM3EYT+G6E0E=;
 b=I4yyhUF+bY9ahQj//VFWh4xrgZsa4w1m0Do988DgpWkOOYIoN6lNUHQ9G76Uwa1hX2k0+enzJWu1IOfpqz0HNy7H9YCjXvqv2OdYkSw+xLOQXebL6OHFyB3oL1VxM50nWxjKrSObCJ51GfUHbFdPflKADfCMNrvfi6wiK/ey4HMv3wlCH5MSIzIpX/0fWlIiApQyo7Hcz5YvxhVcMZUN4sjp0U8OdORctU5B7WIHO+RD7LEy2CXo2HZCa6F9FXKGhPBJ8wUVmzbpo4z1bZm+yGkLxJqlF3WnMTWIVW8W7pZiSNATgnO7NnDs3p7K9D8ZKutY46foL+UmNovtqTT1WA==
Received: from DM5PR07CA0098.namprd07.prod.outlook.com (2603:10b6:4:ae::27) by
 BL1PR12MB5900.namprd12.prod.outlook.com (2603:10b6:208:398::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 15:30:19 +0000
Received: from DS1PEPF0000E633.namprd02.prod.outlook.com
 (2603:10b6:4:ae:cafe::88) by DM5PR07CA0098.outlook.office365.com
 (2603:10b6:4:ae::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 15:30:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS1PEPF0000E633.mail.protection.outlook.com (10.167.17.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Thu, 1 Dec 2022 15:30:18 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 1 Dec 2022
 07:30:12 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 1 Dec 2022 07:30:11 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 1 Dec 2022 07:30:09 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH V2 vfio 04/14] vfio/mlx5: Refactor PD usage
Date:   Thu, 1 Dec 2022 17:29:21 +0200
Message-ID: <20221201152931.47913-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221201152931.47913-1-yishaih@nvidia.com>
References: <20221201152931.47913-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E633:EE_|BL1PR12MB5900:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c683c47-a089-4f33-aee8-08dad3b0f435
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eUF4zoL+n8O3me6nKz46qgesIIONziVYySaiW2IBnX27J2TtUazJ2fj0hosjlLqCpW9UIvWI7WEeMPdTx3+iIseEROpydajRu1CHnvYNeCErQRxfH72SGWXI4EJeMo2UL4lhgTVB7oRi3OW3G8YQ+VZTIybbuIrKQAFcT623ETeQ2XhTtC8QEvOmy+tZ2XYC8dOBc2qKB/GTE+3X7l1cl49y4ypSKWFSxwZ1f7C2K8WvIN0PRbxJ3MQNILKoLiJ5DDtoflcSo9PGCkSZCZEU78guu5NNJosgSI0NKznOabyoYkSAhE7KFB+N814InbO54LfsZd++ntlkgUubmvBnDQ/8ru0/Gn16pw4xdh7fAMAEyEWlM1PNMG2NLLYFFYl8s8jcihPIy/VRk1BDSawClaZtHM61vFV5bZzZdvVy+b52BwZJ+6XnPElSRshY6O5fl2XxACH9QvfWzOjGIBB20Wnz0K24DQU+YMzUlQ/AjTbHIu549aNqyjvJO7aqGy9Tj13lMCdi6plFGYJFzyozyMeL6E51s+Uu2y4HUD1Ppg8woaxoVf4u1B80l8Wjj619OkC1681dRvuRwEGywBRw9btmp8lpME5C8F9gO+ABPy0k+S0FHh4g9YWnoFM1wlT6UOgAY32SAO37ffwEi4YK2dPRf4m9KVxLl/COCKZ0N+x07LChjtzyjAMpIjGmsh9YZI0wXUzDc2shLWugWfChQQ==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(376002)(346002)(451199015)(36840700001)(46966006)(40470700004)(36860700001)(70586007)(40480700001)(8676002)(82740400003)(4326008)(66899015)(70206006)(478600001)(110136005)(336012)(6636002)(186003)(1076003)(54906003)(86362001)(82310400005)(7636003)(6666004)(356005)(83380400001)(316002)(2616005)(41300700001)(7696005)(26005)(40460700003)(36756003)(8936002)(426003)(5660300002)(47076005)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 15:30:18.9803
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c683c47-a089-4f33-aee8-08dad3b0f435
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E633.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5900
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
index 4081a0f7e057..7392a93af96f 100644
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
@@ -252,20 +255,25 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
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
 
@@ -347,6 +355,7 @@ static struct mlx5_vf_migration_file *
 mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
 {
 	struct mlx5_vf_migration_file *migf;
+	int ret;
 
 	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
 	if (!migf)
@@ -355,20 +364,30 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
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
@@ -376,6 +395,7 @@ void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev)
 		mlx5_cmd_cleanup_async_ctx(&mvdev->saving_migf->async_ctx);
 		cancel_work_sync(&mvdev->saving_migf->async_data.work);
 		mlx5vf_disable_fd(mvdev->saving_migf);
+		mlx5fv_cmd_clean_migf_resources(mvdev->saving_migf);
 		fput(mvdev->saving_migf->filp);
 		mvdev->saving_migf = NULL;
 	}
-- 
2.18.1

