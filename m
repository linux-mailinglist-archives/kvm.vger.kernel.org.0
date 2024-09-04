Return-Path: <kvm+bounces-25822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EF82F96AF12
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 05:19:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 714C11F238B0
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 03:19:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ADC813BACE;
	Wed,  4 Sep 2024 03:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WzCc4lsu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B8D57CA7;
	Wed,  4 Sep 2024 03:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419683; cv=none; b=vAfCqx4ZJNASldh2pEkAy5athryevZPESMe2kv/fH94R8uRu38IN2Y9ZRzIlnRQnPXDi3C3WvUJQ4VHLrt/SVXLg4+79HBuQW99Ngi3psR48B6F6qLPaN8w2lQl+LXiBi+ZfIz1dM+TNi8EqdiYGQUB0/He8NL1XUDU13Ulbx6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419683; c=relaxed/simple;
	bh=dVkl2Ju9fcT/LP1iKG9XPwmDZFKTu0VPLIUzUyrrd+w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=THnBOh6pEajarilk2WC0yFnLYxXExScq+jEKPcbu2oROFonNpMGh0TEHOvsKNgIgLFKJ04zE39DLF9kqXWHW4BJBf3lanzCCr1LDQiX7oxM7jB7imq/StgvahJZpkHXd40nIvlS/ToWNVMcahc90llO1LRi8Rrxy/yCSXqHfPao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WzCc4lsu; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725419680; x=1756955680;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dVkl2Ju9fcT/LP1iKG9XPwmDZFKTu0VPLIUzUyrrd+w=;
  b=WzCc4lsu8eE49lZBHNlPJPtte035GqXMMO1tyFK2BdcL0GlYd8BFpjPE
   ilDOjq+1ylYAZ5Fvu1SoAdr4IBiOCrbImlE8ZPbaw82zZ3G80dXdlc59c
   nohO99hyCzcU/oRhGK71VR5hqnMCLLu3A2J6JPpqWxise3UAVHrLcS39B
   7qbwarRW+n0/TJwDjpp+GZEbmD3RUJj3+CxK5YUDzzDzTxP3zXfTebdZx
   LOYZ26DKQCPhADSlb7LP2cDXmgADRISjSDeHpWDuws2hCvAMfAo+WV50r
   3HBkJmixqNaC/jiM4sEgjwukPwNBFpZD3IdfsrGjgI21HaJqkq0hwpHBF
   Q==;
X-CSE-ConnectionGUID: 7PMPfuhYQZ+mTHIhsDijPg==
X-CSE-MsgGUID: zfQyrpWCSISGZvv6ynpFPA==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="23564700"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="23564700"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:09 -0700
X-CSE-ConnectionGUID: ByB7aPORQT+rxVmIwauYRA==
X-CSE-MsgGUID: x94eR9t/T8C2KrCkic0tqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="65106331"
Received: from dgramcko-desk.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:08 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	isaku.yamahata@gmail.com,
	yan.y.zhao@intel.com,
	nik.borisov@suse.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 14/21] KVM: TDX: Implement hooks to propagate changes of TDP MMU mirror page table
Date: Tue,  3 Sep 2024 20:07:44 -0700
Message-Id: <20240904030751.117579-15-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Implement hooks in TDX to propagate changes of mirror page table to private
EPT, including changes for page table page adding/removing, guest page
adding/removing.

TDX invokes corresponding SEAMCALLs in the hooks.

- Hook link_external_spt
  propagates adding page table page into private EPT.

- Hook set_external_spte
  tdx_sept_set_private_spte() in this patch only handles adding of guest
  private page when TD is finalized.
  Later patches will handle the case of adding guest private pages before
  TD finalization.

- Hook free_external_spt
  It is invoked when page table page is removed in mirror page table, which
  currently must occur at TD tear down phase, after hkid is freed.

