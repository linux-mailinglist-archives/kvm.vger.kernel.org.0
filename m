Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF39B79AE87
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 01:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbjIKUr0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235830AbjIKJkW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 05:40:22 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2078.outbound.protection.outlook.com [40.107.243.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6387DEE
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 02:40:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iDeyrvz4WkbbKBCmdsTrVsESSjGmhHPoneEnZtVY2K8zbxh3xr8drexATElEWWfuub4XPmnIseiD5yxR/IjhDDUFdQZD6J5xm9IOacglyfYCtq1cMRDgsiRg7EbwWadDHr4KgKqIE3FFTQAYxp2eYiE/Z5FMiYUOioSgwIeUHW/HNlMtllpd3agx3c6xDsUS03OXr8epL2aq23xczkYIgbMFouS10GLgrx/kL4IBQtOj61IJwTHyjyBSaF2lilM5I2h1HTo+3sNT2uMAugROPFUfXjPMM4Nk59/chFraSmzFkyLTkKqGqYMJfyUkwzQgyVj7QEYLthqUgONucpjI8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9dyyCY4+Q53oLYLjtoMP/hKnpiaIguKbKHeWHVlXRnI=;
 b=oX2D3HYg9a2dSwLvN0HVXEjjtpCyTXHlKlU0myAXKxo/kzYdXc6fZf7RkqoFQjWqLbSEDW+sYY8gCF8+xNaxqdeMSYt6mj9//HDF4Mr3qe4Z1yLk2BPUu7XOKud6ezXneF+cVoUZgSRGiTwZ6uYidbwfP+oRku9qrr2JolSaA/fn78nNhL+QcH811gijsXxPEObuQsOGssYlevrRGEfZnK1WWblYzCHkO96FIpOnjCSZUSEU1onE5c5HWGVCMA38g7+TISXueRIq4qAD+u/4yK+A1ds0oHgHW/sPX7+oxOQSrUZbVyMSLBIvxpS2Dr86UyHD+KH9upIaExJ4XSFOOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9dyyCY4+Q53oLYLjtoMP/hKnpiaIguKbKHeWHVlXRnI=;
 b=aZxYGmC9igjfA8+hAW7szM4EcXoFmnVYZeoxXS+AzxY52SVKuJxadLXK6PQQDYRco9CMlWbsIexE9/OG6MJZJWQ0XxG+U3FjcdWDW2WnJHBjIdxsPGyXfRq0cZFi7ah2tSiFOfFhzBKycWEDfyRWI1c/l/WEgduh95CG10+bWMBzaKJwgVFkaHmpDG0X4srf4dOR3nvwh7+Bbv1BQbHxOLbkO6ylqECy2o4rRgHKKFr63fcOo+b8L08TRurLi0ENsxdQVON/0iPJQei0GSk5eMIO9zzadlcyr79cizXgBz9tl3SQ+Ilu0KSSnxlRrPO4D5X8D27VDOM90oZLzPJdIA==
Received: from MN2PR11CA0003.namprd11.prod.outlook.com (2603:10b6:208:23b::8)
 by CH3PR12MB7522.namprd12.prod.outlook.com (2603:10b6:610:142::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Mon, 11 Sep
 2023 09:40:16 +0000
Received: from BL6PEPF0001AB58.namprd02.prod.outlook.com
 (2603:10b6:208:23b:cafe::af) by MN2PR11CA0003.outlook.office365.com
 (2603:10b6:208:23b::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.35 via Frontend
 Transport; Mon, 11 Sep 2023 09:40:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB58.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.16 via Frontend Transport; Mon, 11 Sep 2023 09:40:16 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 11 Sep 2023
 02:40:06 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 11 Sep
 2023 02:40:05 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 11 Sep
 2023 02:40:03 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH vfio 9/9] vfio/mlx5: Activate the chunk mode functionality
Date:   Mon, 11 Sep 2023 12:38:56 +0300
Message-ID: <20230911093856.81910-10-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230911093856.81910-1-yishaih@nvidia.com>
References: <20230911093856.81910-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB58:EE_|CH3PR12MB7522:EE_
X-MS-Office365-Filtering-Correlation-Id: 6eff3a3e-6a3b-42c2-b69a-08dbb2ab1b0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UV0VUW+yR3q+k+Im8XeW9XCrezRYF12XYxmsA3gSl1kUCWqU2B0WjIK+C1GB3JMIZbXtaIgKHUeFhilw1igbXnxeiw9jfgryA815yjUA4LBPfRdbuLVIDjmNaL5qFx8/fMpAgJiBAhz8ZXZzNJs6zPtqy51D7ZzhyLzhLbuuo9BDLFrAEsdax8TZncw14fbMX2QE66JRtmnEH9HqRwR5CBXe1/CV5oMavpTwA/1F9kSJTdKZKpl0apfcl9mmRM7VJrtSnKOYdxEkOl/ORPB6G40FC9hC7B4KfbpEwTAJETqhkZR8TeBJp7QY+L5tjk3zjE55BzuGN+PO6RkglKCt/sGsj0NMmltrSvY5ckeWV1nQMDqhvm1xtj7mH1aBMAkiK8w7jysQQGB9p20aVU2VRS8m/uNQcrXWv87Gy6lpLDBhNfO9WkPSddPQrtDEIl4l4+S+jWkAAZsioB7Os7zWIP8bcU/O2JvUUon8wGKCY30kLVhYPxtDsb3gbEiqfN32EcK/So5D9mAzMftC09yV1UpgGWRD1Q4JDq3hBZoptShhVF2SskIpVotkSnK+JYYtP2u0Qs2hT70PxfLZAtqRPPSK6CU21w1pd99JysRIKbrCd6xfxKPYbZkv9DtWPnII5gOSaB2reNKQCw0TJt6xjM3GlBehTdb18BOI4BTGwkQiw+hPXonX0wxY2jva8lSScfet6Nz8HQ42rTjJg7L3kp7wPVQOso7db5R8pKo8numTgY24bRItbSqbRwsqxqyT23jv8SPfL7R1LmPPEEwQYff2kGQKoxV5x39Mp5lpEREgQJiIRpbcDc2KJrwqLTgGkFCZTCyUPz7e6xL9GPmqiA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(346002)(39860400002)(396003)(451199024)(1800799009)(82310400011)(186009)(36840700001)(40470700004)(46966006)(8936002)(41300700001)(70586007)(316002)(1076003)(8676002)(4326008)(2616005)(70206006)(107886003)(426003)(356005)(82740400003)(110136005)(7636003)(7696005)(40480700001)(478600001)(336012)(54906003)(5660300002)(26005)(83380400001)(6636002)(6666004)(2906002)(40460700003)(36860700001)(4744005)(47076005)(86362001)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2023 09:40:16.4192
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eff3a3e-6a3b-42c2-b69a-08dbb2ab1b0f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL6PEPF0001AB58.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7522
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that all pieces are in place, activate the chunk mode functionality
based on device capabilities.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index e68bf9ba5300..efd1d252cdc9 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -261,6 +261,9 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
 		mvdev->core_device.vdev.migration_flags |=
 			VFIO_MIGRATION_PRE_COPY;
 
+	if (MLX5_CAP_GEN_2(mvdev->mdev, migration_in_chunks))
+		mvdev->chunk_mode = 1;
+
 end:
 	mlx5_vf_put_core_dev(mvdev->mdev);
 }
-- 
2.18.1

