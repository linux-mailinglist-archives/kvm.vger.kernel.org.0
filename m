Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D15A1159DC
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 00:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfLFX6J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 18:58:09 -0500
Received: from mga07.intel.com ([134.134.136.100]:55586 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbfLFX5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 18:57:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2019 15:57:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,286,1571727600"; 
   d="scan'208";a="219530359"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 06 Dec 2019 15:57:38 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/16] KVM: x86/mmu: Consolidate tdp_page_fault() and nonpaging_page_fault()
Date:   Fri,  6 Dec 2019 15:57:24 -0800
Message-Id: <20191206235729.29263-12-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191206235729.29263-1-sean.j.christopherson@intel.com>
References: <20191206235729.29263-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Consolidate the direct MMU page fault handlers into a common helper,
direct_page_fault().  Except for unique max level conditions, the tdp
and nonpaging fault handlers are functionally identical.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 166 +++++++++++++++--------------------------
 1 file changed, 61 insertions(+), 105 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a09a3bc0b6ae..929fca02b075 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4169,67 +4169,72 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 	return false;
 }
 
-static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa,
-				u32 error_code, bool prefault)
+static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
+			     bool prefault, int max_level, bool is_tdp)
 {
-	int r;
-	int level;
-	kvm_pfn_t pfn;
-	unsigned long mmu_seq;
-	gfn_t gfn = gpa >> PAGE_SHIFT;
 	bool write = error_code & PFERR_WRITE_MASK;
-	bool map_writable;
 	bool exec = error_code & PFERR_FETCH_MASK;
 	bool lpage_disallowed = exec && is_nx_huge_page_enabled();
-	int max_level;
+	bool map_writable;
 
-	/* Note, paging is disabled, ergo gva == gpa. */
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	unsigned long mmu_seq;
+	kvm_pfn_t pfn;
+	int level, r;
+
+	MMU_WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa));
+
+	if (page_fault_handle_page_track(vcpu, error_code, gfn))
+		return RET_PF_EMULATE;
+
+	r = mmu_topup_memory_caches(vcpu);
+	if (r)
+		return r;
+
+	if (lpage_disallowed)
+		max_level = PT_PAGE_TABLE_LEVEL;
+
+	level = mapping_level(vcpu, gfn, &max_level);
+	if (level > PT_PAGE_TABLE_LEVEL)
+		gfn &= ~(KVM_PAGES_PER_HPAGE(level) - 1);
+
+	if (fast_page_fault(vcpu, gpa, level, error_code))
+		return RET_PF_RETRY;
+
+	mmu_seq = vcpu->kvm->mmu_notifier_seq;
+	smp_rmb();
+
+	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, write, &map_writable))
+		return RET_PF_RETRY;
+
+	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
+		return r;
+
+	r = RET_PF_RETRY;
+	spin_lock(&vcpu->kvm->mmu_lock);
+	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
+		goto out_unlock;
+	if (make_mmu_pages_available(vcpu) < 0)
+		goto out_unlock;
+	if (likely(max_level > PT_PAGE_TABLE_LEVEL))
+		transparent_hugepage_adjust(vcpu, gfn, &pfn, &level);
+	r = __direct_map(vcpu, gpa, write, map_writable, level, pfn, prefault,
+			 is_tdp && lpage_disallowed);
+
+out_unlock:
+	spin_unlock(&vcpu->kvm->mmu_lock);
+	kvm_release_pfn_clean(pfn);
+	return r;
+}
+
+static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa,
+				u32 error_code, bool prefault)
+{
 	pgprintk("%s: gva %lx error %x\n", __func__, gpa, error_code);
 
-	gpa &= PAGE_MASK;
-
-	if (page_fault_handle_page_track(vcpu, error_code, gfn))
-		return RET_PF_EMULATE;
-
-	r = mmu_topup_memory_caches(vcpu);
-	if (r)
-		return r;
-
-	MMU_WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa));
-
 	/* This path builds a PAE pagetable, we can map 2mb pages at maximum. */
