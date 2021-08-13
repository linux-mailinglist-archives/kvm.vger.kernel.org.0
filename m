Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2665E3EBD00
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 22:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbhHMUCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 16:02:24 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:50382 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234498AbhHMUCW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 16:02:22 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mEcwo-000467-DW; Fri, 13 Aug 2021 21:34:30 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
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
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 11/13] KVM: Keep memslots in tree-based structures instead of array-based ones
Date:   Fri, 13 Aug 2021 21:33:24 +0200
Message-Id: <418e7c82c9963161bfdda74ae3b0fb3f16c5d007.1628871413.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628871411.git.maciej.szmigiero@oracle.com>
References: <cover.1628871411.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

The current memslot code uses a (reverse gfn-ordered) memslot array for
keeping track of them.

Because the memslot array that is currently in use cannot be modified
every memslot management operation (create, delete, move, change flags)
has to make a copy of the whole array so it has a scratch copy to work on.

Strictly speaking, however, it is only necessary to make copy of the
memslot that is being modified, copying all the memslots currently present
is just a limitation of the array-based memslot implementation.

Two memslot sets, however, are still needed so the VM continues to run
on the currently active set while the requested operation is being
performed on the second, currently inactive one.

In order to have two memslot sets, but only one copy of actual memslots
it is necessary to split out the memslot data from the memslot sets.

The memslots themselves should be also kept independent of each other
so they can be individually added or deleted.

These two memslot sets should normally point to the same set of
memslots. They can, however, be desynchronized when performing a
memslot management operation by replacing the memslot to be modified
by its copy.  After the operation is complete, both memslot sets once
again point to the same, common set of memslot data.

This commit implements the aforementioned idea.

For tracking of gfns an ordinary rbtree is used since memslots cannot
overlap in the guest address space and so this data structure is
sufficient for ensuring that lookups are done quickly.

