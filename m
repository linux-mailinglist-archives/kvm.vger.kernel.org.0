Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946FC6FD46A
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 05:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235134AbjEJDfx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 23:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235734AbjEJDe7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 23:34:59 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E27B30EB;
        Tue,  9 May 2023 20:34:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwjiB+Dex2a/2oO7z7AgmwPskpBEOs7VyNI48bDjNeKhRc1N0ARJdb7IBXMZk0FJ+N+gDWTTV1BIeDR8qxL1T7KlQXq8IYHaDh7fH9UfFtfyapTqJ5wa0K5R6wAYAGBiq8s6xa6WVyYWh05ONO3cyrcVEiS4v1vgd/hBSLXjtQUtzKvn91GI8+NROHCdiRfIv1e25d3L0wJb6A+56r5umYVRDfg3Bgl6zgyzpk1KGlpNcd05oZ1MrfhHSyXjkZ40GS2f4Jo4L2Yzf6ClT9EtK8VpGm97xuHzwF/Urzs6sZ5jyGbx7C3n48QwL/VUIP3DU8NiYHIQ/kHkZO57SW2D9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V0NElZ4X9QBwVbXtfVudA7k/g7fQ8jmLjhQm8mdt5gk=;
 b=KUOyeRAQHwGZTVurwMbCXiUfJEfpmpeq7AtM+67HarhvAOTf3f6E4pBszqo9gvNU5h9LyJVAzaShq93UPHV8b34PoBfoRhyISKq40IcXeTqCO6oMG3OHwG95h3SVz3OvAfFf15Zs5vElmwRRDaBQvxnx+MjymFksI38V9qRLmgav+5efMhvaalhXiMRcaDBaieZoEOfjX9L1EVwV8pQbYMDvndcc6RlDJpE7QlTzdb6i1eqpahi+gjCIiqVUdSW+f2TJOWyicq7KzQ7IKvWskM4ZS4rA7LToyXw9ZjwPrf1Uk8whLTmw/y/Zz0xmY/LQvKJAw9z0MkY1/UX94EcRwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V0NElZ4X9QBwVbXtfVudA7k/g7fQ8jmLjhQm8mdt5gk=;
 b=mN/UqVsVZnmdh1ZudAeP5mHfWJs0chumqHN9Z5jHajGn0bEIBzmqaymCPJFELrVXrUGRzqmSg2CKEhiC4d2rxzBJRESmLSW+qKMuO+jh9otUOlS/rYe2eOgVHTqktyxg9KzwdE6ELR5xIryZ0Jb72dWKX4eIz7DBfdu6PZ2O1yqilXsGJrsGOOVsgygAViJsHvdOdIQjhkWYAGvEyOI+3H2AjZGqNIaOz8IgBnbmOa/h/GvUtpZDV6t7AghqPA30VQKXjPGJbllzmxFXnKWPxRkhLB8/yptuTFdcK7OvtOHSEh4I1tqvKPW/apM5grplCbOhfTaYhEikUdxCWPu+Fw==
