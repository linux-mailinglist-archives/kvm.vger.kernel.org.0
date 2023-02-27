Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 198B26A3D8D
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbjB0I4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjB0Izk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:55:40 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4697822782
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 00:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677487660; x=1709023660;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=THmjUcfk/6GSHNNmMU6Ebzb5sJJPJioIWDLVrFSanP8=;
  b=Bagqss00CL+oNd2QVX/Du0BuAEY86agMuhi/xqjrkZHIVoZgoDxJd1YI
   Nm3WqKR3a3WGld1ai+f14lpoI6hH7g96vPwq8qBR9VAmLFoGyHkPYxH5X
   quJ3KAakqEmHB3ntHXf7V/NvKpMSiq4GUkHh/vydikT1mPeOqo7D+1aZR
   7F1xh/QLKVNCoRT/LjGP4kLEef+kSlejSr8CzZpSs0AALZtwbIIjDhDJV
   nT1D+sf6j+C52g9t6vl1i7vm6uyhffTv0xeyuPrC0bWE71eBIfgQijuBD
   LFdTA1L5cTrpuP7dnKakj2qejRLviCJXB8WD0iftRaxQ7jJ+m8YrqGnnM
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="322057696"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="322057696"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:46:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="651127087"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="651127087"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga006.jf.intel.com with ESMTP; 27 Feb 2023 00:46:15 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com
Cc:     kvm@vger.kernel.org, Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v5 3/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Date:   Mon, 27 Feb 2023 16:45:45 +0800
Message-Id: <20230227084547.404871-4-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230227084547.404871-1-robert.hu@linux.intel.com>
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

LAM feature uses 2 high bits in CR3 (bit 62 for LAM_U48 and bit 61 for
LAM_U57) to enable/config LAM feature for user mode addresses. The LAM
masking is done before legacy canonical checks.

To virtualize LAM CR3 bits usage, this patch:
1. Don't reserve these 2 bits when LAM is enable on the vCPU. Previously
when validate CR3, kvm uses kvm_vcpu_is_legal_gpa(), now define
kvm_vcpu_is_valid_cr3() which is actually kvm_vcpu_is_legal_gpa()
+ CR3.LAM bits validation. Substitutes kvm_vcpu_is_legal/illegal_gpa()
with kvm_vcpu_is_valid_cr3() in call sites where is validating CR3 rather
than pure GPA.
2. mmu::get_guest_pgd(), its implementation is get_cr3() which returns
whole guest CR3 value. Strip LAM bits in those call sites that need pure
PGD value, e.g. mmu_alloc_shadow_roots(), FNAME(walk_addr_generic)().
3. When form a new guest CR3 (vmx_load_mmu_pgd()), melt in LAM bit
(kvm_get_active_lam()).
4. When guest sets CR3, identify ONLY-LAM-bits-toggling cases, where it is
unnecessary to make new pgd, but just make request of load pgd, then new
CR3.LAM bits configuration will be melt in (above point 3). To be
conservative, this case still do TLB flush.
5. For nested VM entry, allow the 2 CR3 bits set in corresponding
VMCS host/guest fields.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/mmu.h             |  5 +++++
 arch/x86/kvm/mmu/mmu.c         |  9 ++++++++-
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 arch/x86/kvm/vmx/nested.c      |  4 ++--
 arch/x86/kvm/vmx/vmx.c         |  3 ++-
 arch/x86/kvm/x86.c             | 33 ++++++++++++++++++++++++++++-----
 arch/x86/kvm/x86.h             |  1 +
 7 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 6bdaacb6faa0..866f2b7cb509 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -142,6 +142,11 @@ static inline unsigned long kvm_get_active_pcid(struct kvm_vcpu *vcpu)
 	return kvm_get_pcid(vcpu, kvm_read_cr3(vcpu));
 }
 
