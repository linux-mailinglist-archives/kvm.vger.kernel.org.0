Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCC0667B8E
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240853AbjALQne (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:43:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240262AbjALQij (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:38:39 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D917E1C930;
        Thu, 12 Jan 2023 08:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541245; x=1705077245;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5fMNrNf8Cw68uJMx1qkY7B2PWvsJTjljFJ1y7hVMhXM=;
  b=Th+RikfmLC7ltpKe0oQ5rrKEatNA4miqU9zEyZxBNDTczUYLSYOdIKOT
   or5ea5otQnyrjC2UtjLMtfZ0F9O89NFM4ymTwTg/aE1vLOPyOqZClWv6t
   UakgOBA2nnj44+ih7dT7q3YO/Vvbxjrw5us5LeJSCOyR2HcHiVi9xuprj
   2NyOcIr7KzSfMaspo7pXtDEP057HfZH9VyYmtfhYvOFn7tSL5tZ04SXfL
   Z1OkX04J3C0KkO1m2fSWe63HDztgDtZvVg40BrlccLOvEfh23sDHEcbHR
   oJxMgocYHjvpR9tIxh5TAW9/+zFQP5KfxvqnK9jQg9rYVCmnBmRSebJWX
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811932"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811932"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:30 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151833"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151833"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:29 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 057/113] KVM: TDX: TDP MMU TDX support
Date:   Thu, 12 Jan 2023 08:32:05 -0800
Message-Id: <2749eb2e634df67937aade6dc46b1c86defcfee5.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/main.c    |  61 +++++++-
 arch/x86/kvm/vmx/tdx.c     | 302 ++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h     |   7 +
 arch/x86/kvm/vmx/x86_ops.h |   4 +
 5 files changed, 369 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 7171df3e262a..9c874bca69f6 100644
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
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index d0d8cfa89344..770d1b29d1c3 100644
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
@@ -177,12 +226,12 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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
index aa07e03843b6..e68816999387 100644
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
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -282,6 +284,22 @@ static int tdx_do_tdh_mng_key_config(void *param)
 
 int tdx_vm_init(struct kvm *kvm)
 {
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
 	/*
 	 * This function initializes only KVM software construct.  It doesn't
 	 * initialize TDX stuff, e.g. TDCS, TDR, TDCX, HKID etc.
@@ -387,6 +405,261 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
 }
 
+static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn)
+{
+	struct page *page = pfn_to_page(pfn);
+
+	put_page(page);
+}
+
+static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
+				     enum pg_level level, kvm_pfn_t pfn)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	hpa_t hpa = pfn_to_hpa(pfn);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	struct tdx_module_output out;
+	u64 err;
+
+	/* TODO: handle large pages. */
+	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
+		return -EINVAL;
+
+	/*
+	 * Because restricted mem doesn't support page migration with
+	 * a_ops->migrate_page (yet), no callback isn't triggered for KVM on
+	 * page migration.  Until restricted mem supports page migration,
+	 * prevent page migration.
+	 * TODO: Once restricted mem introduces callback on page migration,
+	 * implement it and remove get_page/put_page().
+	 */
+	get_page(pfn_to_page(pfn));
+
+	if (likely(is_td_finalized(kvm_tdx))) {
+		err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, hpa, &out);
+		if (err == TDX_ERROR_SEPT_BUSY) {
+			tdx_unpin(kvm, pfn);
+			return -EAGAIN;
+		}
+		if (KVM_BUG_ON(err, kvm)) {
+			pr_tdx_error(TDH_MEM_PAGE_AUG, err, &out);
+			tdx_unpin(kvm, pfn);
+			return -EIO;
+		}
+		return 0;
+	}
+
+	/* TODO: tdh_mem_page_add() comes here for the initial memory. */
+
+	return 0;
+}
+
+static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
+				       enum pg_level level, kvm_pfn_t pfn)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct tdx_module_output out;
+	gpa_t gpa = gfn_to_gpa(gfn);
+	hpa_t hpa = pfn_to_hpa(pfn);
+	hpa_t hpa_with_hkid;
+	u64 err;
+
+	/* TODO: handle large pages. */
+	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
+		return -EINVAL;
+
+	if (!is_hkid_assigned(kvm_tdx)) {
+		/*
+		 * The HKID assigned to this TD was already freed and cache
+		 * was already flushed. We don't have to flush again.
+		 */
+		err = tdx_reclaim_page(hpa, false, 0);
+		if (KVM_BUG_ON(err, kvm))
+			return -EIO;
+		tdx_unpin(kvm, pfn);
+		return 0;
+	}
+
+	do {
+		/*
+		 * When zapping private page, write lock is held. So no race
+		 * condition with other vcpu sept operation.  Race only with
+		 * TDH.VP.ENTER.
+		 */
+		err = tdh_mem_page_remove(kvm_tdx->tdr_pa, gpa, tdx_level, &out);
+	} while (err == TDX_ERROR_SEPT_BUSY);
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error(TDH_MEM_PAGE_REMOVE, err, &out);
+		return -EIO;
+	}
+
+	hpa_with_hkid = set_hkid_to_hpa(hpa, (u16)kvm_tdx->hkid);
+	do {
+		/*
+		 * TDX_OPERAND_BUSY can happen on locking PAMT entry.  Because
+		 * this page was removed above, other thread shouldn't be
+		 * repeatedly operating on this page.  Just retry loop.
+		 */
+		err = tdh_phymem_page_wbinvd(hpa_with_hkid);
+	} while (err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX));
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
+		return -EIO;
+	}
+	tdx_unpin(kvm, pfn);
+	return 0;
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
+	err = tdh_mem_sept_add(kvm_tdx->tdr_pa, gpa, tdx_level, hpa, &out);
+	if (err == TDX_ERROR_SEPT_BUSY)
+		return -EAGAIN;
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error(TDH_MEM_SEPT_ADD, err, &out);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
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
+	err = tdh_mem_range_block(kvm_tdx->tdr_pa, gpa, tdx_level, &out);
+	if (err == TDX_ERROR_SEPT_BUSY)
+		return -EAGAIN;
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error(TDH_MEM_RANGE_BLOCK, err, &out);
+		return -EIO;
+	}
+	return 0;
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
+	do {
+		/*
+		 * kvm_flush_remote_tlbs() doesn't allow to return error and
+		 * retry.
+		 */
+		err = tdh_mem_track(kvm_tdx->tdr_pa);
+	} while ((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY);
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
+
+	/*
+	 * The HKID assigned to this TD was already freed and cache was
+	 * already flushed. We don't have to flush again.
+	 */
+	if (!is_hkid_assigned(kvm_tdx))
+		return tdx_reclaim_page(__pa(private_spt), false, 0);
+
+	/*
+	 * free_private_spt() is (obviously) called when a shadow page is being
+	 * zapped.  KVM doesn't (yet) zap private SPs while the TD is active.
+	 * Note: This function is for private shadow page.  Not for private
+	 * guest page.   private guest page can be zapped during TD is active.
+	 * shared <-> private conversion and slot move/deletion.
+	 */
+	KVM_BUG_ON(is_hkid_assigned(kvm_tdx), kvm);
+	return -EINVAL;
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
+static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
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
+	return tdx_sept_drop_private_spte(kvm, gfn, level, pfn);
+}
+
 int tdx_dev_ioctl(void __user *argp)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
@@ -798,6 +1071,25 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
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
@@ -1016,8 +1308,16 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
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
index 237c8038eb6a..5cc5d1a29c08 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -18,6 +18,7 @@ struct kvm_tdx {
 	int hkid;
 
 	bool finalized;
+	atomic_t tdh_mem_track;
 
 	u64 tsc_offset;
 };
@@ -165,6 +166,12 @@ static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 fiel
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
index d7745ac380ed..8ae689929347 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -158,6 +158,8 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
+void tdx_flush_tlb(struct kvm_vcpu *vcpu);
+int tdx_sept_tlb_remote_flush(struct kvm *kvm);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
@@ -178,6 +180,8 @@ static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
+static inline void tdx_flush_tlb(struct kvm_vcpu *vcpu) {}
+static inline int tdx_sept_tlb_remote_flush(struct kvm *kvm) { return 0; }
 static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
 #endif
 
-- 
2.25.1

