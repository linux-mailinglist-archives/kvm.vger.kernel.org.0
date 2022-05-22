Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D3E530228
	for <lists+kvm@lfdr.de>; Sun, 22 May 2022 11:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243043AbiEVJse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 May 2022 05:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239763AbiEVJsd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 May 2022 05:48:33 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0783982B
        for <kvm@vger.kernel.org>; Sun, 22 May 2022 02:48:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lCHpElw0tuEMaAPsioRyzFl/b6Wi4cTuUF8SYIVqbUBq6vWpWwUqgjpEKw6cYo2tmhEo8XUl3gk6HtCPIZW6OsqLlxDtL6N5h8X36EcYvwcNSBcn6nXi5w1n+JAe7ZiBwvHxTmIukiS4vGQQcnEVyKckyHGbO2xm0uqaqU2/1vo9L4qIpaYzY/mauMSYf+gCVoLmDtU8Q9XnTIIRC3PY6u0BSbznVjNtOW3hHcE4VTTJFQQmEcQzKh5x0/OMzFdb62w8OlYw/JWHXM9Rqc6/G/+bkNwrXmks17UPfXhmqqxPzUaRM4eLJtHqN58wIqSgoyPXC4PV8JMarfq9MB5wMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xckL2O8fVGz420TRn3RphWjYE45+NNqHWOFO0nAy6Rg=;
 b=ZAl5f32QYK43zBB2TOxVpznKkS1OcPexitpHdd2K3wDx2InMm0vZmd+/P83VLvcPEkfhxhbOx0HUpdvzsgxB15YZkvYwFLiMVPFYbPpeHTNGEqYImMdc9nomrZ7dkyJxB4WhN44PzvKHPb4kFAOi7Iu4DG/+cR/7WfmElHBi57Q0aYnaekXVlTjT9TpLhZ95BHbkRQ+zkO6KHgtGG9oI7h+Ue6dBOJXqzkias7Djamp1g6P+nJr4q8ZVdubjx5zLNwjRsp2dUBeslgFU6e7LWcKlLZXfkImixKmVP8MRa2JWspDKHsmu8GCw1eOcm/7C3TqTWTpE+mYa6rmP/XKH+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xckL2O8fVGz420TRn3RphWjYE45+NNqHWOFO0nAy6Rg=;
 b=emNCxdZxCC0NHDWs9l5Qg6tyHL2gChijnlx3VIJpeuFpKYoOAMWwjTHcV09TCfHtO7cy+oZcU+KWPzf4DDDmH5wb2+mQNzhfOrwjnAffSNQS1tX/3aLyXybx74vEvI1jsIXZUWmpY8V6xQHlKMTsHALvfMeI78pPxmFbLn4rziWXxthnV55vrjH596NWuB/2Zu66uOgV5IWYkl1g+Qg0G+5oyHUY1wpv51tR5eorHoWidalJ25KslOeT19MVlWi53Uw2eETYfu55y+vGq884QrOy79TyKtSGyBFWkvv+COaPVxBo0uWA+S/oPi413mHRuhuIdGkRnOlq1r8rA7+pBA==
