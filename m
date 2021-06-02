Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07BB398C2A
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhFBOP3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:15:29 -0400
Received: from mail-bn8nam11on2088.outbound.protection.outlook.com ([40.107.236.88]:32416
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231627AbhFBOOK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:14:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqtacyGbzahgZkDEbHsOWNePCQGPBYmqrsekjXTYgwgf2fkfTFoJxGM4JYYv4tip1fYN5ceIgG4DciBr4XUML4ETdoxjwVoM9aOhcFRzgxyyaZXguNu0M0zGE4siwcwCJrNJutEL8eh6BDKzY5vX/E11gu1QReq89he1kCh369q0L6B+mEjk1nHTLzqPvDlHwWH6nsZzLp0PmfQNdpzF4OpgrPikoS1369wFcoJuEV+IkkAR83yiqwUOZ++T+RAeAdNGMocnN6k/rAMI+XM3G5nWHbmWLp9X1W6j8bYfmGSCjQa/FjKdhFNLRPnE6+znDcM3yAbJVi169Jo1HvtBlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UgzOEPHPOpw/L+40HOMnWYeNM0P9/hPteowwlWxGbZc=;
 b=ihReDO2C69FHIWSqoSRF9+8qqrWGn8RCsYzq5W+OB3ILPkdJi+VyCmn6962vn8hCL4NJv9wpfyBNewpfVqEgo9+l4W+cxkeg1KkEH0YIA6PL30UdBVsr/4/MBr4AECHVKZ+tDiwI2Gnbkc8LiTBpY/7Ra03bTLP2/B8tev9Z/cZb+CiCcyYkDJELURmEN/uFV7onbo83JDPpwdNRONs2sfI50V6JqStNgKlTKgFKM6KiDZK0CfZTCTvPD94qrb/hJOCl4Qoj/PYoZQovQyYwm+G8hif9cJn9882iOSbChkZj2k2yke7W3RGeDy4P/1g1B66/w6wn7IUv7NgXkBCcUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UgzOEPHPOpw/L+40HOMnWYeNM0P9/hPteowwlWxGbZc=;
 b=DUwO0SuYKBIZ8mKCmUbmbrMpJiKWweWgFVNGov66S6f7VZtL/p03fP/wFmdc0NXE+RTGyzGKATZkuO6tfX/VPT8WloWRwPRc7aGgbqy2JC9ALVSuU/y1ZPrAH22C0qUhnv+IaxAntTeHjHALraichMuirzFAZtYSJJR+J/p5T1M=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2368.namprd12.prod.outlook.com (2603:10b6:802:32::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 14:11:39 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:11:39 +0000
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
Subject: [PATCH Part2 RFC v3 09/37] x86/fault: Add support to dump RMP entry on fault
Date:   Wed,  2 Jun 2021 09:10:29 -0500
Message-Id: <20210602141057.27107-10-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6fa51aa9-0fb4-4e27-95f7-08d925d056fb
X-MS-TrafficTypeDiagnostic: SN1PR12MB2368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB236838A6D6AA6320683D6D2FE53D9@SN1PR12MB2368.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tXdiSR3M74oQUNaaro04ssXRaaJmXPui4fYtThq8mkCpeQEBosxzKl41ZVYJaQ5EzJjag65dos+HaZE+AusJh7KkaGAppWBa/k/OX+trzd22PkhuPUVnZhfMUBxfxGjcPorbzXoIy4SUCAGNr1LYdL95AokOzEF16v+QBr1vHhKqIaK/mCzLXhfsH0pDw1auukM/r2NXo7DOqgVmr+hCcbfTSbsFbaKbX/6sX9KQfveUff3Ml5R0+3TJTXXdTkMblqpSo06N3sWzQ0G0Q+XiUFey0K+4VJsBoSitFWduOt4+N2sBbu3qZYc/97sO5AYaH+blrR7YM5bf3VNWSKohJbPRsJvvGuJZ+SwydY/FDYomSCBGSgBvCc2YyewGpPuNMfxDVhOTNzOPl941YMmYLN/pbUXT+oreimAGH03odVWVK+QSDhrt1mn93g9QB7TxQ6fvfjI6T9YwdcS2ADp20BUwp6PdK1FQ32rkr4tvsMRJQcz47j5genpI2LoT1pIGGy3AojCYgsZeI4Q7h8Nw3gFdxvb7WiQJ4niw/NtY79E/1tL0eHu4GxocJMj4XWywlp9+cUFdJ2QVgPqwG0HqAtC20EmZR4mHvfxESyEhjb0xy1zn0klm1V1FaBYgqUc6N3flbMFBo0aOQycVBv/57w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(5660300002)(86362001)(6486002)(52116002)(7696005)(44832011)(38350700002)(38100700002)(956004)(2616005)(1076003)(8676002)(7416002)(8936002)(478600001)(186003)(316002)(4326008)(16526019)(26005)(66556008)(66476007)(2906002)(36756003)(54906003)(83380400001)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XpRjVdqJRwyGFuvgLvDxejMzPo6YifoEpjHuk/3SZqtOXGtqmUiiArZUc0lj?=
 =?us-ascii?Q?YMbuwM2iHX1VOVcL7FvQXMELojZmshw2gGZQCWr48tuu5J6a3C2VH/SRhW9i?=
 =?us-ascii?Q?7bwfHUd9emOBJLpzCZ9OjfDfV/FsQBIpGI5raVKHXla+9dOSc3noZkDVHbQ7?=
 =?us-ascii?Q?NVUzqq6D56ZnClngSCxfCpXPh+5Zz6Du0I1hNNhGMzm3aW3TYVS3CmBfY2le?=
 =?us-ascii?Q?38wddPqkKC5IXBzecqwyOsAbmDz5yu2ZT3Oh9TYDt8FHSRcCMKTOiwyK1n18?=
 =?us-ascii?Q?kjr08S2hH8/XWSaZKifbzmSO8qWwDo4/S6943xn1y0ZyCar5UnGcLQgYhJnY?=
 =?us-ascii?Q?mgyuepV3RQajAW0aVpU6Of8WaS5eT4NFVXy83nNiEkgiRecIVk+n7Dy4tmOB?=
 =?us-ascii?Q?0LY5qIZ8tMhoegrNMBIksoingHDJxW4+NZp5VHaFGzJaVkLqX9ZI2vxN/cY1?=
 =?us-ascii?Q?jPgkAYszXvpge20BiUVdk+0oS+9PqF2rgt+Hhz6HpGkucacRRF2S5C8juozz?=
 =?us-ascii?Q?5EdOf8g1hsGnqGSGJU3CJsbr+7l0ipZpnDUhScNP1+8Z+AqDUp0hNDOuNPy1?=
 =?us-ascii?Q?tGEEw/hWkNPb7q8ToS56PcjSxJHm2nCnDMGr9bz1OopYplia9h0o+vuJKmeD?=
 =?us-ascii?Q?WzLrOHWZd0eOZtqy3ypjhFqhUfTPHV05UF4adKTlUQRSkG3a4FVX4FmI4449?=
 =?us-ascii?Q?aioYMbfXetqjIFCXHRDFjp6FUDi8GnE8yT5+RzWkgBa+GgrwoH6GNyjGonI9?=
 =?us-ascii?Q?ZQGkg9nrS7XvCPVOUfY4mBL3ETNQauByaAdVfG0ICU4PTLLK/N7h055SszwI?=
 =?us-ascii?Q?X+G8JoDkKccpkDBheN1HgCd5oYm5RuQ/4pd4S8QFPZU735mu+Qk2Z1GkCc20?=
 =?us-ascii?Q?oh1TO9fYxtw/Lh6IuJDudCiwF54rb2yLi4gZuUFkisG+8YgUgM6ITyA0yhBb?=
 =?us-ascii?Q?Pw6WrHtrGuKXk7K3qnkcjuuzGoywLD8Jr7s8xdayi6+8ncaW1vUmmL0udYn0?=
 =?us-ascii?Q?Yz2nQMbt2ILgWJwjV8Mn2+qPK8qeVetWSpuINwKluJc8xM0WkjAoUC7k9EvH?=
 =?us-ascii?Q?PFRLLsHh4AarkG8x3bWRln4xZVgf8oi1l8flkwqx7bPiPGyQKqvxuyM+bZx7?=
 =?us-ascii?Q?fidKJSIpLLAwKDAnoo4YkkfDuzqBoh/eyl1AFEH2D+zXl3jH0XYkJa0ZGyUc?=
 =?us-ascii?Q?0tdqtWKP5vamyycYBhzjo6Sh1+fuV3dLFwFlxdqXQYDfFNSX9+Wd6rQgU0qd?=
 =?us-ascii?Q?tzMDNIWneEdAzIFEqlNH19JiwgDIKPy3WOQ8RPQQ8bTxLD9i5ri/Gs2ahaAp?=
 =?us-ascii?Q?CVYUx/T61QeyvGAnhIcNA4rO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fa51aa9-0fb4-4e27-95f7-08d925d056fb
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:11:39.4818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +pqCGAhLWOaNIeqS1H6qN6ccUctjYWphwHCf2/ikk7K05q3PoM6ELa8diHX/4h/1GLJM6i00eVsUH9saUEc6cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2368
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When SEV-SNP is enabled globally, a write from the host goes through the
RMP check. If the hardware encounters the check failure, then it raises
the #PF (with RMP set). Dump the RMP table to help the debug.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/mm/fault.c | 78 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 2715240c757e..e6deedf27d78 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -19,6 +19,7 @@
 #include <linux/uaccess.h>		/* faulthandler_disabled()	*/
 #include <linux/efi.h>			/* efi_crash_gracefully_on_page_fault()*/
 #include <linux/mm_types.h>
+#include <linux/sev.h>			/* snp_lookup_page_in_rmptable() */
 
 #include <asm/cpufeature.h>		/* boot_cpu_has, ...		*/
 #include <asm/traps.h>			/* dotraplinkage, ...		*/
@@ -502,6 +503,80 @@ static void show_ldttss(const struct desc_ptr *gdt, const char *name, u16 index)
 		 name, index, addr, (desc.limit0 | (desc.limit1 << 16)));
 }
 
