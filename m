Return-Path: <kvm+bounces-5367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7273C820774
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:33:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 285CC28244C
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A2FDBE67;
	Sat, 30 Dec 2023 16:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dxcK5gDo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C109616412;
	Sat, 30 Dec 2023 16:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ICc76jn6MrQxcOh+Vxrc8NlzIIg1grm3UyML3/pWMlFudXkBfyHk3aqpTcsbPCYCFbppB7ciy3Sa4YSmEhMqXGBx+p3l52c/Zep5h+wxvGvSomG6PdHl1fuhM+7ehyDMClzkLMVgYYpoE3TzjcMSqBKDQHOsUuTz1ICDwlbtc8ohGxwBNLO6+N4GRTuzceyPGULqWapbmS9RCmAtDUc67MDvrvhDzbLyOeErzHr/sYIh6UH4aDpNHikW/6AHaTKoyQQKTLMWvpXYz6bpH3xiFE79UdgLTT6IhIOzfz4ZiR52HS3bBWqgRm/F3ebYdBp9494Q+QwTM/4nIEoJpdMpDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XNTycqLWVTdQiyWtYzX7nv+9EhEAY+mXjSy4btD/JWQ=;
 b=nnhJStP8p1MyAPzj5JARTklFenTP2y9VlaxtaKYwLGd5iW/wvUDF8LIiZI5UQQfv1S4GCExMuBRBU9+YgcVwFoaDcm3jXO+qwSTOio2c/+O49y4ervri9onkC0e2BpisYWnGUvKLNIy7GIZ1ZjUM2tBWBGOwl7rwXF8h3E3/Rq3lwhB6IZZ+NDq+A93+RH+Q1fzDolQsx9eWeaTx9wnm8jwvXe7VlBDttgP/QrtqLTxtGXZ8P8yZTPZfuQb/ND7CcICgtVwU/2y1ZVX/gnbP7gXKwjfKkJfAQN7SSH+w/3LepwBptYBxyBMPBGJz3nNTiKyvNcKl9alV+8e9Hok3AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNTycqLWVTdQiyWtYzX7nv+9EhEAY+mXjSy4btD/JWQ=;
 b=dxcK5gDoCpn0PWREtZlzoV6Xtjy/0TsT33tHo2fD/I2GfgI6eYhpGPgcAdlNMb+KO7gS6w4NTQWXJQ6HzzUNHqrQGT+tK3eyFQqOqgvqFaHuwpmcbcP/l6rSG9/wYyOwgg4XwZg3c3Wt8OMEuCQjuNl21ON9dX5Pp7RqNSZxVSo=
