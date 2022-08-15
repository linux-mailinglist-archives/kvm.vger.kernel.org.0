Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2E85934D7
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 20:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236725AbiHOSRH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 14:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236621AbiHOSQ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 14:16:29 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6742B18E;
        Mon, 15 Aug 2022 11:14:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mqkZgVc0iVS84iQ0wNx8VhitoWC3aVTQnzAWMcS08Iu8Ox9bc1UeQp3x4W84Lufvp+mMnKV7SyHlW+RT/iLKBoHd4OYYQztbbRD7CBD6m3EczhiNzAROawXSYaCqNU2GTGVepzzeSUgbUxBKq2NcoOlS31Q4BRo0OthMFLtpPLdMGZCPp6YB/YwFbWdnBh9ylHHZD7zi8kSZZKs5b3pvBThubKBkaidbKmWAXkpOFhB4fgzmUs7LBi84hIZ5YPqW4lD37XkYb4b0aMSVrFDoiW7f8RNlSS5fqor2hEIaNMoksdgkXfLbSbLb3tWakcuo+lRpUPlHkjQ43t74gQt51g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DBDOHqleZHVVamzDwdTTjmN2SJGMbpiPi41DSE4yMzI=;
 b=lj6IfPUt3+f3D9rser0zBKmZ8G1NhgxwK8sUGbJqQFHKQMNsENBRjuHaNWVMlgjHZh0OwzvV+kHe4u4VCZ7sVgAFpi+XuIFo6MFuA3gZIeecW6ldOx6C4mLA4MWLOm26/ry3hL9SA0PIH7fnHL5s+CQVqaclYyZQ3zsq+K/EqCwFIDeNDh5R9Y7EJk/OE8nSz63CejS08kJ6rKFVxaY86SH0gbhdkcS+itRtEUMkn0dHQ2YZ8CTCp888ONjq2Y229nk39nn5OC7Ai8T0pNiyPLrFVP6p411TkOiB98+F+EuIU4cRGDc10cigkT4t3zKdU9HnR9GFWb+ho0f8qRUOzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=rosenzweig.io smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DBDOHqleZHVVamzDwdTTjmN2SJGMbpiPi41DSE4yMzI=;
 b=d8+21JOl6W/w0/y0IhtkqluiCg/E22RWOjjUBdNsu1xYfLPwHzPQDbPjnaTGO9jUBx4PIEPyeiXKzKYAcJJbMnfOv0bfLEvGmLBTTH5SPPFNL8xRKNd6pS8Na5H9yZwM0HT0OwYvJpMtK+NSxtUVzLMYwkf2pufj3efrbN4pKjkp4XU4+JbIZzLTS7UTKJOkwYf5VUJSV1ulNJZaJNavSZ76ldlLW/c+n1vnu2ztCAgSuIGEJIYBRckO/IwWVp+mcbitLznukbWkZ4TTctTIy1TcRDzOfUJoEdcvvAEOGCnrhLQdqTLvzuPKuj56a8cl7/tl29RzqJoW2qkOlGdFdQ==
