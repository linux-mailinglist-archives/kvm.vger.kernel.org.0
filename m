Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A4635E194
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 16:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343579AbhDMOdc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 10:33:32 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:49706 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237060AbhDMOdJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 10:33:09 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.93.0.4)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1lWJkn-00040N-6x; Tue, 13 Apr 2021 16:10:57 +0200
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
Subject: [PATCH v2 7/8] KVM: Optimize gfn lookup in kvm_zap_gfn_range()
Date:   Tue, 13 Apr 2021 16:10:13 +0200
Message-Id: <2e599cf1c3318207c13cad0a73c1b28b8419dcbe.1618322004.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1618322001.git.maciej.szmigiero@oracle.com>
References: <cover.1618322001.git.maciej.szmigiero@oracle.com>
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
 arch/x86/kvm/mmu/mmu.c   | 41 ++++++++++++++++++++++++++++++++++++++--
 include/linux/kvm_host.h | 22 +++++++++++++++++++++
 2 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 74781c00a420..7e610d3bc819 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5498,14 +5498,51 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	int i;
 	bool flush = false;
 
+	if (gfn_end == gfn_start || WARN_ON(gfn_end < gfn_start))
+		return;
+
 	write_lock(&kvm->mmu_lock);
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
-		int ctr;
+		int idxactive;
+		struct rb_node *node;
 
 		slots = __kvm_memslots(kvm, i);
-		kvm_for_each_memslot(memslot, ctr, slots) {
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
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bb50776a5ebd..884cac86042a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -703,6 +703,28 @@ struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
 	return NULL;
 }
 
+static inline
+struct rb_node *kvm_memslots_gfn_upper_bound(struct kvm_memslots *slots,
+					     gfn_t gfn)
+{
+	int idxactive = kvm_memslots_idx(slots);
+	struct rb_node *node, *result = NULL;
+
+	for (node = slots->gfn_tree.rb_node; node; ) {
+		struct kvm_memory_slot *slot;
+
+		slot = container_of(node, struct kvm_memory_slot,
+				    gfn_node[idxactive]);
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
 /*
  * KVM_SET_USER_MEMORY_REGION ioctl allows the following operations:
  * - create a new memory slot
