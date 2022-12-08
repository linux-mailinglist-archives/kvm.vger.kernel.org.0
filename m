Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEF0647731
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 21:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiLHU0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 15:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiLHU0k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 15:26:40 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A367E822;
        Thu,  8 Dec 2022 12:26:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QhcXLu9wVIAKMNCINipB03dSiHfXWDF7vykTYYX29lc0LE5lG258ZdabLuapA8bC22e0tCO9nI3JUjBXtbfPZdUlJP/lVxniQtEyonXzOeq4qGfUVJC8SVvFzmpvZ1xPHNJZam2My/HCRsD7xT8B+FLzzLclBKkG5PDhmRrcQeZ/VV3oLx4mfswjGQVpwqZVY0KPhjLBCqTLhjyqke/WKhVzsnBfTGLteR6tjDdNHeoT1eRLshjux3RR99i29vczkwg58IhDVN8UZoQCFAxmYFFSwnAihPJRuqUOV/Hx/TdVe5xlAih073OiLQY8KgIVWjBtUOCpKzaKFqshs5O87g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pNiIOfQKqm5Z65VrC0HyT+g1vKabh/68FnRnr6UQsIo=;
 b=dV4VCPZ+QLPHjBJfX0dluhQCYJq34TDwMArCGHAHWpB2HHFPn/ru5rtepECSb91SvTLmTlVJlwMr6tLWn19TOO1EUCxb0wjRx50blWQ+6cQgcgMj/saajNfQuy+12QDlaWpP5Vhjv8Ooja8yH/ovARmb9JPQiDYBauXBZydqUm462jdXHxVO7mFB/hl14sFteyM6va0cKKv1pMK5ZrA3G+L+dIQPz1n/bZgSjIneTWz+UEIeDrfQAs8wM/ZmsYDaxjLmopmvnfCY8in+H4+oBx7cNcMpOX5ZAkHJ700WbS1IHga9EFKVLBVWK45SZpqFhFuzqsJIQBnoLRb/acL7/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pNiIOfQKqm5Z65VrC0HyT+g1vKabh/68FnRnr6UQsIo=;
 b=Fb+NsUORR1OSARm94QCTMNCmdcwtKrBvBE8VQMRqVrb50hwaikntXXm4sziQh4zi1OpEHYIvUIohUoLmdKSEdXszItIfRA+kkmUsnCobCv37dbLgE96OF0l+XsjVrCSlojzo+8RtRImYsZqGirzw24DsIVRYmVbAALNwtB4Zo91pw6R//+xCC6wRgz4qiXVSoEkjQenTlIdIu55oYRpv3PG5WhSjGS+A3W1JKBnu0cJXzMXYOBQp2bdNXtWnRlKWjtDLENHanNXoV7+oc+xVZF0Z4m4LksmGKYCdv3cP3ui5t7eRT10jBPIbo4GR4tY1tfp/QrV/8n2kE7jN6lQGig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 20:26:38 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 20:26:37 +0000
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
Subject: [PATCH iommufd 0/9] Remove IOMMU_CAP_INTR_REMAP
Date:   Thu,  8 Dec 2022 16:26:27 -0400
Message-Id: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR17CA0024.namprd17.prod.outlook.com
 (2603:10b6:208:15e::37) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6163:EE_
