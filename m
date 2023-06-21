Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFA3739355
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 01:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbjFUX4H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 19:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjFUXz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 19:55:58 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB6919BD;
        Wed, 21 Jun 2023 16:55:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M3LVJ2yqU1aXUTHCcQgrOjNRLJ+zZbPG9P34N7WiO9vyRUyuj6vQuQDArKW9iQhKh5nuQevPcRxhMissYHpbZMKR6QyWTgyRs3MZ21G9XGRAR8hDGINW65/hs/CWYAn4p0V2i8n5EZlT+PQLj80VJW68gf33VJ5kGCkl2aKPSS/V22uFMcu64SbnF1n9bi0P3uS4zzJ7PCGa0M8pqzXpXMu8RZ7Y+8X66l1BhK9BeDb0UY9zbE3Eem9oshmgW1O+mrWQ9oe2hfl7EUKcZoq9+4/ojtW1VsuJ9V2dBD86Xj5tmrkDmScn7FEf8qBKa+qYRPnwhWf9Jw1KnYBdbMxQKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h9c1V23bWJTyTuJZVhIWQIcbksX0hPKqLTQpOJXmFuI=;
 b=YSGBmx7CEeJslVo02evsO3raheiPB1d5XcpEotG9B+n8BB4boQfQQmiTijrIU29l676zFfGe3YccdmX96Jj8M9BBJxp+erhlNoDzwqkDo5m0HzJCqW/A/UQk1X6GtOstIVuC10PqN0q7LaC6oovpG6HUXwcixfBF7550oyICYwiL/y77cyvrjwFI5n+GZkx4yg4+Hy1q7XC2D5AWM4SfdXfZFang0T6nadS4lM7/MLDvRRR3GeW4MqdI69PcUg841RXTVokIlNn2u075dSPtCnvl/xEohQUFe1sO4tRovRzX9Szn7uYSJ6q5J1s+eux/1kY+Ig6y7Nxi3lwECABjHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h9c1V23bWJTyTuJZVhIWQIcbksX0hPKqLTQpOJXmFuI=;
 b=Y8bE+0nLzbMB67Jep2o2nFTxii+5WFEcGW+q9fhpFq2DKp/NLzmOWv4OFRNVUNg7QNs9vfba3QUUoDXbQCxN4nUg4ztGY+ku6JFyux5Bh3kRckeZMyOSh8CHxtPKcgioN5Z7XPieOmV1dirATzxnVP2wgR/jvKGL1tSh4fxfOy0=
