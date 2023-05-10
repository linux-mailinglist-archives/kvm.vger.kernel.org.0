Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08706FD46F
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 05:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235759AbjEJDgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 23:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235312AbjEJDfE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 23:35:04 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5630F268E;
        Tue,  9 May 2023 20:34:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CA7yT+6yF6DkdyYoOyaLuNN2vva4TjFcKUjLITHTpdGj5xX0NLzlJ7Xx//ihvumy2kg6vzm1hpHz4UeK8pq/F3ABHa/yWvqRCxsdppyzdw1kB4f1b7/di+vkgfDUMcR/qaIInx77mHlQTdn7H/rAKe17b2YEbgoG7hVpnzKCI7QijZV9usIDIR4vWS3dK8gcovFo2yc14YHmRaSlGQgeZEv6kNoxKpXSbiSjU61fe4h0sFvWMSKCRPS8+nm6mkxZp5GIphHLuusAViNYHwwjUZIEaWMIPw3luG8dmXwv0EH8I3KkDd+kQ/a0ztrB8fYKJsIntsZZTmRRbZldWKbuRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wkozRIdnZ+SDWZ7LNbdDRxamnFQ7ndzENLR3RmzKDHM=;
 b=UaeDbL6Ip7tzk7KQFzUvBWmkfH+1qtyY7rHLJpa6CEXN6C+6JbeJCkzu2ySqDV0uXCjCuRl1LG5WdsKqGkodKrDl4QZRM938k3zl/Q/kevgF10xVAEid6bkFwCzkSXD2mngWwX9VEbAKeOQuR/ISZYzU8TAd/Bj6TcT0ISZvVwQpb6dMEEoSxh8zzDF48budRzGZ97ks1lLcA+WQ+4Z+0BDb9m7BWUJWeYSFvizo8fxd7omFQ40nJ5gYqns8rRfSqMNrl0DieB0E4EhcHfU+CoeEmrBQuecmzgsFBloFY2p2heLSqMjuFuUd/oB2kS5U/tF0e/MVisJU97n/H+5AXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wkozRIdnZ+SDWZ7LNbdDRxamnFQ7ndzENLR3RmzKDHM=;
 b=EpxKatNRt3Ffco8fD3OcXSX8xHUbVnhKLjeJZZrUphaYQYJ92pP48mOYXBlqwRRTq57ZPvo/2uPRjoBmSOMFVG9dpFSyxOE+aSgGOt7x7Qk11qJC7O1L3kYFBNy6KgRuM/qGqlHWq0+5leCDla6b/g7ctm0WvgKw002dDKRCJbVcgX09Hwch+4tShQLV5HG0isIboRgRS8kH3QgBDEfsdlgrrKrgkJxjON//0brER8P+oUlvfKlb8njiqwofpSgLb20g8oFWNW9u2c8sKRIRFR57/0FSc+NdR4m3E+1P4CuB1d81TbuUNbsmVmDBknYuQTC1+a6GmmkQVorUQTcxBw==
