Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18D664A76D
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 19:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbiLLSqw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 13:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233335AbiLLSqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 13:46:23 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBC317400;
        Mon, 12 Dec 2022 10:46:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QZJIS2+aVb1tHBDovbEzvNSe70WVUJkwxsTY2ETTNU768czA5NzuVR9Ckja74f9V72Z2kI7cBq0CRz3mAyHOMOX26Yt1QH8Ve1dj7TIQpvhrw1ULb/ttOTw2Ky/oh7yXHxFLSJatgsmlu4Hh6Suz2OqNZWh45EY7P4f92k4Fkt4sPBSTUEaqRCeG3oMPrNyTX1h+hyfIIfN91smFlnnOlqDS72muYVRSVxJPeu5oYiV1dzH1nQROOGbCdsCFvY8/KZ90dpcYnx2CEHeMn8IOP8jKqrVxf0/Eg1Jm/lTqHlA6HZh58JOaQjDiVTa4ngR7El1fzLq1W8Lu+y9kkD9BCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SpAyHAcUkQ5k5tqlYycaTrAdXIe4UZ34eAsquonhUpU=;
 b=SsR6vh3pcZnwJ6BwoDWcgYimj3zoj4X2erlsHuRbdS3+CDuUOiPT+rCnu9LeMhhaHAhJ42mscfdRAr8VVUCdEyPy2bSV0+40HL+HJTq+DSr/8+ochNWuT0C5ZRmQibuienV14ppu1+D+FnnfS6Q1ySMaSiWQkzjnJk4+Z8goWBnZdJJcpEQ+Z9JHnlzqw2i7FTEFBQh80X3yIMXcvKkCY2NLcxbv1VW/GIQUzfnDaQrStCpphis7Cxyr+dymv5TrZ6mYbWtt1FQpkMPBobTV7VoxzTQusVUJKD3hDwUDvc7c5m+VoVTBHILSPxhsUDo/bVOXIaCRYN/Wdfw2XlFGbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpAyHAcUkQ5k5tqlYycaTrAdXIe4UZ34eAsquonhUpU=;
 b=m+jUVafXy/o59YYjwOC5eC9/cn2r7lqrAqBHuA4toVB27OLlJBLUVIhdttILZ/vSGBAj6hSVBGnIsMcS7gLS0xNgYK6cdoXluutQV0eyBCSXJL+GnrZazlKVmvB2UMb7g6Wym/Zccyfr5MvN+UTtyd7p6e6UWNnyQhQmuy9AMcAlmD0XFaPQBwlpM/NxqwsWC7LvHjx/Y1sxHlYm37JWHTFGlw2ctEid/fjbvSJgLP/gfxAukmx9fsmFUBNAv3/N+9sIBQVvrioXGPK2PkaEcz/aEiCziTK3wwHYPXUYORDKFa592utOWPFddNfO7hl+B3bf+6qtABRzyE43gzmcRQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5748.namprd12.prod.outlook.com (2603:10b6:8:5f::19) with
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
Subject: [PATCH iommufd v2 1/9] irq: Add msi_device_has_isolated_msi()
Date:   Mon, 12 Dec 2022 14:45:55 -0400
Message-Id: <1-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR04CA0012.namprd04.prod.outlook.com
 (2603:10b6:208:d4::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5748:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b8a1ab9-1c36-41d9-4238-08dadc711fd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N+GPQr9+Qwdqt24fpYACEA70u2rjnYSvlOSnm5xhtsYo3fJSVNX6SrRYv66dbtDShkIUByhN0SlBoBKFEAwDyqR9vYGSOwA72fOUnV7xRC5cnmReO+yW8hd2ew4YHsoAyG+f95OBsv2WI+4F0nXBITq1w1l1HoMCvGnCIA1sttiIizP1rrMcNn1bjCq2qPA8dDTTkAiaG+faXZwe6OEC+483S2xPA5VJW5m+8P/rWkzfRwuIMa9ouTZsClUQmRV6/UsXT20KaWJef0SKJmLv6bDLIMeChRf59BWrjwVvxwLBE3/dBgYVzIN3G22CNd83MJW0gppl0u6IWbPxK1rVpW9XRWhh1t2z8I2tnVXPWL7tHKbfytEoEQS+vR/g++g84wI68rkYX9jo7bYBfepd3ykO/N4h+LU0lSLBUFWg+jfD3NlfTk5JfOAfDPDP5luoPGxAet+rRn6x99cu/cBb19FE4tPjGa+l1DFEAADoVnbrp093YmorfApeJWNXsf2tUPD0f0JdRX9ul3hS5r/v1gVixPahIBBHuTemqm9qsYEe1RQ1mkjgmYmpAOyDG6oYEIpb7+/VlG4enqR7aY1uGF36smAzkxjqVH52uEtJxkaB/fkNzPRM0ENp//RQ36pZqD9Y5KjuSKEremTYJlIcUH0hfouOIFo9xSUFQwsTQoGXTaqSM+k6qmHdui8p6RJ7tg2cgpar0HWfDc0ImdpnZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(451199015)(921005)(2906002)(38100700002)(41300700001)(4326008)(26005)(36756003)(86362001)(6506007)(6666004)(66946007)(54906003)(8936002)(7416002)(316002)(110136005)(5660300002)(66556008)(66476007)(478600001)(6486002)(6512007)(186003)(8676002)(83380400001)(2616005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vysBE2tKEi4fahls+ypDiPKrI5W4yLC3BVeK+JZSja2BsrmTLNjJ27Yt6OWX?=
 =?us-ascii?Q?lGPvX3obaDhZOgnpWw0x7k5kGBHE5WvocpRlQ7qeGgWVC7DGJZz3UkP1Yvqh?=
 =?us-ascii?Q?RIOHDzY3RpgsBUsB4N8PXs8hNSjrA/GpN6Hg0W8KA2bpc9dK6Qc0ambvA8yn?=
 =?us-ascii?Q?9f24PaG1U45JUBYjlyp0WWiTdsGD9wSkleNoTt7uOdDwM9xl5fcpztoh/S8F?=
 =?us-ascii?Q?j/EiUrEf94cqg1nPDo/xossInJ2rKnyJkOtl9aN4jYj4LwHLDwvD8fDCbfwp?=
 =?us-ascii?Q?EG8rUXGGtpJB9DC8hT2Fw8OyhZEm9PKejz10kgEZ4V/oRTo9EsdtT4DSiQpu?=
 =?us-ascii?Q?B9fxqqu6BEpoUdZMDAWPsemB/IERa+LMT8COLxjATFctxZO2K0XZyhM2AqVn?=
 =?us-ascii?Q?l42h42sH1SYvFvbrAA1h4N/UsHYHUTlR9lNgxpbiQHV7DD/DBsV/PJJy5cZJ?=
 =?us-ascii?Q?YZ/3zaGeN1qVS2JnFwa6hKGj4Pvpw9pFQLiHVvgsy8mahs//KCd5WLQ5e9yo?=
 =?us-ascii?Q?QcT8fyxOA2kMkSpyTE/bYSMsYC7psYR2B1yfKZ1gXLolrFtSQGYo5YByr9eP?=
 =?us-ascii?Q?z6elHvszP+akefQLvXGMDCwGEWW1upIDG80oipuTvHuFxncz7MOjffdz9VFQ?=
 =?us-ascii?Q?Vii7MApA72S2fTTEAkS5ElNR1jVbsPO0ytR/UqfhwUDtUfkTzspqY/jkwG7x?=
 =?us-ascii?Q?UV3x6lxQYmFEsIURJD9NJphAyHpqxReF7pekZZUmdUxkOBUnfd/SKiMVjhoR?=
 =?us-ascii?Q?lEJ2o/7SjWWdStq0MaNvacaX7yB5KbHFoTK3KAxkdAQZ9B+AHu0fFCIcXjz/?=
 =?us-ascii?Q?EPYHqBZFvM+lITXOfdJfPFtqUKS4auNT3qT+It81nmQjK6wpiOBhssA7Y3je?=
 =?us-ascii?Q?JkLVktUtfIO8iLMtETzZ8uME3v+Z/pGM+kiXdwxb1bYSMrnrRpmPDJYNfa7x?=
 =?us-ascii?Q?2moDYXEFzldJGei7By10KC5S0hNQKPIEwvbxgme1sGaK7BhLVGP4xwL+wnoY?=
 =?us-ascii?Q?/r+NmdctxXLYmfWzDvIjPgUUOEz9UNsSZ3VWs3sJZjQruzbK8v22c2g5bGGc?=
 =?us-ascii?Q?2dH7GVia7hjyS3EVpla0fW0MxCcVujbqX9eEn+u++/9vanra/0nMeIJiHC/A?=
 =?us-ascii?Q?7RBsn7Ow2fBclcjvvdj40YR+3Zrk40yhe3ogDvE5QkvPuTgbs7ZK3mgl9fQd?=
 =?us-ascii?Q?kydlNDbBYY56GyL/qZH3BsJ4aGnpd1mM8WQPuNZzHVg7vpYnNYidWYMAC/Nm?=
 =?us-ascii?Q?/hJX4uW3HteZVAgi0PnKS8ISufD1niNSKvM5kLyqUcgF+OCWqBNCDJkmez2h?=
 =?us-ascii?Q?Z7Vs6sRcqpSVOaDTeqw5XZj7iadd8LA0MbWNs8H2XoG7liZcF0IhYR6+vxRV?=
 =?us-ascii?Q?ZVWBVrxstqzzxgBmDVzcEHdLpxLhv59gp/sVktL8vTqVCIb/e22+w1hd7mBU?=
 =?us-ascii?Q?GrERkbTAOjLTsIw2SoAhzAu3MT28o1zV9TKGtYRlANkUsmWueJ/eFtcyVgcf?=
 =?us-ascii?Q?OT9USoTK0zbXjR8WMm1DInUuyZvHIJOeEJV2uUtNGz4LdobbH1Ssbm8Wuj8w?=
 =?us-ascii?Q?yv1alVa26/eJv4qCmVLLbmZmcp6b+XOiqSHxJ0hz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b8a1ab9-1c36-41d9-4238-08dadc711fd1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 18:46:05.2062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qY5YU/3ML1KNUCK1GUeHLyvC0IMYKu/sggpEbO0yT03xRQVFNGxrpB+Wals7gVmT
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

This will replace irq_domain_check_msi_remap() in following patches.

The new API makes it more clear what "msi_remap" actually means from a
functional perspective instead of identifying an implementation specific
HW feature.

Isolated MSI means that HW modeled by an irq_domain on the path from the
initiating device to the CPU will validate that the MSI message specifies
an interrupt number that the device is authorized to trigger. This must
block devices from triggering interrupts they are not authorized to
trigger.  Currently authorization means the MSI vector is one assigned to
the device.

This is interesting for securing VFIO use cases where a rouge MSI (eg
created by abusing a normal PCI MemWr DMA) must not allow the VFIO
userspace to impact outside its security domain, eg userspace triggering
interrupts on kernel drivers, a VM triggering interrupts on the
hypervisor, or a VM triggering interrupts on another VM.

As this is actually modeled as a per-irq_domain property, not a global
platform property, correct the interface to accept the device parameter
and scan through only the part of the irq_domains hierarchy originating
from the source device.

Locate the new code in msi.c as it naturally only works with
CONFIG_GENERIC_MSI_IRQ, which also requires CONFIG_IRQ_DOMAIN and
IRQ_DOMAIN_HIERARCHY.

Cc: Eric Auger <eric.auger@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>
Cc: Bharat Bhushan <bharat.bhushan@nxp.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/msi.h | 13 +++++++++++++
 kernel/irq/msi.c    | 27 +++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/include/linux/msi.h b/include/linux/msi.h
index a112b913fff949..e8a3f3a8a7f427 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -649,6 +649,19 @@ int platform_msi_device_domain_alloc(struct irq_domain *domain, unsigned int vir
 void platform_msi_device_domain_free(struct irq_domain *domain, unsigned int virq,
 				     unsigned int nvec);
 void *platform_msi_get_host_data(struct irq_domain *domain);
+
+bool msi_device_has_isolated_msi(struct device *dev);
+#else /* CONFIG_GENERIC_MSI_IRQ */
+static inline bool msi_device_has_isolated_msi(struct device *dev)
+{
+	/*
+	 * Arguably if the platform does not enable MSI support then it has
+	 * "isolated MSI", as an interrupt controller that cannot receive MSIs
+	 * is inherently isolated by our definition. As nobody seems to needs
+	 * this be conservative and return false anyhow.
+	 */
+	return false;
+}
 #endif /* CONFIG_GENERIC_MSI_IRQ */
 
 /* PCI specific interfaces */
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index bd4d4dd626b4bd..1c6811e145f170 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -1622,3 +1622,30 @@ struct msi_domain_info *msi_get_domain_info(struct irq_domain *domain)
 {
 	return (struct msi_domain_info *)domain->host_data;
 }
+
+/**
+ * msi_device_has_isolated_msi - True if the device has isolated MSI
+ * @dev: The device to check
+ *
+ * Isolated MSI means that HW modeled by an irq_domain on the path from the
+ * initiating device to the CPU will validate that the MSI message specifies an
+ * interrupt number that the device is authorized to trigger. This must block
+ * devices from triggering interrupts they are not authorized to trigger.
+ * Currently authorization means the MSI vector is one assigned to the device.
+ *
+ * This is interesting for securing VFIO use cases where a rouge MSI (eg created
+ * by abusing a normal PCI MemWr DMA) must not allow the VFIO userspace to
+ * impact outside its security domain, eg userspace triggering interrupts on
+ * kernel drivers, a VM triggering interrupts on the hypervisor, or a VM
+ * triggering interrupts on another VM.
+ */
+bool msi_device_has_isolated_msi(struct device *dev)
+{
+	struct irq_domain *domain = dev_get_msi_domain(dev);
+
+	for (; domain; domain = domain->parent)
+		if (domain->flags & IRQ_DOMAIN_FLAG_MSI_REMAP)
+			return true;
+	return false;
+}
+EXPORT_SYMBOL_GPL(msi_device_has_isolated_msi);
-- 
2.38.1

