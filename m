Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27C03637E75
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 18:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiKXRkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 12:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiKXRkk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 12:40:40 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502DD1369DD
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 09:40:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fFomPN4HspyqnNf0lnOm2NRek4t6mkf5WEse3iqEaiKsgQmdBkvciS0Gjkn7FfItciLYB27V71Xm3N+Xj6KRBZDSBInVbUzieyo/E1WzYe0g5PTP1ARUuNk5WQBGm0+5VvdxeTdUCprabECqXwvc79JhfpFfAeyfgRwb8O4Wi8IypM3oP7gKmBCvqBfC/3hnUWRR8Xi5Zj0OsmHAOBW3rbArAjNBsnwCDau8w6vWU9Z+VmAnJQBS8ibqtJObeG127LWUUNkj+r4lcSnkMEoI9X4lnJuvWpmIePI1RX0JxcJv1j8voqINDSGVY/BV0JudeGkLokAlL8NYBf2UAfut/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6IKX56A9g0wdhCtKrvYyx/KFTKDx9Q9EClvU4e5syGE=;
 b=gtGsRqC7U9ClnTN4Q2VNR04/xGAFi7K76+QKYR7IB2T7yq+25oWzEpz7Itjx3bO3SyVQAQskCtpBdNER8F7LFTnpLQ5BLkKo244MHW+UjbaV1BkexdTqfbkqJytwlY+eu9LxK1f+dRHf7kQxruDI8h2Aee6xDOinkyZlKHpc1ncUHYTfa+Krp+K3OJ/L0dkgdsXCWC2urcnac6xDJKiiEjqLvNbu3igsiUsG/A13pJTqOBoZv5k4b/pR2JN7oZ8cDNtzJV0OEluOHFMKXMxLKh54uRzm0XBPpoJqFhh00bog4fOuE/+U7exKeo01CyHm62GgS81RT7j8DIYFq01k0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6IKX56A9g0wdhCtKrvYyx/KFTKDx9Q9EClvU4e5syGE=;
 b=eli1spmxHqXscrs461Lrz2xCbRTwVOK7T76/oJw6uoF/GBlfBmk0Gr28Mnqcvc0ftjvT43DSFEfdmcrVHoVAQtnG6dpLpFPmnu4g45I5FtUo52DcYMyHN2w4Kzu+XbwyrePIKWqnigeL6tJrNxZHk840hAkwAuKwvfRaASiYSqwZvGpnQAAw45dc2T8P+FEwR+2S4BKv5kQwHZnFPJpem8y8FuOItoC81na6lOwlIzPMUAOapTzOxGNoJiR8P9oC+5Gn0D72/cHQ5apy+VXa0eR4rYSPM8R0S8jQjoApP2SlTOSOdvugpgJbQ8Nt//O+AO9XtJS+Wy9JnZLi8JaOmg==
