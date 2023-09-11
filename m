Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0AA79BDEB
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbjIKUuB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235817AbjIKJkE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 05:40:04 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1A0EE
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 02:39:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iByYBnnBydzeecGLpvAQZIXqw5kdUaan/liVwdVAGBssvuQSktRMaqeABOVw+LwBfhKUro3KJHrAzo4nHXnBWoVnFLFfj8T7x1HrEAUdAu360rgBjO1Gn1dMgXGTNuWoU/X/Xl8Gz3oB9PMFAyIQ7LuKq+5PLwHGN6ouk/CCNsnKhC14kdkHNB3YOTwY2JncuuwYPk/COd4SbUCEzCbf0kQHiEmKPvvZSb1EEWO5FhP+JVe7ZbLt6BT7czN3TEYUbgGDgA1JDTRE+fMjW6s116KjHQtfmG5kPuirpfXZPhIjhyh+n2jZlJWoZFRBsWJCswjWyub8as5JtI3YSgWkSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sQVQ+bCXXCtXoD2Ad+Bb3eAnuZYGGwwVcldZOvmPK68=;
 b=EUAj9x70Oj4RFixgZQPdazvXrCu1ysefL3pdyNL3CbZi2RXYpiYN2WQnoBN/d6pEQhFy6qV8HYD5us6P1Y0aUemloartxbrTDMZ0X74deq2JE5jjK+bkYJJO1RSOog6Ag/f7lRxH6O4e7AQBCJLMAMaPvqir5uaOs5xjgITeVowm9foBvHqrqSzHXllQeY4xrkd5T+z+gU/OpDdRg2fh8pRAUTSy86tjvFg46wwdnKBzxpzDm3jpnB13Wgw9ddckpmrpPipm3HSnuB1WpyhDjBQEU5X7X0nW9LnTKJdCoTvDg1do38A1Nr5/axO5JCEZobpjrZ1mJJNP3dU0rJjmoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQVQ+bCXXCtXoD2Ad+Bb3eAnuZYGGwwVcldZOvmPK68=;
 b=LSUFpb45TbFuEeYH2okOZpUXQTvLxqUhqikrv8kZvsy3iU4AOsAWRF+D09vuXbeghiGPNsLZpUZ4CJASM2o0NBkPMNrV/yPy1hS5fZDnLv+OfJxL7wsYqnmxafJvKjxb3HwK8Iuoiz4O48fENKWce2/bROs9S2dgpvHexHS2LtXVu0CdAJ2iHsZaN4VJXl5Qz2GQNgm4h0piLDsXvwVPu/cixdQpAWFPlWbh2tRjZeq6grsEwRJjBprjLhlBotQhJEuT2Bzd00B6YTQ9rVpJmgrbkgE5afMoT0MVj75/XuvzzxqRCMuoTERvWUk7UsgeavXNcNRAqgfMXSZYy1bhFg==
