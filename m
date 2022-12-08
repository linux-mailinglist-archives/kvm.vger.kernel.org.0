Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B6C647741
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 21:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiLHU05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 15:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiLHU0r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 15:26:47 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6190384B50;
        Thu,  8 Dec 2022 12:26:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bPY/c0bjiiTO2dosHOY8ymvjDmUk6Rgf1abI96QarTqkY7N0pOvS0QObRE3Cj1geu9U8L5TNLb/oNjATRKyXePvjMfFI7UJlLry7IPf59jaMdDqnEmtAq2nIajynCevHsGRfumO6j4NVlDHwNHGtyh/ufVc8soVS3uU/kLIN3sURh3k0ntYaDPoAHDEBfGzuyzH1CHvoceHitBR94Tz2hFsNFh1pxiedfLLxDaaT6eqR5QAvWx4krqDKHxZfIo/8nX+pZ85ze+mj5y+JdLEl1HkttdiTvbgBhr2Auli2sMryYVMNxMe/4dfiNy0UQ+9bay9UyF+XGq2FA8nRtYs8SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=89goVtnC6sgoworYI8ijFJgyNMrqqj1BeZ5V+Cirw+g=;
 b=GHK4/MmFPlsuAYTBgIbQQ4T8TS9xAecIfNzBHuAgfVUNJJDlvSe9yqUm0gP9vlJ39MKqJmNFuV5wRnWYnza11eUesjYJn0zFG+xOBbATEFyqeVdLFQagqvBjyrRN/XpaEr/nkzAaAmHwj+p2pKLxOjHzrrwBSY+21ft1zPJKatkwrV0DOfKYreYnaeseWc14Wg49S4i77vovqkyo9mJo22fe0PD2qi1QLMSZsI9CEDsl3TMhsSXX1i/pH0fTDWRuRjTDZqznyjJUuhNBOEnLrv+qDFBxbssVr+sqakiGTDb55vgvOu1TMAwfCdpSwb9nr3ARqppXlwDTC18Jr5Q7uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=89goVtnC6sgoworYI8ijFJgyNMrqqj1BeZ5V+Cirw+g=;
 b=kqsnHW692UwhZDp+z7dNchchjz4A/IWKVSVsyj1wqOyRPruR4njB4E9vDyZ6tQQf8GUiIsCQ6nprBDicFy5PMCkwZeU26631sOmfxuht43jHRxuLM+0ePcevb4BnxK2g3CpVGHQEZk4KwVE+9Bsqnp57Uhd0Z7hUL3W/c+R4pT9Fn+Pr2Ii7JYybVpuSw4oi80jn1hurwwAEE/kIXXEqFHZEf/+52Xqk7zVPDryVS+POGo/ux8Sq9ZIhRwmSjXL9tXCY+YdkVsCUOLWvi7Djn2PHPtK/GIsxs0+8vCw5ONt8lcFxO3RCEvPicc1yrHjmhXyIwzf4L+KPjg97qnVCwQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6966.namprd12.prod.outlook.com (2603:10b6:a03:449::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 20:26:43 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 20:26:43 +0000
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
Subject: [PATCH iommufd 8/9] irq/s390: Add arch_is_secure_msi() for s390
Date:   Thu,  8 Dec 2022 16:26:35 -0400
Message-Id: <8-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0232.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6966:EE_
X-MS-Office365-Filtering-Correlation-Id: 39e8b42c-1c62-4168-92e2-08dad95a829e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sXS37TGQDx8YhaSmxS1AUmY0OOgyS323uohvZ8+DMA6BBuOo9Uosw274+Z8UUSnpJ7Ky0KDPzlE6LtM1aJGDS8QQmq7BxfrjawJET1f6bjDblWbtZ7hpPTwrhpZCzwBjitRDge10Laq8k0ziweqySmJbOeEf2qf1NLsUah8E8VfWqcvEVirmsajWvOiuBW+2kmRN2Jyzmd4Jz1EHuogRV07+5dm2++b33SYp2HTWUZyENpztgDHRPS3vBcQESP8iRxKEr3DHHrqaZ8B6ICw2w9XSmIRCS11cPqW23euYw43c8q5ji0vA4EbrOLSAAF4zr+XhblRnUFGW+tsv9O3s69i1fMu4ECmjbXN4hbPPW5gGvuqBLR3yMjkC0YHt9mWojF/Lww5tie0+Fg6UetSXSaP8xxM1E/Cfw+Hy5Roo2jdMv6pi9HFSgZe3H5tZLIOAIZbt7d0Wm/7KpMYrM3mcV3VP3JRoo17Lk5dADOZyxt1Xy+CPNlKHSYztmf7r6pccGOpDmfVE3o9b+qmMLLHOqZ7gU8YRwquizTZvHotOTQhUudIctzWAXLswcTKFlJuVWHiEt98dWyMvLaWVzWldpAvnTJxqOX/uhWDWTW37PUKHI3hbYKPJATa0BuF8akm2hKUOOEs82eJyUW/xYTPSeEfo7hYcfSar3ndx3++eCzQGwH5PlC6odhLcRR4eE32o45732wr0J/m6UMsn/yBJ+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(451199015)(38100700002)(36756003)(86362001)(5660300002)(921005)(41300700001)(4326008)(2906002)(8936002)(66556008)(7416002)(83380400001)(66946007)(316002)(66476007)(54906003)(6486002)(110136005)(2616005)(478600001)(8676002)(186003)(6506007)(6666004)(26005)(6512007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a2ulFypLBP1XPITmOqda/RRhh/uLqthgIViMnOKCmTdPtEV+2a14kOh5BMeZ?=
 =?us-ascii?Q?5JUEU0pOcM8vo/RrmW87zr3rtdn94JWEYtXPDZJXJ2ctJCHS/mmIWqmgKzHB?=
 =?us-ascii?Q?OQ9dQqNGBfA0SdWIr91U07nhdOpWaDQrckifol8L/zf0ycg5CJKXWoiKlxPH?=
 =?us-ascii?Q?dyQ+KhcG73X412mHnNZzgf0CgQ18LjlOdcirb2sL9FEsi/jW0utNXHhju/pR?=
 =?us-ascii?Q?FT9aSq8Ope5uxDHNoLMG09V11lKRTddbMFI7eF/OK4D4SlTsUe/T/2BGz9qy?=
 =?us-ascii?Q?xFMgF8bldDYDJrk+bWNqZcv8IM8SYYs8ZNMAhAa7I9bESwQ0rwtCZ5pZNgPk?=
 =?us-ascii?Q?b3cONINu8Eqt3p0NIWxn3l74OT4Ed0mOOlhDkfzSrgyN1PuhUbrN+6+fq2VP?=
 =?us-ascii?Q?qECRaUVIXWRHVIzLIXRCiV/xuHI2TnylEt87410V1wjUEijLZGBhh3nR+yz9?=
 =?us-ascii?Q?iyswNMUx/h9pisTUttxyXMMKEKk0F8la0IvQqmEjMT/Y4eo7KVS4U4VQkt7u?=
 =?us-ascii?Q?KUrSUCxwxRe15vzzQ+eBMKuUvqyuwYiXfmjiEhioGuh/nDp21FWdJgw2m1FC?=
 =?us-ascii?Q?zQ9M3gbwJ0GCe3/m5JBHNdCLrQBmz8s2759yHDs2ktKVz1BYBakkELHBENCb?=
 =?us-ascii?Q?9zpz54oov7AVX2LESa1s2Y9jhfjF6xELpfe2rAAs9YckeLhAUzFyYoKAvK+Z?=
 =?us-ascii?Q?peQXB5wMM383th58MInh45Nw3tEIqSyHME8yE/oVD1P1e6VFOo06O6TJFzB0?=
 =?us-ascii?Q?8RC6FVAmmVreRANWsUZwXr3HaVvjZOOanA5ILiNUfEzqj+z8Czb9qgyXEfSc?=
 =?us-ascii?Q?nBfyX6vkICCaJ9z5Xy2h2smzqvrPzuIbwvJk1mnwlicBqwYbAdiqSGUpElUq?=
 =?us-ascii?Q?ZKPDyuWnoOcrOawUQA0h1xVwVOPqFSAJfQk8droYdWAUdBEBJT54C86BRgkF?=
 =?us-ascii?Q?BBiQJgi/RUPt010J2GbiXG8ACG9/fLYj8Iz2j1EtRmaFXF1RicFSaAKuypgX?=
 =?us-ascii?Q?G8SHhJuHxxUnnHCJRhxN0u50zZ2YumDFjgLjwj7HSB+Ag0XYlt1rSWyNDd7T?=
 =?us-ascii?Q?SnSrTXRNg5gRyBdGEnYtCC4PxTZd2rj8HADdu78qXiUFZ/DE6orltOlHPlpn?=
 =?us-ascii?Q?rqJnoUjs6SlfwuUuFXz/1D5B8iggidxQuCLSl08u3gjhj4VUgmvFt4jqYV0g?=
 =?us-ascii?Q?u27gN8b76UonbJiVqq6VmtPaKbavZNWtDkTLRg8ZqSiJRXBaUu127q93zt1c?=
 =?us-ascii?Q?jhfkC8i3eac7FDpZxOT2Ho+qXtBuG4mGUHjG41Vqi8WyvDNlH9de3gH2q+DB?=
 =?us-ascii?Q?yfnGDQ6U0s1KzLT8eYVrIUx8Ux4Q8SC3ssUO5RgFaQCkgy/DK/vQXft2x+h/?=
 =?us-ascii?Q?dgNjtrTwrE+J6THjfYN8tlbQP9rX2be3C50lsD1mK17jOmanq+HzTseBL3p0?=
 =?us-ascii?Q?XJSigwDca24nLugpUIgrbSNWInxFRLQPoEiN19SLAQt2T1PMBPGwmg9kCSn1?=
 =?us-ascii?Q?LPqs5xe/DYTtSUKLTTmwqaiAEaQsaXL2esdGMkweT+CqNz5D8ggXi8aKpQfF?=
 =?us-ascii?Q?b0LM52FD5/eju+h5x8Uu6P40DOx5E1c9N8QIvrh7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39e8b42c-1c62-4168-92e2-08dad95a829e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 20:26:39.0716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cvofKnY7HitRyS/p+8Wqo7VppZIDxh5d/oiTmUj7XQ85dPwFFd3IlbdS0s2w3QBl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6966
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

s390 doesn't use irq_domains, so it has no place to set
IRQ_DOMAIN_FLAG_SECURE_MSI. Instead of continuing to abuse the iommu
subsystem to convey this information add a simple define which s390 can
make statically true. The define will cause irq_device_has_secure_msi() to
return true.

I do not know if S390 meets the definition of "Secure MSI" if someone can
explain how it works I will update the comment in the arch/msi.h to
explain it. Please consider updating S390 to use the modern IRQ
infrastructure.

Remove IOMMU_CAP_INTR_REMAP from the s390 iommu driver.

Cc: Matthew Rosato <mjrosato@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 arch/s390/include/asm/msi.h | 12 ++++++++++++
 drivers/iommu/s390-iommu.c  |  2 --
 include/linux/msi.h         |  6 +++++-
 kernel/irq/msi.c            |  2 +-
 4 files changed, 18 insertions(+), 4 deletions(-)
 create mode 100644 arch/s390/include/asm/msi.h

diff --git a/arch/s390/include/asm/msi.h b/arch/s390/include/asm/msi.h
new file mode 100644
index 00000000000000..e3522bde3e9c90
--- /dev/null
+++ b/arch/s390/include/asm/msi.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_S390_MSI_H
+#define _ASM_S390_MSI_H
+#include <asm-generic/msi.h>
+
+/*
+ * Work around S390 not using irq_domain at all so we can't set
+ * IRQ_DOMAIN_FLAG_SECURE_MSI
+ */
+#define arch_is_secure_msi() true
+
+#endif
diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
index 3c071782f6f16d..c80f4728c0f307 100644
--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -44,8 +44,6 @@ static bool s390_iommu_capable(struct device *dev, enum iommu_cap cap)
 	switch (cap) {
 	case IOMMU_CAP_CACHE_COHERENCY:
 		return true;
-	case IOMMU_CAP_INTR_REMAP:
-		return true;
 	default:
 		return false;
 	}
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 75c2c4e71fc34c..8efbf34a86f247 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -48,6 +48,10 @@ typedef struct arch_msi_msg_data {
 } __attribute__ ((packed)) arch_msi_msg_data_t;
 #endif
 
+#ifndef arch_is_secure_msi
+#define arch_is_secure_msi() false
+#endif
+
 /**
  * msi_msg - Representation of a MSI message
  * @address_lo:		Low 32 bits of msi message address
@@ -660,7 +664,7 @@ static inline bool msi_device_has_secure_msi(struct device *dev)
 	 * inherently secure by our definition. As nobody seems to needs this be
 	 * conservative and return false anyhow.
 	 */
-	return false;
+	return arch_is_secure_msi();
 }
 #endif /* CONFIG_GENERIC_MSI_IRQ */
 
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 18264bddf63b89..aba4f12df190b7 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -1644,6 +1644,6 @@ bool msi_device_has_secure_msi(struct device *dev)
 	for (; domain; domain = domain->parent)
 		if (domain->flags & IRQ_DOMAIN_FLAG_SECURE_MSI)
 			return true;
-	return false;
+	return arch_is_secure_msi();
 }
 EXPORT_SYMBOL_GPL(msi_device_has_secure_msi);
-- 
2.38.1

