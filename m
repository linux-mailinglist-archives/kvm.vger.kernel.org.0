Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4823D30A321
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 09:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbhBAIPD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 03:15:03 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:43154 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232290AbhBAIPA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 03:15:00 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.93.0.4)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1l6UL9-0004rZ-90; Mon, 01 Feb 2021 09:13:43 +0100
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
Subject: [PATCH 2/2] KVM: Scalable memslots implementation
Date:   Mon,  1 Feb 2021 09:13:32 +0100
Message-Id: <4d748e0fd50bac68ece6952129aed319502b6853.1612140117.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <ceb96527b6f7bb662eec813f05b897a551ebd0b2.1612140117.git.maciej.szmigiero@oracle.com>
References: <ceb96527b6f7bb662eec813f05b897a551ebd0b2.1612140117.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

The current memslot code uses a (reverse) gfn-ordered memslot array for
keeping track of them.
This only allows quick binary search by gfn, quick lookup by hva is not
possible (the implementation has to do a linear scan of the whole memslot
array).

Because the memslot array that is currently in use cannot be modified
every memslot management operation (create, delete, move, change flags)
has to make a copy of the whole array so it has a scratch copy to work
on.

Strictly speaking, however, it is only necessary to make copy of the
memslot that is being modified, copying all the memslots currently
present is just a limitation of the array-based memslot implementation.

Two memslot sets, however, are still needed so the VM continues to
run on the currently active set while the requested operation is being
performed on the second, currently inactive one.

In order to have two memslot sets, but only one copy of the actual
memslots it is necessary to split out the memslot data from the
memslot sets.

The memslots themselves should be also kept independent of each other
so they can be individually added or deleted.

These two memslot sets should normally point to the same set of
memslots. They can, however, be desynchronized when performing a
memslot management operation by replacing the memslot to be modified
by its copy.
After the operation is complete, both memslot sets once again
point to the same, common set of memslot data.

This commit implements the aforementioned idea.

The new implementation uses two trees to perform quick lookups:
For tracking of gfn an ordinary rbtree is used since memslots cannot
overlap in the guest address space and so this data structure is
sufficient for ensuring that lookups are done quickly.

For tracking of hva, however, an interval tree is needed since they
can overlap between memslots.

ID to memslot mappings are kept in a hash table instead of using
a statically allocated "id_to_index" array.

The "lru slot" mini-cache, that keeps track of the last found-by-gfn
memslot, is still present in the new code.

There was also a desire to make the new structure operate on
"pay as you go" basis, that is, that the user only pays the price of the
memslot count that is actually used, not of the maximum count allowed.
Because of that, the implementation makes is possible to make
available for use the maximum memslot count allowed by the KVM API.

The operation semantics were carefully matched to the original
implementation, the outside-visible behavior should not change.
Only the timing will be different.

Making lookup and memslot management operations O(log(n)) brings
some performance benefits (tested on a Xeon 8167M machine):
509 slots in use:
Test		Before		After		Improvement
Map		0,0246s		0,0240s		 2%
Unmap		0,0833s		0,0318s		62%
Unmap 2M	0,00177s	0,000917s	48%
Move active	0,0000959s	0,0000816s	15%
Move inactive	0,0000960s	0,0000799s	17%
Slot setup	0,0107s		0,00825s	23%

100 slots in use:
Test		Before		After		Improvement
Map		0,0208s		0,0207s		None
Unmap		0,0406s		0,0315s		22%
Unmap 2M	0,000534s	0,000504s	 6%
Move active	0,0000845s	0,0000828s	 2%
Move inactive	0,0000861s	0,0000805s	 7%
Slot setup	0,00193s	0,00181s	 6%

50 slots in use:
Test		Before		After		Improvement
Map		0,0207s		0,0202s		 2%
Unmap		0,0360s		0,0317s		12%
Unmap 2M	0,000454s	0,000449s	None
Move active	0,0000890s	0,0000875s	 2%
Move inactive	0,0000807s	0,0000806s	None
Slot setup	0,00108s	0,00103s	 4%

30 slots in use:
Test		Before		After		Improvement
Map		0,0205s		0,0202s		 1%
Unmap		0,0342s		0,0317s		 7%
Unmap 2M	0,000426s	0,000430s	-1% / None
Move active	0,0000868s	0,0000841s	 3%
Move inactive	0,0000908s	0,0000882s	 3%
Slot setup	0,000810s	0,000777s	 4%

10 slots in use:
Test		Before		After		Improvement
Map		0,0205s		0,0203s		None
Unmap		0,0319s		0,0312s		  2%
Unmap 2M	0,000399s	0,000406s	 -2%
Move active	0,0000955s	0,0000953s	None
Move inactive	0,0000911s	0,0000909s	None
Slot setup	0,000286s	0,000284s	None

For comparison, 32k memslots get the following results with
the new code:
Map (8194)	0,0563s
Unmap		0,0351s
Unmap 2M	0,0350s
Move active	0,0000812s
Move inactive	0,0000847s
Slot setup	0,585s

