Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBC065F4AA
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 20:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235631AbjAEThI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 14:37:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235746AbjAETgA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 14:36:00 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1741A232;
        Thu,  5 Jan 2023 11:34:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RiogZ6mFyXs9o/Y7vLyDjhiw6SZz4IuEuEXG6kmB8JwFIK57YR4Zf2M9W57bcFsqGYQ35kisrDwOHu442INvc0iOiBazhETNQxa8kGZa9dgo9r+WEnCCHFnIgQsNI7Xf2mlitOPl2vIBGfuRuGq56G+zuvxFB+bbgPY3BqJKzxtYO7KZB+HszuxDOu7PLnArirSp8wI/2eiBo8/Ng6IWBb+18fGizRfsLi0H9QByquqeZEyyIJ33D8fxTdA0oZ1BrMmTYFaMd6iOZK56KEMVNvkShUU4rz2MCXqVYRcGab5Q+5TkYi+Eca2pDvTW1L+UqeXAR1XeGwjSD85qPfqMSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EyuibPUEpGMeh7uiH6zC5yEoYdpeP8pvOhMxcgnITi8=;
 b=lFun/mjLL32No36AQxk63u/kIP6+otb4pW/SrTbnzpzWjkTljyi1QDpr+oH6bmRUHLFDod9rSOgoODMmXLpgPZFGMQgsJl5iHMjq7mMQlysn9rlaoGxLKHiMEhORsxuPXfeZhGbgeL4vQXc1D46PCnIgLslSkMmiHqosWYdYf3z/3ibGHm+8l1YWmDQ2gfvH35cpXQJTA4WaFBwVsLvMy4k+bt2MEBu4xsvNPppXXNhzGSzFTbPbTHC0oxIXjjbvbp4loxkmBGZoN6xhIV+ohLtKdZcxrihHazfbgvf3+6RJVIVPVrbaPdWGJattXCt72aO2Aa9n0/+hw45tLltfVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EyuibPUEpGMeh7uiH6zC5yEoYdpeP8pvOhMxcgnITi8=;
 b=fjo9bO6F5Jq4A6W9Xov5yKeb2owz0RTmzqmLLdI6sESQ6HAN/9lP1gwHhOo18DSIoRP6UTu96wzUkQtKL7ZPlCPtUjnzCFVccV0xmU9zf1xPzRXF/pyfYy9uDrNs1wI3s5ULLQ19/3ByzX6achCm2XmqbNJeH6L492wsTkhEgKVSU3WyFFZeSDNI5rxGog3o193UETxZ7XYlpABwwx013nvDJc12vjK898O8y2Gzl3RBUv1rOLmfzK/WDYxs1S/xdnTdSQv73fdDpVxNM/lSwAMJFiL2FCsqO3RpwGGbH5RvFZpCvpD/ktSvsNLV7IWk5B36e7+8rbM2DAdob4pxOw==
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
Subject: [PATCH iommufd v3 7/9] iommu/x86: Replace IOMMU_CAP_INTR_REMAP with IRQ_DOMAIN_FLAG_ISOLATED_MSI
Date:   Thu,  5 Jan 2023 15:33:55 -0400
Message-Id: <7-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0327.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA3PR12MB7950:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fee1d6b-26bf-4197-5d18-08daef53cbd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3FxwUIso3hOuisGQHT46yPLC5z+5UNpkmf2PCMRnasSHAISvGmku62N+iZBOcNgIZAGseusk921bSKuj5Ar1WfX5XMIKG7BqowV9SveK+sC4FkGWsIXJivBAYvQU8NskPneMWRnDlTjCvQnHsyjs9Pz5wG8+k2UBQd8y/XJ2xhqTRfgxWSzG5QnEiQ8gqHNgv3jDaVIMmKTJnz5i48Oz8EYbQXyczQRAvAodmrF/XzKHFW+4SQ4Haf+QFSFN0qHmNrD2N1VR4X7FAnH/nnqh8ZFOaiPD+ZIbs1ljxWKj5jo5D+cmMoIkGiZDVayakboVeOxQvBlLGsWXceV2GdtdCdaMMPMUlmyCTmEZIYXRYbobLdHT9bAoetEfJQZ3xLucM49ik/O6b2MuLiOsOHvbCH3E8KGg+RUJ5WDp8oQHvutLkmNvBxf5Pk/Ihc8ArKi7h1beoo4XVTAzAn3d9TV0L3dfClrJtbH+JwIAhqnjt3S4FyV6zgTa+SJ+VGMnOLZyuGLaGHYyn/0/RvApaoj/e6YtsQ+0Z7YZxKMeD3DFsIPKfQsRS+UYoROm7d/tYRzH5O8o73i7O6C7o7UoTdL1HSk3nti5pMmQPQJj/GjdiMmo6zxm6v2L/bCun1gqMPEUX1dDWxMACI+U4SBIeAvJgqWdVuPU9g7FKNCNiAjEwupsK20fSQIkFotVE3y4r8cuUNifV9YSG2KTN0xTQZ42ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(451199015)(66556008)(7416002)(41300700001)(4326008)(66946007)(5660300002)(66476007)(8936002)(8676002)(110136005)(54906003)(2906002)(316002)(6506007)(478600001)(6512007)(6666004)(26005)(186003)(6486002)(86362001)(2616005)(83380400001)(38100700002)(921005)(36756003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lJ4xBGX9XLkRMQXRzIr5zOuugfVCbeSw9HlpHaxM5a3e1VZfDXgudfBr+NCD?=
 =?us-ascii?Q?FriJn0bwMy+0nwaQmF7ZTWj3fgq8ocqJqnqcUleiF8kp8t0HbudqD8g9jYoF?=
 =?us-ascii?Q?aPdx3gI1I/B4g9sSxaRN7DOWRGTondp7O5gVsJOb7GcmRuMMD1tKcCDOK8Jo?=
 =?us-ascii?Q?Ah2v4stShejOVbEbITXg9oXe4P8D7l4aE9ZSTgm4yxepCL4EakmQHK8qd75S?=
 =?us-ascii?Q?0fA7a24aA2FqFWIWfgVFdTI8Ovxl2WLQCecTavZuXNqykhNNJKDMHJxU+Css?=
 =?us-ascii?Q?tE0b0DnLkBYDbBk6in/pdiRrqc8q2A7y0qeu3XIsJqK/fVavK73I3Ru09dDU?=
 =?us-ascii?Q?2t3S+ZjmIiW+VNH9dXqLJFf3pOsHDAHeiRgOQfyO1qkVW0oYW4yi321BBctg?=
 =?us-ascii?Q?xEXaxUIk8kb0uWoVXG6K6NhZ9Iy7r9IqWPiBGj5w082AUl0Y4Q+76PIr6sf3?=
 =?us-ascii?Q?b7xV430I4Rl/CNykShAr97fEBrLlw7Z1if891xySDkOgP2q0H1sD2jj5GxVd?=
 =?us-ascii?Q?dM3jGVnJq+E/pJNbl3kGhuoS2IR7ZsgvvK55oanCMgAwC9sl0oSE9J76tQ+h?=
 =?us-ascii?Q?0x1nyLDxebNWtVY/FLvjUNdoEZxsMPE28gBU+w10Tfkk1wdwL8mfX9z2wZdR?=
 =?us-ascii?Q?nYj7YTQG6BP+O0p1BZIn38Mrxj1SB/U5a78snWmRyNS0DeM6nctxwRk0PDBX?=
 =?us-ascii?Q?HZq1WVl0ukHonS2ar2j+yvV69IoLrN40iRZgiqso9HX+f49T7nuCYfdNS/XQ?=
 =?us-ascii?Q?mC1Q7GxOK2DIEulJ/ZtJykSFaYhlEIl7dLPMjJrDLTWm9+3Hj+zGQ3Z6znLj?=
 =?us-ascii?Q?atP+3WIFpMhR1MLLhuHh5dt6FMcSNlajrp/4LexPrOh61RML6mgqumARmYGR?=
 =?us-ascii?Q?F2ZsscvCrV9OlaCz5wrkXDxINLzQj4CmBucvDEMr3/zCrtzlCta3NPXJDNWH?=
 =?us-ascii?Q?Jyv7cOyN1evGslLJXW6dNcQr0fHp6dfeqUcf9hceuitCVX6LuuuUDvtWklOM?=
 =?us-ascii?Q?5C07I0JHTcU4hjbQ68xbhLG5gDlV0nU6FgGopkR5JaivZIgswTSUlsn+2DXK?=
 =?us-ascii?Q?+ZxS18qWxn/B188flZTBxdA4OEDMmYxm+pUJVI+mbdZzC5DeKYUp3zqebYbV?=
 =?us-ascii?Q?RhS5hjVnPJMIX6I/IY00MUV7tHyokDCEMZCQnRgJHPx04T4tkyngEWS6Jg/y?=
 =?us-ascii?Q?ReUyVsCidmUcTq1CTNObhtBgurIvevw439fFCWvy7A1b3u6Cj90rqOEkedr1?=
 =?us-ascii?Q?qXz4F/Hj3bQUwKTlhkBjPGxoHLkP7Sy3V8Yq2CTnkou5/kUEfKlR/EhIN28Y?=
 =?us-ascii?Q?oSbdRkDta6qQQapGmpHePJ9Wphx+Ceec7LT8RjlNoPDX1s3yNQr+DZaHXQqa?=
 =?us-ascii?Q?4S6wDIywg3cKb+eoIi2q0UYhxoPHwoVmSEEEHr8odNzF+YcnjUpjU12uv+w4?=
 =?us-ascii?Q?DlFvuHGBzhvGJctyHwnXFaKy+COFW5kDKeYYfaCpu7nOCC4nRIaHx242hcZm?=
 =?us-ascii?Q?chIYCSGD2HJXRYkBwi+DPGPmnRowcHcyxhVT3hn/nmfI3H6WS+QwQAgH85DW?=
 =?us-ascii?Q?Z9grhg32ugyuEYUfN1AODaferU1VsjcfDWilb9p7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fee1d6b-26bf-4197-5d18-08daef53cbd0
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 19:34:00.8990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vvKCmykmZswlK0fmiiHpWiBxdTxGIZFm+sgoeaP4iQO0NDqOqEsUxuuDe14+ht83
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

Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c           | 5 ++---
 drivers/iommu/intel/iommu.c         | 2 --
 drivers/iommu/intel/irq_remapping.c | 3 ++-
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index cbeaab55c0dbcc..321d50e9df5b4a 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2271,8 +2271,6 @@ static bool amd_iommu_capable(struct device *dev, enum iommu_cap cap)
 	switch (cap) {
 	case IOMMU_CAP_CACHE_COHERENCY:
 		return true;
-	case IOMMU_CAP_INTR_REMAP:
-		return (irq_remapping_enabled == 1);
 	case IOMMU_CAP_NOEXEC:
 		return false;
 	case IOMMU_CAP_PRE_BOOT_PROTECTION:
@@ -3671,7 +3669,8 @@ int amd_iommu_create_irq_domain(struct amd_iommu *iommu)
 	}
 
 	irq_domain_update_bus_token(iommu->ir_domain,  DOMAIN_BUS_AMDVI);
-	iommu->ir_domain->flags |= IRQ_DOMAIN_FLAG_MSI_PARENT;
+	iommu->ir_domain->flags |= IRQ_DOMAIN_FLAG_MSI_PARENT |
+				   IRQ_DOMAIN_FLAG_ISOLATED_MSI;
 
 	if (amd_iommu_np_cache)
 		iommu->ir_domain->msi_parent_ops = &virt_amdvi_msi_parent_ops;
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 59df7e42fd533c..7cfab5fd5e5964 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4464,8 +4464,6 @@ static bool intel_iommu_capable(struct device *dev, enum iommu_cap cap)
 	switch (cap) {
 	case IOMMU_CAP_CACHE_COHERENCY:
 		return true;
-	case IOMMU_CAP_INTR_REMAP:
-		return irq_remapping_enabled == 1;
 	case IOMMU_CAP_PRE_BOOT_PROTECTION:
 		return dmar_platform_optin();
 	case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index f58f5f57af782b..6d01fa078c36fc 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -573,7 +573,8 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
 	}
 
 	irq_domain_update_bus_token(iommu->ir_domain,  DOMAIN_BUS_DMAR);
-	iommu->ir_domain->flags |= IRQ_DOMAIN_FLAG_MSI_PARENT;
+	iommu->ir_domain->flags |= IRQ_DOMAIN_FLAG_MSI_PARENT |
+				   IRQ_DOMAIN_FLAG_ISOLATED_MSI;
 
 	if (cap_caching_mode(iommu->cap))
 		iommu->ir_domain->msi_parent_ops = &virt_dmar_msi_parent_ops;
-- 
2.39.0

