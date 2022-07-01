Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5452C563C05
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 23:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbiGAVpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 17:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232058AbiGAVp2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 17:45:28 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232A96F36C;
        Fri,  1 Jul 2022 14:45:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gHL4MjaJvC38kBCgetnO9ULWNOlE0yISS3RT/hST3RcuaDU5YPQ+q0hJGWQCd0behlYgfvCq8+hzrN82qz+mD35Tz06HoEkMwH/Mdlw25ZoeOy/cXaaCebAJUmkDUOnjJLdHywgApOl26gbyogpu0kez79sy6dz3ZMwZHXWNDYqHkM+nviDVBbn0hLBHhtvI04xRWDoGP5pF3ozlhOVjieTR8EmH0Y2aSECFSLb11WDd6fW4vUBGCgwitnwi/u144eKP0lZNbo24szbjG9faPn7WY8mvttba3kI5hxnyQrYV2AKk/FGQXfNAorgdnwGEdLlHfT62riR5rpyMS3tDCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CwdZHXjoRblbmukEmi+AT7FP9piX2Pi+haS19LpVbXk=;
 b=SC59yJ3MDxoRJCyCdHT7kgGUtZm1LQNpOyfafK4VBKEUrYZBvuXo901Aa/oGVf6ndwdPyJNbGTXptKK0NQ/vKkWHPIbtyGsX0u7jCZL7j6K4sVa0Fp/5fYD+J8AaiLoqDvq1ZzEBbxutydNlBDg/vqD13j55WFufWFAN1Y3Vkba4ei58oCcpO+VNgyrp6UjOa6/cRIYPM1DGGL9TVrUwzxzZhcE0s6PeS+C3gpjnDG/PtYvyMGAGAHHLYYSlYy8XDgqbvju1Xf1qZ7lFjkKCK7cyxFB0PwUBL+gqf4d36xvHGykaYKcFoJ/Pffn8VEYwSvPN7Y6vEc+cxNnIcOdxMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CwdZHXjoRblbmukEmi+AT7FP9piX2Pi+haS19LpVbXk=;
 b=DJ89L6C2sdeU4/hGEF9pN3Y5JJXT1SRVT2GVg/Z6dFGjCmupHZZlbswRmWyCyizDQa0jY8o6FAx1cqIeNobXL71IdPPCb+7EGcgkAelhXwxGfwRw6T6fr06VolfnZXd92b7CWLNWDe7I/G70jcDS0Sk5WI4E0PJf5ZFKkMepQ9grR3nDsdaSd6S2xN5tyH4HgCf08zRLbws6aCsTzOofx9Uv4AUUq3wvBpqkN4Ajy5Q3eVU4ZwrN24jYQYtFyqAv1TuUFtFBdyL/Q4XUpsRwrADATr8xj45l6fX/R5R21V7mqrn8/C/2MyCXYwMj/cKU1VCEfGSjKnLVl2rSyjzopg==
