Return-Path: <kvm+bounces-67132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EB8DCCF7D41
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 11:38:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EA826304AE66
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 10:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6143E337B87;
	Tue,  6 Jan 2026 10:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lIJuCufn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BDD1E3DE5;
	Tue,  6 Jan 2026 10:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767695192; cv=none; b=RfGA+XOK1CvZ87oN5ieA5GuP+bcZ22xLHUEWlGN3WFlKcaLP6JaAC0Dxa6Rl4t6lL5USzrwwgeM/WtJXZ0GOJa3V3cAbdBwTMYAo5/6gqleGbOMk1+aA17tPM3Ro1qXoqFAhNztP7pLOtC1DFRetg1WVZsy9hF7ndEZuCkrpXKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767695192; c=relaxed/simple;
	bh=xXosmn1UyznO3Ntig48bCZdj7wfeHeeTNRKz3vbDbxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkckzcK4t5fYsfA6UPzWZ6p0XYpTboYgEMqZGsHLxCYpsl1BuiChgBx8jCR6Tu7Cd9lizaSFaOqHSgxovZ98vIUfAQjbvuFUX2E8Hjq/jP2uEkFnM4CE2K2e9+bI8a7guNfKM20gcR13YyM7vwU5dmnHTGYay3M0G2R04Bxgk2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lIJuCufn; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767695190; x=1799231190;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xXosmn1UyznO3Ntig48bCZdj7wfeHeeTNRKz3vbDbxc=;
  b=lIJuCufn9BHs/8PB0LsjVIhsbR1p5N4WxvamgBXCHefmRXMX7ArIDxhD
   xjQOrt9WtTL8hqFLc3OcUycoBZaTzPE8w9JjCuXqY8zhV1k/NVnZxZqZl
   HBOWiwMjjHIfCwR3BEOOwI7s+1AO7Wyu9j5xtmT6trJ+WHhRbbOdL253D
   Ae6DjnhY24apa7NzlfawmDhlt2rZVWUiYC4t/lFdDoCHvAD9Ggp42D3sZ
   Eza2RDoD9Z0W0A+hp1hfF96rZHE+sYmePEsZTjNLIZBYz2IfFAbNP4DcD
   OOyOLK9CIgTe0hShZ3TtBJMGPTPF6lp+c/zVA5PwCqqaAn8UjuoBjdhUd
   w==;
X-CSE-ConnectionGUID: oOh3UIT7RnGZyZ2OLsyJTw==
X-CSE-MsgGUID: JiW/5kK0Rw2ele0k86pixw==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="72918889"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="72918889"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:26:29 -0800
X-CSE-ConnectionGUID: 28oFsooDT8m4a5drTlnc4w==
X-CSE-MsgGUID: 0PHXVftfS0Ks4lUoJFO+hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="207665115"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:26:23 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kas@kernel.org,
	tabba@google.com,
	ackerleytng@google.com,
	michael.roth@amd.com,
	david@kernel.org,
	vannapurve@google.com,
	sagis@google.com,
	vbabka@suse.cz,
	thomas.lendacky@amd.com,
	nik.borisov@suse.com,
	pgonda@google.com,
	fan.du@intel.com,
	jun.miao@intel.com,
	francescolavra.fl@gmail.com,
	jgross@suse.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	kai.huang@intel.com,
	binbin.wu@linux.intel.com,
	chao.p.peng@intel.com,
	chao.gao@intel.com,
	yan.y.zhao@intel.com
Subject: [PATCH v3 23/24] x86/tdx: Pass guest memory's PFN info to demote for updating pamt_refcount
Date: Tue,  6 Jan 2026 18:24:26 +0800
Message-ID: <20260106102426.25311-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20260106101646.24809-1-yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Pass guest memory's PFN info to tdh_mem_page_demote() by adding parameters
"guest_folio" and "guest_start_idx" to tdh_mem_page_demote().

The guest memory's pfn info is not required by directly SEAMCALL
TDH_MEM_PAGE_DEMOTE. Instead, it's used by host kernel to track the
pamt_refcount for the 2MB range containing the guest private memory.

Ater the S-EPT mapping is successfully split, set the pamt_refcount for the
2MB range containing the guest private memory to 512 after ensuring its
original value is 0. Warn loudly if the setting refcount operation fails,
which indicates kernel bugs.

Check guest memory's base pfn is 2MB aligned and all the guest memory is
contained in a single folio in tdh_mem_page_demote() to guard against any
kernel bugs.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
v3:
- Split out as a new patch.
- Added parameters "guest_folio" and "guest_start_idx" to pass the guest
  memory pfn info.
- Use atomic_cmpxchg_release() to set guest_pamt_refcount.
- No need to add param "pfn_for_gfn" kvm_x86_ops.split_external_spt() as
  the pfn info is already contained in param "old_mirror_spte" in
  kvm_x86_ops.split_external_spte().
---
 arch/x86/include/asm/tdx.h  |  6 +++---
 arch/x86/kvm/vmx/tdx.c      |  9 ++++++---
 arch/x86/virt/vmx/tdx/tdx.c | 30 +++++++++++++++++++++++++-----
 3 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 5fc7498392fd..f536782da157 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -250,9 +250,9 @@ u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, u16 hkid);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
 u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data);
