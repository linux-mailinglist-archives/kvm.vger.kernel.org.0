Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB52739366
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 01:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjFUX4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 19:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjFUXzw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 19:55:52 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0CC1710;
        Wed, 21 Jun 2023 16:55:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gd6c6DWiafCTp2ztB4go7PY8HSdmHMSH9OUfhk413TjCTdF59gpgZsw58IJ3Nk9hanua5CpuGMpiEFP5QJUjV0pUVlF0ayzCGviBRPXMVJV0orzobDrVv60bD8wPRDNQYWmIMy29SKktxMwnn1RhLtRoU44NTLod5YB0AxEn+L+ZTqpdd1UIsppxMiJ9fsPX31+Nfk5VxfBjP+k/VdN9MJ23RVQ6aglR3k/CkIJtuFS/DL66Hb45RPjBrLRLlcFug0n4uVnny7JdtjH3nYQ4P5qu5rCp9TT8BTXs+KXhDTzLpDCxx5exCmTbZc85Poz+RI58Ay8csWLYh+/Wb+JRFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zGNRyfGK4mdTMzFSz+GKDdonCpxeLi7YSFP+IeRBqlc=;
 b=iwIZuJv9aKkQBQnBdRmoz8vR1wF/IYQjc/h1brmBO1Kjpya/s34rec04u24BK4gASnVYLSTYHi8bz+5Wj4VaXckpDm316EAUqY2UI3E4qp1zQ7Hc8W+Y4z2z7jk6JhXXn07whtEQCv0Twnfepkr0WYEyGbWU45+BvYE7EYBvtnE1aWpeINwD+APKUjHU3RP0p6/pW4h4vug+IG0eFKW3z8PFSNNLC313QrWgZAwCwytF0y4f9IwgEQAOmuLUmS3O1H/6NRcZdvlFeenDYiEvRC+ISUAOO43XiGRIl3VnrbBHVRebfCRv2ENTIRa0QI5EDAaAF7P0QK8ON0jfhAdBbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zGNRyfGK4mdTMzFSz+GKDdonCpxeLi7YSFP+IeRBqlc=;
 b=pNUvl/1bFvCscc5WAVEJdVWq86k37pBRMP0C1ogX6IyJ6ASQN9DK68Ir195onPLIbs5si1aWfoVqQCOQvcoDR4MXVPCnV7IYRF6PEGusyuTmkRi3qZv017HRz8qlIH9XDk+ENlHEzky8CTftjvoPOY1ihokiaHtVTNIbYiy/KtU=
