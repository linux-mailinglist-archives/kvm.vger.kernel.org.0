Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11D8739363
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 01:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjFUX4p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 19:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbjFUX4G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 19:56:06 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237771BF7;
        Wed, 21 Jun 2023 16:56:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RDU9CqgLRnSat+0kpOXWxajenIa5E0UkUmZj7tAs/qlSeEM5egg4orf1whxdaeWn+PKVB3mjhIz9DDc6vQnDTCjjhZx+vYbA3KHzqigWuslNdUS7S431QoT7O121KLw6o1fLmYzpXrrxTlRXQg6TeNqFjPDWnqri9LtPy/EUEWxSZtGXCKrIRpS8AocWZvj+OZXLJ3sy+4ygT9acGRiYqLB++/Z7Qj6shf9nnbEbnAzbCVSCDrgHAgRwo8A1ixAFZxwPwzfu2kG+fHLDxcsYIdfrGiuS9Ya0Zxxjk4JOx8nRQXl0AZ6aumqkiYUDK6R0VuhlN09K+g1FP4API/DsZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aju7L6FAaEB7q7q5mybI04vPRz51MsXL4lyz1nHz12s=;
 b=bmluJ3C83ZgqvVnvs0H+stVclcR5c4pzgngubRq2gHYaFOZYPuRoPdTvuBhVJEMM5whqdoWp8Sh2LAqOigXFzUoOtN/mDGfwnxiNYfSGKaISYMiGLMOhlShQD/W9tUmwNslJweo277DxC8bdbJEXJqO1uavbiGP7TknTVEXYCnhMOjfv6IPPJD6/83741IEGawkx7phzWX1sl1d+C2G964+vOnpybYLUnMjn/g68kNrylJcKMppRcrNlZu6obidBwMLWchhS39gK3wcyCyAGEMgOuEopwuFazAZIrS66TUqbT7mc+AbNIErcMCc95lV1C5lMB2XTm5d3T+w5oymlUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aju7L6FAaEB7q7q5mybI04vPRz51MsXL4lyz1nHz12s=;
 b=HKCzeK5fiIA79UjlNIU5SUBw5R1wR2wKLWfjU4Mkd6ElEV9MtBmMwLJfJQILRgr+GD9jA9p7nGiW7XQRC3g7uPhJDV7E3XRAFCcPzvhPxnjBSIn19/GUoN1dznFLXcWn1623Wi486XFCyk7R7OahvqWqczm5Ie0BOfgpQHfGSGg=