Received: from MW4PR04CA0211.namprd04.prod.outlook.com (2603:10b6:303:87::6)
 by BYAPR12MB4741.namprd12.prod.outlook.com (2603:10b6:a03:a2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Sun, 22 May
 2022 09:48:28 +0000
Received: from CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::47) by MW4PR04CA0211.outlook.office365.com
 (2603:10b6:303:87::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15 via Frontend
 Transport; Sun, 22 May 2022 09:48:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT005.mail.protection.outlook.com (10.13.174.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5273.14 via Frontend Transport; Sun, 22 May 2022 09:48:27 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 22 May
 2022 09:48:27 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 22 May
 2022 02:48:26 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Sun, 22 May
 2022 02:48:21 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kvm@vger.kernel.org>
CC:     <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <kevin.tian@intel.com>, <shameerali.kolothum.thodi@huawei.com>,
        <liulongfang@huawei.com>
Subject: [PATCH] vfio: Split migration ops from main device ops
Date:   Sun, 22 May 2022 12:47:56 +0300
Message-ID: <20220522094756.219881-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16992858-c5b1-4a14-cdb9-08da3bd838eb
X-MS-TrafficTypeDiagnostic: BYAPR12MB4741:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB4741BB3A171DE47C1784095DC3D59@BYAPR12MB4741.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pzr9hhq7sFeCVa230mWhbkSVi5NJXOpIS0wTJ1ppppd5w2AvY+vtFmvWlgHeBaJJdBuT8zj5KGOmWyN2tlRMOkHsIlVUF8EQnBD6rlUQmrJu4C2oCLqvJ/G1zC+EV+aEN+c1aXAvIMx2gqF3hYGwZU+fQY7tEsxXxjCcp7MHloahtqXuk+jSNzoiPSMz7ttmXhoRy29RM0iv+MBxPKZ35iM5OdcQmJHNvZZPf+R4BkJAyzNbc8sWNUayW3HxhG7uLMTbYT8IYUQyDHlje3L/SOHVBBw7MzmBmlajKiJ4MGlpoBRFwsbRiX6Eua3EkYFa9JkR0pYQbpp4wjb3Udc4KM3Z0Fh39Ff2vQv1HNxVZzzq2pfWHGZkmdYRoRjmRSFYaw1uH8w3ngdGO6PGp1mZ4DohcKeNXvdYg6NAuZDh3y4aLdqEyJX8DwkW3UmsJu18Kzx3jhkDZazvzzD6LawOHOwYc9SVoaxL2JxritC1t2X4DA0tGBRLPywGSAE3yvBEB8qf4Vi2qAKO0iIJu1aVh1D5JgHYoBYdoeO+Rn4Fy94iXqwNZCyuyDJzUS6H8WwHPaFCpX/JMc6cOmLPxJSFEq9Am/fhfIyU2JfQwPY6lr+tNupUNVf3cv36thPEU30gk0wHEpfAmLt2M4fXrm9G0dga4jQojHyoHDJBPvBwHjl8kAWX94rFzOuufcwZMvERnjH4cVj3M+/wiC6t9hPjRA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(7696005)(6666004)(1076003)(36756003)(426003)(83380400001)(82310400005)(2616005)(47076005)(508600001)(26005)(36860700001)(2906002)(356005)(81166007)(8936002)(40460700003)(4326008)(5660300002)(110136005)(186003)(336012)(70206006)(70586007)(316002)(8676002)(86362001)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2022 09:48:27.8892
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16992858-c5b1-4a14-cdb9-08da3bd838eb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4741
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio core checks whether the driver sets some migration op (e.g.
set_state/get_state) and accordingly calls its op.

However, currently mlx5 driver sets the above ops without regards to its
migration caps.

This might lead to unexpected usage/Oops if user space may call to the
above ops even if the driver doesn't support migration. As for example,
the migration state_mutex is not initialized in that case.

The cleanest way to manage that seems to split the migration ops from
the main device ops, this will let the driver setting them separately
from the main ops when it's applicable.

As part of that, cleaned-up HISI driver to match this scheme.

This scheme may enable down the road to come with some extra group of
ops (e.g. DMA log) that can be set without regards to the other options
based on driver caps.

Fixes: 6fadb021266d ("vfio/mlx5: Implement vfio_pci driver for mlx5 devices")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 27 +++++--------------
 drivers/vfio/pci/mlx5/cmd.c                   |  4 ++-
 drivers/vfio/pci/mlx5/cmd.h                   |  3 ++-
 drivers/vfio/pci/mlx5/main.c                  |  9 ++++---
 drivers/vfio/vfio.c                           | 13 ++++-----
 include/linux/vfio.h                          | 26 +++++++++++-------
 6 files changed, 40 insertions(+), 42 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index e92376837b29..cfe9c8925d68 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1208,17 +1208,7 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
 	vfio_pci_core_close_device(core_vdev);
 }
 
-static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
-	.name = "hisi-acc-vfio-pci-migration",
-	.open_device = hisi_acc_vfio_pci_open_device,
-	.close_device = hisi_acc_vfio_pci_close_device,
-	.ioctl = hisi_acc_vfio_pci_ioctl,
-	.device_feature = vfio_pci_core_ioctl_feature,
-	.read = hisi_acc_vfio_pci_read,
-	.write = hisi_acc_vfio_pci_write,
-	.mmap = hisi_acc_vfio_pci_mmap,
-	.request = vfio_pci_core_request,
-	.match = vfio_pci_core_match,
+static const struct vfio_migration_ops hisi_acc_vfio_pci_migrn_ops = {
 	.migration_set_state = hisi_acc_vfio_pci_set_device_state,
 	.migration_get_state = hisi_acc_vfio_pci_get_device_state,
 };
@@ -1266,20 +1256,15 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
 	if (!hisi_acc_vdev)
 		return -ENOMEM;
 
+	vfio_pci_core_init_device(&hisi_acc_vdev->core_device, pdev,
+				  &hisi_acc_vfio_pci_ops);
 	pf_qm = hisi_acc_get_pf_qm(pdev);
 	if (pf_qm && pf_qm->ver >= QM_HW_V3) {
 		ret = hisi_acc_vfio_pci_migrn_init(hisi_acc_vdev, pdev, pf_qm);
-		if (!ret) {
-			vfio_pci_core_init_device(&hisi_acc_vdev->core_device, pdev,
-						  &hisi_acc_vfio_pci_migrn_ops);
-		} else {
+		if (!ret)
+			hisi_acc_vdev->core_device.vdev.mig_ops = &hisi_acc_vfio_pci_migrn_ops;
+		else
 			pci_warn(pdev, "migration support failed, continue with generic interface\n");
-			vfio_pci_core_init_device(&hisi_acc_vdev->core_device, pdev,
-						  &hisi_acc_vfio_pci_ops);
-		}
-	} else {
-		vfio_pci_core_init_device(&hisi_acc_vdev->core_device, pdev,
-					  &hisi_acc_vfio_pci_ops);
 	}
 
 	dev_set_drvdata(&pdev->dev, &hisi_acc_vdev->core_device);
diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 9b9f33ca270a..334806c024b1 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -98,7 +98,8 @@ void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev)
 	destroy_workqueue(mvdev->cb_wq);
 }
 