- Hook remove_external_spte
  It is invoked when guest private page is removed in mirror page table,
  which can occur when TD is active, e.g. during shared <-> private
  conversion and slot move/deletion.
  This hook is ensured to be triggered before hkid is freed, because
  gmem fd is released along with all private leaf mappings zapped before
  freeing hkid at VM destroy.

  TDX invokes below SEAMCALLs sequentially:
  1) TDH.MEM.RANGE.BLOCK (remove RWX bits from a private EPT entry),
  2) TDH.MEM.TRACK (increases TD epoch)
  3) TDH.MEM.PAGE.REMOVE (remove the private EPT entry and untrack the
     guest page).

  TDH.MEM.PAGE.REMOVE can't succeed without TDH.MEM.RANGE.BLOCK and
  TDH.MEM.TRACK being called successfully.
  SEAMCALL TDH.MEM.TRACK is called in function tdx_track() to enforce that
  TLB tracking will be performed by TDX module for private EPT.

Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU part 2 v1:
 - Split from the big patch "KVM: TDX: TDP MMU TDX support".
 - Move setting up the 4 callbacks (kvm_x86_ops::link_external_spt etc)
   from tdx_hardware_setup() (which doesn't exist anymore) to
   vt_hardware_setup() directly.  Make tdx_sept_link_external_spt() those
   4 callbacks global and add declarations to x86_ops.h so they can be
   setup in vt_hardware_setup().
 - Updated the KVM_BUG_ON() in tdx_sept_free_private_spt(). (Isaku, Binbin)
 - Removed the unused tdx_post_mmu_map_page().
 - Removed WARN_ON_ONCE) in tdh_mem_page_aug() according to Isaku's
   feedback:
   "This WARN_ON_ONCE() is a guard for buggy TDX module. It shouldn't return
   (TDX_EPT_ENTRY_STATE_INCORRECT | TDX_OPERAND_ID_RCX)) when
   SEPT_VE_DISABLED cleared.  Maybe we should remove this WARN_ON_ONCE()
   because the TDX module is mature."
 - Update for the wrapper functions for SEAMCALLs. (Sean)
 - Add preparation for KVM_TDX_INIT_MEM_REGION to make
   tdx_sept_set_private_spte() callback nop when the guest isn't finalized.
 - use unlikely(err) in  tdx_reclaim_td_page().
 - Updates from seamcall overhaul (Kai)
 - Move header definitions from "KVM: TDX: Define TDX architectural
   definitions" (Sean)
 - Drop ugly unions (Sean)
 - Remove tdx_mng_key_config_lock cleanup after dropped in "KVM: TDX:
   create/destroy VM structure" (Chao)
 - Since HKID is freed on vm_destroy() zapping only happens when HKID is
   allocated. Remove relevant code in zapping handlers that assume the
   opposite, and add some KVM_BUG_ON() to assert this where it was
   missing. (Isaku)
---
 arch/x86/kvm/vmx/main.c     |  14 ++-
 arch/x86/kvm/vmx/tdx.c      | 222 +++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx_arch.h |  23 ++++
 arch/x86/kvm/vmx/tdx_ops.h  |   6 +
 arch/x86/kvm/vmx/x86_ops.h  |  37 ++++++
 5 files changed, 300 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 1c86849680a3..bf6fd5cca1d6 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -36,9 +36,21 @@ static __init int vt_hardware_setup(void)
 	 * is KVM may allocate couple of more bytes than needed for
 	 * each VM.
 	 */
-	if (enable_tdx)
+	if (enable_tdx) {
 		vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size,
 				sizeof(struct kvm_tdx));
