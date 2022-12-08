Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E313E647736
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 21:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiLHU0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 15:26:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiLHU0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 15:26:43 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359E17E82B;
        Thu,  8 Dec 2022 12:26:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RecgPm+rxkTxCehhGLLAs4iQ0IpYijpCFEo58/7LFNOr01Nell0lTQojmM2KykD4DzAFPbgHdOpvWP1+9syC1CeODE/u6RYJiQTeSX6EWmw1qrMBrKQILW/W5dxDSqg5OjZ1jx9pkglv85iBEsG3PFcXNUr+yGrsSYqIpO5aVg1+eTTeVaOxLuYDcqvT1xiQT1DS5GzenSV4m17hCDbLeY6mG8zAgilMuv08ONOLB8wdwFewxwEbWl7Ivl0GuTNMMzQRz9BRlZ2EJm8UgG8IWiSQW+gmALtJbNZRwkMQalkTg5JJKx8Z6R9yda9IuaSTEOL2gHCZ9N+DxYGoaH0L+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SCyOL545mD+Jn9BYCHsO5I6THzW7bsM87PbSEnWiaLo=;
 b=ANL2jDRyW2rQWOT7RdQUEOkbxretlwX+bk4vybBUAwoO03dgsaQRkqOjH8G8UeFudiwqf8Pi7bL8Dqe/t/qVCUr7iF8GOq41AoelM5NcYnYO6KUu/XoGOOeK2KAMDf/wu/lWzJgBqwdt2XQg9OpSPgGJAgf/TdAl/TAUixANtw2yzi+5gZ24VaB2AbfLaFKLdr/fEIkFK3IQen1mAaUBXH/o8GYlgIHcWta+CiMDVeIGhJLBLbGor4YV1C6uztwqtWEw5M4aPOTAiWW1uwOuq6gps17TIGlkMzqvw3YgNV8pQ+/jjUmxXCXnIbfcgpsmtCLsQjxCO2U5Y9zu+V8cjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SCyOL545mD+Jn9BYCHsO5I6THzW7bsM87PbSEnWiaLo=;
 b=Jc1sSXGaS6UPqTL8Mi6gimHCT/4r6kgYzXDODZiawG6Wd7aH3/DondMuh8ZR2pidQdDyMrBKJgs01KyaXuWAgi67aMtNyKRzVvVXaxUk40k4P/KmQuNAAO7AZc2S1UJqg5kJbTw/gADhTlAZB9Qrr6Jy/UjbqR+Z2kvQMJkeuVVCMEw5e5PKSeZdI8ZKZF9j7ebVu/db7ZNp82JVfxnD+scrVoavUTD56u3i6oRH9A08UTCSDPjaB6l8fQfm9aD9gWusPBRpcO5A9FdcvYN1tsUm8cN2T81qOl4yT5dhDgUdH2n7Q2dMDpehZ8+vztgL3rxNULtaXpmcQLStIZ/4hg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6966.namprd12.prod.outlook.com (2603:10b6:a03:449::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 20:26:40 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 20:26:39 +0000
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
Subject: [PATCH iommufd 5/9] irq: Remove unused irq_domain_check_msi_remap() code
Date:   Thu,  8 Dec 2022 16:26:32 -0400
Message-Id: <5-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 89f6c9fd-124f-44d8-75a6-08dad95a820d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CkuwO5oWepHiQMCEzZkoYCxVCmY9mKHQPXS+mN4TgNuI028ypcxfwBUc/6xO4nrfqh4YLb8pXwk1xDwz4daeTA8kJ8J7KLLhksFmLe7uSXwv6oF2vZ1dQV10AKHz34188NpXga4Y8EUI8zA/vgw7xRhSFiU4AEyPXdfWMs/ZRGzzL44jyA8IJ79cybPdIO3bwTRAl9+Ku1/w3n6Aojd/fYLXZJ0Nt1OkOds2wmY5jcWeG24swEWxpRWOPOOG0jMSGJ6bGSV5mDdRtHtQl72UhGeOIiclkoX5zfiPiVZCJKktxDC3DClOCAJlkSDWCApVmXCW3p/JMHkB0DAhZvJQxUq9ukIzZPNe/jTxnn8fp1LsdiqcgiAiRKaZWoQO+AMFmz7OozLfQYMHz8jWMnspZ7lcYa0G/yMKK3/VUz2IRQNNezPd8YrtT8VqNV4Tg6qdoktdztyv8u01gSv/O/AieTGOqwuPKIy0hBwtId/zqTSA+FJA8YitbbUN4Pi6NJMxeokbCs919VRq1b4o8Hli3byOjpgAO6hCaepCsV+s5rEzuvCtdxRNIbWAqP9uaRgI+STLSdT/fn0PqKAlH0jl7VxF6XNDeOYrpxPHtSAZ5l6HcBKRwdhz54fgZQeT8gbRKUhsIBUWOenH+eWW+IQu5HPlL1oqSim0MGXK8I5zxnt8fus6mTro7xQ3yIjMrNllfNKt1P2ocZYkKcdvtrzILQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(451199015)(38100700002)(36756003)(86362001)(5660300002)(921005)(41300700001)(4326008)(2906002)(8936002)(66556008)(7416002)(83380400001)(66946007)(316002)(66476007)(54906003)(6486002)(110136005)(2616005)(478600001)(8676002)(186003)(6506007)(6666004)(26005)(6512007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ez+sohmTH7nDvSK3cS2d6s9iMamKGGoonHROSl4eNyvGdlTWT3mSfuOUpSFO?=
 =?us-ascii?Q?tjIkO+g1hmGhjgE+o5AM18RjEPyS/Ge3jqEQkbF8hKaZRE8bb1lXLIhpX28T?=
 =?us-ascii?Q?L1ZN8eUST6zSeR3vOFL1cwe/JwDNFN+Tvc4yOHNkTZTdb/PXBaucviVxNMEB?=
 =?us-ascii?Q?rTCtZrsJ0lNZP3yosbLFtPSL4toJi7FuSRpCCcvHM8YsBSryMW+y6+ccKdDw?=
 =?us-ascii?Q?PHGydC6UFoud4LJEMQgNTgD59eJ1Tb1h6SNLhpuZK3g2h5QEm9BxmocjiCo4?=
 =?us-ascii?Q?jyCPoG4g+LMYH5o2wBFy77XAn7YsY+HwZTpvvePZqStdn8djGNztX/PYusM7?=
 =?us-ascii?Q?exFC7+uNlYekrMIqSHhOzRjQiRZJykCoJpy049kwXPv4eOkrKRAQIeCivQis?=
 =?us-ascii?Q?RNWQbaSzM7XccMZENPQhjhIqpvDqnttOhLQJ/K41oOpm8YHgMRXa0un/9BId?=
 =?us-ascii?Q?zxeBvtYk0cJweZIuT6U1vWBPuGb7sEuNXazAF3cZwrmaqVORnrzIb/9LfzkE?=
 =?us-ascii?Q?Vjf2EqJuks4HciKQqzRlC1hLljQhLcjIhc8Flwe8gC0N8IWg/kANVLlIJzGr?=
 =?us-ascii?Q?Dli9tIdkHgJorJ9Y8WQaCaySqhL/Px56VsJEVl0jdR8PiuVfzJ3SOOeJWuor?=
 =?us-ascii?Q?p1xgk6zfrniDdLcs+tp17QDSEvuTrQb6WxxbCKjeN/PwHw1fBmYJJOAyL25m?=
 =?us-ascii?Q?7Ml4sJ7SD4HCIb2c0D2IlMLWzj/NZF2zmibmA2+XXRXmEEEjLztsidwmUmud?=
 =?us-ascii?Q?Zr/64r7DJ1P+m7zqYUZxusTfzqJjWlmbdqryTy5h131qs4RUb+aXoQB1cIqD?=
 =?us-ascii?Q?BT3Y9WPISI8Ch82At1YFnmXyYoNTLBh8Sn1Uc/aPqPx1ncygIr+pA8mDV4K/?=
 =?us-ascii?Q?VSs7CG18MmtJt2GhABaR9VTLf4p3XxVRS/guAqWtkvmu5l89PKemDPnqNmK4?=
 =?us-ascii?Q?yiEq0t1ZP6uYaPb+W9a2LjKio5supHvY9nstkraNULay+RJLflWt7ZXQ63H6?=
 =?us-ascii?Q?6CgIHAmy9XUYMQPOTLiw1xXCzw9iMhlXwadrW0173WiqE17W4CCPfZsjozu0?=
 =?us-ascii?Q?XqNPUqtxLW4XoqMv3YPNXmbU1RVlr8FIFBO54hvk3du2Nu4h5i7i7BhH961s?=
 =?us-ascii?Q?f5L5MtYHRUx28lBJBpu6BF03H/MXf2oDcnU+VdrKNqgfoxoledrjRwGyftIr?=
 =?us-ascii?Q?/3wYdXGJ2xLyh0uH/0wwPIR+XWPbuEUAOoW6IQaspDVFQydcRLyBI0C2EZmw?=
 =?us-ascii?Q?Ck4BXmIcLgI8zN8G9URnZBR0e0cZlFqeywwYJ91te4RizErK6Vgni0/hPd1B?=
 =?us-ascii?Q?eoIc9AY68DPdwt7tyIC4uiY2kd69J1PISO5ucX53Mssvsttdws2DRaM3QxUi?=
 =?us-ascii?Q?dl//gTS16O2w7umpvXpcG3A3qutTKBju+I3n7H2JiWPpR3YQQIQWcpC/e8t7?=
 =?us-ascii?Q?/XkWgIzuc3JX9xJ5UhrK5eT708vRWiv6u3SgE1aY+sK3ITxBiWguEX6Hp+I4?=
 =?us-ascii?Q?ymCPGXdhVq8OYr3Il2oQRk/xpkArALg+n0DaijYpk3cfGDd5bQ0cS1YwmAFF?=
 =?us-ascii?Q?AGcqCHcuydd3VJgwO5kg2c5OkjqVsjuXcCdOo+ko?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89f6c9fd-124f-44d8-75a6-08dad95a820d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 20:26:38.1362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EOn6klQlOA+oOMqqjr86GydbiR25JEJItRpaszv74bqxMO0pgiMJ6sSi/Ztn26Tm
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

After converting the users of irq_domain_check_msi_remap() it and the
helpers are no longer needed.

The new version does not require all the #ifdef helpers and inlines
because CONFIG_GENERIC_MSI_IRQ always requires CONFIG_IRQ_DOMAIN and
IRQ_DOMAIN_HIERARCHY.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/irqdomain.h | 23 -----------------------
 kernel/irq/irqdomain.c    | 39 ---------------------------------------
 2 files changed, 62 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index a372086750ca55..b04ce03d3bb69f 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -276,7 +276,6 @@ struct irq_domain *irq_domain_create_legacy(struct fwnode_handle *fwnode,
 					    void *host_data);
 extern struct irq_domain *irq_find_matching_fwspec(struct irq_fwspec *fwspec,
 						   enum irq_domain_bus_token bus_token);
-extern bool irq_domain_check_msi_remap(void);
 extern void irq_set_default_host(struct irq_domain *host);
 extern struct irq_domain *irq_get_default_host(void);
 extern int irq_domain_alloc_descs(int virq, unsigned int nr_irqs,
@@ -559,13 +558,6 @@ static inline bool irq_domain_is_msi(struct irq_domain *domain)
 	return domain->flags & IRQ_DOMAIN_FLAG_MSI;
 }
 
-static inline bool irq_domain_is_msi_remap(struct irq_domain *domain)
-{
-	return domain->flags & IRQ_DOMAIN_FLAG_MSI_REMAP;
-}
-
-extern bool irq_domain_hierarchical_is_msi_remap(struct irq_domain *domain);
-
 static inline bool irq_domain_is_msi_parent(struct irq_domain *domain)
 {
 	return domain->flags & IRQ_DOMAIN_FLAG_MSI_PARENT;
@@ -611,17 +603,6 @@ static inline bool irq_domain_is_msi(struct irq_domain *domain)
 	return false;
 }
 
-static inline bool irq_domain_is_msi_remap(struct irq_domain *domain)
-{
-	return false;
-}
-
-static inline bool
-irq_domain_hierarchical_is_msi_remap(struct irq_domain *domain)
-{
-	return false;
-}
-
 static inline bool irq_domain_is_msi_parent(struct irq_domain *domain)
 {
 	return false;
@@ -641,10 +622,6 @@ static inline struct irq_domain *irq_find_matching_fwnode(
 {
 	return NULL;
 }
-static inline bool irq_domain_check_msi_remap(void)
-{
-	return false;
-}
 #endif /* !CONFIG_IRQ_DOMAIN */
 
 #endif /* _LINUX_IRQDOMAIN_H */
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 8fe1da9614ee8d..10495495158210 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -436,31 +436,6 @@ struct irq_domain *irq_find_matching_fwspec(struct irq_fwspec *fwspec,
 }
 EXPORT_SYMBOL_GPL(irq_find_matching_fwspec);
 
-/**
- * irq_domain_check_msi_remap - Check whether all MSI irq domains implement
- * IRQ remapping
- *
- * Return: false if any MSI irq domain does not support IRQ remapping,
- * true otherwise (including if there is no MSI irq domain)
- */
-bool irq_domain_check_msi_remap(void)
-{
-	struct irq_domain *h;
-	bool ret = true;
-
-	mutex_lock(&irq_domain_mutex);
-	list_for_each_entry(h, &irq_domain_list, link) {
-		if (irq_domain_is_msi(h) &&
-		    !irq_domain_hierarchical_is_msi_remap(h)) {
-			ret = false;
-			break;
-		}
-	}
-	mutex_unlock(&irq_domain_mutex);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(irq_domain_check_msi_remap);
-
 /**
  * irq_set_default_host() - Set a "default" irq domain
  * @domain: default domain pointer
@@ -1815,20 +1790,6 @@ static void irq_domain_check_hierarchy(struct irq_domain *domain)
 	if (domain->ops->alloc)
 		domain->flags |= IRQ_DOMAIN_FLAG_HIERARCHY;
 }
-
-/**
- * irq_domain_hierarchical_is_msi_remap - Check if the domain or any
- * parent has MSI remapping support
- * @domain: domain pointer
- */
-bool irq_domain_hierarchical_is_msi_remap(struct irq_domain *domain)
-{
-	for (; domain; domain = domain->parent) {
-		if (irq_domain_is_msi_remap(domain))
-			return true;
-	}
-	return false;
-}
 #else	/* CONFIG_IRQ_DOMAIN_HIERARCHY */
 /**
  * irq_domain_get_irq_data - Get irq_data associated with @virq and @domain
-- 
2.38.1

