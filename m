Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4132818DA34
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbgCTV3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:29:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:37251 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727499AbgCTV3C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:29:02 -0400
IronPort-SDR: tgRWIH7oQR6zlYuHUGnSy4oOkSFB1RRzeopTRvYF1Yf3+m4JXKcuiFy2H3YOmUWS7ohellxmEh
 5mu1MJJIuwfQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:29:01 -0700
IronPort-SDR: 9jIZJu9RuVUPeBet9uoBhTwx8VtMgZ1X8bgSTTivrr3GNJEcjQ+7Fz8nNUKce7tOMwoxsE7vfx
 KayyXz3OTWQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224532"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2020 14:29:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v3 36/37] KVM: x86: Replace "cr3" with "pgd" in "new cr3/pgd" related code
Date:   Fri, 20 Mar 2020 14:28:32 -0700
Message-Id: <20200320212833.3507-37-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320212833.3507-1-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename functions and variables in kvm_mmu_new_cr3() and related code to
replace "cr3" with "pgd", i.e. continue the work started by commit
727a7e27cf88a ("KVM: x86: rename set_cr3 callback and related flags to
load_mmu_pgd").  kvm_mmu_new_cr3() and company are not always loading a
new CR3, e.g. when nested EPT is enabled "cr3" is actually an EPTP.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  8 ++---
 arch/x86/kvm/mmu/mmu.c          | 58 ++++++++++++++++-----------------
 arch/x86/kvm/vmx/nested.c       |  8 ++---
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 arch/x86/kvm/x86.c              |  2 +-
 5 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6fca2e45886c..167729624149 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -373,12 +373,12 @@ struct rsvd_bits_validate {
 };
 
 struct kvm_mmu_root_info {
-	gpa_t cr3;
+	gpa_t pgd;
 	hpa_t hpa;
 };
 
 #define KVM_MMU_ROOT_INFO_INVALID \
-	((struct kvm_mmu_root_info) { .cr3 = INVALID_PAGE, .hpa = INVALID_PAGE })
+	((struct kvm_mmu_root_info) { .pgd = INVALID_PAGE, .hpa = INVALID_PAGE })
 
 #define KVM_MMU_NUM_PREV_ROOTS 3
 
@@ -404,7 +404,7 @@ struct kvm_mmu {
 	void (*update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			   u64 *spte, const void *pte);
 	hpa_t root_hpa;
-	gpa_t root_cr3;
+	gpa_t root_pgd;
 	union kvm_mmu_role mmu_role;
 	u8 root_level;
 	u8 shadow_root_level;
@@ -1517,7 +1517,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len);
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
-void kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t new_cr3, bool skip_tlb_flush,
+void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd, bool skip_tlb_flush,
 		     bool skip_mmu_sync);
 
 void kvm_configure_mmu(bool enable_tdp, int tdp_page_level);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7b0fb7f2c24d..be03f353dd3d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3669,7 +3669,7 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 							   &invalid_list);
 			mmu->root_hpa = INVALID_PAGE;
 		}
-		mmu->root_cr3 = 0;
+		mmu->root_pgd = 0;
 	}
 
 	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
@@ -3726,8 +3726,8 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	} else
 		BUG();
 
-	/* root_cr3 is ignored for direct MMUs. */
-	vcpu->arch.mmu->root_cr3 = 0;
+	/* root_pgd is ignored for direct MMUs. */
+	vcpu->arch.mmu->root_pgd = 0;
 
 	return 0;
 }
@@ -3736,11 +3736,11 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_page *sp;
 	u64 pdptr, pm_mask;
-	gfn_t root_gfn, root_cr3;
+	gfn_t root_gfn, root_pgd;
 	int i;
 
-	root_cr3 = vcpu->arch.mmu->get_guest_pgd(vcpu);
-	root_gfn = root_cr3 >> PAGE_SHIFT;
+	root_pgd = vcpu->arch.mmu->get_guest_pgd(vcpu);
+	root_gfn = root_pgd >> PAGE_SHIFT;
 
 	if (mmu_check_root(vcpu, root_gfn))
 		return 1;
@@ -3765,7 +3765,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		++sp->root_count;
 		spin_unlock(&vcpu->kvm->mmu_lock);
 		vcpu->arch.mmu->root_hpa = root;
