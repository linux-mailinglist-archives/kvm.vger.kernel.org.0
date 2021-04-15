Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80299360F9A
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 17:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbhDOP6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 11:58:35 -0400
Received: from mail-mw2nam12on2043.outbound.protection.outlook.com ([40.107.244.43]:22998
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233835AbhDOP6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 11:58:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LUuezIMoiP4TuxRfOXRZZYMTRAjFflevohZ6e6UJzUrzYx5lzgUW0N6/zXGVYpNkwNor24Oj3pOHbr6yHM/ii1wEtFVn7+tj8Vz9VM36Axb3gIHSJS/PoYUWi95RvGzcKt8hdnk4WJqs5DctAKUY9y3v23Kgnhd6zSn2jOtnICCE5NbMwjGUo7ZumFM2OmF0czyro8WEYEI73RPGM76mmYxtVyOqqBiima3O7sWQ5NVVx0EhhDMTii24UfxJqVmVYlK4YH2JmcgNtNjgpRnOqZoHaksLacfPrDtQaLczmRYBReqzx8QPAn1mvLSHKTHGbkqnwIvWneUz029epjnUew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aeeqct5+sugnu9WBplpXTxst9mSGFBE80DKsxBaznhQ=;
 b=khJ/flng2RvR8TEjL2S82/UDQzxJYnCBp6liXRT33itBWVxSk5EM5CEREejpJI4PRFHFYTQo9VGBI6dfsHQXcIeGGm9BMlD+lwA9rsV+kx+2KJ58WcEIjT0lUjrYzUqIc+Uq6ZdZIKuGVKXKZlxaZ+DlzuX3pZZRBNUz8GaC4vtgiMJ3Fg4p5Sg7Hn9/Pt8ibDdKV8Z99mNsVFNGDnAyhlpeBf24brBroJeIa2FulfrApDgfO7rXackl2zwaGavjgV6U6grxw/5Erj+guEDjiOf1XimuENidKa9ibzzZkfMv92c52LD4PxeFkdTYrccHfGU+j59qDG9jM+9c9P/X7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aeeqct5+sugnu9WBplpXTxst9mSGFBE80DKsxBaznhQ=;
 b=wt7spPrUKwdG35q9Bb5y8PjDw5rXnXiRvdRmy+7yKBfKsU/Hm9dzNeRXY/EA6TZ4PQldVWC7Yg6A7YxrSyoZ5J5c3YHcjzJDDJJXvcU0+bv9JeQ8mYa4YWC+T8cTNvedfKK9+ZktEtMmhv//yKaNUZPqW2e1PafVzEVF/pW4Raw=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2720.namprd12.prod.outlook.com (2603:10b6:805:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Thu, 15 Apr
 2021 15:58:09 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4042.018; Thu, 15 Apr 2021
 15:58:09 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v13 09/12] mm: x86: Invoke hypercall when page encryption status is changed