Received: from DM5PR07CA0062.namprd07.prod.outlook.com (2603:10b6:4:ad::27) by
 PH8PR12MB7349.namprd12.prod.outlook.com (2603:10b6:510:217::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 16:29:49 +0000
Received: from SN1PEPF0002BA51.namprd03.prod.outlook.com
 (2603:10b6:4:ad:cafe::98) by DM5PR07CA0062.outlook.office365.com
 (2603:10b6:4:ad::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.21 via Frontend
 Transport; Sat, 30 Dec 2023 16:29:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA51.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:29:49 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:29:44 -0600
From: Michael Roth <michael.roth@amd.com>
To: <x86@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v1 03/26] iommu/amd: Don't rely on external callers to enable IOMMU SNP support
Date: Sat, 30 Dec 2023 10:19:31 -0600
Message-ID: <20231230161954.569267-4-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230161954.569267-1-michael.roth@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA51:EE_|PH8PR12MB7349:EE_
X-MS-Office365-Filtering-Correlation-Id: 0486a6ab-0105-4b84-74ba-08dc09548aeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cGaAG1iawuS/qL2BkgOScQy2xmdEo7hVs3iKawzZ3q3qL09wTVYhP1wgsEFtjQO9wAwM3nx5zKbHveBUMc7v6UjxxUY2fdByziqJf17hHOQlQLS42hZxqsu3kVg3pXi2f0fYIW4S/r3zd+P7Z1LAQPElHRgKhxiEJiEVFGbKgrVb6qmYLrKYp41FeGnPap9GSIdzgmJfUDenTjvJh6HfJcGqBQ7Sq7AHus05Y9MXxawhZrbeKPIC4odn1+y8WvKJ77OhUX7xlTuxV45fipZoyeRGp5m0/lLpuJc+scFNBI0i5JzgoU6MMplHQ8Mi119m10MBDSksok1DmrG/1TOxzk3eTl6dAzOwRMWseITDnnJfRcEgjxRRj5C6jsMa/TKokSfzPI48gme7Olt6fH4uP3gwqTRAfylOeM7u87LJAcgMRcgYIe27kdICVjGzyYtFrKSaf3gqWLh5If+/2UVNv9affE2ZxHCTvv6XFeegsNcYRrDzcIwZ9Xgf1qMvylbyeJ4MBjHUhajXKPwByyPRhLhLLsB3ajZOQmYWP5KR1pYSD7gQtLaXqsvbz4PwO8V7tNTF+yZ0furCD7MjFpm09uJDumTz44vGYkZh3fGUjkKqRkQTGaw28wLUKH7Fh2ej+bSXJwiqhdBVmk9cJG4v5EBSj1t35CSFUIc8fzDtSWyBpci4+zrWjKkPiDR8NBxC5MGNq/X8Be7yWJ+53I1ptvwh4FyRidG5I3pfdRj2wFdh7jgSNZ5IVFSaihuTZ4fQLZnxzqrdWqJFqeJK90gR6w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(396003)(346002)(376002)(230922051799003)(64100799003)(82310400011)(186009)(1800799012)(451199024)(40470700004)(36840700001)(46966006)(40460700003)(40480700001)(16526019)(426003)(336012)(26005)(83380400001)(1076003)(86362001)(36756003)(81166007)(356005)(82740400003)(47076005)(4326008)(7406005)(44832011)(5660300002)(7416002)(2616005)(36860700001)(6666004)(54906003)(8936002)(70206006)(70586007)(8676002)(316002)(6916009)(2906002)(41300700001)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:29:49.1732
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0486a6ab-0105-4b84-74ba-08dc09548aeb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA51.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7349

From: Ashish Kalra <ashish.kalra@amd.com>

Currently the expectation is that the kernel will call
amd_iommu_snp_enable() to perform various checks and set the
amd_iommu_snp_en flag that the IOMMU uses to adjust its setup routines
to account for additional requirements on hosts where SNP is enabled.

This is somewhat fragile as it relies on this call being done prior to
IOMMU setup. It is more robust to just do this automatically as part of
IOMMU initialization, so rework the code accordingly.

There is still a need to export information about whether or not the
IOMMU is configured in a manner compatible with SNP, so relocate the
existing amd_iommu_snp_en flag so it can be used to convey that
information in place of the return code that was previously provided by
calls to amd_iommu_snp_enable().

While here, also adjust the kernel messages related to IOMMU SNP
enablement for consistency/grammar/clarity.

Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/iommu.h  |  1 +
 drivers/iommu/amd/amd_iommu.h |  1 -
 drivers/iommu/amd/init.c      | 69 ++++++++++++++++-------------------
 include/linux/amd-iommu.h     |  4 --
 4 files changed, 32 insertions(+), 43 deletions(-)

diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
index 2fd52b65deac..3be2451e7bc8 100644
--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -10,6 +10,7 @@ extern int force_iommu, no_iommu;
 extern int iommu_detected;
 extern int iommu_merge;
 extern int panic_on_overflow;
+extern bool amd_iommu_snp_en;
 
 #ifdef CONFIG_SWIOTLB
 extern bool x86_swiotlb_enable;
diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 8b3601f285fd..c970eae2313d 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -164,5 +164,4 @@ void amd_iommu_domain_set_pgtable(struct protection_domain *domain,
 				  u64 *root, int mode);
 struct dev_table_entry *get_dev_table(struct amd_iommu *iommu);
 
-extern bool amd_iommu_snp_en;
 #endif
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index c83bd0c2a1c9..96a1a7fed470 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3221,6 +3221,36 @@ static bool __init detect_ivrs(void)
 	return true;
 }
 