-		goto set_root_cr3;
+		goto set_root_pgd;
 	}
 
 	/*
@@ -3831,8 +3831,8 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		vcpu->arch.mmu->root_hpa = __pa(vcpu->arch.mmu->lm_root);
 	}
 
-set_root_cr3:
-	vcpu->arch.mmu->root_cr3 = root_cr3;
+set_root_pgd:
+	vcpu->arch.mmu->root_pgd = root_pgd;
 
 	return 0;
 }
@@ -4248,49 +4248,49 @@ static void nonpaging_init_context(struct kvm_vcpu *vcpu,
 	context->nx = false;
 }
 
-static inline bool is_root_usable(struct kvm_mmu_root_info *root, gpa_t cr3,
+static inline bool is_root_usable(struct kvm_mmu_root_info *root, gpa_t pgd,
 				  union kvm_mmu_page_role role)
 {
-	return (role.direct || cr3 == root->cr3) &&
+	return (role.direct || pgd == root->pgd) &&
 	       VALID_PAGE(root->hpa) && page_header(root->hpa) &&
 	       role.word == page_header(root->hpa)->role.word;
 }
 
 /*
- * Find out if a previously cached root matching the new CR3/role is available.
+ * Find out if a previously cached root matching the new pgd/role is available.
  * The current root is also inserted into the cache.
  * If a matching root was found, it is assigned to kvm_mmu->root_hpa and true is
  * returned.
  * Otherwise, the LRU root from the cache is assigned to kvm_mmu->root_hpa and
  * false is returned. This root should now be freed by the caller.
  */
-static bool cached_root_available(struct kvm_vcpu *vcpu, gpa_t new_cr3,
+static bool cached_root_available(struct kvm_vcpu *vcpu, gpa_t new_pgd,
 				  union kvm_mmu_page_role new_role)
 {
 	uint i;
 	struct kvm_mmu_root_info root;
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 
-	root.cr3 = mmu->root_cr3;
+	root.pgd = mmu->root_pgd;
 	root.hpa = mmu->root_hpa;
 
-	if (is_root_usable(&root, new_cr3, new_role))
+	if (is_root_usable(&root, new_pgd, new_role))
 		return true;
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
 		swap(root, mmu->prev_roots[i]);
 
-		if (is_root_usable(&root, new_cr3, new_role))
+		if (is_root_usable(&root, new_pgd, new_role))
 			break;
 	}
 
 	mmu->root_hpa = root.hpa;
-	mmu->root_cr3 = root.cr3;
+	mmu->root_pgd = root.pgd;
 
 	return i < KVM_MMU_NUM_PREV_ROOTS;
 }
 
-static bool fast_cr3_switch(struct kvm_vcpu *vcpu, gpa_t new_cr3,
+static bool fast_pgd_switch(struct kvm_vcpu *vcpu, gpa_t new_pgd,
 			    union kvm_mmu_page_role new_role)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
@@ -4302,17 +4302,17 @@ static bool fast_cr3_switch(struct kvm_vcpu *vcpu, gpa_t new_cr3,
 	 */
 	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
 	    mmu->root_level >= PT64_ROOT_4LEVEL)
-		return !mmu_check_root(vcpu, new_cr3 >> PAGE_SHIFT) &&
-		       cached_root_available(vcpu, new_cr3, new_role);
+		return !mmu_check_root(vcpu, new_pgd >> PAGE_SHIFT) &&
+		       cached_root_available(vcpu, new_pgd, new_role);
 
 	return false;
 }
 
-static void __kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t new_cr3,
+static void __kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd,
 			      union kvm_mmu_page_role new_role,
 			      bool skip_tlb_flush, bool skip_mmu_sync)
 {
-	if (!fast_cr3_switch(vcpu, new_cr3, new_role)) {
+	if (!fast_pgd_switch(vcpu, new_pgd, new_role)) {
 		kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, KVM_MMU_ROOT_CURRENT);
 		return;
 	}
@@ -4341,13 +4341,13 @@ static void __kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t new_cr3,
 	__clear_sp_write_flooding_count(page_header(vcpu->arch.mmu->root_hpa));
 }
 