X-MS-Office365-Filtering-Correlation-Id: fb9ff81c-a301-4f29-8d6d-08dad95a81e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jLtguAAUyiBmAtlTDi9EEZPsRsVFhS+lAOkUcXvTPucIO+KNIxkS614MjcL19a2jmrgIjtorgtzSqsqr5YHCW2Y0RXqcJtXLAfEG6Or307XdsY4SHZ5LC/ifB89QlrYDekUOZAbqx6nef/A+m1hwXP1Eanj77lG1xD+kKEkq4M3d+SWoNwK/rtzKNYBehqZaMgXvd7Sy9UV2dHQlSEE/rTchz48p621tkm6GsCbsuVaQD1bRk3x6A+dlhHdjGOuvM1ULbHoU6sAC1NNl9oEneBPWA+Ck//T/zl6ghCxQybYJxza0aj3Zpgss2dMUMwspVWiooGBxGic4n0dkgR/rB9os82Y2rCNMGZCKFkLn2OfU6/NBG77PzMLj5b10qPEHyt5N/0+Za+EpHjiATL2We7yvJyYr4ov4+bGJsXRNmLMPuYw4ozY53pT/b099fA8g9iWi47adVhhohOOeuw3J4FVV7lL6Ru7KbSPaiQ6NDTJ/WwoSKj0VpW/+KEMPm9eJwkTxkipx1P5/nMbJaWpInJwb/5Njtc9DFPj8IWyLbIeLt7fm9VDFfKahWvhtsOGfgLIX3A2q9vm4Qxyun1fpG0FifM/4Hck1I0zcRXjx4NxVrh4LtQzQRUca8VeUv+ARv8knDPSXa0vGa9eRt+/cUJhJeukKVvlpvjAQ/1F4VyyoeQNm+AmC7gJOmHzO3Uek/tS6cZFiwGCyBizqEioTdh04FooI6P+3ALfsoQN+yqZ2QvO/tgfCOmkHmUtLWzkNlqEcKhqA++3NesN9Vj4fAbUh+SL6Hv2k2GSyvX9BkvE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(451199015)(41300700001)(7416002)(8936002)(2616005)(66946007)(5660300002)(110136005)(8676002)(66556008)(186003)(36756003)(66476007)(4326008)(54906003)(316002)(38100700002)(921005)(83380400001)(2906002)(6486002)(966005)(6506007)(6666004)(86362001)(478600001)(26005)(6512007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JEMBo5XmgtPKr0Dfn1HneIRS+oJFLDPi2SQTNv24LxUp3U18bV2Dirswmevp?=
 =?us-ascii?Q?eIKcSo9yj3zfGrVGBrfobNnaOlFuc/t9GKD/Pgve+/+mx1lkh65T6wkW6hNf?=
 =?us-ascii?Q?YnKV2LRY4sexu82/bjR6AvCQhTHJZXMlH+S1yOMl4hOMxSghpu0S7X+hiKof?=
 =?us-ascii?Q?oKAKLDdOtMA/WNT3z1Bhy6KdLZj4jNHlKWZ5Ed4TBv9Rgb8qLerP/Gj7iYS0?=
 =?us-ascii?Q?loNDO7EtFutfM3Ii7vY8KnMKfGwoiuxwgxzhTP0V/rA6ZC2qMaZecKZZGpR7?=
 =?us-ascii?Q?tYnbTTu9uVtTaXQ+3RqvbYuKYD7aYeAhets8hGHYIiLdXJhbQ4+NGgthCRUT?=
 =?us-ascii?Q?DfFK35ye3Z9q/cyeO/NzfYRA0Esd9skQj/gr8F0pAxmZq1ztfhHxxgWRMATK?=
 =?us-ascii?Q?q15ymM4K4t/6zpB0+4cCfhAZ59ZabrocPNkQ4tOVQZsffHaqSE85Hms5aZzE?=
 =?us-ascii?Q?EdPifxT4WakQ7tWO+P53SztPDmMSCSfCNWb24YU38TAlvp3W2kc3YziGnD7B?=
 =?us-ascii?Q?AqG+aeUOmk/6MZjtqhPsq1givBB3nc6sOt/gysascnkgIYZs/nwnezVG/elM?=
 =?us-ascii?Q?X3u9pqXWDnvaVqeGl7vZOrLD3yRfVIVvM0NX77172gn9xBy5T/D/xvXUKSSb?=
 =?us-ascii?Q?XtYmZ2jbXXhbcnE875HBWUWk1CHgO0HZnL/48zqPq56oL2Hck+gGrnjvnvLe?=
 =?us-ascii?Q?wdGfX7esePzOQW3N8roUm5GRAw9MUui9x4+7Mur7NKBuTq1HM09aHqEYxh0r?=
 =?us-ascii?Q?dg806Tt3a6JOivv1ZeFHfVc9y8TEwbcJMf+JBhSVZREGEh25N/lpvo6HDDEa?=
 =?us-ascii?Q?cGXE1KrHHsHTVbDOg7UVc4Lzn/m15o0GhuWsvULLo+vl51ZmhOazU8uSYtz9?=
 =?us-ascii?Q?GL8ZKy+GVHiURJDEYmhA9zho1TNQEDIGmk1xUA+TlNBoLv3gA1YHn+u+p5UZ?=
 =?us-ascii?Q?pjV5MDpMlmwe5l4OT2RZ8fIzEuw3unZYtNyb+Q2sqwEQkjFnwFAkYjVLW6I9?=
 =?us-ascii?Q?hsUA4b0PgSyA2qMNbBu6yLLynSeUAhDI+4y6Au1hGEhh1x0VbbP95XVHCq1s?=
 =?us-ascii?Q?b1btSzAAEt09jPo5PAtAxGGpBxaQIawkITcdIxvPbsA1HQYgMaWAJ0cFiPL9?=
 =?us-ascii?Q?ijj3ea8CWpiiGNXPQKzMlrwVgAgaq0bWHbKkly4ESu+1w/90zlPOHR+qRIho?=
 =?us-ascii?Q?FrnKqpaeYV0CaKy3U7SKHgACpXmn3nYngaibeTP1FoFKOQ0xW1krUo4d9ctu?=
 =?us-ascii?Q?2wcprGb88JkSuGCr2rr5MLykaIlNtQe6ig3Yp4VA3blunltJuV/cHwUEUp8A?=
 =?us-ascii?Q?k+Gj6vA+lp9EcZKQ8IEhr1rhEubRxqEoLT3UZ2J3gkiiufk5pSWNF/ENHnms?=
 =?us-ascii?Q?EqOBMdzETyPa6boydwwaJiweSC8zX3r8EZLmJF4uxG/8KerJIHNBhnBQvOg9?=
 =?us-ascii?Q?aNzVqeQ6xbv6KTY8n3Eir/+0H2rgsDcEF0SMRpxDThA1eovpiWo6lTvYZqDf?=
 =?us-ascii?Q?NfDmkdsqy2nlfykoOVui2J2kZv09FQbDk7KAnMlAs8LeLDlpnmPRpvdkaKOm?=
 =?us-ascii?Q?9cNQ76g8slgQy8dzcug=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb9ff81c-a301-4f29-8d6d-08dad95a81e2
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 20:26:37.7925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: efHjGZV5cUQ2cdcKS7y4Ev75JHh0AnA0KMOHkyVWoKNcsECC/yMjg7KmtLxxF4HO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6163
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

