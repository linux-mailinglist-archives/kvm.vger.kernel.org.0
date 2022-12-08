Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7C8464773F
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 21:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiLHU0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 15:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiLHU0p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 15:26:45 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE9C8427E;
        Thu,  8 Dec 2022 12:26:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lR1nVmP+B/M8BD/ODhw9VKzsgaVDnLml/SXrOO8EA/fgUasLgjyAQA6qFhafeXSMtXoQcx4ULwIPbf41VI4GniiTYbVSGZVKgykCwCUeZeycq/5zVrmSbqyJnu9Ra3yVk1VWJgCJ8yLKuN+jCBgxbWZ8rBUvDflbYT8O0L/xRV0/g2o4/FoXFZJa+C6Qn+14JWqirUAZnfm4pxpWydrZL1AA0g4huUcmyRWKxk63YJ+mFNQMXbjjNYnVCcnUyYWG8yOe60kADnWFIrsOspXYj+xNp9WZs4GTj/xUM+dLqNDGrHLzYLCyO5vKMIcJolV824Xb5Lob3tlctKQRYsXWjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KsBthhZkVasakyTGlPWvQQpo3fF7kAiiJxCZrQctMYY=;
 b=dEAv5STAnn5M2r6HKNtzEi9Me/WGhyPAoD5Iig8SH02NtplrR0KQ5olNnZHUinRZLw4HhRip7LXQJ3Dk4roF8u/5m11UHUWszeHChx1COGO6wrO0YgnEmCJtnAcVMGAs3OAx6lNWWOkT+4I3JBT7z1mwEBtK3DA+N+WhdjzJLogxAIbcZt1l3cOV9+Th05o5o9GH+rTZF9y0aiqqwdrn1F4RRlyviA2AUbux4hF6gYWpvtDUhjFU/ppK+5bwiPq1PfsZDRP+0lZBgnwaDORPeSwUcXFRJuZBVkvrb4vFYUktI4StjShqhHdBElGa58Or31EWIW1FJR+EmHtWWqpQUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KsBthhZkVasakyTGlPWvQQpo3fF7kAiiJxCZrQctMYY=;
 b=ju2Xm/vTKquc58luLP6eSl4xICEwZRX6RiNmEGu/7Ji8rm7k8ZJlWi3B5j7ndJeS87PlI7iMEiqxGV/4jFEw6dMdJsviNZEB0yWWE/eznjFfrrRlUGet0PMRwdwJgn6DM55Nh1TZ11mi81o+VulWQhr9RS1Lr2jMFvtAidc6BU97aihl5nQM9IC/e5VpJyw/67Qc25yuxsPsvcRH8ndtY2hxU1CdDyZDh4nUXxj7A9z/KTXdk1g9a2P/BjXu9iMDIHgDpiGXgiBAozqJdjb43A3U5bwdPJA9CBW00Z4az4Uo4+hAbKi46kdVcMONbbJR2gg/i3vRdTChC5kKWL7CNA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6966.namprd12.prod.outlook.com (2603:10b6:a03:449::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 20:26:41 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 20:26:41 +0000
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
Subject: [PATCH iommufd 1/9] irq: Add msi_device_has_secure_msi()
Date:   Thu,  8 Dec 2022 16:26:28 -0400
Message-Id: <1-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0070.prod.exchangelabs.com
 (2603:10b6:208:25::47) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6966:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f055923-6a3f-47cb-5a59-08dad95a8284
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7IXkjoWAadnYKK/D57Rs8oXy73GYEeq5s3TQmJazbw+cpb7Ns7vt5S68iDZ7c2IP1IKXXnOeghHB9cBEfjzPYb3bH2kI+F4VBNItEJH3hZ1r+6LeGDogyq781BIkaL6MfSuvhmJDS93BVCGHUK78jTN2FdGKwQX8GKuPFk2nmaZ+LEQjUpRRWucjlmwcIRFsBhzFUMUvy6M/vQJNHgq4MQszPN8z3yZ7A5TD3xjby/eYWtGKsG4Pt3gxnTf2oI50bAypBMUTd8VANiPXA83e6RMwajED1prRiZSIRcsz6eTXegynkVSRDu8Thkc+rdTW0A2QN3Y1AIUrhphmSwojn7qv3B6jix89Kc4lOCw2oo8qwckGE9G6gzUOqTkNWOE/zjs9Y3pqainYBCaDXxs3DWPZieYUbhg/qEkI96/JRhNf9ca2lu01T8FksnbQSIe6I/xTtRa6IQ4KjVivvBOEwIubPWMSzsWsbSyfn07RsPB3GrV7Lkm3toggX2aiuqh5OvgM8x/GjC9KF6ltGTOMm6hDJJFoZ2EtBRnFNSo2ddjQHtX+5UfwcwET2X4lg4sdb5j7MXBDlSxUzxVkvKN4KdRearrLL98M8ph684OJgxJY4cGrEZOhVMMJjzgQq4unGpUTbPd0o0PKp670H8X5tuey0a/qPrdaT+2zzmxyohVS6+TCskt1PzdCJmgAwlihV8gN+Ix4fDMND+E3gx9FIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(451199015)(38100700002)(36756003)(86362001)(5660300002)(921005)(41300700001)(4326008)(2906002)(8936002)(66556008)(7416002)(83380400001)(66946007)(316002)(66476007)(54906003)(6486002)(110136005)(2616005)(478600001)(8676002)(186003)(6506007)(6666004)(26005)(6512007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ICIfgxjlT1H81q2Pl9xDDKyUIranFq6VAg20DE5t5byRMARAxkpuJmvpxdiM?=
 =?us-ascii?Q?5aw3HrZ2UUf5ma6OcZJIcFo4CKtVEwZ6RkxSbpBNYirLM8azR7AztstG9OWq?=
 =?us-ascii?Q?NiR4s0teKonrsIvthpqsiMuQ80npK1LPE/i5UcCAU0nkW4/cyhmDSM7/n12P?=
 =?us-ascii?Q?j2d6uZ3Dwh4skZFCJOEWBrOIdAQWLKu5FKu7xCUITtfM7uyLvtBdA3KFc4kj?=
 =?us-ascii?Q?Pxhu1KRrWXV6R8oBvUp9IsO63FnWcVhT83qnny6dAPIsqEStVbcAHKI0cxoV?=
 =?us-ascii?Q?ahTzIYAiF3Ll88M+m3Z1BkHjtATNesQj8GBKwFqlsRmBtpcrKFalD6kMR3tP?=
 =?us-ascii?Q?6R4CdLLH7vbXOxiYj5N+cQJwWbqryvmj3DXC7bwBLe92pFMX4dUS6WIY2KRn?=
 =?us-ascii?Q?Y66tz90iAVeeYnoCdytXTXngVGzNQf9R7ZGmETqrvuvpXoKXtrEKu8nsLFVs?=
 =?us-ascii?Q?GR3zRV8EPR5Zo9m0/HgSoaeAVluGJNRQSvAFJEm0YvZq3YXcf5Zgm2+cj2dS?=
 =?us-ascii?Q?BcZGa8xWLMlFr/mdM1890TaXK4gR7gxdagGanVHTmsT0UhgPjyE6pH3gwvEz?=
 =?us-ascii?Q?57eP4aynmtHAtvPt9DnO+87MF5sY3xl/KP1hKU6WFbp7SVdSXxqcxR+EVOSl?=
 =?us-ascii?Q?l4RabO6O79jKcsjyZyzv2qHYGFNAeS6D5zJeABhpn0K7gtgeBbP7xZk6bPTA?=
 =?us-ascii?Q?IZMLj5zhjyUl1xE9TGGuk18AHw9p0Pdprx5Z6PQFOuUNwi7zG3GEEK9AKqO2?=
 =?us-ascii?Q?feD9jlD9BltEu28eifZ5Kc3c9YR+uVPMe2OlR8HtRoD1dZtVJEzU6MR3Odpb?=
 =?us-ascii?Q?XcR8UnT8zok4CNKp76JrtRN+gux8drFIYiOO5DTg8n2J7W3ai2aKLqK1Gjrd?=
 =?us-ascii?Q?nXXPN/GOFTK37h4gvhJhbM9r2mgCVlq+RMpwDwmKvf/L/fkNR2t0cfgphCHM?=
 =?us-ascii?Q?CKSTwOuWxH3Bhi8AeE4f77qo08fqysKnOFEh994uM6R4CVY111S/X7oOK9Ub?=
 =?us-ascii?Q?bmKniUqN2Vjuw2TE1vM8P6pTV5EI7F/9dPbwklcjZSCSTrpzzHpLV4OfwZKn?=
 =?us-ascii?Q?5zmXfKHQAQf+r7UAxCVxR3lvCImYwNBfx0+GEiyuVk5XRniYYGK9+bR2Z90f?=
 =?us-ascii?Q?yhbOXt9d7twVomyQlHujgooVDDbHxS3P212P2+BUMmF2NurWW53TV67uqbGi?=
 =?us-ascii?Q?ylycLMX15MUNEx2N5ajYbX4xS057x2Pv6zi0X73yUq81UOXwsXfcsWQudEAu?=
 =?us-ascii?Q?g8WWjTL+msddWb9sKo9+gtoCi0sgmq9lM2xapdoBw4fkjmEol36NPA+5DHhT?=
 =?us-ascii?Q?gKvOuV2njoHmdFJ/LM1T19Fkw6z4kWRlbQAlKrFGTS+5VrDxkGb3JesCFOu5?=
 =?us-ascii?Q?TiiUqp9pyR1NTzWjvVmIRveznf0f7QIPgGXjA7ervM0+xOm+g3S0bjTRSl70?=
 =?us-ascii?Q?lowg0SxGnVSM0JiZgjCRwtWmEAqDfCliSKu2SipSwKi/Tqdj80kxkGxYbGwz?=
 =?us-ascii?Q?WeD1pszuNGGRs6M3tGKyrtNyBiO6tBGg5roqJGBbGXgledi0FmYkUQj+25r3?=
 =?us-ascii?Q?WjUlOaRlF0/zkjlQTuw+vm7vQHI7S2LEHUopPCuL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f055923-6a3f-47cb-5a59-08dad95a8284
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 20:26:38.8841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hAE91joyHtqrdSYYmF+uNkoDOjRwOBe/AzRK3zc9NJsn+MsJPkCEX4qbJPl3QTW0
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

This will replace irq_domain_check_msi_remap() in following patches.

The new API makes it more clear what "msi_remap" actually means from a
functional perspective instead of identifying an implementation specific
HW feature.

Secure MSI means that an irq_domain on the path from the initiating device
to the CPU will validate that the MSI message specifies an interrupt
number that the initiating device is authorized to trigger. Secure MSI
must block devices from triggering interrupts they are not authorized to
trigger. Currently authorization means the MSI vector is one assigned to
the device.

This determination is interesting for VMs where assigning a device to VM A
should not allow VM A to trigger interrupts on VM B or the host via rouge
MSI operations, eg by mimicking MSI using PCI MemWr DMA.

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
 kernel/irq/msi.c    | 25 +++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/linux/msi.h b/include/linux/msi.h
index a112b913fff949..75c2c4e71fc34c 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -649,6 +649,19 @@ int platform_msi_device_domain_alloc(struct irq_domain *domain, unsigned int vir
 void platform_msi_device_domain_free(struct irq_domain *domain, unsigned int virq,
 				     unsigned int nvec);
 void *platform_msi_get_host_data(struct irq_domain *domain);
+
+bool msi_device_has_secure_msi(struct device *dev);
+#else /* CONFIG_GENERIC_MSI_IRQ */
+static inline bool msi_device_has_secure_msi(struct device *dev)
+{
+	/*
+	 * Arguably if the platform does not enable MSI support then it has
+	 * "secure MSI", as an interrupt controller that cannot receive MSIs is
+	 * inherently secure by our definition. As nobody seems to needs this be
+	 * conservative and return false anyhow.
+	 */
+	return false;
+}
 #endif /* CONFIG_GENERIC_MSI_IRQ */
 
 /* PCI specific interfaces */
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index bd4d4dd626b4bd..7a7d9f969001c7 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -1622,3 +1622,28 @@ struct msi_domain_info *msi_get_domain_info(struct irq_domain *domain)
 {
 	return (struct msi_domain_info *)domain->host_data;
 }
+
+/**
+ * msi_device_has_secure_msi - True if the device has secure MSI
+ * @dev: The device to check
+ *
+ * Secure MSI means that an irq_domain on the path from the initiating device to
+ * the CPU will validate that the MSI message specifies an interrupt number that
+ * the device is authorized to trigger. This must block devices from triggering
+ * interrupts they are not authorized to trigger. Currently authorization means
+ * the MSI vector is one assigned to the device.
+ *
+ * This is interesting for VMs where assigning device to a VM A should not allow
+ * VM A to trigger interrupts on VM B via rouge MSI operations, eg by mimicking
+ * MSI using PCI MemWr DMA.
+ */
+bool msi_device_has_secure_msi(struct device *dev)
+{
+	struct irq_domain *domain = dev_get_msi_domain(dev);
+
+	for (; domain; domain = domain->parent)
+		if (domain->flags & IRQ_DOMAIN_FLAG_MSI_REMAP)
+			return true;
+	return false;
+}
+EXPORT_SYMBOL_GPL(msi_device_has_secure_msi);
-- 
2.38.1

