Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C48412844
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 23:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343855AbhITVnf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 17:43:35 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:45542 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237356AbhITVlb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 17:41:31 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mSR0q-0006RA-Mm; Mon, 20 Sep 2021 23:39:44 +0200
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
Subject: [PATCH v5 07/13] KVM: Just resync arch fields when slots_arch_lock gets reacquired
Date:   Mon, 20 Sep 2021 23:38:55 +0200
Message-Id: <311810ebd1111bed50d931d424297384171afc36.1632171479.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632171478.git.maciej.szmigiero@oracle.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
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

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 virt/kvm/kvm_main.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 348fae880189..48d182840060 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1482,6 +1482,15 @@ static void kvm_copy_memslots(struct kvm_memslots *to,
 	memcpy(to, from, kvm_memslots_size(from->used_slots));
 }
 
+static void kvm_copy_memslots_arch(struct kvm_memslots *to,
+				   struct kvm_memslots *from)
+{
+	int i;
+
+	for (i = 0; i < from->used_slots; i++)
+		to->memslots[i].arch = from->memslots[i].arch;
+}
+
 /*
  * Note, at a minimum, the current number of used slots must be allocated, even
  * when deleting a memslot, as we need a complete duplicate of the memslots for
@@ -1567,10 +1576,10 @@ static int kvm_set_memslot(struct kvm *kvm,
 		/*
 		 * The arch-specific fields of the memslots could have changed
 		 * between releasing the slots_arch_lock in
-		 * install_new_memslots and here, so get a fresh copy of the
-		 * slots.
+		 * install_new_memslots and here, so get a fresh copy of these
+		 * fields.
 		 */
-		kvm_copy_memslots(slots, __kvm_memslots(kvm, as_id));
+		kvm_copy_memslots_arch(slots, __kvm_memslots(kvm, as_id));
 	}
 
 	r = kvm_arch_prepare_memory_region(kvm, old, new, mem, change);
@@ -1587,8 +1596,6 @@ static int kvm_set_memslot(struct kvm *kvm,
 
 out_slots:
 	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
-		slot = id_to_memslot(slots, old->id);
-		slot->flags &= ~KVM_MEMSLOT_INVALID;
 		slots = install_new_memslots(kvm, as_id, slots);
 	} else {
 		mutex_unlock(&kvm->slots_arch_lock);
