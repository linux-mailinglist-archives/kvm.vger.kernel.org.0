Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92305BF507
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 05:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbiIUDxC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 23:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiIUDxA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 23:53:00 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B743811831
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 20:52:58 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-34d2a92912dso35629817b3.14
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 20:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date;
        bh=65IHPDWcEPHatIJvVtC4UFnK87ToWVhNqOGAMogY9r8=;
        b=T15XCwtjMe5w/tN31uTWn/z5Zpdqlc3OvdvrohZCRYKMRqF4xVlTKGap7DcHirPdxF
         s//FqP6CeGcsGwcNZaYmivsEsjikqfblRVaLneli1/egVKiTp8o2MNymdVlvxG2hDxOH
         o4TtUcC8Lkjca1Wuuh7PpWYi4sasv63ev0HIDmtTel3dxJjYiFesZ4lW9N3Y0+GENakV
         88S7eR5f0SnWe5X+tcCq7Uk9q+komX6MnbXp4MoT/2TZntx8943Ic8bh+cmGzve4qs8M
         h2cpIFfsVhAQNmY/Qe0U/4HynDgaa/lFGAN5f9pVVkcezoKeH5qIv+5CeZdn0CULsOQZ
         8Opg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=65IHPDWcEPHatIJvVtC4UFnK87ToWVhNqOGAMogY9r8=;
        b=f7NE+urGeV4d2E82erFChluUaJRs1sVosFJFOgFQZ9FGLfP37/EAYtXQ+KYfo1kM5K
         i1Zcc3lMXQy9fsvAlD5aA30yGRA940adSb46gCeSynvc3vCW4sHnIwFI5+moAQiEHPqT
         7y43EpwXw/+x2mEt/yGctKxUjLb6L9Qa+JUwM2qYDVbOXmXPCU0IY6CAPNwRaYAKjyL0
         diGk8CdG2fB2j+o3Acogb7gBwzwqj4P4VQyAw7g+ait2F+sVB/40TE7lnLlb/1kQQPF2
         gv595l+kF+6mFDJFAmGBIwzCc9UDBBzZbH6HBEI89EIz2uxNRSIVY/sGA/6NHlR/Nlap
         0pxg==
X-Gm-Message-State: ACrzQf2VOk0amjxQCKUTeomMChgdmUgd03J1tdtOV3vmtjyPyCYSMTgR
        u2TJV8W291083btExSiyDdOhFwM=
X-Google-Smtp-Source: AMsMyM78bz4TcihSrVjTu5Y1OtfK1jOwBaqHwW5UWS4f8ruK/5Nt/yUuiNxHLYMDdB2HcHR00UHVMIk=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:1b89:96f1:d30:e3c])
 (user=pcc job=sendgmr) by 2002:a25:880e:0:b0:698:946d:9a0 with SMTP id
 c14-20020a25880e000000b00698946d09a0mr23249003ybl.172.1663732378017; Tue, 20
 Sep 2022 20:52:58 -0700 (PDT)
Date:   Tue, 20 Sep 2022 20:51:34 -0700
In-Reply-To: <20220921035140.57513-1-pcc@google.com>
Message-Id: <20220921035140.57513-3-pcc@google.com>
Mime-Version: 1.0
References: <20220921035140.57513-1-pcc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Subject: [PATCH v4 2/8] arm64: mte: Fix/clarify the PG_mte_tagged semantics
From:   Peter Collingbourne <pcc@google.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Peter Collingbourne <pcc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

Currently the PG_mte_tagged page flag mostly means the page contains
valid tags and it should be set after the tags have been cleared or
restored. However, in mte_sync_tags() it is set before setting the tags
to avoid, in theory, a race with concurrent mprotect(PROT_MTE) for
shared pages. However, a concurrent mprotect(PROT_MTE) with a copy on
write in another thread can cause the new page to have stale tags.
Similarly, tag reading via ptrace() can read stale tags if the
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
[pcc@google.com: fix build with CONFIG_ARM64_MTE disabled]
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Peter Collingbourne <pcc@google.com>
---
 arch/arm64/include/asm/mte.h     | 30 ++++++++++++++++++++++++++++++
 arch/arm64/include/asm/pgtable.h |  2 +-
 arch/arm64/kernel/cpufeature.c   |  4 +++-
 arch/arm64/kernel/elfcore.c      |  2 +-
 arch/arm64/kernel/hibernate.c    |  2 +-
 arch/arm64/kernel/mte.c          | 12 +++++++-----
 arch/arm64/kvm/guest.c           |  4 ++--
 arch/arm64/kvm/mmu.c             |  4 ++--
 arch/arm64/mm/copypage.c         |  5 +++--
 arch/arm64/mm/fault.c            |  2 +-
 arch/arm64/mm/mteswap.c          |  2 +-
 11 files changed, 52 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
index aa523591a44e..46618c575eac 100644
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
@@ -54,6 +77,13 @@ size_t mte_probe_user_range(const char __user *uaddr, size_t size);
 /* unused if !CONFIG_ARM64_MTE, silence the compiler */
 #define PG_mte_tagged	0
 
+static inline void set_page_mte_tagged(struct page *page)
+{
+}
+static inline bool page_mte_tagged(struct page *page)
+{
+	return false;
+}
 static inline void mte_zero_clear_page_tags(void *addr)
 {
 }
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 71a1af42f0e8..98b638441521 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1050,7 +1050,7 @@ static inline void arch_swap_invalidate_area(int type)
 static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
 {
 	if (system_supports_mte() && mte_restore_tags(entry, &folio->page))
-		set_bit(PG_mte_tagged, &folio->flags);
+		set_page_mte_tagged(&folio->page);
 }
 
 #endif /* CONFIG_ARM64_MTE */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 5d0527ba0804..ab3312788d60 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2049,8 +2049,10 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
 	 * Clear the tags in the zero page. This needs to be done via the
 	 * linear map which has the Tagged attribute.
 	 */
