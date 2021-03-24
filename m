Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9F0347E93
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237139AbhCXRF2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:05:28 -0400
Received: from mail-bn8nam11on2078.outbound.protection.outlook.com ([40.107.236.78]:50401
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236999AbhCXRE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:04:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f6xSxedJfOf5oQ06SwzmFNbO4M/+sF7DpKTbs2N+26k7QGpBBpgVQyO1TEFEXa80Un5bDVA9eNr0eJEzOZ2Z60q+vLdTwi2Fg3LXACmPQXtm5pmNh1TtcYOhSy3UhKwINWxY/CeMN96+iUoV3lb2+3jjrQTUoX3y9Ur/jqEf2rdERjBCbgER5VYu0AuqHLCt7X9yACyQA8B1SYwHOS0Q405ALODoAiG+cjnWx3f0hYyX+fZfSd+quk5KyrZJKs2tJtRGS4W02uwYfzke1cRHkjOBgs4LZ2O9PAxf44VH+KYfjOOwMdIjqeCKPU2rF3bjTa30h2PUJFbPlCxGvcR5fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=do0UcJtGd1tsraFXZSOPOCjSYY6X2rNAIohoHuu/wmU=;
 b=HxI6EXvvNrwfgXI+dKXwKGViv4wBQeAXbVCqwTvp3wHYOr00MSAcamRQfDNInMq7LTk5hfwzSGxrZN8WCdthfyXx7IaR1AbQovxpzN95QTuu+PjB3o+h9lavQ1iSH0eojAMBvcYg9ksMdYjrNmxGXJZLjQ0eaFyY/1gYuhu/K/+4to4ZzrgccTcIrOerTd7Cl36pcgbjCMCw5XwlDY/FgT4nqlMIsGnyKdk2BhXLKw9QHC6FJ7lAI0HKbVt8WmUj5MT7aLzD0Yn6J+UT5EZce/bh8AOmgG5nEMGEr92IaO0ADSgbI7PO5wvBzagEwgfyzAw5pw3KYhP1T8gZOQEpQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=do0UcJtGd1tsraFXZSOPOCjSYY6X2rNAIohoHuu/wmU=;
 b=zvh/zJNlyIYMBQs+ddfM24s30Naz9H7fBfzKoO8QH/c8zs5ciKdxP81+9WFHr9FMSd0zH/y5g02tc/vlPkx/oWRzKCjWLyZYB7UHQh8sKljTm52Mk7TqNzy8OHSvGzwSQ+y3D48BntdRrohJhV4izL1KUIPmCoG9oS+Jor/dXE8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 24 Mar
 2021 17:04:56 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:04:56 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC Part2 PATCH 07/30] mm: add support to split the large THP based on RMP violation
