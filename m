Return-Path: <kvm+bounces-7052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C43683D381
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:41:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E722E1F23601
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:41:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3308B676;
	Fri, 26 Jan 2024 04:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="moVU9MZI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2087.outbound.protection.outlook.com [40.107.237.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B404D510;
	Fri, 26 Jan 2024 04:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706244049; cv=fail; b=g6lx3oMgCXqcKAC+FtB5C5pqIN5GtWXskoxl9ITFscwwfVNFxZTHgfSLPea21kvHUG8/NyUGBSw5P3+j5MHPXE6Otb1MHnpinnh9K0zpN+su1o7iVAupY/Ija82UhSPna/tgkgk3Zkxi18yVG3ItkJySZ+0bSGKEsJ7BSgl7M+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706244049; c=relaxed/simple;
	bh=xOyI4cQWpozeRQAinbpiJ/P+FjZu5fdOtIOMxMa4fDY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gD3y9/gEkgnGG5MnUlXWAzVzgn7WjqNKmj15agk5sCzVivLpSf82FK8JLLpyq2BmGWAwIQnnEjF2VoBq6tOkCLITmB87cDRpebyP1+lfkGtrfVJl5tDtegqsGhI+QKz77NqWUfYZ9kijq1V5rC56fG0OC8IACJyg5M2ZDV5VQfY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=moVU9MZI; arc=fail smtp.client-ip=40.107.237.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VeZrnm2e1PW48zb3oGKYqTbeBzD2zCTHbKb8kXo/mxBgEFow+yQP2g47MZ/oIEyooLTIKtITkjLsBVc2TCfpa4nSOZK1VoIH4Ayc/GUksMD0IINfR1GQnnPHcghUrWBSK46cGABSAzZwixYy4ShKWbcPqpYiH6TdcWdDGpmqehs0cg/Eowe/zSJaExRbipgQTi8QJjx+5Wd82USyTnEquxhh6qP/LP/3i8Wkgged0mO+btFOvJSfSgS19ZlfTo2ykvdVnWJYQ9rv1VwmSc0hCsHmhf48fGxaPGKRVsVusFe0l9T300Xq7Hw6pwZsvYUqqClnsq1DHkZUytCqYS6J/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5kiZwN/er7VREe8gy2nnlht7qc4XPTgKknA5h/Y9v8k=;
 b=ZpHer7G8Ruaqy39EaHpBXUeXNcW3FDIdM3Dk3A2I9gyoL8n2KpOHdQ+Hcw5zN5qfV+AmJm9z5vqdNpZzKMFHcLnpW5WV8qE3Nd7o7Rs0artCeRBVIUEw6GR5LPnG8z+SkytTQW5opnggBOGBl3l8fFJ6lhEyzJAEJIiHSLbvVnnYPqMxYT8eMpnV01CKEBA4KNUTzZ2spASBhfpJkHETolci40Adk3cMUO/Zaq2p/ubyezgmsMf5DdUGrieiH5+3EPyk+oo29jRpzAWOuPv6FXeR83MILhgLFaT2bZLpsnG3axmryE0hyw3o2nKlwE4A/MzrKPs+S/x8VT5oEtM+lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5kiZwN/er7VREe8gy2nnlht7qc4XPTgKknA5h/Y9v8k=;
 b=moVU9MZIEPloTUJXqQONJrCUv+0Cw36CAG6mHvA8kOjihXtLloY+2jKWiNQfskwrcPbk70qMG0lfM5rCCJLmgPWHDeBqM0NTlOeJKBxFpHcp+2o9CBVCiu/9CVDiblkeXaYYjCooYxaqUequUqg0WgutiAOJQdwL6MBeqnG7tGU=
