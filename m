Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE1801BF344
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 10:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgD3Ipg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 04:45:36 -0400
Received: from mail-mw2nam10on2062.outbound.protection.outlook.com ([40.107.94.62]:52607
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726420AbgD3Ipf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 04:45:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ajeyfw9D+ZxfFiNLToKFzGpMQTJCfHTklh9RqJ3XLPDvN320m9h9SafRxYUsdkvmWc3FUdU2I/iuJjg2R6VO8tKDtnSBxEo29usn/9xnnN8WVLx6zXGfyQGB8KJoGUCrnauUOAyBDstDPymIoJvLgI/4iVbGzyKfe3SH6oqVCkPw0u3GyjiswMQR9nOAAR0NdOr0dmBmbIIrCHiE13wJZLRuD0GHYNfRSVwk+uJLxkFTCtQ52Z1mpCcjhtDTOe8YYj+Co5ho8Zpy32D8HKrsjJacaBfSrOGhI5mfKUYvchQ4AtVnAOFCjUAWzo5HbfSeDJVXKGRuj6iP0RZRko+j9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dGc+4NNuqOeQw8l5bUjqXtWiVGPKR4A0/3wOmAcBaGY=;
 b=dk9vhJTidepIzu6yeSrpiwtAKCWuRby9Bnwf87hjPKqL992gTeCntpS/B7/SRibyOKktafRgZBxElJpkJ3tGrwFrMgIUwwFOPyhQYpV1iewcu1ypVlKmTicGm9bHiSHxMYIzvKPqbZgQisrLZi/hKR7VLf8Q5Za+yqTVyfCw5HTB9Z3OjwQdlrhV6dMWDG1IUsjTG/ePJD8JDtUgh2r+FswLWSMFGc6pTQKYlLo0Kv2SofGLKVOjTE5IqI3jDvZMjL9TPeqgFFHHlTE28HTkEW0TEKzXmKEjQRqI82S7/4xwzfluJ4/sfqD8wI0cOx2zrNKuKQHhzJkPACyW7OSuhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dGc+4NNuqOeQw8l5bUjqXtWiVGPKR4A0/3wOmAcBaGY=;
 b=jS5U1SmAkpCMY8VcsyrGh50J/9kqDSGiL9z5LrydBx77sB3iOvXoFzZgGM7mZM1x56pNYhC9T16ChUWXTB9LrqPDiyEnz+N68iO9ahsxRl56zXIvJE0PtC/7f9AnfPGcpiJxKvei2K0F0TakyeeknhFTPFP1GqmNCp3XL4Lq1oc=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1883.namprd12.prod.outlook.com (2603:10b6:3:113::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.13; Thu, 30 Apr 2020 08:45:31 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 08:45:31 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v7 11/18] mm: x86: Invoke hypercall when page encryption status is changed
Date:   Thu, 30 Apr 2020 08:45:22 +0000
Message-Id: <c167e7191cb8f9c7635f5d8cfecb1157cc96cf6b.1588234824.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588234824.git.ashish.kalra@amd.com>
References: <cover.1588234824.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0401CA0014.namprd04.prod.outlook.com
 (2603:10b6:803:21::24) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0401CA0014.namprd04.prod.outlook.com (2603:10b6:803:21::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 08:45:30 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 67b929f0-3678-4ca5-e54d-08d7ece2d745
X-MS-TrafficTypeDiagnostic: DM5PR12MB1883:|DM5PR12MB1883:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1883A781DEA4E2FD2F745A438EAA0@DM5PR12MB1883.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(366004)(136003)(376002)(39860400002)(478600001)(86362001)(956004)(8936002)(26005)(2906002)(2616005)(6916009)(8676002)(36756003)(6486002)(7416002)(4326008)(16526019)(186003)(66574012)(7696005)(66476007)(5660300002)(66946007)(6666004)(52116002)(66556008)(316002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Vg8mt3VIP5rW2C3gRPQSzzARK1hMBZNHjdNcKshgTK3fQlT8DukaYCjHSp8y4oTkGxpsxkI8gmQCyK+EDgsMEdBrwRZ/KNDikGVeXAMfyzoIBRPGmQ/akdoa7M3/ZD03eb5ChcVkAveb/FHUFE6QOBA6iVIAst4QPbV7Ocs1x2oAy1usLjGN3KHPoILNoTC8Kj8rdfnW3gbtGpql8YAG/S9+HrsujnEyz92JKYAi5jJ+B4GCWqpPLvuWlSB7aKTaYRxWZd9BYj/NZYdvG2EkkRdZUpvTnSPm1I83D15taEsyzs7vHgwqGZnjNWoGe5Nu1BJjjJfNSsKN7n7g+jL7sRnCCk1p+Y+9Jp3LpQaYBIvPSKKeFlfhHdJAa5Z42pUso36B+zrJULi/ZxGGJcaAGaMa4bpzKwvvqCs5HxbDA2afx3e+sPOw8f452sv/h1Beacphsc4n5ufAGVRIJJpZsc6ZM5s5zRlmpmFH0uPT0zzeSo+dPJ1ZbnTGxNPQfPB
X-MS-Exchange-AntiSpam-MessageData: QfKTJjf4o9A9IAyYjEKdaDiSgCX8QknrfM3ZdjFDAkxBCEW01NTUYf2/vIXsxBeb7ZC+qK3iDME2ZTl0LOrA7OGjwKqqNG38uqat+iD1SiJXxr6f8A4qMRG+VnIa5xD6aFMG2tPTH6NnFk9t8qWnypFvA1vlrkse8X1FKH3TVERArZn0Kn+USmCdHgAp/ZYNSl5gVdDEPKc3i6ak1cBaaeO46IKU4/a/uCg5uoTGxAhmFpZLbDiRHjIrLn2I0x/Fjpz8vVfs3Vumj+WGzDDhaBOufVF6Nm3488RzT3wYvGlS3aqz4E5OIIpYxQNTYbXTLDjvywk6KDuWygHuSznAoLPBG54WKWLolwAgNcErUGH3KCBm88Uwn3/g9APtrtuY+D817NKFDLhwSW+wUGJqvMSjUkZbtnLJTE1FH//OrtApvzS0BLLX5OcV8Lmk7MpWbtLSUD8dkI3/ouc//yccgUC0ApXNfvEjd3T1maRX5V/CndDRJ4dlb8fGvE69fQFyo6Edr/mzvvDi/Vlr9xG20en+/zKr3W7RWQzio0wErCmJMKrQgob4p6eKSJhB9bd+3LPRrAnzVDoOBFwlGYjxHCh+6C6DqymMwO63hewqYKWhppXkvLp0OxTQZhPcoJe/wiX5bcFezLHBHC+QAnzq0vig341aG94Ywr1FTOyRxcrnv+1KzbmMo0h4OVjZFuaV6xxkdstES3p0XLdV3iYNcjcAYKXQORc0OKshIFfg1YrSava0rtwgVZoYONhDXhr6tub84PF3Ds/K4yKVeWEiBE18lFPPADtZiACwKQjKT18=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67b929f0-3678-4ca5-e54d-08d7ece2d745
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 08:45:31.6559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DNuT1N/MrHIWhOWAP+M7PQXF4veW83s1dOKqpmeKlzmb3ety0Hx3uAmzVN8J90C5FES0JhOT5cCRnFpe/wK8DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1883
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <Brijesh.Singh@amd.com>

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
 arch/x86/mm/mem_encrypt.c             | 58 ++++++++++++++++++++++++++-
 arch/x86/mm/pat/set_memory.c          |  7 ++++
 5 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 694d8daf4983..8127b9c141bf 100644
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
@@ -946,6 +952,10 @@ static inline void paravirt_arch_dup_mmap(struct mm_struct *oldmm,
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
index f4bd4b431ba1..603f5abf8a78 100644
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
 
@@ -196,6 +198,48 @@ void __init sme_early_init(void)
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
+		if (x86_platform.hyper.sev_migration_hcall)
+			x86_platform.hyper.sev_migration_hcall(pfn << PAGE_SHIFT,
+							       psize >> PAGE_SHIFT,
+							       enc);
+		vaddr_next = (vaddr & pmask) + psize;
+	}
+}
+
 static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
 {
 	pgprot_t old_prot, new_prot;
@@ -253,12 +297,13 @@ static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
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
 
@@ -313,6 +358,8 @@ static int __init early_set_memory_enc_dec(unsigned long vaddr,
 
 	ret = 0;
 
+	set_memory_enc_dec_hypercall(start, PAGE_ALIGN(size) >> PAGE_SHIFT,
+					enc);
 out:
 	__flush_tlb_all();
 	return ret;
@@ -451,6 +498,15 @@ void __init mem_encrypt_init(void)
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
index 59eca6a94ce7..9aaf1b6f5a1b 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -27,6 +27,7 @@
 #include <asm/proto.h>
 #include <asm/memtype.h>
 #include <asm/set_memory.h>
+#include <asm/paravirt.h>
 
 #include "../mm_internal.h"
 
@@ -2003,6 +2004,12 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
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