Received: from DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) by
 BYAPR12MB3480.namprd12.prod.outlook.com (2603:10b6:a03:aa::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.18; Fri, 1 Jul 2022 21:45:15 +0000
Received: from DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:40:cafe::5b) by DM6PR03CA0033.outlook.office365.com
 (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15 via Frontend
 Transport; Fri, 1 Jul 2022 21:45:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT063.mail.protection.outlook.com (10.13.172.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.17 via Frontend Transport; Fri, 1 Jul 2022 21:45:15 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 1 Jul
 2022 21:45:14 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Fri, 1 Jul 2022
 14:45:13 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Fri, 1 Jul 2022 14:45:11 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <marcan@marcan.st>,
        <sven@svenpeter.dev>, <robin.murphy@arm.com>,
        <robdclark@gmail.com>, <baolu.lu@linux.intel.com>,
        <orsonzhai@gmail.com>, <baolin.wang7@gmail.com>,
        <zhang.lyra@gmail.com>, <jean-philippe@linaro.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kevin.tian@intel.com>
CC:     <suravee.suthikulpanit@amd.com>, <alyssa@rosenzweig.io>,
        <dwmw2@infradead.org>, <mjrosato@linux.ibm.com>,
        <gerald.schaefer@linux.ibm.com>, <thierry.reding@gmail.com>,
        <vdumpa@nvidia.com>, <jonathanh@nvidia.com>, <cohuck@redhat.com>,
        <thunder.leizhen@huawei.com>, <christophe.jaillet@wanadoo.fr>,
        <chenxiang66@hisilicon.com>, <john.garry@huawei.com>,
        <yangyingliang@huawei.com>, <iommu@lists.linux-foundation.org>,
        <iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: [PATCH v5 5/5] vfio/iommu_type1: Simplify group attachment
Date:   Fri, 1 Jul 2022 14:44:55 -0700
Message-ID: <20220701214455.14992-6-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220701214455.14992-1-nicolinc@nvidia.com>
References: <20220701214455.14992-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7860a5b4-7207-4cf2-c5d2-08da5baafbba
X-MS-TrafficTypeDiagnostic: BYAPR12MB3480:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ebABnAaW+oJCCgqUNTIgLdRlqkEdyZMtdqOGBV9z46hvjJhruL0H2U0HKwYgXDoZLO0HB5nDtKENvX8JbcUsDSuW6wE9QeX0thg0qCTL1sxhMt+xoePq8xJhS89E7fQPbifEl7ERindzY4d8uK4sbxhNvMPiSXCqeZasQ7ETn1a5cIQgxt0YMvHX564AyYU+Co8vMMp74ihQRM7Ki3vWGuJF2ZY0/bGmnj0ngHf7xU67o8XMwSIM9mtlqA99xRF3169OJC4gdsjacMPoidj+wxm+7lGqdZuaA5yEeT7/LLjwiyXAvZgNPiHw0LjiVv2dGDmji+VnwmLKRUDqPmSkRfP+N7VU9CgMbfVyHfHqUtdxeqG0BDCNNLDsf+r46HHPd3tGMIz2PD+MH2eyx5mUiyacpcseAMzdgZtIosA5O0vzO+yH7bQ3Gl1IxYfiCwGm9GxUjcb/CNo0KmhQsA+mDteBaXjTqBFIhZgOtm+lH8ix8rkUf7guzv4iKSDuaVsRSROT3gjgkjCD/tEFaC8JT40R5VlDnL6ywymOKW9AyRH4zcb56XDmteJVAgA6MI2FHi9w4NcnfB32LYx3dfOK3VgMdWe+h0BHKgRP2NpAw9vAtxtNpBnrr0MEJ2sMFZX8b6O40wIpNkARf7x5Bkh8A7zYtvP9fQ0Faz5xUArHiAeic+aAaSZeFW4D+OHGQ7r9V1RJAx8myad22kDh6ONF8qlvJyv4o1BNwnNW23EQ72JMDvn6WFOouXCfU6tdISqXJmuCRW7Nc57lznAR7Fkv5mofgUEeaAX3kkfT38GAB+n2YGRzgc7WafmEkKAgyazXNNyQHaUlmEhLk7xGC0uG+Igp+dX9cdzeUuksqICu/wumz1COXEWdhgHTJW8rqlOwZDEFbF3mzcBjptnbQNIb5TwdqZ8pfT3b5UHJnYdXTdo=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(39860400002)(396003)(46966006)(36840700001)(40470700004)(7416002)(81166007)(36756003)(6666004)(2906002)(356005)(40480700001)(8676002)(186003)(70586007)(54906003)(7406005)(8936002)(7696005)(70206006)(5660300002)(41300700001)(921005)(86362001)(30864003)(40460700003)(82740400003)(82310400005)(110136005)(426003)(4326008)(2616005)(83380400001)(47076005)(336012)(36860700001)(316002)(1076003)(26005)(478600001)(36900700001)(2101003)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 21:45:15.0517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7860a5b4-7207-4cf2-c5d2-08da5baafbba
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3480
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Un-inline the domain specific logic from the attach/detach_group ops into
two paired functions vfio_iommu_alloc_attach_domain() and
vfio_iommu_detach_destroy_domain() that strictly deal with creating and
destroying struct vfio_domains.

Add the logic to check for EMEDIUMTYPE return code of iommu_attach_group()
and avoid the extra domain allocations and attach/detach sequences of the
old code. This allows properly detecting an actual attach error, like
-ENOMEM, vs treating all attach errors as an incompatible domain.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 333 +++++++++++++++++---------------
 1 file changed, 180 insertions(+), 153 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 5624bbf02ab7..d3a4cedcd082 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2155,14 +2155,179 @@ static int vfio_iommu_domain_alloc(struct device *dev, void *data)
 	return 1; /* Don't iterate */
 }
 
+static struct vfio_domain *
+vfio_iommu_alloc_attach_domain(struct vfio_iommu *iommu,
+			       struct vfio_iommu_group *group,
+			       struct list_head *group_resv_regions)
+{
+	struct iommu_domain *new_domain;
+	struct vfio_domain *domain;
+	phys_addr_t resv_msi_base;
+	int ret = 0;
+
+	/* Try to match an existing compatible domain */
+	list_for_each_entry (domain, &iommu->domain_list, next) {
+		ret = iommu_attach_group(domain->domain, group->iommu_group);
+		/* -EMEDIUMTYPE means an incompatible domain, so try next one */
+		if (ret == -EMEDIUMTYPE)
+			continue;
+		if (ret)
+			return ERR_PTR(ret);
+		goto done;
+	}
+
+	/*
+	 * Going via the iommu_group iterator avoids races, and trivially gives
+	 * us a representative device for the IOMMU API call. We don't actually
+	 * want to iterate beyond the first device (if any).
+	 */
+	iommu_group_for_each_dev(group->iommu_group, &new_domain,
+				 vfio_iommu_domain_alloc);
+	if (!new_domain)
+		return ERR_PTR(-EIO);
+
+	if (iommu->nesting) {
+		ret = iommu_enable_nesting(new_domain);
+		if (ret)
+			goto out_free_iommu_domain;
+	}
+
+	ret = iommu_attach_group(new_domain, group->iommu_group);
+	if (ret)
+		goto out_free_iommu_domain;
+
+	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
+	if (!domain) {
+		ret = -ENOMEM;
+		goto out_detach;
+	}
+
+	domain->domain = new_domain;
+	vfio_test_domain_fgsp(domain);
+
+	/*
+	 * If the IOMMU can block non-coherent operations (ie PCIe TLPs with
+	 * no-snoop set) then VFIO always turns this feature on because on Intel
+	 * platforms it optimizes KVM to disable wbinvd emulation.
+	 */
+	if (new_domain->ops->enforce_cache_coherency)
+		domain->enforce_cache_coherency =
+			new_domain->ops->enforce_cache_coherency(new_domain);
+
+	/* replay mappings on new domains */
+	ret = vfio_iommu_replay(iommu, domain);
+	if (ret)
+		goto out_free_domain;
+
+	if (vfio_iommu_has_sw_msi(group_resv_regions, &resv_msi_base)) {
+		ret = iommu_get_msi_cookie(domain->domain, resv_msi_base);
+		if (ret && ret != -ENODEV)
+			goto out_free_domain;
+	}
+
+	INIT_LIST_HEAD(&domain->group_list);
+	list_add(&domain->next, &iommu->domain_list);
+	vfio_update_pgsize_bitmap(iommu);
+
+done:
+	list_add(&group->next, &domain->group_list);
+
+	/*
+	 * An iommu backed group can dirty memory directly and therefore
+	 * demotes the iommu scope until it declares itself dirty tracking
+	 * capable via the page pinning interface.
+	 */
+	iommu->num_non_pinned_groups++;
+
+	return domain;
+
+out_free_domain:
+	kfree(domain);
+out_detach:
+	iommu_detach_group(new_domain, group->iommu_group);
+out_free_iommu_domain:
+	iommu_domain_free(new_domain);
+	return ERR_PTR(ret);
+}
+
+static void vfio_iommu_unmap_unpin_all(struct vfio_iommu *iommu)
+{
+	struct rb_node *node;
+
+	while ((node = rb_first(&iommu->dma_list)))
+		vfio_remove_dma(iommu, rb_entry(node, struct vfio_dma, node));
+}
+
+static void vfio_iommu_unmap_unpin_reaccount(struct vfio_iommu *iommu)
+{
+	struct rb_node *n, *p;
+
+	n = rb_first(&iommu->dma_list);
+	for (; n; n = rb_next(n)) {
+		struct vfio_dma *dma;
+		long locked = 0, unlocked = 0;
+
+		dma = rb_entry(n, struct vfio_dma, node);
+		unlocked += vfio_unmap_unpin(iommu, dma, false);
+		p = rb_first(&dma->pfn_list);
+		for (; p; p = rb_next(p)) {
+			struct vfio_pfn *vpfn = rb_entry(p, struct vfio_pfn,
+							 node);
+
+			if (!is_invalid_reserved_pfn(vpfn->pfn))
+				locked++;
+		}
+		vfio_lock_acct(dma, locked - unlocked, true);
+	}
+}
+
+static void vfio_iommu_detach_destroy_domain(struct vfio_domain *domain,
+					     struct vfio_iommu *iommu,
+					     struct vfio_iommu_group *group)
+{
+	iommu_detach_group(domain->domain, group->iommu_group);
+	list_del(&group->next);
+	if (!list_empty(&domain->group_list))
+		goto out_dirty;
+
+	/*
+	 * Group ownership provides privilege, if the group list is empty, the
+	 * domain goes away. If it's the last domain with iommu and external
+	 * domain doesn't exist, then all the mappings go away too. If it's the
+	 * last domain with iommu and external domain exist, update accounting
+	 */
+	if (list_is_singular(&iommu->domain_list)) {
+		if (list_empty(&iommu->emulated_iommu_groups)) {
+			WARN_ON(iommu->notifier.head);
+			vfio_iommu_unmap_unpin_all(iommu);
+		} else {
+			vfio_iommu_unmap_unpin_reaccount(iommu);
+		}
+	}
+	iommu_domain_free(domain->domain);
+	list_del(&domain->next);
+	kfree(domain);
+	vfio_update_pgsize_bitmap(iommu);
+
+out_dirty:
+	/*
+	 * Removal of a group without dirty tracking may allow the iommu scope
+	 * to be promoted.
+	 */
+	if (!group->pinned_page_dirty_scope) {
+		iommu->num_non_pinned_groups--;
+		if (iommu->dirty_page_tracking)
+			vfio_iommu_populate_bitmap_full(iommu);
+	}
+}
+
 static int vfio_iommu_type1_attach_group(void *iommu_data,
 		struct iommu_group *iommu_group, enum vfio_group_type type)
 {
 	struct vfio_iommu *iommu = iommu_data;
 	struct vfio_iommu_group *group;
-	struct vfio_domain *domain, *d;
-	bool resv_msi, msi_remap;
-	phys_addr_t resv_msi_base = 0;
+	struct vfio_domain *domain;
+	bool msi_remap;
 	struct iommu_domain_geometry *geo;
 	LIST_HEAD(iova_copy);
 	LIST_HEAD(group_resv_regions);
@@ -2193,32 +2358,17 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		goto out_unlock;
 	}
 
-	ret = -ENOMEM;
-	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
-	if (!domain)
+	ret = iommu_get_group_resv_regions(iommu_group, &group_resv_regions);
+	if (ret)
 		goto out_free_group;
 
-	/*
-	 * Going via the iommu_group iterator avoids races, and trivially gives
-	 * us a representative device for the IOMMU API call. We don't actually
-	 * want to iterate beyond the first device (if any).
-	 */
-	ret = -EIO;
-	iommu_group_for_each_dev(iommu_group, &domain->domain,
-				 vfio_iommu_domain_alloc);
-	if (!domain->domain)
-		goto out_free_domain;
-
-	if (iommu->nesting) {
-		ret = iommu_enable_nesting(domain->domain);
-		if (ret)
-			goto out_domain;
+	domain = vfio_iommu_alloc_attach_domain(iommu, group,
+						&group_resv_regions);
+	if (IS_ERR(domain)) {
+		ret = PTR_ERR(domain);
+		goto out_free_group;
 	}
 
-	ret = iommu_attach_group(domain->domain, group->iommu_group);
-	if (ret)
-		goto out_domain;
-
 	/* Get aperture info */
 	geo = &domain->domain->geometry;
 	if (vfio_iommu_aper_conflict(iommu, geo->aperture_start,
@@ -2227,10 +2377,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		goto out_detach;
 	}
 
-	ret = iommu_get_group_resv_regions(iommu_group, &group_resv_regions);
-	if (ret)
-		goto out_detach;
-
 	if (vfio_iommu_resv_conflict(iommu, &group_resv_regions)) {
 		ret = -EINVAL;
 		goto out_detach;
@@ -2254,11 +2400,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	if (ret)
 		goto out_detach;
 
-	resv_msi = vfio_iommu_has_sw_msi(&group_resv_regions, &resv_msi_base);
-
-	INIT_LIST_HEAD(&domain->group_list);
-	list_add(&group->next, &domain->group_list);
-
 	msi_remap = irq_domain_check_msi_remap() ||
 		    iommu_group_for_each_dev(iommu_group, (void *)IOMMU_CAP_INTR_REMAP,
 					     vfio_iommu_device_capable);
@@ -2270,107 +2411,25 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		goto out_detach;
 	}
 
-	/*
-	 * If the IOMMU can block non-coherent operations (ie PCIe TLPs with
-	 * no-snoop set) then VFIO always turns this feature on because on Intel
-	 * platforms it optimizes KVM to disable wbinvd emulation.
-	 */
-	if (domain->domain->ops->enforce_cache_coherency)
-		domain->enforce_cache_coherency =
-			domain->domain->ops->enforce_cache_coherency(
-				domain->domain);
-
-	/* Try to match an existing compatible domain */
-	list_for_each_entry(d, &iommu->domain_list, next) {
-		iommu_detach_group(domain->domain, group->iommu_group);
-		if (!iommu_attach_group(d->domain, group->iommu_group)) {
-			list_add(&group->next, &d->group_list);
-			iommu_domain_free(domain->domain);
-			kfree(domain);
-			goto done;
-		}
-
-		ret = iommu_attach_group(domain->domain,  group->iommu_group);
-		if (ret)
-			goto out_domain;
-	}
-
-	vfio_test_domain_fgsp(domain);
-
-	/* replay mappings on new domains */
-	ret = vfio_iommu_replay(iommu, domain);
-	if (ret)
-		goto out_detach;
-
-	if (resv_msi) {
-		ret = iommu_get_msi_cookie(domain->domain, resv_msi_base);
-		if (ret && ret != -ENODEV)
-			goto out_detach;
-	}
-
-	list_add(&domain->next, &iommu->domain_list);
-	vfio_update_pgsize_bitmap(iommu);
-done:
 	/* Delete the old one and insert new iova list */
 	vfio_iommu_iova_insert_copy(iommu, &iova_copy);
 
-	/*
-	 * An iommu backed group can dirty memory directly and therefore
-	 * demotes the iommu scope until it declares itself dirty tracking
-	 * capable via the page pinning interface.
-	 */
-	iommu->num_non_pinned_groups++;
 	mutex_unlock(&iommu->lock);
 	vfio_iommu_resv_free(&group_resv_regions);
 
 	return 0;
 
 out_detach:
-	iommu_detach_group(domain->domain, group->iommu_group);
-out_domain:
-	iommu_domain_free(domain->domain);
-	vfio_iommu_iova_free(&iova_copy);
-	vfio_iommu_resv_free(&group_resv_regions);
-out_free_domain:
-	kfree(domain);
+	vfio_iommu_detach_destroy_domain(domain, iommu, group);
 out_free_group:
 	kfree(group);
 out_unlock:
 	mutex_unlock(&iommu->lock);
+	vfio_iommu_iova_free(&iova_copy);
+	vfio_iommu_resv_free(&group_resv_regions);
 	return ret;
 }
 
-static void vfio_iommu_unmap_unpin_all(struct vfio_iommu *iommu)
-{
-	struct rb_node *node;
-
-	while ((node = rb_first(&iommu->dma_list)))
-		vfio_remove_dma(iommu, rb_entry(node, struct vfio_dma, node));
-}
-
-static void vfio_iommu_unmap_unpin_reaccount(struct vfio_iommu *iommu)
-{
-	struct rb_node *n, *p;
-
-	n = rb_first(&iommu->dma_list);
-	for (; n; n = rb_next(n)) {
-		struct vfio_dma *dma;
-		long locked = 0, unlocked = 0;
-
-		dma = rb_entry(n, struct vfio_dma, node);
-		unlocked += vfio_unmap_unpin(iommu, dma, false);
-		p = rb_first(&dma->pfn_list);
-		for (; p; p = rb_next(p)) {
-			struct vfio_pfn *vpfn = rb_entry(p, struct vfio_pfn,
-							 node);
-
-			if (!is_invalid_reserved_pfn(vpfn->pfn))
-				locked++;
-		}
-		vfio_lock_acct(dma, locked - unlocked, true);
-	}
-}
-
 /*
  * Called when a domain is removed in detach. It is possible that
  * the removed domain decided the iova aperture window. Modify the
@@ -2485,44 +2544,12 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 		group = find_iommu_group(domain, iommu_group);
 		if (!group)
 			continue;
-
-		iommu_detach_group(domain->domain, group->iommu_group);
-		list_del(&group->next);
-		/*
-		 * Group ownership provides privilege, if the group list is
-		 * empty, the domain goes away. If it's the last domain with
-		 * iommu and external domain doesn't exist, then all the
-		 * mappings go away too. If it's the last domain with iommu and
-		 * external domain exist, update accounting
-		 */
-		if (list_empty(&domain->group_list)) {
-			if (list_is_singular(&iommu->domain_list)) {
-				if (list_empty(&iommu->emulated_iommu_groups)) {
-					WARN_ON(iommu->notifier.head);
-					vfio_iommu_unmap_unpin_all(iommu);
-				} else {
-					vfio_iommu_unmap_unpin_reaccount(iommu);
-				}
-			}
-			iommu_domain_free(domain->domain);
-			list_del(&domain->next);
-			kfree(domain);
-			vfio_iommu_aper_expand(iommu, &iova_copy);
-			vfio_update_pgsize_bitmap(iommu);
-		}
-		/*
-		 * Removal of a group without dirty tracking may allow
-		 * the iommu scope to be promoted.
-		 */
-		if (!group->pinned_page_dirty_scope) {
-			iommu->num_non_pinned_groups--;
-			if (iommu->dirty_page_tracking)
-				vfio_iommu_populate_bitmap_full(iommu);
-		}
+		vfio_iommu_detach_destroy_domain(domain, iommu, group);
 		kfree(group);
 		break;
 	}
 
+	vfio_iommu_aper_expand(iommu, &iova_copy);
 	if (!vfio_iommu_resv_refresh(iommu, &iova_copy))
 		vfio_iommu_iova_insert_copy(iommu, &iova_copy);
 	else
-- 
2.17.1

