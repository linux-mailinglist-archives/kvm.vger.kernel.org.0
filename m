Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E493B1159E3
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 00:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfLFX6T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 18:58:19 -0500
Received: from mga07.intel.com ([134.134.136.100]:55586 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726552AbfLFX5j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 18:57:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2019 15:57:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,286,1571727600"; 
   d="scan'208";a="219530343"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 06 Dec 2019 15:57:37 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/16] KVM: x86/mmu: Refactor handling of forced 4k pages in page faults
Date:   Fri,  6 Dec 2019 15:57:20 -0800
Message-Id: <20191206235729.29263-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191206235729.29263-1-sean.j.christopherson@intel.com>
References: <20191206235729.29263-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor the page fault handlers and mapping_level() to track the max
allowed page level instead of only tracking if a 4k page is mandatory
due to one restriction or another.  This paves the way for cleanly
consolidating tdp_page_fault() and nonpaging_page_fault(), and for
eliminating a redundant check on mmu_gfn_lpage_is_disallowed().

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 45 ++++++++++++++--------------------
 arch/x86/kvm/mmu/paging_tmpl.h | 16 +++++++-----
 2 files changed, 29 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bd1711201181..877924cbb75b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1324,18 +1324,19 @@ gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
 }
 
 static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn,
-			 bool *force_pt_level)
+			 int *max_levelp)
 {
-	int host_level, max_level;
+	int host_level, max_level = *max_levelp;
 	struct kvm_memory_slot *slot;
 
-	if (unlikely(*force_pt_level))
+	if (unlikely(max_level == PT_PAGE_TABLE_LEVEL))
 		return PT_PAGE_TABLE_LEVEL;
 
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, large_gfn);
-	*force_pt_level = !memslot_valid_for_gpte(slot, true);
-	if (unlikely(*force_pt_level))
+	if (!memslot_valid_for_gpte(slot, true)) {
+		*max_levelp = PT_PAGE_TABLE_LEVEL;
 		return PT_PAGE_TABLE_LEVEL;
+	}
 
 	host_level = host_mapping_level(vcpu->kvm, large_gfn);
 
@@ -4169,9 +4170,10 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa,
 	unsigned long mmu_seq;
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	bool write = error_code & PFERR_WRITE_MASK;
-	bool force_pt_level, map_writable;
+	bool map_writable;
 	bool exec = error_code & PFERR_FETCH_MASK;
 	bool lpage_disallowed = exec && is_nx_huge_page_enabled();
+	int max_level;
 
 	/* Note, paging is disabled, ergo gva == gpa. */
 	pgprintk("%s: gva %lx error %x\n", __func__, gpa, error_code);
@@ -4187,19 +4189,12 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 	MMU_WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa));
 
-	force_pt_level = lpage_disallowed;
-	level = mapping_level(vcpu, gfn, &force_pt_level);
-	if (likely(!force_pt_level)) {
-		/*
-		 * This path builds a PAE pagetable - so we can map
-		 * 2mb pages at maximum. Therefore check if the level
-		 * is larger than that.
-		 */
-		if (level > PT_DIRECTORY_LEVEL)
-			level = PT_DIRECTORY_LEVEL;
+	/* This path builds a PAE pagetable, we can map 2mb pages at maximum. */
+	max_level = lpage_disallowed ? PT_PAGE_TABLE_LEVEL : PT_DIRECTORY_LEVEL;
 
+	level = mapping_level(vcpu, gfn, &max_level);
+	if (level > PT_PAGE_TABLE_LEVEL)
 		gfn &= ~(KVM_PAGES_PER_HPAGE(level) - 1);
-	}
 
 	if (fast_page_fault(vcpu, gpa, level, error_code))
 		return RET_PF_RETRY;
@@ -4219,7 +4214,7 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa,
 		goto out_unlock;
 	if (make_mmu_pages_available(vcpu) < 0)
 		goto out_unlock;
-	if (likely(!force_pt_level))
+	if (likely(max_level > PT_PAGE_TABLE_LEVEL))
 		transparent_hugepage_adjust(vcpu, gfn, &pfn, &level);
 	r = __direct_map(vcpu, gpa, write, map_writable, level, pfn,
 			 prefault, false);
@@ -4273,7 +4268,6 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	kvm_pfn_t pfn;
 	int r;
 	int level;
-	bool force_pt_level;
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	unsigned long mmu_seq;
 	int write = error_code & PFERR_WRITE_MASK;
@@ -4301,13 +4295,12 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			break;
 	}
 
-	force_pt_level = lpage_disallowed || max_level == PT_PAGE_TABLE_LEVEL;
-	level = mapping_level(vcpu, gfn, &force_pt_level);
-	if (likely(!force_pt_level)) {
-		if (level > max_level)
-			level = max_level;
+	if (lpage_disallowed)
+		max_level = PT_PAGE_TABLE_LEVEL;
+
+	level = mapping_level(vcpu, gfn, &max_level);
+	if (level > PT_PAGE_TABLE_LEVEL)
 		gfn &= ~(KVM_PAGES_PER_HPAGE(level) - 1);
-	}
 
 	if (fast_page_fault(vcpu, gpa, level, error_code))
 		return RET_PF_RETRY;
@@ -4327,7 +4320,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		goto out_unlock;
 	if (make_mmu_pages_available(vcpu) < 0)
 		goto out_unlock;
-	if (likely(!force_pt_level))
+	if (likely(max_level > PT_PAGE_TABLE_LEVEL))
 		transparent_hugepage_adjust(vcpu, gfn, &pfn, &level);
 	r = __direct_map(vcpu, gpa, write, map_writable, level, pfn,
 			 prefault, lpage_disallowed);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index c1d7b866a03f..1938a6e4e631 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -778,7 +778,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	bool map_writable, is_self_change_mapping;
 	bool lpage_disallowed = (error_code & PFERR_FETCH_MASK) &&
 				is_nx_huge_page_enabled();
-	bool force_pt_level = lpage_disallowed;
+	int max_level;
 
 	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
 
@@ -818,14 +818,18 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	is_self_change_mapping = FNAME(is_self_change_mapping)(vcpu,
 	      &walker, user_fault, &vcpu->arch.write_fault_to_shadow_pgtable);
 
+	max_level = lpage_disallowed ? PT_PAGE_TABLE_LEVEL :
+				       PT_MAX_HUGEPAGE_LEVEL;
+
 	if (walker.level >= PT_DIRECTORY_LEVEL && !is_self_change_mapping) {
-		level = mapping_level(vcpu, walker.gfn, &force_pt_level);
-		if (likely(!force_pt_level)) {
+		level = mapping_level(vcpu, walker.gfn, &max_level);
+		if (likely(max_level > PT_DIRECTORY_LEVEL)) {
 			level = min(walker.level, level);
 			walker.gfn = walker.gfn & ~(KVM_PAGES_PER_HPAGE(level) - 1);
 		}
-	} else
-		force_pt_level = true;
+	} else {
+		max_level = PT_PAGE_TABLE_LEVEL;
+	}
 
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
@@ -865,7 +869,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
 	if (make_mmu_pages_available(vcpu) < 0)
 		goto out_unlock;
-	if (!force_pt_level)
+	if (max_level > PT_PAGE_TABLE_LEVEL)
 		transparent_hugepage_adjust(vcpu, walker.gfn, &pfn, &level);
 	r = FNAME(fetch)(vcpu, addr, &walker, write_fault,
 			 level, pfn, map_writable, prefault, lpage_disallowed);
-- 
2.24.0

