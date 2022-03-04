Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B414CDF4C
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 22:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiCDUcV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:32:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiCDUcS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:32:18 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C135C1EBAA0;
        Fri,  4 Mar 2022 12:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646425884; x=1677961884;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RtQ+v1zoudDLQqL10db4hIhngsqy0ZhI6lXufIdB85A=;
  b=a4sv7jaspYXH/L0xC9PJWioR9//O+fkocVw4eaYdWhlhEW1+qsu+MKgk
   VbyCVoJH/uub5Z8YHhNsjyA0t/dj/SXhkwFOQVkWO3j9TdZML7YbnGENC
   GTu7B+xD9iNwuP8UQrTbQfiQipEl5+O8hIx/+c5TB9n2cOgbtheKXxyMQ
   SnC4gwM8Qi/QfV4N+NdJUYIY4Q1znHg4O3FOV33bDf7ro+pPY0ITKROEF
   /rlQXvOhkVpRilRFV5crOGQ/4W2nE1keZ2uhcRp1XkH6/KtiOYBeftwZK
   wrzJmPOuSET/X6YosqrxFXeiPacivNQZNsjlIGOwDLQmIQcidlay/kLPO
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="251624218"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="251624218"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:26 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344386"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:25 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 051/104] KVM: TDX: TDP MMU TDX support
Date:   Fri,  4 Mar 2022 11:49:07 -0800
Message-Id: <0cb08c592fc83a2b5f76daef130bca5a11415af1.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Implement hooks of TDP MMU for TDX backend.  TLB flush, TLB shootdown,
propagating the change private EPT entry to Secure EPT and freeing Secure
EPT page.

TLB flush handles both shared EPT and private EPT.  It flushes shared EPT
same as VMX.  It also waits for the TDX TLB shootdown.

For the hook to free Secure EPT page, unlinks the Secure EPT page from the
Secure EPT so that the page can be freed to OS.

Propagating the entry change to Secure EPT.  The possible entry changes are
present -> non-present(zapping) and non-present -> present(population).  On
population just link the Secure EPT page or the private guest page to the
Secure EPT by TDX SEAMCALL.

Because TDP MMU allows concurrent zapping/population, zapping requires
synchronous TLB shootdown with the frozen EPT entry.  It zaps the secure
entry, increments TLB counter, sends IPI to remote vcpus to trigger TLB
flush, and then unlinks the private guest page from the Secure EPT.

For simplicity, batched zapping with exclude lock is handled as concurrent
zapping.  Although it's inefficient, it can be optimized in the future.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    |  40 +++++-
 arch/x86/kvm/vmx/tdx.c     | 246 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h     |  14 +++
 arch/x86/kvm/vmx/tdx_ops.h |   3 +
 arch/x86/kvm/vmx/x86_ops.h |   2 +
 5 files changed, 301 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 6969e3557bd4..f571b07c2aae 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -89,6 +89,38 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	return vmx_vcpu_reset(vcpu, init_event);
 }
 