The "last used slot" mini-caches (both per-slot set one and per-vCPU one),
that keep track of the last found-by-gfn memslot, are still present in the
new code.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c                |   8 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c |   4 +-
 arch/powerpc/kvm/book3s_hv.c        |   3 +-
 arch/powerpc/kvm/book3s_hv_nested.c |   4 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c  |  14 +-
 arch/s390/kvm/kvm-s390.c            |  24 +-
 arch/s390/kvm/kvm-s390.h            |   6 +-
 arch/x86/kvm/debugfs.c              |   6 +-
 arch/x86/kvm/mmu/mmu.c              |   4 +-
 arch/x86/kvm/x86.c                  |   4 +-
 include/linux/kvm_host.h            | 140 +++---
 virt/kvm/kvm_main.c                 | 659 +++++++++++++---------------
 12 files changed, 425 insertions(+), 451 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ed74d23970a0..deea7de18e96 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -209,13 +209,13 @@ static void stage2_flush_vm(struct kvm *kvm)
 {
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
-	int idx;
+	int idx, bkt;
 
 	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
 
 	slots = kvm_memslots(kvm);
-	kvm_for_each_memslot(memslot, slots)
+	kvm_for_each_memslot(memslot, bkt, slots)
 		stage2_flush_memslot(kvm, memslot);
 
 	spin_unlock(&kvm->mmu_lock);
@@ -548,14 +548,14 @@ void stage2_unmap_vm(struct kvm *kvm)
 {
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
-	int idx;
+	int idx, bkt;
 
 	idx = srcu_read_lock(&kvm->srcu);
 	mmap_read_lock(current->mm);
 	spin_lock(&kvm->mmu_lock);
 
 	slots = kvm_memslots(kvm);
-	kvm_for_each_memslot(memslot, slots)
+	kvm_for_each_memslot(memslot, bkt, slots)
 		stage2_unmap_memslot(kvm, memslot);
 
 	spin_unlock(&kvm->mmu_lock);
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index c63e263312a4..213232914367 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -734,11 +734,11 @@ void kvmppc_rmap_reset(struct kvm *kvm)
 {
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
-	int srcu_idx;
+	int srcu_idx, bkt;
 
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 	slots = kvm_memslots(kvm);
-	kvm_for_each_memslot(memslot, slots) {
+	kvm_for_each_memslot(memslot, bkt, slots) {
 		/* Mutual exclusion with kvm_unmap_hva_range etc. */
 		spin_lock(&kvm->mmu_lock);
 		/*
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 6d63c8e6d4f0..4ead97ae985e 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5791,11 +5791,12 @@ static int kvmhv_svm_off(struct kvm *kvm)
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		struct kvm_memory_slot *memslot;
 		struct kvm_memslots *slots = __kvm_memslots(kvm, i);
+		int bkt;
 
 		if (!slots)
 			continue;
 
-		kvm_for_each_memslot(memslot, slots) {
+		kvm_for_each_memslot(memslot, bkt, slots) {
 			kvmppc_uvmem_drop_pages(memslot, kvm, true);
 			uv_unregister_mem_slot(kvm->arch.lpid, memslot->id);
 		}
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 8543ad538b0c..c95868719706 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -730,7 +730,7 @@ void kvmhv_release_all_nested(struct kvm *kvm)
 	struct kvm_nested_guest *gp;
 	struct kvm_nested_guest *freelist = NULL;
 	struct kvm_memory_slot *memslot;
-	int srcu_idx;
+	int srcu_idx, bkt;
 
 	spin_lock(&kvm->mmu_lock);
 	for (i = 0; i <= kvm->arch.max_nested_lpid; i++) {
@@ -751,7 +751,7 @@ void kvmhv_release_all_nested(struct kvm *kvm)
 	}
 
 	srcu_idx = srcu_read_lock(&kvm->srcu);
-	kvm_for_each_memslot(memslot, kvm_memslots(kvm))
+	kvm_for_each_memslot(memslot, bkt, kvm_memslots(kvm))
 		kvmhv_free_memslot_nest_rmap(memslot);
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
 }
diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index a7061ee3b157..adc1c495d47c 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -459,7 +459,7 @@ unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot, *m;
 	int ret = H_SUCCESS;
-	int srcu_idx;
+	int srcu_idx, bkt;
 
 	kvm->arch.secure_guest = KVMPPC_SECURE_INIT_START;
 
@@ -478,7 +478,7 @@ unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
 
 	/* register the memslot */
 	slots = kvm_memslots(kvm);
-	kvm_for_each_memslot(memslot, slots) {
+	kvm_for_each_memslot(memslot, bkt, slots) {
 		ret = __kvmppc_uvmem_memslot_create(kvm, memslot);
 		if (ret)
 			break;
@@ -486,7 +486,7 @@ unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
 
 	if (ret) {
 		slots = kvm_memslots(kvm);
-		kvm_for_each_memslot(m, slots) {
+		kvm_for_each_memslot(m, bkt, slots) {
 			if (m == memslot)
 				break;
 			__kvmppc_uvmem_memslot_delete(kvm, memslot);
@@ -647,7 +647,7 @@ void kvmppc_uvmem_drop_pages(const struct kvm_memory_slot *slot,
 
 unsigned long kvmppc_h_svm_init_abort(struct kvm *kvm)
 {
-	int srcu_idx;
+	int srcu_idx, bkt;
 	struct kvm_memory_slot *memslot;
 
 	/*
@@ -662,7 +662,7 @@ unsigned long kvmppc_h_svm_init_abort(struct kvm *kvm)
 
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 
-	kvm_for_each_memslot(memslot, kvm_memslots(kvm))
+	kvm_for_each_memslot(memslot, bkt, kvm_memslots(kvm))
 		kvmppc_uvmem_drop_pages(memslot, kvm, false);
 
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
@@ -821,7 +821,7 @@ unsigned long kvmppc_h_svm_init_done(struct kvm *kvm)
 {
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
-	int srcu_idx;
+	int srcu_idx, bkt;
 	long ret = H_SUCCESS;
 
 	if (!(kvm->arch.secure_guest & KVMPPC_SECURE_INIT_START))
@@ -830,7 +830,7 @@ unsigned long kvmppc_h_svm_init_done(struct kvm *kvm)
 	/* migrate any unmoved normal pfn to device pfns*/
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 	slots = kvm_memslots(kvm);
-	kvm_for_each_memslot(memslot, slots) {
+	kvm_for_each_memslot(memslot, bkt, slots) {
 		ret = kvmppc_uv_migrate_mem_slot(kvm, memslot);
 		if (ret) {
 			/*
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 9c3a85793ba4..811761a187dd 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1035,13 +1035,13 @@ static int kvm_s390_vm_start_migration(struct kvm *kvm)
 	struct kvm_memory_slot *ms;
 	struct kvm_memslots *slots;
 	unsigned long ram_pages = 0;
-	int slotnr;
+	int bkt;
 
 	/* migration mode already enabled */
 	if (kvm->arch.migration_mode)
 		return 0;
 	slots = kvm_memslots(kvm);
-	if (!slots || !slots->used_slots)
+	if (!slots || kvm_memslots_empty(slots))
 		return -EINVAL;
 
 	if (!kvm->arch.use_cmma) {
@@ -1049,8 +1049,7 @@ static int kvm_s390_vm_start_migration(struct kvm *kvm)
 		return 0;
 	}
 	/* mark all the pages in active slots as dirty */
-	for (slotnr = 0; slotnr < slots->used_slots; slotnr++) {
-		ms = slots->memslots + slotnr;
+	kvm_for_each_memslot(ms, bkt, slots) {
 		if (!ms->dirty_bitmap)
 			return -EINVAL;
 		/*
@@ -1968,22 +1967,21 @@ static unsigned long kvm_s390_next_dirty_cmma(struct kvm_memslots *slots,
 					      unsigned long cur_gfn)
 {
 	struct kvm_memory_slot *ms = __gfn_to_memslot_approx(slots, cur_gfn, true);
-	int slotidx = ms - slots->memslots;
 	unsigned long ofs = cur_gfn - ms->base_gfn;
+	struct rb_node *mnode = &ms->gfn_node[slots->node_idx];
 
 	if (ms->base_gfn + ms->npages <= cur_gfn) {
-		slotidx--;
+		mnode = rb_next(mnode);
 		/* If we are above the highest slot, wrap around */
-		if (slotidx < 0)
-			slotidx = slots->used_slots - 1;
+		if (!mnode)
+			mnode = rb_first(&slots->gfn_tree);
 
-		ms = slots->memslots + slotidx;
+		ms = container_of(mnode, struct kvm_memory_slot, gfn_node[slots->node_idx]);
 		ofs = 0;
 	}
 	ofs = find_next_bit(kvm_second_dirty_bitmap(ms), ms->npages, ofs);
-	while ((slotidx > 0) && (ofs >= ms->npages)) {
-		slotidx--;
-		ms = slots->memslots + slotidx;
+	while (ofs >= ms->npages && (mnode = rb_next(mnode))) {
+		ms = container_of(mnode, struct kvm_memory_slot, gfn_node[slots->node_idx]);
 		ofs = find_next_bit(kvm_second_dirty_bitmap(ms), ms->npages, 0);
 	}
 	return ms->base_gfn + ofs;
@@ -1996,7 +1994,7 @@ static int kvm_s390_get_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	struct kvm_memory_slot *ms;
 
-	if (unlikely(!slots->used_slots))
+	if (unlikely(kvm_memslots_empty(slots)))
 		return 0;
 
 	cur_gfn = kvm_s390_next_dirty_cmma(slots, args->start_gfn);
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 5787b12aff7e..71a92d208b4a 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -211,12 +211,14 @@ static inline int kvm_s390_user_cpu_state_ctrl(struct kvm *kvm)
 /* get the end gfn of the last (highest gfn) memslot */
 static inline unsigned long kvm_s390_get_gfn_end(struct kvm_memslots *slots)
 {
+	struct rb_node *node;
 	struct kvm_memory_slot *ms;
 
-	if (WARN_ON(!slots->used_slots))
+	if (WARN_ON(kvm_memslots_empty(slots)))
 		return 0;
 
-	ms = slots->memslots;
+	node = rb_last(&slots->gfn_tree);
+	ms = container_of(node, struct kvm_memory_slot, gfn_node[slots->node_idx]);
 	return ms->base_gfn + ms->npages;
 }
 
diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index 4fa519caaef7..555f98f4a396 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -108,9 +108,10 @@ static int kvm_mmu_rmaps_stat_show(struct seq_file *m, void *v)
 	write_lock(&kvm->mmu_lock);
 
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		int bkt;
+
 		slots = __kvm_memslots(kvm, i);
-		for (j = 0; j < slots->used_slots; j++) {
-			slot = &slots->memslots[j];
+		kvm_for_each_memslot(slot, bkt, slots)
 			for (k = 0; k < KVM_NR_PAGE_SIZES; k++) {
 				rmap = slot->arch.rmap[k];
 				lpage_size = kvm_mmu_slot_lpages(slot, k + 1);
@@ -122,7 +123,6 @@ static int kvm_mmu_rmaps_stat_show(struct seq_file *m, void *v)
 					cur[index]++;
 				}
 			}
-		}
 	}
 
 	write_unlock(&kvm->mmu_lock);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 708ffc3bf1e0..2a4ac5100ff2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5643,8 +5643,10 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	if (kvm_memslots_have_rmaps(kvm)) {
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+			int bkt;
+
 			slots = __kvm_memslots(kvm, i);
-			kvm_for_each_memslot(memslot, slots) {
+			kvm_for_each_memslot(memslot, bkt, slots) {
 				gfn_t start, end;
 
 				start = max(gfn_start, memslot->base_gfn);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f39bf3c3a054..d9fd85400663 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11384,8 +11384,10 @@ int alloc_all_memslots_rmaps(struct kvm *kvm)
 	}
 
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		int bkt;
+
 		slots = __kvm_memslots(kvm, i);
-		kvm_for_each_memslot(slot, slots) {
+		kvm_for_each_memslot(slot, bkt, slots) {
 			r = memslot_rmap_alloc(slot, slot->npages);
 			if (r) {
 				mutex_unlock(&kvm->slots_arch_lock);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 27ece967ab48..71a9e13dab2d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -31,6 +31,7 @@
 #include <linux/notifier.h>
 #include <linux/hashtable.h>
 #include <linux/interval_tree.h>
+#include <linux/rbtree.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -358,11 +359,13 @@ struct kvm_vcpu {
 	struct kvm_dirty_ring dirty_ring;
 
 	/*
-	 * The index of the most recently used memslot by this vCPU. It's ok
-	 * if this becomes stale due to memslot changes since we always check
-	 * it is a valid slot.
+	 * The most recently used memslot by this vCPU and the slots generation
+	 * for which it is valid.
+	 * No wraparound protection is needed since generations won't overflow in
+	 * thousands of years, even assuming 1M memslot operations per second.
 	 */
-	int last_used_slot;
+	struct kvm_memory_slot *last_used_slot;
+	u64 last_used_slot_gen;
 };
 
 /* must be called with irqs disabled */
@@ -427,9 +430,26 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
  */
 #define KVM_MEM_MAX_NR_PAGES ((1UL << 31) - 1)
 
+/*
+ * Since at idle each memslot belongs to two memslot sets it has to contain
+ * two embedded nodes for each data structure that it forms a part of.
+ *
+ * Two memslot sets (one active and one inactive) are necessary so the VM
+ * continues to run on one memslot set while the other is being modified.
+ *
+ * These two memslot sets normally point to the same set of memslots.
+ * They can, however, be desynchronized when performing a memslot management
+ * operation by replacing the memslot to be modified by its copy.
+ * After the operation is complete, both memslot sets once again point to
+ * the same, common set of memslot data.
+ *
+ * The memslots themselves are independent of each other so they can be
+ * individually added or deleted.
+ */
 struct kvm_memory_slot {
-	struct hlist_node id_node;
-	struct interval_tree_node hva_node;
+	struct hlist_node id_node[2];
+	struct interval_tree_node hva_node[2];
+	struct rb_node gfn_node[2];
 	gfn_t base_gfn;
 	unsigned long npages;
 	unsigned long *dirty_bitmap;
@@ -524,19 +544,14 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 }
 #endif
 
-/*
- * Note:
- * memslots are not sorted by id anymore, please use id_to_memslot()
- * to get the memslot by its id.
- */
 struct kvm_memslots {
 	u64 generation;
+	atomic_long_t last_used_slot;
 	struct rb_root_cached hva_tree;
-	/* The mapping table from slot id to the index in memslots[]. */
+	struct rb_root gfn_tree;
+	/* The mapping table from slot id to memslot. */
 	DECLARE_HASHTABLE(id_hash, 7);
-	atomic_t last_used_slot;
-	int used_slots;
-	struct kvm_memory_slot memslots[];
+	int node_idx;
 };
 
 struct kvm {
@@ -557,6 +572,9 @@ struct kvm {
 	 */
 	struct mutex slots_arch_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
+	/* The two memslot sets - active and inactive (per address space) */
+	struct kvm_memslots __memslots[KVM_ADDRESS_SPACE_NUM][2];
+	/* The current active memslot set for each address space */
 	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 
@@ -731,12 +749,6 @@ static inline int kvm_vcpu_get_idx(struct kvm_vcpu *vcpu)
 	return vcpu->vcpu_idx;
 }
 
-#define kvm_for_each_memslot(memslot, slots)				\
-	for (memslot = &slots->memslots[0];				\
-	     memslot < slots->memslots + slots->used_slots; memslot++)	\
-		if (WARN_ON_ONCE(!memslot->npages)) {			\
-		} else
-
 void kvm_vcpu_destroy(struct kvm_vcpu *vcpu);
 
 void vcpu_load(struct kvm_vcpu *vcpu);
@@ -797,12 +809,23 @@ static inline struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu)
 	return __kvm_memslots(vcpu->kvm, as_id);
 }
 
+static inline bool kvm_memslots_empty(struct kvm_memslots *slots)
+{
+	return RB_EMPTY_ROOT(&slots->gfn_tree);
+}
+
+#define kvm_for_each_memslot(memslot, bkt, slots)			      \
+	hash_for_each(slots->id_hash, bkt, memslot, id_node[slots->node_idx]) \
+		if (WARN_ON_ONCE(!memslot->npages)) {			      \
+		} else
+
 static inline
 struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
 {
 	struct kvm_memory_slot *slot;
+	int idx = slots->node_idx;
 
-	hash_for_each_possible(slots->id_hash, slot, id_node, id) {
+	hash_for_each_possible(slots->id_hash, slot, id_node[idx], id) {
 		if (slot->id == id)
 			return slot;
 	}
@@ -1206,25 +1229,15 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
 bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
 
 /*
- * Returns a pointer to the memslot at slot_index if it contains gfn.
+ * Returns a pointer to the memslot if it contains gfn.
  * Otherwise returns NULL.
  */
 static inline struct kvm_memory_slot *
-try_get_memslot(struct kvm_memslots *slots, int slot_index, gfn_t gfn)
+try_get_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	struct kvm_memory_slot *slot;
-
-	if (slot_index < 0 || slot_index >= slots->used_slots)
+	if (!slot)
 		return NULL;
 
-	/*
-	 * slot_index can come from vcpu->last_used_slot which is not kept
-	 * in sync with userspace-controllable memslot deletion. So use nospec
-	 * to prevent the CPU from speculating past the end of memslots[].
-	 */
-	slot_index = array_index_nospec(slot_index, slots->used_slots);
-	slot = &slots->memslots[slot_index];
-
 	if (gfn >= slot->base_gfn && gfn < slot->base_gfn + slot->npages)
 		return slot;
 	else
@@ -1232,50 +1245,31 @@ try_get_memslot(struct kvm_memslots *slots, int slot_index, gfn_t gfn)
 }
 
 /*
- * Returns a pointer to the memslot that contains gfn and records the index of
- * the slot in index. Otherwise returns NULL.
+ * Returns a pointer to the memslot that contains gfn. Otherwise returns NULL.
  *
  * With "approx" set returns the memslot also when the address falls
  * in a hole. In that case one of the memslots bordering the hole is
  * returned.
- *
- * IMPORTANT: Slots are sorted from highest GFN to lowest GFN!
  */
 static inline struct kvm_memory_slot *
-search_memslots(struct kvm_memslots *slots, gfn_t gfn, int *index, bool approx)
+search_memslots(struct kvm_memslots *slots, gfn_t gfn, bool approx)
 {
-	int start = 0, end = slots->used_slots;
-	struct kvm_memory_slot *memslots = slots->memslots;
 	struct kvm_memory_slot *slot;
-
-	if (unlikely(!slots->used_slots))
-		return NULL;
-
-	while (start < end) {
-		int slot = start + (end - start) / 2;
-
-		if (gfn >= memslots[slot].base_gfn)
-			end = slot;
-		else
-			start = slot + 1;
-	}
-
-	if (approx && start >= slots->used_slots) {
-		*index = slots->used_slots - 1;
-		return &memslots[slots->used_slots - 1];
-	}
-
-	slot = try_get_memslot(slots, start, gfn);
-	if (slot) {
-		*index = start;
-		return slot;
-	}
-	if (approx) {
-		*index = start;
-		return &memslots[start];
+	struct rb_node *node;
+	int idx = slots->node_idx;
+
+	slot = NULL;
+	for (node = slots->gfn_tree.rb_node; node; ) {
+		slot = container_of(node, struct kvm_memory_slot, gfn_node[idx]);
+		if (gfn >= slot->base_gfn) {
+			if (gfn < slot->base_gfn + slot->npages)
+				return slot;
+			node = node->rb_right;
+		} else
+			node = node->rb_left;
 	}
 
-	return NULL;
+	return approx ? slot : NULL;
 }
 
 /*
@@ -1287,15 +1281,15 @@ static inline struct kvm_memory_slot *
 __gfn_to_memslot_approx(struct kvm_memslots *slots, gfn_t gfn, bool approx)
 {
 	struct kvm_memory_slot *slot;
-	int slot_index = atomic_read(&slots->last_used_slot);
 
-	slot = try_get_memslot(slots, slot_index, gfn);
+	slot = (struct kvm_memory_slot *)atomic_long_read(&slots->last_used_slot);
+	slot = try_get_memslot(slot, gfn);
 	if (slot)
 		return slot;
 
-	slot = search_memslots(slots, gfn, &slot_index, approx);
+	slot = search_memslots(slots, gfn, approx);
 	if (slot) {
-		atomic_set(&slots->last_used_slot, slot_index);
+		atomic_long_set(&slots->last_used_slot, (unsigned long)slot);
 		return slot;
 	}
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1be05acab3ed..26aa3690b172 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -415,7 +415,7 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->preempted = false;
 	vcpu->ready = false;
 	preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
-	vcpu->last_used_slot = 0;
+	vcpu->last_used_slot = NULL;
 }
 
 void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
@@ -514,7 +514,7 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 						  range->start, range->end - 1) {
 			unsigned long hva_start, hva_end;
 
-			slot = container_of(node, struct kvm_memory_slot, hva_node);
+			slot = container_of(node, struct kvm_memory_slot, hva_node[slots->node_idx]);
 			hva_start = max(range->start, slot->userspace_addr);
 			hva_end = min(range->end, slot->userspace_addr +
 						  (slot->npages << PAGE_SHIFT));
@@ -848,20 +848,6 @@ static void kvm_destroy_pm_notifier(struct kvm *kvm)
 }
 #endif /* CONFIG_HAVE_KVM_PM_NOTIFIER */
 
-static struct kvm_memslots *kvm_alloc_memslots(void)
-{
-	struct kvm_memslots *slots;
-
-	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
-	if (!slots)
-		return NULL;
-
-	slots->hva_tree = RB_ROOT_CACHED;
-	hash_init(slots->id_hash);
-
-	return slots;
-}
-
 static void kvm_destroy_dirty_bitmap(struct kvm_memory_slot *memslot)
 {
 	if (!memslot->dirty_bitmap)
@@ -871,27 +857,33 @@ static void kvm_destroy_dirty_bitmap(struct kvm_memory_slot *memslot)
 	memslot->dirty_bitmap = NULL;
 }
 
+/* This does not remove the slot from struct kvm_memslots data structures */
 static void kvm_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
 	kvm_destroy_dirty_bitmap(slot);
 
 	kvm_arch_free_memslot(kvm, slot);
 
-	slot->flags = 0;
-	slot->npages = 0;
+	kfree(slot);
 }
 
 static void kvm_free_memslots(struct kvm *kvm, struct kvm_memslots *slots)
 {
+	struct hlist_node *idnode;
 	struct kvm_memory_slot *memslot;
+	int bkt;
 
-	if (!slots)
+	/*
+	 * The same memslot objects live in both active and inactive sets,
+	 * arbitrarily free using index '1' so the second invocation of this
+	 * function isn't operating over a structure with dangling pointers
+	 * (even though this function isn't actually touching them).
+	 */
+	if (!slots->node_idx)
 		return;
 
-	kvm_for_each_memslot(memslot, slots)
+	hash_for_each_safe(slots->id_hash, bkt, idnode, memslot, id_node[1])
 		kvm_free_memslot(kvm, memslot);
-
-	kvfree(slots);
 }
 
 static umode_t kvm_stats_debugfs_mode(const struct _kvm_stats_desc *pdesc)
@@ -1030,8 +1022,9 @@ int __weak kvm_arch_create_vm_debugfs(struct kvm *kvm)
 static struct kvm *kvm_create_vm(unsigned long type)
 {
 	struct kvm *kvm = kvm_arch_alloc_vm();
+	struct kvm_memslots *slots;
 	int r = -ENOMEM;
-	int i;
+	int i, j;
 
 	if (!kvm)
 		return ERR_PTR(-ENOMEM);
@@ -1058,13 +1051,20 @@ static struct kvm *kvm_create_vm(unsigned long type)
 
 	refcount_set(&kvm->users_count, 1);
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
-		struct kvm_memslots *slots = kvm_alloc_memslots();
+		for (j = 0; j < 2; j++) {
+			slots = &kvm->__memslots[i][j];
 
-		if (!slots)
-			goto out_err_no_arch_destroy_vm;
-		/* Generations must be different for each address space. */
-		slots->generation = i;
-		rcu_assign_pointer(kvm->memslots[i], slots);
+			atomic_long_set(&slots->last_used_slot, (unsigned long)NULL);
+			slots->hva_tree = RB_ROOT_CACHED;
+			slots->gfn_tree = RB_ROOT;
+			hash_init(slots->id_hash);
+			slots->node_idx = j;
+
+			/* Generations must be different for each address space. */
+			slots->generation = i;
+		}
+
+		rcu_assign_pointer(kvm->memslots[i], &kvm->__memslots[i][0]);
 	}
 
 	for (i = 0; i < KVM_NR_BUSES; i++) {
@@ -1118,8 +1118,6 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
 	for (i = 0; i < KVM_NR_BUSES; i++)
 		kfree(kvm_get_bus(kvm, i));
-	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-		kvm_free_memslots(kvm, __kvm_memslots(kvm, i));
 	cleanup_srcu_struct(&kvm->irq_srcu);
 out_err_no_irq_srcu:
 	cleanup_srcu_struct(&kvm->srcu);
@@ -1184,8 +1182,10 @@ static void kvm_destroy_vm(struct kvm *kvm)
 #endif
 	kvm_arch_destroy_vm(kvm);
 	kvm_destroy_devices(kvm);
-	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-		kvm_free_memslots(kvm, __kvm_memslots(kvm, i));
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		kvm_free_memslots(kvm, &kvm->__memslots[i][0]);
+		kvm_free_memslots(kvm, &kvm->__memslots[i][1]);
+	}
 	cleanup_srcu_struct(&kvm->irq_srcu);
 	cleanup_srcu_struct(&kvm->srcu);
 	kvm_arch_free_vm(kvm);
@@ -1255,217 +1255,6 @@ static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
 	return 0;
 }
 
-/*
- * Delete a memslot by decrementing the number of used slots and shifting all
- * other entries in the array forward one spot.
- * @memslot is a detached dummy struct with just .id and .as_id filled.
- */
-static inline void kvm_memslot_delete(struct kvm_memslots *slots,
-				      struct kvm_memory_slot *memslot)
-{
-	struct kvm_memory_slot *mslots = slots->memslots;
-	struct kvm_memory_slot *oldslot = id_to_memslot(slots, memslot->id);
-	int i;
-
-	if (WARN_ON(!oldslot))
-		return;
-
-	slots->used_slots--;
-
-	if (atomic_read(&slots->last_used_slot) >= slots->used_slots)
-		atomic_set(&slots->last_used_slot, 0);
-
-	for (i = oldslot - mslots; i < slots->used_slots; i++) {
-		interval_tree_remove(&mslots[i].hva_node, &slots->hva_tree);
-		hash_del(&mslots[i].id_node);
-
-		mslots[i] = mslots[i + 1];
-		interval_tree_insert(&mslots[i].hva_node, &slots->hva_tree);
-		hash_add(slots->id_hash, &mslots[i].id_node, mslots[i].id);
-	}
-	interval_tree_remove(&mslots[i].hva_node, &slots->hva_tree);
-	hash_del(&mslots[i].id_node);
-	mslots[i] = *memslot;
-}
-
-/*
- * "Insert" a new memslot by incrementing the number of used slots.  Returns
- * the new slot's initial index into the memslots array.
- */
-static inline int kvm_memslot_insert_back(struct kvm_memslots *slots)
-{
-	return slots->used_slots++;
-}
-
-/*
- * Move a changed memslot backwards in the array by shifting existing slots
- * with a higher GFN toward the front of the array.  Note, the changed memslot
- * itself is not preserved in the array, i.e. not swapped at this time, only
- * its new index into the array is tracked.  Returns the changed memslot's
- * current index into the memslots array.
- * The memslot at the returned index will not be in @slots->hva_tree or
- * @slots->id_hash by then.
- * @memslot is a detached struct with desired final data of the changed slot.
- */
-static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
-					    struct kvm_memory_slot *memslot)
-{
-	struct kvm_memory_slot *mslots = slots->memslots;
-	struct kvm_memory_slot *mmemslot = id_to_memslot(slots, memslot->id);
-	int i;
-
-	if (!mmemslot || !slots->used_slots)
-		return -1;
-
-	/*
-	 * The loop below will (possibly) overwrite the target memslot with
-	 * data of the next memslot, or a similar loop in
-	 * kvm_memslot_move_forward() will overwrite it with data of the
-	 * previous memslot.
-	 * Then update_memslots() will unconditionally overwrite and re-add
-	 * it to the hash table.
-	 * That's why the memslot has to be first removed from the hash table
-	 * here.
-	 */
-	interval_tree_remove(&mmemslot->hva_node, &slots->hva_tree);
-	hash_del(&mmemslot->id_node);
-
-	/*
-	 * Move the target memslot backward in the array by shifting existing
-	 * memslots with a higher GFN (than the target memslot) towards the
-	 * front of the array.
-	 */
-	for (i = mmemslot - mslots; i < slots->used_slots - 1; i++) {
-		if (memslot->base_gfn > mslots[i + 1].base_gfn)
-			break;
-
-		WARN_ON_ONCE(memslot->base_gfn == mslots[i + 1].base_gfn);
-
-		/* Shift the next memslot forward one and update its index. */
-		interval_tree_remove(&mslots[i + 1].hva_node, &slots->hva_tree);
-		hash_del(&mslots[i + 1].id_node);
-
-		mslots[i] = mslots[i + 1];
-		interval_tree_insert(&mslots[i].hva_node, &slots->hva_tree);
-		hash_add(slots->id_hash, &mslots[i].id_node, mslots[i].id);
-	}
-	return i;
-}
-
-/*
- * Move a changed memslot forwards in the array by shifting existing slots with
- * a lower GFN toward the back of the array.  Note, the changed memslot itself
- * is not preserved in the array, i.e. not swapped at this time, only its new
- * index into the array is tracked.  Returns the changed memslot's final index
- * into the memslots array.
- * The memslot at the returned index will not be in @slots->hva_tree or
- * @slots->id_hash by then.
- * @memslot is a detached struct with desired final data of the new or
- * changed slot.
- * Assumes that the memslot at @start index is not in @slots->hva_tree or
- * @slots->id_hash.
- */
-static inline int kvm_memslot_move_forward(struct kvm_memslots *slots,
-					   struct kvm_memory_slot *memslot,
-					   int start)
-{
-	struct kvm_memory_slot *mslots = slots->memslots;
-	int i;
-
-	for (i = start; i > 0; i--) {
-		if (memslot->base_gfn < mslots[i - 1].base_gfn)
-			break;
-
-		WARN_ON_ONCE(memslot->base_gfn == mslots[i - 1].base_gfn);
-
-		/* Shift the next memslot back one and update its index. */
-		interval_tree_remove(&mslots[i - 1].hva_node, &slots->hva_tree);
-		hash_del(&mslots[i - 1].id_node);
-
-		mslots[i] = mslots[i - 1];
-		interval_tree_insert(&mslots[i].hva_node, &slots->hva_tree);
-		hash_add(slots->id_hash, &mslots[i].id_node, mslots[i].id);
-	}
-	return i;
-}
-
-/*
- * Re-sort memslots based on their GFN to account for an added, deleted, or
- * moved memslot.  Sorting memslots by GFN allows using a binary search during
- * memslot lookup.
- *
- * IMPORTANT: Slots are sorted from highest GFN to lowest GFN!  I.e. the entry
- * at memslots[0] has the highest GFN.
- *
- * The sorting algorithm takes advantage of having initially sorted memslots
- * and knowing the position of the changed memslot.  Sorting is also optimized
- * by not swapping the updated memslot and instead only shifting other memslots
- * and tracking the new index for the update memslot.  Only once its final
- * index is known is the updated memslot copied into its position in the array.
- *
- *  - When deleting a memslot, the deleted memslot simply needs to be moved to
- *    the end of the array.
- *
- *  - When creating a memslot, the algorithm "inserts" the new memslot at the
- *    end of the array and then it forward to its correct location.
- *
- *  - When moving a memslot, the algorithm first moves the updated memslot
- *    backward to handle the scenario where the memslot's GFN was changed to a
- *    lower value.  update_memslots() then falls through and runs the same flow
- *    as creating a memslot to move the memslot forward to handle the scenario
- *    where its GFN was changed to a higher value.
- *
- * Note, slots are sorted from highest->lowest instead of lowest->highest for
- * historical reasons.  Originally, invalid memslots where denoted by having
- * GFN=0, thus sorting from highest->lowest naturally sorted invalid memslots
- * to the end of the array.  The current algorithm uses dedicated logic to
- * delete a memslot and thus does not rely on invalid memslots having GFN=0.
- *
- * The other historical motiviation for highest->lowest was to improve the
- * performance of memslot lookup.  KVM originally used a linear search starting
- * at memslots[0].  On x86, the largest memslot usually has one of the highest,
- * if not *the* highest, GFN, as the bulk of the guest's RAM is located in a
- * single memslot above the 4gb boundary.  As the largest memslot is also the
- * most likely to be referenced, sorting it to the front of the array was
- * advantageous.  The current binary search starts from the middle of the array
- * and uses an LRU pointer to improve performance for all memslots and GFNs.
- *
- * @memslot is a detached struct, not a part of the current or new memslot
- * array.
- */
-static void update_memslots(struct kvm_memslots *slots,
-			    struct kvm_memory_slot *memslot,
-			    enum kvm_mr_change change)
-{
-	int i;
-
-	if (change == KVM_MR_DELETE) {
-		kvm_memslot_delete(slots, memslot);
-	} else {
-		if (change == KVM_MR_CREATE)
-			i = kvm_memslot_insert_back(slots);
-		else
-			i = kvm_memslot_move_backward(slots, memslot);
-		i = kvm_memslot_move_forward(slots, memslot, i);
-
-		if (WARN_ON_ONCE(i < 0))
-			return;
-
-		/*
-		 * Copy the memslot to its new position in memslots and update
-		 * its index accordingly.
-		 */
-		slots->memslots[i] = *memslot;
-		slots->memslots[i].hva_node.start = memslot->userspace_addr;
-		slots->memslots[i].hva_node.last = memslot->userspace_addr +
-			(memslot->npages << PAGE_SHIFT) - 1;
-		interval_tree_insert(&slots->memslots[i].hva_node,
-				     &slots->hva_tree);
-		hash_add(slots->id_hash, &slots->memslots[i].id_node,
-			 memslot->id);
-	}
-}
-
 static int check_memory_region_flags(const struct kvm_userspace_memory_region *mem)
 {
 	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
@@ -1480,11 +1269,12 @@ static int check_memory_region_flags(const struct kvm_userspace_memory_region *m
 	return 0;
 }
 
-static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
-		int as_id, struct kvm_memslots *slots)
+static void kvm_swap_active_memslots(struct kvm *kvm, int as_id,
+				     struct kvm_memslots **active,
+				     struct kvm_memslots **inactive)
 {
-	struct kvm_memslots *old_memslots = __kvm_memslots(kvm, as_id);
-	u64 gen = old_memslots->generation;
+	struct kvm_memslots *slots = *inactive;
+	u64 gen = (*active)->generation;
 
 	WARN_ON(gen & KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS);
 	slots->generation = gen | KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS;
@@ -1536,61 +1326,139 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 
 	slots->generation = gen;
 
-	return old_memslots;
+	swap(*active, *inactive);
 }
 
-static size_t kvm_memslots_size(int slots)
+static void kvm_memslot_gfn_insert(struct kvm_memslots *slots,
+				   struct kvm_memory_slot *slot)
 {
-	return sizeof(struct kvm_memslots) +
-	       (sizeof(struct kvm_memory_slot) * slots);
+	struct rb_root *gfn_tree = &slots->gfn_tree;
+	struct rb_node **node, *parent;
+	int idx = slots->node_idx;
+
+	parent = NULL;
+	for (node = &gfn_tree->rb_node; *node; ) {
+		struct kvm_memory_slot *tmp;
+
+		tmp = container_of(*node, struct kvm_memory_slot, gfn_node[idx]);
+		parent = *node;
+		if (slot->base_gfn < tmp->base_gfn)
+			node = &(*node)->rb_left;
+		else if (slot->base_gfn > tmp->base_gfn)
+			node = &(*node)->rb_right;
+		else
+			BUG();
+	}
+
+	rb_link_node(&slot->gfn_node[idx], parent, node);
+	rb_insert_color(&slot->gfn_node[idx], gfn_tree);
 }
 
-static void kvm_copy_memslots(struct kvm_memslots *to,
-			      struct kvm_memslots *from)
+static void kvm_memslot_gfn_erase(struct kvm_memslots *slots,
+				  struct kvm_memory_slot *slot)
 {
-	memcpy(to, from, kvm_memslots_size(from->used_slots));
+	rb_erase(&slot->gfn_node[slots->node_idx], &slots->gfn_tree);
 }
 
-static void kvm_copy_memslots_arch(struct kvm_memslots *to,
-				   struct kvm_memslots *from)
+static void kvm_memslot_gfn_replace(struct kvm_memslots *slots,
+				    struct kvm_memory_slot *old,
+				    struct kvm_memory_slot *new)
 {
-	int i;
+	int idx = slots->node_idx;
+
+	WARN_ON_ONCE(old->base_gfn != new->base_gfn);
 
-	for (i = 0; i < from->used_slots; i++)
-		to->memslots[i].arch = from->memslots[i].arch;
+	rb_replace_node(&old->gfn_node[idx], &new->gfn_node[idx],
+			&slots->gfn_tree);
 }
 
-/*
- * Note, at a minimum, the current number of used slots must be allocated, even
- * when deleting a memslot, as we need a complete duplicate of the memslots for
- * use when invalidating a memslot prior to deleting/moving the memslot.
- */
-static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
-					     enum kvm_mr_change change)
+static void kvm_copy_memslot(struct kvm_memory_slot *dest,
+			     const struct kvm_memory_slot *src)
 {
-	struct kvm_memslots *slots;
-	size_t new_size;
-	struct kvm_memory_slot *memslot;
+	dest->base_gfn = src->base_gfn;
+	dest->npages = src->npages;
+	dest->dirty_bitmap = src->dirty_bitmap;
+	dest->arch = src->arch;
+	dest->userspace_addr = src->userspace_addr;
+	dest->flags = src->flags;
+	dest->id = src->id;
+	dest->as_id = src->as_id;
 
-	if (change == KVM_MR_CREATE)
-		new_size = kvm_memslots_size(old->used_slots + 1);
-	else
-		new_size = kvm_memslots_size(old->used_slots);
+	dest->hva_node[0].start = dest->hva_node[1].start =
+		dest->userspace_addr;
+	dest->hva_node[0].last = dest->hva_node[1].last =
+		dest->userspace_addr + (dest->npages << PAGE_SHIFT) - 1;
+}
 
-	slots = kvzalloc(new_size, GFP_KERNEL_ACCOUNT);
-	if (unlikely(!slots))
-		return NULL;
+/*
+ * Replace @old with @new in @slots.
+ *
+ * With NULL @old this simply adds @new to @slots.
+ * With NULL @new this simply removes @old from @slots.
+ *
+ * If @new is non-NULL its hva_node[slots_idx] range has to be set
+ * appropriately.
+ */
+static void kvm_replace_memslot(struct kvm_memslots *slots,
+				struct kvm_memory_slot *old,
+				struct kvm_memory_slot *new)
+{
+	int idx = slots->node_idx;
+
+	if (old) {
+		hash_del(&old->id_node[idx]);
+		interval_tree_remove(&old->hva_node[idx], &slots->hva_tree);
+		atomic_long_cmpxchg(&slots->last_used_slot,
+				    (unsigned long)old, (unsigned long)new);
+		if (!new) {
+			kvm_memslot_gfn_erase(slots, old);
+			return;
+		}
+	}
 
-	kvm_copy_memslots(slots, old);
+	WARN_ON(PAGE_SHIFT > 0 &&
+		new->hva_node[idx].start >= new->hva_node[idx].last);
+	hash_add(slots->id_hash, &new->id_node[idx], new->id);
+	interval_tree_insert(&new->hva_node[idx], &slots->hva_tree);
 
-	slots->hva_tree = RB_ROOT_CACHED;
-	hash_init(slots->id_hash);
-	kvm_for_each_memslot(memslot, slots) {
-		interval_tree_insert(&memslot->hva_node, &slots->hva_tree);
-		hash_add(slots->id_hash, &memslot->id_node, memslot->id);
+	/* Shame there is no O(1) interval_tree_replace()... */
+	if (old && old->base_gfn == new->base_gfn) {
+		kvm_memslot_gfn_replace(slots, old, new);
+	} else {
+		if (old)
+			kvm_memslot_gfn_erase(slots, old);
+		kvm_memslot_gfn_insert(slots, new);
 	}
+}
 
-	return slots;
+/*
+ * Replace @old with @new in @active set, first activating the @inactive
+ * set so @active will no longer be active and can be modified.
+ * Then free @old and return with pointers in @active and @inactive swapped
+ * (since the actual active <-> inactive sets have been swapped).
+ *
+ * With NULL @old this simply adds @new to @active (while swapping the sets).
+ * With NULL @new this simply removes @old from @active and frees it
+ * (while also swapping the sets).
+ */
+static void kvm_activate_memslot(struct kvm *kvm, int as_id,
+				 struct kvm_memslots **active,
+				 struct kvm_memslots **inactive,
+				 struct kvm_memory_slot *old,
+				 struct kvm_memory_slot *new)
+{
+	/*
+	 * Swap the active <-> inactive memslots.
+	 * Note, this also swaps the active and inactive pointers themselves
+	 * and releases slots_arch_lock.
+	 */
+	kvm_swap_active_memslots(kvm, as_id, active, inactive);
+
+	/* Propagate the new memslot to the now inactive memslots. */
+	kvm_replace_memslot(*inactive, old, new);
+
+	/* And free the old slot (if there was one). */
+	kfree(old);
 }
 
 static int kvm_set_memslot(struct kvm *kvm,
@@ -1599,16 +1467,47 @@ static int kvm_set_memslot(struct kvm *kvm,
 			   struct kvm_memory_slot *new, int as_id,
 			   enum kvm_mr_change change)
 {
-	struct kvm_memory_slot *slot;
-	struct kvm_memslots *slots;
+	struct kvm_memslots *active = __kvm_memslots(kvm, as_id);
+	int node_idx_inactive = active->node_idx == 0 ? 1 : 0;
+	struct kvm_memslots *inactive = &kvm->__memslots[as_id][node_idx_inactive];
+	/*
+	 * "slotina" (from "slot inactive") is a slot that is never in the
+	 * active memslot set.
+	 * This slot may be a part of the inactive memslot set or it might be detached.
+	 *
+	 * Conversely, an "slotact" (from "slot active") is a slot that is
+	 * in the active memslot set.
+	 * This slot might be a part of the inactive memslot set, too.
+	 *
+	 * The above terms only apply to a particular variable if it is going
+	 * to see further accesses later during this function execution
+	 * (that is, an invariant may no longer be true if the particular variable
+	 * won't be accessed anymore).
+	 */
+	struct kvm_memory_slot *slotina, *slotact;
 	int r;
 
+	if (change != KVM_MR_CREATE) {
+		slotact = id_to_memslot(active, old->id);
+		if (WARN_ON_ONCE(!slotact))
+			return -EIO;
+	}
+
+	/*
+	 * Modifications are done on a temporary, unreachable slot.
+	 * The changes are then (eventually) propagated to both the
+	 * active and inactive slots.
+	 */
+	slotina = kzalloc(sizeof(*slotina), GFP_KERNEL_ACCOUNT);
+	if (!slotina)
+		return -ENOMEM;
+
 	/*
-	 * Released in install_new_memslots.
+	 * Released in kvm_swap_active_memslots.
 	 *
 	 * Must be held from before the current memslots are copied until
 	 * after the new memslots are installed with rcu_assign_pointer,
-	 * then released before the synchronize srcu in install_new_memslots.
+	 * then released before the synchronize srcu in kvm_swap_active_memslots.
 	 *
 	 * When modifying memslots outside of the slots_lock, must be held
 	 * before reading the pointer to the current memslots until after all
@@ -1619,68 +1518,145 @@ static int kvm_set_memslot(struct kvm *kvm,
 	 */
 	mutex_lock(&kvm->slots_arch_lock);
 
-	slots = kvm_dup_memslots(__kvm_memslots(kvm, as_id), change);
-	if (!slots) {
-		mutex_unlock(&kvm->slots_arch_lock);
-		return -ENOMEM;
-	}
-
 	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
 		/*
-		 * Note, the INVALID flag needs to be in the appropriate entry
-		 * in the freshly allocated memslots, not in @old or @new.
+		 * Mark the current slot INVALID.
+		 * This must be done on the temporary slot to avoid
+		 * modifying the current slot in the active tree.
 		 */
-		slot = id_to_memslot(slots, old->id);
-		slot->flags |= KVM_MEMSLOT_INVALID;
+		kvm_copy_memslot(slotina, slotact);
+		slotina->flags |= KVM_MEMSLOT_INVALID;
+		kvm_replace_memslot(inactive, slotact, slotina);
+
+		/*
+		 * Activate the slot that is now marked INVALID, but don't
+		 * propagate the slot to the now inactive slots. The slot is
+		 * either going to be deleted or recreated as a new slot.
+		*/
+		kvm_swap_active_memslots(kvm, as_id, &active, &inactive);
 
 		/*
-		 * We can re-use the memory from the old memslots.
-		 * It will be overwritten with a copy of the new memslots
-		 * after reacquiring the slots_arch_lock below.
+		 * The temporary and current slot have swapped roles,
+		 * slotina is now in the active set and slotact is not,
+		 * so swap the variables appropriately, too.
 		 */
-		slots = install_new_memslots(kvm, as_id, slots);
+		swap(slotina, slotact);
 
-		/* From this point no new shadow pages pointing to a deleted,
+		/*
+		 * From this point no new shadow pages pointing to a deleted,
 		 * or moved, memslot will be created.
 		 *
 		 * validation of sp->gfn happens in:
 		 *	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
 		 *	- kvm_is_visible_gfn (mmu_check_root)
 		 */
-		kvm_arch_flush_shadow_memslot(kvm, slot);
+		kvm_arch_flush_shadow_memslot(kvm, slotact);
 
-		/* Released in install_new_memslots. */
+		/* Was released by kvm_swap_active_memslots, reacquire. */
 		mutex_lock(&kvm->slots_arch_lock);
+	}
 
+	if (change != KVM_MR_CREATE) {
 		/*
-		 * The arch-specific fields of the memslots could have changed
-		 * between releasing the slots_arch_lock in
-		 * install_new_memslots and here, so get a fresh copy of these
-		 * fields.
+		 * The arch-specific fields of the memslot could have changed
+		 * between reading them and taking slots_arch_lock in one of two
+		 * places above.
+		 * That includes old and new which were read in __kvm_set_memory_region.
 		 */
-		kvm_copy_memslots_arch(slots, __kvm_memslots(kvm, as_id));
+		old->arch = new->arch = slotina->arch = slotact->arch;
 	}
 
 	r = kvm_arch_prepare_memory_region(kvm, old, new, mem, change);
-	if (r)
-		goto out_slots;
+	if (r) {
+		if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
+			/*
+			 * Revert the above INVALID change.
+			 * No modifications required since the original slot
+			 * was preserved in the inactive slots.
+			 * This also frees the temporary slot and releases slots_arch_lock.
+			 */
+			kvm_activate_memslot(kvm, as_id, &active, &inactive, slotact, slotina);
+		} else {
+			mutex_unlock(&kvm->slots_arch_lock);
+			kfree(slotina);
+		}
+		return r;
+	}
 
-	update_memslots(slots, new, change);
-	slots = install_new_memslots(kvm, as_id, slots);
+	if (change == KVM_MR_MOVE) {
+		/*
+		 * The memslot's gfn is changing, remove it from the inactive
+		 * tree, it will be re-added with its updated gfn. Because its
+		 * range is changing, an in-place replace is not possible.
+		 */
+		kvm_memslot_gfn_erase(inactive, slotina);
 
-	kvm_arch_commit_memory_region(kvm, mem, old, new, change);
+		slotina->base_gfn = new->base_gfn;
+		slotina->flags = new->flags;
+		slotina->dirty_bitmap = new->dirty_bitmap;
+		/* kvm_arch_prepare_memory_region() might have modified arch */
+		slotina->arch = new->arch;
 
-	kvfree(slots);
-	return 0;
+		/* Re-add to the gfn tree with the updated gfn */
+		kvm_memslot_gfn_insert(inactive, slotina);
 
-out_slots:
-	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
-		slots = install_new_memslots(kvm, as_id, slots);
+		/* Replace the current INVALID slot with the updated memslot. */
+		kvm_activate_memslot(kvm, as_id, &active, &inactive, slotact, slotina);
+	} else if (change == KVM_MR_FLAGS_ONLY) {
+		/*
+		 * Similar to the MOVE case, but the slot doesn't need to be
+		 * zapped as an intermediate step. Instead, the old memslot is
+		 * simply replaced with a new, updated copy in both memslot sets.
+		 *
+		 * Since the memslot gfn is unchanged, kvm_copy_replace_memslot()
+		 * and kvm_memslot_gfn_replace() can be used to switch the node
+		 * in the gfn tree instead of removing the old and inserting the
+		 * new as two separate operations. Replacement is a single O(1)
+		 * operation versus two O(log(n)) operations for remove+insert.
+		 */
+		kvm_copy_memslot(slotina, slotact);
+		slotina->flags = new->flags;
+		slotina->dirty_bitmap = new->dirty_bitmap;
+		/* kvm_arch_prepare_memory_region() might have modified arch */
+		slotina->arch = new->arch;
+		kvm_replace_memslot(inactive, slotact, slotina);
+
+		kvm_activate_memslot(kvm, as_id, &active, &inactive, slotact, slotina);
+	} else if (change == KVM_MR_CREATE) {
+		/*
+		 * Add the new memslot to the inactive set as a copy of the
+		 * new memslot data provided by userspace.
+		 */
+		kvm_copy_memslot(slotina, new);
+		kvm_replace_memslot(inactive, NULL, slotina);
+
+		kvm_activate_memslot(kvm, as_id, &active, &inactive, NULL, slotina);
+	} else if (change == KVM_MR_DELETE) {
+		/*
+		 * Remove the old memslot (in the inactive memslots)
+		 * by passing NULL as the new slot.
+		 */
+		kvm_replace_memslot(inactive, slotina, NULL);
+		kvm_activate_memslot(kvm, as_id, &active, &inactive, slotact, NULL);
 	} else {
-		mutex_unlock(&kvm->slots_arch_lock);
+		BUG();
 	}
-	kvfree(slots);
-	return r;
+
+	/*
+	 * No need to refresh new->arch since this runs without slots_arch_lock anyway
+	 * (was released by kvm_activate_memslot call in one of the branches above).
+	 */
+	kvm_arch_commit_memory_region(kvm, mem, old, new, change);
+
+	/*
+	 * Free the memslot and its metadata.
+	 * Note, slotact and slotina hold the same metadata, but slotact
+	 * was freed by kvm_activate_memslot(). It's slotina's turn now.
+	 */
+	if (change == KVM_MR_DELETE)
+		kvm_free_memslot(kvm, slotina);
+
+	return 0;
 }
 
 static int kvm_delete_memslot(struct kvm *kvm,
@@ -1688,7 +1664,6 @@ static int kvm_delete_memslot(struct kvm *kvm,
 			      struct kvm_memory_slot *old, int as_id)
 {
 	struct kvm_memory_slot new;
-	int r;
 
 	if (!old->npages)
 		return -EINVAL;
@@ -1701,12 +1676,7 @@ static int kvm_delete_memslot(struct kvm *kvm,
 	 */
 	new.as_id = as_id;
 
-	r = kvm_set_memslot(kvm, mem, old, &new, as_id, KVM_MR_DELETE);
-	if (r)
-		return r;
-
-	kvm_free_memslot(kvm, old);
-	return 0;
+	return kvm_set_memslot(kvm, mem, old, &new, as_id, KVM_MR_DELETE);
 }
 
 /*
@@ -1749,12 +1719,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
 		return -EINVAL;
 
-	/*
-	 * Make a full copy of the old memslot, the pointer will become stale
-	 * when the memslots are re-sorted by update_memslots(), and the old
-	 * memslot needs to be referenced after calling update_memslots(), e.g.
-	 * to free its resources and for arch specific behavior.
-	 */
 	tmp = id_to_memslot(__kvm_memslots(kvm, as_id), id);
 	if (tmp) {
 		old = *tmp;
@@ -1800,8 +1764,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	}
 
 	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
+		int bkt;
+
 		/* Check for overlaps */
-		kvm_for_each_memslot(tmp, __kvm_memslots(kvm, as_id)) {
+		kvm_for_each_memslot(tmp, bkt, __kvm_memslots(kvm, as_id)) {
 			if (tmp->id == id)
 				continue;
 			if (!((new.base_gfn + new.npages <= tmp->base_gfn) ||
@@ -2138,21 +2104,30 @@ EXPORT_SYMBOL_GPL(gfn_to_memslot);
 struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 	struct kvm_memslots *slots = kvm_vcpu_memslots(vcpu);
+	u64 gen = slots->generation;
 	struct kvm_memory_slot *slot;
-	int slot_index;
 
-	slot = try_get_memslot(slots, vcpu->last_used_slot, gfn);
+	/*
+	 * This also protects against using a memslot from a different address space,
+	 * since different address spaces have different generation numbers.
+	 */
+	if (unlikely(gen != vcpu->last_used_slot_gen)) {
+		vcpu->last_used_slot = NULL;
+		vcpu->last_used_slot_gen = gen;
+	}
+
+	slot = try_get_memslot(vcpu->last_used_slot, gfn);
 	if (slot)
 		return slot;
 
 	/*
 	 * Fall back to searching all memslots. We purposely use
 	 * search_memslots() instead of __gfn_to_memslot() to avoid
-	 * thrashing the VM-wide last_used_index in kvm_memslots.
+	 * thrashing the VM-wide last_used_slot in kvm_memslots.
 	 */
-	slot = search_memslots(slots, gfn, &slot_index, false);
+	slot = search_memslots(slots, gfn, false);
 	if (slot) {
-		vcpu->last_used_slot = slot_index;
+		vcpu->last_used_slot = slot;
 		return slot;
 	}
 
