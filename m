Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C919643ED2
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 09:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbiLFIgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 03:36:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbiLFIg2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 03:36:28 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55FEB871
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 00:36:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TPRH1TsOjMZBgMrDM6Pv+y4P5oehARo/r/VLJRcgJPoZ/4QRoij8IANv/R0YSMJwKHLPnEFCxv0Rz6xemUhynEgoI7P+h7du4d5R0Gv5uEE06JU5RTwCp7v9pd7HonQWguFFWo4/J9rzdxNuDdy0DT/GkLn8Jo0bPG0ynZvlVxQh6IxhomhMd4ISCRzXGBbE8uy9uzZMWSaSQuosOhmYcpInwHhyB2NKwhX5KbYD7mV32uwfjoxuppr5N2nBRsw/dDnMzN4TkRPwQWv5/qDX/X/vVAAPDJtYGUunfK1Cty5AC9MXJC2V2FQ2rJ8eatqyfo/w9FlxQsj8zpBUEj2kIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KvAHdI2RID8sQjFZ4CqeVrtRgrAgbEiBY+k2QpZpnuo=;
 b=cn1OKpm6mgZyIYzzbFRFr7DnKmKfBQabdIX448q9YlqXsGCGbBlXGFV37m+JQTQviUoMUEiJeRw19nLMUKxnwAPBh5R7NlywOAHoWBjznXjCfR6C0RVKLdp5rVIuVoLplEUj24CSR2M5inEAsLXyH/aHnlv1dDtQUqmJBsEl6BMeqiYJ8HmhVxkC5rxUkvgZJx9R+738Iuc5vFyrkMO4sXlB8kYN2rv5Zs8kSLUO9pM6SMfLLDq7gJIRahTt4q3jilflnPCCySBEwzQ1NK0YMOEj4AUvLLARzAqEslvYqkEY/Zu/CplrFUoVf9bM3rkEcv07RjZqMGoq57Ndf3L+fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KvAHdI2RID8sQjFZ4CqeVrtRgrAgbEiBY+k2QpZpnuo=;
 b=FdiXIe73d6tXrLVEmq+EYsc8ijaRpqgQl01Bzzw0eEJNz/gUGQz61bYEBhH/GdE+tAnT51gnzI94F44AuDBm5HEBHZnNWj3yOxfJBN6JCMz2d8lC4fK66Vn/quyNFLbsZj750xnoT8BEjnXkELMaBrIMwZju9HHBIiFjjI8k6kqNN7JbWX4DnbMvZrd2BinFbEkFuMUe/T8CKByy3Den5GLOOvaET3f28YUskIfxvam+vKGg6EkR/Yt8WA2zlHYfOtcYL1x4mVZCAb2FJbclgaEdujK6eTTAKu7rxoAaTIchk3mptvAFtuA0QWYS4R7Z1EmMwj3oY/4HroEP0KZDSg==
Received: from MN2PR02CA0019.namprd02.prod.outlook.com (2603:10b6:208:fc::32)
 by IA1PR12MB6603.namprd12.prod.outlook.com (2603:10b6:208:3a1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 08:36:13 +0000
Received: from BL02EPF00010209.namprd05.prod.outlook.com
 (2603:10b6:208:fc:cafe::25) by MN2PR02CA0019.outlook.office365.com
 (2603:10b6:208:fc::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Tue, 6 Dec 2022 08:36:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL02EPF00010209.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Tue, 6 Dec 2022 08:36:13 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 6 Dec 2022
 00:36:01 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 6 Dec 2022 00:36:00 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 6 Dec 2022 00:35:57 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V4 vfio 14/14] vfio/mlx5: Enable MIGRATION_PRE_COPY flag
Date:   Tue, 6 Dec 2022 10:34:38 +0200
Message-ID: <20221206083438.37807-15-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221206083438.37807-1-yishaih@nvidia.com>
References: <20221206083438.37807-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00010209:EE_|IA1PR12MB6603:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c57bbcf-6557-40dc-fcd5-08dad764eefb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r0UjY/Z/pub0fvjTjpsedfiF2qoFAMgJxug3WTZ5SGyZLM3N6VpCdfkLCHiwEZWYKYwso5m/bozZFnUWPRKg7xfiTvu5CvBpTIhoJaYOmB5BRvB6yQGbgdBD+Y4nuMeCkv4R6o1jCKRneoQZg/9AsLaEYwdZJh9t/23sBRlfhrmC7BmNcch9wUQr2wT/J0eiBM428xfKKyxxutO2Y84JJRQiigaYAZue+h95RN7IPcSFYPN2lbjv6KOz5cVXuIRdBBN1GQsjlFXwj6LmpYjx/9CRuCxb/OwhTdwIvJzO6MSMBzCuAfNsIIlN32fJE1MM4F7AfphRiuv8y2CnEZS7CuXVmPiljoCRhF1fO+ynWQpVpg8ZsLbB7OoSn84zyRLbqvh77vyxvlA+X8rZDt2fKkXVYmW8ATGh15a7/fAgPxbz0vDHyUNNZCxASOGX++7cG2cyb9dRlLo9tq8368GJ4dwYBNOiAgNFsIGpqQQofDbar9iqTAJiZ4CMqVvuNDfY+7V/6dxefro0OUZMta49GOgu6F7Do5EYknup6avtmehYb7Uvk1uomRNKFsKtXLrdrNk0g4tOirYZLXWDoDYKMaEEfSINW7PCbX+cvWXJiZs+FUupbhMVoTP12h3LiCitDuKa1UhybVsz7AAGQ7vDoK5THZ5DRCbNkkCqR2IhwfTvMhCh22hSgqistUyPgy++VuIXS0uwFNa77AN0BFf/wg==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(376002)(136003)(451199015)(40470700004)(46966006)(36840700001)(82740400003)(36756003)(70206006)(70586007)(86362001)(7636003)(356005)(4326008)(8936002)(8676002)(2906002)(41300700001)(4744005)(36860700001)(40460700003)(110136005)(54906003)(316002)(2616005)(6636002)(1076003)(40480700001)(5660300002)(82310400005)(478600001)(6666004)(336012)(47076005)(426003)(186003)(26005)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 08:36:13.0664
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c57bbcf-6557-40dc-fcd5-08dad764eefb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF00010209.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6603
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

