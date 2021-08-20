Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87993F30AB
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235822AbhHTQCi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:02:38 -0400
Received: from mail-bn8nam08on2075.outbound.protection.outlook.com ([40.107.100.75]:31200
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234287AbhHTQBl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:01:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P/VtGql/d9gSetz+WSrHUWHi+aDf8qzXNslKgj7nUgy6UvTtzg01wiQ8HIR4Qmqk/c0s7KhO7Iy9qIcFWu6Lc7RqJNMceypf716PoVI8ZFUNFdyLSSV415HEDn/VSr126ivMTDq6YLkkEMnRfu+5ETDhz1+LIAXTgaQE7RiP76X9rGpYuMjEVjKw7ExGq+jccb33DPB3R+8HnSJ0prtgz9/VKHt0x/4UTjwtC5ViiGrRA2HpeMOj6sYodoYbHvg/f+DOlzEKqoSyZXd0TXSeoejVGYVB4lLZt5WcSvtdy/27mv9Je/OQiZC9uYIXx6jRALOKtBYrYJHtH7U+NYo9RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p5hkMrseCkrHwlr4op5/3GK81xCGz8iZGUNbsaNcbeg=;
 b=BG5vDBGQ6+HmYwm/j/ntnVWmmV1zsFFm0kwu+eiVsVBuU3vf6Vae/TlrYUItmaSlNFsNvWp8VgeeziW9QY/GdH5ndy7wf1iwPKby5tQyFCupEmJ8W15ViTBONjMHZZrXzpLDHqMSUdxkmRg1aNfTn7o+GvAk0Lnofs5UMu3WhCjEUXIwnbrBlCJH1upgwgSR9NeB281kkceJnPfbYAdQqgqeLtM2Pw69qqRqPVjPy3funhmFOvdmzrBQdVYCZUwQmtRTPw3uN3e4sFKpMlAJRLWj/iMDyz3GUukCDT9+JvOy9N8PraSl1D7VPi10J6L5RTWorx4bG+Y/Y1PH77NOxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p5hkMrseCkrHwlr4op5/3GK81xCGz8iZGUNbsaNcbeg=;
 b=FEzIedaQELaY8lntGfVDI+CwmHw9pCGjtMJpj/Mf+7gC193yLpMvTaX/IYH2WsKMjrRrPzjH1rY9bsWpf5UpN+m/jXVaZEnxHOhjgATyQ40ikQNHgBhRoegdMHPlKG+ZHpLRvH+7yvHj0X0Co2Uz49cBqBcWyqHUfezdv8Gjt44=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:00:05 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:05 +0000
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
Subject: [PATCH Part2 v5 09/45] x86/fault: Add support to dump RMP entry on fault
Date:   Fri, 20 Aug 2021 10:58:42 -0500
Message-Id: <20210820155918.7518-10-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d66e3f31-5d24-46e7-fb9a-08d963f3935f
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB43849E72DC33610A2D60F054E5C19@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HDnaRj0857IJaxC5yHHOI47zAAtvZjehMlQB25NU5PzCZkEa/nOgTWQQ2g6y310WXuqU1LX9DIaNcnr8vOU3g9ElMxwvUeuj8EO9EDWWWXdyYfqQ9Tp44Ir8NSVCtJg7f5giAnYbfgb0d8zJYLoF/NPwqVlqyWMYFfN+pQZfcMsJtx2G7H1oF47ufgrJFsXhQ9JrR6XTKMpXO7B20rV+08JgAxeZqxvmVGnc131qp/MiThBDlmQ6xqibqnu+YsmHXlIvlWKlCbHvwwD7KTlU3rfCH4ooSXuxqoZgSNgWa0P3GSThFDnTJ5nVZfNuScu26yay+rVqk1c41aiiEnY9MlAP2Ol765srkGEu/iPYYl2it4gr+9DVH8r+6+tGnTLBrwEsTVDfQd133Zlzj1UvGKzrkXnlzs0RyAMZ+YSb/t8NqTPF4+VuenIbKqqXW6J7Ra7TFUE2Sx9VYfidbYFVF0ed13YglX9Yu8uKbdOfdl39ZNSSZJr13YPNsNwCQ/f058iTHpAvC3/QHUmfkbGad2N4HktGrCQv42joILraWH112EPsAyKU8VA08TfePQXYycaQWbRu/68BYNLkT3hBMGOysjp5JY+pESGMZzu+4kR5QFLp4/SMu0IZ05nQuFcGwDSff0ob4pOFI4RiYDqykmw3s7yj/Q8i5qbFXlw8Ie7N9tR6dBEAjVtxyyKDvPqqRs/Mv0FpC8sEkyItvmACgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(5660300002)(6666004)(52116002)(66946007)(44832011)(36756003)(7416002)(66476007)(7406005)(6486002)(956004)(8936002)(316002)(2906002)(186003)(4326008)(478600001)(86362001)(26005)(54906003)(38100700002)(38350700002)(7696005)(1076003)(8676002)(83380400001)(2616005)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j3J+28U8OUaQoiAxShATLDmg6AsToNQufppiGXPqy99AptNS+bPWW7iCKQSp?=
 =?us-ascii?Q?rObLv9fbhR6tA3BT/AgCKk5eeofqf3KkGrSlCDSIUU6BnIwSOoEV2F+qZbM1?=
 =?us-ascii?Q?oPpKVEJCjooStYNpn4hgFahgj0LFtkYN76V/o8Cs2sHqni+uXggaBkhklXR4?=
 =?us-ascii?Q?A1PbwDglUTZaMhiijW36i0HPzrANZdGup6NLCPqEPQ6JOlR7082nhG2SCRVJ?=
 =?us-ascii?Q?C3w5a97DciBAfyejYEWnJCnH1RZVAIZOWBZcUUAJn3/GRcI6R2P85J7aL1DM?=
 =?us-ascii?Q?RYT8JPN46kCTJn4/NkPjXa9NsUeVg5vm1FfQOjyTsEEfCUPTg/O0fcQJZ9CF?=
 =?us-ascii?Q?cKqlBzYqQf5NtpiTqC/m43QCU2ovRltVpBtn5h34hNoFphIWP6z+C8kB+8vX?=
 =?us-ascii?Q?D49Fmm6MT2nmf7duh5eSmGDRl9NhFZWjALrYFbtsLLHln+36n30XmcvEHgN0?=
 =?us-ascii?Q?WWB9y6TkvtsSIgxFj3/vDpU8A35+Q00p/VvlUfIdIOTfr68UpV4QSU7fY6M9?=
 =?us-ascii?Q?h0aKIU6MATM0NrqsUh76IDB56DEq4T6a/q44Azra8YmWHVPGRIHXO3Mce1Iw?=
 =?us-ascii?Q?m7DBSlftHXcuVOP6MJdyijuNc56QvjRfJrG+GfN6riDVSGoIneNJvsjLkUI3?=
 =?us-ascii?Q?4v72Z0CjAkFwnU632OPTWyLbmbliG5Y+6isONDGnxM/CnywxYIwozVtuMdJ5?=
 =?us-ascii?Q?VXW12GUFox0hvbHBeMF9oGyAjJVemVEqmGfCwjZmwtFXASLhtt3FZIwyFxTe?=
 =?us-ascii?Q?QvrNWtKmap5vXyZNZvfW8Y525pAoS7vwkslhqvyIay6h55N5C9lGFFDMtpJP?=
 =?us-ascii?Q?A4DsR5nCfC3W3TL2YPRPUNNgwDKd7fMQ4lZpL+KqhLYzRd02awUTmnEwZWjk?=
 =?us-ascii?Q?T78M0p0wHPyi+9cWLc64XYWpYpAkGU2ybdMS/qrPZTqpD+xPN4kQUyJ3fb8G?=
 =?us-ascii?Q?HRftAliBGYV6Z/aCdF3Sts1SrynPpS/mHv0AY6VvK0nlVi8kPQ0tEJyFzC8u?=
 =?us-ascii?Q?Iikt8A8huzRp9hL+QBT73eXUTqNuqo3f9kvZ/e+Hy7HX09kY0iS3QDcFxPNt?=
 =?us-ascii?Q?6uKvChufSujECC5yKbRP5c7riwMP4ZxDx1k/nwEnmpjB22tlZ8YQ2GddEhqP?=
 =?us-ascii?Q?lwc1vzRTFt5BrspFTH9C3vftbiWkD/Tax2yoIkpUUZYuP1eXlGSLgRwUdoC+?=
 =?us-ascii?Q?eQtwoGlaFIcZfXRPsF/qEMNfHBM1svtNPk35sm+YEZdjMZhT6Ng10Ro5bN47?=
 =?us-ascii?Q?7jhs/I5k1OAv33ZUn2/xQ5QYXeLRb3nY68Wo6oahQdv9ZQTnFJl2lknI4p1c?=
 =?us-ascii?Q?86Wb+9VmKH5K7WCb2jJjTsD3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d66e3f31-5d24-46e7-fb9a-08d963f3935f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:05.2248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wa2tiBjyPa/1DFQvBvuRPfPdoOp1OwngpcBdLfPafpjMFYhUPflfqVMwftTPngQuD0gzt7eR2MmpR+U9l044kA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
index 92ced9626e95..569294f687e6 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -106,6 +106,11 @@ struct __packed rmpentry {
 
 #define rmpentry_assigned(x)	((x)->info.assigned)
 #define rmpentry_pagesize(x)	((x)->info.pagesize)
+#define rmpentry_vmsa(x)	((x)->info.vmsa)
+#define rmpentry_asid(x)	((x)->info.asid)
+#define rmpentry_validated(x)	((x)->info.validated)
+#define rmpentry_gpa(x)		((unsigned long)(x)->info.gpa)
+#define rmpentry_immutable(x)	((x)->info.immutable)
 
 #define RMPADJUST_VMSA_PAGE_BIT		BIT(16)
 
@@ -165,6 +170,7 @@ void __init snp_prep_memory(unsigned long paddr, unsigned int sz, enum psc_op op
 void snp_set_memory_shared(unsigned long vaddr, unsigned int npages);
 void snp_set_memory_private(unsigned long vaddr, unsigned int npages);
 void snp_set_wakeup_secondary_cpu(void);
+void dump_rmpentry(u64 pfn);
 #ifdef __BOOT_COMPRESSED
 bool sev_snp_enabled(void);
 #else
@@ -188,6 +194,7 @@ static inline void snp_set_memory_shared(unsigned long vaddr, unsigned int npage
 static inline void snp_set_memory_private(unsigned long vaddr, unsigned int npages) { }
 static inline void snp_set_wakeup_secondary_cpu(void) { }
 static inline void sev_snp_cpuid_init(struct boot_params *bp) { }
+static inline void dump_rmpentry(u64 pfn) {}
 #ifdef __BOOT_COMPRESSED
 static inline bool sev_snp_enabled { return false; }
 #else
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index bad41deb8335..8b3e83e50468 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2404,6 +2404,49 @@ static struct rmpentry *__snp_lookup_rmpentry(u64 pfn, int *level)
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
index f2d543b92f43..9cd33169dfb5 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -33,6 +33,7 @@
 #include <asm/pgtable_areas.h>		/* VMALLOC_START, ...		*/
 #include <asm/kvm_para.h>		/* kvm_handle_async_pf		*/
 #include <asm/vdso.h>			/* fixup_vdso_exception()	*/
+#include <asm/sev.h>			/* dump_rmpentry()		*/
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
@@ -289,7 +290,7 @@ static bool low_pfn(unsigned long pfn)
 	return pfn < max_low_pfn;
 }
 
-static void dump_pagetable(unsigned long address)
+static void dump_pagetable(unsigned long address, bool show_rmpentry)
 {
 	pgd_t *base = __va(read_cr3_pa());
 	pgd_t *pgd = &base[pgd_index(address)];
@@ -345,10 +346,11 @@ static int bad_address(void *p)
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
@@ -366,6 +368,7 @@ static void dump_pagetable(unsigned long address)
 	if (bad_address(p4d))
 		goto bad;
 
+	pfn = p4d_pfn(*p4d);
 	pr_cont("P4D %lx ", p4d_val(*p4d));
 	if (!p4d_present(*p4d) || p4d_large(*p4d))
 		goto out;
@@ -374,6 +377,7 @@ static void dump_pagetable(unsigned long address)
 	if (bad_address(pud))
 		goto bad;
 
+	pfn = pud_pfn(*pud);
 	pr_cont("PUD %lx ", pud_val(*pud));
 	if (!pud_present(*pud) || pud_large(*pud))
 		goto out;
@@ -382,6 +386,7 @@ static void dump_pagetable(unsigned long address)
 	if (bad_address(pmd))
 		goto bad;
 
+	pfn = pmd_pfn(*pmd);
 	pr_cont("PMD %lx ", pmd_val(*pmd));
 	if (!pmd_present(*pmd) || pmd_large(*pmd))
 		goto out;
@@ -390,9 +395,13 @@ static void dump_pagetable(unsigned long address)
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
@@ -578,7 +587,7 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long ad
 		show_ldttss(&gdt, "TR", tr);
 	}
 
-	dump_pagetable(address);
+	dump_pagetable(address, error_code & X86_PF_RMP);
 }
 
 static noinline void
@@ -595,7 +604,7 @@ pgtable_bad(struct pt_regs *regs, unsigned long error_code,
 
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
2.17.1

