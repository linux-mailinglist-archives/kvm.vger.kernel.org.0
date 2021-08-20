Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DB73F30A0
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233873AbhHTQCS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:02:18 -0400
Received: from mail-bn8nam08on2041.outbound.protection.outlook.com ([40.107.100.41]:41272
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234115AbhHTQBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:01:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LZ/3ERwvsg0aSCmcI4O5AiyIYyulCq4niK59itZ1phre7EnpovRyBqk8Xb4yaFqbcg7+H3/XITXLyOEwFUfrt2ropL9I6fQWP9kEtQX+RFvtr+yt78nZl+aFa9yg2AFACPsJMcrrkQck3aajjwtYcEHEYNWxx8Si4nk8x2zb1JCuDLyKhajmxaWuiaUUglgBsJ4RHC7b/Aot1/5RSOg7WciN8XH5B2F52M2vebPFNuEO345vIcZzkL4BEfdmX3+DMcr6dymYtzVAEkfLZOInSNQ/XoNycAJIjeqe6y1bj4UkwvgaVutQaE70+N9BhQoNFRI3XvFczhSNHNrP5Z9+uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=98DtS9JM1I+DiexvI/B1gLAoM8L/pKgfG2QGPzZbbGU=;
 b=gscNaqUFJLiosyg5sA4Q83OnBihENS0NSrL+nP2qEgHBji0oGzZ8MlTIf1Sff4aA/B6EXoopsk8WqZ78IXlDkGhfIz2rjmmTU6WDKSz5jOVbBPBmUE7L+Fpoe6vsrHC/8+JChHkuds6Sp7zcv7cUaagQOlRr6u3vWO04RL6hQ/sB+YKRqEy38C2gy+vYvlLboSmU/Ch9sdjgC4EibH4nJP9GdrNLLqzVYpyrhP+ft+q5S0StjSzvFyxcoMaaveoRav8kuoDbzy6KISYRaDoR51adUggdCVMKkGoyY9sw1LieOSy3kVzqIwEhBoqBvWd8MB2epvaanAU+Br6ZXrC29g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=98DtS9JM1I+DiexvI/B1gLAoM8L/pKgfG2QGPzZbbGU=;
 b=qnap4gN5fuJvko/t8b1FiFMrFhn6RY6xHLTVyIJFuYPHACw38QeUpWj0TggUWf526AiDAOZMZadstwidPLvdfh8k4evv28siLAucom8vh41E+TL8sf5VK5Zc/fXPYdaB+6xtMt820hsTC7lYo4v9uMH5R7jcNhwPl6CXlOo5ws8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:00:04 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:04 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 v5 08/45] x86/fault: Add support to handle the RMP fault for user address
