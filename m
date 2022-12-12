Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A2D64A769
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 19:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbiLLSq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 13:46:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233187AbiLLSqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 13:46:23 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DEE43885;
        Mon, 12 Dec 2022 10:46:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YCly8MlIDEnZmKjMAiHhz8L/V+RZn28dS535mxqAZgLz5XAPcmXgIi7a2BTunm2lkKYPG1ppEFn2DshlFbw95nCEEWrmAaJNwTyaXUTZV59HzvNeMVhgGnUuL1aHtinFrbzJJ5xXQREFi5G4j+hwxxmtKtMPDOKjkSieJp5CU3XZHP35PNOWaNEMLeSePu69g18H6kacoWTydeucbfk+DTqdfxhz9zrwnFuyWpdokXehBFxXn4cDUPjtBLKA60Qnwrj/y5eOnwutmxgH7D8m/bjiTP814orghUEbo7mOJbJE9kchTQ9uiZCR0NDwJ9uWtI2LQxl3spkd3eVKiEmc9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JFf/mZBTTZWIZoWNydWeMPtKphLWsB+vnLrAnyCdHbs=;
 b=W3Ess7Mbt+d3GENykNSujDbXC2XmI7EtZOoC8WQSHX8e4m5G9rIvb9/E5cr4O4dpkvRlqnc8vAVu3FvDFnBBj+S2C6Z2MzHXPTm+2motZQXoiAXQR8y801WkBVwbHWmZN1nqBf/zJkqGdvhFE+3GzhSpT4Fy24zNlIPzJ/32HE70G0VAFaSzVsC1GjkVoP7KF+Ioa6w+AevUZ+2RTE3VdPYkLiluDvwO94e4AYxm6qvZSNpcTl3MedcGO1Cqvv7NXw1fk9YY4s/fXW5F2CS4YEI2Xg5UE6So/ErBh7flfUCn+5J8A8d3Bn58fpTtP3WUiZebfIpGlJ75YzeIzu1znQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JFf/mZBTTZWIZoWNydWeMPtKphLWsB+vnLrAnyCdHbs=;
 b=in1z7BK8Cu5/lvEpaiJUzAN2C+LQ5B/VP7lyJkLs3RBs1RypRHTCsuQZbAy3CHOEuTCr5t2WHK/R8XB+xcIl0UD81sz5rLkQF+mMdTzsgHN7xNfWJdWYdeceigFkraWwNkVdsOQ4NOcH1ULGSq6mFoRdKDQ6halvxKq0dy2mLa1PuwUP5PRfF21yI3L0L6/t62XtMk7NSh+zciJhk3895Xu6vz0N5NqFAaAdsTjiZTbh7vfRcJQiiquZ/HR8P+I72tVz1vB/zAVlxGUbIhBLjfiEPO08Gor1x7vkmoiRcpH50o64Zg4R9znMtm41lcr+u0abGR27d/nckiYcy/ESYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BN9PR12MB5340.namprd12.prod.outlook.com (2603:10b6:408:105::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 18:46:05 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 18:46:05 +0000
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
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
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
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH iommufd v2 0/9] Remove IOMMU_CAP_INTR_REMAP
Date:   Mon, 12 Dec 2022 14:45:54 -0400
Message-Id: <0-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR04CA0036.namprd04.prod.outlook.com
 (2603:10b6:208:d4::49) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BN9PR12MB5340:EE_