Received: from BN9PR03CA0284.namprd03.prod.outlook.com (2603:10b6:408:f5::19)
 by BYAPR12MB3175.namprd12.prod.outlook.com (2603:10b6:a03:13a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Mon, 15 Aug
 2022 18:14:48 +0000
Received: from BN8NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::6f) by BN9PR03CA0284.outlook.office365.com
 (2603:10b6:408:f5::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.18 via Frontend
 Transport; Mon, 15 Aug 2022 18:14:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT087.mail.protection.outlook.com (10.13.177.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.7 via Frontend Transport; Mon, 15 Aug 2022 18:14:48 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Mon, 15 Aug 2022 18:14:46 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 15 Aug 2022 11:14:45 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Mon, 15 Aug 2022 11:14:43 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <robin.murphy@arm.com>,
        <alex.williamson@redhat.com>
CC:     <suravee.suthikulpanit@amd.com>, <marcan@marcan.st>,
        <sven@svenpeter.dev>, <alyssa@rosenzweig.io>,
        <robdclark@gmail.com>, <dwmw2@infradead.org>,
        <baolu.lu@linux.intel.com>, <mjrosato@linux.ibm.com>,
        <gerald.schaefer@linux.ibm.com>, <orsonzhai@gmail.com>,
        <baolin.wang@linux.alibaba.com>, <zhang.lyra@gmail.com>,
        <thierry.reding@gmail.com>, <vdumpa@nvidia.com>,
        <jonathanh@nvidia.com>, <jean-philippe@linaro.org>,
        <cohuck@redhat.com>, <jgg@nvidia.com>, <tglx@linutronix.de>,
        <shameerali.kolothum.thodi@huawei.com>,
        <thunder.leizhen@huawei.com>, <christophe.jaillet@wanadoo.fr>,
        <yangyingliang@huawei.com>, <jon@solid-run.com>,
        <iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <asahi@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <kevin.tian@intel.com>
Subject: [PATCH v6 0/5] Simplify vfio_iommu_type1 attach/detach routine
Date:   Mon, 15 Aug 2022 11:14:32 -0700
Message-ID: <20220815181437.28127-1-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42e74da4-a60f-4d27-abd2-08da7eea0a26
X-MS-TrafficTypeDiagnostic: BYAPR12MB3175:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?3T0znNhMYYbfBMf++6MsKiMLA6JpO8vmGgMq3oG7+hOFFSp/outHNYFKBJHo?=
 =?us-ascii?Q?swNqE4K7RlNthKqfP4gjrEoyXvQsUzIBALIJh6q4H+4iSeX7YXBfb9RRyzhn?=
 =?us-ascii?Q?6feLMt30VGM5Hc4w2TtzBQ19hDNxweeld3MiNwretgRNNoKmh290uZR8pm8c?=
 =?us-ascii?Q?iuRrcD76PytfpVBQVE0OHJCStWbZmRjTXsI4G9rSEaVqYQYLIp5PCHndwNh4?=
 =?us-ascii?Q?gUifeV5PvoASqnjKpEl/BMXPXA4Zt2tMyCVIO0rt9iLgZ3ZsNZjAsuQ+/yam?=
 =?us-ascii?Q?njJJWNJT+tqjwF8q4tArpxeh558R5M3+cUgjxr3t+P7WbTmVL1X4+62YOQOx?=
 =?us-ascii?Q?uRCYhn5XYa1scinSxwsB8KC2MvDGUqohKHr7Fqs7EcE25JtybKNwSMTfvm5c?=
 =?us-ascii?Q?ngnSRUhLDOKqWAzB1BJlA+DiNqb2ZFQHdlD+M1P5OrW0orl/W4faVMNTmIXy?=
 =?us-ascii?Q?ww3QnjI5LqtYWj0ogkA8tZoAdqq6mwfAkcnO4RllPIyWlwIXleMhfOhBd9sz?=
 =?us-ascii?Q?0iCXNeGSuL46CAKTu44/89IE1RIEMHnAUjtdndbVN5ZHddrQZ7d1ubWxjWMV?=
 =?us-ascii?Q?QDlTOwwVFMoEpKJh7VkwxdXmH99nhT/FCnNigHpBmyL87psDV4ukREWGxd+A?=
 =?us-ascii?Q?Ww54aGTdF4uuNMHPxXz6UOnubI7m5nDI9mo6aeBF6vgse/pSHUCdzM6joLVX?=
 =?us-ascii?Q?AdS7eAftaUIOCBSfDEVLRFFgW4ONnEcC5/33T7+OBEPlZGEL2zx/Ja16Cq1N?=
 =?us-ascii?Q?e04FQanRbXmGJF4Ck42A8RDeT5N1Ao4tp0Efy9wEqWttqTcyOfag5b3xQ9Is?=
 =?us-ascii?Q?IXe1rI7cuJO/9o/t+KRyeqxjjhVUVN8Joqz7bgodkkPMLjYVzGvhCaHKOiyT?=
 =?us-ascii?Q?ppEXxCKuPbPOjVZBAfrr6mjHesexFE+5DZSvJPbTGtfuFV7Ph9xj9FeDT4Pe?=
 =?us-ascii?Q?++t1FbUd/AkvBFCn7QGgQw=3D=3D?=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(376002)(39860400002)(396003)(46966006)(40470700004)(36840700001)(36756003)(86362001)(1076003)(426003)(336012)(186003)(47076005)(82740400003)(2616005)(356005)(81166007)(83380400001)(70206006)(70586007)(5660300002)(8936002)(7416002)(7406005)(4326008)(8676002)(966005)(40480700001)(82310400005)(2906002)(478600001)(36860700001)(40460700003)(6666004)(26005)(7696005)(41300700001)(316002)(54906003)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 18:14:48.2225
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42e74da4-a60f-4d27-abd2-08da7eea0a26
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3175
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
with this series, since there's very less value in doing that as KVM will
not be able to take advantage of it -- this just wastes domain memory.
Instead, we rely on Intel IOMMU driver taking care of that internally.

This is on github:
https://github.com/nicolinc/iommufd/commits/vfio_iommu_attach-v6

Changelog
v6:
 * Rebased on top of v6.0-rc1
 * Added "Reviewed-by" from Jason
 * Added "Cc" to Joerg/Will/Robin for the IOMMU patch
v5: https://lore.kernel.org/kvm/20220701214455.14992-1-nicolinc@nvidia.com/
 * Rebased on top of Robin's "Simplify bus_type determination".
 * Fixed a wrong change returning -EMEDIUMTYPE in arm-smmu driver.
 * Added Baolu's "Reviewed-by".
v4: https://lore.kernel.org/kvm/20220630203635.33200-1-nicolinc@nvidia.com/
 * Dropped -EMEDIUMTYPE change in mtk_v1 driver per Robin's input
 * Added Baolu's and Kevin's Reviewed-by lines
v3: https://lore.kernel.org/kvm/20220623200029.26007-1-nicolinc@nvidia.com/
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
 drivers/iommu/arm/arm-smmu/arm-smmu.c       |   5 +-
 drivers/iommu/arm/arm-smmu/qcom_iommu.c     |   9 +-
 drivers/iommu/intel/iommu.c                 |  10 +-
 drivers/iommu/iommu.c                       |  28 ++
 drivers/iommu/ipmmu-vmsa.c                  |   4 +-
 drivers/iommu/omap-iommu.c                  |   3 +-
 drivers/iommu/s390-iommu.c                  |   2 +-
 drivers/iommu/sprd-iommu.c                  |   6 +-
 drivers/iommu/tegra-gart.c                  |   2 +-
 drivers/iommu/virtio-iommu.c                |   3 +-
 drivers/vfio/vfio_iommu_type1.c             | 353 ++++++++++----------
 14 files changed, 229 insertions(+), 217 deletions(-)

-- 
2.17.1

