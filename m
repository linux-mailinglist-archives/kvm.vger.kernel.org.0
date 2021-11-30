Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78E9464074
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 22:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244225AbhK3Vp7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 16:45:59 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:56016 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344438AbhK3Vpz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 16:45:55 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1msAt2-0005wX-RT; Tue, 30 Nov 2021 22:42:04 +0100
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
Subject: [PATCH v6 03/29] KVM: Resync only arch fields when slots_arch_lock gets reacquired
Date:   Tue, 30 Nov 2021 22:41:16 +0100
Message-Id: <a47c93c2fe40e7ed27eb0ff6ac2b173254058b6c.1638304315.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1638304315.git.maciej.szmigiero@oracle.com>
References: <cover.1638304315.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

There is no need to copy the whole memslot data after releasing
slots_arch_lock for a moment to install temporary memslots copy in
kvm_set_memslot() since this lock only protects the arch field of each
memslot.

Just resync this particular field after reacquiring slots_arch_lock.

Note, this also eliminates the need to manually clear the INVALID flag
when restoring memslots; the "setting" of the INVALID flag was an
unwanted side effect of copying the entire memslots.

Since kvm_copy_memslots() has just one caller remaining now
open-code it instead.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
[sean: tweak shortlog, note INVALID flag in changelog, revert comment]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 049f98238992..95616392ff91 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1517,12 +1517,6 @@ static size_t kvm_memslots_size(int slots)
 	       (sizeof(struct kvm_memory_slot) * slots);
 }
 
-static void kvm_copy_memslots(struct kvm_memslots *to,
-			      struct kvm_memslots *from)
-{
-	memcpy(to, from, kvm_memslots_size(from->used_slots));
-}
-
 /*
  * Note, at a minimum, the current number of used slots must be allocated, even
  * when deleting a memslot, as we need a complete duplicate of the memslots for
@@ -1541,11 +1535,22 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
 
 	slots = kvzalloc(new_size, GFP_KERNEL_ACCOUNT);
 	if (likely(slots))
-		kvm_copy_memslots(slots, old);
+		memcpy(slots, old, kvm_memslots_size(old->used_slots));
 
 	return slots;
 }
 
+static void kvm_copy_memslots_arch(struct kvm_memslots *to,
+				   struct kvm_memslots *from)
+{
+	int i;
+
+	WARN_ON_ONCE(to->used_slots != from->used_slots);
+
+	for (i = 0; i < from->used_slots; i++)
+		to->memslots[i].arch = from->memslots[i].arch;
+}
+
 static int kvm_set_memslot(struct kvm *kvm,
 			   const struct kvm_userspace_memory_region *mem,
 			   struct kvm_memory_slot *new, int as_id,
@@ -1586,9 +1591,10 @@ static int kvm_set_memslot(struct kvm *kvm,
 		slot->flags |= KVM_MEMSLOT_INVALID;
 
 		/*
-		 * We can re-use the memory from the old memslots.
-		 * It will be overwritten with a copy of the new memslots
-		 * after reacquiring the slots_arch_lock below.
+		 * We can re-use the old memslots, the only difference from the
+		 * newly installed memslots is the invalid flag, which will get
+		 * dropped by update_memslots anyway.  We'll also revert to the
+		 * old memslots if preparing the new memory region fails.
 		 */
 		slots = install_new_memslots(kvm, as_id, slots);
 
@@ -1605,12 +1611,14 @@ static int kvm_set_memslot(struct kvm *kvm,
 		mutex_lock(&kvm->slots_arch_lock);
 
 		/*
-		 * The arch-specific fields of the memslots could have changed
-		 * between releasing the slots_arch_lock in
-		 * install_new_memslots and here, so get a fresh copy of the
-		 * slots.
+		 * The arch-specific fields of the now-active memslots could
+		 * have been modified between releasing slots_arch_lock in
+		 * install_new_memslots and re-acquiring slots_arch_lock above.
+		 * Copy them to the inactive memslots.  Arch code is required
+		 * to retrieve memslots *after* acquiring slots_arch_lock, thus
+		 * the active memslots are guaranteed to be fresh.
 		 */
-		kvm_copy_memslots(slots, __kvm_memslots(kvm, as_id));
+		kvm_copy_memslots_arch(slots, __kvm_memslots(kvm, as_id));
 	}
 
 	/*
@@ -1659,13 +1667,10 @@ static int kvm_set_memslot(struct kvm *kvm,
 	return 0;
 
 out_slots:
-	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
-		slot = id_to_memslot(slots, new->id);
-		slot->flags &= ~KVM_MEMSLOT_INVALID;
+	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
 		slots = install_new_memslots(kvm, as_id, slots);
-	} else {
+	else
 		mutex_unlock(&kvm->slots_arch_lock);
-	}
 	kvfree(slots);
 	return r;
 }
