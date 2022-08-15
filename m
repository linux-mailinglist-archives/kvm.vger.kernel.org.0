Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96615934E8
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 20:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239791AbiHOSRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 14:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238496AbiHOSQl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 14:16:41 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4859C2B196;
        Mon, 15 Aug 2022 11:15:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jnJct5glXxuRsqPHx+SNxpbuG6vmrvJ1vu1AFPa/s0t3rKsHAxvovTZ/OabojbM50CLzRHLkh4o9TSQltlbfwlDqfSJ7UCtexlBYM3L3NR/UTB8YN9FF7p/CQDo/8ktrgK3Hs40NaZgeCCIp++Nx5bMJtJ9eYxXKGYE+UiNt5VVIlNqlwmJJioh15eUHoBcWonee65qUCmKos0dY7f3KzDGiMfn9mUFd1qZnZsaTkdbzzYsEi7ITjLF1DJXyuQlEJEGoiVRTDNcc9kq+vMUNwz/2RuLLD7HWWaVqNzkVXcZk9HS32b5zK6loesszLfZQ+8GqK3K2+taMUyAsVLvedA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3fC522AkfGkzCZT2al4Vn8EClV5JuJDQb66exOspkjU=;
 b=gB6UgN3VerLFg0QCHVF1hXKBBplW3WxEGtDMKnQCnsDPlxX4bwnFmvoooxmGpzPTnhskm/j4CSwL4R2/snboi3wtJ3zteq5tgfIAfC8r4PwMERfHvitvsFMRTVRKH6RX1H6GVhYzDYSC+LaHENYYortVDVJ5St9+CqQ94tOY4pMyRPpx4rZpbngIHle4rZKtxPOrLldQc1x0js7YUej97eAvUKaZ/UNNCY1aWjr+L13Fkak/x57ldJN2MVZHjYyh+kPQjlWZT29Tnlq7IMfiQKqM/ohyj8oiXOkEQgFInqr8tkcJmg3KujzsHujsTf2B3pO3V+uk+Pr6e2PeMljhpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=rosenzweig.io smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3fC522AkfGkzCZT2al4Vn8EClV5JuJDQb66exOspkjU=;
 b=H6YN4pj8wBy7Cue7x/VU0jH3UYqJDL5SYV5ucv80ZwRNmv1f54ElM96F652PgKIIv7kFrJkbPCDVSwLY7xb2/oUGJKPQb3AfKLj8jUUZksC04eg9Gs6fWtXgy1H2A1RbI9OpD37PncopcHMKmEA+OCtt1euf7L8oWqdgWivkRVkjDERRgCkt9hJN5f9Puxw1IpqWzi7Lnn1qEd8a8KMzEenLj06r8K+ZZjXrZS+qpPZ29u3m0xQw56wTViBPsxdOMLzei8/9y3b2YBq505CgSE/PEN1zlA5Ct1fJuTEoNL93HC32DZ31/ZcgAndBzLdGzur32U11plxy6lHziUmiTQ==
