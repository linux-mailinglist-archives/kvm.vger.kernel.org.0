Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AEF7642AA7
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 15:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiLEOtU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 09:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbiLEOtR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 09:49:17 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2067.outbound.protection.outlook.com [40.107.96.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3141B7A1
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 06:49:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHfB3p1E04QqSVvHet2kE4kFlLj8LfWqugNDFfp2VEn8IX083rGSKPX1pCQlVDSLeS4s4NxpZLKt8qvlaOVpXPjR6JW2WLNrwe5XmLy0K32AaluwS35W4Ca/7eGzWEhuLkXyUQI38I3vSeU0L8odsO7pkWVY0Ipf+rnQzzhCJ+LpVcPx86uLGpXFC2wpGPVhgwmZa5xmmP+ExAt1IIBnCtTvj8qDJ2bXMEHY0QVU0cIWlcJd28fsn02DA5Z7nNaGW4r9JwAWCWFhAQ0vKmSWGE5Kt8uDOcqff9xb0NPoDVktnnx4953ikwNMZhnyMU9uHM3sEQrTT+6MCAB6adJlQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=atS9WtVhHIUg8aIzy0neojIfiBRjVu88h+ixljUF16s=;
 b=bXyhI0YSlPlJsu6Z7Z1KaBtNrbstqq7ie9eCqmuGCTQ3TIh0CViC+TRPp9kP8Yeut9fhyCofQh5bHOtFEp+MSH0AAQ3kxOqYgfhbhYyVxsIL/taAxwmk06vfiop5kafcNFoSMWIgqJkoBW5877fQ8epEz7TXS4d69XdJ7PSYI1SyCeo30ZdwkYQtw1kdI/vC3HQFDxOHeEgHiFC5Zo8oR4Q9oS9uhky9SUM2v+u3rsWsocmjXS0jKKKVfup26155qc0I6iwXnN1XDWr+B2ZjTrlCljl+KzMzYyRiI8zjql1tWv1Geb+vRfUGw5yWp6LU8caPs+0plPxaqCNlgpDEPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=atS9WtVhHIUg8aIzy0neojIfiBRjVu88h+ixljUF16s=;
 b=Ky5qb1rBCrOqEY765KKFIN0rqnv2wy5QwlvDz7RfWLDfXFZnosVZRrOzwwMj/GNu5vkFH1MFGtAWLOSQ8ZHyIZ0z4elU64Z6Z7bcIXnosy+WCK6gy9Uyzi34Vdiq9UH9AX2SsjO551VnY1bt9rJZHEjsFxGj5WUioA9m6TijTdBadRJwhe5UEpUkw3krtS343iZL8qHY9+qObVr++RoDrEhqwqomrnTaF7BdFRrT6AI09VckKlSXZ9EoXuF+ThHHgAyqOKF4/RaSsAEDQ6YnbRQ0QgZLln2tYLheHtef0314nIK40EjQ1+78z0Rh1pCsOx42GQRYz37depLnddYA5A==
Received: from CY5PR13CA0046.namprd13.prod.outlook.com (2603:10b6:930:11::30)
 by CY5PR12MB6252.namprd12.prod.outlook.com (2603:10b6:930:20::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 14:49:15 +0000
Received: from CY4PEPF0000B8EA.namprd05.prod.outlook.com
 (2603:10b6:930:11:cafe::b7) by CY5PR13CA0046.outlook.office365.com
 (2603:10b6:930:11::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.8 via Frontend
 Transport; Mon, 5 Dec 2022 14:49:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000B8EA.mail.protection.outlook.com (10.167.241.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.11 via Frontend Transport; Mon, 5 Dec 2022 14:49:14 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 06:49:06 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 06:49:06 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Mon, 5 Dec
 2022 06:49:03 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V3 vfio 01/14] net/mlx5: Introduce ifc bits for pre_copy
Date:   Mon, 5 Dec 2022 16:48:25 +0200
Message-ID: <20221205144838.245287-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221205144838.245287-1-yishaih@nvidia.com>
References: <20221205144838.245287-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EA:EE_|CY5PR12MB6252:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d2fe2fe-9a76-43d7-18f1-08dad6cfe138
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mEYU3KvEj0/9vsrQg/swwwOZDb9oz13gRdwb+xrOoitu2mqsb0ITJsqinPJ6+b+GiWphV5rHRtcATQBuN4JIvCoMUg70RiDbPcWiKVGjHO011aKr774TWecTlEkJaz0VjMZ7W730rebhJ1BGhjQrQRt8Za4RH2VgedyGVuhOUvZAuCUHlt8fZFoW0dPpTiE+o/p/y0d7axcH95i75g3jr/7AHWzx37EClOZ9gTiI4mhpCoFdjy7tcqnDYejN85tSJFGvOTsk0CU7AlPRhZ5CiLWtf4V9McYs9A8WRatkSixzqVG0zz8UQGwU33ZroQAVBr+ehW7ljdsKpT1BR75Toh82MxRKlH7ymCSmrbv9Z5kUKkNNaaY8AVJH58fyy1i+jDAiGPpjHoKjN7km2KM/C3HR/ayh10xVmkr3OGdQbE9yyHQV+zcAli3NZBLZilEFLUbvLtNLYWZWDR8DG9yn/R96wwoQ7ut7RvSvvw6Mkl4sTRWdi49RkEgwqlHQruKL0HFgSaUnFQ597jdj2Nl3TbqvH0h4jJV9rq66e3D2RQlfnNl87NCfP8Dc/QUdvoNs0z46JoNDzm5bjGbD0pbPrm0nd2xQl3+dbclFPN/Sf6YrekbbgDZN+o/8jLvsbcYPWFwbileWlUAynZ5QUDJfeGJYycRl1rlC6RlMVcvHzC0r8U7c1zWHsRAsbw2eTpJ14Y1ubWfYynvg079ABnKU3w==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(346002)(136003)(451199015)(40470700004)(36840700001)(46966006)(83380400001)(36860700001)(356005)(86362001)(7636003)(82740400003)(5660300002)(41300700001)(8936002)(2906002)(4326008)(40460700003)(82310400005)(8676002)(40480700001)(186003)(26005)(7696005)(6666004)(336012)(47076005)(426003)(1076003)(54906003)(316002)(110136005)(6636002)(2616005)(70586007)(478600001)(70206006)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 14:49:14.9908
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d2fe2fe-9a76-43d7-18f1-08dad6cfe138
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6252
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

