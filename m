Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A79E719721B
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 03:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbgC3BjA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Mar 2020 21:39:00 -0400
Received: from mail-eopbgr750048.outbound.protection.outlook.com ([40.107.75.48]:39303
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727815AbgC3BjA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Mar 2020 21:39:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZBW4zeGYREk2KsucA3GtyLzy1MrT+MFM+NNkpj62/A3Y61uVMpE0ogkLEC0Xf1LG5fQydPnnFdUWUcHgGYwkgKeRiDK4MZnGq6Jf+asRpCERe8OrPgeCBefM8QdcLshuy1U77BmG9yhnoWvWELAjBdUhjitTikIdVU32JmQqwBxTlsWCjZA0lgydGr3Age5mb5KVgn7BR1JUs/8LWmDV8Ii6qJzCYVhXCrcXs+s7rxjzNtu4QbK039iCsr7RcCjgyVp2fvodUEUEzyZlTsvrrG4nQ+0erlpWYaZAicup7YJoOLQ4El4igCz0zUCaxGE3XCWWUJ5icMIBzA8tc9QBVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mtUHk17blOSg2a6eSqI1/FBFC0Cg73y4oTIurroTLA=;
 b=W+jZ0rMdtQ9xrMP9c529/Mzc0ox4I7K0ypw6dw1vhJZhzxC+jXnPKYK/kMF1h44XONVH/t+SPbJmPV6YNIdNUbbi4OF8G+6CVEiXkl8M8hNVj3SFOA+RDjNFemXIqmp/AQ1wxtx+NkbpFYdc0GHthYJrjUK2qN7a4yZzZxTrkE8ruUZjtLaKRuwzKlSRNZU2zsQQ/xi9eUF3wgS59/7wd/guWdbX84ZAJPYhJsuo2cQRR43gsrdJyRcAo9vFrktFG8zc82+3S2AFRHFEyw19SJHVGEDuzI0YpdAUsLltMtpH3Sf2GP4nj5yLBQQNSjxoQMj1EkHu80YzuKAVQ33b6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mtUHk17blOSg2a6eSqI1/FBFC0Cg73y4oTIurroTLA=;
 b=WC/VTATPEQJ4mG+D1PbbIKRKKSVQMmtQV/nBiwjDVprMUPBwxfaqRALqRRj7fL4xxPHbUuGpuAzSeF85JEW8EpqnELbayNBImFG5T/0F/Dtcu7AOm3A2zky6TohWKvaS5yn77XadfkFxn6kGuiGorigd9RdHM4RdXAK8i7dPS0Y=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1387.namprd12.prod.outlook.com (2603:10b6:3:6c::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Mon, 30 Mar 2020 01:36:46 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 01:36:46 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
Subject: [PATCH v5 10/14] mm: x86: Invoke hypercall when page encryption status is changed
Date:   Mon, 30 Mar 2020 01:36:37 +0000
Message-Id: <7de8c7748914b9511175b5a8b252332d1c00d33f.1585531159.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1585531159.git.ashish.kalra@amd.com>
References: <cover.1585531159.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0801CA0023.namprd08.prod.outlook.com
 (2603:10b6:803:29::33) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0801CA0023.namprd08.prod.outlook.com (2603:10b6:803:29::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Mon, 30 Mar 2020 01:36:45 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e4e95d80-9108-4127-a224-08d7d44acf22
X-MS-TrafficTypeDiagnostic: DM5PR12MB1387:|DM5PR12MB1387:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1387BBBF9E130FE8C6AB6D618ECB0@DM5PR12MB1387.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(186003)(66574012)(66556008)(6666004)(66476007)(86362001)(6916009)(66946007)(316002)(4326008)(7696005)(52116002)(5660300002)(6486002)(16526019)(26005)(36756003)(478600001)(7416002)(81166006)(81156014)(8936002)(2616005)(8676002)(2906002)(956004)(136400200001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MXt2I5hHfu7UcvvOq89UWjqt1pbvf06guiu3+PtGHJmpME0QZ3V0hyhh+hFd4AcChvjw3VeCZWiEbq8hV00haRjuv5wQsWrle7TFN0znIIzYCd3zufC3bQt/z3JL1F5gWVkZGBemiMKD9yGBEn4RixamXeHU46UcZsQcvKGKiOS3MEKB7svAjYWsmpkkiTXnkpRUF5xu3ONFwdV3kOqkD7js/rEnSRt4u4X7rQuYgp0HEB8QOVoTWKXkEM4LqIJN6L0cTrPhnwWbf+p8itikqepOCBTR7WWLqaNL/HJvPFiBvIS9jVMp/d19zjujzujJh7+wEQphCONa+OnJxYsP2537pTgFG3Zer6THgZJwBaFhtXGQJ/GOihbEC0qsorNc3zt8HqhEue0SS8vq402dtf+iebhbeMBNC8D3EOO81LOr2azQHCwFIKoyyYz24acm2wRDPTM8e1X39G2yEm3FRyQUXxCaPYowwfi0bw75NpFBRkAyGNErGJBKZp2OQ24r
X-MS-Exchange-AntiSpam-MessageData: enxBITf6EyBdKAg9GAwemrhhS+3dEwizkyXMEeM+Ahbb09P6ZCBkEQNo9PbicXjtl759ciugl8jQvbWcdT9aLtYrFFM6nuceLliXRVwJ+FVqAMq8ZrCAYmDUAhD614i0q8nrvOrXLQyLc+9ZDmYXDA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4e95d80-9108-4127-a224-08d7d44acf22
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 01:36:46.5705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PFDkl5eNR4nlZO5GWztb6+FqAGBBeDzGKYTdz9FJpb6HOik8QMQOZtX9M3WpNCWdZGnWnWp3Cf8wFKywwtBp1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1387
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <Brijesh.Singh@amd.com>

Invoke a hypercall when a memory region is changed from encrypted ->
decrypted and vice versa. Hypervisor need to know the page encryption
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
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/paravirt.h       |  6 +++
 arch/x86/include/asm/paravirt_types.h |  2 +
 arch/x86/kernel/paravirt.c            |  1 +
 arch/x86/mm/mem_encrypt.c             | 57 ++++++++++++++++++++++++++-
 arch/x86/mm/pat/set_memory.c          |  7 ++++
 5 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 694d8daf4983..aa296af5d393 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -78,6 +78,12 @@ static inline void paravirt_arch_exit_mmap(struct mm_struct *mm)
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
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 732f62e04ddb..03bfd515c59c 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -215,6 +215,8 @@ struct pv_mmu_ops {
 
 	/* Hook for intercepting the destruction of an mm_struct. */
 	void (*exit_mmap)(struct mm_struct *mm);
+	void (*page_encryption_changed)(unsigned long vaddr, int npages,
+					bool enc);
 
 #ifdef CONFIG_PARAVIRT_XXL
 	struct paravirt_callee_save read_cr2;
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index c131ba4e70ef..840c02b23aeb 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -367,6 +367,7 @@ struct paravirt_patch_template pv_ops = {
 			(void (*)(struct mmu_gather *, void *))tlb_remove_page,
 
 	.mmu.exit_mmap		= paravirt_nop,
+	.mmu.page_encryption_changed	= paravirt_nop,
 
 #ifdef CONFIG_PARAVIRT_XXL
 	.mmu.read_cr2		= __PV_IS_CALLEE_SAVE(native_read_cr2),
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index f4bd4b431ba1..c9800fa811f6 100644
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
 
@@ -196,6 +198,47 @@ void __init sme_early_init(void)
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
@@ -253,12 +296,13 @@ static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
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
 
@@ -313,6 +357,8 @@ static int __init early_set_memory_enc_dec(unsigned long vaddr,
 
 	ret = 0;
 
+	set_memory_enc_dec_hypercall(start, PAGE_ALIGN(size) >> PAGE_SHIFT,
+					enc);
 out:
 	__flush_tlb_all();
 	return ret;
@@ -451,6 +497,15 @@ void __init mem_encrypt_init(void)
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
 	pr_info("AMD %s active\n",
 		sev_active() ? "Secure Encrypted Virtualization (SEV)"
 			     : "Secure Memory Encryption (SME)");
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index c4aedd00c1ba..86b7804129fc 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -26,6 +26,7 @@
 #include <asm/proto.h>
 #include <asm/memtype.h>
 #include <asm/set_memory.h>
+#include <asm/paravirt.h>
 
 #include "../mm_internal.h"
 
@@ -1987,6 +1988,12 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
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

