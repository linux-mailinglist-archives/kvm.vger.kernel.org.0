Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30875369680
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 17:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243109AbhDWP7f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 11:59:35 -0400
Received: from mail-eopbgr760081.outbound.protection.outlook.com ([40.107.76.81]:1347
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231858AbhDWP7e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 11:59:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nMd4JtPRl/Xpt5e9VlMkIGhyD8SYCbZHKsx6T6ku+jsb1yDljoUt/prLPIjq5SkPdLum/ODfeV8a+MwRMxXTTr1iyIuTrP0r4/vcOipANAibFOGIrduUIinpFIMPkOj/sxnNe2PdoepWmY35yvSaQqi+N8g2mmbiDf7pF4cyt7h+mlxpotjPmFzwi4n6aahn4Pw9Ik2OH0EoQjWmFZOFwvMLHB8KX5bMNEC6rAAwUFOBxlAxHPHnl8mD1GG4zL/veS7ufG2Pt11YNIFxRaB9yNkvi0k8ZfkNfnhZOOi1v9ErhoM4jQAPYwuYU3Wsr5tLXAJ0ajPtmMrXAcFmAifDTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V519WsdDsLhQcSitVWrmZPwA4RVtfnxNsUoCkWKP0qw=;
 b=Cer3u7CDgodNogicVkTM6yyxGQHA3OmeupbECK5Y8TETsJkh+YOFEKJU3WSHUIMV97oiVzZhpD8lL/CXHOavHFv00gZVVFSNBEVHWuQ5c7XQWCh1qfG+Y9WDRczgbqfFHKo9BSGvjv7x0I7cj1kFrWgvoD395UqaZDGiqv8XQQ0eRQRSHiXTWXL4v4/HljcjV+x9uH1OU9TCfSVkcGUcsQ3YimAhNXdTT6cKsU1MjZWzopaXa89//NKgeJ+Yn79J26dMt3EKiATb+1o5vVQx5tNDFRP9e70ZJ5h3U9KdJmBGqyvydlcoHeC8olvJfpVjIVPCmGtzUALDSwSbo5IIZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V519WsdDsLhQcSitVWrmZPwA4RVtfnxNsUoCkWKP0qw=;
 b=ZDvMMx4KHMB4zCstn3BdOnmsi1d2wF6slYRVn3fCU/Y0PXqR/6bQN/4FvrBzz3hbScDxjAMsBppYVLRWslaHxQRhBOyINpwf/cHSCki4GAFMAlvFfzdWcS/9bz0O6LmonLdXFZmBLqtTa3S5tc+WGwK3Md5EBbn4usqAYq76FAA=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Fri, 23 Apr
 2021 15:58:54 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%7]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 15:58:54 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v2 2/4] mm: x86: Invoke hypercall when page encryption status is changed
