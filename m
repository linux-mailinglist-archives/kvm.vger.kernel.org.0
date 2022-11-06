Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5053661E504
	for <lists+kvm@lfdr.de>; Sun,  6 Nov 2022 18:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbiKFRrd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Nov 2022 12:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbiKFRra (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Nov 2022 12:47:30 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332B364CB
        for <kvm@vger.kernel.org>; Sun,  6 Nov 2022 09:47:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NLZWO/Gb6TZcGewhMGee0mfbGVRV9KLtcVoiv5F2+Yh3roiCeuGKRwbM3Uy8odtBMny/euG/ilGumRLKkPCwCwIyscrjTFfPB+rAXkTdYGGRReyTWcp3HGHNoaSCNYDAtjjADAgwohjM7f2IbaDDPacyPVMiOGZS+i72wVB6oOMTwsVShOEK9m8tj47Ab5OZPvBNt3aoIwEtfNQwWmDMsP1lScywoUuvDCrIKUyPIvOctaPF8xMDjugx2nrWoWTZid6ciffUkNkGLY7cEXKM/611HkYV2/MJ5cYyAlFnVwnCyau9n3wPfmnnwVV8E697cePfcK51zm9BI9d2rlJy3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EyMf95wUkBQAiYj8yP+CguzBhX8VxgQsNU1Lx+uLNqg=;
 b=Rh/5Er4714+FaE4Lyc/GxaXCf9PYY2oiOJ3GyK26gpBcmgzccN2GSAdDVQI1h5qnTlZ6b4H+LTTwnjiOKq5KHw4r7MpFOO5bRO0zY+GqXVPeCC6EE1OmbxjKn9Zk6uEeDfBszpD8Ov/mtqUTmTSn2EWQHUkKz+3yeD2wm0AD8XaZ1YjtBj/gjXHmcnh0F+Ld0pvhzJY4WXZAEN/59WocEOF3nYxlgnbIyhEn60BfHZoU7wm7PdFRsggJaQXInVW22hDiM2ql1OukvDU8zj23cSuWN8Kbo19AF9Xu1mwVu+g0gE0mc3HOtK+cIKag9kBcrYlw2sdmNcREFfp/slUcww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EyMf95wUkBQAiYj8yP+CguzBhX8VxgQsNU1Lx+uLNqg=;
 b=d17ffT9nCmpkntg+dPYRLF4lGp+6AIqlz0lbwoLQz0Rc2Us+TKbJAKhMY5T441FonVAAvz6ecdeuhunDlLXchxhk0MqTygg6mbWyYTDxMrQTcD36fg2yWpJA7Neu3RSNTaqU+6+GPodal+zyYbSzw7qkU02DFmRtbLkPz2AQAL5eon6h48IKf15iCvPF9o7bDYZQgfYhMu6lF9GrEAPQWBAUzBOBmarzSmx9HZ1Hrc7K4M1BRZWu+hqJWNPz1WEKPnYRaSvICk2ZszXAPCDBs0wu7cyM2D4AWvR39y1XoDGIEEESLXwOFxTW087ArP61QcxU1Je3LahNICRGRrWODw==
Received: from BN9PR03CA0655.namprd03.prod.outlook.com (2603:10b6:408:13b::30)
 by PH0PR12MB5418.namprd12.prod.outlook.com (2603:10b6:510:e5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.24; Sun, 6 Nov
 2022 17:47:24 +0000
Received: from BN8NAM11FT085.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13b:cafe::9a) by BN9PR03CA0655.outlook.office365.com
 (2603:10b6:408:13b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25 via Frontend
 Transport; Sun, 6 Nov 2022 17:47:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT085.mail.protection.outlook.com (10.13.176.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Sun, 6 Nov 2022 17:47:23 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 6 Nov 2022
 09:47:22 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Sun, 6 Nov 2022 09:47:22 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Sun, 6 Nov 2022 09:47:19 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH vfio 05/13] vfio/mlx5: Enforce a single SAVE command at a time
Date:   Sun, 6 Nov 2022 19:46:22 +0200
Message-ID: <20221106174630.25909-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221106174630.25909-1-yishaih@nvidia.com>
References: <20221106174630.25909-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT085:EE_|PH0PR12MB5418:EE_
X-MS-Office365-Filtering-Correlation-Id: ad26d005-4d89-4b1b-eabb-08dac01ef642
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GBYkwwT1PGPkkI8mTPAoDSF6QA0PXF0iywfnxw6gPJ3ugBy97Wp4Pwyis5mBVKJ0TPRMnGO79VTcJ+OCESlAaUxO9XU2kobjIT3KPvDh45hY25SSipZ7c8gDpDjelxCWduqo91ovgakp6acLolX89SA7VVwOTbks1lGovXhBzjjXNVrGIgri07/ab+dClFnEd+vr3s6CAw6AIZlVR2Jkz82/lWpo8hkfGFeezashCh7NSogtXXWDyCF6yNtzu2pCNQAPJzUCo9TAoA5Fmr758pSDx5rDU1R7xf1c3yQgGpDZbda22ZXdVIy3VDXrX18ZB51yqInCfWzAh0IA0ZbLeRsVKqy8zRs9PD6BuM2E5sZb4jKVUdFAv9V7jFUQIrKl8MGyN2jqpLz2pXNqTeeP0+CR64xEcQY6liV4INKt/vkyuJYQL4Ewul2+z7HmQF4HfoqxaAjbMlnuWJwSsWTtKFXePOGw+gsKpbmkG7Bmy0oUKOl6pvPqT7FoapyH8Z0fmCeV+YP1M+tezwFSsY19VlfyOJ0Id48UL12p7cCtDWG54aZXAfe3YzxcY+kEPPAj7DasuGezWBNWuka3U60zBPXrj9pXzoBuO4vkAP4nnbI30soZhLw8L/BJ3MSFiLmq8tKqXGxkyNRCQnC1VkN5FMkZWnMMnYhkdtf/pSISl06W8NwAIirdoVQcC1S2EOOuhm3s91GswNmmgMik1eDxxmHk/43HN79qs6MSooWbYVnmF0z21o1qk9ros5yCEo2ENFmN2o9e8JLNMO2lqpVqYQ==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199015)(36840700001)(46966006)(40470700004)(5660300002)(478600001)(41300700001)(8936002)(66899015)(2616005)(40480700001)(26005)(1076003)(186003)(2906002)(47076005)(426003)(336012)(4326008)(36756003)(70206006)(8676002)(70586007)(83380400001)(36860700001)(40460700003)(82310400005)(82740400003)(7696005)(86362001)(356005)(6636002)(110136005)(316002)(7636003)(6666004)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 17:47:23.7447
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad26d005-4d89-4b1b-eabb-08dac01ef642
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT085.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5418
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/vfio/pci/mlx5/cmd.c  | 5 +++++
 drivers/vfio/pci/mlx5/cmd.h  | 2 ++
 drivers/vfio/pci/mlx5/main.c | 1 +
 3 files changed, 8 insertions(+)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 0848bc905d3e..b9ed2f1c8689 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -281,6 +281,8 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
 	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE, 0);
 	mlx5_core_dealloc_pd(mdev, async_data->pdn);
 	kvfree(async_data->out);
