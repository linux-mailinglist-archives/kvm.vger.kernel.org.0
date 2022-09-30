Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B215F08D1
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbiI3KXD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbiI3KUp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:20:45 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C7D1FBC84;
        Fri, 30 Sep 2022 03:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533155; x=1696069155;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hyBFh+FarfkmXzmrpHAeW1rE5zBWAYb52vtutxnlXTs=;
  b=Al7Kt5LPVQba+JR7wrfKi4GzTlg+TBRaqWndgbWbr6Ui7mD265pMGQb/
   /pdS+8T5JmMzOP8WbnVRHUjF2cEHvzS9xpBGWPiT5He6PoZDCQZbdddMj
   igg13jgrq9eAtERRbk8We4CadMNhSWv2TMCCZBRcfbokWercZeW8yo+sK
   NEeoUIDsjRftvy2CREyYVyxaEP5TCePs1DS4Ace2e+zFNM2T6rUgf+H6G
   Jb4Ks9NgWpNnFafbv2yvPCPhnGefFqgcxg+4BPB7y9OWebaJieHozzEWo
   KUfUQfwqstBeNo/R7Wvj2OrVbPL+CcOhnJ9cRD7VKX/fy5m4IMH2LXMqL
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281870117"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="281870117"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:00 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807682"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807682"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:00 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 055/105] KVM: TDX: TDP MMU TDX support
Date:   Fri, 30 Sep 2022 03:17:49 -0700
Message-Id: <41aa5461e9df28a45826389bb319d30c2b26560d.1664530908.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/mmu/tdp_mmu.c |   4 +
 arch/x86/kvm/vmx/main.c    |  61 +++++++-
 arch/x86/kvm/vmx/tdx.c     | 289 ++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h     |  21 +++
 arch/x86/kvm/vmx/x86_ops.h |   4 +
 6 files changed, 374 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 8f468ee2b985..3167c12d9c74 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -74,7 +74,8 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
 	u64 spte = generation_mmio_spte_mask(gen);
 	u64 gpa = gfn << PAGE_SHIFT;
 
-	WARN_ON_ONCE(!vcpu->kvm->arch.shadow_mmio_value);
+	WARN_ON_ONCE(!vcpu->kvm->arch.shadow_mmio_value &&
+		     !kvm_gfn_shared_mask(vcpu->kvm));
 
 	access &= shadow_mmio_access_mask;
 	spte |= vcpu->kvm->arch.shadow_mmio_value | access;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index cb25168dbbd5..784dcfaed505 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -566,6 +566,10 @@ static void handle_changed_private_spte(struct kvm *kvm, gfn_t gfn,
 	} else if (was_leaf) {
 		/* non-present -> non-present doesn't make sense. */
 		KVM_BUG_ON(!was_present, kvm);
+		/*
+		 * Zap private leaf SPTE.  Zapping private table is done
+		 * below in handle_removed_tdp_mmu_page().
+		 */
 		static_call(kvm_x86_zap_private_spte)(kvm, gfn, level);
 		static_call(kvm_x86_remove_private_spte)(kvm, gfn, level, old_pfn);
 	}
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 025315e0934b..10aacde3a40a 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -100,6 +100,55 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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
@@ -176,12 +225,12 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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
index 0312172c98cb..e08ead40c964 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -6,7 +6,9 @@
 #include "capabilities.h"
 #include "x86_ops.h"
 #include "tdx.h"
+#include "vmx.h"
 #include "x86.h"
+#include "mmu.h"
 
 #undef pr_fmt
 #define pr_fmt(fmt) "tdx: " fmt
@@ -283,10 +285,28 @@ int tdx_vm_init(struct kvm *kvm)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 
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
+	kvm_mmu_set_mmio_spte_value(kvm, 0);
+
+	/* TODO: Enable 2mb and 1gb large page support. */
+	kvm->arch.tdp_max_page_level = PG_LEVEL_4K;
+
 	/* vCPUs can't be created until after KVM_TDX_INIT_VM. */
 	kvm->max_vcpus = 0;
 	kvm_tdx->hkid = -1;
 
