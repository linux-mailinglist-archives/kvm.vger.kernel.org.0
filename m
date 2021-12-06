Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D082946A659
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 20:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349342AbhLFUBM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 15:01:12 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:50606 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349368AbhLFUAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 15:00:52 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1muK6e-00011v-2q; Mon, 06 Dec 2021 20:57:00 +0100
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 26/29] KVM: Optimize gfn lookup in kvm_zap_gfn_range()
Date:   Mon,  6 Dec 2021 20:54:32 +0100
Message-Id: <ef242146a87a335ee93b441dcf01665cb847c902.1638817641.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1638817637.git.maciej.szmigiero@oracle.com>
References: <cover.1638817637.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

Introduce a memslots gfn upper bound operation and use it to optimize
kvm_zap_gfn_range().
This way this handler can do a quick lookup for intersecting gfns and won't
have to do a linear scan of the whole memslot set.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/x86/kvm/mmu/mmu.c   | 12 +++--
 include/linux/kvm_host.h | 94 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 103 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f5a89942f054..7be12f482ab8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5704,19 +5704,22 @@ static bool __kvm_zap_rmaps(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 {
 	const struct kvm_memory_slot *memslot;
 	struct kvm_memslots *slots;
+	struct kvm_memslot_iter iter;
 	bool flush = false;
 	gfn_t start, end;
-	int i, bkt;
+	int i;
 
 	if (!kvm_memslots_have_rmaps(kvm))
 		return flush;
 
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		slots = __kvm_memslots(kvm, i);
-		kvm_for_each_memslot(memslot, bkt, slots) {
+
+		kvm_for_each_memslot_in_gfn_range(&iter, slots, gfn_start, gfn_end) {
+			memslot = iter.slot;
 			start = max(gfn_start, memslot->base_gfn);
 			end = min(gfn_end, memslot->base_gfn + memslot->npages);
-			if (start >= end)
+			if (WARN_ON_ONCE(start >= end))
 				continue;
 
 			flush = slot_handle_level_range(kvm, memslot, kvm_zap_rmapp,
@@ -5737,6 +5740,9 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	bool flush;
 	int i;
 
+	if (WARN_ON_ONCE(gfn_end <= gfn_start))
+		return;
+
 	write_lock(&kvm->mmu_lock);
 
 	kvm_inc_notifier_count(kvm, gfn_start, gfn_end);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 41efe53cf150..f8ed799e8674 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -848,6 +848,100 @@ struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
 	return NULL;
 }
 
+/* Iterator used for walking memslots that overlap a gfn range. */
+struct kvm_memslot_iter {
+	struct kvm_memslots *slots;
+	struct rb_node *node;
+	struct kvm_memory_slot *slot;
+};
+
+static inline void kvm_memslot_iter_next(struct kvm_memslot_iter *iter)
+{
+	iter->node = rb_next(iter->node);
+	if (!iter->node)
+		return;
+
+	iter->slot = container_of(iter->node, struct kvm_memory_slot, gfn_node[iter->slots->node_idx]);
+}
+
+static inline void kvm_memslot_iter_start(struct kvm_memslot_iter *iter,
+					  struct kvm_memslots *slots,
+					  gfn_t start)
+{
+	int idx = slots->node_idx;
+	struct rb_node *tmp;
+	struct kvm_memory_slot *slot;
+
+	iter->slots = slots;
+
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
+	}
+
+	/*
+	 * Find the slot with the lowest gfn that can possibly intersect with
+	 * the range, so we'll ideally have slot start <= range start
+	 */
+	if (iter->node) {
+		/*
+		 * A NULL previous node means that the very first slot
+		 * already has a higher start gfn.
+		 * In this case slot start > range start.
+		 */
+		tmp = rb_prev(iter->node);
+		if (tmp)
+			iter->node = tmp;
+	} else {
+		/* a NULL node below means no slots */
+		iter->node = rb_last(&slots->gfn_tree);
+	}
+
+	if (iter->node) {
+		iter->slot = container_of(iter->node, struct kvm_memory_slot, gfn_node[idx]);
+
+		/*
+		 * It is possible in the slot start < range start case that the
+		 * found slot ends before or at range start (slot end <= range start)
+		 * and so it does not overlap the requested range.
+		 *
+		 * In such non-overlapping case the next slot (if it exists) will
+		 * already have slot start > range start, otherwise the logic above
+		 * would have found it instead of the current slot.
+		 */
+		if (iter->slot->base_gfn + iter->slot->npages <= start)
+			kvm_memslot_iter_next(iter);
+	}
+}
+
+static inline bool kvm_memslot_iter_is_valid(struct kvm_memslot_iter *iter, gfn_t end)
+{
+	if (!iter->node)
+		return false;
+
+	/*
+	 * If this slot starts beyond or at the end of the range so does
+	 * every next one
+	 */
+	return iter->slot->base_gfn < end;
+}
+
+/* Iterate over each memslot at least partially intersecting [start, end) range */
+#define kvm_for_each_memslot_in_gfn_range(iter, slots, start, end)	\
+	for (kvm_memslot_iter_start(iter, slots, start);		\
+	     kvm_memslot_iter_is_valid(iter, end);			\
+	     kvm_memslot_iter_next(iter))
+
 /*
  * KVM_SET_USER_MEMORY_REGION ioctl allows the following operations:
  * - create a new memory slot
