Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2039E6FD67E
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 08:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236062AbjEJGGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 02:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236033AbjEJGGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 02:06:48 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC5E11B;
        Tue,  9 May 2023 23:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683698806; x=1715234806;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YOiQl/T37UeuzPGMw9RHriITaSNZlYPbFup82XgSCt0=;
  b=ThBqTmO4syb/Byd0VujFIw9hqWNQ4Ng71IlYP5veBoaz4IyrrAQwf1/Z
   qS7p2rJXXMl+Pef9aQS2SCe4tTpFN7xxZnsY2kUyeU+z18H1BCayg8x8G
   KxEwRhtGrWlMPH/YWUVevKqg4+qUGLnT76wqpiroMuNXSmqwg4AXxhXvD
   sN7SqO5YZYaoyVjuEEkc+NRPfR1Ca/5qFCbeAV2ZyJvZE+mIkDkGLapmp
   ipOmKN+ji4/ZRF5QOhfCsoGgsEccmpVzyz7uHdONoadQ4jFksQTGD2YEw
   th87BFOq9nsGD9hBvu3NE3R7LRrI7Zzae9wJrsmQlzHIUoIUU27mmOn6+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="348969262"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="348969262"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 23:06:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="768803100"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="768803100"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.238.8.90])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 23:06:43 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hu@linux.intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v8 3/6] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Date:   Wed, 10 May 2023 14:06:08 +0800
Message-Id: <20230510060611.12950-4-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230510060611.12950-1-binbin.wu@linux.intel.com>
References: <20230510060611.12950-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Robert Hoo <robert.hu@linux.intel.com>

Add support to allow guests to set two new CR3 non-address control bits for
guests to enable the new Intel CPU feature Linear Address Masking (LAM) on user
pointers.

LAM modifies the checking that is applied to 64-bit linear addresses, allowing
software to use of the untranslated address bits for metadata and masks the
metadata bits before using them as linear addresses to access memory. LAM uses
two new CR3 non-address bits LAM_U48 (bit 62) and AM_U57 (bit 61) to configure
LAM for user pointers. LAM also changes VMENTER to allow both bits to be set in
VMCS's HOST_CR3 and GUEST_CR3 for virtualization.

When EPT is on, CR3 is not trapped by KVM and it's up to the guest to set any of
the two LAM control bits. However, when EPT is off, the actual CR3 used by the
guest is generated from the shadow MMU root which is different from the CR3 that
is *set* by the guest, and KVM needs to manually apply any active control bits
to VMCS's GUEST_CR3 based on the cached CR3 *seen* by the guest.

KVM manually checks guest's CR3 to make sure it points to a valid guest physical
address (i.e. to support smaller MAXPHYSADDR in the guest). Extend this check
to allow the two LAM control bits to be set. And to make such check generic,
introduce a new field 'cr3_ctrl_bits' to vcpu to record all feature control bits
that are allowed to be set by the guest. After check, non-address bits of guest
CR3 will be stripped off to extract guest physical address.

In case of nested, for a guest which supports LAM, both VMCS12's HOST_CR3 and
GUEST_CR3 are allowed to have the new LAM control bits set, i.e. when L0 enters
L1 to emulate a VMEXIT from L2 to L1 or when L0 enters L2 directly. KVM also
manually checks VMCS12's HOST_CR3 and GUEST_CR3 being valid physical address.
Extend such check to allow the new LAM control bits too.

Note, LAM doesn't have a global control bit to turn on/off LAM completely, but
purely depends on hardware's CPUID to determine it can be enabled or not. That
means, when EPT is on, even when KVM doesn't expose LAM to guest, the guest can
still set LAM control bits in CR3 w/o causing problem. This is an unfortunate
virtualization hole. KVM could choose to intercept CR3 in this case and inject
fault but this would hurt performance when running a normal VM w/o LAM support.
This is undesirable. Just choose to let the guest do such illegal thing as the
worst case is guest being killed when KVM eventually find out such illegal
behaviour and that is the guest to blame.

