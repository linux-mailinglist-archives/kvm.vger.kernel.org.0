Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B466A61E501
	for <lists+kvm@lfdr.de>; Sun,  6 Nov 2022 18:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiKFRrS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Nov 2022 12:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbiKFRrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Nov 2022 12:47:16 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2082.outbound.protection.outlook.com [40.107.101.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9186479
        for <kvm@vger.kernel.org>; Sun,  6 Nov 2022 09:47:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k/4rhUFwavHFZcr2ejxVgcU0d8k2cPHZcGgPdawEcSkvlg7c+1S5626TBWY+j94jBoXg5z02074JkJPnGWVtf45BBkYLJcw0LG+FwxT9pE6qgDZrcWEuaOPE5cHWTk3++uwBKsFR5fZrktuOHU3UG16vupvDZpJY9e694pH/oMiFbyF6rlXkUHVdsgKmbYQi4LUIhA3+evQEK1FWyeytSv7IfVUbQ/ff/3EmjsnT1q1oevlEfePIxJUAvQYo7Ru5SVgBwJDoAO11vc9NZYnTJKu+DHALxCguEtgPxQPx6nvcXZNUfS5i2QyzgyIas4XDRX398O4w047QSYbNLdjUPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vjm+z5O/62oj3E9OBEYAsU+ZQ0yPw1f9Zb2up/kXkdY=;
 b=PXvj0srMmhxX1hZKr9ZpD7JWGViIX8RCBhRRvtqcvslCzjqwNXZ2kVObfiEWoOLURzQiVq6mDLr9f+TSc4GQ6lVrIsCOYlWOHPzVYOUhGxBg3TgFeugL9lYHpkMS0S1s56hupKFzTA5rFYSt2gx5ah3VHZqNCYgO5FmnJ9KVtnNLA+qb+32n2or25ey13g25Mc1IxemMLIBfKpDPbWA7CapHhDBQeHT0i7RvbPcQpyRCN8BMUqfPg7+nPY5HXMvzjBbRwZd+3UJIqVXnh9Da6aw5kgfESl7jQ0C/k8r3px7Ta6MMt1ZzhO7QkM7ooNumvIcRoh1fjdVX3nFyqGFAzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vjm+z5O/62oj3E9OBEYAsU+ZQ0yPw1f9Zb2up/kXkdY=;
 b=dEpmKMgdh7NmV0ESM6oAxWodB6k3ibKL3wIE8n+Lq8AlSjFdNDPBx0d+J4+Ir07zUbDB0SkJ75vfPEd+hjErbGiDcy2eifDcygZit9/afLCdTdmTNC696lltXM3RB5UdxrASTFYW93T9u7hRHF8k4sXWS7lu8ZDlcsXs1G+HDlVen0FS4g/EIyjRkvEaTWDHPngyAwdQxroQ4j8walzCNs+kDjdF8BtojUh1AEUCoyGLf3NVq9A4cpf7ZMGr1giIuLGBP0iwa9VQ+AjS5bUEg3xnNcl7MKHJTKmERgO/mNJKDdmHnJdDKttBDLZD9UgzgmKGKobFBouKKWSzka+w1g==
Received: from DM5PR07CA0106.namprd07.prod.outlook.com (2603:10b6:4:ae::35) by
 DM6PR12MB4417.namprd12.prod.outlook.com (2603:10b6:5:2a4::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.26; Sun, 6 Nov 2022 17:47:13 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::18) by DM5PR07CA0106.outlook.office365.com
 (2603:10b6:4:ae::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25 via Frontend
 Transport; Sun, 6 Nov 2022 17:47:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Sun, 6 Nov 2022 17:47:13 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 6 Nov 2022
 09:47:13 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Sun, 6 Nov 2022 09:47:12 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Sun, 6 Nov 2022 09:47:09 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH vfio 02/13] vfio/mlx5: Fix a typo in mlx5vf_cmd_load_vhca_state()
Date:   Sun, 6 Nov 2022 19:46:19 +0200
Message-ID: <20221106174630.25909-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221106174630.25909-1-yishaih@nvidia.com>
References: <20221106174630.25909-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT010:EE_|DM6PR12MB4417:EE_
X-MS-Office365-Filtering-Correlation-Id: dcc395d5-2014-40e2-ae8e-08dac01ef034
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ekJCcp2/S5wdA97BVcPNq2RMF9kLMHO89SqF2IONschUCUIQmZBriTBKKqSl7mBU8M/yN76tXoR2Km280OFSOkoW/83bYGtf209SBzXPzscm6JfFe4xi0BSV9LV/z7/XS6R/4Qe4BiWcQ9KoKbm8c0bXVB/oYkQYq49uZCBxRbM/dkWNnx/k5cNG9VgLsPVq+sIjvOAAhrYzRy2synVU5xb6ZndhNzUeYDQG4o800WzXjArvWrg4YyhHTHnmMNzM5hzezlZEl4Dge6d39tGaE0lw3T8by55nHhAqr/8kWrylWlyyxP2N3NTrfmS/6/khqCD8LgdwtSXNdP7dffKRAtnWiyKqTDUn+FXm2Hjo9IEeqJ54tcSmfo10qOck6qpLwsXSvBnOwwNFXllC5ELSKN0YHVZ6ztL9iH0AyYzgKTaz3aLXUnaG2oeHD3OZPksibTiyT2aGzffd07WYlTE5KaiDdjTlR5BZhL6tfl6AlCN9slyhj2o5PZr1tLA8iGUzA/Q2dzmnMZ6mqhmoG8OkqJLGBzIbcCuTvKUrAylu2T8Fz1TYiZqIgWYwzAyFMxaZbEjrPQxVc5/hhfSHBekELQxF7z+UwevlGJ0yantAWLLlyZ8fU7929JGEkPQtC65l5jV9030KSlxr8x5S6Ps8wZ/d2GleQfqtEuqyScqEEhfPV1HR3rhDDZEGTJT8gJIOrJ0CB73WWwuoUHKH/OMkOJriN8UNqXTD+LkV4Aa0vJRZjy23DEhRUw4VvbJKBmpo+oW6mRWDxRDgpRDbpzshgw==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(39860400002)(346002)(451199015)(40470700004)(36840700001)(46966006)(36756003)(356005)(7636003)(82740400003)(40460700003)(86362001)(40480700001)(478600001)(2906002)(4744005)(6666004)(54906003)(8676002)(6636002)(7696005)(316002)(4326008)(70206006)(70586007)(8936002)(41300700001)(5660300002)(110136005)(82310400005)(36860700001)(2616005)(336012)(1076003)(186003)(26005)(83380400001)(47076005)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 17:47:13.6476
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dcc395d5-2014-40e2-ae8e-08dac01ef034
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4417
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a typo in mlx5vf_cmd_load_vhca_state() to use the 'load' memory
layout.

As in/out sizes are equal for save and load commands there wasn't any
functional issue.

Fixes: f1d98f346ee3 ("vfio/mlx5: Expose migration commands over mlx5 device")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index c604b70437a5..0848bc905d3e 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -378,8 +378,8 @@ int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 			       struct mlx5_vf_migration_file *migf)
 {
 	struct mlx5_core_dev *mdev;
-	u32 out[MLX5_ST_SZ_DW(save_vhca_state_out)] = {};
-	u32 in[MLX5_ST_SZ_DW(save_vhca_state_in)] = {};
+	u32 out[MLX5_ST_SZ_DW(load_vhca_state_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(load_vhca_state_in)] = {};
 	u32 pdn, mkey;
 	int err;
 
-- 
2.18.1

