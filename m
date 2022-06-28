Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4797055E41B
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345051AbiF1NNL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 09:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345583AbiF1NNJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 09:13:09 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B634128B
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 06:13:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YCLI4PcDPfAeTfLUfXXBGMzp391j7PGz7QsO+nHdszuUeohFqpK736OzBBr+zYT18DCEWjCf9LGTWAIZzIPRajQOJH59gXrZF1jRHY5hE+sem0pwZbft2WtASk5bj/QB5aUVVRqIUPmNjiBfHJq5QLAIDWAl+yqR2tDpYR0YMHK46dC9vYs+a3pMFXbgbBmUz0iuAZr21T528/1W5ecO3/BwL0hgglSrRDi9HJsjxCSM6j6AX/Fuo3W5TlobgYBFSkVxPPdzqhdabl+163rhypZU5h2fJpi0bsf8wtvnOfp7RGSnf92CF2bjWJHX7eycVT9hoLlTAYmBtbL9AnqJlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uC9/bnD9q5Va3GjZDNllPtEd1sDxK+UNVvcUUD2F7Wk=;
 b=DXQ72Q/3kzwrpYi1H93HuUYWQX8zbtJ2XZoK9HEfvPaRpWdhcQH7oSHW9fIROmDUi3UYSxvpsVR3iEkxiv494nnU2Xu4CpcwTnQr4Ye13cQ1fkX4h2Cg9UKEUIzIbLY4H+zjbYmY4y2tqvWNrEwV6eXdki7IwkxIFh31fY9h8y9tX//+FHVuOAJLi8IDvLyGid+vZAzLcIX3BE9X7LN1ADoPig7IW69jS9Y2I//kZqAZcQNsdEHlNGbo8Z2YIwM6BRhOuEhWXb6V8t1uq4StZ9ODWlYTcFPMeZLGCqv6WwB94OESiU4PWKsg6AiysrZ2m5AyCeemBGdgxv73n0CGsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uC9/bnD9q5Va3GjZDNllPtEd1sDxK+UNVvcUUD2F7Wk=;
 b=e4zfDqNFvi8r1ZU75kgqQDt1xXOjcGQGNk34VRdof2x8VOEHGYZAjOpIIiFSL7mjgviMdM6yC2EBilM4E8WQA/zq4jPJJVRAq7KMtxgGo5w3PjMCDTAiZHwQHQRcLf4+rEsRf4oahbdWSkL3dvvXgXZ5vAYKcss9k8Tne/OoLR3hAP/DjQILJQuf+jId6+D2xox9QbZKFEuTEryRzgI9fcstobwr3/URQo0YIN1LZM54XqlgbUd8DPsUm8MEXUKtGQqRwsJQ/VaGtqArfKuXL1ZKw62P2b9VpF+MPBTT4xXxOAL//BLIWGxv8ydLZQDpvL2H2X2Ch+bqnHXdqM9Djw==