X-MS-Office365-Filtering-Correlation-Id: 8943cc6e-1473-4ae0-7dc0-08dadc711fcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v7ErjENx6joR1p0CtA+syn5AkCh1bQp50Z8HSXMjviw55kZXM1a8dUj/0YL79Vp34NbBT683WZ9J9/Er0rCiAqylcqZKgs8jr1D9m2tjMRDgpb8dVNpdbGDiy2jBANlO9DTna5ZD57VjiU53KBJP96/2rqVbM5C/g+XXlSMoMdnhiJk7h3aC4Z8f51e9eZBJvEXiabBQzPecvuMEW4yIOTUoMARjbWuUlaVgO/2ABNGoAm6wOB+WJHb6gvQ+W1vuAMpGiFUcngjDujnVVuPm2S94JXxXuKtGBE6Fp7gofkRf4pJBGDFBArUP67LEJNekLNxQJe5SbBbd/y3b3WDwLDCu0DPofjvkaQIuCLlc6Csv24pQ3ZVOcq1yRyYIKh/14qpcd5NmqKqqj7OEyXfPq/bzZXkv+lpJFNw9WB/i/aACE/fSWJvPHjwa/zjZRZh1fFmTE64CsQI/08QoMwP4zEzPkBkk18xg48nlUMYup4yDN0Ls7zT5ZIkCsNbM/Gg6xUwMqHVVtasSaewqNNiUhWmlge0ocdOCubLOxy+ZIJnN8FPzhQEICylLtRMt87j92e+BH1qeo3mpPfBuzEmMzGRYye0pzDek237utQjh24lcI3SlM8YfYH5fe2goLBB1phxY5jDQNbVJ4S/nmtRqz8O1jt614gny84PD4dvfATm7rSs78rbXN2JYPeBoaya27KehMSi/DgY9JhYhz3Nas64LbK9fMeb72mtXeYHyyxIHccWFbiFo36zgJuHIfwTiJE2B4wF6TnrAaRMvUn3XLmZM2CnCQf2qiAj8U82ciC8bvH8HQ4iTrXbASkiEUXyzq9PsAjlFjL0s3+jwPGEv+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(366004)(136003)(39860400002)(396003)(451199015)(2906002)(7416002)(36756003)(66946007)(38100700002)(66476007)(4326008)(8676002)(316002)(86362001)(54906003)(66556008)(8936002)(41300700001)(5660300002)(478600001)(6506007)(921005)(6666004)(2616005)(186003)(6512007)(26005)(6486002)(110136005)(966005)(83380400001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0aYZa566fZzHFPrwxq1ReBo8BIHb41vEyiQ70LXdCGXcBdUOBs5/217GPXjV?=
 =?us-ascii?Q?t5/pTCq/qVM8tlAPeVAErszPSYkLj1J8ptMQEwEoLw47pW6hh64iWZI8NOUU?=
 =?us-ascii?Q?lL+LpHgd2dxrkyXvd/O2b3nV1RHoTdbvnEzw3eOl7aYhy7aKP/sbtcveOLFr?=
 =?us-ascii?Q?XHpbwejer8TL4YZaVl/CHBUuPITikWjR8vrnu7ZJlkk/clHc21YePaC1C/sj?=
 =?us-ascii?Q?l0y/s5yImeVqswYXqsMqL3t4l7XB7+QLl0nK9V4ox4QsBK20B5sfys9IHHEE?=
 =?us-ascii?Q?DEtYuDCoh3tW0KvlzlW0cgBl78aNM2tS/LwuC/fma0OOaM78j+V6FrE6DtRB?=
 =?us-ascii?Q?mdWmKUOxuTG5lI91OfPdJ+mO6pgTB3472/1zyEtqZmH8geeguGJesZt3jGDA?=
 =?us-ascii?Q?zfB/RsyTKq7fsvFL8dyrY7Idno2ITd/AJ6foeWOgDaGENRpkXowwzvUCb/QY?=
 =?us-ascii?Q?37S7v3wXTJkFpoIgF71Ln0QBi1pSW0qJboj9McnpJDozVddvo74h0GSMigXM?=
 =?us-ascii?Q?ZCz9ujqsrRWgLQ0c9JEG5PbuIimRY38iIVcrhUkLkITBgGBTM8WowAFLzyBo?=
 =?us-ascii?Q?CquXN6RjHDazN6nmAunN/EjjjT1p5u/8wPVIKrf1i4O3jLVxa3fLMe+aGx4K?=
 =?us-ascii?Q?xbrHeEI2a92KyNopCInbkUJ0Zru2G5eGF432cPHPgH46lRSuj1/whH6fWXCm?=
 =?us-ascii?Q?NdRsmwfsETSKnvBcdaF630bGOfHZWw0R0s9a4U6L7zMjlBBlI+A2W2Uv8ArT?=
 =?us-ascii?Q?/iPY/8hnNb+6bCbZ2JDreET6peOv34mgQWjSMY8PMU0wFFUkYUttZtRJgij1?=
 =?us-ascii?Q?t3BvAUUb74jCPKZK9ZlNEvK3+i2LusM9kESVNR8X7ENXbaiwWKTHoNqWxxrP?=
 =?us-ascii?Q?GBuoTsY7oHMVTUSLJ8vDhMw+d5X98BytgdxwXHqHTJIVIBrbECBvS32cK6GI?=
 =?us-ascii?Q?GPV0wzMYzzl5s5ofZN7Bsr4XtTFOSduY9Q/58/0MmY1y9RO/hIuIZjUkyeaN?=
 =?us-ascii?Q?yr2kQNO0K9t+XaBhVuJwHQ7Lt0R/6gxzzXbIAxQTPJ8aHDiXPE978lBwkrsw?=
 =?us-ascii?Q?9T9wbnBQ+PJQjmJx+Et40N1YY97FEnyNcD0KdBiP7nkLtLu9dKaBORSYqF4t?=
 =?us-ascii?Q?ev0u3Rz0lt8oWizS95d5qY8XyIZP9DL6xLOzyOCs7vgyB6Qmch/HM6rNdgBK?=
 =?us-ascii?Q?ElSl/c9PoH/EN6XsJobAdcpvz1gWoKqXLMPMVUBSt35fJxHuRdK/YrganraA?=
 =?us-ascii?Q?NzbGwQlKmmxdjCDvpcnfEE+oOjxjD5gse2+4V+xWwE1gjD+gRWhPm3z+zLWI?=
 =?us-ascii?Q?K8p/ctwkrTK3Z/hNSM9H7E5jRQKVADbut6vcn2yCH97kQIrGSrCCF5eNZXuP?=
 =?us-ascii?Q?fzf0zuitl8dIuqePpURzZylnJbEj5C1ZDNTbf1SLYRONVuwn2FO6CB3fYp0l?=
 =?us-ascii?Q?yT6QPWqfy4WK8+qtUcrskbm4qni7ArOqE9/CdwNhi0NnBsxaw92uMPeNcEXw?=
 =?us-ascii?Q?tAKvaZ4RHPdQh3gW8kHccefUQdZ4GnuEuub54oLEe1QKZFN6ca0RFqkAlgc4?=
 =?us-ascii?Q?50SUlxGRfeIzObsef0F9jugchgPdflEwDMVfNq9D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8943cc6e-1473-4ae0-7dc0-08dadc711fcc
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 18:46:05.0676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3AdDRkwM4Z0bOS4FQXiJD1ruupqVHvullkCm9emdMiYz2awGE+l4mJtSTVZbkMEB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5340
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[ This would be for v6.3, the series depends on a bunch of stuff in
linux-next. I would be happy to merge it through the iommfd tree ]

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

v2:
 - Rename secure_msi to isolated_msi
 - Add iommu_group_has_isolated_msi() as a core function to support
   VFIO/iommufd. It checks that the group has a consisent isolated_msi
   to catch driver bugs.
 - Revise comment and commit messages for clarity
 - Drop the VFIO iteration patch since iommu_group_has_isolated_msi() just
   does it.
 - Link to Matthew's discussion about S390 and explain it is less secure
v1: https://lore.kernel.org/r/0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

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
 drivers/iommu/iommu.c               | 23 +++++++++++++++++
 drivers/iommu/iommufd/device.c      |  4 +--
 drivers/iommu/s390-iommu.c          |  2 --
 drivers/irqchip/irq-gic-v3-its.c    |  4 +--
 drivers/vfio/vfio_iommu_type1.c     | 16 +++---------
 include/linux/iommu.h               |  2 +-
 include/linux/irqdomain.h           | 29 +++------------------
 include/linux/msi.h                 | 17 +++++++++++++
 kernel/irq/irqdomain.c              | 39 -----------------------------
 kernel/irq/msi.c                    | 27 ++++++++++++++++++++
 14 files changed, 99 insertions(+), 91 deletions(-)
 create mode 100644 arch/s390/include/asm/msi.h


base-commit: 644f4ef9a6ea0e0c65f949bd6b80857d4223c476
-- 
2.38.1

