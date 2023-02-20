Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12D469D30F
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbjBTSrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbjBTSrO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:47:14 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2065.outbound.protection.outlook.com [40.107.101.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DC721947;
        Mon, 20 Feb 2023 10:46:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ijAMP9dOwsm1No4MWGXlYrk1HbG7w41UFZyAfUrqQYzJcQawWoSQjhyiGiYxPMWE5Iyw6pRM0t3L20dyVzZzOKp2ZreBRXDoyCMXKPUgvD1wDjbLhJHDih9jW0pjzY6vu/EWP3JcAHF/4zf0DPDBHUuN6dxDvyKj1Y14JDT6acdM3U4Bl4bmz8C4q+5aIIPLURfZVQVAvOlXFcR1lVOp9VwoqaJAuJNXB7gNIMB2DAWI5NPer14aTop503DE9FBQpjIMZforu9icwAL6PILHbtjgKOSFOujTxy9S8kiZwvE/xmtiwwIt/WJz/OaGjBA7Toq6ifdVdYecfFOzIoLphw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D0uOF+T4jZHmuqcz209Qddae1NNTWTRVV73luMTut3g=;
 b=lafWjtZybMxuXjgQouaJBdObEhfHM5xAcD9JQIiJ9Sv5ZSJUsY9VQRDKGUs4JrcMMvOhVLYyyX0kMbKtaHbAoL7NRWC/GTkb3RfGqjWMoGb/KliQC894dlvnVuY/E49FTpu1LKrT6+IbGcQ78Hc20mQixHyiVFGbVqGR/8VI3wT+aE1bvfxHBoZIVtSciRnMHTo/w4pznY8hKlshXP4yBUiPByO11D9RQA1w+C5gp2Tet17CjoyyhvL0rgftIRByRboXvwZL6bKJ2Eo2yl8Qt9n6FNAXi04bKlqqmY7TvRSFqLH9PlMz3E8GjF7Lb/LgXzcmFTLkW9XceQH278f4Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D0uOF+T4jZHmuqcz209Qddae1NNTWTRVV73luMTut3g=;
 b=PaKvaCtb+mFMGg8TOMFnrW27/YAARnIbfllvEMZMGd+HC7UBk96gLgV0n5Gz9dD6n+QapLNUIP05kaLabC+riB/IiHEtIiAZPBS+PAnYgrsiVlfioWzh0jw7X2u9FBXNw23pUDqGmXhaHOC5bLuJQ/WCK2Jo+t0GN1jm422u9II=
Received: from CY5PR15CA0046.namprd15.prod.outlook.com (2603:10b6:930:1b::7)
 by BL1PR12MB5254.namprd12.prod.outlook.com (2603:10b6:208:31e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 18:46:21 +0000
Received: from CY4PEPF0000C96B.namprd02.prod.outlook.com
 (2603:10b6:930:1b:cafe::1c) by CY5PR15CA0046.outlook.office365.com
 (2603:10b6:930:1b::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:46:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C96B.mail.protection.outlook.com (10.167.241.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:46:20 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:46:19 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "Jarkko Sakkinen" <jarkko.sakkinen@profian.com>
Subject: [PATCH RFC v8 17/56] x86/fault: Add support to handle the RMP fault for user address
Date:   Mon, 20 Feb 2023 12:38:08 -0600
Message-ID: <20230220183847.59159-18-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C96B:EE_|BL1PR12MB5254:EE_
X-MS-Office365-Filtering-Correlation-Id: 9daee4c6-b661-4543-da8d-08db1372c21f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VyHcgg771pKNaQaZ66TOwQjJx+5a1DDEHtgpaRzGyoXjyiaE2CigwirpZLR9q+6QT8Ar/smJsi244WePfNfXuVgaXMeb9sD9VOSfAT2BoHMp2VTQc2uKJ19Q00W7v+QcinnBYWBwERT4GWkWDdys3BNGYjUEh8KyHx4lM/A1jcs5fVSWUyUKIibRIwnCeRvucm/Z/kYmbuF0lOyx0j4Jfil0gtcPE9OiEoWS+8Ob1v8DIBAMlBOeSJlO9ETwo61JpG7Fy/RaSj/bh4R0Q6FYGAkSf83agPNcOOSAZOFzV02oDZ0Xbc1mu88HquKV+wGhLuOJ6SfMdXeAGRh0XohaTTNWzPHBHRWgUbUWbUEg6LUJcV4USBRseylRU0m9xXTKMA+lBlAcgLD7R9Lu1oBdPERUjDa1Gvbwtt8IEwmnWin2UrMiKa91ZqitlCx8q0dKaPLnKfu/DZ1BWn+MdQCSQFyhZ/SMSofeVF+5VYdRiGEaTAf5gbFrJP1cQrciPVv3eLcVYZgZs2ECa6rVXO8RtKx8XYASGA4KUig1FdrgWjEnDI637lgWE7YeBVdARtnEC0RSqDNGvAslH28iQOB9MVhgJLcweAqXlcrVBQWXfPQehFfe/HlS/ErdneWP09nBfJCbPNKoELu3p5101E1Oun0LRXnP2T0A0pokdjUv9PikdmfIvqlrilPT00M1AziR6V7e5aRgIRZtWVrNkcF4ctpy7FlzpAQtVZyP25jLzeY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(396003)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(40460700003)(54906003)(316002)(8936002)(83380400001)(8676002)(70206006)(70586007)(4326008)(41300700001)(6666004)(1076003)(2616005)(6916009)(47076005)(16526019)(40480700001)(186003)(26005)(426003)(356005)(478600001)(336012)(36756003)(82310400005)(86362001)(2906002)(82740400003)(44832011)(7406005)(7416002)(36860700001)(5660300002)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:46:20.6030
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9daee4c6-b661-4543-da8d-08db1372c21f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C96B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5254
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

When SEV-SNP is enabled globally, a write from the host goes through the
RMP check. When the host writes to pages, hardware checks the following
conditions at the end of page walk:

1. Assigned bit in the RMP table is zero (i.e page is shared).
2. If the page table entry that gives the sPA indicates that the target
   page size is a large page, then all RMP entries for the 4KB
   constituting pages of the target must have the assigned bit 0.
3. Immutable bit in the RMP table is not zero.

The hardware will raise page fault if one of the above conditions is not
met. Try resolving the fault instead of taking fault again and again. If
the host attempts to write to the guest private memory then send the
SIGBUS signal to kill the process. If the page level between the host and
RMP entry does not match, then split the address to keep the RMP and host
page levels in sync.

Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@profian.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@profian.com>
Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/mm/fault.c      | 104 ++++++++++++++++++++++++++++++++++++++-
 include/linux/mm.h       |   3 +-
 include/linux/mm_types.h |   3 ++
 mm/memory.c              |  10 ++++
 4 files changed, 118 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index f8193b99e9c8..afd4cde17001 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -33,6 +33,7 @@
 #include <asm/kvm_para.h>		/* kvm_handle_async_pf		*/
 #include <asm/vdso.h>			/* fixup_vdso_exception()	*/
 #include <asm/irq_stack.h>
+#include <asm/sev.h>			/* snp_lookup_rmpentry()	*/
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
@@ -414,6 +415,7 @@ static void dump_pagetable(unsigned long address)
 	pr_cont("PTE %lx", pte_val(*pte));
 out:
 	pr_cont("\n");
+
 	return;
 bad:
 	pr_info("BAD\n");
@@ -527,6 +529,8 @@ static void show_ldttss(const struct desc_ptr *gdt, const char *name, u16 index)
 static void
 show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long address)
 {
+	unsigned long pfn;
+
 	if (!oops_may_print())
 		return;
 
@@ -599,7 +603,10 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long ad
 		show_ldttss(&gdt, "TR", tr);
 	}
 
-	dump_pagetable(address);
+	pfn = dump_pagetable(address);
+
+	if (error_code & X86_PF_RMP)
+		sev_dump_rmpentry(pfn);
 }
 
 static noinline void
@@ -1240,6 +1247,90 @@ do_kern_addr_fault(struct pt_regs *regs, unsigned long hw_error_code,
 }
 NOKPROBE_SYMBOL(do_kern_addr_fault);
 
+enum rmp_pf_ret {
+	RMP_PF_SPLIT	= 0,
+	RMP_PF_RETRY	= 1,
+	RMP_PF_UNMAP	= 2,
+};
+
+/*
+ * The goal of RMP faulting routine is really to check whether the
+ * page that faulted should be accessible.  That can be determined
+ * simply by looking at the RMP entry for the 4k address being accessed.
+ * If that entry has Assigned=1 then it's a bad address. It could be
+ * because the 2MB region was assigned as a large page, or it could be
+ * because the region is all 4k pages and that 4k was assigned.
+ * In either case, it's a bad access.
+ * There are basically two main possibilities:
+ * 1. The 2M entry has Assigned=1 and Page_Size=1. Then all 511 middle
+ * entries also have Assigned=1. This entire 2M region is a guest page.
+ * 2. The 2M entry has Assigned=0 and Page_Size=0. Then the 511 middle
+ * entries can be anything, this region consists of individual 4k assignments.
+ */
+static int handle_user_rmp_page_fault(struct pt_regs *regs, unsigned long error_code,
+				      unsigned long address)
+{
+	int rmp_level, level;
+	pgd_t *pgd;
+	pte_t *pte;
+	u64 pfn;
+
+	pgd = __va(read_cr3_pa());
+	pgd += pgd_index(address);
+
+	pte = lookup_address_in_pgd(pgd, address, &level);
+
+	/*
+	 * It can happen if there was a race between an unmap event and
+	 * the RMP fault delivery.
+	 */
+	if (!pte || !pte_present(*pte))
+		return RMP_PF_UNMAP;
+
+	/*
+	 * RMP page fault handler follows this algorithm:
+	 * 1. Compute the pfn for the 4kb page being accessed
+	 * 2. Read that RMP entry -- If it is assigned then kill the process
+	 * 3. Otherwise, check the level from the host page table
+	 *    If level=PG_LEVEL_4K then the page is already smashed
+	 *    so just retry the instruction
+	 * 4. If level=PG_LEVEL_2M/1G, then the host page needs to be split
+	 */
+
+	pfn = pte_pfn(*pte);
+
+	/* If its large page then calculte the fault pfn */
+	if (level > PG_LEVEL_4K)
+		pfn = pfn | PFN_DOWN(address & (page_level_size(level) - 1));
+
+	/*
+	 * If its a guest private page, then the fault cannot be resolved.
+	 * Send a SIGBUS to terminate the process.
+	 *
+	 * As documented in APM vol3 pseudo-code for RMPUPDATE, when the 2M range
+	 * is covered by a valid (Assigned=1) 2M entry, the middle 511 4k entries
+	 * also have Assigned=1. This means that if there is an access to a page
+	 * which happens to lie within an Assigned 2M entry, the 4k RMP entry
+	 * will also have Assigned=1. Therefore, the kernel should see that
+	 * the page is not a valid page and the fault cannot be resolved.
+	 */
+	if (snp_lookup_rmpentry(pfn, &rmp_level)) {
+		pr_info("Fatal RMP page fault, terminating process, entry assigned for pfn 0x%llx\n",
+			pfn);
+		do_sigbus(regs, error_code, address, VM_FAULT_SIGBUS);
+		return RMP_PF_RETRY;
+	}
+
+	/*
+	 * The backing page level is higher than the RMP page level, request
+	 * to split the page.
+	 */
+	if (level > rmp_level)
+		return RMP_PF_SPLIT;
+
+	return RMP_PF_RETRY;
+}
+
 /*
  * Handle faults in the user portion of the address space.  Nothing in here
  * should check X86_PF_USER without a specific justification: for almost
@@ -1337,6 +1428,17 @@ void do_user_addr_fault(struct pt_regs *regs,
 	if (error_code & X86_PF_INSTR)
 		flags |= FAULT_FLAG_INSTRUCTION;
 
+	/*
+	 * If its an RMP violation, try resolving it.
+	 */
+	if (error_code & X86_PF_RMP) {
+		if (handle_user_rmp_page_fault(regs, error_code, address))
+			return;
+
+		/* Ask to split the page */
+		flags |= FAULT_FLAG_PAGE_SPLIT;
+	}
+
 #ifdef CONFIG_X86_64
 	/*
 	 * Faults in the vsyscall page might need emulation.  The
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3c84f4e48cd7..2fd8e16d149c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -466,7 +466,8 @@ static inline bool fault_flag_allow_retry_first(enum fault_flag flags)
 	{ FAULT_FLAG_USER,		"USER" }, \
 	{ FAULT_FLAG_REMOTE,		"REMOTE" }, \
 	{ FAULT_FLAG_INSTRUCTION,	"INSTRUCTION" }, \
-	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }
+	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }, \
+	{ FAULT_FLAG_PAGE_SPLIT,	"PAGESPLIT" }
 
 /*
  * vm_fault is filled by the pagefault handler and passed to the vma's
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 500e536796ca..06ba34d51638 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -962,6 +962,8 @@ typedef struct {
  *                      mapped R/O.
  * @FAULT_FLAG_ORIG_PTE_VALID: whether the fault has vmf->orig_pte cached.
  *                        We should only access orig_pte if this flag set.
+ * @FAULT_FLAG_PAGE_SPLIT: The fault was due page size mismatch, split the
+ *                         region to smaller page size and retry.
  *
  * About @FAULT_FLAG_ALLOW_RETRY and @FAULT_FLAG_TRIED: we can specify
  * whether we would allow page faults to retry by specifying these two
@@ -999,6 +1001,7 @@ enum fault_flag {
 	FAULT_FLAG_INTERRUPTIBLE =	1 << 9,
 	FAULT_FLAG_UNSHARE =		1 << 10,
 	FAULT_FLAG_ORIG_PTE_VALID =	1 << 11,
+	FAULT_FLAG_PAGE_SPLIT =		1 << 12,
 };
 
 typedef unsigned int __bitwise zap_flags_t;
diff --git a/mm/memory.c b/mm/memory.c
index f88c351aecd4..e68da7e403c6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4996,6 +4996,12 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
 	return 0;
 }
 
+static int handle_split_page_fault(struct vm_fault *vmf)
+{
+	__split_huge_pmd(vmf->vma, vmf->pmd, vmf->address, false, NULL);
+	return 0;
+}
+
 /*
  * By the time we get here, we already hold the mm semaphore
  *
@@ -5078,6 +5084,10 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 				pmd_migration_entry_wait(mm, vmf.pmd);
 			return 0;
 		}
+
+		if (flags & FAULT_FLAG_PAGE_SPLIT)
+			return handle_split_page_fault(&vmf);
+
 		if (pmd_trans_huge(vmf.orig_pmd) || pmd_devmap(vmf.orig_pmd)) {
 			if (pmd_protnone(vmf.orig_pmd) && vma_is_accessible(vma))
 				return do_huge_pmd_numa_page(&vmf);
-- 
2.25.1