+static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_flush_tlb(vcpu);
+
+	vmx_flush_tlb_all(vcpu);
+}
+
+static void vt_flush_tlb_current(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_flush_tlb(vcpu);
+
+	vmx_flush_tlb_current(vcpu);
+}
+
+static void vt_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
+{
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
+	vmx_flush_tlb_gva(vcpu, addr);
+}
+
+static void vt_flush_tlb_guest(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_flush_tlb_guest(vcpu);
+}
+
 static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			int pgd_level)
 {
@@ -162,10 +194,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.set_rflags = vmx_set_rflags,
 	.get_if_flag = vmx_get_if_flag,
 
-	.tlb_flush_all = vmx_flush_tlb_all,
-	.tlb_flush_current = vmx_flush_tlb_current,
-	.tlb_flush_gva = vmx_flush_tlb_gva,
-	.tlb_flush_guest = vmx_flush_tlb_guest,
+	.tlb_flush_all = vt_flush_tlb_all,
+	.tlb_flush_current = vt_flush_tlb_current,
+	.tlb_flush_gva = vt_flush_tlb_gva,
+	.tlb_flush_guest = vt_flush_tlb_guest,
 
 	.vcpu_pre_run = vmx_vcpu_pre_run,
 	.run = vmx_vcpu_run,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 51098e10b6a0..5d74ae001e4f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -5,7 +5,9 @@
 
 #include "capabilities.h"
 #include "x86_ops.h"
+#include "mmu.h"
 #include "tdx.h"
+#include "vmx.h"
 #include "x86.h"
 
 #undef pr_fmt
@@ -272,6 +274,15 @@ int tdx_vm_init(struct kvm *kvm)
 	int ret, i;
 	u64 err;
 
+	/*
+	 * To generate EPT violation to inject #VE instead of EPT MISCONFIG,
+	 * set RWX=0.
+	 */
+	kvm_mmu_set_mmio_spte_mask(kvm, 0, VMX_EPT_RWX_MASK, 0);
+
+	/* TODO: Enable 2mb and 1gb large page support. */
+	kvm->arch.tdp_max_page_level = PG_LEVEL_4K;
+
 	/* vCPUs can't be created until after KVM_TDX_INIT_VM. */
 	kvm->max_vcpus = 0;
 
@@ -331,6 +342,8 @@ int tdx_vm_init(struct kvm *kvm)
 		tdx_mark_td_page_added(&kvm_tdx->tdcs[i]);
 	}
 