-	if (!test_and_set_bit(PG_mte_tagged, &ZERO_PAGE(0)->flags))
+	if (!page_mte_tagged(ZERO_PAGE(0))) {
 		mte_clear_page_tags(lm_alias(empty_zero_page));
+		set_page_mte_tagged(ZERO_PAGE(0));
+	}
 
 	kasan_init_hw_tags_cpu();
 }
diff --git a/arch/arm64/kernel/elfcore.c b/arch/arm64/kernel/elfcore.c
index 27ef7ad3ffd2..353009d7f307 100644
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
index af5df48ba915..788597a6b6a2 100644
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
index b2b730233274..2287316639f3 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -41,14 +41,17 @@ static void mte_sync_page_tags(struct page *page, pte_t old_pte,
 	if (check_swap && is_swap_pte(old_pte)) {
 		swp_entry_t entry = pte_to_swp_entry(old_pte);
 
-		if (!non_swap_entry(entry) && mte_restore_tags(entry, page))
+		if (!non_swap_entry(entry) && mte_restore_tags(entry, page)) {
+			set_page_mte_tagged(page);
 			return;
+		}
 	}
 
 	if (!pte_is_tagged)
 		return;
 
 	mte_clear_page_tags(page_address(page));
+	set_page_mte_tagged(page);
 }
 
 void mte_sync_tags(pte_t old_pte, pte_t pte)
@@ -64,7 +67,7 @@ void mte_sync_tags(pte_t old_pte, pte_t pte)
 
 	/* if PG_mte_tagged is set, tags have already been initialised */
 	for (i = 0; i < nr_pages; i++, page++) {
-		if (!test_and_set_bit(PG_mte_tagged, &page->flags))
+		if (!page_mte_tagged(page))
 			mte_sync_page_tags(page, old_pte, check_swap,
 					   pte_is_tagged);
 	}
@@ -91,8 +94,7 @@ int memcmp_pages(struct page *page1, struct page *page2)
 	 * pages is tagged, set_pte_at() may zero or change the tags of the
 	 * other page via mte_sync_tags().
 	 */
-	if (test_bit(PG_mte_tagged, &page1->flags) ||
-	    test_bit(PG_mte_tagged, &page2->flags))
+	if (page_mte_tagged(page1) || page_mte_tagged(page2))
 		return addr1 != addr2;
 
 	return ret;
@@ -398,7 +400,7 @@ static int __access_remote_tags(struct mm_struct *mm, unsigned long addr,
 			put_page(page);
 			break;
 		}
-		WARN_ON_ONCE(!test_bit(PG_mte_tagged, &page->flags));
+		WARN_ON_ONCE(!page_mte_tagged(page));
 
 		/* limit access to the end of the page */
 		offset = offset_in_page(addr);
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 2ff13a3f8479..817fdd1ab778 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -1059,7 +1059,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 		maddr = page_address(page);
 
 		if (!write) {
-			if (test_bit(PG_mte_tagged, &page->flags))
+			if (page_mte_tagged(page))
 				num_tags = mte_copy_tags_to_user(tags, maddr,
 							MTE_GRANULES_PER_PAGE);
 			else
@@ -1076,7 +1076,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 			 * completed fully
 			 */
 			if (num_tags == MTE_GRANULES_PER_PAGE)
-				set_bit(PG_mte_tagged, &page->flags);
+				set_page_mte_tagged(page);
 
 			kvm_release_pfn_dirty(pfn);
 		}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c9a13e487187..012ed1bc0762 100644
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
index 24913271e898..731d8a35701e 100644
--- a/arch/arm64/mm/copypage.c
+++ b/arch/arm64/mm/copypage.c
@@ -21,9 +21,10 @@ void copy_highpage(struct page *to, struct page *from)
 
 	copy_page(kto, kfrom);
 
-	if (system_supports_mte() && test_bit(PG_mte_tagged, &from->flags)) {
-		set_bit(PG_mte_tagged, &to->flags);
+	if (system_supports_mte() && page_mte_tagged(from)) {
+		page_kasan_tag_reset(to);
 		mte_copy_page_tags(kto, kfrom);
+		set_page_mte_tagged(to);
 	}
 }
 EXPORT_SYMBOL(copy_highpage);
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 5b391490e045..629e886ceec4 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -934,5 +934,5 @@ struct page *alloc_zeroed_user_highpage_movable(struct vm_area_struct *vma,
 void tag_clear_highpage(struct page *page)
 {
 	mte_zero_clear_page_tags(page_address(page));
-	set_bit(PG_mte_tagged, &page->flags);
+	set_page_mte_tagged(page);
 }
diff --git a/arch/arm64/mm/mteswap.c b/arch/arm64/mm/mteswap.c
index 4334dec93bd4..a78c1db23c68 100644
--- a/arch/arm64/mm/mteswap.c
+++ b/arch/arm64/mm/mteswap.c
@@ -24,7 +24,7 @@ int mte_save_tags(struct page *page)
 {
 	void *tag_storage, *ret;
 
-	if (!test_bit(PG_mte_tagged, &page->flags))
+	if (!page_mte_tagged(page))
 		return 0;
 
 	tag_storage = mte_allocate_tag_storage();
-- 
2.37.3.968.ga6b4b080e4-goog

