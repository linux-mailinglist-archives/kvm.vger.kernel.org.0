Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A6F53E776
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 19:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbiFFI5W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 04:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbiFFI5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 04:57:20 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2083.outbound.protection.outlook.com [40.107.223.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EFD5FEC
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 01:57:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RRW/CNX/+RD9FjAatRo5zj5xroZAdyzUJ1tKVISR1osbFG5G3Dh4E+xlRMHltG27iAawPlj6oSGU6mEp3+uh0VfVMps2wnQAbuZTWeLAn0kxbx/dH7k/1nF+M7FEq0/7gU9CK0z/AQDO/4W4VM69fNAKTMRM6YbFtGduAuAF7LbJ9j8Xftig8ql2gWhDHlxDTOiny2VA7usOxHjY6f98Ai6TvYRzxA29VcEL9X7zfphe5IkWKa7PBvtjlVgzjebHl3xxhRPRZwNLAQOcJf4w9oy4yfvHIV+pTgagFzUxqlq0xEAfHykMyGyCHK6KEweWot6QEVkXPkkXFI8r72HenA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8FemQgNFiS1SXcKH1hsWr8XT4woDl/2l8p2P1d/kHzc=;
 b=N6eslxJOzl0HVwYqX42HjezEg78bvlh8aOoDl8ksHxuCVuOHtlbayZyUDxW04iX+t/0XHXNCNaqeO8+es0UaFKvGT1+APsijOwvwXnID+AKjKjW91glisXaMEMF4NEDScYWycczZQiOS5GTIR8LJ+8yoRZUwrmtC0g/xL1L7f35NXQm344gerIZjdFN0drO2s5vuaK7HQtCs685W51jImIV/oNAd3Wbym/wCm/6wGExvqsT65qxCTbq9GDrIxHMCabqjqtfikOgornEXG5L7kUtT2TKv1TOQf1427wgifUB/Wc+pLFlgBONP6gI/aBQTzLd1vpgeqcILePgc/L5phQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8FemQgNFiS1SXcKH1hsWr8XT4woDl/2l8p2P1d/kHzc=;
 b=Cgz4+gqVB8TTzlAnPZSmK/vxg1xX5ZlocNuVgjp4xWCCwF7TbF8YF34j7uUDre/9ZvUygrj8j80a1jgzHxk5H5kcat6c/v6HPUQBq6GespDQYFzSsFFVWhAIKFOT03LRFxaVCN+Pf9agibhg2fP2gUeoRsvRtZXAmQ4gThcl7gSAjAxudOMp1i0VOGl8NlNVySAfyt3tfiXAO4QnQmS5+Nw/1bHxhM/EBFwmOSewh1KAuG+FBHStESdyk+JjuNkp/nTFTqveaO33X5DcUjEkcpUif1+eK8IYqfbuavR6TwkmceeWdLWaPwOdqc0r5X8AgmZlbNgSOR9+jFWfWP6P9g==
Received: from BN9PR03CA0119.namprd03.prod.outlook.com (2603:10b6:408:fd::34)
 by DM5PR12MB1721.namprd12.prod.outlook.com (2603:10b6:3:10d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Mon, 6 Jun
 2022 08:57:16 +0000
Received: from BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::d4) by BN9PR03CA0119.outlook.office365.com
 (2603:10b6:408:fd::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.18 via Frontend
 Transport; Mon, 6 Jun 2022 08:57:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT021.mail.protection.outlook.com (10.13.177.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5314.12 via Frontend Transport; Mon, 6 Jun 2022 08:57:15 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 6 Jun
 2022 08:57:13 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 6 Jun 2022
 01:57:13 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Mon, 6 Jun
 2022 01:57:10 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kvm@vger.kernel.org>
CC:     <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <kevin.tian@intel.com>, <shameerali.kolothum.thodi@huawei.com>,
        <liulongfang@huawei.com>
Subject: [PATCH vfio 0/2] Migration few enhancements 
Date:   Mon, 6 Jun 2022 11:56:17 +0300
Message-ID: <20220606085619.7757-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cdc3983f-10af-49ee-54df-08da479a8dfe
X-MS-TrafficTypeDiagnostic: DM5PR12MB1721:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1721298B5C9B2D602469E1C1C3A29@DM5PR12MB1721.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H2NTDLqssQbRAk4TKucLwpvOw0nX56ZEaH1gWenvSTUsNiEQG9VGC5U1AOFK6Uie0yxlM3nLJwvsCZXARkgZK9W0VH4gKGdagMbxLHv+TTBNM6yEa7//AOgAPa7/teiHD0yqMMek5u6SKFzEm9V7cl4gn5kLntuHIOznOBjowlY6up4dRSqPGEjOfC5XuuZM0u3n78gL1F0Muz543JeUPXtBvbAYq0MQPxX7crSLhhBf49PrDW+PqGWCXbbOdOsjJhNafpmtIev2yIgknrnNWO01YYq5HvKzvpqxM8tk4QLxA3V4yjoMciWFZ2poKkYq8SLzZ1YjeNMFXlW4Luy1IKOAvAe43F3HVOU0n5Fal1es2juWMP81g1bRWbTiyeQYeOAlhO5flcY/OJvewO8twCQ01yVSPvZQVCbNIa0rJPE/bmtNtfAjL6L+ew+PIf9UYGlkdw3oGXvcJ3etm2yt4EOkCGMcAHsDFeh9Wh9blpdWYJ9gX7r+FSJzSMec0Q9/CmJm4sKmwf40kbfAdeB3srp19pexIDsurJHA3sFRZx0VoP28BuBEnsiJGN7HTQdxYAfjpnn75M1sh/vEQHHEhYhbU+B5PnZ3716Iv/Qh/VgwzTNSP6wHvhlnzC2egZ1XBVqnLt/lsg3WJ1/ul7OsvpU3MxigRKciT7gYo59kRzWQ+nAKlJ+P1ld5oNO9NNiVjp6USMR1w1WV+b/xzjPLUg==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(356005)(26005)(2906002)(54906003)(81166007)(4743002)(7696005)(316002)(36756003)(36860700001)(86362001)(83380400001)(47076005)(336012)(82310400005)(2616005)(4326008)(110136005)(8676002)(1076003)(70206006)(70586007)(5660300002)(508600001)(186003)(8936002)(40460700003)(426003)(66574015)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 08:57:15.7418
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc3983f-10af-49ee-54df-08da479a8dfe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1721
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series includes few enhancements in the migration area and some
fixes in mlx5 driver as of below.

It splits migration ops from the main device ops, this enables a driver
to safely set its migration's ops only when migration is supported and
leave the other code around (e.g., core, driver) clean.

Registering different structs based on the device capabilities might
start to hit combinatorial explosion when we'll introduce ops for dirty
logging that may be optional too.

As part of that, adapt mlx5 to this scheme and fix some issues around
its migration capable usage.

Yishai Hadas (2):
  vfio/mlx5: Protect mlx5vf_disable_fds() upon close device
  vfio: Split migration ops from main device ops

 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 11 +++++---
 drivers/vfio/pci/mlx5/cmd.c                   | 14 +++++++++-
 drivers/vfio/pci/mlx5/cmd.h                   |  4 ++-
 drivers/vfio/pci/mlx5/main.c                  | 11 +++++---
 drivers/vfio/vfio.c                           | 13 +++++-----
 include/linux/vfio.h                          | 26 ++++++++++++-------
 6 files changed, 54 insertions(+), 25 deletions(-)

-- 
2.18.1

