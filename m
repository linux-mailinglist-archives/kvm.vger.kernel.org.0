Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1D163F3E8
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 16:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbiLAPa5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 10:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbiLAPak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 10:30:40 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74EB5AA8FD
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 07:30:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fTjN313Bt9rfHYxByo1usFAoO3pVi8AQaaaINha7Y3JmX+XKswcvk0A/7h/yp3zEF4l16+FFx/Jpc388RlgTBCwG8RT6wydyWV4xwCaAc6vusY3XdjBKhvlu61K7k2IOysYy6PfzmmPmVNiGXTqk/hJ4LIqXcTRe5ZVD5kVwIK69PAvE9xD0z1g3knmOpDUnN31B32L4A25C418ecwWz7bf9ptu0/2yb1mWLSnkD2YscJTh1h92ayHI8PcRDqXWvnQ9mFBMgGef+JYzLQTRbIkMWK1Rn70EAvFMUeGXu2T3NJP6u6InZ7z68ueRsaAJDY+FEG2RDaJPTeGl5QaZAtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=atS9WtVhHIUg8aIzy0neojIfiBRjVu88h+ixljUF16s=;
 b=SM7zZrZFowMDOebjUKHNmureoA7g1/3eHlvjvbPn5NAWhALKhc4VaOPefmTNgKKHpImXyzBRIM9I5J3PbcY+OtV2YFodzU/zPy/JwwWqRC/XD1U/Sn65VN+V1xUZcioPObM156S/2s7uGS9eHYTViGgx/zQ6O6hhcqr3Bngsb0kl6JWHRIYno6PIyztu6aJ0gTGdBUxtqjJgdNBS04r37nO7ZUpJZig2EDJ4VONw7raB877xTT3nGYL+d8lo28ldCGJRFmWLZ9d9nrSjGjnO9XpFYNOKk4MXnWCTbwwooXKnoNlmAtMVdkVtf9wuMYHcMovo7RKxdbX9nIxe+ArBcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=atS9WtVhHIUg8aIzy0neojIfiBRjVu88h+ixljUF16s=;
 b=YbWKt6H+CN7KsVh0ZlSc8KmecT0LRxo65PCCJxaCP914SxeNUD65ztOQaahwDcEn76CDSmUyTUdaZpkXUXs9T2Oga1c8sLDtdnvVqr+Glg+N8p344O8UzDEbciQTs9r7q+n5i0+s9Je2MvwIYZiL9006fOk7IrNZjYV2whRdXZwcy6uR0a3z81BW8jn18u1TmWKGRj5AsoRh2YDvyZ0OqQwER+UMmpoSb2XIBaJh2214d86Z1js8KrcrTAI4iM5OFomo5O0ocqWZ3A6ZF6NJzm4lHgCysh7UuALGBrJJUd3kBOks3o/5w8z4srTlWg0J3/DxjMEZtdwIEljp192pJw==