Received: from DM6PR06CA0062.namprd06.prod.outlook.com (2603:10b6:5:54::39) by
 CY5PR12MB6178.namprd12.prod.outlook.com (2603:10b6:930:25::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.28; Mon, 15 Aug 2022 18:14:57 +0000
Received: from DM6NAM11FT109.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::ff) by DM6PR06CA0062.outlook.office365.com
 (2603:10b6:5:54::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.18 via Frontend
 Transport; Mon, 15 Aug 2022 18:14:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT109.mail.protection.outlook.com (10.13.173.178) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.7 via Frontend Transport; Mon, 15 Aug 2022 18:14:56 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Mon, 15 Aug 2022 18:14:56 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 15 Aug 2022 11:14:55 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Mon, 15 Aug 2022 11:14:53 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <robin.murphy@arm.com>,
        <alex.williamson@redhat.com>
CC:     <suravee.suthikulpanit@amd.com>, <marcan@marcan.st>,
        <sven@svenpeter.dev>, <alyssa@rosenzweig.io>,
        <robdclark@gmail.com>, <dwmw2@infradead.org>,
        <baolu.lu@linux.intel.com>, <mjrosato@linux.ibm.com>,
        <gerald.schaefer@linux.ibm.com>, <orsonzhai@gmail.com>,
        <baolin.wang@linux.alibaba.com>, <zhang.lyra@gmail.com>,
        <thierry.reding@gmail.com>, <vdumpa@nvidia.com>,
        <jonathanh@nvidia.com>, <jean-philippe@linaro.org>,
        <cohuck@redhat.com>, <jgg@nvidia.com>, <tglx@linutronix.de>,
        <shameerali.kolothum.thodi@huawei.com>,
        <thunder.leizhen@huawei.com>, <christophe.jaillet@wanadoo.fr>,
        <yangyingliang@huawei.com>, <jon@solid-run.com>,
        <iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <asahi@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <kevin.tian@intel.com>
Subject: [PATCH v6 5/5] vfio/iommu_type1: Simplify group attachment
Date:   Mon, 15 Aug 2022 11:14:37 -0700
Message-ID: <20220815181437.28127-6-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220815181437.28127-1-nicolinc@nvidia.com>
References: <20220815181437.28127-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9d7b7eb-2a52-43ca-5210-08da7eea0f18
X-MS-TrafficTypeDiagnostic: CY5PR12MB6178:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5+DUxYDIoCX8R+jqbhG5h0fC4jw+7cj80r7fcVyBwPejMEN3fh9fQGP+3eJ5yrrjT7WAQ6n6Dl/DwRzUnGD1zzNu+SCZSOu8mnlMU+7zlsT+OWWCZzoCTLBvnqm97dnOtdUANfy7iNNYsZ+FsTp9OqkI/BVHYttXWjbQCt2M1uCQXx59qxO/TFhpbvZtt0TGC8Cp0YC7RkFG1jEAeUD5g7cdZyyKYRK0QvimCb9tr3rF0gkSunQ02iAKcJX0iHxazTiyNI4mMw39ArjcKJQ7tf5uQSDNjNnNHhCM8iLa6OQyq90hOVgxAifOLv9++WlFe4H6I1m4/vrdGFTSfIdi6ykfgV/F6Baw2E1ba5K3QscWljUtuH/pdq/u6xkFKGQEl8sEzQ5YJ/kgwuOESC3FaHUNWuF5sdpIx4ozo/fTYE21RAmUyVpwONNTDTitn4EzGj2ozGAYftukQz64VP9ujE2CxWEKMOs9XrpyGpu0V27CRWbl3i+f8+uY6+/k1k8V4bXnoyqn9NFnfyOdNv+/+9BzXFsXXWce69D0sOFxKap/qoESwzKKbu4wAwTWz9c9K+Gxqd7onW6va0G1XQt8I+D4I+UlZIve5jaUORU9Zsa2kAvecIBYyOTnBaY/DrKweZEa14Ft2O7WkgFQucgPzyETo2hW6kL6Qv9KUAHy5bElVu0sc1gJyA+siLHKvkBka9nA+tLgxE3gmW3azV7ALU0Xm75ZcYEJY/H6eFAEwcBrg8T+qKWhzF3xvZjlrbZAzW52MIUE+SBDLSEOuFZDMDrPnYnCXmRzzcq7gp0eSAxQt81Q13y7Ea+tmCpoGTcOzIZvvZB1gf2vpSYJ74/0RQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(39860400002)(376002)(46966006)(36840700001)(40470700004)(356005)(81166007)(86362001)(8676002)(36860700001)(336012)(186003)(426003)(2616005)(47076005)(40460700003)(82740400003)(83380400001)(70206006)(70586007)(36756003)(4326008)(1076003)(316002)(82310400005)(2906002)(30864003)(8936002)(5660300002)(7416002)(7406005)(41300700001)(478600001)(6666004)(7696005)(40480700001)(54906003)(110136005)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 18:14:56.5483
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9d7b7eb-2a52-43ca-5210-08da7eea0f18
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT109.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6178
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/vfio/vfio_iommu_type1.c | 334 +++++++++++++++++---------------
 1 file changed, 180 insertions(+), 154 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 3b63a5a237c9..51d29b8780cd 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2163,14 +2163,179 @@ static int vfio_iommu_domain_alloc(struct device *dev, void *data)
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
+			WARN_ON(!list_empty(&iommu->device_list));
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
@@ -2201,32 +2366,17 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
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
@@ -2235,10 +2385,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		goto out_detach;
 	}
 
-	ret = iommu_get_group_resv_regions(iommu_group, &group_resv_regions);
-	if (ret)
-		goto out_detach;
-
 	if (vfio_iommu_resv_conflict(iommu, &group_resv_regions)) {
 		ret = -EINVAL;
 		goto out_detach;
@@ -2262,11 +2408,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
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
@@ -2278,107 +2419,25 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
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
@@ -2493,45 +2552,12 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
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
-					WARN_ON(!list_empty(
-						&iommu->device_list));
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

