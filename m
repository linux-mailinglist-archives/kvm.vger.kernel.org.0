Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92AD55B059
	for <lists+kvm@lfdr.de>; Sun, 26 Jun 2022 10:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbiFZIkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jun 2022 04:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234030AbiFZIkk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jun 2022 04:40:40 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF7C12AF3
        for <kvm@vger.kernel.org>; Sun, 26 Jun 2022 01:40:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJhyresg7zCz2zdEM8Vr8rpzXebTtVk+XB3yLiwHsK/ZCQ/e0ilFIKcYymE5zxYHq0X9PIVL/ylthC8FgmLbhtVzPsOm7Xlp3firqa4LMq2w0X6vadjALfPVNtEhROQbixgTalRQ+zO0mcHppk6jzV08haroE9wfKLL4p9uWe2kzVzKOAMcTPTS3HHJXMRjVUIp7GygznQEOqcGwIsq9QGYyVKyjCK6JSOUyOTKJuERx4ecALMp4PRDfYsCGzgD4uYpZdFKAsRWGCH091K8XaCF+FtFuBcN5puslGrMw42GOeLiyR5omcjsOvPEP7MSK/AwMpRjTSz3ypkU8VW+Cdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ODaPmzfkff+5ZsYDAeBUF9cNN3ach0C1hlAzHsDzc6Q=;
 b=ntkrnL97ZJBLBBLfXob2uk1stwYde9FMjgsAx4qarSAOkYtGLXDE+Fejs8KGryVLCTcH1mwozVHYzcteWv5wPXdd7oJXTHgNXRWe3IVurDqROxgrpkuMTw+YczELLF49cK1d5+B3h5pe207iWHX6KFZ5mFPvZ3O31o3okkp9WmdsfFxKw2IAvtbqFEEMyA2i+f/d+hsoU38lQ3BoVEKfyN7XknBYVVQNU4icOc+ZzaHa7CmFGjJhGoIKc4jaEOJE+V6xOVlibqHbDaqVoMTeFWPYZH4KnwUjhSmIpPDfQ9Uba9N95WwgqQsf2yyQNkKo9JVkT1rbg+8jMPKMVnGmyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ODaPmzfkff+5ZsYDAeBUF9cNN3ach0C1hlAzHsDzc6Q=;
 b=Prggq9KC6w+hO6LzbnDj05o7293shdA0AiR4LxY+RC5jq0TC1bO57sj1oixxXdAMfDDFos95/ZAfY+UCoqCDGqxc7Y06roPs9ZZFWnsp7ChuQrD37JwSS4/JoOOPN2GfGehL/eI5tjdLwG82v1a8pq1lWk0bLzKeHoj9+0em8cAcoyHyF2yH0GFdFR40cN/qR/gjtLfO6DR7PFEKwmZqZN4OM1TtuaXH1Me+dEtled9zERYY/yIBRPs/xrrPw4MBJU4GzxBNIBwmOiJkIFjrmdhJzDt1lT3MD4uZHcbfpGAhp5TSZbpQnsJa9tXnt2pI+PPZYOiOn+nizomxJ5KunA==
