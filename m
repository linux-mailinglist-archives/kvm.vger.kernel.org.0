Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA6D739347
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 01:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjFUXzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 19:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjFUXzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 19:55:49 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2068.outbound.protection.outlook.com [40.107.100.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F081733;
        Wed, 21 Jun 2023 16:55:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gD5xo5lP4pzi8P8HgxGczL+hJqEARH8kr6ViXtBGH3cdW/l7g2XpnYssKekGXohs1zq3wTDNMUdpZzSzcFNSOp1Ssf//EWundUAmv5xAU8wxoA4s/rT88KRjsldSVq2hxR4gTiJrZ1QnRg5I3yPHiUgHsw3gN08brqdEIit1unX+tKcUMvGH0km1M3UOc3vJbvvZyIL6/02QbvUfSu53gHSzslhSG/TpyJIJAlux41ApsXufc2jno+QkXjq9wTC4uDD4R0NWK//dfU75ErNrx8MM22IUMq2Fdp27XIH75b7rZ1E0ggfVteNyrNVI8BUg79DqYGUTS16TKiY0AQLpBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g1LmUXY7El6wGAuzWxVdc/JfOGIzhDxjgvsNezhtaD0=;
 b=Fgxl5K9JK2ngGKQRNTOim4zoQ6CjEtBHYPlu3Q1ckGQ8p33mkRAeKYKxanX8hin+v3uJfpl1PXVj1MGl+eQaOIdMS4oHk9I5ojmbNen+yauodJFh2BOnIiP0J56sFwRPN/g2X3hJlZSJlOsiQ1C2rf4zsqdNQGC3Gb0fJmXWYHAZkcIA9bwg5SUPPN/Epx3Q7YNYZwBUgOqycfSg9OlvmOSgYRkKUGVHjE/0dhAPMvfy2GLYf1FKI1X8Jv3YPBPPvPVGJXm+Mbb2Phlco3OvIqrpTv0i2d2DYDTqWigRvaOZ9QmtzQprbxbib/1/HfSFBTjr5MIVynOrx0+X/Toceg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g1LmUXY7El6wGAuzWxVdc/JfOGIzhDxjgvsNezhtaD0=;
 b=f07mcITxw7C8TqkyWC01UekO5jGDFjIfzrozOlAuTay4Aj9Nswv9MqwufS7pqzuGbAmIFzb7XuHj8ddUAjxQxzg/7s+V0cbJ+CygYKvF3bV/GFWPQsIwBKDS/XVEzEt2YWVbqGIVZLOiEE852AGg6q4+FoL7pJYt4z77j9xTt6w=
Received: from CYZPR10CA0017.namprd10.prod.outlook.com (2603:10b6:930:8a::17)
 by IA1PR12MB6068.namprd12.prod.outlook.com (2603:10b6:208:3ec::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Wed, 21 Jun
 2023 23:55:46 +0000
Received: from CY4PEPF0000E9CD.namprd03.prod.outlook.com
 (2603:10b6:930:8a:cafe::f6) by CYZPR10CA0017.outlook.office365.com
 (2603:10b6:930:8a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23 via Frontend
 Transport; Wed, 21 Jun 2023 23:55:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9CD.mail.protection.outlook.com (10.167.241.140) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6521.24 via Frontend Transport; Wed, 21 Jun 2023 23:55:46 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 21 Jun
 2023 18:55:44 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <iommu@lists.linux.dev>,
        <kvm@vger.kernel.org>
CC:     <joro@8bytes.org>, <robin.murphy@arm.com>, <yi.l.liu@intel.com>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <nicolinc@nvidia.com>, <baolu.lu@linux.intel.com>,
        <eric.auger@redhat.com>, <pandoh@google.com>,
        <kumaranand@google.com>, <jon.grimm@amd.com>,
        <santosh.shukla@amd.com>, <vasant.hegde@amd.com>,
        <jay.chen@amd.com>, <joseph.chung@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>
Subject: [RFC PATCH 03/21] iommu/amd: Update PASID, GATS, and GLX feature related macros
Date:   Wed, 21 Jun 2023 18:54:50 -0500
Message-ID: <20230621235508.113949-4-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230621235508.113949-1-suravee.suthikulpanit@amd.com>
References: <20230621235508.113949-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9CD:EE_|IA1PR12MB6068:EE_
X-MS-Office365-Filtering-Correlation-Id: a91cc3b1-4731-47c8-1a86-08db72b307f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jx94nxk4DBUl/0lyI+oCtVNJyz2vmCp2bWQHqjq6UEP0NN00Lj9pLp6nTZptHzn8ceAbBAUZ226wk4+ADmkJXVHZytinZRvenPJC+EK7rRvnQ0SUYfqTCLxro/XLWya4FFNywzIqMU9DnrjliORLjwTJlOGDJkVVbYjEY//C5qkCxN4mbFnAbZTfZZ/g/Ur/Z+slbd0TVlCrbECTzVokZr7nTWHfNNqxsCNx37AaIYIABzGBZEQQdQx8/Tr349sseE0Wum3QP8H355eMksbYzFWwRTgJx6P0YA4iPI48jtSq0CZ0WwYhpYdh4nPKiN+G6vN2uIveEz5Taqsx342+mqKHF4cT/VTGVjwRQKX7N3MvG0R+3O0UywmURXVLOg2KkDZe1GKQz4A6pIMImAbVMSVYABa5Bs44t1jPDBPOEQaQICItY8OAZcWA00MRH0DJuMvxaDPyKZAaC/G2qY8N73asaR1Zjus2rJVeZbI8T9+P6FGTqqm4omE9sotUHPgnM87K942ExnPbjTTyKB4XmNzEvMw63dUwmSkmdGcI+27TNxY30aVbIXz+24qRwgs4EBuvnh75tr6Ocq12OVM51md6KBg/TzdXu1vTzVcA+6tkMXlEyFEkHG67DL97HgjPbUuPjIumzdRWSoj5lY8WLQG6RZpCEV7iUfld0UMd0nLmE0qhpkUBd75J3/GOMuY08rF9ZyBvK0IDKBbqlXuuF1r/Hu3y8ZcshdkKr27vYyedr/ZoXd1rD2Cqo4K4wRuq/8RtFRRVB0WtAGfk/L7QWg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(136003)(39860400002)(451199021)(46966006)(36840700001)(40470700004)(40460700003)(70206006)(36860700001)(2906002)(83380400001)(7416002)(8676002)(47076005)(478600001)(54906003)(16526019)(8936002)(5660300002)(7696005)(70586007)(316002)(186003)(4326008)(44832011)(41300700001)(26005)(1076003)(6666004)(2616005)(426003)(336012)(110136005)(40480700001)(82740400003)(81166007)(82310400005)(36756003)(86362001)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 23:55:46.0048
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a91cc3b1-4731-47c8-1a86-08db72b307f3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9CD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6068
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clean up and reorder them according to the bit index. There is no
functional change.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd/amd_iommu_types.h | 13 +++++++------
 drivers/iommu/amd/init.c            | 10 +++++-----
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 2ddbda3a4374..09df25779fe9 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -93,18 +93,19 @@
 #define FEATURE_GA		(1ULL<<7)
 #define FEATURE_HE		(1ULL<<8)
 #define FEATURE_PC		(1ULL<<9)
-#define FEATURE_GATS_SHIFT	(12)
-#define FEATURE_GATS_MASK	(3ULL)
 #define FEATURE_GAM_VAPIC	(1ULL<<21)
 #define FEATURE_GIOSUP		(1ULL<<48)
 #define FEATURE_EPHSUP		(1ULL<<50)
 #define FEATURE_SNP		(1ULL<<63)
 
-#define FEATURE_PASID_SHIFT	32
-#define FEATURE_PASID_MASK	(0x1fULL << FEATURE_PASID_SHIFT)
+#define FEATURE_GATS_SHIFT	12
+#define FEATURE_GATS_MASK	(0x03ULL << FEATURE_GATS_SHIFT)
 
-#define FEATURE_GLXVAL_SHIFT	14
-#define FEATURE_GLXVAL_MASK	(0x03ULL << FEATURE_GLXVAL_SHIFT)
+#define FEATURE_GLX_SHIFT	14
+#define FEATURE_GLX_MASK	(0x03ULL << FEATURE_GLX_SHIFT)
+
+#define FEATURE_PASMAX_SHIFT	32
+#define FEATURE_PASMAX_MASK	(0x1FULL << FEATURE_PASMAX_SHIFT)
 
 /* Extended Feature 2 Bits */
 #define FEATURE_SNPAVICSUP_SHIFT	5
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 886cf55e75e2..6a045a187971 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -310,7 +310,7 @@ static bool check_feature_on_all_iommus(u64 mask)
 
 static inline int check_feature_gpt_level(void)
 {
-	return ((amd_iommu_efr >> FEATURE_GATS_SHIFT) & FEATURE_GATS_MASK);
+	return ((amd_iommu_efr && FEATURE_GATS_MASK) >> FEATURE_GATS_SHIFT);
 }
 
 /*
@@ -2039,16 +2039,16 @@ static int __init iommu_init_pci(struct amd_iommu *iommu)
 		u32 max_pasid;
 		u64 pasmax;
 
-		pasmax = iommu->features & FEATURE_PASID_MASK;
-		pasmax >>= FEATURE_PASID_SHIFT;
+		pasmax = iommu->features & FEATURE_PASMAX_MASK;
+		pasmax >>= FEATURE_PASMAX_SHIFT;
 		max_pasid  = (1 << (pasmax + 1)) - 1;
 
 		amd_iommu_max_pasid = min(amd_iommu_max_pasid, max_pasid);
 
 		BUG_ON(amd_iommu_max_pasid & ~PASID_MASK);
 
-		glxval   = iommu->features & FEATURE_GLXVAL_MASK;
-		glxval >>= FEATURE_GLXVAL_SHIFT;
+		glxval   = iommu->features & FEATURE_GLX_MASK;
+		glxval >>= FEATURE_GLX_SHIFT;
 
 		if (amd_iommu_max_glx_val == -1)
 			amd_iommu_max_glx_val = glxval;
-- 
2.34.1

