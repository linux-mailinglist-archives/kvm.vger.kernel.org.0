Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9629B642AB7
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 15:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbiLEOui (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 09:50:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbiLEOub (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 09:50:31 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2651C101
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 06:50:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GGsWiEjmoEgeuUw5xmaHJ7zfd6alab8ft0cn/i1HMynT6eIISeg3LXL+5WCCtVNAknEdI/trVL+C5nvzlyITaFvdaNzadbQpVkUnoPLYXpnO/t7JneTonMjJJtTD+utO+1xo9Y8oV6fJy8EyYPJpKucMDoObR8KNFiGV8m6luFEkFQaNkdj3/iUxQCPHBBYD+u5MrC8bxU8XXIk/vDu/5FID2P6kQdKMD3LBZVp+yNPTHBbbRXySnDHXvavGtvgJxA+rLnqqdnJA8nZTNUZordEqEszcEiDDgpZbTwhkvA40dOjyeqNfgp1h7IYfa2Y6eKgIyR/0MO+MdnEZKRIfug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KvAHdI2RID8sQjFZ4CqeVrtRgrAgbEiBY+k2QpZpnuo=;
 b=eXSf6sDVGyiiIreSgY38Sv+zr2FN0fwgMMhS1yJyCkARez6c2cASYoN+0u4FraonPKHAlgyt4MvV8SRTitQuZBWDpkszeXrgg4EklkuTzMag17uIyR2oEW+j/jKog4zG2Es1Tp1BbgOmmTVk1mShUO0WWM7WYT+CjxY8KQF/NoJDjs12Ew4GOfDzvqu9hRL02FLHYee+xKCJngn20wAjQJdHL6Vn9+tKs9SpiLrtai39WlMOehsC+K8FgqctQdJV1MtDImHC9jcDbGuHDoVZc1vaWFWjXd6F+FHokLq6RKG4+wTVk8qS05LJSg9s6VF1B7yL+CnaTpvCRYmwPn0q4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KvAHdI2RID8sQjFZ4CqeVrtRgrAgbEiBY+k2QpZpnuo=;
 b=lF/YaqX40544mLneWU+js5mq+GbSw4d8k/Tfv7QWPWaQL4yNkpYBUZFtnywcUYHesDLlTWnpkCr5Vgp9jQyvyGwN5uM3MtNhV/3YnvH5qbNtH5X7UKHmy74CwcKLkFiuMJMgSD/Y7mFsLuRCFR/obE/2cgSsJ7tLPONSXXIiHr4qoPKUTxqBT8rCHiIS+xSFVfqh+ZFLYXQV5YL6YwZ20dxSe0VRqvC9cAu1aXe1XmGjLQXvAeakFd8r2MtsOec12TxJOAapdetnlaCc1Og82P1t8WZIiZjanD70/3XxB8IpmJht0CpmygtpAgabHdc4GtgOZ7iDTO5Sccsnw8jEGQ==
Received: from CY5PR15CA0101.namprd15.prod.outlook.com (2603:10b6:930:7::22)
 by BL1PR12MB5302.namprd12.prod.outlook.com (2603:10b6:208:31d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 14:50:16 +0000
Received: from CY4PEPF0000B8E8.namprd05.prod.outlook.com
 (2603:10b6:930:7:cafe::2b) by CY5PR15CA0101.outlook.office365.com
 (2603:10b6:930:7::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Mon, 5 Dec 2022 14:50:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000B8E8.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.11 via Frontend Transport; Mon, 5 Dec 2022 14:50:13 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 06:49:57 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 06:49:56 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Mon, 5 Dec
 2022 06:49:53 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V3 vfio 14/14] vfio/mlx5: Enable MIGRATION_PRE_COPY flag
Date:   Mon, 5 Dec 2022 16:48:38 +0200
Message-ID: <20221205144838.245287-15-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221205144838.245287-1-yishaih@nvidia.com>
References: <20221205144838.245287-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8E8:EE_|BL1PR12MB5302:EE_
X-MS-Office365-Filtering-Correlation-Id: a0794ac9-7a22-4a15-f77b-08dad6d00444
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z1WFwfnaA/ReOrSjmoM8yhdTPTDi4XQX0pyt6VP5wQZjVyAdsShiUnTP8GFYwZxtU1E/Jty8AHWkRuT00Y0451xVatYEa0qbDaXpeYvxGwCOkBK6YvtvnB47JHXM0TwT8y37POjSQE/NKgA0ovQSelLL84qAA7PJrqfC48TrS4QLSaj01EasLuMX5NURrjYWRwSFYhyk51tqBDZ/TIrZQpi2S99ycLaDXmGVrKElzrOc585URyxQvN+rGtqth0XEmy5JpYfwyOe8htEAKwglnezpLldffVCSNP8qKfsTC8azrfnMD7maFTPggZY8PtedgUAgpW3gmwzxSWFHJ5KIfxc0VU7hkEuoFpYNru6ny0y2+l9LgSzZ+pYdVQy0dm4L2TdrXgil6tT4SoSD77l++nYESUAdCp2t4U5h5I6Wo48ubqkvdpHRTbwXHLvhd59SwqhmNcGPq8Es4VIe2pdOSXqjN8g01UUoqVHHo3QpXuP6qpQJ4ppyUIF9h23N5dseXMdnuz58vW0Gow2OUfy9AGqpUdfRl/InLgVPSBdTUKjuWSgvJ9N/1PbiW05dwgk+B7jiW2br3THi+KYOXGySCt2KXJ9CFVO062qYOf2JU0LVA6lxsUrY7VgJ9063FhdgSF8m5cw4UW66CT8BXqFkq9af3DfZYKX43nwkf2Dzm0SVJ+mFXpUyp7J4aUdM0ls9e44nDffPsW4x8oiAnnOJFg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(396003)(136003)(451199015)(36840700001)(40470700004)(46966006)(36756003)(82740400003)(86362001)(356005)(7636003)(2906002)(40460700003)(41300700001)(8936002)(4326008)(4744005)(5660300002)(36860700001)(70206006)(70586007)(478600001)(316002)(54906003)(2616005)(110136005)(6636002)(40480700001)(8676002)(82310400005)(336012)(6666004)(1076003)(47076005)(426003)(7696005)(186003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 14:50:13.8110
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0794ac9-7a22-4a15-f77b-08dad6d00444
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8E8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5302
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
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 01ef695e9441..64e68d13cb98 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -222,6 +222,11 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
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

