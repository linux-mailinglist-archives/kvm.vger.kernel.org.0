Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCE5B134D62
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 21:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbgAHU1T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 15:27:19 -0500
Received: from mga06.intel.com ([134.134.136.31]:45241 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727370AbgAHU1L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 15:27:11 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 12:27:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,411,1571727600"; 
   d="scan'208";a="211658395"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 08 Jan 2020 12:27:07 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        syzbot+c9d1fb51ac9d0d10c39d@syzkaller.appspotmail.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Barret Rhoden <brho@google.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Zeng <jason.zeng@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Subject: [PATCH 12/14] KVM: x86/mmu: Fold max_mapping_level() into kvm_mmu_hugepage_adjust()
Date:   Wed,  8 Jan 2020 12:24:46 -0800
Message-Id: <20200108202448.9669-13-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200108202448.9669-1-sean.j.christopherson@intel.com>
References: <20200108202448.9669-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fold max_mapping_level() into kvm_mmu_hugepage_adjust() now that HugeTLB
mappings are handled in kvm_mmu_hugepage_adjust(), i.e. there isn't a
need to pre-calculate the max mapping level.  Co-locating all hugepage
checks eliminates a memslot lookup, at the cost of performing the
__mmu_gfn_lpage_is_disallowed() checks while holding mmu_lock.

The latency of lpage_is_disallowed() is likely negligible relative to
the rest of the code run while holding mmu_lock, and can be offset to
some extent by eliminating the mmu_gfn_lpage_is_disallowed() check in
set_spte() in a future patch.  Eliminating the check in set_spte() is
made possible by performing the initial lpage_is_disallowed() checks
while holding mmu_lock.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 60 ++++++++++++++--------------------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 --
 2 files changed, 24 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f93b0c5e4170..f2667fe0dc75 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1310,27 +1310,6 @@ gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return slot;
 }
 
-static int max_mapping_level(struct kvm_vcpu *vcpu, gfn_t gfn,
-			     int max_level)
-{
-	struct kvm_memory_slot *slot;
-
-	if (unlikely(max_level == PT_PAGE_TABLE_LEVEL))
-		return PT_PAGE_TABLE_LEVEL;
-
-	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	if (!memslot_valid_for_gpte(slot, true))
-		return PT_PAGE_TABLE_LEVEL;
-
-	max_level = min(max_level, kvm_x86_ops->get_lpage_level());
-	for ( ; max_level > PT_PAGE_TABLE_LEVEL; max_level--) {
-		if (!__mmu_gfn_lpage_is_disallowed(gfn, max_level, slot))
-			break;
-	}
-
-	return max_level;
-}
-
 /*
  * About rmap_head encoding:
  *
@@ -3101,10 +3080,11 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (pte_access & ACC_WRITE_MASK) {
 
 		/*
-		 * Other vcpu creates new sp in the window between
-		 * max_mapping_level() and acquiring mmu-lock. We can
-		 * allow guest to retry the access, the mapping can
-		 * be fixed if guest refault.
+		 * Legacy code to handle an obsolete scenario where a different
+		 * vcpu creates new sp in the window between this vcpu's query
+		 * of lpage_is_disallowed() and acquiring mmu_lock.  No longer
+		 * necessary now that lpage_is_disallowed() is called after
+		 * acquiring mmu_lock.
 		 */
 		if (level > PT_PAGE_TABLE_LEVEL &&
 		    mmu_gfn_lpage_is_disallowed(vcpu, gfn, level))
@@ -3295,9 +3275,8 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 }
 
 static int host_pfn_mapping_level(struct kvm_vcpu *vcpu, gfn_t gfn,
-				  kvm_pfn_t pfn)
+				  kvm_pfn_t pfn, struct kvm_memory_slot *slot)
 {
-	struct kvm_memory_slot *slot;
 	unsigned long hva;
 	pte_t *pte;
 	int level;
@@ -3310,16 +3289,13 @@ static int host_pfn_mapping_level(struct kvm_vcpu *vcpu, gfn_t gfn,
 		return PT_PAGE_TABLE_LEVEL;
 
 	/*
-	 * Manually do the equivalent of kvm_vcpu_gfn_to_hva() to avoid the
+	 * Note, using the already-retrieved memslot and __gfn_to_hva_memslot()
+	 * is not solely for performance, it's also necessary to avoid the
 	 * "writable" check in __gfn_to_hva_many(), which will always fail on
 	 * read-only memslots due to gfn_to_hva() assuming writes.  Earlier
 	 * page fault steps have already verified the guest isn't writing a
 	 * read-only memslot.
 	 */
-	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	if (!memslot_valid_for_gpte(slot, true))
-		return PT_PAGE_TABLE_LEVEL;
-
 	hva = __gfn_to_hva_memslot(slot, gfn);
 
 	pte = lookup_address_in_mm(vcpu->kvm->mm, hva, &level);
@@ -3332,18 +3308,32 @@ static int host_pfn_mapping_level(struct kvm_vcpu *vcpu, gfn_t gfn,
 static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 				   int max_level, kvm_pfn_t *pfnp)
 {
+	struct kvm_memory_slot *slot;
 	kvm_pfn_t pfn = *pfnp;
 	kvm_pfn_t mask;
 	int level;
 
-	if (max_level == PT_PAGE_TABLE_LEVEL)
+	if (unlikely(max_level == PT_PAGE_TABLE_LEVEL))
 		return PT_PAGE_TABLE_LEVEL;
 
 	if (is_error_noslot_pfn(pfn) || kvm_is_reserved_pfn(pfn) ||
 	    kvm_is_zone_device_pfn(pfn))
 		return PT_PAGE_TABLE_LEVEL;
 
-	level = host_pfn_mapping_level(vcpu, gfn, pfn);
+	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+	if (!memslot_valid_for_gpte(slot, true))
+		return PT_PAGE_TABLE_LEVEL;
+
+	max_level = min(max_level, kvm_x86_ops->get_lpage_level());
+	for ( ; max_level > PT_PAGE_TABLE_LEVEL; max_level--) {
+		if (!__mmu_gfn_lpage_is_disallowed(gfn, max_level, slot))
+			break;
+	}
+
+	if (max_level == PT_PAGE_TABLE_LEVEL)
+		return PT_PAGE_TABLE_LEVEL;
+
+	level = host_pfn_mapping_level(vcpu, gfn, pfn, slot);
 	if (level == PT_PAGE_TABLE_LEVEL)
 		return level;
 
@@ -4182,8 +4172,6 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	if (lpage_disallowed)
 		max_level = PT_PAGE_TABLE_LEVEL;
 
-	max_level = max_mapping_level(vcpu, gfn, max_level);
-
 	if (fast_page_fault(vcpu, gpa, error_code))
 		return RET_PF_RETRY;
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 0560982eda8b..ea174d85700a 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -817,8 +817,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	else
 		max_level = walker.level;
 
-	max_level = max_mapping_level(vcpu, walker.gfn, max_level);
-
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-- 
2.24.1

