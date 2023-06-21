Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAC573934E
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 01:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbjFUX4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 19:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbjFUXzz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 19:55:55 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D451735;
        Wed, 21 Jun 2023 16:55:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQTC225F29bDjIizZLCPBygr4CsOSNEr7kCs20fHnsUertI8uE4dPY8inQCAV9IvgB8/U3sf8sn49ynJei3OUxJ1K8CRLBuIe/LuI6Ls04Ee6t/zNbFJ54Xxp2B7YPWS9TUGs+SKktkTu3H/xyznvgsNhTLvluPwIeUBCLyduGerIrSNXHZaPoZTZ+zPUp3bX+0Ihp2aU26tNCmOnJRNvEcSWefyQfgJfejq/MdX+e3zg6ZHuSLoqUNyLan8DiA1ieQ3i0c6M7EbZC8LM+4dpGF4nIdyPIZYQE7eKinf+rqjAdRuE0gzRgwq9lIxIXsz4nyyRTGR00mz/rx9FkcByg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zhubrmf4ky5HkOPhrtywcxqqAIJ6An6kzyc696QJ8CA=;
 b=Uq2SzgdRca52Tom2fuphbafldLeQkEgk5Sg9fXBbauPN+DUbleqrm+pFtjmtWmpkDEqWhHZ8fJykn5yfNpyZegqRxcR6oeZNQRHmml9JXHDrpchJ57Hk1y4mx4FssQaFEo7dTlBDAbRB3NwWkRBePssNfMGJjq8lNr9OZNvoz+8ji02HFzeRZF+0fvc0/GWbsI2use8sxyS3X54+KNPMdEgTeG9A1gX9erwizjkkfdOoL2jOokhJvqArn+7OD8d6rL6IslyOqp4JmQlpwSWibJG+5Hye7+qDuLTSAiXxh3KrHhMv26nFkhdyq1rq10l/Nlyqc2F7VdwLKnH3wN+2JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zhubrmf4ky5HkOPhrtywcxqqAIJ6An6kzyc696QJ8CA=;
 b=mNKjOjaBWijKU3ZYO6XMqrdKrXxet4IF6cCNXeuwAGqwwW1IsdthATEPuvfnSHE/wdpf709xabtBjiUHf8HCCf8yVZ+Q/W3sbOu9ehtAIIJWJzVDZfEoDzOfVE4pL0Jo26Ea2RUBV2g4ZCGE38zbi2RsYmK4yCJuCywXSrKXGyU=
Received: from CY5PR15CA0042.namprd15.prod.outlook.com (2603:10b6:930:1b::26)
 by SJ0PR12MB5469.namprd12.prod.outlook.com (2603:10b6:a03:37f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Wed, 21 Jun
 2023 23:55:50 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:930:1b:cafe::c8) by CY5PR15CA0042.outlook.office365.com
 (2603:10b6:930:1b::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21 via Frontend
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
 2023 18:55:48 -0500
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
Subject: [RFC PATCH 07/21] iommu/amd: Modify set_dte_entry() to add user domain input parameter
Date:   Wed, 21 Jun 2023 18:54:54 -0500
Message-ID: <20230621235508.113949-8-suravee.suthikulpanit@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|SJ0PR12MB5469:EE_
X-MS-Office365-Filtering-Correlation-Id: 75a552d4-1f28-4ec4-a08f-08db72b30a8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7FUQNR7dFw/Z+Vytpw4B2arlz4W2AxifmZj1i/bCMTyKzVATqKzYTy1DV0ZO4wXWr7TUt+y9Fk30+QZgn5SRaeYfDGWBLWIaJsxMKE4DXiCAMjXxmHC/TJ1BDAQBh6EHkjjZA+LZwNQblk3egc0TpKyMpfCSU7CTY8W1gF+VR4IswwlrEz2yhQVKQ3eESZiDH8N6smhkLyjsgRoYAy8xUWiNR+M1E1hEyUr0ZLiY+zZ1FXmiwNS0BuMuBeTnGcBTH3wi60l5hHkt71Lg+2M/NVhta0xESJ8SzxkVg3lSPa0xBTcfgNVG1XoFI0qYKR/Sb/73GWiJdOXaSZ0YpSIu4HXkvX7xPlyr8zuaMPpfwhUOWEcWnpkf0UU5GqByGFDaZAQuAUnvpKzE5tbc1utmsOUChMbCD7YaAu4nqm+s3q+unOjcQw/GyDYf9SWrQu/FePPSi5ZLQkYApTbaD+RM3e7JNGXlSgwDrkMAydBd4m+7qh8HaWkMTEkplKejGkW0HfpDFQ5pmnyrgyjaONXq+Hvp5lrlSiE7rAy67bjPRRnr981UuMpbPqiprxZwfOB0vokCN2ox/lYi75zU4ZQ98a973pDMCH22satQKJiXCxo6oYD4plT4wm6C7zycjEZRyKIj/L3JTEBBCP7KesSi/HdYnK05CogDwt2cOHEMXhUOklpmx+JQsFXnXdZLcgfBvM3d4vdIpZLpZrNTf4aYrcqXPAVnvWGUHIg6vPGoFtq2bBYUlD4lHq9+xANHKGqZGkL7y5FdF+qCZuSHMlFwPQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39860400002)(376002)(346002)(451199021)(36840700001)(46966006)(40470700004)(7696005)(6666004)(82310400005)(83380400001)(356005)(81166007)(40480700001)(26005)(16526019)(1076003)(186003)(336012)(2616005)(47076005)(426003)(36860700001)(40460700003)(36756003)(70586007)(70206006)(4326008)(316002)(2906002)(8936002)(8676002)(7416002)(44832011)(5660300002)(86362001)(110136005)(41300700001)(54906003)(82740400003)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 23:55:50.3860
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75a552d4-1f28-4ec4-a08f-08db72b30a8f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5469
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

