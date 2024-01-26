Return-Path: <kvm+bounces-7075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EE3D83D3C6
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:51:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92DA11C23371
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:51:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C8C61759D;
	Fri, 26 Jan 2024 04:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uNwkMi+D"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2057.outbound.protection.outlook.com [40.107.212.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89456171A2;
	Fri, 26 Jan 2024 04:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706244534; cv=fail; b=enyxh4+J20Y+YX/mC91JVKS6UT8awR8bGI72Tl7mQZi8zL6h4kFqVs5geSAvAVHht8MnUXEFNSSgNoqyihUDXRMSiHJBIYVJ9ZlH5RI4eowpyOhoANCUUTKTGkPDiR1rPZZMkwVLQbmT2jCZd26K1hOWYGHbYXigygLK8mqWpg0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706244534; c=relaxed/simple;
	bh=s73tXNHFGjiNoi3Sfb/3fLEBfGhP4aCl+Gx507YJ8Lw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NlU/QmkL5xL6vx6cMcift5pVHDgDFHt0RlJQCan2lhu/BoZpLJBCBH5Eu+kU5TptSelWOjf3uR7QzrlmBTKjrv72nGCKv5E3WVklFE09BE20ea+ULU3Pj67f+kU99UDaYa5PA7IlAvPVNG5N6vsAMDMVNbCN9PdnnyRYeX3SgD4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uNwkMi+D; arc=fail smtp.client-ip=40.107.212.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S1POwzsHhno8drn/FXjHLl/L1T8OGoe/kifWwnR0ukQW5glBGDYM0PI9wwMhsnIcq1DMg4gcL2oF1M3Lxvedmg+UMqOwelOBvnsN0DM6tf5AjnUO45y1vaIs/HGlDAYaGgXM1xbCvKr5yflAnQ4E9Zg2uHV/mwZoHYH/ly6VgMu/YI42RDGZBYb6+YcAJEPb3tnx2rs4AykLXjNVEECWVgJiH2LLxZZT1h9oVkdtkgyfCpcvaQu1WL0f/JmZ1F9NBwLx3Ej0CiRNOHFDCBfP+WWHMusn1HWj1Bb2vylaD8s/JVHdQZL/JoHpo4sMmUQxzlurBGSKNmYDiDQFDzPvwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JBK8P9DZYAHFE8/v3KeAVGaPleccg4tTZLLxJ7l1gD4=;
 b=jXAnAzKGqVZJhRryPN9cIk/zpXjKnpVmjiW89M2gtl8zbOBGxVWtuDb9AbpnayrbLqWlw/9LXxbT1f9fBMFOTFBd235T58FhuL7vf//ZVHcG8ER7O1UVKa6jHuF979mJ5cslV5m6wgCdNy768/0lJ1MJlP4B47oJi2SA1HvAxUAskZDOg75XK+zwuRGL2KFmA3KMA4TXusWJBSIJ7TvUkbNITvxpXf924Xb4miGzNT+uKKywiijq4YHfS9MW3coPIRc1gm1UBEa7j+g43iyhA4yrzSsu0WaVo2LWoNc+k0a2DOIfUjpX74UCTNFmBmGoleklF+Jqhtj1cUOqfKieHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JBK8P9DZYAHFE8/v3KeAVGaPleccg4tTZLLxJ7l1gD4=;
 b=uNwkMi+DNNYTdvwFhNah8LpkcYzH/hWieIOF+elUJ0Q43LNhVQZKwlb+VQst+iuYT6Kfkeg1lu6rqJcrQGID26ozzZM3got1VA1pP/38GGq/pKSimruSox2nU4tY/3uvTg3R1j42eeB1TDlNgvjMFwri82mWC3/qXnlsnllEcr4=
