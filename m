Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10407558BEB
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 01:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiFWXt6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 19:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiFWXt4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 19:49:56 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153244D9EF
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 16:49:55 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j2-20020a2597c2000000b0064b3e54191aso784054ybo.20
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 16:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=f7hEYvs16C5Hh3J1bMIu9ameAoVR3D8cHVYfY6s/rfM=;
        b=f61MRM5nJZ2nCc6ENnmYqAlkQCW/lvCe54MAhkLgfnIXLqOGx1cVuNWYSt6xm7ruNy
         BwmO5qYxfwnlT0Do6lQo0Rj7CUBGnF0JqBv72g0V/lTfP6h63KU51rOKbF3dMk/LNJCb
         NR97PTJj8w/+m8wkU9N8+iMqJJ/luIabGpZhcmEyFCtzC/OOphJ1AmQBoIo5hZOyHMA5
         DlFGT8QU/tWtWOgxwBzVfCnfBWqM82wd08KzP3CH3kRDSU7t8WQ0OGthk3Lwhyy0Oyib
         4fKLXy7r4PI7DfLAETDccjKxHVIllyAMLPuL/FMs9ms/iMLEq6VORHlXmCch472X7u0a
         peeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=f7hEYvs16C5Hh3J1bMIu9ameAoVR3D8cHVYfY6s/rfM=;
        b=j8xqPHrku3H/XbZ9Qv9fxu3RZL2v2rvVH+c9xsvCViH2rFDpopMrrwzysHRooE8j5k
         JRaxbRFfR+0OPFVvOuUQYMoph0wKrlzrBECJmXEhVduFF9H42vzrR/4XUUaUYkuPcAzf
         LPPPY5AIoPtZ1TnAum9cgaDoQWpCtMoOfUOQIrs3HEg230PbwLvU5gzAAJTIigNJkmGP
         eHloBOR3N3TqCAKsiffziLfGG8fx7nbowNuiTT82ycovX1xU4BUfPe+kM0VrFzSbaiEt
         G3Nv5cRepX1po4SoSm6PegOT8hB+KGr+ZanxN05vwY0I2lZuk/i/CRKb9YN77ypIT1AA
         hafQ==
X-Gm-Message-State: AJIora8oy3mx1RDBILQieszJyyT4pDe1gH6k4S3zqUbrRB2fbtyKRgfN
        SeOyakvmgHaL4aEvANiy3oHp/Qo=
X-Google-Smtp-Source: AGRyM1sDSlMwMDDhnNeVvNzGEqMh7ydsscF1uK4qVrjgiAG4OVTtshwcyPQtI86ne6cKMTIlEStdNck=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:5f78:1f61:a153:ae87])
 (user=pcc job=sendgmr) by 2002:a25:8909:0:b0:656:ae08:d91a with SMTP id
 e9-20020a258909000000b00656ae08d91amr12681634ybl.414.1656028194361; Thu, 23
 Jun 2022 16:49:54 -0700 (PDT)
Date:   Thu, 23 Jun 2022 16:49:44 -0700
Message-Id: <20220623234944.141869-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
From:   Peter Collingbourne <pcc@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Peter Collingbourne <pcc@google.com>,
        Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        linux-arm-kernel@lists.infradead.org,
        Michael Roth <michael.roth@amd.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Certain VMMs such as crosvm have features (e.g. sandboxing, pmem) that
depend on being able to map guest memory as MAP_SHARED. The current
restriction on sharing MAP_SHARED pages with the guest is preventing
the use of those features with MTE. Therefore, remove this restriction.

To avoid races between multiple tasks attempting to clear tags on the
same page, introduce a new page flag, PG_mte_tag_clearing, and test-set it
atomically before beginning to clear tags on a page. If the flag was not
initially set, spin until the other task has finished clearing the tags.

Link: https://linux-review.googlesource.com/id/I05a57f546f2b4d9b008a08f5f03e9ba3c950fdcc
Signed-off-by: Peter Collingbourne <pcc@google.com>
---
 arch/arm64/include/asm/mte.h   |  5 +++++
 arch/arm64/kernel/mte.c        | 13 +++++++++++-
 arch/arm64/kvm/mmu.c           | 36 +++++++---------------------------
 include/linux/page-flags.h     |  1 +
 include/trace/events/mmflags.h |  7 ++++---
 5 files changed, 29 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
index aa523591a44e..f66f70194c76 100644
--- a/arch/arm64/include/asm/mte.h
+++ b/arch/arm64/include/asm/mte.h
@@ -19,6 +19,7 @@
 #include <asm/pgtable-types.h>
 
 void mte_clear_page_tags(void *addr);
