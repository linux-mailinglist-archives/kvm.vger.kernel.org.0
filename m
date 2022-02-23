Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7244C12D1
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 13:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240490AbiBWMid (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 07:38:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234988AbiBWMic (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 07:38:32 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBB09E57D;
        Wed, 23 Feb 2022 04:38:05 -0800 (PST)
Received: from zn.tnic (dslb-088-067-221-104.088.067.pools.vodafone-ip.de [88.67.221.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 895261EC0513;
        Wed, 23 Feb 2022 13:37:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1645619879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=i6n28Q6rKAo8mQJ0Lb1lcXle/xRQx/BIQ1hlAqaxWQ0=;
        b=elyAUA0BwUdIjMeyif8YI8pUJqcI0do7PClD0GKrDf/owXAa0nLvpA8zfFcGGldjnW8RHT
        rciU6L+1buxsk8L0WgcmRuoGRjkiLZNc9kds1y+L+GFiaDUqJSKIkbiFodWe00gI7SfXW1
        RuSm+z3Kg6ybax8/8bH68c9xoBMghK0=
Date:   Wed, 23 Feb 2022 13:38:03 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] x86/mm/cpa: Generalize __set_memory_enc_pgtable()
Message-ID: <YhYqqxaI08sOSPwP@zn.tnic>
References: <20220222185740.26228-1-kirill.shutemov@linux.intel.com>
 <20220223043528.2093214-1-brijesh.singh@amd.com>
 <YhYbLDTFLIksB/qp@zn.tnic>
 <20220223115539.pqk7624xku2qwhlu@black.fi.intel.com>
 <YhYkz7wMON1o64Ba@zn.tnic>
 <20220223122508.3nvvz4b7fj2fsr2a@black.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220223122508.3nvvz4b7fj2fsr2a@black.fi.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 23, 2022 at 03:25:08PM +0300, Kirill A. Shutemov wrote:
> So far it is only success or failure. I used int and -EIO as failure.
> bool is enough, but I don't see a reason not to use int.

bool it is.

---
From 8855bca859d8768ac04bfcf5b4aeb9cf3c69295a Mon Sep 17 00:00:00 2001
From: Brijesh Singh <brijesh.singh@amd.com>
Date: Tue, 22 Feb 2022 22:35:28 -0600
Subject: [PATCH] x86/mm/cpa: Generalize __set_memory_enc_pgtable()

The kernel provides infrastructure to set or clear the encryption mask
from the pages for AMD SEV, but TDX requires few tweaks.

- TDX and SEV have different requirements to the cache and TLB
  flushing.

- TDX has own routine to notify VMM about page encryption status change.

Modify __set_memory_enc_pgtable() and make it flexible enough to cover
both AMD SEV and Intel TDX. The AMD-specific behavior is isolated in
callback under x86_platform_cc. TDX will provide own version of the
callbacks.

  [ bp: Beat into submission. ]

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20220223043528.2093214-1-brijesh.singh@amd.com
---
 arch/x86/include/asm/set_memory.h |  1 -
 arch/x86/include/asm/x86_init.h   | 16 +++++++
 arch/x86/kernel/x86_init.c        | 16 ++++++-
 arch/x86/mm/mem_encrypt_amd.c     | 72 +++++++++++++++++++++----------
 arch/x86/mm/pat/set_memory.c      | 22 +++++-----
 5 files changed, 92 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index ff0f2d90338a..ce8dd215f5b3 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -84,7 +84,6 @@ int set_pages_rw(struct page *page, int numpages);
 int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
 bool kernel_page_present(struct page *page);
-void notify_range_enc_status_changed(unsigned long vaddr, int npages, bool enc);
 
 extern int kernel_set_to_readonly;
 
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 22b7412c08f6..e9170457697e 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -141,6 +141,21 @@ struct x86_init_acpi {
 	void (*reduced_hw_early_init)(void);
 };
 
+/**
+ * struct x86_guest - Functions used by misc guest incarnations like SEV, TDX, etc.
+ *
+ * @enc_status_change_prepare	Notify HV before the encryption status of a range is changed
+ * @enc_status_change_finish	Notify HV after the encryption status of a range is changed
+ * @enc_tlb_flush_required	Returns true if a TLB flush is needed before changing page encryption status
+ * @enc_cache_flush_required	Returns true if a cache flush is needed before changing page encryption status
+ */
+struct x86_guest {
+	void (*enc_status_change_prepare)(unsigned long vaddr, int npages, bool enc);
+	bool (*enc_status_change_finish)(unsigned long vaddr, int npages, bool enc);
+	bool (*enc_tlb_flush_required)(bool enc);
+	bool (*enc_cache_flush_required)(void);
+};
+
 /**
  * struct x86_init_ops - functions for platform specific setup
  *
@@ -287,6 +302,7 @@ struct x86_platform_ops {
 	struct x86_legacy_features legacy;
 	void (*set_legacy_features)(void);
 	struct x86_hyper_runtime hyper;
+	struct x86_guest guest;
 };
 
 struct x86_apic_ops {
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 7d20c1d34a3c..e84ee5cdbd8c 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -129,6 +129,11 @@ struct x86_cpuinit_ops x86_cpuinit = {
 
 static void default_nmi_init(void) { };
 
+static void enc_status_change_prepare_noop(unsigned long vaddr, int npages, bool enc) { }
+static bool enc_status_change_finish_noop(unsigned long vaddr, int npages, bool enc) { return false; }
+static bool enc_tlb_flush_required_noop(bool enc) { return false; }
+static bool enc_cache_flush_required_noop(void) { return false; }
+
 struct x86_platform_ops x86_platform __ro_after_init = {
 	.calibrate_cpu			= native_calibrate_cpu_early,
 	.calibrate_tsc			= native_calibrate_tsc,
@@ -138,9 +143,16 @@ struct x86_platform_ops x86_platform __ro_after_init = {
 	.is_untracked_pat_range		= is_ISA_range,
 	.nmi_init			= default_nmi_init,
 	.get_nmi_reason			= default_get_nmi_reason,
-	.save_sched_clock_state 	= tsc_save_sched_clock_state,
-	.restore_sched_clock_state 	= tsc_restore_sched_clock_state,
+	.save_sched_clock_state		= tsc_save_sched_clock_state,
+	.restore_sched_clock_state	= tsc_restore_sched_clock_state,
 	.hyper.pin_vcpu			= x86_op_int_noop,
+
+	.guest = {
+		.enc_status_change_prepare = enc_status_change_prepare_noop,
+		.enc_status_change_finish  = enc_status_change_finish_noop,
+		.enc_tlb_flush_required	   = enc_tlb_flush_required_noop,
+		.enc_cache_flush_required  = enc_cache_flush_required_noop,
+	},
 };
 
 EXPORT_SYMBOL_GPL(x86_platform);
diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index 2b2d018ea345..9619a5833811 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -177,25 +177,6 @@ void __init sme_map_bootdata(char *real_mode_data)
 	__sme_early_map_unmap_mem(__va(cmdline_paddr), COMMAND_LINE_SIZE, true);
 }
 
-void __init sme_early_init(void)
-{
-	unsigned int i;
-
-	if (!sme_me_mask)
-		return;
-
-	early_pmd_flags = __sme_set(early_pmd_flags);
-
-	__supported_pte_mask = __sme_set(__supported_pte_mask);
-
-	/* Update the protection map with memory encryption mask */
-	for (i = 0; i < ARRAY_SIZE(protection_map); i++)
-		protection_map[i] = pgprot_encrypted(protection_map[i]);
-
-	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
-		swiotlb_force = SWIOTLB_FORCE;
-}
-
 void __init sev_setup_arch(void)
 {
 	phys_addr_t total_mem = memblock_phys_mem_size();
@@ -256,7 +237,17 @@ static unsigned long pg_level_to_pfn(int level, pte_t *kpte, pgprot_t *ret_prot)
 	return pfn;
 }
 
-void notify_range_enc_status_changed(unsigned long vaddr, int npages, bool enc)
+static bool amd_enc_tlb_flush_required(bool enc)
+{
+	return true;
+}
+
+static bool amd_enc_cache_flush_required(void)
+{
+	return !cpu_feature_enabled(X86_FEATURE_SME_COHERENT);
+}
+
+static void enc_dec_hypercall(unsigned long vaddr, int npages, bool enc)
 {
 #ifdef CONFIG_PARAVIRT
 	unsigned long sz = npages << PAGE_SHIFT;
@@ -287,6 +278,19 @@ void notify_range_enc_status_changed(unsigned long vaddr, int npages, bool enc)
 #endif
 }
 
+static void amd_enc_status_change_prepare(unsigned long vaddr, int npages, bool enc)
+{
+}
+
+static bool amd_enc_status_change_finish(unsigned long vaddr, int npages, bool enc)
+{
+	if (cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT))
+		return false;
+
+	enc_dec_hypercall(vaddr, npages, enc);
+	return true;
+}
+
 static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
 {
 	pgprot_t old_prot, new_prot;
@@ -392,7 +396,7 @@ static int __init early_set_memory_enc_dec(unsigned long vaddr,
 
 	ret = 0;
 
-	notify_range_enc_status_changed(start, PAGE_ALIGN(size) >> PAGE_SHIFT, enc);
+	early_set_mem_enc_dec_hypercall(start, PAGE_ALIGN(size) >> PAGE_SHIFT, enc);
 out:
 	__flush_tlb_all();
 	return ret;
@@ -410,7 +414,31 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
 
 void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool enc)
 {
-	notify_range_enc_status_changed(vaddr, npages, enc);
+	enc_dec_hypercall(vaddr, npages, enc);
+}
+
+void __init sme_early_init(void)
+{
+	unsigned int i;
+
+	if (!sme_me_mask)
+		return;
+
+	early_pmd_flags = __sme_set(early_pmd_flags);
+
+	__supported_pte_mask = __sme_set(__supported_pte_mask);
+
+	/* Update the protection map with memory encryption mask */
+	for (i = 0; i < ARRAY_SIZE(protection_map); i++)
+		protection_map[i] = pgprot_encrypted(protection_map[i]);
+
+	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
+		swiotlb_force = SWIOTLB_FORCE;
+
+	x86_platform.guest.enc_status_change_prepare = amd_enc_status_change_prepare;
+	x86_platform.guest.enc_status_change_finish  = amd_enc_status_change_finish;
+	x86_platform.guest.enc_tlb_flush_required    = amd_enc_tlb_flush_required;
+	x86_platform.guest.enc_cache_flush_required  = amd_enc_cache_flush_required;
 }
 
 void __init mem_encrypt_free_decrypted_mem(void)
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index af77dbfd143c..3b75262cfb27 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1989,8 +1989,8 @@ int set_memory_global(unsigned long addr, int numpages)
  */
 static int __set_memory_enc_pgtable(unsigned long addr, int numpages, bool enc)
 {
-	struct cpa_data cpa;
 	pgprot_t empty = __pgprot(0);
+	struct cpa_data cpa;
 	int ret;
 
 	/* Should not be working on unaligned addresses */
@@ -2008,10 +2008,12 @@ static int __set_memory_enc_pgtable(unsigned long addr, int numpages, bool enc)
 	kmap_flush_unused();
 	vm_unmap_aliases();
 
-	/*
-	 * Before changing the encryption attribute, we need to flush caches.
-	 */
-	cpa_flush(&cpa, !this_cpu_has(X86_FEATURE_SME_COHERENT));
+	/* Flush the caches as needed before changing the encryption attribute. */
+	if (x86_platform.guest.enc_tlb_flush_required(enc))
+		cpa_flush(&cpa, x86_platform.guest.enc_cache_flush_required());
+
+	/* Notify hypervisor that we are about to set/clr encryption attribute. */
+	x86_platform.guest.enc_status_change_prepare(addr, numpages, enc);
 
 	ret = __change_page_attr_set_clr(&cpa, 1);
 
@@ -2024,11 +2026,11 @@ static int __set_memory_enc_pgtable(unsigned long addr, int numpages, bool enc)
 	 */
 	cpa_flush(&cpa, 0);
 
-	/*
-	 * Notify hypervisor that a given memory range is mapped encrypted
-	 * or decrypted.
-	 */
-	notify_range_enc_status_changed(addr, numpages, enc);
+	/* Notify hypervisor that we have successfully set/clr encryption attribute. */
+	if (!ret) {
+		if (!x86_platform.guest.enc_status_change_finish(addr, numpages, enc))
+			ret = -EIO;
+	}
 
 	return ret;
 }
-- 
2.29.2

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
