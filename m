Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A37F09C93F
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729463AbfHZGVn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:21:43 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42156 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729710AbfHZGVn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:21:43 -0400
Received: by mail-pl1-f194.google.com with SMTP id y1so9465415plp.9;
        Sun, 25 Aug 2019 23:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/xZAip2zW6i9NMm+py6AQ68uiNbiHqbMvTdwtHXWeus=;
        b=lLTrZhB9PI5ge2nVyCfUbGvge0U/43rU7JXgXepEj1xP1mM+4QIOP9a+NuUi/NQD8Y
         VlmaRyn8ODq4ZE0kLl9+0g63FFW36lji6BSmZHpAitaou1xL+GKEaMJNgMsGPnepooGA
         b0rUYcqx3E1R48PsMewlu9+4AtVdy9/nAz6+l55cTKEJOk02UPUDk9yHnDJ8IehwPdUa
         bFJ9ilrQ/I5ZPcxrvQ0RXnL8MD3putKofXOP/WKfBn/2QfStx9o91clO6b0AEWCY7YBo
         VAM4DG1IA5hROR9vwgSNQs+q6Ip6boRNONRUGMVPAgVAl+/eMOdvb+7DqcTUgGYtse/C
         HmCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/xZAip2zW6i9NMm+py6AQ68uiNbiHqbMvTdwtHXWeus=;
        b=A4jMnjC6sOXU8YDP9/BMsX/NxWO0Lk7psc2YnJw+stwDXXNkdsTsNEbQv7bGmCUJ8+
         Eo445MpVrYussluQI15GihI1axOtBqaziSfJlrix8xkRgNBAylG7jnjSYoNRH6C9i6e6
         PC5XttSCa5U75zUDyAsMzonrHSR6nLIXxs9W7ElNlbhZvQg20NLWO4HJSnEqMHgvVmYE
         y1NpEF+AlRxx4z1d5bz33xinQ2h4L/BpcH9GvCp9fjjQ0uZh5o+LmkT4PuTkRFibmJ9u
         SEx5OhdRVmGgCAIUVUQVGGGe6NMzTXejNsZLIVsfZXqRkeouuLjF09/RgJCFyJ1UlYtb
         akHg==
X-Gm-Message-State: APjAAAXp/ZrIjHSsuvGkslU4CWRQ1uQQIFNn0IbMPdWzvBNc9GjJPBes
        dPuN8tPHbd49mygMCq4mHSFZTpBsrEg=
X-Google-Smtp-Source: APXvYqzWsd+vvHmDuQ7RtujVMR9fGkWE4uCRVpENxcbKqpGAo40BRpWVzyrV42dk52GBkoVPZNwStg==
X-Received: by 2002:a17:902:6546:: with SMTP id d6mr16972952pln.338.1566800502525;
        Sun, 25 Aug 2019 23:21:42 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id f7sm10030353pfd.43.2019.08.25.23.21.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 25 Aug 2019 23:21:42 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH 11/23] KVM: PPC: Book3S HV: Nested: Remove single nest rmap entries
Date:   Mon, 26 Aug 2019 16:20:57 +1000
Message-Id: <20190826062109.7573-12-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190826062109.7573-1-sjitindarsingh@gmail.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The nested rmap entries are used to track nested pages which map a given
guest page such that that information can be retrieved from the guest
memslot. These entries are stored in the guest memslot as a singly
linked list (llist) with the next pointer of the last entry in the list
used to store a "single entry" to save having to add another list entry.

This approach while saving a small amount of memory significantly
complicates the list handling. For simplicity and code clarity remove
the existence of these "single entries" and always insert another list
entry to hold the final value.

