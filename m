Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623DB35E18F
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 16:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243927AbhDMOdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 10:33:05 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:49616 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346457AbhDMOb5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 10:31:57 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.93.0.4)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1lWJkh-000405-R8; Tue, 13 Apr 2021 16:10:51 +0200
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
Subject: [PATCH v2 6/8] KVM: Keep memslots in tree-based structures instead of array-based ones
Date:   Tue, 13 Apr 2021 16:10:12 +0200
Message-Id: <645d94e2fac60a51a7b976d404cd7c942f072876.1618322004.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1618322001.git.maciej.szmigiero@oracle.com>
References: <cover.1618322001.git.maciej.szmigiero@oracle.com>
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

The "lru slot" mini-cache, that keeps track of the last found-by-gfn
memslot, is still present in the new code.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/arm64/kvm/mmu.c                |  12 +-
 arch/mips/kvm/mmu.c                 |   4 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c |   8 +-
 arch/powerpc/kvm/book3s_hv.c        |   3 +-
 arch/powerpc/kvm/book3s_hv_nested.c |   4 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c  |  14 +-
 arch/powerpc/kvm/book3s_pr.c        |   4 +-
 arch/s390/kvm/kvm-s390.c            |  27 +-
 arch/s390/kvm/kvm-s390.h            |   7 +-
 arch/x86/kvm/mmu/mmu.c              |   8 +-
 arch/x86/kvm/mmu/tdp_mmu.c          |   4 +-
 include/linux/kvm_host.h            | 100 ++---
 virt/kvm/kvm_main.c                 | 576 ++++++++++++++--------------
 13 files changed, 394 insertions(+), 377 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4b0ac98a5a53..f6d571280c27 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -161,13 +161,13 @@ static void stage2_flush_vm(struct kvm *kvm)
 {
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
-	int idx;
+	int idx, ctr;
 
 	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
 
 	slots = kvm_memslots(kvm);
-	kvm_for_each_memslot(memslot, slots)
+	kvm_for_each_memslot(memslot, ctr, slots)
 		stage2_flush_memslot(kvm, memslot);
 
 	spin_unlock(&kvm->mmu_lock);
@@ -452,14 +452,14 @@ void stage2_unmap_vm(struct kvm *kvm)
 {
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
-	int idx;
+	int idx, ctr;
 
 	idx = srcu_read_lock(&kvm->srcu);
 	mmap_read_lock(current->mm);
 	spin_lock(&kvm->mmu_lock);
 
 	slots = kvm_memslots(kvm);
-	kvm_for_each_memslot(memslot, slots)
+	kvm_for_each_memslot(memslot, ctr, slots)
 		stage2_unmap_memslot(kvm, memslot);
 
 	spin_unlock(&kvm->mmu_lock);
@@ -1073,6 +1073,7 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 			     void *data)
 {
 	struct kvm_memslots *slots;
+	int idxactive;
 	struct interval_tree_node *node;
 	struct kvm_memory_slot *memslot;
 	int ret = 0;
@@ -1081,6 +1082,7 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 		return 0;
 
 	slots = kvm_memslots(kvm);
+	idxactive = kvm_memslots_idx(slots);
 
 	/* we only care about the pages that the guest sees */
 	kvm_for_each_hva_range_memslot(node, slots, start, end - 1) {
@@ -1088,7 +1090,7 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 		gfn_t gpa;
 
 		memslot = container_of(node, struct kvm_memory_slot,
-				       hva_node);
+				       hva_node[idxactive]);
 		hva_start = max(start, memslot->userspace_addr);
 		hva_end = min(end, memslot->userspace_addr +
 					(memslot->npages << PAGE_SHIFT));
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index 0c7c48f08ec2..a3b2589081eb 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -449,6 +449,7 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 			     void *data)
 {
 	struct kvm_memslots *slots;
+	int idxactive;
 	struct interval_tree_node *node;
 	struct kvm_memory_slot *memslot;
 	int ret = 0;
@@ -457,6 +458,7 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 		return 0;
 
 	slots = kvm_memslots(kvm);
+	idxactive = kvm_memslots_idx(slots);
 
 	/* we only care about the pages that the guest sees */
 	kvm_for_each_hva_range_memslot(node, slots, start, end - 1) {
@@ -464,7 +466,7 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 		gfn_t gfn, gfn_end;
 
 		memslot = container_of(node, struct kvm_memory_slot,
-				       hva_node);
+				       hva_node[idxactive]);
 		hva_start = max(start, memslot->userspace_addr);
 		hva_end = min(end, memslot->userspace_addr +
 					(memslot->npages << PAGE_SHIFT));
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index fca2a978617c..7133bfb58e9c 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -734,11 +734,11 @@ void kvmppc_rmap_reset(struct kvm *kvm)
 {
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
-	int srcu_idx;
+	int srcu_idx, ctr;
 
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 	slots = kvm_memslots(kvm);
-	kvm_for_each_memslot(memslot, slots) {
+	kvm_for_each_memslot(memslot, ctr, slots) {
 		/* Mutual exclusion with kvm_unmap_hva_range etc. */
 		spin_lock(&kvm->mmu_lock);
 		/*
@@ -763,6 +763,7 @@ static int kvm_handle_hva_range(struct kvm *kvm,
 	int ret;
 	int retval = 0;
 	struct kvm_memslots *slots;
+	int idxactive;
 	struct interval_tree_node *node;
 	struct kvm_memory_slot *memslot;
 
@@ -770,12 +771,13 @@ static int kvm_handle_hva_range(struct kvm *kvm,
 		return 0;
 
 	slots = kvm_memslots(kvm);
+	idxactive = kvm_memslots_idx(slots);
 	kvm_for_each_hva_range_memslot(node, slots, start, end - 1) {
 		unsigned long hva_start, hva_end;
 		gfn_t gfn, gfn_end;
 
 		memslot = container_of(node, struct kvm_memory_slot,
-				       hva_node);
+				       hva_node[idxactive]);
 		hva_start = max(start, memslot->userspace_addr);
 		hva_end = min(end, memslot->userspace_addr +
 					(memslot->npages << PAGE_SHIFT));
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 13bad6bf4c95..1e204ec35908 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5574,11 +5574,12 @@ static int kvmhv_svm_off(struct kvm *kvm)
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		struct kvm_memory_slot *memslot;
 		struct kvm_memslots *slots = __kvm_memslots(kvm, i);
+		int ctr;
 
 		if (!slots)
 			continue;
 
-		kvm_for_each_memslot(memslot, slots) {
+		kvm_for_each_memslot(memslot, ctr, slots) {
 			kvmppc_uvmem_drop_pages(memslot, kvm, true);
 			uv_unregister_mem_slot(kvm->arch.lpid, memslot->id);
 		}
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 0cd0e7aad588..ab7cd857fea3 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -698,7 +698,7 @@ void kvmhv_release_all_nested(struct kvm *kvm)
 	struct kvm_nested_guest *gp;
 	struct kvm_nested_guest *freelist = NULL;
 	struct kvm_memory_slot *memslot;
-	int srcu_idx;
+	int srcu_idx, ctr;
 
 	spin_lock(&kvm->mmu_lock);
 	for (i = 0; i <= kvm->arch.max_nested_lpid; i++) {
@@ -719,7 +719,7 @@ void kvmhv_release_all_nested(struct kvm *kvm)
 	}
 
 	srcu_idx = srcu_read_lock(&kvm->srcu);
-	kvm_for_each_memslot(memslot, kvm_memslots(kvm))
+	kvm_for_each_memslot(memslot, ctr, kvm_memslots(kvm))
 		kvmhv_free_memslot_nest_rmap(memslot);
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
 }
diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 84e5a2dc8be5..671c8f6d605e 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -458,7 +458,7 @@ unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot, *m;
 	int ret = H_SUCCESS;
-	int srcu_idx;
+	int srcu_idx, ctr;
 
 	kvm->arch.secure_guest = KVMPPC_SECURE_INIT_START;
 
@@ -477,7 +477,7 @@ unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
 
 	/* register the memslot */
 	slots = kvm_memslots(kvm);
-	kvm_for_each_memslot(memslot, slots) {
+	kvm_for_each_memslot(memslot, ctr, slots) {
 		ret = __kvmppc_uvmem_memslot_create(kvm, memslot);
 		if (ret)
 			break;
@@ -485,7 +485,7 @@ unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
 
 	if (ret) {
 		slots = kvm_memslots(kvm);
-		kvm_for_each_memslot(m, slots) {
+		kvm_for_each_memslot(m, ctr, slots) {
 			if (m == memslot)
 				break;
 			__kvmppc_uvmem_memslot_delete(kvm, memslot);
@@ -646,7 +646,7 @@ void kvmppc_uvmem_drop_pages(const struct kvm_memory_slot *slot,
 
 unsigned long kvmppc_h_svm_init_abort(struct kvm *kvm)
 {
-	int srcu_idx;
+	int srcu_idx, ctr;
 	struct kvm_memory_slot *memslot;
 
 	/*
@@ -661,7 +661,7 @@ unsigned long kvmppc_h_svm_init_abort(struct kvm *kvm)
 
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 
-	kvm_for_each_memslot(memslot, kvm_memslots(kvm))
+	kvm_for_each_memslot(memslot, ctr, kvm_memslots(kvm))
 		kvmppc_uvmem_drop_pages(memslot, kvm, false);
 
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
@@ -820,7 +820,7 @@ unsigned long kvmppc_h_svm_init_done(struct kvm *kvm)
 {
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
-	int srcu_idx;
+	int srcu_idx, ctr;
 	long ret = H_SUCCESS;
 
 	if (!(kvm->arch.secure_guest & KVMPPC_SECURE_INIT_START))
@@ -829,7 +829,7 @@ unsigned long kvmppc_h_svm_init_done(struct kvm *kvm)
 	/* migrate any unmoved normal pfn to device pfns*/
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 	slots = kvm_memslots(kvm);
-	kvm_for_each_memslot(memslot, slots) {
+	kvm_for_each_memslot(memslot, ctr, slots) {
 		ret = kvmppc_uv_migrate_mem_slot(kvm, memslot);
 		if (ret) {
 			/*
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index d0a7127403f0..52040aaef3cc 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -431,6 +431,7 @@ static void do_kvm_unmap_hva(struct kvm *kvm, unsigned long start,
 	long i;
 	struct kvm_vcpu *vcpu;
 	struct kvm_memslots *slots;
+	int idxactive;
 	struct interval_tree_node *node;
 	struct kvm_memory_slot *memslot;
 
@@ -438,12 +439,13 @@ static void do_kvm_unmap_hva(struct kvm *kvm, unsigned long start,
 		return;
 
 	slots = kvm_memslots(kvm);
+	idxactive = kvm_memslots_idx(slots);
 	kvm_for_each_hva_range_memslot(node, slots, start, end - 1) {
 		unsigned long hva_start, hva_end;
 		gfn_t gfn, gfn_end;
 
 		memslot = container_of(node, struct kvm_memory_slot,
-				       hva_node);
+				       hva_node[idxactive]);
 		hva_start = max(start, memslot->userspace_addr);
 		hva_end = min(end, memslot->userspace_addr +
 					(memslot->npages << PAGE_SHIFT));
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 4445c99eb00e..9a5570cfe863 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1006,13 +1006,13 @@ static int kvm_s390_vm_start_migration(struct kvm *kvm)
 	struct kvm_memory_slot *ms;
 	struct kvm_memslots *slots;
 	unsigned long ram_pages = 0;
-	int slotnr;
+	int ctr;
 
 	/* migration mode already enabled */
 	if (kvm->arch.migration_mode)
 		return 0;
 	slots = kvm_memslots(kvm);
-	if (!slots || !slots->used_slots)
+	if (!slots || kvm_memslots_empty(slots))
 		return -EINVAL;
 
 	if (!kvm->arch.use_cmma) {
@@ -1020,8 +1020,7 @@ static int kvm_s390_vm_start_migration(struct kvm *kvm)
 		return 0;
 	}
 	/* mark all the pages in active slots as dirty */
-	for (slotnr = 0; slotnr < slots->used_slots; slotnr++) {
-		ms = slots->memslots + slotnr;
+	kvm_for_each_memslot(ms, ctr, slots) {
 		if (!ms->dirty_bitmap)
 			return -EINVAL;
 		/*
@@ -1939,22 +1938,24 @@ static unsigned long kvm_s390_next_dirty_cmma(struct kvm_memslots *slots,
 					      unsigned long cur_gfn)
 {
 	struct kvm_memory_slot *ms = search_memslots(slots, cur_gfn, true);
-	int slotidx = ms - slots->memslots;
 	unsigned long ofs = cur_gfn - ms->base_gfn;
+	int idxactive = kvm_memslots_idx(slots);
+	struct rb_node *mnode = &ms->gfn_node[idxactive];
 
 	if (ms->base_gfn + ms->npages <= cur_gfn) {
-		slotidx--;
+		mnode = rb_next(mnode);
 		/* If we are above the highest slot, wrap around */
-		if (slotidx < 0)
-			slotidx = slots->used_slots - 1;
+		if (!mnode)
+			mnode = rb_first(&slots->gfn_tree);
 
-		ms = slots->memslots + slotidx;
+		ms = container_of(mnode, struct kvm_memory_slot,
+				  gfn_node[idxactive]);
 		ofs = 0;
 	}
 	ofs = find_next_bit(kvm_second_dirty_bitmap(ms), ms->npages, ofs);
-	while ((slotidx > 0) && (ofs >= ms->npages)) {
-		slotidx--;
-		ms = slots->memslots + slotidx;
+	while (ofs >= ms->npages && (mnode = rb_next(mnode))) {
+		ms = container_of(mnode, struct kvm_memory_slot,
+				  gfn_node[idxactive]);
 		ofs = find_next_bit(kvm_second_dirty_bitmap(ms), ms->npages, 0);
 	}
 	return ms->base_gfn + ofs;
@@ -1967,7 +1968,7 @@ static int kvm_s390_get_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	struct kvm_memory_slot *ms;
 
-	if (unlikely(!slots->used_slots))
+	if (unlikely(kvm_memslots_empty(slots)))
 		return 0;
 
 	cur_gfn = kvm_s390_next_dirty_cmma(slots, args->start_gfn);
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 96537370ce8c..fa0215fed66e 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -211,12 +211,15 @@ static inline int kvm_s390_user_cpu_state_ctrl(struct kvm *kvm)
 /* get the end gfn of the last (highest gfn) memslot */
 static inline unsigned long kvm_s390_get_gfn_end(struct kvm_memslots *slots)
 {
+	struct rb_node *node;
+	int idxactive = kvm_memslots_idx(slots);
 	struct kvm_memory_slot *ms;
 
-	if (WARN_ON(!slots->used_slots))
+	if (WARN_ON(kvm_memslots_empty(slots)))
 		return 0;
 
-	ms = slots->memslots;
+	node = rb_last(&slots->gfn_tree);
+	ms = container_of(node, struct kvm_memory_slot, gfn_node[idxactive]);
 	return ms->base_gfn + ms->npages;
 }
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 75fa497aa27f..74781c00a420 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1434,15 +1434,17 @@ static __always_inline int kvm_handle_hva_range(struct kvm *kvm,
 		return 0;
 
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		int idxactive;
 		struct interval_tree_node *node;
 
 		slots = __kvm_memslots(kvm, i);
+		idxactive = kvm_memslots_idx(slots);
 		kvm_for_each_hva_range_memslot(node, slots, start, end - 1) {
 			unsigned long hva_start, hva_end;
 			gfn_t gfn_start, gfn_end;
 
 			memslot = container_of(node, struct kvm_memory_slot,
-					       hva_node);
+					       hva_node[idxactive]);
 			hva_start = max(start, memslot->userspace_addr);
 			hva_end = min(end, memslot->userspace_addr +
 				      (memslot->npages << PAGE_SHIFT));
@@ -5498,8 +5500,10 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	write_lock(&kvm->mmu_lock);
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		int ctr;
+
 		slots = __kvm_memslots(kvm, i);
-		kvm_for_each_memslot(memslot, slots) {
+		kvm_for_each_memslot(memslot, ctr, slots) {
 			gfn_t start, end;
 
 			start = max(gfn_start, memslot->base_gfn);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 69683028763c..68b0996f8023 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -894,9 +894,11 @@ static __always_inline int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm,
 
 	for (as_id = 0; as_id < KVM_ADDRESS_SPACE_NUM; as_id++) {
 		for_each_tdp_mmu_root_yield_safe(kvm, root, as_id) {
+			int idxactive;
 			struct interval_tree_node *node;
 
 			slots = __kvm_memslots(kvm, as_id);
+			idxactive = kvm_memslots_idx(slots);
 			kvm_for_each_hva_range_memslot(node, slots,
 						       start, end - 1) {
 				unsigned long hva_start, hva_end;
@@ -904,7 +906,7 @@ static __always_inline int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm,
 
 				memslot = container_of(node,
 						       struct kvm_memory_slot,
-						       hva_node);
+						       hva_node[idxactive]);
 				hva_start = max(start, memslot->userspace_addr);
 				hva_end = min(end, memslot->userspace_addr +
 					(memslot->npages << PAGE_SHIFT));
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b8196cbd2c6f..bb50776a5ebd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -29,6 +29,7 @@
 #include <linux/nospec.h>
 #include <linux/interval_tree.h>
 #include <linux/hashtable.h>
+#include <linux/rbtree.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -352,8 +353,9 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
 #define KVM_MEM_MAX_NR_PAGES ((1UL << 31) - 1)
 
 struct kvm_memory_slot {
-	struct hlist_node id_node;
-	struct interval_tree_node hva_node;
+	struct hlist_node id_node[2];
+	struct interval_tree_node hva_node[2];
+	struct rb_node gfn_node[2];
 	gfn_t base_gfn;
 	unsigned long npages;
 	unsigned long *dirty_bitmap;
@@ -448,19 +450,14 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 }
 #endif
 
-/*
- * Note:
- * memslots are not sorted by id anymore, please use id_to_memslot()
- * to get the memslot by its id.
- */
 struct kvm_memslots {
 	u64 generation;
+	atomic_long_t lru_slot;
 	struct rb_root_cached hva_tree;
-	/* The mapping table from slot id to the index in memslots[]. */
+	struct rb_root gfn_tree;
+	/* The mapping table from slot id to memslot. */
 	DECLARE_HASHTABLE(id_hash, 7);
-	atomic_t lru_slot;
-	int used_slots;
-	struct kvm_memory_slot memslots[];
+	bool is_idx_0;
 };
 
 struct kvm {
@@ -472,6 +469,7 @@ struct kvm {
 
 	struct mutex slots_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
+	struct kvm_memslots memslots_all[KVM_ADDRESS_SPACE_NUM][2];
 	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 
@@ -611,12 +609,6 @@ static inline int kvm_vcpu_get_idx(struct kvm_vcpu *vcpu)
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
@@ -676,6 +668,22 @@ static inline struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu)
 	return __kvm_memslots(vcpu->kvm, as_id);
 }
 
+static inline bool kvm_memslots_empty(struct kvm_memslots *slots)
+{
+	return RB_EMPTY_ROOT(&slots->gfn_tree);
+}
+
+static inline int kvm_memslots_idx(struct kvm_memslots *slots)
+{
+	return slots->is_idx_0 ? 0 : 1;
+}
+
+#define kvm_for_each_memslot(memslot, ctr, slots)	\
+	hash_for_each(slots->id_hash, ctr, memslot,	\
+		      id_node[kvm_memslots_idx(slots)]) \
+		if (WARN_ON_ONCE(!memslot->npages)) {	\
+		} else
+
 #define kvm_for_each_hva_range_memslot(node, slots, start, last)	     \
 	for (node = interval_tree_iter_first(&slots->hva_tree, start, last); \
 	     node;							     \
@@ -684,9 +692,10 @@ static inline struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu)
 static inline
 struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
 {
+	int idxactive = kvm_memslots_idx(slots);
 	struct kvm_memory_slot *slot;
 
-	hash_for_each_possible(slots->id_hash, slot, id_node, id) {
+	hash_for_each_possible(slots->id_hash, slot, id_node[idxactive], id) {
 		if (slot->id == id)
 			return slot;
 	}
@@ -1095,42 +1104,39 @@ bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
  * With "approx" set returns the memslot also when the address falls
  * in a hole. In that case one of the memslots bordering the hole is
  * returned.
- *
- * IMPORTANT: Slots are sorted from highest GFN to lowest GFN!
  */
 static inline struct kvm_memory_slot *
 search_memslots(struct kvm_memslots *slots, gfn_t gfn, bool approx)
 {
-	int start = 0, end = slots->used_slots;
-	int slot = atomic_read(&slots->lru_slot);
-	struct kvm_memory_slot *memslots = slots->memslots;
-
-	if (unlikely(!slots->used_slots))
-		return NULL;
-
-	if (gfn >= memslots[slot].base_gfn &&
-	    gfn < memslots[slot].base_gfn + memslots[slot].npages)
-		return &memslots[slot];
-
-	while (start < end) {
-		slot = start + (end - start) / 2;
-
-		if (gfn >= memslots[slot].base_gfn)
-			end = slot;
-		else
-			start = slot + 1;
+	int idxactive = kvm_memslots_idx(slots);
+	struct kvm_memory_slot *slot;
+	struct rb_node *prevnode, *node;
+
+	slot = (struct kvm_memory_slot *)atomic_long_read(&slots->lru_slot);
+	if (slot &&
+	    gfn >= slot->base_gfn && gfn < slot->base_gfn + slot->npages)
+		return slot;
+
+	for (prevnode = NULL, node = slots->gfn_tree.rb_node; node; ) {
+		prevnode = node;
+		slot = container_of(node, struct kvm_memory_slot,
+				    gfn_node[idxactive]);
+		if (gfn >= slot->base_gfn) {
+			if (gfn < slot->base_gfn + slot->npages) {
+				atomic_long_set(&slots->lru_slot,
+						(unsigned long)slot);
+				return slot;
+			}
+			node = node->rb_right;
+		} else
+			node = node->rb_left;
 	}
 
-	if (approx && start >= slots->used_slots)
-		return &memslots[slots->used_slots - 1];
+	if (approx && prevnode)
+		return container_of(prevnode, struct kvm_memory_slot,
+				    gfn_node[idxactive]);
 
-	if (start < slots->used_slots && gfn >= memslots[start].base_gfn &&
-	    gfn < memslots[start].base_gfn + memslots[start].npages) {
-		atomic_set(&slots->lru_slot, start);
-		return &memslots[start];
-	}
-
-	return approx ? &memslots[start] : NULL;
+	return NULL;
 }
 
 static inline struct kvm_memory_slot *
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 37b44cde9ae7..a027686657a6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -654,18 +654,12 @@ static int kvm_init_mmu_notifier(struct kvm *kvm)
 
 #endif /* CONFIG_MMU_NOTIFIER && KVM_ARCH_WANT_MMU_NOTIFIER */
 
-static struct kvm_memslots *kvm_alloc_memslots(void)
+static void kvm_init_memslots(struct kvm_memslots *slots)
 {
-	struct kvm_memslots *slots;
-
-	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
-	if (!slots)
-		return NULL;
-
+	atomic_long_set(&slots->lru_slot, (unsigned long)NULL);
 	slots->hva_tree = RB_ROOT_CACHED;
+	slots->gfn_tree = RB_ROOT;
 	hash_init(slots->id_hash);
-
-	return slots;
 }
 
 static void kvm_destroy_dirty_bitmap(struct kvm_memory_slot *memslot)
@@ -677,27 +671,31 @@ static void kvm_destroy_dirty_bitmap(struct kvm_memory_slot *memslot)
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
+	int ctr;
+	struct hlist_node *idnode;
 	struct kvm_memory_slot *memslot;
 
-	if (!slots)
+	/*
+	 * Both active and inactive struct kvm_memslots should point to
+	 * the same set of memslots, so it's enough to free them once
+	 */
+	if (slots->is_idx_0)
 		return;
 
-	kvm_for_each_memslot(memslot, slots)
+	hash_for_each_safe(slots->id_hash, ctr, idnode, memslot, id_node[1])
 		kvm_free_memslot(kvm, memslot);
-
-	kvfree(slots);
 }
 
 static void kvm_destroy_vm_debugfs(struct kvm *kvm)
@@ -793,13 +791,14 @@ static struct kvm *kvm_create_vm(unsigned long type)
 
 	refcount_set(&kvm->users_count, 1);
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
-		struct kvm_memslots *slots = kvm_alloc_memslots();
+		kvm_init_memslots(&kvm->memslots_all[i][0]);
+		kvm_init_memslots(&kvm->memslots_all[i][1]);
+		kvm->memslots_all[i][0].is_idx_0 = true;
+		kvm->memslots_all[i][1].is_idx_0 = false;
 
-		if (!slots)
-			goto out_err_no_arch_destroy_vm;
 		/* Generations must be different for each address space. */
-		slots->generation = i;
-		rcu_assign_pointer(kvm->memslots[i], slots);
+		kvm->memslots_all[i][0].generation = i;
+		rcu_assign_pointer(kvm->memslots[i], &kvm->memslots_all[i][0]);
 	}
 
 	for (i = 0; i < KVM_NR_BUSES; i++) {
@@ -852,8 +851,6 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
 	for (i = 0; i < KVM_NR_BUSES; i++)
 		kfree(kvm_get_bus(kvm, i));
-	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-		kvm_free_memslots(kvm, __kvm_memslots(kvm, i));
 	cleanup_srcu_struct(&kvm->irq_srcu);
 out_err_no_irq_srcu:
 	cleanup_srcu_struct(&kvm->srcu);
@@ -907,8 +904,10 @@ static void kvm_destroy_vm(struct kvm *kvm)
 #endif
 	kvm_arch_destroy_vm(kvm);
 	kvm_destroy_devices(kvm);
-	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-		kvm_free_memslots(kvm, __kvm_memslots(kvm, i));
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		kvm_free_memslots(kvm, &kvm->memslots_all[i][0]);
+		kvm_free_memslots(kvm, &kvm->memslots_all[i][1]);
+	}
 	cleanup_srcu_struct(&kvm->irq_srcu);
 	cleanup_srcu_struct(&kvm->srcu);
 	kvm_arch_free_vm(kvm);
@@ -968,212 +967,6 @@ static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
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
-	struct kvm_memory_slot *dmemslot = id_to_memslot(slots, memslot->id);
-	int i;
-
-	if (WARN_ON(!dmemslot))
-		return;
-
-	slots->used_slots--;
-
-	if (atomic_read(&slots->lru_slot) >= slots->used_slots)
-		atomic_set(&slots->lru_slot, 0);
-
-	for (i = dmemslot - mslots; i < slots->used_slots; i++) {
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
-	if (WARN_ON_ONCE(!mmemslot) ||
-	    WARN_ON_ONCE(!slots->used_slots))
-		return -1;
-
-	/*
-	 * update_memslots() will unconditionally overwrite and re-add the
-	 * target memslot so it has to be removed here first
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
-		if (i < 0)
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
@@ -1188,10 +981,12 @@ static int check_memory_region_flags(const struct kvm_userspace_memory_region *m
 	return 0;
 }
 
-static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
-		int as_id, struct kvm_memslots *slots)
+static void swap_memslots(struct kvm *kvm, int as_id)
 {
 	struct kvm_memslots *old_memslots = __kvm_memslots(kvm, as_id);
+	int idxactive = kvm_memslots_idx(old_memslots);
+	int idxina = idxactive == 0 ? 1 : 0;
+	struct kvm_memslots *slots = &kvm->memslots_all[as_id][idxina];
 	u64 gen = old_memslots->generation;
 
 	WARN_ON(gen & KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS);
@@ -1220,44 +1015,129 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 	kvm_arch_memslots_updated(kvm, gen);
 
 	slots->generation = gen;
+}
+
+static void kvm_memslot_gfn_insert(struct rb_root *gfn_tree,
+				  struct kvm_memory_slot *slot,
+				  int which)
+{
+	struct rb_node **cur, *parent;
+
+	for (cur = &gfn_tree->rb_node, parent = NULL; *cur; ) {
+		struct kvm_memory_slot *cslot;
+
+		cslot = container_of(*cur, typeof(*cslot), gfn_node[which]);
+		parent = *cur;
+		if (slot->base_gfn < cslot->base_gfn)
+			cur = &(*cur)->rb_left;
+		else if (slot->base_gfn > cslot->base_gfn)
+			cur = &(*cur)->rb_right;
+		else
+			BUG();
+	}
 
-	return old_memslots;
+	rb_link_node(&slot->gfn_node[which], parent, cur);
+	rb_insert_color(&slot->gfn_node[which], gfn_tree);
 }
 
 /*
- * Note, at a minimum, the current number of used slots must be allocated, even
- * when deleting a memslot, as we need a complete duplicate of the memslots for
- * use when invalidating a memslot prior to deleting/moving the memslot.
+ * Just copies the memslot data.
+ * Does not copy or touch the embedded nodes, including the ranges at hva_nodes.
  */
-static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
-					     enum kvm_mr_change change)
+static void kvm_copy_memslot(struct kvm_memory_slot *dest,
+			     struct kvm_memory_slot *src)
 {
-	struct kvm_memslots *slots;
-	size_t old_size, new_size;
-	struct kvm_memory_slot *memslot;
+	dest->base_gfn = src->base_gfn;
+	dest->npages = src->npages;
+	dest->dirty_bitmap = src->dirty_bitmap;
+	dest->arch = src->arch;
+	dest->userspace_addr = src->userspace_addr;
+	dest->flags = src->flags;
+	dest->id = src->id;
+	dest->as_id = src->as_id;
+}
 
-	old_size = sizeof(struct kvm_memslots) +
-		   (sizeof(struct kvm_memory_slot) * old->used_slots);
+/*
+ * Initializes the ranges at both hva_nodes from the memslot userspace_addr
+ * and npages fields.
+ */
+static void kvm_init_memslot_hva_ranges(struct kvm_memory_slot *slot)
+{
+	slot->hva_node[0].start = slot->hva_node[1].start =
+		slot->userspace_addr;
+	slot->hva_node[0].last = slot->hva_node[1].last =
+		slot->userspace_addr + (slot->npages << PAGE_SHIFT) - 1;
+}
 
-	if (change == KVM_MR_CREATE)
-		new_size = old_size + sizeof(struct kvm_memory_slot);
-	else
-		new_size = old_size;
+/*
+ * Replaces the @oldslot with @nslot in the memslot set indicated by
+ * @slots_idx.
+ *
+ * With NULL @oldslot this simply adds the @nslot to the set.
+ * With NULL @nslot this simply removes the @oldslot from the set.
+ *
+ * If @nslot is non-NULL its hva_node[slots_idx] range has to be set
+ * appropriately.
+ */
+static void kvm_replace_memslot(struct kvm *kvm,
+				int as_id, int slots_idx,
+				struct kvm_memory_slot *oldslot,
+				struct kvm_memory_slot *nslot)
+{
+	struct kvm_memslots *slots = &kvm->memslots_all[as_id][slots_idx];
 
-	slots = kvzalloc(new_size, GFP_KERNEL_ACCOUNT);
-	if (unlikely(!slots))
-		return NULL;
+	if (WARN_ON(!oldslot && !nslot))
+		return;
 
-	memcpy(slots, old, old_size);
+	if (oldslot) {
+		hash_del(&oldslot->id_node[slots_idx]);
+		interval_tree_remove(&oldslot->hva_node[slots_idx],
+				     &slots->hva_tree);
+		atomic_long_cmpxchg(&slots->lru_slot,
+				    (unsigned long)oldslot,
+				    (unsigned long)nslot);
+		if (!nslot) {
+			rb_erase(&oldslot->gfn_node[slots_idx],
+				 &slots->gfn_tree);
+			return;
+		}
+	}
 
-	slots->hva_tree = RB_ROOT_CACHED;
-	hash_init(slots->id_hash);
-	kvm_for_each_memslot(memslot, slots) {
-		interval_tree_insert(&memslot->hva_node, &slots->hva_tree);
-		hash_add(slots->id_hash, &memslot->id_node, memslot->id);
+	hash_add(slots->id_hash, &nslot->id_node[slots_idx],
+		 nslot->id);
+	WARN_ON(PAGE_SHIFT > 0 &&
+		nslot->hva_node[slots_idx].start >=
+		nslot->hva_node[slots_idx].last);
+	interval_tree_insert(&nslot->hva_node[slots_idx],
+			     &slots->hva_tree);
+
+	/* Shame there is no O(1) interval_tree_replace()... */
+	if (oldslot && oldslot->base_gfn == nslot->base_gfn)
+		rb_replace_node(&oldslot->gfn_node[slots_idx],
+				&nslot->gfn_node[slots_idx],
+				&slots->gfn_tree);
+	else {
+		if (oldslot)
+			rb_erase(&oldslot->gfn_node[slots_idx],
+				 &slots->gfn_tree);
+		kvm_memslot_gfn_insert(&slots->gfn_tree,
+				       nslot, slots_idx);
 	}
+}
 
-	return slots;
+/*
+ * Copies the @oldslot data into @nslot and uses this slot to replace
+ * @oldslot in the memslot set indicated by @slots_idx.
+ */
+static void kvm_copy_replace_memslot(struct kvm *kvm,
+				     int as_id, int slots_idx,
+				     struct kvm_memory_slot *oldslot,
+				     struct kvm_memory_slot *nslot)
+{
+	kvm_copy_memslot(nslot, oldslot);
+	kvm_init_memslot_hva_ranges(nslot);
+
+	kvm_replace_memslot(kvm, as_id, slots_idx, oldslot, nslot);
 }
 
 static int kvm_set_memslot(struct kvm *kvm,
@@ -1266,56 +1146,178 @@ static int kvm_set_memslot(struct kvm *kvm,
 			   struct kvm_memory_slot *new, int as_id,
 			   enum kvm_mr_change change)
 {
-	struct kvm_memory_slot *slot;
-	struct kvm_memslots *slots;
+	struct kvm_memslots *slotsact = __kvm_memslots(kvm, as_id);
+	int idxact = kvm_memslots_idx(slotsact);
+	int idxina = idxact == 0 ? 1 : 0;
+	struct kvm_memslots *slotsina = &kvm->memslots_all[as_id][idxina];
+	struct kvm_memory_slot *slotina, *slotact;
 	int r;
 
-	slots = kvm_dup_memslots(__kvm_memslots(kvm, as_id), change);
-	if (!slots)
+	slotina = kzalloc(sizeof(*slotina), GFP_KERNEL_ACCOUNT);
+	if (!slotina)
 		return -ENOMEM;
 
+	if (change != KVM_MR_CREATE)
+		slotact = id_to_memslot(slotsact, old->id);
+
 	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
 		/*
-		 * Note, the INVALID flag needs to be in the appropriate entry
-		 * in the freshly allocated memslots, not in @old or @new.
+		 * Replace the slot to be deleted or moved in the inactive
+		 * memslot set by its copy with KVM_MEMSLOT_INVALID flag set.
 		 */
-		slot = id_to_memslot(slots, old->id);
-		slot->flags |= KVM_MEMSLOT_INVALID;
+		kvm_copy_replace_memslot(kvm, as_id, idxina, slotact, slotina);
+		slotina->flags |= KVM_MEMSLOT_INVALID;
 
 		/*
-		 * We can re-use the old memslots, the only difference from the
-		 * newly installed memslots is the invalid flag, which will get
-		 * dropped by update_memslots anyway.  We'll also revert to the
-		 * old memslots if preparing the new memory region fails.
+		 * Swap the active <-> inactive memslot set.
+		 * Now the active memslot set still contains the memslot to be
+		 * deleted or moved, but with the KVM_MEMSLOT_INVALID flag set.
 		 */
-		slots = install_new_memslots(kvm, as_id, slots);
+		swap_memslots(kvm, as_id);
+		swap(idxact, idxina);
+		swap(slotsina, slotsact);
+		swap(slotact, slotina);
 
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
 	}
 
 	r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
 	if (r)
 		goto out_slots;
 
-	update_memslots(slots, new, change);
-	slots = install_new_memslots(kvm, as_id, slots);
+	if (change == KVM_MR_MOVE) {
+		/*
+		 * Since we are going to be changing the memslot gfn we need to
+		 * remove it from the gfn tree so it can be re-added there with
+		 * the updated gfn.
+		 */
+		rb_erase(&slotina->gfn_node[idxina],
+			 &slotsina->gfn_tree);
+
+		slotina->base_gfn = new->base_gfn;
+		slotina->flags = new->flags;
+		slotina->dirty_bitmap = new->dirty_bitmap;
+		/* kvm_arch_prepare_memory_region() might have modified arch */
+		slotina->arch = new->arch;
+
+		/* Re-add to the gfn tree with the updated gfn */
+		kvm_memslot_gfn_insert(&slotsina->gfn_tree,
+				       slotina, idxina);
+
+		/*
+		 * Swap the active <-> inactive memslot set.
+		 * Now the active memslot set contains the new, final memslot.
+		 */
+		swap_memslots(kvm, as_id);
+		swap(idxact, idxina);
+		swap(slotsina, slotsact);
+		swap(slotact, slotina);
+
+		/*
+		 * Replace the temporary KVM_MEMSLOT_INVALID slot with the
+		 * new, final memslot in the inactive memslot set and
+		 * free the temporary memslot.
+		 */
+		kvm_replace_memslot(kvm, as_id, idxina, slotina, slotact);
+		kfree(slotina);
+	} else if (change == KVM_MR_FLAGS_ONLY) {
+		/*
+		 * Almost like the move case above, but we don't use a temporary
+		 * KVM_MEMSLOT_INVALID slot.
+		 * Instead, we simply replace the old memslot with a new, updated
+		 * copy in both memslot sets.
+		 *
+		 * Since we aren't going to be changing the memslot gfn we can
+		 * simply use kvm_copy_replace_memslot(), which will use
+		 * rb_replace_node() to switch the memslot node in the gfn tree
+		 * instead of removing the old one and inserting the new one
+		 * as two separate operations.
+		 * It's a performance win since node replacement is a single
+		 * O(1) operation as opposed to two O(log(n)) operations for
+		 * slot removal and then re-insertion.
+		 */
+		kvm_copy_replace_memslot(kvm, as_id, idxina, slotact, slotina);
+		slotina->flags = new->flags;
+		slotina->dirty_bitmap = new->dirty_bitmap;
+		/* kvm_arch_prepare_memory_region() might have modified arch */
+		slotina->arch = new->arch;
+
+		/* Swap the active <-> inactive memslot set. */
+		swap_memslots(kvm, as_id);
+		swap(idxact, idxina);
+		swap(slotsina, slotsact);
+		swap(slotact, slotina);
+
+		/*
+		 * Replace the old memslot in the other memslot set and
+		 * then finally free it.
+		 */
+		kvm_replace_memslot(kvm, as_id, idxina, slotina, slotact);
+		kfree(slotina);
+	} else if (change == KVM_MR_CREATE) {
+		/*
+		 * Add the new memslot to the current inactive set as a copy
+		 * of the provided new memslot data.
+		 */
+		kvm_copy_memslot(slotina, new);
+		kvm_init_memslot_hva_ranges(slotina);
+
+		kvm_replace_memslot(kvm, as_id, idxina, NULL, slotina);
+
+		/* Swap the active <-> inactive memslot set. */
+		swap_memslots(kvm, as_id);
+		swap(idxact, idxina);
+		swap(slotsina, slotsact);
+
+		/* Now add it also to the other memslot set */
+		kvm_replace_memslot(kvm, as_id, idxina, NULL, slotina);
+	} else if (change == KVM_MR_DELETE) {
+		/*
+		 * Remove the old memslot from the current inactive set
+		 * (the other, active set contains the temporary
+		 * KVM_MEMSLOT_INVALID slot)
+		 */
+		kvm_replace_memslot(kvm, as_id, idxina, slotina, NULL);
+
+		/* Swap the active <-> inactive memslot set. */
+		swap_memslots(kvm, as_id);
+		swap(idxact, idxina);
+		swap(slotsina, slotsact);
+		swap(slotact, slotina);
+
+		/* Remove the temporary KVM_MEMSLOT_INVALID slot and free it. */
+		kvm_replace_memslot(kvm, as_id, idxina, slotina, NULL);
+		kfree(slotina);
+		/* slotact will be freed by kvm_free_memslot() */
+	} else
+		BUG();
 
 	kvm_arch_commit_memory_region(kvm, mem, old, new, change);
 
-	kvfree(slots);
+	if (change == KVM_MR_DELETE)
+		kvm_free_memslot(kvm, slotact);
+
 	return 0;
 
 out_slots:
-	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
-		slots = install_new_memslots(kvm, as_id, slots);
-	kvfree(slots);
+	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
+		swap_memslots(kvm, as_id);
+		swap(idxact, idxina);
+		swap(slotsina, slotsact);
+		swap(slotact, slotina);
+
+		kvm_replace_memslot(kvm, as_id, idxina, slotina, slotact);
+	}
+	kfree(slotina);
+
 	return r;
 }
 
@@ -1324,7 +1326,6 @@ static int kvm_delete_memslot(struct kvm *kvm,
 			      struct kvm_memory_slot *old, int as_id)
 {
 	struct kvm_memory_slot new;
-	int r;
 
 	if (!old->npages)
 		return -EINVAL;
@@ -1337,12 +1338,7 @@ static int kvm_delete_memslot(struct kvm *kvm,
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
@@ -1385,12 +1381,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
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
@@ -1436,8 +1426,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	}
 
 	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
+		int ctr;
+
 		/* Check for overlaps */
-		kvm_for_each_memslot(tmp, __kvm_memslots(kvm, as_id)) {
+		kvm_for_each_memslot(tmp, ctr, __kvm_memslots(kvm, as_id)) {
 			if (tmp->id == id)
 				continue;
 			if (!((new.base_gfn + new.npages <= tmp->base_gfn) ||
