Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F71E61E502
	for <lists+kvm@lfdr.de>; Sun,  6 Nov 2022 18:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbiKFRrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Nov 2022 12:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbiKFRrV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Nov 2022 12:47:21 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDA864CB
        for <kvm@vger.kernel.org>; Sun,  6 Nov 2022 09:47:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mvhlMfK4zMqM3oYDdoOXAcZoi9VZ8LSyg9ze9PbCig5UoV/nqhq2ymIApFhGebIoZ3Qhhu2GgWoSfb7n9/ja5xH2a+aMhYp/Qi4fcnyFQcbH75morJv0YnDyeoHW5zdulKspD75dIL03B8mX6xKxwSRts0Ca3he07ZEV1ZOj/E+7xWtozeQ4BKwHwfVpz8867IOG5+koadB+lKM24CCLTBxhplmWlTEoR8OmbVwWO+Z6ay7mSuOhyb7G5EbWisyoYFldeKc6eM0c6PERYyeBfakeJg60MOcINScgJObdyHI7QaMDAvJJ/9DBp96VDdzGi+NUcaFeTjvQYP6k6t70fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7TfSCc1q+xE5ZW97VX5TpUrgcJbu476irAj8lTMNRGQ=;
 b=GcJicjRAYfIbYF/G8MK8oEULv6VHGCjSUu0ljUp4mCaiiXHdk76wc6RAMcXBeEuAb/8yoGsC2gp47hgTYexSE2vcMvxteQ3bUNdGlBXbV5YnSTOPL1R/Uh2ox3hPmHyfwiOPIZwZrmGa9zwLUjD7UTifAPPl/mwklVFXbTxBvIDyU8MukVCMghRMeGPd8gdw4wKxrQOhuTqcIeRjzyJGe2kKFFjFglUrpGKEbXWfjcRMa2dziH/sooU6CDEWvAMDSpyrLKdpEEgKbMUckXhnF6anFAO9TDkp7uqE4chhfrhKwf8DzT34V3bw0ALqINy+Q/Wo+FNByyIhIsomBQjl2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7TfSCc1q+xE5ZW97VX5TpUrgcJbu476irAj8lTMNRGQ=;
 b=T74hMBzBW81rTnAiXK84C9vDIMoRYhp3gBsrgANMMybJWd6YbmMPPva6bzluTfyOEMQU8h25AvciMMZnc1I8G22lVS5fmKPo0gUIlyy42GFjq10a4ps9eBFxKf58Il42Wy1lO7iOiPn+uQxytU3cI9X75aQRLUvCH4Y0+3+KOmhrE0whWIlMTYDTsCOPh0FDhTa65/Z5BvNMcK3fp/qZ6RUzcclZkhNg+FEMP11DEarmB4IErM28YP+SOvVUenPAh4NAv7EvM9kpDjNBmrTtNm2Z2CJR68U11UiDajo1RLusONvBfWa+F368RKdYCJ54HoP0RwGjqJW7Mwzm+oIzWQ==
Received: from DM5PR07CA0085.namprd07.prod.outlook.com (2603:10b6:4:ae::14) by
 BL1PR12MB5061.namprd12.prod.outlook.com (2603:10b6:208:310::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Sun, 6 Nov
 2022 17:47:17 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::f3) by DM5PR07CA0085.outlook.office365.com
 (2603:10b6:4:ae::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22 via Frontend
 Transport; Sun, 6 Nov 2022 17:47:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Sun, 6 Nov 2022 17:47:16 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 6 Nov 2022
 09:47:16 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Sun, 6 Nov 2022 09:47:15 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Sun, 6 Nov 2022 09:47:13 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH vfio 03/13] net/mlx5: Introduce ifc bits for pre_copy
