Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D8C412856
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 23:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhITVpC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 17:45:02 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:45692 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241065AbhITVmC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 17:42:02 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mSR1H-0006UY-9d; Mon, 20 Sep 2021 23:40:11 +0200
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
Subject: [PATCH v5 12/13] KVM: Optimize gfn lookup in kvm_zap_gfn_range()
Date:   Mon, 20 Sep 2021 23:39:00 +0200
Message-Id: <062df8ac9eb280440a5f0c11159616b1bbb1c2c4.1632171479.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632171478.git.maciej.szmigiero@oracle.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
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
 arch/x86/kvm/mmu/mmu.c   | 11 +++++--
 include/linux/kvm_host.h | 69 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a05e581ef210..f2859988d630 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5724,18 +5724,25 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	int i;
 	bool flush = false;
 
+	if (WARN_ON_ONCE(gfn_end <= gfn_start))
+		return;
+
 	write_lock(&kvm->mmu_lock);
 
 	kvm_inc_notifier_count(kvm, gfn_start, gfn_end);
 
 	if (kvm_memslots_have_rmaps(kvm)) {
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
-			int bkt;
+			int idx;
+			struct rb_node *node;
 
 			slots = __kvm_memslots(kvm, i);
-			kvm_for_each_memslot(memslot, bkt, slots) {
+			idx = slots->node_idx;
+
+			kvm_for_each_memslot_in_gfn_range(node, slots, gfn_start, gfn_end) {
 				gfn_t start, end;
 
+				memslot = container_of(node, struct kvm_memory_slot, gfn_node[idx]);
 				start = max(gfn_start, memslot->base_gfn);
 				end = min(gfn_end, memslot->base_gfn + memslot->npages);
 				if (start >= end)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6433efff447a..9ae5f7341cf5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -833,6 +833,75 @@ struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
 	return NULL;
 }
 
+static inline
+struct rb_node *kvm_memslots_gfn_upper_bound(struct kvm_memslots *slots, gfn_t gfn)
+{
+	int idx = slots->node_idx;
+	struct rb_node *node, *result = NULL;
+
+	for (node = slots->gfn_tree.rb_node; node; ) {
+		struct kvm_memory_slot *slot;
+
+		slot = container_of(node, struct kvm_memory_slot, gfn_node[idx]);
+		if (gfn < slot->base_gfn) {
+			result = node;
+			node = node->rb_left;
+		} else
+			node = node->rb_right;
+	}
+
+	return result;
+}
+
+static inline
+struct rb_node *kvm_for_each_in_gfn_first(struct kvm_memslots *slots, gfn_t start)
+{
+	struct rb_node *node;
+
+	/*
+	 * Find the slot with the lowest gfn that can possibly intersect with
+	 * the range, so we'll ideally have slot start <= range start
+	 */
+	node = kvm_memslots_gfn_upper_bound(slots, start);
+	if (node) {
+		struct rb_node *pnode;
+
+		/*
+		 * A NULL previous node means that the very first slot
+		 * already has a higher start gfn.
+		 * In this case slot start > range start.
+		 */
+		pnode = rb_prev(node);
+		if (pnode)
+			node = pnode;
+	} else {
+		/* a NULL node below means no slots */
+		node = rb_last(&slots->gfn_tree);
+	}
+
+	return node;
+}
+
+static inline
+bool kvm_for_each_in_gfn_no_more(struct kvm_memslots *slots, struct rb_node *node, gfn_t end)
+{
+	struct kvm_memory_slot *memslot;
+
+	memslot = container_of(node, struct kvm_memory_slot, gfn_node[slots->node_idx]);
+
+	/*
+	 * If this slot starts beyond or at the end of the range so does
+	 * every next one
+	 */
+	return memslot->base_gfn >= end;
+}
+
+/* Iterate over each memslot *possibly* intersecting [start, end) range */
+#define kvm_for_each_memslot_in_gfn_range(node, slots, start, end)	\
+	for (node = kvm_for_each_in_gfn_first(slots, start);		\
+	     node && !kvm_for_each_in_gfn_no_more(slots, node, end);	\
+	     node = rb_next(node))					\
+
 /*
  * KVM_SET_USER_MEMORY_REGION ioctl allows the following operations:
  * - create a new memory slot