Received: from MN2PR11CA0027.namprd11.prod.outlook.com (2603:10b6:208:23b::32)
 by DM4PR12MB7525.namprd12.prod.outlook.com (2603:10b6:8:113::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Wed, 10 May
 2023 03:34:39 +0000
Received: from BL02EPF000145BB.namprd05.prod.outlook.com
 (2603:10b6:208:23b:cafe::8a) by MN2PR11CA0027.outlook.office365.com
 (2603:10b6:208:23b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33 via Frontend
 Transport; Wed, 10 May 2023 03:34:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF000145BB.mail.protection.outlook.com (10.167.241.211) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.20 via Frontend Transport; Wed, 10 May 2023 03:34:39 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 9 May 2023
 20:34:25 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 9 May 2023
 20:34:25 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Tue, 9 May 2023 20:34:24 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <robin.murphy@arm.com>, <will@kernel.org>
CC:     <eric.auger@redhat.com>, <kevin.tian@intel.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <shameerali.kolothum.thodi@huawei.com>, <jean-philippe@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>, <yi.l.liu@intel.com>
Subject: [PATCH v2 14/17] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED type of allocations
Date:   Tue, 9 May 2023 20:33:34 -0700
Message-ID: <75b2fb9e4473cfacbd762f451f8a3c35189a171b.1683688960.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1683688960.git.nicolinc@nvidia.com>
References: <cover.1683688960.git.nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000145BB:EE_|DM4PR12MB7525:EE_
X-MS-Office365-Filtering-Correlation-Id: 11b42380-0ce2-4681-d91b-08db51077c45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rhLC/ih8q615fmnw3v/jAFHXsljIDUv9FEa6vbAKr12fHu6kBhAcB9DbaqHex85iSWkDiHfCXM91p2xTh+3IDjpDoKOLGLJN6Th0jAMtiTtL8Opayc+7u603S0Zt0i688vfMaIKQ6UAB8jzNfA57J2S+9TNFJG+gE0G6zHdAdn/yi1vXARqRmEWRE4/U8y0ZWBdG0P+xOx6mPqVJxjc2emd8Eiwp6iDDkfUupS3kEBTac/5L4Nl5A5zH4rSPSd+VZTa3chD7q1U7Ozl2u6cyOV9jldZISrwG1PyM5Z1+VfSFYBQKCZSvrzsTUMS5NRusSdrbIPZ8QmjicpOlXawCzSRFIRces+qTR64/iiK7xNwB9/2/YJdx4+8hf36iLhoENlaWISnlzpZPfla62DoEO++mDaoIxoiG9oEEy2JuCKuDnDeYwCFrY8F3AvwgzyUnfLxQVxIwC42i0bDOtA3GIG5pJw5LLUmpyVC7DMfifx2QuQnr3pZl7ZqcwYiHx16pMmZ7IWZAxAiRZpvyie12pUDaICS6qhBvxGGnmwmkFj8Djt9qJETcRgObokASZRS/LtEucjQXiWAdjhz77t8GoC7XknhbO2DfmCPwtrz0ZyT29X8rXyFGt6SUvW6VDFUtc8mdZD/pA1IGi7d6l8PyFGwfeBkFT62JopiRhwEKtkt0lqxRDvDjM8dPFRSBK4qOGfyAtWGIrnDjDfrts8wCqpXl/0/vgFS/p1L05RJI+jIja/0jwTnaP+lLx9XhzjBazAjLqv0PMMojRcjz6qgumMhElTlLPRDvnawss6HCtcQ=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(346002)(396003)(376002)(451199021)(36840700001)(46966006)(40470700004)(54906003)(83380400001)(47076005)(70586007)(7636003)(7696005)(356005)(316002)(36756003)(5660300002)(186003)(70206006)(4326008)(82740400003)(2906002)(41300700001)(6666004)(426003)(36860700001)(336012)(86362001)(110136005)(26005)(82310400005)(40460700003)(2616005)(8936002)(8676002)(40480700001)(7416002)(478600001)(414714003)(473944003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 03:34:39.2599
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11b42380-0ce2-4681-d91b-08db51077c45
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000145BB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7525
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

Add domain allocation support for IOMMU_DOMAIN_NESTED type. This includes
the "finalise" part to log in the user space Stream Table Entry info.

Co-developed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 112 +++++++++++++++++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |   1 +
 2 files changed, 110 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 75ee928c2390..3d150924581f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2181,6 +2181,76 @@ static int arm_smmu_domain_finalise_s2(struct arm_smmu_domain *smmu_domain,
 	return 0;
 }
 
+static int
+arm_smmu_domain_finalise_nested(struct iommu_domain *domain,
+				struct arm_smmu_master *master,
+				const struct iommu_hwpt_arm_smmuv3 *user_cfg)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_device *smmu = smmu_domain->smmu;
+	bool feat_2lvl_cdtab = smmu->features & ARM_SMMU_FEAT_2_LVL_CDTAB;
+	bool feat_s1 = smmu->features & ARM_SMMU_FEAT_TRANS_S1;
+	bool feat_s2 = smmu->features & ARM_SMMU_FEAT_TRANS_S2;
+	size_t event_len = EVTQ_ENT_DWORDS * sizeof(u64);
+	size_t ste_len = STRTAB_STE_DWORDS * sizeof(u64);
+	struct device *dev = master->dev;
+	void __user *event_user = NULL;
+	u64 event[EVTQ_ENT_DWORDS];
+	u64 ste[STRTAB_STE_DWORDS];
+	u8 s1dss, s1fmt, s1cdmax;
+	u64 s1ctxptr;
+
+	if (user_cfg->out_event_uptr && user_cfg->event_len == event_len)
+		event_user = u64_to_user_ptr(user_cfg->out_event_uptr);
+	event[0] = FIELD_PREP(EVTQ_0_ID, EVT_ID_BAD_STE);
+
+	if (!feat_s1 || !feat_s2) {
+		dev_dbg(dev, "does not implement two stages\n");
+		if (event_user && copy_to_user(event_user, event, event_len))
+			return -EFAULT;
+		return -EINVAL;
+	}
+
+	if (!user_cfg->ste_uptr || user_cfg->ste_len != ste_len)
+		return -EINVAL;
+	if (copy_from_user(ste, u64_to_user_ptr(user_cfg->ste_uptr), ste_len))
+		return -EFAULT;
+
+	s1dss = FIELD_GET(STRTAB_STE_1_S1DSS, ste[1]);
+
+	s1fmt = FIELD_GET(STRTAB_STE_0_S1FMT, ste[0]);
+	if (!feat_2lvl_cdtab && s1fmt != STRTAB_STE_0_S1FMT_LINEAR) {
+		dev_dbg(dev, "unsupported format (0x%x)\n", s1fmt);
+		if (event_user && copy_to_user(event_user, event, event_len))
+			return -EFAULT;
+		return -EINVAL;
+	}
+
+	s1cdmax = FIELD_GET(STRTAB_STE_0_S1CDMAX, ste[0]);
+	if (s1cdmax > master->ssid_bits) {
+		dev_dbg(dev, "s1cdmax (%d-bit) is out of range (%d-bit)\n",
+			s1cdmax, master->ssid_bits);
+		if (event_user && copy_to_user(event_user, event, event_len))
+			return -EFAULT;
+		return -EINVAL;
+	}
+
+	s1ctxptr = ste[0] & STRTAB_STE_0_S1CTXPTR_MASK;
+	if (s1ctxptr & ~GENMASK_ULL(smmu->ias, 0)) {
+		dev_dbg(dev, "s1ctxptr (0x%llx) is out of range (%lu-bit)\n",
+			s1ctxptr, smmu->ias);
+		if (event_user && copy_to_user(event_user, event, event_len))
+			return -EFAULT;
+		return -EINVAL;
+	}
+
+	smmu_domain->s1_cfg.s1dss = s1dss;
+	smmu_domain->s1_cfg.s1fmt = s1fmt;
+	smmu_domain->s1_cfg.s1cdmax = s1cdmax;
+	smmu_domain->s1_cfg.cdcfg.cdtab_dma = s1ctxptr;
+	return 0;
+}
+
 static int arm_smmu_domain_finalise(struct iommu_domain *domain,
 				    struct arm_smmu_master *master,
 				    const struct iommu_hwpt_arm_smmuv3 *user_cfg)
@@ -2202,6 +2272,11 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain,
 		return 0;
 	}
 
+	if (domain->type == IOMMU_DOMAIN_NESTED) {
+		smmu_domain->stage = ARM_SMMU_DOMAIN_S1;
+		return arm_smmu_domain_finalise_nested(domain, master, user_cfg);
+	}
+
 	if (user_cfg_s2 && !(smmu->features & ARM_SMMU_FEAT_TRANS_S2))
 		return -EINVAL;
 	if (user_cfg_s2)
@@ -2898,9 +2973,16 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 	arm_smmu_sva_remove_dev_pasid(domain, dev, pasid);
 }
 
