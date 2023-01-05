Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A3565F4AC
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 20:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236180AbjAEThR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 14:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235968AbjAETgI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 14:36:08 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338EB18399;
        Thu,  5 Jan 2023 11:34:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J34QSeXyJRqJAuo6jNqCb2disYaj0ZgqAzW5+zAVGSRTGDibhwqkrGto+8Qz7mcK9zeDPkVuXpLSqCTjNuwW6jvm1ogcRBvDgBwQ3Ns9OKREz8ysCAVLswSVL580I+6KgtUBfKsjUlTw67hiC7r20SlvlNyo9axhJoM2Ts5DAzRarIPJZM12l7i5RQn28S4/bQAkIm+kVt5cd8SOVdl/0F3smMe+f2zhMVwSXXQcrkUpJRzIklK7EHrO8b+/xqLezeZUudXhuOekiHyQUmTNqhLTJGaNDD9IPMOFxazyPphQj0c/8eNMK33VNoa6CSPKnnSLoVp8s9Nf5gDJNhcRWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vydri3ueFcEWwcTaRdAjuiH3I1ynRaf6NAEyjiwVSv4=;
 b=DXQay7S/F1nK6SZ9DvrEr0WgFAfxHpzNNgAEX4+Y+V6/sfsN2AAxUxOJxhe5Y8MxZxRePqd69Q8usZZ5AwpJwcqZ7bTLmUZYpEika+kPvARD2rIteAtDCbqMalJFrUo3gv/XPizy62thgLttBDdaIPEWwb+J560cSRFCg+x+Dfq3Y1V67lc0hciv4E5IYSH4Y/RqQ47j0/0L3afM8RRFN0+WJNA1H5BeAz3OPiTW8D3ClSExXcdPi0Tq02cq5p5mZPobzFwAB3Q0fEDphJgKIa+ZRLBco2qx3Qc7IvT+lIc6uAUC+X3s9Yl/WXV5RPlEmMkGTkvNqczU7Y53L9cZyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vydri3ueFcEWwcTaRdAjuiH3I1ynRaf6NAEyjiwVSv4=;
 b=bP+Ef7flRApfqqOadIYOf1O+BplCFykRhaf2+WR7El8CqKmgQCvba112tWiUE9dCkrFDvkr2AeICsn+2GPLLitd6W9btsgXvoGd9aHGsLPC2yCIgnontlS74e8QBiR0zKetdAvr8IdCSos5kLRRpIW8Udds2ttUEUeiMaQ2quvLPFm2YyS3XAYr5RyD2zBdBOTbkgz2xShddRPPPOtbgOOlPITqyvAeTbq3mX+P4tVJMl8H5p6wFksIChoy2NTRHVIZPNwt19FWqeQ07uyxekE6wnrAtsNNT6n2G0LKdIg1xvP5ZqS7KdfyT64x35pTwzDPvvnLxinj1ZZdfamuEDg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA3PR12MB7950.namprd12.prod.outlook.com (2603:10b6:806:31c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 19:34:02 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 19:34:02 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>
Cc:     Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH iommufd v3 0/9] Remove IOMMU_CAP_INTR_REMAP
Date:   Thu,  5 Jan 2023 15:33:48 -0400
Message-Id: <0-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR02CA0036.namprd02.prod.outlook.com
 (2603:10b6:208:fc::49) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA3PR12MB7950:EE_