+		/*
+		 * Note, TDX may fail to initialize in a later time in
+		 * vt_init(), in which case it is not necessary to setup
+		 * those callbacks.  But making them valid here even
+		 * when TDX fails to init later is fine because those
+		 * callbacks won't be called if the VM isn't TDX guest.
+		 */
+		vt_x86_ops.link_external_spt = tdx_sept_link_private_spt;
+		vt_x86_ops.set_external_spte = tdx_sept_set_private_spte;
+		vt_x86_ops.free_external_spt = tdx_sept_free_private_spt;
+		vt_x86_ops.remove_external_spte = tdx_sept_remove_private_spte;
+	}
 
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 6feb3ab96926..b8cd5a629a80 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -447,6 +447,177 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
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
+	hpa_t hpa = pfn_to_hpa(pfn);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	u64 entry, level_state;
+	u64 err;
+
+	err = tdh_mem_page_aug(kvm_tdx, gpa, hpa, &entry, &level_state);
+	if (unlikely(err == TDX_ERROR_SEPT_BUSY)) {
+		tdx_unpin(kvm, pfn);
+		return -EAGAIN;
+	}
+	if (unlikely(err == (TDX_EPT_ENTRY_STATE_INCORRECT | TDX_OPERAND_ID_RCX))) {
+		if (tdx_get_sept_level(level_state) == tdx_level &&
+		    tdx_get_sept_state(level_state) == TDX_SEPT_PENDING &&
+		    is_last_spte(entry, level) &&
+		    spte_to_pfn(entry) == pfn &&
+		    entry & VMX_EPT_SUPPRESS_VE_BIT) {
+			tdx_unpin(kvm, pfn);
+			return -EAGAIN;
+		}
+	}
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error_2(TDH_MEM_PAGE_AUG, err, entry, level_state);
+		tdx_unpin(kvm, pfn);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
+			      enum pg_level level, kvm_pfn_t pfn)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+
+	/* TODO: handle large pages. */
+	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
+		return -EINVAL;
+
+	/*
+	 * Because guest_memfd doesn't support page migration with
+	 * a_ops->migrate_folio (yet), no callback is triggered for KVM on page
+	 * migration.  Until guest_memfd supports page migration, prevent page
+	 * migration.
+	 * TODO: Once guest_memfd introduces callback on page migration,
+	 * implement it and remove get_page/put_page().
+	 */
+	get_page(pfn_to_page(pfn));
+
+	if (likely(is_td_finalized(kvm_tdx)))
+		return tdx_mem_page_aug(kvm, gfn, level, pfn);
+
+	/*
+	 * TODO: KVM_MAP_MEMORY support to populate before finalize comes
+	 * here for the initial memory.
+	 */
+	return 0;
+}
+
+static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
+				      enum pg_level level, kvm_pfn_t pfn)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	hpa_t hpa = pfn_to_hpa(pfn);
+	hpa_t hpa_with_hkid;
+	u64 err, entry, level_state;
+
+	/* TODO: handle large pages. */
+	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
+		return -EINVAL;
+
+	if (KVM_BUG_ON(!is_hkid_assigned(kvm_tdx), kvm))
+		return -EINVAL;
+
+	do {
+		/*
+		 * When zapping private page, write lock is held. So no race
+		 * condition with other vcpu sept operation.  Race only with
+		 * TDH.VP.ENTER.
+		 */
+		err = tdh_mem_page_remove(kvm_tdx, gpa, tdx_level, &entry,
+					  &level_state);
+	} while (unlikely(err == TDX_ERROR_SEPT_BUSY));
+	if (unlikely(!is_td_finalized(kvm_tdx) &&
+		     err == (TDX_EPT_WALK_FAILED | TDX_OPERAND_ID_RCX))) {
+		/*
+		 * This page was mapped with KVM_MAP_MEMORY, but
+		 * KVM_TDX_INIT_MEM_REGION is not issued yet.
+		 */
+		if (!is_last_spte(entry, level) || !(entry & VMX_EPT_RWX_MASK)) {
+			tdx_unpin(kvm, pfn);
+			return 0;
+		}
+	}
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error_2(TDH_MEM_PAGE_REMOVE, err, entry, level_state);
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
+		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
+		return -EIO;
+	}
+	tdx_clear_page(hpa);
+	tdx_unpin(kvm, pfn);
+	return 0;
+}
+
+int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
+			      enum pg_level level, void *private_spt)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	hpa_t hpa = __pa(private_spt);
+	u64 err, entry, level_state;
+
+	err = tdh_mem_sept_add(to_kvm_tdx(kvm), gpa, tdx_level, hpa, &entry,
+			       &level_state);
+	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
+		return -EAGAIN;
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error_2(TDH_MEM_SEPT_ADD, err, entry, level_state);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
+				     enum pg_level level)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	gpa_t gpa = gfn_to_gpa(gfn) & KVM_HPAGE_MASK(level);
+	u64 err, entry, level_state;
+
+	/* For now large page isn't supported yet. */
+	WARN_ON_ONCE(level != PG_LEVEL_4K);
+
+	err = tdh_mem_range_block(kvm_tdx, gpa, tdx_level, &entry, &level_state);
+	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
+		return -EAGAIN;
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error_2(TDH_MEM_RANGE_BLOCK, err, entry, level_state);
+		return -EIO;
+	}
+	return 0;
+}
+
 /*
  * Ensure shared and private EPTs to be flushed on all vCPUs.
  * tdh_mem_track() is the only caller that increases TD epoch. An increase in
@@ -471,7 +642,7 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
  * occurs certainly after TD epoch increment and before the next
  * tdh_mem_track().
  */
