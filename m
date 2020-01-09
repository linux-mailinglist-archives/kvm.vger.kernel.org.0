Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD5A136399
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 00:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbgAIXGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 18:06:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:54670 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729076AbgAIXGm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 18:06:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 15:06:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="396242476"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 09 Jan 2020 15:06:41 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Laight <David.Laight@ACULAB.COM>,
        Arvind Sankar <nivedita@alum.mit.edu>
Subject: [PATCH v2 2/2] KVM: x86/mmu: Micro-optimize nEPT's bad memptype/XWR checks
Date:   Thu,  9 Jan 2020 15:06:40 -0800
Message-Id: <20200109230640.29927-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109230640.29927-1-sean.j.christopherson@intel.com>
References: <20200109230640.29927-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rework the handling of nEPT's bad memtype/XWR checks to micro-optimize
the checks as much as possible.  Move the check to a separate helper,
__is_bad_mt_xwr(), which allows the guest_rsvd_check usage in
paging_tmpl.h to omit the check entirely for paging32/64 (bad_mt_xwr is
always zero for non-nEPT) while retaining the bitwise-OR of the current
code for the shadow_zero_check in walk_shadow_page_get_mmio_spte().

Add a comment for the bitwise-OR usage in the mmio spte walk to avoid
future attempts to "fix" the code, which is what prompted this
optimization in the first place[*].

Opportunistically remove the superfluous '!= 0' and parantheses, and
use BIT_ULL() instead of open coding its equivalent.

The net effect is that code generation is largely unhanged for
walk_shadow_page_get_mmio_spte(), marginally better for
ept_prefetch_invalid_gpte(), and significantly improved for
paging32/64_prefetch_invalid_gpte().

Note, walk_shadow_page_get_mmio_spte() can't use a templated version of
the memtype/XRW as it works on the host's shadow PTEs, e.g. checks that
KVM hasn't borked its EPT tables.  Even if it could be templated, the
benefits of having a single implementation far outweight the few uops
that would be saved for NPT or non-TDP paging, e.g. most compilers
inline it all the way to up kvm_mmu_page_fault().

[*] https://lkml.kernel.org/r/20200108001859.25254-1-sean.j.christopherson@intel.com

Cc: Jim Mattson <jmattson@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 26 ++++++++++++++------------
 arch/x86/kvm/mmu/paging_tmpl.h | 19 +++++++++++++++++--
 2 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7269130ea5e2..2992ff7b42a7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3968,20 +3968,14 @@ static gpa_t nonpaging_gva_to_gpa_nested(struct kvm_vcpu *vcpu, gpa_t vaddr,
 static bool
 __is_rsvd_bits_set(struct rsvd_bits_validate *rsvd_check, u64 pte, int level)
 {
-	int bit7 = (pte >> 7) & 1, low6 = pte & 0x3f;
+	int bit7 = (pte >> 7) & 1;
 
-	return (pte & rsvd_check->rsvd_bits_mask[bit7][level-1]) |
-		((rsvd_check->bad_mt_xwr & (1ull << low6)) != 0);
+	return pte & rsvd_check->rsvd_bits_mask[bit7][level-1];
 }
 
-static bool is_rsvd_bits_set(struct kvm_mmu *mmu, u64 gpte, int level)
+static bool __is_bad_mt_xwr(struct rsvd_bits_validate *rsvd_check, u64 pte)
 {
-	return __is_rsvd_bits_set(&mmu->guest_rsvd_check, gpte, level);
-}
-
-static bool is_shadow_zero_bits_set(struct kvm_mmu *mmu, u64 spte, int level)
-{
-	return __is_rsvd_bits_set(&mmu->shadow_zero_check, spte, level);
+	return rsvd_check->bad_mt_xwr & BIT_ULL(pte & 0x3f);
 }
 
 static bool mmio_info_in_cache(struct kvm_vcpu *vcpu, u64 addr, bool direct)
@@ -4005,9 +3999,12 @@ walk_shadow_page_get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	u64 sptes[PT64_ROOT_MAX_LEVEL], spte = 0ull;
+	struct rsvd_bits_validate *rsvd_check;
 	int root, leaf;
 	bool reserved = false;
 
+	rsvd_check = &vcpu->arch.mmu->shadow_zero_check;
+
 	walk_shadow_page_lockless_begin(vcpu);
 
 	for (shadow_walk_init(&iterator, vcpu, addr),
@@ -4022,8 +4019,13 @@ walk_shadow_page_get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 		if (!is_shadow_present_pte(spte))
 			break;
 
-		reserved |= is_shadow_zero_bits_set(vcpu->arch.mmu, spte,
-						    iterator.level);
+		/*
+		 * Use a bitwise-OR instead of a logical-OR to aggregate the
+		 * reserved bit and EPT's invalid memtype/XWR checks to avoid
+		 * adding a Jcc in the loop.
+		 */
+		reserved |= __is_bad_mt_xwr(rsvd_check, spte) |
+			    __is_rsvd_bits_set(rsvd_check, spte, iterator.level);
 	}
 
 	walk_shadow_page_lockless_end(vcpu);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 1fde6a1c506d..eaa00c4daeb1 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -128,6 +128,21 @@ static inline int FNAME(is_present_gpte)(unsigned long pte)
 #endif
 }
 
+static bool FNAME(is_bad_mt_xwr)(struct rsvd_bits_validate *rsvd_check, u64 gpte)
+{
+#if PTTYPE != PTTYPE_EPT
+	return false;
+#else
+	return __is_bad_mt_xwr(rsvd_check, gpte);
+#endif
+}
+
+static bool FNAME(is_rsvd_bits_set)(struct kvm_mmu *mmu, u64 gpte, int level)
+{
+	return __is_rsvd_bits_set(&mmu->guest_rsvd_check, gpte, level) ||
+	       FNAME(is_bad_mt_xwr)(&mmu->guest_rsvd_check, gpte);
+}
+
 static int FNAME(cmpxchg_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			       pt_element_t __user *ptep_user, unsigned index,
 			       pt_element_t orig_pte, pt_element_t new_pte)
@@ -183,7 +198,7 @@ static bool FNAME(prefetch_invalid_gpte)(struct kvm_vcpu *vcpu,
 	    !(gpte & PT_GUEST_ACCESSED_MASK))
 		goto no_present;
 
-	if (is_rsvd_bits_set(vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL))
+	if (FNAME(is_rsvd_bits_set)(vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL))
 		goto no_present;
 
 	return false;
@@ -400,7 +415,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 		if (unlikely(!FNAME(is_present_gpte)(pte)))
 			goto error;
 
-		if (unlikely(is_rsvd_bits_set(mmu, pte, walker->level))) {
+		if (unlikely(FNAME(is_rsvd_bits_set)(mmu, pte, walker->level))) {
 			errcode = PFERR_RSVD_MASK | PFERR_PRESENT_MASK;
 			goto error;
 		}
-- 
2.24.1

