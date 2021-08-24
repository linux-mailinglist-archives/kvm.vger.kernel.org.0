Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274993F5CC9
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 13:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236610AbhHXLGD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 07:06:03 -0400
Received: from mail-bn8nam11on2085.outbound.protection.outlook.com ([40.107.236.85]:65342
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236601AbhHXLF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 07:05:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dbB0QrTTv96fyGWJnf0mRrgFn5rddDDn0Ef8CUEW6inpWCVuVYjROUAOtnaT1MhxPXoAhgK0GWfh4NQkPhKUNT/sz0bPgVuzXsSDIxrok6P7coQ/JSxyW3u4JeIC8zGJWE0WX2MrWYPngJ4kRrsWl7uPoDcQhuuvLMR8CoO1vBNaqAs2fILh1wVTFlOF0sLYrPRCYazkfe/cqYUcQSuuTWHh3Emz2f2o+r9t+Q0VaoG7VEgeeWTP+eRjFsrmfRQcHIkVc+1Cw7HPzBvDM9MOA1rM/sGCsHMI3svg3TSqJ5jICOZTe/dx0EMDSwvctK9zrBExOZBFaQbAWj6MZ0s8pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=slkbt5DX+7qkTH/MJzZRKo3B9pqMRUFT25eGHR/gFjM=;
 b=jlB8AqNAhiBgZCzTlgFCRtV7gwuk4NrBFS/VOTeAay9mSJDbsto6q2trIDHyYXdlsSH1h9FV3ORMxz3vVpaKJ7moJQp4DqJsVTls7e3RYOsJhO5yLBF3Q5mXc/fk+rBQ5d1eXTAXuG801fawYkcToZ2EO1IMZvNDjU8yB1FBFkCmWN+erK8SEx7sX9VSKq11DWN4w/VznouTR+Lnno4XCwGSu8sHCuPhJJ+5qpvEPdLQHVDZN0PR+3S5qfO6/DkYUXEduQdOoeahDkBZjDIWHWZIr3mgFPFK76HqDaMDe7p5MP9wqvoOuapDpx4/Vlpc4PVp2yb4bbo0pfNW1rUZog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=slkbt5DX+7qkTH/MJzZRKo3B9pqMRUFT25eGHR/gFjM=;
 b=i/KJQq+c8Xr1UW+45gg3sqa4XYm7ml8mrONWvU/G0w6xLuVu0wXJxVxm6UZNFHJ5gXREEHODW2w+BX6Uh0AixsEOagg7Qcrn5THQERkEd/LzTF2aGE5a2EuxpI9otTUAD5J+MPrS/CBYqo2tzEQXkps7QLF30AtdNrlb2gYtNbw=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2544.namprd12.prod.outlook.com (2603:10b6:802:2b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 11:05:11 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 11:05:11 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@alien8.de,
        Thomas.Lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        brijesh.singh@amd.com, dovmurik@linux.ibm.com, tobin@linux.ibm.com,
        jejb@linux.ibm.com, dgilbert@redhat.com
Subject: [PATCH v6 2/5] mm: x86: Invoke hypercall when page encryption status is changed
Date:   Tue, 24 Aug 2021 11:05:00 +0000
Message-Id: <0a237d5bb08793916c7790a3e653a2cbe7485761.1629726117.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1629726117.git.ashish.kalra@amd.com>
References: <cover.1629726117.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN6PR01CA0005.prod.exchangelabs.com (2603:10b6:805:b6::18)
 To SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR01CA0005.prod.exchangelabs.com (2603:10b6:805:b6::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Tue, 24 Aug 2021 11:05:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 691855f7-6a39-4d2a-6fb5-08d966ef0af9
X-MS-TrafficTypeDiagnostic: SN1PR12MB2544:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB25449B47826F51F184E088EE8EC59@SN1PR12MB2544.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: osG6ehWtsCqZKomiJ0rpNUGXw0QlF2QO2hxji311rQFnxPiSizmgH5CDD3+wv1i5QxxqZDrGW6ha/o22QE7aktUeMAdo8RoYGK0wO82VYBc73E5AQXuPWTRkJBAflCplZWXAT3XkwE6ngCp/h72x9WOec+eUjSWbb/kot8XrqidCC5if4HmsgdHGSCuBYuClfKsS73cV8yUP/Or8ywFYoBInJTjGNRRhSCjBKQ5zY4q5vNbJVZl3J1E/DORU47BqWuJEiNW5xZzqEoYi+wYL7vnM3I8BnhGSh00JJE7+yxh+nOfc/4U0wXEqcTlvbUMCpkFiL4qjH9DuXNrwV2Ub8/IBYABOuQzEvF4K6W9U23RFVUudIIcwPlqKA9PHZW0D+FrYzaQi8rAph/bSANLvQPYcea1TQvCY/rlAcayFToRyeVjXWn2K1sB6f9vRYyK5e38usxA2uYpeRjP1dFDN0Ej60+OiNRexMEcne+3ayIobXwq/xCIrCEl1+2m7Pt1/kImAJADWopTa5gzvdSrhAzY3VznnvmfVwls4yCcDZb7pTxydAM4zXecdKBZHza2dgk8rpULDucIxDx5goLKfj+w6SKQkMb91ol9fJduhMBazHUraSzaa1JwKwVEfUdlliPWVwYz+kc1lZvOggdwU2GQhxtvr1Koqgwn0IXcUc7NNELU6roNgIrfVCW7otIzwS/yEW7QYPlO6lAF1EJ0vJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(396003)(39860400002)(346002)(36756003)(83380400001)(2906002)(6666004)(6916009)(956004)(86362001)(66476007)(5660300002)(52116002)(8936002)(26005)(2616005)(7696005)(66946007)(478600001)(38350700002)(38100700002)(6486002)(186003)(4326008)(316002)(8676002)(7416002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mJIb+olE7bPbXhgscNUP6P1VVRb+1AaAqSkWzpDr2SdmyoMVUbQcBElQ7pnj?=
 =?us-ascii?Q?mOA6MEI16nFzI2rIkdfQ8A0/7Y3SaTum/L7XDN+Yl6TS+11spTWBl4cDP1Vm?=
 =?us-ascii?Q?5ZXR0N52VD2an0fdwvNJaEcPfQdia8saTJFveQsYBxzxkeSe/Bap2dVTdKCL?=
 =?us-ascii?Q?TmikGY48G/+MLkhoX7noSOKmPN7oB6ODq3aVoeAgL9JW3RLp36tlI6XIezAg?=
 =?us-ascii?Q?It2mnZRa2hQa+toxYooOaqwsbrSsgSFhxPVSAOnpdbe41m0Mxo7JzQDE9Xho?=
 =?us-ascii?Q?t9tJZ4dkiV0ssy8Hebcgr2WBtDIjNNf/EhZcAbopym73wmPU/j6ToXzLZV4H?=
 =?us-ascii?Q?3K2VL82fMEhlz6gsJcrHS1lwcc48qWJemDms6OrvryBtnlHpQzBN+LExhlGX?=
 =?us-ascii?Q?2CphUhEh8q+v/ocf6Qx883koJ7wcZlkMWML8uKdW8S+AdwQBNqX21mKbDiZG?=
 =?us-ascii?Q?3H7ApvXNPBYnFf9bNMtWT1BUV43XzYJUKu1yf5teDvSlhRNH8RYKSBNFKYib?=
 =?us-ascii?Q?fHe+w25Zu7cbK0g6HhrwEZW2zr06wACqSd/fO3PigNDmrLL9FSFU96z4zpiq?=
 =?us-ascii?Q?7GN1byHZZVLGhLzGotZrLU5C2wzRyqqBAKMzqL8dNHDUbKClQsk7v7s+yYxq?=
 =?us-ascii?Q?lIoPgMZGpVRk6KIc+tQ4n5wKzl5HAJjkEY2Fa7ena5e5KyJdH0hnFw9aQvZS?=
 =?us-ascii?Q?jfiRhgM9zk7odiD9kyag29+vShK30KC3Jn+FuzUvuvbN1RTo5JRVMwe35q6L?=
 =?us-ascii?Q?/41hd01DbFuUahsaZVS8arrZEirnw1I21+b/wJNAd37GEIbHHXeBIF5YVC25?=
 =?us-ascii?Q?fbB3FwEU30LcT/WRsaFH7WjuLRGTTqrfZdspHtBCoqlB3j7Yttg+yZKj6aNW?=
 =?us-ascii?Q?BM9ePrcU5oETMtS+Ul9VA9c28VexUvg5NaR1xrVxpu4ObIhGbfR6X94JynsK?=
 =?us-ascii?Q?RZO5t7s/IDDxhrlBrCweyfO3gwjUHdZngL+AvaNpYf6Hm226k0nU3wwMLt4n?=
 =?us-ascii?Q?uCFOkNpCJlmA8+IFSHd+TDbUP7iDSfCgFXHKg9mcF3mWpElMhHqrZPeaBuVl?=
 =?us-ascii?Q?JZNyHp8rw9BfxXjR0AzbSPPJX8TevhEWZt3l3/FkZhDh5PDEZNUpk34N5kpi?=
 =?us-ascii?Q?9jc/rgit6uTVxTW4fXRHOLQvLRQUDh7eWtOP5ynMe94pstAcgtiHoo+la626?=
 =?us-ascii?Q?TonRKuWbwma7sX1zShN3FPb/LgLLRDdHwtTyH/Z4dCcta1m0yi5p3PxNlIxh?=
 =?us-ascii?Q?y0ZCK/2DriKh/Uw05YCpVujR4GffZiQHe/wbntvkICNXHT3/rqZAyeUhPY/a?=
 =?us-ascii?Q?7pzZs5PQx9kiZNVuSnPywWdC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 691855f7-6a39-4d2a-6fb5-08d966ef0af9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 11:05:11.8351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pYaW78HTf8ShvNkUm2L3Civ/TD/xYCxE8wGiVlsbs+1rME70kbTcqNXTQeFNDE9n/hhCNeB9vmvRYBeh4yCAHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2544
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
index ad8a5c586a35..4f0cd505f924 100644
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

