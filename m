Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4360946A662
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 20:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbhLFUBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 15:01:22 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:50634 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349539AbhLFUBE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 15:01:04 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1muK6o-00013R-Oe; Mon, 06 Dec 2021 20:57:10 +0100
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
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 28/29] KVM: Wait 'til the bitter end to initialize the "new" memslot
Date:   Mon,  6 Dec 2021 20:54:34 +0100
Message-Id: <a084d0531ca3a826a7f861eb2b08b5d1c06ef265.1638817641.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1638817637.git.maciej.szmigiero@oracle.com>
References: <cover.1638817637.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Initialize the "new" memslot in the !DELETE path only after the various
sanity checks have passed.  This will allow a future commit to allocate
@new dynamically without having to copy a memslot, and without having to
deal with freeing @new in error paths and in the "nothing to change" path
that's hiding in the sanity checks.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 virt/kvm/kvm_main.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4cb97b31eac5..627bd689d5ad 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1845,6 +1845,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	struct kvm_memory_slot new;
 	struct kvm_memslots *slots;
 	enum kvm_mr_change change;
+	unsigned long npages;
+	gfn_t base_gfn;
 	int as_id, id;
 	int r;
 
@@ -1871,6 +1873,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		return -EINVAL;
 	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
 		return -EINVAL;
+	if ((mem->memory_size >> PAGE_SHIFT) > KVM_MEM_MAX_NR_PAGES)
+		return -EINVAL;
 
 	slots = __kvm_memslots(kvm, as_id);
 
@@ -1894,15 +1898,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		return kvm_set_memslot(kvm, old, &new, KVM_MR_DELETE);
 	}
 
-	new.as_id = as_id;
-	new.id = id;
-	new.base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
-	new.npages = mem->memory_size >> PAGE_SHIFT;
-	new.flags = mem->flags;
-	new.userspace_addr = mem->userspace_addr;
-
-	if (new.npages > KVM_MEM_MAX_NR_PAGES)
-		return -EINVAL;
+	base_gfn = (mem->guest_phys_addr >> PAGE_SHIFT);
+	npages = (mem->memory_size >> PAGE_SHIFT);
 
 	if (!old || !old->npages) {
 		change = KVM_MR_CREATE;
@@ -1911,27 +1908,33 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		 * To simplify KVM internals, the total number of pages across
 		 * all memslots must fit in an unsigned long.
 		 */
-		if ((kvm->nr_memslot_pages + new.npages) < kvm->nr_memslot_pages)
+		if ((kvm->nr_memslot_pages + npages) < kvm->nr_memslot_pages)
 			return -EINVAL;
 	} else { /* Modify an existing slot. */
-		if ((new.userspace_addr != old->userspace_addr) ||
-		    (new.npages != old->npages) ||
-		    ((new.flags ^ old->flags) & KVM_MEM_READONLY))
+		if ((mem->userspace_addr != old->userspace_addr) ||
+		    (npages != old->npages) ||
+		    ((mem->flags ^ old->flags) & KVM_MEM_READONLY))
 			return -EINVAL;
 
-		if (new.base_gfn != old->base_gfn)
+		if (base_gfn != old->base_gfn)
 			change = KVM_MR_MOVE;
-		else if (new.flags != old->flags)
+		else if (mem->flags != old->flags)
 			change = KVM_MR_FLAGS_ONLY;
 		else /* Nothing to change. */
 			return 0;
 	}
 
 	if ((change == KVM_MR_CREATE || change == KVM_MR_MOVE) &&
-	    kvm_check_memslot_overlap(slots, id, new.base_gfn,
-				      new.base_gfn + new.npages))
+	    kvm_check_memslot_overlap(slots, id, base_gfn, base_gfn + npages))
 		return -EEXIST;
 
+	new.as_id = as_id;
+	new.id = id;
+	new.base_gfn = base_gfn;
+	new.npages = npages;
+	new.flags = mem->flags;
+	new.userspace_addr = mem->userspace_addr;
+
 	return kvm_set_memslot(kvm, old, &new, change);
 }
 EXPORT_SYMBOL_GPL(__kvm_set_memory_region);