Since the map test can be done with up to 8194 slots, the result above
for this test was obtained running it with that maximum number of slots.

In both the old and new memslot code case the measurements were done
against the new KVM selftest framework and with the retpoline-friendly
KVM HVA handler.

On x86-64 the code was well tested, passed KVM unit tests and KVM
selftests with KASAN on.
And, of course, booted various guests successfully.
On other KVM platforms the code was compile-tested only.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/arm64/kvm/Kconfig              |   1 +
 arch/arm64/kvm/mmu.c                |  20 +-
 arch/mips/kvm/Kconfig               |   1 +
 arch/mips/kvm/mmu.c                 |  12 +-
 arch/powerpc/kvm/Kconfig            |   1 +
 arch/powerpc/kvm/book3s_64_mmu_hv.c |  16 +-
 arch/powerpc/kvm/book3s_64_vio.c    |   2 +-
 arch/powerpc/kvm/book3s_64_vio_hv.c |   2 +-
 arch/powerpc/kvm/book3s_hv.c        |   3 +-
 arch/powerpc/kvm/book3s_hv_nested.c |   4 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c  |  14 +-
 arch/powerpc/kvm/book3s_pr.c        |  12 +-
 arch/s390/kvm/Kconfig               |   1 +
 arch/s390/kvm/kvm-s390.c            |  66 +---
 arch/s390/kvm/kvm-s390.h            |  15 +
 arch/s390/kvm/pv.c                  |   4 +-
 arch/x86/include/asm/kvm_host.h     |   3 +-
 arch/x86/kvm/Kconfig                |   1 +
 arch/x86/kvm/mmu/mmu.c              |  78 ++--
 arch/x86/kvm/mmu/tdp_mmu.c          |  13 +-
 arch/x86/kvm/x86.c                  |  16 +-
 include/linux/kvm_host.h            | 139 ++++---
 virt/kvm/kvm_main.c                 | 580 ++++++++++++++++------------
 23 files changed, 589 insertions(+), 415 deletions(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 3964acf5451e..f075e9939a2a 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -40,6 +40,7 @@ menuconfig KVM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select TASKSTATS
 	select TASK_DELAY_ACCT
+	select INTERVAL_TREE
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7d2257cc5438..065670df1dff 100644
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
@@ -1070,21 +1070,27 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 			     void *data)
 {
 	struct kvm_memslots *slots;
+	int idxactive;
+	struct interval_tree_node *node;
 	struct kvm_memory_slot *memslot;
 	int ret = 0;
 
+	if (end == start || WARN_ON(end < start))
+		return 0;
+
 	slots = kvm_memslots(kvm);
+	idxactive = kvm_memslots_idx(slots);
 
 	/* we only care about the pages that the guest sees */
-	kvm_for_each_memslot(memslot, slots) {
+	kvm_for_each_hva_range_memslot(node, slots, start, end - 1) {
 		unsigned long hva_start, hva_end;
 		gfn_t gpa;
 
+		memslot = container_of(node, struct kvm_memory_slot,
+				       hva_node[idxactive]);
 		hva_start = max(start, memslot->userspace_addr);
 		hva_end = min(end, memslot->userspace_addr +
 					(memslot->npages << PAGE_SHIFT));
-		if (hva_start >= hva_end)
-			continue;
 
 		gpa = hva_to_gfn_memslot(hva_start, memslot) << PAGE_SHIFT;
 		ret |= handler(kvm, gpa, (u64)(hva_end - hva_start), data);
diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index 032b3fca6cbb..5ba260f38e75 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -27,6 +27,7 @@ config KVM
 	select KVM_MMIO
 	select MMU_NOTIFIER
 	select SRCU
+	select INTERVAL_TREE
 	help
 	  Support for hosting Guest kernels.
 
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index 3dabeda82458..a3b2589081eb 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -449,21 +449,27 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 			     void *data)
 {
 	struct kvm_memslots *slots;
+	int idxactive;
+	struct interval_tree_node *node;
 	struct kvm_memory_slot *memslot;
 	int ret = 0;
 
+	if (end == start || WARN_ON(end < start))
+		return 0;
+
 	slots = kvm_memslots(kvm);
+	idxactive = kvm_memslots_idx(slots);
 
 	/* we only care about the pages that the guest sees */
-	kvm_for_each_memslot(memslot, slots) {
+	kvm_for_each_hva_range_memslot(node, slots, start, end - 1) {
 		unsigned long hva_start, hva_end;
 		gfn_t gfn, gfn_end;
 
+		memslot = container_of(node, struct kvm_memory_slot,
+				       hva_node[idxactive]);
 		hva_start = max(start, memslot->userspace_addr);
 		hva_end = min(end, memslot->userspace_addr +
 					(memslot->npages << PAGE_SHIFT));
-		if (hva_start >= hva_end)
-			continue;
 
 		/*
 		 * {gfn(page) | page intersects with [hva_start, hva_end)} =
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 549591d9aaa2..dd7fdb25f2e5 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -26,6 +26,7 @@ config KVM
 	select KVM_VFIO
 	select IRQ_BYPASS_MANAGER
 	select HAVE_KVM_IRQ_BYPASS
+	select INTERVAL_TREE
 
 config KVM_BOOK3S_HANDLER
 	bool
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 38ea396a23d6..213ed3af9afc 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -733,11 +733,11 @@ void kvmppc_rmap_reset(struct kvm *kvm)
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
@@ -762,18 +762,24 @@ static int kvm_handle_hva_range(struct kvm *kvm,
 	int ret;
 	int retval = 0;
 	struct kvm_memslots *slots;
+	int idxactive;
+	struct interval_tree_node *node;
 	struct kvm_memory_slot *memslot;
 
+	if (end == start || WARN_ON(end < start))
+		return 0;
+
 	slots = kvm_memslots(kvm);
-	kvm_for_each_memslot(memslot, slots) {
+	idxactive = kvm_memslots_idx(slots);
+	kvm_for_each_hva_range_memslot(node, slots, start, end - 1) {
 		unsigned long hva_start, hva_end;
 		gfn_t gfn, gfn_end;
 
+		memslot = container_of(node, struct kvm_memory_slot,
+				       hva_node[idxactive]);
 		hva_start = max(start, memslot->userspace_addr);
 		hva_end = min(end, memslot->userspace_addr +
 					(memslot->npages << PAGE_SHIFT));
-		if (hva_start >= hva_end)
-			continue;
 		/*
 		 * {gfn(page) | page intersects with [hva_start, hva_end)} =
 		 * {gfn, gfn+1, ..., gfn_end-1}.
diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 8da93fdfa59e..148525120504 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -346,7 +346,7 @@ static long kvmppc_tce_to_ua(struct kvm *kvm, unsigned long tce,
 	unsigned long gfn = tce >> PAGE_SHIFT;
 	struct kvm_memory_slot *memslot;
 
-	memslot = search_memslots(kvm_memslots(kvm), gfn);
+	memslot = search_memslots(kvm_memslots(kvm), gfn, false);
 	if (!memslot)
 		return -EINVAL;
 
diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index 083a4e037718..a4042403630d 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -80,7 +80,7 @@ static long kvmppc_rm_tce_to_ua(struct kvm *kvm,
 	unsigned long gfn = tce >> PAGE_SHIFT;
 	struct kvm_memory_slot *memslot;
 
-	memslot = search_memslots(kvm_memslots_raw(kvm), gfn);
+	memslot = search_memslots(kvm_memslots_raw(kvm), gfn, false);
 	if (!memslot)
 		return -EINVAL;
 
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 6f612d240392..725e03481b3a 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5556,11 +5556,12 @@ static int kvmhv_svm_off(struct kvm *kvm)
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
index 33b58549a9aa..cf68182c5add 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -656,7 +656,7 @@ void kvmhv_release_all_nested(struct kvm *kvm)
 	struct kvm_nested_guest *gp;
 	struct kvm_nested_guest *freelist = NULL;
 	struct kvm_memory_slot *memslot;
-	int srcu_idx;
+	int srcu_idx, ctr;
 
 	spin_lock(&kvm->mmu_lock);
 	for (i = 0; i <= kvm->arch.max_nested_lpid; i++) {
@@ -677,7 +677,7 @@ void kvmhv_release_all_nested(struct kvm *kvm)
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
index 913944dc3620..52040aaef3cc 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -431,18 +431,24 @@ static void do_kvm_unmap_hva(struct kvm *kvm, unsigned long start,
 	long i;
 	struct kvm_vcpu *vcpu;
 	struct kvm_memslots *slots;
+	int idxactive;
+	struct interval_tree_node *node;
 	struct kvm_memory_slot *memslot;
 
+	if (end == start || WARN_ON(end < start))
+		return;
+
 	slots = kvm_memslots(kvm);
-	kvm_for_each_memslot(memslot, slots) {
+	idxactive = kvm_memslots_idx(slots);
+	kvm_for_each_hva_range_memslot(node, slots, start, end - 1) {
 		unsigned long hva_start, hva_end;
 		gfn_t gfn, gfn_end;
 
+		memslot = container_of(node, struct kvm_memory_slot,
+				       hva_node[idxactive]);
 		hva_start = max(start, memslot->userspace_addr);
 		hva_end = min(end, memslot->userspace_addr +
 					(memslot->npages << PAGE_SHIFT));
-		if (hva_start >= hva_end)
-			continue;
 		/*
 		 * {gfn(page) | page intersects with [hva_start, hva_end)} =
 		 * {gfn, gfn+1, ..., gfn_end-1}.
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index 67a8e770e369..2e84d3922f7c 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -33,6 +33,7 @@ config KVM
 	select HAVE_KVM_NO_POLL
 	select SRCU
 	select KVM_VFIO
+	select INTERVAL_TREE
 	help
 	  Support hosting paravirtualized guest machines using the SIE
 	  virtualization capability on the mainframe. This should work
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index dbafd057ca6a..59220885ef2d 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1011,13 +1011,13 @@ static int kvm_s390_vm_start_migration(struct kvm *kvm)
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
@@ -1025,8 +1025,7 @@ static int kvm_s390_vm_start_migration(struct kvm *kvm)
 		return 0;
 	}
 	/* mark all the pages in active slots as dirty */
-	for (slotnr = 0; slotnr < slots->used_slots; slotnr++) {
-		ms = slots->memslots + slotnr;
+	kvm_for_each_memslot(ms, ctr, slots) {
 		if (!ms->dirty_bitmap)
 			return -EINVAL;
 		/*
@@ -1917,41 +1916,6 @@ static long kvm_s390_set_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
 /* for consistency */
 #define KVM_S390_CMMA_SIZE_MAX ((u32)KVM_S390_SKEYS_MAX)
 
-/*
- * Similar to gfn_to_memslot, but returns the index of a memslot also when the
- * address falls in a hole. In that case the index of one of the memslots
- * bordering the hole is returned.
- */
-static int gfn_to_memslot_approx(struct kvm_memslots *slots, gfn_t gfn)
-{
-	int start = 0, end = slots->used_slots;
-	int slot = atomic_read(&slots->lru_slot);
-	struct kvm_memory_slot *memslots = slots->memslots;
-
-	if (gfn >= memslots[slot].base_gfn &&
-	    gfn < memslots[slot].base_gfn + memslots[slot].npages)
-		return slot;
-
-	while (start < end) {
-		slot = start + (end - start) / 2;
-
-		if (gfn >= memslots[slot].base_gfn)
-			end = slot;
-		else
-			start = slot + 1;
-	}
-
-	if (start >= slots->used_slots)
-		return slots->used_slots - 1;
-
-	if (gfn >= memslots[start].base_gfn &&
-	    gfn < memslots[start].base_gfn + memslots[start].npages) {
-		atomic_set(&slots->lru_slot, start);
-	}
-
-	return start;
-}
-
 static int kvm_s390_peek_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
 			      u8 *res, unsigned long bufsize)
 {
@@ -1978,23 +1942,25 @@ static int kvm_s390_peek_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
 static unsigned long kvm_s390_next_dirty_cmma(struct kvm_memslots *slots,
 					      unsigned long cur_gfn)
 {
-	int slotidx = gfn_to_memslot_approx(slots, cur_gfn);
-	struct kvm_memory_slot *ms = slots->memslots + slotidx;
+	struct kvm_memory_slot *ms = search_memslots(slots, cur_gfn, true);
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
@@ -2007,7 +1973,7 @@ static int kvm_s390_get_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	struct kvm_memory_slot *ms;
 
-	if (unlikely(!slots->used_slots))
+	if (unlikely(kvm_memslots_empty(slots)))
 		return 0;
 
 	cur_gfn = kvm_s390_next_dirty_cmma(slots, args->start_gfn);
@@ -2017,7 +1983,7 @@ static int kvm_s390_get_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
 	if (!ms)
 		return 0;
 	next_gfn = kvm_s390_next_dirty_cmma(slots, cur_gfn + 1);
-	mem_end = slots->memslots[0].base_gfn + slots->memslots[0].npages;
+	mem_end = kvm_s390_get_gfn_end(slots);
 
 	while (args->count < bufsize) {
 		hva = gfn_to_hva(kvm, cur_gfn);
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 79dcd647b378..fa0215fed66e 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -208,6 +208,21 @@ static inline int kvm_s390_user_cpu_state_ctrl(struct kvm *kvm)
 	return kvm->arch.user_cpu_state_ctrl != 0;
 }
 
+/* get the end gfn of the last (highest gfn) memslot */
+static inline unsigned long kvm_s390_get_gfn_end(struct kvm_memslots *slots)
+{
+	struct rb_node *node;
+	int idxactive = kvm_memslots_idx(slots);
+	struct kvm_memory_slot *ms;
+
+	if (WARN_ON(kvm_memslots_empty(slots)))
+		return 0;
+
+	node = rb_last(&slots->gfn_tree);
+	ms = container_of(node, struct kvm_memory_slot, gfn_node[idxactive]);
+	return ms->base_gfn + ms->npages;
+}
+
 /* implemented in pv.c */
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
 int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 813b6e93dc83..6bf42cdf4013 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -117,7 +117,6 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
 	unsigned long base = uv_info.guest_base_stor_len;
 	unsigned long virt = uv_info.guest_virt_var_stor_len;
 	unsigned long npages = 0, vlen = 0;
-	struct kvm_memory_slot *memslot;
 
 	kvm->arch.pv.stor_var = NULL;
 	kvm->arch.pv.stor_base = __get_free_pages(GFP_KERNEL_ACCOUNT, get_order(base));
@@ -131,8 +130,7 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
 	 * Slots are sorted by GFN
 	 */
 	mutex_lock(&kvm->slots_lock);
-	memslot = kvm_memslots(kvm)->memslots;
-	npages = memslot->base_gfn + memslot->npages;
+	npages = kvm_s390_get_gfn_end(kvm_memslots(kvm));
 	mutex_unlock(&kvm->slots_lock);
 
 	kvm->arch.pv.guest_len = npages * PAGE_SIZE;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3d6616f6f6ef..4ddfd3d522b1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -40,9 +40,9 @@
 #define KVM_MAX_VCPUS 288
 #define KVM_SOFT_MAX_VCPUS 240
 #define KVM_MAX_VCPU_ID 1023
-#define KVM_USER_MEM_SLOTS 509
 /* memory slots that are not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 3
+#define KVM_USER_MEM_SLOTS (SHRT_MAX - KVM_PRIVATE_MEM_SLOTS)
 #define KVM_MEM_SLOTS_NUM (KVM_USER_MEM_SLOTS + KVM_PRIVATE_MEM_SLOTS)
 
 #define KVM_HALT_POLL_NS_DEFAULT 200000
@@ -902,6 +902,7 @@ enum kvm_irqchip_mode {
 #define APICV_INHIBIT_REASON_X2APIC	5
 
 struct kvm_arch {
+	unsigned long n_memslots_pages;
 	unsigned long n_used_mmu_pages;
 	unsigned long n_requested_mmu_pages;
 	unsigned long n_max_mmu_pages;
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 7ac592664c52..932af1b7d002 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -46,6 +46,7 @@ config KVM
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_VFIO
 	select SRCU
+	select INTERVAL_TREE
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4140e308cf30..bb7cbb119018 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1512,17 +1512,24 @@ static int kvm_handle_hva_range(struct kvm *kvm,
 	int ret = 0;
 	int i;
 
+	if (end == start || WARN_ON(end < start))
+		return 0;
+
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		int idxactive;
+		struct interval_tree_node *node;
+
 		slots = __kvm_memslots(kvm, i);
-		kvm_for_each_memslot(memslot, slots) {
+		idxactive = kvm_memslots_idx(slots);
+		kvm_for_each_hva_range_memslot(node, slots, start, end - 1) {
 			unsigned long hva_start, hva_end;
 			gfn_t gfn_start, gfn_end;
 
+			memslot = container_of(node, struct kvm_memory_slot,
+					       hva_node[idxactive]);
 			hva_start = max(start, memslot->userspace_addr);
 			hva_end = min(end, memslot->userspace_addr +
 				      (memslot->npages << PAGE_SHIFT));
-			if (hva_start >= hva_end)
-				continue;
 			/*
 			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
 			 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
@@ -5517,12 +5524,51 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	int i;
 	bool flush;
 
+	if (gfn_end == gfn_start || WARN_ON(gfn_end < gfn_start))
+		return;
+
 	spin_lock(&kvm->mmu_lock);
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		int idxactive;
+		struct rb_node *node;
+
 		slots = __kvm_memslots(kvm, i);
-		kvm_for_each_memslot(memslot, slots) {
+		idxactive = kvm_memslots_idx(slots);
+
+		/*
+		 * Find the slot with the lowest gfn that can possibly intersect with
+		 * the range, so we'll ideally have slot start <= range start
+		 */
+		node = kvm_memslots_gfn_upper_bound(slots, gfn_start);
+		if (node) {
+			struct rb_node *pnode;
+
+			/*
+			 * A NULL previous node means that the very first slot
+			 * already has a higher start gfn.
+			 * In this case slot start > range start.
+			 */
+			pnode = rb_prev(node);
+			if (pnode)
+				node = pnode;
+		} else {
+			/* a NULL node below means no slots */
+			node = rb_last(&slots->gfn_tree);
+		}
+
+		for ( ; node; node = rb_next(node)) {
 			gfn_t start, end;
 
+			memslot = container_of(node, struct kvm_memory_slot,
+					       gfn_node[idxactive]);
+
+			/*
+			 * If this slot starts beyond or at the end of the range so does
+			 * every next one
+			 */
+			if (memslot->base_gfn >= gfn_start + gfn_end)
+				break;
+
 			start = max(gfn_start, memslot->base_gfn);
 			end = min(gfn_end, memslot->base_gfn + memslot->npages);
 			if (start >= end)
@@ -5939,30 +5985,6 @@ int kvm_mmu_module_init(void)
 	return ret;
 }
 
-/*
- * Calculate mmu pages needed for kvm.
- */
-unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm)
-{
-	unsigned long nr_mmu_pages;
-	unsigned long nr_pages = 0;
-	struct kvm_memslots *slots;
-	struct kvm_memory_slot *memslot;
-	int i;
-
-	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
-		slots = __kvm_memslots(kvm, i);
-
-		kvm_for_each_memslot(memslot, slots)
-			nr_pages += memslot->npages;
-	}
-
-	nr_mmu_pages = nr_pages * KVM_PERMILLE_MMU_PAGES / 1000;
-	nr_mmu_pages = max(nr_mmu_pages, KVM_MIN_ALLOC_MMU_PAGES);
-
-	return nr_mmu_pages;
-}
-
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_unload(vcpu);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f666b0fab861..0a9c77ac1c93 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -728,18 +728,25 @@ static int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm, unsigned long start,
 	int ret = 0;
 	int as_id;
 
+	if (end == start || WARN_ON(end < start))
+		return 0;
+
 	for_each_tdp_mmu_root_yield_safe(kvm, root) {
+		int idxactive;
+		struct interval_tree_node *node;
+
 		as_id = kvm_mmu_page_as_id(root);
 		slots = __kvm_memslots(kvm, as_id);
-		kvm_for_each_memslot(memslot, slots) {
+		idxactive = kvm_memslots_idx(slots);
+		kvm_for_each_hva_range_memslot(node, slots, start, end - 1) {
 			unsigned long hva_start, hva_end;
 			gfn_t gfn_start, gfn_end;
 
+			memslot = container_of(node, struct kvm_memory_slot,
+					       hva_node[idxactive]);
 			hva_start = max(start, memslot->userspace_addr);
 			hva_end = min(end, memslot->userspace_addr +
 				      (memslot->npages << PAGE_SHIFT));
-			if (hva_start >= hva_end)
-				continue;
 			/*
 			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
 			 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 76bce832cade..4bc049889708 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10760,9 +10760,19 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
-	if (!kvm->arch.n_requested_mmu_pages)
-		kvm_mmu_change_mmu_pages(kvm,
-				kvm_mmu_calculate_default_mmu_pages(kvm));
+	if (change == KVM_MR_CREATE)
+		kvm->arch.n_memslots_pages += new->npages;
+	else if (change == KVM_MR_DELETE)
+		kvm->arch.n_memslots_pages -= old->npages;
+
+	if (!kvm->arch.n_requested_mmu_pages) {
+		unsigned long nr_mmu_pages;
+
+		nr_mmu_pages = kvm->arch.n_memslots_pages *
+			       KVM_PERMILLE_MMU_PAGES / 1000;
+		nr_mmu_pages = max(nr_mmu_pages, KVM_MIN_ALLOC_MMU_PAGES);
+		kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
+	}
 
 	/*
 	 * FIXME: const-ify all uses of struct kvm_memory_slot.
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f3b1013fb22c..c416f9e95961 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -26,6 +26,9 @@
 #include <linux/rcuwait.h>
 #include <linux/refcount.h>
 #include <linux/nospec.h>
+#include <linux/interval_tree.h>
+#include <linux/hashtable.h>
+#include <linux/rbtree.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -341,6 +344,9 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
 #define KVM_MEM_MAX_NR_PAGES ((1UL << 31) - 1)
 
 struct kvm_memory_slot {
+	struct hlist_node id_node[2];
+	struct interval_tree_node hva_node[2];
+	struct rb_node gfn_node[2];
 	gfn_t base_gfn;
 	unsigned long npages;
 	unsigned long *dirty_bitmap;
@@ -436,24 +442,21 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 }
 #endif
 
-/*
- * Note:
- * memslots are not sorted by id anymore, please use id_to_memslot()
- * to get the memslot by its id.
- */
 struct kvm_memslots {
 	u64 generation;
-	/* The mapping table from slot id to the index in memslots[]. */
-	short id_to_index[KVM_MEM_SLOTS_NUM];
-	atomic_t lru_slot;
-	int used_slots;
-	struct kvm_memory_slot memslots[];
+	atomic_long_t lru_slot;
+	struct rb_root_cached hva_tree;
+	struct rb_root gfn_tree;
+	/* The mapping table from slot id to memslot. */
+	DECLARE_HASHTABLE(id_hash, 7);
+	bool is_idx_0;
 };
 
 struct kvm {
 	spinlock_t mmu_lock;
 	struct mutex slots_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
+	struct kvm_memslots memslots_all[KVM_ADDRESS_SPACE_NUM][2];
 	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 
@@ -591,12 +594,6 @@ static inline int kvm_vcpu_get_idx(struct kvm_vcpu *vcpu)
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
@@ -655,19 +652,61 @@ static inline struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu)
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
+#define kvm_for_each_hva_range_memslot(node, slots, start, last)	     \
+	for (node = interval_tree_iter_first(&slots->hva_tree, start, last); \
+	     node;							     \
+	     node = interval_tree_iter_next(node, start, last))	     \
+
 static inline
 struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
 {
-	int index = slots->id_to_index[id];
+	int idxactive = kvm_memslots_idx(slots);
 	struct kvm_memory_slot *slot;
 
-	if (index < 0)
-		return NULL;
+	hash_for_each_possible(slots->id_hash, slot, id_node[idxactive], id) {
+		if (slot->id == id)
+			return slot;
+	}
+
+	return NULL;
+}
+
+static inline
+struct rb_node *kvm_memslots_gfn_upper_bound(struct kvm_memslots *slots,
+					     gfn_t gfn)
+{
+	int idxactive = kvm_memslots_idx(slots);
+	struct rb_node *node, *result = NULL;
+
+	for (node = slots->gfn_tree.rb_node; node; ) {
+		struct kvm_memory_slot *slot;
 
-	slot = &slots->memslots[index];
+		slot = container_of(node, struct kvm_memory_slot,
+				    gfn_node[idxactive]);
+		if (gfn < slot->base_gfn) {
+			result = node;
+			node = node->rb_left;
+		} else
+			node = node->rb_right;
+	}
 
-	WARN_ON(slot->id != id);
-	return slot;
+	return result;
 }
 
 /*
@@ -1068,36 +1107,40 @@ bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
  * gfn_to_memslot() itself isn't here as an inline because that would
  * bloat other code too much.
  *
- * IMPORTANT: Slots are sorted from highest GFN to lowest GFN!
+ * With "approx" set returns the memslot also when the address falls
+ * in a hole. In that case one of the memslots bordering the hole is
+ * returned.
  */
 static inline struct kvm_memory_slot *
-search_memslots(struct kvm_memslots *slots, gfn_t gfn)
+search_memslots(struct kvm_memslots *slots, gfn_t gfn, bool approx)
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
 
-	if (start < slots->used_slots && gfn >= memslots[start].base_gfn &&
-	    gfn < memslots[start].base_gfn + memslots[start].npages) {
-		atomic_set(&slots->lru_slot, start);
-		return &memslots[start];
-	}
+	if (approx && prevnode)
+		return container_of(prevnode, struct kvm_memory_slot,
+				    gfn_node[idxactive]);
 
 	return NULL;
 }
@@ -1105,7 +1148,7 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn)
 static inline struct kvm_memory_slot *
 __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
 {
-	return search_memslots(slots, gfn);
+	return search_memslots(slots, gfn, false);
 }
 
 static inline unsigned long
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8367d88ce39b..46cf4daece89 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -623,19 +623,12 @@ static int kvm_init_mmu_notifier(struct kvm *kvm)
 
 #endif /* CONFIG_MMU_NOTIFIER && KVM_ARCH_WANT_MMU_NOTIFIER */
 
-static struct kvm_memslots *kvm_alloc_memslots(void)
+static void kvm_init_memslots(struct kvm_memslots *slots)
 {
-	int i;
-	struct kvm_memslots *slots;
-
-	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
-	if (!slots)
-		return NULL;
-
-	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
-		slots->id_to_index[i] = -1;
-
-	return slots;
+	atomic_long_set(&slots->lru_slot, (unsigned long)NULL);
+	slots->hva_tree = RB_ROOT_CACHED;
+	slots->gfn_tree = RB_ROOT;
+	hash_init(slots->id_hash);
 }
 
 static void kvm_destroy_dirty_bitmap(struct kvm_memory_slot *memslot)
@@ -647,27 +640,31 @@ static void kvm_destroy_dirty_bitmap(struct kvm_memory_slot *memslot)
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
@@ -763,13 +760,14 @@ static struct kvm *kvm_create_vm(unsigned long type)
 
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
@@ -822,8 +820,6 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
 	for (i = 0; i < KVM_NR_BUSES; i++)
 		kfree(kvm_get_bus(kvm, i));
-	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-		kvm_free_memslots(kvm, __kvm_memslots(kvm, i));
 	cleanup_srcu_struct(&kvm->irq_srcu);
 out_err_no_irq_srcu:
 	cleanup_srcu_struct(&kvm->srcu);
@@ -877,8 +873,10 @@ static void kvm_destroy_vm(struct kvm *kvm)
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
@@ -938,168 +936,6 @@ static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
 	return 0;
 }
 
-/*
- * Delete a memslot by decrementing the number of used slots and shifting all
- * other entries in the array forward one spot.
- */
-static inline void kvm_memslot_delete(struct kvm_memslots *slots,
-				      struct kvm_memory_slot *memslot)
-{
-	struct kvm_memory_slot *mslots = slots->memslots;
-	int i;
-
-	if (WARN_ON(slots->id_to_index[memslot->id] == -1))
-		return;
-
-	slots->used_slots--;
-
-	if (atomic_read(&slots->lru_slot) >= slots->used_slots)
-		atomic_set(&slots->lru_slot, 0);
-
-	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots; i++) {
-		mslots[i] = mslots[i + 1];
-		slots->id_to_index[mslots[i].id] = i;
-	}
-	mslots[i] = *memslot;
-	slots->id_to_index[memslot->id] = -1;
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
- */
-static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
-					    struct kvm_memory_slot *memslot)
-{
-	struct kvm_memory_slot *mslots = slots->memslots;
-	int i;
-
-	if (WARN_ON_ONCE(slots->id_to_index[memslot->id] == -1) ||
-	    WARN_ON_ONCE(!slots->used_slots))
-		return -1;
-
-	/*
-	 * Move the target memslot backward in the array by shifting existing
-	 * memslots with a higher GFN (than the target memslot) towards the
-	 * front of the array.
-	 */
-	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots - 1; i++) {
-		if (memslot->base_gfn > mslots[i + 1].base_gfn)
-			break;
-
-		WARN_ON_ONCE(memslot->base_gfn == mslots[i + 1].base_gfn);
-
-		/* Shift the next memslot forward one and update its index. */
-		mslots[i] = mslots[i + 1];
-		slots->id_to_index[mslots[i].id] = i;
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
-		mslots[i] = mslots[i - 1];
-		slots->id_to_index[mslots[i].id] = i;
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
-		/*
-		 * Copy the memslot to its new position in memslots and update
-		 * its index accordingly.
-		 */
-		slots->memslots[i] = *memslot;
-		slots->id_to_index[memslot->id] = i;
-	}
-}
-
 static int check_memory_region_flags(const struct kvm_userspace_memory_region *mem)
 {
 	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
@@ -1114,10 +950,12 @@ static int check_memory_region_flags(const struct kvm_userspace_memory_region *m
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
@@ -1146,34 +984,115 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
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
 
-	if (change == KVM_MR_CREATE)
-		new_size = old_size + sizeof(struct kvm_memory_slot);
-	else
-		new_size = old_size;
+	if (WARN_ON(!oldslot && !nslot))
+		return;
+
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
+
+	hash_add(slots->id_hash, &nslot->id_node[slots_idx],
+		 nslot->id);
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
+	}
+}
 
-	slots = kvzalloc(new_size, GFP_KERNEL_ACCOUNT);
-	if (likely(slots))
-		memcpy(slots, old, old_size);
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
+	nslot->hva_node[slots_idx].start = oldslot->hva_node[slots_idx].start;
+	nslot->hva_node[slots_idx].last = oldslot->hva_node[slots_idx].last;
 
-	return slots;
+	kvm_replace_memslot(kvm, as_id, slots_idx, oldslot, nslot);
 }
 
 static int kvm_set_memslot(struct kvm *kvm,
@@ -1182,56 +1101,182 @@ static int kvm_set_memslot(struct kvm *kvm,
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
+		slotina->hva_node[idxact].start = slotina->hva_node[idxina].start =
+			slotina->userspace_addr;
+		slotina->hva_node[idxact].last = slotina->hva_node[idxina].last =
+			slotina->userspace_addr +
+			(slotina->npages << PAGE_SHIFT) - 1;
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
 
@@ -1240,7 +1285,6 @@ static int kvm_delete_memslot(struct kvm *kvm,
 			      struct kvm_memory_slot *old, int as_id)
 {
 	struct kvm_memory_slot new;
-	int r;
 
 	if (!old->npages)
 		return -EINVAL;
@@ -1253,12 +1297,60 @@ static int kvm_delete_memslot(struct kvm *kvm,
 	 */
 	new.as_id = as_id;
 
-	r = kvm_set_memslot(kvm, mem, old, &new, as_id, KVM_MR_DELETE);
-	if (r)
-		return r;
+	return kvm_set_memslot(kvm, mem, old, &new, as_id, KVM_MR_DELETE);
+}
 
-	kvm_free_memslot(kvm, old);
-	return 0;
+static bool kvm_check_memslot_overlap(struct kvm_memslots *slots,
+				      struct kvm_memory_slot *nslot)
+{
+	int idxactive = kvm_memslots_idx(slots);
+	struct rb_node *node;
+
+	/*
+	 * Find the slot with the lowest gfn that can possibly intersect with
+	 * the new slot, so we'll ideally have slot start <= nslot start
+	 */
+	node = kvm_memslots_gfn_upper_bound(slots, nslot->base_gfn);
+	if (node) {
+		struct rb_node *pnode;
+
+		/*
+		 * A NULL previous node means that the very first slot
+		 * already has a higher start gfn.
+		 * In this case slot start > nslot start.
+		 */
+		pnode = rb_prev(node);
+		if (pnode)
+			node = pnode;
+	} else {
+		/* a NULL node below means no existing slots */
+		node = rb_last(&slots->gfn_tree);
+	}
+
+	for ( ; node; node = rb_next(node)) {
+		struct kvm_memory_slot *cslot;
+
+		cslot = container_of(node, struct kvm_memory_slot,
+				     gfn_node[idxactive]);
+
+		/*
+		 * if this slot starts beyond or at the end of the new slot
+		 * so does every next one
+		 */
+		if (cslot->base_gfn >= nslot->base_gfn + nslot->npages)
+			break;
+
+		if (cslot->id == nslot->id)
+			continue;
+
+		if (cslot->base_gfn >= nslot->base_gfn)
+			return true;
+
+		if (cslot->base_gfn + cslot->npages > nslot->base_gfn)
+			return true;
+	}
+
+	return false;
 }
 
 /*
@@ -1301,12 +1393,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
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
@@ -1353,13 +1439,9 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
 	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
 		/* Check for overlaps */
-		kvm_for_each_memslot(tmp, __kvm_memslots(kvm, as_id)) {
-			if (tmp->id == id)
-				continue;
-			if (!((new.base_gfn + new.npages <= tmp->base_gfn) ||
-			      (new.base_gfn >= tmp->base_gfn + tmp->npages)))
-				return -EEXIST;
-		}
+		if (kvm_check_memslot_overlap(__kvm_memslots(kvm, as_id),
+					      &new))
+			return -EEXIST;
 	}
 
 	/* Allocate/free page dirty bitmap as needed */
