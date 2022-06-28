Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E06655E6AE
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 18:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348277AbiF1QAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 12:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348061AbiF1P7u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 11:59:50 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2049.outbound.protection.outlook.com [40.107.100.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511E6B79
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 08:59:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DvCVu0abW1N1rE4P2lEaXmwjRwaLjJRXnyoNhXMO4gyH3ixtrOkPTWP+ac5cdobsBXsZXogx3ZjH8SyJNyiMOIfjN9yEvkpQmeJqLSfm9nhlZiy5tfbzbG+yn1uD6YA2MhwPxbJYNI6cKr2CsYZfC5GbsExQl6+D9jHSwVWlzJGtfsyplP+MG+q2W+EnmeggDK6PaIfv12U+8zP2g6+PWuoJBdQReH/E5tJLZht0yJB79N6K5xxUw8PM0qj7RVYKujI1hrxLbar70SffyTuyHsyeexfGxjWsMvzmY8Qtt2mNbG5OP7sZ3SOKbQTTLmCCnuU+mPf7dAVnHenugEfDKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4FU0SF+R3sQDwmMMK0dPHFM1NO3T31njTmSiF9pYpZ4=;
 b=RDpvlcu4LIlTWg652SERitetvoX+Fu7NtO/gUw9XknUZkUysZz+L0dTS7hJbQAvuDhow9FshKEg5ji3h1CWGYHdxFeuaHdi/7dd4rKc/Uqm543e/7hg8GPqY6gGO/Tu70KOmLjNsljqqGMh1NKAMb1/4I8RZ72TmPIxYyD+P3JJImCKGhUVFcmUon737wP3F2YmCA5YDsqx4BIQrIFgoi5UVTPb6pAeT5PjEOGILaem9u3qjHtizfvYpy4weDIvyzbvl7TtHlFVPbZgPLAYQaj5xHGuZuD8lKrfvoYjnqMCn3g/ENssDJs+RRg1VUdjsTS/k8pALbMFYK3YckRFBtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4FU0SF+R3sQDwmMMK0dPHFM1NO3T31njTmSiF9pYpZ4=;
 b=pUeMLUYmb6Qhl5E80+wx+yLDgXOgx206L8fALkKe33xZtH782UR4wXDveEKfbZz+aWXtKPIC1bXy2WJlbPiwYzRgwCAJn3enIOYER6atwRQXdKVUI9ENP3hMi66OgqihQTq4e81Y206AIL3Ia2diH5VVAWr0ww1xtYADSiXGP103yMNGn98ixPSwaFZ6eXauUhdYI5/k0YAVmn2Ds97LiPKmVNH55uXIEORJUv1CBM3ypmhZCMhbyvNnnPkqj68Op7Jixdmi8WplXWo6xPvnvYD3+DJ2KZYQVDETWAYkr0Z4tJiMr64CBHVyuStfmH+TsDjtUJWZJNJ4PhWTUxvYOw==
Received: from MWHPR12CA0039.namprd12.prod.outlook.com (2603:10b6:301:2::25)
 by MN2PR12MB3789.namprd12.prod.outlook.com (2603:10b6:208:16a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Tue, 28 Jun
 2022 15:59:35 +0000
Received: from CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:2:cafe::aa) by MWHPR12CA0039.outlook.office365.com
 (2603:10b6:301:2::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Tue, 28 Jun 2022 15:59:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT059.mail.protection.outlook.com (10.13.174.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Tue, 28 Jun 2022 15:59:34 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 28 Jun 2022 15:59:34 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 28 Jun 2022 08:59:34 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Tue, 28 Jun 2022 08:59:31 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kvm@vger.kernel.org>
CC:     <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <kevin.tian@intel.com>, <shameerali.kolothum.thodi@huawei.com>,
        <liulongfang@huawei.com>
Subject: [PATCH V3 vfio 1/2] vfio/mlx5: Protect mlx5vf_disable_fds() upon close device
Date:   Tue, 28 Jun 2022 18:59:09 +0300
Message-ID: <20220628155910.171454-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220628155910.171454-1-yishaih@nvidia.com>
References: <20220628155910.171454-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f18f3b1e-d3e5-41ba-d460-08da591f324e
X-MS-TrafficTypeDiagnostic: MN2PR12MB3789:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yNzyzQSZR0QK4y9ZgPNavBXrV+XeGG2ewUDlbT3A4VfAbw81fvsc6Efrh29tBI7FMJ2nulThlz/OvkZ9flNrq+OaiLOSgz0WFu870I8WfmhGr4kjv302lsM0h8tv1yZ7P4VtyuukepyY+kvRPybuyq3p9PeRKmEJggTAvTivizj6BDprvQLuntW/HVO/ZXrTAMNFa2qdosnZ1ugHqCy1kmkPT84OOBEsmDpTW5W3iD3ut8NUzBRj3GqlWc+E0ZCc6lvYn9BmNCbJpdnCSCaiKHMw7Q/54QNcZ/NYsrK7PfItLUCN11+6AEMextgP+jMVPCV2xqvOPYxF1pr9G/Ca8GaoJTxqk9cBJjou4QdhXvcpIxNeJi1AwTOYezuVAHqX7cfVSFr92MvRZGm/2woOi+wPkw9sBj3KiEmtYMnY/wt7je5CihQyhstMaNiDzEfPGEguPIdKz34DLfgTurPag90SIZCvpyLEhu/rzVlaYyY2PLmAHAUxSkFMHyq5c3jUD2idDZy6jVgpa0hwF+Xx8RlsO8fQV9LQ0ojN3GBE+WzMnqYlgPQI/10xS2Y8HQHAr5bFUUoXxlxLBdsZWLRpmB0VVsnf3jpRuZGgKFNkLHGCUYhSpMh/MTBqz4JPwuSflibOx2OEA1zdLNg3GUeK1Pi7oFUjS0vGaRkmBbduVj+WON0rbhZ8BBlxlmihavoLv1wwEz4Jlz0ek2QYp7KdHmyorS24YsPmiQ/Xwcu5AlBmikjRI4QHEmv6V8O8hVn9yK/tQkXSyB8PGoEAtTjA/pb7xtvB+flain4RX0B8SdCGMNhVgSO330Rfp7aXLBY7kl0fxm9pWw+53H9o4fd8PQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(346002)(396003)(136003)(40470700004)(46966006)(36840700001)(70586007)(36756003)(86362001)(426003)(7696005)(6666004)(40480700001)(8936002)(26005)(110136005)(82310400005)(70206006)(336012)(186003)(83380400001)(356005)(2616005)(54906003)(82740400003)(1076003)(36860700001)(47076005)(478600001)(40460700003)(316002)(81166007)(5660300002)(8676002)(41300700001)(2906002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 15:59:34.8138
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f18f3b1e-d3e5-41ba-d460-08da591f324e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3789
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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

