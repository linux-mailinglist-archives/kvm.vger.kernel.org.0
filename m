Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF5C55278E
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345560AbiFTXFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345583AbiFTXEF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:04:05 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E607C64FE;
        Mon, 20 Jun 2022 16:04:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KNvnjJB/inM4nzh0ZEomU5veJ5znbLcOKovaQdGxhG/J48BAoUtvooWgfAEK4QYMLkJZMjColkHO7hRXaMh9RNJXf4rv4D5m53SMjW20Pt/GiM7AUn8c3OzP276u5pPmKy3yI7bxzwaS9Iz5yjnO32SXCSXvxGSWLvaqp9kHMG4FRNPUdJJbYthmTqRNRZN4haLB4C7qgBZDl82qpI5LDKWNasi5FIx7Y0XaGbKQL7s+y61MP76O36cyI7nRUx2yVjjIGyuLsoZU5O85pWKvs661N1QkNV6CtxHI+Y0ahlm9Vfl5XHOeunzxppLLXgWJVqpOxwuXmzFsMUoKUWKGRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PBTiarWw3c9UerDPI+x3Dt0qD83dHvqYQq1OSMgRGyA=;
 b=i/JtL0A+hpoRiJzqX1k0YR3LhrEzpHxsDHqdBl8drq55oRYNxEUDczJUEis8S7+XLKwTO9V1xK/vW4zboud6psAZ8JcgJn65YeJesPay65gh3XV3T+j4ZacZKlakt3DmKzuQ3Cbu8WG+JFgCCeOogqFYyBjOzUahWlIRnV9/oe7knZ8DntJTmGXhHsrPIf+O5tPt1IcVuILEEmYHor/UMxTm0v8vg7hol25hCyNIdXXZxL3NzpUGs6U0ysJ4ModufjbdAZAc8CBM2Vlm3esyX6uw2/vNzjd0vnOvZb50bssfnCJ7N1PIlI9xqVLJPtE+RcBDnewmRaqcVGXst9GVog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBTiarWw3c9UerDPI+x3Dt0qD83dHvqYQq1OSMgRGyA=;
 b=ZZg7O0BaJQHMOQNC1bJgILwmXHi9nW9ZjpFsOGe0Y4ELyqASCF1FcobQGdVuimlp5U3C/XuQ1cgHRvoRGiX3X5IrfQABl+0Tj2tkFowsJRc9K6KLpLYm8D7NP+069EWkJiTrwQ2xltObf6xythwQTN5LW6dhrPc9IF2gD/my+fE=
