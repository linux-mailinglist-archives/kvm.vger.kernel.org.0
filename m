Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0BB134D78
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 21:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbgAHU1v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 15:27:51 -0500
Received: from mga06.intel.com ([134.134.136.31]:45241 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727261AbgAHU1H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 15:27:07 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 12:27:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,411,1571727600"; 
   d="scan'208";a="211658374"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 08 Jan 2020 12:27:06 -0800
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
Subject: [PATCH 06/14] KVM: x86/mmu: Refactor THP adjust to prep for changing query
Date:   Wed,  8 Jan 2020 12:24:40 -0800
Message-Id: <20200108202448.9669-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200108202448.9669-1-sean.j.christopherson@intel.com>
References: <20200108202448.9669-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor transparent_hugepage_adjust() in preparation for walking the
host page tables to identify hugepage mappings, initially for THP pages,
and eventualy for HugeTLB and DAX-backed pages as well.  The latter
cases support 1gb pages, i.e. the adjustment logic needs access to the
max allowed level.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 44 +++++++++++++++++-----------------
 arch/x86/kvm/mmu/paging_tmpl.h |  3 +--
 2 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8ca6cd04cdf1..30836899be73 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3329,33 +3329,34 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 	__direct_pte_prefetch(vcpu, sp, sptep);
 }
 
-static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
-					gfn_t gfn, kvm_pfn_t *pfnp,
+static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
+					int max_level, kvm_pfn_t *pfnp,
 					int *levelp)
 {
 	kvm_pfn_t pfn = *pfnp;
 	int level = *levelp;
+	kvm_pfn_t mask;
+
+	if (max_level == PT_PAGE_TABLE_LEVEL || level > PT_PAGE_TABLE_LEVEL)
+		return;
+
+	if (is_error_noslot_pfn(pfn) || kvm_is_reserved_pfn(pfn) ||
+	    kvm_is_zone_device_pfn(pfn))
+		return;
+
+	if (!kvm_is_transparent_hugepage(pfn))
+		return;
+
+	level = PT_DIRECTORY_LEVEL;
 
 	/*
-	 * Check if it's a transparent hugepage. If this would be an
-	 * hugetlbfs page, level wouldn't be set to
-	 * PT_PAGE_TABLE_LEVEL and there would be no adjustment done
-	 * here.
+	 * mmu_notifier_retry() was successful and mmu_lock is held, so
+	 * the pmd can't be split from under us.
 	 */
-	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
-	    !kvm_is_zone_device_pfn(pfn) && level == PT_PAGE_TABLE_LEVEL &&
-	    kvm_is_transparent_hugepage(pfn)) {
-		unsigned long mask;
-
-		/*
-		 * mmu_notifier_retry() was successful and mmu_lock is held, so
-		 * the pmd can't be split from under us.
-		 */
-		*levelp = level = PT_DIRECTORY_LEVEL;
-		mask = KVM_PAGES_PER_HPAGE(level) - 1;
-		VM_BUG_ON((gfn & mask) != (pfn & mask));
-		*pfnp = pfn & ~mask;
-	}
+	*levelp = level;
+	mask = KVM_PAGES_PER_HPAGE(level) - 1;
+	VM_BUG_ON((gfn & mask) != (pfn & mask));
+	*pfnp = pfn & ~mask;
 }
 
 static void disallowed_hugepage_adjust(struct kvm_shadow_walk_iterator it,
@@ -3395,8 +3396,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, int write,
 	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
 		return RET_PF_RETRY;
 
-	if (likely(max_level > PT_PAGE_TABLE_LEVEL))
-		transparent_hugepage_adjust(vcpu, gfn, &pfn, &level);
+	transparent_hugepage_adjust(vcpu, gfn, max_level, &pfn, &level);
 
 	trace_kvm_mmu_spte_requested(gpa, level, pfn);
 	for_each_shadow_entry(vcpu, gpa, it) {
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index b53bed3c901c..0029f7870865 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -673,8 +673,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 	gfn = gw->gfn | ((addr & PT_LVL_OFFSET_MASK(gw->level)) >> PAGE_SHIFT);
 	base_gfn = gfn;
 
-	if (max_level > PT_PAGE_TABLE_LEVEL)
-		transparent_hugepage_adjust(vcpu, gw->gfn, &pfn, &hlevel);
+	transparent_hugepage_adjust(vcpu, gw->gfn, max_level, &pfn, &hlevel);
 
 	trace_kvm_mmu_spte_requested(addr, gw->level, pfn);
 
-- 
2.24.1

