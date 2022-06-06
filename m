Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C740553E307
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 10:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiFFGUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 02:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiFFGUD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 02:20:03 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2045.outbound.protection.outlook.com [40.107.236.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDE121E0B;
        Sun,  5 Jun 2022 23:19:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cndKJOiJd90tXzm/yOg6GgkNavKUiAMwfv6bOIysihopzc6Xshv8wMsgzqF6osS5xme/1+MVhBtlikayvzg59nZTWZsRp1s5vA8sC26PBKE2y/V68Sb58noh+YIO5DyS+qXeXk7BXOg/0qGxddOGR0i2FoJRa12+MbBCXYdlVyKZEyO22ITepK6UkpILoW0Ngau1fhLIdGM2dbCtwgxNn3uhZ5p76I/9DveLemrCyLjBLexgrKcs4kI89TNhjfR8A1AjU/SfX+Bwflor3TqyMsL6XXAWIsjV3QroTzhHxAlw//GVtz/S3NUJI3ProPlTUYIgWN+5+YcGoguDwM0tsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qt61BEzWAJnf/jjYQPs/mf5a7J0wxbd8tUu1/z9I+ro=;
 b=Fhmg/hcS/GKTVHdJa67QBMwxlUs8EK1td39cjXNGOo5FTqwtB2SaSPYlZ1vehE9JaCe4eFRfEcmL7PrOizvqkbL25NCOHOh3i2Dc5qGOcaFSjYVzrOGQ6gvHXY25hygY/JGcZNjiQ0sPSDXirt5SP0iDkWZ8YxHiG9gAZmAHXKade9yfXPJyztfT0NTBFXhE5465t4VbBzP8B2kdpbttM2gaaCLQN0h0goqzDjntt9bOfSm9a68AzoEa8RORI7LMySH3X6hPG8/GE17wwNqOzslBX3qncp6LaTiTIXxDNvfMYWJf86NFE+LRHwfBUWttNy2Smz5n7MWaHBnui/TwhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=samsung.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qt61BEzWAJnf/jjYQPs/mf5a7J0wxbd8tUu1/z9I+ro=;
 b=pZhCEki/WrrDNL6nzAhWkMes+eXnm7eBIhNmnUDuvd8VQ/Lwy7bvo21V8SnWQyH4Zu7dIGoeA2CGzq9jNc3OWhn824TDsFVDGWFUK76ylUq4aMYWZN5DAmWOBrh2335ZCzV3Iv+brkY0+2lolWQPCcAMgQgN5I+66IypBIHg2DYu1plzvA05XuYxI9dz7QLIVlKuiBipWVpb7CDyBjC4w9jstfdhwR/YZVyDR8tK1BWMK2mDhWhjYkTOcSRikSqNObdYZg5B131hHqVsf4SHVpH3yAXSo+ZV55wb9GXUxUFbRSyLs8hunfEBtXUjOnV3T13lJI2sk8pFwZv+Ds13Gg==
Received: from MW4PR03CA0182.namprd03.prod.outlook.com (2603:10b6:303:b8::7)
 by DM6PR12MB2890.namprd12.prod.outlook.com (2603:10b6:5:15e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.18; Mon, 6 Jun
 2022 06:19:53 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::5a) by MW4PR03CA0182.outlook.office365.com
 (2603:10b6:303:b8::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12 via Frontend
 Transport; Mon, 6 Jun 2022 06:19:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5314.12 via Frontend Transport; Mon, 6 Jun 2022 06:19:52 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 6 Jun
 2022 06:19:52 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 5 Jun 2022
 23:19:51 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Sun, 5 Jun 2022 23:19:49 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <joro@8bytes.org>, <will@kernel.org>,
        <marcan@marcan.st>, <sven@svenpeter.dev>, <robin.murphy@arm.com>,
        <robdclark@gmail.com>, <m.szyprowski@samsung.com>,
        <krzysztof.kozlowski@linaro.org>, <baolu.lu@linux.intel.com>,
        <agross@kernel.org>, <bjorn.andersson@linaro.org>,
        <matthias.bgg@gmail.com>, <heiko@sntech.de>, <orsonzhai@gmail.com>,
        <baolin.wang7@gmail.com>, <zhang.lyra@gmail.com>, <wens@csie.org>,
        <jernej.skrabec@gmail.com>, <samuel@sholland.org>,
        <jean-philippe@linaro.org>, <alex.williamson@redhat.com>
CC:     <suravee.suthikulpanit@amd.com>, <alyssa@rosenzweig.io>,
        <alim.akhtar@samsung.com>, <dwmw2@infradead.org>,
        <yong.wu@mediatek.com>, <mjrosato@linux.ibm.com>,
        <gerald.schaefer@linux.ibm.com>, <thierry.reding@gmail.com>,
        <vdumpa@nvidia.com>, <jonathanh@nvidia.com>, <cohuck@redhat.com>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-rockchip@lists.infradead.org>, <linux-s390@vger.kernel.org>,
        <linux-sunxi@lists.linux.dev>, <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: [PATCH 0/5] Simplify vfio_iommu_type1 attach/detach routine
Date:   Sun, 5 Jun 2022 23:19:22 -0700
Message-ID: <20220606061927.26049-1-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 398b826b-ed06-426d-5c5f-08da47849165
X-MS-TrafficTypeDiagnostic: DM6PR12MB2890:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB2890C7DE246EECA45C210CC1ABA29@DM6PR12MB2890.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lxIvg2z2sn5/yqJNLZP0SOo/ZwR6vmGSXF4b/VrgDZUYpPYs7nwcT45mp7+AU2P52kLC3Ym/oYCD2pyGR7engcAwHD1PRhXFMg+NJ3yhaYTnKiREMZY2qUgp95goY4I/7ZoLrrwh5Gsl/A7VGm4FQJ7993ZrZHdQKOj9+wdTkqsdzMqKajX8CZv/OqVTvwMKN6zqQn9AbaXx5EY+ECXkn7c8/JyO3neqyoyUlkW41kB8E2bBeelwtvl9qk16UN7Csk784yZuf1lCYjUBaJwJR6jzOVknIVvO26orltaUeIBtm3SjcjZ/IkExoAMifcacxDGq1R/Rtu9+4UkOWL5ySBQcHtxSeZ4BvTNEfyDHC8EulLJFymDOxiM+aKTgrhRH5PBjiY5ZYBeAY47OQCcdWMYxfgWJfhpg+QrLJ15JTZ30oqBsbc2rra8FEvifAwOx6xMIS4aoppRmLpkqJzilbvg+KgQFBq7nvoif0pCtK2QzRFEqn/agh/7yMa1/dCVopyDWknn3jEXDnwAEELnfSUIAjZ1RI3CMG6b0FraBhoNPjir+/he0ADqQS1CiNFZSuVzpg6WVq9/Pl/lNxQkXBjDfFRlv9uFdDU74Y3rDRF52zuHXNL+dG0Fhers8QAsNUG18YWzLkcikOjFAsl/wj73n4jHGdTTINxM+8idC9b6UJi0M5fvfYcMVGft9olZ9Pxzw54B8o8OFpBErcCkHhTvlXmrW7DS4t/KYNo24tAaZNmuSw8JD6flulB4Gyyb9g7l8yYBBZ9YTpvoUkD2+RtxEYhYCs2de5SMu26+4UGmKnnXs/keUPIRVp6HXpycbXO0HqmEhG67GW1u+18lEFp2bnqV1S1SH/O0FX77UZMA=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(336012)(47076005)(1076003)(2616005)(426003)(36756003)(7416002)(6666004)(83380400001)(966005)(186003)(7696005)(36860700001)(26005)(81166007)(110136005)(40460700003)(8936002)(921005)(356005)(316002)(82310400005)(4326008)(508600001)(86362001)(8676002)(5660300002)(54906003)(70206006)(70586007)(2906002)(7406005)(83996005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 06:19:52.5847
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 398b826b-ed06-426d-5c5f-08da47849165
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2890
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a preparatory series for IOMMUFD v2 patches. It enforces error
code -EMEDIUMTYPE in iommu_attach_device() and iommu_attach_group() when
an IOMMU domain and a device/group are incompatible. It also moves the
domain->ops check into __iommu_attach_device(). These allow VFIO iommu
code to simplify its group attachment routine, by avoiding the extra
IOMMU domain allocations and attach/detach sequences of the old code.

Worths mentioning the exact match for enforce_cache_coherency is removed
with this series, since there's very less value in doing that since KVM
won't be able to take advantage of it -- this just wastes domain memory.
Instead, we rely on Intel IOMMU driver taking care of that internally.

This is on github: https://github.com/nicolinc/iommufd/commits/vfio_iommu_attach

Jason Gunthorpe (1):
  vfio/iommu_type1: Prefer to reuse domains vs match enforced cache
    coherency

Nicolin Chen (4):
  iommu: Return -EMEDIUMTYPE for incompatible domain and device/group
  iommu: Ensure device has the same iommu_ops as the domain
  vfio/iommu_type1: Clean up update_dirty_scope in detach_group()
  vfio/iommu_type1: Simplify group attachment

 drivers/iommu/amd/iommu.c                   |   3 +-
 drivers/iommu/apple-dart.c                  |   5 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |   7 +-
 drivers/iommu/arm/arm-smmu/arm-smmu.c       |   1 +
 drivers/iommu/arm/arm-smmu/qcom_iommu.c     |   3 +-
 drivers/iommu/exynos-iommu.c                |   1 +
 drivers/iommu/fsl_pamu_domain.c             |   1 +
 drivers/iommu/intel/iommu.c                 |   5 +-
 drivers/iommu/iommu.c                       |  26 ++
 drivers/iommu/ipmmu-vmsa.c                  |   3 +-
 drivers/iommu/msm_iommu.c                   |   1 +
 drivers/iommu/mtk_iommu.c                   |   1 +
 drivers/iommu/mtk_iommu_v1.c                |   1 +
 drivers/iommu/omap-iommu.c                  |   3 +-
 drivers/iommu/rockchip-iommu.c              |   1 +
 drivers/iommu/s390-iommu.c                  |   1 +
 drivers/iommu/sprd-iommu.c                  |   1 +
 drivers/iommu/sun50i-iommu.c                |   1 +
 drivers/iommu/tegra-gart.c                  |   1 +
 drivers/iommu/tegra-smmu.c                  |   1 +
 drivers/iommu/virtio-iommu.c                |   3 +-
 drivers/vfio/vfio_iommu_type1.c             | 315 ++++++++++----------
 include/linux/iommu.h                       |   2 +
 23 files changed, 223 insertions(+), 164 deletions(-)

-- 
2.17.1

