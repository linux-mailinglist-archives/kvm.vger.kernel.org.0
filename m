Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D14936FD46E
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 05:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235735AbjEJDgL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 23:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235768AbjEJDfA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 23:35:00 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2057.outbound.protection.outlook.com [40.107.93.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6824B59E5;
        Tue,  9 May 2023 20:34:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LsjJgsSik2z+2Hcfv/3LiJttY8m9xxYSEwNfTvVef5hO/twhXm9LVnpt1zbkyWe/Jaj+BMrVS219WwQ1tQT4XN4vWOj2zL7ekrn4CwdsamIye9TONCz/6WzG8MM28L/H2dt6Kpi29cWqhnEOs7oNjp5XpIXnQdnEPJzZIMtF+KfCsQpz0+stGRK8VBacfbxhSZyCH+fbyLtlczk28mv9/a2D6N+vwQRJE7X+XC9iKZhBBKMTE/o56H3gAdzxSLaeLtLIcSQhwIOpIKJqSB+e0NdNqrBE2oRKA41X1jUtrOJU9dccar4S3AJbQ2+8GXM4qTqjbNM9L4kbdPBCnWhIjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=780CyHHRhVckiPXJb45VGjzPkDA6ekdv9KzzU9BWVfM=;
 b=LZ5/LkbNmP5JcIzE2uSDhHOfUNJtvkSMNY44KDcarVsjNlzaE0dUxrb8Er4YtGk0CmSTky0F66IgujyZlEHEW4zs+2KblX/4E4scvkXcnPa8bqiX1CndaahdyCpv24h/2pn6NFtPbMUg1NqRjg3wfREut5jxR2xTH5BQWjkMr5J/FvwR1qRSwAqf0AqTm6N3ImCCMLa9mJDw0DJNHb0V3+BELg82RMSJU/ZgxuIn5z05PmEjNsEUlJELEO5gtIpu51QLeEOa9X+Opo0fS2X4w+R05AHXTKiqV8eOBaeLQAACSGVZ9vD/HY7Th0H9NR8nQVXRnyh/9U0EluPFjLWIfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=780CyHHRhVckiPXJb45VGjzPkDA6ekdv9KzzU9BWVfM=;
 b=f9BiNtNrmBecueW03eifhyrNa8DZkcst4tqZEc+/gvUdcsvjvRbTIBCKH47zUrIKz19D//0n2ivDAo379ZxovpncKaSbia9evSeiuBlKUqsf0sltqjuAVgMmraNS0QjFb7cwYwml+BNfBui0uHgMw8btrurNgocmYVFpskipKqi7GEBioMk/gGjnvkQ7TgClNhtEAdGaSekJYof3nxhrtAwtLV+HVw54VYW6zUyIj5v/hrZ41pBNd0dKxGa3KkHhPRCrnjEp9Q4o+D3Vq3zlov5Ar+GX2Uyojyx/oIurBrKt8MOWXGRgOWLAqP/PQv0Ewmz8XEfRecM+8IkY0z4krA==
Received: from MN2PR11CA0006.namprd11.prod.outlook.com (2603:10b6:208:23b::11)
 by DM4PR12MB7504.namprd12.prod.outlook.com (2603:10b6:8:110::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Wed, 10 May
 2023 03:34:37 +0000
Received: from BL02EPF000145BB.namprd05.prod.outlook.com
 (2603:10b6:208:23b:cafe::d4) by MN2PR11CA0006.outlook.office365.com
 (2603:10b6:208:23b::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18 via Frontend
 Transport; Wed, 10 May 2023 03:34:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF000145BB.mail.protection.outlook.com (10.167.241.211) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.20 via Frontend Transport; Wed, 10 May 2023 03:34:37 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 9 May 2023
 20:34:24 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 9 May 2023
 20:34:24 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Tue, 9 May 2023 20:34:23 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <robin.murphy@arm.com>, <will@kernel.org>
CC:     <eric.auger@redhat.com>, <kevin.tian@intel.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <shameerali.kolothum.thodi@huawei.com>, <jean-philippe@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>, <yi.l.liu@intel.com>
Subject: [PATCH v2 13/17] iommu/arm-smmu-v3: Add arm_smmu_domain_alloc_user
Date:   Tue, 9 May 2023 20:33:33 -0700
Message-ID: <7d8caa89c156b6915d3da5307b9ec3b8f218359e.1683688960.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1683688960.git.nicolinc@nvidia.com>
References: <cover.1683688960.git.nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000145BB:EE_|DM4PR12MB7504:EE_
X-MS-Office365-Filtering-Correlation-Id: 14c95795-96fb-4ac2-be87-08db51077b27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /vNfD551WEGAgNBjRf3ExSCsLdaTxJmRaHkJfSYOCJjPOdPpen4BKvbnaNw1OaAvHq8Yj/JoR5jm7Rjr3mnjezozm7bDlTHHTMYKsHaVSrXezteou4kA+Q/iKE/3GQDtcWU1FGGs9SLND9v9OthMEMgcg9HkUu7pVWc1LSWTAfaBWkYfYYAiTOOJs5odB1hTpePzGReKzxCOxe2NLo2Ugc8oFb39IKOGweFZUQSnAQsrnYFLgYpXr3++T1vcbxkmndoBJHpGloPCZMD1+knhAf3vyo6Lg8WFBWHumAV9z+j9h7ERsX4mVNxavqRXpVhX27kQOW698RLFwgBbfJ3pwPG9JRS0K77DDLxR/v9COuLEG2oSLnY0cJMOLYnwBaQ7SvGf5hFbPgvr7NMUeY33HUrYQiwBPAhualXJDJkoiIe9613cQ8oYUKHyuxSMgCziq78wSD1pbCGfMsLZ+S/WmQBH6EivIVefcw9wqEZ/PqmIEAECfWjyHFVLvHgFWTx/SR6+nsfifiuLM+fx+Tl825kKbPVeG5bR8D8Pa4ppcApVCokPdCH2anXhzj/ypSrqdq+ufAnRAf0AoaS08fKNaRqUIwRfIXQmn4bfDZ1OR1VcEBz12v218gD/eCF24jn8yOislmYaL2GalxJiNkQYmyUM9a7NanX0idhn2lrkoHluYqaf9TW8lVlzuYbfXEX0deWDZ0xDFquFMSF+JOKaTQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(136003)(396003)(451199021)(46966006)(40470700004)(36840700001)(86362001)(36756003)(6666004)(316002)(54906003)(70586007)(478600001)(4326008)(7696005)(70206006)(110136005)(40480700001)(82310400005)(5660300002)(8936002)(8676002)(47076005)(7416002)(356005)(41300700001)(2906002)(82740400003)(7636003)(186003)(36860700001)(26005)(336012)(83380400001)(426003)(2616005)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 03:34:37.4005
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14c95795-96fb-4ac2-be87-08db51077b27
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000145BB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7504
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The arm_smmu_domain_alloc_user callback function is used for userspace to
allocate iommu_domains, such as standalone stage-1 domain, nested stage-1
domain, and nested stage-2 domain. The input user_data is in the type of
struct iommu_hwpt_arm_smmuv3 that contains the configurations of a nested
stage-1 or a nested stage-2 iommu_domain. A NULL user_data will just opt
in a standalone stage-1 domain allocation.

Add a constitutive function __arm_smmu_domain_alloc to support that.

Since ops->domain_alloc_user has a valid dev pointer, the master pointer
is available when calling __arm_smmu_domain_alloc() in this case, meaning
that arm_smmu_domain_finalise() can be done at the allocation stage. This
allows IOMMUFD to initialize the hw_pagetable for the domain.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 117 +++++++++++++++-----
 1 file changed, 87 insertions(+), 30 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index b8c189b732ba..75ee928c2390 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2051,36 +2051,6 @@ static void *arm_smmu_hw_info(struct device *dev, u32 *length)
 	return info;
 }
 
-static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
-{
-	struct arm_smmu_domain *smmu_domain;
-
-	if (type == IOMMU_DOMAIN_SVA)
-		return arm_smmu_sva_domain_alloc();
-
-	if (type != IOMMU_DOMAIN_UNMANAGED &&
-	    type != IOMMU_DOMAIN_DMA &&
-	    type != IOMMU_DOMAIN_DMA_FQ &&
-	    type != IOMMU_DOMAIN_IDENTITY)
-		return NULL;
-
-	/*
-	 * Allocate the domain and initialise some of its data structures.
-	 * We can't really do anything meaningful until we've added a
-	 * master.
-	 */
-	smmu_domain = kzalloc(sizeof(*smmu_domain), GFP_KERNEL);
-	if (!smmu_domain)
-		return NULL;
-
-	mutex_init(&smmu_domain->init_mutex);
-	INIT_LIST_HEAD(&smmu_domain->devices);
-	spin_lock_init(&smmu_domain->devices_lock);
-	INIT_LIST_HEAD(&smmu_domain->mmu_notifiers);
-
-	return &smmu_domain->domain;
-}
-
 static int arm_smmu_bitmap_alloc(unsigned long *map, int span)
 {
 	int idx, size = 1 << span;
@@ -2928,10 +2898,97 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 	arm_smmu_sva_remove_dev_pasid(domain, dev, pasid);
 }
 
+/**
+ * __arm_smmu_domain_alloc - Allocate a customizable iommu_domain
+ * @type: Type of the new iommu_domain, in form of IOMMU_DOMAIN_*
+ * @master: Optional master pointer for the allocation. If given, this will be
+ *          used to call arm_smmu_domain_finalise at the end of the allocation.
+ *          Otherwise, arm_smmu_domain_finalise will be done when the domain is
+ *          attached to a device.
+ * @user_cfg: Optional user configuration for the allocation. This allows the
+ *            caller, mainly user space, to customize the iommu_domain in the
+ *            arm_smmu_domain_finalise function that decodes the user_cfg data.
+ *
+ * This helper function is shared by domain_alloc_user() and domain_alloc().
+ * Unlike ops->domain_alloc has been so far only called by the iommu core that
+ * sets default values of domain->type, domain->ops and domain->pgsize_bitmap,
+ * the ops->domain_alloc_user could be directly called by the iommufd core. So,
+ * this function should set those default values for an ops->domain_alloc_user
+ * call. Note that domain->pgsize_bitmap is set in arm_smmu_domain_finalise().
+ */
+static struct iommu_domain *
+__arm_smmu_domain_alloc(unsigned type,
+			struct arm_smmu_master *master,
+			const struct iommu_hwpt_arm_smmuv3 *user_cfg)
+{
+	struct arm_smmu_domain *smmu_domain;
+	struct iommu_domain *domain;
+	int ret = 0;
+
+	if (type == IOMMU_DOMAIN_SVA)
+		return arm_smmu_sva_domain_alloc();
+
+	if (type != IOMMU_DOMAIN_UNMANAGED &&
+	    type != IOMMU_DOMAIN_DMA &&
+	    type != IOMMU_DOMAIN_DMA_FQ &&
+	    type != IOMMU_DOMAIN_IDENTITY)
+		return NULL;
+
+	/*
+	 * Allocate the domain and initialise some of its data structures.
+	 * We can't really finalise the domain unless a master is given.
+	 */
+	smmu_domain = kzalloc(sizeof(*smmu_domain), GFP_KERNEL);
+	if (!smmu_domain)
+		return NULL;
+	domain = &smmu_domain->domain;
+
+	domain->type = type;
+	domain->ops = arm_smmu_ops.default_domain_ops;
+
+	mutex_init(&smmu_domain->init_mutex);
+	INIT_LIST_HEAD(&smmu_domain->devices);
+	spin_lock_init(&smmu_domain->devices_lock);
+	INIT_LIST_HEAD(&smmu_domain->mmu_notifiers);
+
+	if (master) {
+		smmu_domain->smmu = master->smmu;
+		ret = arm_smmu_domain_finalise(domain, master, user_cfg);
+		if (ret) {
+			kfree(smmu_domain);
+			return NULL;
+		}
+	}
+
+	return domain;
+}
+
+static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
+{
+	return __arm_smmu_domain_alloc(type, NULL, NULL);
+}
+
+static struct iommu_domain *
+arm_smmu_domain_alloc_user(struct device *dev, struct iommu_domain *parent,
+			   const void *user_data)
+{
+	const struct iommu_hwpt_arm_smmuv3 *user_cfg = user_data;
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	unsigned type = IOMMU_DOMAIN_UNMANAGED;
+
+	return __arm_smmu_domain_alloc(type, master, user_cfg);
+}
+
+static const size_t arm_smmu_domain_user_data_len[] = {
+	[IOMMU_HWPT_TYPE_ARM_SMMUV3] = sizeof(struct iommu_hwpt_arm_smmuv3),
+};
+
 static struct iommu_ops arm_smmu_ops = {
 	.capable		= arm_smmu_capable,
 	.hw_info		= arm_smmu_hw_info,
 	.domain_alloc		= arm_smmu_domain_alloc,
+	.domain_alloc_user	= arm_smmu_domain_alloc_user,
+	.domain_alloc_user_data_len = arm_smmu_domain_user_data_len,
 	.probe_device		= arm_smmu_probe_device,
 	.release_device		= arm_smmu_release_device,
 	.set_dev_user_data	= arm_smmu_set_dev_user_data,
-- 
2.40.1

