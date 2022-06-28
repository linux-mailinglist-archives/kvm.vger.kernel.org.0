Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D10FF55E41A
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344999AbiF1NNC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 09:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbiF1NNA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 09:13:00 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2080.outbound.protection.outlook.com [40.107.100.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D7931229
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 06:12:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QE3j/DB7oPZgDYeECgT0CLhLKy1nvLVHAC/XT1EOI8lVCgmxTF8N0P88w1Ur9hDogIUNS8YNeThoDzpm7FNLxsXiI5RAIrSB3sIc2Ofmd2QBzOMd70u3uexQKY7Wr2BREz9WLJe+NzFiod1gQxC7zINX2MEx9lrOb1Sw8RFe6wUrBoEMvlwN4H/up8KpA2uDv9vcGac2Spcxx3jUJyLyHHDtJvERExQvEAEAWcB2CfmuQLlmMFiJOgHKeiBeIRnw94rNeHHvc4VVeo15zeRZzZGKo3W6NbZQIdv5UwTnSUW1oB14qQtADeT1Xr9B+bsr3zZbqMQVQRskMXKyS/1HzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yed27j+PrPEI0Zo2iUC/Nzn9oeVWQCsRCdZhfDiVH+c=;
 b=XXyRqq435dR7TvRAvIkMX1MxMT9VUKJpF2cixN8okJo+EPXKiNrAZT6/CA7dt33r28N9c6Kx9obnyqd9ZPr6ipsAGZKhKzhWRjhqRlPMxI9dtZjwC9QwagoquXG5aqxhxbO4GIcufTKLOYj9EQL5h1PzzNeY2atIRP8vBS1GzLh6qyBfLpZAYs+Axae3qtuEtUFPOhlcn77zwMuJM/UqRrPOncbabLwoIPw0kB4rp98LbiBBsrEZF6RqUCYUFO+dngadiAo28LiR3GRXpLfg5wNmaFJitwuT/6H7QKWY+496YHgkLzTV6W2qft/BwD7R4GzFaaIENc639H/0+0SNig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yed27j+PrPEI0Zo2iUC/Nzn9oeVWQCsRCdZhfDiVH+c=;
 b=ty9cfvavyKAKir/F5T8kmkoqd0DxWwIYlQ4bRhjdVBVd0ZY+Mfg82QlZoFiL15ScxQTZ22HRlD/lCG4XQvasN05TmnF+jpbMx+d166sQKzZXqg2fc0EyrEwpbASOpEZwX3ZgvFr/+pzjvo/+wQ3dBOEfMpFULNV+s1jmtreSgLtaZ5EXi9o5q7DhXLa16vBk5ub3ta1A53xqk20PC35MnVD8990IxxAeKlzVeNV4qDiP7/Qzy9WCx1wrF0aBv8RUHY29dGW9HOIqdHkXlEhjn3h4v5mbAxqkRu0omQmp/Do68DVoMTfhVwgIw/QNpgAzu1NZPAcKW40EAE4aZORznw==
Received: from BN9PR03CA0887.namprd03.prod.outlook.com (2603:10b6:408:13c::22)
 by BN6PR12MB1170.namprd12.prod.outlook.com (2603:10b6:404:20::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Tue, 28 Jun
 2022 13:12:57 +0000
Received: from BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::d5) by BN9PR03CA0887.outlook.office365.com
 (2603:10b6:408:13c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16 via Frontend
 Transport; Tue, 28 Jun 2022 13:12:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT062.mail.protection.outlook.com (10.13.177.34) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Tue, 28 Jun 2022 13:12:57 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 28 Jun 2022 13:12:56 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 28 Jun 2022 06:12:56 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Tue, 28 Jun 2022 06:12:53 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kvm@vger.kernel.org>
CC:     <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <kevin.tian@intel.com>, <shameerali.kolothum.thodi@huawei.com>,
        <liulongfang@huawei.com>
Subject: [PATCH V2 vfio 0/2] Migration few enhancements
Date:   Tue, 28 Jun 2022 16:12:11 +0300
Message-ID: <20220628131213.165730-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dfda8358-c55c-4674-91e7-08da5907eb56
X-MS-TrafficTypeDiagnostic: BN6PR12MB1170:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5sKC9RYF8c0pMDFPX6qM/74fGHgoIFCYPcYrVXpElTkp6cTx8aAW28jh1a0a7PN4oHk1WdnFzC5FLs8Vg9p4ddw3sD6alj4JPBIqd7kN2IVLQl554aYgQBgDQjyTwGdYcqulMOc5mEljG1XTUkRW5bvJyy9q0CiaZl98mQvQN70vajHATLWmZB0QKXGuaEV6v8fSqthgpn2K8Q0ByDAf0zwCanYEhzln5axEOUpynchiMSkjjy7Bd5jLxP4eEfYUt0DKtIdbfeH+O63F81kdgKHwtJcVkcX7IsrPqQ7EOqZyNIZ//JkXucnGjgPhzcx92eTaYEkLag8QP0B4fcXXvID6fNe6naFMGSPDb1riOz9RKrseIWOyt1wXejkbdOezgJMAJJWMOCUeIK9WJhynkfRANTY0hxHZCUrtUVyM1ObWbGBEB6TT+LADV3P21eqwYmRPCkPqGNvcxd8yNJ4nJY6wkmNaUcHooEhvZYbwDjQyZ77oerf1JQNajiG2s39WDQSKNwwFvHjUQhHJHyvEYMm4FfOeywEbpWLYPa6AEHfdQIBGSuYyodJvMxY+BJiROb8lJ0rJlsQqWf0QyUgFFRR/+IofjwMrEVMnsfTbND/M2Y+0Hcg6QijveT1smh8HyfyUFmYJhC7c76QVemu79ZkrsgdGvKLzR5jCJTgzSeDA+0W+bqdikzQGW/i6NK3ytJ+yONZAcbRGGZglLVhk5d6PvWntM1mAqPlJ/q0A7NnE3wfynnsTBNgod58X0ZmYdKS171MFqF3Nyaf2wTHhlfTx/5WHZDY2OtzecyYnQfBxjWH/IsKa1kCk5T7tn0mM70CUYrNORXKnAMnzc8TIOev99uSubyDpfka+yMHmvJWQHa7m4Hn6Zq92fdwiwdLzBjbKyB8PlEVljheGVaQ3GsZVxDhMKSmnhVV09hwGO+hkJY8zj9yJtSAv00naTbgn
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(39860400002)(346002)(40470700004)(46966006)(36840700001)(86362001)(336012)(83380400001)(70586007)(426003)(47076005)(6666004)(81166007)(66574015)(36860700001)(316002)(26005)(186003)(966005)(2906002)(110136005)(4326008)(36756003)(41300700001)(1076003)(2616005)(82310400005)(40480700001)(82740400003)(70206006)(8936002)(7696005)(54906003)(8676002)(478600001)(356005)(5660300002)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 13:12:57.2433
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dfda8358-c55c-4674-91e7-08da5907eb56
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1170
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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

V2:
- Validate ops construction and migration mandatory flags on
  registration as was asked by Kevin and Jason.
- As of the above move to use a single 'mig_ops' check in vfio before
  calling the driver.

V1: https://lore.kernel.org/all/20220626083958.54175-1-yishaih@nvidia.com/
- Add a comment about the required usage of 'mig_ops' as was suggested
  by Alex.
- Add Kevin's Reviewed-by tag.

V0:
https://lore.kernel.org/all/20220616170118.497620ba.alex.williamson@redhat.com/T/

Yishai
Yishai Hadas (2):
  vfio/mlx5: Protect mlx5vf_disable_fds() upon close device
  vfio: Split migration ops from main device ops

 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 11 +++++--
 drivers/vfio/pci/mlx5/cmd.c                   | 14 ++++++++-
 drivers/vfio/pci/mlx5/cmd.h                   |  4 ++-
 drivers/vfio/pci/mlx5/main.c                  | 11 ++++---
 drivers/vfio/pci/vfio_pci_core.c              |  7 +++++
 drivers/vfio/vfio.c                           | 11 ++++---
 include/linux/vfio.h                          | 30 ++++++++++++-------
 7 files changed, 63 insertions(+), 25 deletions(-)

-- 
2.18.1

