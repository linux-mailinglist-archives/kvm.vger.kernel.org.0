Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE4D35D160
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 21:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238180AbhDLTqI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 15:46:08 -0400
Received: from mail-dm6nam10on2077.outbound.protection.outlook.com ([40.107.93.77]:39626
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237514AbhDLTqH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 15:46:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EQpaWcyyiS8MQr5T8qSLK3DXRj1Y9EzOeajwCslyWer1tmNriSnDDkF4grPb00vTqdFRvLY7hK31Lk1aj67dFrHy/cXZyBT4eBDct6N1+sjY+UtjSHMzkt0RwIFfPJ2IZKgkPddxlhwdxIlGWd4eeFeD1OzzDygXvgTSH9lm+F5j/XDEt1TR+I25MQ+jFz+m8USbBjTgxga+M4oDZrEjqR1rvj9psUMyI1wT5poXHqLjX9keonjGvVU8eJGhsa/VWCbqiYs+z8PKIlgmTZz/Nqckn9NQ3WTjucZaVTDWUjdcUWHl/lZmkY4fDkNRYJ/GW/CaEQLBYYFv01sqcVxOZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptwi1W+4zT0Cz1ubGqqSi1V3I2VOGialOuW68ChkUDM=;
 b=Licoaht6c0lQCqHxjFI+ORp9gBmh3jxwzrdZUssunfBLT1O/OvJc/DB+HdqOaUR0xdFbqO5NW10FaDP8lpuL9xmLix8ZszYqV+uwnGDo8/ImVwu/tvvNpEdBYfZ4IoKWfMgWHr5rkoyTjrgR3vUTOvfLAmwnznvK8MCU3vQ0zIf2U2bB5VY0z9y+4DKM58h/2fy09rp5b7T85jltZfmylbuF1hE+szSXKIa9FWMk5YmU6bajdHQ7fbO+kE8zfJ7KeW+bq9+0sX34h2LFWF/krFSDJt+Tx4Pz44lFC5PuDDf0zQ04znWG5JOhsm32ZogqOZrwYld1yyXSai6F4sqoJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptwi1W+4zT0Cz1ubGqqSi1V3I2VOGialOuW68ChkUDM=;
 b=3qOnAm1xbCSYykEgeFT0YGDpL1Kgah4Zra5rFAJi78hIhkbLdbl/AedEQjS5kZ0vukv+Xota8nplBKOk+X+hZvohlbJRGU8yHSLGr8uvFIqAU8Qh+/e1cksMfkdKDfHloPOtKvzLZwYigYC1W8bSI8KoCIMUqmwdwNIUZFOsC+0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2367.namprd12.prod.outlook.com (2603:10b6:802:26::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 19:45:47 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 19:45:47 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v12 09/13] mm: x86: Invoke hypercall when page encryption status is changed
Date:   Mon, 12 Apr 2021 19:45:38 +0000
Message-Id: <f2340642c5b8d597a099285194fca8d05c9843bd.1618254007.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618254007.git.ashish.kalra@amd.com>
References: <cover.1618254007.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0139.namprd05.prod.outlook.com
 (2603:10b6:803:2c::17) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0501CA0139.namprd05.prod.outlook.com (2603:10b6:803:2c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.8 via Frontend Transport; Mon, 12 Apr 2021 19:45:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad0a17d8-f80a-4282-899c-08d8fdeb91a2
X-MS-TrafficTypeDiagnostic: SN1PR12MB2367:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB236765F15ED4214ED1B82C5E8E709@SN1PR12MB2367.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iFzTQEY4Iq6czYzSzb+innCJ4FJmGkmySJUmYH6mL2oD+VAxcum00vcJ0Xtg8dOU4lalYH13fMra5Z0Mb+wAj+4MDeneSHqKHF2qQ97qKroDtVjS8HiXiP8AvplYO05C4G+6LroozWJr+755HLFzQf96xvg7J67XgC3O2Gu7Cb4+Cl4auUE8sDT5mUgUbUSE5olAQQUnEF9scEOXvn4Qm+owF4SV3tpP8TwndngCKJI6ZBe6kWAf53tsDxLL1zAX7Rr3a1qVpfdwbZYwkfrlt7oTHJkSvxs2f50qzw0J9Lqr0NOT6hJ83Rwi3tUYUd5XUOG12HyKHoaX5kYq55A88D0pDKgo+Ia37EVBOh1bLxssU7Yp10upTVx9F3Wm5aNFMDMMwGOCb+Jck+5Gau5EvsW0LtXjxuorPHDkHOFpX9hs/KOBkBGxQMAWPmfqqRrXn85aqsRsh4LXfHgSRYv42onpf3xiRe0K9IxmC4RdiZDuw9Br95dw1VWS5x76QnvykIhqMYHi1wpOISf3goJkGH1o4ABSjNtUl7tKPWF9wFDPAAbMX34d1akvCgBUqVhkNYOK5ZcPBJN7OcQ0KTTUhz79IcMviusTe9ONKlpwjAAeHTIJjjua5v5Ua5IR8M8KVXOyekVGyX3aFN089ibIz5KAM5xI08GvEC4Ubgx+DT0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(366004)(136003)(39860400002)(6666004)(36756003)(16526019)(7416002)(38100700002)(6916009)(956004)(38350700002)(2616005)(8676002)(8936002)(2906002)(26005)(478600001)(5660300002)(52116002)(86362001)(316002)(4326008)(83380400001)(66556008)(66476007)(186003)(6486002)(66946007)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hloCLHp9WhxaRiJ+0dfxJ47npvolmSiXkKjbJSP3ogjgU8UqPeJfIb2dhzWg?=
 =?us-ascii?Q?/uk+i9COPV2xsYQdpsDDWIn7JAFo+zSZh/D+4Udx927KumFpKVoNUPDHrfz0?=
 =?us-ascii?Q?3SxlDLUlGaQ3FHqikiNPf1lM0uzNsgcVUVavCch2nDqnjkKMIUDnuAOY2SJY?=
 =?us-ascii?Q?GN5eYqoyICw4LcvW8VfbY7Gg4XjxzpHbd1KeVa0ScD/kXKgzHlnsdZ985pWg?=
 =?us-ascii?Q?YX1SrrqW41+HuxUKi0ydBF6vrRzcq+gw6m4xSG2dcznNuF4pWNnYAkL56pCa?=
 =?us-ascii?Q?8U8GL6tSBO/ww8f5HlitYTkqCpOXbUX3HcB16WTcCU1uNj00lkHmuo8YzdF+?=
 =?us-ascii?Q?Jik3YbsXfYtDK9tAoHlD97Ba6PRHnAeHpVqzOSHP+9/Fs+CYs+PkWYcALcXP?=
 =?us-ascii?Q?UCMoV8wdLGbMpj7XBX5adUqrIDT0UFjdJCHZpNWnWzVtFnSpaOwMsUHmTBmR?=
 =?us-ascii?Q?MBtBx0aT2YNUm8tW7xM3eeLy5mrs/9R43S5Oklxq0lzFU8YXYqbecEnFvnGw?=
 =?us-ascii?Q?K3sXh4VwKWN6exwffCfYy1ql1QMJ/aRA8SkM55oxjvxfHQxxjgyhknUVqoBL?=
 =?us-ascii?Q?OcOIWkW3xjIFt1u8aDLXH1qTMQ5sMBduyh9dqYpIbyzb9xOUy0u5Ca4XO7M8?=
 =?us-ascii?Q?ggO8mca7Afb9XJWYve5Kse+xqG6aByjGXW/Gc3oYu+Pu6E7Fcv1OsoLKVaDZ?=
 =?us-ascii?Q?HwfnhLUXjOUvx62/2s3c6pr/V1vQXosRHT5xJiVCqXgTzePrqil3S7F3HT1a?=
 =?us-ascii?Q?c/A7o0VIkBTMpNI1PwTbnxiNLewVM+riUj7Ybyo3x9mp1de0tvD3c1GMxCpI?=
 =?us-ascii?Q?q6ShyCa7FoW64PvyUAqNzoVpkXG/F93Hsf7ARZqnR0IKm0L6odDuMFWgfVut?=
 =?us-ascii?Q?baDp1CuIdD7wtcx7WpgTgYI9WMzGW4fz2Sz3txRyZS3fnAMRh/tYqHxiamt4?=
 =?us-ascii?Q?HxU2gOh0Ge94W5gKbcaXyqMHB5MawkSfJJSsy2wO4dIw8yI8vpTY9Vr8nPRR?=
 =?us-ascii?Q?XIjyIvfCJ4I1wO0DaijQycKiKam11AXKYbEHWhqU52FT+vYEKtUSNFroK8RB?=
 =?us-ascii?Q?krJJ0sQuJl+aCFrYyHAZ/1wl/2CU+wJtFOcPLojas5NsSKfeN6tqiLNR+z2s?=
 =?us-ascii?Q?wrC3YqtREj2PhmKqRgY7YzFRHNWBNGCkPuNTUsgbQY6pTcDY7QNM3me998Jo?=
 =?us-ascii?Q?uvxWA5fNbsygOhykzRBuT3SyAYXjgZiZm0e4oLeFgH7ni8wqJK5v65rprhst?=
 =?us-ascii?Q?XxHfHoaJruuFrLcGoYsMy2lEJmuO8h1muLKlWPptXCuZW1aBrof/lG3w0OHQ?=
 =?us-ascii?Q?1k4q60xjdvVGDV8HaDU7hUjA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad0a17d8-f80a-4282-899c-08d8fdeb91a2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 19:45:47.6484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 19InP0NEXtSZcxpTQLLr2N8o3JvcNPH8JsFzxvniEi2z6hWEDjc1ervExJ7Wkj98YUHQMGpUqLlgHNjQwjpKZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2367
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