Opportunistically use GENMASK_ULL() to define __PT_BASE_ADDR_MASK.
Opportunistically use kvm_vcpu_is_legal_cr3() to check CR3 in SVM nested code,
to provide a clear distinction b/t CR3 and GPA checks.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 5 +++++
 arch/x86/kvm/cpuid.h            | 5 +++++
 arch/x86/kvm/mmu.h              | 5 +++++
 arch/x86/kvm/mmu/mmu.c          | 8 +++++++-
 arch/x86/kvm/mmu/mmu_internal.h | 1 +
 arch/x86/kvm/mmu/paging_tmpl.h  | 3 ++-
 arch/x86/kvm/mmu/spte.h         | 2 +-
 arch/x86/kvm/svm/nested.c       | 4 ++--
 arch/x86/kvm/vmx/nested.c       | 4 ++--
 arch/x86/kvm/vmx/vmx.c          | 6 +++++-
 arch/x86/kvm/x86.c              | 4 ++--
 11 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c6f03d151c31..46471dd9cc1b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -727,6 +727,11 @@ struct kvm_vcpu_arch {
 	unsigned long cr0_guest_owned_bits;
 	unsigned long cr2;
 	unsigned long cr3;
+	/*
+	 * CR3 non-address feature control bits.
+	 * Guest CR3 may contain any of those bits at runtime.
+	 */
+	u64 cr3_ctrl_bits;
 	unsigned long cr4;
 	unsigned long cr4_guest_owned_bits;
 	unsigned long cr4_guest_rsvd_bits;
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index b1658c0de847..ef8e1b912d7d 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -42,6 +42,11 @@ static inline int cpuid_maxphyaddr(struct kvm_vcpu *vcpu)
 	return vcpu->arch.maxphyaddr;
 }
 
+static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
+{
+	return !((cr3 & vcpu->arch.reserved_gpa_bits) & ~vcpu->arch.cr3_ctrl_bits);
+}
+
 static inline bool kvm_vcpu_is_legal_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
 {
 	return !(gpa & vcpu->arch.reserved_gpa_bits);
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 92d5a1924fc1..81d8a433dae1 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -144,6 +144,11 @@ static inline unsigned long kvm_get_active_pcid(struct kvm_vcpu *vcpu)
 	return kvm_get_pcid(vcpu, kvm_read_cr3(vcpu));
 }
 
