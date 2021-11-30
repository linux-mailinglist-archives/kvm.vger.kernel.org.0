Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D4646408E
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 22:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344505AbhK3VrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 16:47:14 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:56036 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344443AbhK3Vp4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 16:45:56 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1msAt8-0005wx-8g; Tue, 30 Nov 2021 22:42:10 +0100
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
        Atish Patra <atish.patra@wdc.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 04/29] KVM: Use "new" memslot's address space ID instead of dedicated param
Date:   Tue, 30 Nov 2021 22:41:17 +0100
Message-Id: <b6bc74fe52b089fa8870115547426c7454834476.1638304315.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1638304315.git.maciej.szmigiero@oracle.com>
References: <cover.1638304315.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Now that the address space ID is stored in every slot, including fake
slots used for deletion, use the slot's as_id instead of passing in the
redundant information as a param to kvm_set_memslot().  This will greatly
simplify future memslot work by avoiding passing a large number of
variables around purely to honor @as_id.

Drop a comment in the DELETE path about new->as_id being provided purely
for debug, as that's now a lie.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 virt/kvm/kvm_main.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 95616392ff91..683a5ef6f71e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1553,7 +1553,7 @@ static void kvm_copy_memslots_arch(struct kvm_memslots *to,
 
 static int kvm_set_memslot(struct kvm *kvm,
 			   const struct kvm_userspace_memory_region *mem,
-			   struct kvm_memory_slot *new, int as_id,
+			   struct kvm_memory_slot *new,
 			   enum kvm_mr_change change)
 {
 	struct kvm_memory_slot *slot, old;
@@ -1576,7 +1576,7 @@ static int kvm_set_memslot(struct kvm *kvm,
 	 */
 	mutex_lock(&kvm->slots_arch_lock);
 
-	slots = kvm_dup_memslots(__kvm_memslots(kvm, as_id), change);
+	slots = kvm_dup_memslots(__kvm_memslots(kvm, new->as_id), change);
 	if (!slots) {
 		mutex_unlock(&kvm->slots_arch_lock);
 		return -ENOMEM;
@@ -1596,7 +1596,7 @@ static int kvm_set_memslot(struct kvm *kvm,
 		 * dropped by update_memslots anyway.  We'll also revert to the
 		 * old memslots if preparing the new memory region fails.
 		 */
-		slots = install_new_memslots(kvm, as_id, slots);
+		slots = install_new_memslots(kvm, new->as_id, slots);
 
 		/* From this point no new shadow pages pointing to a deleted,
 		 * or moved, memslot will be created.
@@ -1618,7 +1618,7 @@ static int kvm_set_memslot(struct kvm *kvm,
 		 * to retrieve memslots *after* acquiring slots_arch_lock, thus
 		 * the active memslots are guaranteed to be fresh.
 		 */
-		kvm_copy_memslots_arch(slots, __kvm_memslots(kvm, as_id));
+		kvm_copy_memslots_arch(slots, __kvm_memslots(kvm, new->as_id));
 	}
 
 	/*
@@ -1635,7 +1635,7 @@ static int kvm_set_memslot(struct kvm *kvm,
 		WARN_ON_ONCE(change != KVM_MR_CREATE);
 		memset(&old, 0, sizeof(old));
 		old.id = new->id;
-		old.as_id = as_id;
+		old.as_id = new->as_id;
 	}
 
 	/* Copy the arch-specific data, again after (re)acquiring slots_arch_lock. */
@@ -1646,7 +1646,7 @@ static int kvm_set_memslot(struct kvm *kvm,
 		goto out_slots;
 
 	update_memslots(slots, new, change);
-	slots = install_new_memslots(kvm, as_id, slots);
+	slots = install_new_memslots(kvm, new->as_id, slots);
 
 	/*
 	 * Update the total number of memslot pages before calling the arch
@@ -1668,7 +1668,7 @@ static int kvm_set_memslot(struct kvm *kvm,
 
 out_slots:
 	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
-		slots = install_new_memslots(kvm, as_id, slots);
+		slots = install_new_memslots(kvm, new->as_id, slots);
 	else
 		mutex_unlock(&kvm->slots_arch_lock);
 	kvfree(slots);
@@ -1740,13 +1740,9 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
 		memset(&new, 0, sizeof(new));
 		new.id = id;
-		/*
-		 * This is only for debugging purpose; it should never be
-		 * referenced for a removed memslot.
-		 */
 		new.as_id = as_id;
 
-		return kvm_set_memslot(kvm, mem, &new, as_id, KVM_MR_DELETE);
+		return kvm_set_memslot(kvm, mem, &new, KVM_MR_DELETE);
 	}
 
 	new.as_id = as_id;
@@ -1809,7 +1805,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			bitmap_set(new.dirty_bitmap, 0, new.npages);
 	}
 
-	r = kvm_set_memslot(kvm, mem, &new, as_id, change);
+	r = kvm_set_memslot(kvm, mem, &new, change);
 	if (r)
 		goto out_bitmap;
 
