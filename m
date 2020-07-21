Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0123228AFD
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731336AbgGUVSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:18:41 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37790 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731181AbgGUVP4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:15:56 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 0459F3031FC2;
        Wed, 22 Jul 2020 00:09:24 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id D63B7304FA12;
        Wed, 22 Jul 2020 00:09:23 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 34/84] KVM: x86: page_track: add support for preread, prewrite and preexec
Date:   Wed, 22 Jul 2020 00:08:32 +0300
Message-Id: <20200721210922.7646-35-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
 arch/x86/include/asm/kvm_page_track.h |  48 ++++++++++-
 arch/x86/kvm/mmu.h                    |   4 +
 arch/x86/kvm/mmu/mmu.c                |  81 +++++++++++++++++
 arch/x86/kvm/mmu/page_track.c         | 120 ++++++++++++++++++++++++--
 4 files changed, 243 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 00a66c4d4d3c..c10f0f65c77a 100644
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
@@ -81,7 +122,12 @@ kvm_page_track_register_notifier(struct kvm *kvm,
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
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 444bb9c54548..e2c0518af750 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -222,6 +222,10 @@ void kvm_mmu_gfn_disallow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_gfn_allow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn);
+bool kvm_mmu_slot_gfn_read_protect(struct kvm *kvm,
+				   struct kvm_memory_slot *slot, u64 gfn);
+bool kvm_mmu_slot_gfn_exec_protect(struct kvm *kvm,
+				   struct kvm_memory_slot *slot, u64 gfn);
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu, gpa_t l2_gpa);
 
 int kvm_mmu_post_init_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 038a0e028e77..ede8ef6d1e34 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1579,6 +1579,31 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
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
@@ -1593,6 +1618,32 @@ static bool __rmap_write_protect(struct kvm *kvm,
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
@@ -1768,6 +1819,36 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 	return write_protected;
 }
 
+bool kvm_mmu_slot_gfn_read_protect(struct kvm *kvm,
+				   struct kvm_memory_slot *slot, u64 gfn)
+{
+	struct kvm_rmap_head *rmap_head;
+	bool read_protected = false;
+	int i;
+
+	for (i = PG_LEVEL_4K; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
+		rmap_head = __gfn_to_rmap(gfn, i, slot);
+		read_protected |= __rmap_read_protect(kvm, rmap_head);
+	}
+
+	return read_protected;
+}
+
+bool kvm_mmu_slot_gfn_exec_protect(struct kvm *kvm,
+				   struct kvm_memory_slot *slot, u64 gfn)
+{
+	struct kvm_rmap_head *rmap_head;
+	bool exec_protected = false;
+	int i;
+
+	for (i = PG_LEVEL_4K; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
+		rmap_head = __gfn_to_rmap(gfn, i, slot);
+		exec_protected |= __rmap_exec_protect(kvm, rmap_head);
+	}
+
+	return exec_protected;
+}
+
 static bool rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 {
 	struct kvm_memory_slot *slot;
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 02759b81a04c..b593bcf80be0 100644
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
@@ -95,7 +95,7 @@ static void update_gfn_track(struct kvm_memory_slot *slot, gfn_t gfn,
  * @kvm: the guest instance we are interested in.
  * @slot: the @gfn belongs to.
  * @gfn: the guest page.
- * @mode: tracking mode, currently only write track is supported.
+ * @mode: tracking mode.
  */
 void kvm_slot_page_track_add_page(struct kvm *kvm,
 				  struct kvm_memory_slot *slot, gfn_t gfn,
@@ -113,9 +113,16 @@ void kvm_slot_page_track_add_page(struct kvm *kvm,
 	 */
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
 
-	if (mode == KVM_PAGE_TRACK_WRITE)
+	if (mode == KVM_PAGE_TRACK_PREWRITE || mode == KVM_PAGE_TRACK_WRITE) {
 		if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn))
 			kvm_flush_remote_tlbs(kvm);
+	} else if (mode == KVM_PAGE_TRACK_PREREAD) {
+		if (kvm_mmu_slot_gfn_read_protect(kvm, slot, gfn))
+			kvm_flush_remote_tlbs(kvm);
+	} else if (mode == KVM_PAGE_TRACK_PREEXEC) {
+		if (kvm_mmu_slot_gfn_exec_protect(kvm, slot, gfn))
+			kvm_flush_remote_tlbs(kvm);
+	}
 }
 EXPORT_SYMBOL_GPL(kvm_slot_page_track_add_page);
 
@@ -130,7 +137,7 @@ EXPORT_SYMBOL_GPL(kvm_slot_page_track_add_page);
  * @kvm: the guest instance we are interested in.
  * @slot: the @gfn belongs to.
  * @gfn: the guest page.
- * @mode: tracking mode, currently only write track is supported.
+ * @mode: tracking mode.
  */
 void kvm_slot_page_track_remove_page(struct kvm *kvm,
 				     struct kvm_memory_slot *slot, gfn_t gfn,
@@ -223,12 +230,78 @@ kvm_page_track_unregister_notifier(struct kvm *kvm,
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
+	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
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
+	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
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
@@ -249,12 +322,41 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
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
+	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
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
