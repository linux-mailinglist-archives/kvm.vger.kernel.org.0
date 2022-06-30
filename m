Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D28562134
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 19:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235970AbiF3RYn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 13:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235207AbiF3RYm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 13:24:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D00934641
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 10:24:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0A266214F
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 17:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF37C3411E;
        Thu, 30 Jun 2022 17:24:37 +0000 (UTC)
Date:   Thu, 30 Jun 2022 18:24:34 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Peter Collingbourne <pcc@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        kvm@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Michael Roth <michael.roth@amd.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>,
        Steven Price <steven.price@arm.com>
Subject: Re: [PATCH] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
Message-ID: <Yr3cUq2mIHPlkXUW@arm.com>
References: <20220623234944.141869-1-pcc@google.com>
 <YrXu0Uzi73pUDwye@arm.com>
 <CAMn1gO7-qVzZrAt63BJC-M8gKLw4=60iVUo6Eu8T_5y3AZnKcA@mail.gmail.com>
 <YrmXzHXv4babwbNZ@arm.com>
 <CAMn1gO5s2m-AkoYpY0dcLkKVyEAGeC2borZfgT09iqc=w_LZxQ@mail.gmail.com>
 <YrtBIX0/0jyAdgnz@arm.com>
 <CAMn1gO7aC1zqWDt1bAk_ds8ejuhx2obo-LE-2UwFXch=uNFoAA@mail.gmail.com>
 <Yryku0/XU2GkcjvY@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yryku0/XU2GkcjvY@arm.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 29, 2022 at 08:15:07PM +0100, Catalin Marinas wrote:
> In the meantime, I'll think some more about the lazy stuff. We need at
> least mte_sync_tags() fixed to set the PG_mte_tagged after the tags have
> been updated (fixes the CoW + mprotect() race but probably breaks
> concurrent MAP_SHARED mprotect()). We'd have to add some barriers (maybe
> in a new function, set_page_tagged()). Some cases like restoring from
> swap (both private and shared) have the page lock held. KVM doesn't seem
> to take any page lock, so it can race with the VMM.
> 
> Anyway, I doubt we can get away with a single bit. We can't make use of
> PG_locked either since set_pte_at() is called with the page either
> locked or unlocked.

I dug out the one of the old threads on MAP_SHARED and KVM:

https://lore.kernel.org/r/20210609174117.GA18459@arm.com

Last year we did not consider another page flag for the lock, only a big
lock or an array of locks and neither looked appealing. An extra bit in
the page flags scales a lot better though we tend not go through these
bits that quickly.

Anyway, I think at least for the current setup, we need something like
below. It can break concurrent mprotect() by zeroing valid tags but
that's a lot less likely to happen than CoW. I'm still digging through
the KVM, I think it has the mprotect() race already if it's done in the
VMM.

-----8<-----------------------------
From 1f424a52a71df0ff0dafef8a00fe1a8363de63ee Mon Sep 17 00:00:00 2001
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 30 Jun 2022 10:16:56 +0100
Subject: [PATCH] arm64: mte: Fix/clarify the PG_mte_tagged semantics

Currently the PG_mte_tagged page flag mostly means the page contains
valid tags and it should be set after the tags have been cleared or
restored. However, in mte_sync_tags() it is set before setting the tags
to avoid, in theory, a race with concurrent mprotect(PROT_MTE) for
shared pages. However, a concurrent mprotect(PROT_MTE) with a copy on
write in another thread can cause the new page to have stale tags.
Similarly, tag reading via ptrace() can read stale tags of the
PG_mte_tagged flag is set before actually clearing/restoring the tags.

Fix the PG_mte_tagged semantics so that it is only set after the tags
have been cleared or restored. This is safe for swap restoring into a
MAP_SHARED or CoW page since the core code takes the page lock. Add two
functions to test and set the PG_mte_tagged flag with acquire and
release semantics. The downside is that concurrent mprotect(PROT_MTE) on
a MAP_SHARED page may cause tag loss. This is already the case for KVM
guests if a VMM changes the page protection while the guest triggers a
user_mem_abort().

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
---
 arch/arm64/include/asm/mte.h     | 32 ++++++++++++++++++++++++++++++++
 arch/arm64/include/asm/pgtable.h |  2 +-
 arch/arm64/kernel/cpufeature.c   |  4 +++-
 arch/arm64/kernel/elfcore.c      |  2 +-
 arch/arm64/kernel/hibernate.c    |  2 +-
 arch/arm64/kernel/mte.c          |  8 ++++----
 arch/arm64/kvm/guest.c           |  4 ++--
 arch/arm64/kvm/mmu.c             |  4 ++--
 arch/arm64/mm/copypage.c         |  4 ++--
 arch/arm64/mm/fault.c            |  2 +-
 arch/arm64/mm/mteswap.c          |  2 +-
 11 files changed, 50 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
