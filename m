Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E728552787
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345395AbiFTXEj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345752AbiFTXES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:04:18 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567DC20F69;
        Mon, 20 Jun 2022 16:04:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XZM25cENgNcRIHhAkd4gVfrHvfdsNATCoJRgiQUlknK5aGZLV1YYDqSFxSp7EaonF4KT2jjLxk9x968aykkkn054+I8/9fkpbFmlEJgrmYu7nCZPHV8LXJ1kNQZC9E7br8OwVno6I2/FEuQnhmPuiBIoPATbnDOdoOHq52c1Q/zXLYFwn933v75oaMPqaWwOig5JrEl9j5x1MvfGkw6+h3OQLiq/Z/lWqOVVv2/1SHfly0qL/+YAhuBWxUs3z8znP5EPO5xk0hOY2AlhX1RJ05rBG3c1jlS3JCczK7F/aGA8KNaAJGGUn6ZeUExtWTpbT4nS+sR4y2Si0ZQP8QvW/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WU3JMwJgqvyPUcyzBZs7TBL5nqj7/gWSpusixIl6aVc=;
 b=QigYGxk8yVUAEvMHWYpqIKTm6wj1QnLJZuHNp28qPVlUgvVGOt8k4zKHUaVCTTk4enLYPAMCJP1i3+RHImxM9R2UlJnyCvDI0IaAG/l2TtAcn4hUt2TiFJJSJYzJJPWvogOobMqFdDqTLgi+jAmH9nTLryIe5rFy6lGNg9vbOcQlH9hyjA+LBFJRujlCA+Lg3lzqXy56SP6wnd77rL0FB1aEqg2ZLB8W4IubPBcCelgumY3ODucfArfQXmPH7pRDYE99qZZamGErGxpGvFq0bz5gmgR5gBPghdlOwf1T5Jk2pqdJfocR+Qm1crbtSzoEV0z8BChFcpMFJv0X0e/sfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WU3JMwJgqvyPUcyzBZs7TBL5nqj7/gWSpusixIl6aVc=;
 b=rpdDK4LIMmRU3EBgVOCZR1czzAf4dqMbgScBGyZrTXle/kIkMLaJJI5DQtG5RWUV+b2IAvFAyJmxWnQqP39qupU/2+vHbdiAiUAtfI8vX3aySMurDnyQNvyjkeugiM7Wz1jEfnRL2Wd1WSeABVin/m4FC9k4VAXq6xA+dfI9fsw=
Received: from YQBPR0101CA0166.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:f::9)
 by BN6PR1201MB2546.namprd12.prod.outlook.com (2603:10b6:404:b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Mon, 20 Jun
 2022 23:04:10 +0000
Received: from DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:c01:f:cafe::f) by YQBPR0101CA0166.outlook.office365.com
 (2603:10b6:c01:f::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Mon, 20 Jun 2022 23:04:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT044.mail.protection.outlook.com (10.13.173.185) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:04:10 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:04:07 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 10/49] x86/fault: Add support to dump RMP entry on fault
