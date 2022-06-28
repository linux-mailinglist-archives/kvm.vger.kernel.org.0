Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 313FE55E95C
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 18:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348274AbiF1QAC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 12:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348210AbiF1P7m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 11:59:42 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2042.outbound.protection.outlook.com [40.107.92.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3464837A24
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 08:59:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mSQ+7rNAHY8Gnzsn1fFviIG6Wn3AyLdax9U88jlQyH3ch9dcdx4+Bro7jVx0Q4s3t8j2ckTrybDXUbe6GUBjmXC08BCc42kZx681x514xiOJxiX2vwPGMKVFJtU27hfRVfUuDp39FcwK2GyJ/A8vzCegCYnCvPOWgxG3XgbwyLbFVOL+p/HdvwITtiFyeJp4oNWLpuz3w511HKNWtSnRwP/6tYarOtJ9gkPZgDSvw9BB250CyNb7Ohc9WOfgmRcwqJjOV0YlTQ3asmYklq3AGDhc+mOenu9Oq7K2AimzhYcmuoYyOy9pzUwYgx7UFtRb6TwAUtoCnsJylK35qNjHzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cXD+zm24UY71Kq0lWEOO4yNpgFmuEXUsYa8DoD+SlLo=;
 b=HmOD4oks5Lr0AFKXaUTD22wRWg+d9wYgjLGVppFK5Es18V0ssWZiOracMSAQH5DDNtcqMd6K8yCHrI84eLH7G+evpgcwwS0Uatqg+Je2mszbFkfXOGWO4kCHWnia1UUMR5i2HRq0erHDo99OQtHQClPc54WLUffo4hHt20woWrJbnvsBXl4puo2U6M5Ww1bX5rnB2OGz3v9RWdl77UsZbbhlN4IDJr6JxYX8v6Wm4plR6vT0XknkEf3df6Q1kPSsmvB/hOJe2jwfaX933R8fAdMSU0TBlyt5/UMhHSdnQjojMIg6qa3gYhRhbzCg1fL29wkJuiAGlD89TFvtEsmuHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cXD+zm24UY71Kq0lWEOO4yNpgFmuEXUsYa8DoD+SlLo=;
 b=Po+5K52qnS9Q/4vuc95XEmPfT2ISDaLkGEhuNHYO4r/O2BcXjVedhDgsB8DGfUQNdIhEMoezmPWi1bDupK/mn64TWX+tJkayecb4+Wgas8+cjMgq7WI+rsX3hfqglhWgIlbMdK4DnMB2fmaJ7iRXYkpIEZEWz9jz4FF/o/aS43STfPEsYSVi8fcjxZdwi6GWxQCvK/cjzw7oeAfyP6XU/4Lpjb2IEubKlOPyee7mJKt4thO3odIsC3SHUsc16x13xRSFJgb7YqeTDm5yGCQs6lBENCadEhk3jsgBBrTPpvYuMtpAU2994mDIVc93sx6BRxwTAP+7YlQyrqhjNdbkYg==
Received: from MW2PR2101CA0027.namprd21.prod.outlook.com (2603:10b6:302:1::40)
 by BN6PR12MB1714.namprd12.prod.outlook.com (2603:10b6:404:107::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Tue, 28 Jun
 2022 15:59:32 +0000
Received: from CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::7e) by MW2PR2101CA0027.outlook.office365.com
 (2603:10b6:302:1::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.7 via Frontend
 Transport; Tue, 28 Jun 2022 15:59:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT004.mail.protection.outlook.com (10.13.175.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Tue, 28 Jun 2022 15:59:32 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 28 Jun 2022 15:59:32 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 28 Jun 2022 08:59:31 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Tue, 28 Jun 2022 08:59:29 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kvm@vger.kernel.org>
CC:     <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <kevin.tian@intel.com>, <shameerali.kolothum.thodi@huawei.com>,
        <liulongfang@huawei.com>
Subject: [PATCH V3 vfio 0/2] Migration few enhancements
Date:   Tue, 28 Jun 2022 18:59:08 +0300
Message-ID: <20220628155910.171454-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f66b1447-bb3e-4105-07b7-08da591f30c3
X-MS-TrafficTypeDiagnostic: BN6PR12MB1714:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RRFBgT85wg4TL+aLlwMDYLaKsWHSLZDr/hqbvJ2XxeVkUf8/MJCl5KpV3T2jP0oKDtCIpPa2CSpsUT5oigdN+8s0HjwD282aiJzKW+W7RhUzuLpARf6T73TAEle+BYCMEc/gFBisl9/o6L1lxK0K1cAS2Pzb1Q3xYOngSO3fyh3PI8zwK8XV5JOqKZNBStlYvAcuss64KzPkc3F3ABtZnUD+ELCa2IxOHR2nBVBcloyA9Ky8izY8tUVt6Hi2Km2wDyKr4V4dMIOdrILlmbq7GsD8aCqSECTQeUYEQuCkupFA+Ui+RXKY3y0t0cVQWn6lMXiztfywygQKmjIr0uLK0ftzrl7Oj4UdS+yun7ALe7c57dbeLXyffCFrgxr8zXPWPkg/er6ZFa+OtLZwxSdwRwsBEYDcTZKWGw5yVlCzzDT4CY6jLEgY8KfPjDT0skIjT4Pr3jM9Xme4EWdFTELPF1xBydCo3QNOUw6/POznQJODlcgchGDjyIXupqoj0XPKI1s79S4xERBw+qli9ImvzyPXEM8W7ssvrYdwmxYr0xP7Ys52l/LkIkZafIcqD0+lFLuT4bwgk4+HBt2SCsAuS2n4DCNIrnoq4dHTdQaLbqvddrOzAUPIgycfN87tCzmw4bjcgGYvcwuqkEw5gbnvNZ+dvT4N5OTuFRBjMAgPjjB3jELggSHGBFLwI7oLB/B2hUwYEBxa0nQUyL1kuQUOoi6iqLlYhjpA/u6Z8eIhwNTTkcnUDsE+gDc7kU79VhEKTdNW1hgu7CK3d0PDxg5Jdtbohi1Pz5I4fl1lF7joGsAj2MW67QprW8S5fC6XRNvSu7Ev2tg0nFlRgcRAJBuyyCNvL0WEoNgx4GO5y8xVnucEnImcjLkESz3qLULf0kekbrtbDjiF22GipHGf3UqWDT6+4TL7AC6QxaN1VZf02usSh2YOG9oolgY7qAiSylwd
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(136003)(396003)(40470700004)(46966006)(36840700001)(110136005)(4326008)(2906002)(82310400005)(82740400003)(1076003)(81166007)(2616005)(54906003)(8936002)(356005)(316002)(70206006)(70586007)(8676002)(186003)(83380400001)(86362001)(6666004)(36860700001)(47076005)(7696005)(5660300002)(66574015)(336012)(966005)(40460700003)(40480700001)(426003)(41300700001)(36756003)(478600001)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 15:59:32.2198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f66b1447-bb3e-4105-07b7-08da591f30c3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1714
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

V3:
- Fix a typo in vfio_pci_core_register_device(), to check for both set & get 'mig_ops'.

V2: https://lore.kernel.org/all/20220616170118.497620ba.alex.williamson@redhat.com/T/
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

