Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0DB64A776
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 19:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbiLLSrp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 13:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233389AbiLLSqY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 13:46:24 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF00B17412;
        Mon, 12 Dec 2022 10:46:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FnCNYnouFpIqm+9pfD9gt/+vCZUMgUGwjrgZcU+G3WYpjyAMWuYNVQ4pixKyQMwzWZ9wsF4o31gNjkl+b2mvnITrJyojFk2sCJCkaN48CFG538HNXvib92VDzVj57vtbhItAHYRuS9upkM3patcYtwjj8HHE0jdQ7+6f0L5p51i12XGPJ2j+NULwDgsKON67O89HdtSWSD/hHX89CFUG2XaNfSiqzZubBQopFNZh0Pd+kFqXLMLA8g2fUr8HU2Lmw+xjecZWEbHuZiplkqChM9ma5Lknu8ZODHFMi0BNeG97u3mGFj1DDtDfUqVJM2xsReUZomJIS4ucSMwRjRtSrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SCyOL545mD+Jn9BYCHsO5I6THzW7bsM87PbSEnWiaLo=;
 b=SL/pay+jEXRQzlWRoyNsqtrKB+CccfNC9jMujGas4TFA6HD2K28TzZRlAnQmeWuGO/q7LVOi07CTxVavgNn9qLL5eHSNyG8DAomGTBc4qdeH6W/3GlRJdc+rsBIiRIZqUWrv17njJbNbxH6Ogl8caovpfYQeDqqOTDYXO3Q7WBfxcP3B+bGB0PcBRakFcjpraSUDt84OKkq8koVvJf2TpWgfA+gq2i+Fq+vVvDSC/M7bYr4e8wdRSJ13R9RLZ8L9PKBkL1+f8fUvSYbaqZ6e3iOPWQ6TZTUgeqafaCNjblEI4t80bytLX6lU3fwzs3uxn+aqGb2O2D3oLdYjYC0qTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SCyOL545mD+Jn9BYCHsO5I6THzW7bsM87PbSEnWiaLo=;
 b=PotLv4GQCcKFIOqC5rO+xTkc0v1SoO4+OUq2ERYwDu6VvR+xMFkEAjR67ftwrHbPWt/ozGyD+5qQXSIp3paAk3S3mlzJy+5pRfB6C0GvDWBl+gG7rJ4r2KGlPzIEGLaNIfrF3SZw/C1PfRtxKq9FEbShGfWV0UML73T+pc82haoYdRYKhIlfaSs0FZIelnoxOsC8VcXnLCzYNx8Ac9vUB3WyFdgt8CiCIEIqHROlHZ3zMtBwEMCeHraZiWEuTXznxs9XJDISnAeGh2lXFVcluR+j1/5hB+35HIDMMHB3w3rJWfn0AhEFhiMgPBdLf6HJwRzOfN25e56o6039IRfw1w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5748.namprd12.prod.outlook.com (2603:10b6:8:5f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 18:46:06 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 18:46:06 +0000
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
Subject: [PATCH iommufd v2 5/9] irq: Remove unused irq_domain_check_msi_remap() code
Date:   Mon, 12 Dec 2022 14:45:59 -0400
Message-Id: <5-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0028.namprd05.prod.outlook.com
 (2603:10b6:208:c0::41) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5748:EE_
X-MS-Office365-Filtering-Correlation-Id: e609b223-13c2-461a-7255-08dadc711ffe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wGXMR4UCaDjPBwuUd3yZVCT5kY5R0+ZVDdaXvfXwWguwADmdc8h1RFDMfI/6TflRT/88DpHeIzSAuu3j3QFfW8PKNM6FVLWqqmWm0IDZC2qHz+HFiIkcAWTpeosZyMo13ivCpD3K638NUamv6KIaXp9yjd1Jxw3iwDiUQX9wbgnmWOSd0+MQ2WqPhFjX5mN9RNuKpo6SVogn6r+yCvhW0hWWvRpgcu46cOcXyZOQtq0pT2Ily7y/iFCYtYgvmLIVKD+DPCVRwFbEUTsAXv9klK+luj9fsSJ7mTnTQchHbYU6AvBXMKtZ2aLstGu/wl3UMSjQdhob6YY5+DQC03ppOrpyrQx/PWwuRGWPCvC9Dx5wEf3vrPeVAta/Iwz8N0m0dBtco2g3k2WfyGiPp1773c2knaMul4lVbDI19M8atCTPv8hqo6IndRlxZJkezthzDGOqIyfc2tdApj8AObq13o/8k1LeMEMQzoT6eUudrQKSscTD80IWIu8MMA+kB9K9OTDyyyYfOXPxO+FtcMLqWyVfhpYYYwbhttYAq18vEL27VSKudq11lUEosYzsaPR7lgCLWIwbj3YuF7qqrXdSoH4aPDJOFcT4JUTRFJueiIOtXM0KcEclrJnAgWOzntwCHflYVzNmB6/wySN5M6sZVa812mQVEHa06IHplEy9F5oZi53k+CZSizz7LUuclzfFA8f7y3pwLlzlIGMEMOZjgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(451199015)(921005)(2906002)(38100700002)(41300700001)(4326008)(26005)(36756003)(86362001)(6506007)(6666004)(66946007)(54906003)(8936002)(7416002)(316002)(110136005)(5660300002)(66556008)(66476007)(478600001)(6486002)(6512007)(186003)(8676002)(83380400001)(2616005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YAePcslj8tXX4If2Jek7PNw5Jx5myqX0K79cPXzbeo7aK+p5Ogrc0JLQGmDu?=
 =?us-ascii?Q?z6rv8dLVQVlCtGcf/VuS5RYibL/8kP8AgC7+ibbX8AP5DkJrd7kTGrWlgx9E?=
 =?us-ascii?Q?8aZKP2H4TDHlBKZznhQ3pABWI44lhwMBYAys9+YUvbcQIJaA0qFnmvUu3ZVU?=
 =?us-ascii?Q?qfaMM6keUKLOgQORgjWjsX86g85p7pK26IId+LVlqlr8t6nhDPnZtQxS278c?=
 =?us-ascii?Q?W1MYfaqN+CsJCvf9B1Nj70W6wwjMAJ3q99XtTrADYFkpgXjJTaXdt4DingBH?=
 =?us-ascii?Q?BP7BjW4zWeJrHx6oFUVnqhQDcgn1tOBaSRJ6c8JvZJeE4uzuDHIUPfqtRPUy?=
 =?us-ascii?Q?vgbIkjuEgekZH+FxaURxUE3XrI5pEz6o9rKDdfue8SXw/BBvx8lG/XovN6Q7?=
 =?us-ascii?Q?VwN8dZI26ewD7silVRPwTTQXfQEqGGufrXB7caBSvFVhVdzhuvB8q5npqqjm?=
 =?us-ascii?Q?FBvJ0mjwPVu5wcQkMSgw4Y+sWjWmunntBPM2YI+M6oZjyhPZh5EuznnYcbWF?=
 =?us-ascii?Q?N7cWZRxTbNDVhuGUBFhOxllPsGMrdh/hAb8u9WvQXLIvplOw9xCeRkOjAdlx?=
 =?us-ascii?Q?C8zAND7ZW+QVEqsy2H4RL7Tk5TrFFUYQVNAOWL8P15OWWFewErzf8471bSeR?=
 =?us-ascii?Q?vNHoEox98YoP43H42kE+4voootIkI9xOL6GR1TJjN0dBmIdM2w6ZiXvXEFIU?=
 =?us-ascii?Q?1eXwDMazPP6bAR2QC46uBvQwE3ONWcKZDcyXTnT//4gjy7ZoKsDQ48m4YyXd?=
 =?us-ascii?Q?emcaJ9EliOrqcpqj/GX47W/eNBznZAgQCK+XeD8eSomaxLAWtPyTTFRjfGQ4?=
 =?us-ascii?Q?/+Yitly9arbjsQAXykRJ2M6R+Q9uhQsHq6CxlMQVVOg8hEpAdVMtSO8QLjZk?=
 =?us-ascii?Q?AXxYuwc+K9UDlO4u97sEAqAinuWuhyNELCsmLF4t1qlm72F4C0huqR/cksAY?=
 =?us-ascii?Q?Ka7kL02QNUYUt2BSqt1H1zaDEH4iRqm5oBpRaj7uUgxfbLbj/9a/MmkcgwjB?=
 =?us-ascii?Q?c4P1GU5SCr9E3kE/kQY4fJtWIgfG96E2GScAh3n2tLM1uuLs6fsdkQxxuYsv?=
 =?us-ascii?Q?6Rqjqq+r8uQ1x51zW3Ni7uz5qln5Vi7dpsL/tH/4shryilr4TjGpFxWaB61X?=
 =?us-ascii?Q?iM6OxUfn7/oK0TPfU39ouiWKvYTnlxj55WoI28xocvEmHm4kPpi8g+PaFbTL?=
 =?us-ascii?Q?xEc7qy9/SiCc9YmX/M4BoXxnTZOYBnHkWemIYj1zYOa/nXo631nznxOEPy49?=
 =?us-ascii?Q?/n3J0iHGtMwOS1zuPdcpPCBWn0UgT/ZGKq91LdgElQyuOFIdMB8IBL+chKIi?=
 =?us-ascii?Q?wLiPcUxjmyHhhvQI5ug2NL9DvLmbnrtsuc4bB9QoPCoahL0ZKAfQ4zbLojh2?=
 =?us-ascii?Q?dTX3D8p/cDmdpmovnR8z1m07QCnVDuCsLTGsCa98c/SBWX1KJLGdLwxR78rh?=
 =?us-ascii?Q?adhDjxdvjunY/okkyIRkaMtWhsAPDWwLB0yVSKPDHY2V2MySNpqv/6ztEI4l?=
 =?us-ascii?Q?nsoNrXjBjZ3EXdMOXw2gdyFyhssopMt/a4/S2M2Ysrulw/ElUS4oIdHGaM+V?=
 =?us-ascii?Q?w8+ffBmfBoViCwxACrDPp3FIqFLMTxZEgH/qCbc8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e609b223-13c2-461a-7255-08dadc711ffe
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 18:46:05.3936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xtnnt96szeYR17TM4l+qCYakGpFZ4UtRLi8l5EPMwhLF8ve/BGhKhTY1ZFyU6IC5
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

