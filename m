Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 031B1647742
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 21:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiLHU07 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 15:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiLHU0s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 15:26:48 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D36F84B45;
        Thu,  8 Dec 2022 12:26:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qa+qSYS5B7PjrxBMqnOj4Wuo6rQGdSjuv7jsEx6vVFhMrGLhtWg2orCY/TgvUZMGq6CAUAymBje+2W22RlpxtYb9nMuqsG/QzzKwJTcSI6bw5HxhJMfrxQI0b4ihgGGJDwmBNApfNhFB8teemoMNOmSn/epIGWAABK+6FXijNGg/wuDYYX4MIjeVDR3f79slOWMusM6bQ2OAA/uOTMYDCak1dI4WGUQTG5EUuHjHLb5ep0ebLsB9lcjeSZXGkqhZfJ8pf+0FMgZ9LtAPoTwLHPxi0zeW5zrUANTmceRQ5Ek2o5DbZR4TnYF9Kjp9xktCbHlfgLI+7ob+iJmqHOqmfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qiUrLGYpRHRvTN0nQtivy752j9/niuZ54a2UFBQQNBc=;
 b=nIIvEU2pJhqj5hMvWXNfRDqYInSKJTxl1FdI9rnj7nC8VnV7hjvM4euC2eDVA0hrqiUqL8sckFqsouiu1I32uxVkTXHMWipovhHPSBaGG1Bl67ZTAwlzmPcB6oRFAcjhULyXkHCWKO5rdYxafdsOhRNWNHWNZbiogpeHclV0tzi22ECZz/FoL+enhmUAeAOsvli5lGrjXZcuTRQ+8+XIHwB8gHq937DbLBrcX/kkyG25UNoRvxmp4JsoJlyhUtcmpaQxecx1+zsx1Pypnm57kqdGwHjNC7aZif7mwlAZyxecxyMt3CJiShNxawFXlp70vhxRftKStKQWIyHN8cug3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qiUrLGYpRHRvTN0nQtivy752j9/niuZ54a2UFBQQNBc=;
 b=RYRRoL9ZvCpKRLAFlkC471Wi4nY9rRGpKIr+U7BQyuBYPQpcjCxRC6ED99Dm2k3voSAjzyT0QML92t7w70xuMKvOPuJzmF5WrisKglYAk97lDQ6Uex4Rklc24h49/ow/KLGLbWhuz2g6R4Tnaoevzqbpa+vvPUl0iw6LgeeQgpJV3nnVLutJlGHYcdI0AsEjl0hYOE5G+uf7wOFJPuyIRQ+fuoOKObqFASUfrXN2GtGOy/ZXIQ6ADLa01yYcr9JHuhhLnj7l9vNgrHRFUnnCVnRqI0vN2NERn/zt6DyLyyB/1cXTZ1fizIzjXdeY70RndRz6g8F2fD3mU4sHic6CAg==
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
Subject: [PATCH iommufd 6/9] irq: Rename MSI_REMAP to SECURE_MSI
Date:   Thu,  8 Dec 2022 16:26:33 -0400
Message-Id: <6-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0156.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6966:EE_
X-MS-Office365-Filtering-Correlation-Id: 202133c4-97d3-4c0e-a3e0-08dad95a8345
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8jI+2z6vReTtsSMwxuj49dOm+459j0lGRMAb+7oVGJkQw1SFyz9IG6+SQO1kaPDSe9ppfIUU1XbtkV9LfrcAPVNrv9LS41WXEAtlj0PxdrkJ3HKfuTWLh2fQo13FPfuHOQLXPXL1xqCYogqfuNqo86bIWT7mNK85FwSYlZ7+rIzwp8hC/+u8VOu+TCZCaGf9hsvaePu3/uej8zA6HVzqiiDRmRsHWmhOUbcc1V1Df1TVTQA9/0v6Zar0QZZ6YetM20uEMbizQ8Kt4TDS8ntM6FdRgYHly7Z+7DRiL/gBUAuExl66wmaU0l1YvSXUotRJegYJn5SvzYLEJ7rf1km4UTkIT0fGqi29FwKUgCHDLaFGZU/fW24MR+F4vTm1n+eEsPm6mnYFkaKh4sne9EA2mA4Lr7Plv/yu4hTiSAoq14ibZkmbUPqhlGxXQzT61JP9VeMloiPJlnIj3LXL2JRGgYU84QmuiqP6WRgyWR0+8A6R38FeECf2TfzJ7NOAg41HZzv7sqjhxIP2xoNUmNV7rQghhAus3HCePO/syxN+CLv2HsE5ErKqm3GaOXxCzkeo49ZF4GtlgGKfo3HuIYZ6YSsDq82+Uu6TPSqghRBjKVjBOt0it++kTCxwCrkSU0eD3kPev0yQpSNrvZsjD+72T+CnPy93MJP+W0ecz7MeUjJPHDFaqkTPn6zPDFQRvBNnQZ4CPCCJf+6fSeK4prD5BQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(451199015)(38100700002)(36756003)(86362001)(5660300002)(921005)(41300700001)(4326008)(2906002)(8936002)(66556008)(7416002)(83380400001)(66946007)(316002)(66476007)(54906003)(6486002)(110136005)(2616005)(478600001)(8676002)(186003)(6506007)(6666004)(26005)(6512007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rU5+azCyF2eZXxj0Qhf1PNkpbooTAf+gD7W5Ut1xLXUJHtu3M9qKJd1eGaFq?=
 =?us-ascii?Q?RbZZW4qJOBu+EgYgR7rAqe8ccEDjw06t3anBy+fxKeEGbfrjT5yZE+X9yE+a?=
 =?us-ascii?Q?G/Vlib06yZlzko1MVTaVmUJs1H+2X072cFUnL5RM0c88bsQ20uMJmCNP1gDL?=
 =?us-ascii?Q?LqT8sAzxR2XQmIhBQCtzgMMpa+FRbQkTqUgt1/VGBNyGRwECiJeFWHJjIFPF?=
 =?us-ascii?Q?C5PKnPHWvgL9lIv5ZkNKdwVw7DW3j+4ukWlwB9yDLgCF51asC/hjYSMeXDMg?=
 =?us-ascii?Q?xQXK4jtMzzrrO+hzJ8u2qJR4KDB1q6opYwY/Wzh8sQn8l395REDRtO9cV20K?=
 =?us-ascii?Q?weU4TnMGhsyXI0GYUC7BYcS3CMcSi3LHPFQcIFa/R8RHAlsgxmNdTPutfDTr?=
 =?us-ascii?Q?LiKYC/ZpeXkMnuyZUnj1FS/dP5jH2XkujhgHbetJYeqDXZiQ1ZNdZSJ59GTu?=
 =?us-ascii?Q?YZ8dIPs+S6kMw1VA+GEajciFNIwbOMZSOp58X54dYZAQBITNAyy32kG1X8MB?=
 =?us-ascii?Q?X8iHrSv89lRgwHzlKrAx9SQEsZB2Z75C/TROn8gUW5RK1XwTgi5/9eInOMS5?=
 =?us-ascii?Q?M8bvVlZBVTCmcLZ+zhlfIS9vtsxYDgII56BchqOXl3EDRqF8hxC9ktt0B4/m?=
 =?us-ascii?Q?Sh9iWJCt21yVP2AuqdbXD0MbWD2N3kE2y2ty/W0hizPLRtwhrVP/wU585p7E?=
 =?us-ascii?Q?EB1w3IASYVnA6fEBXebMMOJ8HemNXwfK9fZaw5V7kpahJX39NbMqq6Mvil5y?=
 =?us-ascii?Q?iz0eylC204/FGfwqSK2hzeLokSIAAtacQ0mCD4Uye+qpw5BWHeEQjBZIkuRi?=
 =?us-ascii?Q?PMeNz5N7e+IcOWNYm7y4P76Ipc+NEZNZ7S1EPe5Tafx8nbNUQgoTGgqs+Waa?=
 =?us-ascii?Q?0qGdoiCMG9kEkMzXx7RS6Vvtefl4YBqWcvQFr+L5uazboPR+HcuHsvVx3nDq?=
 =?us-ascii?Q?kpelRPlf0Lb8FXoDogu/cpTThsx8tLJWOhoalNMiQnqAgcal0PTCq5vpT9NG?=
 =?us-ascii?Q?SsPHvQ/kCuAYkK2md+UE9SH1++t+PlwTTEidBCHd4Ax+jxuXwy9f6mcubcfv?=
 =?us-ascii?Q?z1wLBDDyOTZQEJxWoWUYfiMplzGpy3rNvOocILFweyK8aNFKgu75GzxOxz/n?=
 =?us-ascii?Q?b8L8FVm8GhI+7wabjXDE/dfWpo9BNN2YDUUzVZSjO33tTz9Z90G89/DNpdoO?=
 =?us-ascii?Q?lsKenT319A01UKpUwsitLWjJx4EK4HLvlw6J6XPNdbyScJA5r6qRxpgJ6pai?=
 =?us-ascii?Q?Ni6T31ME3YHXdtoUVkaWJUvrLJpA87lhmL4Kz1/JSKhwldTNRl4JweM8QCPK?=
 =?us-ascii?Q?h/WYbBQuwhlLA6mGGMBqckKB5luns3R+iw+9hHS6yjKI/NBj3/vLJU/mnsnV?=
 =?us-ascii?Q?eqs2cxMdYnersV9jDaBoZAxS6EZcC0GL3djjKB4WwSzdKz9/D6EJeVx5OcdW?=
 =?us-ascii?Q?UZ7Zoh4rjj+R5VTbvyN9yjQ1KtYKzCoIoln8XJCYNRAMDMv2jlRnyrz6AJM7?=
 =?us-ascii?Q?fcNR1cTP1dFZF7Q3AZwSL3e3xdHPBeFpLlFFW+pZJQs+0agj67PjZkP5vwii?=
 =?us-ascii?Q?qsYMFIr5woEhT0TlrRY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 202133c4-97d3-4c0e-a3e0-08dad95a8345
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 20:26:40.1353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w19QouSlfb0hbzN8zGBO46VLZqeSCSocgJzBcle1ESyewFDj2rO+W3Ott9DsnAem
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

What x86 calls "interrupt remapping" is one way to achieve secure MSI,
make it clear this is talking about secure MSI, no matter how it is
achieved. This matches the new driver facing API name of
msi_device_has_secure_msi()

No functional change.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 4 ++--
 include/linux/irqdomain.h        | 4 ++--
 kernel/irq/msi.c                 | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 973ede0197e36f..bb1aa5367ada6a 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4692,7 +4692,7 @@ static bool __maybe_unused its_enable_quirk_socionext_synquacer(void *data)
 		}
 
 		/* the pre-ITS breaks isolation, so disable MSI remapping */
