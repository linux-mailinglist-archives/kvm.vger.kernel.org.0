Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6324444C77
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 01:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbhKDAao (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 20:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbhKDA3R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 20:29:17 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A354C061203
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 17:26:40 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id q2-20020a170902dac200b001422673d86fso1025675plx.20
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 17:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=7rzhcX7MhxExPYBH2airLxvO3D/6cRPAJqYqBvFLkLI=;
        b=glYV1AwCXiCDMEzeHKJeBM7t5OOl/RIHw91NlGWfABgcjYJRSOPOw7GJRnkYACGeGR
         OtpZPEuTh6v3GqcOOsOB/46At1eJGTxMXgU/4c3t/Hj5zV58di7o7voo03nMlGivkhaY
         JoBBb1LkxqBIUVtFOxMZCYnn3HHaVkEs0wL2aEdpGRexTSo3rgI0NcRpK8O+0+jGrEFL
         /Ysjs1hlWs/4G8AfeSe2g1AGYGLsspoz6XqSGx1Z9H6dfSE1rIw8k3FWXRmftP8+qBE9
         TI3jFj5zOOpeOJ5i/kx6GCn+0CaKSq4eOjXJNyUT9qDIGajUuDTcGhPVPnls/gbXVU4g
         ChWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=7rzhcX7MhxExPYBH2airLxvO3D/6cRPAJqYqBvFLkLI=;
        b=iKc2luvxONhyQKJwsXimp58wKrbcIB5J8Q4g2s1LMznJlvAToVcZw0nM2x2l37G99C
         oXKZGrbTahkTPdfd5+EXJP8/DPYD/O362wgQxSPPmN5J89YcjngFjYQ1ozftNu4VBboj
         faX2pZWxu+2U6Fiy93IUTUtkws4CMhNeXh2EWc0IzuMOxuRGt8UdePJHfr/9TzEmjxL/
         8EqTulpE7K1Hl9wwSy88GfbVMj+1TUv+ogL82297mB1RHJYEspTeuGMf6pWPpLTyXJi/
         5PvhEF9pMS9F01tV7XZRr0jxrOcO3Bk4MWfwTPKf8VM2+GJfQDh/9CPLK1TGlqVYSUek
         GOVw==
X-Gm-Message-State: AOAM532Xcbrg7pmZvnF6+qHtyFVUuNyMNyQTyTgR6UACgvmh/kHl2s+L
        kR/OrZpBZ57wTlG9Acc88Nfi1Uc8m9I=
X-Google-Smtp-Source: ABdhPJw+suRRBiZu3StiwU37JwgZC93JimIk+hnUmSuDbQX1c0RQsyp1eUCtkfUaD/MUVYbOsMPkNBO+zXU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:18b:b0:141:eda2:d5fa with SMTP id
 z11-20020a170903018b00b00141eda2d5famr21586756plg.63.1635985599965; Wed, 03
 Nov 2021 17:26:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Nov 2021 00:25:25 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-25-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 24/30] KVM: Use interval tree to do fast hva lookup in memslots
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

The current memslots implementation only allows quick binary search by gfn,
quick lookup by hva is not possible - the implementation has to do a linear
scan of the whole memslots array, even though the operation being performed
might apply just to a single memslot.

This significantly hurts performance of per-hva operations with higher
memslot counts.