+	spin_lock_init(&kvm_tdx->seamcall_lock);
+
 	/*
 	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
 	 * ioctl() to define the configure CPUID values for the TD.
@@ -501,6 +514,220 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
 }
 
+static void __tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
+					enum pg_level level, kvm_pfn_t pfn)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	hpa_t hpa = pfn_to_hpa(pfn);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	struct tdx_module_output out;
+	u64 err;
+
+	if (WARN_ON_ONCE(is_error_noslot_pfn(pfn) || kvm_is_reserved_pfn(pfn)))
+		return;
+
+	/* TODO: handle large pages. */
+	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
+		return;
+
+	/* Pin the page, TDX KVM doesn't yet support page migration. */
+	get_page(pfn_to_page(pfn));
+
+	if (likely(is_td_finalized(kvm_tdx))) {
+		err = tdh_mem_page_aug(kvm_tdx->tdr.pa, gpa, hpa, &out);
+		if (KVM_BUG_ON(err, kvm))
+			pr_tdx_error(TDH_MEM_PAGE_AUG, err, &out);
+		return;
+	}
+}
+
+static void tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
+				      enum pg_level level, kvm_pfn_t pfn)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+
+	spin_lock(&kvm_tdx->seamcall_lock);
+	__tdx_sept_set_private_spte(kvm, gfn, level, pfn);
+	spin_unlock(&kvm_tdx->seamcall_lock);
+}
+
+static void tdx_sept_drop_private_spte(
+	struct kvm *kvm, gfn_t gfn, enum pg_level level, kvm_pfn_t pfn)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	hpa_t hpa = pfn_to_hpa(pfn);
+	hpa_t hpa_with_hkid;
+	struct tdx_module_output out;
+	u64 err = 0;
+
+	/* TODO: handle large pages. */
+	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
+		return;
+
+	spin_lock(&kvm_tdx->seamcall_lock);
+	if (is_hkid_assigned(kvm_tdx)) {
+		err = tdh_mem_page_remove(kvm_tdx->tdr.pa, gpa, tdx_level, &out);
+		if (KVM_BUG_ON(err, kvm)) {
+			pr_tdx_error(TDH_MEM_PAGE_REMOVE, err, &out);
+			goto unlock;
+		}
+
+		hpa_with_hkid = set_hkid_to_hpa(hpa, (u16)kvm_tdx->hkid);
+		err = tdh_phymem_page_wbinvd(hpa_with_hkid);
+		if (WARN_ON_ONCE(err)) {
+			pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
+			goto unlock;
+		}
+	} else
+		err = tdx_reclaim_page((unsigned long)__va(hpa), hpa);
+
+unlock:
+	spin_unlock(&kvm_tdx->seamcall_lock);
+
+	if (!err)
+		put_page(pfn_to_page(pfn));
+}
+
+static int tdx_sept_link_private_sp(struct kvm *kvm, gfn_t gfn,
+				    enum pg_level level, void *sept_page)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	hpa_t hpa = __pa(sept_page);
+	struct tdx_module_output out;
+	u64 err;
+
+	spin_lock(&kvm_tdx->seamcall_lock);
+	err = tdh_mem_sept_add(kvm_tdx->tdr.pa, gpa, tdx_level, hpa, &out);
+	spin_unlock(&kvm_tdx->seamcall_lock);
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error(TDH_MEM_SEPT_ADD, err, &out);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static void tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
+				      enum pg_level level)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	struct tdx_module_output out;
+	u64 err;
+
+	spin_lock(&kvm_tdx->seamcall_lock);
+	err = tdh_mem_range_block(kvm_tdx->tdr.pa, gpa, tdx_level, &out);
+	spin_unlock(&kvm_tdx->seamcall_lock);
+	if (KVM_BUG_ON(err, kvm))
+		pr_tdx_error(TDH_MEM_RANGE_BLOCK, err, &out);
+}
+
+static int tdx_sept_free_private_sp(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				    void *sept_page)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	int ret;
+
+	/*
+	 * free_private_sp() is (obviously) called when a shadow page is being
+	 * zapped.  KVM doesn't (yet) zap private SPs while the TD is active.
+	 */
+	if (KVM_BUG_ON(is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
+		return -EINVAL;
+
+	spin_lock(&kvm_tdx->seamcall_lock);
+	ret = tdx_reclaim_page((unsigned long)sept_page, __pa(sept_page));
+	spin_unlock(&kvm_tdx->seamcall_lock);
+
+	return ret;
+}
+
+static int tdx_sept_tlb_remote_flush(struct kvm *kvm)
+{
+	struct kvm_tdx *kvm_tdx;
+	u64 err;
+
+	if (!is_td(kvm))
+		return -EOPNOTSUPP;
+
+	kvm_tdx = to_kvm_tdx(kvm);
+	if (!is_hkid_assigned(kvm_tdx))
+		return 0;
+
+	/* If TD isn't finalized, it's before any vcpu running. */
+	if (unlikely(!is_td_finalized(kvm_tdx)))
+		return 0;
+
+	kvm_tdx->tdh_mem_track = true;
+
+	kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH);
+
+	err = tdh_mem_track(kvm_tdx->tdr.pa);
+	if (KVM_BUG_ON(err, kvm))
+		pr_tdx_error(TDH_MEM_TRACK, err, NULL);
+
+	WRITE_ONCE(kvm_tdx->tdh_mem_track, false);
+
+	return 0;
+}
+
+static void tdx_handle_changed_private_spte(
+	struct kvm *kvm, gfn_t gfn, enum pg_level level,
+	kvm_pfn_t old_pfn, bool was_present, bool was_leaf,
+	kvm_pfn_t new_pfn, bool is_present, bool is_leaf, void *sept_page)
+{
+	WARN_ON(!is_td(kvm));
+	lockdep_assert_held(&kvm->mmu_lock);
+
+	if (is_present) {
+		/* TDP MMU doesn't change present -> present */
+		WARN_ON(was_present);
+
+		/*
+		 * Use different call to either set up middle level
+		 * private page table, or leaf.
+		 */
+		if (is_leaf)
+			tdx_sept_set_private_spte(kvm, gfn, level, new_pfn);
+		else {
+			WARN_ON(!sept_page);
+			if (tdx_sept_link_private_sp(kvm, gfn, level, sept_page))
+				/* failed to update Secure-EPT.  */
+				WARN_ON(1);
+		}
+	} else if (was_leaf) {
+		/* non-present -> non-present doesn't make sense. */
+		WARN_ON(!was_present);
+
+		/*
+		 * Zap private leaf SPTE.  Zapping private table is done
+		 * below in handle_removed_tdp_mmu_page().
+		 */
+		tdx_sept_zap_private_spte(kvm, gfn, level);
+
+		/*
+		 * TDX requires TLB tracking before dropping private page.  Do
+		 * it here, although it is also done later.
+		 * If hkid isn't assigned, the guest is destroying and no vcpu
+		 * runs further.  TLB shootdown isn't needed.
+		 *
+		 * TODO: implement with_range version for optimization.
+		 * kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
+		 *   => tdx_sept_tlb_remote_flush_with_range(kvm, gfn,
+		 *                                 KVM_PAGES_PER_HPAGE(level));
+		 */
+		if (is_hkid_assigned(to_kvm_tdx(kvm)))
+			kvm_flush_remote_tlbs(kvm);
+
+		tdx_sept_drop_private_spte(kvm, gfn, level, old_pfn);
+	}
+}
+
 static int tdx_capabilities(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
@@ -736,6 +963,21 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	return ret;
 }
 