Received: from CY5PR15CA0033.namprd15.prod.outlook.com (2603:10b6:930:1b::24)
 by BY5PR12MB4163.namprd12.prod.outlook.com (2603:10b6:a03:202::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Wed, 21 Jun
 2023 23:55:52 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:930:1b:cafe::5f) by CY5PR15CA0033.outlook.office365.com
 (2603:10b6:930:1b::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23 via Frontend
 Transport; Wed, 21 Jun 2023 23:55:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D4.mail.protection.outlook.com (10.167.241.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6521.21 via Frontend Transport; Wed, 21 Jun 2023 23:55:52 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 21 Jun
 2023 18:55:50 -0500
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
Subject: [RFC PATCH 09/21] iommu/amd: Add support for hw_info for iommu capability query
Date:   Wed, 21 Jun 2023 18:54:56 -0500
Message-ID: <20230621235508.113949-10-suravee.suthikulpanit@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|BY5PR12MB4163:EE_
X-MS-Office365-Filtering-Correlation-Id: 9555c499-7111-4111-4358-08db72b30bd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SXdP8JRmtUCCodN7DF4QalKVNOFfxQ+icg6IrcJPCynEHNz4BBYDrEkJGO5GQj/768kgIrb5pdbJt+olgH0SPhhdHv13+K0gKBM7r5p5PK31Uqyl1STutqV08QcLxGwZZGqIPOM4huBqLMMPQZHVglHQjNN6TEPxv/Z9pfZYrLbE8pbUKhtAwCqBoAC34Yroa/h0kO03SYzyxU8AGwqnO/H30w13wx2QOXQnzCxk3Qep5hFRULKWh8PSmBetZlTj6a8UPs+yOfI7JrxgbQEeFRwVBfnLGv0uNgY+hti5dfUhv0E0p1/ZKeD+1v7ar3LctHqMHFVy7XW3azNGd6uh4aHrHCtQAaVXAWoNxsqPYk7xxM8lUPNeMYS7EzXeH+EhMF8u0PwinThm2oUlrUtdCQcu8tIGOLMHeZNxmTf3nCJk06wQJYScZX5mmepXRepvkeP0pgqxTAkpDiv/A4OTZ9eNQXfYVcG/rlHHp7YmlBqMqMKnHmKK9z6/9aQq5iLVyGsnUcLYcrsdTOHHRQkHzfDn1LyRdkUmNjqyRfpfXYe1upa6lpGGYzLflLoyu+Lp1PN5iC+AUh6nsLmfoJwoKdYPAP4xkf9wplbFeOEHGb4PCasEbDv+DuK4VnRD788HJ49PB6P9sw85nFxZ2mUNOvobxq/vXKaFzWblfpeIrEF5s5nlb48TKsk0+m+xsz4z4qW4LqMYGuAFkcVpRphN5IR/M7OHOjwrnnpqezqE+4yBHoHj9OQ2MiQTRKR2DD6W7Y4F6pEaTRDuFA8ByKoulg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199021)(40470700004)(46966006)(36840700001)(36860700001)(36756003)(82310400005)(40460700003)(81166007)(356005)(70206006)(5660300002)(44832011)(7416002)(41300700001)(8936002)(86362001)(4326008)(8676002)(316002)(40480700001)(82740400003)(70586007)(47076005)(426003)(26005)(1076003)(2616005)(16526019)(186003)(2906002)(7696005)(336012)(478600001)(110136005)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 23:55:52.5267
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9555c499-7111-4111-4358-08db72b30bd6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4163
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

AMD IOMMU Extended Feature(2) Register (EFR/EFR2) specifies features
supported by each IOMMU hardware instance. The IOMMU driver checks each
feature-specific bits before enabling each feature at run time.

For hardware-assisted vIOMMU, the hypervisor determines which IOMMU
features to supported in the guest, and communicates this information
to user-space (e.g. QEMU) via iommufd IOMMU_DEVICE_GET_HW_INFO ioctl.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd/amd_iommu.h       |  2 ++
 drivers/iommu/amd/amd_iommu_types.h |  3 +++
 drivers/iommu/amd/iommu.c           | 37 +++++++++++++++++++++++++++++
 include/uapi/linux/iommufd.h        | 11 +++++++++
 4 files changed, 53 insertions(+)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index d36a39796c2f..c9dfa4734801 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -84,6 +84,8 @@ extern int amd_iommu_domain_set_gcr3(struct iommu_domain *dom, u32 pasid,
 				     unsigned long cr3);
 extern int amd_iommu_domain_clear_gcr3(struct iommu_domain *dom, u32 pasid);
 
+extern void amd_iommu_build_efr(u64 *efr, u64 *efr2);
+
 #ifdef CONFIG_IRQ_REMAP
 extern int amd_iommu_create_irq_domain(struct amd_iommu *iommu);
 #else
diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 09df25779fe9..8830f511bee4 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -98,12 +98,15 @@
 #define FEATURE_EPHSUP		(1ULL<<50)
 #define FEATURE_SNP		(1ULL<<63)
 
+#define FEATURE_GATS_5LEVEL	1ULL
 #define FEATURE_GATS_SHIFT	12
 #define FEATURE_GATS_MASK	(0x03ULL << FEATURE_GATS_SHIFT)
 
+#define FEATURE_GLX_3LEVEL	0ULL
 #define FEATURE_GLX_SHIFT	14
 #define FEATURE_GLX_MASK	(0x03ULL << FEATURE_GLX_SHIFT)
 
+#define FEATURE_PASMAX_16	0xFULL
 #define FEATURE_PASMAX_SHIFT	32
 #define FEATURE_PASMAX_MASK	(0x1FULL << FEATURE_PASMAX_SHIFT)
 
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index c23f99ebdffc..4a42af85664e 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2435,8 +2435,45 @@ static bool amd_iommu_enforce_cache_coherency(struct iommu_domain *domain)
 	return true;
 }
 
+void amd_iommu_build_efr(u64 *efr, u64 *efr2)
+{
+	if (efr) {
+		*efr = (FEATURE_GT | FEATURE_GIOSUP);
+
+		/* 5-level v2 page table support */
+		*efr |= ((FEATURE_GATS_5LEVEL << FEATURE_GATS_SHIFT) &
+			 FEATURE_GATS_MASK);
+
+		/* 3-level GCR3 table support */
+		*efr |= ((FEATURE_GLX_3LEVEL << FEATURE_GLX_SHIFT) &
+			 FEATURE_GLX_MASK);
+
+		/* 16-bit PASMAX support */
+		*efr |= ((FEATURE_PASMAX_16 << FEATURE_PASMAX_SHIFT) &
+			 FEATURE_PASMAX_MASK);
+	}
+
+	if (efr2)
+		*efr2 = 0;
+}
+
+static void *amd_iommu_hw_info(struct device *dev, u32 *length)
+{
+	struct iommu_hw_info_amd *hwinfo;
+
+	hwinfo = kzalloc(sizeof(*hwinfo), GFP_KERNEL);
+	if (!hwinfo)
+		return ERR_PTR(-ENOMEM);
+
+	*length = sizeof(*hwinfo);
+
+	amd_iommu_build_efr(&hwinfo->efr, &hwinfo->efr2);
+	return hwinfo;
+}
+
 const struct iommu_ops amd_iommu_ops = {
 	.capable		= amd_iommu_capable,
+	.hw_info		= amd_iommu_hw_info,
 	.domain_alloc		= amd_iommu_domain_alloc,
 	.probe_device		= amd_iommu_probe_device,
 	.release_device		= amd_iommu_release_device,
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index ec870e2d32fd..f8ea9faf6770 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -508,6 +508,17 @@ struct iommu_hw_info_smmuv3 {
 	__u32 idr[6];
 };
 
+/**
+ * struct iommu_hw_info_amd - AMD IOMMU device info
+ *
+ * @efr : Value of AMD IOMMU Extended Feature Register (EFR)
+ * @efr2: Value of AMD IOMMU Extended Feature 2 Register (EFR2)
+ */
+struct iommu_hw_info_amd {
+	__u64 efr;
+	__u64 efr2;
+};
+
 /**
  * enum iommu_hw_info_type - IOMMU Hardware Info Types
  * @IOMMU_HW_INFO_TYPE_INTEL_VTD: Intel VT-d iommu info type
-- 
2.34.1

