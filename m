Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11B9368849
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 22:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239528AbhDVU4O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 16:56:14 -0400
Received: from mail-mw2nam10on2075.outbound.protection.outlook.com ([40.107.94.75]:4961
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236851AbhDVU4N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 16:56:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TtdfrRDrtSPfTKraQuZXVk9Qztu40JemGRA/WY/sJwF104VtG7M4ilHnJ81Z+tgtZO8X35ULG3eDo9UGZYXTFuVKOd8vONd0nhuHGTRyiZR/kxy8BhawaJJuSJr/HXgAlX++OBMQiJfZiPtXRBRp+4LTFmlptslEivwQwAskn+wbgnPM/PZDrIx8tjUVFGxr33FHfi2ohf0Ai5Pp+KNl5mOvyMDoNQv0LY/N2a+DT6+SOfdiAYlNbCzIw1puJOI4llPZPJ8lhoAz7Wb6zmTGXQH3Z/zGhpZV0FSwvZw/68S+fRnQzDYZ6Lj3TFtmvOkgEeIVHteV7Bne3B2U42K+Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V519WsdDsLhQcSitVWrmZPwA4RVtfnxNsUoCkWKP0qw=;
 b=hhIIvlTcsrg8RdIfC2TBY0CLqULuPWc0vjd/skop7j0vXUNxuQL03iZPlyD1Qn8D5RQkg+DbcaDEIBtISODkscQx2rirbvhvFDVw+A6TaU5zRZAoh/PC1xWMMmkg4mG2zgpUiA3le5jZ/lyZoVdTf/EtohU1cZ7Ww15kX240GFNqLmgD7q0cAfDpLe4Lm9jZF2oVlSbEUP16BmIzCiphYDOyXe+cIvhEuuOOuZC2r4xmmpY/KAMxZuvVU5YcJZgBZClc5c6gU8ixYWKnJIQ3lztCm+3sI/9UsyTcToVCDrAOI8lFzwtlJex+x81RsD5KDLSgzZ+L3DqGFYrgfM4AXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V519WsdDsLhQcSitVWrmZPwA4RVtfnxNsUoCkWKP0qw=;
 b=UvOBdf7c3dOI0wR2jqErBASO7Vd6oZ5nJg0gU9/BUIWxIb3xQPIgll5bXCpURRGNFpAkk8m8+GqltZBWJ5jJvLnRgDzksagwnUKEkQlgDv7BryOHEssUnjqcbQZch5cTn1Y2mjWP040+yWAVY4TJh/q7sHzeN9SE5SpNUyM/s0w=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 22 Apr
 2021 20:55:35 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%7]) with mapi id 15.20.4065.021; Thu, 22 Apr 2021
 20:55:35 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH 2/4] mm: x86: Invoke hypercall when page encryption status is changed
