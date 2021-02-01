Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3546530A31F
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 09:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbhBAIO6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 03:14:58 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:43152 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232045AbhBAIO4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 03:14:56 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.93.0.4)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1l6UL3-0004rW-Ua; Mon, 01 Feb 2021 09:13:37 +0100
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
Subject: [PATCH 1/2] KVM: x86/mmu: Make HVA handler retpoline-friendly
Date:   Mon,  1 Feb 2021 09:13:31 +0100
Message-Id: <ceb96527b6f7bb662eec813f05b897a551ebd0b2.1612140117.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

When retpolines are enabled they have high overhead in the inner loop
inside kvm_handle_hva_range() that iterates over the provided memory area.

Implement a static dispatch there, just like commit 7a02674d154d
("KVM: x86/mmu: Avoid retpoline on ->page_fault() with TDP") did for the
MMU page fault handler.

This significantly improves performance on the unmap test on the existing
kernel memslot code (tested on a Xeon 8167M machine):
30 slots in use:
Test		Before	  After	    Improvement
Unmap		0.0368s	  0.0353s    4%
Unmap 2M	0.000952s 0.000431s 55%

509 slots in use:
Unmap		0.0872s	  0.0777s   11%
Unmap 2M	0.00236s  0.00168s  29%

Looks like performing this indirect call via a retpoline might have
interfered with unrolling of the whole loop in the CPU.

Provide such static dispatch only for kvm_unmap_rmapp() and
kvm_age_rmapp() and their TDP MMU equivalents since other handlers are
called in ranges of single byte only, so they already have high overhead
to begin with if walking over a large memory area.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/x86/kvm/mmu/mmu.c     |  59 +++++++++++++------
 arch/x86/kvm/mmu/tdp_mmu.c | 116 ++++++++++++++++++++++---------------
 2 files changed, 112 insertions(+), 63 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6d16481aa29d..4140e308cf30 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1456,6 +1456,45 @@ static void slot_rmap_walk_next(struct slot_rmap_walk_iterator *iterator)
 	     slot_rmap_walk_okay(_iter_);				\
 	     slot_rmap_walk_next(_iter_))
 
+static int kvm_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+			 struct kvm_memory_slot *slot, gfn_t gfn, int level,
+			 unsigned long data)
+{
+	u64 *sptep;
+	struct rmap_iterator iter;
+	int young = 0;
+
+	for_each_rmap_spte(rmap_head, &iter, sptep)
+		young |= mmu_spte_age(sptep);
+
+	trace_kvm_age_page(gfn, level, slot, young);
+	return young;
+}
+
+static int kvm_handle_hva_do(struct kvm *kvm,
+			     struct slot_rmap_walk_iterator *iterator,
+			     struct kvm_memory_slot *memslot,
+			     unsigned long data,
+			     int (*handler)(struct kvm *kvm,
+					    struct kvm_rmap_head *rmap_head,
+					    struct kvm_memory_slot *slot,
+					    gfn_t gfn,
+					    int level,
+					    unsigned long data))
+{
+#ifdef CONFIG_RETPOLINE
+	if (handler == kvm_unmap_rmapp)
+		return kvm_unmap_rmapp(kvm, iterator->rmap, memslot,
+				       iterator->gfn, iterator->level, data);
+	else if (handler == kvm_age_rmapp)
+		return kvm_age_rmapp(kvm, iterator->rmap, memslot,
+				     iterator->gfn, iterator->level, data);
+	else
+#endif
+		return handler(kvm, iterator->rmap, memslot,
+			       iterator->gfn, iterator->level, data);
+}
+
 static int kvm_handle_hva_range(struct kvm *kvm,
 				unsigned long start,
 				unsigned long end,
@@ -1495,8 +1534,9 @@ static int kvm_handle_hva_range(struct kvm *kvm,
 						 KVM_MAX_HUGEPAGE_LEVEL,
 						 gfn_start, gfn_end - 1,
 						 &iterator)
-				ret |= handler(kvm, iterator.rmap, memslot,
-					       iterator.gfn, iterator.level, data);
+				ret |= kvm_handle_hva_do(kvm, &iterator,
+							 memslot, data,
+							 handler);
 		}
 	}
 
@@ -1539,21 +1579,6 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 	return r;
 }
 
-static int kvm_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			 struct kvm_memory_slot *slot, gfn_t gfn, int level,
-			 unsigned long data)
-{
-	u64 *sptep;
-	struct rmap_iterator iter;
-	int young = 0;
-
-	for_each_rmap_spte(rmap_head, &iter, sptep)
-		young |= mmu_spte_age(sptep);
-
-	trace_kvm_age_page(gfn, level, slot, young);
-	return young;
-}
-
 static int kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 			      struct kvm_memory_slot *slot, gfn_t gfn,
 			      int level, unsigned long data)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 2ef8615f9dba..f666b0fab861 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -639,45 +639,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	return ret;
 }
 