Date:   Fri, 20 Aug 2021 10:58:41 -0500
Message-Id: <20210820155918.7518-9-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a325673-4258-4d4c-63ca-08d963f392a6
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384ABB9CC10756414F58C9AE5C19@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5L0oN+z4mf2JRn7y/PVPMEKNmK0jHW8TqA0uX0x+/ZOMteWvwt2PSeFY8Ae88vB1Yt7KPShxzwGXN8/Jv92vHoeOYpkSiH9R5GKtxxPA3Tub8xUAjevur2ucomsxcVn5h4ouPDDliKPAwECEpLwfQgTgLXQ/WnoQSDVWdLD15bTOdjPGMnczwAc74E2KuqEi+ScqZv4vK0IT5O0r30WW7sET+Qqt/emSEL1DmzoJJbazHlTvl592a/0821Sj1n3TbO7R590KuaZ6j5x9Tl6LvyAbKvttNAT6ZOxcKr5xTYXm7u+fccqsvRgY41MvYXx3M3GWKRsayAu0MsL56NrA4+kiv3JIEnHUYNQveAMw4ofKy3cTkjF+7ZPtkJPrXTorardvNMQUAcuJR6EOdbV6fxvNQfZZyguZzef3tM5cbEzrut1oTfxcK5k3Ndc6rrfUlNPIj1ShkbCE3kJJuJSH3yoCsudR9vT/j8itNGpdOi+GxDdAmzvneh0ieU0OHfdYnnbuKc/6rruudRzaBIl2SLzUIYuOZX7bdtP3MW+s0tNneRaxozwzt1o0dzI7if6Yhpu0zT0zhSWEaEMEv7aAbEHLy/PLZxaKHURFKshMjsOyCCCbUB9+lHHnnsc7n/3aqgGnA4/7qETsScQnuSQa2tVMM6j/CHnlX5iWitIa8W7amEdcV2viJx7fZFeGNrJH14GYiWhxDXKt27OuYHerVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(5660300002)(6666004)(52116002)(66946007)(44832011)(36756003)(7416002)(66476007)(7406005)(6486002)(956004)(8936002)(316002)(2906002)(186003)(4326008)(478600001)(86362001)(26005)(54906003)(38100700002)(38350700002)(7696005)(1076003)(8676002)(83380400001)(2616005)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4mVsba6kmmTIbCmbFKDwBpHzwv5kjapO5sc7C+KvZIL+sY8V66ErgXAmYM9v?=
 =?us-ascii?Q?YSscWW20w0QztqLCZnYh5UafcjAQCW0PNEAQwvmi2Q1sgLinu/5M8Dth4x5w?=
 =?us-ascii?Q?ZfwFr7EfN2UjvsRDJKaOzozcmXqh0ABoA4F7756Db1nJ07pV0esl6inI8KMU?=
 =?us-ascii?Q?UpCdxvRmGyLk2WiQarpibLseZMxt+WiHGZydl4ZsH5n2OC+LvkWdst4bsO71?=
 =?us-ascii?Q?DCHp64RcoFqwqR/f2PnkPYDs8k/FmNdaqzfrhBv6efnDE7HyUTH8mcAJuVWm?=
 =?us-ascii?Q?ph6gFxgrdqKxa78mspncMB/ZxdddczNn/wpv4aX0mudZZkyVm2JqoYu+cFtW?=
 =?us-ascii?Q?laj9tXAkFnbyjD0fdqABE2jycRfZZevwVmvYma2YiIgrXFlylHzSpW4V7bKN?=
 =?us-ascii?Q?cOqs3lYcR+qCl+qNEHim4+iazGqRaJebFdPYiR2MPA+0B7GidPhiHWAQhsQB?=
 =?us-ascii?Q?WYpqbnGmPw4hca7R0uQyQ1v4JNlJFbBRskD/qIFFGVctExQCn+FrSUUWgky9?=
 =?us-ascii?Q?pw+y9WB3iuXjcfPRzj2FntD2++M9DENW78RtdqGY4d061rVZKxlVgdGqhBkq?=
 =?us-ascii?Q?duFLKB2vEg5WONPRvHqntcVBRYdPZD/GlA33wK78ZJOBNqc+0yXuAxtC+4go?=
 =?us-ascii?Q?8g6ONXvA4A26Xli/xuK/T1sU4XXjMiQecq88iUh1EW1/34IesDKDoYAlS2KU?=
 =?us-ascii?Q?lDirHnLA1LFplTGChD1igCyUsuK4ulUQsaobdUic3lp3kjc8ZN73AmA2TL5v?=
 =?us-ascii?Q?L24QwD6VawsXvOCNanc6T8XQbapQBJnb2dpOFXHx1j2uRzXMLAFw85FDr/hb?=
 =?us-ascii?Q?f7QX7OvB6tQ2AOx5IWW3D2GZ5wXIpXpqtlbcIs2LnOAUjTt24FpyXK2LoVoV?=
 =?us-ascii?Q?OtqjAYad97I5uk4gd8AgVbzAZRJa9wLRG6eNR4Pe4nfz2XAespf+xtBqcrlL?=
 =?us-ascii?Q?axvpaRVl7p4uEgtP7KDPVW07xvyDSaFtJSr/elJT34owUH67A5Orw+cfSGYC?=
 =?us-ascii?Q?z9IbbHpiZbG1ZPERxjXTEyGmg4Qi4B2n7TG3FSSCCo2Bemv+7BPFZRBIODpX?=
 =?us-ascii?Q?KgUYOTL6IOy18Jz2cQ74qWs3Bw/++/MxJucdBmpFAyasvhe0S9ybDou/gP8W?=
 =?us-ascii?Q?3um5aibEbsSlfz1pf5qJ6uFGv0DTN4pGomsBlfFwsIUNVyZQQOfK98YeBqdo?=
 =?us-ascii?Q?galGpsM1pVxOI+NzCC18AqSMfwnooWpM2EU7honXl8f6oG3jQOXy0J989Nbn?=
 =?us-ascii?Q?Ck7hkaAIfE/DUPqJQth3rX6e58omVDpO9DyU7FbcRVqRNR+HSGPEHKTbnrfQ?=
 =?us-ascii?Q?7dtjYnT+67+YkURG7jJqouCp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a325673-4258-4d4c-63ca-08d963f392a6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:04.0165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KY3jmId+8kpDY5Eb+Qq/sFL0hgQAlfWT1ArWI4KPKR2JWC4OGxU0FmEgf0y/9IGGaVRij+cakpzRi3XIeMz+UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
 arch/x86/mm/fault.c | 66 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mm.h  |  6 ++++-
 mm/memory.c         | 13 +++++++++
 3 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 8b7a5757440e..f2d543b92f43 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -19,6 +19,7 @@
 #include <linux/uaccess.h>		/* faulthandler_disabled()	*/
 #include <linux/efi.h>			/* efi_crash_gracefully_on_page_fault()*/
 #include <linux/mm_types.h>
