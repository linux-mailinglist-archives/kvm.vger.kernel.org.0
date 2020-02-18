Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA641633EB
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 22:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbgBRVHy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 16:07:54 -0500
Received: from mga07.intel.com ([134.134.136.100]:6399 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727624AbgBRVHx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 16:07:53 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 13:07:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,457,1574150400"; 
   d="scan'208";a="253856472"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 18 Feb 2020 13:07:47 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v6 22/22] KVM: x86/mmu: Consolidate open coded variants of memslot TLB flushes
Date:   Tue, 18 Feb 2020 13:07:36 -0800
Message-Id: <20200218210736.16432-23-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218210736.16432-1-sean.j.christopherson@intel.com>
References: <20200218210736.16432-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace open coded instances of kvm_arch_flush_remote_tlbs_memslot()'s
functionality with calls to the aforementioned function.  Update the
comment in kvm_arch_flush_remote_tlbs_memslot() to elaborate on how it
is used and why it asserts that slots_lock is held.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 34 +++++++++-------------------------
 1 file changed, 9 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8a6516ce2983..1eb8654cc9d0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5870,13 +5870,6 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 				      false);
 	spin_unlock(&kvm->mmu_lock);
 
-	/*
-	 * kvm_mmu_slot_remove_write_access() and kvm_vm_ioctl_get_dirty_log()
-	 * which do tlb flush out of mmu-lock should be serialized by
-	 * kvm->slots_lock otherwise tlb flush would be missed.
-	 */
-	lockdep_assert_held(&kvm->slots_lock);
-
 	/*
 	 * We can flush all the TLBs out of the mmu lock without TLB
 	 * corruption since we just change the spte from writable to
@@ -5889,8 +5882,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 	 * on PT_WRITABLE_MASK anymore.
 	 */
 	if (flush)
-		kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
-			memslot->npages);
+		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
 static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
@@ -5946,8 +5938,11 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
 					struct kvm_memory_slot *memslot)
 {
 	/*
-	 * All the TLBs can be flushed out of mmu lock, see the comments in
-	 * kvm_mmu_slot_remove_write_access().
+	 * All current use cases for flushing the TLBs for a specific memslot
+	 * are related to dirty logging, and do the TLB flush out of mmu_lock.
+	 * The interaction between the various operations on memslot must be
+	 * serialized by slots_locks to ensure the TLB flush from one operation
+	 * is observed by any other operation on the same memslot.
 	 */
 	lockdep_assert_held(&kvm->slots_lock);
 	kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
@@ -5963,8 +5958,6 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 	flush = slot_handle_leaf(kvm, memslot, __rmap_clear_dirty, false);
 	spin_unlock(&kvm->mmu_lock);
 
-	lockdep_assert_held(&kvm->slots_lock);
-
 	/*
 	 * It's also safe to flush TLBs out of mmu lock here as currently this
 	 * function is only used for dirty logging, in which case flushing TLB
@@ -5972,8 +5965,7 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 	 * dirty_bitmap.
 	 */
 	if (flush)
-		kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
-				memslot->npages);
+		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_slot_leaf_clear_dirty);
 
@@ -5987,12 +5979,8 @@ void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
 					false);
 	spin_unlock(&kvm->mmu_lock);
 
-	/* see kvm_mmu_slot_remove_write_access */
-	lockdep_assert_held(&kvm->slots_lock);
-
 	if (flush)
-		kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
-				memslot->npages);
+		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_slot_largepage_remove_write_access);
 
@@ -6005,12 +5993,8 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
 	flush = slot_handle_all_level(kvm, memslot, __rmap_set_dirty, false);
 	spin_unlock(&kvm->mmu_lock);
 
-	lockdep_assert_held(&kvm->slots_lock);
-
-	/* see kvm_mmu_slot_leaf_clear_dirty */
 	if (flush)
-		kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
-				memslot->npages);
+		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_slot_set_dirty);
 
-- 
2.24.1

