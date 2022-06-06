Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC9653E9CA
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 19:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbiFFI5c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 04:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbiFFI50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 04:57:26 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2084.outbound.protection.outlook.com [40.107.237.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240B91835C
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 01:57:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TD1mk5zz4ANb6hG3yJyqJPlqTUjYQQAmTqmw/ePxTaCONacmxCXdCUZaq3J9QezVyffQKkMI0PXZ6+7GcuFeEunbZDck7J73krNCQzl5Axz10aHDY2zlFCWlgo6ioTSRTl9dzq0rSCY9/m96xKBUijirkP6gQITlQUm82j353XL5YDeV0lrW4taqPpa84RiLQHfB3mD5UvSxAjMOzIwm7qibK/ZwiM4aeyjzZAbLxkA5OlIct1+xcb/EFGM/PVOQUG3GVUevRrzlO8GzeP6W6OugAOptBGNXlW8m+GAo+38otCPNmHpacP6tUALZBN/PXB+5z14J9rO+nnJIiL48IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WB0vsfgtEPHIw+staE4Tb7BYwc1hahOx2vwkEWEam0A=;
 b=ahUzLhrt193NIxDXsDlyUNR33XrhR7dUWCnks5b3qEnfHS228uSVMz62/B+RpAFs2ThQS98J14ZgRSC2nfmjMpEp/K9BbPQSt9zxiZIxbOhtLIJiGz8MlEfMUXt3f4oY8aYJXI7PwIaEBwruv/0larQO7dVcX0r2g7uBL0AH5dckqB9GHQfr+1q2FhddoYTfZEgma8lX80secm1MHfCU9QOfVWp4/PKCzioE9NHV2rOyih/vTy6wRA0hM6JXDbclhiaGFq7YBprWO+F0GmefV73JDEjUCTdMhcQjdSWVttgtOvppUbKyQnwvrnrpIbRTGVNlhvLXM/dzRGen44bObg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WB0vsfgtEPHIw+staE4Tb7BYwc1hahOx2vwkEWEam0A=;
 b=sjIJchFTlv8L/kIzIINER3zLD3EqYoVOTQ3mdaMQXejFJz2Y1/KjYnHkk5VlHpzQpkLfYDKAQYGS78symcMVw2izWxwDINW9gTHiv0TtnKo1llYceRn4vQVYQZ5YZ8hJ7Vh28ynziO+A7T6iyaH41L6lQJ2RGen4EIFb+ZxCeJTDf24yunazBEWr9ZqB1/VTq+qZlQ9//omi+7/cuXw1Qjiq/a9kmLB2uq0n6P0EUQK66CHKJRuaJjBwDjKPZz9oCAeHEMSpqJxcBHkmneqwVJLF9OhxC+IsY2T29uBxNufJvQ5RwnMw675H0xFqvY4NbFpGnljZoQIAiGH8beS0+w==
Received: from BN9PR03CA0035.namprd03.prod.outlook.com (2603:10b6:408:fb::10)
 by MWHPR12MB1838.namprd12.prod.outlook.com (2603:10b6:300:106::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Mon, 6 Jun
 2022 08:57:18 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fb:cafe::f4) by BN9PR03CA0035.outlook.office365.com
 (2603:10b6:408:fb::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.15 via Frontend
 Transport; Mon, 6 Jun 2022 08:57:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5314.12 via Frontend Transport; Mon, 6 Jun 2022 08:57:17 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 6 Jun
 2022 08:57:17 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 6 Jun 2022
 01:57:16 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Mon, 6 Jun
 2022 01:57:13 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kvm@vger.kernel.org>
CC:     <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <kevin.tian@intel.com>, <shameerali.kolothum.thodi@huawei.com>,
        <liulongfang@huawei.com>
Subject: [PATCH vfio 1/2] vfio/mlx5: Protect mlx5vf_disable_fds() upon close device
Date:   Mon, 6 Jun 2022 11:56:18 +0300
Message-ID: <20220606085619.7757-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220606085619.7757-1-yishaih@nvidia.com>
References: <20220606085619.7757-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e16caa92-c5a6-4a6b-cb32-08da479a8f45
X-MS-TrafficTypeDiagnostic: MWHPR12MB1838:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1838A5B83ABCBACF075AD90FC3A29@MWHPR12MB1838.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T1cL41+ZQ7Ox2Vt3/josaUbCOqqliyb7B2v13ymb5s8NWKQaCfzz/1tQeVaYXLgV5LAL9ZVIOL1ePe54CNuoJHY/OhcU2ol9ynw3Ny/TIoOaxjYmh/G01j+yXUKWSY6R8NS2wG5lZ4hM+b1BKHxsQcENhtZhegDfJWa/EYy7jvrHQw82laqtQ3RXNF9bYSnkBOhl7TRY2o1iwmdjAKKCAfeoD9wiAFriLZxXNiCYvESynh825KgOsZrDXp6Hm0zQ/4frnKjSWoAXIBM6ijfUF80khTpw3TT46VGPYoA/GddvCTpffPQepHUkJXMz2beDLaya/VwdPuXETmM2waqugKHZl6dcy34/EFQ5zwSuf1Q6Vfqfb1Bf+Ntw9gpAhvShCIgJqpSELiMCzr5XcZ3nYfO/7y8yg+hMjWfWDEZKWpgJzHEL67tMo0uwRY6ZlOwkZCXotqfnCne8iZdE9Fto4OzS1pEVMssosFiNCECTLQFa7fRSemGf7vv102IrCemoqidwTpw9akIL9WWpOsVhEvTNn27Df5rVa7gc0YZMtX8ylVlTUt4sj3PX2nXu+NtNnLEcH913KJbSzyQvFlqHZvryf/wACYEj0RGd2HvMeUl1S2QZVqFbrfLHYGDgD50Mu42M4ZSqsRA6bvxH+AAW9L1ge7v+R4EYfY/xWdjp+Ot6dgYVm48ytimowieLMcim6jmjKzbVnDxNXUp2B5nf2w==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(5660300002)(356005)(40460700003)(8936002)(81166007)(86362001)(2906002)(508600001)(110136005)(336012)(426003)(186003)(83380400001)(36756003)(54906003)(47076005)(316002)(70206006)(36860700001)(4326008)(82310400005)(26005)(7696005)(70586007)(8676002)(2616005)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 08:57:17.8879
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e16caa92-c5a6-4a6b-cb32-08da479a8f45
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1838
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Protect mlx5vf_disable_fds() upon close device to be called under the
state mutex as done in all other places.

This will prevent a race with any other flow which calls
mlx5vf_disable_fds() as of health/recovery upon
MLX5_PF_NOTIFY_DISABLE_VF event.

Encapsulate this functionality in a separate function named
mlx5vf_cmd_close_migratable() to consider migration caps and for further
usage upon close device.

Fixes: 6fadb021266d ("vfio/mlx5: Implement vfio_pci driver for mlx5 devices")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 10 ++++++++++
 drivers/vfio/pci/mlx5/cmd.h  |  1 +
 drivers/vfio/pci/mlx5/main.c |  2 +-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 9b9f33ca270a..cdd0c667dc77 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -88,6 +88,16 @@ static int mlx5fv_vf_event(struct notifier_block *nb,
 	return 0;
 }
 
+void mlx5vf_cmd_close_migratable(struct mlx5vf_pci_core_device *mvdev)
+{
+	if (!mvdev->migrate_cap)
+		return;
+
+	mutex_lock(&mvdev->state_mutex);
+	mlx5vf_disable_fds(mvdev);
+	mlx5vf_state_mutex_unlock(mvdev);
+}
+
 void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev)
 {
 	if (!mvdev->migrate_cap)
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 6c3112fdd8b1..aa692d9ce656 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -64,6 +64,7 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 					  size_t *state_size);
 void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev);
 void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev);
+void mlx5vf_cmd_close_migratable(struct mlx5vf_pci_core_device *mvdev);
 int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 			       struct mlx5_vf_migration_file *migf);
 int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 0558d0649ddb..d754990f0662 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -570,7 +570,7 @@ static void mlx5vf_pci_close_device(struct vfio_device *core_vdev)
 	struct mlx5vf_pci_core_device *mvdev = container_of(
 		core_vdev, struct mlx5vf_pci_core_device, core_device.vdev);
 
-	mlx5vf_disable_fds(mvdev);
+	mlx5vf_cmd_close_migratable(mvdev);
 	vfio_pci_core_close_device(core_vdev);
 }
 
-- 
2.18.1