No functional change.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/include/asm/kvm_book3s_64.h | 65 ++++++++++----------------------
 arch/powerpc/kvm/book3s_hv_nested.c      | 51 ++++++++++---------------
 2 files changed, 39 insertions(+), 77 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index ef6af64a4451..410e609efd37 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -48,66 +48,39 @@ struct kvm_nested_guest {
 };
 
 /*
+ * We use nested rmap entries to store information so that we can find pte
+ * entries in the shadow page table of a nested guest when the host is modifying
+ * a pte for a l1 guest page. For a radix nested guest this is the nested
+ * gpa which can then be used to walk the radix shadow page table to find a
+ * pte. For a hash nested guest this is an index into the shadow hpt which can
+ * be used to find a pte. Irrespective the lpid of the nested guest is stored.
+ *
+ * These entries are stored in a rmap_nested struct. There may be multiple
+ * entries for a single l1 guest page since that guest may have multiple nested
+ * guests and map the same page into more than 1, or a single nested guest may
+ * map the same l1 guest page with multiple hpt entries. To accommodate this
+ * the rmap_nested entries are linked together in a singly linked list with the
+ * corresponding rmap entry in the rmap array of the memslot containing the
+ * head pointer of the linked list (or NULL if list is empty).
+ */
+
+/*
  * We define a nested rmap entry as a single 64-bit quantity
  * 0xFFF0000000000000	12-bit lpid field
  * 0x000FFFFFFFFFFFC0	46-bit guest page frame number (radix) or hpt index
- * 0x0000000000000001	1-bit  single entry flag
+ * 0x000000000000003F	6-bit unused field
  */
 #define RMAP_NESTED_LPID_MASK		0xFFF0000000000000UL
 #define RMAP_NESTED_LPID_SHIFT		(52)
 #define RMAP_NESTED_GPA_MASK		0x000FFFFFFFFFFFC0UL
 #define RMAP_NESTED_GPA_SHIFT		(6)
-#define RMAP_NESTED_IS_SINGLE_ENTRY	0x0000000000000001UL
 
 /* Structure for a nested guest rmap entry */
 struct rmap_nested {
 	struct llist_node list;
-	u64 rmap;
+	u64 rmap;			/* layout defined above */
 };
 
