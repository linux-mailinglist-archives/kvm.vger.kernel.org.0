Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7748F64D051
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239261AbiLNTu6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239231AbiLNTuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:50:24 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F4B2C133;
        Wed, 14 Dec 2022 11:49:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZnCdoyFXiQXbmWX1uYJ9GyHiNG54F+bWFDOF+TLVfU/MmD5mUD7SmvlFndFTaIJvk1hxBn3TZ8UPzLxXQepSqgYoIXPaU3/k8Q+JMWEsjUR8W2Nky2cEVQTDI7AKO0XaK058WizX9Patgb+j0wBEfaabQOUaLAnKOuH6j3CAKBn44dTNz4Nk/mn3gt37lFeShulRX0uZulIA7JRmxS1kiPiF8a7gdvqr44HCPiR7skyw3ANvPSaDc9ZtS2C+D6cyZemaze/mW0vqSFsIF+3W+54tbyc6PkzNCENCjeMfAzzEAw3kUi0m+HGY1bfIa/Bk2Qw26dZ4bAROFd1k+IRcOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0DDUpcAbZbIX2Z0x25kQh8te3lopnStDcycaGYXFBvw=;
 b=HW2aPewNgwuIa6/QCHPMfgeIjjehZpespm7/EWWNEoCwCcwe7DcsK1AXvfM2JYLAHIkS/rEROlHmu35KS26gZnvkc3WWlYtbCObNqylldBOcbxakNpJRvhI/PbIyWzCfBdcMVV4G3Q+6YMQpH2CEe6ukLou0GtL74Hie7kj3tXBqw0tZfOeey/lLwCNNkqcASjSkaNhq4PegEo9p9+axGJJh6SF60HVvvB+ZNmJk1uNV1bCVe24KxL4g2NCFh8orLzETpcy1VBw+qxGVE+lL+3ql4hk+TKtvKgnhDSVWtBtRqD1Yx3EKsdgwdlq+Sj64MmvQ2g1EXuUKv6lcLpdYKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0DDUpcAbZbIX2Z0x25kQh8te3lopnStDcycaGYXFBvw=;
 b=3u8SHPVFA0rIlLi82kMbqVu7j+t+SAkb4OiUZwDrCv3sn2SDnF+4h3n5NxQfESS5vSlRfzND12r7DrsZSugrGaqas7jYoMtKUIdcGnZc6m9XDrolasBgwDliEBlkJAz/W0vhtqKxz6CVy82F35yF5OE/LCdGe42+6ollk5hcLV8=