Received: from DM6PR03CA0075.namprd03.prod.outlook.com (2603:10b6:5:333::8) by
 DM6PR12MB4313.namprd12.prod.outlook.com (2603:10b6:5:21e::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.17; Tue, 28 Jun 2022 13:13:03 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::1c) by DM6PR03CA0075.outlook.office365.com
 (2603:10b6:5:333::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Tue, 28 Jun 2022 13:13:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Tue, 28 Jun 2022 13:13:02 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 28 Jun 2022 13:13:02 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 28 Jun 2022 06:13:01 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Tue, 28 Jun 2022 06:12:59 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kvm@vger.kernel.org>
CC:     <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <kevin.tian@intel.com>, <shameerali.kolothum.thodi@huawei.com>,
        <liulongfang@huawei.com>
Subject: [PATCH V2 vfio 2/2] vfio: Split migration ops from main device ops
Date:   Tue, 28 Jun 2022 16:12:13 +0300
Message-ID: <20220628131213.165730-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220628131213.165730-1-yishaih@nvidia.com>
References: <20220628131213.165730-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7007c745-a6c3-4958-7788-08da5907eeb1
X-MS-TrafficTypeDiagnostic: DM6PR12MB4313:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tg8wKJ6Ft8kUX4DXUFzkKkAbC72Do09KkToNa3TAxPmModx2Vqk89wxhwp6gN/3M2ouvudigKqJbHOvtER+EcJcF8qTy9yxEMh4KmoOTZYuKWcGQXZMPMBFiyzpWEJvGWQ/xaKc9OTBNUpB/sTSrcLeldjpMVlOyNST0821KG+7bf6EYMLCjAGXbOBGMW7rVwN8t8xbxTYfIWsen3AoKBomkA9KMhHH75G0lmSWF2KpPAMdtYO7rlyAM0U+2U6tZ7mS6Wc1tyGs1Bi+7jqc9EbnFyCBElOBac+b95vkohC0ayWOHaTMLBp5YxI8TcjzkHZqLGi6Fg58vCs1Eb4OSBB+pBlpsyX+OE0xQCywvL0sAQD268SohJChtNgWPAfL4KmsHiiXg7PDatZy3Qct3J8E+rRYgt+gXeq8HgPlW7EeEyd+VDAcW9pe47GvGFJCIOtMeAaD+3LXUEsZ0nsxrOUu39NyzbWUMmngDZg6qBLYSRzzm8YhFXwdGNlngLgaq1eIAJi7BQQxCuPqDpvpET5zSVcTjwjqJcwR80ftI9wlMZJxwUz47yvTltlZMPQlOjctqmkbmcAOmny72nEcrD3v27D/2vhZ80itvZ7pr+m0kNixPIuR/RoWnzPJmPYqPmMtEYlvwB7x8pBgXyqVpd/QvXx25iocJxDhhcNIEuYsW/eEyprKCa0JyTaC5rLQ8cnF45QpG5+EQnqpWOJBjxWXBvgh3ocUZkBf1FlPtg2fK7KBv8J5AgfnVwdeVKhMT3kM/ooNnbjUQnbpGwi/TycjLTShCwWam8Ub5cNfHeF1p+MhMrnNgBWT5a5o3YpNoZd8Dk62gf/MCrr1Kuby0SQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(376002)(396003)(136003)(46966006)(36840700001)(40470700004)(8676002)(83380400001)(40460700003)(40480700001)(81166007)(70586007)(36860700001)(7696005)(30864003)(336012)(356005)(70206006)(426003)(4326008)(8936002)(186003)(26005)(478600001)(1076003)(5660300002)(36756003)(316002)(54906003)(82310400005)(41300700001)(110136005)(47076005)(82740400003)(86362001)(6666004)(2616005)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 13:13:02.9347
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7007c745-a6c3-4958-7788-08da5907eeb1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4313
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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

As part of that, validate ops construction on registration and include a
check for VFIO_MIGRATION_STOP_COPY since the uAPI claims it must be set
in migration_flags.

HISI driver was changed as well to match this scheme.

This scheme may enable down the road to come with some extra group of
ops (e.g. DMA log) that can be set without regards to the other options
based on driver caps.

Fixes: 6fadb021266d ("vfio/mlx5: Implement vfio_pci driver for mlx5 devices")
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 11 +++++--
 drivers/vfio/pci/mlx5/cmd.c                   |  4 ++-
 drivers/vfio/pci/mlx5/cmd.h                   |  3 +-
 drivers/vfio/pci/mlx5/main.c                  |  9 ++++--
 drivers/vfio/pci/vfio_pci_core.c              |  7 +++++
 drivers/vfio/vfio.c                           | 11 ++++---
 include/linux/vfio.h                          | 30 ++++++++++++-------
 7 files changed, 51 insertions(+), 24 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 4def43f5f7b6..ea762e28c1cc 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1185,7 +1185,7 @@ static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
 	if (ret)
 		return ret;
 
-	if (core_vdev->ops->migration_set_state) {
+	if (core_vdev->mig_ops) {
 		ret = hisi_acc_vf_qm_init(hisi_acc_vdev);
 		if (ret) {
 			vfio_pci_core_disable(vdev);
@@ -1208,6 +1208,11 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
 	vfio_pci_core_close_device(core_vdev);
 }
 
+static const struct vfio_migration_ops hisi_acc_vfio_pci_migrn_state_ops = {
+	.migration_set_state = hisi_acc_vfio_pci_set_device_state,
+	.migration_get_state = hisi_acc_vfio_pci_get_device_state,
+};
+
 static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
 	.name = "hisi-acc-vfio-pci-migration",
 	.open_device = hisi_acc_vfio_pci_open_device,
@@ -1219,8 +1224,6 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
 	.mmap = hisi_acc_vfio_pci_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
-	.migration_set_state = hisi_acc_vfio_pci_set_device_state,
-	.migration_get_state = hisi_acc_vfio_pci_get_device_state,
 };
 
 static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
@@ -1272,6 +1275,8 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
 		if (!ret) {
 			vfio_pci_core_init_device(&hisi_acc_vdev->core_device, pdev,
 						  &hisi_acc_vfio_pci_migrn_ops);
+			hisi_acc_vdev->core_device.vdev.mig_ops =
+					&hisi_acc_vfio_pci_migrn_state_ops;
 		} else {
 			pci_warn(pdev, "migration support failed, continue with generic interface\n");
 			vfio_pci_core_init_device(&hisi_acc_vdev->core_device, pdev,
diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index cdd0c667dc77..dd5d7bfe0a49 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -108,7 +108,8 @@ void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev)
 	destroy_workqueue(mvdev->cb_wq);
 }
 
-void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev)
+void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
+			       const struct vfio_migration_ops *mig_ops)
 {
 	struct pci_dev *pdev = mvdev->core_device.pdev;
 	int ret;
@@ -149,6 +150,7 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev)
 	mvdev->core_device.vdev.migration_flags =
 		VFIO_MIGRATION_STOP_COPY |
 		VFIO_MIGRATION_P2P;
