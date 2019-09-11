Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF7CB042F
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 20:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730228AbfIKSum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 14:50:42 -0400
Received: from mga06.intel.com ([134.134.136.31]:39421 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729758AbfIKSul (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 14:50:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Sep 2019 11:50:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="196980864"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga002.jf.intel.com with ESMTP; 11 Sep 2019 11:50:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Marc Zyngier <marc.zyngier@arm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: [PATCH 01/13] KVM: Reinstall old memslots if arch preparation fails
Date:   Wed, 11 Sep 2019 11:50:26 -0700
Message-Id: <20190911185038.24341-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190911185038.24341-1-sean.j.christopherson@intel.com>
References: <20190911185038.24341-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reinstall the old memslots if preparing the new memory region fails
after invalidating a to-be-{re}moved memslot.

Remove the superfluous 'old_memslots' variable so that it's somewhat
clear that the error handling path needs to free the unused memslots,
not simply the 'old' memslots.

Fixes: bc6678a33d9b9 ("KVM: introduce kvm->srcu and convert kvm_set_memory_region to SRCU update")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 virt/kvm/kvm_main.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c6a91b044d8d..daa5de5b3f88 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -923,7 +923,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	unsigned long npages;
 	struct kvm_memory_slot *slot;
 	struct kvm_memory_slot old, new;
-	struct kvm_memslots *slots = NULL, *old_memslots;
+	struct kvm_memslots *slots;
 	int as_id, id;
 	enum kvm_mr_change change;
 
@@ -1031,7 +1031,13 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		slot = id_to_memslot(slots, id);
 		slot->flags |= KVM_MEMSLOT_INVALID;
 
-		old_memslots = install_new_memslots(kvm, as_id, slots);
+		/*
+		 * We can re-use the old memslots, the only difference from the
+		 * newly installed memslots is the invalid flag, which will get
+		 * dropped by update_memslots anyway.  We'll also revert to the
+		 * old memslots if preparing the new memory region fails.
+		 */
+		slots = install_new_memslots(kvm, as_id, slots);
 
 		/* From this point no new shadow pages pointing to a deleted,
 		 * or moved, memslot will be created.
@@ -1041,13 +1047,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		 *	- kvm_is_visible_gfn (mmu_check_roots)
 		 */
 		kvm_arch_flush_shadow_memslot(kvm, slot);
-
-		/*
-		 * We can re-use the old_memslots from above, the only difference
-		 * from the currently installed memslots is the invalid flag.  This
-		 * will get overwritten by update_memslots anyway.
-		 */
-		slots = old_memslots;
 	}
 
 	r = kvm_arch_prepare_memory_region(kvm, &new, mem, change);
@@ -1061,15 +1060,17 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	}
 
 	update_memslots(slots, &new, change);
-	old_memslots = install_new_memslots(kvm, as_id, slots);
+	slots = install_new_memslots(kvm, as_id, slots);
 
 	kvm_arch_commit_memory_region(kvm, mem, &old, &new, change);
 
 	kvm_free_memslot(kvm, &old, &new);
-	kvfree(old_memslots);
+	kvfree(slots);
 	return 0;
 
 out_slots:
+	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
+		slots = install_new_memslots(kvm, as_id, slots);
 	kvfree(slots);
 out_free:
 	kvm_free_memslot(kvm, &new, &old);
-- 
2.22.0

