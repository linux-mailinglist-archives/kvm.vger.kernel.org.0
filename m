Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A151B68F1E9
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 16:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbjBHPXa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 10:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjBHPX2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 10:23:28 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0EE4609D
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 07:23:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ij6BaBqV0g07E4Nd5MSqt7MfBUqYV9YfGJflICuWe3hdJuH6g3FIZKsRDU9qYGa6Fo2krszUPtp70rNtJJQ3DbmBiSbzbh8bWWJWVqXM1QEr7wvYejRyk28nAP3e5JovnJPkRwuUGfvd9TLYhWRSylXhglsMo6SjVs5Dapnb/DqwS3rCTQnkcbJCqqdw/N+6aYUD+DTWv1+XHbNb+eXyWqfv0MRExY0RoJbEugNIH3l4W3Blqpl9VJaxK5MGzU+ZsJOu160b0InlXkJEGTpgnOom5x9VpE27H3mrfkuNNdlxNfmLqHs5f61/bP3sIO7PLA/tww1k15q1l4DrreVTcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oSoeMQNbuYqkJd6fHFVBVyPf8KUGkbec1C5mf2Lrdwk=;
 b=hVxvCb8vpmZ6YJP1EIogqPDv7te2Mt/GeJSWlCTyRKzmqpR1I1Hl8TPx7pBtBFAkdWQJAW9FanZEa4cMMRjem3F7eMexfXLx8FbQo/k5DXY6KzawdOvyo+oVjKN7CIzR6tYBpHh3/u1XOooijZUJncta5C6hRwXaIwDm9GPzFTRv0aI8Mob6gGo5H/TsBrSP0p2bPOaXsfCgaG7egTbvUOvcmvzn5wFucPONHLXnHh5poZ0ysUrMnDBZuN3xjjTDwocBV1po2i73+CDbEY77Fhq/VXNa8p7lpp9IWNjkxSVBeGR52gPEpz2IYQ8JUGt3u1OCaJxpPrs172CeCQzCMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSoeMQNbuYqkJd6fHFVBVyPf8KUGkbec1C5mf2Lrdwk=;
 b=Xj1Hj2FIO6OdoHbrU2UqD1ywTKLxGGcdbq6IEHBG8bW4CHCl1gokVx40FoGENGB0rv0kJGyVh8cDVrFPpyHam1W9vdc+xhNfxsH1sHs1lbrhy5T7nQGKal44UITDzFT8E0DwLOqDkUIVIlHsrR+TFY7gR467+f+2GUzsTBt7R+dx4F5lPI644bO1dVqjx0jvNfcK+P/aF3kXXO46Diy3C5cD2k6qxqI0LPV7Pa2GbZn8VfaLU/I+0odVgdyPcfxMzDkm+YN3BOxzstucejJcIRDo0U4OYXqXpmXT1d4f5QedBVE0j32YLZA2vEeTl6qYI1Dw/Rf9G9CVr2u8Em7ThQ==
Received: from DS7P222CA0030.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::10) by
 SJ0PR12MB6784.namprd12.prod.outlook.com (2603:10b6:a03:44f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Wed, 8 Feb
 2023 15:23:25 +0000
Received: from DM6NAM11FT081.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2e:cafe::dd) by DS7P222CA0030.outlook.office365.com
 (2603:10b6:8:2e::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36 via Frontend
 Transport; Wed, 8 Feb 2023 15:23:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT081.mail.protection.outlook.com (10.13.172.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.17 via Frontend Transport; Wed, 8 Feb 2023 15:23:24 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 8 Feb 2023
 07:23:16 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 8 Feb 2023 07:23:15 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Wed, 8 Feb 2023 07:23:13 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <avihaih@nvidia.com>
Subject: [PATCH vfio] vfio/mlx5: Fix range size calculation upon tracker creation
Date:   Wed, 8 Feb 2023 17:22:34 +0200
Message-ID: <20230208152234.32370-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT081:EE_|SJ0PR12MB6784:EE_
X-MS-Office365-Filtering-Correlation-Id: f3cbdb02-8be5-4a1f-866b-08db09e86be9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vyl+hfKjhtI+ZlZquiB/gC+bAz0mYTPJIwSqIBbJv2kYKKTYGa+s/G/344FlAzS7gVYOuXFjPn3jwTiPK/OEPShHS565T5bjWRv50t1ljGhIEQz3GE3pCT4pbq9F+6vwhy17M3tLNZYY+D2Q/4MxLFBVKp/+FO68/PEKzIEXcLTFfDbWHqRMDhk50A28zmznQYUPQ3lbh28ryyEsIgE+jgTvHjrUWaqhhFOK6J4FNWbkwh65hu9PigALE/xu5dbduiA03JypCD/8cIcwgeFTRcfJOkiCfh0qIlqdgfug2rIZ67//7zDTKYd7CSdTH81v4hjOx8dJOZ6t8boOHEbhXpuHViPX26KXT1yreSC3bmuqtZvmKtUuHikc3C2Sd6hoSNLJULKksHZga7nUjNsobjxT5hPF0c0y0uCGdI3xdBfR/junIM6klepY5FxmRnz8LRnodNnk0ocNZOORl+7l8IFpS8jqVLYVLydhrdfxg3C/dEElIQmiQ6mAqCJYz1xMFZNKEAwUVF2KEbQkqCjpL+ZifsxrH52mNrs/oiq0eAEn0qCxh0qsELwJ6PENdGizOtBoAYCrkuwHad9bLltteI1edNTj0RIfnv+NEUwzjW4/QYQzzxRXEwCF3i3yE+jvpNyAvt450J37ORfy8An/8i9wt06vT+gl+DUkL7QYibpDgXoXcPuQKZC9ItsAurWQsZJit5QFKJCZTnUeeuFJ9g==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(376002)(39860400002)(136003)(451199018)(36840700001)(40470700004)(46966006)(82310400005)(54906003)(6636002)(1076003)(8676002)(316002)(110136005)(356005)(186003)(86362001)(7636003)(6666004)(107886003)(7696005)(82740400003)(26005)(478600001)(40480700001)(336012)(426003)(8936002)(41300700001)(40460700003)(83380400001)(47076005)(5660300002)(36756003)(4326008)(2616005)(70586007)(36860700001)(70206006)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 15:23:24.9180
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3cbdb02-8be5-4a1f-866b-08db09e86be9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT081.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6784
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix range size calculation to include the last byte of each range.

In addition, log round up the length of the total ranges to be stricter.

Fixes: c1d050b0d169 ("vfio/mlx5: Create and destroy page tracker object")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 5161d845c478..deed156e6165 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -830,7 +830,7 @@ static int mlx5vf_create_tracker(struct mlx5_core_dev *mdev,
 	node = interval_tree_iter_first(ranges, 0, ULONG_MAX);
 	for (i = 0; i < num_ranges; i++) {
 		void *addr_range_i_base = range_list_ptr + record_size * i;
-		unsigned long length = node->last - node->start;
+		unsigned long length = node->last - node->start + 1;
 
 		MLX5_SET64(page_track_range, addr_range_i_base, start_address,
 			   node->start);
@@ -840,7 +840,7 @@ static int mlx5vf_create_tracker(struct mlx5_core_dev *mdev,
 	}
 
 	WARN_ON(node);
-	log_addr_space_size = ilog2(total_ranges_len);
+	log_addr_space_size = ilog2(roundup_pow_of_two(total_ranges_len));
 	if (log_addr_space_size <
 	    (MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_min_addr_space)) ||
 	    log_addr_space_size >
-- 
2.18.1

