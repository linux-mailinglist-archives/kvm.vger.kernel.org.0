Return-Path: <kvm+bounces-5345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C795282072B
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:22:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB3AE1C2125C
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:22:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45D77FBFE;
	Sat, 30 Dec 2023 16:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2rUdD4cc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CA6EAC8;
	Sat, 30 Dec 2023 16:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OGA7QZ8yKn5tHyJnPXC6Ba3p/yBthCMCyutN2PBAw89lngdE+IKFgfu/HmFBARdv7PwGqC1lZUd+xZ8uDR6oDZFlQ1AnSpmJA+T98dli/UXLmWhyCS5HXVt2IDvWq82tnQ2fZr15LRBT5P3jdoNn+THrm72wGgGqGnKl/3WfsJ8D6vgbw4asWbn6OuYTTbyhB/M73RLv/UQ8nUR04kopU1DCgE3ouLHEqzw7TtVcF6S7ufNmV5Sr5tjpLT7T04Aqa8PZoxUteghFoK3ZdMck0uhCLXtCMT7xIBQzGr2C/RAh/ZSWk1b5e996N6VmiTYshezZwpqLB9KU6ubOv0zrYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Vpevmi74naosPmEvRWKbYnfNlTrLJU5qBx4EN7GWE4=;
 b=J0ThlBzhP5cHOk3N8TJTsIyTtSUrMio39XH/VOPhJx70pBAP+bYnUHax4u/DUVQnNsJnriv3q2jhRMt1MqGM1qbe4ShPiTWDmxwpdM1k7yJ1KlXnNTbDBimWA72wSefQTVs6Uch8WyGp/5IFCSf85F7OAUpUucOc15arTKczLKThxFHn1tmfBRMGLINr23fQ49dMJUMQlGOcHo9eI4OyaiShQNgMebBn2UgHb/S++c75+krPwgzr5eVPJKiIsvIDiSs7EGHPkSEcibjnl/m8jCPZhY0QGQwirTdOS9gV3huAV9z5fUQTyruCOMODB9e6BNZg7aNf5uAjxr6JX4lyig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Vpevmi74naosPmEvRWKbYnfNlTrLJU5qBx4EN7GWE4=;
 b=2rUdD4ccxYAuaoRXVKeTaC0Zr/Fa0KSY0fy95sBUStWeTpWE21VvG2dJ3ZZ8oH7+0JZfLCyj5tjYhbHIJszRdYAoNO1xhmpjHBcm1QuS5/t1s0G8R7wIU87ZetoY3Pl+930WKbv06sEfl23XsYKI44NmOKbFraZfbwPsVXSU/Qc=
Received: from CH0P223CA0009.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:116::35)
 by PH8PR12MB7111.namprd12.prod.outlook.com (2603:10b6:510:22d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 16:22:07 +0000
Received: from DS3PEPF000099DD.namprd04.prod.outlook.com
 (2603:10b6:610:116:cafe::bf) by CH0P223CA0009.outlook.office365.com
 (2603:10b6:610:116::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.21 via Frontend
 Transport; Sat, 30 Dec 2023 16:22:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099DD.mail.protection.outlook.com (10.167.17.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:22:07 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:22:06 -0600
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
Subject: [PATCH v1 10/26] x86/sev: Add helper functions for RMPUPDATE and PSMASH instruction
Date: Sat, 30 Dec 2023 10:19:38 -0600
Message-ID: <20231230161954.569267-11-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DD:EE_|PH8PR12MB7111:EE_
X-MS-Office365-Filtering-Correlation-Id: 422b6fa3-9631-459e-0941-08dc09537792
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	v6QgR0FV1CuUkrS77dsmrhT57yHZBTtgPqGaG6oGW3UNd3cSSe7uWcnBNNZ27M+s1YuS6+G5VMrDMPFO+DZ3HVs+lBOCSiEuMDM+NFRY8oHZ7QqB0r3ObEGu2eU6pYONgrmRe1WHPqePFJ8hJxL11PnlOqyyYVVKDuBFrBuaEbNMaStB/dO7hQI4jKN9SCl+HDZsbWsbS9pTE6x+e2u0P+LokhURL6ZKfIvQIwKrU+jD4gI9ZD5zKHJ1nq9g3NgR2hkOpQMYGA66iuxDQa43vbbfSziGhY5WBtZTq/c7GzGd0vlFAY72eYeR9LLAO2M7HzzHLY9Ro7sPQQSsF7JQTOdY0hG4s6I5x4qKgmtewRUPxP2mCPyi3Kys1ba0VSDc9xeY/z6jYoUY2RQmAnl54lncZuNv3JDJnT2T6mFp9KAQDm0q84K7aY2b7BnBefzacaEhXfnJKcq2mL2WJC104n0aLkTbTYsj7haQzA0Osuuku5ULgcqdBIqpf8fgATYlmGv+mdeVFfe6sMjZrZqAJZEWskgYmFTXj1yL4sUNtkyW5KZpxIUIc68kglhvwwioipN7Vq4ZvzzmiC83OdGzGRpl5p7XCLot6qffhOs+/DMqst48cup5/d9ADA9JVsO9yLP2Fx2q5/dcd7ej4TwVaQDMehInSmJPSQEf3Vj8m0yT/216RT0UPXUI0BiG4D87Y7p3ly0AhDo94OsQI01dQPXE1rTZRAnhMVOhqOONy3a+XVvwNM5iTDiJCNcDDODsmyXV+ILcN7Am3LE4dUe1DA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(346002)(376002)(39860400002)(230922051799003)(451199024)(1800799012)(64100799003)(82310400011)(186009)(36840700001)(40470700004)(46966006)(426003)(83380400001)(16526019)(40480700001)(1076003)(26005)(2616005)(40460700003)(336012)(478600001)(6666004)(47076005)(41300700001)(316002)(54906003)(70206006)(70586007)(6916009)(36756003)(44832011)(8936002)(4326008)(8676002)(36860700001)(356005)(81166007)(86362001)(82740400003)(2906002)(5660300002)(7416002)(7406005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:22:07.1981
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 422b6fa3-9631-459e-0941-08dc09537792
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DD.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7111

From: Brijesh Singh <brijesh.singh@amd.com>

The RMPUPDATE instruction writes a new RMP entry in the RMP Table. The
hypervisor will use the instruction to add pages to the RMP table. See
APM3 for details on the instruction operations.

The PSMASH instruction expands a 2MB RMP entry into a corresponding set
of contiguous 4KB RMP entries. The hypervisor will use this instruction
to adjust the RMP entry without invalidating it.

Add helpers to make use of these instructions.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: add RMPUPDATE retry logic for transient FAIL_OVERLAP errors]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev.h | 23 +++++++++++
 arch/x86/virt/svm/sev.c    | 79 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 102 insertions(+)

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
index 7c9ced8911e9..ff9fa0a85a7f 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -343,3 +343,82 @@ void snp_dump_hva_rmpentry(unsigned long hva)
 	dump_rmpentry(pte_pfn(*pte));
 }
 EXPORT_SYMBOL_GPL(snp_dump_hva_rmpentry);
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


