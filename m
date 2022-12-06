Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC19644A5A
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 18:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235363AbiLFRgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 12:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235259AbiLFRgJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 12:36:09 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C1A37F93
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 09:36:07 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id z1-20020a17090a66c100b002196a0895a6so13677235pjl.5
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 09:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EexaDR+ZUMOeyHekBnbhmko3+9Xc1K29meG6UCLtOrc=;
        b=h+zaYT9end89tIo9b2PVWNxFrVHzi+Iim+OouFjtvn2sBZEdZu0z4TsPxoZaO27dOJ
         p5rvD7S2+MUVgtauzWvUtd8OEbeS05jWjro8t99zLHM1rJs2l0OvfcDkrG76OPUECgjA
         zJRDQIAXpk6lQy7W3HdN9RTXYen3QoVCz//rHnev2iMgv7itjFppiRrY8QewM+REbgND
         xc5QRxhfvR0/nJs8vXhcd1+1yAR54THKwSx2HtQGLKK385JZXgvgfR9wV7+QQtbv8qMR
         1JEqPxBj3gZDK5UWCw1XhUMgoJb303nVQy49bINx+QxxtHhnuXEA1/4JJb6GrZgt+lLL
         RIfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EexaDR+ZUMOeyHekBnbhmko3+9Xc1K29meG6UCLtOrc=;
        b=GZN/bg0camBH4BONzlCTkPrYndd9ukmDSm3pwB3Idc4c4UVVmkBodI2zz3iVdEWd1r
         tvKbrsIV92wWNETeDR+Duw2em0NypwVw033TziVWqBfPn/3httQB6nG7I3kSsVrV5or4
         VtWLubi1M91Y3zfK++2F0GEUk3te/M4n3rC/tp1vswyD1/LKA0FnAr3340jwnn/gl3uq
         GNPhikE99wqnxDRSQhMgioamBTZT7P522ezrLqiimJtoU2xl3H3EP0npHVmRIt4/betP
         Lm2tgt9qjJdHwH8xsxgFI1pmx36Sn7P/ZvFui2hBUanh9Lexhu3Pi73pwVgISsh/v7rR
         ppUQ==
X-Gm-Message-State: ANoB5pmER3XR1ItDoygypjM8fIFvBOdZOadzv0PzNiQzRSxSuneAKB8A
        h7QedsTNT+fC+8K3NWbzhOF1FZeH9sGq
X-Google-Smtp-Source: AA0mqf5M3cker1iBSFrDHcbA7eaCcZjIXVNYlpw6/d4VHns8SW/q7qZqaIOhrX5owyF4SPbITG46zwD7NB7u
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:90a:d086:b0:219:227d:d91f with SMTP id
 k6-20020a17090ad08600b00219227dd91fmr4993173pju.0.1670348167215; Tue, 06 Dec
 2022 09:36:07 -0800 (PST)
Date:   Tue,  6 Dec 2022 17:35:55 +0000
In-Reply-To: <20221206173601.549281-1-bgardon@google.com>
Mime-Version: 1.0
References: <20221206173601.549281-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221206173601.549281-2-bgardon@google.com>
Subject: [PATCH 1/7] KVM: x86/MMU: Move pte_list operations to rmap.c
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ben Gardon <bgardon@google.com>
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

In the interest of eventually splitting the Shadow MMU out of mmu.c,
start by moving some of the operations for manipulating pte_lists out of
mmu.c and into a new pair of files: rmap.c and rmap.h.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/Makefile           |   2 +-
 arch/x86/kvm/debugfs.c          |   1 +
 arch/x86/kvm/mmu/mmu.c          | 152 +-------------------------------
 arch/x86/kvm/mmu/mmu_internal.h |   1 -
 arch/x86/kvm/mmu/rmap.c         | 141 +++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/rmap.h         |  34 +++++++
 6 files changed, 179 insertions(+), 152 deletions(-)
 create mode 100644 arch/x86/kvm/mmu/rmap.c
 create mode 100644 arch/x86/kvm/mmu/rmap.h

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 80e3fe184d17..9f766eebeddf 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -12,7 +12,7 @@ include $(srctree)/virt/kvm/Makefile.kvm
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
 			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o \
-			   mmu/spte.o
+			   mmu/spte.o mmu/rmap.o
 
 ifdef CONFIG_HYPERV
 kvm-y			+= kvm_onhyperv.o
diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index c1390357126a..29f692ecd6f3 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -9,6 +9,7 @@
 #include "lapic.h"
 #include "mmu.h"
 #include "mmu/mmu_internal.h"
+#include "mmu/rmap.h"
 
 static int vcpu_get_timer_advance_ns(void *data, u64 *val)
 {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4736d7849c60..90b3735d6064 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -26,6 +26,7 @@
 #include "kvm_emulate.h"
 #include "cpuid.h"
 #include "spte.h"
+#include "rmap.h"
 
 #include <linux/kvm_host.h>
 #include <linux/types.h>
@@ -112,24 +113,6 @@ module_param(dbg, bool, 0644);
 
 #include <trace/events/kvm.h>
 
-/* make pte_list_desc fit well in cache lines */
-#define PTE_LIST_EXT 14
-
-/*
- * Slight optimization of cacheline layout, by putting `more' and `spte_count'
- * at the start; then accessing it will only use one single cacheline for
- * either full (entries==PTE_LIST_EXT) case or entries<=6.
- */
-struct pte_list_desc {
-	struct pte_list_desc *more;
-	/*
-	 * Stores number of entries stored in the pte_list_desc.  No need to be
-	 * u64 but just for easier alignment.  When PTE_LIST_EXT, means full.
-	 */
-	u64 spte_count;
-	u64 *sptes[PTE_LIST_EXT];
-};
-
 struct kvm_shadow_walk_iterator {
 	u64 addr;
 	hpa_t shadow_addr;
@@ -155,7 +138,6 @@ struct kvm_shadow_walk_iterator {
 		({ spte = mmu_spte_get_lockless(_walker.sptep); 1; });	\
 	     __shadow_walk_next(&(_walker), spte))
 
-static struct kmem_cache *pte_list_desc_cache;
 struct kmem_cache *mmu_page_header_cache;
 static struct percpu_counter kvm_total_used_mmu_pages;
 
@@ -674,11 +656,6 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
-static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
-{
-	kmem_cache_free(pte_list_desc_cache, pte_list_desc);
-}
-
 static bool sp_has_gptes(struct kvm_mmu_page *sp);
 
 static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
@@ -878,111 +855,6 @@ gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return slot;
 }
 
-/*
- * About rmap_head encoding:
- *
- * If the bit zero of rmap_head->val is clear, then it points to the only spte
- * in this rmap chain. Otherwise, (rmap_head->val & ~1) points to a struct
- * pte_list_desc containing more mappings.
- */
-
-/*
- * Returns the number of pointers in the rmap chain, not counting the new one.
- */
-static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
-			struct kvm_rmap_head *rmap_head)
-{
-	struct pte_list_desc *desc;
-	int count = 0;
-
-	if (!rmap_head->val) {
-		rmap_printk("%p %llx 0->1\n", spte, *spte);
-		rmap_head->val = (unsigned long)spte;
-	} else if (!(rmap_head->val & 1)) {
-		rmap_printk("%p %llx 1->many\n", spte, *spte);
-		desc = kvm_mmu_memory_cache_alloc(cache);
-		desc->sptes[0] = (u64 *)rmap_head->val;
-		desc->sptes[1] = spte;
-		desc->spte_count = 2;
-		rmap_head->val = (unsigned long)desc | 1;
-		++count;
-	} else {
-		rmap_printk("%p %llx many->many\n", spte, *spte);
-		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
-		while (desc->spte_count == PTE_LIST_EXT) {
-			count += PTE_LIST_EXT;
-			if (!desc->more) {
-				desc->more = kvm_mmu_memory_cache_alloc(cache);
-				desc = desc->more;
-				desc->spte_count = 0;
-				break;
-			}
-			desc = desc->more;
-		}
-		count += desc->spte_count;
-		desc->sptes[desc->spte_count++] = spte;
-	}
-	return count;
-}
-
-static void
-pte_list_desc_remove_entry(struct kvm_rmap_head *rmap_head,
-			   struct pte_list_desc *desc, int i,
-			   struct pte_list_desc *prev_desc)
-{
-	int j = desc->spte_count - 1;
-
-	desc->sptes[i] = desc->sptes[j];
-	desc->sptes[j] = NULL;
-	desc->spte_count--;
-	if (desc->spte_count)
-		return;
-	if (!prev_desc && !desc->more)
-		rmap_head->val = 0;
-	else
-		if (prev_desc)
-			prev_desc->more = desc->more;
-		else
-			rmap_head->val = (unsigned long)desc->more | 1;
-	mmu_free_pte_list_desc(desc);
-}
-
-static void pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
-{
-	struct pte_list_desc *desc;
-	struct pte_list_desc *prev_desc;
-	int i;
-
-	if (!rmap_head->val) {
-		pr_err("%s: %p 0->BUG\n", __func__, spte);
-		BUG();
-	} else if (!(rmap_head->val & 1)) {
-		rmap_printk("%p 1->0\n", spte);
-		if ((u64 *)rmap_head->val != spte) {
-			pr_err("%s:  %p 1->BUG\n", __func__, spte);
-			BUG();
-		}
-		rmap_head->val = 0;
-	} else {
-		rmap_printk("%p many->many\n", spte);
-		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
-		prev_desc = NULL;
-		while (desc) {
-			for (i = 0; i < desc->spte_count; ++i) {
-				if (desc->sptes[i] == spte) {
-					pte_list_desc_remove_entry(rmap_head,
-							desc, i, prev_desc);
-					return;
-				}
-			}
-			prev_desc = desc;
-			desc = desc->more;
-		}
-		pr_err("%s: %p many->many\n", __func__, spte);
-		BUG();
-	}
-}
-
 static void kvm_zap_one_rmap_spte(struct kvm *kvm,
 				  struct kvm_rmap_head *rmap_head, u64 *sptep)
 {
@@ -1011,7 +883,7 @@ static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
 		for (i = 0; i < desc->spte_count; i++)
 			mmu_spte_clear_track_bits(kvm, desc->sptes[i]);
 		next = desc->more;
-		mmu_free_pte_list_desc(desc);
+		free_pte_list_desc(desc);
 	}
 out:
 	/* rmap_head is meaningless now, remember to reset it */