Date:   Thu, 22 Apr 2021 20:55:25 +0000
Message-Id: <cf5f311872f58b371dec43e082d82dae55533597.1619124613.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1619124613.git.ashish.kalra@amd.com>
References: <cover.1619124613.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR13CA0022.namprd13.prod.outlook.com
 (2603:10b6:806:130::27) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA0PR13CA0022.namprd13.prod.outlook.com (2603:10b6:806:130::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16 via Frontend Transport; Thu, 22 Apr 2021 20:55:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d21adc52-70f0-4b3c-5cc6-08d905d0f9fc
X-MS-TrafficTypeDiagnostic: SA0PR12MB4510:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4510567454CDA57F4FAC4CD48E469@SA0PR12MB4510.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fWDFCkiBbF7ln5wE2hx0lups+YSq9KuRafYU5/6MmQp13/kQISAc5BAjEhbVWsffYsUWm9HecFSQpxLhtlU/IjDXNQPtBGsraDcOJliZYIDRG3ChxtcuSQZ3jNrhz1QIsNyGMwWGJuPO4Zb28n9xRVUZiuysMI1jNYVNzhBjT0sGaVwzLY7UV7qJcT+dx2C/UUpJmVer9i/1W2E1XeB2IIHsRPgGKJbg+VRwkv6DIRH1ueMrLTSAR2HHiLTqdf1gwPqU6TUAiO5AjS9rYSi+1Jl0frnJfAXigC1evvSRjaVVvkidEpzVFnJb62POiA6BjT4DckzAt2bM/15Q80V+OE2pKkaCcn4XuAWYOk7JBiF2i2WFyPxoZ7L3J3A8C7Mv0FWsFZGzdBzvyW3VsrKy6fHYpXey70cDlwsyw4B0w0C0HAZL9ty8b2lUDSfq1L+LdlcMSzT6Flg20wFsnGZsiGeDOD1A/TYd7Ewkl8jL9/GULVSUQth5IvSbsKCi/x3caThrnKJszaQAN6F0zJlC0ul0H+2URMlgzxuxGBxD8TevXQN327mCbkes9wXF7ZYMbXeDh+BGQgEeGVOcVUwWBHY1hn/isKC7u5zbGTC/Hl9mQRTEFDJSwmhJGF2gEDyxUnKfVW83nZdabdeEd8Bp4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(316002)(7696005)(6666004)(86362001)(2906002)(52116002)(66946007)(66556008)(956004)(8936002)(38350700002)(4326008)(6486002)(5660300002)(66476007)(36756003)(6916009)(38100700002)(186003)(7416002)(2616005)(26005)(16526019)(478600001)(83380400001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4DU7N7YTOW4EPj5aeQwfwCWd0KCtrO70bkoJX8gbknWWPU0ogEpHHFNGjdrJ?=
 =?us-ascii?Q?CTxdPehDtLKeB3CbUnLspSIdjzHW2+V6iecqE1PZXgMXGENXPU1fWS5bj8jW?=
 =?us-ascii?Q?o3LDUCxJOB99xra+mt2ZyHf7c0dMiGv5kdXje4UfqMJXqk51x6mXYbZlhyFw?=
 =?us-ascii?Q?X/OCLYGv3dTBvqGT7wbdYk+FSS7YbCTXCjG3YdQfBnZY2oNSvCO8oeo0Jxfw?=
 =?us-ascii?Q?kmEe2d1XjOs0SOKVpGGUX81juey3EZ7ATf9qm2AuykpH07OK2hsKwSAAj3rn?=
 =?us-ascii?Q?9B5sF15paDUgnG30N2kG6cQLGtF2y8aMy0mYCsfk4+WVIGOnwZ8vHpZBTyI+?=
 =?us-ascii?Q?pnvU3vdZohSn2KCdWqZE5EaUlyGzXqPZkNwc8G7sZG8SQ1abzopW38Xn42Gb?=
 =?us-ascii?Q?8brLt/2n/reRO3GDMm0P2c9dvvLgq1VfRXRna5tO0jheW7Pw1YzQkWmgdp7X?=
 =?us-ascii?Q?pJV7Q/nSs0ge9xhVcNRxNEhNWxCD8NFOhPrZxuCerNiWGJ6+hFqCAalpOyWh?=
 =?us-ascii?Q?RT/etebOp8WRtyvtYfZO1QajWr0kt0+3lTnnp33hdwp2fid7/u362NvtlP0F?=
 =?us-ascii?Q?Bk+MMrykTLecgR24ZCU8Hi5DPX/ohvUENijwOtRCerUSCvLq6bp+mgIFjdj8?=
 =?us-ascii?Q?avFnzK/U8xe4MGq1JP+z5+feUbxfyTVD/516vf5ASw2QgQXH4GXfpOgNSLTn?=
 =?us-ascii?Q?Qn2LtIPQqwITnLVnnAAK6Di8D6dOMn3y1shIxyWiEUD6Hw7WC58yBJkx+SrD?=
 =?us-ascii?Q?TGw40IH9fmrYL89226jaTndbOZxmhP6UcxIIcUBD9+a0rRJJt3zQJisQmo41?=
 =?us-ascii?Q?IBvRpG3chAAA4tsieCONzRVEUA8zdiXr+uhLGyUZhhjt8DYGbSN8qh4EocI2?=
 =?us-ascii?Q?jDTqHELDMs3MyT5eqGD8oZKBU9xrOI7bUyVR590+Ihdjj2zC+WquTmWthlnr?=
 =?us-ascii?Q?EEuWymjBuoEpV2EIC2CE2xrDaZeaoN2Pfl09OkRc3JesUf7VjxN1kvIIEZKr?=
 =?us-ascii?Q?w+Ye8Ii3+sgvBfOBdd7sfdN4cnBIDhAK5/ibp1aQ4XGaxTU9ajVA2npQQ/T8?=
 =?us-ascii?Q?hNkD+aonm2UfM6yFn0EPCOTFyPPY3r/XG/mvN5iWhGRJ+gXINA0+75kQp0os?=
 =?us-ascii?Q?m7tpLPquqnhKzGMGI3BSdzLcbgxTX7eeOVG+zJ1vgzrq/FZ7e/8epbdryy5s?=
 =?us-ascii?Q?YnxPygGo2ev/NQS5xFHGMEH63CtBUMYDMvPtZEYlMSPa0MOAnJCW4d7HxDdL?=
 =?us-ascii?Q?Y5+zFIVw0pin7wxjc5HhSULj6KlRYLcTCADkHgZqpzCJ+u1uZu3kfsSxzbX3?=
 =?us-ascii?Q?24Ttugmr0O+lxTT/1uZvoXTr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d21adc52-70f0-4b3c-5cc6-08d905d0f9fc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 20:55:35.6277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oXdzX9JhXOBl9NxP8GRtzTDJf2MRx9xx8xRbDiI1/DRuf59yBG3fNp2CqBlBPstY1+SfS+ADgGTwQg9WwRCmKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4510
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

