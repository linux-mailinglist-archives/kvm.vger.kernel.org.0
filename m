Return-Path: <kvm+bounces-5341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EAF9C82071D
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:21:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 758701F211C8
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:21:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28C55B672;
	Sat, 30 Dec 2023 16:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KOHn8Mh9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2058.outbound.protection.outlook.com [40.107.93.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D5AC140;
	Sat, 30 Dec 2023 16:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bRGYH4AcDgalqD7vDEphQ77duRXi2nCS0FZOmTft0JOmyeZmLKnZ46xW+N2QjWHo1ZV9ywKifVk9PDaH4TAumPFVXXz9HdtIh4i4UHpS+NW125ZS+40yuJwXZFBH7lhwW1kU5dMZbFKNour54RCBSh02NHwGK/yR/VGLB7AAXFB0XpyfKsKbVy8VRGtV+IyhtyjergGAuRZecYZr7ae1akn4EuMuX521IWYLF5wLNuLqxLESgPWVbhte/xucy+WVnD7LsdRK3FJFRAYEuFxc0FqrZP6/Iav2g7zO0ko7bn5B3TlXiTN8MSfu4JroT+k2NQySoA1sYalODbl0STRztg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rfRxzbJ12CAcEfGFEQrfXeMgidShRr9+id1B4s8C9+Y=;
 b=gw8qp5xIMBlb/HLiAOHy8VNZLOHvbtyUxncwub4WvBHpgXfShpNzwtUekFfAUPeoMaPcdsTfxHgigKVuXESZNLVAlluI3+wyZUWXrSexivtbiG3Ieyr/fzvkMgN5A0nZL8KkGs+PQfPNDHe9p0GGiaxUoxXkvH9GZQ+3nyHbq+wLwvd1ArLBtYKCKiZtgLwvjT3p5DzblSjuESzTTh6RW3Tz+AqLetyIGrysHtikjH3gL+swCJB8xgvXXrFNlw0mkCG+pbqQbH12XtmdjjEwq+Np3wsqMiO4SxgO8JidXJUt4E6Qhs7JY0ynoAOfDE8Qwm1vMVKOwm3QIDp15zHPiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rfRxzbJ12CAcEfGFEQrfXeMgidShRr9+id1B4s8C9+Y=;
 b=KOHn8Mh9En7m/Wj6jLYVKXbPuHLPHrp3t3mdxnCQ+iUiUQZxGM5Yq22PkIhfvwM5wbrCQ3xpobDtExVDNo4ORGZSXdneWhmPPIFswZ5GEUVMbLjzNxrmTWtXPU0BjQXse/mPJqbSlHusBR6M1W/Le0bL2/hkNMGpSzf0DoIV3uU=
Received: from DM6PR05CA0061.namprd05.prod.outlook.com (2603:10b6:5:335::30)
 by PH0PR12MB5436.namprd12.prod.outlook.com (2603:10b6:510:eb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 16:20:44 +0000
Received: from DS3PEPF000099E0.namprd04.prod.outlook.com
 (2603:10b6:5:335:cafe::89) by DM6PR05CA0061.outlook.office365.com
 (2603:10b6:5:335::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.7 via Frontend
 Transport; Sat, 30 Dec 2023 16:20:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099E0.mail.protection.outlook.com (10.167.17.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:20:43 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:20:43 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v1 07/26] x86/fault: Add helper for dumping RMP entries
Date: Sat, 30 Dec 2023 10:19:35 -0600
Message-ID: <20231230161954.569267-8-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E0:EE_|PH0PR12MB5436:EE_
X-MS-Office365-Filtering-Correlation-Id: 39a54684-a8bf-4311-f6db-08dc095345f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tlGFuUAz0Gp9UOMa35JQEc9NhV3NSXDDeduRA1vWfr+NpX0c/aj2nhuJL9dXG96Nh4S2SgZPBZFeSdg+kTTO//JzZP4nrWUsUTGWKan4UqLPw5RnZ9t5HSfIYcoQPBO0YfLE844+Q2pIqiviFFcPgKTqpM4TV/dA4P9IGaNjPPKg7SeX8L++5m1G0nTUaSEiYl+JINknQMijipCLojmu3wDo5twoJYSNsTSLSnw7wWyVqHa1HNabFT75xqetQFxV3+zMRjzrD5OTsdLji7mgs6M0jqEH8OblRHERAc0NO601LRQ9xGFHRXWQZWA8fkRm5PhvwAf0Py4rPhid8ScaHhl2zJss3v1CZYF7eIPu1apXkQfG7LpTR9adsDu3zkaiwUBjqsabsa3WDTaOqDwv333PUTSXNXfEGR5J0pvcpwl4LDW2BLAstPspJNkzl4GD76z6q0GqUQCwGjuln9l6DCm4/Mb58eAA0rb14T/OZS6uJwkd8PqR0foV2Q7GAyclg7ANeAvEdifHjjgI2YbQBgy5U9dhidM7jEX7ukf6Edr/s6oUxJrO3HAZL7eyjamQ+BtNG1Q8hP4tt8FkIvwYg/0MMJme/zU9MzG00gaFBmlGtj9etErHvGCmzEVcYsQEZPhBJW/+IAidoW3aB2ij3ITJcplZzxuyfPZaCvcxCgXCdkM+1ztoQ2P0dZB0UuM4gDPD5s+zm91SmhAkN+7aqdXHpcTgZs52TL/3XO8mzrsm6d/jBRFyhOsTwtNFckqJgrgfdDMvkiEfXNAlcxofsg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(396003)(346002)(136003)(230922051799003)(82310400011)(64100799003)(186009)(1800799012)(451199024)(40470700004)(36840700001)(46966006)(40460700003)(36860700001)(478600001)(2616005)(41300700001)(82740400003)(4326008)(6916009)(70206006)(70586007)(36756003)(44832011)(54906003)(81166007)(356005)(316002)(86362001)(6666004)(47076005)(16526019)(336012)(426003)(1076003)(40480700001)(26005)(83380400001)(8676002)(8936002)(2906002)(5660300002)(7416002)(7406005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:20:43.9866
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39a54684-a8bf-4311-f6db-08dc095345f8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5436

From: Brijesh Singh <brijesh.singh@amd.com>

This information will be useful for debugging things like page faults
due to RMP access violations and RMPUPDATE failures.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: move helper to standalone patch, rework dump logic to reduce
      verbosity]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev.h |  2 +
 arch/x86/virt/svm/sev.c    | 77 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+)

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
index 49fdfbf4e518..7c9ced8911e9 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -266,3 +266,80 @@ int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level)
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
+	u64 pfn_current, pfn_end;
+	struct rmpentry *e;
+	u64 *e_data;
+	int level;
+
+	e = __snp_lookup_rmpentry(pfn, &level);
+	if (IS_ERR(e)) {
+		pr_info("Failed to read RMP entry for PFN 0x%llx, error %ld\n",
+			pfn, PTR_ERR(e));
+		return;
+	}
+
+	e_data = (u64 *)e;
+	if (e->assigned) {
+		pr_info("RMP entry for PFN 0x%llx: [high=0x%016llx low=0x%016llx]\n",
+			pfn, e_data[1], e_data[0]);
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
+	pfn_current = ALIGN(pfn, PTRS_PER_PMD);
+	pfn_end = pfn_current + PTRS_PER_PMD;
+
+	while (pfn_current < pfn_end) {
+		e = __snp_lookup_rmpentry(pfn_current, &level);
+		if (IS_ERR(e)) {
+			pfn_current++;
+			continue;
+		}
+
+		e_data = (u64 *)e;
+		if (e_data[0] || e_data[1]) {
+			pr_info("No assigned RMP entry for PFN 0x%llx, but the 2MB region contains populated RMP entries, e.g.: PFN 0x%llx: [high=0x%016llx low=0x%016llx]\n",
+				pfn, pfn_current, e_data[1], e_data[0]);
+			return;
+		}
+		pfn_current++;
+	}
+
+	pr_info("No populated RMP entries in the 2MB region containing PFN 0x%llx\n",
+		pfn);
+}
+
+void snp_dump_hva_rmpentry(unsigned long hva)
+{
+	unsigned int level;
+	pgd_t *pgd;
+	pte_t *pte;
+
+	pgd = __va(read_cr3_pa());
+	pgd += pgd_index(hva);
+	pte = lookup_address_in_pgd(pgd, hva, &level);
+
+	if (!pte) {
+		pr_info("Can't dump RMP entry for HVA %lx: no PTE/PFN found\n", hva);
+		return;
+	}
+
+	dump_rmpentry(pte_pfn(*pte));
+}
+EXPORT_SYMBOL_GPL(snp_dump_hva_rmpentry);
-- 
2.25.1