Date:   Mon, 20 Jun 2022 23:03:58 +0000
Message-ID: <af381cc88410c0e2c48fda5732741edd0d7609ac.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc7f4d59-db38-4cc8-9abe-08da53112f74
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2546:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB25464941300B42D36A2A5BF98EB09@BN6PR1201MB2546.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3pHDBzM5VpiGW4Nl98G0PwVZGoYHbn8OONLwOnAoKVc0L3vc+8vCsdD1nrJKYrCKbjqzhpos3i8alACGd4yXNQ1hjk26+p6PTydSz3XjZ+Y9gGL2Sqh9zpYxxerAzR2Vm3GWIDEBb/xmZG1/lL7Ny7ACwTJ94FPuFpK/LZQXa7lXClDBufhlth55aU+C/PdszSC4DooWixhq46kE7xNKnxDhftcrP3FM/pYIp7Qud67RdWxIt+7Mb2b9LMBKiC93cRD/osmSHOOi+va3Bl2pylBw73u1oKFEQJ/+yoRNtE8fesGyiCfnwSUybI6mOgtEQzPNEXRpPOTXlW11IpDLmUM+1xfQ9jE2uuZT6auomNL2hyq9Gc/eEQEqL/Y3IFnLpuDE4mqur90RiyqnRRbgWlz1rXR9GI57QowAt3NxVMpAOeLrv49gU0Uqb0hcCwHXW+ArmmZgOhLEaVb43/4UNw0mNzxXXuTrwBISWRjsCLpf4tt5ba4tCcWxq8vDXcYQJ9qikQr1oGSFTwadVFGtyQi3X4Dd7BC3NfB76kBox3ZcQdkTDLFUlqwjnr2zUhjtddO7Av7dsyA0Fu6bR1NvVZMW46KpivKzriHPItn85gPSa8jpXS+Yau+K8SG/SCcBEv5T7sFQOVZy83PYm/paf3gspn5BblBEjGhrfS19+SZADwkiOtYnKRlME91qnrhe15EoMTADgVeYnhGBQOQxQFJ/RzhCTxJar13c9pu55Pjx7fz3IpuZ8sesf41QSSDj/6hGQdQwvmKd/zLnVhBOGQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(376002)(39860400002)(46966006)(36840700001)(40470700004)(40460700003)(336012)(82310400005)(6666004)(81166007)(426003)(47076005)(26005)(2616005)(41300700001)(40480700001)(7696005)(7406005)(2906002)(7416002)(5660300002)(36756003)(8936002)(70206006)(316002)(36860700001)(70586007)(54906003)(356005)(4326008)(8676002)(83380400001)(82740400003)(86362001)(478600001)(186003)(16526019)(110136005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:04:10.1129
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc7f4d59-db38-4cc8-9abe-08da53112f74
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2546
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

When SEV-SNP is enabled globally, a write from the host goes through the
RMP check. If the hardware encounters the check failure, then it raises
the #PF (with RMP set). Dump the RMP entry at the faulting pfn to help
the debug.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev.h |  7 +++++++
 arch/x86/kernel/sev.c      | 43 ++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/fault.c        | 17 +++++++++++----
 include/linux/sev.h        |  2 ++
 4 files changed, 65 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 6ab872311544..c0c4df817159 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -113,6 +113,11 @@ struct __packed rmpentry {
 
 #define rmpentry_assigned(x)	((x)->info.assigned)
 #define rmpentry_pagesize(x)	((x)->info.pagesize)
+#define rmpentry_vmsa(x)	((x)->info.vmsa)
+#define rmpentry_asid(x)	((x)->info.asid)
+#define rmpentry_validated(x)	((x)->info.validated)
+#define rmpentry_gpa(x)		((unsigned long)(x)->info.gpa)
+#define rmpentry_immutable(x)	((x)->info.immutable)
 
 #define RMPADJUST_VMSA_PAGE_BIT		BIT(16)
 
@@ -205,6 +210,7 @@ void snp_set_wakeup_secondary_cpu(void);
 bool snp_init(struct boot_params *bp);
 void snp_abort(void);
 int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, unsigned long *fw_err);
+void dump_rmpentry(u64 pfn);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
@@ -229,6 +235,7 @@ static inline int snp_issue_guest_request(u64 exit_code, struct snp_req_data *in
 {
 	return -ENOTTY;
 }
+static inline void dump_rmpentry(u64 pfn) {}
 #endif
 
 #endif
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 734cddd837f5..6640a639fffc 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2414,6 +2414,49 @@ static struct rmpentry *__snp_lookup_rmpentry(u64 pfn, int *level)
 	return entry;
 }
 
+void dump_rmpentry(u64 pfn)
+{
+	unsigned long pfn_end;
+	struct rmpentry *e;
+	int level;
+
+	e = __snp_lookup_rmpentry(pfn, &level);
+	if (!e) {
+		pr_alert("failed to read RMP entry pfn 0x%llx\n", pfn);
+		return;
+	}
+
+	if (rmpentry_assigned(e)) {
+		pr_alert("RMPEntry paddr 0x%llx [assigned=%d immutable=%d pagesize=%d gpa=0x%lx"
+			" asid=%d vmsa=%d validated=%d]\n", pfn << PAGE_SHIFT,
+			rmpentry_assigned(e), rmpentry_immutable(e), rmpentry_pagesize(e),
+			rmpentry_gpa(e), rmpentry_asid(e), rmpentry_vmsa(e),
+			rmpentry_validated(e));
+		return;
+	}
+
+	/*
+	 * If the RMP entry at the faulting pfn was not assigned, then we do not
+	 * know what caused the RMP violation. To get some useful debug information,
+	 * let iterate through the entire 2MB region, and dump the RMP entries if
+	 * one of the bit in the RMP entry is set.
+	 */
+	pfn = pfn & ~(PTRS_PER_PMD - 1);
+	pfn_end = pfn + PTRS_PER_PMD;
+
+	while (pfn < pfn_end) {
+		e = __snp_lookup_rmpentry(pfn, &level);
+		if (!e)
+			return;
+
+		if (e->low || e->high)
+			pr_alert("RMPEntry paddr 0x%llx: [high=0x%016llx low=0x%016llx]\n",
+				 pfn << PAGE_SHIFT, e->high, e->low);
+		pfn++;
+	}
+}
+EXPORT_SYMBOL_GPL(dump_rmpentry);
+
 /*
  * Return 1 if the RMP entry is assigned, 0 if it exists but is not assigned,
  * and -errno if there is no corresponding RMP entry.
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index f5de9673093a..25896a6ba04a 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -34,6 +34,7 @@
 #include <asm/kvm_para.h>		/* kvm_handle_async_pf		*/
 #include <asm/vdso.h>			/* fixup_vdso_exception()	*/
 #include <asm/irq_stack.h>
+#include <asm/sev.h>			/* dump_rmpentry()		*/
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
@@ -290,7 +291,7 @@ static bool low_pfn(unsigned long pfn)
 	return pfn < max_low_pfn;
 }
 