Date:   Fri, 23 Apr 2021 15:58:43 +0000
Message-Id: <ff68a73e0cdaf89e56add5c8b6e110df881fede1.1619193043.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1619193043.git.ashish.kalra@amd.com>
References: <cover.1619193043.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN1PR12CA0098.namprd12.prod.outlook.com
 (2603:10b6:802:21::33) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN1PR12CA0098.namprd12.prod.outlook.com (2603:10b6:802:21::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Fri, 23 Apr 2021 15:58:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9429766f-9a2b-4379-7111-08d90670b1ce
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45570525D9541B799C85927A8E459@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DDmvlIgbp5/k9GkfHaobiAMLLiXFgeI7ebOFfML+Ilj7bPlMcpX4DXg6sjfXtYDhdEKjHPbxdqhhTj3UOLNjvRJuAu1waQhfJtEvFL/Ik945FEuFCPjg454VuwNoXBSnQ8t9SXTAFx1O+j616WE9Hr23B1GE6AM9S6HEC7jmVCEg+V1XVXhE+ZGN8Ny3I/Co57AAvhyzoQQ/sukLZrigoRQZjpnu8wZe1UItqsZll2/4uRjcqdsodv6S1N0fp+1eyz3QvPyaHpeOl+djJ0JD7GjEh3kL2BOGq3qd9rO54sxvjqlIeGq7UTZpDaZovvAww910ttix5box0/pCWaeBDo+prsZVSnADieJOJZlF3SrKuO3qPpe36ghzcUn+KJ9RdSf5t156wCy8+uuN3e0T2FG3iFDGhPBciEHOdtDTO6I+afAmOMK75EtHxx4SdhYbZiLe7QS/a2RcZvrOZTQfgrorRB+kcVfITq5FWFyb0vUOKGVg5vHUJPV5f1jdBhC4y4p6pTOHxx5p8co1Gou6PvorUgxDzzHAXH+ZDGhuIQUWsoDFm8drHbrz68MwL8NwZKoWeLHP5Ja8/RtTv/MYs11GbPPt/HVid/fmL0Re45KN/oqQijmi/H4YCrweguB2qq6pB2iGOtLUJhmQqgsGkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(39860400002)(346002)(376002)(52116002)(6916009)(7696005)(8936002)(38100700002)(38350700002)(66476007)(4326008)(2616005)(8676002)(478600001)(956004)(186003)(36756003)(5660300002)(6666004)(6486002)(316002)(26005)(7416002)(16526019)(2906002)(66556008)(66946007)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Pan1LLvsUGU+EaiRaCY4QEGuw8HSXn4Noao62CcBQmK3v02bI8HaFdy6uSas?=
 =?us-ascii?Q?7fsU/GF5ZV42/ITyr34fE1kxAWkLi8puEfsxU8KOYM0UN39M/rX81Ai6fSJX?=
 =?us-ascii?Q?r9b8MiiAa2TecY6zWb4TLHCAZQ03vOlNUs2My4xS3yqQAEl/QtaycT07+SwX?=
 =?us-ascii?Q?EBsgJ5AW8Kag8zYIUwGJT+fo1Nkv8hRoM8U9L8iFTHctP2kpKcadZu2hOywq?=
 =?us-ascii?Q?YaKsEFoQCBg/oLulLlo2uJnOQV65YAS7Lnb2KMRTfKGPHjNyltcyuM996F2Z?=
 =?us-ascii?Q?6AxsSarKviyusgfiXk7fJ2eXSrGOFSaohnooeA16BCX04nJca0Zfh6x1w9I5?=
 =?us-ascii?Q?OqcSWn1xOKL1JFWJ20UDTid6ZZ5l0Ney/laCyCPRa8ZYUqlrNsgMb5ID3Kx8?=
 =?us-ascii?Q?MxdjDdKB6mNkE6UDPcHxD1Q5Z58Cf6I49nqFmJHN8vSQd7pkgsG49HpfAN/l?=
 =?us-ascii?Q?1DiRbId97J00cyXgPv0pE34gz4KqBxGFjODavYVz58Gh8fVZUpiFI7Q4Mni+?=
 =?us-ascii?Q?klpqqpnkoHO6qq9AveTNFMBGwOGIUU3L0yoqzlAbjVhyhbbMdumZ8DmovluG?=
 =?us-ascii?Q?8fRDF3YGJTRPQIorD7y0WaYgNjxeIpbvWsrv8b+4PUSLWyMKu782haEKeEhw?=
 =?us-ascii?Q?QHfkpLKSMw1BgZX0VOF9g4QSAyHIM4wyIQ4/LkUlgJWP0ZFmM6CQx95WI446?=
 =?us-ascii?Q?gOgGDM645OXU8OA9P0sEvvOLnP/ReQaCYo/QdP9Jn73GNxgPSyoqcW8eXsEW?=
 =?us-ascii?Q?ut7vhYloFfLOzYTNH64U7Izrc4U2IFUn7WLj5PGMqbrG/cRgCaIhNToRyBQR?=
 =?us-ascii?Q?GVi9rsPPIHze1+z674qhQEvnj0UaKOVHgE2+ETUfXxGUoIztnRHNtgEIcNEj?=
 =?us-ascii?Q?9dyNWr91cCh5T0YiVLX7PbhgwJoYsZqcgewu/0rDqxD5lLCxPCg1o+MhR/t1?=
 =?us-ascii?Q?z6fnb3cXe7shCjsnRxDWhgmQhUomyHFpO5OuEoFTWV1oSqXn4RZfF48ECIr1?=
 =?us-ascii?Q?AkP0a4ugbXB4Tkryjv6gJ9XEXVdQ9FfsxdVyLCZem5YP03zyYfitakKk9qNN?=
 =?us-ascii?Q?bko0tXbme2NAtw1UNroZOYmsLaZ0LIGnuvfQxePl2SAkA/wOjnkjdTDbwd50?=
 =?us-ascii?Q?t32R3DqH0FcTlIXF+1QUuRnC4bEeh95132vcuZJWngFdDwTmIUlbsZj95juF?=
 =?us-ascii?Q?0nysMnyrd7cbSr3dx7ohV9ny0NPS7BE4WX6a+N/1HCYI9YQN8Uv8rzISS5kX?=
 =?us-ascii?Q?lENMUiyIwYcyQB82yg1LeDDUZdbIiBxDiEST+cEp/edQmhwAhnj7StbWNP42?=
 =?us-ascii?Q?8TMnZHQ4YQ9LNlYspaj+xPb3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9429766f-9a2b-4379-7111-08d90670b1ce
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 15:58:54.1454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0xeAgDxfW7GAHrVLyt1cTWgpPyd09BUoVDasE9AwHK8jrurN5AIZwNoVQ2Twv4bFCydBlrhAO+U7knl/ZiEOeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
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
---
 arch/x86/include/asm/paravirt.h       |  6 +++
 arch/x86/include/asm/paravirt_types.h |  2 +
 arch/x86/include/asm/set_memory.h     |  2 +
 arch/x86/kernel/paravirt.c            |  1 +
 arch/x86/mm/mem_encrypt.c             | 66 +++++++++++++++++++++++----
 arch/x86/mm/pat/set_memory.c          |  7 +++
 6 files changed, 75 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 4abf110e2243..c0ef13e97f5a 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -84,6 +84,12 @@ static inline void paravirt_arch_exit_mmap(struct mm_struct *mm)
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
index de87087d3bde..7245d08f5500 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -195,6 +195,8 @@ struct pv_mmu_ops {
 
 	/* Hook for intercepting the destruction of an mm_struct. */
 	void (*exit_mmap)(struct mm_struct *mm);
+	void (*notify_page_enc_status_changed)(unsigned long pfn, int npages,
+					       bool enc);
 
 #ifdef CONFIG_PARAVIRT_XXL
 	struct paravirt_callee_save read_cr2;
diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index 4352f08bfbb5..ed9cfe062634 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -83,6 +83,8 @@ int set_pages_rw(struct page *page, int numpages);
 int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
 bool kernel_page_present(struct page *page);
+void notify_addr_enc_status_changed(unsigned long vaddr, int npages,
+				    bool enc);
 
 extern int kernel_set_to_readonly;
 
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index c60222ab8ab9..192230247ad7 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -335,6 +335,7 @@ struct paravirt_patch_template pv_ops = {
 			(void (*)(struct mmu_gather *, void *))tlb_remove_page,
 
 	.mmu.exit_mmap		= paravirt_nop,
+	.mmu.notify_page_enc_status_changed	= paravirt_nop,
 
 #ifdef CONFIG_PARAVIRT_XXL
 	.mmu.read_cr2		= __PV_IS_CALLEE_SAVE(native_read_cr2),
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 4b01f7dbaf30..e4b94099645b 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -229,29 +229,74 @@ void __init sev_setup_arch(void)
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
+		return 0;
 	}
 
+	if (ret_prot)
+		*ret_prot = prot;
+
+	return pfn;
+}
+
+void notify_addr_enc_status_changed(unsigned long vaddr, int npages,
+				    bool enc)
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
+		if (!kpte || pte_none(*kpte))
+			return;
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
@@ -286,12 +331,13 @@ static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
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
 
@@ -346,6 +392,8 @@ static int __init early_set_memory_enc_dec(unsigned long vaddr,
 
 	ret = 0;
 
+	notify_addr_enc_status_changed(start, PAGE_ALIGN(size) >> PAGE_SHIFT,
+					enc);
 out:
 	__flush_tlb_all();
 	return ret;
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 16f878c26667..45e65517405a 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -2012,6 +2012,13 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
 	 */
 	cpa_flush(&cpa, 0);
 
+	/*
+	 * Notify hypervisor that a given memory range is mapped encrypted
+	 * or decrypted. The hypervisor will use this information during the
+	 * VM migration.
+	 */
+	notify_addr_enc_status_changed(addr, numpages, enc);
+
 	return ret;
 }
 
-- 
2.17.1