Received: from CY5P221CA0019.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:b::32) by
 PH0PR12MB7886.namprd12.prod.outlook.com (2603:10b6:510:26e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Wed, 14 Dec
 2022 19:49:32 +0000
Received: from CY4PEPF0000C978.namprd02.prod.outlook.com
 (2603:10b6:930:b:cafe::8e) by CY5P221CA0019.outlook.office365.com
 (2603:10b6:930:b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:49:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C978.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.10 via Frontend Transport; Wed, 14 Dec 2022 19:49:32 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:49:31 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v7 16/64] x86/sev: Add helper functions for RMPUPDATE and PSMASH instruction
Date:   Wed, 14 Dec 2022 13:40:08 -0600
Message-ID: <20221214194056.161492-17-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C978:EE_|PH0PR12MB7886:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f1acf69-b517-4b5a-a134-08dade0c5213
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qNGZadhHH0CrbDWAAKPvG3KYsvUouIn1eqYuEL9EZOKRMjovK7VzfttHgoBqMor0230tEEqp6OIkeTKj4UHLNzHfaKibQRZC2wGskc6ElNtE2+EClsz3ZXMwI4452yJ2JJCEMa4EtpG2VYlRZ9QbML0Y7FEY8rJe27YqztGZTKWfy6xnxa5q6nCxs34IzCGrZdCYLM6Rmo8Bvcs4gAdHPoI477ib5+ULBI+kHLV7tMkARlDzCZZfeBrJucHojMywZWadrkVlBmNrUMxseaX1LwC7nekPdrlEBNt1i0BRS6cfKn7zg+eAyyWuOo7Mz82jOry6sOZJ+3s+fTp6M/WI+99279bEdmgPstJ2oADZ+n1C0HrdxqjEOt7w92BW9kApS653luPBTNfY+iP6FR25ukzrHsegFHeMw8bNio0x4Vh4Yxrfahg8576IHVGJ4BhV/Ap0m4mH+9ux7pP4NA49mfsutCCl/nkgqLNZXkei20yOniyftqhMiX/2ojr6JEQqQuojISsZVYPdALdLrw6Mg0YUhKyPNjxyOmjitQre4IULLoIpVBsRvrszWWORmUxv6wtRdAA1a5LLc1NEZomtkK74sKpGSfmebBv015OROEip5Ju6MNsuHtuvYOLyjdY89BHZCGf8YHUJU6D3CritevlT/PjyVKqieSazT3pNSDpEZyYiHFn8f0gsRZpGB2NAT55rc2ln7iHSeTrZQ7VLV/e5QJKndkIkl6gr9+AX1m69U1mGV8Ca7ceaZkEMoa6xSKZdjsvbZ0nB3fhkL3SWTA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(376002)(396003)(451199015)(36840700001)(40470700004)(46966006)(36860700001)(82310400005)(83380400001)(336012)(1076003)(426003)(86362001)(2616005)(47076005)(40460700003)(40480700001)(36756003)(82740400003)(81166007)(356005)(316002)(54906003)(70206006)(2906002)(70586007)(8676002)(8936002)(4326008)(5660300002)(7416002)(44832011)(7406005)(41300700001)(26005)(186003)(6666004)(6916009)(16526019)(478600001)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:49:32.3245
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f1acf69-b517-4b5a-a134-08dade0c5213
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C978.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7886
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The RMPUPDATE instruction writes a new RMP entry in the RMP Table. The
hypervisor will use the instruction to add pages to the RMP table. See
APM3 for details on the instruction operations.

The PSMASH instruction expands a 2MB RMP entry into a corresponding set
of contiguous 4KB-Page RMP entries. The hypervisor will use this
instruction to adjust the RMP entry without invalidating the previous
RMP entry.

Add the following external interface API functions:

int psmash(u64 pfn);
psmash is used to smash a 2MB aligned page into 4K
pages while preserving the Validated bit in the RMP.

int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable);
Used to assign a page to guest using the RMPUPDATE instruction.

int rmp_make_shared(u64 pfn, enum pg_level level);
Used to transition a page to hypervisor/shared state using the RMPUPDATE instruction.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
[mdr: add RMPUPDATE retry logic for transient FAIL_OVERLAP errors]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev.h | 24 ++++++++++
 arch/x86/kernel/sev.c      | 95 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 119 insertions(+)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 8d3ce2ad27da..4eeedcaca593 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -80,10 +80,15 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
 
 /* Software defined (when rFlags.CF = 1) */
 #define PVALIDATE_FAIL_NOUPDATE		255
+/* RMUPDATE detected 4K page and 2MB page overlap. */
+#define RMPUPDATE_FAIL_OVERLAP		7
 
 /* RMP page size */
 #define RMP_PG_SIZE_4K			0
+#define RMP_PG_SIZE_2M			1
 #define RMP_TO_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
+#define X86_TO_RMP_PG_LEVEL(level)	(((level) == PG_LEVEL_4K) ? RMP_PG_SIZE_4K : RMP_PG_SIZE_2M)
+
 #define RMPADJUST_VMSA_PAGE_BIT		BIT(16)
 
 /* SNP Guest message request */
@@ -133,6 +138,15 @@ struct snp_secrets_page_layout {
 	u8 rsvd3[3840];
 } __packed;
 
