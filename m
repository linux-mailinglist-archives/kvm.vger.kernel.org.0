Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03DAD643EC7
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 09:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234272AbiLFIgV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 03:36:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234316AbiLFIfv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 03:35:51 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B9A18E0D
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 00:35:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ub4OfVL9yBFZ/CabYPgR3QpBnjYK7KVoR7x4z10RhrP7O5owA5G2X2GpvGR9ocEX0WhxQuWkh0a4ylbkI9NzNAzXSSwnom26t/9eGEFyJyLLEL4XBciCELOveet2OLf+jZfYTQaWn93HG4/TxAisQWP9bxVcJOH8vLt38ao2SdtsiVG0ikJsnDSexLo30Tdr/4Lmv6GEFzGmsamZKLGr+9Tz5ByvOt01u6+0oMve1rM0zoO9iRob3deS+jBPqow7qneG0tln8t5P7v0ljHIxSUm/bvTdv67iFv1KdFAH5thQSuQZvZqljloNZzGBRJfliu21zE0Ch5JLrorXJjbw8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mJI2trT55PVHXIAkqqeIO5OfjZXn9lo+ApMxNa4PUok=;
 b=gGb5Y7yRss1IRkoszsng7iAUCZVvo0lcZaNxzqYH6vjcCAvJqOAjopRg3pozBS6S9i1MNNvwxRGzY2fX8tURqEEhmNHvB/fcXwF13M58vutTIKb+NhblR613ex46SgtX0r66kJ0Bt2DPhB7racaLkr5lBLHh9QDcP78lGiX2ufAun0oUV8QYj7PJFRLw45viD+SAoQ3W3U9x5M8MGsJ7i2g0SK27X70pZYkvTgGbScrekTwzp6pVoqHtBzQc8SmOqxJUiWJfQIbzonQSd9ImyKqkFEcZhC43uM6vUQfl7bznsIjGRRXpzFzYvqhV25wh9TnX2xPoN8t5NFTllFJrXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJI2trT55PVHXIAkqqeIO5OfjZXn9lo+ApMxNa4PUok=;
 b=lc5GzLEim7ZGuZ9kDaGzuDLkWngEFB3JMiD2vaW6K0CjCNF37LgT6fPUclE+5aZLboMJiYlImoUK2R77/fH1tsDyyCebZ8GxC7C1X4AX/GDKV/0CmOmswKwExdIVq8opDeQddkYvyGwMS48Xc+qTDrVyQppt+x4KTTou/Zj4tfaT+h5h4OSUhXrehBbimDtMPgFZfzVtLqMuMabLIWdDpd2Utao56fkIPH9GMkkbxIE6rwyqmT6OniZ5mXj5kIfqu9A5Rsf50xTnI9FIwC7BoEDLJNY7HEfwPzcuqXL6zRPum7ZcgrUAN0FXftjSJkA5hxXe4eMNT1sYkDmNoM4JoA==
Received: from DM6PR08CA0025.namprd08.prod.outlook.com (2603:10b6:5:80::38) by
 BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Tue, 6 Dec
 2022 08:35:31 +0000
Received: from DS1PEPF0000E654.namprd02.prod.outlook.com
 (2603:10b6:5:80:cafe::7d) by DM6PR08CA0025.outlook.office365.com
 (2603:10b6:5:80::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Tue, 6 Dec 2022 08:35:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS1PEPF0000E654.mail.protection.outlook.com (10.167.18.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Tue, 6 Dec 2022 08:35:31 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 6 Dec 2022
 00:35:22 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 6 Dec 2022 00:35:22 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 6 Dec 2022 00:35:19 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V4 vfio 03/14] vfio/mlx5: Enforce a single SAVE command at a time
Date:   Tue, 6 Dec 2022 10:34:27 +0200
Message-ID: <20221206083438.37807-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221206083438.37807-1-yishaih@nvidia.com>
References: <20221206083438.37807-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E654:EE_|BL1PR12MB5995:EE_
X-MS-Office365-Filtering-Correlation-Id: ee325b2f-5e71-4322-f3d9-08dad764d612
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S/TXwQRH/Ki8Iv4UXv1hm4ja/vbaSLPHJu7pRsyz3TwLoUon1bNebBW3d15HbzMuNYuIRjiGcqp5MblWdhkFtO5LnxzjfAzVpk2g8E5tqip09f6P03SyPkYTM0/G3hgq8GeJJlNVqj+W807CizYckMZTBIjHwZmdR4KiidALnUH0GMCbbFR2qKQk906Rq9gGP/jE2R5OupRSrEvsKdvS0gS/WTA7ShT2IAQ4bd9KlwbY76A5vPoSgMZEpkv19kZc5rpCkbS61oHYrZ4EKvuv8ceN3XuA5PCZcoohrMzgYLmdIRU39rXfUPakd/7UfEmNZt0vYcUJRz0q8gt703tWeG7c+vw0HfO23N4DHqFyx7oxlwXr049Dcw5UuEmJZPsfFBsDRCVX3Nz+V5y0T8Ul1C1TnVgMEPWllAI9CoYKa/ze/Lv2T2Tshrw/TvaoY0cPH4UWdNWKl9i4UTpJ1y2J9U7T2c35LwIJrG9L3wKbSDqwY459VV1MvqFpB++BMZdKg6Dl+kZaL3/tLKGtfzPO+gsEqNmegOIon6B0oCay/fu2/WcoA0E+jDEq9Q3NH7RQXXB/ZCZtiIiqvtPi8Xnz+1a8u24mLUPYCRXBTQXLUjZmTKUCaLnUQfh++Qbp+/T95FAVyqZ22sFo1eqAngK1gqQaEKfHMFyx9fMH68JaQMIKNKz6t7G2VZaBaPVey2VT13olIoMQy24vseGL5CUkrQ==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199015)(40470700004)(36840700001)(46966006)(54906003)(6636002)(110136005)(70586007)(478600001)(186003)(26005)(1076003)(7696005)(6666004)(316002)(36756003)(82310400005)(40480700001)(8676002)(2616005)(70206006)(4326008)(41300700001)(8936002)(2906002)(5660300002)(82740400003)(36860700001)(356005)(7636003)(426003)(66899015)(83380400001)(40460700003)(86362001)(336012)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 08:35:31.3207
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee325b2f-5e71-4322-f3d9-08dad764d612
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E654.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5995
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

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 6 ++++++
 drivers/vfio/pci/mlx5/cmd.h  | 1 +
 drivers/vfio/pci/mlx5/main.c | 7 +++++++
 3 files changed, 14 insertions(+)

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
index 6e9cf2aacc52..0d71ebb2a972 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -245,6 +245,13 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
 	stream_open(migf->filp->f_inode, migf->filp);
 	mutex_init(&migf->lock);
 	init_waitqueue_head(&migf->poll_wait);
+	init_completion(&migf->save_comp);
+	/*
+	 * save_comp is being used as a binary semaphore built from
+	 * a completion. A normal mutex cannot be used because the lock is
+	 * passed between kernel threads and lockdep can't model this.
+	 */
+	complete(&migf->save_comp);
 	mlx5_cmd_init_async_ctx(mvdev->mdev, &migf->async_ctx);
 	INIT_WORK(&migf->async_data.work, mlx5vf_mig_file_cleanup_cb);
 	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev,
-- 
2.18.1

