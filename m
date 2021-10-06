Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873544244E8
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239581AbhJFRnf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:43:35 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53744 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239376AbhJFRmm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:42 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 15AD6307CAEE;
        Wed,  6 Oct 2021 20:31:04 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id E80F4305FFA0;
        Wed,  6 Oct 2021 20:31:03 +0300 (EEST)
X-Is-Junk-Enabled: fGZTSsP0qEJE2AIKtlSuFiRRwg9xyHmJ
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v12 26/77] KVM: x86: page_track: add support for preread, prewrite and preexec
Date:   Wed,  6 Oct 2021 20:30:22 +0300
Message-Id: <20211006173113.26445-27-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

The access to a tracked memory page leads to two types of actions from the
introspection tool: either the access is allowed (maybe with different
data for the source operand) or the vCPU should re-enter in guest
(the page is not tracked anymore, the instruction was skipped/emulated by
the introspection tool, etc.). These new callbacks must return 'true'
for the first case and 'false' for the second.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_page_track.h |  48 +++++++++-
 arch/x86/kvm/mmu/mmu.c                |  95 ++++++++++++++++++++
 arch/x86/kvm/mmu/mmu_internal.h       |   6 ++
 arch/x86/kvm/mmu/page_track.c         | 123 ++++++++++++++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c            | 106 ++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h            |   6 ++
 6 files changed, 374 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index df6e5674ea5c..56ba4d2d0a31 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -3,7 +3,10 @@
 #define _ASM_X86_KVM_PAGE_TRACK_H
 
 enum kvm_page_track_mode {
+	KVM_PAGE_TRACK_PREREAD,
+	KVM_PAGE_TRACK_PREWRITE,
 	KVM_PAGE_TRACK_WRITE,
+	KVM_PAGE_TRACK_PREEXEC,
 	KVM_PAGE_TRACK_MAX,
 };
 