+void tdx_flush_tlb(struct kvm_vcpu *vcpu)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct kvm_mmu *mmu = vcpu->arch.mmu;
+	u64 root_hpa = mmu->root_hpa;
+
+	/* Flush the shared EPTP, if it's valid. */
+	if (VALID_PAGE(root_hpa))
+		ept_sync_context(construct_eptp(vcpu, root_hpa,
+						mmu->shadow_root_level));
+
+	while (READ_ONCE(kvm_tdx->tdh_mem_track))
+		cpu_relax();
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
@@ -901,6 +1143,10 @@ static int __init __tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 	hkid_start_pos = boot_cpu_data.x86_phys_bits;
 	hkid_mask = GENMASK_ULL(max_pa - 1, hkid_start_pos);
 
+	x86_ops->tlb_remote_flush = tdx_sept_tlb_remote_flush;
+	x86_ops->free_private_sp = tdx_sept_free_private_sp;
+	x86_ops->handle_changed_private_spte = tdx_handle_changed_private_spte;
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index b32e068c51b4..906666c7c70b 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -29,9 +29,17 @@ struct kvm_tdx {
 	struct kvm_cpuid_entry2 cpuid_entries[KVM_MAX_CPUID_ENTRIES];
 
 	bool finalized;
+	bool tdh_mem_track;
 
 	u64 tsc_offset;
 	unsigned long tsc_khz;
+
+	/*
+	 * Lock to prevent seamcalls from running concurrently
+	 * when TDP MMU is enabled, because TDP fault handler
+	 * runs concurrently.
+	 */
+	spinlock_t seamcall_lock;
 };
 
 struct vcpu_tdx {
@@ -166,6 +174,12 @@ static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 fiel
 	return out.r8;
 }
 
+static __always_inline int pg_level_to_tdx_sept_level(enum pg_level level)
+{
+	WARN_ON(level == PG_LEVEL_NONE);
+	return level - 1;
+}
+
 #else
 #define enable_tdx false
 static inline int tdx_module_setup(void) { return -ENODEV; };
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index dc76b3a5cf96..cb40edc8c245 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -30,12 +30,14 @@ static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
 static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source,
 				struct tdx_module_output *out)
 {
+	tdx_clflush_page(hpa);
 	return kvm_seamcall(TDH_MEM_PAGE_ADD, gpa, tdr, hpa, source, 0, out);
 }
 
 static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
 				struct tdx_module_output *out)
 {
+	tdx_clflush_page(page);
 	return kvm_seamcall(TDH_MEM_SEPT_ADD, gpa | level, tdr, page, 0, 0, out);
 }
 
@@ -48,6 +50,7 @@ static inline u64 tdh_vp_addcx(hpa_t tdvpr, hpa_t addr)
 static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
 				struct tdx_module_output *out)
 {
+	tdx_clflush_page(hpa);
 	return kvm_seamcall(TDH_MEM_PAGE_AUG, gpa, tdr, hpa, 0, 0, out);
 }
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index ad9b1c883761..922a3799336e 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -144,6 +144,7 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
+void tdx_flush_tlb(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 #else
 static inline void tdx_pre_kvm_init(
@@ -163,6 +164,7 @@ static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
+static inline void tdx_flush_tlb(struct kvm_vcpu *vcpu) {}
 static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
 #endif
 
-- 
2.25.1