Date:   Sun, 6 Nov 2022 19:46:20 +0200
Message-ID: <20221106174630.25909-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221106174630.25909-1-yishaih@nvidia.com>
References: <20221106174630.25909-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT010:EE_|BL1PR12MB5061:EE_
X-MS-Office365-Filtering-Correlation-Id: d9221c6b-2752-4850-c9a0-08dac01ef21f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uf9lbB6rRgjEPE1FjZVB8ReAyZP2SZAcl6Os4SpfrIjEENAnF92SlM9LuJ3wTc8AZgTqojwvIDP6RG+Vfya1NTk0cTY6sVpmVtYEqm/GNmOM6bZsZdyzyncjbZ6AKYEt3l+pU1eitoCyqD5rU8lX9jkOsICdvSrSjHVJa8IsE+n0LN83cqWJeIzYZx760goelSBEXis50sAEsGnE4cXt5gnxAm2GUJB90Z1k1aqcBAMYG5lQQY/9X+wSs68cPDPXPI8wpe/8/ofnYs6MEfMlYguYS4JyY7Ncc7tuAHXaBJMhfAWwJlm4Y91gY6FFav/CXdhlpKasnA6KwDfGDBkPWn+r/H2XaxrTDfhbsH7sjb1iTPtYIyYAZTQLOGyjRspAfyB4z625eE2Lu7MqNLQUCEfy5XZhtwfnpD4GsuXjuDRRpagbdPiZlc5sgFLI8F2UpodeVycbvCScJSwi0TyBdIrd4AHokGXQoxfLUmpQWpy8+zQ6AFi1BGaTvQQ6RWr9Ir3szFLf1reuHFwKrv48eYK9/5zZvgc8psJrtMxPkiGMqyQzFtzC1FzFrC95SczPwQVSngRCP7PY6rgF26Y8UDPeR2k1fwQkCi3gVaTWJ6JdwbfCuALaOmUkLyixbmpKpnor6DPZzitB/o+Rkes4YrtxxcOQkmOMeYeZnXRlJcmN0O3SjrYcUsAklXR+hAljwHnBqYXZGrWzDW7llvKhC0wc6Y/s9KI8RW8irxE2LR7VmApr5WbFhNLwXKHAJ6quR01KsXQQvsmwKbskokk2Yw==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(376002)(136003)(396003)(451199015)(46966006)(36840700001)(40470700004)(86362001)(5660300002)(36756003)(41300700001)(2906002)(8936002)(82310400005)(6666004)(478600001)(4326008)(6636002)(70206006)(8676002)(26005)(70586007)(316002)(110136005)(54906003)(7696005)(356005)(7636003)(40480700001)(186003)(336012)(1076003)(36860700001)(2616005)(426003)(83380400001)(47076005)(40460700003)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 17:47:16.8505
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9221c6b-2752-4850-c9a0-08dac01ef21f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5061
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

Introduce ifc related stuff to enable PRE_COPY of VF during migration.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 06eab92b9fb3..9e35b657866c 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1831,7 +1831,12 @@ struct mlx5_ifc_cmd_hca_cap_2_bits {
 	u8	   max_reformat_remove_size[0x8];
 	u8	   max_reformat_remove_offset[0x8];
 
-	u8	   reserved_at_c0[0x160];
+	u8	   reserved_at_c0[0x8];
+	u8	   migration_multi_load[0x1];
+	u8	   migration_tracking_state[0x1];
+	u8	   reserved_at_ca[0x16];
+
+	u8         reserved_at_e0[0x140];
 
 	u8	   reserved_at_220[0x1];
 	u8	   sw_vhca_id_valid[0x1];
@@ -11744,7 +11749,8 @@ struct mlx5_ifc_query_vhca_migration_state_in_bits {
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
 
-	u8         reserved_at_40[0x10];
+	u8         incremental[0x1];
+	u8         reserved_at_41[0xf];
 	u8         vhca_id[0x10];
 
 	u8         reserved_at_60[0x20];
@@ -11770,7 +11776,9 @@ struct mlx5_ifc_save_vhca_state_in_bits {
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