+static void iommu_snp_enable(void)
+{
+#ifdef CONFIG_KVM_AMD_SEV
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return;
+	/*
+	 * The SNP support requires that IOMMU must be enabled, and is
+	 * not configured in the passthrough mode.
+	 */
+	if (no_iommu || iommu_default_passthrough()) {
+		pr_err("SNP: IOMMU is disabled or configured in passthrough mode, SNP cannot be supported.\n");
+		return;
+	}
+
+	amd_iommu_snp_en = check_feature(FEATURE_SNP);
+	if (!amd_iommu_snp_en) {
+		pr_err("SNP: IOMMU SNP feature is not enabled, SNP cannot be supported.\n");
+		return;
+	}
+
+	pr_info("IOMMU SNP support is enabled.\n");
+
+	/* Enforce IOMMU v1 pagetable when SNP is enabled. */
+	if (amd_iommu_pgtable != AMD_IOMMU_V1) {
+		pr_warn("Forcing use of AMD IOMMU v1 page table due to SNP.\n");
+		amd_iommu_pgtable = AMD_IOMMU_V1;
+	}
+#endif
+}
+
 /****************************************************************************
  *
  * AMD IOMMU Initialization State Machine
@@ -3256,6 +3286,7 @@ static int __init state_next(void)
 		break;
 	case IOMMU_ENABLED:
 		register_syscore_ops(&amd_iommu_syscore_ops);
+		iommu_snp_enable();
 		ret = amd_iommu_init_pci();
 		init_state = ret ? IOMMU_INIT_ERROR : IOMMU_PCI_INIT;
 		break;
@@ -3766,41 +3797,3 @@ int amd_iommu_pc_set_reg(struct amd_iommu *iommu, u8 bank, u8 cntr, u8 fxn, u64
 
 	return iommu_pc_get_set_reg(iommu, bank, cntr, fxn, value, true);
 }
-
-#ifdef CONFIG_AMD_MEM_ENCRYPT
-int amd_iommu_snp_enable(void)
-{
-	/*
-	 * The SNP support requires that IOMMU must be enabled, and is
-	 * not configured in the passthrough mode.
-	 */
-	if (no_iommu || iommu_default_passthrough()) {
-		pr_err("SNP: IOMMU is disabled or configured in passthrough mode, SNP cannot be supported");
-		return -EINVAL;
-	}
-
-	/*
-	 * Prevent enabling SNP after IOMMU_ENABLED state because this process
-	 * affect how IOMMU driver sets up data structures and configures
-	 * IOMMU hardware.
-	 */
-	if (init_state > IOMMU_ENABLED) {
-		pr_err("SNP: Too late to enable SNP for IOMMU.\n");
-		return -EINVAL;
-	}
-
-	amd_iommu_snp_en = check_feature(FEATURE_SNP);
-	if (!amd_iommu_snp_en)
-		return -EINVAL;
-
-	pr_info("SNP enabled\n");
-
-	/* Enforce IOMMU v1 pagetable when SNP is enabled. */
-	if (amd_iommu_pgtable != AMD_IOMMU_V1) {
-		pr_warn("Force to using AMD IOMMU v1 page table due to SNP\n");
-		amd_iommu_pgtable = AMD_IOMMU_V1;
-	}
-
-	return 0;
-}
-#endif
diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
index dc7ed2f46886..7365be00a795 100644
--- a/include/linux/amd-iommu.h
+++ b/include/linux/amd-iommu.h
@@ -85,8 +85,4 @@ int amd_iommu_pc_get_reg(struct amd_iommu *iommu, u8 bank, u8 cntr, u8 fxn,
 		u64 *value);
 struct amd_iommu *get_amd_iommu(unsigned int idx);
 
-#ifdef CONFIG_AMD_MEM_ENCRYPT
-int amd_iommu_snp_enable(void);
-#endif
-
 #endif /* _ASM_X86_AMD_IOMMU_H */
-- 
2.25.1


