Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE3C69E3BC
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 16:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbjBUPka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 10:40:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234762AbjBUPkU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 10:40:20 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061.outbound.protection.outlook.com [40.107.244.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BA17DA8;
        Tue, 21 Feb 2023 07:40:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P6nj20rGTjF30yLzksNT9sP29jvRGMSh6ej//qeA9XqSfCcor3tWkmoLBiSVRkyuOUsxJgb4+l2QUafs2yodZYUt+hzyJwIvXuhEIeZdP2GuP5FqbFuiGE1CXeQNnUhljhe4vNE+sUAZrQkJaCj4QncfjIizhvEtJ5eDNf8P335gB1aYwKz/WRRW1a7YdxiGVImYJTm2tHk/bGBYe0ckMLHxZcdRQNgVVZcuMkxG7OHvz/NlPoLzPDAqfeg5LYz3S4+NJRWLTG29l1FOVQXdy/Gws9PyLZD4xJSdfqccErpvYHmEWtTnwn6whrB35fsvjgMI7fsPPA3hUC9rSEmG7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q3bIPZccKdbJ2AhxGH9rGe9pitXQcDhctO7uEm8gE1o=;
 b=iwFo0vTepV7gxk+gAJTfpamKmENeFf2Ud+L9x0HJkpalE/kQTKt3wrog8qAe4jq7mB7vijTDWxbiLDYa3PVxsizpliHHa7jp2lKqEwJN7TqIdZs9M9yja/ZAWPPvXfdLO8VLFKNTUxVivRrEuqdvW3os+IqOAshN4TQABifYXR91ZZF/UfHI25iE3w1nkvPbtEtzSIkyCR8yiRDXlgjxsXYviaCVgO9HpVK9oXyBVVNa0bz+MRYKk+zGDsPD84n7FhKlrvxuctFSYUEbKOSi3Uo2lpkRzsFUpUdtgVjWeF/zCJKI97+iCyc4ofX+rRzeHnF1sRS+CAI5ePRZziCLgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q3bIPZccKdbJ2AhxGH9rGe9pitXQcDhctO7uEm8gE1o=;
 b=Gil29Vuiq2zH8tFhBINJiS4tf1R6njNBriH7p1954whTWt11qle3V+AbNiDVEXHW6JYt2ljKQALUA/mvlBLvB3rAlHwvT6y78H0cQyQ6KfRbHoRECVYGkMu4HrsSO6mt5XpwadSuWqy0+dElWBhbcPeBGE5l86ptbFOW//rl0DVNQArYzKhJGh2MYZ4RxF/jlGBrt+LKRBG222WiLyWXFseZrOAZSLNQLqOb2CbGXZfbgSPVQBrNiYkI7HV20YCxby23ScGiQMV7/hx43zTuIHqpM0Ydfg8ns8S5ymGoWAsw9ZCDKl0hrJZQh5jxncPFpkVXfjU/Gr6ZHvJwSgT4Lg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB8060.namprd12.prod.outlook.com (2603:10b6:806:343::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Tue, 21 Feb
 2023 15:39:52 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6111.021; Tue, 21 Feb 2023
 15:39:52 +0000
Date:   Tue, 21 Feb 2023 11:39:51 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <Y/Tlx8j3i17n5bzL@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5XsTzcB5BGJvgAK9"
Content-Disposition: inline
X-ClientProxiedBy: BL1P221CA0012.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB8060:EE_
X-MS-Office365-Filtering-Correlation-Id: a2c9664b-5c50-4255-e834-08db1421df7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s1gakRWquBCMVlGr+pk46WyyeXrmZj9cnw4TT0AxYcm6SQWrfZOB31b3dlyW1COhPrBjHpaWIVt2/84SQYhatBP0j2Huc6Uo8VbleQx7fQkvOOX7qYPHGINZWM2yUWE26MDaseIAD306VUiliBmEBo7lRdeP62MKJb3PCdsLRB673eX+2tTMDx3G7wRYQEtV0kOQ5kW1UxdVPQ5GWqBiHblHrmMwtVcBiUNIi3+exXxc0s7dvjhOqc2xsg14iGQiASEVGeS7FrM3jnaRZVCi0wWO099zdOXs5jmIEgd4lDm6oyNWI8N3j34QhTkSrs5wKrmM+5C5rRGtK/wTqSsEapIO3JU2nra+fbd5cIAdblA36VjD0BfSajUR8+ia6PPHvN9+hpX03G1G2yFfq3p+qYgJ1XoHOf6C/DwFsHZdnL7sQ18pKEDzP2h0GEaTxImxHFBcBKltpZy9/XPsTOs7DMWCuqPDxnzE94ua7RB9LT5DOHjXbv3W3iL9oyDtNuyU4LdjR0dYeZSeVi+mj+/2FG6afFIMMdaWlVESEzILoH3uQUlBeGDXKjXqQ5ymaM7LjlHC7sdb+5kgSM26ltgKrKGwgUZeJU2nHpav2py7JCK2Ao8eVkatPRD6DkgC6+Lt5lKo87BpcJ+LxuR3u77ads43Ba5g86h0dzMg5RIGlRG7bm5Kak56d+P9yB2uvzuVguU21kcSSslPWwQBC1CmctkDCP9GkF0eNnGzQAaMvAiP8bcCSEpkiHtObVlifanl2maAb2DLmsavIqRtfyk9xg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199018)(26005)(6512007)(966005)(186003)(6486002)(2616005)(83380400001)(21480400003)(44144004)(6506007)(478600001)(316002)(66476007)(66556008)(38100700002)(4326008)(2906002)(66946007)(8936002)(8676002)(41300700001)(6916009)(5660300002)(36756003)(86362001)(2700100001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7DTxNYluZzmS5hei1mfN8h30vycpVstp+FR6rZGdYdl3hinvVceidX3rvZMz?=
 =?us-ascii?Q?tYritrUDz5PD/gFIWYjcGrnKhDSy9cu2YL3u1Tc6yrFObQ2pA418DllLl6rO?=
 =?us-ascii?Q?Mv/wp44qbm+h+0f2lcNEkTRYI67ChzMUEjmfcNIlfjetq0ZRh7fhrfZCyXPy?=
 =?us-ascii?Q?PONJf6RCc4xe5QMNFjPi12TtHAWBc7VHugDTy5heMNtC9mIweFUXqbT3Fcsu?=
 =?us-ascii?Q?WhoQDhcaeeCpH6vX8uDaMUvySEqOpwXwRT23b5WC0X7qlWwy7pxeTDFVcEU2?=
 =?us-ascii?Q?IlZvoX6LiE1OC5UetFzRypR0Qy2f1Ck5+3vu62NYQnfo7xMZBNNrFFIs979u?=
 =?us-ascii?Q?c0GkscBVZCV8XWOe0xQq9iF1mZofcxmAYlqesd571g/Uj6VcZX2JmDG85rwO?=
 =?us-ascii?Q?OzVZyzM6FNjMgA68MRDU9oCV/I8QClAH0j/wTCot5QEMBuMaEAeX6dKRuQpK?=
 =?us-ascii?Q?6c8ANbgt81tXY3926lgOAIXxBorRydaV5Cbruozh3/JeicjeO9T0fQFe0GUX?=
 =?us-ascii?Q?XtrFKtfw1+xaYfJ6dkFGe+VZnRfSsfcbPjrHs1Rt77t3KfV/TSVOTuSZg0W6?=
 =?us-ascii?Q?pU0Evde8UVTVLdineNEEWK7FUTFL3pxIuFnnN5Fe/ka6i6HckjoXtFN6pO1S?=
 =?us-ascii?Q?AkyZbISMceaKNvNcR0vxHUi9+COQggWMysoHkdAORSxZKrAU8yJZMC2DpftA?=
 =?us-ascii?Q?GLtgvwmyld6DY5cEILXzbxrF+tTHk1aKp5TAXBmoVFoGN7q+zX6TqTqw3Ryo?=
 =?us-ascii?Q?TX0QZE4rUYtnQp1S/7WcwvHncCvO8TerV0GEsRhLTizYnaHTRc3mfq3xgmby?=
 =?us-ascii?Q?6kMlbsQqcwCPkesD1w3NR1bUm2nkT5e74AGRFTY4ZCvhBKSmfXmImehDTVUm?=
 =?us-ascii?Q?cgxWTLZtXWfSoGiZi4I/M23RCKPuGWFy7seCGL3HYH7mYzIemyNpyxtrb8YX?=
 =?us-ascii?Q?im1UC84f2QnWq0jreg10B8Pp/9FT7MQ90GHBMz6p/SK3oHIuDViDbiZIiinM?=
 =?us-ascii?Q?E1wkg/IJVrHUzICPwR4En3z271ohd2aFvyL//o5K682a73UfBYikF7doC0T4?=
 =?us-ascii?Q?uqvouTLfTfGJ3VomzP3LgxcLgK5Z5ra2XLZRobfoyTX9/N1n+CNB6ZFaVIgA?=
 =?us-ascii?Q?7/3Y0G1t7AZOUH0ZIUIYEbNNR/JlM0ZsmuddC6UON9czaPoN3Fao2nMa+Ttg?=
 =?us-ascii?Q?bEYJXJIK/2WCD9u3f8HM22A/Id6K1/91kssDFlAzd433nl/v3vQ/E1BWtVNk?=
 =?us-ascii?Q?oWJd4JSslnJOeNXqFNNLGkm2BLPXN1F39yVj3gg7Bere9ZZFVzLmAntM9plL?=
 =?us-ascii?Q?l8l+Gso9zAADIKEwHohI3y+mYHREEkk0hINsHAvHPEieZKt1fUDhhnv+pwvu?=
 =?us-ascii?Q?B1gGcBX0inaJlaStATuCUjLrFIfHTb1/LOv9YuKxHnUztNlzifQeoFIFoi6T?=
 =?us-ascii?Q?Ryb7EEvXgDE1Abaz+pZ5SD+lsOJc+WapYFnZ0fZHsUShsl+OAuJvWsB3ffvJ?=
 =?us-ascii?Q?YvCtGHb/L/5gnqi/98UNVaP8NrLt3+BlLFqf64ThfzkWsI3HY5FFyVFSs1/P?=
 =?us-ascii?Q?8ZrG50qBQzfS051w6eZp1En/zI64YeqFNzUoicQj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2c9664b-5c50-4255-e834-08db1421df7a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 15:39:52.0469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pkeKII4Zwu9rxPNt8aNTkT+b7eW6vQmsw2jjvj9hIHFHNEklsk9VoVR8RR971hwr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8060
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--5XsTzcB5BGJvgAK9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

This PR has a few smaller updates related to iommufd. Several big topics are
currently still on the mailing list in review:

- VFIO device cdev support to allow exposing all the iommufd features:
  https://lore.kernel.org/kvm/20230221034812.138051-1-yi.l.liu@intel.com/

- iommufd page table replace operation:
  https://lore.kernel.org/kvm/cover.1675802050.git.nicolinc@nvidia.com/

- IOMMU driver information query:
  https://lore.kernel.org/r/20230209041642.9346-1-yi.l.liu@intel.com

- Intel VT-d nested translation:
  https://lore.kernel.org/r/20230209043153.14964-1-yi.l.liu@intel.com

- Draft patches for ARM SMMUv3 nested translation:
  https://github.com/nicolinc/iommufd/commits/wip/iommufd-v6.2-rc5-nesting

Along with qemu patches implementing iommufd:
https://lore.kernel.org/qemu-devel/20230131205305.2726330-1-eric.auger@redhat.com/

And draft patches for the qemu side support for nested translation.

This PR has a shared branch with Joerg's tree changing the signature of
iommu_map() to add a gfp_t. There were some conflicts with v6.2 which I've
resolved in this PR and there will be a conflict against the rpmsg tree:

 https://lore.kernel.org/r/20230127180226.783baf07@canb.auug.org.au

--- a/drivers/remoteproc/qcom_q6v5_adsp.c
+++ b/drivers/remoteproc/qcom_q6v5_adsp.c
@@ -367,7 +367,8 @@ static int adsp_map_carveout(struct rproc *rproc)
        iova =  adsp->mem_phys | (sid << 32);

        ret = iommu_map(rproc->domain, iova, adsp->mem_phys,
-                       adsp->mem_size, IOMMU_READ | IOMMU_WRITE);
+                       adsp->mem_size, IOMMU_READ | IOMMU_WRITE,
+                       GFP_KERNEL);
        if (ret) {
                dev_err(adsp->dev, "Unable to map ADSP Physical Memory\n");
                return ret;

Thanks,
Jason

The following changes since commit c9c3395d5e3dcc6daee66c6908354d47bf98cb0c:

  Linux 6.2 (2023-02-19 14:24:22 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to 939204e4df962982cbc84acc26b29b421dd530a8:

  Merge tag 'v6.2' into iommufd.git for-next (2023-02-21 11:11:03 -0400)

----------------------------------------------------------------
iommufd for 6.3

Some polishing and small fixes for iommufd:

- Remove IOMMU_CAP_INTR_REMAP, instead rely on the interrupt subsystem

- Use GFP_KERNEL_ACCOUNT inside the iommu_domains

- Support VFIO_NOIOMMU mode with iommufd

- Various typos

- A list corruption bug if HWPTs are used for attach

----------------------------------------------------------------
Jason Gunthorpe (26):
      genirq/msi: Add msi_device_has_isolated_msi()
      iommu: Add iommu_group_has_isolated_msi()
      vfio/type1: Convert to iommu_group_has_isolated_msi()
      iommufd: Convert to msi_device_has_isolated_msi()
      genirq/irqdomain: Remove unused irq_domain_check_msi_remap() code
      genirq/msi: Rename IRQ_DOMAIN_MSI_REMAP to IRQ_DOMAIN_ISOLATED_MSI
      iommu/x86: Replace IOMMU_CAP_INTR_REMAP with IRQ_DOMAIN_FLAG_ISOLATED_MSI
      irq/s390: Add arch_is_isolated_msi() for s390
      iommu: Remove IOMMU_CAP_INTR_REMAP
      Merge branch 'isolated_msi' into iommufd.git for-next
      iommu: Add a gfp parameter to iommu_map()
      iommu: Remove iommu_map_atomic()
      iommu: Add a gfp parameter to iommu_map_sg()
      iommu/dma: Use the gfp parameter in __iommu_dma_alloc_noncontiguous()
      iommufd: Use GFP_KERNEL_ACCOUNT for iommu_map()
      iommu/intel: Add a gfp parameter to alloc_pgtable_page()
      iommu/intel: Support the gfp argument to the map_pages op
      iommu/intel: Use GFP_KERNEL in sleepable contexts
      iommu/s390: Push the gfp parameter to the kmem_cache_alloc()'s
      iommu/s390: Use GFP_KERNEL in sleepable contexts
      Merge branch 'iommu-memory-accounting' of ssh://gitolite.kernel.org/pub/scm/linux/kernel/git/joro/iommu intoiommufd/for-next
      vfio: Support VFIO_NOIOMMU with iommufd
      Merge branch 'vfio-no-iommu' into iommufd.git for-next
      iommufd: Make sure to zero vfio_iommu_type1_info before copying to user
      iommufd: Do not add the same hwpt to the ioas->hwpt_list twice
      Merge tag 'v6.2' into iommufd.git for-next

Nicolin Chen (1):
      selftests: iommu: Fix test_cmd_destroy_access() call in user_copy

Yi Liu (1):
      iommufd: Add three missing structures in ucmd_buffer

 arch/arm/mm/dma-mapping.c                          |  11 ++-
 arch/s390/include/asm/msi.h                        |  17 ++++
 arch/s390/include/asm/pci_dma.h                    |   5 +-
 arch/s390/pci/pci_dma.c                            |  31 +++---
 .../gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c    |   3 +-
 drivers/gpu/drm/tegra/drm.c                        |   2 +-
 drivers/gpu/host1x/cdma.c                          |   2 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c           |   8 +-
 drivers/iommu/amd/iommu.c                          |   5 +-
 drivers/iommu/dma-iommu.c                          |  18 +++-
 drivers/iommu/intel/iommu.c                        |  38 ++++----
 drivers/iommu/intel/iommu.h                        |   2 +-
 drivers/iommu/intel/irq_remapping.c                |   3 +-
 drivers/iommu/intel/pasid.c                        |   2 +-
 drivers/iommu/iommu.c                              |  77 ++++++++-------
 drivers/iommu/iommufd/Kconfig                      |   2 +-
 drivers/iommu/iommufd/device.c                     |   8 +-
 drivers/iommu/iommufd/iommufd_private.h            |   2 +
 drivers/iommu/iommufd/main.c                       |   3 +
 drivers/iommu/iommufd/pages.c                      |   6 +-
 drivers/iommu/iommufd/vfio_compat.c                | 107 +++++++++++++++++----
 drivers/iommu/s390-iommu.c                         |  17 ++--
 drivers/irqchip/irq-gic-v3-its.c                   |   4 +-
 drivers/media/platform/qcom/venus/firmware.c       |   2 +-
 drivers/net/ipa/ipa_mem.c                          |   6 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |   2 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |   4 +-
 drivers/remoteproc/remoteproc_core.c               |   5 +-
 drivers/vfio/Kconfig                               |   2 +-
 drivers/vfio/container.c                           |   7 --
 drivers/vfio/group.c                               |   7 +-
 drivers/vfio/iommufd.c                             |  19 +++-
 drivers/vfio/vfio.h                                |   8 +-
 drivers/vfio/vfio_iommu_type1.c                    |  25 ++---
 drivers/vfio/vfio_main.c                           |   7 ++
 drivers/vhost/vdpa.c                               |   2 +-
 include/linux/iommu.h                              |  33 ++-----
 include/linux/iommufd.h                            |  12 ++-
 include/linux/irqdomain.h                          |  29 +-----
 include/linux/msi.h                                |  17 ++++
 kernel/irq/irqdomain.c                             |  39 --------
 kernel/irq/msi.c                                   |  27 ++++++
 tools/testing/selftests/iommu/iommufd.c            |   2 +-
 43 files changed, 369 insertions(+), 259 deletions(-)
 create mode 100644 arch/s390/include/asm/msi.h

--5XsTzcB5BGJvgAK9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCY/TlxQAKCRCFwuHvBreF
YRpnAQDTvcfKDA2P2XHTAiwOSItwqvdjbjKeIfpiyFVdXWn3ygEA60i4dPMSeb7D
tvMlUKkhd3EiQKca4cxciXRag9bAmwY=
=pvdS
-----END PGP SIGNATURE-----

--5XsTzcB5BGJvgAK9--