@@ -22,6 +25,33 @@ struct kvm_page_track_notifier_head {
 struct kvm_page_track_notifier_node {
 	struct hlist_node node;
 
+	/*
+	 * It is called when guest is reading the read-tracked page
+	 * and the read emulation is about to happen.
+	 *
+	 * @vcpu: the vcpu where the read access happened.
+	 * @gpa: the physical address read by guest.
+	 * @gva: the virtual address read by guest.
+	 * @bytes: the read length.
+	 * @node: this node.
+	 */
+	bool (*track_preread)(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+			      int bytes,
+			      struct kvm_page_track_notifier_node *node);
+	/*
+	 * It is called when guest is writing the write-tracked page
+	 * and the write emulation didn't happened yet.
+	 *
+	 * @vcpu: the vcpu where the write access happened.
+	 * @gpa: the physical address written by guest.
+	 * @gva: the virtual address written by guest.
+	 * @new: the data was written to the address.
+	 * @bytes: the written length.
+	 * @node: this node
+	 */
+	bool (*track_prewrite)(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+			       const u8 *new, int bytes,
+			       struct kvm_page_track_notifier_node *node);
 	/*
 	 * It is called when guest is writing the write-tracked page
 	 * and write emulation is finished at that time.
@@ -36,6 +66,17 @@ struct kvm_page_track_notifier_node {
 	void (*track_write)(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			    const u8 *new, int bytes,
 			    struct kvm_page_track_notifier_node *node);
+	/*
+	 * It is called when guest is fetching from a exec-tracked page
+	 * and the fetch emulation is about to happen.
+	 *
+	 * @vcpu: the vcpu where the fetch access happened.
+	 * @gpa: the physical address fetched by guest.
+	 * @gva: the virtual address fetched by guest.
+	 * @node: this node.
+	 */
+	bool (*track_preexec)(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+			      struct kvm_page_track_notifier_node *node);
 	/*
 	 * It is called when memory slot is being created
 	 *
@@ -49,7 +90,7 @@ struct kvm_page_track_notifier_node {
 				  struct kvm_page_track_notifier_node *node);
 	/*
 	 * It is called when memory slot is being moved or removed
-	 * users can drop write-protection for the pages in that memory slot
+	 * users can drop active protection for the pages in that memory slot
 	 *
 	 * @kvm: the kvm where memory slot being moved or removed
 	 * @slot: the memory slot being moved or removed
@@ -85,7 +126,12 @@ kvm_page_track_register_notifier(struct kvm *kvm,
 void
 kvm_page_track_unregister_notifier(struct kvm *kvm,
 				   struct kvm_page_track_notifier_node *n);
+bool kvm_page_track_preread(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+			    int bytes);
+bool kvm_page_track_prewrite(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+			     const u8 *new, int bytes);
 void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			  const u8 *new, int bytes);
+bool kvm_page_track_preexec(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva);
 void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot);
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a802c46d0e16..8124fdd78aad 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1231,6 +1231,31 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
 	return mmu_spte_update(sptep, spte);
 }
 
+static bool spte_read_protect(u64 *sptep)
+{
+	u64 spte = *sptep;
+	bool exec_only_supported = (shadow_present_mask == 0ull);
+
+	rmap_printk("rmap_read_protect: spte %p %llx\n", sptep, *sptep);
+
+	WARN_ON_ONCE(!exec_only_supported);
+
+	spte = spte & ~(PT_WRITABLE_MASK | PT_PRESENT_MASK);
+
+	return mmu_spte_update(sptep, spte);
+}
+
+static bool spte_exec_protect(u64 *sptep)
+{
+	u64 spte = *sptep;
+
+	rmap_printk("rmap_exec_protect: spte %p %llx\n", sptep, *sptep);
+
+	spte = spte & ~PT_USER_MASK;
+
+	return mmu_spte_update(sptep, spte);
+}
+
 static bool __rmap_write_protect(struct kvm *kvm,
 				 struct kvm_rmap_head *rmap_head,
 				 bool pt_protect)
@@ -1245,6 +1270,32 @@ static bool __rmap_write_protect(struct kvm *kvm,
 	return flush;
 }
 
+static bool __rmap_read_protect(struct kvm *kvm,
+				struct kvm_rmap_head *rmap_head)
+{
+	struct rmap_iterator iter;
+	bool flush = false;
+	u64 *sptep;
+
+	for_each_rmap_spte(rmap_head, &iter, sptep)
+		flush |= spte_read_protect(sptep);
+
+	return flush;
+}
+
+static bool __rmap_exec_protect(struct kvm *kvm,
+				struct kvm_rmap_head *rmap_head)
+{
+	struct rmap_iterator iter;
+	bool flush = false;
+	u64 *sptep;
+
+	for_each_rmap_spte(rmap_head, &iter, sptep)
+		flush |= spte_exec_protect(sptep);
+
+	return flush;
+}
+
 static bool spte_clear_dirty(u64 *sptep)
 {
 	u64 spte = *sptep;
@@ -1423,6 +1474,50 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 	return write_protected;
 }
 
+bool kvm_mmu_slot_gfn_read_protect(struct kvm *kvm,
+				   struct kvm_memory_slot *slot, u64 gfn,
+				   int min_level)
+{
+	struct kvm_rmap_head *rmap_head;
+	bool read_protected = false;
+	int i;
+
+	if (kvm_memslots_have_rmaps(kvm)) {
+		for (i = min_level; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
+			rmap_head = gfn_to_rmap(gfn, i, slot);
+			read_protected |= __rmap_read_protect(kvm, rmap_head);
+		}
+	}
+
+	if (is_tdp_mmu_enabled(kvm))
+		read_protected |=
+			kvm_tdp_mmu_read_protect_gfn(kvm, slot, gfn, min_level);
+
+	return read_protected;
+}
+
+bool kvm_mmu_slot_gfn_exec_protect(struct kvm *kvm,
+				   struct kvm_memory_slot *slot, u64 gfn,
+				   int min_level)
+{
+	struct kvm_rmap_head *rmap_head;
+	bool exec_protected = false;
+	int i;
+
+	if (kvm_memslots_have_rmaps(kvm)) {
+		for (i = min_level; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
+			rmap_head = gfn_to_rmap(gfn, i, slot);
+			exec_protected |= __rmap_exec_protect(kvm, rmap_head);
+		}
+	}
+
+	if (is_tdp_mmu_enabled(kvm))
+		exec_protected |=
+			kvm_tdp_mmu_exec_protect_gfn(kvm, slot, gfn, min_level);
+
+	return exec_protected;
+}
+
 static bool rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 {
 	struct kvm_memory_slot *slot;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 585146a712d2..dd5fb48e8433 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -126,6 +126,12 @@ void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn,
 				    int min_level);
+bool kvm_mmu_slot_gfn_read_protect(struct kvm *kvm,
+				   struct kvm_memory_slot *slot, u64 gfn,
+				   int min_level);
+bool kvm_mmu_slot_gfn_exec_protect(struct kvm *kvm,
+				   struct kvm_memory_slot *slot, u64 gfn,
+				   int min_level);
 void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 					u64 start_gfn, u64 pages);
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index f18be17b56a3..56b3c721e5e9 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Support KVM gust page tracking
+ * Support KVM guest page tracking
  *
  * This feature allows us to track page access in guest. Currently, only
  * write access is tracked.
@@ -151,7 +151,7 @@ static void update_gfn_track(struct kvm_memory_slot *slot, gfn_t gfn,
  * @kvm: the guest instance we are interested in.
  * @slot: the @gfn belongs to.
  * @gfn: the guest page.
- * @mode: tracking mode, currently only write track is supported.
+ * @mode: tracking mode.
  */
 void kvm_slot_page_track_add_page(struct kvm *kvm,
 				  struct kvm_memory_slot *slot, gfn_t gfn,
@@ -173,9 +173,16 @@ void kvm_slot_page_track_add_page(struct kvm *kvm,
 	 */
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
 
-	if (mode == KVM_PAGE_TRACK_WRITE)
+	if (mode == KVM_PAGE_TRACK_WRITE) {
 		if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
 			kvm_flush_remote_tlbs(kvm);
+	} else if (mode == KVM_PAGE_TRACK_PREREAD) {
+		if (kvm_mmu_slot_gfn_read_protect(kvm, slot, gfn, PG_LEVEL_4K))
+			kvm_flush_remote_tlbs(kvm);
+	} else if (mode == KVM_PAGE_TRACK_PREEXEC) {
+		if (kvm_mmu_slot_gfn_exec_protect(kvm, slot, gfn, PG_LEVEL_4K))
+			kvm_flush_remote_tlbs(kvm);
+	}
 }
 EXPORT_SYMBOL_GPL(kvm_slot_page_track_add_page);
 
@@ -190,7 +197,7 @@ EXPORT_SYMBOL_GPL(kvm_slot_page_track_add_page);
  * @kvm: the guest instance we are interested in.
  * @slot: the @gfn belongs to.
  * @gfn: the guest page.
- * @mode: tracking mode, currently only write track is supported.
+ * @mode: tracking mode.
  */
 void kvm_slot_page_track_remove_page(struct kvm *kvm,
 				     struct kvm_memory_slot *slot, gfn_t gfn,
@@ -289,12 +296,80 @@ kvm_page_track_unregister_notifier(struct kvm *kvm,
 }
 EXPORT_SYMBOL_GPL(kvm_page_track_unregister_notifier);
 
+/*
+ * Notify the node that a read access is about to happen. Returning false
+ * doesn't stop the other nodes from being called, but it will stop
+ * the emulation.
+ *
+ * The node should figure out if the read page is the one that the node
+ * is interested in by itself.
+ *
+ * The nodes will always be in conflict if they track the same page:
+ * - accepting a read won't guarantee that the next node will not override
+ *   the data (filling new/bytes and setting data_ready)
+ * - filling new/bytes with custom data won't guarantee that the next node
+ *   will not override that
+ */
+bool kvm_page_track_preread(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+			    int bytes)
+{
+	struct kvm_page_track_notifier_head *head;
+	struct kvm_page_track_notifier_node *n;
+	int idx;
+	bool ret = true;
+
+	head = &vcpu->kvm->arch.track_notifier_head;
+
+	if (hlist_empty(&head->track_notifier_list))
+		return ret;
+
+	idx = srcu_read_lock(&head->track_srcu);
+	hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
+				srcu_read_lock_held(&head->track_srcu))
+		if (n->track_preread)
+			if (!n->track_preread(vcpu, gpa, gva, bytes, n))
+				ret = false;
+	srcu_read_unlock(&head->track_srcu, idx);
+	return ret;
+}
+
+/*
+ * Notify the node that a write access is about to happen. Returning false
+ * doesn't stop the other nodes from being called, but it will stop
+ * the emulation.
+ *
+ * The node should figure out if the written page is the one that the node
+ * is interested in by itself.
+ */
+bool kvm_page_track_prewrite(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+			     const u8 *new, int bytes)
+{
+	struct kvm_page_track_notifier_head *head;
+	struct kvm_page_track_notifier_node *n;
+	int idx;
+	bool ret = true;
+
+	head = &vcpu->kvm->arch.track_notifier_head;
+
+	if (hlist_empty(&head->track_notifier_list))
+		return ret;
+
+	idx = srcu_read_lock(&head->track_srcu);
+	hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
+				srcu_read_lock_held(&head->track_srcu))
+		if (n->track_prewrite)
+			if (!n->track_prewrite(vcpu, gpa, gva, new, bytes, n))
+				ret = false;
+	srcu_read_unlock(&head->track_srcu, idx);
+	return ret;
+}
+
 /*
  * Notify the node that write access is intercepted and write emulation is
  * finished at this time.
  *
- * The node should figure out if the written page is the one that node is
- * interested in by itself.
+ * The node should figure out if the written page is the one that the node
+ * is interested in by itself.
  */
 void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			  const u8 *new, int bytes)
@@ -316,12 +391,42 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 	srcu_read_unlock(&head->track_srcu, idx);
 }
 
