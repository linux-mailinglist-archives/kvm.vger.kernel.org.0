Return-Path: <kvm+bounces-67131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 81C82CF7D2C
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 11:37:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 28ED2305BD3F
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 10:36:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2380D337BA5;
	Tue,  6 Jan 2026 10:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mf7XqUOV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588DF1E3DE5;
	Tue,  6 Jan 2026 10:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767695179; cv=none; b=TAkIl9BDeqTOj1ro56tsPQUpKM4Gxk0oOHFEgcviMRGzA/EDAFcoMTByG7I0JZB5VJq5V8gfgiG8YvAIpYTi7bu3/BO89GVfCgcdBX4OO8oDyjRvVkDamrRsmn6nZVpqBsj8pMvgQHc+I02S/tRZF6KalUuFHWKq3DJdv1FfWCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767695179; c=relaxed/simple;
	bh=yVRhINa0SpzR7LHo8RdjWdsoINtk7obtx80TlyEt/8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fa/mm7lkgTqtZ73Ygtx6n5pc9dAfIM9shuIfVdzVjPc5uqTRHb+9e7N0779rHrKtRvd4ZxcjxpwXBEHcw1rETRJQlxV8DlthmDoTztkH8B7dxrHivWcYQi7gbdWepM/gmnys3xsczEyibZKPUbcuf4G3/tM6WaVDzDHnnlAjr2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mf7XqUOV; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767695177; x=1799231177;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yVRhINa0SpzR7LHo8RdjWdsoINtk7obtx80TlyEt/8I=;
  b=mf7XqUOVQpRYSQBW6fYBLrMjJ89PbniQeCid7S/B2aIijmGagVTQYFo2
   9/WGqaV4FUocCBedMaWkRwBgviPNFm74eGBjtRVLeqyibaoXvT44d+9I/
   UOIDODfaWa7n8bRboc05M0f5e9b0MOSkRBBIjVsovzJE7uvPk9EwmZAct
   z49q93/u8WdQinXlYA1wTu5Kwl7I8mPNQOWKtjPzPHIXSb/GamBUcIJx7
   PRoFpts7m+Fa7jhNIytlLNmfaMjSGG53YdH/cos9eJy7ElPw4XuldwFPY
   /4bWSni4ZE3nz5nbDADoW2R/qrQD4u+2b49JHQtulReD90c3/f96uP4iK
   A==;
X-CSE-ConnectionGUID: 0AHx6fJtS3WChha16QkkLg==
X-CSE-MsgGUID: vgeLspW/QHeEA7cVndWQEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="72918874"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="72918874"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:26:16 -0800
X-CSE-ConnectionGUID: 4vkVzlpVTdGWWZMW3I76rQ==
X-CSE-MsgGUID: R+xgwDwzQumSTbnOF7vweQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="207665023"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:26:10 -0800
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
Subject: [PATCH v3 22/24] x86/tdx: Add/Remove DPAMT pages for guest private memory to demote
Date: Tue,  6 Jan 2026 18:24:13 +0800
Message-ID: <20260106102413.25294-1-yan.y.zhao@intel.com>
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

When Dynamic PAMT is enabled and splitting a 2MB mapping to 512 4KB
mappings, SEAMCALL TDH.MEM.PAGE.DEMOTE takes the Dynamic PAMT page pair in
registers R12 and R13. The Dynamic PAMT page pair is used to store physical
memory metadata for the 2MB guest private memory after its S-EPT mapping is
split to 4KB successfully.

Pass prealloc_split_cache (the per-VM split cache) to SEAMCALL wrapper
tdh_mem_page_demote() for dequeuing Dynamic PAMT pages from the cache.
Protect the cache dequeuing in KVM with prealloc_split_cache_lock.

Inside wrapper tdh_mem_page_demote(), dequeue the Dynamic PAMT pages into
the guest_memory_pamt_page array and copy the page address to R12 and R13.