Date:   Wed, 24 Mar 2021 12:04:13 -0500
Message-Id: <20210324170436.31843-8-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324170436.31843-1-brijesh.singh@amd.com>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0210.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:04:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 19a39c8b-4a3c-4b70-e34d-08d8eee6f337
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB455789CACA2C28CBA6E84D7EE5639@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:913;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FXch2kW+LV4YCVqStkMnPkE8+8fcPaHy+H34/FHIXDqkFxzWhUxzWBXKTOLj4oMXOckAaZPZ+53fG27q6/lTA4F202h1hXy7GSSg6bJ0ye3RyVkKBQ64J5DxAiIEu1drBos0L7BsgD8NzLB+ZA2W9l+UePHkTYJmD8Pj1e3GIuPDBiry9N+1Rchyw6fhzSrRbXhCv8ncXEhQxRKyS3cmH4wN3Q0bvvFKm8+pot+2Ap50hlYN2kVvZrLC4dyLto2fnB5K+2qijXgd5QCtmGSJy+XpeWQOBQB00RF2lO3VejgfOAWoP+nN8lXe9CcKWHsGzHAkaO1MYqmv95sBUpzGASuolW6Oc/urEL274H/AF3WCd3aeolJC7j7nbeivy2T9qgAw/OtxLrx8lOzX0nBYroDI0VokZf6B/UyCiqnBv+13iN1zKTtcWeXv33yl1VgIH6D1EbgHz6ElwTb3Y/fJ18EVNicZP6b1itgaq0BoXNzvjUpPGZlHCY98Xnf/NGJQkRRbEfaSC6OnAfcz4QDM34IHnzL4E5jag24qfBnnLQuOK1Mps0p0levRYNsk9oNW1R+w96G6A8CJQPJfaSwcmUF/BrC0AI2ksfi9C6L7N+h2aNiuCY1BFf0G3JFwAujPlpmxjNIbrMpzSGBADCwNJ9hFgocB4C96Qsv5jpzABpQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(86362001)(54906003)(186003)(44832011)(6666004)(4326008)(38100700001)(26005)(316002)(66476007)(8676002)(16526019)(1076003)(2616005)(83380400001)(5660300002)(6486002)(956004)(52116002)(8936002)(478600001)(7416002)(7696005)(66556008)(36756003)(66946007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CiutqyPj5xo6QsRvwHDeUthMliKzoNdDzYoBwbZNk/kF7iD9K45qVfAZnQq4?=
 =?us-ascii?Q?3IhlmSJmYhb+5LUca0WnXkuYgkb6b8NT9PEMK6BHSWM21/U0eElFvGbUotj8?=
 =?us-ascii?Q?OA5E1wmPMXrc0qQp31wBGV2Q7s8CMJ+5r1L7Qnw8uBZKYGzuP1ibVgPxHpas?=
 =?us-ascii?Q?F/guXeDA03UEP85yBvUfVrmGah1O7Qg58hM3c70CC2dZMerCGNCmGPdPgk6Z?=
 =?us-ascii?Q?JMS5tuhZsHHcnTKEdt4bl+m5lR7uNFPCHRfMEPzhZSfpki3cfcV73jRZxwFe?=
 =?us-ascii?Q?+Cjhzjfkp2Q9Liydu9spQKYc7YEC2Bs1Gxvvc3r4VUf6SiJOgWK8TxXdK3O6?=
 =?us-ascii?Q?6y0wZU5TcUEOFwtNqDN1x41bOz3zhrxy5vjYYOVvaRQ5WwInCF7d3jROJ4Mv?=
 =?us-ascii?Q?jmXKBdRkRaKd2BRzn2wHff/TQ5gFasMlTyaL+icLs2TacuM0+1IAwYgQ4IGc?=
 =?us-ascii?Q?GI28su/2LI6RgPiSmJol4fldqwtTHLFy/YYdUQGWjvXd9/OTHWUTehUPPNdP?=
 =?us-ascii?Q?h+CcmkfUWUHsPeRga4uhUXlnyJdNysokj3Ld2EC715f3q7Q/NoaqTxPxTBc6?=
 =?us-ascii?Q?ewLNtooFCabxb+uH9pYeTDu2o/AGgdaambeBNEgctdG3E0s8tzUx1lWus8MX?=
 =?us-ascii?Q?Y7qGNXJAkZTK4WIldvmwpzTuAsObixK9LCGa4+rHswPnMWpOqwUjaDMTW2c4?=
 =?us-ascii?Q?9aYowg/UbJnQx7X4CrMG8G1QuLIS3jsOJsHJSMwZ1CRFuXVfLqBoJ95s982q?=
 =?us-ascii?Q?nSCE6/iYNqLQAuhNmLvvrsjBh6Fu07+kuvgEDhUP6aO+GVnbw7FEDBGuxhxh?=
 =?us-ascii?Q?1BOSi7YQTUDnItzU7hCXIggbp5D9WhLzODfXUWxrT0JJXB7Rfx0r60P1LqkY?=
 =?us-ascii?Q?IPB9Z9Lp0duJ29J9i+2lzGJA1xNiQcQh+C8hXSrgz5Me/yxlL41wz5L40ddP?=
 =?us-ascii?Q?xM9QfJ6rk4iF4O0/+c3OABc1s77ieZMlxtt840q5eim98YE4y5/QcCdTrcHA?=
 =?us-ascii?Q?Le8hImTvVJEYvDP+DYqX7Ly3EGYG+uowLLQgza6wicCBkxKR8AP66AD6MnTE?=
 =?us-ascii?Q?lPDJd95Vtbv8E8tQ2TZhb96u6SLdBMGuZCWPCdg6wzjd2eI4pyIZExaHTGBU?=
 =?us-ascii?Q?mYF4xjBuk/u722wHi0PJzG+WNw0KU6XKcRu9r36CpW0/v+XUbWbbDUEJcC7I?=
 =?us-ascii?Q?27gt2EY6d8/QxKd1lztfrxlta6ruKEAfo+/OjHIEH/678CWmtMWJdqIxq4wF?=
 =?us-ascii?Q?dXhNt6AXWlj5d6v53RDA6y/bUfPP8NGlFS9Tt2KU25032gXh9uZYvzgPEJKf?=
 =?us-ascii?Q?/VypaW5duVRlNpUpyIaBYQW+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19a39c8b-4a3c-4b70-e34d-08d8eee6f337
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:04:56.4629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pfqppQlQkuvub/Fc3lQyxJo6k5nWJPwxiwyBJgBsDDxn/aAGtHb5mhJM4LOYqR4EuQqYGv7ba/HP541ilruARw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When SEV-SNP is enabled globally in the system, a write from the hypervisor
can raise an RMP violation. We can resolve the RMP violation by splitting
the virtual address to a lower page level.

e.g
- guest made a page shared in the RMP entry so that the hypervisor
  can write to it.
- the hypervisor has mapped the pfn as a large page. A write access
  will cause an RMP violation if one of the pages within the 2MB region
  is a guest private page.

The above RMP violation can be resolved by simply splitting the large
page.

The architecture specific code will read the RMP entry to determine
if the fault can be resolved by splitting and propagating the request
to split the page by setting newly introduced fault flag
(FAULT_FLAG_PAGE_SPLIT). If the fault cannot be resolved by splitting,
then a SIGBUS signal is sent to terminate the process.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/mm/fault.c | 81 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mm.h  |  6 +++-
 mm/memory.c         | 11 ++++++
 3 files changed, 97 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 7605e06a6dd9..f6571563f433 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1305,6 +1305,70 @@ do_kern_addr_fault(struct pt_regs *regs, unsigned long hw_error_code,
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
+/*
+ * The RMP fault can happen when a hypervisor attempts to write to:
+ * 1. a guest owned page or
+ * 2. any pages in the large page is a guest owned page.
+ *
+ * #1 will happen only when a process or VMM is attempting to modify the guest page
+ * without the guests cooperation. If a guest wants a VMM to be able to write to its memory
+ * then it should make the page shared. If we detect #1, kill the process because we can not
+ * resolve the fault.
+ *
+ * #2 can happen when the page level does not match between the RMP entry and x86
+ * page table walk, e.g the page is mapped as a large page in the x86 page table but its
+ * added as a 4K shared page in the RMP entry. This can be resolved by splitting the address
+ * into a smaller page level.
+ */
+static int handle_rmp_page_fault(unsigned long hw_error_code, unsigned long address)
+{
+	unsigned long pfn, mask;
+	int rmp_level, level;
+	rmpentry_t *e;
+	pte_t *pte;
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
+	e = lookup_page_in_rmptable(pfn_to_page(pfn), &rmp_level);
+	if (!e) {
+		pr_alert("SEV-SNP: failed to lookup RMP entry for address 0x%lx pfn 0x%lx\n",
+			 address, pfn);
+		return RMP_FAULT_KILL;
+	}
+
+	/* Its a guest owned page */
+	if (rmpentry_assigned(e))
+		return RMP_FAULT_KILL;
+
+	/*
+	 * Its a shared page but the page level does not match between the native walk
+	 * and RMP entry.
+	 */
+	if (level > rmp_level)
+		return RMP_FAULT_PAGE_SPLIT;
+
+	return RMP_FAULT_RETRY;
+}
+
 /* Handle faults in the user portion of the address space */
 static inline
 void do_user_addr_fault(struct pt_regs *regs,
@@ -1315,6 +1379,7 @@ void do_user_addr_fault(struct pt_regs *regs,
 	struct task_struct *tsk;
 	struct mm_struct *mm;
 	vm_fault_t fault;
+	int ret;
 	unsigned int flags = FAULT_FLAG_DEFAULT;
 
 	tsk = current;
@@ -1377,6 +1442,22 @@ void do_user_addr_fault(struct pt_regs *regs,
 	if (hw_error_code & X86_PF_INSTR)
 		flags |= FAULT_FLAG_INSTRUCTION;
 
+	/*
+	 * If its an RMP violation, see if we can resolve it.
+	 */
+	if ((hw_error_code & X86_PF_RMP)) {
+		ret = handle_rmp_page_fault(hw_error_code, address);
+		if (ret == RMP_FAULT_PAGE_SPLIT) {
+			flags |= FAULT_FLAG_PAGE_SPLIT;
+		} else if (ret == RMP_FAULT_KILL) {
+			fault |= VM_FAULT_SIGBUS;
+			mm_fault_error(regs, hw_error_code, address, fault);
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
index ecdf8a8cd6ae..1be3218f3738 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -434,6 +434,8 @@ extern pgprot_t protection_map[16];
  * @FAULT_FLAG_REMOTE: The fault is not for current task/mm.
  * @FAULT_FLAG_INSTRUCTION: The fault was during an instruction fetch.
  * @FAULT_FLAG_INTERRUPTIBLE: The fault can be interrupted by non-fatal signals.
+ * @FAULT_FLAG_PAGE_SPLIT: The fault was due page size mismatch, split the region to smaller
+ *   page size and retry.
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
index feff48e1465a..c9dcf9b30719 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4427,6 +4427,12 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
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
@@ -4448,6 +4454,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 	pgd_t *pgd;
 	p4d_t *p4d;
 	vm_fault_t ret;
+	int split_page = flags & FAULT_FLAG_PAGE_SPLIT;
 
 	pgd = pgd_offset(mm, address);
 	p4d = p4d_alloc(mm, pgd, address);
@@ -4504,6 +4511,10 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 				pmd_migration_entry_wait(mm, vmf.pmd);
 			return 0;
 		}
+
+		if (split_page)
+			return handle_split_page_fault(&vmf);
+
 		if (pmd_trans_huge(orig_pmd) || pmd_devmap(orig_pmd)) {
 			if (pmd_protnone(orig_pmd) && vma_is_accessible(vma))
 				return do_huge_pmd_numa_page(&vmf, orig_pmd);
-- 
2.17.1