+static inline u64 kvm_get_active_lam(struct kvm_vcpu *vcpu)
+{
+	return kvm_read_cr3(vcpu) & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
+}
+
 static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 {
 	u64 root_hpa = vcpu->arch.mmu->root.hpa;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 835426254e76..3efec7f8d8c6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3699,7 +3699,14 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	int quadrant, i, r;
 	hpa_t root;
 
-	root_pgd = mmu->get_guest_pgd(vcpu);
+	/*
+	 * Omit guest_cpuid_has(X86_FEATURE_LAM) check but can unconditionally
+	 * strip CR3 LAM bits because they resides in high reserved bits,
+	 * with LAM or not, those high bits should be striped anyway when
+	 * interpreted to pgd.
+	 */
+	root_pgd = mmu->get_guest_pgd(vcpu) &
+		   ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
 	root_gfn = root_pgd >> PAGE_SHIFT;
 
 	if (mmu_check_root(vcpu, root_gfn))
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 0f6455072055..57f39c7492ed 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -324,7 +324,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	trace_kvm_mmu_pagetable_walk(addr, access);
 retry_walk:
 	walker->level = mmu->cpu_role.base.level;
-	pte           = mmu->get_guest_pgd(vcpu);
+	pte           = mmu->get_guest_pgd(vcpu) & ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
 	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
 
 #if PTTYPE == 64
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b6f4411b613e..301912155dd1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1078,7 +1078,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 			       bool nested_ept, bool reload_pdptrs,
 			       enum vm_entry_failure_code *entry_failure_code)
 {
-	if (CC(kvm_vcpu_is_illegal_gpa(vcpu, cr3))) {
+	if (CC(!kvm_vcpu_is_valid_cr3(vcpu, cr3))) {
 		*entry_failure_code = ENTRY_FAIL_DEFAULT;
 		return -EINVAL;
 	}
@@ -2906,7 +2906,7 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 
 	if (CC(!nested_host_cr0_valid(vcpu, vmcs12->host_cr0)) ||
 	    CC(!nested_host_cr4_valid(vcpu, vmcs12->host_cr4)) ||
-	    CC(kvm_vcpu_is_illegal_gpa(vcpu, vmcs12->host_cr3)))
+	    CC(!kvm_vcpu_is_valid_cr3(vcpu, vmcs12->host_cr3)))
 		return -EINVAL;
 
 	if (CC(is_noncanonical_address(vmcs12->host_ia32_sysenter_esp, vcpu)) ||
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fe5615fd8295..66edd091f145 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3289,7 +3289,8 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			update_guest_cr3 = false;
 		vmx_ept_load_pdptrs(vcpu);
 	} else {
-		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu);
+		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu) |
+			    kvm_get_active_lam(vcpu);
 	}
 
 	if (update_guest_cr3)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b9611690561d..be6c7c986f0f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1231,10 +1231,21 @@ static void kvm_invalidate_pcid(struct kvm_vcpu *vcpu, unsigned long pcid)
 	kvm_mmu_free_roots(vcpu->kvm, mmu, roots_to_free);
 }
 
+bool kvm_vcpu_is_valid_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
+{
+	if (guest_cpuid_has(vcpu, X86_FEATURE_LAM))
+		cr3 &= ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
+	else if (cr3 & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57))
+		return false;
+
+	return kvm_vcpu_is_legal_gpa(vcpu, cr3);
+}
+EXPORT_SYMBOL_GPL(kvm_vcpu_is_valid_cr3);
+
 int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	bool skip_tlb_flush = false;
-	unsigned long pcid = 0;
+	unsigned long pcid = 0, old_cr3;
 #ifdef CONFIG_X86_64
 	bool pcid_enabled = !!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
 
@@ -1254,14 +1265,26 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
 	 * the current vCPU mode is accurate.
 	 */
-	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
+	if (!kvm_vcpu_is_valid_cr3(vcpu, cr3))
 		return 1;
 
 	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
 		return 1;
 
-	if (cr3 != kvm_read_cr3(vcpu))
-		kvm_mmu_new_pgd(vcpu, cr3);
+	old_cr3 = kvm_read_cr3(vcpu);
+	if (cr3 != old_cr3) {
+		if ((cr3 ^ old_cr3) & ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57)) {
+			kvm_mmu_new_pgd(vcpu, cr3 & ~(X86_CR3_LAM_U48 |
+					X86_CR3_LAM_U57));
+		} else {
+			/*
+			 * Though only LAM bits change, mark the
+			 * request in order to force an update on guest CR3
+			 * because the LAM bits of old CR3 is stale
+			 */
+			kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
+		}
+	}
 
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
@@ -11185,7 +11208,7 @@ static bool kvm_is_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 		 */
 		if (!(sregs->cr4 & X86_CR4_PAE) || !(sregs->efer & EFER_LMA))
 			return false;
-		if (kvm_vcpu_is_illegal_gpa(vcpu, sregs->cr3))
+		if (!kvm_vcpu_is_valid_cr3(vcpu, sregs->cr3))
 			return false;
 	} else {
 		/*
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 8ec5cc983062..6b6bfddc84e0 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -440,6 +440,7 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 int kvm_spec_ctrl_test_value(u64 value);
 bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
+bool kvm_vcpu_is_valid_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
 int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 			      struct x86_exception *e);
 int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva);
-- 
2.31.1