Invoke SEAMCALL TDH_MEM_PAGE_DEMOTE using seamcall_saved_ret() to handle
registers above R11.

Free the Dynamic PAMT pages after SEAMCALL TDH_MEM_PAGE_DEMOTE fails since
the guest private memory is still mapped at 2MB level.

Opportunistically, rename dpamt_args_array_ptr() to
dpamt_args_array_ptr_rdx() for tdh_phymem_pamt_{add/remove} and invoke
dpamt_args_array_ptr_r12() in tdh_mem_page_demote() for populating
registers starting from R12.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
v3:
- Split out as a new patch.
- Get pages from preallocate cache corresponding to DPAMT v4.
---
 arch/x86/include/asm/tdx.h  |  1 +
 arch/x86/kvm/vmx/tdx.c      |  5 ++-
 arch/x86/virt/vmx/tdx/tdx.c | 76 ++++++++++++++++++++++++++-----------
 3 files changed, 59 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index abe484045132..5fc7498392fd 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -251,6 +251,7 @@ u64 tdh_mng_create(struct tdx_td *td, u16 hkid);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
 u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data);
 u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *new_sept_page,
+			struct tdx_prealloc *prealloc,
 			u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mr_extend(struct tdx_td *td, u64 gpa, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mr_finalize(struct tdx_td *td);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ec47bd799274..a11ff02a4f30 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2021,8 +2021,11 @@ static int tdx_sept_split_private_spte(struct kvm *kvm, gfn_t gfn, enum pg_level
 	if (KVM_BUG_ON(ret, kvm))
 		return -EIO;
 
+	spin_lock(&kvm_tdx->prealloc_split_cache_lock);
 	err = tdh_do_no_vcpus(tdh_mem_page_demote, kvm, &kvm_tdx->td, gpa,
-			      tdx_level, new_sept_page, &entry, &level_state);
+			      tdx_level, new_sept_page,
+			      &kvm_tdx->prealloc_split_cache, &entry, &level_state);
+	spin_unlock(&kvm_tdx->prealloc_split_cache_lock);
 	if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_DEMOTE, entry, level_state, kvm)) {
 		tdx_pamt_put(new_sept_page);
 		return -EIO;
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 76963c563906..9917e4e7705f 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1848,25 +1848,69 @@ u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_rd);
 
+static int alloc_pamt_array(u64 *pa_array, struct tdx_prealloc *prealloc);
+static void free_pamt_array(u64 *pa_array);
+/*
+ * The TDX spec treats the registers like an array, as they are ordered
+ * in the struct. The array size is limited by the number or registers,
+ * so define the max size it could be for worst case allocations and sanity
+ * checking.
+ */
+#define MAX_TDX_ARG_SIZE(reg) ((sizeof(struct tdx_module_args) - \
+			       offsetof(struct tdx_module_args, reg)) / sizeof(u64))
+#define TDX_ARG_INDEX(reg) (offsetof(struct tdx_module_args, reg) / \
+			    sizeof(u64))
+/*
+ * Treat struct the registers like an array that starts at R12, per
+ * TDX spec. Do some sanitychecks, and return an indexable type.
+ */
+static u64 *dpamt_args_array_ptr_r12(struct tdx_module_array_args *args)
+{
+	WARN_ON_ONCE(tdx_dpamt_entry_pages() > MAX_TDX_ARG_SIZE(r12));
+
+	return &args->args_array[TDX_ARG_INDEX(r12)];
+}
+
 u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *new_sept_page,