@@ -1019,26 +891,6 @@ static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
 	return true;
 }
 
-unsigned int pte_list_count(struct kvm_rmap_head *rmap_head)
-{
-	struct pte_list_desc *desc;
-	unsigned int count = 0;
-
-	if (!rmap_head->val)
-		return 0;
-	else if (!(rmap_head->val & 1))
-		return 1;
-
-	desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
-
-	while (desc) {
-		count += desc->spte_count;
-		desc = desc->more;
-	}
-
-	return count;
-}
-
 static struct kvm_rmap_head *gfn_to_rmap(gfn_t gfn, int level,
 					 const struct kvm_memory_slot *slot)
 {
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index dbaf6755c5a7..cd1c8f32269d 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -166,7 +166,6 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    int min_level);
 void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 					u64 start_gfn, u64 pages);
-unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
 
 extern int nx_huge_pages;
 static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
diff --git a/arch/x86/kvm/mmu/rmap.c b/arch/x86/kvm/mmu/rmap.c
new file mode 100644
index 000000000000..daa99dee0709
--- /dev/null
+++ b/arch/x86/kvm/mmu/rmap.c
@@ -0,0 +1,141 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "mmu.h"
+#include "mmu_internal.h"
+#include "mmutrace.h"
+#include "rmap.h"
+#include "spte.h"
+
+#include <asm/cmpxchg.h>
+#include <trace/events/kvm.h>
+
+/*
+ * About rmap_head encoding:
+ *
+ * If the bit zero of rmap_head->val is clear, then it points to the only spte
+ * in this rmap chain. Otherwise, (rmap_head->val & ~1) points to a struct
+ * pte_list_desc containing more mappings.
+ */
+
+/*
+ * Returns the number of pointers in the rmap chain, not counting the new one.
+ */
+int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
+		 struct kvm_rmap_head *rmap_head)
+{
+	struct pte_list_desc *desc;
+	int count = 0;
+
+	if (!rmap_head->val) {
+		rmap_printk("%p %llx 0->1\n", spte, *spte);
+		rmap_head->val = (unsigned long)spte;
+	} else if (!(rmap_head->val & 1)) {
+		rmap_printk("%p %llx 1->many\n", spte, *spte);
+		desc = kvm_mmu_memory_cache_alloc(cache);
+		desc->sptes[0] = (u64 *)rmap_head->val;
+		desc->sptes[1] = spte;
+		desc->spte_count = 2;
+		rmap_head->val = (unsigned long)desc | 1;
+		++count;
+	} else {
+		rmap_printk("%p %llx many->many\n", spte, *spte);
+		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
+		while (desc->spte_count == PTE_LIST_EXT) {
+			count += PTE_LIST_EXT;
+			if (!desc->more) {
+				desc->more = kvm_mmu_memory_cache_alloc(cache);
+				desc = desc->more;
+				desc->spte_count = 0;
+				break;
+			}
+			desc = desc->more;
+		}
+		count += desc->spte_count;
+		desc->sptes[desc->spte_count++] = spte;
+	}
+	return count;
+}
+
+void free_pte_list_desc(struct pte_list_desc *pte_list_desc)
+{
+	kmem_cache_free(pte_list_desc_cache, pte_list_desc);
+}
+
+static void
+pte_list_desc_remove_entry(struct kvm_rmap_head *rmap_head,
+			   struct pte_list_desc *desc, int i,
+			   struct pte_list_desc *prev_desc)
+{
+	int j = desc->spte_count - 1;
+
+	desc->sptes[i] = desc->sptes[j];
+	desc->sptes[j] = NULL;
+	desc->spte_count--;
+	if (desc->spte_count)
+		return;
+	if (!prev_desc && !desc->more)
+		rmap_head->val = 0;
+	else
+		if (prev_desc)
+			prev_desc->more = desc->more;
+		else
+			rmap_head->val = (unsigned long)desc->more | 1;
+	free_pte_list_desc(desc);
+}
+
+void pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
+{
+	struct pte_list_desc *desc;
+	struct pte_list_desc *prev_desc;
+	int i;
+
+	if (!rmap_head->val) {
+		pr_err("%s: %p 0->BUG\n", __func__, spte);
+		BUG();
+	} else if (!(rmap_head->val & 1)) {
+		rmap_printk("%p 1->0\n", spte);
+		if ((u64 *)rmap_head->val != spte) {
+			pr_err("%s:  %p 1->BUG\n", __func__, spte);
+			BUG();
+		}
+		rmap_head->val = 0;
+	} else {
+		rmap_printk("%p many->many\n", spte);
+		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
+		prev_desc = NULL;
+		while (desc) {
+			for (i = 0; i < desc->spte_count; ++i) {
+				if (desc->sptes[i] == spte) {
+					pte_list_desc_remove_entry(rmap_head,
+							desc, i, prev_desc);
+					return;
+				}
+			}
+			prev_desc = desc;
+			desc = desc->more;
+		}
+		pr_err("%s: %p many->many\n", __func__, spte);
+		BUG();
+	}
+}
+
+unsigned int pte_list_count(struct kvm_rmap_head *rmap_head)
+{
+	struct pte_list_desc *desc;
+	unsigned int count = 0;
+
+	if (!rmap_head->val)
+		return 0;
+	else if (!(rmap_head->val & 1))
+		return 1;
+
+	desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
+
+	while (desc) {
+		count += desc->spte_count;
+		desc = desc->more;
+	}
+
+	return count;
+}
+
diff --git a/arch/x86/kvm/mmu/rmap.h b/arch/x86/kvm/mmu/rmap.h
new file mode 100644
index 000000000000..059765b6e066
--- /dev/null
+++ b/arch/x86/kvm/mmu/rmap.h
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#ifndef __KVM_X86_MMU_RMAP_H
+#define __KVM_X86_MMU_RMAP_H
+
+#include <linux/kvm_host.h>
+
+/* make pte_list_desc fit well in cache lines */
+#define PTE_LIST_EXT 14
+
+/*
+ * Slight optimization of cacheline layout, by putting `more' and `spte_count'
+ * at the start; then accessing it will only use one single cacheline for
+ * either full (entries==PTE_LIST_EXT) case or entries<=6.
+ */
+struct pte_list_desc {
+	struct pte_list_desc *more;
+	/*
+	 * Stores number of entries stored in the pte_list_desc.  No need to be
+	 * u64 but just for easier alignment.  When PTE_LIST_EXT, means full.
+	 */
+	u64 spte_count;
+	u64 *sptes[PTE_LIST_EXT];
+};
+
+static struct kmem_cache *pte_list_desc_cache;
+
+int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
+		 struct kvm_rmap_head *rmap_head);
+void free_pte_list_desc(struct pte_list_desc *pte_list_desc);
+void pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head);
+unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
+
+#endif /* __KVM_X86_MMU_RMAP_H */
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