-static void __always_unused tdx_track(struct kvm *kvm)
+static void tdx_track(struct kvm *kvm)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	u64 err;
@@ -492,6 +663,55 @@ static void __always_unused tdx_track(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_OUTSIDE_GUEST_MODE);
 }
 
+int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
+			      enum pg_level level, void *private_spt)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+
+	/*
+	 * free_external_spt() is only called after hkid is freed when TD is
+	 * tearing down.
+	 * KVM doesn't (yet) zap page table pages in mirror page table while
+	 * TD is active, though guest pages mapped in mirror page table could be
+	 * zapped during TD is active, e.g. for shared <-> private conversion
+	 * and slot move/deletion.
+	 */
+	if (KVM_BUG_ON(is_hkid_assigned(kvm_tdx), kvm))
+		return -EINVAL;
+
+	/*
+	 * The HKID assigned to this TD was already freed and cache was
+	 * already flushed. We don't have to flush again.
+	 */
+	return tdx_reclaim_page(__pa(private_spt));
+}
+
+int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
+				 enum pg_level level, kvm_pfn_t pfn)
+{
+	int ret;
+
+	/*
+	 * HKID is released when vm_free() which is after closing gmem_fd
+	 * which causes gmem invalidation to zap all spte.
+	 * Population is only allowed after KVM_TDX_INIT_VM.
+	 */
+	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
+		return -EINVAL;
+
+	ret = tdx_sept_zap_private_spte(kvm, gfn, level);
+	if (ret)
+		return ret;
+
+	/*
+	 * TDX requires TLB tracking before dropping private page.  Do
+	 * it here, although it is also done later.
+	 */
+	tdx_track(kvm);
+
+	return tdx_sept_drop_private_spte(kvm, gfn, level, pfn);
+}
+
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index 815e74408a34..634ed76db26a 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -155,6 +155,29 @@ struct td_params {
 #define TDX_MIN_TSC_FREQUENCY_KHZ		(100 * 1000)
 #define TDX_MAX_TSC_FREQUENCY_KHZ		(10 * 1000 * 1000)
 
+/* Additional Secure EPT entry information */
+#define TDX_SEPT_LEVEL_MASK		GENMASK_ULL(2, 0)
+#define TDX_SEPT_STATE_MASK		GENMASK_ULL(15, 8)
+#define TDX_SEPT_STATE_SHIFT		8
+
+enum tdx_sept_entry_state {
+	TDX_SEPT_FREE = 0,
+	TDX_SEPT_BLOCKED = 1,
+	TDX_SEPT_PENDING = 2,
+	TDX_SEPT_PENDING_BLOCKED = 3,
+	TDX_SEPT_PRESENT = 4,
+};
+
+static inline u8 tdx_get_sept_level(u64 sept_entry_info)
+{
+	return sept_entry_info & TDX_SEPT_LEVEL_MASK;
+}
+
+static inline u8 tdx_get_sept_state(u64 sept_entry_info)
+{
+	return (sept_entry_info & TDX_SEPT_STATE_MASK) >> TDX_SEPT_STATE_SHIFT;
+}
+
 #define MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM	BIT_ULL(20)
 
 /*
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index 8ca3e252a6ed..73ffd80223b0 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -31,6 +31,12 @@
 #define pr_tdx_error_3(__fn, __err, __rcx, __rdx, __r8)	\
 	pr_tdx_error_N(__fn, __err, "rcx 0x%llx, rdx 0x%llx, r8 0x%llx\n", __rcx, __rdx, __r8)
 
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
index 28fda93f0b27..d1db807b793a 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -131,6 +131,15 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
+int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
+			      enum pg_level level, void *private_spt);
+int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
+			      enum pg_level level, void *private_spt);
+int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
+			      enum pg_level level, kvm_pfn_t pfn);
+int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
+				 enum pg_level level, kvm_pfn_t pfn);
+
 void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 #else
@@ -146,6 +155,34 @@ static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
+static inline int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
+					    enum pg_level level,
+					    void *private_spt)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
+					    enum pg_level level,
+					    void *private_spt)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
+					    enum pg_level level,
+					    kvm_pfn_t pfn)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
+					       enum pg_level level,
+					       kvm_pfn_t pfn)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline void tdx_flush_tlb_current(struct kvm_vcpu *vcpu) {}
 static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
 #endif
-- 
2.34.1