Received: from CY5PR15CA0035.namprd15.prod.outlook.com (2603:10b6:930:1b::22)
 by DM6PR12MB5008.namprd12.prod.outlook.com (2603:10b6:5:1b7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Wed, 21 Jun
 2023 23:55:49 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:930:1b:cafe::68) by CY5PR15CA0035.outlook.office365.com
 (2603:10b6:930:1b::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21 via Frontend
 Transport; Wed, 21 Jun 2023 23:55:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D4.mail.protection.outlook.com (10.167.241.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6521.21 via Frontend Transport; Wed, 21 Jun 2023 23:55:48 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 21 Jun
 2023 18:55:47 -0500
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
Subject: [RFC PATCH 06/21] iommu/amd: Modify set_dte_entry() to add gcr3 input parameter
Date:   Wed, 21 Jun 2023 18:54:53 -0500
Message-ID: <20230621235508.113949-7-suravee.suthikulpanit@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|DM6PR12MB5008:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cac8257-46cc-4cc0-e63e-08db72b30992
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CKJYfh11c6zLG16peuQ70hb/dk0m6rk2zRP1HESICEfzbWNds/HcbZ8X7LVlGLXpba02dv0qcxwJqB59DxtONMz6DAJ5KuH0MyHUdDmsrux65o5+J9jYc+ASoRFwhVLi/3+W+dcm5yC9lAvtLGanscK+RsQT5e8RgZ2UdfbUfFtGaU/ehQw5iMd3wQ46FUKfRzn8i3otg65VnDQIf74JFutRSEPBiWeZ10hF5+fAGTGC7ZEzldGOX3+Q7b5XyYkrywW044yjrIKexx+5riWrMrF1iV5AsIBoySV4rQrHP12Tz1WN2hmZyx6g1Zv3n6n/LyKHGm2GCSJZCDLRcMovgDUg2Mj3xPb9aKqt6heJuJLPb1qaXXsTkbWHrBTDintnCHFIjF8+JUzcVXsFyTvL3cxKf9+2VRzynaaXf/9UYPngQH5Wp+m0A13G6hmo8FlJTvUxujIMUAOJNsHYLJ2iJyA/36Im1nd3tH0sgukndP9Ve4O5NZ1V8CRfPoXdsBUXLeini/2pfxIciFu82u61Gu8yiWScs5vvdRCtxaAnCU5rxp7SYMyT+mHp9k+Mv8sonXz8t0K7SZmpSxHDqVA74PJD4LfezfrHjignp5lj9JF3MSKCu8b2cNwqSz+1hY9Eg2EynmPQQ2qRCR/NolWbkXAgU7JALcxfA7tRwVhYC4T7hN7jAeMBsbswiPtG+Oswdig4B2eVANHjd8S7EtFqXHyK5aLHBc0K3dEBrHjIP/OR/3z60vIs97a/UMl24KOSNa0qTJmqX2ISvmwBVT/gmg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(396003)(376002)(451199021)(40470700004)(46966006)(36840700001)(6666004)(110136005)(4326008)(54906003)(478600001)(47076005)(40480700001)(336012)(2616005)(426003)(83380400001)(36756003)(86362001)(36860700001)(40460700003)(2906002)(186003)(82310400005)(70586007)(16526019)(7696005)(1076003)(26005)(356005)(82740400003)(81166007)(316002)(70206006)(8676002)(41300700001)(8936002)(5660300002)(44832011)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 23:55:48.7297
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cac8257-46cc-4cc0-e63e-08db72b30992
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5008
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
 drivers/iommu/amd/amd_iommu.h |  1 +
 drivers/iommu/amd/iommu.c     | 10 ++++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 5d2eed07a1fa..dbfc70556220 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -16,6 +16,7 @@ extern void iommu_feature_disable(struct amd_iommu *iommu, u8 bit);
 extern u8 __iomem * __init iommu_map_mmio_space(u64 address, u64 end);
 extern void set_dte_entry(struct amd_iommu *iommu, u16 devid,
 			  struct protection_domain *domain,
+			  u64 *gcr3_tbl,
 			  bool ats, bool ppr);
 extern int iommu_flush_dte(struct amd_iommu *iommu, u16 devid);
 extern struct protection_domain *to_pdomain(struct iommu_domain *dom);
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 3b31ecde0122..4728929657f5 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1590,7 +1590,9 @@ static void set_dte_entry_v2(struct amd_iommu *iommu,
 }
 
 void set_dte_entry(struct amd_iommu *iommu, u16 devid,
-		   struct protection_domain *domain, bool ats, bool ppr)
+		   struct protection_domain *domain,
+		   u64 *gcr3_tbl,
+		   bool ats, bool ppr)
 {
 	u64 pte_root = 0;
 	u64 flags = 0;
@@ -1622,7 +1624,7 @@ void set_dte_entry(struct amd_iommu *iommu, u16 devid,
 			pte_root |= 1ULL << DEV_ENTRY_PPR;
 	}
 
-	set_dte_entry_v2(iommu, domain, domain->gcr3_tbl, &pte_root, &flags);
+	set_dte_entry_v2(iommu, domain, gcr3_tbl, &pte_root, &flags);
 
 	if ((domain->flags & PD_IOMMUV2_MASK) &&
 	    amd_iommu_gpt_level == PAGE_MODE_5_LEVEL) {
@@ -1686,7 +1688,7 @@ static void do_attach(struct iommu_dev_data *dev_data,
 	domain->dev_cnt                 += 1;
 
 	/* Update device table */
-	set_dte_entry(iommu, dev_data->devid, domain,
+	set_dte_entry(iommu, dev_data->devid, domain, domain->gcr3_tbl,
 		      ats, dev_data->iommu_v2);
 	clone_aliases(iommu, dev_data->dev);
 
@@ -1965,7 +1967,7 @@ static void update_device_table(struct protection_domain *domain)
 
 		if (!iommu)
 			continue;
-		set_dte_entry(iommu, dev_data->devid, domain,
+		set_dte_entry(iommu, dev_data->devid, domain, domain->gcr3_tbl,
 			      dev_data->ats.enabled, dev_data->iommu_v2);
 		clone_aliases(iommu, dev_data->dev);
 	}
-- 
2.34.1

