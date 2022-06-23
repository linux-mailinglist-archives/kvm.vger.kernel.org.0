Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4135589A9
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 22:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiFWUBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 16:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiFWUBf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 16:01:35 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CF237A87;
        Thu, 23 Jun 2022 13:01:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ioz+3T6XL/LOssSuOvDzhkh7lr4NxBmrBOpZSkczDCC870NdSesfT+mWbugGkbpxTp1YoVv+KGLUqrR6YoZN97ym7764a3PBU4UB/HD009GaPcIADAZxCvJn0aovrTxSXWGaFUkb0wTt1sUMo2+p5EZU2bP0vWScOuiH9fT7QnHHYT6W6lKKCLuRPXrmm7s5ekHgCDEUmmltbt8EK1KNzpzFsk5vMyPUO4T+5Zw7laP/AFqaun/RGQ4AO4YxULjp7IUNfAJTyO2tT2shx1cg6Szg/R2UZLB/LVjBFmmj+SluNXJoKHOWbVd8ZQ/xkxlntwctdX2VZeTpP54EP8Ah0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F86+RvzjkgjzMtSa8CwsA63oaKihCbAPxS/B+zVQWH4=;
 b=XWo+NSFjycn8F0mOlZHtyhn8ifCegdJ3I2RvkElRmGVfmBWOEDAG8hxH4ty+ywTmBoEVmlUjFT2g+7uGilBupXrmxBnug3eJZWkJoEZBJQ7clZSq/o/Ze/FOK1uFHV5HNrCwBK/ZMoLVFOIiRzl2K0YAHUg08AaRdHSt+YEBwDk7dAIUf2ZB3RUjnRhsBBwF/qzPNYqhAfFo/Vw8LfW/AIYjVxvkTdcNGzQyLi35+Apodn6gslZ+MhrijQ07Papu39ygQma5jJulMJXsMbvIpJJudvzpklgAj7HA5HF9lCH1iQcCf/AUMeT7nfkd7c4Sbd6ItMXxOE1D1R/eagv5aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F86+RvzjkgjzMtSa8CwsA63oaKihCbAPxS/B+zVQWH4=;
 b=JIAyEzIH2R2iPILKwFCZIi1wAz2utkwn6aeRrYUHx4S52d83MV5Hkxc5AhLgQqQeJfF3oevKLmySZxL7hpXHYp0R0dNvl/vHJ6raMPH00I9JhkfWgq3htGFp4beF4UnWvhFHmo27ayBsS3ip8f5DMQwEAP3ommYMAJBz8OtVfVFCIzI6VB8TLFKssbxPueIPxejbBxU6uXeaBSHtFwdOiQ31193ISSinowmhBPbMYSCSdoqSfkRhEpJOkMJX10FyG0QQ323CRh7yzta/qqwIsXEsS1snHioJzhmEjVUW0FYCBZ/d13a1yxF7HbgAzkQbyaJL5WFvUoHI81pfa+W3ZA==
