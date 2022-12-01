Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24FB163F3EA
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 16:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbiLAPbD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 10:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbiLAPan (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 10:30:43 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4BFAA8EB
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 07:30:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HBPuuxB5G5g+b2sgnzzVJMnAKCeU1WNkgjf5MFY61Qv5Ejqipo+2YWhOAVYtq4LYDMfSAMua7hfyDYrdXJAWxOpW1LXXG0bPTB3P1p5XL96iauTsknDxJxZmIq6odJkrq88fFYW/pogTgIFF8MDBxdRW2Od7FVX/BPnoL6hF0J/nePJ9kTnuFOrdacHrU6hTMPiMDcbYy4RGpk5gpSgHxc0tHphgiZ9L6OZorBe4mUh94Hu5Vqy7nOfCOk8v+WE1AqdES0XfLapPpALmqxX0FHScOSKnjCDNQHhKO6Lebvdglu/UN43W/k+eG1sSp2JUjJWe4rz7eraESF+IqzqD3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6IKX56A9g0wdhCtKrvYyx/KFTKDx9Q9EClvU4e5syGE=;
 b=aE596h0C5YnD+STyRijWqf+yeMfuYPWo7MLNmL5mhHY9vSOxlIhwwZM7AnayJs20FxT4sqabYskTXPUSUzdfzXPZc5lfJqYXggC+CrD1UsuSy9nw2EtWYktnOuewNQuH/6nO5/NdRaOKmAK6F5lI9TOJt3c6NRcsIpYnB7tlinF1Qu7SLbAxdqUKUurIF7iqAIBvAHziG5sYtl3jvk0ggKj+/lV++OeGgyDUl8lmod+O9Ig3H4ddrpreOjxrexZIU2c1h5q3Z0C9hUfsZQEVQurK5E7TXuN8Gf3SiyZxjN1dpMpdYjvrq017mY83ISNN9SqVv4ByfYCnyX3o138GSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6IKX56A9g0wdhCtKrvYyx/KFTKDx9Q9EClvU4e5syGE=;
 b=K7bmg2VAhspQroT0vNFNhuu3wPIpvcITlux1YX5cjb+O+yxgXimWyEbzIZM59QdxLsf3VlW1P+MYeJ0p7w4vp+817VyvZwnj+4RagqMVwP/P/WLKHZp0LKRBGDP6HXuDzxx7vCVionFCnI8eWsRuD6rxTHlsGuC8/fdkN5xrq6SKqPG+Kjqp6X3P+O3u1+Jejxcj99xAQDD9Ip6TZSCiIVOV+ETyYabdnc0jm6+zU3UJ+jL0iDUIzdtLf/VUpfAfLAP1oDFyT+23PNBXE/siOWUAizfjYZz/8asVi70n16iCqF9fGYkOM4u3nR/XwWKcGRKFn6jywZ2Qh/t9Ee/1Eg==
Received: from CY5PR15CA0097.namprd15.prod.outlook.com (2603:10b6:930:7::19)
 by LV2PR12MB5919.namprd12.prod.outlook.com (2603:10b6:408:173::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 15:30:20 +0000
Received: from CY4PEPF0000C967.namprd02.prod.outlook.com
 (2603:10b6:930:7:cafe::ff) by CY5PR15CA0097.outlook.office365.com
 (2603:10b6:930:7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 15:30:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000C967.mail.protection.outlook.com (10.167.241.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Thu, 1 Dec 2022 15:30:19 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 1 Dec 2022
 07:30:09 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 1 Dec 2022 07:30:08 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 1 Dec 2022 07:30:06 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH V2 vfio 03/14] vfio/mlx5: Enforce a single SAVE command at a time
Date:   Thu, 1 Dec 2022 17:29:20 +0200
Message-ID: <20221201152931.47913-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221201152931.47913-1-yishaih@nvidia.com>
References: <20221201152931.47913-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C967:EE_|LV2PR12MB5919:EE_
X-MS-Office365-Filtering-Correlation-Id: 51e07a0b-bb63-406e-8783-08dad3b0f4bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SQqPALidFOroIRchZUmgsV8a4AMPh4fAsXeGDBGFBa5I331NXeY5E6S1ne7yqs2CFbBLmYRk7uN+2ElsBTnhSOoVmkM+BZ8X2K8lEZXYUvRkgXATD3SgEgPZ8rMtdgfczTd107IE/1q37WQqUZKrmCv8PBS5pUGl0asHKeTfQrfb7piJpReYDtjbCcBDwjs3G12XdOoT/GBnxpEp4wdc87crzAbmQewaFQIQPL9qbPhG7RsydIbcNitNa3o3jWKY/qA4QYVoTv5NScNgTN32clvDX3V+ZDJT1DDvLuBo/prc2/Msbo+evC2YoFLqTocEo5/SwBhhx5Dlcg/sX3DQsX9HlFYbSd5xhHgpDXNf6HN8JZlgHn78GPD4KwzyZ5gjsBUGFKBR0l18mCpk4+ydT+Mel2TfjVyMlKy3P4rYOGKO7Q87ZeSrjBRcj3oF3wKHy4Xo7Ucdfw7KYRGhSFmQsrSW51Ge4997LyRDVuR8qPmvFlwGxBtHmyQrkqvEqCfM9i5/j8R/RbrmrjcZFFZJx1AoKPk3XhMKP9iq3kavffmPuVF/NqqEOFBEr3X7Qla2AfVanG7WL2rBT9ex3j+rfBARycNYqlvEg77Frqb4gZf76H7iD4mdqngp8L6Vd5TSwuMkAz+OZs++m/cZsq7mITTSlbKVLie9zWvSkpo+X8FzSKCDuvE7DiKjbRjvZsArdODWklJIXZBgcryjI81Pog==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39860400002)(136003)(376002)(451199015)(36840700001)(40470700004)(46966006)(40460700003)(7636003)(86362001)(36756003)(356005)(40480700001)(478600001)(70586007)(70206006)(6636002)(6666004)(7696005)(2906002)(8936002)(316002)(110136005)(5660300002)(54906003)(82310400005)(426003)(186003)(41300700001)(36860700001)(2616005)(336012)(82740400003)(26005)(83380400001)(8676002)(1076003)(47076005)(4326008)(66899015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 15:30:19.8953
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51e07a0b-bb63-406e-8783-08dad3b0f4bc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C967.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5919
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

