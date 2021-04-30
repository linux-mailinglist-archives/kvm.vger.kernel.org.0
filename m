Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6113336FA87
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhD3MkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:40:22 -0400
Received: from mail-bn8nam12on2041.outbound.protection.outlook.com ([40.107.237.41]:60768
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232543AbhD3MkE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:40:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JtikAgUx0WYIkC5maE5NqCwUwxMvLbG8b4vu/ZVPXZBHOk2JyIEYdGO3hq4peqn5ErZ/QtaUQv5US3aGVmSBgdUIQvBx5EKHbAUSHM3pixKdvTrlu0jelO9qqLE9XO3nqMjFNfrhWn3AOg8g0KA3WCjt4xlcn5nFDZA4yRuWkGBLXwF9fXFapJed/mvj2NpBL0vzdP6V3xnAwOl5BD/xhbE73EaVRyRenWayVNvfhvyjUBeykIb+jk0V/QEoL1zZRfSwxbU4rZRX8NBSzr907EbL4TakNblhGqk1+/guxFyjIJ9pjauWuexc2xIUgO0CfROiqcGIMvnYcgije3x8bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S+61kpZuBnxPQA6Jak/Dfpo81a0hBdVaTDnFYoNbg4s=;
 b=EdVAxeSuY/j59yb5KS51nW6MrVtg/ViGXmBPFkd7Fz2GtUbWS0k8OvvmY+kVrTNf5IeWiPYHv75pPzvbltIsG7cm7t9yoR3B04v6354J3LM+EH+u4QclD4Y0SwCh4bm+A69542tLBmGVaeygxFdTo0fNX4WZweE3nvxUkAl1NNYqCpYea0x6w9MPSOsWOnHU1OrAKeKCw08r2Nadz6nheE8U1SqSSDePSt4gAH4vU7JQ1Mf/c6REWV3Z2uWyJvIzWpkxOrtzZjHpihVckJGdBf1i3mowOmq1zGFHcR6UsvY/A9CFtJiLTqSNHVsu3NoK0bYZdUDEhvpNnjX5E0jQnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S+61kpZuBnxPQA6Jak/Dfpo81a0hBdVaTDnFYoNbg4s=;
 b=hYTRC4ZjYGnyMv/UmuLJr1+XYs/h77hNS35DxRtYvB9KgTXUm3WlQ8LvwWb5VGywjeE48aHLSr6iMcvrrp00Qp2uQSES1+VmV9mzhkk+1t8V8miIyVjrNoUO2VfRNPJxSb9wdNp7/rh6uhKkI9PukcODt8D2k0/2G9fRKrHQE6Y=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2832.namprd12.prod.outlook.com (2603:10b6:805:eb::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Fri, 30 Apr
 2021 12:39:02 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:02 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 11/37] x86/fault: Add support to handle the RMP fault for user address
Date:   Fri, 30 Apr 2021 07:37:56 -0500
Message-Id: <20210430123822.13825-12-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430123822.13825-1-brijesh.singh@amd.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0089.namprd05.prod.outlook.com
 (2603:10b6:803:22::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18d24d63-1728-4cfc-e468-08d90bd4eeaa
X-MS-TrafficTypeDiagnostic: SN6PR12MB2832:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB283266EB2C9D9B60AEACAB5DE55E9@SN6PR12MB2832.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:332;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fyK//B10I8ogPVcjYYv6+s3MwiyTyPIBJePOEqvSYNF7EyjdEvyGIm6nNRryaCcdwNdN1fErcXxKB9zwLEndIqC+Oxr/FbOHW/M/Rt/l7LycQiwfEhP8nUT4inMOBaJkTazzp31ox44No3LQU810JFGserDdJG7ymnohSQmV3PtHFGKnaIE4bszfZQds3E9SP0HGhVyKTyW5KxL7hfQWIbJ2FxJ6UJ32JCZ4CyudVkIrsoqPMZgXw/p3c7w0/71dMKXXO/utOyz9+6RMvYY+61n8V80HfLjIAv3jZ9GzYoIUTghht0NAKQzVb5e/XbIPLDRmKY+FaXfKVq4LffbsqHyyZlsBMPfMfKb8mEtuJj8TS6UGp/O9N1wq6Cid696gETATThU5KD/xSzX5EwzP/rphmM7Jpp6Ca9eSW0XzXZrxkWZMeBF5Y6lsabhaHASYDe03mdMINbi4bWHKkEsZfsQkPtASDhqqSjNQ0RtEmRGPgpO+4Sfi/95WnBWEDZEkHv91qFwZF3FxfWAceU8wEgMYMjDI2SllnJRi1+3CGYdqeu2+OdZYmw8IwNoZIsK05jWIfQTrfL5RNWGLNcEallnen5Ns36J6I2wCFE/tPC8p4cm3JWpOaVJmmu2Z+OqbIf+t+bAyy4T1udjMUwW6bA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(66556008)(956004)(7696005)(66476007)(6666004)(2906002)(7416002)(66946007)(1076003)(52116002)(38100700002)(186003)(16526019)(4326008)(2616005)(6486002)(5660300002)(44832011)(8676002)(26005)(316002)(8936002)(36756003)(478600001)(83380400001)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zq8g2EYKPlNu6+mGJs8abr5IdI2AedqE/dDlyHZ2DghKbr6putvbjvFTy0mm?=
 =?us-ascii?Q?jHNqGzljj2/8vQFV0GdA9tF4HujOYUZRd/gjQx09DvedTgLgx0PuVoMiOJ/I?=
 =?us-ascii?Q?bkw5F9CwvBJUaUPqyaNvBjW+Ufm8KPjBAaPy6qMjaqg9Y7V3P6XD3reRYtpm?=
 =?us-ascii?Q?7BJx/d9qZnAlF4ITMARIogkRIlbxLgYpa7wh5WY/0Ch9Pg69caQ6U9CDD4Da?=
 =?us-ascii?Q?o2fTKgOMB+pDHS7v1fSfyDWC3d782iBdyyj1CHcijXbbnA5Js6pYfRcZziqR?=
 =?us-ascii?Q?JlQTGlgs2FUrlEvZUZYdgVFaKGpgEFtRBSNZet2olZ+zNAw1tkzZHrHvHD0p?=
 =?us-ascii?Q?MRO4FnFTFIvyipz3SbEgY1OHhsc8VNpE4dVjfEvpgu/j7BM65ExBcn3EFjQ5?=
 =?us-ascii?Q?U6Fa5qUJkj9jwSzs4akZSOHQv1jq5pVabbxGpbfz8ae/fsAZKRJ3Z2yr2Cq4?=
 =?us-ascii?Q?J35piDWk+yZAgs2eGYLl1zvekQib+JRTHWoszsL17ZQCxQviDCsapMaicMgA?=
 =?us-ascii?Q?R3mu+tUQxTftsC4MP88baGUXFJRox65PT340b6zyk954YMUxDJ8iKmI4cFYp?=
 =?us-ascii?Q?x/3pQ/szNtVK8H/8b0yzgsUE31h419R6a+TmthUXqAzpEX5sVhmmhzeWOMG6?=
 =?us-ascii?Q?KnIcPP0XXLnteYWxs0DQehaxcLKTCmJ3xrLMCnn2IPBUGxZCWaeF4e23QhrT?=
 =?us-ascii?Q?FPX9uKPIgwwD5lQP1JDfPFFecPoqyO4TprvvwCUaWvarlKD0rSLQ5IEhv2KQ?=
 =?us-ascii?Q?Y04CspbWPfiHsFbl77vtXcvf+9xsWDDFO8rusCWmZMMMuc+VZh8LhkT8i4Rc?=
 =?us-ascii?Q?1glhgpTPiuEgDr3CByE8xOAhvv8SMlxWRZW6+j8Y4XFJWH7ZTyZti+3YftCO?=
 =?us-ascii?Q?G41NPRWE8zkcVj9NRY1zo9ymfk2brtoVt+V0lgEOs/TCQur+2xC/s6Yjoa2p?=
 =?us-ascii?Q?ewuF8VH3QXMNc6MMl/MItwCfJ48HC/UjAzx5e/McTqQj32KrAwtJN3Z7X+Om?=
 =?us-ascii?Q?LAKBjAOHBk3J0wyBdNBeswHc/d+/eovViyJ810hVglx8m1TFMw8zuftWLH0d?=
 =?us-ascii?Q?BcZk2wc9LKHWwLG5D2SvDZGYfy76XGvYUpS2njI8hHBEi42OSjOPThOhkEtu?=
 =?us-ascii?Q?mdD94WiDTDfRFUejIQQ4XCUK5ASQPHFgXHiiwdjeLXz1Vh95IPGD3Wa81rJn?=
 =?us-ascii?Q?s+axuImbwSlhOyu1Vt0ps0/hcrvv7MNklf6dpl1wC2Aedx3I9ULubPNswvW9?=
 =?us-ascii?Q?zpuvH0gIm4kbOLpptomou3+73fwVuRhJBfL0VEbCyXAy80qyQdtUPzQK5ZVt?=
 =?us-ascii?Q?FPFIy3KaDjyB0bliU5i8f+o3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18d24d63-1728-4cfc-e468-08d90bd4eeaa
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:01.7753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A1Ozx6UCG4J8sxI/UFGgDWh2yJSt8b+/fbIC04nfTio1U8/afTsSVEpikmlx4fr0OJ3wKGBwz3Ay8C9Dg+0hNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2832
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
 arch/x86/mm/fault.c | 60 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mm.h  |  6 ++++-
 mm/memory.c         | 13 ++++++++++
 3 files changed, 78 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index d833fe84010f..4441f5332c2c 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1348,6 +1348,49 @@ do_kern_addr_fault(struct pt_regs *regs, unsigned long hw_error_code,
 }
 NOKPROBE_SYMBOL(do_kern_addr_fault);
 
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
@@ -1365,6 +1408,7 @@ void do_user_addr_fault(struct pt_regs *regs,
 	struct task_struct *tsk;
 	struct mm_struct *mm;
 	vm_fault_t fault;
+	int ret;
 	unsigned int flags = FAULT_FLAG_DEFAULT;
 
 	tsk = current;
@@ -1445,6 +1489,22 @@ void do_user_addr_fault(struct pt_regs *regs,
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
index 8ba434287387..b37d9d8aae3b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -434,6 +434,8 @@ extern pgprot_t protection_map[16];
  * @FAULT_FLAG_REMOTE: The fault is not for current task/mm.
  * @FAULT_FLAG_INSTRUCTION: The fault was during an instruction fetch.
  * @FAULT_FLAG_INTERRUPTIBLE: The fault can be interrupted by non-fatal signals.
+ * @FAULT_FLAG_PAGE_SPLIT: The fault was due page size mismatch, split the
+ *  region to smaller page size and retry.
  *
  * About @FAULT_FLAG_ALLOW_RETRY and @FAULT_FLAG_TRIED: we can specify
  * whether we would allow page faults to retry by specifying these two
@@ -464,6 +466,7 @@ extern pgprot_t protection_map[16];
 #define FAULT_FLAG_REMOTE			0x80
 #define FAULT_FLAG_INSTRUCTION  		0x100
 #define FAULT_FLAG_INTERRUPTIBLE		0x200
+#define FAULT_FLAG_PAGE_SPLIT			0x400
 
 /*
  * The default fault flags that should be used by most of the
@@ -501,7 +504,8 @@ static inline bool fault_flag_allow_retry_first(unsigned int flags)
 	{ FAULT_FLAG_USER,		"USER" }, \
 	{ FAULT_FLAG_REMOTE,		"REMOTE" }, \
 	{ FAULT_FLAG_INSTRUCTION,	"INSTRUCTION" }, \
-	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }
+	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }, \
+	{ FAULT_FLAG_PAGE_SPLIT,	"PAGESPLIT" }
 
 /*
  * vm_fault is filled by the pagefault handler and passed to the vma's
diff --git a/mm/memory.c b/mm/memory.c
index 550405fc3b5e..21ec049e21ad 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4358,6 +4358,15 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
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
@@ -4435,6 +4444,10 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
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