Received: from BN6PR14CA0046.namprd14.prod.outlook.com (2603:10b6:404:13f::32)
 by SN1PR12MB2525.namprd12.prod.outlook.com (2603:10b6:802:29::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.17; Thu, 23 Jun
 2022 20:01:32 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13f:cafe::98) by BN6PR14CA0046.outlook.office365.com
 (2603:10b6:404:13f::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18 via Frontend
 Transport; Thu, 23 Jun 2022 20:01:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Thu, 23 Jun 2022 20:01:31 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 23 Jun
 2022 20:01:31 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 23 Jun
 2022 13:01:30 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 23 Jun 2022 13:01:27 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <marcan@marcan.st>,
        <sven@svenpeter.dev>, <robin.murphy@arm.com>,
        <robdclark@gmail.com>, <baolu.lu@linux.intel.com>,
        <matthias.bgg@gmail.com>, <orsonzhai@gmail.com>,
        <baolin.wang7@gmail.com>, <zhang.lyra@gmail.com>,
        <jean-philippe@linaro.org>, <alex.williamson@redhat.com>,
        <jgg@nvidia.com>, <kevin.tian@intel.com>
CC:     <suravee.suthikulpanit@amd.com>, <alyssa@rosenzweig.io>,
        <dwmw2@infradead.org>, <yong.wu@mediatek.com>,
        <mjrosato@linux.ibm.com>, <gerald.schaefer@linux.ibm.com>,
        <thierry.reding@gmail.com>, <vdumpa@nvidia.com>,
        <jonathanh@nvidia.com>, <cohuck@redhat.com>,
        <thunder.leizhen@huawei.com>, <tglx@linutronix.de>,
        <chenxiang66@hisilicon.com>, <christophe.jaillet@wanadoo.fr>,
        <john.garry@huawei.com>, <yangyingliang@huawei.com>,
        <jordan@cosmicpenguin.net>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: [PATCH v3 0/5] Simplify vfio_iommu_type1 attach/detach routine
Date:   Thu, 23 Jun 2022 13:00:24 -0700
Message-ID: <20220623200029.26007-1-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76548f47-483f-43be-535a-08da55532af8
X-MS-TrafficTypeDiagnostic: SN1PR12MB2525:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?XbHupQRekQ/jWGmhFPXbCar4gKVjHlyVGsmHEQU069ocuou0rvok7c1jeLWc?=
 =?us-ascii?Q?DZYn/bVfp7lgf6EqZDB88kQ66QzuGskMXIX3cDOHIJ3gggjC0FMubLyF5xHq?=
 =?us-ascii?Q?mZhWk0hZnleTbgUzhk/zkpUBkJFOLdvwwFTEFtBnwljKp8K5y529//PEKyMQ?=
 =?us-ascii?Q?uxiDXb0fBz72ktufTP7OLpEASCcNbq54sv50Ui/L5pBQCdl/veDhE0xAdETc?=
 =?us-ascii?Q?kvAgzBGq65QM4VZZNQxbPJcRidbv1MZ4H5BpjDwlLGLPBhfHDnz2MPZyDUxG?=
 =?us-ascii?Q?mmfTxPaRUBF1IgO05NrXnYWNsGj09jL3mRGEt5TTThh6rZcoTJEeWenTbEI7?=
 =?us-ascii?Q?olDCW/7buNYCQNAIJmtzvEtGHM0RCsC7Xuma1VPXyNKPy1iQceJFPpyhD0wq?=
 =?us-ascii?Q?8sf8SUIDU6xkWAx7HOzF8hnzU2NZzK5d/Tf8Wai0QgrTe1eIv4IACaeAp0zg?=
 =?us-ascii?Q?7/tzkUiy3P6atov25Yxlg8Fuc8V58VlP0FkgUaAwAHJa5MvVjL88RG17eSo7?=
 =?us-ascii?Q?7M2kEvJIrgOJV0znUWQ9vGCmyPhU7PzKn13IstacxU73hQo6lBCCNJzoRtm8?=
 =?us-ascii?Q?1oF+WzQaSOCKzJDvA99hRXp8sWocOteVZYMOTuUuYLgCnAM70o6MIufiLweZ?=
 =?us-ascii?Q?Rqpi0xWKP3cJTDkDwQYdjNTh+S1XCKry7P7P4zC2ZhBzoUns/IW1WZDW5jRT?=
 =?us-ascii?Q?ER+bTnY6I90ndhEfzG55FJRdnKmIQeNFmpra15QHnRL0Ip7Y/Cifdjk9nQTe?=
 =?us-ascii?Q?l9FsajEyzxFTbzX2NMnZgRcK7V9E4PaphTISG/tbLWR4ipDi2HUhMD3Waegc?=
 =?us-ascii?Q?2RhjdEaAige8tqpkoqM2mePVV60Qwn+/1d0JIc9f7hNEBcEsgpL6pdN8TM6n?=
 =?us-ascii?Q?M/CKPAXZg73II45c31ccUP8AaBfEjJDH2xZ8sB8+q4vGn1qVxLuQ2JXBP5Uj?=
 =?us-ascii?Q?tGAyQD8HeDVqjlglitoUi9XdDPR2AcQnrpljXAIH7cLp7ZGbhESni0slS+qi?=
 =?us-ascii?Q?I3BCbKgYReew7Xen/K4UKHUqdA=3D=3D?=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(396003)(376002)(46966006)(36840700001)(40470700004)(316002)(966005)(54906003)(8676002)(70206006)(186003)(356005)(40480700001)(4326008)(41300700001)(36756003)(8936002)(81166007)(2906002)(86362001)(7416002)(5660300002)(2616005)(26005)(478600001)(7696005)(110136005)(921005)(82740400003)(1076003)(7406005)(336012)(36860700001)(82310400005)(6666004)(426003)(70586007)(83380400001)(40460700003)(47076005)(83996005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 20:01:31.6191
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76548f47-483f-43be-535a-08da55532af8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2525
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a preparatory series for IOMMUFD v2 patches. It enforces error
code -EMEDIUMTYPE in iommu_attach_device() and iommu_attach_group() when
an IOMMU domain and a device/group are incompatible. It also drops the
useless domain->ops check since it won't fail in current environment.

These allow VFIO iommu code to simplify its group attachment routine, by
avoiding the extra IOMMU domain allocations and attach/detach sequences
of the old code.

Worths mentioning the exact match for enforce_cache_coherency is removed
with this series, since there's very less value in doing that since KVM
won't be able to take advantage of it -- this just wastes domain memory.
Instead, we rely on Intel IOMMU driver taking care of that internally.

This is on github:
https://github.com/nicolinc/iommufd/commits/vfio_iommu_attach

Changelog
v3:
 * Dropped all dev_err since -EMEDIUMTYPE clearly indicates what error.
 * Updated commit message of enforce_cache_coherency removing patch.
 * Updated commit message of domain->ops removing patch.
 * Replaced "goto out_unlock" with simply mutex_unlock() and return.
 * Added a line of comments for -EMEDIUMTYPE return check.
 * Moved iommu_get_msi_cookie() into alloc_attach_domain() as a cookie
   should be logically tied to the lifetime of a domain itself.
 * Added Kevin's "Reviewed-by".
v2: https://lore.kernel.org/kvm/20220616000304.23890-1-nicolinc@nvidia.com/
 * Added -EMEDIUMTYPE to more IOMMU drivers that fit the category.
 * Changed dev_err to dev_dbg for -EMEDIUMTYPE to avoid kernel log spam.
 * Dropped iommu_ops patch, and removed domain->ops in VFIO directly,
   since there's no mixed-driver use case that would fail the sanity.
 * Updated commit log of the patch removing enforce_cache_coherency.
 * Fixed a misplace of "num_non_pinned_groups--" in detach_group patch.
 * Moved "num_non_pinned_groups++" in PATCH-5 to the common path between
   domain-reusing and new-domain pathways, like the code previously did.
 * Fixed a typo in EMEDIUMTYPE patch.
v1: https://lore.kernel.org/kvm/20220606061927.26049-1-nicolinc@nvidia.com/

Jason Gunthorpe (1):
  vfio/iommu_type1: Prefer to reuse domains vs match enforced cache
    coherency

Nicolin Chen (4):
  iommu: Return -EMEDIUMTYPE for incompatible domain and device/group
  vfio/iommu_type1: Remove the domain->ops comparison
  vfio/iommu_type1: Clean up update_dirty_scope in detach_group()
  vfio/iommu_type1: Simplify group attachment

 drivers/iommu/amd/iommu.c                   |   2 +-
 drivers/iommu/apple-dart.c                  |   4 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  15 +-
 drivers/iommu/arm/arm-smmu/arm-smmu.c       |   6 +-
 drivers/iommu/arm/arm-smmu/qcom_iommu.c     |   9 +-
 drivers/iommu/intel/iommu.c                 |  10 +-
 drivers/iommu/iommu.c                       |  28 ++
 drivers/iommu/ipmmu-vmsa.c                  |   4 +-
 drivers/iommu/mtk_iommu_v1.c                |   2 +-
 drivers/iommu/omap-iommu.c                  |   3 +-
 drivers/iommu/s390-iommu.c                  |   2 +-
 drivers/iommu/sprd-iommu.c                  |   6 +-
 drivers/iommu/tegra-gart.c                  |   2 +-
 drivers/iommu/virtio-iommu.c                |   3 +-
 drivers/vfio/vfio_iommu_type1.c             | 340 ++++++++++----------
 15 files changed, 225 insertions(+), 211 deletions(-)

-- 
2.17.1