When setting up IOMMU page table in nested mode, the host (v1) table
is managed by the hypervisor, while the guest (v2) table is managed by
the guest kernel. In this case, IOMMU driver needs to program IOMMU device
table entry (DTE) using the set_dte_entry() helper function with guest
table information (i.e. gcr3 table, glx, max pasid), which is stored
in the user domain.

There is no functional change.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd/amd_iommu.h | 1 +
 drivers/iommu/amd/iommu.c     | 9 ++++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index dbfc70556220..d36a39796c2f 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -16,6 +16,7 @@ extern void iommu_feature_disable(struct amd_iommu *iommu, u8 bit);
 extern u8 __iomem * __init iommu_map_mmio_space(u64 address, u64 end);
 extern void set_dte_entry(struct amd_iommu *iommu, u16 devid,
 			  struct protection_domain *domain,
+			  struct protection_domain *udomain,
 			  u64 *gcr3_tbl,
 			  bool ats, bool ppr);
 extern int iommu_flush_dte(struct amd_iommu *iommu, u16 devid);
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 4728929657f5..333c8a4831be 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1591,9 +1591,11 @@ static void set_dte_entry_v2(struct amd_iommu *iommu,
 
 void set_dte_entry(struct amd_iommu *iommu, u16 devid,
 		   struct protection_domain *domain,
+		   struct protection_domain *udomain,
 		   u64 *gcr3_tbl,
 		   bool ats, bool ppr)
 {
+	struct protection_domain *dom;
 	u64 pte_root = 0;
 	u64 flags = 0;
 	u32 old_domid;
@@ -1624,7 +1626,8 @@ void set_dte_entry(struct amd_iommu *iommu, u16 devid,
 			pte_root |= 1ULL << DEV_ENTRY_PPR;
 	}
 
-	set_dte_entry_v2(iommu, domain, gcr3_tbl, &pte_root, &flags);
+	dom = udomain ? udomain : domain;
+	set_dte_entry_v2(iommu, dom, gcr3_tbl, &pte_root, &flags);
 
 	if ((domain->flags & PD_IOMMUV2_MASK) &&
 	    amd_iommu_gpt_level == PAGE_MODE_5_LEVEL) {
@@ -1688,7 +1691,7 @@ static void do_attach(struct iommu_dev_data *dev_data,
 	domain->dev_cnt                 += 1;
 
 	/* Update device table */
-	set_dte_entry(iommu, dev_data->devid, domain, domain->gcr3_tbl,
+	set_dte_entry(iommu, dev_data->devid, domain, NULL, domain->gcr3_tbl,
 		      ats, dev_data->iommu_v2);
 	clone_aliases(iommu, dev_data->dev);
 
@@ -1967,7 +1970,7 @@ static void update_device_table(struct protection_domain *domain)
 
 		if (!iommu)
 			continue;
-		set_dte_entry(iommu, dev_data->devid, domain, domain->gcr3_tbl,
+		set_dte_entry(iommu, dev_data->devid, domain, NULL, domain->gcr3_tbl,
 			      dev_data->ats.enabled, dev_data->iommu_v2);
 		clone_aliases(iommu, dev_data->dev);
 	}
-- 
2.34.1

