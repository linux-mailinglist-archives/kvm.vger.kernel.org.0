Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5123355E16D
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241894AbiF0V5P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241529AbiF0Vzi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:55:38 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82649DE9C;
        Mon, 27 Jun 2022 14:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366902; x=1687902902;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6oHKg9gM/Ae8MJy7QQX35Iytobr64XHO3OU0vbYaT10=;
  b=h5nQ0uuDC/WgGTwlprCSpgxVb6JL2DEH++Q6ttrCIrV4+foZgfghV4KK
   OL9FwHhrEecmgtD2ai5FAAVfSEqTKbngoKMi75F5vDbrHkEQd0MCvFYMG
   OpVwumCM9jeNCOyIn9l3qwykx/lMi2TDQ3o91xDOEzec2o++UAajx2o0+
   fzVgND7boUnUSL1oAuJGyqOznL6Nm2lHgMg2VgrdIRF7xw7lQo0t3iu5a
   MOYvtzN/MzDQLDr64VPXKh8tuuaX0yGFSjr4OLFksplo2o/fcTAtWhsHo
   yQS3gO5NX0FsxPW0ftsrcYu5iq79f6tV6hE+OCNGNsfNvlZ0FXm7dx2oB
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="281609585"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="281609585"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:55 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863610"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:55 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 054/102] KVM: TDX: TDP MMU TDX support
Date:   Mon, 27 Jun 2022 14:53:46 -0700
Message-Id: <e43d6ef9434712c61d65195794e7e4d154fa0290.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/main.c    |  40 ++++-
 arch/x86/kvm/vmx/tdx.c     | 318 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h     |  21 +++
 arch/x86/kvm/vmx/x86_ops.h |   2 +
 4 files changed, 377 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 252b7298b230..442d89e02459 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -110,6 +110,38 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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
@@ -185,10 +217,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.set_rflags = vmx_set_rflags,
 	.get_if_flag = vmx_get_if_flag,
 
-	.flush_tlb_all = vmx_flush_tlb_all,
-	.flush_tlb_current = vmx_flush_tlb_current,
-	.flush_tlb_gva = vmx_flush_tlb_gva,
-	.flush_tlb_guest = vmx_flush_tlb_guest,
+	.flush_tlb_all = vt_flush_tlb_all,
+	.flush_tlb_current = vt_flush_tlb_current,
+	.flush_tlb_gva = vt_flush_tlb_gva,
+	.flush_tlb_guest = vt_flush_tlb_guest,
 
 	.vcpu_pre_run = vmx_vcpu_pre_run,
 	.vcpu_run = vmx_vcpu_run,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 24b428b7491d..3d578197d567 100644
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
@@ -290,6 +292,22 @@ int tdx_vm_init(struct kvm *kvm)
 	int ret, i;
 	u64 err;
 
+	/*
+	 * Because guest TD is protected, VMM can't parse the instruction in TD.
+	 * Instead, guest uses MMIO hypercall.  For unmodified device driver,
+	 * #VE needs to be injected for MMIO and #VE handler in TD converts MMIO
+	 * instruction into MMIO hypercall.
+	 *
+	 * SPTE value for MMIO needs to be setup so that #VE is injected into
+	 * TD instead of triggering EPT MISCONFIG.
+	 * - RWX=0 so that EPT violation is triggered.
+	 * - suppress #VE bit is cleared to inject #VE.
+	 */
+	kvm_mmu_set_mmio_spte_mask(kvm, 0, VMX_EPT_RWX_MASK, 0);
+
+	/* TODO: Enable 2mb and 1gb large page support. */
+	kvm->arch.tdp_max_page_level = PG_LEVEL_4K;
+
 	/* vCPUs can't be created until after KVM_TDX_INIT_VM. */
 	kvm->max_vcpus = 0;
 
@@ -374,6 +392,8 @@ int tdx_vm_init(struct kvm *kvm)
 		tdx_mark_td_page_added(&kvm_tdx->tdcs[i]);
 	}
 
