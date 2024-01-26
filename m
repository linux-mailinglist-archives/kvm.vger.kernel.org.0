Return-Path: <kvm+bounces-7071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E15583D3BA
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:49:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34B3528A834
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:49:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9620611701;
	Fri, 26 Jan 2024 04:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tT6aYyvF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3CA14286;
	Fri, 26 Jan 2024 04:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706244449; cv=fail; b=h7GBuG2Hfrqen79u9drT6TjYph7w+//tR8cWTH3kWqqI413kS8PV0/ptV4bS/aob9Ro5UqbtfTQg5FFVU1UwbHu9+JFsl1YJnsOTwVY1DoPQ04KqgwZuSGM4SfFXysHR6QwexWwEiB8kASw2xOUc6Xdj+GTguWJu4GFGUgrtZbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706244449; c=relaxed/simple;
	bh=FEBkCvDTVqpmwe28vX81GS+793UVHWDFXoV3nW49ObI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=REXUIGdYL+Qb3FJF41tknTSm5yVDpbVn6DNhATmI+m5SE8vtdi5MwA59sgY77vbBfVgIf2mFqi01PZPkqISSbHrW1am2Zvkq4Sa3TOnVT3ONQU3uUXhcrRS2e8OOjEe+REO0rJHajhSETjJzNWeINZB4JabUtGhQzU8ezkz++NA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tT6aYyvF; arc=fail smtp.client-ip=40.107.237.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ceoRQrq+IgLVVDpLxXpGqbP2qWiAqQJZRjBXkcDuGHZIsbbOwTQe5oQ5lsgLYMUaiMhmC3zbalTmLmfXJ6p36kW5GGhC42LPOrXBmKDDP4SqHOWIuddiwBbGgjQY3UpIE0tiA84noJSpTA+a6wgXCR89zWEAnrH2YWbE9uxxIHJws097AIVCwIprjE0yc6ROTeLAvn7BPw5hMWp+AWMHx2uuYOKU1hUtYL7Dz9242SgsOKT+qhpvNyatQfSrA8YxB9gOxQ1xAX+IdP7kdqD8kQTnKQ3eyhiu6jTeV7xhVLGtVCOTg18nucC9CV3tZSSwT6U7k41b+BqrXsBaM7lzig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NBek176QqoHkHFTnqUlqsPM+BztDxiraqcjGfbpN8I0=;
 b=e9FqhDffu3LV9vRMBDFdI+FCKQPPaHIrTSgfOQDiLEm8azQgTsSWUnR29rlnZ9KJNfvN3uTd3g2MjMg2obMjDMCy7aRF9TdRAuluKw28wwDdaCv1cXQzE5D0CWc9BfVJMxz11spbbFl8YMWRq5VInYAmah1VWah3dzVshIV+L4wNkh5XfGC6gvkh5ANJLMvpcRJReyKlFljRQ9CK9O//+xIuu0f0RLBqT6AEeTDECMzaVBfwM7tQZcTsQxArlK6Qiqz1gdy23huxz2ZabHkuXQggvUTn1hCkPJvnMOjzDR89ODEmk2S2CQ9fUAd02V/FUUYvkkM6OqaJfgUa2uH8ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NBek176QqoHkHFTnqUlqsPM+BztDxiraqcjGfbpN8I0=;
 b=tT6aYyvFZIPmWVEX7yoNV/udFFop7tAqdIBEj7/rDOQQ1GYu62/md7mXYdgxL5c0m8P5G549nA4AS1cOrfCrWm75ZQHFdjE1mOJN3ZkcdNbxKRBZjloqZD3Upk4w8B//zKo5we/TvsiRCrvj0ceODnv5k3SC5glC62qThXT7YM4=
