Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFE11159E2
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 00:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbfLFX6T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 18:58:19 -0500
Received: from mga07.intel.com ([134.134.136.100]:55584 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbfLFX5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 18:57:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2019 15:57:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,286,1571727600"; 
   d="scan'208";a="219530332"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 06 Dec 2019 15:57:36 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/16] KVM: x86/mmu: Move nonpaging_page_fault() below try_async_pf()
Date:   Fri,  6 Dec 2019 15:57:17 -0800
Message-Id: <20191206235729.29263-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191206235729.29263-1-sean.j.christopherson@intel.com>
References: <20191206235729.29263-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move nonpaging_page_fault() below try_async_pf() to eliminate the
forward declaration of try_async_pf() and to prepare for combining the
bulk of nonpaging_page_fault() and tdp_page_fault() into a common
helper.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 142 ++++++++++++++++++++---------------------
 1 file changed, 69 insertions(+), 73 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8217cdd6beac..ef1b7663f6ea 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3653,10 +3653,6 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, int level,
 	return fault_handled;
 }
 
-static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
-			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn, bool write,
-			 bool *writable);
-
 static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 			       struct list_head *invalid_list)
 {
@@ -4115,75 +4111,6 @@ static void shadow_page_table_clear_flood(struct kvm_vcpu *vcpu, gva_t addr)
 	walk_shadow_page_lockless_end(vcpu);
 }
 
-static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa,
-				u32 error_code, bool prefault)
-{
-	int r;
-	int level;
-	kvm_pfn_t pfn;
-	unsigned long mmu_seq;
-	gfn_t gfn = gpa >> PAGE_SHIFT;
-	bool write = error_code & PFERR_WRITE_MASK;
-	bool force_pt_level, map_writable;
-	bool exec = error_code & PFERR_FETCH_MASK;
-	bool lpage_disallowed = exec && is_nx_huge_page_enabled();
-
-	/* Note, paging is disabled, ergo gva == gpa. */
-	pgprintk("%s: gva %lx error %x\n", __func__, gpa, error_code);
-
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
-
-		gfn &= ~(KVM_PAGES_PER_HPAGE(level) - 1);
-	}
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
-	if (likely(!force_pt_level))
-		transparent_hugepage_adjust(vcpu, gfn, &pfn, &level);
-	r = __direct_map(vcpu, gpa, write, map_writable, level, pfn,
-			 prefault, false);
-out_unlock:
-	spin_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(pfn);
-	return r;
-}
-
 static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				   gfn_t gfn)
 {
@@ -4233,6 +4160,75 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 	return false;
 }
 
+static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa,
+				u32 error_code, bool prefault)
+{
+	int r;
+	int level;
+	kvm_pfn_t pfn;
+	unsigned long mmu_seq;
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	bool write = error_code & PFERR_WRITE_MASK;
+	bool force_pt_level, map_writable;
+	bool exec = error_code & PFERR_FETCH_MASK;
+	bool lpage_disallowed = exec && is_nx_huge_page_enabled();
+
+	/* Note, paging is disabled, ergo gva == gpa. */
+	pgprintk("%s: gva %lx error %x\n", __func__, gpa, error_code);
+
+	gpa &= PAGE_MASK;
+
+	if (page_fault_handle_page_track(vcpu, error_code, gfn))
+		return RET_PF_EMULATE;
+
+	r = mmu_topup_memory_caches(vcpu);
+	if (r)
+		return r;
+
+	MMU_WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa));
+
+	force_pt_level = lpage_disallowed;
+	level = mapping_level(vcpu, gfn, &force_pt_level);
+	if (likely(!force_pt_level)) {
+		/*
+		 * This path builds a PAE pagetable - so we can map
+		 * 2mb pages at maximum. Therefore check if the level
+		 * is larger than that.
+		 */
+		if (level > PT_DIRECTORY_LEVEL)
+			level = PT_DIRECTORY_LEVEL;
+
+		gfn &= ~(KVM_PAGES_PER_HPAGE(level) - 1);
+	}
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
+	if (handle_abnormal_pfn(vcpu, gpa, gfn, pfn, ACC_ALL, &r))
+		return r;
+
+	r = RET_PF_RETRY;
+	spin_lock(&vcpu->kvm->mmu_lock);
+	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
+		goto out_unlock;
+	if (make_mmu_pages_available(vcpu) < 0)
+		goto out_unlock;
+	if (likely(!force_pt_level))
+		transparent_hugepage_adjust(vcpu, gfn, &pfn, &level);
+	r = __direct_map(vcpu, gpa, write, map_writable, level, pfn,
+			 prefault, false);
+out_unlock:
+	spin_unlock(&vcpu->kvm->mmu_lock);
+	kvm_release_pfn_clean(pfn);
+	return r;
+}
+
 int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 				u64 fault_address, char *insn, int insn_len)
 {
-- 
2.24.0