Received: from BYAPR06CA0028.namprd06.prod.outlook.com (2603:10b6:a03:d4::41)
 by PH8PR12MB6915.namprd12.prod.outlook.com (2603:10b6:510:1bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 17:40:38 +0000
Received: from CO1PEPF00001A60.namprd05.prod.outlook.com
 (2603:10b6:a03:d4:cafe::71) by BYAPR06CA0028.outlook.office365.com
 (2603:10b6:a03:d4::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19 via Frontend
 Transport; Thu, 24 Nov 2022 17:40:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1PEPF00001A60.mail.protection.outlook.com (10.167.241.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.17 via Frontend Transport; Thu, 24 Nov 2022 17:40:37 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 24 Nov
 2022 09:40:29 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 24 Nov 2022 09:40:29 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 24 Nov 2022 09:40:25 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH V1 vfio 03/14] vfio/mlx5: Enforce a single SAVE command at a time
Date:   Thu, 24 Nov 2022 19:39:21 +0200
Message-ID: <20221124173932.194654-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221124173932.194654-1-yishaih@nvidia.com>
References: <20221124173932.194654-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A60:EE_|PH8PR12MB6915:EE_
X-MS-Office365-Filtering-Correlation-Id: 740be603-84d1-46c8-b2c8-08dace42ff82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +h0tzpSdYpTT79hlq/MPOhEK0rBp1NbknBETWrJT+ubzmIsnqGcEqf+e3YxD42AvlLijijHVDnO6o7eaRttqbnlpizEir7rN+zdyYUKeaAXWz1NQ0dZuhDwmO79c94DKJMWXBN5bWhfWC1j8EADSnK2BnW90MAdjFJazR/qkJC7wphPtejC0Vgjxq0+BGv8LhKKZNJxJz+erPcTESScJz+Aov8/QspX9YNbRhUIR/jWoM7YxpZEUcRxdMRKqug+lzZwbDRbXTyjFT59qGtB3nNUXX+W4o15TX+INH7IP5git9LFL8fG2HLXcevUYeiRHdtnjEL+BHRrl1XN3Y4D9pe3cKcrOo8WtbRvXocKrkMq9sBOa7e7Sulni2+TxV66hLVEPot/TbTMf0Vb5dX+GsDGvrvcCdTWyp5MX7rEI9Hl2qeGeIxMhilSj4JinvVLS6yNb53FEKL80YZvzh4gkOOosfI3XN948TzVdm43k+e3CYNr/MryynHiArmGqpykktzLITIJIOSNrU78Xmm1jGkTvzs5YDPcQfOti/ZnxdpLe2FTQ/NgXbKB1FF9GH8Waq6lfMiIDvoNARTP86sFbIkSOfhp3IydYbX/Qfc3wVrpdhTdi92ddeEhN64sngHagIYxnh2SXeSwe8u5+UuaN9rMB4RgtbJYZctD/OwUEmTJFpHlZjFWK6X6Vjou2kRRRRfluKLGMf46J6psP002buA==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(396003)(346002)(451199015)(36840700001)(40470700004)(46966006)(316002)(6636002)(54906003)(110136005)(86362001)(41300700001)(8936002)(356005)(70206006)(8676002)(4326008)(70586007)(7636003)(36756003)(83380400001)(186003)(1076003)(336012)(426003)(2616005)(47076005)(36860700001)(82740400003)(40460700003)(478600001)(82310400005)(40480700001)(6666004)(26005)(7696005)(66899015)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 17:40:37.5327
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 740be603-84d1-46c8-b2c8-08dace42ff82
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A60.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6915
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enforce a single SAVE command at a time.

As the SAVE command is an asynchronous one, we must enforce running only
a single command at a time.

This will preserve ordering between multiple calls and protect from
races on the migration file data structure.

This is a must for the next patches from the series where as part of
PRE_COPY we may have multiple images to be saved and multiple SAVE
commands may be issued from different flows.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 6 ++++++
 drivers/vfio/pci/mlx5/cmd.h  | 1 +
 drivers/vfio/pci/mlx5/main.c | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 0848bc905d3e..55ee8036f59c 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -281,6 +281,7 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
 	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE, 0);
 	mlx5_core_dealloc_pd(mdev, async_data->pdn);
 	kvfree(async_data->out);
+	complete(&migf->save_comp);
 	fput(migf->filp);
 }
 
@@ -321,6 +322,10 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 		return -ENOTCONN;
 
 	mdev = mvdev->mdev;
+	err = wait_for_completion_interruptible(&migf->save_comp);
+	if (err)
+		return err;
+
 	err = mlx5_core_alloc_pd(mdev, &pdn);
 	if (err)
 		return err;
@@ -371,6 +376,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE, 0);
 err_dma_map:
 	mlx5_core_dealloc_pd(mdev, pdn);
+	complete(&migf->save_comp);
 	return err;
 }
 
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 921d5720a1e5..8ffa7699872c 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -37,6 +37,7 @@ struct mlx5_vf_migration_file {
 	unsigned long last_offset;
 	struct mlx5vf_pci_core_device *mvdev;
 	wait_queue_head_t poll_wait;
+	struct completion save_comp;
 	struct mlx5_async_ctx async_ctx;
 	struct mlx5vf_async_data async_data;
 };
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 6e9cf2aacc52..4081a0f7e057 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -245,6 +245,8 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
 	stream_open(migf->filp->f_inode, migf->filp);
 	mutex_init(&migf->lock);
 	init_waitqueue_head(&migf->poll_wait);
+	init_completion(&migf->save_comp);
+	complete(&migf->save_comp);
 	mlx5_cmd_init_async_ctx(mvdev->mdev, &migf->async_ctx);
 	INIT_WORK(&migf->async_data.work, mlx5vf_mig_file_cleanup_cb);
 	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev,
-- 
2.18.1

