Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9B2E4020
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 01:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387960AbfJXXIp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 19:08:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:23483 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387509AbfJXXHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 19:07:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 16:07:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,226,1569308400"; 
   d="scan'208";a="202445853"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 24 Oct 2019 16:07:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH v3 08/15] KVM: Move setting of memslot into helper routine
Date:   Thu, 24 Oct 2019 16:07:37 -0700
Message-Id: <20191024230744.14543-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191024230744.14543-1-sean.j.christopherson@intel.com>
References: <20191024230744.14543-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split out the core functionality of setting a memslot into a separate
helper in preparation for moving memslot deletion into its own routine.

Tested-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 virt/kvm/kvm_main.c | 106 ++++++++++++++++++++++++++------------------
 1 file changed, 63 insertions(+), 43 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e2f47d60f696..860de4fadce6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -920,6 +920,66 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 	return old_memslots;
 }
 
+static int kvm_set_memslot(struct kvm *kvm,
+			   const struct kvm_userspace_memory_region *mem,
+			   const struct kvm_memory_slot *old,
+			   struct kvm_memory_slot *new, int as_id,
+			   enum kvm_mr_change change)
+{
+	struct kvm_memory_slot *slot;
+	struct kvm_memslots *slots;
+	int r;
+
+	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
+	if (!slots)
+		return -ENOMEM;
+	memcpy(slots, __kvm_memslots(kvm, as_id), sizeof(struct kvm_memslots));
+
+	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
+		/*
+		 * Note, the INVALID flag needs to be in the appropriate entry
+		 * in the freshly allocated memslots, not in @old or @new.
+		 */
+		slot = id_to_memslot(slots, old->id);
+		slot->flags |= KVM_MEMSLOT_INVALID;
+
+		/*
+		 * We can re-use the old memslots, the only difference from the
+		 * newly installed memslots is the invalid flag, which will get
+		 * dropped by update_memslots anyway.  We'll also revert to the
+		 * old memslots if preparing the new memory region fails.
+		 */
+		slots = install_new_memslots(kvm, as_id, slots);
+
+		/* From this point no new shadow pages pointing to a deleted,
+		 * or moved, memslot will be created.
+		 *
+		 * validation of sp->gfn happens in:
+		 *	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
+		 *	- kvm_is_visible_gfn (mmu_check_roots)
+		 */
+		kvm_arch_flush_shadow_memslot(kvm, slot);
+	}
+
+	r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
+	if (r)
+		goto out_slots;
+
+	update_memslots(slots, new, change);
+	slots = install_new_memslots(kvm, as_id, slots);
+
+	kvm_arch_commit_memory_region(kvm, mem, old, new, change);
+
+	kvfree(slots);
+	return 0;
+
+out_slots:
+	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
+		slots = install_new_memslots(kvm, as_id, slots);
+	kvfree(slots);
+	return r;
+}
+
 /*
  * Allocate some memory and give it an address in the guest physical address
  * space.
@@ -936,7 +996,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	unsigned long npages;
 	struct kvm_memory_slot *slot;
 	struct kvm_memory_slot old, new;
-	struct kvm_memslots *slots;
 	int as_id, id;
 	enum kvm_mr_change change;
 
@@ -1023,58 +1082,19 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			return r;
 	}
 
-	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
-	if (!slots) {
-		r = -ENOMEM;
-		goto out_bitmap;
-	}
-	memcpy(slots, __kvm_memslots(kvm, as_id), sizeof(struct kvm_memslots));
-
-	if ((change == KVM_MR_DELETE) || (change == KVM_MR_MOVE)) {
-		slot = id_to_memslot(slots, id);
-		slot->flags |= KVM_MEMSLOT_INVALID;
-
-		/*
-		 * We can re-use the old memslots, the only difference from the
-		 * newly installed memslots is the invalid flag, which will get
-		 * dropped by update_memslots anyway.  We'll also revert to the
-		 * old memslots if preparing the new memory region fails.
-		 */
-		slots = install_new_memslots(kvm, as_id, slots);
-
-		/* From this point no new shadow pages pointing to a deleted,
-		 * or moved, memslot will be created.
-		 *
-		 * validation of sp->gfn happens in:
-		 *	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
-		 *	- kvm_is_visible_gfn (mmu_check_roots)
-		 */
-		kvm_arch_flush_shadow_memslot(kvm, slot);
-	}
-
-	r = kvm_arch_prepare_memory_region(kvm, &new, mem, change);
-	if (r)
-		goto out_slots;
-
 	/* actual memory is freed via old in kvm_free_memslot below */
 	if (change == KVM_MR_DELETE) {
 		new.dirty_bitmap = NULL;
 		memset(&new.arch, 0, sizeof(new.arch));
 	}
 
-	update_memslots(slots, &new, change);
-	slots = install_new_memslots(kvm, as_id, slots);
-
-	kvm_arch_commit_memory_region(kvm, mem, &old, &new, change);
+	r = kvm_set_memslot(kvm, mem, &old, &new, as_id, change);
+	if (r)
+		goto out_bitmap;
 
 	kvm_free_memslot(kvm, &old, &new);
-	kvfree(slots);
 	return 0;
 
-out_slots:
-	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
-		slots = install_new_memslots(kvm, as_id, slots);
-	kvfree(slots);
 out_bitmap:
 	if (new.dirty_bitmap && !old.dirty_bitmap)
 		kvm_destroy_dirty_bitmap(&new);
-- 
2.22.0

