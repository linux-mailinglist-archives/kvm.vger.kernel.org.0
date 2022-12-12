Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE0D64A771
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 19:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbiLLSrl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 13:47:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbiLLSqZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 13:46:25 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9528429F;
        Mon, 12 Dec 2022 10:46:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eMm9CaDDiYBTrozhq2y3WUIsZ0L2yxpLyxLW9tK4dLFExYKUm/w0YrOdruIUjcG0l/FiULMiUwa5+TokOrTmK0/PX5NbnFIvytoEZ6DDLhXIOstEc9+t78Cy4GPzQZ+8/49x2lWZmNb/naFKIIZAhRN0gzUuBMYy0lUPVyMwCNq9AEdvvrdWhQwFicSXHgFtyeMtgNWgvximc9Fw/W0endxKKavvoMllm91A9EObWrXyOaKh2L7ZdqNAe1bMwguaebP00Rh5yQgzS640drvyNMyNjwuznFPxd7iVolAqrYjlr+QZ1Cx/XVmj7pa3lk+aQtwmK5dsvXln30coOFxwtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PAAAd2JCjy4Pvpex6QY5cRz4epZ1aPkfxv92iEHzFPQ=;
 b=h7obItoHWTtGieNQZmdvog1YFuVpTS8EDVDeJFmINvdxhNs8vJoYJVe/yGhw+KzcVO3+DLWSRUcQ6NDQp0Hk+6OsXznwphK9ZRdJFMegi8KFV+BX9Sqh2YO/XNfC9ysZ/Ei0zGRK3BWBRKwU4TuMbcQ2dMgIItpa2qh/cZk2g03wmqiG9hbhnRK2D8zPbacvE1t6k2JXQb82Fy2pv8ANkkOxF7B43VBP71OojOaGaftYbQDPU0S1ixJDhxRcjaOm42n/JNEBiOgLAjjO4fDO0YYDFXh54+Zi3di6Px5Ej5baXKWNaf3VEUrDHB4xNTRcTqwoDvBNoszqJARLnahbJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PAAAd2JCjy4Pvpex6QY5cRz4epZ1aPkfxv92iEHzFPQ=;
 b=Y1R7+L4/qVa3c2o6pz8gqb6vHPWYDNkkdwI+KlBUPh+2Rp6Cgk6fICo26GDykXjMq5bvi4y2G0ima7y1Oc6jzeawbiL5OJQxETdGP26kVLH5w8YXb8TXZqXbx3sPnU0qAk91uw1ZRfIbZnvSqr/qvoVjf+zbHkG4/UtKyUw7vGTYp8CLO35CkBOLk4sE+lQmPVNSn4RGUQAs0EuVxn8eEvLELm6RvM2W1sUd5XpTziw7dtg0mLPILE/ptnuKmG3abGt5NVymewuHJCStb6KiOdWvIVGBcXnfg7u9LXGw7AlXVtipUizHQj+H48Jyg/Ms5Rv84yO5SqjYE1hVZU6WPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5748.namprd12.prod.outlook.com (2603:10b6:8:5f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 18:46:07 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 18:46:07 +0000
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
Subject: [PATCH iommufd v2 7/9] iommu/x86: Replace IOMMU_CAP_INTR_REMAP with IRQ_DOMAIN_FLAG_ISOLATED_MSI
Date:   Mon, 12 Dec 2022 14:46:01 -0400
Message-Id: <7-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0362.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5748:EE_
X-MS-Office365-Filtering-Correlation-Id: 13083baf-e534-4161-bcb3-08dadc71202b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bji2IztwEil6nKdSnW1HKAVga1xCAVY/4U+zsj/LZYLze69aaQg3NXW7DGUf3qoAz2W+fgWW8q0/wMDwsKTjLuS2Dq1bHhlzd7jOdCxjDREVdf6/uM6g8EAeIlscKNp6Ur7db/XA8dwawyY2JGYHRi3EFUrtgIeVigeGaWEsZju1yLdoI64TxI5O2pDWoLZRqqvGHLNQ6nVysPgkmWQYwmN3p9EYO7GxQ5mu0ooG6qyVTccipdipU6IAxA1NxW8Noa8NJJ27TYjxGHMkdyRYRCJRX/TvPVuy2/q4qCMvS9+yvg2/manhW/Bfq6/lN1tWjz6h1JW4bogJcNbJA6pylG32q5X9+X+9h/hLjb2kWPEAnPDPZMRNRoBMWFKm15R+zG0Q53AcHCJtLzB3gPg437e8rYH4ohr8CTAq4AvAZZBkPqAz4o+4cjEvEiQmPxoPZsfBJLjp64X7suUaugV/mrXRNDdGPujfdB1QWR29oD/xV2Ge8lOL6rc1pKQ86nEh9GlvaNzQ5gDriF0o+QS01Cm5LbSjLR8ft0Bdsg9NpiGsADvtrvypExNY0N8/Z/tFU/SSdeFL3V2SD0voui+Cv8qFjjopXhQtO8IulDbGmM73LJT7mwZ8RKTqSCi6QZg/xWTR53pLEFkgx/+fJ5Tm7rSf02NOYBEfKJdSCQK5S2FtWfDTOTng6YICUlECbKhBsilVjptsQHTLin7fyhd79w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(451199015)(921005)(2906002)(38100700002)(41300700001)(4326008)(26005)(36756003)(86362001)(6506007)(6666004)(66946007)(54906003)(8936002)(7416002)(316002)(110136005)(5660300002)(66556008)(66476007)(478600001)(6486002)(6512007)(186003)(8676002)(83380400001)(2616005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?foZwcglZn38xX+kTFGaRWkjwnU9LexznKzftBZUWMErvBCeEotkbWxqomDh9?=
 =?us-ascii?Q?ABhnslMW4dZ7BEyqBB1W4ykZH1XefBU/fZhuFWm5DMPKHWobgebngT4RZ6a4?=
 =?us-ascii?Q?WLsoF8ZK48+lmA2NutTfSSwd8b5FNHSI+c47xbLpG7ARahkpoS1wcHwRbD/D?=
 =?us-ascii?Q?8W50feJ/Fpjr6YgVOkabFot1zUg2DUuifsNpn40B0QU4R6B90dylLZ/QzptZ?=
 =?us-ascii?Q?k009M8KYNatmOpZX65is+E+21UBidu92fI8Yjp3JuhoB+2mDVoFEFhTUv9D5?=
 =?us-ascii?Q?R41JyeTyx1HmE6TNfwrBOjX4WHMi3mr9dJPfpY/qkv+f6yZuAr86R+ddndXt?=
 =?us-ascii?Q?lJBmFFwv9YqFWiCjMrCM0rZtSAjZtIdYo1ZHFplhhqWwVmZQSw85dPVY8T07?=
 =?us-ascii?Q?Y5DzvcYnNlwY+KVqQC7kfG2iwz105EHoNOmWMq51s/TYy8bJ6TctDnfF6Jso?=
 =?us-ascii?Q?sFZ1vsPpkIKe3BxxYSwOwmdfYYesRLuYjLSQNV+GLiato74F84tM3HINiVZv?=
 =?us-ascii?Q?rTzXLhNCl8hvHuyaCWj2u9EnTUEpxifjRYfGg0YBkjP/n8vVa7d+G6LHr7zO?=
 =?us-ascii?Q?QSmk9EYZ0RE/3iuSXj6A3oaSO3ia6dBhePFvh2CjoRRVHn6wEG27GlUtSWjQ?=
 =?us-ascii?Q?km2pE6K3zd69+Nv7NeLD438uoNyCFLQ5eAijuMEAa6clWJ9EaR3TvOhjAW1Y?=
 =?us-ascii?Q?T9GHA2oDkIVyrYPoNLnBNSDOVa1Dk2pOsw5Dt8gCdFeANxvPUW9+sCPWpxHc?=
 =?us-ascii?Q?dG+s5mTc2BMSM67+c1mlhiftURtiVrknPrAcZc9DxY7spgL0LsufpNinSNBV?=
 =?us-ascii?Q?UhWSxcW5+odktDgZOdIFgZ3IHgIhxfrMRc19ah9lsNthz20YKX62tr8WRyYw?=
 =?us-ascii?Q?SpRcovKDPPIzU+/3hLPZu+FHmVrX2vudp1gVWrwUj/NrBomr5AD6+RuypASF?=
 =?us-ascii?Q?+9iDergY2O0bVRm1q+C8X9wk2W3hbe6SLKU9UpyYRbR21AKVPHDl1kVtPatA?=
 =?us-ascii?Q?jB/EJUdqNZwvWzhXCf+Y0eWlYHjr6FIk9zKnq19bS35pmMsAukzbXj+XPJOz?=
 =?us-ascii?Q?Yom7fQI2tHoY2fLIHPvoGbONdgQRTwalWNwfvfmuQ+l6KI8cKAvixnqNCUSH?=
 =?us-ascii?Q?qiEVfL3048yekeDSb05083PhTD7rrsH8IGQ/UZNj3NfgtIHUkYBCyin54gU6?=
 =?us-ascii?Q?6m7NqbFz1Ogo6jg10RKUUgi5RA1n2lZI0b3IKxPdKF0TGjX0Wy7sHiXevlfZ?=
 =?us-ascii?Q?f9nWvVBgvY540iT9HFU7YbN7i9sBKNDC1Ai1HV9YfyGOYLZvhPbTeNe7f3ms?=
 =?us-ascii?Q?Xk1W+XYhmFoNPeAuPllh/H+/0bl02ql1avRkXihdr57+nRBonq5N6ODTxtga?=
 =?us-ascii?Q?844hSHqygwpl4PviKF3/zvUIWxJA+/XPBzQuk9+V3H8LLPWQ37ALcYiVfE2e?=
 =?us-ascii?Q?9yo9L2pKlCEA93hT1HtrogP52F8B5KJTAdaWZ25sGfjrxraGQnwazi3IhsJm?=
 =?us-ascii?Q?QzszEPTdJVjSGAX4GcjupFAtbdWUxHGQlpUo+nyLNZWKqC9VII55XIMDE3/V?=
 =?us-ascii?Q?atzCmD7kUe5JS7Totr6YZ/GoDDIszDQnUh6t7Ctj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13083baf-e534-4161-bcb3-08dadc71202b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 18:46:05.6904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fjVy22F3vbn4d/NAhvZ0oahqvn8I8mauVCLCTVGehsInUmxMCdQRhs1wQGkjNBCH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5748
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On x86 platforms when the HW can support interrupt remapping the iommu
driver creates an irq_domain for the IR hardware and creates a child MSI
irq_domain.

When the global irq_remapping_enabled is set, the IR MSI domain is
assigned to the PCI devices (by intel_irq_remap_add_device(), or
amd_iommu_set_pci_msi_domain()) making those devices have the isolated MSI
property.

Due to how interrupt domains work, setting IRQ_DOMAIN_FLAG_ISOLATED_MSI on
the parent IR domain will cause all struct devices attached to it to
return true from msi_device_has_isolated_msi(). This replaces the
IOMMU_CAP_INTR_REMAP flag as all places using IOMMU_CAP_INTR_REMAP also
call msi_device_has_isolated_msi()

Set the flag and delete the cap.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c           | 5 ++---
 drivers/iommu/intel/iommu.c         | 2 --
 drivers/iommu/intel/irq_remapping.c | 3 ++-
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 8d37d9087fab28..3c2840cf275a60 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2272,8 +2272,6 @@ static bool amd_iommu_capable(struct device *dev, enum iommu_cap cap)
 	switch (cap) {
 	case IOMMU_CAP_CACHE_COHERENCY:
 		return true;
-	case IOMMU_CAP_INTR_REMAP:
-		return (irq_remapping_enabled == 1);
 	case IOMMU_CAP_NOEXEC:
 		return false;
 	case IOMMU_CAP_PRE_BOOT_PROTECTION:
@@ -3672,7 +3670,8 @@ int amd_iommu_create_irq_domain(struct amd_iommu *iommu)
 	}
 
 	irq_domain_update_bus_token(iommu->ir_domain,  DOMAIN_BUS_AMDVI);
-	iommu->ir_domain->flags |= IRQ_DOMAIN_FLAG_MSI_PARENT;
+	iommu->ir_domain->flags |= IRQ_DOMAIN_FLAG_MSI_PARENT |
+				   IRQ_DOMAIN_FLAG_ISOLATED_MSI;
 
 	if (amd_iommu_np_cache)
 		iommu->ir_domain->msi_parent_ops = &virt_amdvi_msi_parent_ops;
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index ebe44a07c4b00e..8037a599ade0d6 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4453,8 +4453,6 @@ static bool intel_iommu_capable(struct device *dev, enum iommu_cap cap)
 	switch (cap) {
 	case IOMMU_CAP_CACHE_COHERENCY:
 		return true;
-	case IOMMU_CAP_INTR_REMAP:
-		return irq_remapping_enabled == 1;
 	case IOMMU_CAP_PRE_BOOT_PROTECTION:
 		return dmar_platform_optin();
 	case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index a723f53ba472f9..95d218c5077947 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -576,7 +576,8 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
 	}
 
 	irq_domain_update_bus_token(iommu->ir_domain,  DOMAIN_BUS_DMAR);
-	iommu->ir_domain->flags |= IRQ_DOMAIN_FLAG_MSI_PARENT;
+	iommu->ir_domain->flags |= IRQ_DOMAIN_FLAG_MSI_PARENT |
+				   IRQ_DOMAIN_FLAG_ISOLATED_MSI;
 
 	if (cap_caching_mode(iommu->cap))
 		iommu->ir_domain->msi_parent_ops = &virt_dmar_msi_parent_ops;
-- 
2.38.1

