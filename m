Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8DB6FD44F
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 05:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbjEJDe1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 23:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjEJDeX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 23:34:23 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D2F1FEE;
        Tue,  9 May 2023 20:34:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/JdbTgYTyeJ7/b0z/nG6pbbrVPGdqIOCUZq5G027LCNHfLdQ8dmyT3CqDGwPzFf+AfWkZuKfXtuuPq/rlrU+UEVvKowkwjlIzHZcAaZGgtSthPHQq/8RwK2/L6zTOnv6dg8oK9yXi0Ii4atzyA4WEX7ReoAVs10Ef0PnGp05C1jHSisO8x4rnkUGSO+pA95savdBmeeSqHhEdydjlWYYe8JziCXDFcC6niC29/INtPszycxlQAqQ7OQpki/4YoSPc1XS632vaN9ffqS3UhAIBJzizbzAgmDwms+TrlsIQ/PELmywzKqdR5RhFohVH50CS9C0QxNEX9UsP1k/uR1yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nm6vv8W4uGmWfFQfyrhHXkdlgjCGnzbDiQoV8M71IgA=;
 b=RX5tENLRMZyex1Eta3YKippdV4hTZuoGIajweFS4rlDfdF5okrvwzLvnGjBSI+Ix2AjdFPYg5Y1H/YSNpZE7B/u5Lvwp9b9txmrzRUBrTC2g85olfOMho7ERQW/jSpWkmi142+CDEVM2q3XahqOpK7FlYBGBUOJMJaakEdSzrfLDIQNnXUalEynR6iAWpxG4hdyabkt8kC/epsoEGuADuSNhfNxZr0S37hJ5ZbSK2oljFvIln3CPNf0NpHqeVgZJGpvvW/ncHSybToHFdbEZ2BnXa6QYzuLFJIE6sIRZTBip4+iQ3i1gLutU9/0X3c/E88EYVcy/h8/4Ks3eSw+Q+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nm6vv8W4uGmWfFQfyrhHXkdlgjCGnzbDiQoV8M71IgA=;
 b=dWQh9hozFuZ2a5PemsWGddVe5t4+JG5Bvvvgl3SaOIM4XOxqBHKu8EFVOl7VJS4UoOK7z5xnrdXm/hCk8l/P4i4KSOLO5RcRXhvJoikiPtwTP2JdisKx+ebHf/Dr9k7SGKz1WW3KIMN1O144pDvOEWtB+1SuVsHfv5d/Qgx72IZnaV3jSaDxFvmqORqGB/Eh6ZLVDBRG9LcASxoKhMCw/lmk6n/k4BAQTHJ6LuDsJtiCZBJkk6CjA+AmM7BLInAwz76QI9LNPMng2qCGnyVPvrTvhzMflI00p89hdeC73Je8OLfTY7vKoZ/YtOyjQL/i34Atqf6/AB6Ig2q9fPDTDw==
