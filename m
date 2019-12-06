Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C94E1159D5
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 00:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfLFX5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 18:57:54 -0500
Received: from mga07.intel.com ([134.134.136.100]:55585 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbfLFX5m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 18:57:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2019 15:57:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,286,1571727600"; 
   d="scan'208";a="219530365"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 06 Dec 2019 15:57:39 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/16] KVM: x86/mmu: Move calls to thp_adjust() down a level
Date:   Fri,  6 Dec 2019 15:57:26 -0800
Message-Id: <20191206235729.29263-14-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191206235729.29263-1-sean.j.christopherson@intel.com>
References: <20191206235729.29263-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the calls to thp_adjust() down a level from the page fault handlers
to the map/fetch helpers and remove the page count shuffling done in
thp_adjust().

Despite holding a reference to the underlying page while processing a
page fault, the page fault flows don't actually rely on holding a
reference to the page when thp_adjust() is called.  At that point, the
fault handlers hold mmu_lock, which prevents mmu_notifier from completing
any invalidations, and have verified no invalidations from mmu_notifier
have occurred since the page reference was acquired (which is done prior
to taking mmu_lock).

The kvm_release_pfn_clean()/kvm_get_pfn() dance in thp_adjust() is a
quirk that is necessitated because thp_adjust() modifies the pfn that is
consumed by its caller.  Because the page fault handlers call
kvm_release_pfn_clean() on said pfn, thp_adjust() needs to transfer the
reference to the correct pfn purely for correctness when the pfn is
released.

Calling thp_adjust() from __direct_map() and FNAME(fetch) means the pfn
adjustment doesn't change the pfn as seen by the page fault handlers,
i.e. the pfn released by the page fault handlers is the same pfn that
was returned by gfn_to_pfn().

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 31 ++++++++++++-------------------
 arch/x86/kvm/mmu/paging_tmpl.h | 11 ++++++-----
 2 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 49e5d48e7327..904fb466dd24 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3341,24 +3341,15 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
 	    !kvm_is_zone_device_pfn(pfn) && level == PT_PAGE_TABLE_LEVEL &&
 	    PageTransCompoundMap(pfn_to_page(pfn))) {
 		unsigned long mask;
+
 		/*
-		 * mmu_notifier_retry was successful and we hold the
-		 * mmu_lock here, so the pmd can't become splitting
-		 * from under us, and in turn
-		 * __split_huge_page_refcount() can't run from under
-		 * us and we can safely transfer the refcount from
-		 * PG_tail to PG_head as we switch the pfn to tail to
-		 * head.
+		 * mmu_notifier_retry() was successful and mmu_lock is held, so
+		 * the pmd can't be split from under us.
 		 */
 		*levelp = level = PT_DIRECTORY_LEVEL;
 		mask = KVM_PAGES_PER_HPAGE(level) - 1;
 		VM_BUG_ON((gfn & mask) != (pfn & mask));
-		if (pfn & mask) {
-			kvm_release_pfn_clean(pfn);
-			pfn &= ~mask;
-			kvm_get_pfn(pfn);
-			*pfnp = pfn;
-		}
+		*pfnp = pfn & ~mask;
 	}
 }
 
@@ -3386,8 +3377,9 @@ static void disallowed_hugepage_adjust(struct kvm_shadow_walk_iterator it,
 }
 
 static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, int write,
-			int map_writable, int level, kvm_pfn_t pfn,
-			bool prefault, bool account_disallowed_nx_lpage)
+			int map_writable, int level, int max_level,
+			kvm_pfn_t pfn, bool prefault,
+			bool account_disallowed_nx_lpage)
 {
 	struct kvm_shadow_walk_iterator it;
 	struct kvm_mmu_page *sp;
@@ -3398,6 +3390,9 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, int write,
 	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
 		return RET_PF_RETRY;
 
+	if (likely(max_level > PT_PAGE_TABLE_LEVEL))
+		transparent_hugepage_adjust(vcpu, gfn, &pfn, &level);
+
 	trace_kvm_mmu_spte_requested(gpa, level, pfn);
 	for_each_shadow_entry(vcpu, gpa, it) {
 		/*
@@ -4216,10 +4211,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		goto out_unlock;
 	if (make_mmu_pages_available(vcpu) < 0)
 		goto out_unlock;
-	if (likely(max_level > PT_PAGE_TABLE_LEVEL))
-		transparent_hugepage_adjust(vcpu, gfn, &pfn, &level);
-	r = __direct_map(vcpu, gpa, write, map_writable, level, pfn, prefault,
-			 is_tdp && lpage_disallowed);
+	r = __direct_map(vcpu, gpa, write, map_writable, level, max_level, pfn,
+			 prefault, is_tdp && lpage_disallowed);
 
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 7d57ec576df0..3b0ba2a77e28 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -613,7 +613,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
  */
 static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 			 struct guest_walker *gw,
-			 int write_fault, int hlevel,
+			 int write_fault, int hlevel, int max_level,
 			 kvm_pfn_t pfn, bool map_writable, bool prefault,
 			 bool lpage_disallowed)
 {
@@ -673,6 +673,9 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 	gfn = gw->gfn | ((addr & PT_LVL_OFFSET_MASK(gw->level)) >> PAGE_SHIFT);
 	base_gfn = gfn;
 
+	if (max_level > PT_PAGE_TABLE_LEVEL)
+		transparent_hugepage_adjust(vcpu, gw->gfn, &pfn, &hlevel);
+
 	trace_kvm_mmu_spte_requested(addr, gw->level, pfn);
 
 	for (; shadow_walk_okay(&it); shadow_walk_next(&it)) {
@@ -865,10 +868,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
 	if (make_mmu_pages_available(vcpu) < 0)
 		goto out_unlock;
-	if (max_level > PT_PAGE_TABLE_LEVEL)
-		transparent_hugepage_adjust(vcpu, walker.gfn, &pfn, &level);
-	r = FNAME(fetch)(vcpu, addr, &walker, write_fault,
-			 level, pfn, map_writable, prefault, lpage_disallowed);
+	r = FNAME(fetch)(vcpu, addr, &walker, write_fault, level, max_level,
+			 pfn, map_writable, prefault, lpage_disallowed);
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
 
 out_unlock:
-- 
2.24.0