Received: from BYAPR07CA0032.namprd07.prod.outlook.com (2603:10b6:a02:bc::45)
 by DM4PR12MB5344.namprd12.prod.outlook.com (2603:10b6:5:39a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26; Fri, 26 Jan
 2024 04:40:45 +0000
Received: from MWH0EPF000971E6.namprd02.prod.outlook.com
 (2603:10b6:a02:bc:cafe::46) by BYAPR07CA0032.outlook.office365.com
 (2603:10b6:a02:bc::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.37 via Frontend
 Transport; Fri, 26 Jan 2024 04:40:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000971E6.mail.protection.outlook.com (10.167.243.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 04:40:44 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:40:43 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v2 10/25] x86/sev: Add helper functions for RMPUPDATE and PSMASH instruction
Date: Thu, 25 Jan 2024 22:11:10 -0600
Message-ID: <20240126041126.1927228-11-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E6:EE_|DM4PR12MB5344:EE_
X-MS-Office365-Filtering-Correlation-Id: fa54b2f0-6fe3-4570-8bbf-08dc1e28f5ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WfJ1hAzRyglTd9I7ruhZxVOS5k4L25u9zbwuRLnd6NkdjdukB5XeeCayEROD8I3+6wLXMHRtP5MnM3lAZZoM58zVrVtg635HeR2k9flfOP005GgxjksLL3ObpbhJFYiPfMgmcpl3f93ooJ+F6B+tbtd70VjVvTW692/zaZdlAkmnqiVg5xl5KtUmZHpDmELpqeuHLsEUovauqfFakQsylFfmg9YLud8YV0XtwfW2l/sIsfTdDziQa1QbE7H7v40+398BOVAMTezVsVMJHDw4lEjcu4AF0wo9+/DvN38NEplgN9CDb/qyaPuVTx/E5Pifn5s+tESmKKyBMaAV0iT//WGvHALm0QVeuPwv9KWYubBmc2fM9nmdywMR4vUv+JrXl3vych13xqFBqi96rGZ0T9XRtf2CzcjPnzeLHYD1mB1NmX8rtc54m6rcsnYtrzMFOcCcZbNVTK8vyjF1KUYZKbgnXE2XCS/MgkbPPlo9rs+/iUe+h/w9zqVzmVGIOYREYziiKZ3fHxzYlpOZihVrRZaUsq5u6LOBCJix7NkRGr8fiflfsAbr5PbHsaA57AZI7yOUQN5+fqu9/DKBmdkwA0WUWBcztqpiTbVesQn526Dj+PnGYCkH8g0GQRBevDmkkmIBp6stCKSciDMco2al1f6GAYvtLtnjzTDQwiyZxPVTEGhnGHc9/jZXcBGEqCRhb6Nil0i+1ucQNtoP5fxp79Y9opwWiv4Gh7Yu2YjKT92FtUWhemGbGt8EAAJOdZPmVmVQneLWcpZGpDbGFJuxeQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(376002)(136003)(346002)(230922051799003)(64100799003)(186009)(451199024)(82310400011)(1800799012)(40470700004)(36840700001)(46966006)(47076005)(36860700001)(16526019)(8936002)(336012)(426003)(41300700001)(5660300002)(36756003)(83380400001)(478600001)(8676002)(4326008)(26005)(86362001)(70586007)(70206006)(44832011)(6916009)(54906003)(316002)(1076003)(2616005)(7406005)(2906002)(7416002)(6666004)(40460700003)(40480700001)(356005)(81166007)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:40:44.7547
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa54b2f0-6fe3-4570-8bbf-08dc1e28f5ab
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5344

From: Brijesh Singh <brijesh.singh@amd.com>

The RMPUPDATE instruction updates the access restrictions for a page via
its corresponding entry in the RMP Table. The hypervisor will use the
instruction to enforce various access restrictions on pages used for
confidential guests and other specialized functionality. See APM3 for
details on the instruction operations.

The PSMASH instruction expands a 2MB RMP entry in the RMP table into a
corresponding set of contiguous 4KB RMP entries while retaining the
state of the validated bit from the original 2MB RMP entry. The
hypervisor will use this instruction in cases where it needs to re-map a
page as 4K rather than 2MB in a guest's nested page table.

Add helpers to make use of these instructions.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: add RMPUPDATE retry logic for transient FAIL_OVERLAP errors]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev.h | 23 ++++++++++
 arch/x86/virt/svm/sev.c    | 92 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 115 insertions(+)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 2c53e3de0b71..d3ccb7a0c7e9 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -87,10 +87,23 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
 /* Software defined (when rFlags.CF = 1) */
 #define PVALIDATE_FAIL_NOUPDATE		255
 
+/* RMUPDATE detected 4K page and 2MB page overlap. */
+#define RMPUPDATE_FAIL_OVERLAP		4
+
 /* RMP page size */
 #define RMP_PG_SIZE_4K			0
 #define RMP_PG_SIZE_2M			1
 #define RMP_TO_PG_LEVEL(level)		(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
+#define PG_LEVEL_TO_RMP(level)		(((level) == PG_LEVEL_4K) ? RMP_PG_SIZE_4K : RMP_PG_SIZE_2M)
+
+struct rmp_state {
+	u64 gpa;
+	u8 assigned;
+	u8 pagesize;
+	u8 immutable;
+	u8 rsvd;
+	u32 asid;
+} __packed;
 
 #define RMPADJUST_VMSA_PAGE_BIT		BIT(16)
 
@@ -248,10 +261,20 @@ static inline u64 sev_get_status(void) { return 0; }
 bool snp_probe_rmptable_info(void);
 int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level);
 void snp_dump_hva_rmpentry(unsigned long address);
