Return-Path: <kvm+bounces-9694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E710866CFD
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:50:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8169D1C2032D
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:50:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13B4567C54;
	Mon, 26 Feb 2024 08:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZSLl1hQt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C976862A09;
	Mon, 26 Feb 2024 08:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936112; cv=none; b=HUzqyskCbVV1FzZRX7/COu6H/9fhfCelFWuxwk+4zaaJSKvFBXP0dmG4T6OpKmVMGhR7zVUbfemTJAtn0Ls8j5s2FaqGol7jkC4cOEuM30hwtjWcZQDyqhuE2jxs1ibJ5mXVRmXoovW1b3BPqevouAFNdYkNj47CpF5Ws1e6xNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936112; c=relaxed/simple;
	bh=cOIa/c1mL8lEIWnCrohNsbjcGldly9dZiHJor/YrCwI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HU9G95YMqpmuo6kVjTk/sfPkifCrYPaBeZFZtnvudJXiI+JUScA4i/RjuxSSptCAzp4liLPxXNTAK0nsu+nRUBaGKABDwHt2mz0k/Z8iiOnmKAOCVz4AF2C7CVdZvCgDBZUYEPcqhxrTOGWAFqwhyNyhPCV1O/+g7Pg+pgCtxsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZSLl1hQt; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936109; x=1740472109;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cOIa/c1mL8lEIWnCrohNsbjcGldly9dZiHJor/YrCwI=;
  b=ZSLl1hQtcDA8vxIMqPQZQPp0ithGY9yxwHvW22sRc9eR/sDDRrYAW8f9
   JLsNcoTL8Wq+677w9Ey/te+0/Di0v6jFrcZs2Hcjmcok4Q4tavuUPcBHr
   A77GCb5eV1uISO/eQUhcRcC5IXHK/F/e0nu8OniR9EptxzM9XxzU94RdW
   ChgDSm1cf4X1vOIYGH+2qEL0FTyIT4UxuZunvsRU05YeI4jVziHTiZXYU
   dFbPs1bVivaMaNbnd167dIA6cgVPIxqAd4LSQ1XTjQh5w/lvhGQPeURiz
   O1gpalC5K23w16ZaAzc75xilvgCeHdIGOxQ2Zo3ZOwUt6z2N6hFT0obz6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3069465"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3069465"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="11272420"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:28 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v19 070/130] KVM: TDX: TDP MMU TDX support
Date: Mon, 26 Feb 2024 00:26:12 -0800
Message-Id: <56cdb0da8bbf17dc293a2a6b4ff74f6e3e034bbd.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
v19:
- Compile fix when CONFIG_HYPERV != y.
  It's due to the following patch.  Catch it up.
  https://lore.kernel.org/all/20231018192325.1893896-1-seanjc@google.com/
- Add comments on tlb shootdown to explan the sequence.
- Use gmem_max_level callback, delete tdp_max_page_level.

v18:
- rename tdx_sept_page_aug() -> tdx_mem_page_aug()
- checkpatch: space => tab

v15 -> v16:
- Add the handling of TD_ATTR_SEPT_VE_DISABLE case.

v14 -> v15:
- Implemented tdx_flush_tlb_current()
- Removed unnecessary invept in tdx_flush_tlb().  It was carry over
  from the very old code base.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/spte.c    |   3 +-
 arch/x86/kvm/vmx/main.c    |  91 ++++++++-
 arch/x86/kvm/vmx/tdx.c     | 372 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h     |   2 +-
 arch/x86/kvm/vmx/tdx_ops.h |   6 +
 arch/x86/kvm/vmx/x86_ops.h |  13 ++
 6 files changed, 481 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 318135daf685..83926a35ea47 100644
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
index 54df6653193e..8c5bac3defdf 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -29,6 +29,10 @@ static int vt_max_vcpus(struct kvm *kvm)
 	return kvm->max_vcpus;
 }
 
+#if IS_ENABLED(CONFIG_HYPERV)
+static int vt_flush_remote_tlbs(struct kvm *kvm);
+#endif
+
 static __init int vt_hardware_setup(void)
 {
 	int ret;
@@ -49,11 +53,29 @@ static __init int vt_hardware_setup(void)
 		pr_warn_ratelimited("TDX requires mmio caching.  Please enable mmio caching for TDX.\n");
 	}
 
