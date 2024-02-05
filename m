Return-Path: <kvm+bounces-8018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97B31849B1C
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 13:56:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB559B26296
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 12:56:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53A8C4CE0B;
	Mon,  5 Feb 2024 12:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lyPKDL14"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2043.outbound.protection.outlook.com [40.107.244.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AD62E416
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 12:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707137359; cv=fail; b=UAE3aL0SkgxOr6Tmo2a3gsEQQFE8Rv1MXqkmPbeQ4PV6QXhhNwO6yrY9QP2laZqdAstWAOEXWJjcOAOZ6q5uXAsLnh6LGU0u2nojyEZSIXCbg3hnE/i78YU6sCkRGEnsHs5I6Sy8D1O94l3ERaA/h3Oi6id2XfNLgrRqffP4BEc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707137359; c=relaxed/simple;
	bh=Ntxja4oN0lZkVDvWQPaxE+WCfSw2oLqngq5w2DwS3dI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C+rNuPb7W0WXwkTpjdMtwl458o8ledY3I1l+N/pDNljv6BrEOPNS4aVwm242WOyWjtzJmR2ThKSB2dh/5iVROACw0dNsqhBgPVHLWJPBjsV0LIPWYudaameDGlVg3C8VKdPtoN6pf2gvX8x2gwwVZhSlEpxd+ycSYNaqw8LbZ9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lyPKDL14; arc=fail smtp.client-ip=40.107.244.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W8JzLpXpmAYESHlkSnf280JUiBtVJgCkGTM+GnTODomaBMjU1NEB2t3U+scx+Q9XsIBx8ExY59goSOoi6CwBbPhVGVDTun/IdZHzaAt+7YFDsEXqMOC6tEbwZCcKIXsx/Pt2rwMBw0IvhqnFxH7xUTK5Xr22P5iRUq44nEGR7Zs/KY7RdC6DO9t2VRuPbFbMlNhXUofwPeOFJlVU4Iag8pIC8Fnc8D9hWowOEL5qvN9aCU3aIaw/tP8JP7lqKED8G8XdRfiAZhowN6eNzHeU+O23uk13u4rq/aNvhGOz/Zan7FGUAiSNMih4cMrMyjQ7mH+VIGo4fwolLl9EcAl4SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SvK2uwQK8OjkuxkT0j16/tjZMW2dOXK80PYMkLbUKME=;
 b=M047fee8zFEfmIHtglfk2XZWijnJR9Kc1Vnr711LxdLEYqYxRcdkIxdT9x+Gq4G1H2/VEg61xcDokNi4R67ukhhCKocS78CShm8xFtEMqpS0T4fs6S4Moo3HHBCGc55PbW2/RiLLrvfRr6ckXFFMxYePzI52A9y1Xy/kudf10HHrtmKvbgpzo++iL4vJO+j9qG7wl3xliNkyGVj2yR1usI3DlHnUSNJJgVLupHut3lc9elucYW+pY3cGi7uE8OsGSXiYdrrrdSkkBI15FrwPfGakxGvkdfBapI9Kh8HZpgN1qMDbkLpYje3WaouXwIS336JG23ELM3oFvDhH7iUsgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvK2uwQK8OjkuxkT0j16/tjZMW2dOXK80PYMkLbUKME=;
 b=lyPKDL14bUbvB9CaSV5ikMr7+rKKO9ymtQiLP3/aAxtGyfziNBRh3/cxg0tEUELu81IsDq76eNVkhCG1HUAHMDg7awCTRUrMtKCnPPdl7ayQHMRgVuTOiZ8+pxYr4FIxrJmTRW8ia8ePHKLFej0xes/8lStXIxNju/rdYxx2J5vfNlNHYc3Vp5k86M2m9gUbfsy0Q8/CdCL36bICWtCIlTR2nznZGuvTnyUGXsdiS0zPVh6pAuBkIpgk3moF9+ksyIRvmPvLHh8FgCVom+tw+8KKWT7ssErCGHIfPnbBpQExJoPjEaxkiZ33zlDknGHG2e3L6gUsyn9G8GSzePkFYg==
