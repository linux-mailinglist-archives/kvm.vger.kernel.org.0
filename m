Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0908763F3F6
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 16:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbiLAPb0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 10:31:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbiLAPa6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 10:30:58 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2069.outbound.protection.outlook.com [40.107.94.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D49C0AD31F
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 07:30:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KiGWaE2JUK8kGw2RGG0ILn8E9GUhMNdraQM1SPP1TXPcaC9SIB3wqu4bWptGZz+H/Xb+BEQkL0Me5cbGwq0ulJHL2Yp2v9nju+ZvJY3/wwWf/rRm5R+rZigm/FoUFphfy0vn5MsmHDFcMjFIXXAcqxlV7Gg3pewPOZO7QpAj3p/v+IRQdx75sQmB6yDVDiClVQ4GT2TjP5WMRzZ5S8KBTq02jZ49buPyBb/8TueiTUfermlePyWaqhDI/N1vbUw2ZcTt4vEsiUZWFrGoDeX2Q+gaVt2nz4/AMq2vm1VxGqF6sQiYM2emHpBMmTA7XhJt9W89ovo/IcKf8d9qUqOYpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tv4vz8/NSie+I1CUyuv5X9cZibCvVDSc8xTipAImjxg=;
 b=jIuIFumoLMQV0+v7Q1K1IsNe8tWv0AMmJNSuFhibx6lYX4db8xlsEtnf/07h0pKwYE3mf+29IC4mz2yQ6iHEgVG8zuBoYujzcoAesCDlnWyTUYOAVMc78JpX+f2tl8xPe+dZRQSjbg9h/wNrj/YFCAPe3g8eyKokXCSdzt523xcwPndXdW/o90z4KwKbs1wvTy0rXkMtEmCWQ/3mTzwYLD66Vo4b2JepH6OPq/myxMqjArEgh0F7+VHV9eNlAfbr61o6WFV6l1+2n8Yn4Qs3FQIYfyT+PTSr9HoeAi6GJRPgiV0PdSA1EgXZewBZwpIsAVXP8JiFGn17V7R0ikDjJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tv4vz8/NSie+I1CUyuv5X9cZibCvVDSc8xTipAImjxg=;
 b=VnLXtxb9T2K9I2evRCi9Q7QLKGynPxhwh18wH2rpngoPMxnTeIkLRuKhkelF2+GriGWgqsZxW0ztC0YKSg3d/aYvK1Xp/1Lx7Kqh/rTDzVbuewtBBUxTkct7Lpw83ptyr3AQLnFpFaiKJNYYkTxAzpXWYi8fghIvwnN5h7w8F+c+UvctqCL7yrlGsrvKfwa24NQTDUBVSB8Se3f5yIoEr3XVPwXZzv1c9gYqsH6kzTtASrSSJH8U7/MW2FyeReTYc6TIq3a2j1/AmbBySFXw7O1a3rV1HNWJucOgq8lVtpii2H76MWnGeRg1gDiY+NNMDQOGUfSAaiS/9zxRUSjnXw==
Received: from DS7PR03CA0100.namprd03.prod.outlook.com (2603:10b6:5:3b7::15)
 by DM6PR12MB4233.namprd12.prod.outlook.com (2603:10b6:5:210::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 15:30:55 +0000
Received: from DS1PEPF0000E634.namprd02.prod.outlook.com
 (2603:10b6:5:3b7:cafe::ff) by DS7PR03CA0100.outlook.office365.com
 (2603:10b6:5:3b7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 15:30:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS1PEPF0000E634.mail.protection.outlook.com (10.167.17.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Thu, 1 Dec 2022 15:30:55 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 1 Dec 2022
 07:30:44 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 1 Dec 2022 07:30:43 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 1 Dec 2022 07:30:41 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH V2 vfio 14/14] vfio/mlx5: Enable MIGRATION_PRE_COPY flag
Date:   Thu, 1 Dec 2022 17:29:31 +0200
Message-ID: <20221201152931.47913-15-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221201152931.47913-1-yishaih@nvidia.com>
References: <20221201152931.47913-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E634:EE_|DM6PR12MB4233:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d955fe2-15b4-4871-f428-08dad3b109d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ERvp91Qoz3l31/5ty2Lc+zDcMivPI+jj5nNV+EL0S/UMF8KSLQ5qfm+PEZnSK68O36rYk45frPRfRad6JNur/Q2Jrh6r/pYJS1sNtarl1rjiLBB9uTTc3tlVubTiJy2GBkvk/pA22kOKyEsiziYOoj0QZuGyehW0HEqQD0BufrvbXvgmpKgRlmQVoLbV2J/5ptkG2McDzMtybjaxKeUYXZuU9XdPDx9sCVJmdf6viIixBh8IIM84o2lsOU+h1GUoG/JlY8t/2TOLgpu76P2Q61+vozFxoh2lIWcmM17Ivg45wCQ7JsYWutLQs/74PkxHgGjw7ph1AxjjqKKaWaDdNf8ki2ge9h2VjNcPRh/BFFZIxYb11cLGaEP7Uli2qtfdN7WGyViEVANoVMkIvAzCMTtOhGjPxsA2R3lFvdl0FOwA3kg9386PMafMG8Xi6bffUG9DYptBJC/sggd7wtpL58reRz8dXdbFcVo7GRKflxxXdyySuc8LlA9+aeS6GoIJTmINaZuXam/CtSni5w+/rfJVVRD9JtDJ+aHIp+mQn+x5z1sKJfPfK9MbDbcCkZnl5A+sDJpI0YW7X5gll2cbAVm3cvSLqX5fTDs90+D1b+ywFkKkelTsMmCmtLPJhaAdCeHnua7q1oC2v4OYeKDjtojrF1Y1kLhDCrCxC1JjHSrvBVvJXvZxxPhkHttJwOT8u9gadA+nJOmm2VB/7af/OA==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(136003)(376002)(451199015)(40470700004)(36840700001)(46966006)(47076005)(426003)(336012)(6666004)(40460700003)(26005)(7696005)(110136005)(36756003)(356005)(40480700001)(7636003)(54906003)(82310400005)(186003)(36860700001)(82740400003)(86362001)(2616005)(1076003)(478600001)(2906002)(5660300002)(70586007)(6636002)(8936002)(4326008)(316002)(8676002)(4744005)(41300700001)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 15:30:55.2563
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d955fe2-15b4-4871-f428-08dad3b109d4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E634.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4233
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