index aa523591a44e..dcf0e09112b9 100644
--- a/arch/arm64/include/asm/mte.h
+++ b/arch/arm64/include/asm/mte.h
@@ -37,6 +37,29 @@ void mte_free_tag_storage(char *storage);
 /* track which pages have valid allocation tags */
 #define PG_mte_tagged	PG_arch_2
 
+static inline void set_page_mte_tagged(struct page *page)
+{
+	/*
+	 * Ensure that the tags written prior to this function are visible
+	 * before the page flags update.
+	 */
+	smp_wmb();
+	set_bit(PG_mte_tagged, &page->flags);
+}
+
+static inline bool page_mte_tagged(struct page *page)
+{
+	bool ret = test_bit(PG_mte_tagged, &page->flags);
+
+	/*
+	 * If the page is tagged, ensure ordering with a likely subsequent
+	 * read of the tags.
+	 */
+	if (ret)
+		smp_rmb();
+	return ret;
+}
+
 void mte_zero_clear_page_tags(void *addr);
 void mte_sync_tags(pte_t old_pte, pte_t pte);
 void mte_copy_page_tags(void *kto, const void *kfrom);
@@ -54,6 +77,15 @@ size_t mte_probe_user_range(const char __user *uaddr, size_t size);
 /* unused if !CONFIG_ARM64_MTE, silence the compiler */
 #define PG_mte_tagged	0
 
+static inline set_page_mte_tagged(struct page *page)
+{
+}
+
+static inline bool page_mte_tagged(struct page *page)
+{
+	return false;
+}
+
 static inline void mte_zero_clear_page_tags(void *addr)
 {
 }
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 0b6632f18364..08823669db0a 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1034,7 +1034,7 @@ static inline void arch_swap_invalidate_area(int type)
 static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
 {
 	if (system_supports_mte() && mte_restore_tags(entry, &folio->page))
-		set_bit(PG_mte_tagged, &folio->flags);
+		set_page_mte_tagged(&folio->page);
 }
 
 #endif /* CONFIG_ARM64_MTE */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 8d88433de81d..01eda797bd59 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1964,8 +1964,10 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
 	 * Clear the tags in the zero page. This needs to be done via the
 	 * linear map which has the Tagged attribute.
 	 */
-	if (!test_and_set_bit(PG_mte_tagged, &ZERO_PAGE(0)->flags))
+	if (page_mte_tagged(ZERO_PAGE(0))) {
 		mte_clear_page_tags(lm_alias(empty_zero_page));
+		set_page_mte_tagged(ZERO_PAGE(0));
+	}
 
 	kasan_init_hw_tags_cpu();
 }