+static void dump_rmpentry(unsigned long address)
+{
+	struct rmpentry *e;
+	unsigned long pfn;
+	pgd_t *pgd;
+	pte_t *pte;
+	int level;
+
+	pgd = __va(read_cr3_pa());
+	pgd += pgd_index(address);
+
+	pte = lookup_address_in_pgd(pgd, address, &level);
+	if (unlikely(!pte))
+		return;
+
+	switch (level) {
+	case PG_LEVEL_4K: {
+		pfn = pte_pfn(*pte);
+		break;
+	}
+	case PG_LEVEL_2M: {
+		pfn = pmd_pfn(*(pmd_t *)pte);
+		break;
+	}
+	case PG_LEVEL_1G: {
+		pfn = pud_pfn(*(pud_t *)pte);
+		break;
+	}
+	case PG_LEVEL_512G: {
+		pfn = p4d_pfn(*(p4d_t *)pte);
+		break;
+	}
+	default:
+		return;
+	}
+
+	e = snp_lookup_page_in_rmptable(pfn_to_page(pfn), &level);
+	if (unlikely(!e))
+		return;
+
+	/*
+	 * If the RMP entry at the faulting address was not assigned, then dump may
+	 * not provide any useful debug information. Iterate through the entire 2MB
+	 * region, and dump the RMP entries if one of the bit in the RMP entry is set.
+	 */
+	if (rmpentry_assigned(e)) {
+		pr_alert("RMPEntry paddr 0x%lx [assigned=%d immutable=%d pagesize=%d gpa=0x%lx"
+			" asid=%d vmsa=%d validated=%d]\n", pfn << PAGE_SHIFT,
+			rmpentry_assigned(e), rmpentry_immutable(e), rmpentry_pagesize(e),
+			rmpentry_gpa(e), rmpentry_asid(e), rmpentry_vmsa(e),
+			rmpentry_validated(e));
+
+		pr_alert("RMPEntry paddr 0x%lx %016llx %016llx\n", pfn << PAGE_SHIFT,
+			e->high, e->low);
+	} else {
+		unsigned long pfn_end;
+
+		pfn = pfn & ~0x1ff;
+		pfn_end = pfn + PTRS_PER_PMD;
+
+		while (pfn < pfn_end) {
+			e = snp_lookup_page_in_rmptable(pfn_to_page(pfn), &level);
+
+			if (unlikely(!e))
+				return;
+
+			if (e->low || e->high)
+				pr_alert("RMPEntry paddr 0x%lx: %016llx %016llx\n",
+					pfn << PAGE_SHIFT, e->high, e->low);
+			pfn++;
+		}
+	}
+}
+
 static void
 show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long address)
 {
@@ -578,6 +653,9 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long ad
 	}
 
 	dump_pagetable(address);
+
+	if (error_code & X86_PF_RMP)
+		dump_rmpentry(address);
 }
 
 static noinline void
-- 
2.17.1