+static inline u64 kvm_get_active_cr3_ctrl_bits(struct kvm_vcpu *vcpu)
+{
+	return kvm_read_cr3(vcpu) & vcpu->arch.cr3_ctrl_bits;
+}
+
 static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 {
 	u64 root_hpa = vcpu->arch.mmu->root.hpa;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c8961f45e3b1..deea9a9f0c75 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3812,7 +3812,13 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	hpa_t root;
 
 	root_pgd = kvm_mmu_get_guest_pgd(vcpu, mmu);
-	root_gfn = root_pgd >> PAGE_SHIFT;
+	/*
+	 * Guest PGD can be CR3 or EPTP (for nested EPT case). CR3 may contain
+	 * additional control bits (e.g. LAM control bits). To be generic,
+	 * unconditionally strip non-address bits when computing the GFN since
+	 * the guest PGD has already been checked for validity.
+	 */
+	root_gfn = (root_pgd & __PT_BASE_ADDR_MASK) >> PAGE_SHIFT;
 
 	if (mmu_check_root(vcpu, root_gfn))
 		return 1;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index d39af5639ce9..7d2105432d66 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -21,6 +21,7 @@ extern bool dbg;
 #endif
 
 /* Page table builder macros common to shadow (host) PTEs and guest PTEs. */
+#define __PT_BASE_ADDR_MASK GENMASK_ULL(51, 12)
 #define __PT_LEVEL_SHIFT(level, bits_per_level)	\
 	(PAGE_SHIFT + ((level) - 1) * (bits_per_level))
 #define __PT_INDEX(address, level, bits_per_level) \
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 0662e0278e70..394733ac9088 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -62,7 +62,7 @@
 #endif
 
 /* Common logic, but per-type values.  These also need to be undefined. */
-#define PT_BASE_ADDR_MASK	((pt_element_t)(((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1)))
+#define PT_BASE_ADDR_MASK	((pt_element_t)__PT_BASE_ADDR_MASK)
 #define PT_LVL_ADDR_MASK(lvl)	__PT_LVL_ADDR_MASK(PT_BASE_ADDR_MASK, lvl, PT_LEVEL_BITS)
 #define PT_LVL_OFFSET_MASK(lvl)	__PT_LVL_OFFSET_MASK(PT_BASE_ADDR_MASK, lvl, PT_LEVEL_BITS)
 #define PT_INDEX(addr, lvl)	__PT_INDEX(addr, lvl, PT_LEVEL_BITS)
@@ -324,6 +324,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	trace_kvm_mmu_pagetable_walk(addr, access);
 retry_walk:
 	walker->level = mmu->cpu_role.base.level;
+	/* gpte_to_gfn() will strip non-address bits. */
 	pte           = kvm_mmu_get_guest_pgd(vcpu, mmu);
 	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 1279db2eab44..777f7d443e3b 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -36,7 +36,7 @@ static_assert(SPTE_TDP_AD_ENABLED == 0);
 #ifdef CONFIG_DYNAMIC_PHYSICAL_MASK
 #define SPTE_BASE_ADDR_MASK (physical_mask & ~(u64)(PAGE_SIZE-1))
 #else
-#define SPTE_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
+#define SPTE_BASE_ADDR_MASK __PT_BASE_ADDR_MASK
 #endif
 
 #define SPTE_PERM_MASK (PT_PRESENT_MASK | PT_WRITABLE_MASK | shadow_user_mask \
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 96936ddf1b3c..1df801a48451 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -311,7 +311,7 @@ static bool __nested_vmcb_check_save(struct kvm_vcpu *vcpu,
 	if ((save->efer & EFER_LME) && (save->cr0 & X86_CR0_PG)) {
 		if (CC(!(save->cr4 & X86_CR4_PAE)) ||
 		    CC(!(save->cr0 & X86_CR0_PE)) ||
-		    CC(kvm_vcpu_is_illegal_gpa(vcpu, save->cr3)))
+		    CC(!kvm_vcpu_is_legal_cr3(vcpu, save->cr3)))
 			return false;
 	}
 
@@ -520,7 +520,7 @@ static void nested_svm_transition_tlb_flush(struct kvm_vcpu *vcpu)
 static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 			       bool nested_npt, bool reload_pdptrs)
 {
-	if (CC(kvm_vcpu_is_illegal_gpa(vcpu, cr3)))
+	if (CC(!kvm_vcpu_is_legal_cr3(vcpu, cr3)))
 		return -EINVAL;
 
 	if (reload_pdptrs && !nested_npt && is_pae_paging(vcpu) &&
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e35cf0bd0df9..11b12a75ca91 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1085,7 +1085,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 			       bool nested_ept, bool reload_pdptrs,
 			       enum vm_entry_failure_code *entry_failure_code)
 {
-	if (CC(kvm_vcpu_is_illegal_gpa(vcpu, cr3))) {
+	if (CC(!kvm_vcpu_is_legal_cr3(vcpu, cr3))) {
 		*entry_failure_code = ENTRY_FAIL_DEFAULT;
 		return -EINVAL;
 	}
@@ -2913,7 +2913,7 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 
 	if (CC(!nested_host_cr0_valid(vcpu, vmcs12->host_cr0)) ||
 	    CC(!nested_host_cr4_valid(vcpu, vmcs12->host_cr4)) ||
-	    CC(kvm_vcpu_is_illegal_gpa(vcpu, vmcs12->host_cr3)))
+	    CC(!kvm_vcpu_is_legal_cr3(vcpu, vmcs12->host_cr3)))
 		return -EINVAL;
 
 	if (CC(is_noncanonical_address(vmcs12->host_ia32_sysenter_esp, vcpu)) ||
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 362b2dce7661..9c80048ca30c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3361,7 +3361,8 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			update_guest_cr3 = false;
 		vmx_ept_load_pdptrs(vcpu);
 	} else {
-		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu);
+		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu) |
+		            kvm_get_active_cr3_ctrl_bits(vcpu);
 	}
 
 	if (update_guest_cr3)
@@ -7743,6 +7744,9 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		vmx->msr_ia32_feature_control_valid_bits &=
 			~FEAT_CTL_SGX_LC_ENABLED;
 
+	if (guest_cpuid_has(vcpu, X86_FEATURE_LAM))
+		vcpu->arch.cr3_ctrl_bits |= X86_CR3_LAM_U48 | X86_CR3_LAM_U57;
+
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ceb7c5e9cf9e..f0059a1e9ac8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1275,7 +1275,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
 	 * the current vCPU mode is accurate.
 	 */
-	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
+	if (!kvm_vcpu_is_legal_cr3(vcpu, cr3))
 		return 1;
 
 	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
@@ -11443,7 +11443,7 @@ static bool kvm_is_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 		 */
 		if (!(sregs->cr4 & X86_CR4_PAE) || !(sregs->efer & EFER_LMA))
 			return false;
-		if (kvm_vcpu_is_illegal_gpa(vcpu, sregs->cr3))
+		if (!kvm_vcpu_is_legal_cr3(vcpu, sregs->cr3))
 			return false;
 	} else {
 		/*
-- 
2.25.1

