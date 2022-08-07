Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A61958BD42
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236805AbiHGWEw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235037AbiHGWDG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:03:06 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCE89FE3;
        Sun,  7 Aug 2022 15:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909762; x=1691445762;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rSGdnJhGyRSuluTYeO3rXqWtQDTMEx+yDKWnunfLsT4=;
  b=DB0uDMvWRrezHL3JjAY+ZrCfNZDlmiN2LvPMfNBqBOoRPOLrH9s+OvR2
   B2b0lcRB2QWfB7AUfu61OZPeqcVI7Wk3W8l/yk7qs/BzkaYj+bIStq03l
   bWUsTHyCbkSaqCgbvztHDrUoIsnXf4EyNgYFTcoAtLKS6df+gZaxJD2nv
   qS07Ks5yHVSVNTuoywxcl1uE3DsgeWmM9tTVqgB65GQ5rGVgbcnI+pz1j
   vthHDRAdTmEIX2FTnvqe+/Y7HRii1yrr/jfnVPZyIShWfrMALaN9FEaHv
   rMVES5y9GJAMfROAl0MpXDgZun5LQx0uLyywdSoqKNf25wKAlvtCR9j0L
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="291695694"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="291695694"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:37 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682616"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:37 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 053/103] KVM: TDX: TDP MMU TDX support
Date:   Sun,  7 Aug 2022 15:01:38 -0700
Message-Id: <2b51971467ab7c8e60ea1e17ba09f607db444935.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
EPT page. TLB flush handles both shared EPT and private EPT.  It flushes
shared EPT same as VMX.  It also waits for the TDX TLB shootdown.  For the
hook to free Secure EPT page, unlinks the Secure EPT page from the Secure
EPT so that the page can be freed to OS.

Propagate the entry change to Secure EPT.  The possible entry changes are
present -> non-present(zapping) and non-present -> present(population).  On
population just link the Secure EPT page or the private guest page to the
Secure EPT by TDX SEAMCALL. Because TDP MMU allows concurrent
zapping/population, zapping requires synchronous TLB shoot down with the
frozen EPT entry.  It zaps the secure entry, increments TLB counter, sends
IPI to remote vcpus to trigger TLB flush, and then unlinks the private
guest page from the Secure EPT. For simplicity, batched zapping with
exclude lock is handled as concurrent zapping.  Although it's inefficient,
it can be optimized in the future.

For MMIO SPTE, the spte value changes as follows.
initial value (suppress VE bit is set)
-> Guest issues MMIO and triggers EPT violation
-> KVM updates SPTE value to MMIO value (suppress VE bit is cleared)
-> Guest MMIO resumes.  It triggers VE exception in guest TD
-> Guest VE handler issues TDG.VP.VMCALL<MMIO>
-> KVM handles MMIO
-> Guest VE handler resumes its execution after MMIO instruction

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/spte.c    |   3 +-
 arch/x86/kvm/vmx/main.c    |  61 ++++++-
 arch/x86/kvm/vmx/tdx.c     | 320 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h     |  21 +++
 arch/x86/kvm/vmx/vmx.c     |   2 +-
 arch/x86/kvm/vmx/x86_ops.h |   5 +-
 6 files changed, 403 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 3ad16124eeeb..877a5c032efd 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -58,7 +58,8 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
 	u64 spte = generation_mmio_spte_mask(gen);
 	u64 gpa = gfn << PAGE_SHIFT;
 
-	WARN_ON_ONCE(!vcpu->kvm->arch.shadow_mmio_value);
+	WARN_ON_ONCE(!vcpu->kvm->arch.shadow_mmio_value &&
+		     !kvm_gfn_shared_mask(vcpu->kvm));
 
 	access &= shadow_mmio_access_mask;
 	spte |= vcpu->kvm->arch.shadow_mmio_value | access;
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index e52e12b8d49a..cef84c52caa9 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -110,6 +110,55 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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
+static int vt_tlb_remote_flush(struct kvm *kvm)
+{
+	if (is_td(kvm))
+		return tdx_sept_tlb_remote_flush(kvm);
+
+	return vmx_tlb_remote_flush(kvm);
+}
+
+static int vt_tlb_remote_flush_with_range(struct kvm *kvm,
+					  struct kvm_tlb_range *range)
+{
+	if (is_td(kvm))
+		return -EOPNOTSUPP; /* fall back to tlb_remote_flush */
+
+	return vmx_tlb_remote_flush_with_range(kvm, range);
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
@@ -185,12 +234,12 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.set_rflags = vmx_set_rflags,
 	.get_if_flag = vmx_get_if_flag,
 
-	.flush_tlb_all = vmx_flush_tlb_all,
-	.flush_tlb_current = vmx_flush_tlb_current,
-	.tlb_remote_flush = vmx_tlb_remote_flush,
-	.tlb_remote_flush_with_range = vmx_tlb_remote_flush_with_range,
-	.flush_tlb_gva = vmx_flush_tlb_gva,
-	.flush_tlb_guest = vmx_flush_tlb_guest,
+	.flush_tlb_all = vt_flush_tlb_all,
+	.flush_tlb_current = vt_flush_tlb_current,
+	.tlb_remote_flush = vt_tlb_remote_flush,
+	.tlb_remote_flush_with_range = vt_tlb_remote_flush_with_range,
+	.flush_tlb_gva = vt_flush_tlb_gva,
+	.flush_tlb_guest = vt_flush_tlb_guest,
 
 	.vcpu_pre_run = vmx_vcpu_pre_run,
 	.vcpu_run = vmx_vcpu_run,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 7a631ae78e59..edb5af011794 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -5,8 +5,11 @@
 
 #include "capabilities.h"
 #include "x86_ops.h"
+#include "mmu.h"
 #include "tdx.h"
+#include "vmx.h"
 #include "x86.h"
+#include "mmu.h"
 
 #undef pr_fmt
 #define pr_fmt(fmt) "tdx: " fmt
@@ -276,6 +279,22 @@ int tdx_vm_init(struct kvm *kvm)
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
+	kvm_mmu_set_mmio_spte_mask(kvm, 0, VMX_EPT_RWX_MASK);
+
+	/* TODO: Enable 2mb and 1gb large page support. */
+	kvm->arch.tdp_max_page_level = PG_LEVEL_4K;
+
 	/* vCPUs can't be created until after KVM_TDX_INIT_VM. */
 	kvm->max_vcpus = 0;
 
@@ -360,6 +379,8 @@ int tdx_vm_init(struct kvm *kvm)
 		tdx_mark_td_page_added(&kvm_tdx->tdcs[i]);
 	}
 
