Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3E373936E
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 01:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjFUX4L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 19:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbjFUXzy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 19:55:54 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2054.outbound.protection.outlook.com [40.107.220.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E4F1710;
        Wed, 21 Jun 2023 16:55:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZOJN4TC/0/d+E25u2CDXMKiSWOPVOw5oL3VjsLH1Lu7BpulJtOMOJXSWrxSQqTE/E75LMBHMf/RJF+k7G+S2JIGbzrvp8VSY7RZM/9MxPm+ErRbGhWQzsN2K4x+PELfaMqyUKkF0AoSakszwEj/YEm0PQNwGcnrWRTfbj6jhw/JWiB7kwefD4PqcIiiaK+gLePZUQgorrS/4nQUowSrtC7SvOh/QY8LbVgRl3rgHXCGJ2cmrQNiVuKw3pgTpObnn7UhNnQ3zHf/5Qwj5DSS6muA6UMfp0L/+lD1s79pMLFiv/KtQWvSmX/RXcg3Xg2nUUBfvn44bQD5g16/Pllir/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rLb5xtN5TaWay0gJVTKsVlxdX6r0nThc1E7uO+JsurY=;
 b=Uhhnllxe8q5oAzBIfMkDoOfuuROrut8KhYWEahZFR6uLKfUyGmLOm7YweTVgcfM3ZtE1yFcQq+eDa15R8uTTRQKiGBaLTcdNAgSJP5unsUuK03X8ougNaNKfA4OfAcgiqeJRw1vYFWdlHrwdmaOlY66Hggw1pRvAmlRw7iMHBsSSCL0eoCR5bUtXqCl/wumbzBXj/lIhFT243ZfIY2btvQBSX3L+mDpfGGELcHl4ql4r/R81DkZ0JyaV2/n7HBLRhFBr+bdEm29TobYLChdd6P4UJ/3GvscR6C2jth0zQUM+85YTnuIQlVhgMOzLYOt2ASe3aXF2PuNJSHlWbuQIGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rLb5xtN5TaWay0gJVTKsVlxdX6r0nThc1E7uO+JsurY=;
 b=xBIDnbTRWPnsUnmg66556YLdXdfiwCs2UOmi/Ju3/oubKfs4zAVreaGBbrKrRv6ZgFixSJ0so2fpB0Qh/+aE5gNsOs6f3rckDOu69ZKjwNUlLmYFUwV1RQTPl4Xb6Kt0tqfKAPGaUlRa7XxWL8ZRmjsYJrs39S8W2FR6fLiEcJw=
Received: from CY5PR15CA0053.namprd15.prod.outlook.com (2603:10b6:930:1b::30)
 by BL1PR12MB5302.namprd12.prod.outlook.com (2603:10b6:208:31d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Wed, 21 Jun
 2023 23:55:51 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:930:1b:cafe::df) by CY5PR15CA0053.outlook.office365.com
 (2603:10b6:930:1b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23 via Frontend
 Transport; Wed, 21 Jun 2023 23:55:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D4.mail.protection.outlook.com (10.167.241.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6521.21 via Frontend Transport; Wed, 21 Jun 2023 23:55:50 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 21 Jun
 2023 18:55:49 -0500
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
Subject: [RFC PATCH 08/21] iommu/amd: Allow nested IOMMU page tables
Date:   Wed, 21 Jun 2023 18:54:55 -0500
Message-ID: <20230621235508.113949-9-suravee.suthikulpanit@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|BL1PR12MB5302:EE_
X-MS-Office365-Filtering-Correlation-Id: f84711e7-3783-4837-3b31-08db72b30acb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KJT4n4Ec4KvH2bEojB86+baQFYdyYGnSWIxaOLQ9kK1k063657lOs8l3mtaUFPhVn+4IUASeaZribS9hrEvgzxmVsVdDnISSBg9QYfc6AwK7dqar34VBAKSA8n7HEaiQEr+w5MIHX4zvjye3pJWFcmqllkSG7Z/YlKayKyjd7OXpsxDQavDV7JqM9IVrkVrUGCFxaCSYdLUa+mRzb82VxMSQpBMlUc1n/8Ve90hVYjoRxK0bo32vJxoIvcHVPnhYKhmW/h2OIRgkI747b1CewDp25vFITzFISDdmwfqKoitKEGqQvYGMamxulSOcBMe9RDqVNpoO+7UMdCX/ZIgSSd4Aub5VIlGNDqAC9+0kRQ3vfCGN4tpVaZO91Xi11DvDLdppeqtkzFHuaNMysWKHm+Nhid74Dzm67ZxR1sle59H3xzQVhZ6mYnjquploOvJ0isO7w5ncvVoAK7g04sAArPyb1aNOIlvp77X6PdjZ1UgRNNvfw9oPMLmmFLPi09F+KrZFzFkEwPhJB2a38e1wLbpH2UnmSeWJE25O6apemxOsbApmC2kQ5eOT2SF4Vr22dh4lIBH5fg9d/CxLNrt+9Ox4wC80VOxZ8+0twU/euJjRuoFFT3eZ9whlcCNr997Z831dxBTLrXx/6e+u3HsMRZQUB5SS0PezCKLbjeSeETB3Vs7SuDQPd++XXvxUsPfbA2hKk05+NS8QVCo6QgQB7lG3O6aQHu6CauuxkvLEletcQEjL+lvHbjpUsxmLDLXzGkwF12aF8Mr/pqQp0PVLuQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(396003)(376002)(346002)(451199021)(46966006)(40470700004)(36840700001)(40460700003)(7696005)(6666004)(478600001)(83380400001)(16526019)(186003)(47076005)(426003)(26005)(336012)(2616005)(82310400005)(86362001)(82740400003)(36756003)(356005)(1076003)(81166007)(40480700001)(36860700001)(70586007)(70206006)(4326008)(41300700001)(316002)(7416002)(44832011)(8936002)(8676002)(5660300002)(110136005)(54906003)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 23:55:50.7766
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f84711e7-3783-4837-3b31-08db72b30acb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5302
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

The GCR3 table contains guest CR3 registers, and it is used to
setup guest page tables. Current logic only allow guest CR3 table
setup only when the host table is not setup (i.e. PAGE_MODE_NONE).
Therefore, only 1-level page translation is allowed
(e.g. host only vs. guest only).

Remove this restriction to allow nested page table setup.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd/iommu.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 333c8a4831be..c23f99ebdffc 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2531,12 +2531,12 @@ int amd_iommu_domain_enable_v2(struct iommu_domain *dom, int pasids, bool giov)
 	spin_lock_irqsave(&pdom->lock, flags);
 
 	/*
-	 * Save us all sanity checks whether devices already in the
-	 * domain support IOMMUv2. Just force that the domain has no
-	 * devices attached when it is switched into IOMMUv2 mode.
+	 * With nested page table, we can enable * v2 (i.e GCR3)
+	 * on a existing domain. Therefore, only check if domain
+	 * already enable v2.
 	 */
 	ret = -EBUSY;
-	if (pdom->dev_cnt > 0 || pdom->flags & PD_IOMMUV2_MASK)
+	if (pdom->flags & PD_IOMMUV2_MASK)
 		goto out;
 
 	if (!pdom->gcr3_tbl)
@@ -2688,9 +2688,6 @@ static int __set_gcr3(struct protection_domain *domain, u32 pasid,
 {
 	u64 *pte;
 
-	if (domain->iop.mode != PAGE_MODE_NONE)
-		return -EINVAL;
-
 	pte = __get_gcr3_pte(domain->gcr3_tbl, domain->glx, pasid, true);
 	if (pte == NULL)
 		return -ENOMEM;
-- 
2.34.1

