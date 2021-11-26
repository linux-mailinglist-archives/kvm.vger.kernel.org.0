Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFDAB45E3B7
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 01:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357284AbhKZAgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 19:36:53 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:55300 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235709AbhKZAev (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 19:34:51 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mqP9H-0007HP-9z; Fri, 26 Nov 2021 01:31:31 +0100
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: Make kvm_for_each_memslot_in_gfn_range() strict and use iterators
Date:   Fri, 26 Nov 2021 01:31:09 +0100
Message-Id: <4e6962905b2fc003acabf8bbee3a0ec1d634966c.1637884349.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1637884349.git.maciej.szmigiero@oracle.com>
References: <cover.1637884349.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

Make kvm_for_each_memslot_in_gfn_range() return only memslots at least
partially intersecting the requested range.
At the same time modify its implementation to use iterators.

This simplifies kvm_check_memslot_overlap() a bit.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/x86/kvm/mmu/mmu.c   |  11 ++---
 include/linux/kvm_host.h | 104 +++++++++++++++++++++++++--------------
 virt/kvm/kvm_main.c      |  17 ++-----
 3 files changed, 75 insertions(+), 57 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8f0035517450..009eb27d34d3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5715,23 +5715,22 @@ static bool __kvm_zap_rmaps(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 {
 	const struct kvm_memory_slot *memslot;
 	struct kvm_memslots *slots;
-	struct rb_node *node;
+	struct kvm_memslot_iter iter;
 	bool flush = false;
 	gfn_t start, end;
-	int i, idx;
+	int i;
 
 	if (!kvm_memslots_have_rmaps(kvm))
 		return flush;
 
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		slots = __kvm_memslots(kvm, i);
-		idx = slots->node_idx;
 
-		kvm_for_each_memslot_in_gfn_range(node, slots, gfn_start, gfn_end) {
-			memslot = container_of(node, struct kvm_memory_slot, gfn_node[idx]);
+		kvm_for_each_memslot_in_gfn_range(&iter, slots, gfn_start, gfn_end) {
+			memslot = kvm_memslot_iter_slot(&iter);
 			start = max(gfn_start, memslot->base_gfn);
 			end = min(gfn_end, memslot->base_gfn + memslot->npages);
-			if (start >= end)
+			if (WARN_ON_ONCE(start >= end))
 				continue;
 
 			flush = slot_handle_level_range(kvm, memslot, kvm_zap_rmapp,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3932bb091099..580d9abd97c1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -841,74 +841,104 @@ struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
 	return NULL;
 }
 
-static inline
-struct rb_node *kvm_memslots_gfn_upper_bound(struct kvm_memslots *slots, gfn_t gfn)
+/* Iterator used for walking memslots that overlap a gfn range. */
+struct kvm_memslot_iter {
+	struct kvm_memslots *slots;
+	gfn_t end;
+	struct rb_node *node;
+};
+
+static inline void kvm_memslot_iter_start(struct kvm_memslot_iter *iter,
+					  struct kvm_memslots *slots,
+					  gfn_t start, gfn_t end)
 {
 	int idx = slots->node_idx;
-	struct rb_node *node, *result = NULL;
+	struct rb_node *tmp;
+	struct kvm_memory_slot *slot;
 
-	for (node = slots->gfn_tree.rb_node; node; ) {
-		struct kvm_memory_slot *slot;
+	iter->slots = slots;
+	iter->end = end;
 
-		slot = container_of(node, struct kvm_memory_slot, gfn_node[idx]);
-		if (gfn < slot->base_gfn) {
-			result = node;
-			node = node->rb_left;
-		} else
-			node = node->rb_right;
+	/*
+	 * Find the so called "upper bound" of a key - the first node that has
+	 * its key strictly greater than the searched one (the start gfn in our case).
+	 */
+	iter->node = NULL;
+	for (tmp = slots->gfn_tree.rb_node; tmp; ) {
+		slot = container_of(tmp, struct kvm_memory_slot, gfn_node[idx]);
+		if (start < slot->base_gfn) {
+			iter->node = tmp;
+			tmp = tmp->rb_left;
+		} else {
+			tmp = tmp->rb_right;
+		}
 	}
 
-	return result;
-}
-
-static inline
-struct rb_node *kvm_for_each_in_gfn_first(struct kvm_memslots *slots, gfn_t start)
-{
-	struct rb_node *node;
-
 	/*
 	 * Find the slot with the lowest gfn that can possibly intersect with
 	 * the range, so we'll ideally have slot start <= range start
 	 */
-	node = kvm_memslots_gfn_upper_bound(slots, start);
-	if (node) {
-		struct rb_node *pnode;
-
+	if (iter->node) {
 		/*
 		 * A NULL previous node means that the very first slot
 		 * already has a higher start gfn.
 		 * In this case slot start > range start.
 		 */
-		pnode = rb_prev(node);
-		if (pnode)
-			node = pnode;
+		tmp = rb_prev(iter->node);
+		if (tmp)
+			iter->node = tmp;
 	} else {
 		/* a NULL node below means no slots */
-		node = rb_last(&slots->gfn_tree);
+		iter->node = rb_last(&slots->gfn_tree);
 	}
 
-	return node;
+	if (iter->node) {
+		/*
+		 * It is possible in the slot start < range start case that the
+		 * found slot ends before or at range start (slot end <= range start)
+		 * and so it does not overlap the requested range.
+		 *
+		 * In such non-overlapping case the next slot (if it exists) will
+		 * already have slot start > range start, otherwise the logic above
+		 * would have found it instead of the current slot.
+		 */
+		slot = container_of(iter->node, struct kvm_memory_slot, gfn_node[idx]);
+		if (slot->base_gfn + slot->npages <= start)
+			iter->node = rb_next(iter->node);
+	}
 }
 
-static inline
-bool kvm_for_each_in_gfn_no_more(struct kvm_memslots *slots, struct rb_node *node, gfn_t end)
+static inline struct kvm_memory_slot *kvm_memslot_iter_slot(struct kvm_memslot_iter *iter)
+{
+	return container_of(iter->node, struct kvm_memory_slot, gfn_node[iter->slots->node_idx]);
+}
+
+static inline bool kvm_memslot_iter_is_valid(struct kvm_memslot_iter *iter)
 {
 	struct kvm_memory_slot *memslot;
 
-	memslot = container_of(node, struct kvm_memory_slot, gfn_node[slots->node_idx]);
+	if (!iter->node)
+		return false;
+
+	memslot = kvm_memslot_iter_slot(iter);
 
 	/*
 	 * If this slot starts beyond or at the end of the range so does
 	 * every next one
 	 */
-	return memslot->base_gfn >= end;
+	return memslot->base_gfn < iter->end;
+}
+
+static inline void kvm_memslot_iter_next(struct kvm_memslot_iter *iter)
+{
+	iter->node = rb_next(iter->node);
 }
 
-/* Iterate over each memslot *possibly* intersecting [start, end) range */
-#define kvm_for_each_memslot_in_gfn_range(node, slots, start, end)	\
-	for (node = kvm_for_each_in_gfn_first(slots, start);		\
-	     node && !kvm_for_each_in_gfn_no_more(slots, node, end);	\
-	     node = rb_next(node))					\
+/* Iterate over each memslot at least partially intersecting [start, end) range */
+#define kvm_for_each_memslot_in_gfn_range(iter, slots, start, end)	 \
+	for (kvm_memslot_iter_start(iter, slots, start, end);		 \
+	     kvm_memslot_iter_is_valid(iter);				 \
+	     kvm_memslot_iter_next(iter))
 
 /*
  * KVM_SET_USER_MEMORY_REGION ioctl allows the following operations:
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 367c1cba26d2..d6503b92b3cf 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1797,22 +1797,11 @@ static int kvm_set_memslot(struct kvm *kvm,
 static bool kvm_check_memslot_overlap(struct kvm_memslots *slots, int id,
 				      gfn_t start, gfn_t end)
 {
-	int idx = slots->node_idx;
-	struct rb_node *node;
-
-	kvm_for_each_memslot_in_gfn_range(node, slots, start, end) {
-		struct kvm_memory_slot *cslot;
-		gfn_t cend;
+	struct kvm_memslot_iter iter;
 
-		cslot = container_of(node, struct kvm_memory_slot, gfn_node[idx]);
-		cend = cslot->base_gfn + cslot->npages;
-		if (cslot->id == id)
-			continue;
-
-		/* kvm_for_each_in_gfn_no_more() guarantees that cslot->base_gfn < nend */
-		if (cend > start)
+	kvm_for_each_memslot_in_gfn_range(&iter, slots, start, end)
+		if (kvm_memslot_iter_slot(&iter)->id != id)
 			return true;
-	}
 
 	return false;
 }