-	max_level = lpage_disallowed ? PT_PAGE_TABLE_LEVEL : PT_DIRECTORY_LEVEL;
-
-	level = mapping_level(vcpu, gfn, &max_level);
-	if (level > PT_PAGE_TABLE_LEVEL)
-		gfn &= ~(KVM_PAGES_PER_HPAGE(level) - 1);
-
-	if (fast_page_fault(vcpu, gpa, level, error_code))
-		return RET_PF_RETRY;
-
-	mmu_seq = vcpu->kvm->mmu_notifier_seq;
-	smp_rmb();
-
-	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, write, &map_writable))
-		return RET_PF_RETRY;
-
-	if (handle_abnormal_pfn(vcpu, gpa, gfn, pfn, ACC_ALL, &r))
-		return r;
-
-	r = RET_PF_RETRY;
-	spin_lock(&vcpu->kvm->mmu_lock);
-	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
-		goto out_unlock;
-	if (make_mmu_pages_available(vcpu) < 0)
-		goto out_unlock;
-	if (likely(max_level > PT_PAGE_TABLE_LEVEL))
-		transparent_hugepage_adjust(vcpu, gfn, &pfn, &level);
-	r = __direct_map(vcpu, gpa, write, map_writable, level, pfn,
-			 prefault, false);
-out_unlock:
-	spin_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(pfn);
-	return r;
+	return direct_page_fault(vcpu, gpa & PAGE_MASK, error_code, prefault,
+				 PT_DIRECTORY_LEVEL, false);
 }
 
 int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
@@ -4273,69 +4278,20 @@ EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
 static int tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			  bool prefault)
 {
-	kvm_pfn_t pfn;
-	int r;
-	int level;
-	gfn_t gfn = gpa >> PAGE_SHIFT;
-	unsigned long mmu_seq;
-	int write = error_code & PFERR_WRITE_MASK;
-	bool map_writable;
-	bool lpage_disallowed = (error_code & PFERR_FETCH_MASK) &&
-				is_nx_huge_page_enabled();
 	int max_level;
 
-	MMU_WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa));
-
-	if (page_fault_handle_page_track(vcpu, error_code, gfn))
-		return RET_PF_EMULATE;
-
-	r = mmu_topup_memory_caches(vcpu);
-	if (r)
-		return r;
-
 	for (max_level = PT_MAX_HUGEPAGE_LEVEL;
 	     max_level > PT_PAGE_TABLE_LEVEL;
 	     max_level--) {
 		int page_num = KVM_PAGES_PER_HPAGE(max_level);
-		gfn_t base = gfn & ~(page_num - 1);
+		gfn_t base = (gpa >> PAGE_SHIFT) & ~(page_num - 1);
 
 		if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
 			break;
 	}
 
-	if (lpage_disallowed)
-		max_level = PT_PAGE_TABLE_LEVEL;
-
-	level = mapping_level(vcpu, gfn, &max_level);
-	if (level > PT_PAGE_TABLE_LEVEL)
-		gfn &= ~(KVM_PAGES_PER_HPAGE(level) - 1);
-
-	if (fast_page_fault(vcpu, gpa, level, error_code))
-		return RET_PF_RETRY;
-
-	mmu_seq = vcpu->kvm->mmu_notifier_seq;
-	smp_rmb();
-
-	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, write, &map_writable))
-		return RET_PF_RETRY;
-
-	if (handle_abnormal_pfn(vcpu, 0, gfn, pfn, ACC_ALL, &r))
-		return r;
-
-	r = RET_PF_RETRY;
-	spin_lock(&vcpu->kvm->mmu_lock);
-	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
-		goto out_unlock;
-	if (make_mmu_pages_available(vcpu) < 0)
-		goto out_unlock;
-	if (likely(max_level > PT_PAGE_TABLE_LEVEL))
-		transparent_hugepage_adjust(vcpu, gfn, &pfn, &level);
-	r = __direct_map(vcpu, gpa, write, map_writable, level, pfn,
-			 prefault, lpage_disallowed);
-out_unlock:
-	spin_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(pfn);
-	return r;
+	return direct_page_fault(vcpu, gpa, error_code, prefault,
+				 max_level, true);
 }
 
 static void nonpaging_init_context(struct kvm_vcpu *vcpu,
-- 
2.24.0

