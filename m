Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC9E637E72
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 18:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiKXRkh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 12:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiKXRkb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 12:40:31 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2055.outbound.protection.outlook.com [40.107.96.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3952713F489
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 09:40:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kM9bilcaL6dlqm34xrlCH/Y8iPrYAh8ml6rdAC8JBRb8/BBTnTolDXP9iV2r/naar1sQLJpLKSMapfmAEULQi6iy3ADnRRMZu4BoArLPoGHxQxmc1ENVvfIas3JItDjFZyHoIzQKRJqT0kKfTMVEgNiIvBmxgGmMLhWhX2jEaKTiWfWoAtqckyKyBjUDc337n7Q/dDbg5I2nrCDnWW6sRAK6ciN1y2Q+z3qTWayD8wgldNm9+oVlwa4UJqZTVN56KPtw0W6v9B0/bT4qb+NZD1lCawmAIBzQyURNgwcyBaBQq/YIVT7t4ZoRu+rGtkINDLqy9cC/4iZbSZ6MkYkCLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=atS9WtVhHIUg8aIzy0neojIfiBRjVu88h+ixljUF16s=;
 b=C3skPoqVTr/pgq/Z5yvEekMqAxt0grW0qiOveEDxTreujdmRBOpunbunR2k7/6p34uH28xQGpUtPFwNfFFvd695GoW7LxoD4ILIjXSwfh2NJpRCKMP5RcLtTo02/zYQlAsZl7y3ZN1qoHuOuAci9rno+YTSfJjzWwJMmwEtm44nldrGJBz9aM8axjbupP/mrr4qO0oDc0IRCcJyt55s2QeKs4Y3/F2XyyR1rNBf5X7zDryEWPgmLqcNfAAOcpKsWPxMcsKdZnCCQuLoXHybyjPdfUwDurBg6qFDT2IRJJxzrerSDhd58jLKQzJsaEFon16utAalkW+sV9xm2gz/skQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=atS9WtVhHIUg8aIzy0neojIfiBRjVu88h+ixljUF16s=;
 b=eEP2JPwkxrswAh33U7jXVERxkfuRdrzw0u8bjfx2/4pG68QhskCPBN56qi2RibgsWTlTcecnZ5j04MRTh6XfcabQvHhDvVTtLwc3wnwKUbF40XPEMBKpC0EB2+SyPSQCFOHZ16Yd733pLZAY2puvX3v6QTPYWdK8iOb/w3N7ruiFhE+Gx4G2CMHecP54rg0TBgOd3ymf0UgX+01ZXljt8wm4X5tDzIPS60b9FNXbNHU0B040Hujtt8PnZniv/lkGawVxi1ZUQNI0bCd2jstOoIMKakh1/L7WKrTanWDTL+BI2u+tH+k8M6cesAoLzEGgg8nG+H598sVM6VaL3FGW5Q==
Received: from BYAPR11CA0072.namprd11.prod.outlook.com (2603:10b6:a03:80::49)
 by MW4PR12MB7432.namprd12.prod.outlook.com (2603:10b6:303:22d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Thu, 24 Nov
 2022 17:40:29 +0000
Received: from CO1PEPF00001A5E.namprd05.prod.outlook.com
 (2603:10b6:a03:80:cafe::6) by BYAPR11CA0072.outlook.office365.com
 (2603:10b6:a03:80::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19 via Frontend
 Transport; Thu, 24 Nov 2022 17:40:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1PEPF00001A5E.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.17 via Frontend Transport; Thu, 24 Nov 2022 17:40:29 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 24 Nov
 2022 09:40:22 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 24 Nov 2022 09:40:22 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 24 Nov 2022 09:40:19 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH V1 vfio 01/14] net/mlx5: Introduce ifc bits for pre_copy
Date:   Thu, 24 Nov 2022 19:39:19 +0200
Message-ID: <20221124173932.194654-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221124173932.194654-1-yishaih@nvidia.com>
References: <20221124173932.194654-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A5E:EE_|MW4PR12MB7432:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e0a55f0-583b-4164-df71-08dace42fa94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nzOHNxUIdRFhNYoDk6/n5w/4Pt7XqQnHkR5LmVE9p0g1TET6wPvLXy0PVzlibUtFfr+E3rX/XS06T3vuVPvjuov4yq+FQOd0o2VpS1uMGrRU3XWDmRQiGItliTKTlSoNtHAbJpt6F0T+84bSwAq4otSHMadzgRed9N+6teOdgukVOJCa40o+92/hEzx0Z/tfAdf/HAOF2tCZtsuyyes3rlAx+2tKS5J7QEY10Ko4EHTVseQKmJKoDENtn9Sl3xIphfml+Sr7BhSmfW4inpcMtZ1gF0ww8HE1d10ylJIe/EPpA5qaleBOO5PwGPOrl7QxwfryJMthozP6jt5qaZuOWH+MonnBtgtSYXmd1BNY2lyoG0ZHF6Wx9yuXnzmBwt2A+c/2g1yaSd8t0PEYJtrfj6CxKgG0lK0ZGWT0oLx0H05BowiZM6UNw1CM+ih/Ly/m+D2mSvODU3EDBmKkjJFh6XyhT2B20Uz28GfgDtGNXVgMHtWHU5Kqu6Yr1/8topkRg2a99ZS0qp6tBW/k2yBdYjO6RqykN2ItOBoAUspOicWbAC7jcyiXGftssIajJVHtv2+vhwolAZIxEvmiNU9jKHff7SvWcOkot4HBMESIbOcVVPbQgb7uXJ57fzKaka+mm02ulimtyo7sFVJ6gzEAh/jzdKSvVvO8q88Q8wFrxKUb4FuVD4A+pD+9oxVvoYvpm+f1+UMlu1Y2O1/0L06MLw==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(346002)(136003)(451199015)(46966006)(40470700004)(36840700001)(7696005)(54906003)(478600001)(110136005)(4326008)(70586007)(26005)(8936002)(86362001)(82310400005)(8676002)(40480700001)(70206006)(316002)(41300700001)(6636002)(40460700003)(5660300002)(2906002)(83380400001)(36756003)(7636003)(1076003)(82740400003)(36860700001)(2616005)(47076005)(186003)(336012)(356005)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 17:40:29.2632
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e0a55f0-583b-4164-df71-08dace42fa94
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A5E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7432
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