Received: from DM6PR03CA0031.namprd03.prod.outlook.com (2603:10b6:5:40::44) by
 IA0PR12MB8422.namprd12.prod.outlook.com (2603:10b6:208:3de::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7228.24; Fri, 26 Jan 2024 04:48:49 +0000
Received: from DS2PEPF0000343B.namprd02.prod.outlook.com
 (2603:10b6:5:40:cafe::c) by DM6PR03CA0031.outlook.office365.com
 (2603:10b6:5:40::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.33 via Frontend
 Transport; Fri, 26 Jan 2024 04:48:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343B.mail.protection.outlook.com (10.167.18.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 04:48:49 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:48:48 -0600
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
Subject: [PATCH v2 07/25] x86/fault: Add helper for dumping RMP entries
Date: Thu, 25 Jan 2024 22:11:07 -0600
Message-ID: <20240126041126.1927228-8-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343B:EE_|IA0PR12MB8422:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a74fbb3-cc10-4ac6-f082-08dc1e2a1683
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	77W5NKw1K0s0M5MPCewhZZDELukIR19/JflObok4Q5xcHZjZH1lkLShKSY0btuNA//uGplIpW0V6zuVNmFiPb0C6cfAHqlg525V4W1GkwMPX/xI5lV+Ylc9f0XNSdGxhSwEwxFnByHlMaJWxu+UoHkedcdmTACCJmICbTJJiu4EcdfnN7Lp5/z4OjRqSlFBzNK0QJtJIEJUz5+flKlX4neSS6UIsmm3QzCyYEF5l1dsv7isFvM/2DQngw+K/VIBeK7SBeD8Sk0zbHMOePmdayGxYxAeCaWKPduHijshvQ4b3QbLJJthYVr5TrTxmg4dq0HQlRHxu1/1naKYxldVaJqrstxbNv0b/89n54MiH0D+cgw+ntxwbneAdET14GvU5gUpJa+pLXimQgh47yuIVu39lBMTvYz+7TJa8/Cg5jh9kxeoT3UaAWwRRDcydNZebnE3Xss+9De4aj70EV8ayHLICHtbzbNbUrRINbW7j8FykNaWtFZSfyaZtR/W8fK0CVK9Aoy/bC+S6cZ/YTps7IBFE/wOTRahmcW+olAPVrflInuKiNOdRbVs37geQck/2Ry54UqMVtOT0fmA+nO9dzeOF0uK/Jx/jksl5HDExwnBnuJXRw01Nq2hxmmG8sBcCg8qqIY83TbFtpFGS98ZA2yhkuLx/XI8HoOrHdMAPlpa2+nR4ZQbeo8vl1qGLHhkJaj27NkOwds7a5cC/exwcSXTIm3mmHVDGhmBpl3zHfayMDE7uuQ38qK3tEXaNCLkGJ4YY+21CBc7grB+FfaPBtQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(396003)(39860400002)(136003)(230922051799003)(451199024)(1800799012)(82310400011)(186009)(64100799003)(36840700001)(40470700004)(46966006)(41300700001)(83380400001)(336012)(426003)(26005)(1076003)(16526019)(8676002)(2616005)(82740400003)(36860700001)(81166007)(356005)(7406005)(4326008)(44832011)(8936002)(5660300002)(47076005)(316002)(478600001)(2906002)(6666004)(54906003)(7416002)(70206006)(6916009)(70586007)(36756003)(86362001)(40460700003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:48:49.4191
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a74fbb3-cc10-4ac6-f082-08dc1e2a1683
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8422

From: Brijesh Singh <brijesh.singh@amd.com>

This information will be useful for debugging things like page faults
due to RMP access violations and RMPUPDATE failures.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: move helper to standalone patch, rework dump logic as suggested by
      Boris ]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev.h |  2 +
 arch/x86/virt/svm/sev.c    | 99 ++++++++++++++++++++++++++++++++++----
 2 files changed, 91 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 01ce61b283a3..2c53e3de0b71 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -247,9 +247,11 @@ static inline u64 sev_get_status(void) { return 0; }
 #ifdef CONFIG_KVM_AMD_SEV
 bool snp_probe_rmptable_info(void);
 int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level);
+void snp_dump_hva_rmpentry(unsigned long address);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
 static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return -ENODEV; }
