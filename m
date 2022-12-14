Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9BC464D05D
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239307AbiLNTxP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:53:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239280AbiLNTwn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:52:43 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E272BB25;
        Wed, 14 Dec 2022 11:50:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fb8b8FqMgguh/APREXyxGsv3Ha2kDAHaAqkMnuiEcAFj7oUjeOrO3YbGndkqQcoEMr8F/vvSs3sEWL1VSMQnJB3404ABxVZV2N5PnqfhorQT+ZqX7kf5uQ+ppwfNqFU9Wweq6oZuGKgMwFjVheceL92PlrpTBhddbbAlwEgBw4/6o4irg0HJNphtyuN+7HHxZPmqloSPxZJugdXaWod6JVoKml7Hh22AqU8DAv0d2VSZhEGrwK6X/rbcJudoyUEMbxUbxqGpCu5TWwEo2/WTD+CL3se0C5Eyne6sKdolH1QxOxIFNS5KpMx74A1zzIqp+GIglCRWubkeOVRD+VbMgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9LtoKmzOFERPW2EbZIkR/ImCBYp760e0sF60z6DPADA=;
 b=HDvtZYwD11/sBpIcyk+dNNmPNeCVk0GNdRmlmsSxCHduRi6FyUX+vQZc7dXvTQA6YZ9wcKKGYhA5vxJQdF9v9GNbqbajFDj5BbsnbucGKtprlIFBM6xqhpBzwjo045SGUMCyykOb960WA66WxIYSdh8ks4Uly031VPK7qBhysfuH/05iV+cW7IXw31Ni4FeOv/ikvxHgLcmLXBbqxhpatY0pcCm1iUgVJ2XAYxuihnd38P/pVytyVDy2An64B2GvEUIukm1LNIH9mZ5zIkAzfghTBs4XnOkwXHCVxLvzxU0P+R0tqfuIafQDdeh9eHrP40Ei4JBKQukXzMZvzIXJ4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9LtoKmzOFERPW2EbZIkR/ImCBYp760e0sF60z6DPADA=;
 b=4s8MVY5PZNNhw/WTUWK8AW3gFucs+OdDGORBRv9DSFliGhJg7bY2F5LWFLRSi9VxU/jX2fHLoRTW5wqa9xrK65qr+Ectoo4VQrpoZcRmrQVXMcwlLkH2HDuMgOtOXvjI0TAAIm//WZY0E1h07InZ01+cjexZMXHYY99DiPIZW6s=
Received: from CY5P221CA0001.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:b::20) by
 PH8PR12MB7447.namprd12.prod.outlook.com (2603:10b6:510:215::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5924.11; Wed, 14 Dec 2022 19:50:56 +0000
Received: from CY4PEPF0000C978.namprd02.prod.outlook.com
 (2603:10b6:930:b:cafe::fe) by CY5P221CA0001.outlook.office365.com
 (2603:10b6:930:b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:50:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C978.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.10 via Frontend Transport; Wed, 14 Dec 2022 19:50:56 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:50:55 -0600
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
        Brijesh Singh <brijesh.singh@amd.com>,
        Jarkko Sakkinen <jarkko.sakkinen@profian.com>
Subject: [PATCH RFC v7 20/64] x86/fault: Add support to handle the RMP fault for user address
Date:   Wed, 14 Dec 2022 13:40:12 -0600
Message-ID: <20221214194056.161492-21-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C978:EE_|PH8PR12MB7447:EE_
X-MS-Office365-Filtering-Correlation-Id: 12742c80-aadb-48ab-e919-08dade0c840f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jeY4V549PtE4lpiCqMR4/eq5M9IKng/LFBEM5sRL0sT7zBeL2xx1BhGhSB+CRtqAWNqiiUt+AK3HtVm1jaq+vUFRG0RG4NnASKcV99uxq27z+CLk37x22Vh/5b0Mzch3PZ8tIFkDypJUx81Hla6/PXHMJAe/VgTAjoyYB3WmyKPWmsyxta64I35E293+ErEVD1VGZR4amwN2IEQXcbPpsDLsC9KXHmCDw1cnKXeOP1oS2FV7W1oEHz3YbOWz5y8ZB6sDj6oyrT6TcolrLov4L42258ux91C3iQfoXONZ/vAI8p7uv2t3iKxojNx6hqzPIX3iDuPPdl6BiJCZ7TTe05ifyAKhwkv7VVZRIkjXrIFYU6fSjfZBHMcHYSGkKN8igeiO6mgW0TboqZd8b40OxTOpftYOZ/F3mf1NSxohO6a4WGjhtUBO5YDUdxDSiAfjeUh27wW0J1C5UBup8aVSB5BmkA+qduV9PykjMRqNU6UkeQM/ab/GjyKywAtlFMfv0fMVFscTM4zAXwG2A8w7brXJTJs0Wn+Q44kgQlDPa+zyg4Ii1RI5AXl+OAie8TdAUQS3T2XSGGMAW3N1jOGb+1AaLoinmE0o19ZYW2ea+HxB1Xk4PggMBM3gvoVYR3xWlzDSoW+QRN74+agimW5X1RCvPeQdvmHQZ+PVZ0asoYN8qFy+j94PtOqDK73WZi1L/g8S1JGUddMqYqS4kiev8Sj//HwBhwYho/ywHo31Eug=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(376002)(136003)(451199015)(40470700004)(36840700001)(46966006)(86362001)(82310400005)(478600001)(6666004)(16526019)(81166007)(356005)(186003)(82740400003)(26005)(8936002)(336012)(2906002)(1076003)(41300700001)(54906003)(6916009)(316002)(83380400001)(40460700003)(44832011)(47076005)(426003)(36756003)(7416002)(7406005)(2616005)(40480700001)(70206006)(70586007)(4326008)(8676002)(36860700001)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:50:56.1861
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 12742c80-aadb-48ab-e919-08dade0c840f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C978.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7447
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
 arch/x86/mm/fault.c      | 97 ++++++++++++++++++++++++++++++++++++++++
 include/linux/mm.h       |  3 +-
 include/linux/mm_types.h |  3 ++
 mm/memory.c              | 10 +++++
 4 files changed, 112 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index f8193b99e9c8..d611051dcf1e 100644
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
@@ -1240,6 +1242,90 @@ do_kern_addr_fault(struct pt_regs *regs, unsigned long hw_error_code,
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
@@ -1337,6 +1423,17 @@ void do_user_addr_fault(struct pt_regs *regs,
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

