Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDC5154EB5
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 23:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgBFWIy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 17:08:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:30021 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727918AbgBFWIj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 17:08:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 14:08:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,411,1574150400"; 
   d="scan'208";a="404625098"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 06 Feb 2020 14:08:37 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] KVM: x86/mmu: Rename kvm_mmu->get_cr3() to ->get_guest_cr3_or_eptp()
Date:   Thu,  6 Feb 2020 14:08:35 -0800
Message-Id: <20200206220836.22743-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200206220836.22743-1-sean.j.christopherson@intel.com>
References: <20200206220836.22743-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename kvm_mmu->get_cr3() to call out that it is retrieving a guest
value, as opposed to kvm_mmu->set_cr3(), which sets a host value, and to
note that it will return L1's EPTP when nested EPT is in use.  Hopefully
the new name will also make it more obvious that L1's nested_cr3 is
returned in SVM's nested NPT case.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 24 ++++++++++++------------
 arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
 arch/x86/kvm/svm.c              | 10 +++++-----
 arch/x86/kvm/vmx/nested.c       |  8 ++++----
 arch/x86/kvm/x86.c              |  2 +-
 6 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 329d01c689b7..0ab898c14842 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -381,7 +381,7 @@ struct kvm_mmu_root_info {
  */
 struct kvm_mmu {
 	void (*set_cr3)(struct kvm_vcpu *vcpu, unsigned long root);
-	unsigned long (*get_cr3)(struct kvm_vcpu *vcpu);
+	unsigned long (*get_guest_cr3_or_eptp)(struct kvm_vcpu *vcpu);
 	u64 (*get_pdptr)(struct kvm_vcpu *vcpu, int index);
 	int (*page_fault)(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u32 err,
 			  bool prefault);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 33baa2b79652..2933abae280c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3718,7 +3718,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		vcpu->arch.mmu->root_hpa = __pa(vcpu->arch.mmu->pae_root);
 	} else
 		BUG();
-	vcpu->arch.mmu->root_cr3 = vcpu->arch.mmu->get_cr3(vcpu);
+	vcpu->arch.mmu->root_cr3 = vcpu->arch.mmu->get_guest_cr3_or_eptp(vcpu);
 
 	return 0;
 }
@@ -3730,7 +3730,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	gfn_t root_gfn, root_cr3;
 	int i;
 
-	root_cr3 = vcpu->arch.mmu->get_cr3(vcpu);
+	root_cr3 = vcpu->arch.mmu->get_guest_cr3_or_eptp(vcpu);
 	root_gfn = root_cr3 >> PAGE_SHIFT;
 
 	if (mmu_check_root(vcpu, root_gfn))
@@ -4067,7 +4067,7 @@ static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	arch.token = (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
 	arch.gfn = gfn;
 	arch.direct_map = vcpu->arch.mmu->direct_map;
-	arch.cr3 = vcpu->arch.mmu->get_cr3(vcpu);
+	arch.cr3 = vcpu->arch.mmu->get_guest_cr3_or_eptp(vcpu);
 
 	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
 				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
@@ -4919,7 +4919,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->shadow_root_level = kvm_x86_ops->get_tdp_level(vcpu);
 	context->direct_map = true;
 	context->set_cr3 = kvm_x86_ops->set_tdp_cr3;
-	context->get_cr3 = get_cr3;
+	context->get_guest_cr3_or_eptp = get_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
 
@@ -5067,10 +5067,10 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
 	struct kvm_mmu *context = vcpu->arch.mmu;
 
 	kvm_init_shadow_mmu(vcpu);
-	context->set_cr3           = kvm_x86_ops->set_cr3;
-	context->get_cr3           = get_cr3;
-	context->get_pdptr         = kvm_pdptr_read;
-	context->inject_page_fault = kvm_inject_page_fault;
+	context->set_cr3	       = kvm_x86_ops->set_cr3;
+	context->get_guest_cr3_or_eptp = get_cr3;
+	context->get_pdptr	       = kvm_pdptr_read;
+	context->inject_page_fault     = kvm_inject_page_fault;
 }
 
 static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