+static inline void snp_dump_hva_rmpentry(unsigned long address) {}
 #endif
 
 #endif
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 7669b2ff0ec7..c74266e039b2 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -35,16 +35,21 @@
  * Family 19h Model 01h, Rev B1 processor.
  */
 struct rmpentry {
-	u64	assigned	: 1,
-		pagesize	: 1,
-		immutable	: 1,
-		rsvd1		: 9,
-		gpa		: 39,
-		asid		: 10,
-		vmsa		: 1,
-		validated	: 1,
-		rsvd2		: 1;
-	u64 rsvd3;
+	union {
+		struct {
+			u64 assigned	: 1,
+			    pagesize	: 1,
+			    immutable	: 1,
+			    rsvd1	: 9,
+			    gpa		: 39,
+			    asid	: 10,
+			    vmsa	: 1,
+			    validated	: 1,
+			    rsvd2	: 1;
+		};
+		u64 lo;
+	};
+	u64 hi;
 } __packed;
 
 /*
@@ -263,3 +268,77 @@ int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
+
+/*
+ * Dump the raw RMP entry for a particular PFN. These bits are documented in the
+ * PPR for a particular CPU model and provide useful information about how a
+ * particular PFN is being utilized by the kernel/firmware at the time certain
+ * unexpected events occur, such as RMP faults.
+ */
+static void dump_rmpentry(u64 pfn)
+{
+	u64 pfn_i, pfn_end;
+	struct rmpentry *e;
+	int level;
+
+	e = __snp_lookup_rmpentry(pfn, &level);
+	if (IS_ERR(e)) {
+		pr_err("Failed to read RMP entry for PFN 0x%llx, error %ld\n",
+		       pfn, PTR_ERR(e));
+		return;
+	}
+
+	if (e->assigned) {
+		pr_info("PFN 0x%llx, RMP entry: [0x%016llx - 0x%016llx]\n",
+			pfn, e->lo, e->hi);
+		return;
+	}
+
+	/*
+	 * If the RMP entry for a particular PFN is not in an assigned state,
+	 * then it is sometimes useful to get an idea of whether or not any RMP
+	 * entries for other PFNs within the same 2MB region are assigned, since
+	 * those too can affect the ability to access a particular PFN in
+	 * certain situations, such as when the PFN is being accessed via a 2MB
+	 * mapping in the host page table.
+	 */
+	pfn_i = ALIGN_DOWN(pfn, PTRS_PER_PMD);
+	pfn_end = pfn_i + PTRS_PER_PMD;
+
+	pr_info("PFN 0x%llx unassigned, dumping non-zero entries in 2M PFN region: [0x%llx - 0x%llx]\n",
+		pfn, pfn_i, pfn_end);
+
+	while (pfn_i < pfn_end) {
+		e = __snp_lookup_rmpentry(pfn_i, &level);
+		if (IS_ERR(e)) {
+			pr_err("Error %ld reading RMP entry for PFN 0x%llx\n",
+			       PTR_ERR(e), pfn_i);
+			pfn_i++;
+			continue;
+		}
+
+		if (e->lo || e->hi)
+			pr_info("PFN: 0x%llx, [0x%016llx - 0x%016llx]\n", pfn_i, e->lo, e->hi);
+		pfn_i++;
+	}
+}
+
+void snp_dump_hva_rmpentry(unsigned long hva)
+{
+	unsigned long paddr;
+	unsigned int level;
+	pgd_t *pgd;
+	pte_t *pte;
+
+	pgd = __va(read_cr3_pa());
+	pgd += pgd_index(hva);
+	pte = lookup_address_in_pgd(pgd, hva, &level);
+
+	if (!pte) {
+		pr_err("Can't dump RMP entry for HVA %lx: no PTE/PFN found\n", hva);
+		return;
+	}
+
+	paddr = PFN_PHYS(pte_pfn(*pte)) | (hva & ~page_level_mask(level));
+	dump_rmpentry(PHYS_PFN(paddr));
+}
-- 
2.25.1


