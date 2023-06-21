Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF59D739367
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 01:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjFUX4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 19:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjFUXzv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 19:55:51 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2041.outbound.protection.outlook.com [40.107.223.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F1F171C;
        Wed, 21 Jun 2023 16:55:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JeFrL9n2r6WsMWSJUad5tQFMBoGVxeSoNVT6eFciLGbQQDKu/JHqh1y5WWHveHgLIs+J6UBVR/J2FoB2vEiAERG4HdQCNVeZZt5nZ5su/Z9h2CyVe/lqvTE2utWXwx/RwLaaGEe7du0ZK8XyQQMzX0TH+IqxCDD+rRXItf7zhly9pe3Ges8B5AknpIvLpHPDM0Jy9sse5RJqNvKgQGvr+ggKOSeWgqjcC5HUQ0TDSZEZBQxL57gGiLbR/cIwEYwE0TnqJpPfFbD5Kuky2Eeq4FqSA6l9Bwr1Hwwn8iRXYnPjSH9IqAqMIx6T93d6KLJMXnQhZjM0gvl0yAScSMlzgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gSPrSEAa3+LIYJDZ4lFCFstgZyqmi5f7j1/nqqglRWc=;
 b=nZA2dINL0Y5faZc48HtDIkOQi69pffkKS2X/wBL3Zh0V31WJ03Y29xO0dxrnLNz9qjIn9NZIt0oy4cqWHli1IBdIreZUpgv5WOBurMCjj7uF/hbACAcxEAFmyuBgyElUpgwDOujPkB0vX7BHl/Adx4T3L7C/aHSqf8+oYBQgo07DOMMsLQrNvw9Eaxa41r7rCTnQ+8JQdDVwakrAhuaBOezwOIo/9WPVcOhw+37xjRU+LMc2swPuiVFmN7NGT/TXL9aVmuP5z/nvgLhWFdRHTpQGI8OwuJxCHZQNLZt5usZf6UhfDCH2ZQ0xTAyoZyH+UBE4/MdfuE5uIRgPJED8RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gSPrSEAa3+LIYJDZ4lFCFstgZyqmi5f7j1/nqqglRWc=;
 b=aGtRQNiDffePbOTn9fTzYEPWRs6paWCTa8m2hpHwlTxeQE7UW04qXQMoxrKxuWGzdIIOjuh1eJ20N+HRHOr3VnAkt6aaQHSYz4LE5IiB9XZ+o1FwQuiFy1X8ACSJP3p7t/g1hOtbPLC52uJndet41ztykZ+69ggr8v+sHxD8D60=
Received: from CY5PR15CA0052.namprd15.prod.outlook.com (2603:10b6:930:1b::9)
 by IA0PR12MB7625.namprd12.prod.outlook.com (2603:10b6:208:439::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Wed, 21 Jun
 2023 23:55:48 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:930:1b:cafe::c4) by CY5PR15CA0052.outlook.office365.com
 (2603:10b6:930:1b::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21 via Frontend
 Transport; Wed, 21 Jun 2023 23:55:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D4.mail.protection.outlook.com (10.167.241.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6521.21 via Frontend Transport; Wed, 21 Jun 2023 23:55:47 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 21 Jun
 2023 18:55:46 -0500
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
Subject: [RFC PATCH 05/21] iommu/amd: Refactor set_dte_entry() helper function
Date:   Wed, 21 Jun 2023 18:54:52 -0500
Message-ID: <20230621235508.113949-6-suravee.suthikulpanit@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|IA0PR12MB7625:EE_
X-MS-Office365-Filtering-Correlation-Id: dd94c437-1e02-4831-622e-08db72b3090d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GHCHekY8JjVpha0ypVrIWbrwQ0gPLCWww0oL2WuoWGHlR8hVjblKKbySoMGiHzhT1aGfDh4oizSa3Qt6qdR5M3rje0q/7MLmKTQrVimjVdpFP1wlb6uxaCdFblMe4M95aucRvhvTErYZLOdpGXoGvRWHFaZtH5aJNbszWaSPqv3chyEkdhe1+eRcG1/sDhM00KNkY+6QnSdhUf5a/iHWkGKthioh1eUWngv9RVvqS3Yx48XN/0e9ejDgWM3RC0i22He2TuvOoNfZ5N1M50Fdfb76mnyWDFBGluZIoOoMClCPNxr1clqdihkBb3vseYUmwd2nxPXUa+ZJQ9knatwtRxOxPkVskDOAHegxpdo5dDfxJp1YvRnz3WtrOZll4zJUsnUO2ZQCFtoMLR4rnp7EUj0t3tLoEqjS5CRbiBFw30xM1VTDrbd2LYPk+O1zJhBaiME+rgdArxy/RrhgShoZUGHGhrZNr3vj8ZCltO8/+rpt/oRiWCFF/C++yySLerbD76KarIGDnVaipEvS1DrhpmmLrhQgNEV2wiXBeosf1PZwC4ikxE5gD8zl6kkTIH+I5l5Mu5zw1/aw2odonJOiHQJvaCwGBFcguzBv8hme+XXDXSARJHIxNXs/ggzb+wnp1I3HqU2f2iLpWKY4qei31GX1UXpcmbXwgp4+pAa3DteTV9HdyiNRygXkGL2mkyeH4+BRQ5v884+OZwDEBXdt0JuplItAC8SCX9wiXyrK5Y5cxbw85nkm2PBGA+HCrWCcHu2Cm6nTDolIrjhH+1zC1w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39860400002)(376002)(136003)(451199021)(36840700001)(40470700004)(46966006)(356005)(81166007)(36756003)(82740400003)(40480700001)(86362001)(40460700003)(82310400005)(70586007)(2616005)(41300700001)(8936002)(316002)(8676002)(478600001)(4326008)(70206006)(44832011)(47076005)(426003)(83380400001)(1076003)(336012)(7416002)(5660300002)(6666004)(7696005)(16526019)(186003)(54906003)(110136005)(26005)(36860700001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 23:55:47.8547
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd94c437-1e02-4831-622e-08db72b3090d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7625
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

To separate logic for IOMMU guest (v2) page table into another helper
function in preparation for subsequent changes.

There is no functional change.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd/iommu.c | 72 ++++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 31 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 6017fce8d7fd..3b31ecde0122 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1553,6 +1553,42 @@ static void free_gcr3_table(struct protection_domain *domain)
 	free_page((unsigned long)domain->gcr3_tbl);
 }
 
+static void set_dte_entry_v2(struct amd_iommu *iommu,
+			     struct protection_domain *domain,
+			     u64 *gcr3_tbl, u64 *pte_root, u64 *flags)
+{
+	u64 gcr3 = iommu_virt_to_phys(gcr3_tbl);
+	u64 glx  = domain->glx;
+	u64 tmp;
+
+	if (!(domain->flags & PD_IOMMUV2_MASK))
+		return;
+
+	if ((domain->flags & PD_GIOV_MASK) &&
+	    iommu_feature(iommu, FEATURE_GIOSUP))
+		*pte_root |= DTE_FLAG_GIOV;
+
+	*pte_root |= DTE_FLAG_GV;
+	*pte_root |= (glx & DTE_GLX_MASK) << DTE_GLX_SHIFT;
+
+	/* First mask out possible old values for GCR3 table */
+	tmp = DTE_GCR3_VAL_B(~0ULL) << DTE_GCR3_SHIFT_B;
+	*flags    &= ~tmp;
+
+	tmp = DTE_GCR3_VAL_C(~0ULL) << DTE_GCR3_SHIFT_C;
+	*flags    &= ~tmp;
+
+	/* Encode GCR3 table into DTE */
+	tmp = DTE_GCR3_VAL_A(gcr3) << DTE_GCR3_SHIFT_A;
+	*pte_root |= tmp;
+
+	tmp = DTE_GCR3_VAL_B(gcr3) << DTE_GCR3_SHIFT_B;
+	*flags    |= tmp;
+
+	tmp = DTE_GCR3_VAL_C(gcr3) << DTE_GCR3_SHIFT_C;
+	*flags    |= tmp;
+}
+
 void set_dte_entry(struct amd_iommu *iommu, u16 devid,
 		   struct protection_domain *domain, bool ats, bool ppr)
 {
@@ -1586,38 +1622,12 @@ void set_dte_entry(struct amd_iommu *iommu, u16 devid,
 			pte_root |= 1ULL << DEV_ENTRY_PPR;
 	}
 
-	if (domain->flags & PD_IOMMUV2_MASK) {
-		u64 gcr3 = iommu_virt_to_phys(domain->gcr3_tbl);
-		u64 glx  = domain->glx;
-		u64 tmp;
-
-		pte_root |= DTE_FLAG_GV;
-		pte_root |= (glx & DTE_GLX_MASK) << DTE_GLX_SHIFT;
-
-		/* First mask out possible old values for GCR3 table */
-		tmp = DTE_GCR3_VAL_B(~0ULL) << DTE_GCR3_SHIFT_B;
-		flags    &= ~tmp;
-
-		tmp = DTE_GCR3_VAL_C(~0ULL) << DTE_GCR3_SHIFT_C;
-		flags    &= ~tmp;
-
-		/* Encode GCR3 table into DTE */
-		tmp = DTE_GCR3_VAL_A(gcr3) << DTE_GCR3_SHIFT_A;
-		pte_root |= tmp;
-
-		tmp = DTE_GCR3_VAL_B(gcr3) << DTE_GCR3_SHIFT_B;
-		flags    |= tmp;
-
-		tmp = DTE_GCR3_VAL_C(gcr3) << DTE_GCR3_SHIFT_C;
-		flags    |= tmp;
-
-		if (amd_iommu_gpt_level == PAGE_MODE_5_LEVEL) {
-			dev_table[devid].data[2] |=
-				((u64)GUEST_PGTABLE_5_LEVEL << DTE_GPT_LEVEL_SHIFT);
-		}
+	set_dte_entry_v2(iommu, domain, domain->gcr3_tbl, &pte_root, &flags);
 
-		if (domain->flags & PD_GIOV_MASK)
-			pte_root |= DTE_FLAG_GIOV;
+	if ((domain->flags & PD_IOMMUV2_MASK) &&
+	    amd_iommu_gpt_level == PAGE_MODE_5_LEVEL) {
+		dev_table[devid].data[2] |=
+			((u64)GUEST_PGTABLE_5_LEVEL << DTE_GPT_LEVEL_SHIFT);
 	}
 
 	flags &= ~DEV_DOMID_MASK;
-- 
2.34.1