Received: from YQBPR0101CA0173.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:f::16)
 by BL1PR12MB5852.namprd12.prod.outlook.com (2603:10b6:208:397::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Mon, 20 Jun
 2022 23:03:55 +0000
Received: from DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:c01:f:cafe::f2) by YQBPR0101CA0173.outlook.office365.com
 (2603:10b6:c01:f::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15 via Frontend
 Transport; Mon, 20 Jun 2022 23:03:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT044.mail.protection.outlook.com (10.13.173.185) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:03:54 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:03:51 -0500
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
Subject: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP fault for user address
Date:   Mon, 20 Jun 2022 23:03:43 +0000
Message-ID: <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 063eb8f1-3788-4833-90d7-08da53112611
X-MS-TrafficTypeDiagnostic: BL1PR12MB5852:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5852E02BBE5BFA2FD5149B5C8EB09@BL1PR12MB5852.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KFf4gRocrtpowiytW2poXUbGfDqzP4FqnYWFGhLudnysDRgsfv1nG5XKXauR3uHhnSP6YnQRUEgNX6LpkUfbmwfL9DrBBb2ibOJquieklG0X59/ng40V2iQtnhvqfHLIvUJIdM753kUncoVhDrkT/tmUgjVe3Vzmmu42oGKWGy+iPIFer2rhTbS4WlUDoL9MVrWg3IdZyl+LDneBFBkP5CJf8woQgy6xmbYoOCHXtNKL5o6ksq3TzycRIoPST9BKZBMyIRjBNWs5qZrRrlMGVkI0BgX5DP2IBwsEgM6XAedENzuK3206It6L85xrwX1GWAFxQoTc+ALXCER5h0fhVB6VxSwjnJnD0JBBSLuMzAecq2GxKgxGB7ZzU4alqeut5so+Cos1wD+lkVjZWqzn7/PQB5WXao37CSfSSM6B8WlgjiRcQ1jrOsrpUsOqAEiS1BivNvD+o5bCwxwbdd/9hEbdnPBw2UnzFi13XiZjuvLqKtV7cRKsBgR4CVCCwaXtsXDkZBxLroay8be2CMuYZDemqZjS3fFs7Y0o9kOEcFgFx5iG0MSe52UP+6Ya9iq9S/w/9jRxkYyxB8OaTsyooPvvtg5zBmfCBBLCHY5GYdZo0VizG7ejy++KBbvcVGSwMMG/kLKQMoHqdpyVoNirWS4gCVqo88RicFQelnVQMgmudns8TmyzWISjo+YckXK2NswRIWYQ99my8X7tzCwPSYI4dBAybQwjxrpz8Uj7kAF7mQiUCtqG8l8IHYXIZTie8lnrWcy+xSFFgFqTAKslYw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(136003)(396003)(46966006)(36840700001)(40470700004)(86362001)(4326008)(110136005)(5660300002)(426003)(83380400001)(41300700001)(47076005)(8676002)(2906002)(81166007)(36860700001)(70206006)(70586007)(40480700001)(2616005)(16526019)(336012)(54906003)(478600001)(7406005)(36756003)(186003)(26005)(7696005)(6666004)(82740400003)(356005)(316002)(7416002)(8936002)(40460700003)(82310400005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:03:54.3487
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 063eb8f1-3788-4833-90d7-08da53112611
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5852
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

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/mm/fault.c      | 66 ++++++++++++++++++++++++++++++++++++++++
 include/linux/mm.h       |  3 +-
 include/linux/mm_types.h |  3 ++
 mm/memory.c              | 13 ++++++++
 4 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index a4c270e99f7f..f5de9673093a 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -19,6 +19,7 @@
 #include <linux/uaccess.h>		/* faulthandler_disabled()	*/
 #include <linux/efi.h>			/* efi_crash_gracefully_on_page_fault()*/
 #include <linux/mm_types.h>
+#include <linux/sev.h>			/* snp_lookup_rmpentry()	*/
 
 #include <asm/cpufeature.h>		/* boot_cpu_has, ...		*/
 #include <asm/traps.h>			/* dotraplinkage, ...		*/
@@ -1209,6 +1210,60 @@ do_kern_addr_fault(struct pt_regs *regs, unsigned long hw_error_code,
 }
 NOKPROBE_SYMBOL(do_kern_addr_fault);
 
+static inline size_t pages_per_hpage(int level)
+{
+	return page_level_size(level) / PAGE_SIZE;
+}
+
+/*
+ * Return 1 if the caller need to retry, 0 if it the address need to be split
+ * in order to resolve the fault.
+ */
+static int handle_user_rmp_page_fault(struct pt_regs *regs, unsigned long error_code,
+				      unsigned long address)
+{
+	int rmp_level, level;
+	pte_t *pte;
+	u64 pfn;
+
+	pte = lookup_address_in_mm(current->mm, address, &level);
+
+	/*
+	 * It can happen if there was a race between an unmap event and
+	 * the RMP fault delivery.
+	 */
+	if (!pte || !pte_present(*pte))
+		return 1;
+
+	pfn = pte_pfn(*pte);
+
+	/* If its large page then calculte the fault pfn */
+	if (level > PG_LEVEL_4K) {
+		unsigned long mask;
+
+		mask = pages_per_hpage(level) - pages_per_hpage(level - 1);
+		pfn |= (address >> PAGE_SHIFT) & mask;
+	}
+
+	/*
+	 * If its a guest private page, then the fault cannot be resolved.
+	 * Send a SIGBUS to terminate the process.
+	 */
+	if (snp_lookup_rmpentry(pfn, &rmp_level)) {
+		do_sigbus(regs, error_code, address, VM_FAULT_SIGBUS);
+		return 1;
+	}
+
+	/*
+	 * The backing page level is higher than the RMP page level, request
+	 * to split the page.
+	 */
+	if (level > rmp_level)
+		return 0;
+
+	return 1;
+}
+
 /*
  * Handle faults in the user portion of the address space.  Nothing in here
  * should check X86_PF_USER without a specific justification: for almost
@@ -1306,6 +1361,17 @@ void do_user_addr_fault(struct pt_regs *regs,
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
index de32c0383387..2ccc562d166f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -463,7 +463,8 @@ static inline bool fault_flag_allow_retry_first(enum fault_flag flags)
 	{ FAULT_FLAG_USER,		"USER" }, \
 	{ FAULT_FLAG_REMOTE,		"REMOTE" }, \
 	{ FAULT_FLAG_INSTRUCTION,	"INSTRUCTION" }, \
-	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }
+	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }, \
+	{ FAULT_FLAG_PAGE_SPLIT,	"PAGESPLIT" }
 
 /*
  * vm_fault is filled by the pagefault handler and passed to the vma's
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 6dfaf271ebf8..aa2d8d48ce3e 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -818,6 +818,8 @@ typedef struct {
  *                      mapped R/O.
  * @FAULT_FLAG_ORIG_PTE_VALID: whether the fault has vmf->orig_pte cached.
  *                        We should only access orig_pte if this flag set.
+ * @FAULT_FLAG_PAGE_SPLIT: The fault was due page size mismatch, split the
+ *                         region to smaller page size and retry.
  *
  * About @FAULT_FLAG_ALLOW_RETRY and @FAULT_FLAG_TRIED: we can specify
  * whether we would allow page faults to retry by specifying these two
@@ -855,6 +857,7 @@ enum fault_flag {
 	FAULT_FLAG_INTERRUPTIBLE =	1 << 9,
 	FAULT_FLAG_UNSHARE =		1 << 10,
 	FAULT_FLAG_ORIG_PTE_VALID =	1 << 11,
+	FAULT_FLAG_PAGE_SPLIT =		1 << 12,
 };
 
 typedef unsigned int __bitwise zap_flags_t;
diff --git a/mm/memory.c b/mm/memory.c
index 7274f2b52bca..c2187ffcbb8e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4945,6 +4945,15 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
 	return 0;
 }
 
+static int handle_split_page_fault(struct vm_fault *vmf)
+{
+	if (!IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT))
+		return VM_FAULT_SIGBUS;
+
+	__split_huge_pmd(vmf->vma, vmf->pmd, vmf->address, false, NULL);
+	return 0;
+}
+
 /*
  * By the time we get here, we already hold the mm semaphore
  *
@@ -5024,6 +5033,10 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
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