Since hva ranges can overlap between memslots an interval tree is needed
for tracking them.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
[sean: handle interval tree updates in kvm_replace_memslot()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/Kconfig   |  1 +
 arch/mips/kvm/Kconfig    |  1 +
 arch/powerpc/kvm/Kconfig |  1 +
 arch/s390/kvm/Kconfig    |  1 +
 arch/x86/kvm/Kconfig     |  1 +
 include/linux/kvm_host.h |  3 ++
 virt/kvm/kvm_main.c      | 60 +++++++++++++++++++++++++++++-----------
 7 files changed, 52 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index d7eec0b43744..42185dcc9596 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -38,6 +38,7 @@ menuconfig KVM
 	select HAVE_KVM_IRQ_BYPASS
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
+	select INTERVAL_TREE
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index a77297480f56..91d197bee9c0 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -27,6 +27,7 @@ config KVM
 	select KVM_MMIO
 	select MMU_NOTIFIER
 	select SRCU
+	select INTERVAL_TREE
 	help
 	  Support for hosting Guest kernels.
 
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index ff581d70f20c..e4c24f524ba8 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -26,6 +26,7 @@ config KVM
 	select KVM_VFIO
 	select IRQ_BYPASS_MANAGER
 	select HAVE_KVM_IRQ_BYPASS
+	select INTERVAL_TREE
 
 config KVM_BOOK3S_HANDLER
 	bool
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
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 619186138176..7618bef0a4a9 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -43,6 +43,7 @@ config KVM
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_VFIO
 	select SRCU
+	select INTERVAL_TREE
 	select HAVE_KVM_PM_NOTIFIER if PM
 	help
 	  Support hosting fully virtualized guest machines using hardware
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 81003e3acd53..d0363e2ba098 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -30,6 +30,7 @@
 #include <linux/nospec.h>
 #include <linux/notifier.h>
 #include <linux/hashtable.h>
+#include <linux/interval_tree.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -427,6 +428,7 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
 
 struct kvm_memory_slot {
 	struct hlist_node id_node;
+	struct interval_tree_node hva_node;
 	gfn_t base_gfn;
 	unsigned long npages;
 	unsigned long *dirty_bitmap;
@@ -528,6 +530,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
  */
 struct kvm_memslots {
 	u64 generation;
+	struct rb_root_cached hva_tree;
 	/* The mapping table from slot id to the index in memslots[]. */
 	DECLARE_HASHTABLE(id_hash, 7);
 	atomic_t last_used_slot;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 13c497abaab8..f2235c430e64 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -498,6 +498,12 @@ static void kvm_null_fn(void)
 }
 #define IS_KVM_NULL_FN(fn) ((fn) == (void *)kvm_null_fn)
 
+/* Iterate over each memslot intersecting [start, last] (inclusive) range */
+#define kvm_for_each_memslot_in_hva_range(node, slots, start, last)	     \
+	for (node = interval_tree_iter_first(&slots->hva_tree, start, last); \
+	     node;							     \
+	     node = interval_tree_iter_next(node, start, last))	     \
+
 static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 						  const struct kvm_hva_range *range)
 {
@@ -507,6 +513,9 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 	struct kvm_memslots *slots;
 	int i, idx;
 
+	if (WARN_ON_ONCE(range->end <= range->start))
+		return 0;
+
 	/* A null handler is allowed if and only if on_lock() is provided. */
 	if (WARN_ON_ONCE(IS_KVM_NULL_FN(range->on_lock) &&
 			 IS_KVM_NULL_FN(range->handler)))
@@ -515,15 +524,17 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 	idx = srcu_read_lock(&kvm->srcu);
 
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		struct interval_tree_node *node;
+
 		slots = __kvm_memslots(kvm, i);
-		kvm_for_each_memslot(slot, slots) {
+		kvm_for_each_memslot_in_hva_range(node, slots,
+						  range->start, range->end - 1) {
 			unsigned long hva_start, hva_end;
 
+			slot = container_of(node, struct kvm_memory_slot, hva_node);
 			hva_start = max(range->start, slot->userspace_addr);
 			hva_end = min(range->end, slot->userspace_addr +
 						  (slot->npages << PAGE_SHIFT));
-			if (hva_start >= hva_end)
-				continue;
 
 			/*
 			 * To optimize for the likely case where the address
@@ -859,6 +870,7 @@ static struct kvm_memslots *kvm_alloc_memslots(void)
 	if (!slots)
 		return NULL;
 
+	slots->hva_tree = RB_ROOT_CACHED;
 	hash_init(slots->id_hash);
 
 	return slots;
@@ -1262,22 +1274,32 @@ static void kvm_replace_memslot(struct kvm_memslots *slots,
 				struct kvm_memory_slot *new)
 {
 	/*
-	 * Remove the old memslot from the hash list, copying the node data
-	 * would corrupt the list.
+	 * Remove the old memslot from the hash list and interval tree, copying
+	 * the node data would corrupt the structures.
 	 */
 	if (old) {
 		hash_del(&old->id_node);
+		interval_tree_remove(&old->hva_node, &slots->hva_tree);
 
 		if (!new)
 			return;
 	}
 
-	/* Copy the source *data*, not the pointer, to the destination. */
-	if (old)
+	/*
+	 * Copy the source *data*, not the pointer, to the destination.  If
+	 * @old is NULL, initialize @new's hva range.
+	 */
+	if (old) {
 		*new = *old;
+	} else if (new) {
+		new->hva_node.start = new->userspace_addr;
+		new->hva_node.last = new->userspace_addr +
+				     (new->npages << PAGE_SHIFT) - 1;
+	}
 
 	/* (Re)Add the new memslot. */
 	hash_add(slots->id_hash, &new->id_node, new->id);
+	interval_tree_insert(&new->hva_node, &slots->hva_tree);
 }
 
 static void kvm_shift_memslot(struct kvm_memslots *slots, int dst, int src)
@@ -1308,7 +1330,7 @@ static inline void kvm_memslot_delete(struct kvm_memslots *slots,
 		atomic_set(&slots->last_used_slot, 0);
 
 	/*
-	 * Remove the to-be-deleted memslot from the list _before_ shifting
+	 * Remove the to-be-deleted memslot from the list/tree _before_ shifting
 	 * the trailing memslots forward, its data will be overwritten.
 	 * Defer the (somewhat pointless) copying of the memslot until after
 	 * the last slot has been shifted to avoid overwriting said last slot.
@@ -1335,7 +1357,8 @@ static inline int kvm_memslot_insert_back(struct kvm_memslots *slots)
  * itself is not preserved in the array, i.e. not swapped at this time, only
  * its new index into the array is tracked.  Returns the changed memslot's
  * current index into the memslots array.
- * The memslot at the returned index will not be in @slots->id_hash by then.
+ * The memslot at the returned index will not be in @slots->hva_tree or
+ * @slots->id_hash by then.
  * @memslot is a detached struct with desired final data of the changed slot.
  */
 static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
@@ -1349,10 +1372,10 @@ static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
 		return -1;
 
 	/*
-	 * Delete the slot from the hash table before sorting the remaining
-	 * slots, the slot's data may be overwritten when copying slots as part
-	 * of the sorting proccess.  update_memslots() will unconditionally
-	 * rewrite the entire slot and re-add it to the hash table.
+	 * Delete the slot from the hash table and interval tree before sorting
+	 * the remaining slots, the slot's data may be overwritten when copying
+	 * slots as part of the sorting proccess.  update_memslots() will
+	 * unconditionally rewrite and re-add the entire slot.
 	 */
 	kvm_replace_memslot(slots, oldslot, NULL);
 
@@ -1378,10 +1401,12 @@ static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
  * is not preserved in the array, i.e. not swapped at this time, only its new
  * index into the array is tracked.  Returns the changed memslot's final index
  * into the memslots array.
- * The memslot at the returned index will not be in @slots->id_hash by then.
+ * The memslot at the returned index will not be in @slots->hva_tree or
+ * @slots->id_hash by then.
  * @memslot is a detached struct with desired final data of the new or
  * changed slot.
- * Assumes that the memslot at @start index is not in @slots->id_hash.
+ * Assumes that the memslot at @start index is not in @slots->hva_tree or
+ * @slots->id_hash.
  */
 static inline int kvm_memslot_move_forward(struct kvm_memslots *slots,
 					   struct kvm_memory_slot *memslot,
@@ -1574,9 +1599,12 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
 
 	memcpy(slots, old, kvm_memslots_size(old->used_slots));
 
+	slots->hva_tree = RB_ROOT_CACHED;
 	hash_init(slots->id_hash);
-	kvm_for_each_memslot(memslot, slots)
+	kvm_for_each_memslot(memslot, slots) {
+		interval_tree_insert(&memslot->hva_node, &slots->hva_tree);
 		hash_add(slots->id_hash, &memslot->id_node, memslot->id);
+	}
 
 	return slots;
 }
-- 
2.33.1.1089.g2158813163f-goog