+	mvdev->core_device.vdev.mig_ops = mig_ops;
 
 end:
 	mlx5_vf_put_core_dev(mvdev->mdev);
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index aa692d9ce656..8208f4701a90 100644
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
 void mlx5vf_cmd_close_migratable(struct mlx5vf_pci_core_device *mvdev);
 int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index d754990f0662..a9b63d15c5d3 100644
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
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a0d69ddaf90d..46efb4a0aadf 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1855,6 +1855,13 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
 		return -EINVAL;
 
+	if (vdev->vdev.mig_ops) {
+		if ((!(vdev->vdev.mig_ops->migration_get_state &&
+		       vdev->vdev.mig_ops->migration_get_state)) ||
+		    (!(vdev->vdev.migration_flags & VFIO_MIGRATION_STOP_COPY)))
+			return -EINVAL;
+	}
+
 	/*
 	 * Prevent binding to PFs with VFs enabled, the VFs might be in use
 	 * by the host or other users.  We cannot capture the VFs if they
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index e22be13e6771..ccbd106b95d8 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1534,8 +1534,7 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
 	struct file *filp = NULL;
 	int ret;
 
-	if (!device->ops->migration_set_state ||
-	    !device->ops->migration_get_state)
+	if (!device->mig_ops)
 		return -ENOTTY;
 
 	ret = vfio_check_feature(flags, argsz,
@@ -1551,7 +1550,8 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
 	if (flags & VFIO_DEVICE_FEATURE_GET) {
 		enum vfio_device_mig_state curr_state;
 
-		ret = device->ops->migration_get_state(device, &curr_state);
+		ret = device->mig_ops->migration_get_state(device,
+							   &curr_state);
 		if (ret)
 			return ret;
 		mig.device_state = curr_state;
@@ -1559,7 +1559,7 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
 	}
 
 	/* Handle the VFIO_DEVICE_FEATURE_SET */
-	filp = device->ops->migration_set_state(device, mig.device_state);
+	filp = device->mig_ops->migration_set_state(device, mig.device_state);
 	if (IS_ERR(filp) || !filp)
 		goto out_copy;
 
@@ -1582,8 +1582,7 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
 	};
 	int ret;
 
-	if (!device->ops->migration_set_state ||
-	    !device->ops->migration_get_state)
+	if (!device->mig_ops)
 		return -ENOTTY;
 
 	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_GET,
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index aa888cc51757..d6c592565be7 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -32,6 +32,11 @@ struct vfio_device_set {
 struct vfio_device {
 	struct device *dev;
 	const struct vfio_device_ops *ops;
+	/*
+	 * mig_ops is a static property of the vfio_device which must be set
+	 * prior to registering the vfio_device.
+	 */
+	const struct vfio_migration_ops *mig_ops;
 	struct vfio_group *group;
 	struct vfio_device_set *dev_set;
 	struct list_head dev_set_list;
@@ -61,16 +66,6 @@ struct vfio_device {
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
@@ -87,6 +82,21 @@ struct vfio_device_ops {
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