Date:   Thu, 15 Apr 2021 15:57:26 +0000
Message-Id: <f2340642c5b8d597a099285194fca8d05c9843bd.1618498113.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618498113.git.ashish.kalra@amd.com>
References: <cover.1618498113.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:806:130::13) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA0PR13CA0008.namprd13.prod.outlook.com (2603:10b6:806:130::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.6 via Frontend Transport; Thu, 15 Apr 2021 15:58:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd91f4b0-329e-4cfe-b442-08d90027439c
X-MS-TrafficTypeDiagnostic: SN6PR12MB2720:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB27205521B18D79F9FFB89DDF8E4D9@SN6PR12MB2720.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qvv/VkVrWPj3pnYbTGzTcYWYzbjn9cYJbh670G4TeTTtRoX46QJFG1TAdQsve+73wLaeayBFa0ULYsyEtuVTgcf32lcYJzrFJ9k+QLNbl4mY3efAySdQniSB/KJlFvXQm0P8J9XrxOr4V+RfMJd99F+mtZxn2tE6Q5gXGu3TVr4+JE/7hK8p1u85vJyIxMoQ2QodpxE4OcJCIUMVoCyuRUsAbVFnmuTGHVWdeMtsOVGnvD74sfMEL/AmeKRsMa+SaC0/USFZFGflEQY97l719nDIsEpcvvQuOf79zT9yyjITPFDai9XUHDSQFBtDEbkXYWABCNmOFnpD5ZolVBikGj+RVZdUsTZ+w9mbmMInTQcKM2ctUs8M8HezEX6SStHL+lrLO3ZgEVREG/AQYpJB5Z79m2XjkI6B4sh7/TjhINlnuqPSFsLjmBRrVR7R2eRt/XU9E3jc0nQGKAQely1374lqLNzLY+L8lJMSR4KAqBExDX7vpOSdxPckEJAf8JKMjLxvNEncCEIQvfxrnl8z2T+Af4Q8et7r9Qsr5m71Wf88HimiP6cUPhJmK8dev2VuY3FIfigmejjZGGG65irrthYr9CBkz40oBZtcvwBzWia3uYlNue/oJm+dD6w2xreN/BefoddFzCVf9vxwEsCnzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(16526019)(186003)(6666004)(26005)(2906002)(956004)(2616005)(8936002)(316002)(83380400001)(66556008)(66946007)(5660300002)(66476007)(86362001)(478600001)(38350700002)(4326008)(38100700002)(8676002)(7416002)(52116002)(7696005)(36756003)(6486002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?khCPJPozJFeaa7sqUYwsuPtH5e3oLxfN5GXQAjH4xicOR9R1yb/FncRpvIp6?=
 =?us-ascii?Q?fxDzQcYv8i4oCqi4g3krKjC2RBciF8quY31uprNurvpwSTJuZZ4zJ1eRWt7d?=
 =?us-ascii?Q?5Fj46Qp3/jmR6OfkMT+sIj4tRTFKRlJ9zZpsXxbNEP76pEzxw9I5UQ1pvUEF?=
 =?us-ascii?Q?lpDEtvZTzfuvAtHwSfCKKApTXkkBwqngfq8hzU/s1IJLGM/Uy0wM7UBPO2lR?=
 =?us-ascii?Q?vm096AIlwcJF1ahIpFWctQRFGO/Y1SMGojM/CgJcwuhXzKODYkxcJ9tTn/oV?=
 =?us-ascii?Q?Q/lmTdndZOPZAeKnnLFECSwC2J7ElbstO3uEqZtcuf/YkslStiOYROa610DA?=
 =?us-ascii?Q?5qMTbAezEQE2583TaP2qmWoscQ4FlzQV5T/ckN4iBgpqjM93mDs0ZWwzMqqC?=
 =?us-ascii?Q?5YFaPHTnRVoy5KwW0t+RyF1r4HkyJ+Acz94CrDh6s/DMYvHT4MaKSsXh7XF/?=
 =?us-ascii?Q?rTHlWFdh4ZaRyP4WqboQbMFQIVz3ib1h3G+mf2omDX35exZY81lkWKxBpJrY?=
 =?us-ascii?Q?he78e2gakmjS4GxAVVWFO0u5NJGgNA1uL62uSJH4Lf/nSeX9dJA3DBcDbYQY?=
 =?us-ascii?Q?W2p5m4pJ7JbkBRIkZjAsd8tH132LMaMh0ISFZLn8YqB4qLuCUGERTsl9Br6Z?=
 =?us-ascii?Q?ECsRW9hE4G0iY3VAvocz6mB52lKt8Jn8QhmV7hmsAzO+ymptF7v3jKGOjQd0?=
 =?us-ascii?Q?aZlpwW+33zLfqZiTTyzYMSOdQLdCWNTvNTqcvXfBM5jWBWz8CyXmyv+8tuB4?=
 =?us-ascii?Q?KBO1+4kyaCiD2h4w+S/1MS1z7W0TqPbZTfHOmuuAjwlQb2kSPMzjbZo3kkrY?=
 =?us-ascii?Q?zvf8D9k8mHPxvcTOR1Ea6E13U6O6mXR99YtkhYQtAyUGz2x5WFblwcMLpY7B?=
 =?us-ascii?Q?hOKifGgCQCv1kxU33tBcG1rQY+GxjLHmMfrMnx52f9kl9MDwq8qtBzFywEDA?=
 =?us-ascii?Q?9fQrEzBDqg34Bj0MCiyng9K0Cj+4YKAYelaZGHyeMQOTTgaN9xBO3inLaIlV?=
 =?us-ascii?Q?SkldsLjlRBoOXwGjjAVxn2howp2Q7f4CGKHgTE6Bs3SXc/+mGk0DjMM2J51c?=
 =?us-ascii?Q?K5kDgEI+8uYQdPdBMrPEVwIk9cS1ispkLdx9Jtkjec9WPrV15EWLy5rsmrXg?=
 =?us-ascii?Q?5v0308QI5+Q7LcDpqbFDxLqEjhwfkw8HQB3kGSCfH7Z3V7pesOTwRQkdvcoL?=
 =?us-ascii?Q?m/c1x1BwfyjmYXzYKSBkDRrvL2mEgWWyTbrkkVQCzDFMbuLmTvtrDObLqoCM?=
 =?us-ascii?Q?HeWLRQJBIban7DhnHDXJdOux1ZbTo9rYq0GzwYX5xY5FWkNX64/7f3s6Yy76?=
 =?us-ascii?Q?Faez2JRH0um8fUNoNLOBFl5s?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd91f4b0-329e-4cfe-b442-08d90027439c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 15:58:08.9042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RAhNjALUP6Tp+LjEgKnMzsxPBsHbXbPesH2xl+GN3diy40io67PbuwpCbGdv6b57OwqIxd52KWs4nsStS4gqsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2720
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
 arch/x86/include/asm/paravirt.h       | 10 +++++
 arch/x86/include/asm/paravirt_types.h |  2 +
 arch/x86/kernel/paravirt.c            |  1 +
 arch/x86/mm/mem_encrypt.c             | 57 ++++++++++++++++++++++++++-
 arch/x86/mm/pat/set_memory.c          |  7 ++++
 5 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 4abf110e2243..efaa3e628967 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -84,6 +84,12 @@ static inline void paravirt_arch_exit_mmap(struct mm_struct *mm)
 	PVOP_VCALL1(mmu.exit_mmap, mm);
 }
 
+static inline void page_encryption_changed(unsigned long vaddr, int npages,
+						bool enc)
+{
+	PVOP_VCALL3(mmu.page_encryption_changed, vaddr, npages, enc);
+}
+
 #ifdef CONFIG_PARAVIRT_XXL
 static inline void load_sp0(unsigned long sp0)
 {
@@ -799,6 +805,10 @@ static inline void paravirt_arch_dup_mmap(struct mm_struct *oldmm,
 static inline void paravirt_arch_exit_mmap(struct mm_struct *mm)
 {
 }
+
+static inline void page_encryption_changed(unsigned long vaddr, int npages, bool enc)
+{
+}
 #endif
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_X86_PARAVIRT_H */
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index de87087d3bde..69ef9c207b38 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -195,6 +195,8 @@ struct pv_mmu_ops {
 
 	/* Hook for intercepting the destruction of an mm_struct. */
 	void (*exit_mmap)(struct mm_struct *mm);
+	void (*page_encryption_changed)(unsigned long vaddr, int npages,
+					bool enc);
 
 #ifdef CONFIG_PARAVIRT_XXL
 	struct paravirt_callee_save read_cr2;
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index c60222ab8ab9..9f206e192f6b 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -335,6 +335,7 @@ struct paravirt_patch_template pv_ops = {
 			(void (*)(struct mmu_gather *, void *))tlb_remove_page,
 
 	.mmu.exit_mmap		= paravirt_nop,
+	.mmu.page_encryption_changed	= paravirt_nop,
 
 #ifdef CONFIG_PARAVIRT_XXL
 	.mmu.read_cr2		= __PV_IS_CALLEE_SAVE(native_read_cr2),
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index ae78cef79980..fae9ccbd0da7 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/bitops.h>
 #include <linux/dma-mapping.h>
+#include <linux/kvm_para.h>
 
 #include <asm/tlbflush.h>
 #include <asm/fixmap.h>
@@ -29,6 +30,7 @@
 #include <asm/processor-flags.h>
 #include <asm/msr.h>
 #include <asm/cmdline.h>
+#include <asm/kvm_para.h>
 
 #include "mm_internal.h"
 
@@ -229,6 +231,47 @@ void __init sev_setup_arch(void)
 	swiotlb_adjust_size(size);
 }
 
+static void set_memory_enc_dec_hypercall(unsigned long vaddr, int npages,
+					bool enc)
+{
+	unsigned long sz = npages << PAGE_SHIFT;
+	unsigned long vaddr_end, vaddr_next;
+
+	vaddr_end = vaddr + sz;
+
+	for (; vaddr < vaddr_end; vaddr = vaddr_next) {
+		int psize, pmask, level;
+		unsigned long pfn;
+		pte_t *kpte;
+
+		kpte = lookup_address(vaddr, &level);
+		if (!kpte || pte_none(*kpte))
+			return;
+
+		switch (level) {
+		case PG_LEVEL_4K:
+			pfn = pte_pfn(*kpte);
+			break;
+		case PG_LEVEL_2M:
+			pfn = pmd_pfn(*(pmd_t *)kpte);
+			break;
+		case PG_LEVEL_1G:
+			pfn = pud_pfn(*(pud_t *)kpte);
+			break;
+		default:
+			return;
+		}
+
+		psize = page_level_size(level);
+		pmask = page_level_mask(level);
+
+		kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS,
+				   pfn << PAGE_SHIFT, psize >> PAGE_SHIFT, enc);
+
+		vaddr_next = (vaddr & pmask) + psize;
+	}
+}
+
 static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
 {
 	pgprot_t old_prot, new_prot;
@@ -286,12 +329,13 @@ static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
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
 
@@ -346,6 +390,8 @@ static int __init early_set_memory_enc_dec(unsigned long vaddr,
 
 	ret = 0;
 
+	set_memory_enc_dec_hypercall(start, PAGE_ALIGN(size) >> PAGE_SHIFT,
+					enc);
 out:
 	__flush_tlb_all();
 	return ret;
@@ -481,6 +527,15 @@ void __init mem_encrypt_init(void)
 	if (sev_active() && !sev_es_active())
 		static_branch_enable(&sev_enable_key);
 
+#ifdef CONFIG_PARAVIRT
+	/*
+	 * With SEV, we need to make a hypercall when page encryption state is
+	 * changed.
+	 */
+	if (sev_active())
+		pv_ops.mmu.page_encryption_changed = set_memory_enc_dec_hypercall;
+#endif
+
 	print_mem_encrypt_feature_info();
 }
 
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 16f878c26667..3576b583ac65 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -27,6 +27,7 @@
 #include <asm/proto.h>
 #include <asm/memtype.h>
 #include <asm/set_memory.h>
+#include <asm/paravirt.h>
 
 #include "../mm_internal.h"
 
@@ -2012,6 +2013,12 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
 	 */
 	cpa_flush(&cpa, 0);
 
+	/* Notify hypervisor that a given memory range is mapped encrypted
+	 * or decrypted. The hypervisor will use this information during the
+	 * VM migration.
+	 */
+	page_encryption_changed(addr, numpages, enc);
+
 	return ret;
 }
 
-- 
2.17.1

