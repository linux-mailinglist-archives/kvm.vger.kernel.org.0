Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F7C54D5C5
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 02:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355228AbiFPADq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 20:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350582AbiFPAD2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 20:03:28 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07166562EC;
        Wed, 15 Jun 2022 17:03:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BWLY2CWMyJ2C6hh8D40wr8XdiBJXmZWFTGN23E2ejFUkfrJrsPr3HhIXcdfc5/K8uIGdxUJOSJhtLy0vPfEDU2+iGfBdRdAQXNZWbZT9cR+yHw6KveRtuxyf1ZOHDdgr1YbiwDsh2WvC/Ke3B8garvYhHtarzXL8nsXucaju5PrU1tfUs0q6cw3lMUrlA0xbA3wBOUtYx39yo0ZFwRw+t+XGr8UY75tas4M1A+D+y/JRG1rfLsMfABsKiprlWjQwhVO50KbOGyXCuzPwI4p/XbL3P+Zi4OFNaxBMqlKhQBL/CuzojHcmCQRn0+Var9rP8mzqHrjfONZAybq0B4CRdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oX4lVfi6U1wD2Y1TX0Jzjj5byYCwr4lkCfyYZBLts1s=;
 b=lbEl9qEppK/93xWynNfrLiKVOBKq3WPYnOFKSfmDeGMdeKOC8Xn4uhyTuXu4qFEPpkoG0yiVOEhWo1yLdMXvUDmtHOlaTBdNX38mB6S2Yg50WlaX75ajCco7mffalOPUh6TodhMzHIHtPeXL+4ag/Dv/OqXSJFDAIPgJAKtoxs6QFCwrnLJeUcj+hvOkU8I5yeam5wwLbrQSKKueQ38ge59KDduJNXEQF9cLvAnbc/hzHWtGlo2CZ3nOnYwnOsAhTnBKKt9CnTk/Xt4dnk9gI5gdd5snDEg4qyklRAmcew0eOXgom9pas87wcuPTZLKVy4sHT53N6kZhCaLCKQOWxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oX4lVfi6U1wD2Y1TX0Jzjj5byYCwr4lkCfyYZBLts1s=;
 b=EKTICm+p2ft3FdNI2O60kOqeJ3XOi/DTqiE8r0CiDbW/w98gOMwoc15rO/ha+y2vCHozc7o8DbvfFk9itvcomO7n0cPvlKaUKX6LAxwZg6eQ5ViSZRA8nUkLth1pj7n/voyGeLBNMygafwx5muZTc+FJ5bUllGwGbtWnAApFQKGf1mOPQQwzHZB5Cf709Qg22U0ZaRH89cGtcXE9gQukjDj2rZaJt4Z6TeqqOD+G2q8/4B7UIvSXK5aAregTxoLQqZs33JY6knjcpCfnPrNj9vH1hWr84feLgZrx4T3h7nHvE8rCovYbAsiLV7yvmfAeBtE5NV10Xxxq6AWcSqle1w==