-u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *new_sept_page,
-			struct tdx_prealloc *prealloc,
-			u64 *ext_err1, u64 *ext_err2);
+u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct folio *guest_folio,
+			unsigned long guest_start_idx, struct page *new_sept_page,
+			struct tdx_prealloc *prealloc, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mr_extend(struct tdx_td *td, u64 gpa, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mr_finalize(struct tdx_td *td);
 u64 tdh_vp_flush(struct tdx_vp *vp);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a11ff02a4f30..0054a9de867c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1991,7 +1991,9 @@ static int tdx_sept_split_private_spte(struct kvm *kvm, gfn_t gfn, enum pg_level
 				       u64 old_mirror_spte, void *new_private_spt,
 				       bool mmu_lock_shared)
 {
+	struct page *guest_page = pfn_to_page(spte_to_pfn(old_mirror_spte));
 	struct page *new_sept_page = virt_to_page(new_private_spt);
+	struct folio *guest_folio = page_folio(guest_page);
 	int tdx_level = pg_level_to_tdx_sept_level(level);
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	gpa_t gpa = gfn_to_gpa(gfn);
@@ -2022,9 +2024,10 @@ static int tdx_sept_split_private_spte(struct kvm *kvm, gfn_t gfn, enum pg_level
 		return -EIO;
 
 	spin_lock(&kvm_tdx->prealloc_split_cache_lock);
-	err = tdh_do_no_vcpus(tdh_mem_page_demote, kvm, &kvm_tdx->td, gpa,
-			      tdx_level, new_sept_page,
-			      &kvm_tdx->prealloc_split_cache, &entry, &level_state);
+	err = tdh_do_no_vcpus(tdh_mem_page_demote, kvm, &kvm_tdx->td, gpa, tdx_level,
+			      guest_folio, folio_page_idx(guest_folio, guest_page),
+			      new_sept_page, &kvm_tdx->prealloc_split_cache,
+			      &entry, &level_state);
 	spin_unlock(&kvm_tdx->prealloc_split_cache_lock);
 	if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_DEMOTE, entry, level_state, kvm)) {
 		tdx_pamt_put(new_sept_page);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 9917e4e7705f..d036d9b5c87a 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1871,9 +1871,9 @@ static u64 *dpamt_args_array_ptr_r12(struct tdx_module_array_args *args)
 	return &args->args_array[TDX_ARG_INDEX(r12)];
 }
 
-u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *new_sept_page,
-			struct tdx_prealloc *prealloc,
-			u64 *ext_err1, u64 *ext_err2)
+u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct folio *guest_folio,
+			unsigned long guest_start_idx, struct page *new_sept_page,
+			struct tdx_prealloc *prealloc, u64 *ext_err1, u64 *ext_err2)
 {
 	bool dpamt = tdx_supports_dynamic_pamt(&tdx_sysinfo) && level == TDX_PS_2M;
 	u64 guest_memory_pamt_page[MAX_TDX_ARG_SIZE(r12)];
@@ -1882,6 +1882,8 @@ u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *new_
 		.args.rdx = tdx_tdr_pa(td),
 		.args.r8 = page_to_phys(new_sept_page),
 	};
+	/* base pfn for guest private memory */
+	unsigned long guest_base_pfn;
 	u64 ret;
 
 	if (!tdx_supports_demote_nointerrupt(&tdx_sysinfo))
@@ -1889,6 +1891,15 @@ u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *new_
 
 	if (dpamt) {
 		u64 *args_array = dpamt_args_array_ptr_r12(&args);
+		unsigned long npages = 1 << (level * PTE_SHIFT);
+		struct page *guest_page;
+
+		guest_page = folio_page(guest_folio, guest_start_idx);
+		guest_base_pfn = page_to_pfn(guest_page);
+
+		if (guest_start_idx + npages > folio_nr_pages(guest_folio) ||
+		    !IS_ALIGNED(guest_base_pfn, npages))
+			return TDX_OPERAND_INVALID;
 
 		if (alloc_pamt_array(guest_memory_pamt_page, prealloc))
 			return TDX_SW_ERROR;
@@ -1909,9 +1920,18 @@ u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *new_
 	*ext_err1 = args.args.rcx;
 	*ext_err2 = args.args.rdx;
 
-	if (dpamt && ret)
-		free_pamt_array(guest_memory_pamt_page);
+	if (dpamt) {
+		if (ret) {
+			free_pamt_array(guest_memory_pamt_page);
+		} else {
+			/* PAMT refcount for guest private memory */
+			atomic_t *pamt_refcount;
 
+			pamt_refcount = tdx_find_pamt_refcount(guest_base_pfn);
+			WARN_ON_ONCE(atomic_cmpxchg_release(pamt_refcount, 0,
+							    PTRS_PER_PMD));
+		}
+	}
 	return ret;
 }
 EXPORT_SYMBOL_GPL(tdh_mem_page_demote);
-- 
2.43.2


