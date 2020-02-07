Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9662F155DB7
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbgBGSQu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:16:50 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40748 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727117AbgBGSQt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:49 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 10C0F305D3F4;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 015D2305207A;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 32/78] KVM: x86: page_track: add support for preread, prewrite and preexec
Date:   Fri,  7 Feb 2020 20:15:50 +0200
Message-Id: <20200207181636.1065-33-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

These callbacks return a boolean value. If false, the emulation should
stop and the instruction should be reexecuted in guest.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_page_track.h |  48 ++++++++++-
 arch/x86/kvm/mmu.h                    |   4 +
 arch/x86/kvm/mmu/mmu.c                |  81 +++++++++++++++++
 arch/x86/kvm/mmu/page_track.c         | 120 ++++++++++++++++++++++++--
 4 files changed, 243 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index dc528c6f2eb0..646cbfa07676 100644
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
@@ -82,7 +123,12 @@ kvm_page_track_register_notifier(struct kvm *kvm,
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
index d55674f44a18..b3a20fc98c69 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -209,6 +209,10 @@ void kvm_mmu_gfn_disallow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_gfn_allow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn);
+bool kvm_mmu_slot_gfn_read_protect(struct kvm *kvm,
+				   struct kvm_memory_slot *slot, u64 gfn);
+bool kvm_mmu_slot_gfn_exec_protect(struct kvm *kvm,
+				   struct kvm_memory_slot *slot, u64 gfn);
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_post_init_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f2e016dfffe6..124e7ca73b48 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1648,6 +1648,31 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
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
@@ -1662,6 +1687,32 @@ static bool __rmap_write_protect(struct kvm *kvm,
 	return flush;
 }
 
+static bool __rmap_read_protect(struct kvm *kvm,
+				struct kvm_rmap_head *rmap_head)
+{
+	u64 *sptep;
+	struct rmap_iterator iter;
+	bool flush = false;
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
+	u64 *sptep;
+	struct rmap_iterator iter;
+	bool flush = false;
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
@@ -1837,6 +1888,36 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 	return write_protected;
 }
 
+bool kvm_mmu_slot_gfn_read_protect(struct kvm *kvm,
+				   struct kvm_memory_slot *slot, u64 gfn)
+{
+	struct kvm_rmap_head *rmap_head;
+	int i;
+	bool read_protected = false;
+
+	for (i = PT_PAGE_TABLE_LEVEL; i <= PT_MAX_HUGEPAGE_LEVEL; ++i) {
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
+	int i;
+	bool exec_protected = false;
+
+	for (i = PT_PAGE_TABLE_LEVEL; i <= PT_MAX_HUGEPAGE_LEVEL; ++i) {
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
index f36e74430ad2..cc3eb2cc7e38 100644
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
@@ -99,7 +99,7 @@ static void update_gfn_track(struct kvm_memory_slot *slot, gfn_t gfn,
  * @kvm: the guest instance we are interested in.
  * @slot: the @gfn belongs to.
  * @gfn: the guest page.
- * @mode: tracking mode, currently only write track is supported.
+ * @mode: tracking mode.
  */
 void kvm_slot_page_track_add_page(struct kvm *kvm,
 				  struct kvm_memory_slot *slot, gfn_t gfn,
@@ -117,9 +117,16 @@ void kvm_slot_page_track_add_page(struct kvm *kvm,
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
 
@@ -134,7 +141,7 @@ EXPORT_SYMBOL_GPL(kvm_slot_page_track_add_page);
  * @kvm: the guest instance we are interested in.
  * @slot: the @gfn belongs to.
  * @gfn: the guest page.
- * @mode: tracking mode, currently only write track is supported.
+ * @mode: tracking mode.
  */
 void kvm_slot_page_track_remove_page(struct kvm *kvm,
 				     struct kvm_memory_slot *slot, gfn_t gfn,
@@ -227,12 +234,78 @@ kvm_page_track_unregister_notifier(struct kvm *kvm,
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
@@ -253,12 +326,41 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
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