+/*
+ * Notify the node that an instruction is about to be executed.
+ * Returning false doesn't stop the other nodes from being called,
+ * but it will stop the emulation with X86EMUL_RETRY_INSTR.
+ *
+ * The node should figure out if the page is the one that the node
+ * is interested in by itself.
+ */
+bool kvm_page_track_preexec(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva)
+{
+	struct kvm_page_track_notifier_head *head;
+	struct kvm_page_track_notifier_node *n;
+	int idx;
+	bool ret = true;
+
+	head = &vcpu->kvm->arch.track_notifier_head;
+
+	if (hlist_empty(&head->track_notifier_list))
+		return ret;
+
+	idx = srcu_read_lock(&head->track_srcu);
+	hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
+				srcu_read_lock_held(&head->track_srcu))
+		if (n->track_preexec)
+			if (!n->track_preexec(vcpu, gpa, gva, n))
+				ret = false;
+	srcu_read_unlock(&head->track_srcu, idx);
+	return ret;
+}
+
 /*
  * Notify the node that memory slot is being removed or moved so that it can
- * drop write-protection for the pages in the memory slot.
+ * drop active protection for the pages in the memory slot.
  *
- * The node should figure out it has any write-protected pages in this slot
- * by itself.
+ * The node should figure out if the page is the one that the node
+ * is interested in by itself.
  */
 void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 953f24ded6bc..86674047f53a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1483,6 +1483,112 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 	return spte_set;
 }
 