-void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev)
+void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
+			       const struct vfio_migration_ops *mig_ops)
 {
 	struct pci_dev *pdev = mvdev->core_device.pdev;
 	int ret;
@@ -139,6 +140,7 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev)
 	mvdev->core_device.vdev.migration_flags =
 		VFIO_MIGRATION_STOP_COPY |
 		VFIO_MIGRATION_P2P;
+	mvdev->core_device.vdev.mig_ops = mig_ops;
 
 end:
 	mlx5_vf_put_core_dev(mvdev->mdev);
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 6c3112fdd8b1..7b9e3d56158e 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -62,7 +62,8 @@ int mlx5vf_cmd_suspend_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod);
 int mlx5vf_cmd_resume_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod);
 int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 					  size_t *state_size);
-void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev);
+void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
+			       const struct vfio_migration_ops *mig_ops);
 void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev);
 int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 			       struct mlx5_vf_migration_file *migf);
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index dd1009b5ff9c..73998e4778c8 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -574,6 +574,11 @@ static void mlx5vf_pci_close_device(struct vfio_device *core_vdev)
 	vfio_pci_core_close_device(core_vdev);
 }
 
+static const struct vfio_migration_ops mlx5vf_pci_mig_ops = {
+	.migration_set_state = mlx5vf_pci_set_device_state,
+	.migration_get_state = mlx5vf_pci_get_device_state,
+};
+
 static const struct vfio_device_ops mlx5vf_pci_ops = {
 	.name = "mlx5-vfio-pci",
 	.open_device = mlx5vf_pci_open_device,
@@ -585,8 +590,6 @@ static const struct vfio_device_ops mlx5vf_pci_ops = {
 	.mmap = vfio_pci_core_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
-	.migration_set_state = mlx5vf_pci_set_device_state,
-	.migration_get_state = mlx5vf_pci_get_device_state,
 };
 
 static int mlx5vf_pci_probe(struct pci_dev *pdev,
@@ -599,7 +602,7 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 	if (!mvdev)
 		return -ENOMEM;
 	vfio_pci_core_init_device(&mvdev->core_device, pdev, &mlx5vf_pci_ops);
-	mlx5vf_cmd_set_migratable(mvdev);
+	mlx5vf_cmd_set_migratable(mvdev, &mlx5vf_pci_mig_ops);
 	dev_set_drvdata(&pdev->dev, &mvdev->core_device);
 	ret = vfio_pci_core_register_device(&mvdev->core_device);
 	if (ret)
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index cfcff7764403..5bc678547f1f 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1510,8 +1510,8 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
 	struct file *filp = NULL;
 	int ret;
 
-	if (!device->ops->migration_set_state ||
-	    !device->ops->migration_get_state)
+	if (!device->mig_ops->migration_set_state ||
+	    !device->mig_ops->migration_get_state)
 		return -ENOTTY;
 
 	ret = vfio_check_feature(flags, argsz,
@@ -1527,7 +1527,8 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
 	if (flags & VFIO_DEVICE_FEATURE_GET) {
 		enum vfio_device_mig_state curr_state;
 
-		ret = device->ops->migration_get_state(device, &curr_state);
+		ret = device->mig_ops->migration_get_state(device,
+							   &curr_state);
 		if (ret)
 			return ret;
 		mig.device_state = curr_state;
@@ -1535,7 +1536,7 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
 	}
 
 	/* Handle the VFIO_DEVICE_FEATURE_SET */
-	filp = device->ops->migration_set_state(device, mig.device_state);
+	filp = device->mig_ops->migration_set_state(device, mig.device_state);
 	if (IS_ERR(filp) || !filp)
 		goto out_copy;
 
@@ -1558,8 +1559,8 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
 	};
 	int ret;
 
-	if (!device->ops->migration_set_state ||
-	    !device->ops->migration_get_state)
+	if (!device->mig_ops->migration_set_state ||
+	    !device->mig_ops->migration_get_state)
 		return -ENOTTY;
 
 	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_GET,
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 45b287826ce6..1a1f61803742 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -32,6 +32,7 @@ struct vfio_device_set {
 struct vfio_device {
 	struct device *dev;
 	const struct vfio_device_ops *ops;
+	const struct vfio_migration_ops *mig_ops;
 	struct vfio_group *group;
 	struct vfio_device_set *dev_set;
 	struct list_head dev_set_list;
@@ -59,16 +60,6 @@ struct vfio_device {
  *         match, -errno for abort (ex. match with insufficient or incorrect
  *         additional args)
  * @device_feature: Optional, fill in the VFIO_DEVICE_FEATURE ioctl
- * @migration_set_state: Optional callback to change the migration state for
- *         devices that support migration. It's mandatory for
- *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
- *         The returned FD is used for data transfer according to the FSM
- *         definition. The driver is responsible to ensure that FD reaches end
- *         of stream or error whenever the migration FSM leaves a data transfer
- *         state or before close_device() returns.
- * @migration_get_state: Optional callback to get the migration state for
- *         devices that support migration. It's mandatory for
- *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
  */
 struct vfio_device_ops {
 	char	*name;
@@ -85,6 +76,21 @@ struct vfio_device_ops {
 	int	(*match)(struct vfio_device *vdev, char *buf);
 	int	(*device_feature)(struct vfio_device *device, u32 flags,
 				  void __user *arg, size_t argsz);
+};
+
+/**
+ * @migration_set_state: Optional callback to change the migration state for
+ *         devices that support migration. It's mandatory for
+ *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
+ *         The returned FD is used for data transfer according to the FSM
+ *         definition. The driver is responsible to ensure that FD reaches end
+ *         of stream or error whenever the migration FSM leaves a data transfer
+ *         state or before close_device() returns.
+ * @migration_get_state: Optional callback to get the migration state for
+ *         devices that support migration. It's mandatory for
+ *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
+ */
+struct vfio_migration_ops {
 	struct file *(*migration_set_state)(
 		struct vfio_device *device,
 		enum vfio_device_mig_state new_state);
-- 
2.18.1

