Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37EE398C2D
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbhFBOPv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:15:51 -0400
Received: from mail-bn8nam11on2066.outbound.protection.outlook.com ([40.107.236.66]:15585
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231737AbhFBOOW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:14:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=afBM8j+71HRxON9/Ck6T0eqAIzdGEVDEUH11aJXytP2+xLcESiWd0EfQmqcyVns9hSXMlnFtbRFeJ+hEi4qag0sXdrkuIcopA/Lpes8qnRLhr/mc0eo1qvKkPpL8qi4iGxtVABM/R2qdvEQB7AAEwMnkO+xmU2J3N0y+9BEJid4FPjOvyGDzLwU4qD+bFKYD4LBBPysQplu4sAAbKEYSBGezWnZDc3LPgIqmC9sKs27Uljj1VuuHapXLZpEDxhx1yyrqyzC+pKZLC/w4kSib7PVodMkPFALtNuV0MSF1tTLl0nN4PK1k2xVwOtNmJhloj3TUlmf2mKtfXEEy/r7LPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2X+kv6FsknAp8BL9+Ji1NgfORFMy5n4Qe+gj50/+jl4=;
 b=oBMdJwAwH/rC+v2yWMI1BrCsGJxcsYR4sJ3qRHYK7uP9gpiGvihsYNX2dkauwH0NRkjkPrU/UPbondKF6dM7tdX5zstK89JqBjCqC3yZH+3tJgcaoXWNlFuhhX5FJCRLNZrR3iAsPyiURxCs6mIhJ2Gkm3ooALhRn7fYoqXCXYXCcwZKLK/qMFow30ZBo0MYFDdGAJZRtkmiIp0FUoKm/sdEGAbMQH10vlvblbul5ogfOfaxRib8zFsFJWzZcVKhU4I1aJaqT1WH21rmlRWO9AyjncdynGjdKxQe3AjOvpUsE7mhoEXZN5fKNhK1YJNO6sNnJ+ZnH8RRag4yDcFLEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2X+kv6FsknAp8BL9+Ji1NgfORFMy5n4Qe+gj50/+jl4=;
 b=plcpTrbWIPIRebQMAp4nsDnBFhHYjVlsIDUyjds5MO8mAHqqHVdZoQOgV3S2+o6gCNijrzCDKokioVV5ocyr028AH9q2FWiGjkBhCojdQzk1BhbY1z0hFMMi1ixUNYKA0SjEBhvnU9DCYW8AcGqMsdwukJwOSPmmWJqb6MYzFBs=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2368.namprd12.prod.outlook.com (2603:10b6:802:32::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 14:11:40 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:11:40 +0000
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
        David Rientjes <rientjes@google.com>, tony.luck@intel.com,
        npmccallum@redhat.com, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v3 10/37] x86/fault: Add support to handle the RMP fault for user address
Date:   Wed,  2 Jun 2021 09:10:30 -0500
Message-Id: <20210602141057.27107-11-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210602141057.27107-1-brijesh.singh@amd.com>
References: <20210602141057.27107-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:806:d0::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74149feb-0f04-4535-fd10-08d925d057c1
X-MS-TrafficTypeDiagnostic: SN1PR12MB2368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23685681FF150A4F5C79C3FEE53D9@SN1PR12MB2368.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:332;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ThKKFvZDfhnAZyuTxdGd+Oie8mk6udTo3a7XIbZtQDrHbsslUVTT9I6QIvSnyjgGSUgWLCKSudZ0q3KNBQC6dNfcpSk4M84xf8R41AmEf2BmQOtW3WnvEKBgfs7MMDWYi0k3zvAkPzDXBxocQjGyqmmFepeX0w96KhezFLf0jLlCR1zCNKPK8fDXpN//zcWkvV3y3dRjP9a7TDrNVCNL8/vmgfL3ySBbmIVB+Xf7Gv+GtJX4yCm6fvEHRptZXFgHk9WvUg8/7oJizT9rIeia8Ds+UNzE/ZnaOP5Gjdzk3dEhqifPtkfxg/5LjSHq57QJTCvYrWeGYtMooSaOUkCYRLBsmO2wOA2IT+YJg+hJprJ5UpmT72he3aG2L5JGTPOID83hJ600hFpCqqNI+f0WIx/fruiLFjdE5WMLs1+fc7JoTGjuLNJmq1gzSBy6pRCw35BR/X9i8uvxofkObzUYn7WHljqb7Rc8/72rI8paDtzcSKXkJdvW9DqZpS/rouFjsBZTr/zjvT4xQIja2PaJlccRz07d0yHgoCzacfh7Pl5XfQLwDfE+t+5IRuZB4Ju83fIrIe9tg6uaFBsxptB/9qzQWTE4gb9B0ZOEty5/PHbRqkxzwc2hzRGurx+0TbxVtN33S3H0b/lkvXY6hSjU+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(5660300002)(86362001)(6486002)(52116002)(7696005)(44832011)(38350700002)(38100700002)(956004)(2616005)(1076003)(8676002)(7416002)(8936002)(478600001)(186003)(316002)(4326008)(16526019)(26005)(66556008)(66476007)(2906002)(36756003)(54906003)(83380400001)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?WcVQRwKt4miCTYwlCmnvCmaKbP3ivwfPHA2WCcOf3tk2Zttl+KBSe706BmAS?=
 =?us-ascii?Q?XMsnfeD4kkzXeX3+zpDLUQ/MfdoFed6nJF+hYVVXtS9HbRzYG4qlSh2yW3dv?=
 =?us-ascii?Q?k2M4qfYma56oVCEu7BULBtVG3Bt6JxJxTPx2d/efDkqVLV+y7+Bp2TyJduqP?=
 =?us-ascii?Q?v7zKrN9UBLkuQrlHNJECRSJAZYoMHkdjOqqxyB0HE0rVA319qfY9pAeD372y?=
 =?us-ascii?Q?4PvqEMMs3FUi1q8/klikSlp4N01J3kF2UZ2houSab/4vM+X9nIoy//XDbGr2?=
 =?us-ascii?Q?9b6TFPt3BvIqlHchwdrd91vY7Rmp8jUjW0CGFcQ/1UTYpqB79EYMMu8wcPAg?=
 =?us-ascii?Q?/xyzHOqqQMrOUmQeHxG3lHUyjtvC0nP5zj/b56KR37h5iu1x7b/5TQuKxheu?=
 =?us-ascii?Q?KF7yatym+fA9kEwc8E1uZZhO/5svWENK69MdKsiQBpZXHr4HJyE2/mVheqQX?=
 =?us-ascii?Q?p7/Y6fwqTmHrPq2/edvCSmlBcSaYCa0XSbwDuz5STiHItXgcRwVKdeJ2RVod?=
 =?us-ascii?Q?SU/M4Cxf9coxIIa+t73Hh0gDGCYpX40exP7blwEsmPgwLIjudYHdR+Jp4BWX?=
 =?us-ascii?Q?PjoIq7GDdvjZeFkfFFCxdRthTmxKh5uD7V8wH6daZV4eUTrjCRpN0gMnEFC0?=
 =?us-ascii?Q?xL1LHNiDpv1+8WY5JjXm8yqb18eGdkGkpuHmLTomtQDco6YzH3E3+e3WaaW+?=
 =?us-ascii?Q?arkUmKSxFx///+KjPz+Jk5BZ17+MBFZo1ttkgNj4GPJjglmrX/7aAPsJWvHe?=
 =?us-ascii?Q?QrxUhDonEnhIdl9ch4m5ttXegHipgrXmyyYmwr/qKwKLJbcZGoVAFp08CuPH?=
 =?us-ascii?Q?QF6RUgoIf1zpZAXpidNYcGo20EUhFls2tlKwJsiddIjWPnmKnW4DD7irzyWb?=
 =?us-ascii?Q?Orbzg0oOWMSYoh+9NuCRNwuJMF7rujbIvp+yOzy7P2c6hANMrq3xWRbHS86J?=
 =?us-ascii?Q?W//C/pNdVYUnNoMSU5rGAwP6A/VpKupf7m6AGGLulVLGt5S4iUxsQJzB9VzQ?=
 =?us-ascii?Q?lAN3U/T5Y006k/pi5KPxzloPbZoYjJeKzzwGNBOK/4Pa/fOGVSTOCji24R/N?=
 =?us-ascii?Q?2HJhkIf1F0HjqH9P0DeS4TuI3pWKjY/OQoFuTiGl6YOn6Q8q2q7xuQ2IYjLH?=
 =?us-ascii?Q?xxpFknzk7Ly06NrqjtmZ4p66CZH7rFKWp6yA2mTmSEN12n/qzs0ijFOr7tvR?=
 =?us-ascii?Q?tU4X10NkPPiUk1/FvqaapEm6T+kgK8dDOGO6pPcawyCU02/kOr4CpEqGxP2n?=
 =?us-ascii?Q?hGi616Cd6KE+3u0525yhhTfgDLoqxRP34cGKX49SD4TdKoCB41FCgpG7m2Ri?=
 =?us-ascii?Q?bt0RCMemy1Qq6VLa6BN+WNgR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74149feb-0f04-4535-fd10-08d925d057c1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:11:40.7091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oFLsu7jjufmnNA4w6zacb0oynqwY2RDpZUvVZu5YTpepcKEoGA9LVu9sP7kGbNA7uY0bh1pMfnGgZ1YPQqmnrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2368
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
SIGBUG signal to kill the process. If the page level between the host and
RMP entry does not match, then split the address to keep the RMP and host
page levels in sync.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/mm/fault.c | 69 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mm.h  |  6 +++-
 mm/memory.c         | 13 +++++++++
 3 files changed, 87 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index e6deedf27d78..f90d203a2e8f 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1280,6 +1280,58 @@ do_kern_addr_fault(struct pt_regs *regs, unsigned long hw_error_code,
 }
 NOKPROBE_SYMBOL(do_kern_addr_fault);
 
+#define RMP_FAULT_RETRY		0
+#define RMP_FAULT_KILL		1
+#define RMP_FAULT_PAGE_SPLIT	2
+
+static inline size_t pages_per_hpage(int level)
+{
+	return page_level_size(level) / PAGE_SIZE;
+}
+
+static int handle_user_rmp_page_fault(unsigned long hw_error_code, unsigned long address)
+{
+	unsigned long pfn, mask;
+	int rmp_level, level;
+	struct rmpentry *e;
+	pte_t *pte;
+
+	if (unlikely(!cpu_feature_enabled(X86_FEATURE_SEV_SNP)))
+		return RMP_FAULT_KILL;
+
+	/* Get the native page level */
+	pte = lookup_address_in_mm(current->mm, address, &level);
+	if (unlikely(!pte))
+		return RMP_FAULT_KILL;
+
+	pfn = pte_pfn(*pte);
+	if (level > PG_LEVEL_4K) {
+		mask = pages_per_hpage(level) - pages_per_hpage(level - 1);
+		pfn |= (address >> PAGE_SHIFT) & mask;
+	}
+
+	/* Get the page level from the RMP entry. */
+	e = snp_lookup_page_in_rmptable(pfn_to_page(pfn), &rmp_level);
+	if (!e)
+		return RMP_FAULT_KILL;
+
+	/*
+	 * Check if the RMP violation is due to the guest private page access. We can
+	 * not resolve this RMP fault, ask to kill the guest.
+	 */
+	if (rmpentry_assigned(e))
+		return RMP_FAULT_KILL;
+
+	/*
+	 * Its a guest shared page, and the backing page level is higher than the RMP
+	 * page level, request to split the page.
+	 */
+	if (level > rmp_level)
+		return RMP_FAULT_PAGE_SPLIT;
+
+	return RMP_FAULT_RETRY;
+}
+
 /*
  * Handle faults in the user portion of the address space.  Nothing in here
  * should check X86_PF_USER without a specific justification: for almost
@@ -1297,6 +1349,7 @@ void do_user_addr_fault(struct pt_regs *regs,
 	struct task_struct *tsk;
 	struct mm_struct *mm;
 	vm_fault_t fault;
+	int ret;
 	unsigned int flags = FAULT_FLAG_DEFAULT;
 
 	tsk = current;
@@ -1377,6 +1430,22 @@ void do_user_addr_fault(struct pt_regs *regs,
 	if (error_code & X86_PF_INSTR)
 		flags |= FAULT_FLAG_INSTRUCTION;
 
+	/*
+	 * If its an RMP violation, try resolving it.
+	 */
+	if (error_code & X86_PF_RMP) {
+		ret = handle_user_rmp_page_fault(error_code, address);
+		if (ret == RMP_FAULT_PAGE_SPLIT) {
+			flags |= FAULT_FLAG_PAGE_SPLIT;
+		} else if (ret == RMP_FAULT_KILL) {
+			fault |= VM_FAULT_SIGBUS;
+			do_sigbus(regs, error_code, address, fault);
+			return;
+		} else {
+			return;
+		}
+	}
+
 #ifdef CONFIG_X86_64
 	/*
 	 * Faults in the vsyscall page might need emulation.  The
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 322ec61d0da7..211dfe5d3b1d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -450,6 +450,8 @@ extern pgprot_t protection_map[16];
  * @FAULT_FLAG_REMOTE: The fault is not for current task/mm.
  * @FAULT_FLAG_INSTRUCTION: The fault was during an instruction fetch.
  * @FAULT_FLAG_INTERRUPTIBLE: The fault can be interrupted by non-fatal signals.
+ * @FAULT_FLAG_PAGE_SPLIT: The fault was due page size mismatch, split the
+ *  region to smaller page size and retry.
  *
  * About @FAULT_FLAG_ALLOW_RETRY and @FAULT_FLAG_TRIED: we can specify
  * whether we would allow page faults to retry by specifying these two
@@ -481,6 +483,7 @@ enum fault_flag {
 	FAULT_FLAG_REMOTE =		1 << 7,
 	FAULT_FLAG_INSTRUCTION =	1 << 8,
 	FAULT_FLAG_INTERRUPTIBLE =	1 << 9,
+	FAULT_FLAG_PAGE_SPLIT =		1 << 10,
 };
 
 /*
@@ -520,7 +523,8 @@ static inline bool fault_flag_allow_retry_first(enum fault_flag flags)
 	{ FAULT_FLAG_USER,		"USER" }, \
 	{ FAULT_FLAG_REMOTE,		"REMOTE" }, \
 	{ FAULT_FLAG_INSTRUCTION,	"INSTRUCTION" }, \
-	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }
+	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }, \
+	{ FAULT_FLAG_PAGE_SPLIT,	"PAGESPLIT" }
 
 /*
  * vm_fault is filled by the pagefault handler and passed to the vma's
diff --git a/mm/memory.c b/mm/memory.c
index 730daa00952b..aef261d94e33 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4407,6 +4407,15 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
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
@@ -4484,6 +4493,10 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 				pmd_migration_entry_wait(mm, vmf.pmd);
 			return 0;
 		}
+
+		if (flags & FAULT_FLAG_PAGE_SPLIT)
+			return handle_split_page_fault(&vmf);
+
 		if (pmd_trans_huge(orig_pmd) || pmd_devmap(orig_pmd)) {
 			if (pmd_protnone(orig_pmd) && vma_is_accessible(vma))
 				return do_huge_pmd_numa_page(&vmf, orig_pmd);
-- 
2.17.1