Currently the kernel has two ways to signal the "secure MSI" concept that
IOMMU_CAP_INTR_REMAP and irq_domain_check_msi_remap() both lay claim to.

Harmonize these into a single irq_domain based check under
msi_device_has_secure_msi().

In real HW "secure MSI" is implemented in a few different ways:

 - x86 uses "interrupt remapping" which is a block that sits between
   the device and APIC, that can "remap" the MSI MemWr using per-RID
   tables. Part of the remapping is discarding, the per-RID tables
   will not contain vectors that have not been enabled for the device.

 - ARM GICv3 ITS integrates the concept of an out-of-band "device ID"
   directly into the interrupt controller logic. The tables the GIC checks
   that determine how to deliver the interrupt through the ITS device table
   and interrupt translation tables allow limiting which interrupts device
   IDs can trigger.

 - S390 has unconditionally claimed it has secure MSI through the iommu
   driver. I'm not sure how it works, or if it even does. Perhaps
   zpci_set_airq() pushes the "zdev->gias" to the hypervisor which
   limits a device's MSI to only certain KVM contexts (though if true
   this would be considered insecure by VFIO)

After this series the "secure MSI" is tagged based only on the irq_domains
that the interrupt travels through. For x86 enabling interrupt remapping
causes IR irq_domains to be installed in the path, and they can carry the
IRQ_DOMAIN_FLAG_SECURE_MSI. For ARM the GICv3 ITS itself already sets the
flag when it is running in a secure mode, and S390 simply sets it always
through an arch hook since it doesn't use irq_domains at all.

This removes the intrusion of entirely IRQ subsystem information into the
iommu layer. Linux's iommu_domains abstraction has no bearing at all on
the security of MSI. Even if HW linked to the IOMMU may implement the
security on x86 implementations, Linux models that HW through the
irq_domain, not the iommu_domain.

This is on github: https://github.com/jgunthorpe/linux/commits/secure_msi

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (9):
  irq: Add msi_device_has_secure_msi()
  vfio/type1: Check that every device supports IOMMU_CAP_INTR_REMAP
  vfio/type1: Convert to msi_device_has_secure_msi()
  iommufd: Convert to msi_device_has_secure_msi()
  irq: Remove unused irq_domain_check_msi_remap() code
  irq: Rename MSI_REMAP to SECURE_MSI
  iommu/x86: Replace IOMMU_CAP_INTR_REMAP with
    IRQ_DOMAIN_FLAG_SECURE_MSI
  irq/s390: Add arch_is_secure_msi() for s390
  iommu: Remove IOMMU_CAP_INTR_REMAP

 arch/s390/include/asm/msi.h         | 12 +++++++++
 drivers/iommu/amd/iommu.c           |  5 ++--
 drivers/iommu/intel/iommu.c         |  2 --
 drivers/iommu/intel/irq_remapping.c |  3 ++-
 drivers/iommu/iommufd/device.c      |  5 ++--
 drivers/iommu/s390-iommu.c          |  2 --
 drivers/irqchip/irq-gic-v3-its.c    |  4 +--
 drivers/vfio/vfio_iommu_type1.c     | 16 ++++++------
 include/linux/iommu.h               |  1 -
 include/linux/irqdomain.h           | 27 ++------------------
 include/linux/msi.h                 | 17 +++++++++++++
 kernel/irq/irqdomain.c              | 39 -----------------------------
 kernel/irq/msi.c                    | 25 ++++++++++++++++++
 13 files changed, 73 insertions(+), 85 deletions(-)
 create mode 100644 arch/s390/include/asm/msi.h


base-commit: 644f4ef9a6ea0e0c65f949bd6b80857d4223c476
-- 
2.38.1