+			struct tdx_prealloc *prealloc,
 			u64 *ext_err1, u64 *ext_err2)
 {
-	struct tdx_module_args args = {
-		.rcx = gpa | level,
-		.rdx = tdx_tdr_pa(td),
-		.r8 = page_to_phys(new_sept_page),
+	bool dpamt = tdx_supports_dynamic_pamt(&tdx_sysinfo) && level == TDX_PS_2M;
+	u64 guest_memory_pamt_page[MAX_TDX_ARG_SIZE(r12)];
+	struct tdx_module_array_args args = {
+		.args.rcx = gpa | level,
+		.args.rdx = tdx_tdr_pa(td),
+		.args.r8 = page_to_phys(new_sept_page),
 	};
 	u64 ret;
 
 	if (!tdx_supports_demote_nointerrupt(&tdx_sysinfo))
 		return TDX_SW_ERROR;
 
+	if (dpamt) {
+		u64 *args_array = dpamt_args_array_ptr_r12(&args);
+
+		if (alloc_pamt_array(guest_memory_pamt_page, prealloc))
+			return TDX_SW_ERROR;
+
+		/*
+		 * Copy PAMT page PAs of the guest memory into the struct per the
+		 * TDX ABI
+		 */
+		memcpy(args_array, guest_memory_pamt_page,
+		       tdx_dpamt_entry_pages() * sizeof(*args_array));
+	}
+
 	/* Flush the new S-EPT page to be added */
 	tdx_clflush_page(new_sept_page);
-	ret = seamcall_ret(TDH_MEM_PAGE_DEMOTE, &args);
 
-	*ext_err1 = args.rcx;
-	*ext_err2 = args.rdx;
+	ret = seamcall_saved_ret(TDH_MEM_PAGE_DEMOTE, &args.args);
+
+	*ext_err1 = args.args.rcx;
+	*ext_err2 = args.args.rdx;
+
+	if (dpamt && ret)
+		free_pamt_array(guest_memory_pamt_page);
 
 	return ret;
 }
@@ -2104,23 +2148,11 @@ static struct page *alloc_dpamt_page(struct tdx_prealloc *prealloc)
 	return alloc_page(GFP_KERNEL_ACCOUNT);
 }
 
-
-/*
- * The TDX spec treats the registers like an array, as they are ordered
- * in the struct. The array size is limited by the number or registers,
- * so define the max size it could be for worst case allocations and sanity
- * checking.
- */
-#define MAX_TDX_ARG_SIZE(reg) (sizeof(struct tdx_module_args) - \
-			       offsetof(struct tdx_module_args, reg))
-#define TDX_ARG_INDEX(reg) (offsetof(struct tdx_module_args, reg) / \
-			    sizeof(u64))
-
 /*
  * Treat struct the registers like an array that starts at RDX, per
  * TDX spec. Do some sanitychecks, and return an indexable type.
  */
-static u64 *dpamt_args_array_ptr(struct tdx_module_array_args *args)
+static u64 *dpamt_args_array_ptr_rdx(struct tdx_module_array_args *args)
 {
 	WARN_ON_ONCE(tdx_dpamt_entry_pages() > MAX_TDX_ARG_SIZE(rdx));
 
@@ -2188,7 +2220,7 @@ static u64 tdh_phymem_pamt_add(struct page *page, u64 *pamt_pa_array)
 	struct tdx_module_array_args args = {
 		.args.rcx = pamt_2mb_arg(page)
 	};
-	u64 *dpamt_arg_array = dpamt_args_array_ptr(&args);
+	u64 *dpamt_arg_array = dpamt_args_array_ptr_rdx(&args);
 
 	/* Copy PAMT page PA's into the struct per the TDX ABI */
 	memcpy(dpamt_arg_array, pamt_pa_array,
@@ -2216,7 +2248,7 @@ static u64 tdh_phymem_pamt_remove(struct page *page, u64 *pamt_pa_array)
 	struct tdx_module_array_args args = {
 		.args.rcx = pamt_2mb_arg(page),
 	};
-	u64 *args_array = dpamt_args_array_ptr(&args);
+	u64 *args_array = dpamt_args_array_ptr_rdx(&args);
 	u64 ret;
 
 	ret = seamcall_ret(TDH_PHYMEM_PAMT_REMOVE, &args.args);
-- 
2.43.2