Received: from CY5PR15CA0034.namprd15.prod.outlook.com (2603:10b6:930:1b::15)
 by MN2PR12MB4285.namprd12.prod.outlook.com (2603:10b6:208:1d7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Wed, 21 Jun
 2023 23:55:56 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:930:1b:cafe::f6) by CY5PR15CA0034.outlook.office365.com
 (2603:10b6:930:1b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24 via Frontend
 Transport; Wed, 21 Jun 2023 23:55:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D4.mail.protection.outlook.com (10.167.241.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6521.21 via Frontend Transport; Wed, 21 Jun 2023 23:55:56 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 21 Jun
 2023 18:55:54 -0500
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
Subject: [RFC PATCH 13/21] iommu/amd: Introduce vIOMMU command-line option
Date:   Wed, 21 Jun 2023 18:55:00 -0500
Message-ID: <20230621235508.113949-14-suravee.suthikulpanit@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|MN2PR12MB4285:EE_
X-MS-Office365-Filtering-Correlation-Id: 906e513c-5a50-4fcc-3e1e-08db72b30e17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UxT0EgDSsKp73JKt7WUKZiCC9+5VYYCi7DU2nj0yRuGhfcf0OeH46GY+8Q7EyoJx7HEJwwFbe3ye9bkhmShx4E1UaqyKPVtQcvAAUEAhyVPXKAgKR8lJ4ZegvdIlpRa4wtePJO7fytDTqNKuRslLs3TxHZQeHw3J3rxeGpcWKiXlpjAO6TavR6ziCvDT120ajXatSiqPPxt/k4fhSuDkY+EYoaNmgiojIie0Ok4uJGG1S7O6vmxabjVHHOLjoDtxxUTzqGTrNxUDQT7nHSfbYsR0O+DGQNxB2wItVJDMFnP1CKaD85velbA13XM1g6UjxmTUXkHLnT0d5crSa7WBH4PKbAvYeorLO2wi25gqTV+P3TK2qumIp/FeCbj4iAyobH6N7Rfms0LbaqvcdTZsoK1uDKUq6abs+LrAryfsxoayAbcgTyNUtza/XTjqoesNFcGi7y322WJV9nELih+ubshZtiDtlLUyBldYZzHF1TASZkEBvwtDPefL/p16Y0vlN9AwTrT3gZs+XrckrxMl8CAtxy+Y8apexBQ45H7EPxo51Q8lMrcaMdQHnrcMQSkXQYDBPrA43SL6gLmOasBelFeKb/yFGHy6Duxw7xLMQIKMyQOdBrK5FpbWXQEwkRKQ+WRuphc3xTgsDascfAzpt5j4HbwnoNDmhq+DA6OLXB8EICFq6b7UtZ8QiHPDUwM8p/UJiGzNdPGJ7oZsHYyLAM2djIWvdYfLJwEafWT8XDYJ3Laiw4gcker7by2JYh0JA8MiRK0VCegvC9FShJSWjw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199021)(40470700004)(36840700001)(46966006)(6666004)(478600001)(54906003)(110136005)(4326008)(47076005)(40480700001)(336012)(426003)(83380400001)(2616005)(86362001)(36756003)(36860700001)(40460700003)(2906002)(70586007)(82310400005)(16526019)(186003)(7696005)(1076003)(26005)(356005)(82740400003)(81166007)(70206006)(41300700001)(8936002)(8676002)(316002)(5660300002)(7416002)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 23:55:56.3080
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 906e513c-5a50-4fcc-3e1e-08db72b30e17
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4285
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

To disable vIOMMU feature, specify option "amd_iommu=viommu_disable".

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd/amd_iommu.h       |  2 ++
 drivers/iommu/amd/amd_iommu_types.h |  1 +
 drivers/iommu/amd/init.c            | 10 ++++++++++
 3 files changed, 13 insertions(+)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index c9dfa4734801..a65d22384ab8 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -46,6 +46,8 @@ void amd_iommu_debugfs_setup(struct amd_iommu *iommu);
 static inline void amd_iommu_debugfs_setup(struct amd_iommu *iommu) {}
 #endif
 
+extern bool amd_iommu_viommu;
+
 /* Needed for interrupt remapping */
 extern int amd_iommu_prepare(void);
 extern int amd_iommu_enable(void);
diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index aa16a7079b5c..019a9182df87 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -96,6 +96,7 @@
 #define FEATURE_GAM_VAPIC	(1ULL<<21)
 #define FEATURE_GIOSUP		(1ULL<<48)
 #define FEATURE_EPHSUP		(1ULL<<50)
+#define FEATURE_VIOMMU		(1ULL<<55)
 #define FEATURE_SNP		(1ULL<<63)
 
 #define FEATURE_GATS_5LEVEL	1ULL
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 6a045a187971..4dd9f09e16c4 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -194,6 +194,9 @@ bool amdr_ivrs_remap_support __read_mostly;
 
 bool amd_iommu_force_isolation __read_mostly;
 
+/* VIOMMU enabling flag */
+bool amd_iommu_viommu = true;
+
 /*
  * AMD IOMMU allows up to 2^16 different protection domains. This is a bitmap
  * to know which ones are already in use.
@@ -2154,6 +2157,9 @@ static void print_iommu_info(void)
 			if (iommu->features & FEATURE_SNP)
 				pr_cont(" SNP");
 
+			if (iommu->features & FEATURE_VIOMMU)
+				pr_cont(" vIOMMU");
+
 			pr_cont("\n");
 		}
 	}
@@ -2166,6 +2172,8 @@ static void print_iommu_info(void)
 		pr_info("V2 page table enabled (Paging mode : %d level)\n",
 			amd_iommu_gpt_level);
 	}
+	if (amd_iommu_viommu)
+		pr_info("AMD-Vi: vIOMMU enabled\n");
 }
 
 static int __init amd_iommu_init_pci(void)
@@ -3402,6 +3410,8 @@ static int __init parse_amd_iommu_options(char *str)
 			amd_iommu_pgtable = AMD_IOMMU_V1;
 		} else if (strncmp(str, "pgtbl_v2", 8) == 0) {
 			amd_iommu_pgtable = AMD_IOMMU_V2;
+		} else if (strncmp(str, "viommu_disable", 14) == 0) {
+			amd_iommu_viommu = false;
 		} else {
 			pr_notice("Unknown option - '%s'\n", str);
 		}
-- 
2.34.1