Received: from MWHPR19CA0089.namprd19.prod.outlook.com (2603:10b6:320:1f::27)
 by BL1PR12MB5706.namprd12.prod.outlook.com (2603:10b6:208:385::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.22; Thu, 16 Jun
 2022 00:03:22 +0000
Received: from CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:320:1f:cafe::49) by MWHPR19CA0089.outlook.office365.com
 (2603:10b6:320:1f::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Thu, 16 Jun 2022 00:03:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT060.mail.protection.outlook.com (10.13.175.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Thu, 16 Jun 2022 00:03:21 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 16 Jun 2022 00:03:21 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 15 Jun 2022 17:03:20 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Wed, 15 Jun 2022 17:03:18 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <marcan@marcan.st>,
        <sven@svenpeter.dev>, <robin.murphy@arm.com>,
        <robdclark@gmail.com>, <baolu.lu@linux.intel.com>,
        <matthias.bgg@gmail.com>, <orsonzhai@gmail.com>,
        <baolin.wang7@gmail.com>, <zhang.lyra@gmail.com>,
        <jean-philippe@linaro.org>, <alex.williamson@redhat.com>,
        <jgg@nvidia.com>, <kevin.tian@intel.com>
CC:     <suravee.suthikulpanit@amd.com>, <alyssa@rosenzweig.io>,
        <dwmw2@infradead.org>, <yong.wu@mediatek.com>,
        <mjrosato@linux.ibm.com>, <gerald.schaefer@linux.ibm.com>,
        <thierry.reding@gmail.com>, <vdumpa@nvidia.com>,
        <jonathanh@nvidia.com>, <cohuck@redhat.com>,
        <thunder.leizhen@huawei.com>, <tglx@linutronix.de>,
        <christophe.jaillet@wanadoo.fr>, <john.garry@huawei.com>,
        <chenxiang66@hisilicon.com>, <saiprakash.ranjan@codeaurora.org>,
        <isaacm@codeaurora.org>, <yangyingliang@huawei.com>,
        <jordan@cosmicpenguin.net>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: [PATCH v2 5/5] vfio/iommu_type1: Simplify group attachment
Date:   Wed, 15 Jun 2022 17:03:04 -0700
Message-ID: <20220616000304.23890-6-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220616000304.23890-1-nicolinc@nvidia.com>
References: <20220616000304.23890-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fdd0e1a-ad8e-4a5a-3132-08da4f2ba06b
X-MS-TrafficTypeDiagnostic: BL1PR12MB5706:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB57066742A6382376D9B6C5E3ABAC9@BL1PR12MB5706.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k/BonHpEmQVv92qxx6gY499NMhFJa50Un+VMJTdsuZailhAV/sHa4uaq93spAFg8Sij2ogW2Z2A4FBpEzvYeHQFYfxRFI82fxDRwu0P3GvjhMkHw6CbBg3XvjCK/6jLzBTlQ0mmIzZrj1Fg0DehbA+u0+ZwXFo5FnB+da/jnuEC8UH1TR32/t71NQHP98E6SaV1Fk2s/uFTrLgprq/mOYc/j9zJEIVzwbSFCy67rKkdKWGxpZrO25md72ciEHbaXmOEdnC020WCx8B2dKMqumq9N+EQI3v+h4PjB+LEZOwW5LwDdJvzDWJvlbpSsPe0v6ukI09OGJhR1ameurhlol3cBBObzcINERlpPzXUNL3mYkqI1mOF0m/XnksQu33oPVE7X42cJKnRySu1cxMfK34kOwUt5BTVR7I8syQ/k2CANwfHKhYHB7VOlWleZSYA8VRQzvlqXl3eDA9xOj6sLU5dkzXIiQSyazuWyRTAKbOFpRGe/1a6w+xmNNvGMtovP9zsYPSLcEZbin263Y+OXjahWBUVoQU/f2V3gWkm8VmflXz2RESGZP3Kysrc6Pg1s9x+nhHrMwyaaTSBN/aVEnIhudoFw6THCtuNAUuH5QTqXN/kLksHZVsYsoP3Ss5cxfPncQRiSvHpYl7j73zWdjmcBE+1w6COFsuhcy4PF2bVPq7sTcAqoJkI1ujwQPzOnTkOqEV57sjyMMwXry4dATaLQt6FZ6BHWTU/VZUWrzqEoLPY05SOhA2LhBzwTJ4688l88are2wsXgCYEXfOlqWw==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(40470700004)(46966006)(36840700001)(40460700003)(81166007)(83380400001)(8936002)(7416002)(26005)(186003)(7406005)(1076003)(2906002)(6666004)(7696005)(36756003)(5660300002)(30864003)(2616005)(8676002)(70586007)(426003)(54906003)(86362001)(356005)(921005)(4326008)(508600001)(110136005)(47076005)(336012)(36860700001)(82310400005)(70206006)(316002)(2101003)(83996005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 00:03:21.8507
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fdd0e1a-ad8e-4a5a-3132-08da4f2ba06b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5706
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 298 +++++++++++++++++---------------
 1 file changed, 163 insertions(+), 135 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 573caf320788..5986c68e59ee 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -86,6 +86,7 @@ struct vfio_domain {
 	struct list_head	group_list;
 	bool			fgsp : 1;	/* Fine-grained super pages */
 	bool			enforce_cache_coherency : 1;
+	bool			msi_cookie : 1;
 };
 
 struct vfio_dma {
@@ -2153,12 +2154,163 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
 	list_splice_tail(iova_copy, iova);
 }
 
+static struct vfio_domain *
+vfio_iommu_alloc_attach_domain(struct bus_type *bus, struct vfio_iommu *iommu,
+			       struct vfio_iommu_group *group)
+{
+	struct iommu_domain *new_domain;
+	struct vfio_domain *domain;
+	int ret = 0;
+
+	/* Try to match an existing compatible domain */
+	list_for_each_entry (domain, &iommu->domain_list, next) {
+		ret = iommu_attach_group(domain->domain, group->iommu_group);
+		if (ret == -EMEDIUMTYPE)
+			continue;
+		if (ret)
+			return ERR_PTR(ret);
+		goto done;
+	}
+
+	new_domain = iommu_domain_alloc(bus);
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
+	struct vfio_domain *domain;
 	struct bus_type *bus = NULL;
 	bool resv_msi, msi_remap;
 	phys_addr_t resv_msi_base = 0;
@@ -2197,26 +2349,12 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	if (ret)
 		goto out_free_group;
 
-	ret = -ENOMEM;
-	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
-	if (!domain)
+	domain = vfio_iommu_alloc_attach_domain(bus, iommu, group);
+	if (IS_ERR(domain)) {
+		ret = PTR_ERR(domain);
 		goto out_free_group;
-
-	ret = -EIO;
-	domain->domain = iommu_domain_alloc(bus);
-	if (!domain->domain)
-		goto out_free_domain;
-
-	if (iommu->nesting) {
-		ret = iommu_enable_nesting(domain->domain);
-		if (ret)
-			goto out_domain;
 	}
 
-	ret = iommu_attach_group(domain->domain, group->iommu_group);
-	if (ret)
-		goto out_domain;
-
 	/* Get aperture info */
 	geo = &domain->domain->geometry;
 	if (vfio_iommu_aper_conflict(iommu, geo->aperture_start,
@@ -2254,9 +2392,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 
 	resv_msi = vfio_iommu_has_sw_msi(&group_resv_regions, &resv_msi_base);
 
-	INIT_LIST_HEAD(&domain->group_list);
-	list_add(&group->next, &domain->group_list);
-
 	msi_remap = irq_domain_check_msi_remap() ||
 		    iommu_capable(bus, IOMMU_CAP_INTR_REMAP);
 
@@ -2267,107 +2402,32 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
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
+	if (resv_msi && !domain->msi_cookie) {
 		ret = iommu_get_msi_cookie(domain->domain, resv_msi_base);
 		if (ret && ret != -ENODEV)
 			goto out_detach;
+		domain->msi_cookie = true;
 	}
 
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
@@ -2481,44 +2541,12 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
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

