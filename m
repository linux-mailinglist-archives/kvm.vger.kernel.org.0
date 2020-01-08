Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC68A134D54
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 21:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbgAHU1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 15:27:18 -0500
Received: from mga06.intel.com ([134.134.136.31]:45247 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727387AbgAHU1M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 15:27:12 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 12:27:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,411,1571727600"; 
   d="scan'208";a="211658398"
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
Subject: [PATCH 13/14] KVM: x86/mmu: Remove lpage_is_disallowed() check from set_spte()
Date:   Wed,  8 Jan 2020 12:24:47 -0800
Message-Id: <20200108202448.9669-14-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200108202448.9669-1-sean.j.christopherson@intel.com>
References: <20200108202448.9669-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the late "lpage is disallowed" check from set_spte() now that the
initial check is performed after acquiring mmu_lock.  Fold the guts of
the remaining helper, __mmu_gfn_lpage_is_disallowed(), into
kvm_mmu_hugepage_adjust() to eliminate the unnecessary slot !NULL check.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 39 +++------------------------------------
 1 file changed, 3 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f2667fe0dc75..1e4e0ac169a7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1264,28 +1264,6 @@ static void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	list_del(&sp->lpage_disallowed_link);
 }
 
-static bool __mmu_gfn_lpage_is_disallowed(gfn_t gfn, int level,
-					  struct kvm_memory_slot *slot)
-{
-	struct kvm_lpage_info *linfo;
-
-	if (slot) {
-		linfo = lpage_info_slot(gfn, slot, level);
-		return !!linfo->disallow_lpage;
-	}
-
-	return true;
-}
-
-static bool mmu_gfn_lpage_is_disallowed(struct kvm_vcpu *vcpu, gfn_t gfn,
-					int level)
-{
-	struct kvm_memory_slot *slot;
-
-	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	return __mmu_gfn_lpage_is_disallowed(gfn, level, slot);
-}
-
 static inline bool memslot_valid_for_gpte(struct kvm_memory_slot *slot,
 					  bool no_dirty_log)
 {
@@ -3078,18 +3056,6 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	spte |= (u64)pfn << PAGE_SHIFT;
 
 	if (pte_access & ACC_WRITE_MASK) {
-
-		/*
-		 * Legacy code to handle an obsolete scenario where a different
-		 * vcpu creates new sp in the window between this vcpu's query
-		 * of lpage_is_disallowed() and acquiring mmu_lock.  No longer
-		 * necessary now that lpage_is_disallowed() is called after
-		 * acquiring mmu_lock.
-		 */
-		if (level > PT_PAGE_TABLE_LEVEL &&
-		    mmu_gfn_lpage_is_disallowed(vcpu, gfn, level))
-			goto done;
-
 		spte |= PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE;
 
 		/*
@@ -3121,7 +3087,6 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 set_pte:
 	if (mmu_spte_update(sptep, spte))
 		ret |= SET_SPTE_NEED_REMOTE_TLB_FLUSH;
-done:
 	return ret;
 }
 
@@ -3309,6 +3274,7 @@ static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 				   int max_level, kvm_pfn_t *pfnp)
 {
 	struct kvm_memory_slot *slot;
+	struct kvm_lpage_info *linfo;
 	kvm_pfn_t pfn = *pfnp;
 	kvm_pfn_t mask;
 	int level;
@@ -3326,7 +3292,8 @@ static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 
 	max_level = min(max_level, kvm_x86_ops->get_lpage_level());
 	for ( ; max_level > PT_PAGE_TABLE_LEVEL; max_level--) {
-		if (!__mmu_gfn_lpage_is_disallowed(gfn, max_level, slot))
+		linfo = lpage_info_slot(gfn, slot, max_level);
+		if (!linfo->disallow_lpage)
 			break;
 	}
 
-- 
2.24.1

