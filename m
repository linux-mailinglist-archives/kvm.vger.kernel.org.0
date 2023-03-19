Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBC246C0029
	for <lists+kvm@lfdr.de>; Sun, 19 Mar 2023 09:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbjCSIuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Mar 2023 04:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjCSItt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Mar 2023 04:49:49 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB25418B29
        for <kvm@vger.kernel.org>; Sun, 19 Mar 2023 01:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679215786; x=1710751786;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AF53uty/FJI81fea3GlOtXMqGAV27RC5qpM/OnDRXXE=;
  b=Q0TALjFrmP527rlZalUhjDwBVWvxEK7nxAg/GjC1OY5mwnD5SW9Vph3o
   1HCjeYbxfAaeIOW/eUUTqZCgQ76joGUCK4by5tiG4yovrYlyD93UT/A7F
   c2kydT5R0Q1ocGbhLydfrhsPVCOUMfJmHHCtsSJ7u/a2t/jlsh1Kly0Fs
   3ajh7YWZLeQJxaMM/SfGZ4aIY6KjUuLNN+y0acyE/M5q6hK9BmhM9mbW2
   4/22jPEI19XfWCl8AM/GwgBZeViJuh7yi/u2FDOyGkwAjGp7x3mAEhse6
   YbYwcyXqfixPjZaF5K6X8goa/nm0oEOMbQT4ZTIncf8uAo2Bc4g+HzHOP
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10653"; a="424767862"
X-IronPort-AV: E=Sophos;i="5.98,273,1673942400"; 
   d="scan'208";a="424767862"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 01:49:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10653"; a="683146306"
X-IronPort-AV: E=Sophos;i="5.98,273,1673942400"; 
   d="scan'208";a="683146306"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.254.209.111])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 01:49:44 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     chao.gao@intel.com, robert.hu@linux.intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v6 4/7] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Date:   Sun, 19 Mar 2023 16:49:24 +0800
Message-Id: <20230319084927.29607-5-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230319084927.29607-1-binbin.wu@linux.intel.com>
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Robert Hoo <robert.hu@linux.intel.com>

LAM uses CR3.LAM_U48 (bit 62) and CR3.LAM_U57 (bit 61) to configure LAM
masking for user mode pointers.

When EPT is on:
CR3 is fully under control of guest, guest LAM is thus transparent to KVM.

When EPT is off (shadow paging):
KVM needs to handle guest CR3.LAM_U48 and CR3.LAM_U57 toggles.
The two bits don't participate in page table walking. They should be masked
to get the base address of page table. When shadow paging is used, the two
bits should be kept as they are in the shadow CR3.
To be generic, introduce a field 'cr3_ctrl_bits' in kvm_vcpu_arch to record
the bits used to control supported features related to CR3 (e.g. LAM).
- Supported control bits are set to cr3_ctrl_bits.
- Add kvm_vcpu_is_legal_cr3() to validate CR3, allow setting of the control
  bits for the supported features.
- cr3_ctrl_bits is used to mask the control bits when calculate the base
  address of page table from mmu::get_guest_pgd().
- Add kvm_get_active_cr3_ctrl_bits() to get the active control bits to form
  a new guest CR3 (in vmx_load_mmu_pgd()).