+#if IS_ENABLED(CONFIG_HYPERV)
+	/*
+	 * TDX KVM overrides flush_remote_tlbs method and assumes
+	 * flush_remote_tlbs_range = NULL that falls back to
+	 * flush_remote_tlbs.  Disable TDX if there are conflicts.
+	 */
+	if (vt_x86_ops.flush_remote_tlbs ||
+	    vt_x86_ops.flush_remote_tlbs_range) {
+		enable_tdx = false;
+		pr_warn_ratelimited("TDX requires baremetal. Not Supported on VMM guest.\n");
+	}
+#endif
+
 	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
 	if (enable_tdx)
 		vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size,
 					   sizeof(struct kvm_tdx));
 
+#if IS_ENABLED(CONFIG_HYPERV)
+	if (enable_tdx)
+		vt_x86_ops.flush_remote_tlbs = vt_flush_remote_tlbs;
+#endif
+
 	return 0;
 }
 
@@ -136,6 +158,56 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx_vcpu_reset(vcpu, init_event);
 }
 
+static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_flush_tlb(vcpu);
+		return;
+	}
+
+	vmx_flush_tlb_all(vcpu);
+}
+
+static void vt_flush_tlb_current(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_flush_tlb_current(vcpu);
+		return;
+	}
+
+	vmx_flush_tlb_current(vcpu);
+}
+
+#if IS_ENABLED(CONFIG_HYPERV)
+static int vt_flush_remote_tlbs(struct kvm *kvm)
+{
+	if (is_td(kvm))
+		return tdx_sept_flush_remote_tlbs(kvm);
+
+	/*
+	 * fallback to KVM_REQ_TLB_FLUSH.
+	 * See kvm_arch_flush_remote_tlb() and kvm_flush_remote_tlbs().
+	 */
+	return -EOPNOTSUPP;
+}
+#endif
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
@@ -163,6 +235,15 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return tdx_vcpu_ioctl(vcpu, argp);
 }
 
+static int vt_gmem_max_level(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn,
+			     bool is_private, u8 *max_level)
+{
+	if (is_td(kvm))
+		return tdx_gmem_max_level(kvm, pfn, gfn, is_private, max_level);
+
+	return 0;
+}
+
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLE)|			\
 	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
@@ -228,10 +309,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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
@@ -324,6 +405,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.mem_enc_ioctl = vt_mem_enc_ioctl,
 	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
+
+	.gmem_max_level = vt_gmem_max_level,
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 143a3c2a16bc..39ef80857b6a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -8,6 +8,7 @@
 #include "mmu.h"
 #include "tdx_arch.h"
 #include "tdx.h"
+#include "vmx.h"
 #include "x86.h"
 
 #undef pr_fmt