+static const struct iommu_domain_ops arm_smmu_nested_domain_ops = {
+	.attach_dev		= arm_smmu_attach_dev,
+	.free			= arm_smmu_domain_free,
+};
+
 /**
  * __arm_smmu_domain_alloc - Allocate a customizable iommu_domain
  * @type: Type of the new iommu_domain, in form of IOMMU_DOMAIN_*
+ * @s2: Optional pointer to an stage-2 domain, used by an stage-1 nested domain
+ *      allocation, pairing with a valid user_cfg data to configure the domain.
  * @master: Optional master pointer for the allocation. If given, this will be
  *          used to call arm_smmu_domain_finalise at the end of the allocation.
  *          Otherwise, arm_smmu_domain_finalise will be done when the domain is
@@ -2918,6 +3000,7 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
  */
 static struct iommu_domain *
 __arm_smmu_domain_alloc(unsigned type,
+			struct arm_smmu_domain *s2,
 			struct arm_smmu_master *master,
 			const struct iommu_hwpt_arm_smmuv3 *user_cfg)
 {
@@ -2929,11 +3012,15 @@ __arm_smmu_domain_alloc(unsigned type,
 		return arm_smmu_sva_domain_alloc();
 
 	if (type != IOMMU_DOMAIN_UNMANAGED &&
+	    type != IOMMU_DOMAIN_NESTED &&
 	    type != IOMMU_DOMAIN_DMA &&
 	    type != IOMMU_DOMAIN_DMA_FQ &&
 	    type != IOMMU_DOMAIN_IDENTITY)
 		return NULL;
 
+	if (s2 && (s2->stage != ARM_SMMU_DOMAIN_S2 || !user_cfg))
+		return NULL;
+
 	/*
 	 * Allocate the domain and initialise some of its data structures.
 	 * We can't really finalise the domain unless a master is given.
@@ -2941,10 +3028,14 @@ __arm_smmu_domain_alloc(unsigned type,
 	smmu_domain = kzalloc(sizeof(*smmu_domain), GFP_KERNEL);
 	if (!smmu_domain)
 		return NULL;
+	smmu_domain->s2 = s2;
 	domain = &smmu_domain->domain;
 
 	domain->type = type;
-	domain->ops = arm_smmu_ops.default_domain_ops;
+	if (s2)
+		domain->ops = &arm_smmu_nested_domain_ops;
+	else
+		domain->ops = arm_smmu_ops.default_domain_ops;
 
 	mutex_init(&smmu_domain->init_mutex);
 	INIT_LIST_HEAD(&smmu_domain->devices);
@@ -2965,7 +3056,7 @@ __arm_smmu_domain_alloc(unsigned type,
 
 static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
 {
-	return __arm_smmu_domain_alloc(type, NULL, NULL);
+	return __arm_smmu_domain_alloc(type, NULL, NULL, NULL);
 }
 
 static struct iommu_domain *
@@ -2975,8 +3066,23 @@ arm_smmu_domain_alloc_user(struct device *dev, struct iommu_domain *parent,
 	const struct iommu_hwpt_arm_smmuv3 *user_cfg = user_data;
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	unsigned type = IOMMU_DOMAIN_UNMANAGED;
+	struct arm_smmu_domain *s2 = NULL;
+
+	/*
+	 * The type of the new domain stays at IOMMU_DOMAIN_UNMANAGED, unless a
+	 * valid parent domain is given, turning it to be IOMMU_DOMAIN_NESTED.
+	 * The "stage" of an IOMMU_DOMAIN_UNMANAGED domain, however, is decided
+	 * in the arm_smmu_domain_finalise function that reads user_cfg->flags,
+	 * to set the stage accordingly.
+	 */
+	if (parent) {
+		if (parent->ops != arm_smmu_ops.default_domain_ops)
+			return NULL;
+		type = IOMMU_DOMAIN_NESTED;
+		s2 = to_smmu_domain(parent);
+	}
 
-	return __arm_smmu_domain_alloc(type, master, user_cfg);
+	return __arm_smmu_domain_alloc(type, s2, master, user_cfg);
 }
 
 static const size_t arm_smmu_domain_user_data_len[] = {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 6ed86883d52e..9540926b4598 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -380,6 +380,7 @@
 
 #define EVTQ_0_ID			GENMASK_ULL(7, 0)
 
+#define EVT_ID_BAD_STE			0x4
 #define EVT_ID_TRANSLATION_FAULT	0x10
 #define EVT_ID_ADDR_SIZE_FAULT		0x11
 #define EVT_ID_ACCESS_FAULT		0x12
-- 
2.40.1

