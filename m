Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D463658B8D
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 11:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbiL2KQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 05:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbiL2KNp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 05:13:45 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E9BCE0E
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 02:08:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aDHalOqo/99rk0lLohHJRrMfiMK5nHP4LxzX6DlK/uTkhpBcfkKVchYxKt0Ufz0V+8KvTlu/ZpT9fU3bqfmSc0+1gwWc33y9yAtBkd9NjH3oSOB03MPoKwyfsMbqSI1HZ0/EASrncb/HZDpOnhjLQCloiflTSItNiaStJ2b7Vx08CNX3WKxPp452Zi9Gxma9/NitqQ/hZsovquQEqHQctGXOl9dov0WvBbc0EQab38HNGimd2lzIUb+bQQrTYONeGghKeAipDqiDjz2adzx60OZ/BnTt2YjWOM0NUuzAVTiZXFmS+vfPoRrruC6EvmIMz1jiaT/6cqeKk0GIugGnVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Q9REDnNtM2xjdE8TFKcSApPR37Obqc159zUBo9lbnY=;
 b=Zh1R3Zcgp3yDgJ9lvx4pXM/Zbi//HuPsBHO91T5kytRCMNbaL6u99KPcPwPSKUIkfNqdm7/HNy2IlOfaqjcrrdKdwPBN6Yd+4KFGIIV265N6XyBO1EUV+jtcoIV5I32d72jO2S+msnTueuORAEXSrHY4RbjZRweYwSm6kn+yQdJw0FZ0JmuRGWFOrhem/PDl4LyS7uNtiBckDxKBAAEwPJ1EzTYRCvCecCP7Y+5zAJ4nOhmqW4WoXelOhfe+qmmimfMIo837XIEGBGqG/HN8CDncM61M40iAAhsuQmeD3ocbeDZX8WrPONLVX2/SHEOpE9GUGio+PcpZPUNVspqwXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Q9REDnNtM2xjdE8TFKcSApPR37Obqc159zUBo9lbnY=;
 b=Kid37ir6QsGr42hqsopjoM9paQ3+WPkXk+nSRX0cXN2TeymAS/aSoT4aRINqDm4WUQ/rJwHXdk/oGMjE5Y9gg31oD4BzIBkvy/nDdUd44pkRCEXVJa5/6cTtB0lw3ZU2VRBDdd06W0WuD1MA5CgkjwvLglL+japxILv2PVJwY3LN0ZeoShAM+gpfeJCdVp41Wk5fEsWg/gptLq3Ph6KueMjvSQWnZ18V+b82Q4SwNvQm3E8YiziCP4kQxbmIK8LbKg8l8/mBzrT7qHpYJUjmmTYw1hzR5ckDWBVyP+xrW1zZV3FvpXkZhik/dRg2yqaRV6leBZlzsx6Ecugy485oQw==
Received: from BN9P222CA0005.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::10)
 by DS7PR12MB5768.namprd12.prod.outlook.com (2603:10b6:8:77::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 10:08:25 +0000
Received: from BN8NAM11FT095.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::4e) by BN9P222CA0005.outlook.office365.com
 (2603:10b6:408:10c::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.17 via Frontend
 Transport; Thu, 29 Dec 2022 10:08:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT095.mail.protection.outlook.com (10.13.176.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.17 via Frontend Transport; Thu, 29 Dec 2022 10:08:25 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 29 Dec
 2022 02:08:16 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 29 Dec
 2022 02:08:16 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 29 Dec
 2022 02:08:13 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <diana.craciun@oss.nxp.com>, <eric.auger@redhat.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH vfio 0/6] Move to use cgroups for userspace persistent allocations
Date:   Thu, 29 Dec 2022 12:07:28 +0200
Message-ID: <20221229100734.224388-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT095:EE_|DS7PR12MB5768:EE_
X-MS-Office365-Filtering-Correlation-Id: 48c379f1-b87c-496b-ba49-08dae984a017
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZtrkhwL9KkHsAmS8WXojmurYSIpa/XLvwXvVgycaP7kH5EodaA+DZW5ZcYmVHhbEcycPABq/daahgalyfXsOmI1TTsovdK0mn8tT5LmsMFfDOV5lzAJLKZPEIFtsj/VXgVAnQW067EJitY64kiUpwMMV0ZXJF+lGO0+e5yZ/b20jhflw2T7pBVnbV/3pQZ1Lhsr4wRmoYUQe0EMIlXGw3tS/HkGkJWLEpPFyoI5cBuDeNRPXkDbfwpnvgJ/evsOWTJ7M/fghEHv6a7pkaTRy4Z+6BcN3YcMdOh5X6i3DCjsDiBXuMMQl7RY3Cr/XyHbE1XeuRpN1gUilw9ChBQAlDq/0D/d2jLbiZw8bg6AHbZfVFQNkng/MzINjqSii5UMX4RknjyBrze9WVKrFNyXDZJNSzkVyEkx7ZwdZpe6Mn1I6DuY4eIy0ckmnWU/V/tv074ok49/Ldrrk5fhXL1MDmhjCB+R1/QGIGYV3lTKBZUmkXwBVDlak3A7IWBo1+wz1Thu2vaI4IDy78z/T8lCAdu1sWZSikV9tKpaSNA0a1qXOESkazlp56gbZ/eNT0NWgP7SSP9nYnX7IGfhSm0l5nob+XgIrFfxztjmFyUKhREUZqorDRGGvNmoVxMQD7Bf9MSg4tknDDxy9rDtXE6DfGRPMVQ0Wh92W02cFf66ystN0ETR7IuUzaB9y3B+ZU3IBM6y+8jXcsgvicsJSYdmTSuX7kIAEfu55dQv5wXnuQ9shkh+UwssG92OZ0bVa/3BbjlqQxAOqgYE1LoCBxHfgoYUBx3rPmLLe3wkeGULKTzU=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199015)(36840700001)(46966006)(40470700004)(26005)(186003)(7636003)(356005)(40480700001)(478600001)(86362001)(966005)(82310400005)(316002)(36756003)(6636002)(110136005)(54906003)(41300700001)(7696005)(2906002)(8936002)(47076005)(83380400001)(6666004)(5660300002)(8676002)(70586007)(70206006)(4326008)(2616005)(1076003)(40460700003)(36860700001)(336012)(426003)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 10:08:25.5023
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48c379f1-b87c-496b-ba49-08dae984a017
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT095.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5768
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

