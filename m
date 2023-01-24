Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81AD679C84
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 15:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235045AbjAXOu5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 09:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234988AbjAXOuv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 09:50:51 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7B630188
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 06:50:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQn3lT6UaD33dPLWsA80bV3fJLTP/1ca9FWGsVgH5sjKj/l3aw6zVXoWnBoMqXA7LP9EijAhNvpgJKjADk67x3+KsDkoIoLJeoNWSnu6Fh98KYSs0uFTgIFcCJC/PyEMDO3g8xHkt4zgh8tB/WR4YCOghKMctwDZom1PdYWGkKID0ekTAgleLUH4ZXp+/opG+n+nons2CppRBOAi6of8qqmwtAUmsu9QoSzXxh7KSHZJhf5kFqAQ91zB+8ixFssa18FBY/CTOoc7/UwhmEuVsuI18RnqUCxfMPNAltF6GrdOh7UCubemj6WMbhRSUQRJrjhaQL8gBAlutXR5DJWEPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4FlYJLCw/SAkJAYbp00ixafkCDI1ePIVDz11ajIdqdk=;
 b=FJR/n/outPy1nSaft8v1c+8Etr2pqQ95Z69Sflpc7jyEpWYZqOBTDpe4gfKw9A5TtgJjZEg1mVwRZ8z8Kc2kZY6TOohqtsaJ/UTP4bJAhEUsejGiuTztg3ioVGwXbJqk85E6X+T/0BKKTMXzhpJ7L+yenJ/70KutaNvEo3Ewy7LC8Yfv5I40ev37nVhwI8BZctS91Yw6WZIkFQG440XHNCPRUIUAEsyOchoD+pklvxv51fjE59xYM9O53D8o2GHaQetlH+EtjJa4q8nFVyjADrBNmXPyAn+w3nzW/JQDGCN7gquXe8ryVrZXq44MABiiFrX3WPXr05Ez/tNrscVcoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4FlYJLCw/SAkJAYbp00ixafkCDI1ePIVDz11ajIdqdk=;
 b=FURH09nfwDENfqPO/NjFILT5qcVc8oRqmy12bOWaU2Z1tBz0pp/tZ4w8dSA7LoSdbbM8613j5BLqu1o9GZPU32iL/vXa8fLidk73Mc42gX6BJzW+oxcLj02QZ0KAmZquh4oAanunKowbQfCItuhtv8ya5EkrJ8qoOvJQgHIKcobPU4s1x4qp4BJ4OA7OJiuZ/nB7EDQVoJqYWt0r4NlRc/yT29WKATW54vqTEY9DvmKXuyyRZStL24qoFhZUjPXwD35lhM2swvxHI8b8L6RimTRHr+tne2XaFZtiL+GZSlahn1XSuPB/dk4GD/lz3gLIe1qEIo5+HSu0bXRyf9NxwQ==
