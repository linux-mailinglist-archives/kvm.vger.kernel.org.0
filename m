Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7769255B05C
	for <lists+kvm@lfdr.de>; Sun, 26 Jun 2022 10:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbiFZIlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jun 2022 04:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234030AbiFZIlM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jun 2022 04:41:12 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9252B12AB3
        for <kvm@vger.kernel.org>; Sun, 26 Jun 2022 01:41:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ABaK7kTK9GTyoBcavO84yxA9qC+/27UePelaav23PXGmigbyCMD4k8nV3I3mbApuNDy7jbrNg5AdC3XGdnNzjl3VbOEHEG4/q9IAPzzk9l/8LNim2stvi08Z8eFMY0Hs2RGp2nS/GBOzg8N3UyBtOokm/j8XcNW515OmaS0JK4leAOSDJWVV2/sybr8Hy2WwzowVhZGedy6BAFNH9mL3S9BbTyNUBHJGH8zd53e8TKLiblEXGlQuAkfCvW63Svb/KN9wMqUwn77Sem8C22yfJZojdoUpe95IN70lwOkcEbciWTJJBcFX7gMbZ5BlXxdS4rrzdRLebV5N4+5kFE/kwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4FU0SF+R3sQDwmMMK0dPHFM1NO3T31njTmSiF9pYpZ4=;
 b=lEiGrGf3e0n+NRzsrXTP6PnMBztKjblojnP3ZAlYtYUpmI+Kx0snmF/z5m6OHRjm9bTAzaqETN431Fyb+3dYq+wpuyI/czSKE+76QcRkHGIXUJoQbLVSMgol9M5hzkStgqZqzOtEzXegvKcqjZwdUhIlsQ/cRDQmNUi/RdzOgm6NSRYStSfiVBLOcFHs4DV3K5V+wnek5oGPr3Ear5VpapOdwRkurS/m1+kv96u3JKBrGhI0erE7xgBq/3CCUXsy3SEhHw6WCxrBvW6o3lwBkTvoidyr1iVqdO9W0wz4qvx7Q3g3NWQo4U/DVpeOiarZRWAbUBBW11w9jTIm59k7BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4FU0SF+R3sQDwmMMK0dPHFM1NO3T31njTmSiF9pYpZ4=;
 b=TZy/G9nEKDw+2nLBJ2NcgAfLVU6lYTLQlxByaDYAc0Ldmgvk1UsyVgzTsGguK96JMGdzX9veLCj2d79b6TEhDbG+HeKcvBlndV+nnzrw1+mOkxOiPMd9u7EAZ6ubuvXiFEnDmS7ix/L1QIv0ChOlT4SPpPlRApzne8Qer2CTdFLvYh0Zl0zH3NUTOb3FqGiop82QVKvlNf+sGIP4hQuufMivTdu3eZGFYv8IkFKAQqeCgaVsaMA0+FvOTu18Z/tJSl/RxzYjS+G554nt40piZTa8ESMiAOo+eWEE4yVl1Ome4iCOib6V49t8/u9sx84pSpplkcNROOPCkoOJgcg1jQ==
Received: from DM6PR11CA0025.namprd11.prod.outlook.com (2603:10b6:5:190::38)
 by DM6PR12MB3465.namprd12.prod.outlook.com (2603:10b6:5:3a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Sun, 26 Jun
 2022 08:41:09 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:190:cafe::c3) by DM6PR11CA0025.outlook.office365.com
 (2603:10b6:5:190::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Sun, 26 Jun 2022 08:41:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Sun, 26 Jun 2022 08:41:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 26 Jun
 2022 08:40:32 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 26 Jun
 2022 01:40:31 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Sun, 26 Jun
 2022 01:40:29 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kvm@vger.kernel.org>
CC:     <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <kevin.tian@intel.com>, <shameerali.kolothum.thodi@huawei.com>,
        <liulongfang@huawei.com>
Subject: [PATCH V1 vfio 1/2] vfio/mlx5: Protect mlx5vf_disable_fds() upon close device
Date:   Sun, 26 Jun 2022 11:39:57 +0300
Message-ID: <20220626083958.54175-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220626083958.54175-1-yishaih@nvidia.com>
References: <20220626083958.54175-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff12266c-4aa9-48ba-4ca8-08da574f9e55
X-MS-TrafficTypeDiagnostic: DM6PR12MB3465:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hKTHicziZUea28+QH1bluRZgSwrizMzxfyPUi5GHXrOHi9xZLrc5BI++xJ9dTBpQIJDkUSDDX36sxyzYAmZdi7tIq4rabDc547aqrJ/m+P9aGaaLx3ZklZ6cYbeJ9nTD7ARUH1jbqxpeE7z2sEI43GXod46GxhlD9pMWo+PIoc/fQrExBDj8izXyBAfWSB1LNcH+llbuF3XAeOou9y21xy6E7SJ9Bq3PxAKXvDQD3I30VuLZCANuK02+bSq+AbYbQMePzkt4Tp4CtfdZXqUgvXHvTBGf3j3vIHW/BMGQgVAk4k+ieKErGHse7C7SnbozeNeNogTJfzNUr+900m0aXZf8GL1OoIbvhe/MRP4N+18C6rdlw5fr1+gw8Ib1mNv6GNRDUHumhMVz1BRU1Vax6QJK9y/AANBtZMpB7oL20gQ3rtT14S3hNH1DUMzaH2ggUQt/azwAN/gHcdc65lLwhb3yYwwTiA0YCZnVQKHwmCD0/I0jpYUVwMajPu0+zd7osRlukQZu9kQDsjWjRauKpUN0RBbxFM2vyt4/qXoFnD2mdjGhqaBaKk8Pd0zOamRvyzzTIyN2p21zjA0CLaSH+LqX+s03wse9O01i2kBdy8dc0kkeQ5C7Xmv+CB010wrHgCeBqfrtf5afcFRWWKQBVNBG//Q4aZYq9qwgUpiI6DLrjnS365XBGquqNALptvFGOc40Q16bbOvk+RuIG7EMSdQ/6nbTCDorbYqfhxKg475jW5Xyzd0IPOxB2shUEV2beCw/LaoLHUsn6vbriOSiIa39n+EdUx0+nwwGtagael1kUYZiDkl+bXm3fV3UJkSMmIr1JatkjSW3MxPmYKKJEg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(136003)(396003)(36840700001)(40470700004)(46966006)(26005)(6666004)(2906002)(7696005)(86362001)(70586007)(70206006)(82740400003)(41300700001)(82310400005)(36756003)(54906003)(8676002)(4326008)(316002)(356005)(1076003)(8936002)(81166007)(40480700001)(36860700001)(186003)(336012)(426003)(47076005)(40460700003)(2616005)(110136005)(478600001)(5660300002)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2022 08:41:09.5676
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ff12266c-4aa9-48ba-4ca8-08da574f9e55
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3465
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
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
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

