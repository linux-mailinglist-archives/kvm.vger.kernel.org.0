Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0810761E50D
	for <lists+kvm@lfdr.de>; Sun,  6 Nov 2022 18:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbiKFRsM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Nov 2022 12:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbiKFRr7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Nov 2022 12:47:59 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2082.outbound.protection.outlook.com [40.107.95.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D7B6569
        for <kvm@vger.kernel.org>; Sun,  6 Nov 2022 09:47:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YEcl+mpwPtLdQzkgx1C5YY4a2ydaTRukvS5ERNV5TdCqcqNdYFTcPWvRY98DOQM79/ICQ/1OSUU2BPpdbgOTY7ALpAHmGgDZ96/gotKGLmeytBngoYFvPEeRN1SBg3gUqd+9QMc5StzAXd/LlHlmzOlSe37LcbT3jlhORH0OnY9gNCXGCrXM0sxbU2PlEVyQq8NLWIQr1NztG+NbSD0XJXEePIG+834JuWa8b3q4V3b63rwf7Pr5122XdxsisYsU/T7nlaz9rSK93cmk7oUXZo6unxLG+pOc9Fe81beyeuV+9C3Jkj4sLy9CcQwW3XP4zolVR+MV7aQJh8khguZN7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f61bF3voGi2g7EHk23iYWXebgdkBJ7TNNjnngTUGQo4=;
 b=cO1EDXcEZdhUvTfKLizll3OG1GKoaNK5QtcoRIHZF2Io7JUdTNEiEsfHg+GjzW6HbLEfOotfh4DOU+z5e7nyl+ohLK9r0SJQoLYf6IUZIPvNbjTzZfhxobj6OY+wKd+nXd/I5ur0fBh/EWJfL29W3etU/6oUlXO1wRctVtFDcti9IVbmoa7mPWhMx04W40Ckh7sDnPZyELv46xh+pDgT0itnvTzc8mhAW9yNKau93kpzU9WTcUlUlDlyOulrXCGFaCiN2nelcClMswRcCNdJrTCFVFSTlAoYMzOOr0Bs/CUlGO7WM4C4DTCcaMaemMuN0qoH2taqrUlTClgUZbix1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f61bF3voGi2g7EHk23iYWXebgdkBJ7TNNjnngTUGQo4=;
 b=BkR/HyOJo+Ekodq81tSJjWICUGUZa8JF8+lMvnj54K9LC1YxbpO71kOf9sD3bM2i6eLzzQ+tLw6sAOt+Qz/Wnf1qad01QzjGk0aS3Njox8nuEOu3D6SPW6hQd4d3OG7UjZRuGWLtBtxzDkNCIpU1XfOjIEagHvfWXdqvnEX8KJ/KpjuRHr7aSUfFPC7UBwY+jHL3c6gCrKNxxfK7vkHVg2ejgLK3q2AGTLNpYkjOuZqbdm0NFv9iN0S669vqk+lfCIzjV87fvJlZJnfu8rQ8gjVSvR9+w2aYkx5KdYAqM/UiutheiMUJU+ltUnDK/FAyg9IDKkvTFA7znATP5S4OmQ==
Received: from BN0PR04CA0182.namprd04.prod.outlook.com (2603:10b6:408:e9::7)
 by DM4PR12MB5963.namprd12.prod.outlook.com (2603:10b6:8:6a::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.26; Sun, 6 Nov 2022 17:47:49 +0000
Received: from BN8NAM11FT083.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e9:cafe::3a) by BN0PR04CA0182.outlook.office365.com
 (2603:10b6:408:e9::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25 via Frontend
 Transport; Sun, 6 Nov 2022 17:47:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT083.mail.protection.outlook.com (10.13.177.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Sun, 6 Nov 2022 17:47:49 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 6 Nov 2022
 09:47:48 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Sun, 6 Nov 2022 09:47:47 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Sun, 6 Nov 2022 09:47:45 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH vfio 13/13] vfio/mlx5: Enable MIGRATION_PRE_COPY flag
Date:   Sun, 6 Nov 2022 19:46:30 +0200
Message-ID: <20221106174630.25909-14-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221106174630.25909-1-yishaih@nvidia.com>
References: <20221106174630.25909-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT083:EE_|DM4PR12MB5963:EE_
X-MS-Office365-Filtering-Correlation-Id: b034f91c-861b-40ae-1a87-08dac01f0586
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZzgRpMcSorrOOkyd9eUDEP4XAtZsBp6uakr3JSFLjVF2t2DPdqOT5D1pEUZZ7SZ854RI91srSUwDlSDZ+1IhA8z6VScD1QuwrsKTs3EuWkgQf1tqBrr83R9o9vJLdKAXDayActJKAzyFnvkya8UVNrEmD/Pc3iVs5r8CmbzrtsE11c4zcVQEvVkieH6RMylOvWuImUfJQLZaoLlYa1YyXso0+yh/TeHKiXpe602ThttcQPQwjyNhbtO+mkWO6MW3/8wQEn7GOF3oKdKEny4edhPXYAn148UwDNyo/S1PDaOqwyYw6148yNXp3z5f7AmJLA+CCweDy6RYebivTa92fQaA0DhbYc1lorXVZuxwY8GQdABGOwa9EPTmt6i7mu0+6kDVISW/Pv3nz5c2taYOW+YMCKANH0E4stzBi1ffD+D7KFlgtAxjVk6W/HQTKE5+EaO0eVLf1lWjMhv+cAr3yck3FIq3xRUZzK+/izhvYeBErPszp8RRcVhEGg098sfwr/tmrr2ga/5m0z9ZqwQQs886qbmzFZOmz/pXyM7iDUiAHA4ktCcnt/qZICKX77l/e9vWQBEX3xlK+izVWfOqA3OEAow3dJekTpptxi3euLgzfoPzmhiMHzSMPMOdvJ9ikTgwJb2VgSO7L5gRTS8WshnjfZ/LO4IG4uGElnFWnMX5Guz+KkF8DI4fVKHRMjUx91SOOFNM79yWMZeGzptEpplNhXaO9N7aWWJiNPoavDV1rNtQfbJ6EoVboMVcIIaVjray2B0FfA9MxnFcde7Utg==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(136003)(396003)(451199015)(40470700004)(46966006)(36840700001)(478600001)(40480700001)(4744005)(8936002)(36756003)(5660300002)(2906002)(316002)(6636002)(54906003)(110136005)(41300700001)(70586007)(8676002)(70206006)(4326008)(7636003)(356005)(36860700001)(82740400003)(7696005)(6666004)(86362001)(186003)(40460700003)(1076003)(426003)(47076005)(26005)(2616005)(336012)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 17:47:49.3509
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b034f91c-861b-40ae-1a87-08dac01f0586
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT083.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5963
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index ef1c141dc5e0..8c3bb706f630 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -202,6 +202,11 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
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