+	migf->save_cb_active = false;
+	wake_up(&migf->save_wait);
 	fput(migf->filp);
 }
 
@@ -321,6 +323,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 		return -ENOTCONN;
 
 	mdev = mvdev->mdev;
+	wait_event(migf->save_wait, !migf->save_cb_active);
 	err = mlx5_core_alloc_pd(mdev, &pdn);
 	if (err)
 		return err;
@@ -353,6 +356,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	get_file(migf->filp);
 	async_data->mkey = mkey;
 	async_data->pdn = pdn;
+	migf->save_cb_active = true;
 	err = mlx5_cmd_exec_cb(&migf->async_ctx, in, sizeof(in),
 			       async_data->out,
 			       out_size, mlx5vf_save_callback,
@@ -371,6 +375,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE, 0);
 err_dma_map:
 	mlx5_core_dealloc_pd(mdev, pdn);
+	migf->save_cb_active = false;
 	return err;
 }
 
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 921d5720a1e5..b1c5dd2ff144 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -26,6 +26,7 @@ struct mlx5_vf_migration_file {
 	struct mutex lock;
 	u8 disabled:1;
 	u8 is_err:1;
+	u8 save_cb_active:1;
 
 	struct sg_append_table table;
 	size_t total_length;
@@ -37,6 +38,7 @@ struct mlx5_vf_migration_file {
 	unsigned long last_offset;
 	struct mlx5vf_pci_core_device *mvdev;
 	wait_queue_head_t poll_wait;
+	wait_queue_head_t save_wait;
 	struct mlx5_async_ctx async_ctx;
 	struct mlx5vf_async_data async_data;
 };
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 4c7a39ffd247..5da278f3c31c 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -245,6 +245,7 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
 	stream_open(migf->filp->f_inode, migf->filp);
 	mutex_init(&migf->lock);
 	init_waitqueue_head(&migf->poll_wait);
+	init_waitqueue_head(&migf->save_wait);
 	mlx5_cmd_init_async_ctx(mvdev->mdev, &migf->async_ctx);
 	INIT_WORK(&migf->async_data.work, mlx5vf_mig_file_cleanup_cb);
 	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev,
-- 
2.18.1