-/*
- * for_each_nest_rmap_safe - iterate over the list of nested rmap entries
- *			     safe against removal of the list entry or NULL list
- * @pos:	a (struct rmap_nested *) to use as a loop cursor
- * @node:	pointer to the first entry
- *		NOTE: this can be NULL
- * @rmapp:	an (unsigned long *) in which to return the rmap entries on each
- *		iteration
- *		NOTE: this must point to already allocated memory
- *
- * The nested_rmap is a llist of (struct rmap_nested) entries pointed to by the
- * rmap entry in the memslot. The list is always terminated by a "single entry"
- * stored in the list element of the final entry of the llist. If there is ONLY
- * a single entry then this is itself in the rmap entry of the memslot, not a
- * llist head pointer.
- *
- * Note that the iterator below assumes that a nested rmap entry is always
- * non-zero.  This is true for our usage because the LPID field is always
- * non-zero (zero is reserved for the host).
- *
- * This should be used to iterate over the list of rmap_nested entries with
- * processing done on the u64 rmap value given by each iteration. This is safe
- * against removal of list entries and it is always safe to call free on (pos).
- *
- * e.g.
- * struct rmap_nested *cursor;
- * struct llist_node *first;
- * unsigned long rmap;
- * for_each_nest_rmap_safe(cursor, first, &rmap) {
- *	do_something(rmap);
- *	free(cursor);
- * }
- */
-#define for_each_nest_rmap_safe(pos, node, rmapp)			       \
-	for ((pos) = llist_entry((node), typeof(*(pos)), list);		       \
-	     (node) &&							       \
-	     (*(rmapp) = ((RMAP_NESTED_IS_SINGLE_ENTRY & ((u64) (node))) ?     \
-			  ((u64) (node)) : ((pos)->rmap))) &&		       \
-	     (((node) = ((RMAP_NESTED_IS_SINGLE_ENTRY & ((u64) (node))) ?      \
-			 ((struct llist_node *) ((pos) = NULL)) :	       \
-			 (pos)->list.next)), true);			       \
-	     (pos) = llist_entry((node), typeof(*(pos)), list))
-
 struct kvm_nested_guest *kvmhv_get_nested(struct kvm *kvm, int l1_lpid,
 					  bool create);
 void kvmhv_put_nested(struct kvm_nested_guest *gp);
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index c6304aa949c1..c76e499437ee 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -800,31 +800,20 @@ static inline bool kvmhv_n_rmap_is_equal(u64 rmap_1, u64 rmap_2, u64 mask)
 /* called with kvm->mmu_lock held */
 void kvmhv_insert_nest_rmap(unsigned long *rmapp, struct rmap_nested **n_rmap)
 {
-	struct llist_node *entry = ((struct llist_head *) rmapp)->first;
+	struct llist_head *head = (struct llist_head *) rmapp;
 	struct rmap_nested *cursor;
-	u64 rmap, new_rmap = (*n_rmap)->rmap;
+	u64 new_rmap = (*n_rmap)->rmap;
 
-	/* Are there any existing entries? */
-	if (!(*rmapp)) {
-		/* No -> use the rmap as a single entry */
-		*rmapp = new_rmap | RMAP_NESTED_IS_SINGLE_ENTRY;
-		return;
-	}
-
-	/* Do any entries match what we're trying to insert? */
-	for_each_nest_rmap_safe(cursor, entry, &rmap) {
-		if (kvmhv_n_rmap_is_equal(rmap, new_rmap, RMAP_NESTED_LPID_MASK
-							| RMAP_NESTED_GPA_MASK))
+	/* Do any existing entries match what we're trying to insert? */
+	llist_for_each_entry(cursor, head->first, list) {
+		if (kvmhv_n_rmap_is_equal(cursor->rmap, new_rmap,
+					  RMAP_NESTED_LPID_MASK |
+					  RMAP_NESTED_GPA_MASK))
 			return;
 	}
 
-	/* Do we need to create a list or just add the new entry? */
-	rmap = *rmapp;
-	if (rmap & RMAP_NESTED_IS_SINGLE_ENTRY) /* Not previously a list */
-		*rmapp = 0UL;
-	llist_add(&((*n_rmap)->list), (struct llist_head *) rmapp);
-	if (rmap & RMAP_NESTED_IS_SINGLE_ENTRY) /* Not previously a list */
-		(*n_rmap)->list.next = (struct llist_node *) rmap;
+	/* Insert the new entry */
+	llist_add(&((*n_rmap)->list), head);
 
 	/* Set NULL so not freed by caller */
 	*n_rmap = NULL;
@@ -874,9 +863,9 @@ void kvmhv_update_nest_rmap_rc_list(struct kvm *kvm, unsigned long *rmapp,
 				    unsigned long clr, unsigned long set,
 				    unsigned long hpa, unsigned long nbytes)
 {
-	struct llist_node *entry = ((struct llist_head *) rmapp)->first;
+	struct llist_head *head = (struct llist_head *) rmapp;
 	struct rmap_nested *cursor;
-	unsigned long rmap, mask;
+	unsigned long mask;
 
 	if ((clr | set) & ~(_PAGE_DIRTY | _PAGE_ACCESSED))
 		return;
@@ -884,8 +873,9 @@ void kvmhv_update_nest_rmap_rc_list(struct kvm *kvm, unsigned long *rmapp,
 	mask = PTE_RPN_MASK & ~(nbytes - 1);
 	hpa &= mask;
 
-	for_each_nest_rmap_safe(cursor, entry, &rmap)
-		kvmhv_update_nest_rmap_rc(kvm, rmap, clr, set, hpa, mask);
+	llist_for_each_entry(cursor, head->first, list)
+		kvmhv_update_nest_rmap_rc(kvm, cursor->rmap, clr, set, hpa,
+					  mask);
 }
 
 /*
@@ -924,11 +914,10 @@ static void kvmhv_invalidate_nest_rmap_list(struct kvm *kvm,
 					    unsigned long mask)
 {
 	struct llist_node *entry = llist_del_all((struct llist_head *) rmapp);
-	struct rmap_nested *cursor;
-	unsigned long rmap;
+	struct rmap_nested *cursor, *next;
 
-	for_each_nest_rmap_safe(cursor, entry, &rmap) {
-		kvmhv_invalidate_nest_rmap(kvm, rmap, hpa, mask);
+	llist_for_each_entry_safe(cursor, next, entry, list) {
+		kvmhv_invalidate_nest_rmap(kvm, cursor->rmap, hpa, mask);
 		kfree(cursor);
 	}
 }
@@ -966,12 +955,12 @@ static void kvmhv_free_memslot_nest_rmap(struct kvm_memory_slot *free)
 	unsigned long page;
 
 	for (page = 0; page < free->npages; page++) {
-		unsigned long rmap, *rmapp = &free->arch.rmap[page];
-		struct rmap_nested *cursor;
+		unsigned long *rmapp = &free->arch.rmap[page];
+		struct rmap_nested *cursor, *next;
 		struct llist_node *entry;
 
 		entry = llist_del_all((struct llist_head *) rmapp);
-		for_each_nest_rmap_safe(cursor, entry, &rmap)
+		llist_for_each_entry_safe(cursor, next, entry, list)
 			kfree(cursor);
 	}
 }
-- 
2.13.6