@@ -5082,10 +5082,10 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 	if (new_role.as_u64 == g_context->mmu_role.as_u64)
 		return;
 
-	g_context->mmu_role.as_u64 = new_role.as_u64;
-	g_context->get_cr3           = get_cr3;
-	g_context->get_pdptr         = kvm_pdptr_read;
-	g_context->inject_page_fault = kvm_inject_page_fault;
+	g_context->mmu_role.as_u64	 = new_role.as_u64;
+	g_context->get_guest_cr3_or_eptp = get_cr3;
+	g_context->get_pdptr		 = kvm_pdptr_read;
+	g_context->inject_page_fault	 = kvm_inject_page_fault;
 
 	/*
 	 * Note that arch.mmu->gva_to_gpa translates l2_gpa to l1_gpa using
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 6b15b58f3ecc..24dfa0fcba56 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -333,7 +333,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	trace_kvm_mmu_pagetable_walk(addr, access);
 retry_walk:
 	walker->level = mmu->root_level;
-	pte           = mmu->get_cr3(vcpu);
+	pte           = mmu->get_guest_cr3_or_eptp(vcpu);
 	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
 
 #if PTTYPE == 64
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 9dbb990c319a..ccbefb234ba0 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2998,11 +2998,11 @@ static void nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.mmu = &vcpu->arch.guest_mmu;
 	kvm_init_shadow_mmu(vcpu);
-	vcpu->arch.mmu->set_cr3           = nested_svm_set_tdp_cr3;
-	vcpu->arch.mmu->get_cr3           = nested_svm_get_tdp_cr3;
-	vcpu->arch.mmu->get_pdptr         = nested_svm_get_tdp_pdptr;
-	vcpu->arch.mmu->inject_page_fault = nested_svm_inject_npf_exit;
-	vcpu->arch.mmu->shadow_root_level = get_npt_level(vcpu);
+	vcpu->arch.mmu->set_cr3		      = nested_svm_set_tdp_cr3;
+	vcpu->arch.mmu->get_guest_cr3_or_eptp = nested_svm_get_tdp_cr3;
+	vcpu->arch.mmu->get_pdptr	      = nested_svm_get_tdp_pdptr;
+	vcpu->arch.mmu->inject_page_fault     = nested_svm_inject_npf_exit;
+	vcpu->arch.mmu->shadow_root_level     = get_npt_level(vcpu);
 	reset_shadow_zero_bits_mask(vcpu, vcpu->arch.mmu);
 	vcpu->arch.walk_mmu              = &vcpu->arch.nested_mmu;
 }
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b4f1be0b5608..8cab6f21f356 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -354,10 +354,10 @@ static void nested_ept_init_mmu_context(struct kvm_vcpu *vcpu)
 			VMX_EPT_EXECUTE_ONLY_BIT,
 			nested_ept_ad_enabled(vcpu),
 			nested_ept_get_eptp(vcpu));
-	vcpu->arch.mmu->set_cr3           = vmx_set_cr3;
-	vcpu->arch.mmu->get_cr3           = nested_ept_get_eptp;
-	vcpu->arch.mmu->inject_page_fault = nested_ept_inject_page_fault;
-	vcpu->arch.mmu->get_pdptr         = kvm_pdptr_read;
+	vcpu->arch.mmu->set_cr3		      = vmx_set_cr3;
+	vcpu->arch.mmu->get_guest_cr3_or_eptp = nested_ept_get_eptp;
+	vcpu->arch.mmu->inject_page_fault     = nested_ept_inject_page_fault;
+	vcpu->arch.mmu->get_pdptr	      = kvm_pdptr_read;
 
 	vcpu->arch.walk_mmu              = &vcpu->arch.nested_mmu;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0b0b143f0ab6..39e83d52d458 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10125,7 +10125,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 		return;
 
 	if (!vcpu->arch.mmu->direct_map &&
-	      work->arch.cr3 != vcpu->arch.mmu->get_cr3(vcpu))
+	      work->arch.cr3 != vcpu->arch.mmu->get_guest_cr3_or_eptp(vcpu))
 		return;
 
 	vcpu->arch.mmu->page_fault(vcpu, work->cr2_or_gpa, 0, true);
-- 
2.24.1