-static int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm, unsigned long start,
-		unsigned long end, unsigned long data,
-		int (*handler)(struct kvm *kvm, struct kvm_memory_slot *slot,
-			       struct kvm_mmu_page *root, gfn_t start,
-			       gfn_t end, unsigned long data))
-{
-	struct kvm_memslots *slots;
-	struct kvm_memory_slot *memslot;
-	struct kvm_mmu_page *root;
-	int ret = 0;
-	int as_id;
-
-	for_each_tdp_mmu_root_yield_safe(kvm, root) {
-		as_id = kvm_mmu_page_as_id(root);
-		slots = __kvm_memslots(kvm, as_id);
-		kvm_for_each_memslot(memslot, slots) {
-			unsigned long hva_start, hva_end;
-			gfn_t gfn_start, gfn_end;
-
-			hva_start = max(start, memslot->userspace_addr);
-			hva_end = min(end, memslot->userspace_addr +
-				      (memslot->npages << PAGE_SHIFT));
-			if (hva_start >= hva_end)
-				continue;
-			/*
-			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
-			 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
-			 */
-			gfn_start = hva_to_gfn_memslot(hva_start, memslot);
-			gfn_end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, memslot);
-
-			ret |= handler(kvm, memslot, root, gfn_start,
-				       gfn_end, data);
-		}
-	}
-
-	return ret;
-}
-
 static int zap_gfn_range_hva_wrapper(struct kvm *kvm,
 				     struct kvm_memory_slot *slot,
 				     struct kvm_mmu_page *root, gfn_t start,
@@ -686,13 +647,6 @@ static int zap_gfn_range_hva_wrapper(struct kvm *kvm,
 	return zap_gfn_range(kvm, root, start, end, false);
 }
 
-int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
-			      unsigned long end)
-{
-	return kvm_tdp_mmu_handle_hva_range(kvm, start, end, 0,
-					    zap_gfn_range_hva_wrapper);
-}
-
 /*
  * Mark the SPTEs range of GFNs [start, end) unaccessed and return non-zero
  * if any of the GFNs in the range have been accessed.
@@ -739,6 +693,76 @@ static int age_gfn_range(struct kvm *kvm, struct kvm_memory_slot *slot,
 	return young;
 }
 
+static int kvm_tdp_mmu_handle_hva_do(struct kvm *kvm,
+				     struct kvm_memory_slot *slot,
+				     struct kvm_mmu_page *root,
+				     gfn_t start, gfn_t end,
+				     unsigned long data,
+				     int (*handler)(struct kvm *kvm,
+						    struct kvm_memory_slot *slot,
+						    struct kvm_mmu_page *root,
+						    gfn_t start, gfn_t end,
+						    unsigned long data))
+{
+#ifdef CONFIG_RETPOLINE
+	if (handler == zap_gfn_range_hva_wrapper)
+		return zap_gfn_range_hva_wrapper(kvm, slot, root,
+						 start, end, data);
+	else if (handler == age_gfn_range)
+		return age_gfn_range(kvm, slot, root, start, end,
+				     data);
+	else
+#endif
+		return handler(kvm, slot, root, start, end, data);
+}
+
+static int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm, unsigned long start,
+		unsigned long end, unsigned long data,
+		int (*handler)(struct kvm *kvm, struct kvm_memory_slot *slot,
+			       struct kvm_mmu_page *root, gfn_t start,
+			       gfn_t end, unsigned long data))
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;
+	struct kvm_mmu_page *root;
+	int ret = 0;
+	int as_id;
+
+	for_each_tdp_mmu_root_yield_safe(kvm, root) {
+		as_id = kvm_mmu_page_as_id(root);
+		slots = __kvm_memslots(kvm, as_id);
+		kvm_for_each_memslot(memslot, slots) {
+			unsigned long hva_start, hva_end;
+			gfn_t gfn_start, gfn_end;
+
+			hva_start = max(start, memslot->userspace_addr);
+			hva_end = min(end, memslot->userspace_addr +
+				      (memslot->npages << PAGE_SHIFT));
+			if (hva_start >= hva_end)
+				continue;
+			/*
+			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
+			 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
+			 */
+			gfn_start = hva_to_gfn_memslot(hva_start, memslot);
+			gfn_end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, memslot);
+
+			ret |= kvm_tdp_mmu_handle_hva_do(kvm, memslot, root,
+							 gfn_start, gfn_end,
+							 data, handler);
+		}
+	}
+
+	return ret;
+}
+
+int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
+			      unsigned long end)
+{
+	return kvm_tdp_mmu_handle_hva_range(kvm, start, end, 0,
+					    zap_gfn_range_hva_wrapper);
+}
+
 int kvm_tdp_mmu_age_hva_range(struct kvm *kvm, unsigned long start,
 			      unsigned long end)
 {