+	spin_lock_init(&kvm_tdx->seamcall_lock);
+
 	/*
 	 * This function initializes only KVM software construct.  It doesn't
 	 * initialize TDX stuff, e.g. TDCS, TDR, TDCX, HKID etc.
@@ -389,6 +409,246 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
 }
 
+static void tdx_unpin_pfn(struct kvm *kvm, kvm_pfn_t pfn)
+{
+	struct page *page = pfn_to_page(pfn);
+
+	put_page(page);
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
+static void tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
+				       enum pg_level level, kvm_pfn_t pfn)
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
+static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
+				     enum pg_level level, void *private_spt)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	hpa_t hpa = __pa(private_spt);
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
+	KVM_BUG_ON(!is_hkid_assigned(kvm_tdx), &kvm_tdx->kvm);
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
+static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
+				     enum pg_level level, void *private_spt)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	int ret;
+
+	/*
+	 * free_private_spt() is (obviously) called when a shadow page is being
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
+	ret = tdx_reclaim_page((unsigned long)private_spt, __pa(private_spt), false, 0);
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
+static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
+					 enum pg_level level, kvm_pfn_t pfn)
+{
+	/*
+	 * TDX requires TLB tracking before dropping private page.  Do
+	 * it here, although it is also done later.
+	 * If hkid isn't assigned, the guest is destroying and no vcpu
+	 * runs further.  TLB shootdown isn't needed.
+	 *
+	 * TODO: implement with_range version for optimization.
+	 * kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
+	 *   => tdx_sept_tlb_remote_flush_with_range(kvm, gfn,
+	 *                                 KVM_PAGES_PER_HPAGE(level));
+	 */
+	if (is_hkid_assigned(to_kvm_tdx(kvm)))
+		kvm_flush_remote_tlbs(kvm);
+
+	tdx_sept_drop_private_spte(kvm, gfn, level, pfn);
+}
+
 int tdx_dev_ioctl(void __user *argp)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
@@ -801,6 +1061,25 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
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
@@ -1010,8 +1289,16 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 	if (!r)
 		r = tdx_module_setup();
 	vmxoff_all();
+	if (r)
+		return r;
 
-	return r;
+	x86_ops->link_private_spt = tdx_sept_link_private_spt;
+	x86_ops->free_private_spt = tdx_sept_free_private_spt;
+	x86_ops->set_private_spte = tdx_sept_set_private_spte;
+	x86_ops->remove_private_spte = tdx_sept_remove_private_spte;
+	x86_ops->zap_private_spte = tdx_sept_zap_private_spte;
+
+	return 0;
 }
 
 void tdx_hardware_unsetup(void)
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 4ce236a0cab2..5f25f866291e 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -24,8 +24,23 @@ struct kvm_tdx {
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
@@ -181,6 +196,12 @@ static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 fiel
 	return out.r8;
 }
 
+static __always_inline int pg_level_to_tdx_sept_level(enum pg_level level)
+{
+	WARN_ON_ONCE(level == PG_LEVEL_NONE);
+	return level - 1;
+}
+
 #else
 struct kvm_tdx {
 	struct kvm kvm;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index f3c6ab7e517f..7d6d9a6c2562 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -151,6 +151,8 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
+void tdx_flush_tlb(struct kvm_vcpu *vcpu);
+int tdx_sept_tlb_remote_flush(struct kvm *kvm);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
@@ -171,6 +173,8 @@ static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
+static inline void tdx_flush_tlb(struct kvm_vcpu *vcpu) {}
+static inline int tdx_sept_tlb_remote_flush(struct kvm *kvm) { return 0; }
 static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
 #endif
 
-- 
2.25.1