Received: from BN9PR03CA0631.namprd03.prod.outlook.com (2603:10b6:408:13b::6)
 by DS7PR12MB6167.namprd12.prod.outlook.com (2603:10b6:8:98::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 14:50:42 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13b:cafe::45) by BN9PR03CA0631.outlook.office365.com
 (2603:10b6:408:13b::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 14:50:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.17 via Frontend Transport; Tue, 24 Jan 2023 14:50:41 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:50:23 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:50:23 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 24 Jan
 2023 06:50:20 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>
Subject: [PATCH vfio 1/3] vfio/mlx5: Check whether VF is migratable
Date:   Tue, 24 Jan 2023 16:49:53 +0200
Message-ID: <20230124144955.139901-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230124144955.139901-1-yishaih@nvidia.com>
References: <20230124144955.139901-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT026:EE_|DS7PR12MB6167:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c9c1ff3-bff2-4e81-56e8-08dafe1a5d8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TFACilrKUBZaWQxhoyKbVM0Ogw72jeOvy0rO5LrkYliPHy3occYd2veYGMgBz5XP9xpq+6ieXL4XWMaktna0Ux5WbsMb964Hq4iXrZHGYcw12Kqg9e1uaeGC+51J6n5qquKJLezZaj9HEYTNnqPRuQHfMnXOnAtUXe4Qlq9l82QwEr1i8QX/ufCTnj5Q9D1ZHwRE+2bTPFoqPpiu46AP2IAltRSTJu0wwyX7f19kXwl0K4jktXX088bUpKEN7uQ+MkvvGQFLeQ+WDOu82SUlsneMx6+AXa47ZktFPpXb8w7nlZOV7h54t32PsfAjZKzaJy3bgaN3aEFZTeq3PTO3Y49EK74+C8fzldW/79H+npsSoXP/FbAmuuopa68kzgDUBB2i48Ez8wBF5tD3IEX1SGqxlrbsOiQPraBZ+HML5EX1tGhFQo42TXBeExUM3b1y9JJAPR2Zr3MdkR3jWI55o5HlRZs1iy3GHSgj7JD29uxUduNqSRi/c308nYu8z0p4hd4fvmwd210CIRk2PxK/4NxYjJWZYhXT6zQs0iWdGCZx1Y/QslG1S3tfs+vi9XcCceKDhOX0uaJ4RzaEJrezrvmPxLkXtZEYBOkmQFUXLzlxIYOtJaWnuqfeGtQonrZbxj9pFBBvvSmvuEQa2LxZvMhC7OEvPkzFjIPl49BK7hM3DHMR1afDS/YU4zMaJi240b7SCvQZXOQLuovJspRCNw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(396003)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(36756003)(41300700001)(86362001)(356005)(7636003)(82740400003)(8936002)(5660300002)(4326008)(2906002)(82310400005)(36860700001)(110136005)(478600001)(7696005)(26005)(186003)(8676002)(40460700003)(40480700001)(316002)(70206006)(70586007)(54906003)(2616005)(1076003)(6636002)(107886003)(6666004)(336012)(426003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 14:50:41.6489
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c9c1ff3-bff2-4e81-56e8-08dafe1a5d8b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6167
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

Add a check whether VF is migratable. Only if VF is migratable, mark the
VFIO device as migration capable.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 27 +++++++++++++++++++++++++++
 drivers/vfio/pci/mlx5/cmd.h |  1 +
 2 files changed, 28 insertions(+)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 0586f09c69af..e956e79626b7 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -7,6 +7,29 @@
 
 enum { CQ_OK = 0, CQ_EMPTY = -1, CQ_POLL_ERR = -2 };
 
+static int mlx5vf_is_migratable(struct mlx5_core_dev *mdev, u16 func_id)
+{
+	int query_sz = MLX5_ST_SZ_BYTES(query_hca_cap_out);
+	void *query_cap = NULL, *cap;
+	int ret;
+
+	query_cap = kzalloc(query_sz, GFP_KERNEL);
+	if (!query_cap)
+		return -ENOMEM;
+
+	ret = mlx5_vport_get_other_func_cap(mdev, func_id, query_cap,
+					    MLX5_CAP_GENERAL_2);
+	if (ret)
+		goto out;
+
+	cap = MLX5_ADDR_OF(query_hca_cap_out, query_cap, capability);
+	if (!MLX5_GET(cmd_hca_cap_2, cap, migratable))
+		ret = -EOPNOTSUPP;
+out:
+	kfree(query_cap);
+	return ret;
+}
+
 static int mlx5vf_cmd_get_vhca_id(struct mlx5_core_dev *mdev, u16 function_id,
 				  u16 *vhca_id);
 static void
@@ -195,6 +218,10 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
 	if (mvdev->vf_id < 0)
 		goto end;
 
+	ret = mlx5vf_is_migratable(mvdev->mdev, mvdev->vf_id + 1);
+	if (ret)
+		goto end;
+
 	if (mlx5vf_cmd_get_vhca_id(mvdev->mdev, mvdev->vf_id + 1,
 				   &mvdev->vhca_id))
 		goto end;
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 5483171d57ad..657d94affe2b 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -9,6 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/vfio_pci_core.h>
 #include <linux/mlx5/driver.h>
+#include <linux/mlx5/vport.h>
 #include <linux/mlx5/cq.h>
 #include <linux/mlx5/qp.h>
 
-- 
2.18.1