Received: from BN0PR04CA0002.namprd04.prod.outlook.com (2603:10b6:408:ee::7)
 by PH8PR12MB7421.namprd12.prod.outlook.com (2603:10b6:510:22b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 03:34:17 +0000
Received: from BN8NAM11FT072.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::84) by BN0PR04CA0002.outlook.office365.com
 (2603:10b6:408:ee::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18 via Frontend
 Transport; Wed, 10 May 2023 03:34:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT072.mail.protection.outlook.com (10.13.176.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.19 via Frontend Transport; Wed, 10 May 2023 03:34:16 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 9 May 2023
 20:34:08 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 9 May 2023
 20:34:08 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Tue, 9 May 2023 20:34:07 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <robin.murphy@arm.com>, <will@kernel.org>
CC:     <eric.auger@redhat.com>, <kevin.tian@intel.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <shameerali.kolothum.thodi@huawei.com>, <jean-philippe@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>, <yi.l.liu@intel.com>
Subject: [PATCH v2 00/17] Add Nested Translation Support for SMMUv3
Date:   Tue, 9 May 2023 20:33:20 -0700
Message-ID: <cover.1683688960.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT072:EE_|PH8PR12MB7421:EE_
X-MS-Office365-Filtering-Correlation-Id: c8fef9d5-1b92-4e49-996b-08db51076ecd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ExxKo/F9E0Kk+gLakoFqjxqlvRofUzbtHQtHp5kpCe+EsgasCHDSQYitSHGWNlAP4xUG9yA9611KSzeGyXYRahvAyU+gcfxGTKnMA3J/G4qocWl6upJUaz2VEO7tlR6LSDYGa/KHQhTUoZVmqhvGKB413dktbpD2MaIrIxROfbm/UvSL4sWbctGXKXJrlI9nfmW29wuqbS3c/rqCelNGnb+JO856xlDRQB6Snek7kr6angWqeABFQb9WDQBeuGOWjyd8VKFr62qwLW0tN/KeOB/djuXg6XizNj2XhnensT6wJfPopJPSZbsR1s7Lq8008HTaElB7hszuiCg61mUaCSgJXNiLk96evxkmpa9rLizlycGqjdH5nbn2raF8lpviS4ls+6yhsPCU4YtX+0iTWc+ITAGCBHg0r78DAYSn/cOHUv9yx2V8hSznv9fwVhdjTGkzJtDj2RvboyOHAy+rEtRGCerFZI48NQepxNjSB3HAoozPS0Fg0C0S9jV6tDQdf62Egu1sjyda8I4O64vyCDimrfpyTuNmxVp8kcv3QvOx63R7BEYaRlorWANgBPUlQ07vwXazbMt+mN8DXAXMRf63BB8supw35Go2SooYQfyFHR41/lPshdHsHO8K4in7sK0LmcHhrtDq6cBkWfCWuf6MrDrbrRcC5TVRbJFVBx+BtNgd0Hcj+0WdMvpIzibJQa9b+mmYp0ODb1SPM28xoKjP9w2mFYkkJUySDSboZwFKnK59TKVn5UMTKEaRCTaytCaEl1EOlvWdyI/gTNSN3q3vjYm/HAVMn0N6Hi3N+P1eAhH1u4W018ErXYl7H3So8gW4gWUptUXng+584r3Bjg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(136003)(376002)(451199021)(40470700004)(46966006)(36840700001)(5660300002)(110136005)(41300700001)(47076005)(316002)(4326008)(70206006)(70586007)(26005)(478600001)(8676002)(7416002)(186003)(8936002)(6666004)(7696005)(966005)(54906003)(40480700001)(40460700003)(2906002)(36756003)(7636003)(356005)(426003)(336012)(2616005)(36860700001)(83380400001)(86362001)(82740400003)(82310400005)(473944003)(414714003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 03:34:16.6771
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c8fef9d5-1b92-4e49-996b-08db51076ecd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT072.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7421
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[ This series is rebased on top of v6.4-rc1 merging Jason's iommu_hwpt
  branch and Yi's vfio cdev v11 branch, then the replace v7 series and
  the nesting v2 (candidate) series and Intel VT-d series. Note that
  some of them are still getting finalized. So, there can be potential
  minor API changes that would not be reflected in this series. Yet, we
  can start the review at the SMMU driver specific things.

  @robin, the hw_info patch still requires the errata patch that you
  mentioned. Perhaps we can merge that separately or include it in v3.

  Thanks! ]

Changelog
v2:
 * Added arm_smmu_set_dev_data after the set_dev_data series.
 * Added Jason's patch "vfio: Remove VFIO_TYPE1_NESTING_IOMMU"
 * Replaced the iommu_get_unmanaged_domain() helper with Robin's patch.
 * Reworked the code in arm_smmu_cmdq_build_cmd() to make NH_VA to be
   a superset of NH_VAA.
 * Added inline comments and a bug-report link to the patch unsetting
   dst[2] and dst[3] of STE.
 * Dropped the to_s2_cfg helper since only one place really needs it.
 * Dropped the VMID (override) flag and s2vmid in iommu_hwpt_arm_smmuv3
   structure, because it's expected for user space to use a shared S2
   domain/hwpt for all devices, i.e. the VMID (allocated with the S2
   domain is already unified. If there's some special case that still
   needs a VMID unification, we should probably add it incrementally.
 * Move the introduction of the "struct arm_smmu_domain *s2" function
   parameter to the proper patch.
 * Redefined "struct iommu_hwpt_arm_smmuv3" by adding ste_uptr/len and
   out_event_uptr/len. Then added an arm_smmu_domain_finalise_nested()
   function to read guest Stream Table Entry with a proper sanity.
 * Reworked arm_smmu_cache_invalidate_user() by reading the guest CMDQ
   directly, to support batching. Also, added return value feedback of
   -ETIMEDOUT at CMD_SYNC, and reported CERROR_ILL errors via the CONS
   in the user_data structure.
 * Updated data/functions following the nesting infrastructure updates.
 * Added/fixed multiple comments per v1 review inputs.
v1:
 https://lore.kernel.org/all/cover.1678348754.git.nicolinc@nvidia.com/

--------------------------------------------------------------------------

Hi all,

This series of patches add nested translation support for ARM SMMUv3.

Eric Auger made a huge effort previously with the VFIO uAPIs, and sent
his v16 a year ago. Now, the nested translation should follow the new
IOMMUFD uAPIs design. So, most of the key features are ported from the
privous VFIO solution, and then rebuilt on top of the IOMMUFD nesting
infrastructure.

The essential parts in the driver to support a nested translation are
->hw_info, ->domain_alloc_user and ->cache_invalidate_user ops. So this
series fundamentally adds these three functions in the SMMUv3 driver,
along with several preparations and cleanups for them.

One unique requirement for SMMUv3 nested translation support is the MSI
doorbell address translation, which is a 2-stage translation too. And,
to working with the ITS driver, an msi_cookie needs to be setup on the
kernel-managed domain, the stage-2 domain of the nesting setup. And the
same msi_cookie will be fetched, via iommu_dma_get_msi_mapping_domain(),
in the iommu core to allocate and creates IOVA mappings for MSI doorbell
page(s). However, with the nesting design, the device is attached to a
user-managed domain, the stage-1 domain. So both the setup and fetching
of the msi_cookie would not work at the level of stage-2 domain. Thus,
on both sides, the msi_cookie setup and fetching require a redirection
of the domain pointer. It's easy to do so in iommufd core, but needs a
new op in the iommu core and driver.

You can also find this series on the Github:
https://github.com/nicolinc/iommufd/commits/iommufd_nesting-v2

The kernel branch is tested with this QEMU branch:
https://github.com/nicolinc/qemu/commits/wip/iommufd_rfcv4+nesting+smmuv3-v2

Thanks!
Nicolin Chen

Eric Auger (2):
  iommu/arm-smmu-v3: Unset corresponding STE fields when s2_cfg is NULL
  iommu/arm-smmu-v3: Add STRTAB_STE_0_CFG_NESTED for 2-stage translation

Jason Gunthorpe (1):
  vfio: Remove VFIO_TYPE1_NESTING_IOMMU

Nicolin Chen (13):
  iommufd: Add nesting related data structures for ARM SMMUv3
  iommufd/device: Setup MSI on kernel-managed domains
  iommu/arm-smmu-v3: Add arm_smmu_hw_info
  iommu/arm-smmu-v3: Add arm_smmu_set/unset_dev_user_data
  iommu/arm-smmu-v3: Remove ARM_SMMU_DOMAIN_NESTED
  iommu/arm-smmu-v3: Allow ARM_SMMU_DOMAIN_S1 stage to access s2_cfg
  iommu/arm-smmu-v3: Add s1dss in struct arm_smmu_s1_cfg
  iommu/arm-smmu-v3: Pass in user_cfg to arm_smmu_domain_finalise
  iommu/arm-smmu-v3: Add arm_smmu_domain_alloc_user
  iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED type of allocations
  iommu/arm-smmu-v3: Implement arm_smmu_get_msi_mapping_domain
  iommu/arm-smmu-v3: Add CMDQ_OP_TLBI_NH_VAA and CMDQ_OP_TLBI_NH_ALL
  iommu/arm-smmu-v3: Add arm_smmu_cache_invalidate_user

Robin Murphy (1):
  iommu/dma: Support MSIs through nested domains

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 461 ++++++++++++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  11 +-
 drivers/iommu/arm/arm-smmu/arm-smmu.c       |  16 -
 drivers/iommu/dma-iommu.c                   |  18 +-
 drivers/iommu/iommu.c                       |  10 -
 drivers/iommu/iommufd/device.c              |   5 +-
 drivers/iommu/iommufd/main.c                |   1 +
 drivers/iommu/iommufd/vfio_compat.c         |   7 +-
 drivers/vfio/vfio_iommu_type1.c             |  12 +-
 include/linux/iommu.h                       |   7 +-
 include/uapi/linux/iommufd.h                |  83 ++++
 include/uapi/linux/vfio.h                   |   2 +-
 12 files changed, 538 insertions(+), 95 deletions(-)

-- 
2.40.1