diff --git a/arch/arm64/kernel/elfcore.c b/arch/arm64/kernel/elfcore.c
index 98d67444a5b6..f91bb1572d22 100644
--- a/arch/arm64/kernel/elfcore.c
+++ b/arch/arm64/kernel/elfcore.c
@@ -47,7 +47,7 @@ static int mte_dump_tag_range(struct coredump_params *cprm,
 		 * Pages mapped in user space as !pte_access_permitted() (e.g.
 		 * PROT_EXEC only) may not have the PG_mte_tagged flag set.
 		 */
-		if (!test_bit(PG_mte_tagged, &page->flags)) {
+		if (!page_mte_tagged(page)) {
 			put_page(page);
 			dump_skip(cprm, MTE_PAGE_TAG_STORAGE);
 			continue;
diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
index 2e248342476e..018ae7a25737 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -271,7 +271,7 @@ static int swsusp_mte_save_tags(void)
 			if (!page)
 				continue;
 
-			if (!test_bit(PG_mte_tagged, &page->flags))
+			if (!page_mte_tagged(page))
 				continue;
 
 			ret = save_tags(page, pfn);
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index f6b00743c399..37020353bb35 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -58,6 +58,7 @@ static void mte_sync_page_tags(struct page *page, pte_t old_pte,
 	 */
 	smp_wmb();
 	mte_clear_page_tags(page_address(page));
+	set_page_mte_tagged(page);
 }
 
 void mte_sync_tags(pte_t old_pte, pte_t pte)
@@ -73,7 +74,7 @@ void mte_sync_tags(pte_t old_pte, pte_t pte)
 
 	/* if PG_mte_tagged is set, tags have already been initialised */
 	for (i = 0; i < nr_pages; i++, page++) {
-		if (!test_and_set_bit(PG_mte_tagged, &page->flags))
+		if (!page_mte_tagged(page))
 			mte_sync_page_tags(page, old_pte, check_swap,
 					   pte_is_tagged);
 	}
@@ -100,8 +101,7 @@ int memcmp_pages(struct page *page1, struct page *page2)
 	 * pages is tagged, set_pte_at() may zero or change the tags of the
 	 * other page via mte_sync_tags().
 	 */
-	if (test_bit(PG_mte_tagged, &page1->flags) ||
-	    test_bit(PG_mte_tagged, &page2->flags))
+	if (page_mte_tagged(page1) || page_mte_tagged(page2))
 		return addr1 != addr2;
 
 	return ret;
@@ -407,7 +407,7 @@ static int __access_remote_tags(struct mm_struct *mm, unsigned long addr,
 			put_page(page);
 			break;
 		}
-		WARN_ON_ONCE(!test_bit(PG_mte_tagged, &page->flags));
+		WARN_ON_ONCE(!page_mte_tagged(page));
 
 		/* limit access to the end of the page */
 		offset = offset_in_page(addr);
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 8c607199cad1..3b04e69006b4 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -1058,7 +1058,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 		maddr = page_address(page);
 
 		if (!write) {
-			if (test_bit(PG_mte_tagged, &page->flags))
+			if (page_mte_tagged(page))
 				num_tags = mte_copy_tags_to_user(tags, maddr,
 							MTE_GRANULES_PER_PAGE);
 			else
@@ -1075,7 +1075,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 			 * completed fully
 			 */
 			if (num_tags == MTE_GRANULES_PER_PAGE)
-				set_bit(PG_mte_tagged, &page->flags);
+				set_page_mte_tagged(page);
 
 			kvm_release_pfn_dirty(pfn);
 		}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f5651a05b6a8..9cfa516452e1 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1075,9 +1075,9 @@ static int sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 		return -EFAULT;
 
 	for (i = 0; i < nr_pages; i++, page++) {
-		if (!test_bit(PG_mte_tagged, &page->flags)) {
+		if (!page_mte_tagged(page)) {
 			mte_clear_page_tags(page_address(page));
-			set_bit(PG_mte_tagged, &page->flags);
+			set_page_mte_tagged(page);
 		}
 	}
 
diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
index 0dea80bf6de4..f36d796f1bce 100644
--- a/arch/arm64/mm/copypage.c
+++ b/arch/arm64/mm/copypage.c
@@ -21,8 +21,7 @@ void copy_highpage(struct page *to, struct page *from)
 
 	copy_page(kto, kfrom);
 
-	if (system_supports_mte() && test_bit(PG_mte_tagged, &from->flags)) {
-		set_bit(PG_mte_tagged, &to->flags);
+	if (system_supports_mte() && page_mte_tagged(from)) {
 		page_kasan_tag_reset(to);
 		/*
 		 * We need smp_wmb() in between setting the flags and clearing the
@@ -33,6 +32,7 @@ void copy_highpage(struct page *to, struct page *from)
 		 */
 		smp_wmb();
 		mte_copy_page_tags(kto, kfrom);
+		set_page_mte_tagged(to);
 	}
 }
 EXPORT_SYMBOL(copy_highpage);
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index c5e11768e5c1..147fe28d3fbe 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -928,5 +928,5 @@ void tag_clear_highpage(struct page *page)
 {
 	mte_zero_clear_page_tags(page_address(page));
 	page_kasan_tag_reset(page);
-	set_bit(PG_mte_tagged, &page->flags);
+	set_page_mte_tagged(page);
 }
diff --git a/arch/arm64/mm/mteswap.c b/arch/arm64/mm/mteswap.c
index a9e50e930484..9d3a8cf388fc 100644
--- a/arch/arm64/mm/mteswap.c
+++ b/arch/arm64/mm/mteswap.c
@@ -24,7 +24,7 @@ int mte_save_tags(struct page *page)
 {
 	void *tag_storage, *ret;
 
-	if (!test_bit(PG_mte_tagged, &page->flags))
+	if (!page_mte_tagged(page))
 		return 0;
 
 	tag_storage = mte_allocate_tag_storage();
