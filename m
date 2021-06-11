Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093A93A4406
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 16:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhFKO2q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 10:28:46 -0400
Received: from mail-mw2nam10on2071.outbound.protection.outlook.com ([40.107.94.71]:15267
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230129AbhFKO2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 10:28:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c0/UF19Whx5B8KoEUqNQtPZazYqKIlCxZ5wMQ1LZ57STjLm/xZdvhDVF7vRwl4s4S6MvNJxVOGywIa+DhgaOAyfQCF8dFym6qd1kGL5DcZ0pCSnfAFt4JTpj6BuI1IOr+cA1h7cMAHbmqEKqTyVdefu0IghPEFzgJbnTvNykHrFG1qW6/jlH/N3DsyrQE0+lVMOlYFkDcPhlpO6CsldWP1WgxHsEGhVKk6njn+OvUVHpFs+W+APa5FWEGFMqQpeJan631XtK6kmYr5emx7sBV0g6fmuHf3edQWC9S1ReZsUYK1yXqGzM8As+7dL/FlioaUn77WF/19gLa9GT08QJ+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1E3ySw2AmPyoVZHlmiT34Tu8uA+MU5chXd+B/qEwiWg=;
 b=DM3kT+GPp7bGrOQ3FO98PkzRVwrC27Lceqsa0Nd42AZxgGCDbbMe18IvDh8BPab6KaUhgC23hzZoQOB7PcLq+aIWJdGI56QQ/fH3zTuNOyJZ0b3l7xDFpbhFomEq2CEl1irMdRz9Bo/2nbzp8E03ogOCTJm/0MxPf+wcf97DmGOtvmwBMYd5xRwpZAuS419EaLhJusGLHKLe2qVxBcApgo1n0Imotms2L/r8R/lAvX6D5fNxHzr8MojaJj5IzaMdg4a8J55UhohJWJ6ePd7uKuURSp1uQ6+T32fEiF6LwbNXteSATut/TTyyY1kuLHeHDhDYaIEqLtb9nycHVIsdZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1E3ySw2AmPyoVZHlmiT34Tu8uA+MU5chXd+B/qEwiWg=;
 b=sDWEsuA5EB3LPxMRMvmSqFphHLQa+cqhFz72BsCJxiHiUvsnsnrvCTOooEtPxfjQmtkqSgT6JC26qNXyIPsqTCRDBPhdyjIkqfC8BDanWz0KRjI+rV1mwoLzJJLB1wHDZy7Aguz76mNUSxcKmLFW/GIlrZksbMfVzi9ulQyb/kg=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4349.namprd12.prod.outlook.com (2603:10b6:806:98::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Fri, 11 Jun
 2021 14:26:46 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::958d:2e44:518c:744c]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::958d:2e44:518c:744c%7]) with mapi id 15.20.4219.024; Fri, 11 Jun 2021
 14:26:45 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, joro@8bytes.org,
        Thomas.Lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        brijesh.singh@amd.com