+	spin_lock_init(&kvm_tdx->seamcall_lock);
+
 	/*
 	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
 	 * ioctl() to define the configure CPUID values for the TD.
@@ -537,6 +557,281 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
 }
 
+static void tdx_unpin_pfn(struct kvm *kvm, kvm_pfn_t pfn)
+{
+	struct page *page = pfn_to_page(pfn);
+
+	put_page(page);
+	WARN_ON(!page_count(page) && to_kvm_tdx(kvm)->hkid > 0);
+}
+
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
+	/* To prevent page migration, do nothing on mmu notifier. */
+	get_page(pfn_to_page(pfn));
+
+	if (likely(is_td_finalized(kvm_tdx))) {
+		err = tdh_mem_page_aug(kvm_tdx->tdr.pa, gpa, hpa, &out);
+		if (KVM_BUG_ON(err, kvm)) {
+			pr_tdx_error(TDH_MEM_PAGE_AUG, err, &out);
+			put_page(pfn_to_page(pfn));
+		}
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
+		/*
+		 * The HKID assigned to this TD was already freed and cache
+		 * was already flushed. We don't have to flush again.
+		 */
+		err = tdx_reclaim_page((unsigned long)__va(hpa), hpa, false, 0);
+
+unlock:
+	spin_unlock(&kvm_tdx->seamcall_lock);
+
+	if (!err)
+		tdx_unpin_pfn(kvm, pfn);
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
+	/* For now large page isn't supported yet. */
+	WARN_ON_ONCE(level != PG_LEVEL_4K);
+	spin_lock(&kvm_tdx->seamcall_lock);
+	err = tdh_mem_range_block(kvm_tdx->tdr.pa, gpa, tdx_level, &out);
+	spin_unlock(&kvm_tdx->seamcall_lock);
+	if (KVM_BUG_ON(err, kvm))
+		pr_tdx_error(TDH_MEM_RANGE_BLOCK, err, &out);
+}
+
+/*
+ * TLB shoot down procedure:
+ * There is a global epoch counter and each vcpu has local epoch counter.
+ * - TDH.MEM.RANGE.BLOCK(TDR. level, range) on one vcpu
+ *   This blocks the subsequenct creation of TLB translation on that range.
+ *   This corresponds to clear the present bit(all RXW) in EPT entry
+ * - TDH.MEM.TRACK(TDR): advances the epoch counter which is global.
+ * - IPI to remote vcpus
+ * - TDExit and re-entry with TDH.VP.ENTER on remote vcpus
+ * - On re-entry, TDX module compares the local epoch counter with the global
+ *   epoch counter.  If the local epoch counter is older than the global epoch
+ *   counter, update the local epoch counter and flushes TLB.
+ */
+static void tdx_track(struct kvm_tdx *kvm_tdx)
+{
+	u64 err;
+
+	WARN_ON(!is_hkid_assigned(kvm_tdx));
+	/* If TD isn't finalized, it's before any vcpu running. */
+	if (unlikely(!is_td_finalized(kvm_tdx)))
+		return;
+
+	/*
+	 * tdx_flush_tlb() waits for this function to issue TDH.MEM.TRACK() by
+	 * the counter.  The counter is used instead of bool because multiple
+	 * TDH_MEM_TRACK() can be issued concurrently by multiple vcpus.
+	 */
+	atomic_inc(&kvm_tdx->tdh_mem_track);
+	/*
+	 * KVM_REQ_TLB_FLUSH waits for the empty IPI handler, ack_flush(), with
+	 * KVM_REQUEST_WAIT.
+	 */
+	kvm_make_all_cpus_request(&kvm_tdx->kvm, KVM_REQ_TLB_FLUSH);
+
+	spin_lock(&kvm_tdx->seamcall_lock);
+	err = tdh_mem_track(kvm_tdx->tdr.pa);
+	spin_unlock(&kvm_tdx->seamcall_lock);
+
+	/* Release remote vcpu waiting for TDH.MEM.TRACK in tdx_flush_tlb(). */
+	atomic_dec(&kvm_tdx->tdh_mem_track);
+
+	if (KVM_BUG_ON(err, &kvm_tdx->kvm))
+		pr_tdx_error(TDH_MEM_TRACK, err, NULL);
+
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
+	 * Note: This function is for private shadow page.  Not for private
+	 * guest page.   private guest page can be zapped during TD is active.
+	 * shared <-> private conversion and slot move/deletion.
+	 *
+	 * TODO: large page support.  If large page is supported, S-EPT page
+	 * can be freed when promoting 4K page to 2M/1G page during TD running.
+	 * In such case, flush cache and TDH.PAGE.RECLAIM.
+	 */
+	if (KVM_BUG_ON(is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
+		return -EINVAL;
+
+	/*
+	 * The HKID assigned to this TD was already freed and cache was
+	 * already flushed. We don't have to flush again.
+	 */
+	spin_lock(&kvm_tdx->seamcall_lock);
+	ret = tdx_reclaim_page((unsigned long)sept_page, __pa(sept_page), false, 0);
+	spin_unlock(&kvm_tdx->seamcall_lock);
+
+	return ret;
+}
+
+static int tdx_sept_tlb_remote_flush(struct kvm *kvm)
+{
+	struct kvm_tdx *kvm_tdx;
+
+	if (!is_td(kvm))
+		return -EOPNOTSUPP;
+
+	kvm_tdx = to_kvm_tdx(kvm);
+	if (is_hkid_assigned(kvm_tdx))
+		tdx_track(kvm_tdx);
+
+	return 0;
+}
+
+static void tdx_handle_changed_private_spte(
+	struct kvm *kvm, const struct kvm_spte_change *change)
+{
+	const gfn_t gfn = change->gfn;
+	const enum pg_level level = change->level;
+
+	WARN_ON(!is_td(kvm));
+	lockdep_assert_held(&kvm->mmu_lock);
+
+	if (change->new.is_present) {
+		/* TDP MMU doesn't change present -> present */
+		WARN_ON(change->old.is_present);
+
+		/*
+		 * Use different call to either set up middle level
+		 * private page table, or leaf.
+		 */
+		if (change->new.is_leaf)
+			tdx_sept_set_private_spte(
+				kvm, gfn, level, change->new.pfn);
+		else {
+			WARN_ON(!change->sept_page);
+			if (tdx_sept_link_private_sp(
+				    kvm, gfn, level, change->sept_page))
+				/* failed to update Secure-EPT.  */
+				WARN_ON(1);
+		}
+	} else if (change->old.is_leaf) {
+		/* non-present -> non-present doesn't make sense. */
+		WARN_ON(!change->old.is_present);
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
+		tdx_sept_drop_private_spte(kvm, gfn, level, change->old.pfn);
+	}
+}
+
 int tdx_dev_ioctl(void __user *argp)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
@@ -786,6 +1081,25 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	return ret;
 }
 
+void tdx_flush_tlb(struct kvm_vcpu *vcpu)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct kvm_mmu *mmu = vcpu->arch.mmu;
+	u64 root_hpa = mmu->root.hpa;
+
+	/* Flush the shared EPTP, if it's valid. */
+	if (VALID_PAGE(root_hpa))
+		ept_sync_context(construct_eptp(vcpu, root_hpa,
+						mmu->root_role.level));
+
+	/*
+	 * See tdx_track().  Wait for tlb shootdown initiater to finish
+	 * TDH_MEM_TRACK() so that TLB is flushed on the next TDENTER.
+	 */
+	while (atomic_read(&kvm_tdx->tdh_mem_track))
+		cpu_relax();
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
@@ -927,6 +1241,10 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 	pr_info("kvm: TDX is supported. hkid start pos %d mask 0x%llx\n",
 		hkid_start_pos, hkid_mask);
 
+	x86_ops->tlb_remote_flush = tdx_sept_tlb_remote_flush;
+	x86_ops->free_private_sp = tdx_sept_free_private_sp;
+	x86_ops->handle_changed_private_spte = tdx_handle_changed_private_spte;
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 337c3adb4fcf..d8dcbedd690b 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -26,9 +26,24 @@ struct kvm_tdx {
 	int hkid;
 
 	bool finalized;
+	atomic_t tdh_mem_track;
 
 	u64 tsc_offset;
 	unsigned long tsc_khz;
+
+	/*
+	 * Some SEAMCALLs try to lock TD resources (e.g. Secure-EPT) they use or
+	 * update.  If TDX module fails to obtain the lock, it returns
+	 * TDX_OPERAND_BUSY error without spinning.  It's VMM/OS responsibility
+	 * to retry or guarantee no contention because TDX module has the
+	 * restriction on cpu cycles it can spend and VMM/OS knows better
+	 * vcpu scheduling.
+	 *
+	 * TDP MMU uses read lock of kvm.arch.mmu_lock so TDP MMU code can be
+	 * run concurrently with multiple vCPUs.   Lock to prevent seamcalls from
+	 * running concurrently when TDP MMU is enabled.
+	 */
+	spinlock_t seamcall_lock;
 };
 
 struct vcpu_tdx {
@@ -169,6 +184,12 @@ static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 fiel
 	return out.r8;
 }
 
+static __always_inline int pg_level_to_tdx_sept_level(enum pg_level level)
+{
+	WARN_ON(level == PG_LEVEL_NONE);
+	return level - 1;
+}
+
 #else
 static inline int tdx_module_setup(void) { return -ENODEV; };
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index e70f84d29d21..2c55aea8963f 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -145,6 +145,7 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
+void tdx_flush_tlb(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
@@ -164,6 +165,7 @@ static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
+static inline void tdx_flush_tlb(struct kvm_vcpu *vcpu) {}
 static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
 #endif
 
-- 
2.25.1

