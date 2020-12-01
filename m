Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F9B2C943F
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 01:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731066AbgLAAse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 19:48:34 -0500
Received: from mail-bn7nam10on2050.outbound.protection.outlook.com ([40.107.92.50]:4864
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728901AbgLAAse (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 19:48:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oS2KJlDUDX21FqDhlFfWvbTKDfV68i1oKiWX+NCwH7I6ken177GbRn9E47aWXGWjm38vjO8v56POR0I01mgKEeWxxXUbT+7pXG4aIkfRdGdPsE3l+UMsHyyIb0KGp/dlUQO+Ty9apODks6AsP0798qHd8Cw4qkIjt5U+B0qw5DVZT04QBRPwOjG8O+l9mKekkczMqCg963aMHvBGrOUzp0DcqHjXY2yrqiTH+c+Gk+vAqxihyynK2GSKN1HZc7Oa6HO7+ZyWoXokpoCHZ5F6hJIwiYrXe9D+rJpnxwnrYoptYR/ihRHHdcWMfgF8Syg38sbRZpY6g+ngFhz76MpHtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZhKI0DkAsAvx2gmnAyq5fMDUyMXKmNtJ5iq1d326ZZk=;
 b=HJhKItLffwQfOKToxR4uxtL91wQXnD3Iqy2A0jV8fYJu+xLdW1FfP7rw5fgKha3fUASZQ6TXHn8PRsEAqpgrvIZcpg5Rw7r/IRm7P8E8YlNOLZQUvduKvaa7RV8c785kthGhi3RWlO0eyq+okyqNuKT+rSPnT5xuFXfYCbG5rbSDyNGrPhZjqvJoSlCMvwBile6EQNX241WwwEaSGwUnXDwNS/DFAhxIXJuIkvvTDipCLBkmr6xAgY9DD1ZGKM5Rt+tRNTnLqmcGkzVP3syEKUz9pPdqv6uz3yTQ7Xup5MeA6QKXxudEPXk2I6aVgWwmumrAiSxwTdfGZUJY1NADrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZhKI0DkAsAvx2gmnAyq5fMDUyMXKmNtJ5iq1d326ZZk=;
 b=E9zWfmhHMdxdaVWvz9S1vgJDBCNFbGJdXkwPrmx0RrKD2Echyt+4Nv1aGDc8EMbtnvkfWdPT88GKq4AoWddon67PCYgjjE3nxRhNkO+DoYk3fSM+npnxOY8EKZxRLej40jSlYOL/6cftr4AeLoxKOR+8Jdpscm+gDGS4POWAGwg=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB4751.namprd12.prod.outlook.com (2603:10b6:805:df::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.24; Tue, 1 Dec
 2020 00:47:30 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Tue, 1 Dec 2020
 00:47:30 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, brijesh.singh@amd.com,
        dovmurik@linux.vnet.ibm.com, tobin@ibm.com, jejb@linux.ibm.com,
        frankeh@us.ibm.com, dgilbert@redhat.com
Subject: [PATCH v2 4/9] mm: x86: Invoke hypercall when page encryption status is changed.
Date:   Tue,  1 Dec 2020 00:47:20 +0000
Message-Id: <3b095071f6a6ddf11e3ccee94fada9605131ab74.1606782580.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1606782580.git.ashish.kalra@amd.com>
References: <cover.1606782580.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0601CA0021.namprd06.prod.outlook.com
 (2603:10b6:803:2f::31) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0601CA0021.namprd06.prod.outlook.com (2603:10b6:803:2f::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Tue, 1 Dec 2020 00:47:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 326c698e-0e2a-428e-9f12-08d89592aebc
X-MS-TrafficTypeDiagnostic: SN6PR12MB4751:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB4751E9C28DD0767EA1E1E7138EF40@SN6PR12MB4751.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4/XegLNebeQUf3qlxMF2lcRJL7xLmE/037NbcIXhFpOxQIkPbNrvtAzUmAXN/VGBZjNbNntojpOZAmPa6QYEmqetOTf0lUNr7temzijCDf/rhJy1bYJgSHDwLTDhdPK1whYvkftj7F3mMVOqUOIiuMj3a+e4BiC9y06CaCzAPykm7yUJe5UBUMjpeK6jWafoiVVnlPOyCV7h1QjYT7vodgjZGNdnZS41sI2sXGA43czdaeykMzq4pGAUCnkPD7tXC1Kgmn5jqavfgsB0A6donFZBrYEFD2caSZwpbbmBdmpEhHhRa1PZ9x04W+zX/9gTl+rGtqVZLbiQa0FaIk5l/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(366004)(39860400002)(136003)(83380400001)(6666004)(186003)(2616005)(6916009)(478600001)(66574015)(4326008)(316002)(16526019)(52116002)(956004)(26005)(6486002)(7696005)(8936002)(8676002)(7416002)(86362001)(66946007)(66476007)(5660300002)(66556008)(2906002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MEhhMlpBcC9uY0VRanhOTE8yU3JkTzBndWRvWHViV0lObTg3UTk5UVhObjg1?=
 =?utf-8?B?UXozNlJQaERUL1FXa3BHM0Z1YjVTbkRLWXBCMFFpR0I2QksxK2FtOSt0Vjdx?=
 =?utf-8?B?RFQycTFiZml1dUNFUCtoZ25JSkJQektwMVJUY0t1dFZCSWJob2VLTlp4L2Za?=
 =?utf-8?B?dGlzcG94LzNvOEViZEdWQ1NqUXNqc1VCWVRuVmQxenY4S3RuQXFYNXlMaFN3?=
 =?utf-8?B?aWxhOEw4RGVtOEtJZ3NVSTRZVzFOYm10K2o0VFFqQnZhang3VjRSL1RxSWNO?=
 =?utf-8?B?VlNHME9lSlNzQ2tBd3NNL3g1LzQ5Wk5VUzdpV3NNYVJCR1AxQTZJcFkzSHZv?=
 =?utf-8?B?cUdVVVpLdTJIc3FhQ0lWSldyM1N0S3RLZXVNTmg4ZEJtQTJVdXp6eTFGNU54?=
 =?utf-8?B?UmdVZmJJZ2JZdnhPMEUvbGV3aGFkNHJRTDFrOUhxVm1QL29qTDR3UUUrN0t3?=
 =?utf-8?B?SzMxYjdqY1pwc3hEMWRkd2p5OFNTb2xqQS8yZHhsZHgzZHpDQ3FvYUhqblIx?=
 =?utf-8?B?WlJkdFJJWWtRQW9adk95TUFRR0h3VG5UOTREZ3Z4OVdlMG1FbldHbVZvb25P?=
 =?utf-8?B?NFBEWVRvNm1HRjRmNFpsM0Z4eUNRUUE4N2VpckJJb2xCWFlidGpPTEJBbWh6?=
 =?utf-8?B?K1g1bHp2VDlVQlE3ai9kS3VTRG1HS0Y0SFpwTWpjNHd0SVJXQjU2SDh1dG9L?=
 =?utf-8?B?aGdnS2cvSmpiMFlvSVpFZlFuci9DT1ZhN1cxMnRHUkNvZzBSNTdoN3FoVThO?=
 =?utf-8?B?VWJwMjFQbE40emUzeUExUmE5Q2dNTDM1ZzQ2UEZTNERJYjJqWDNtcTZVdkFM?=
 =?utf-8?B?Q0FzUUMxTlRVRzhPQnlEU1djRElVeThEblYrUUdYdytSV3p4RHFpcVY4dDQr?=
 =?utf-8?B?UlFUZkdCK2lqTFZyakFwMlh6UXh6bVRBd2hoMWFGbzdaVzZudzBEOVpJRURw?=
 =?utf-8?B?Y0RQUEFJY2ovbnhYekxWcDQ4S0xyTElmekxTOVFGbmJxRjRFd2M0Ry9pRDFD?=
 =?utf-8?B?bEVDSEU0bkpaeDhpUVFKS0tSS29KdEhySWRDNm9sQ0tYY2xscnFJRjNTOHVv?=
 =?utf-8?B?QUxRNEc0SlR1NEZoN2JiOUN2ZE1DZUdpQUUvRmg5VEk3dzJxeUd4NFJmVDUy?=
 =?utf-8?B?QXhpR20vdzlmVi91S25QL1J2RWwyd1ZMR2VJc0dqNGFpaFcvRExCSVd2Qkdp?=
 =?utf-8?B?cWN3S3N4WTBzUnJaVkdmeGp5cEE2VDlHNlc5TlRSeFBkcEV0djdwWEFBR2xm?=
 =?utf-8?B?NnJKWXU0bytxTk43THRHMk9hR29oRjdzMHpPV2U3VVpyMGdJbjY5ZmVhdTBJ?=
 =?utf-8?Q?SQ7MGmyrMbWSaOut8KrYsq4FlRAj82Ktfs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 326c698e-0e2a-428e-9f12-08d89592aebc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2020 00:47:30.3635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 92LVBXCLxOXtKuqTLMNYY10AKhgv1YVzmOPn19kM3tuwFev4pWmwVDj/a681ts5qYMnlcfuUfxKge3p0+V60dA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4751
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

