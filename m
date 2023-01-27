Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5E4067EF31
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 21:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233495AbjA0UG2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 15:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbjA0UGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 15:06:06 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2089.outbound.protection.outlook.com [40.107.95.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149D913D52;
        Fri, 27 Jan 2023 12:05:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j/oJ/mjzoVJ9LYtmtKqnBfT6ykKG6CCwPi1fhWIWV/ECm6Fh5Lr1nZzkAHoV4zICg9oi91ydGHYOH7ofPw7SgDDCanVZF6KTOCf1ZAYMn5X7zwDjk0CadjtxpqGvOK1+qcbJmhZzoQW7ss9249YUM8O5Kw84JDFLKdrTMEUNdTt8Hdc6YLYTW4fDSbE8eGuukPyl7rUXV6AyinsiG+t+/migr5ZcjUt8ktGi+4/pbt9xlZhu426bp1XaMpj/91O5TxcvlBCkFGrjuPP4gFGONMzRcb3gCwEJC9ZFSLbTeoUtq/ss+NMIpKeiHKKx0j0QZqISQHiEnOJFBstJEraYOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VZh7ZQsu6wXe71RiKkNG/LgBAOZ30KFVhwYqOJyWR/U=;
 b=ScnWR7Ko1/BRa3pJ4uQpM4pFy0H8DiFMmwgtlbmUaIPxLddQ0/sg0kG73us0Pw1rbeSFnAb4S17HdTIVkkq9xyZJsXwWTCqQlYkDvqx5njARdMI7erFm8c7S/hCtkXiK1t7nABgfZ1/g/HIJMk8sG+It9K10o03OVWmXSwEKBVEbGHNrvqJKI7CAcOGCplgBqVPfH5ZnRbRruNAGQ3YEEnHOx5W56Wbi+bq0ayqGLUmgnMi2jM9yS7+rf9U1PyoFL6mIWTqtiYVjm3s2Tz62wgkgglfj8Uv9mg1jARTLx966lE/tGtOg7PdjQ74PRGr+gvMvfP7nLfz58f8MD2hpLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZh7ZQsu6wXe71RiKkNG/LgBAOZ30KFVhwYqOJyWR/U=;
 b=ltVJGMly3csqZVMRnGuY1uGZbqFe5nFJ+c5K3UaSRuAcr+15gWbt27HHYFgQIDDUu/AG/Yu+oAVs4bTu3N5yBcMWMUvXppNG9L053v8JmPWnK3hfG1PRatZ/icnZL/zoF2FTfTdpkcGLUrWmvNWURmCewHEJWa330iHFHLk3fELr0L4W33tmhlV+yEbCqE5QHRmOu+cgi9UwIWUBm2nLWvRFX5spYvm2qP/rcUfa3XBN1wIy8vNPwDL7n9fmleAlAisdfqvbLqrnedShjun+qfNQRXXZAN3Fod3uNqq71yJTYJ80gLyVninyue4BGI8OgbXYyKbIzLX3owM9OdsZXw==
Received: from BN1PR10CA0003.namprd10.prod.outlook.com (2603:10b6:408:e0::8)
 by SJ1PR12MB6243.namprd12.prod.outlook.com (2603:10b6:a03:456::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25; Fri, 27 Jan
 2023 20:05:04 +0000
Received: from BN8NAM11FT110.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e0:cafe::b6) by BN1PR10CA0003.outlook.office365.com
 (2603:10b6:408:e0::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Fri, 27 Jan 2023 20:05:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT110.mail.protection.outlook.com (10.13.176.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 20:05:03 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 12:04:55 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 12:04:54 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Fri, 27 Jan 2023 12:04:53 -0800
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <kevin.tian@intel.com>, <robin.murphy@arm.com>,
        <joro@8bytes.org>, <will@kernel.org>, <agross@kernel.org>,
        <andersson@kernel.org>, <konrad.dybcio@linaro.org>,
        <yong.wu@mediatek.com>, <matthias.bgg@gmail.com>,
        <thierry.reding@gmail.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>
CC:     <vdumpa@nvidia.com>, <jonathanh@nvidia.com>,
        <iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH 0/4] iommu: Reject drivers with broken_unmanaged_domain
Date:   Fri, 27 Jan 2023 12:04:16 -0800
Message-ID: <cover.1674849118.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT110:EE_|SJ1PR12MB6243:EE_
X-MS-Office365-Filtering-Correlation-Id: e9962505-562e-442e-2012-08db00a1c760
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E56bWi9f2cQ9RTOZidH+rfkRzUPcbmeNr4SvrFn/2bblSjf69HFQnSPr95Bg6wZU733fOHOoTi5mrGsOV6ulaVSeISYTUc1qb6vDsUXfdQncNDZNHr4y5biUb4W/sWtlXRwXkhpxNbmO/D/PPl6/3/fitpdbHtPA8c3Wa0t1xVifKdbkELSfQkj9IPU1XODtSEpyVN3R9JyfGxXaZCOMzQTZWlnBYDsyvXgLutcmMfIfprYlbXxqIN94WsXw1aNlLqEpt5pBGnGCCe9IU6C4utzkC71oJRRBsiULmcO3EsG2E0iDOUtrKKJznON4KkAn3YBF8FV7+etSjw2xVbBwoNZbEbqLIDjvCgiRR2CF23Dah759h1HU3QJgmkfAqbDUhNN7ZYI4/Py2QD7uSefvxrrjeTHe+6wpDZ62kbPeDfcGd2DJ5lxTypmYFZ3mOzhFUwe7lVpyHx2ansA18zkVktJ1kUwbwK0+rWmIb2q2X4vmzHnG0j60rG0IbVkW3KjoOPY3OOkPjybpXwUHRNCTHG4Fy0C5No6wnDltKnsO6LhCrOWdAB5WRBqKwVOo/wARLkiTq2Qf/EfeSwt6A3ycJ2xIlQzYv5PHYVccqGmX4wJrFSR9YxHcfIEY4xJLcFajzm/XkaIp0IE6XOAt78Bp7t7gVpzTmflx8QXPfe7ySzfzMUDpAYb2c4qR72YcgVmhl0d78CUl4hm8j9L3EsAFGVl/c6b4CkEkyInG9Tudn7K5eOIOePo8yGtvL9pC+T1Gv8ZQr9u54mu661I7khRBsGkxE5dOcAz63T3TYH9XpTrimc2MWvWwlfccpZi/hA0I
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199018)(40470700004)(46966006)(36840700001)(7696005)(26005)(186003)(6666004)(478600001)(2616005)(2906002)(336012)(966005)(47076005)(426003)(4326008)(110136005)(316002)(83380400001)(70586007)(8676002)(70206006)(54906003)(41300700001)(7416002)(8936002)(5660300002)(36860700001)(356005)(40460700003)(7636003)(82740400003)(921005)(82310400005)(86362001)(36756003)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 20:05:03.5726
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9962505-562e-442e-2012-08db00a1c760
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT110.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6243
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

Both IOMMU_DOMAIN_UNMANAGED and IOMMU_DOMAIN_DMA require the support
of __IOMMU_DOMAIN_PAGING capability, i.e. iommu_map/unmap. However,
some older iommu drivers do not fully support that, and these drivers
also do not advertise support for dma-iommu.c via IOMMU_DOMAIN_DMA,
or use arm_iommu_create_mapping(), so largely their implementations
of IOMMU_DOMAIN_UNMANAGED are untested. This means that a user like
vfio/iommufd does not likely work with them.

Thus, mark all these drivers as having "broken" UNAMANGED domains and
add a new device_iommu_unmanaged_supported() API for vfio/iommufd and
dma-iommu to refuse to work with these drivers.

These are preparatory changes for a new IOMMU API that will be used by
iommufd. Having this flag allows us to prevent any use of the new API
in iommufd, to keep things clean.

You can also find this series on Github:
https://github.com/nicolinc/iommufd/commits/broken_unmanaged_domain

Thank you
Nicolin Chen

Nicolin Chen (4):
  iommu: Add a broken_unmanaged_domain flag in iommu_ops
  iommu/dma: Do not init domain if broken_unmanaged_domain
  iommufd: Do not allocate device object if broken_unmanaged_domain
  vfio: Do not allocate domain if broken_unmanaged_domain

 drivers/iommu/dma-iommu.c       |  3 +++
 drivers/iommu/fsl_pamu_domain.c |  1 +
 drivers/iommu/iommu.c           | 24 ++++++++++++++++++++++++
 drivers/iommu/iommufd/device.c  |  3 +++
 drivers/iommu/msm_iommu.c       |  1 +
 drivers/iommu/mtk_iommu_v1.c    |  1 +
 drivers/iommu/omap-iommu.c      |  1 +
 drivers/iommu/tegra-gart.c      |  1 +
 drivers/iommu/tegra-smmu.c      |  1 +
 drivers/vfio/vfio_iommu_type1.c |  5 ++++-
 include/linux/iommu.h           | 11 +++++++++++
 11 files changed, 51 insertions(+), 1 deletion(-)

-- 
2.39.1