Subject: [PATCH v4 3/5] mm: x86: Invoke hypercall when page encryption status is changed
Date:   Fri, 11 Jun 2021 14:26:33 +0000
Message-Id: <ab5a7a983a943e7ca0a7ad28275a2d094c62c371.1623421410.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1623421410.git.ashish.kalra@amd.com>
References: <cover.1623421410.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0193.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::18) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA0PR11CA0193.namprd11.prod.outlook.com (2603:10b6:806:1bc::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Fri, 11 Jun 2021 14:26:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8475be08-2d5f-4613-ad4f-08d92ce4f0f8
X-MS-TrafficTypeDiagnostic: SA0PR12MB4349:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB43496B7512EF41E51F136BEC8E349@SA0PR12MB4349.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YcyxpX6JkF7z84jswj+ShlRUSOArB+++O6lqeqeuo3imsbNWZzIjMAtsQ8udFi/uqgenENJdaduOWlf4+uiGhoaX4QPrB/N17yI8ywKI39IP4B9Qb9QgOA9W1eXvilJ9PhQocuTBRUyL7DQGOWBHkd5E8ZYjOA+YbhjXBn2XC55pN9FcwQ3u1H3kNfM9X+X/+geo1/Ef2kMksiLnIquA3/jtGWYhTt9jQQhG4RGNPAm+n4oWFnhML3G3Fgz8yznRnPGrGRaUVrOps+p1R1ZUt4bue1zaXmPUCDczzHAAmDWJvG3wPL23NlI8eyJhhs5hiB3Hhilqw6zsj7wKouVwfk3L2jatzGYGAYm02U732bg3+JtuC25fd1lqCTmsbkXd9JY+3jnJb58eQVjKEMT0Gwbh6NdDmPp08RJvMXVA3wuO8WyFWxWpvPiVcFwUfRY3mypNPR0nsbyBxDWGL/vVgJFCiyHMEeJ6CDrNzBkqUnHNx0xQD7BvUdCDijJGCe959RykQi0TO6LLs+r5tIGir6VsBimsrtlbWQnN1o9ha6POK9Bt/fwhJh7vZTJsoQZPHJdewpO62H5NSX/2uFO5mqQD+H/U4krP7vteprqiRx9XLNDmnlcYfFjw+kYVfdDRGaiwx+8VhrojQc4imAHnDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(346002)(366004)(136003)(5660300002)(6486002)(66556008)(6666004)(66946007)(83380400001)(66476007)(36756003)(52116002)(7696005)(38100700002)(38350700002)(316002)(956004)(4326008)(2906002)(2616005)(16526019)(7416002)(86362001)(186003)(26005)(8936002)(478600001)(8676002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VJBDbpEI7Y9RYqid8fan6tcOOBW7zV6vWooZ2yFj4SagMQc3i58iCtcAGjbo?=
 =?us-ascii?Q?SaFf/BgFUvmV6EJEFmvtcsIZSyC2Dbq58hG8hH6GTKXsDEzFzU4OW+RGstGv?=
 =?us-ascii?Q?5OU0pEYvSKJCU8ZxfEFJQBmJif/2+EpX7kGjORRyCh5HEBJi8AoksWmjvwDN?=
 =?us-ascii?Q?FK9rdTugfW7CXidr9lskTt2n/qjJUEMfLBB5AjQxqzvtOdTWyPhvaTTkgcVu?=
 =?us-ascii?Q?weMsxUvCAN99fJk/mdqRLugoz/vFgL1xwn3qMv9hII4F7wSeAVp+4ZzQsJNG?=
 =?us-ascii?Q?NIubDXB+GX6qDhWDw7Dos/EmoJE8oz0H/pMUkZ3hOvrPLZJ6us5coMRd9Piz?=
 =?us-ascii?Q?F35/a/qW5lOOKd1pVWtoDL9GDrEIxadjvR7tT44L0cRUJePi9JFyDhuOiH6Q?=
 =?us-ascii?Q?21qT/w1oS4a0mUpAAWEQ0Q12JfU5EdWq5ntnXIi1rbgVJGc5M3NA+2CKYsnZ?=
 =?us-ascii?Q?AU+6x6TmAQmoa25779cu7OZj5byN94h1twdx7hwIkbNAgB7YSjVXc3832PlI?=
 =?us-ascii?Q?Bx+senN8L0bkY+p+WgbejhHJl+611HwXKYcDZuyolAdoGwajfa95SyqQXyav?=
 =?us-ascii?Q?4HtgQrXSC+31xcEhYQmFvAjCWDXmgs80BUBXcW0ecCcUJLL+6PKB+v356sxG?=
 =?us-ascii?Q?Mxya5ePgHzfTisfBBp/Le3gISVTnENPgmLFfTotUXzYT68dQzdHTEBqEeTEH?=
 =?us-ascii?Q?akRhJq5s/IEzNGkZPv8XMNPmTvNmQfeDAUhOWskDx9APxVZ5C7Z/y1kLfFd6?=
 =?us-ascii?Q?UinVvIZTXXEgHo6aEdBvbZWJodqlWnRqZR8KAopX4BU79i17SrpbtPxzlzaH?=
 =?us-ascii?Q?7LBBgMdhvUWTcZPfxTlTduZxdyGyZhfJkONl65H3bW6ULB4mVHjkYzKPRx2k?=
 =?us-ascii?Q?TN/sGcTWXhZ6k00eI80EGNBjt/gnfGZaZjpuHEkH21CHrGFaml8XHJUruo/p?=
 =?us-ascii?Q?32OZ0+rEYetVy11CKxGhKGUkVL/J8AQhoDgec+SxviirJVo8wMiXsxsYYWqc?=
 =?us-ascii?Q?fEeYG5kzBzdhePA2rENzR4OPFE20Z1foxDAGfr4mLQsjqkSkOhARGGQm7N4G?=
 =?us-ascii?Q?D48e6JUId7YbJZ6C+nyE/nkrAIyXGTPNiLEIlcSz8p7lRPfk3k7rQVdWe22+?=
 =?us-ascii?Q?FSMHzz1fs8L/7N0cF1FsSzTiSRYNIw7I+o56bfHijmEZTMgAK+A/z7QSRR69?=
 =?us-ascii?Q?bdzH/hkNQtvjzQn6ScVN8ztA1KZBmTuetwhxhqBa7ovrlb12xkkhMz83duiR?=
 =?us-ascii?Q?fjp8diDBcAt3e/oyNr5AsvVh5Zf/LS2T9PVLOUu6g/A9PpGynSSKk+g1MppR?=
 =?us-ascii?Q?kNODy6f/BjB6qQVuA6w0UuXL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8475be08-2d5f-4613-ad4f-08d92ce4f0f8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 14:26:45.8119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m0VEpS2jYa90PzrST6M14fSa+WbBKDssTHXw0X1+VwaDjpQudsSRusDL1eWkL2BjX4+cu1KM39NCJ/aRzITftA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4349
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

Invoke a hypercall when a memory region is changed from encrypted ->
decrypted and vice versa. Hypervisor needs to know the page encryption
status during the guest migration.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Steve Rutherford <srutherford@google.com>
Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/paravirt.h       |  6 +++
 arch/x86/include/asm/paravirt_types.h |  1 +
 arch/x86/include/asm/set_memory.h     |  1 +
 arch/x86/kernel/paravirt.c            |  1 +
 arch/x86/mm/mem_encrypt.c             | 67 +++++++++++++++++++++++----
 arch/x86/mm/pat/set_memory.c          |  6 +++
 6 files changed, 73 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index da3a1ac82be5..540bf8cb37db 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -97,6 +97,12 @@ static inline void paravirt_arch_exit_mmap(struct mm_struct *mm)
 	PVOP_VCALL1(mmu.exit_mmap, mm);
 }
 
+static inline void notify_page_enc_status_changed(unsigned long pfn,
+						  int npages, bool enc)
+{
+	PVOP_VCALL3(mmu.notify_page_enc_status_changed, pfn, npages, enc);
+}
+
 #ifdef CONFIG_PARAVIRT_XXL
 static inline void load_sp0(unsigned long sp0)
 {
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index d9d6b0203ec4..664199820239 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -168,6 +168,7 @@ struct pv_mmu_ops {
 
 	/* Hook for intercepting the destruction of an mm_struct. */
 	void (*exit_mmap)(struct mm_struct *mm);
+	void (*notify_page_enc_status_changed)(unsigned long pfn, int npages, bool enc);
 
 #ifdef CONFIG_PARAVIRT_XXL
 	struct paravirt_callee_save read_cr2;
diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index 43fa081a1adb..872617542bbc 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -83,6 +83,7 @@ int set_pages_rw(struct page *page, int numpages);
 int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
 bool kernel_page_present(struct page *page);
+void notify_range_enc_status_changed(unsigned long vaddr, int npages, bool enc);
 
 extern int kernel_set_to_readonly;
 
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 04cafc057bed..1cc20ac9a54f 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -296,6 +296,7 @@ struct paravirt_patch_template pv_ops = {
 			(void (*)(struct mmu_gather *, void *))tlb_remove_page,
 
 	.mmu.exit_mmap		= paravirt_nop,
+	.mmu.notify_page_enc_status_changed	= paravirt_nop,
 
 #ifdef CONFIG_PARAVIRT_XXL
 	.mmu.read_cr2		= __PV_IS_CALLEE_SAVE(native_read_cr2),
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index ff08dc463634..455ac487cb9d 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -228,29 +228,76 @@ void __init sev_setup_arch(void)
 	swiotlb_adjust_size(size);
 }
 
-static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
+static unsigned long pg_level_to_pfn(int level, pte_t *kpte, pgprot_t *ret_prot)
 {
-	pgprot_t old_prot, new_prot;
-	unsigned long pfn, pa, size;
-	pte_t new_pte;
+	unsigned long pfn = 0;
+	pgprot_t prot;
 
 	switch (level) {
 	case PG_LEVEL_4K:
 		pfn = pte_pfn(*kpte);
-		old_prot = pte_pgprot(*kpte);
+		prot = pte_pgprot(*kpte);
 		break;
 	case PG_LEVEL_2M:
 		pfn = pmd_pfn(*(pmd_t *)kpte);
-		old_prot = pmd_pgprot(*(pmd_t *)kpte);
+		prot = pmd_pgprot(*(pmd_t *)kpte);
 		break;
 	case PG_LEVEL_1G:
 		pfn = pud_pfn(*(pud_t *)kpte);
-		old_prot = pud_pgprot(*(pud_t *)kpte);
+		prot = pud_pgprot(*(pud_t *)kpte);
 		break;
 	default:
-		return;
+		WARN_ONCE(1, "Invalid level for kpte\n");
+		return 0;
 	}
 
+	if (ret_prot)
+		*ret_prot = prot;
+
+	return pfn;
+}
+
+void notify_range_enc_status_changed(unsigned long vaddr, int npages, bool enc)
+{
+#ifdef CONFIG_PARAVIRT
+	unsigned long sz = npages << PAGE_SHIFT;
+	unsigned long vaddr_end = vaddr + sz;
+
+	while (vaddr < vaddr_end) {
+		int psize, pmask, level;
+		unsigned long pfn;
+		pte_t *kpte;
+
+		kpte = lookup_address(vaddr, &level);
+		if (!kpte || pte_none(*kpte)) {
+			WARN_ONCE(1, "kpte lookup for vaddr\n");
+			return;
+		}
+
+		pfn = pg_level_to_pfn(level, kpte, NULL);
+		if (!pfn)
+			continue;
+
+		psize = page_level_size(level);
+		pmask = page_level_mask(level);
+
+		notify_page_enc_status_changed(pfn, psize >> PAGE_SHIFT, enc);
+
+		vaddr = (vaddr & pmask) + psize;
+	}
+#endif
+}
+
+static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
+{
+	pgprot_t old_prot, new_prot;
+	unsigned long pfn, pa, size;
+	pte_t new_pte;
+
+	pfn = pg_level_to_pfn(level, kpte, &old_prot);
+	if (!pfn)
+		return;
+
 	new_prot = old_prot;
 	if (enc)
 		pgprot_val(new_prot) |= _PAGE_ENC;
@@ -285,12 +332,13 @@ static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
 static int __init early_set_memory_enc_dec(unsigned long vaddr,
 					   unsigned long size, bool enc)
 {
-	unsigned long vaddr_end, vaddr_next;
+	unsigned long vaddr_end, vaddr_next, start;
 	unsigned long psize, pmask;
 	int split_page_size_mask;
 	int level, ret;
 	pte_t *kpte;
 
+	start = vaddr;
 	vaddr_next = vaddr;
 	vaddr_end = vaddr + size;
 
@@ -345,6 +393,7 @@ static int __init early_set_memory_enc_dec(unsigned long vaddr,
 
 	ret = 0;
 
+	notify_range_enc_status_changed(start, PAGE_ALIGN(size) >> PAGE_SHIFT, enc);
 out:
 	__flush_tlb_all();
 	return ret;
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 156cd235659f..0c937daea0ae 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -2020,6 +2020,12 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
 	 */
 	cpa_flush(&cpa, 0);
 
+	/*
+	 * Notify hypervisor that a given memory range is mapped encrypted
+	 * or decrypted.
+	 */
+	notify_range_enc_status_changed(addr, numpages, enc);
+
 	return ret;
 }
 
-- 
2.17.1