@@ -364,6 +365,19 @@ static int tdx_do_tdh_mng_key_config(void *param)
 
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
 	/*
 	 * This function initializes only KVM software construct.  It doesn't
 	 * initialize TDX stuff, e.g. TDCS, TDR, TDCX, HKID etc.
@@ -459,6 +473,307 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
 }
 
+static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn)
+{
+	struct page *page = pfn_to_page(pfn);
+
+	put_page(page);
+}
+
+static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
+			    enum pg_level level, kvm_pfn_t pfn)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	union tdx_sept_level_state level_state;
+	hpa_t hpa = pfn_to_hpa(pfn);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	struct tdx_module_args out;
+	union tdx_sept_entry entry;
+	u64 err;
+
+	err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, hpa, &out);
+	if (unlikely(err == TDX_ERROR_SEPT_BUSY)) {
+		tdx_unpin(kvm, pfn);
+		return -EAGAIN;
+	}
+	if (unlikely(err == (TDX_EPT_ENTRY_STATE_INCORRECT | TDX_OPERAND_ID_RCX))) {
+		entry.raw = out.rcx;
+		level_state.raw = out.rdx;
+		if (level_state.level == tdx_level &&
+		    level_state.state == TDX_SEPT_PENDING &&
+		    entry.leaf && entry.pfn == pfn && entry.sve) {
+			tdx_unpin(kvm, pfn);
+			WARN_ON_ONCE(!(to_kvm_tdx(kvm)->attributes &
+				       TDX_TD_ATTR_SEPT_VE_DISABLE));
+			return -EAGAIN;
+		}
+	}
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error(TDH_MEM_PAGE_AUG, err, &out);
+		tdx_unpin(kvm, pfn);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
+				     enum pg_level level, kvm_pfn_t pfn)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
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
+	if (likely(is_td_finalized(kvm_tdx)))
+		return tdx_mem_page_aug(kvm, gfn, level, pfn);
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
+	struct tdx_module_args out;
+	gpa_t gpa = gfn_to_gpa(gfn);
+	hpa_t hpa = pfn_to_hpa(pfn);
+	hpa_t hpa_with_hkid;
+	u64 err;
+
+	/* TODO: handle large pages. */
+	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
+		return -EINVAL;
+
+	if (unlikely(!is_hkid_assigned(kvm_tdx))) {
+		/*
+		 * The HKID assigned to this TD was already freed and cache
+		 * was already flushed. We don't have to flush again.
+		 */
+		err = tdx_reclaim_page(hpa);
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
+	} while (unlikely(err == TDX_ERROR_SEPT_BUSY));
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
+	} while (unlikely(err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX)));
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
+		return -EIO;
+	}
+	tdx_clear_page(hpa);
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
+	struct tdx_module_args out;
+	u64 err;
+
+	err = tdh_mem_sept_add(kvm_tdx->tdr_pa, gpa, tdx_level, hpa, &out);
+	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
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
+	gpa_t gpa = gfn_to_gpa(gfn) & KVM_HPAGE_MASK(level);
+	struct tdx_module_args out;
+	u64 err;
+
+	/* This can be called when destructing guest TD after freeing HKID. */
+	if (unlikely(!is_hkid_assigned(kvm_tdx)))
+		return 0;
+
+	/* For now large page isn't supported yet. */
+	WARN_ON_ONCE(level != PG_LEVEL_4K);
+	err = tdh_mem_range_block(kvm_tdx->tdr_pa, gpa, tdx_level, &out);
+	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
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
+static void tdx_track(struct kvm *kvm)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	u64 err;
+
+	KVM_BUG_ON(!is_hkid_assigned(kvm_tdx), kvm);
+	/* If TD isn't finalized, it's before any vcpu running. */
+	if (unlikely(!is_td_finalized(kvm_tdx)))
+		return;
+
+	/*
+	 * tdx_flush_tlb() waits for this function to issue TDH.MEM.TRACK() by
+	 * the counter.  The counter is used instead of bool because multiple
+	 * TDH_MEM_TRACK() can be issued concurrently by multiple vcpus.
+	 *
+	 * optimization: The TLB shoot down procedure described in The TDX
+	 * specification is, TDH.MEM.TRACK(), send IPI to remote vcpus, confirm
+	 * all remote vcpus exit to VMM, and execute vcpu, both local and
+	 * remote.  Twist the sequence to reduce IPI overhead as follows.
+	 *
+	 * local			remote
+	 * -----			------
+	 * increment tdh_mem_track
+	 *
+	 * request KVM_REQ_TLB_FLUSH
+	 * send IPI
+	 *
+	 *				TDEXIT to KVM due to IPI
+	 *
+	 *				IPI handler calls tdx_flush_tlb()
+	 *                              to process KVM_REQ_TLB_FLUSH.
+	 *				spin wait for tdh_mem_track == 0
+	 *
+	 * TDH.MEM.TRACK()
+	 *
+	 * decrement tdh_mem_track
+	 *
+	 *				complete KVM_REQ_TLB_FLUSH
+	 *
+	 * TDH.VP.ENTER to flush tlbs	TDH.VP.ENTER to flush tlbs
+	 */
+	atomic_inc(&kvm_tdx->tdh_mem_track);
+	/*
+	 * KVM_REQ_TLB_FLUSH waits for the empty IPI handler, ack_flush(), with
+	 * KVM_REQUEST_WAIT.
+	 */
+	kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH);
+
+	do {
+		err = tdh_mem_track(kvm_tdx->tdr_pa);
+	} while (unlikely((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY));
+
+	/* Release remote vcpu waiting for TDH.MEM.TRACK in tdx_flush_tlb(). */
+	atomic_dec(&kvm_tdx->tdh_mem_track);
+
+	if (KVM_BUG_ON(err, kvm))
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
+		return tdx_reclaim_page(__pa(private_spt));
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
+int tdx_sept_flush_remote_tlbs(struct kvm *kvm)
+{
+	if (unlikely(!is_td(kvm)))
+		return -EOPNOTSUPP;
+
+	if (is_hkid_assigned(to_kvm_tdx(kvm)))
+		tdx_track(kvm);
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
+	 * TODO: Call TDH.MEM.TRACK() only when we have called
+	 * TDH.MEM.RANGE.BLOCK(), but not call TDH.MEM.TRACK() yet.
+	 */
+	if (is_hkid_assigned(to_kvm_tdx(kvm)))
+		tdx_track(kvm);
+
+	return tdx_sept_drop_private_spte(kvm, gfn, level, pfn);
+}
+
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
@@ -924,6 +1239,39 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	return ret;
 }
 