- For only control bits toggle cases, it is unnecessary to make new pgd, but
  just make request of load pgd.
  Especially, for ONLY-LAM-bits toggle cases, skip TLB flush since hardware
  is not required to flush TLB when CR3 LAM bits toggled.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  7 +++++++
 arch/x86/kvm/cpuid.h            |  5 +++++
 arch/x86/kvm/mmu.h              |  5 +++++
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
 arch/x86/kvm/vmx/nested.c       |  6 +++---
 arch/x86/kvm/vmx/vmx.c          |  6 +++++-
 arch/x86/kvm/x86.c              | 29 +++++++++++++++++++++++------
 8 files changed, 50 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 742fd84c7997..2174ad27013b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -730,6 +730,13 @@ struct kvm_vcpu_arch {
 	unsigned long cr0_guest_owned_bits;
 	unsigned long cr2;
 	unsigned long cr3;
+	/*
+	 * Bits in CR3 used to enable certain features. These bits don't
+	 * participate in page table walking. They should be masked to
+	 * get the base address of page table. When shadow paging is
+	 * used, these bits should be kept as they are in the shadow CR3.
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
index 168c46fd8dd1..29985eeb8e12 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -142,6 +142,11 @@ static inline unsigned long kvm_get_active_pcid(struct kvm_vcpu *vcpu)
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
index aeb240b339f5..e0b86ace7326 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3722,7 +3722,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	int quadrant, i, r;
 	hpa_t root;
 
-	root_pgd = mmu->get_guest_pgd(vcpu);
+	root_pgd = mmu->get_guest_pgd(vcpu) & ~vcpu->arch.cr3_ctrl_bits;
 	root_gfn = root_pgd >> PAGE_SHIFT;
 
 	if (mmu_check_root(vcpu, root_gfn))
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index e5662dbd519c..8887615534b0 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -324,7 +324,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	trace_kvm_mmu_pagetable_walk(addr, access);
 retry_walk:
 	walker->level = mmu->cpu_role.base.level;
-	pte           = mmu->get_guest_pgd(vcpu);
+	pte           = mmu->get_guest_pgd(vcpu) & ~vcpu->arch.cr3_ctrl_bits;
 	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
 
 #if PTTYPE == 64
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0f84cc05f57c..2eb258992d63 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1079,7 +1079,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 			       bool nested_ept, bool reload_pdptrs,
 			       enum vm_entry_failure_code *entry_failure_code)
 {
-	if (CC(kvm_vcpu_is_illegal_gpa(vcpu, cr3))) {
+	if (CC(!kvm_vcpu_is_legal_cr3(vcpu, cr3))) {
 		*entry_failure_code = ENTRY_FAIL_DEFAULT;
 		return -EINVAL;
 	}
@@ -1101,7 +1101,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 	kvm_init_mmu(vcpu);
 
 	if (!nested_ept)
-		kvm_mmu_new_pgd(vcpu, cr3);
+		kvm_mmu_new_pgd(vcpu, cr3 & ~vcpu->arch.cr3_ctrl_bits);
 
 	return 0;
 }
@@ -2907,7 +2907,7 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 
 	if (CC(!nested_host_cr0_valid(vcpu, vmcs12->host_cr0)) ||
 	    CC(!nested_host_cr4_valid(vcpu, vmcs12->host_cr4)) ||
-	    CC(kvm_vcpu_is_illegal_gpa(vcpu, vmcs12->host_cr3)))
+	    CC(!kvm_vcpu_is_legal_cr3(vcpu, vmcs12->host_cr3)))
 		return -EINVAL;
 
 	if (CC(is_noncanonical_address(vmcs12->host_ia32_sysenter_esp, vcpu)) ||
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 66a50224293e..9638a3000256 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3390,7 +3390,8 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			update_guest_cr3 = false;
 		vmx_ept_load_pdptrs(vcpu);
 	} else {
-		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu);
+		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu) |
+		            kvm_get_active_cr3_ctrl_bits(vcpu);
 	}
 
 	if (update_guest_cr3)
@@ -7750,6 +7751,9 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		vmx->msr_ia32_feature_control_valid_bits &=
 			~FEAT_CTL_SGX_LC_ENABLED;
 
+	if (guest_cpuid_has(vcpu, X86_FEATURE_LAM))
+		vcpu->arch.cr3_ctrl_bits |= X86_CR3_LAM_U48 | X86_CR3_LAM_U57;
+
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 410327e7eb55..e74af72f53ec 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1236,7 +1236,7 @@ static void kvm_invalidate_pcid(struct kvm_vcpu *vcpu, unsigned long pcid)
 int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	bool skip_tlb_flush = false;
-	unsigned long pcid = 0;
+	unsigned long pcid = 0, old_cr3;
 #ifdef CONFIG_X86_64
 	bool pcid_enabled = !!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
 
@@ -1247,8 +1247,9 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	}
 #endif
 
+	old_cr3 = kvm_read_cr3(vcpu);
 	/* PDPTRs are always reloaded for PAE paging. */
-	if (cr3 == kvm_read_cr3(vcpu) && !is_pae_paging(vcpu))
+	if (cr3 == old_cr3 && !is_pae_paging(vcpu))
 		goto handle_tlb_flush;
 
 	/*
@@ -1256,14 +1257,30 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
 	 * the current vCPU mode is accurate.
 	 */
-	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
+	if (!kvm_vcpu_is_legal_cr3(vcpu, cr3))
 		return 1;
 
 	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
 		return 1;
 
-	if (cr3 != kvm_read_cr3(vcpu))
-		kvm_mmu_new_pgd(vcpu, cr3);
+	if (cr3 != old_cr3) {
+		if ((cr3 ^ old_cr3) & ~vcpu->arch.cr3_ctrl_bits) {
+			kvm_mmu_new_pgd(vcpu, cr3 & ~vcpu->arch.cr3_ctrl_bits);
+		} else {
+			/*
+			 * Though only control (LAM) bits changed, make the
+			 * request to force an update on guest CR3 because the
+			 * control (LAM) bits are stale
+			 */
+			kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
+			/*
+			 * HW is not required to flush TLB when CR3 LAM bits toggled.
+			 * Currently only LAM bits in cr3_ctrl_bits, if more bits added in
+			 * the future, need to check whether to skip TLB flush or not.
+			 */
+			skip_tlb_flush = true;
+		}
+	}
 
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
@@ -11305,7 +11322,7 @@ static bool kvm_is_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
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