-		its->msi_domain_flags &= ~IRQ_DOMAIN_FLAG_MSI_REMAP;
+		its->msi_domain_flags &= ~IRQ_DOMAIN_FLAG_SECURE_MSI;
 		return true;
 	}
 	return false;
@@ -5074,7 +5074,7 @@ static int __init its_probe_one(struct resource *res,
 	its->cmd_write = its->cmd_base;
 	its->fwnode_handle = handle;
 	its->get_msi_base = its_irq_get_msi_base;
-	its->msi_domain_flags = IRQ_DOMAIN_FLAG_MSI_REMAP;
+	its->msi_domain_flags = IRQ_DOMAIN_FLAG_SECURE_MSI;
 
 	its_enable_quirks(its);
 
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index b04ce03d3bb69f..cc6238bfa9ed06 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -192,8 +192,8 @@ enum {
 	/* Irq domain implements MSIs */
 	IRQ_DOMAIN_FLAG_MSI		= (1 << 4),
 
-	/* Irq domain implements MSI remapping */
-	IRQ_DOMAIN_FLAG_MSI_REMAP	= (1 << 5),
+	/* Irq domain implements secure MSI, see msi_device_has_secure_msi() */
+	IRQ_DOMAIN_FLAG_SECURE_MSI	= (1 << 5),
 
 	/* Irq domain doesn't translate anything */
 	IRQ_DOMAIN_FLAG_NO_MAP		= (1 << 6),
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 7a7d9f969001c7..18264bddf63b89 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -1642,7 +1642,7 @@ bool msi_device_has_secure_msi(struct device *dev)
 	struct irq_domain *domain = dev_get_msi_domain(dev);
 
 	for (; domain; domain = domain->parent)
-		if (domain->flags & IRQ_DOMAIN_FLAG_MSI_REMAP)
+		if (domain->flags & IRQ_DOMAIN_FLAG_SECURE_MSI)
 			return true;
 	return false;
 }
-- 
2.38.1