-void kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t new_cr3, bool skip_tlb_flush,
+void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd, bool skip_tlb_flush,
 		     bool skip_mmu_sync)
 {
-	__kvm_mmu_new_cr3(vcpu, new_cr3, kvm_mmu_calc_root_page_role(vcpu),
+	__kvm_mmu_new_pgd(vcpu, new_pgd, kvm_mmu_calc_root_page_role(vcpu),
 			  skip_tlb_flush, skip_mmu_sync);
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_new_cr3);
+EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
 
 static unsigned long get_cr3(struct kvm_vcpu *vcpu)
 {
@@ -5038,7 +5038,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 		kvm_calc_shadow_ept_root_page_role(vcpu, accessed_dirty,
 						   execonly, level);
 
-	__kvm_mmu_new_cr3(vcpu, new_eptp, new_role.base, true, true);
+	__kvm_mmu_new_pgd(vcpu, new_eptp, new_role.base, true, true);
 
 	if (new_role.as_u64 == context->mmu_role.as_u64)
 		return;
@@ -5532,7 +5532,7 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
 		if (VALID_PAGE(mmu->prev_roots[i].hpa) &&
-		    pcid == kvm_get_pcid(vcpu, mmu->prev_roots[i].cr3)) {
+		    pcid == kvm_get_pcid(vcpu, mmu->prev_roots[i].pgd)) {
 			mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
 			tlb_flush = true;
 		}
@@ -5686,13 +5686,13 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
 
 	vcpu->arch.root_mmu.root_hpa = INVALID_PAGE;
-	vcpu->arch.root_mmu.root_cr3 = 0;
+	vcpu->arch.root_mmu.root_pgd = 0;
 	vcpu->arch.root_mmu.translate_gpa = translate_gpa;
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 		vcpu->arch.root_mmu.prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
 
 	vcpu->arch.guest_mmu.root_hpa = INVALID_PAGE;
-	vcpu->arch.guest_mmu.root_cr3 = 0;
+	vcpu->arch.guest_mmu.root_pgd = 0;
 	vcpu->arch.guest_mmu.translate_gpa = translate_gpa;
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 		vcpu->arch.guest_mmu.prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 72e69d841531..88fe87f8e140 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -356,7 +356,7 @@ static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
 		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
 			prev = &vcpu->arch.mmu->prev_roots[i];
 
-			if (nested_ept_root_matches(prev->hpa, prev->cr3,
+			if (nested_ept_root_matches(prev->hpa, prev->pgd,
 						    vmcs12->ept_pointer))
 				vcpu->arch.mmu->invlpg(vcpu, gpa, prev->hpa);
 		}
@@ -1166,7 +1166,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
 	 * nested_vmx_transition_mmu_sync for details on skipping the MMU sync.
 	 */
 	if (!nested_ept)
-		kvm_mmu_new_cr3(vcpu, cr3, true,
+		kvm_mmu_new_pgd(vcpu, cr3, true,
 				!nested_vmx_transition_mmu_sync(vcpu));
 
 	vcpu->arch.cr3 = cr3;
@@ -5233,13 +5233,13 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
 
 		roots_to_free = 0;
-		if (nested_ept_root_matches(mmu->root_hpa, mmu->root_cr3,
+		if (nested_ept_root_matches(mmu->root_hpa, mmu->root_pgd,
 					    operand.eptp))
 			roots_to_free |= KVM_MMU_ROOT_CURRENT;
 
 		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
 			if (nested_ept_root_matches(mmu->prev_roots[i].hpa,
-						    mmu->prev_roots[i].cr3,
+						    mmu->prev_roots[i].pgd,
 						    operand.eptp))
 				roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
 		}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d49d2a1ddf03..53fea2d38590 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5487,7 +5487,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 		}
 
 		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
-			if (kvm_get_pcid(vcpu, vcpu->arch.mmu->prev_roots[i].cr3)
+			if (kvm_get_pcid(vcpu, vcpu->arch.mmu->prev_roots[i].pgd)
 			    == operand.pcid)
 				roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0d1572a0791c..210af343eebf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1045,7 +1045,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		 !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
 		return 1;
 
-	kvm_mmu_new_cr3(vcpu, cr3, skip_tlb_flush, skip_tlb_flush);
+	kvm_mmu_new_pgd(vcpu, cr3, skip_tlb_flush, skip_tlb_flush);
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
 
-- 
2.24.1

