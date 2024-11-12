Return-Path: <kvm+bounces-31581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CFBE89C4FBE
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:45:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51E681F21240
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:45:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24F7920BB49;
	Tue, 12 Nov 2024 07:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hzfa3ak7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555FE2139AF;
	Tue, 12 Nov 2024 07:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397237; cv=none; b=slXu1hbgAmgqsPkGe9CbuWRwdv1ODJi0HONe/9eRoZMx0+cpYEXmQ8/jw23vowyJxxqirUkKIEXwTl/5VUne3LyUGPPZ8taxmQZ/54bkHxJwSaVb2eN+z6Rg/bgJW4gYfWklcyco5WGA9P8mFCVE3fTuKKhEDi1EZq/ufmmg4kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397237; c=relaxed/simple;
	bh=JoZpPG0nym+VJAQu2zwd3iOukPfsFOAFaeI4EeSaZEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIFTxfBocrMLldhxSVaKaWICc23RNXB/sdbqDFSEFhEc7hpfP5FKcfhpsJZIBSdAxRMikeS26ALg/jM4/aiAJO3wor1kUlGHko81kTLocdpyGq/W3TKu9+hRw77KJyC+C1wGJzhcdy7X2AKKrgRyZILY2Hj929y3sdjzuGqOeug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hzfa3ak7; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731397235; x=1762933235;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JoZpPG0nym+VJAQu2zwd3iOukPfsFOAFaeI4EeSaZEg=;
  b=hzfa3ak78tIdlTZYYenbQf2sdwfnQeHwmvU9kuv7MLHXZ6hhrEmcHMlh
   XYeD/vNMJ6I0z1q4rHK9ls5kIyri6FtQOK3yndqT8jHycM5yyFW9N5Ju7
   By1vMrzNykqHrkGF2Wh1ZgXjk8zqCfylJHKoZko3zIFfs4TJm+O1ZV/Yn
   3LxxE06myrD1LiLXJLuKFiPIKrAEAkPkcl3ISdprpp/hxKpx6cje7GEhE
   aCB8jQOnICw+22emHP+Sx0U2WBFJ54g9JeaLuD/CtHWva63f4v4HtiybW
   Bn3CYya3v25A1AaQ3y8p+FBoPzPLTonllPawPX9XbHdSqDBpbQxUCC0b1
   Q==;
X-CSE-ConnectionGUID: KGsH4Om9ScS0Q7Jso1KY6Q==
X-CSE-MsgGUID: OXBBrvdsT6Gsba6vPmrBoQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11253"; a="31090701"
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="31090701"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:40:35 -0800
X-CSE-ConnectionGUID: quOya2fxQJi+Owk5M32FLg==
X-CSE-MsgGUID: a5S2FhI/Qm+DQWYgAeZh2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="92089590"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:40:31 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 18/24] KVM: TDX: Implement hooks to propagate changes of TDP MMU mirror page table
Date: Tue, 12 Nov 2024 15:38:04 +0800
Message-ID: <20241112073804.22242-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241112073327.21979-1-yan.y.zhao@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
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

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
TDX MMU part 2 v2:
 - No need for is_td_finalized() (Rick)
 - Fixup SEAMCALL call sites due to function parameter changes to SEAMCALL
   wrappers (Kai)
 - Add TD state handling (Tony)
 - Fix "KVM_MAP_MEMORY" comment (Binbin)
 - Updated comment of KVM_BUG_ON() in tdx_sept_remove_private_spte
   (Kai, Rick)
 - Return -EBUSY on busy in tdx_mem_page_aug(). (Kai)
 - Retry tdh_mem_page_aug() on TDX_OPERAND_BUSY instead of
   TDX_ERROR_SEPT_BUSY. (Yan)

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
 arch/x86/kvm/vmx/tdx.c      | 219 +++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx_arch.h |  23 ++++
 arch/x86/kvm/vmx/x86_ops.h  |  37 ++++++
 4 files changed, 291 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 4902d7bb86f3..cb41e9a1d3e3 100644
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
index 9eef361c8e57..29f01cff0e6b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -142,6 +142,14 @@ static DEFINE_MUTEX(tdx_lock);
 
 static atomic_t nr_configured_hkid;
 
+#define TDX_ERROR_SEPT_BUSY    (TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT)
+
+static inline int pg_level_to_tdx_sept_level(enum pg_level level)
+{
+	WARN_ON_ONCE(level == PG_LEVEL_NONE);
+	return level - 1;
+}
+
 /* Maximum number of retries to attempt for SEAMCALLs. */
 #define TDX_SEAMCALL_RETRIES	10000
 
@@ -524,6 +532,166 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
 }
 
+static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn)
+{
+	put_page(pfn_to_page(pfn));
+}
+
+static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
+			    enum pg_level level, kvm_pfn_t pfn)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	hpa_t hpa = pfn_to_hpa(pfn);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	u64 entry, level_state;
+	u64 err;
+
+	err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, hpa, &entry, &level_state);
+	if (unlikely(err & TDX_OPERAND_BUSY)) {
+		tdx_unpin(kvm, pfn);
+		return -EBUSY;
+	}
+
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
+	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
+		return tdx_mem_page_aug(kvm, gfn, level, pfn);
+
+	/*
+	 * TODO: KVM_TDX_INIT_MEM_REGION support to populate before finalize
+	 * comes here for the initial memory.
+	 */
+	return -EOPNOTSUPP;
+}
+
+static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
+				      enum pg_level level, kvm_pfn_t pfn)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	hpa_t hpa = pfn_to_hpa(pfn);
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
+		err = tdh_mem_page_remove(kvm_tdx->tdr_pa, gpa, tdx_level, &entry,
+					  &level_state);
+	} while (unlikely(err == TDX_ERROR_SEPT_BUSY));
+
+	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE &&
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
+
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error_2(TDH_MEM_PAGE_REMOVE, err, entry, level_state);
+		return -EIO;
+	}
+
+	do {
+		/*
+		 * TDX_OPERAND_BUSY can happen on locking PAMT entry.  Because
+		 * this page was removed above, other thread shouldn't be
+		 * repeatedly operating on this page.  Just retry loop.
+		 */
+		err = tdh_phymem_page_wbinvd_hkid(hpa, (u16)kvm_tdx->hkid);
+	} while (unlikely(err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX)));
+
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
+	err = tdh_mem_sept_add(to_kvm_tdx(kvm)->tdr_pa, gpa, tdx_level, hpa, &entry,
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
+	err = tdh_mem_range_block(kvm_tdx->tdr_pa, gpa, tdx_level, &entry, &level_state);
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
@@ -548,7 +716,7 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
  * occurs certainly after TD epoch increment and before the next
  * tdh_mem_track().
  */
-static void __always_unused tdx_track(struct kvm *kvm)
+static void tdx_track(struct kvm *kvm)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	u64 err;
@@ -569,6 +737,55 @@ static void __always_unused tdx_track(struct kvm *kvm)
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
+	 * HKID is released after all private pages have been removed, and set
+	 * before any might be populated. Warn if zapping is attempted when
+	 * there can't be anything populated in the private EPT.
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
index d80ec118834e..289728f1611f 100644
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
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 7151ac38bc31..3e7e7d0eadbf 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -130,6 +130,15 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 
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
 void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
@@ -145,6 +154,34 @@ static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 
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
 static inline void tdx_flush_tlb_all(struct kvm_vcpu *vcpu) {}
 static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
-- 
2.43.2