+void tdx_flush_tlb(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Don't need to flush shared EPTP:
+	 * "TD VCPU TLB Address Spaced Identifier" in the TDX module spec:
+	 * The TLB entries for TD are tagged with:
+	 *  SEAM (1 bit)
+	 *  VPID
+	 *  Secure EPT root (51:12 bits) with HKID = 0
+	 *  PCID
+	 * for *both* Secure-EPT and Shared-EPT.
+	 * TLB flush with Secure-EPT root by tdx_track() results in flushing
+	 * the conversion of both Secure-EPT and Shared-EPT.
+	 */
+
+	/*
+	 * See tdx_track().  Wait for tlb shootdown initiater to finish
+	 * TDH_MEM_TRACK() so that shared-EPT/secure-EPT TLB is flushed
+	 * on the next TDENTER.
+	 */
+	while (atomic_read(&to_kvm_tdx(vcpu->kvm)->tdh_mem_track))
+		cpu_relax();
+}
+
+void tdx_flush_tlb_current(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * flush_tlb_current() is used only the first time for the vcpu to run.
+	 * As it isn't performance critical, keep this function simple.
+	 */
+	tdx_track(vcpu->kvm);
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
@@ -1087,6 +1435,17 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return 0;
 }
 
+int tdx_gmem_max_level(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn,
+		       bool is_private, u8 *max_level)
+{
+	if (!is_private)
+		return 0;
+
+	/* TODO: Enable 2mb and 1gb large page support. */
+	*max_level = min(*max_level, PG_LEVEL_4K);
+	return 0;
+}
+
 #define TDX_MD_MAP(_fid, _ptr)			\
 	{ .fid = MD_FIELD_ID_##_fid,		\
 	  .ptr = (_ptr), }
@@ -1297,8 +1656,21 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 	on_each_cpu(vmx_off, &enable.enabled, true);
 	cpus_read_unlock();
 	free_cpumask_var(enable.enabled);
+	if (r)
+		goto out;
+
+	x86_ops->link_private_spt = tdx_sept_link_private_spt;
+	x86_ops->free_private_spt = tdx_sept_free_private_spt;
+	x86_ops->set_private_spte = tdx_sept_set_private_spte;
+	x86_ops->remove_private_spte = tdx_sept_remove_private_spte;
+	x86_ops->zap_private_spte = tdx_sept_zap_private_spte;
+
+	return 0;
 
 out:
+	/* kfree() accepts NULL. */
+	kfree(tdx_mng_key_config_lock);
+	tdx_mng_key_config_lock = NULL;
 	return r;
 }
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 8a0d1bfe34a0..75596b9dcf3f 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -18,6 +18,7 @@ struct kvm_tdx {
 	int hkid;
 
 	bool finalized;
+	atomic_t tdh_mem_track;
 
 	u64 tsc_offset;
 };
@@ -162,7 +163,6 @@ static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 fiel
 	}
 	return out.r8;
 }
-
 #else
 struct kvm_tdx {
 	struct kvm kvm;
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index e5c069b96126..d27f281152cb 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -44,6 +44,12 @@ static inline u64 tdx_seamcall(u64 op, struct tdx_module_args *in,
 void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_args *out);
 #endif
 
+static inline int pg_level_to_tdx_sept_level(enum pg_level level)
+{
+	WARN_ON_ONCE(level == PG_LEVEL_NONE);
+	return level - 1;
+}
+
 /*
  * TDX module acquires its internal lock for resources.  It doesn't spin to get
  * locks because of its restrictions of allowed execution time.  Instead, it
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 24161fa404aa..d5f75efd87e6 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -153,7 +153,12 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
+void tdx_flush_tlb(struct kvm_vcpu *vcpu);
+void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
+int tdx_sept_flush_remote_tlbs(struct kvm *kvm);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
+int tdx_gmem_max_level(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn,
+		       bool is_private, u8 *max_level);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
 static inline void tdx_hardware_unsetup(void) {}
@@ -176,7 +181,15 @@ static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
+static inline void tdx_flush_tlb(struct kvm_vcpu *vcpu) {}
+static inline void tdx_flush_tlb_current(struct kvm_vcpu *vcpu) {}
+static inline int tdx_sept_flush_remote_tlbs(struct kvm *kvm) { return 0; }
 static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
+static inline int tdx_gmem_max_level(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn,
+				     bool is_private, u8 *max_level)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.25.1


