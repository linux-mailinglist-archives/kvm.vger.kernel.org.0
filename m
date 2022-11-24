Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2D1637E80
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 18:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiKXRlU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 12:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiKXRlL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 12:41:11 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2040.outbound.protection.outlook.com [40.107.101.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8152C13C710
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 09:41:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lfSqh2T8ZtM3Q+pg1KDMcCzA96VHNuOiku7QJTmVWfh79Vd6siVCa2gEA/XDlFNYI7bERIFw/r+Q0hBVjFFVRdWyh6Q99ILuoS/tKxW4AAfp0xzvgPlhL17/hxlxAlgm84MSZHd37+l8Apj4k3oSQBWDzsCP00HfwsdPizmbzhPEBe22hFJI/mJ88yuozNbCI7HLT3IWywqIiynabIqZQ/6yUu8Yv8NhNs40l7v/xsn/YNDOMaXH6iVoqxjZYjD0EpiSyySjtAcCNLyGIh3MSe3zVMKLwSQ9aZbdqRnBH0BcSRurb0gmSWGV6DSp8rB4yJgo/QXLiLq5vpT1T9chEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oeicPMB1a5ZmCLJ9SaKk7KlezHuZMdGanA64A0nPhcE=;
 b=MS3GQ37+g6GlYwajrTUMHEORPGyJXMQaG2Jq4TSfgBnfRIgHcrXMQrmeIDeMEoEzTGnctZh01TTH+POTokoLSW/hjRJ3Dl7ov3R4Qcc+Tyntl0AH0hYFxyDc3TWikkfw9RidxHi7gpCqG3q0QBCF27yNMFOy5UZt2DmDFykmxW8jFAU1IAKIBKUDSy7URozfXdqCQ8KbWh/sRcBQRV6kq0WaxFxS4yASl37phV8tLN/ewXdsAfPb7PvxAcTpnxvRrRq+HsBq2B+iFblZDo1zYEzdMRAhjKhJGfhHSNxcUT0IbJJm3BeUPoB/J8OihmRT1U783zg9VNvheQ014Ter3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oeicPMB1a5ZmCLJ9SaKk7KlezHuZMdGanA64A0nPhcE=;
 b=bHoKFyEKNEKPhaSB7Fg/hEqDSmwvKX59BWb+WD/Ew1klYSVZXEq9W7r1vexuwzf2eNCQOw8LWgBPic6Ci5G/0OEFlaHskI/gxaTHBDNzQWJwyuPHpBlBWAdy4qQXbGITbzGzSMngUd/JfJKjpIcaA5GAU9DNnMQyGQShjQKM1PeTU/4+IqRGkK/y+/fFYd9U/osQJHT4LlNUPxEscjkO0ZhUp6EYxyuxiwN/nX1wjtFuWjjTk/nfOEWT9CDYQovLNEBzWg/BqYsye1Ewonq7qn1QKZp+d2lMG8SfqYQobg8pfN0inkCGhd62cvlJKUfQRK9KYQjZRkDIZh6SV59rpw==
Received: from DS7PR03CA0269.namprd03.prod.outlook.com (2603:10b6:5:3b3::34)
 by DM6PR12MB4297.namprd12.prod.outlook.com (2603:10b6:5:211::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 17:41:08 +0000
Received: from DM6NAM11FT113.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b3:cafe::a9) by DS7PR03CA0269.outlook.office365.com
 (2603:10b6:5:3b3::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19 via Frontend
 Transport; Thu, 24 Nov 2022 17:41:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT113.mail.protection.outlook.com (10.13.173.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.17 via Frontend Transport; Thu, 24 Nov 2022 17:41:08 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 24 Nov
 2022 09:41:07 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 24 Nov 2022 09:41:06 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 24 Nov 2022 09:41:03 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH V1 vfio 14/14] vfio/mlx5: Enable MIGRATION_PRE_COPY flag
Date:   Thu, 24 Nov 2022 19:39:32 +0200
Message-ID: <20221124173932.194654-15-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221124173932.194654-1-yishaih@nvidia.com>
References: <20221124173932.194654-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT113:EE_|DM6PR12MB4297:EE_
X-MS-Office365-Filtering-Correlation-Id: bf02945a-76d0-40d1-2bbf-08dace4311dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8APvwMpxYkkVnrIe/lKl76SPVAPeSarFWOZK07IrprCMs9RWe4UjkRrg3tulW9opW/NdKAuAVlewC2bE9H6+0fWOmnJwC6bBBFde+RQRTohyZSjw0zm6Vn1PUWmjaNoExKa4C50lNgJds1eFB4gQuCr8ox48zjw79P5i2GagWb0EFMDOWhuGphBmf86nYVQDIg0Qap+bPy+OlzS6Y8wudg0Sa8hAaP/mtdAL1jLGpGIUw+u4/8GFgLhYvverkvFBCBQkabC3/b+U08TzGFgxFbeDZsgb59+4VPVgbpwBe2bzKosYKKsg3oHHuCaMMrqpE2n5K7J3eHs0NuMk6EI4bdEb344jATHlIohMguwpQVG47H+n69rbrepNKmPHbyhIGqMTkNTIS+589VyBmf2YQTpMPzAbRokzxJoCIhIQ6Ebs3x+0T0q99Vx3A4dltAqoieQwu4F5PEbbIViHuNd5SBxZiSWBAFJZf1S1SCG3a6JzTwcEiUcGCg7IKywE4glq4wtEVxFek83i5asyh4FTum/zUQmhTu8rJ207ozJfE7QZMzy6EMHRFo6O+1n38EPH2FBslfe6R9BqGQz45A8YdhpK9My7nYJ/Ql11O/qPBbebxY7HgoBHEG1lHzq8nxvPaPqrNN5G/SAuCN7GKjK0WxKvpTRT+YIBFfijPk6h+h1ABzyPt2KOUtkboLhoiV0MSJuJJskWE8U07EAJ8fdFzw==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(136003)(396003)(451199015)(46966006)(40470700004)(36840700001)(186003)(2616005)(1076003)(426003)(336012)(47076005)(82310400005)(36756003)(5660300002)(41300700001)(4744005)(6666004)(7696005)(8936002)(26005)(86362001)(316002)(54906003)(110136005)(6636002)(8676002)(4326008)(40460700003)(478600001)(70586007)(36860700001)(70206006)(2906002)(82740400003)(40480700001)(356005)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 17:41:08.2778
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf02945a-76d0-40d1-2bbf-08dace4311dd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT113.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4297
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Now that everything has been set up for MIGRATION_PRE_COPY, enable it.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index a1dca065b977..019011b8710e 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -221,6 +221,11 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
 	if (MLX5_CAP_GEN(mvdev->mdev, adv_virtualization))
 		mvdev->core_device.vdev.log_ops = log_ops;
 
+	if (MLX5_CAP_GEN_2(mvdev->mdev, migration_multi_load) &&
+	    MLX5_CAP_GEN_2(mvdev->mdev, migration_tracking_state))
+		mvdev->core_device.vdev.migration_flags |=
+			VFIO_MIGRATION_PRE_COPY;
+
 end:
 	mlx5_vf_put_core_dev(mvdev->mdev);
 }
-- 
2.18.1