+int psmash(u64 pfn);
+int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable);
+int rmp_make_shared(u64 pfn, enum pg_level level);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
 static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return -ENODEV; }
 static inline void snp_dump_hva_rmpentry(unsigned long address) {}
+static inline int psmash(u64 pfn) { return -ENODEV; }
+static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid,
+				   bool immutable)
+{
+	return -ENODEV;
+}
+static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
 #endif
 
 #endif
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index c74266e039b2..16b3d8139649 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -342,3 +342,95 @@ void snp_dump_hva_rmpentry(unsigned long hva)
 	paddr = PFN_PHYS(pte_pfn(*pte)) | (hva & ~page_level_mask(level));
 	dump_rmpentry(PHYS_PFN(paddr));
 }
+
+/*
+ * PSMASH a 2MB aligned page into 4K pages in the RMP table while preserving the
+ * Validated bit.
+ */
+int psmash(u64 pfn)
+{
+	unsigned long paddr = pfn << PAGE_SHIFT;
+	int ret;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return -ENODEV;
+
+	if (!pfn_valid(pfn))
+		return -EINVAL;
+
+	/* Binutils version 2.36 supports the PSMASH mnemonic. */
+	asm volatile(".byte 0xF3, 0x0F, 0x01, 0xFF"
+		      : "=a" (ret)
+		      : "a" (paddr)
+		      : "memory", "cc");
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(psmash);
+
+/*
+ * It is expected that those operations are seldom enough so that no mutual
+ * exclusion of updaters is needed and thus the overlap error condition below
+ * should happen very seldomly and would get resolved relatively quickly by
+ * the firmware.
+ *
+ * If not, one could consider introducing a mutex or so here to sync concurrent
+ * RMP updates and thus diminish the amount of cases where firmware needs to
+ * lock 2M ranges to protect against concurrent updates.
+ *
+ * The optimal solution would be range locking to avoid locking disjoint
+ * regions unnecessarily but there's no support for that yet.
+ */
+static int rmpupdate(u64 pfn, struct rmp_state *state)
+{
+	unsigned long paddr = pfn << PAGE_SHIFT;
+	int ret;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return -ENODEV;
+
+	do {
+		/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
+		asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
+			     : "=a" (ret)
+			     : "a" (paddr), "c" ((unsigned long)state)
+			     : "memory", "cc");
+	} while (ret == RMPUPDATE_FAIL_OVERLAP);
+
+	if (ret) {
+		pr_err("RMPUPDATE failed for PFN %llx, ret: %d\n", pfn, ret);
+		dump_rmpentry(pfn);
+		dump_stack();
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+/* Transition a page to guest-owned/private state in the RMP table. */
+int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable)
+{
+	struct rmp_state state;
+
+	memset(&state, 0, sizeof(state));
+	state.assigned = 1;
+	state.asid = asid;
+	state.immutable = immutable;
+	state.gpa = gpa;
+	state.pagesize = PG_LEVEL_TO_RMP(level);
+
+	return rmpupdate(pfn, &state);
+}
+EXPORT_SYMBOL_GPL(rmp_make_private);
+
+/* Transition a page to hypervisor-owned/shared state in the RMP table. */
+int rmp_make_shared(u64 pfn, enum pg_level level)
+{
+	struct rmp_state state;
+
+	memset(&state, 0, sizeof(state));
+	state.pagesize = PG_LEVEL_TO_RMP(level);
+
+	return rmpupdate(pfn, &state);
+}
+EXPORT_SYMBOL_GPL(rmp_make_shared);
-- 
2.25.1