+void mte_ensure_page_tags_cleared(struct page *page);
 unsigned long mte_copy_tags_from_user(void *to, const void __user *from,
 				      unsigned long n);
 unsigned long mte_copy_tags_to_user(void __user *to, void *from,
@@ -37,6 +38,9 @@ void mte_free_tag_storage(char *storage);
 /* track which pages have valid allocation tags */
 #define PG_mte_tagged	PG_arch_2
 
+/* the page is or has been in the process of having its tags cleared */
+#define PG_mte_tag_clearing	PG_arch_3
+
 void mte_zero_clear_page_tags(void *addr);
 void mte_sync_tags(pte_t old_pte, pte_t pte);
 void mte_copy_page_tags(void *kto, const void *kfrom);
@@ -53,6 +57,7 @@ size_t mte_probe_user_range(const char __user *uaddr, size_t size);
 
 /* unused if !CONFIG_ARM64_MTE, silence the compiler */
 #define PG_mte_tagged	0
+#define PG_mte_tag_clearing	0
 
 static inline void mte_zero_clear_page_tags(void *addr)
 {
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index f6b00743c399..8f9655053a9f 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -57,7 +57,18 @@ static void mte_sync_page_tags(struct page *page, pte_t old_pte,
 	 * the new page->flags are visible before the tags were updated.
 	 */
 	smp_wmb();
-	mte_clear_page_tags(page_address(page));
+	mte_ensure_page_tags_cleared(page);
+}
+
+void mte_ensure_page_tags_cleared(struct page *page)
+{
+	if (test_and_set_bit(PG_mte_tag_clearing, &page->flags)) {
+		while (!test_bit(PG_mte_tagged, &page->flags))
+			;
+	} else {
+		mte_clear_page_tags(page_address(page));
+		set_bit(PG_mte_tagged, &page->flags);
+	}
 }
 
 void mte_sync_tags(pte_t old_pte, pte_t pte)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f5651a05b6a8..016d14c9d798 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1050,11 +1050,9 @@ static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
  * able to see the page's tags and therefore they must be initialised first. If
  * PG_mte_tagged is set, tags have already been initialised.
  *
- * The race in the test/set of the PG_mte_tagged flag is handled by:
- * - preventing VM_SHARED mappings in a memslot with MTE preventing two VMs
- *   racing to santise the same page
- * - mmap_lock protects between a VM faulting a page in and the VMM performing
- *   an mprotect() to add VM_MTE
+ * The race in the test/set of the PG_mte_tagged flag is handled via the flag
+ * PG_mte_tag_clearing which is atomically test and set before beginning a tag
+ * initialization, and spinning on PG_mte_tagged if it was already set.
  */
 static int sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 			     unsigned long size)
@@ -1074,12 +1072,9 @@ static int sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 	if (!page)
 		return -EFAULT;
 
-	for (i = 0; i < nr_pages; i++, page++) {
-		if (!test_bit(PG_mte_tagged, &page->flags)) {
-			mte_clear_page_tags(page_address(page));
-			set_bit(PG_mte_tagged, &page->flags);
-		}
-	}
+	for (i = 0; i < nr_pages; i++, page++)
+		if (!test_bit(PG_mte_tagged, &page->flags))
+			mte_ensure_page_tags_cleared(page);
 
 	return 0;
 }
@@ -1092,7 +1087,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	bool write_fault, writable, force_pte = false;
 	bool exec_fault;
 	bool device = false;
-	bool shared;
 	unsigned long mmu_seq;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
@@ -1142,8 +1136,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		vma_shift = get_vma_page_shift(vma, hva);
 	}
 
-	shared = (vma->vm_flags & VM_SHARED);
-
 	switch (vma_shift) {
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SHIFT:
@@ -1263,11 +1255,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 	if (fault_status != FSC_PERM && !device && kvm_has_mte(kvm)) {
-		/* Check the VMM hasn't introduced a new VM_SHARED VMA */
-		if (!shared)
-			ret = sanitise_mte_tags(kvm, pfn, vma_pagesize);
-		else
-			ret = -EFAULT;
+		ret = sanitise_mte_tags(kvm, pfn, vma_pagesize);
 		if (ret)
 			goto out_unlock;
 	}
@@ -1705,16 +1693,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		if (!vma)
 			break;
 
-		/*
-		 * VM_SHARED mappings are not allowed with MTE to avoid races
-		 * when updating the PG_mte_tagged page flag, see
-		 * sanitise_mte_tags for more details.
-		 */
-		if (kvm_has_mte(kvm) && vma->vm_flags & VM_SHARED) {
-			ret = -EINVAL;
-			break;
-		}
-
 		if (vma->vm_flags & VM_PFNMAP) {
 			/* IO region dirty page logging not allowed */
 			if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index e66f7aa3191d..447cdd4b1311 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -134,6 +134,7 @@ enum pageflags {
 #endif
 #ifdef CONFIG_64BIT
 	PG_arch_2,
+	PG_arch_3,
 #endif
 #ifdef CONFIG_KASAN_HW_TAGS
 	PG_skip_kasan_poison,
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index e87cb2b80ed3..ecf7ae0de3d8 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -92,9 +92,9 @@
 #endif
 
 #ifdef CONFIG_64BIT
-#define IF_HAVE_PG_ARCH_2(flag,string) ,{1UL << flag, string}
+#define IF_HAVE_PG_ARCH_2_3(flag,string) ,{1UL << flag, string}
 #else
-#define IF_HAVE_PG_ARCH_2(flag,string)
+#define IF_HAVE_PG_ARCH_2_3(flag,string)
 #endif
 
 #ifdef CONFIG_KASAN_HW_TAGS
@@ -130,7 +130,8 @@ IF_HAVE_PG_UNCACHED(PG_uncached,	"uncached"	)		\
 IF_HAVE_PG_HWPOISON(PG_hwpoison,	"hwpoison"	)		\
 IF_HAVE_PG_IDLE(PG_young,		"young"		)		\
 IF_HAVE_PG_IDLE(PG_idle,		"idle"		)		\
-IF_HAVE_PG_ARCH_2(PG_arch_2,		"arch_2"	)		\
+IF_HAVE_PG_ARCH_2_3(PG_arch_2,		"arch_2"	)		\
+IF_HAVE_PG_ARCH_2_3(PG_arch_3,		"arch_3"	)		\
 IF_HAVE_PG_SKIP_KASAN_POISON(PG_skip_kasan_poison, "skip_kasan_poison")
 
 #define show_page_flags(flags)						\
-- 
2.37.0.rc0.104.g0611611a94-goog