Received: from DM6PR02CA0145.namprd02.prod.outlook.com (2603:10b6:5:332::12)
 by CH3PR12MB8852.namprd12.prod.outlook.com (2603:10b6:610:17d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Fri, 26 Jan
 2024 04:47:25 +0000
Received: from DS2PEPF0000343E.namprd02.prod.outlook.com
 (2603:10b6:5:332:cafe::7a) by DM6PR02CA0145.outlook.office365.com
 (2603:10b6:5:332::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27 via Frontend
 Transport; Fri, 26 Jan 2024 04:47:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343E.mail.protection.outlook.com (10.167.18.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 04:47:25 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:47:24 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v2 03/25] iommu/amd: Don't rely on external callers to enable IOMMU SNP support
Date: Thu, 25 Jan 2024 22:11:03 -0600
Message-ID: <20240126041126.1927228-4-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240126041126.1927228-1-michael.roth@amd.com>
References: <20240126041126.1927228-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343E:EE_|CH3PR12MB8852:EE_
X-MS-Office365-Filtering-Correlation-Id: 07423e29-4b92-4799-7cb8-08dc1e29e47f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	l9wmNHlYa0mNiXk1c/w2oBNPwghxyOcOYuUY/vTjt4cDvVZtaDMtbHcbk8k+ZlAT+jb1fLkw20kMbY5/PWQz9YsqA40108eDRRficOq2Wh7TEi0H1fg5JvBThKAp+8KUzaPZh2Pd6mVl/FZQlHDXRxIr3/wRqgATuw4yMPvUew8w72PQowGjLyfnQjYq0D6F8aFrFl7eEsrGxrZS9qMYTqT7rsNT6w1FH9siXejLGhQee3qma/i0AdLPjm3bhu5p3PYFOG1VCwi0W0etmeQe/sPSYY54czCLtF8V1Q5+p9tg7sB97L1TWxSoubR8pyDBe89mZMALk9xz1OH9IVwloVSePkQdn+OvMLRoRakxqgunBbn3AjkHM0acxCAixoBzphUxeYjJ1Ce/BWc/gff4vtmcNAUlVELUhstAtzhAm4z7nQ0ms0QqDKajb9a9gf2VBfuZbfHE2Bg29k1hTruxpS3WPzJAI+UqvXKgwhlAPQBSp/aa28eyHUDPZzZ14FvCUwmdCZYJReknACfYY5gEg/62/YyYjuSFmFAmqWBEzADWCbBzzp6CxlIjd4hlw8qDiE0vfuLFwHu9T6M2FKNSYVh8OTtwWUbqb4TPz7tN8YX0von70WiF6wJprGV6G6Ja1vqnlhYjcS3PdQK3LqWi995vQLafJxfzMrI/wn2N+JFbw7LJYB6luY029n0VnNDgVApgxO6tF1OTXwSik30YV+xzBVC1d3xr1pJSlWT4qd1bn7lZcBvTOJQeCLMEdPiVQS3atMc5bSTjfufAfHUNjA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(376002)(136003)(39860400002)(230922051799003)(82310400011)(451199024)(186009)(1800799012)(64100799003)(36840700001)(46966006)(40470700004)(40460700003)(40480700001)(41300700001)(83380400001)(86362001)(36756003)(82740400003)(356005)(81166007)(36860700001)(44832011)(47076005)(1076003)(26005)(2616005)(16526019)(426003)(336012)(2906002)(478600001)(70206006)(6666004)(6916009)(70586007)(316002)(54906003)(4326008)(5660300002)(8676002)(7416002)(8936002)(7406005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:47:25.5039
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07423e29-4b92-4799-7cb8-08dc1e29e47f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8852

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
Acked-by: Joerg Roedel <jroedel@suse.de>
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
index c83bd0c2a1c9..3a4eeb26d515 100644
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
+		pr_err("SNP: IOMMU disabled or configured in passthrough mode, SNP cannot be supported.\n");
+		return;
+	}
+
+	amd_iommu_snp_en = check_feature(FEATURE_SNP);
+	if (!amd_iommu_snp_en) {
+		pr_err("SNP: IOMMU SNP feature not enabled, SNP cannot be supported.\n");
+		return;
+	}
+
+	pr_info("IOMMU SNP support enabled.\n");
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


