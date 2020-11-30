Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4827B2C92A5
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 00:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388843AbgK3Xdn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 18:33:43 -0500
Received: from mail-bn7nam10on2065.outbound.protection.outlook.com ([40.107.92.65]:9217
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388510AbgK3Xdm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 18:33:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ikkv3Xl3cRTnXfYtfhwybpGZIzFxZ2rloO7g6QIEkGZnargUN76ssGIwhtPZc6jL7sjIG3khcTOaKuA4O2nKUaR7NWWzUdBkRYm5KxJV9oaT4arRNcKnKnhxRjtjVvIjD2n1oS/z7YbA0QEILPFe75qxqFmTxXQMXY6pAAcp+bbBJXSaVRsxV15R7yeSxLTv/OiWMj6Q7LOCQwSJ2hnltTGAdSzAdNNWo5xAVnkn0kKXHuRU0LHxOVnm9oURrxtA2Pgmev0rIvfo2PicIEy1anH2f0dCClQPNyv4t7Y7vZG6itSNUnrVyJa+NZ5aK/00m9K2djtekZirvNCNbOB4oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZhKI0DkAsAvx2gmnAyq5fMDUyMXKmNtJ5iq1d326ZZk=;
 b=i2YMGvEzku7oKhlKYUQF1oIyJXP/V4gq7tgzFP8XiXb6ehvhMcsZn6iLuHHmBPpkOqj6vds/bhjn7LoJwqtbD5NcYm+BW69otnNPHWpPMBvye1rWxxqweCE0l7edxDFg6D5Mj56BkXKnacq6Usw0+9HQrC37UO9zww3mBAap5QJt+EsUMpIWJNLlKuWq6+ylnUoEtqexhCIBv61ps/DYWw1IzjbyieS3aqT7Smg8VD6XmyzBrmywLXyz+CIweqNrbeudfZfhumrhdJ66BmYBaLZHhDDDokf1jXfu55z4ks+xIq/W+WOxRcHCK29yuxT4ylIQAv8W/x3bhUGQK7ZtvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZhKI0DkAsAvx2gmnAyq5fMDUyMXKmNtJ5iq1d326ZZk=;
 b=CiDr0DQu8/ggEI9J9wa81JH33gaRws1R1RNMGTYABxvpGNVl/bo0KF1x/xMfxEeg8rLfixte0KmkIzz4zwi2PJZ60QIhbbH/pVUTFeOI29UR9wKIdpPgTxaXBlFL1srqFv2uz37P3GsV/QHzfmN/SU+9x9/poq4Bfv1I7V9AJbs=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Mon, 30 Nov
 2020 23:32:53 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Mon, 30 Nov 2020
 23:32:53 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        brijesh.singh@amd.com, dovmurik@linux.vnet.ibm.com, tobin@ibm.com,
        jejb@linux.ibm.com, frankeh@us.ibm.com, dgilbert@redhat.com
Subject: [PATCH 4/9] mm: x86: Invoke hypercall when page encryption status is changed.
Date:   Mon, 30 Nov 2020 23:32:44 +0000
Message-Id: <ce187d20f776e63e27ab286536091041c9d46335.1606633738.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1606633738.git.ashish.kalra@amd.com>
References: <cover.1606633738.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0052.namprd05.prod.outlook.com
 (2603:10b6:803:41::29) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0501CA0052.namprd05.prod.outlook.com (2603:10b6:803:41::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.7 via Frontend Transport; Mon, 30 Nov 2020 23:32:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 371de7c6-5420-4b86-688e-08d895884250
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4509DA326F7C9DFF9B1DE1728EF50@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MGA8oBzux5zbQ8fCa/4fjXFtP2JYnV3S3rsIh5e4FiVG0Tyx/cHQRqfxt1tW3P7XriwkiiiuDTrb1r0vB1enYyY1l5bz/Me0PQLwI/14YMXlBT81cobe2SYrDZhovBWVPYh189uSYmmZ6bBoN+xZoq7yVH6DUG4/C6iQH2laaLBC+teQUH5XkM0L5sLILMsMEhS2hAgrXFukRtAQNkAeDnqZ9FQdCJgJ4ZwU23KxnWOnXqUCQdfOfEDmVFqjpuonix6JzuBJfVl3iP192u9mOrFto4gWqNhtTywgzWdZ4XvqtTB5fKt345BiatC6nBGbJSejk8KjAHG4Ht6wYbzr7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(26005)(83380400001)(956004)(5660300002)(16526019)(7416002)(4326008)(86362001)(2616005)(186003)(316002)(7696005)(6916009)(2906002)(8936002)(6486002)(52116002)(8676002)(66946007)(478600001)(6666004)(66476007)(66556008)(66574015)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mP9tnzDK1B4HB8SmYMhW9pSxr6YKVAhb/xvODlJGJYAVCuepWQQpeR0ZeJ5g16/+jW9h/o7Dotxj0mEJQjyNpQPFqjrI80m/xgo0jDTS8kFYcU6VnVwbdwid/DI+IRCgkqRdTDt1hl3xOMecqGJe1j1+fN3naATCPD6L7moO2gW1VKfUaabQMY8A+0SgdlA/KWA/wZpbjZ+OpGMHw+rD9NchgDPdtxEX1wFAG9GDrMceMNsr/zl9Qq5+iFIclhR0IP61OMJigUETP95BA0SpdEay1wTawB0moKjf5jkwfjJFC1vTT87CRM1iYm+wzpl5CrpDJ0juyQ0M3b1W3JwQwjXmRxasRYrdJutw9yOK18aL6cUfKuc0oC7njlSi9FIotVFKQdXWHXVFYqyUajjhR2ezXpCTZ8Vr5/Doi6gVNOm+7eSTc3NSrCC524W6HcWLstytHSJ8diMqZSt0pKI1rPvhcATMzZXult2mJ/qCD5ZyDyOQYFkRoxPab3uhyB9jOGJA5jMSLTy99X++pUylQ8Rk/+Rg19OWAEehrpuHq13WAfCFrveLiAWhlc6qMYKGS4WERFHDMxc18L36kpVDfzPav2k7tRDgNxOw/kkEY9GbX7mN9UaPtPqeBnb1mLkd/qWsCHnrBg6IrG3lkoDWvkrYQxZNopYCSprNszxu7fu6wKUKmNA1I+ltTXFr9dtSkgpJjNizCODFLh1pveFyaMaVb5C1nTWmdFhPVgJ+sm3h90JuZWxZJG/B63xlnbXd
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 371de7c6-5420-4b86-688e-08d895884250
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2020 23:32:53.5330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZslHagqPvH4bJamFPbRkuoS3XAA4wro253/v/qStuNLUOCYqPCgoSRlzS/O2SXYlkw6Or7InwmYiYcpjrzuiiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
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
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
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
index d25cc6830e89..7aeb7c508c53 100644
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
@@ -840,6 +846,10 @@ static inline void paravirt_arch_dup_mmap(struct mm_struct *oldmm,
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
index 0fad9f61c76a..d7787ec4d19f 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -209,6 +209,8 @@ struct pv_mmu_ops {
 
 	/* Hook for intercepting the destruction of an mm_struct. */
 	void (*exit_mmap)(struct mm_struct *mm);
+	void (*page_encryption_changed)(unsigned long vaddr, int npages,
+					bool enc);
 
 #ifdef CONFIG_PARAVIRT_XXL
 	struct paravirt_callee_save read_cr2;
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 6c3407ba6ee9..52913356b6fa 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -340,6 +340,7 @@ struct paravirt_patch_template pv_ops = {
 			(void (*)(struct mmu_gather *, void *))tlb_remove_page,
 
 	.mmu.exit_mmap		= paravirt_nop,
+	.mmu.page_encryption_changed	= paravirt_nop,
 
 #ifdef CONFIG_PARAVIRT_XXL
 	.mmu.read_cr2		= __PV_IS_CALLEE_SAVE(native_read_cr2),
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index bc0833713be9..9d1ac65050d0 100644
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
 
@@ -198,6 +200,47 @@ void __init sme_early_init(void)
 		swiotlb_force = SWIOTLB_FORCE;
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
@@ -255,12 +298,13 @@ static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
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
 
@@ -315,6 +359,8 @@ static int __init early_set_memory_enc_dec(unsigned long vaddr,
 
 	ret = 0;
 
+	set_memory_enc_dec_hypercall(start, PAGE_ALIGN(size) >> PAGE_SHIFT,
+					enc);
 out:
 	__flush_tlb_all();
 	return ret;
@@ -448,6 +494,15 @@ void __init mem_encrypt_init(void)
 	if (sev_active())
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
index 40baa90e74f4..dcd4557bb7fa 100644
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