+/*
+ * Removes read/write access on the last level SPTE mapping this GFN.
+ * Returns true if an SPTE was set and a TLB flush is needed.
+ */
+static bool read_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
+			     gfn_t gfn, int min_level)
+{
+	bool exec_only_supported = (shadow_present_mask == 0ull);
+	struct tdp_iter iter;
+	u64 new_spte;
+	bool spte_set = false;
+
+	WARN_ON_ONCE(!exec_only_supported);
+
+	rcu_read_lock();
+
+	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
+				   min_level, gfn, gfn + 1) {
+		if (!is_shadow_present_pte(iter.old_spte) ||
+		    !is_last_spte(iter.old_spte, iter.level))
+			continue;
+
+		if ((iter.old_spte & (PT_WRITABLE_MASK | PT_PRESENT_MASK)) == 0)
+			break;
+
+		new_spte = iter.old_spte &
+			~(PT_WRITABLE_MASK | PT_PRESENT_MASK | shadow_mmu_writable_mask);
+
+		tdp_mmu_set_spte(kvm, &iter, new_spte);
+		spte_set = true;
+	}
+
+	rcu_read_unlock();
+
+	return spte_set;
+}
+
+/*
+ * Removes read/write access on the last level SPTE mapping this GFN.
+ * Returns true if an SPTE was set and a TLB flush is needed.
+ */
+bool kvm_tdp_mmu_read_protect_gfn(struct kvm *kvm,
+				  struct kvm_memory_slot *slot, gfn_t gfn,
+				  int min_level)
+{
+	struct kvm_mmu_page *root;
+	bool spte_set = false;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+	for_each_tdp_mmu_root(kvm, root, slot->as_id)
+		spte_set |= read_protect_gfn(kvm, root, gfn, min_level);
+
+	return spte_set;
+}
+
+/*
+ * Removes excute access on the last level SPTE mapping this GFN.
+ * Returns true if an SPTE was set and a TLB flush is needed.
+ */
+static bool exec_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
+			     gfn_t gfn, int min_level)
+{
+	struct tdp_iter iter;
+	u64 new_spte;
+	bool spte_set = false;
+
+	rcu_read_lock();
+
+	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
+				   min_level, gfn, gfn + 1) {
+		if (!is_shadow_present_pte(iter.old_spte) ||
+		    !is_last_spte(iter.old_spte, iter.level))
+			continue;
+
+		if ((iter.old_spte & PT_USER_MASK) == 0)
+			break;
+
+		new_spte = iter.old_spte & ~PT_USER_MASK;
+
+		tdp_mmu_set_spte(kvm, &iter, new_spte);
+		spte_set = true;
+	}
+
+	rcu_read_unlock();
+
+	return spte_set;
+}
+
+/*
+ * Removes excute access on the last level SPTE mapping this GFN.
+ * Returns true if an SPTE was set and a TLB flush is needed.
+ */
+bool kvm_tdp_mmu_exec_protect_gfn(struct kvm *kvm,
+				  struct kvm_memory_slot *slot, gfn_t gfn,
+				  int min_level)
+{
+	struct kvm_mmu_page *root;
+	bool spte_set = false;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+	for_each_tdp_mmu_root(kvm, root, slot->as_id)
+		spte_set |= exec_protect_gfn(kvm, root, gfn, min_level);
+
+	return spte_set;
+}
+
 /*
  * Return the level of the lowest level SPTE added to sptes.
  * That SPTE may be non-present.
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index ceaf7ff3ca7c..5d2d4d62e2f3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -71,6 +71,12 @@ bool kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
 				   int min_level);
+bool kvm_tdp_mmu_read_protect_gfn(struct kvm *kvm,
+				  struct kvm_memory_slot *slot, gfn_t gfn,
+				  int min_level);
+bool kvm_tdp_mmu_exec_protect_gfn(struct kvm *kvm,
+				  struct kvm_memory_slot *slot, gfn_t gfn,
+				  int min_level);
 
 static inline void kvm_tdp_mmu_walk_lockless_begin(void)
 {
