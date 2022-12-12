Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8795064A77D
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 19:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233352AbiLLSry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 13:47:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232128AbiLLSqZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 13:46:25 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE36294;
        Mon, 12 Dec 2022 10:46:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kceNYD1nfKrpDBXGDGKejwRJGpNGsKewcidJAv2Io8SyMyvrNH05g+Ybf0CqUCNuG55jbyBNRrkWeUhBOAwCxHRNjo+eS5xhHKT73kPr0HhWvIo1MN5z668S9F3oZpSwWQsVx+Z9RFTjjMuuy4sa9oFuf0LidaajMvfN0W0NluVrxDjMiByJabv6eQrGibPemekjzwnNohvrpP4UIxOHJ8byZLXKB1a+j0Y46OFXfIa4rkwO/Tipq6kttRe8hyR4vlyelHnkyoR/Z6qde+xX8pobytjMM6mY+of43vphjHizP09a2Bn+MCpjGm62VkUFoqw9btpyEtEU5FdM0fs2jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CLo/PHcYgYCOcoEDyDo2mdLHIy/40rrhTedU87GBNV0=;
 b=Bd073b7PFWM+3ejRex3NIDRXhLQJ8vSmn+KlOfPN8TVH9/MHT/ZatROMfX54UGWu82Tav4H2U6lloxYTc5HeQOn2/TNcxWUtsNhQfjoJK94FNCL6zSiux1/yR4DxXN2l3SwaM9m1FcMDGTUadaWpx35wljHx/nnNJ4RNeStz8jKKbEVQKposwMM5mqJ2sU5cpiVGfFQzuVLB0FfQ0xdhfOLlKPuP7QNc4/T6mEGXxQ+EaVz5JuVOZs+skBfqWvsKN1jGJNpof4eOVdwvqBE2MOtdgStoJA8ILguH1BjI28TkWVH3B+3U+5k+tUO4pZo7Q7OiSJlKAZJysEtQcobBew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CLo/PHcYgYCOcoEDyDo2mdLHIy/40rrhTedU87GBNV0=;
 b=CnUKQhBtP9GJzp98fHg8IM9XbRZrg18IjGMH8bvqXet7XWKtc+A0B2T28KLEtP+4CvmCQwaZFYS1wCTjOc4uyGKX/aaIFNRO8MnahSVoK5knn9CSUrN+wu/m61gbRsY7ducm9Uh4Ivop0CLQfQ7lH3IwnOKV1wEb9cFeuodNmBQRf37l55UygcOAPL6Vm9xk+p57ctLpcad1SfOIZ1b8TXMdF7NkgFO9mHleX1ijG7HvHqSQVwACdZHLnOU8pDqqKbVv9IZ+AH5Gx0hJa+1qw77U4DwXqq6a03uuOKEGR657LkjkLJxsPIne8qTFksHG7an50AXzuPINP+uinjliew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5748.namprd12.prod.outlook.com (2603:10b6:8:5f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 18:46:08 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 18:46:08 +0000
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
Subject: [PATCH iommufd v2 8/9] irq/s390: Add arch_is_isolated_msi() for s390
Date:   Mon, 12 Dec 2022 14:46:02 -0400
Message-Id: <8-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0023.namprd05.prod.outlook.com
 (2603:10b6:208:c0::36) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5748:EE_
X-MS-Office365-Filtering-Correlation-Id: fe654c01-accd-4167-c874-08dadc71207c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 20fR5XNkzP0Ju+oYfhqCzii4ad1gQzCQRgoFej1t5npgEueNytopZp9OO/jvwEyU/ojCFZ3fL6SjHsR+OLRBsPL4ocj1vhuH9vRBJYrOzz8fiToJoi4Sg84uKwPlievK+cipM3TW0Tf/XGsTt+vHUPR0K6uzNkZkJaNbV0uuqiJYxAGiLp4iVEAuXOF676pWBA8JP84JPCEORy2DynTf0JDTC03oSZI8Oam8+8ylWbUNEFf13hUsC73liwrYu6+ZEMqGuWL+EDD7g7GpoLdmrqkuzSFmzUEvmx2yyPBTzJFWTanu0foISGSLy3tE51zKxK4dvVOFlTe41xnxE8w0FZJ335qXEWJvYu5Nws0TGs8UcomCNKPhawkN7VZoQ1kiHroiojkE6VpSdotME4w8vub5bO7GITCLyEs8XxTvvK8EO2jrhtCPRfvmj6awjgIyZSR67Tdh5bkywR6i886HCO3OCmdPxKMB2KL0Po9f2JHB5Xu5/5j+nP6luT3vkH1/tyzSRjtuYBW3aNupwli/7ocCo2SA1PkRQwdj8zWCZMxgfE63kAKQ/h7dTYnAeK2L8PDe/rz1fALqRnlrJQRcSCi/SXg5MW8pyr2yBrcDNEY8tGJBQDBS+AvBCevMaLUqPaFlJH2pXAPxUYk+ErOBEu55ejNON3IzGElPN04xwllhp5LA0adO8O+Cr9rljy/l9EuMFlI60swTIpywYuQ+mrZnjVXl03u7rO7+yW8jKzZdr4pqiN9FJxESplHfLHCl7tDOxqaTQKSMhG6IKOqBxsUIyM8gDJVffHXqkT0M/c0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(451199015)(921005)(2906002)(38100700002)(41300700001)(4326008)(26005)(36756003)(86362001)(6506007)(6666004)(66946007)(54906003)(8936002)(7416002)(316002)(110136005)(5660300002)(66556008)(66476007)(478600001)(6486002)(966005)(6512007)(186003)(8676002)(83380400001)(2616005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vmMlrn2FNt57wwKM7lpgGBAxfmRyFQzJPiJHXQAtI6w//pTSWDY76dxm5nZL?=
 =?us-ascii?Q?1Yup/aZlZ7IaH+ED0r20Uo/ofb7/KRU2atR2sL/C9kGy9ZJBfqvr8Vsiqe6S?=
 =?us-ascii?Q?ghH69XCLqFAJuSgFrrG6VHo+7qVqOItl6+2dnsHgNHlpJrQN4bnWphVAwKa3?=
 =?us-ascii?Q?poHxntIQEgZUyylumjvQYtIU98W03diFCKx8M+sRDp7LtC5D6BSSUod4ylXr?=
 =?us-ascii?Q?cQ/xQ91mLqpswSXZ989a4N8ryMAedyfoJp81+bR9F23sBZJHRgqPEkfmr/v3?=
 =?us-ascii?Q?CQ9Qs3rckoipF8mhAOrBmRMcaYs3+jewL4YWOLrwvoFLyTVHeqJLCJpOhOKg?=
 =?us-ascii?Q?B+yvDDrIBq54GHpdTRgurzMKON/mms0MMpMoQq2B/tE/rpY4SmBVnclPn1oO?=
 =?us-ascii?Q?nOwVWddNY7yACdtTTXLPrIOFTbyHl+Zmz/OsmKPanRFwjGsQTRaXcyw0RYve?=
 =?us-ascii?Q?1X0giNH3A4J15TIcCorjkLhkYKvLQMWMTyWBBMUSIDMM13QGZW4Bn0n8XIfG?=
 =?us-ascii?Q?2tRyKDt3t4lwdBWtIFD3E9IyMYHZ+8OY/PzL3aWbnb6X/wVoOAX7/moYZorG?=
 =?us-ascii?Q?MPyo3+feAjN3t6QxJAMdFtEuz77iVcZ+1I1vDFoSU4xUNjWo9Hki/wjrrq2a?=
 =?us-ascii?Q?pjc3K/8taDonYKQkmbP2mCyxf7CR96wizm0A7oaEtQcbT7BuVoK3AbYrZbDr?=
 =?us-ascii?Q?b1KA2kmAbAv+TWxJyV6whFcuGr5K3ywkU+eZs1izi213M+DlmK7jJTU78r17?=
 =?us-ascii?Q?ACiyjQmksRrQikVBGYGy1oEgA8ROQbLnUKSbDaLgReZo8aJnm11CtiyNpaWV?=
 =?us-ascii?Q?c1c1ny7SxvJkVIflZuhIG1d4I/gatYf7Vtw1PtaVAKxt74CNmqWOweN5U6/G?=
 =?us-ascii?Q?Z1vlWIDskXWNh9gRI86nDwtFBDKDwHIc4IRuPQCZdFdiyN5fUVcPyFShBaht?=
 =?us-ascii?Q?ORaDtJkj4TWDQyvTOeR8uE/E/WVIRCYxGyAWUR3lDfrs82OwUvS4Uz2CW2Rh?=
 =?us-ascii?Q?wF0XWcocjrMN4sIFKi9ttwdaYFs8ai5AVOQPnoBZiekIocnkVQMxq3pskTqZ?=
 =?us-ascii?Q?+oSjnHvNZ0s3Oe4p9/tE8w5ooEjf2vRvo22/iyJ8Xn3P4qUmNm8MLGqWEOp5?=
 =?us-ascii?Q?Gy/VYBW2ynEfcA18mB/i9yolziBux1rPqs+WhO8cAdqtkLTh35oCYqlvcSXf?=
 =?us-ascii?Q?rDc+q9TxevtcXToB2qpE/lAK69esKk3hnBtwRHfIcJaPalkroBE+X5f6E8/P?=
 =?us-ascii?Q?R7zHDKbKUltjlhsGiOJpoih1RXlBv3Lp6ammLgK55WJXXkGNP9wDAxrR/7hn?=
 =?us-ascii?Q?ko/lW8/ipkzjYKx7p0lbIZY3yIwTTVJkMTAJdbSZMXThaKB/2wHtCJD2gPBU?=
 =?us-ascii?Q?aI+m7AmqHUYn48xPygX/aiegOzBhRM6yEf4hYxKY5iNebvfNEhO0d5kVgEeY?=
 =?us-ascii?Q?y+tAlE2Hz2EQWajcRuvHHddkbZlrcec0gzy5zuva7PrbM2JvJKXDu750ao+u?=
 =?us-ascii?Q?gqo7ssPetUgk1XlZ6oUL2HkX8RiId9YtpO+T9bPMZFfjpL+nwuhf4rZ2Oldh?=
 =?us-ascii?Q?hKXcyFr5zSbIvmIX+SypQUDjD4BO56fV6ljIzGZ6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe654c01-accd-4167-c874-08dadc71207c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 18:46:06.2841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5bKH1syW1Ql8F7fXx1ZyfDCQ/pJ5PXz3fD0qH/mbx66NOubt9MrMfh+umVqpfBIc
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

s390 doesn't use irq_domains, so it has no place to set
IRQ_DOMAIN_FLAG_ISOLATED_MSI. Instead of continuing to abuse the iommu
subsystem to convey this information add a simple define which s390 can
make statically true. The define will cause msi_device_has_isolated() to
return true.

Remove IOMMU_CAP_INTR_REMAP from the s390 iommu driver.

Cc: Matthew Rosato <mjrosato@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 arch/s390/include/asm/msi.h | 17 +++++++++++++++++
 drivers/iommu/s390-iommu.c  |  2 --
 include/linux/msi.h         |  6 +++++-
 kernel/irq/msi.c            |  2 +-
 4 files changed, 23 insertions(+), 4 deletions(-)
 create mode 100644 arch/s390/include/asm/msi.h

diff --git a/arch/s390/include/asm/msi.h b/arch/s390/include/asm/msi.h
new file mode 100644
index 00000000000000..399343ed9ffbc6
--- /dev/null
+++ b/arch/s390/include/asm/msi.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_S390_MSI_H
+#define _ASM_S390_MSI_H
+#include <asm-generic/msi.h>
+
+/*
+ * Work around S390 not using irq_domain at all so we can't set
+ * IRQ_DOMAIN_FLAG_ISOLATED_MSI. See for an explanation how it works:
+ *
+ * https://lore.kernel.org/r/31af8174-35e9-ebeb-b9ef-74c90d4bfd93@linux.ibm.com/
+ *
+ * Note this is less isolated than the ARM/x86 versions as userspace can trigger
+ * MSI belonging to kernel devices within the same gisa.
+ */
+#define arch_is_isolated_msi() true
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
index e8a3f3a8a7f427..5cbe6a9d27efd6 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -48,6 +48,10 @@ typedef struct arch_msi_msg_data {
 } __attribute__ ((packed)) arch_msi_msg_data_t;
 #endif
 
+#ifndef arch_is_isolated_msi
+#define arch_is_isolated_msi() false
+#endif
+
 /**
  * msi_msg - Representation of a MSI message
  * @address_lo:		Low 32 bits of msi message address
@@ -660,7 +664,7 @@ static inline bool msi_device_has_isolated_msi(struct device *dev)
 	 * is inherently isolated by our definition. As nobody seems to needs
 	 * this be conservative and return false anyhow.
 	 */
-	return false;
+	return arch_is_isolated_msi();
 }
 #endif /* CONFIG_GENERIC_MSI_IRQ */
 
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 7c5579d3ea4f79..3e46420a4f1a9f 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -1646,6 +1646,6 @@ bool msi_device_has_isolated_msi(struct device *dev)
 	for (; domain; domain = domain->parent)
 		if (domain->flags & IRQ_DOMAIN_FLAG_ISOLATED_MSI)
 			return true;
-	return false;
+	return arch_is_isolated_msi();
 }
 EXPORT_SYMBOL_GPL(msi_device_has_isolated_msi);
-- 
2.38.1