+#include <linux/sev.h>			/* snp_lookup_rmpentry()	*/
 
 #include <asm/cpufeature.h>		/* boot_cpu_has, ...		*/
 #include <asm/traps.h>			/* dotraplinkage, ...		*/
@@ -1202,6 +1203,60 @@ do_kern_addr_fault(struct pt_regs *regs, unsigned long hw_error_code,
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
@@ -1299,6 +1354,17 @@ void do_user_addr_fault(struct pt_regs *regs,
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
index 7ca22e6e694a..74a53c146365 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -447,6 +447,8 @@ extern pgprot_t protection_map[16];
  * @FAULT_FLAG_REMOTE: The fault is not for current task/mm.
  * @FAULT_FLAG_INSTRUCTION: The fault was during an instruction fetch.
  * @FAULT_FLAG_INTERRUPTIBLE: The fault can be interrupted by non-fatal signals.
+ * @FAULT_FLAG_PAGE_SPLIT: The fault was due page size mismatch, split the
+ *  region to smaller page size and retry.
  *
  * About @FAULT_FLAG_ALLOW_RETRY and @FAULT_FLAG_TRIED: we can specify
  * whether we would allow page faults to retry by specifying these two
@@ -478,6 +480,7 @@ enum fault_flag {
 	FAULT_FLAG_REMOTE =		1 << 7,
 	FAULT_FLAG_INSTRUCTION =	1 << 8,
 	FAULT_FLAG_INTERRUPTIBLE =	1 << 9,
+	FAULT_FLAG_PAGE_SPLIT =		1 << 10,
 };
 
 /*
@@ -517,7 +520,8 @@ static inline bool fault_flag_allow_retry_first(enum fault_flag flags)
 	{ FAULT_FLAG_USER,		"USER" }, \
 	{ FAULT_FLAG_REMOTE,		"REMOTE" }, \
 	{ FAULT_FLAG_INSTRUCTION,	"INSTRUCTION" }, \
-	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }
+	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }, \
+	{ FAULT_FLAG_PAGE_SPLIT,	"PAGESPLIT" }
 
 /*
  * vm_fault is filled by the pagefault handler and passed to the vma's
diff --git a/mm/memory.c b/mm/memory.c
index 747a01d495f2..27e6ccec3fc1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4589,6 +4589,15 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
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
@@ -4666,6 +4675,10 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
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
2.17.1