X-MS-Office365-Filtering-Correlation-Id: 8579ec91-fd04-4d6a-bc3a-08daef53cbf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bI2jCNI8qrXuuZ2LWa2I2nhTEj7wkwOmel2VVQdYXYuU9lD8IoJQbJiJTJdSpocUfyH5EMBP/Y2Gx8ro/wPIBumBAuQjMHAXnOI6GXwFBuUqog4LEdujss5n5dXV/92/n4hxwCAtwozPu0bJAQ/1aarfkQ6H6IFulngsHQjSgh3f3VLpWsZKANfxNlc+DXYBHVEsEvWNia5h8ldWyIxo/A0YdGkgbPrkq4+RMwWLfTFZBFjKK43r7rLdijT7UWnEb6sxVyWp3ACMTERN7FJsjoPjvWmuFztfrTqFRgJwe13Ja2ipk5K+Iu8c778GgKSsefZsDd1XqJZvGgtIXhVje+UlGuyvBWpslJvGJRl1Lf8qzG5LVdSd95EEfwjdscnuWWsacx0+OdOWkrmtsKjZJiWzgnRgf5Ajc8WvEdGNpD5swHOnSFkS6303Ri5hVVqK2voi1dOIK26FjQ9sAqL1AmBGzRlmSS3JMiHmVv7qp0pXplxQ+grihslu3SkrZE7RIq3WvBFaOyg4QGapq5SONTlu36HeprnspoPsxKMykx/cKGm4AdsKmmxJ0kEry5U9KnNae5BXbzehDYU9nRfaeKaZXr5p0zwYVpEbAxEuUCj5rpIEqTxuUazxhLSA8LzQfdKPqENWQfp82tD4y8dgXEE150xK96LVMzAcnQIkfp9ubrxFy8pOFfenpAQmNSewCTdxXWMcsk3kru78s+zLtZFMstPmXFltDS335mnauzCCT9YAzNlzHLXYLkwObJVoQEH36u9prZ6pW+3KT+T9LOXHX0f8gVazEBWKGfoNmYYfrK/dOsIJTiiLfjCHMSDE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(451199015)(66556008)(7416002)(41300700001)(4326008)(66946007)(5660300002)(66476007)(8936002)(8676002)(110136005)(54906003)(2906002)(316002)(6506007)(478600001)(6512007)(6666004)(26005)(186003)(966005)(6486002)(86362001)(2616005)(83380400001)(38100700002)(921005)(36756003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tD0WlkUioTpasb/JHAB9zgoFhCWR4fI9sam2ptMZtI0cST92aBX7nY/gOLeY?=
 =?us-ascii?Q?1hTqdDBfmSq4dHZhOXauhuCXN3ors6SVU7Hep/TFZ2ADpL2S3zVuVjGwUdBU?=
 =?us-ascii?Q?A1muhKC2wII3JHVCodMO6gybmXIOqOxYPNhadG6D8MXNCZMipZxY/su0oZt7?=
 =?us-ascii?Q?TFza5sR+PPNxO/lAlYEsMY/0pkSg7iFHdNXqpY+uwaIBDWHtGuPjAWJ+4p0S?=
 =?us-ascii?Q?oPAIc9GG8o9kJzdygFTixRvV+xTVkHR/ki4FV0Roky3owShEMGuvQe4Lbiuu?=
 =?us-ascii?Q?rCURaHMcHsNQY/7U4hZlHJmK4n81LaxRgl2R7G4VBj6j5RITrBb5Lb4jdD/P?=
 =?us-ascii?Q?F4G7lWnbhtedYIbKewIlVl0lHC6uuatD8p+A+NBIDpYJDSl/eFCDPwdu4nM1?=
 =?us-ascii?Q?jzanJ5qRCFn49aV4wf5qTftDrKo6IU/WX1/caMoUifqqs4fnVKb7yuJZmszT?=
 =?us-ascii?Q?5ClgjACnMW8UbYsQHHsmMH7fX6sOgvDBvwmxvG04iFPlW81LZNdTu5maXshE?=
 =?us-ascii?Q?HA0JiJ4ysbGeaDBRmnxs5EuEhGLaaj33ddg7p2Zpj4lZv+QHUVAwieCpwmfc?=
 =?us-ascii?Q?akubpjPOw5fqmpvVGdrZRTPYi3ZvjkKi8sKHCkJS8eMTYRdFXq3MK7S19gvT?=
 =?us-ascii?Q?UBaU0yn+ueVdX5QsXEpz9L3ipzl6H7wA3sjM9H8WVNZfyd4aoYOIsMDk0otn?=
 =?us-ascii?Q?lVcBdZl/3ILR2Jjzohg8jgTi6DkLU5wP8Q4bYJQ9WyTgxz9ugUGQWgO7Cudg?=
 =?us-ascii?Q?+jd/9PA5uiM/hL75pdj7KuAzFjC/9xHtlHe0TeF9oEN3vDtTjxdILwPKNrku?=
 =?us-ascii?Q?yFAg6BB8fzMDk+Sc5NBTuOKw3Gu7+BALYfU92WLu6ht4HSuI4zKL/cSxfaq9?=
 =?us-ascii?Q?UH9QQMVgqwMb44yY49JcIuj2upBPDtk3elvM2kUxk92DOvp7sfMXWwu4hvEe?=
 =?us-ascii?Q?J7Sx1dE3pHSAEvh0v1fT0zyKZblNMFf7krdqcFjlJBH3klaNP8BuJHWJbjUb?=
 =?us-ascii?Q?PcRyFASdT0VSr0szzRouuOEVGayZ57nlDxkCS2fpYdLcNe7jM8fHKT/7dO4c?=
 =?us-ascii?Q?pXaVSIrSNc22hsqks63aOcI/Z+Un4qcmdoLPkIFRqDsi7HHtlXcG9/uQry8z?=
 =?us-ascii?Q?/+AGrkU8TF0dBVRhBTvCv25H+nGw8XWkMTJIPchJ4Ur47LzgFzDlO+kVp78C?=
 =?us-ascii?Q?8JWpNcons5RRDu4VoDrzDMxM5okL2+3zfrNGL4joh6aAiGaInjJHYlIA2TSL?=
 =?us-ascii?Q?BpS6uy++oTb2PgXxIr4SX/EtR0ozkkEm5DDjdyIiDOh6dWrErEe3YrgzgsjC?=
 =?us-ascii?Q?tjU26xmuFVUEBvORqImM7rf8StUVj81lgq3BQFM8Bz+GRbG5VrxAPN9hhiMW?=
 =?us-ascii?Q?rmjzk851k8ypfSfzVPtt8yw4V4N1vln9MVHDO+6Knr8LyCbj72dBznUONA4h?=
 =?us-ascii?Q?qKy4L58eWuZQDMCPV++yOt19qLNFVpRwgl1KaLMUi11Vakd6SJjfpTzkmSYR?=
 =?us-ascii?Q?O0EcSG8g9OFyorPDclGxQWM7WuJhERQkNtQRRsYHVNt6Ng+s78yqSCW0HtgL?=
 =?us-ascii?Q?uJD1g8lP5uYuFclDQja+g146pGLvD4fziy90lUfX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8579ec91-fd04-4d6a-bc3a-08daef53cbf6
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 19:34:01.1021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4bomhfrBn56L2BtTRrFYWmOO5pc5atzbg0iB6mHJboWT7jjS1KqBgoaIrBhvVIME
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7950
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently the kernel has two ways to signal the "isolated MSI" concept
that IOMMU_CAP_INTR_REMAP and irq_domain_check_msi_remap() both lay claim
to.

Harmonize these into a single irq_domain based check under
msi_device_has_isolated_msi().

In real HW "isolated MSI" is implemented in a few different ways:

 - x86 uses "interrupt remapping" which is a block that sits between
   the device and APIC, that can "remap" the MSI MemWr. AMD uses per-RID
   tables to implement isolation while Intel stores the authorized RID in
   each IRTE entry. Part of the remapping is discarding, HW will not
   forward MSIs that don't positively match the tables.

 - ARM GICv3 ITS integrates the concept of an out-of-band "device ID"
   directly into the interrupt controller logic. The tables the GIC checks
   that determine how to deliver the interrupt through the ITS device table
   and interrupt translation tables allow limiting which interrupts device
   IDs can trigger.

 - S390 has unconditionally claimed it has isolated MSI through the iommu
   driver. This is a weaker version of the other arches in that it only
   works between "gisa" domains. See zpci_set_airq() and

    https://lore.kernel.org/r/31af8174-35e9-ebeb-b9ef-74c90d4bfd93@linux.ibm.com/

After this series the "isolated MSI" is tagged based only on the
irq_domains that the interrupt travels through. For x86 enabling interrupt
remapping causes IR irq_domains to be installed in the path, and they can
carry the IRQ_DOMAIN_FLAG_ISOLATED_MSI. For ARM the GICv3 ITS itself
already sets the flag when it is running in a isolated mode, and S390
simply sets it always through an arch hook since it doesn't use
irq_domains at all.

This removes the intrusion of IRQ subsystem information into the iommu
drivers. Linux's iommu_domains abstraction has no bearing at all on the
security of MSI. Even if HW linked to the IOMMU may implement the security
on x86 implementations, Linux models that HW through the irq_domain, not
the iommu_domain.

This is on github: https://github.com/jgunthorpe/linux/commits/secure_msi

v3:
 - Add missing #include to iommu.c
 - Update the comment in msi_device_has_isolated_msi() when
   arch_is_isolated_msi() is added
 - Rebase to v6.2-rc2
v2: https://lore.kernel.org/r/0-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com
 - Rename secure_msi to isolated_msi
 - Add iommu_group_has_isolated_msi() as a core function to support
   VFIO/iommufd. It checks that the group has a consisent isolated_msi
   to catch driver bugs.
 - Revise comment and commit messages for clarity
 - Drop the VFIO iteration patch since iommu_group_has_isolated_msi() just
   does it.
 - Link to Matthew's discussion about S390 and explain it is less secure
v1: https://lore.kernel.org/r/0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com

Jason Gunthorpe (9):
  irq: Add msi_device_has_isolated_msi()
  iommu: Add iommu_group_has_isolated_msi()
  vfio/type1: Convert to iommu_group_has_isolated_msi()
  iommufd: Convert to msi_device_has_isolated_msi()
  irq: Remove unused irq_domain_check_msi_remap() code
  irq: Rename IRQ_DOMAIN_MSI_REMAP to IRQ_DOMAIN_ISOLATED_MSI
  iommu/x86: Replace IOMMU_CAP_INTR_REMAP with
    IRQ_DOMAIN_FLAG_ISOLATED_MSI
  irq/s390: Add arch_is_isolated_msi() for s390
  iommu: Remove IOMMU_CAP_INTR_REMAP

 arch/s390/include/asm/msi.h         | 17 +++++++++++++
 drivers/iommu/amd/iommu.c           |  5 ++--
 drivers/iommu/intel/iommu.c         |  2 --
 drivers/iommu/intel/irq_remapping.c |  3 ++-
 drivers/iommu/iommu.c               | 24 ++++++++++++++++++
 drivers/iommu/iommufd/device.c      |  4 +--
 drivers/iommu/s390-iommu.c          |  2 --
 drivers/irqchip/irq-gic-v3-its.c    |  4 +--
 drivers/vfio/vfio_iommu_type1.c     | 16 +++---------
 include/linux/iommu.h               |  2 +-
 include/linux/irqdomain.h           | 29 +++------------------
 include/linux/msi.h                 | 17 +++++++++++++
 kernel/irq/irqdomain.c              | 39 -----------------------------
 kernel/irq/msi.c                    | 27 ++++++++++++++++++++
 14 files changed, 100 insertions(+), 91 deletions(-)
 create mode 100644 arch/s390/include/asm/msi.h


base-commit: 88603b6dc419445847923fcb7fe5080067a30f98
-- 
2.39.0