Received: from DM6PR06CA0083.namprd06.prod.outlook.com (2603:10b6:5:336::16)
 by DM4PR12MB7525.namprd12.prod.outlook.com (2603:10b6:8:113::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Thu, 1 Dec
 2022 15:30:12 +0000
Received: from CY4PEPF0000C964.namprd02.prod.outlook.com
 (2603:10b6:5:336:cafe::b5) by DM6PR06CA0083.outlook.office365.com
 (2603:10b6:5:336::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 15:30:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000C964.mail.protection.outlook.com (10.167.241.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Thu, 1 Dec 2022 15:30:12 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 1 Dec 2022
 07:30:02 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 1 Dec 2022 07:30:02 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 1 Dec 2022 07:29:59 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH V2 vfio 01/14] net/mlx5: Introduce ifc bits for pre_copy
Date:   Thu, 1 Dec 2022 17:29:18 +0200
Message-ID: <20221201152931.47913-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221201152931.47913-1-yishaih@nvidia.com>
References: <20221201152931.47913-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C964:EE_|DM4PR12MB7525:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b03ffae-dde6-4da3-a25d-08dad3b0f051
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YLv8kL4PhqEmENC7qV/hcdjshiPEA7Jb5aq94HbDTqmGOKUgWml8ssAnZtLIBHFrE2eSOuY55g2aKBoOiAnXKoVzGFXcsBJk4buf8x1FpTUjcGzxdfJhjAxOhfm/dMAgNKyf6Z2/G3Jzr7EW4YdVCB1ShxlVyOkAsgbS1V9Q+Ehz5xOhEWcNDbwL4/IYfaQsIiIWS0Xz9RkOTSeOGtGwylFX5gVhPKnIxE3t5kf8Hfd2vtX4HwUtpYXzfRfCoY0qyI2mOpl9j1C6hYwuG7alRSvQT7n91BRs9nib/+3zMNJ5iZSK54RuW5WdiJ6mcJT28D6STgH0WE5unYmxF7Qk+yeI4u7g8DV7vL13alTsNqTQpo5wPQgoFlYFvsusHm6XWkYIyxWFziChjH1KlKwPPz0WUBckI7AWFo6/8k2WrzOTU2jtaoz2O6nLMx9/bqoY69CVF1S/k28faegk2qhGZ7sprxEP/CAbyYbtMR0vsvG6irU9TSOyzb5yo0uo4VM5csJyZF3H5m1yIyoUKJHAxNKeHS83nBnKr3wAD8jJic8THKv0VD1NdufkHvXnXPiwyAK/4soHgO9ucD5lgOB8bTi/8K9yHgPKkJaTL9jD2OncoflL+s3WiAjho/8ZKmpCaJ6EOY4nS4GHXwLLAP1DMTy+wgxXF4C4iIDnqUWe1bkxFwUzNfMSQbJHdVlp44k5d4z0mThYP+vhZfQ+6W2ibA==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(376002)(346002)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(40480700001)(36756003)(7636003)(86362001)(356005)(54906003)(40460700003)(6636002)(110136005)(316002)(5660300002)(70586007)(8676002)(70206006)(4326008)(478600001)(41300700001)(8936002)(36860700001)(6666004)(83380400001)(82740400003)(47076005)(2906002)(26005)(186003)(7696005)(82310400005)(426003)(2616005)(336012)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 15:30:12.4839
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b03ffae-dde6-4da3-a25d-08dad3b0f051
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C964.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7525
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

Introduce ifc related stuff to enable PRE_COPY of VF during migration.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 5a4e914e2a6f..230a96626a5f 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1882,7 +1882,12 @@ struct mlx5_ifc_cmd_hca_cap_2_bits {
 	u8	   max_reformat_remove_size[0x8];
 	u8	   max_reformat_remove_offset[0x8];
 
-	u8	   reserved_at_c0[0xe0];
+	u8	   reserved_at_c0[0x8];
+	u8	   migration_multi_load[0x1];
+	u8	   migration_tracking_state[0x1];
+	u8	   reserved_at_ca[0x16];
+
+	u8	   reserved_at_e0[0xc0];
 
 	u8	   reserved_at_1a0[0xb];
 	u8	   log_min_mkey_entity_size[0x5];
@@ -11918,7 +11923,8 @@ struct mlx5_ifc_query_vhca_migration_state_in_bits {
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
 
-	u8         reserved_at_40[0x10];
+	u8         incremental[0x1];
+	u8         reserved_at_41[0xf];
 	u8         vhca_id[0x10];
 
 	u8         reserved_at_60[0x20];
@@ -11944,7 +11950,9 @@ struct mlx5_ifc_save_vhca_state_in_bits {
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
 
-	u8         reserved_at_40[0x10];
+	u8         incremental[0x1];
+	u8         set_track[0x1];
+	u8         reserved_at_42[0xe];
 	u8         vhca_id[0x10];
 
 	u8         reserved_at_60[0x20];
-- 
2.18.1

