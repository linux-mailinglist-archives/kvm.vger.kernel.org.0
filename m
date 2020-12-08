Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD35E2D35E8
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731215AbgLHWIC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:08:02 -0500
Received: from mail-co1nam11on2052.outbound.protection.outlook.com ([40.107.220.52]:39170
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727844AbgLHWIB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:08:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BT8OrtLhcePGf7NjsB+l7S/efvkAvR6/psYdiKnN62aRSRRhMhRp3c7MXjFf/TX276F/8FM0AU9vMoV/omnV1IE0cRVWDYLXsPWXU6hFhU+mm2sNJETDnojo6YjIgXqkOZ6RJ8xY9oyTtkHrEbsuvtWZYBB73Lbgp+vjkzEIjUeadpn/8+TmbuQQ0+Bd9dJFRReNtDxudkM2EBPctrHBwCI95Bnxj9C1ZQKsyKG9biOL56+vxrDaGixCZGuUvrikECGBcIsp5wt7UetTQyNBs/1g+7uyoZE/aO7oBRksRrHs9smmnbDID1GELdM1Pn6YdJxHEkqdFG2KcWp1oJM20Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZhKI0DkAsAvx2gmnAyq5fMDUyMXKmNtJ5iq1d326ZZk=;
 b=lybSB97w8VIfCgUzw4gIwa+OPtodukGQFCXfAdSL2z63DElboFcw9fdlLPd95I2GSPxsYJIJm0O4gPd6QwAIFrQVO6lTlKIblFD1ZquvEoxT0aBj6PNoY7dcntEhpscdKBClJ7/y2aAMNRo77C97TujnFd7pYGCeK1mNeP0MBlWEEnppBC75FyMZpLAaEdghJWfeFSrLJEEPStJ9KIEN1/e07UfUn1o6VaaHhUwne91+yd4ZsXQkvb/AcZST6UYooDOOGa5RGk+o/1AJFjF9zCEdzAsRP8ksVEgcUVeEOm1lef9T1QZQCrOH+79Lwk3/Ag4VQCih2alQkI2jg1IHTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZhKI0DkAsAvx2gmnAyq5fMDUyMXKmNtJ5iq1d326ZZk=;
 b=SXJyxsf8zDI5NGlAxVkU5XgBy1/nIsME/ZaqYtCg05g/KJ8LWECs0k8tVWKzdLvhfgGc/L2cWDRSD3UpIPxdLdCE5D802XBTbIP/CMWwPYu4rSf92/WBQ6dpB2OV2wPHK/2Y8RuCICJXj3PCVqyJnyqBxODB3GD6ZheS7QfSn9I=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2640.namprd12.prod.outlook.com (2603:10b6:805:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 22:07:05 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 22:07:05 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v9 10/18] mm: x86: Invoke hypercall when page encryption status is changed
Date:   Tue,  8 Dec 2020 22:06:54 +0000
Message-Id: <1d9d2aef208d23d0667082e95bdf4aa54b062289.1607460588.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1607460588.git.ashish.kalra@amd.com>
References: <cover.1607460588.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH0PR04CA0072.namprd04.prod.outlook.com
 (2603:10b6:610:74::17) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by CH0PR04CA0072.namprd04.prod.outlook.com (2603:10b6:610:74::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 8 Dec 2020 22:07:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 60443ecf-328d-453e-4bde-08d89bc59968
X-MS-TrafficTypeDiagnostic: SN6PR12MB2640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2640A86F48FD4AF21DC0F0898ECD0@SN6PR12MB2640.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sYIt6jy2C/cEGIVxO1avQ5Zi2MNMJWYYdR8Dvhe5pq78+mtRoSpspCt2RuyIfLlfWkYy8NOy9VIw9R6BtPNPgGSaqTw5eORZVjGMQjPfc+p2vKXC6+7pVHK4lfdb2pFi3ifqciSdW9JZ2rcDTbFtiweP40zZmGv7jbDG/Wp3wOHnC5o8Y0CjFKGubS76GKYq2CUKzBp9WPwRAwP/oq1AuK6CVLwMMUaviF21HN1Tcv1ki3lx5it9zVLqk5ekIG2nHafgmTGLGrnkPmKxyGdN04YCGjKm6l2+Vv94DuvQa7b1RhNps05wwW1zVRc0Y7VJQD+xHJq9gf194tt1dHwpvkqtqnW6cl8mPDcGvzOuEDtAqthE6aVJa8BBZlPNHPon
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(2616005)(2906002)(66556008)(83380400001)(508600001)(4326008)(5660300002)(6916009)(52116002)(7416002)(66476007)(6486002)(66574015)(34490700003)(186003)(6666004)(8936002)(16526019)(8676002)(66946007)(86362001)(7696005)(26005)(956004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RzFHMHJPUEVUL3FkcWRpbWMvK0R1U0ltdXRndXJQbmpMeU9TaVAwRDdPOWZX?=
 =?utf-8?B?VnI2U1JJNGJKYVlnTVVEVWczSnhvOVIrSTlmZGRQL0RPTFNLS01LNFVpeDNt?=
 =?utf-8?B?RElyVkNYZmtveFZ2TUpZcitxRGY2L2ljVEFBOE5vMTNwS2NuVmt5MmVlTmU2?=
 =?utf-8?B?cHBhOWFMRk5qTGNCTTlvTkt2TzhsbVpYUDU0Ukg1SldPamQvMk9OTlVUWHNr?=
 =?utf-8?B?aDl1bHNQbGJ6eHo5SVBzVWtzaFRYejFpUzNhYS90dEF0Z2pLN2QwYkV1QzR6?=
 =?utf-8?B?S3k3V09BcUhjRWg3QzQ0ZGkvVHBGRU9OQXVreTRZUWNDaVV1NHpRUHVZTkZj?=
 =?utf-8?B?UUV0Qk0wSDNuQk54V3FvbjdUYXJkMy9CSVVKK1o2N1FJcm5rdlFnOXZmRzMy?=
 =?utf-8?B?UEh2aVhIbzFwSGtseE13QTNXWHB2eS9EVk1sUCtKVVhRaFlobGl2QnNKbXBq?=
 =?utf-8?B?bkZUMG85VmZrMFVKTlBUd01LR2RjOGlqQjljUXVNTEpoSzVpWjUwVmNHQlpW?=
 =?utf-8?B?SHpjK1dIdHdBNmNBb0k1Y3B3R0oybXQ2alU0R3UvMjVGT295TmIxb2ROZUJ0?=
 =?utf-8?B?d2szV1dmZ3R1cGt1WmxlWU5wOTlRS2Q5WTNiTzJsRk5aVm0ycUNMSUVuQ0I2?=
 =?utf-8?B?RGloV3hrTVU0UWE2WjR5YlpJYk51anpuL044eHhHUFRaV2JCdy91azBXRXhG?=
 =?utf-8?B?MUVvNUlwNUg5U1Fmd08rOGxLNmRkOGVNbmp1VHl0RFhPUXFkYkN3LzBDSE9Y?=
 =?utf-8?B?TWovanJEOTJ4akw0SkpmVFdlK3FYY2xBd3NZSDZwR2R5R1FrKys4c0wrYWRq?=
 =?utf-8?B?Q2dJUWJKNUx5blFlcWN1d0RyKzdNdlBiVXpNY2tYN1IxdWVubVdOYlF2Wmpp?=
 =?utf-8?B?STJRVUxJeDZnWEsyNE8wZC8vTFNQSG9PZk5zRE8zdHdrZk5GWGVmOGVRM0VE?=
 =?utf-8?B?eTAvU0xMNW5UZWRVUTlsRVRLTW05WlRKL1JxWXJpN2ROT0dQNC92eU96eGpM?=
 =?utf-8?B?WE5BQnlWVkwyeUs3NEkxRVBCaitEalhoZ1h4OU8xN0FaNGhXMFNaUTNZTytn?=
 =?utf-8?B?TGRuK292N2RmUnlkYzVWQi9aUmhiSURSNzFidXJYeVdwdW02c1R0RkljNk1m?=
 =?utf-8?B?YnhNMXNzSFo1VG1QdStkYUpZWG1Ta2pjeHBDNVBaYzk0RG8ydWRnUHQ1WEtn?=
 =?utf-8?B?bU5KTFhtR0VIaThDbTBhWkxxRS9MVFM1Smo0TkU2amxaSGNGRWkveEZlOTR3?=
 =?utf-8?B?NlR0YjJVWFJDUVVNUmZ2anBoVFQ0Si9kcEM0VC82UUJGazBFOUZpNHA3RXRw?=
 =?utf-8?Q?7k6LGv5BUs/mNoLorsKMw1OfX4wRsA8fI8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 22:07:05.5987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 60443ecf-328d-453e-4bde-08d89bc59968
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: semdlmsLqsNqrc9+bs4CwoIUANAd969Co9PfFBmcJtpe9vpseCkJuANmdrrK6Q2AN8K4TSsLqZnjeyP9mFISYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2640
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