-static void dump_pagetable(unsigned long address)
+static void dump_pagetable(unsigned long address, bool show_rmpentry)
 {
 	pgd_t *base = __va(read_cr3_pa());
 	pgd_t *pgd = &base[pgd_index(address)];
@@ -346,10 +347,11 @@ static int bad_address(void *p)
 	return get_kernel_nofault(dummy, (unsigned long *)p);
 }
 
-static void dump_pagetable(unsigned long address)
+static void dump_pagetable(unsigned long address, bool show_rmpentry)
 {
 	pgd_t *base = __va(read_cr3_pa());
 	pgd_t *pgd = base + pgd_index(address);
+	unsigned long pfn;
 	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
@@ -367,6 +369,7 @@ static void dump_pagetable(unsigned long address)
 	if (bad_address(p4d))
 		goto bad;
 
+	pfn = p4d_pfn(*p4d);
 	pr_cont("P4D %lx ", p4d_val(*p4d));
 	if (!p4d_present(*p4d) || p4d_large(*p4d))
 		goto out;
@@ -375,6 +378,7 @@ static void dump_pagetable(unsigned long address)
 	if (bad_address(pud))
 		goto bad;
 
+	pfn = pud_pfn(*pud);
 	pr_cont("PUD %lx ", pud_val(*pud));
 	if (!pud_present(*pud) || pud_large(*pud))
 		goto out;
@@ -383,6 +387,7 @@ static void dump_pagetable(unsigned long address)
 	if (bad_address(pmd))
 		goto bad;
 
+	pfn = pmd_pfn(*pmd);
 	pr_cont("PMD %lx ", pmd_val(*pmd));
 	if (!pmd_present(*pmd) || pmd_large(*pmd))
 		goto out;
@@ -391,9 +396,13 @@ static void dump_pagetable(unsigned long address)
 	if (bad_address(pte))
 		goto bad;
 
+	pfn = pte_pfn(*pte);
 	pr_cont("PTE %lx", pte_val(*pte));
 out:
 	pr_cont("\n");
+
+	if (show_rmpentry)
+		dump_rmpentry(pfn);
 	return;
 bad:
 	pr_info("BAD\n");
@@ -579,7 +588,7 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long ad
 		show_ldttss(&gdt, "TR", tr);
 	}
 
-	dump_pagetable(address);
+	dump_pagetable(address, error_code & X86_PF_RMP);
 }
 
 static noinline void
@@ -596,7 +605,7 @@ pgtable_bad(struct pt_regs *regs, unsigned long error_code,
 
 	printk(KERN_ALERT "%s: Corrupted page table at address %lx\n",
 	       tsk->comm, address);
-	dump_pagetable(address);
+	dump_pagetable(address, false);
 
 	if (__die("Bad pagetable", regs, error_code))
 		sig = 0;
diff --git a/include/linux/sev.h b/include/linux/sev.h
index 1a68842789e1..734b13a69c54 100644
--- a/include/linux/sev.h
+++ b/include/linux/sev.h
@@ -16,6 +16,7 @@ int snp_lookup_rmpentry(u64 pfn, int *level);
 int psmash(u64 pfn);
 int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable);
 int rmp_make_shared(u64 pfn, enum pg_level level);
+void dump_rmpentry(u64 pfn);
 #else
 static inline int snp_lookup_rmpentry(u64 pfn, int *level) { return 0; }
 static inline int psmash(u64 pfn) { return -ENXIO; }
@@ -25,6 +26,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int as
 	return -ENODEV;
 }
 static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
+static inline void dump_rmpentry(u64 pfn) { }
 
 #endif /* CONFIG_AMD_MEM_ENCRYPT */
 #endif /* __LINUX_SEV_H */
-- 
2.25.1

