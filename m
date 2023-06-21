Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D6C73934B
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 01:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjFUX4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 19:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjFUXzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 19:55:50 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2045.outbound.protection.outlook.com [40.107.96.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2B01735;
        Wed, 21 Jun 2023 16:55:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dc0lJU6JWWq553NiNycteM3x51NupIxxtvWWTtIvlNyVk548CChZ7gm0IIEqR7JVIYKJGGbf/dw1TB68brz6K/K9qnpVS2A2tbWxvGYzQeQK9h3cqJ3G2GQjN3sTKqyXb8pcLqgLNGy21NfXgzbhYutxbovoXS/fWXu1ocGIwmIXN6Dx75PoL9ra/aC3ZCXBVI1SUmnTOKe2eKNoPg5E9eHhybIgR1HCiw48SSok7GRTa2Igl3ANBx1jhrpu4sJvZw8S7ZAkBuIpYlBHj/b6b+8Dh9KwoWBHTthWLyL/f4sWxxHYlHIT/fpHMKln3rhNWhzsMHSwDnoDSJ6+mKPffg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cEqC5gNJ6QrfMU+1FtcsmxsZM8CD4QlJlb2KHBULmps=;
 b=ezJHeWq9jgKF+AIb9vkeK+lqstxGTuyJNbXAZYU1xi7GfzHAlu3/fbpFy9qh6jMkOgcIijU1UAvhyjSWMO0ayg9UuwPemKgfFtAV7zrKsxuXFJsM2H6nQvdqPWqURY5qU+i1KaTSe8lIz6V4HJOqEu2bRi7CWhnVBibDcYGCqzuc3RtK4HPHiErrk3vVOohhphbSUJjsniONZ0JuDsa9PDAKO2QfXRFJKhkhoTSs/a9pxzgXl+nC2VkaXKhtexf87cKcOwgk+wM6M+IWsiB7iDBiyDGkA/80DTbjCfn7L/ABFsMDK3Mqe6n83e8B8dtfzNpbC7GvMJSgdRNJz8NpUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cEqC5gNJ6QrfMU+1FtcsmxsZM8CD4QlJlb2KHBULmps=;
 b=S5veSHUnwIZvPBY9iK1juCauVobXlPAFGDI924JXHXX8/LD6uU8EqC2HjMtvo0riI0PZIVBPiv2ic/vSP+uV1cFvvOQCY3M67t1Ztb5KZowLDvLYTAMETamjORHgVNdL7Q1evGqCkBemkobSUcsFcnHwl9se0WUoZFq6OTlJaUw=
Received: from CYZPR10CA0010.namprd10.prod.outlook.com (2603:10b6:930:8a::23)
 by PH7PR12MB6936.namprd12.prod.outlook.com (2603:10b6:510:1ba::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Wed, 21 Jun
 2023 23:55:46 +0000
Received: from CY4PEPF0000E9CD.namprd03.prod.outlook.com
 (2603:10b6:930:8a:cafe::e2) by CYZPR10CA0010.outlook.office365.com
 (2603:10b6:930:8a::23) with Microsoft SMTP Server (version=TLS1_2,
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
 2023 18:55:45 -0500
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
Subject: [RFC PATCH 04/21] iommu/amd: Modify domain_enable_v2() to add giov parameter
Date:   Wed, 21 Jun 2023 18:54:51 -0500
Message-ID: <20230621235508.113949-5-suravee.suthikulpanit@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9CD:EE_|PH7PR12MB6936:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e9241bf-7f61-4604-8cb9-08db72b30846
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4CfxtBXxwUn+qPhpiUn/h+ZibwitajE/9uMykXHvjgLgtLz9V/JGS8YW5SHzUbdcdho5uSNMvVKTnvK8CvKs+jPxFglmfYx68T2kTe72TmK29kEkaKqOuIM1vV5YOEwMLmR/JGWMVcL6wwsF2AkyUjUJEQxLvaf0QOFy1/H5vI9hSGYulsy7uCYAXmRYr9ro+N/wcTFZxlsy1FTq+4viiTrC2Qz7JVjnw30bMAitHBu6114yoZMhud4dfRYloKRpwB9B5Ksk6bnAcmA7qCpvcB5PJIZXnlp5t0wNqiRvUTbkEFagYNx1qwCxwWzKfzJVG7qRwWZm2WuGTKUtbL8DqdmsqOHucs7onxD3A3Rqkxvsf9TAB09OXv+2HNm8pmn1ZVpWOPbTn92u7I6mbVWUInR69ZKrXq1AvZPW0Q6uawufHiGnbc8RmeU8hQnSSO3gtHb2leoemQjguGdLbWaNvLVshiqolsfxZ0ZTm/BkKrrTgazyvusX4Iv/QDV4ED0aBWSfU0lKncYlnMUP050XFiTVWcry3MHyfChqqNLAfDVo7j3xQ6WOPumgx/cx31I0s7iEZu+d8MjHm/Qiv9q25A90MRmIbfjBXNTsw8khtwfugp/6Qep/1U/jDStTgRRYlWqKTj11jVzcSsk6Eby3g8TzvM7ah6VRasHxrIaoKTMdd3bKlMEXxsD92dXsXt/eHYeyTHzbMe6CkO5cxj6QkFYj/w3ksSO7oWRY6mIZCl8q3Wrec3tOJhHw/zZvDjAtRFzbQU+b9CElrAqCequuDg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39860400002)(346002)(396003)(451199021)(36840700001)(40470700004)(46966006)(82740400003)(81166007)(356005)(16526019)(26005)(186003)(40460700003)(1076003)(47076005)(2616005)(36860700001)(40480700001)(83380400001)(426003)(336012)(82310400005)(54906003)(110136005)(70586007)(478600001)(70206006)(44832011)(5660300002)(7416002)(4326008)(86362001)(2906002)(316002)(8676002)(41300700001)(7696005)(8936002)(6666004)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 23:55:46.5517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e9241bf-7f61-4604-8cb9-08db72b30846
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9CD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6936
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

To preparation for subsequent changes. There is no functional change.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd/amd_iommu.h |  2 +-
 drivers/iommu/amd/iommu.c     | 14 +++++++-------
 drivers/iommu/amd/iommu_v2.c  |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 827d065bbe8e..5d2eed07a1fa 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -70,7 +70,7 @@ extern int amd_iommu_pc_set_reg(struct amd_iommu *iommu, u8 bank, u8 cntr,
 extern int amd_iommu_register_ppr_notifier(struct notifier_block *nb);
 extern int amd_iommu_unregister_ppr_notifier(struct notifier_block *nb);
 extern void amd_iommu_domain_direct_map(struct iommu_domain *dom);
-extern int amd_iommu_domain_enable_v2(struct iommu_domain *dom, int pasids);
+extern int amd_iommu_domain_enable_v2(struct iommu_domain *dom, int pasids, bool giov);
 extern int amd_iommu_flush_page(struct iommu_domain *dom, u32 pasid,
 				u64 address);
 extern void amd_iommu_update_and_flush_device_table(struct protection_domain *domain);
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 356e52f478f1..6017fce8d7fd 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -79,7 +79,7 @@ struct iommu_cmd {
 struct kmem_cache *amd_iommu_irq_cache;
 
 static void detach_device(struct device *dev);
-static int domain_enable_v2(struct protection_domain *domain, int pasids);
+static int domain_enable_v2(struct protection_domain *domain, int pasids, bool giov);
 
 /****************************************************************************
  *
@@ -2051,11 +2051,9 @@ static int protection_domain_init_v2(struct protection_domain *domain)
 		return -ENOMEM;
 	INIT_LIST_HEAD(&domain->dev_list);
 
-	domain->flags |= PD_GIOV_MASK;
-
 	domain->domain.pgsize_bitmap = AMD_IOMMU_PGSIZES_V2;
 
-	if (domain_enable_v2(domain, 1)) {
+	if (domain_enable_v2(domain, 1, true)) {
 		domain_id_free(domain->id);
 		return -ENOMEM;
 	}
@@ -2484,7 +2482,7 @@ void amd_iommu_domain_direct_map(struct iommu_domain *dom)
 EXPORT_SYMBOL(amd_iommu_domain_direct_map);
 
 /* Note: This function expects iommu_domain->lock to be held prior calling the function. */
-static int domain_enable_v2(struct protection_domain *domain, int pasids)
+static int domain_enable_v2(struct protection_domain *domain, int pasids, bool giov)
 {
 	int levels;
 
@@ -2501,13 +2499,15 @@ static int domain_enable_v2(struct protection_domain *domain, int pasids)
 
 	domain->glx      = levels;
 	domain->flags   |= PD_IOMMUV2_MASK;
+	if (giov)
+		domain->flags |= PD_GIOV_MASK;
 
 	amd_iommu_domain_update(domain);
 
 	return 0;
 }
 
-int amd_iommu_domain_enable_v2(struct iommu_domain *dom, int pasids)
+int amd_iommu_domain_enable_v2(struct iommu_domain *dom, int pasids, bool giov)
 {
 	struct protection_domain *pdom = to_pdomain(dom);
 	unsigned long flags;
@@ -2525,7 +2525,7 @@ int amd_iommu_domain_enable_v2(struct iommu_domain *dom, int pasids)
 		goto out;
 
 	if (!pdom->gcr3_tbl)
-		ret = domain_enable_v2(pdom, pasids);
+		ret = domain_enable_v2(pdom, pasids, giov);
 
 out:
 	spin_unlock_irqrestore(&pdom->lock, flags);
diff --git a/drivers/iommu/amd/iommu_v2.c b/drivers/iommu/amd/iommu_v2.c
index 864e4ffb6aa9..0ddd10953d41 100644
--- a/drivers/iommu/amd/iommu_v2.c
+++ b/drivers/iommu/amd/iommu_v2.c
@@ -784,7 +784,7 @@ int amd_iommu_init_device(struct pci_dev *pdev, int pasids)
 	dev_state->domain->type = IOMMU_DOMAIN_IDENTITY;
 	amd_iommu_domain_direct_map(dev_state->domain);
 
-	ret = amd_iommu_domain_enable_v2(dev_state->domain, pasids);
+	ret = amd_iommu_domain_enable_v2(dev_state->domain, pasids, false);
 	if (ret)
 		goto out_free_domain;
 
-- 
2.34.1

