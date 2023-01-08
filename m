Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B9366163F
	for <lists+kvm@lfdr.de>; Sun,  8 Jan 2023 16:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbjAHPpV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 10:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjAHPpT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 10:45:19 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2067.outbound.protection.outlook.com [40.107.95.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0A0FCE7
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 07:45:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QxwKnBKcAj/6Nhg6tnmbv/oNJcraOCMJSWxIpuPXW1nJpZQJK77OTUKUVipirdD+DtSw9bSx39CluvW/eeshH8FEmyta/3EEAPq0VgHllQeaufqB0SJSMGW1D1okMY+hUt+zoHtwlBKPyOZSt0kYr5+NHq4R4mL53pgZoRQFWWG16zl5YYbwI0T+ZV3+VM8TDCBRHDLew9sXsPQNJ+hQruC3ie7A4agoYqWvcbWI6TQxypGFLf2x7TLmsjCMZoRwfmNwu2NePB3sCI8vk38EeP5m3kr543bcNBACeFIidc2t+Uw9uYTjq3Dxu/Y4Vhy2GJJ1UX1fv0c0BqnYlLcKmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mbgjCY1MUxSHpNcn5VVoBGtQNKwj/xyNX+Cq1xeKVeQ=;
 b=Kj2gVrUjyiORSWManndopR8NGzGsLqO/b1IqRk02orAVEarCuNBvXOzk6bGkJYT7C2MQyENpGct9Tmlj6zQq5v9vHqZtmTsQRlpYIkJLiCa70ElymPjeRuktGXhrev6zVFEgEUGa039D+rBynL6uEs90e7+v/1h7rBPfXVbLHlk6Oxy00XaRAel7Rqmq23u5KK2J0kiA6HPyOikR4n2HWqJ2cdtASNwZ9GhH/PNP4qafpdIqkPiiIFlCAN8BSUSrLBlSToO20u1A2ZFJosUwjuxNxXCvESwOiW1LF+Jsm2UhDHdmFED14mcf9eBBGkBNuFErWiohsqGwzK3HWC0/YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mbgjCY1MUxSHpNcn5VVoBGtQNKwj/xyNX+Cq1xeKVeQ=;
 b=hbY9BFKTop+iygYdKQikB1fC5GyOA5aHiMPau+X+su8YxyTxVPQYJKyQVq6pV0y6kBLiV+t7nAeRibL8YNQaPyT2QDTMMpP8t7Tk8lbuWMAMxbq8fhjCOjhQMjltvUZzxVvevGfLPsXm+5V2UiTAw/yVdJeF5Chky2h7Y0i61RqqrCqdgjJivh/B303sKLAtxSrpXI67z6Jf1D7pS/O8cXoVPQEHkiIjM3U0WVOXp2iTB5e3nnk3+nT4nj1fpQwzUJd45Cwp04yDq/o57gFFuZfXgx7cCKEsXWJbvzu1YfVcsj6qrMa9IoeTparP0ox8yiuhuaF38lEN43XMOuDOyA==
Received: from MW4PR03CA0220.namprd03.prod.outlook.com (2603:10b6:303:b9::15)
 by DM8PR12MB5494.namprd12.prod.outlook.com (2603:10b6:8:24::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Sun, 8 Jan 2023 15:45:15 +0000
Received: from CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::7c) by MW4PR03CA0220.outlook.office365.com
 (2603:10b6:303:b9::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Sun, 8 Jan 2023 15:45:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT034.mail.protection.outlook.com (10.13.174.248) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18 via Frontend Transport; Sun, 8 Jan 2023 15:45:15 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 8 Jan 2023
 07:45:05 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 8 Jan 2023
 07:45:05 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Sun, 8 Jan
 2023 07:45:02 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <diana.craciun@oss.nxp.com>, <eric.auger@redhat.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V1 vfio 0/6] Move to use cgroups for userspace persistent allocations
Date:   Sun, 8 Jan 2023 17:44:21 +0200
Message-ID: <20230108154427.32609-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT034:EE_|DM8PR12MB5494:EE_
X-MS-Office365-Filtering-Correlation-Id: ed51054d-6bbb-44f2-b903-08daf18f565a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JkPw3Yqi4WB9/x9VqTd3Ku4nqR9V4AF0MUovnE0jcqc9nUHxUHNGMpybsJOhUHUjsOcm/UnaL6igCBtOIt+FiUX5rHjOhEd5KI7lpGCb/10SoFFRyQ3yz8Zu7JNhbCZwBMFs0ezCxOCn52eeImJtzfWXs7TbFJT3AGeSV/iHBAJE5NMsVOn4xs/bvdvRzO6RGXDFTgckCAThWJ4wPc+/VD33nqiq9yq8uVzoKukZyVN3qfZooPTczvczxuVyLnDBm+i4P9Whx0pSbYYMCGyZZHghdaMRh0P2jkAE4BCUHgzbUPbuwn8n+WJuWtKvstzzC33ADQjr91b8kAB4QgIf7Ov3aHUbecqy1Nchd9jfCYPEZ4ymhBEKQ+RaBEVfqW6TL6gLrh8rVcLkDphvFGxDMFi2RD5dkEJ1YIgyQvQTsVG3NyJD1yoCVpuJGtZJImkyhh6pooD4j46x1HiEMpcDHd8Vg7A5JvnpKGu+1JRGZY+lUZvryE7sloFE72EGVT2vnt49HcSp9/G3jUQmMRiRTea+nGoptm/3l9dwXgye6858DQphiijZ0Y6nuJrhtiEA1GCwlRyTCB9nPplpWhh/KfrBJ2ZtBOgESXLhMu9XDQsKFfhU+8zXWd/DfEC14CfgI+2QuDrp3drINuysVCJcI2UkxNX0/0C1S+0gnAetrrCjT58luxT54rIbKUXPDXM2xToNuSH5nSXGsxGcXPu6I1vFWJLBvgSkC9jovFkGS32TpWFg0TesgxqjxhncFRgpRrMi7e5k7baYVs4cUSP1ejxvWLodjVJZke4tRBmn2Q1TeCGUhUZf7OI0xTA+OYaWNuKbEZdOjRNPstRSQSQXCg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(346002)(376002)(451199015)(36840700001)(40470700004)(46966006)(1076003)(5660300002)(316002)(40480700001)(26005)(7696005)(186003)(966005)(478600001)(2616005)(426003)(41300700001)(47076005)(40460700003)(336012)(110136005)(70586007)(54906003)(4326008)(6636002)(70206006)(8676002)(36756003)(83380400001)(8936002)(82310400005)(86362001)(6666004)(36860700001)(82740400003)(356005)(2906002)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2023 15:45:15.6187
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed51054d-6bbb-44f2-b903-08daf18f565a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5494
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series changes the vfio and its sub drivers to use
GFP_KERNEL_ACCOUNT for userspace persistent allocations.

The GFP_KERNEL_ACCOUNT option lets the memory allocator know that this
is untrusted allocation triggered from userspace and should be a subject
of kmem accountingis, and as such it is controlled by the cgroup
mechanism. [1]

As part of this change, we allow loading in mlx5 driver larger images
than 512 MB by dropping the arbitrary hard-coded value that we have
today and move to use the max device loading value which is for now 4GB.

In addition, the first patch from the series fixes a UBSAN note in mlx5
that was reported once the kernel was compiled with this option.

[1] https://www.kernel.org/doc/html/latest/core-api/memory-allocation.html

Changes from V0: https://www.spinics.net/lists/kvm/msg299508.html
Patch #2 - Fix MAX_LOAD_SIZE to use BIT_ULL instead of BIT as was
           reported by the krobot test.

Yishai

Jason Gunthorpe (1):
  vfio: Use GFP_KERNEL_ACCOUNT for userspace persistent allocations

Yishai Hadas (5):
  vfio/mlx5: Fix UBSAN note
  vfio/mlx5: Allow loading of larger images than 512 MB
  vfio/hisi: Use GFP_KERNEL_ACCOUNT for userspace persistent allocations
  vfio/fsl-mc: Use GFP_KERNEL_ACCOUNT for userspace persistent
    allocations
  vfio/platform: Use GFP_KERNEL_ACCOUNT for userspace persistent
    allocations

 drivers/vfio/container.c                      |  2 +-
 drivers/vfio/fsl-mc/vfio_fsl_mc.c             |  2 +-
 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c        |  4 ++--
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  4 ++--
 drivers/vfio/pci/mlx5/cmd.c                   | 17 +++++++++--------
 drivers/vfio/pci/mlx5/main.c                  | 19 ++++++++++---------
 drivers/vfio/pci/vfio_pci_config.c            |  6 +++---
 drivers/vfio/pci/vfio_pci_core.c              |  7 ++++---
 drivers/vfio/pci/vfio_pci_igd.c               |  2 +-
 drivers/vfio/pci/vfio_pci_intrs.c             | 10 ++++++----
 drivers/vfio/pci/vfio_pci_rdwr.c              |  2 +-
 drivers/vfio/platform/vfio_platform_common.c  |  2 +-
 drivers/vfio/platform/vfio_platform_irq.c     |  8 ++++----
 drivers/vfio/virqfd.c                         |  2 +-
 14 files changed, 46 insertions(+), 41 deletions(-)

-- 
2.18.1