Received: from CY5PR15CA0256.namprd15.prod.outlook.com (2603:10b6:930:66::27)
 by SN7PR12MB7449.namprd12.prod.outlook.com (2603:10b6:806:299::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.30; Mon, 11 Sep
 2023 09:39:56 +0000
Received: from CY4PEPF0000FCC5.namprd03.prod.outlook.com
 (2603:10b6:930:66:cafe::30) by CY5PR15CA0256.outlook.office365.com
 (2603:10b6:930:66::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.41 via Frontend
 Transport; Mon, 11 Sep 2023 09:39:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000FCC5.mail.protection.outlook.com (10.167.242.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.17 via Frontend Transport; Mon, 11 Sep 2023 09:39:56 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 11 Sep 2023
 02:39:45 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 11 Sep
 2023 02:39:44 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 11 Sep
 2023 02:39:42 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH vfio 1/9] net/mlx5: Introduce ifc bits for migration in a chunk mode
Date:   Mon, 11 Sep 2023 12:38:48 +0300
Message-ID: <20230911093856.81910-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230911093856.81910-1-yishaih@nvidia.com>
References: <20230911093856.81910-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC5:EE_|SN7PR12MB7449:EE_
X-MS-Office365-Filtering-Correlation-Id: 32d3839c-a229-4451-24d1-08dbb2ab0f2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sV+VXZNsUisAqgpMEu2G+NyNtsKlBVpHMXotfjrHnez86tRWdJtWe9MERYwhnXkqvkH25+Rz1FohJsVaIlGalflk8Q2TrD7n3V94eatFXfsSQukIVIPsRSjcnHiurNZ8R999bw+JIKN1sWp2tFdQnJHTeH8lyoOo7SEx8wOg2XWckTpDI94OJS5AloidJdE3dvGJSmqMsRMj/iEZlJuRxe+EebQ898viaSXIvgcCaI31GV4WN+s64buMywbhN9AJK/p3tlDLj7lY24U/tLwas9euNbQSZ8agxs/ZQ2S9I0yaW2oBHawwe/p2igKDF35tWQezenCQdxLOjeyv7nTQ+9fj96vxUfajavVCdORDLBN0XUrnbAuDXM/LM9rgIrWsyN6Tbgc0Ww1VaadoZjEOzmePSaYBlXsG/bwdalfabGJjAP2fjW0hVR6V8vrArKex2fqM/zlY8w8eVc44k8FSiyiN0f2jUsH2n5ptq3K9gKIqFu2O2ji5nv3OkoKk9yIC7lk4mpWg9EggW2ztlhGHXjKbOn+rDZ+YYX+/heDPmez78TeE9tNWGY243x5v/b04/jD2haCrl27OdwbNqCemxenmklQpe7sKKTXdHAWDyHkSJ6Oq2i3yyUM0EUdkqFBOQcVT1Cov2kisZqzahFYFPugBR2LCtmUiZMd/YeRngt+HRVCPtiRXwN8HmXoKYcpO/QALb1yLD6zL16J0wCJ5s27AmS78dP1joPJ2HhBM0BpARe5bWmlb/7v1z6iHKBqT
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(346002)(136003)(376002)(82310400011)(451199024)(1800799009)(186009)(40470700004)(36840700001)(46966006)(83380400001)(110136005)(2906002)(426003)(1076003)(336012)(107886003)(2616005)(26005)(478600001)(70586007)(316002)(70206006)(54906003)(8676002)(7696005)(8936002)(5660300002)(36756003)(86362001)(40460700003)(356005)(47076005)(7636003)(82740400003)(41300700001)(36860700001)(40480700001)(6636002)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2023 09:39:56.5066
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32d3839c-a229-4451-24d1-08dbb2ab0f2a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000FCC5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7449
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce ifc related stuff to enable migration in a chunk mode.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index fc3db401f8a2..3265bfcb3156 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1948,7 +1948,9 @@ struct mlx5_ifc_cmd_hca_cap_2_bits {
 	u8	   reserved_at_c0[0x8];
 	u8	   migration_multi_load[0x1];
 	u8	   migration_tracking_state[0x1];
-	u8	   reserved_at_ca[0x16];
+	u8	   reserved_at_ca[0x6];
+	u8	   migration_in_chunks[0x1];
+	u8	   reserved_at_d1[0xf];
 
 	u8	   reserved_at_e0[0xc0];
 
@@ -12392,7 +12394,8 @@ struct mlx5_ifc_query_vhca_migration_state_in_bits {
 	u8         op_mod[0x10];
 
 	u8         incremental[0x1];
-	u8         reserved_at_41[0xf];
+	u8         chunk[0x1];
+	u8         reserved_at_42[0xe];
 	u8         vhca_id[0x10];
 
 	u8         reserved_at_60[0x20];
@@ -12408,7 +12411,11 @@ struct mlx5_ifc_query_vhca_migration_state_out_bits {
 
 	u8         required_umem_size[0x20];
 
-	u8         reserved_at_a0[0x160];
+	u8         reserved_at_a0[0x20];
+
+	u8         remaining_total_size[0x40];
+
+	u8         reserved_at_100[0x100];
 };
 
 struct mlx5_ifc_save_vhca_state_in_bits {
@@ -12440,7 +12447,7 @@ struct mlx5_ifc_save_vhca_state_out_bits {
 
 	u8         actual_image_size[0x20];
 
-	u8         reserved_at_60[0x20];
+	u8         next_required_umem_size[0x20];
 };
 
 struct mlx5_ifc_load_vhca_state_in_bits {
-- 
2.18.1