Received: from BN9PR03CA0474.namprd03.prod.outlook.com (2603:10b6:408:139::29)
 by CH2PR12MB4200.namprd12.prod.outlook.com (2603:10b6:610:ac::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Sun, 26 Jun
 2022 08:40:36 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::cb) by BN9PR03CA0474.outlook.office365.com
 (2603:10b6:408:139::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16 via Frontend
 Transport; Sun, 26 Jun 2022 08:40:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Sun, 26 Jun 2022 08:40:36 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 26 Jun
 2022 08:40:35 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 26 Jun
 2022 01:40:34 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Sun, 26 Jun
 2022 01:40:32 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kvm@vger.kernel.org>
CC:     <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <kevin.tian@intel.com>, <shameerali.kolothum.thodi@huawei.com>,
        <liulongfang@huawei.com>
Subject: [PATCH V1 vfio 2/2] vfio: Split migration ops from main device ops
Date:   Sun, 26 Jun 2022 11:39:58 +0300
Message-ID: <20220626083958.54175-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220626083958.54175-1-yishaih@nvidia.com>
References: <20220626083958.54175-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eaba1fc8-383a-4dd0-ea04-08da574f8a82
X-MS-TrafficTypeDiagnostic: CH2PR12MB4200:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iEOHhJtbvaLisGyH6F0f7GsuREG3VIXE4JrGgdZuN+5aN5Mk9B5aWRGa2XhD9oKNSuM9cktE6pVJvzL8Um1lj/s+L9ENFROQs4VRG1sOtr7gNYOhUV4uRFD3zvOH7HqFF5H+goaYKJwegONzuwGcvyfFFGl2eFVvVV4C1zCSbkfCsDNfq/tlq2BNTLuaAuXZWGocVASVlN9LlPqmI3AKjrOiCjOJwa08mgdpIVex6+n2mQOrHsXlO173yRz8gPcA6KFwnhjMoMJ2hq65Mwzch0hZhV3Os5Ki2jYCbsFUO+XcUegK5Zoq1EFCN07IWRB/rnyFpkJd1vcHTpCyWYz8xfzPyc8l3V4M136VmCXN2MFx1tTVUmN/qERXtA8uMphz+KbWi7CzzuwBNcGvrS5jnPHIgnDcS98R7PE7G4kURdJR2UWpoKMrTi+9cBihNo5Iry+68oTlPfFXNI70Rqrg9hRuvXnVdzIuKz44BcRI1LvrWjx56YYNjk6fCR+JrLlSXrUVtc++Y4pAIHMWrhLvIOfDAqn0Ekp18iImsZJSxnM4sCFok2ZV2wAivmDl5A7wUh/Vn+De4+5AOT4CiK2689PAgNB65K1XTpOiIHh5GaE3hWgjyXr6Dy/YfJDCWLcMiyuWcC80A6EGiAft9yom/zh/hA0Bazj26yvk4L2nsfh4Fb1NJ6K5MOHEFTpsESGvHn6PclUl3mEgGgcZnmBohp4EYi9ONbp4XyBetzWB+XQW+tz3WPVZ2BJmrI3MBpJsVg8Zm/8rxsioab6LABF3kztuXsEZZ3fUA8qbgMkGyhHrMn6EqmHfcSWQXJygl68oRUlQg9HQA5kIB4gzTVl2TA==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(39860400002)(136003)(40470700004)(46966006)(36840700001)(5660300002)(83380400001)(82310400005)(41300700001)(6666004)(36756003)(26005)(426003)(47076005)(336012)(36860700001)(2616005)(8676002)(2906002)(478600001)(40460700003)(86362001)(186003)(70586007)(356005)(8936002)(316002)(7696005)(110136005)(1076003)(81166007)(70206006)(40480700001)(54906003)(4326008)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2022 08:40:36.1871
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eaba1fc8-383a-4dd0-ea04-08da574f8a82
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4200
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

As part of that, changed HISI driver to match this scheme.

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
 drivers/vfio/vfio.c                           | 13 ++++----
 include/linux/vfio.h                          | 30 ++++++++++++-------
 6 files changed, 46 insertions(+), 24 deletions(-)

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
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index e22be13e6771..453dc2464969 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1534,8 +1534,8 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
 	struct file *filp = NULL;
 	int ret;
 
-	if (!device->ops->migration_set_state ||
-	    !device->ops->migration_get_state)
+	if (!device->mig_ops->migration_set_state ||
+	    !device->mig_ops->migration_get_state)
 		return -ENOTTY;
 
 	ret = vfio_check_feature(flags, argsz,
@@ -1551,7 +1551,8 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
 	if (flags & VFIO_DEVICE_FEATURE_GET) {
 		enum vfio_device_mig_state curr_state;
 
-		ret = device->ops->migration_get_state(device, &curr_state);
+		ret = device->mig_ops->migration_get_state(device,
+							   &curr_state);
 		if (ret)
 			return ret;
 		mig.device_state = curr_state;
@@ -1559,7 +1560,7 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
 	}
 
 	/* Handle the VFIO_DEVICE_FEATURE_SET */
-	filp = device->ops->migration_set_state(device, mig.device_state);
+	filp = device->mig_ops->migration_set_state(device, mig.device_state);
 	if (IS_ERR(filp) || !filp)
 		goto out_copy;
 
@@ -1582,8 +1583,8 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
 	};
 	int ret;
 
-	if (!device->ops->migration_set_state ||
-	    !device->ops->migration_get_state)
+	if (!device->mig_ops->migration_set_state ||
+	    !device->mig_ops->migration_get_state)
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