Received: from BL1PR13CA0270.namprd13.prod.outlook.com (2603:10b6:208:2ba::35)
 by PH7PR12MB6563.namprd12.prod.outlook.com (2603:10b6:510:211::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.17; Mon, 5 Feb
 2024 12:49:15 +0000
Received: from MN1PEPF0000F0E0.namprd04.prod.outlook.com
 (2603:10b6:208:2ba:cafe::c3) by BL1PR13CA0270.outlook.office365.com
 (2603:10b6:208:2ba::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.14 via Frontend
 Transport; Mon, 5 Feb 2024 12:49:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000F0E0.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Mon, 5 Feb 2024 12:49:14 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 5 Feb 2024
 04:49:01 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 5 Feb 2024
 04:49:01 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.1258.12 via Frontend Transport; Mon, 5 Feb
 2024 04:48:59 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V1 vfio 5/5] vfio/mlx5: Let firmware knows upon leaving PRE_COPY back to RUNNING
Date: Mon, 5 Feb 2024 14:48:28 +0200
Message-ID: <20240205124828.232701-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20240205124828.232701-1-yishaih@nvidia.com>
References: <20240205124828.232701-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E0:EE_|PH7PR12MB6563:EE_
X-MS-Office365-Filtering-Correlation-Id: fc21b9fa-e1db-41e6-248c-08dc2648dbdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	k6RoMm3sF8BAlVpbqmf32VHBA0np5nXVnFM8pQ0NYWpVHNBkXD9xP5GKjUFsVxMf022HdHZLOzQHHQpYJZJu5nHfIWaPLid6lDzx/HO8BTgsAwUsI8gXs9pJ9GPsk1GoG8qAJ+1s/T2NMinnaMVJd2nv8gVrFk/3mklYsdin0wrmfPIwhUAf9u4vdCAPSCe8k8f0PKIM8Aq/veqZA/6AbpvpqoGYdDr3mMznfKADPAeJmyYhinNPJxmVIuKcQbg4jIifSguCtab9CgP6zD32KfnebD2LsM2gmqVcO7M/B9rZf/rMoAnj7N9MAPFO47IKmJyWguM4oMCM3kUI4ki0x/aYHfix35thrZ2S6zFyl8nGJvAzsxEPfKx7lCLr7V0F5KJ5yn0FcJGP5mwyKrLJAVgji3yqYRYOs5WBNnMAqQRd+5ISeCaTEi+Shwc8W+EqmbrkobDKTV/9LOXDz4eiyIjlXTK5aqgc6aXLFwMwz45XItn/QqAiopS09J5YyhX0YSXsdHXdJbD4RAUZQ8u2oQuoJs9L8jJBUhmR2laM1L2JARP8cmqExUgvfTgVxrKpfTBYetiJLP6LDZQtCVNECZiy725uX0kodvgK4XmgaMODSKugy2RYF8OSzWvMrwYUrY1fBA3t8pCSxQF5nAnPjiOtzYN2LSF7hjCe/bvbPrEMaTmPYMmQWhRIm9mypSvs4yE0piHPaeH2oLC6uXEuWrGDE4zXJx3z9ilOcosRVUAa5C7mCKatMTEYwRZ/k5C/
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(346002)(39860400002)(376002)(230922051799003)(1800799012)(64100799003)(82310400011)(451199024)(186009)(40470700004)(36840700001)(46966006)(40460700003)(40480700001)(41300700001)(47076005)(36860700001)(36756003)(83380400001)(7696005)(6666004)(107886003)(336012)(1076003)(426003)(26005)(2906002)(356005)(82740400003)(7636003)(2616005)(70586007)(6636002)(316002)(70206006)(54906003)(478600001)(110136005)(86362001)(8676002)(4326008)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 12:49:14.5874
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc21b9fa-e1db-41e6-248c-08dc2648dbdc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6563

Let firmware knows upon leaving PRE_COPY back to RUNNING as of some
error in the target/migration cancellation.

This will let firmware cleaning its internal resources that were turned
on upon PRE_COPY.

The flow is based on the device specification in this area.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 14 +++++++++----
 drivers/vfio/pci/mlx5/cmd.h  |  4 +++-
 drivers/vfio/pci/mlx5/main.c | 39 +++++++++++++++++++++++++++++-------
 3 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 6800e4ffe9ee..c54bcd5d0917 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -108,8 +108,9 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 		ret = wait_for_completion_interruptible(&mvdev->saving_migf->save_comp);
 		if (ret)
 			return ret;
-		if (mvdev->saving_migf->state ==
-		    MLX5_MIGF_STATE_PRE_COPY_ERROR) {
+		/* Upon cleanup, ignore previous pre_copy error state */
+		if (mvdev->saving_migf->state == MLX5_MIGF_STATE_PRE_COPY_ERROR &&
+		    !(query_flags & MLX5VF_QUERY_CLEANUP)) {
 			/*
 			 * In case we had a PRE_COPY error, only query full
 			 * image for final image
@@ -200,7 +201,7 @@ void mlx5vf_cmd_close_migratable(struct mlx5vf_pci_core_device *mvdev)
 	/* Must be done outside the lock to let it progress */
 	set_tracker_error(mvdev);
 	mutex_lock(&mvdev->state_mutex);
-	mlx5vf_disable_fds(mvdev);
+	mlx5vf_disable_fds(mvdev, NULL);
 	_mlx5vf_free_page_tracker_resources(mvdev);
 	mlx5vf_state_mutex_unlock(mvdev);
 }
@@ -639,6 +640,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	u32 in[MLX5_ST_SZ_DW(save_vhca_state_in)] = {};
 	struct mlx5_vhca_data_buffer *header_buf = NULL;
 	struct mlx5vf_async_data *async_data;
+	bool pre_copy_cleanup = false;
 	int err;
 
 	lockdep_assert_held(&mvdev->state_mutex);
@@ -649,6 +651,10 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	if (err)
 		return err;
 
+	if ((migf->state == MLX5_MIGF_STATE_PRE_COPY ||
+	     migf->state == MLX5_MIGF_STATE_PRE_COPY_ERROR) && !track && !inc)
+		pre_copy_cleanup = true;
+
 	if (migf->state == MLX5_MIGF_STATE_PRE_COPY_ERROR)
 		/*
 		 * In case we had a PRE_COPY error, SAVE is triggered only for
@@ -667,7 +673,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 
 	async_data = &migf->async_data;
 	async_data->buf = buf;
-	async_data->stop_copy_chunk = !track;
+	async_data->stop_copy_chunk = (!track && !pre_copy_cleanup);
 	async_data->out = kvzalloc(out_size, GFP_KERNEL);
 	if (!async_data->out) {
 		err = -ENOMEM;
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 0d6a2db3d801..707393df36c4 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -197,6 +197,7 @@ struct mlx5vf_pci_core_device {
 enum {
 	MLX5VF_QUERY_INC = (1UL << 0),
 	MLX5VF_QUERY_FINAL = (1UL << 1),
+	MLX5VF_QUERY_CLEANUP = (1UL << 2),
 };
 
 int mlx5vf_cmd_suspend_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod);
@@ -232,7 +233,8 @@ int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 struct page *mlx5vf_get_migration_page(struct mlx5_vhca_data_buffer *buf,
 				       unsigned long offset);
 void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev);
-void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev);
+void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev,
+			enum mlx5_vf_migf_state *last_save_state);
 void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work);
 void mlx5vf_mig_file_set_save_work(struct mlx5_vf_migration_file *migf,
 				   u8 chunk_num, size_t next_required_umem_size);
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index fe09a8c8af95..3982fcf60cf2 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -1146,7 +1146,8 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
 	return ERR_PTR(ret);
 }
 
-void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev)
+void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev,
+			enum mlx5_vf_migf_state *last_save_state)
 {
 	if (mvdev->resuming_migf) {
 		mlx5vf_disable_fd(mvdev->resuming_migf);
@@ -1157,6 +1158,8 @@ void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev)
 	if (mvdev->saving_migf) {
 		mlx5_cmd_cleanup_async_ctx(&mvdev->saving_migf->async_ctx);
 		cancel_work_sync(&mvdev->saving_migf->async_data.work);
+		if (last_save_state)
+			*last_save_state = mvdev->saving_migf->state;
 		mlx5vf_disable_fd(mvdev->saving_migf);
 		wake_up_interruptible(&mvdev->saving_migf->poll_wait);
 		mlx5fv_cmd_clean_migf_resources(mvdev->saving_migf);
@@ -1217,12 +1220,34 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 		return migf->filp;
 	}
 
-	if ((cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP) ||
-	    (cur == VFIO_DEVICE_STATE_PRE_COPY && new == VFIO_DEVICE_STATE_RUNNING) ||
+	if (cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP) {
+		mlx5vf_disable_fds(mvdev, NULL);
+		return NULL;
+	}
+
+	if ((cur == VFIO_DEVICE_STATE_PRE_COPY && new == VFIO_DEVICE_STATE_RUNNING) ||
 	    (cur == VFIO_DEVICE_STATE_PRE_COPY_P2P &&
 	     new == VFIO_DEVICE_STATE_RUNNING_P2P)) {
-		mlx5vf_disable_fds(mvdev);
-		return NULL;
+		struct mlx5_vf_migration_file *migf = mvdev->saving_migf;
+		struct mlx5_vhca_data_buffer *buf;
+		enum mlx5_vf_migf_state state;
+		size_t size;
+
+		ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &size, NULL,
+					MLX5VF_QUERY_INC | MLX5VF_QUERY_CLEANUP);
+		if (ret)
+			return ERR_PTR(ret);
+		buf = mlx5vf_get_data_buffer(migf, size, DMA_FROM_DEVICE);
+		if (IS_ERR(buf))
+			return ERR_CAST(buf);
+		/* pre_copy cleanup */
+		ret = mlx5vf_cmd_save_vhca_state(mvdev, migf, buf, false, false);
+		if (ret) {
+			mlx5vf_put_data_buffer(buf);
+			return ERR_PTR(ret);
+		}
+		mlx5vf_disable_fds(mvdev, &state);
+		return (state != MLX5_MIGF_STATE_ERROR) ? NULL : ERR_PTR(-EIO);
 	}
 
 	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_RESUMING) {
@@ -1244,7 +1269,7 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 			if (ret)
 				return ERR_PTR(ret);
 		}
-		mlx5vf_disable_fds(mvdev);
+		mlx5vf_disable_fds(mvdev, NULL);
 		return NULL;
 	}
 
@@ -1289,7 +1314,7 @@ void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev)
 		mvdev->deferred_reset = false;
 		spin_unlock(&mvdev->reset_lock);
 		mvdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
-		mlx5vf_disable_fds(mvdev);
+		mlx5vf_disable_fds(mvdev, NULL);
 		goto again;
 	}
 	mutex_unlock(&mvdev->state_mutex);
-- 
2.18.1