+	spin_lock_init(&kvm_tdx->seamcall_lock);
+
 	/*
 	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
 	 * ioctl() to define the configure CPUID values for the TD.
@@ -523,6 +544,283 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
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
+	if (WARN_ON_ONCE(is_error_noslot_pfn(pfn) ||
+			 !kvm_pfn_to_refcounted_page(pfn)))
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
+int tdx_sept_tlb_remote_flush(struct kvm *kvm)
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
+	bool was_leaf = change->old.is_present && change->old.is_last;
+	bool is_leaf = change->new.is_present && change->new.is_last;
+	const gfn_t gfn = change->gfn;
+	const enum pg_level level = change->level;
+
+	WARN_ON(!is_td(kvm));
+	lockdep_assert_held(&kvm->mmu_lock);
+
+	if (change->new.is_present) {
+		/* TDP MMU doesn't change present -> present */
+		WARN_ON(change->old.is_present);
+		/*
+		 * Use different call to either set up middle level
+		 * private page table, or leaf.
+		 */
+		if (is_leaf)
+			tdx_sept_set_private_spte(
+				kvm, gfn, level, change->new.pfn);
+		else {
+			WARN_ON(!change->sept_page);
+			if (tdx_sept_link_private_sp(
+				    kvm, gfn, level, change->sept_page))
+				/* failed to update Secure-EPT.  */
+				WARN_ON(1);
+		}
+	} else if (was_leaf) {
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
@@ -770,6 +1068,25 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
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
@@ -901,6 +1218,9 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 	pr_info("kvm: TDX is supported. x86 phys bits %d\n",
 		boot_cpu_data.x86_phys_bits);
 
+	x86_ops->free_private_sp = tdx_sept_free_private_sp;
+	x86_ops->handle_changed_private_spte = tdx_handle_changed_private_spte;
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 91961d4f4b65..d1b1cd60ff6f 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -26,8 +26,23 @@ struct kvm_tdx {
 	int hkid;
 
 	bool finalized;
+	atomic_t tdh_mem_track;
 
 	u64 tsc_offset;
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
@@ -168,6 +183,12 @@ static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 fiel
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
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index afe7d85ac427..9dbad6c77511 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -145,7 +145,7 @@ module_param_named(preemption_timer, enable_preemption_timer, bool, S_IRUGO);
 extern bool __read_mostly allow_smaller_maxphyaddr;
 module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
 
-u64 __ro_after_init vmx_shadow_mmio_mask;
+static u64 __ro_after_init vmx_shadow_mmio_mask;
 
 #define KVM_VM_CR0_ALWAYS_OFF (X86_CR0_NW | X86_CR0_CD)
 #define KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST X86_CR0_NE
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index b8d92fc061ff..bae7b2edd045 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -13,7 +13,6 @@ void hv_vp_assist_page_exit(void);
 void __init vmx_init_early(void);
 int __init vmx_init(void);
 void vmx_exit(void);
-extern u64 __ro_after_init vmx_shadow_mmio_mask;
 
 __init int vmx_cpu_has_kvm_support(void);
 __init int vmx_disabled_by_bios(void);
@@ -149,6 +148,8 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
+void tdx_flush_tlb(struct kvm_vcpu *vcpu);
+int tdx_sept_tlb_remote_flush(struct kvm *kvm);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
@@ -168,6 +169,8 @@ static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
+static inline void tdx_flush_tlb(struct kvm_vcpu *vcpu) {}
+static inline int tdx_sept_tlb_remote_flush(struct kvm *kvm) { return 0; }
 static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
 #endif
 
-- 
2.25.1

