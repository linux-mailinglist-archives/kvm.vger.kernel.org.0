Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06AE965F4A9
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 20:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236109AbjAEThF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 14:37:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235944AbjAETfN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 14:35:13 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E5417894;
        Thu,  5 Jan 2023 11:34:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EZIJNGNTsleZTnhBIgKZZZ7eMTG2xUF32mEfbRUJJMd/TvlN3/XX/YboVrgv4oMvRH4/eSC3QksKmHqFWlHcXyRcRfS55D380YyiC39ZoV7w3FseTVS5oBn+pHtiDU79kQ2QdwDRN5trrdyBV6YNE3Aivug/dvCkB0U5wWyf5rIbPbFWNhCNPZG+nbu8R4Iapa7oT7oyEFlu0RQ4oPcnzyoaB48DkRSzLG+bGOzCpMiOs/x+GMgE8noi1bOBmozY8yjEu0nSuRwuLlN4Ngh5zzH4yMM2jdn37B0ebh0RDwU0uEmCDqXUSHKyvplXUmFV+rsssl39iaTaNwPaSy5dig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZvEIS91FyxOHJlA7slRdWkbc8+lsRvHRgU+kOfTr3Hc=;
 b=JX5JErh6TJuYnGAcCU494EqoN9EvfJa8wQ7yZopnwg8gqCYK9E3E4jbjptyNvsKBO333AVQTLtCKQA0euAHGgkmvfnkUTOXU3bc19jYLKhiSdGGQi38dlClS04HFsZI5hbb7EZau0CeWMjEnJS9Vcddaf50hNTaojQa5HQ6AH1LgARhYNXor3Z5YpRdMnsj42GBLFTXkNF8yMNpPGe4Xq4344KBZXHs+j6hJ7LLUhGMxGlMlC9+LnGsNEgqnfBrr5jh+tFG/4HHmOHFkPlGYJVaGk4x5dC33h5yRp3qFRfda8c+tH+Sh702kov07xM60Hpuwp2lSt7ih8PWOxXqJow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZvEIS91FyxOHJlA7slRdWkbc8+lsRvHRgU+kOfTr3Hc=;
 b=Djx+UUVE+TpW/0Cw3tOr6ez8vb8ySpVxP0s8gb4XkYX3/aMVGqPD+akIx5dhA6UMkAHi6h4dG78h4DFKAxfLRzPSK1hRcov0c2iK72mxr2RwfrXdh4zJQGb/ddsj3Emo+v30oAkcmqzzs2CAreyS/Wt0YyJRFnSDa3VJt3H+2/cEX9yG8OnAPXT0u4gHU+QDzNyql3T4eOKhJsYAhPNZu77JyNvNt+38FXONazomvv4yP+HGUYpL4NLhYgmt769TWHsMiTKUoZw7NguLtOHZLGRvBv3JhG/YHhmQ1RoJxNwTZWLG2zAEeILtwJqol2QyPyBX9LP5lBxTHwQBwdwrJw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB6776.namprd12.prod.outlook.com (2603:10b6:806:25b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 19:33:59 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 19:33:59 +0000
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
Subject: [PATCH iommufd v3 5/9] irq: Remove unused irq_domain_check_msi_remap() code
Date:   Thu,  5 Jan 2023 15:33:53 -0400
Message-Id: <5-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:208:160::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB6776:EE_
X-MS-Office365-Filtering-Correlation-Id: e887f276-5cd4-4701-bb5c-08daef53ca7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iEwrayhJeo/zuUKSpY27I0s7wN/5ZVITrEkY0zNkyOmiRRMrAjU/lCFTOMt7lKYfqKDsnqLo+S2cxrmCRvnPTQeVSPn+vWA3ObyoORW2rso9HujTyWc3hElDGhCy7qpcr44VhB42jPTfqMl0y1ytS2mQqKm0BMW6ZdhRwzdkSBTJcUb5uD7dlGyORFhEFKj1FcC9Zy8XlPX6dwz37RIAxeeZ2UYa2Jrb7FRUY89uLl+t9cMZCPP+SLYmVOKo6M0ipclmfnIdQ8yvJU5NyclD2Z+EmAiCc2ZETYLiHQigAKEL8MC6GH+CKNuKfca1AeLlgHy3UHkSDhIOnwS1eqEyZK8CE47pdGPVIiygH1o9qIU64TZiX3QwYkUMP2MPVmW9+w12r0ai4boAmoCzzIevKjI9lGC4bEi1NHRIvAiDKroQFHaZN2GIrt4e0a1hPzjkRsD2B8SDdMWHuDuxazdUtvUKo5XC1z4tyDMTN2Pv91JHrb0AaMYmHIMJKmtTTZr2OsQBW8CVjOzan45nk154KHuHvNvipBl/ZKlT1rYzgnZqVfP2/5HqwF78YU8ky0+DveT3ATSPIIKaXx2dls+nB3R+iRwnGCXqqipJN2AaLij2ehLDXO/o6cEKF4ydI6/BO4Q1GXOWHyyLGXhGAZfO4NxjqlL7B5CKGy3ClLtQLF5rN0ZXmvLOYikqsx7WoW9dNnR0/0ihZpyFrcjIwvDVKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(451199015)(6486002)(6512007)(26005)(186003)(6506007)(7416002)(8936002)(83380400001)(478600001)(54906003)(4326008)(316002)(2616005)(66476007)(8676002)(36756003)(66556008)(6666004)(66946007)(41300700001)(38100700002)(5660300002)(2906002)(110136005)(921005)(86362001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d0j2pCTDAzyAbQiWfVdMvLSjjKv4lhCNiWFhd0FN/RzrrayFi4YzgTcgRpvW?=
 =?us-ascii?Q?AJaLzIhSSHL4biL+Al90R0UVVaZi7olrFZpGQim1SgJ0bNc9SrZrU6Gnr/im?=
 =?us-ascii?Q?9+nATkI3QUFuWYoF+Sfi0gNdOkLaQq/4TlyFBhIaus/tW9rFqULtVBvAvWpk?=
 =?us-ascii?Q?qVbovG3yy0Xn6YVoxji0Rhrm8NBnSOBYxk9BRP5eHe/rSICLVX+BFi3KEtKH?=
 =?us-ascii?Q?vUnbAVOTwWtF4Y2bpaZn3eBLPZU+XqjzhRky5bX2yTA6yx0X9+/3UcCI4TDo?=
 =?us-ascii?Q?136lc4e+hfFWGoJUrmqU9fmS3qkanYfpTZNrautCmHUN+M9DglDMUYPrZ6Cp?=
 =?us-ascii?Q?JhqeBhRdmZdNMvEB7o7LE8KiJwj6E+mOMw7ZIPUl/v0XVlM9hIny4ucShHIB?=
 =?us-ascii?Q?O2QVIA5zMnlR9M4xqPxB3zj/OLUHo6Ole9K51zi1yM/sBEX2DzNVexSeK4Sj?=
 =?us-ascii?Q?v+oXIiLqtEJnrr17PvQisiyocaPN4jj2TVWOyh6KjDwm/sKr94ImPf10Q0/r?=
 =?us-ascii?Q?dhw9X417jrDAB2G9zOUfcAD0iXiUikb6OKVH6F4/ghgwLmmp0MRdQIC4k8Fj?=
 =?us-ascii?Q?HYqXu6zPGDwGwC/OTvlnEfhWujH6dbPUNbX29N4pHvL1POHdy3Df6gzRg7HG?=
 =?us-ascii?Q?6M8SfpNU2ONcf5d8UqLcyle0qXKvHzd1ZYjyAd65KQ9SXxg4StqNeNmvk/d1?=
 =?us-ascii?Q?yfa/J5BHONGEbCDMRA5zELHSVJ6fG41NqBCy7Ug7D0GIWhCMS8nyTav271eT?=
 =?us-ascii?Q?j4ZpW53hw8NN13mIxwBKWUR/2YOqGG+YKk147wo1O+qy0EHkhDVUWkghFo6X?=
 =?us-ascii?Q?juWDZpaEhp3qZdSGpuImwb4Wnj/MMyJUgmtCPYQtqhDZ6dGkfziPpY9//sZw?=
 =?us-ascii?Q?6x+SCU9M23jHfGHuxpyt+GHBer06b1+88D6xCMKOoEn/Q0TNce6GU2Dgm0dM?=
 =?us-ascii?Q?D8jBHVpE0edbyUb01v4GKEwcEF4zexcWfJ9iR2AH8l3wOEg5HkIdUaUv7rOQ?=
 =?us-ascii?Q?Bud0f8+ogbvt23fSwVzkj3QVKD0vS32TYEh3waG132gI+ztEbz2c1X++MOnU?=
 =?us-ascii?Q?M8c0GHCtUz8BQwuxkAQP0yyhJLbbVHO4btidRAYcSxoJkXr54AWiOqcqM05Y?=
 =?us-ascii?Q?goCExWr2ejvLej4DaEbbpLbB7nVVgIY5HKP7ydzXuNvp1Jq8qi1FtCllRxG6?=
 =?us-ascii?Q?ea6VUVmcOYJ05CyU66ajahccLE7oEXeL+ydJq90sMmPiMiEYEtaWGuYZd0XV?=
 =?us-ascii?Q?CLQbBIhIOI/gbYtD8q2BlYrqzon+jbnJ4gGwYz6KezNEIAll3gQAUxOfjRb7?=
 =?us-ascii?Q?V5iTMevJdLJVHPiO+oumdFLUMQ/dlJI7BbCoKM9tf9ZsGs7b7/8M/lu2qZ1a?=
 =?us-ascii?Q?LB2THNS2ll/64rBYMx3CzWZ7CQwh8pk17M6PeodARYb6dvLM9CLKm2P+NYCj?=
 =?us-ascii?Q?9a+OjF2QP0IDW/Ec6oqBsOTRNnYdLfmleteMLZLr+YXGdx/pzCwJMqJzGJeO?=
 =?us-ascii?Q?TkTZlNlV2zGsQgFUKMAQcbLZrN5g2nlUq+uz2MY+KZVCqGmq8hzpi0MOMYpb?=
 =?us-ascii?Q?z/6Ccwu3N3XxYQ7/fDlF8Uw4t2nCa5MXYAhOwrgN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e887f276-5cd4-4701-bb5c-08daef53ca7d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 19:33:58.6939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CBXShzvSLetb8ELJ/OxxFu67nliH8URecn5DQS3ZFT6kjc55U3Z/KTj5N4TbXbxj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6776
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

Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
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
2.39.0

