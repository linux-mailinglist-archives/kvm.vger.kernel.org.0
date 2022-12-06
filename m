Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A17F643EC5
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 09:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbiLFIgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 03:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233724AbiLFIfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 03:35:47 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613C5B871
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 00:35:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MdjJO5a92+E3J7GSwL1866+M4BpuP1bWGbgAg8uJQ7i8Kg5km9JJsdoAQ0S8r0ot55/pYZKD2OWo+EfH3D1VHGclktT8y46AMmXmqOxIr51KLe1ebb8fwRkxln/1ZeZ6oquEiGWNiyOGKz9HhjIbZV/FJIWHSWYjfl71cNuHl80BiFy3V0zOUk75X99lqRLfDoxBIAqrKDkPBDPdKk+2rVBVXQJoPiwPfKCy3iqPZ1qsqHM0XWyBA0zsJR6d7UNwLUNMeyppXMAxPxmKah8k73/a790E5AplnaxxU16Zw5vmtbJuGsx9xLy+PsZYPbmaLhIzmLqkC+eV3SHxRmwQ7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/FbcIkA8BAspvDPMvyemsuCn6rLSFyyIu7/8eympMg=;
 b=XO1ifyOsUskdSegW8x9vVb0GWq4Gzl3NakPQWzAWU1aQV0j52dI/qv2WmTC3OYJX2k+BH77HuSxUq3FUT4JIhi2gDGQzemzJOtkKyaFsAATHHtGAJuTnrYnvAueO8r2xwx9ZyR3aqJ9iZidqUjAuj8mCXo+1Y7lTp3H0tq8ksVjjGcKuEKTqqx3R2tMvlSQOWZ81l4veAIyaLaCzI5HynDqb/m1L/toTqGXyUmuv7ha9P2H4DidXy5BItaeiFd5aSk9h7b5IaEAOEaNfzNv4ZO8mZCM1rYyKuCbi3Cnw/0zfLhQClJP+Efau8X7ryDdjodDGhD1kkWOTnlM1ZB8gLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/FbcIkA8BAspvDPMvyemsuCn6rLSFyyIu7/8eympMg=;
 b=hgGb375idDBhxZHXA7sc9Z6e7Sd3WnCJPDQhP+xTe/2lGnsJHyvuC/zcMm0FR4oicQ3/mMUpc8Mm++O/zmytAUQmyq68X9hDHe8+BPZtHKnzVQaa80DG30aoWWj08GHkL76WlsMKgDOX3rIzvlzpRfdTllF6+fGIgyYrCxPOhhMFoUC0DjsY55ZmwuO0/2WUuR9n9+gUDb14RUC5M1pSkdNA9wCM1Ybldjmtu80b6pghl4riRY3HspFpVF/+4DnEY3y0IGYeHFOHRmRuxfzDHK1P+DeKzM5vNxU2ezzs/017XgMa33vKzrspEtDUnF9eloqZaApn1g4PktkLwULKmA==
Received: from DS7PR03CA0031.namprd03.prod.outlook.com (2603:10b6:5:3b5::6) by
 MN2PR12MB4502.namprd12.prod.outlook.com (2603:10b6:208:263::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 08:35:25 +0000
Received: from DS1PEPF0000E64F.namprd02.prod.outlook.com
 (2603:10b6:5:3b5:cafe::2c) by DS7PR03CA0031.outlook.office365.com
 (2603:10b6:5:3b5::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Tue, 6 Dec 2022 08:35:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS1PEPF0000E64F.mail.protection.outlook.com (10.167.18.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Tue, 6 Dec 2022 08:35:25 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 6 Dec 2022
 00:35:15 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 6 Dec 2022 00:35:15 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 6 Dec 2022 00:35:12 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V4 vfio 01/14] net/mlx5: Introduce ifc bits for pre_copy
Date:   Tue, 6 Dec 2022 10:34:25 +0200
Message-ID: <20221206083438.37807-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221206083438.37807-1-yishaih@nvidia.com>
References: <20221206083438.37807-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E64F:EE_|MN2PR12MB4502:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c4f1b85-f838-4419-e7b2-08dad764d2bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A/Y894Z6jHeXr/3uqm3SaG1YbR4B8tFHTrAu/L2NnNfubb0P6bNuq/AVu7qZe8OVKJfZToh4IWLkaBh1uHEDNKtfyn/71mMDPcPqwqIAg/rpJoB2jj4yLLMqrGqCjUaNtdOwtjaJP4nvdeJQ+VTO4iOyAHmTWIL5oePWgtZON4XtDtW5ifd4RabNE7k+30tCoKAXXtC7VM3OygzO5LYYpCNX2nFHTabwzKZjXZ9lN9CIlm6NQwV2uCE5Jn8clfvKuAC2R7SmUNuNgixguZhqZXCPuKA+S0Olp+GLhS7gIQdzbdasmK2a5aspPG1EjVXFrQ8aAO1iUELuGrEOTTMaTkV9yX2+FschwIRC+x5K9ClqkopRT33FHfTHpa5SeXwUMJ1eU6WM9GREQ88VtFv1ILmODgqDFq18bSaof2+YIhsqu4aPwPZ8Qs97bIHW9YIQftGjrw1kF2GLyTRpZtfjafj5E0Y/qqybhj7Cxxx2SQa3ptx426SabUiJEx33qgjH6PzSiXkz6xl4Ne6GtnTcSitnbM/SIlkjkQDT7rHNG7v7UGxthvNE/2KPZ+2bcc0ILrb3W9t16FXTjOWBACoLDYI4XXPWV9Hro9yIAqdwYgKB3he+XS1LH7/AnpV9GDKJnq5ZEGeAsbPFN6FSILfz9S972dBjQ5hzjrybLogF4SR1iiQJ5SvfX5W5ES7UCWFryDAk1k86lr0sf6u8kBW65g==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(376002)(39860400002)(451199015)(36840700001)(46966006)(40470700004)(40480700001)(7696005)(4326008)(6636002)(110136005)(54906003)(316002)(70586007)(86362001)(26005)(70206006)(8676002)(356005)(1076003)(2906002)(7636003)(41300700001)(336012)(2616005)(186003)(36860700001)(426003)(8936002)(47076005)(478600001)(82740400003)(6666004)(82310400005)(83380400001)(5660300002)(36756003)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 08:35:25.7080
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c4f1b85-f838-4419-e7b2-08dad764d2bc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E64F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4502
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
Acked-by: Leon Romanovsky <leonro@nvidia.com>
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

