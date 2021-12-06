Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA63A46A63C
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 20:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349231AbhLFT7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 14:59:54 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:50134 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349155AbhLFT7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 14:59:43 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1muK5W-0000sU-Qi; Mon, 06 Dec 2021 20:55:50 +0100
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
Subject: [PATCH v7 13/29] KVM: Use prepare/commit hooks to handle generic memslot metadata updates
Date:   Mon,  6 Dec 2021 20:54:19 +0100
Message-Id: <2ddd5446e3706fe3c1e52e3df279f04c458be830.1638817640.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1638817637.git.maciej.szmigiero@oracle.com>
References: <cover.1638817637.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Handle the generic memslot metadata, a.k.a. dirty bitmap, updates at the
same time that arch handles it's own metadata updates, i.e. at memslot
prepare and commit.  This will simplify converting @new to a dynamically
allocated object, and more closely aligns common KVM with architecture
code.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 virt/kvm/kvm_main.c | 109 +++++++++++++++++++++++++++-----------------
 1 file changed, 66 insertions(+), 43 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b778b8ab1885..1689f598fe9e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1551,6 +1551,69 @@ static void kvm_copy_memslots_arch(struct kvm_memslots *to,
 		to->memslots[i].arch = from->memslots[i].arch;
 }
 
+static int kvm_prepare_memory_region(struct kvm *kvm,
+				     const struct kvm_memory_slot *old,
+				     struct kvm_memory_slot *new,
+				     enum kvm_mr_change change)
+{
+	int r;
+
+	/*
+	 * If dirty logging is disabled, nullify the bitmap; the old bitmap
+	 * will be freed on "commit".  If logging is enabled in both old and
+	 * new, reuse the existing bitmap.  If logging is enabled only in the
+	 * new and KVM isn't using a ring buffer, allocate and initialize a
+	 * new bitmap.
+	 */
+	if (!(new->flags & KVM_MEM_LOG_DIRTY_PAGES))
+		new->dirty_bitmap = NULL;
+	else if (old->dirty_bitmap)
+		new->dirty_bitmap = old->dirty_bitmap;
+	else if (!kvm->dirty_ring_size) {
+		r = kvm_alloc_dirty_bitmap(new);
+		if (r)
+			return r;
+
+		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
+			bitmap_set(new->dirty_bitmap, 0, new->npages);
+	}
+
+	r = kvm_arch_prepare_memory_region(kvm, old, new, change);
+
+	/* Free the bitmap on failure if it was allocated above. */
+	if (r && new->dirty_bitmap && !old->dirty_bitmap)
+		kvm_destroy_dirty_bitmap(new);
+
+	return r;
+}
+
+static void kvm_commit_memory_region(struct kvm *kvm,
+				     struct kvm_memory_slot *old,
+				     const struct kvm_memory_slot *new,
+				     enum kvm_mr_change change)
+{
+	/*
+	 * Update the total number of memslot pages before calling the arch
+	 * hook so that architectures can consume the result directly.
+	 */
+	if (change == KVM_MR_DELETE)
+		kvm->nr_memslot_pages -= old->npages;
+	else if (change == KVM_MR_CREATE)
+		kvm->nr_memslot_pages += new->npages;
+
+	kvm_arch_commit_memory_region(kvm, old, new, change);
+
+	/*
+	 * Free the old memslot's metadata.  On DELETE, free the whole thing,
+	 * otherwise free the dirty bitmap as needed (the below effectively
+	 * checks both the flags and whether a ring buffer is being used).
+	 */
+	if (change == KVM_MR_DELETE)
+		kvm_free_memslot(kvm, old);
+	else if (old->dirty_bitmap && !new->dirty_bitmap)
+		kvm_destroy_dirty_bitmap(old);
+}
+
 static int kvm_set_memslot(struct kvm *kvm,
 			   struct kvm_memory_slot *new,
 			   enum kvm_mr_change change)
@@ -1637,27 +1700,14 @@ static int kvm_set_memslot(struct kvm *kvm,
 		old.as_id = new->as_id;
 	}
 
-	r = kvm_arch_prepare_memory_region(kvm, &old, new, change);
+	r = kvm_prepare_memory_region(kvm, &old, new, change);
 	if (r)
 		goto out_slots;
 
 	update_memslots(slots, new, change);
 	slots = install_new_memslots(kvm, new->as_id, slots);
 
-	/*
-	 * Update the total number of memslot pages before calling the arch
-	 * hook so that architectures can consume the result directly.
-	 */
-	if (change == KVM_MR_DELETE)
-		kvm->nr_memslot_pages -= old.npages;
-	else if (change == KVM_MR_CREATE)
-		kvm->nr_memslot_pages += new->npages;
-
-	kvm_arch_commit_memory_region(kvm, &old, new, change);
-
-	/* Free the old memslot's metadata.  Note, this is the full copy!!! */
-	if (change == KVM_MR_DELETE)
-		kvm_free_memslot(kvm, &old);
+	kvm_commit_memory_region(kvm, &old, new, change);
 
 	kvfree(slots);
 	return 0;
@@ -1753,7 +1803,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
 	if (!old.npages) {
 		change = KVM_MR_CREATE;
-		new.dirty_bitmap = NULL;
 
 		/*
 		 * To simplify KVM internals, the total number of pages across
@@ -1773,9 +1822,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			change = KVM_MR_FLAGS_ONLY;
 		else /* Nothing to change. */
 			return 0;
-
-		/* Copy dirty_bitmap from the current memslot. */
-		new.dirty_bitmap = old.dirty_bitmap;
 	}
 
 	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
@@ -1789,30 +1835,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		}
 	}
 
-	/* Allocate/free page dirty bitmap as needed */
-	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES))
-		new.dirty_bitmap = NULL;
-	else if (!new.dirty_bitmap && !kvm->dirty_ring_size) {
-		r = kvm_alloc_dirty_bitmap(&new);
-		if (r)
-			return r;
-
-		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
-			bitmap_set(new.dirty_bitmap, 0, new.npages);
-	}
-
-	r = kvm_set_memslot(kvm, &new, change);
-	if (r)
-		goto out_bitmap;
-
-	if (old.dirty_bitmap && !new.dirty_bitmap)
-		kvm_destroy_dirty_bitmap(&old);
-	return 0;
-
-out_bitmap:
-	if (new.dirty_bitmap && !old.dirty_bitmap)
-		kvm_destroy_dirty_bitmap(&new);
-	return r;
+	return kvm_set_memslot(kvm, &new, change);
 }
 EXPORT_SYMBOL_GPL(__kvm_set_memory_region);
 