Received: from BN9P220CA0018.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::23)
 by CY8PR12MB7633.namprd12.prod.outlook.com (2603:10b6:930:9c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 03:34:36 +0000
Received: from BL02EPF000145B8.namprd05.prod.outlook.com
 (2603:10b6:408:13e:cafe::94) by BN9P220CA0018.outlook.office365.com
 (2603:10b6:408:13e::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33 via Frontend
 Transport; Wed, 10 May 2023 03:34:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF000145B8.mail.protection.outlook.com (10.167.241.208) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.19 via Frontend Transport; Wed, 10 May 2023 03:34:36 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 9 May 2023
 20:34:23 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 9 May 2023
 20:34:23 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Tue, 9 May 2023 20:34:22 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <robin.murphy@arm.com>, <will@kernel.org>
CC:     <eric.auger@redhat.com>, <kevin.tian@intel.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <shameerali.kolothum.thodi@huawei.com>, <jean-philippe@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>, <yi.l.liu@intel.com>
Subject: [PATCH v2 12/17] iommu/arm-smmu-v3: Pass in user_cfg to arm_smmu_domain_finalise
Date:   Tue, 9 May 2023 20:33:32 -0700
Message-ID: <931282642f7b2a6a73cdbdcecd428bdeb1ecad27.1683688960.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1683688960.git.nicolinc@nvidia.com>
References: <cover.1683688960.git.nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000145B8:EE_|CY8PR12MB7633:EE_
X-MS-Office365-Filtering-Correlation-Id: e3eaa902-9adb-4c20-eb73-08db51077a6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EkEKUI0WHX+cT1/+hH2mZ/O9ReNzF/kjIHpIu9T+Vx/+UAOnJ8ty4e52ZcqVcy20jvI4KI4Qa3TT6V1noWiD497NjlZed+ep0x7y0STZqHnnBQLmZtaXZry+D+wiCNA+h+cdDEhSyD3e+dkax8hVb8gTczjI3Ph+Bw3WzUVk9H7kbO3EdOWbonV+eN8fGPmQH7MgKpfd54ssiF6cUHROeijFuR3x/YgKoHjQbIVOPpppVq0iUm+WJqF/SNt+KWMe0YZHh1uXbwPK0IeffqryonLucw8bxqgOk4auutnNGHLkAQsbu5xhih8ayRuKM95mlnl+otGCm+8WCLN+XyJG/HfVvCr3R2+H8LvXJfGw1IH0QjCSVMaNOzSr/DeSB0nCZWSuA2eIDbQaaElfU/hZI5A8e3WClCycD4oFpWxaDaMcbke3bp8b/s+HSS9doAG+dJ5X9SwcwwZP4/6Ts76t9Ks2vqPutPhnaHnA0ZpwdpKcY6RfGQIK6RjSEP18pqLY2virC8mNvnCOGZ/MUv6LhEIHx/uHkLiknuDDoxGKnsYBLVqAVXm3Vwy9C9vaWP0xzg32SUT14e584FAQfSiT/BWcVldNpPWcH/tYqtPif+FfJbjiIiRefQEhcq6yHhGEJGsTHYgngyp2cRNuOhroviSrNSeB8IRyzx0tPXyaEtDB67Mc2yRX2B+vW8ZsUviU21m0tvEyImUW1mdxkOs4VA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(376002)(136003)(346002)(451199021)(46966006)(40470700004)(36840700001)(110136005)(4326008)(70206006)(82740400003)(356005)(70586007)(316002)(7636003)(40480700001)(8676002)(336012)(8936002)(426003)(82310400005)(47076005)(54906003)(83380400001)(26005)(86362001)(41300700001)(5660300002)(36860700001)(186003)(7416002)(478600001)(36756003)(2616005)(2906002)(40460700003)(7696005)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 03:34:36.1474
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e3eaa902-9adb-4c20-eb73-08db51077a6a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000145B8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7633
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

The struct iommu_hwpt_arm_smmuv3 contains the userspace Stream Table Entry
info (for ARM_SMMU_DOMAIN_S1) and an "S2" flag (for ARM_SMMU_DOMAIN_S2).

Pass in a valid user_cfg pointer, so arm_smmu_domain_finalise() can handle
both types of user domain finalizations.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 8b827247f4b9..b8c189b732ba 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -26,6 +26,7 @@
 #include <linux/pci.h>
 #include <linux/pci-ats.h>
 #include <linux/platform_device.h>
+#include <uapi/linux/iommufd.h>
 
 #include "arm-smmu-v3.h"
 #include "../../dma-iommu.h"
@@ -2211,7 +2212,8 @@ static int arm_smmu_domain_finalise_s2(struct arm_smmu_domain *smmu_domain,
 }
 
 static int arm_smmu_domain_finalise(struct iommu_domain *domain,
-				    struct arm_smmu_master *master)
+				    struct arm_smmu_master *master,
+				    const struct iommu_hwpt_arm_smmuv3 *user_cfg)
 {
 	int ret;
 	unsigned long ias, oas;
@@ -2223,12 +2225,18 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain,
 				 struct io_pgtable_cfg *);
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
+	bool user_cfg_s2 = user_cfg && (user_cfg->flags & IOMMU_SMMUV3_FLAG_S2);
 
 	if (domain->type == IOMMU_DOMAIN_IDENTITY) {
 		smmu_domain->stage = ARM_SMMU_DOMAIN_BYPASS;
 		return 0;
 	}
 
+	if (user_cfg_s2 && !(smmu->features & ARM_SMMU_FEAT_TRANS_S2))
+		return -EINVAL;
+	if (user_cfg_s2)
+		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
+
 	/* Restrict the stage to what we can actually support */
 	if (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1))
 		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
@@ -2472,7 +2480,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 
 	if (!smmu_domain->smmu) {
 		smmu_domain->smmu = smmu;
-		ret = arm_smmu_domain_finalise(domain, master);
+		ret = arm_smmu_domain_finalise(domain, master, NULL);
 		if (ret) {
 			smmu_domain->smmu = NULL;
 			goto out_unlock;
-- 
2.40.1