+struct rmp_state {
+	u64 gpa;
+	u8 assigned;
+	u8 pagesize;
+	u8 immutable;
+	u8 rsvd;
+	u32 asid;
+} __packed;
+
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 extern struct static_key_false sev_es_enable_key;
 extern void __sev_es_ist_enter(struct pt_regs *regs);
@@ -198,6 +212,9 @@ bool snp_init(struct boot_params *bp);
 void __init __noreturn snp_abort(void);
 int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, unsigned long *fw_err);
 int snp_lookup_rmpentry(u64 pfn, int *level);
+int psmash(u64 pfn);
+int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable);
+int rmp_make_shared(u64 pfn, enum pg_level level);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
@@ -223,6 +240,13 @@ static inline int snp_issue_guest_request(u64 exit_code, struct snp_req_data *in
 	return -ENOTTY;
 }
 static inline int snp_lookup_rmpentry(u64 pfn, int *level) { return 0; }
+static inline int psmash(u64 pfn) { return -ENXIO; }
+static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid,
+				   bool immutable)
+{
+	return -ENODEV;
+}
+static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
 #endif
 
 #endif
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 706675561f49..67035d34adad 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2523,3 +2523,98 @@ int snp_lookup_rmpentry(u64 pfn, int *level)
 	return !!rmpentry_assigned(e);
 }
 EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
+
+/*
+ * psmash is used to smash a 2MB aligned page into 4K
+ * pages while preserving the Validated bit in the RMP.
+ */
+int psmash(u64 pfn)
+{
+	unsigned long paddr = pfn << PAGE_SHIFT;
+	int ret;
+
+	if (!pfn_valid(pfn))
+		return -EINVAL;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return -ENXIO;
+
+	/* Binutils version 2.36 supports the PSMASH mnemonic. */
+	asm volatile(".byte 0xF3, 0x0F, 0x01, 0xFF"
+		      : "=a"(ret)
+		      : "a"(paddr)
+		      : "memory", "cc");
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(psmash);
+
+static int rmpupdate(u64 pfn, struct rmp_state *val)
+{
+	unsigned long paddr = pfn << PAGE_SHIFT;
+	int retries = 0;
+	int ret;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return -ENXIO;
+
+retry:
+	/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
+	asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
+		     : "=a"(ret)
+		     : "a"(paddr), "c"((unsigned long)val)
+		     : "memory", "cc");
+
+	if (ret) {
+		if (!retries) {
+			pr_err("RMPUPDATE failed, ret: %d, pfn: %llx, npages: %d, level: %d, retrying (max: %d)...\n",
+			       ret, pfn, npages, level, 2 * num_present_cpus());
+			dump_stack();
+		}
+		retries++;
+		if (retries < 2 * num_present_cpus())
+			goto retry;
+	} else if (retries > 0) {
+		pr_err("RMPUPDATE for pfn %llx succeeded after %d retries\n", pfn, retries);
+	}
+
+	return ret;
+}
+
+/*
+ * Assign a page to guest using the RMPUPDATE instruction.
+ */
+int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable)
+{
+	struct rmp_state val;
+
+	if (!pfn_valid(pfn))
+		return -EINVAL;
+
+	memset(&val, 0, sizeof(val));
+	val.assigned = 1;
+	val.asid = asid;
+	val.immutable = immutable;
+	val.gpa = gpa;
+	val.pagesize = X86_TO_RMP_PG_LEVEL(level);
+
+	return rmpupdate(pfn, &val);
+}
+EXPORT_SYMBOL_GPL(rmp_make_private);
+
+/*
+ * Transition a page to hypervisor/shared state using the RMPUPDATE instruction.
+ */
+int rmp_make_shared(u64 pfn, enum pg_level level)
+{
+	struct rmp_state val;
+
+	if (!pfn_valid(pfn))
+		return -EINVAL;
+
+	memset(&val, 0, sizeof(val));
+	val.pagesize = X86_TO_RMP_PG_LEVEL(level);
+
+	return rmpupdate(pfn, &val);
+}
+EXPORT_SYMBOL_GPL(rmp_make_shared);
-- 
2.25.1

