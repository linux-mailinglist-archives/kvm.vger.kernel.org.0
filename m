Return-Path: <kvm+bounces-63308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 091C6C621B8
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 03:40:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 435C035BB9D
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 02:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8589D269D06;
	Mon, 17 Nov 2025 02:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GZJ2biYp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB819261B75;
	Mon, 17 Nov 2025 02:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763347106; cv=none; b=EfyfuIKty/jJPqfJzne6rXmVhkkYYCDioqZwWcGPdwADSlwHt7ziih/hNhqvLexMjPhd2GKvW8QU4uHVLa7s6k8Oc6Z2GRz54++OstVcj/EEcCIf8ZjyaOt0fuMj+9/8ubrSxZAhMxhP0nRSNByTTklPGw1zWzHUssUV9ip2TAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763347106; c=relaxed/simple;
	bh=vGz3Efxg8PzqtJ9JoXWjl4xuxSf+0PFhjVR2mSBXjdI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JhPsDQEDN7R6wJcjsI1sbD9OE6LAxY2heDHfZyVI3yA3ObxrPvo184wgJMkUo+wOH6UF6IIfDWa2/O4oIjvc6WTLWjirXsLXwrfGHavPxUtntT55i7VT2z0dgsFL9cb7pa7wH8SUmNalrBuuHeOU1BFRBiBwTYgHqXu5KpUhNCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GZJ2biYp; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763347105; x=1794883105;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vGz3Efxg8PzqtJ9JoXWjl4xuxSf+0PFhjVR2mSBXjdI=;
  b=GZJ2biYp0ns93gex5QOgW/NvUxZzfa5RTy6/XbM5u2pw4tlEMQDP5JLt
   +Tshf78wQYlJcDtc93ig8ojdXdAozwPs6VEAifEGcHVNrRARLzAWoR+SW
   VXmmtXtmUJdpRpSI1R4y8lgWLt6e6TioF9znPGnUhcKFqqgea/mQlV7VZ
   eWRMF6UT3IJRqyb9tlW/X+Pkg45auLh9Mn2u9Nz6YtFhmQwvL7iG/bjr0
   WQ5n2a+LijYSqw0bVtxm+RtXH7ubtaq3LL2SL0TQl/LlfOzNZ31dkt1RY
   mOtcSsqQI4MWmrzM8Ibh04xjm005sujWX+grtarEZ08ZPQnSVGBeMebtN
   A==;
X-CSE-ConnectionGUID: RRSIIVIxSSm8mMIJgChpGw==
X-CSE-MsgGUID: P6eaavGaQceFhVQNfZ8pwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="82729525"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="82729525"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 18:38:25 -0800
X-CSE-ConnectionGUID: ZEq5nm+1QAm2g3iBOwrOSQ==
X-CSE-MsgGUID: urb99QjcT1WJkUWCxWD7tQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="227658243"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 16 Nov 2025 18:38:20 -0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org
Cc: chao.gao@intel.com,
	dave.jiang@intel.com,
	baolu.lu@linux.intel.com,
	yilun.xu@linux.intel.com,
	yilun.xu@intel.com,
	zhenzhong.duan@intel.com,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	dan.j.williams@intel.com,
	kas@kernel.org,
	x86@kernel.org
Subject: [PATCH v1 08/26] x86/virt/tdx: Add tdx_enable_ext() to enable of TDX Module Extensions
Date: Mon, 17 Nov 2025 10:22:52 +0800
Message-Id: <20251117022311.2443900-9-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

Add a kAPI tdx_enable_ext() for kernel to enable TDX Module Extensions
after basic TDX Module initialization.

The extension initialization uses the new TDH.EXT.MEM.ADD and
TDX.EXT.INIT seamcalls. TDH.EXT.MEM.ADD add pages to a shared memory
pool for extensions to consume. The number of pages required is
published in the MEMORY_POOL_REQUIRED_PAGES field from TDH.SYS.RD. Then
on TDX.EXT.INIT, the extensions consume from the pool and initialize.

TDH.EXT.MEM.ADD is the first user of tdx_page_array. It provides pages
to TDX Module as control (private) pages. A tdx_clflush_page_array()
helper is introduced to flush shared cache before SEAMCALL, to avoid
shared cache write back damages these private pages.

TDH.EXT.MEM.ADD uses HPA_LIST_INFO as parameter so could leverage the
'first_entry' field to simplify the interrupted - retry flow. Host
don't have to care about partial page adding and 'first_entry'.

Use a new version TDH.SYS.CONFIG for VMM to tell TDX Module which
optional features (e.g. TDX Connect, and selecting TDX Connect implies
selecting TDX Module Extensions) to use and let TDX Module update its
global metadata (e.g. memory_pool_required_pages for TDX Module
Extensions). So after calling this new version TDH.SYS.CONFIG, VMM
updates the cached tdx_sysinfo.

Note that this extension initialization does not impact existing
in-flight SEAMCALLs that are not implemented by the extension. So only
the first user of an extension-seamcall needs invoke this helper.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Co-developed-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/tdx.h            |   3 +
 arch/x86/virt/vmx/tdx/tdx.h           |   2 +
 arch/x86/virt/vmx/tdx/tdx.c           | 184 ++++++++++++++++++++++++--
 drivers/virt/coco/tdx-host/tdx-host.c |   5 +
 4 files changed, 181 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 3a3ea3fa04f2..1eeb77a6790a 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -125,11 +125,13 @@ static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
 #define seamcall(_fn, _args)		sc_retry(__seamcall, (_fn), (_args))
 #define seamcall_ret(_fn, _args)	sc_retry(__seamcall_ret, (_fn), (_args))
 #define seamcall_saved_ret(_fn, _args)	sc_retry(__seamcall_saved_ret, (_fn), (_args))
+int tdx_enable_ext(void);
 const char *tdx_dump_mce_info(struct mce *m);
 
 /* Bit definitions of TDX_FEATURES0 metadata field */
 #define TDX_FEATURES0_TDXCONNECT	BIT_ULL(6)
 #define TDX_FEATURES0_NO_RBP_MOD	BIT_ULL(18)
+#define TDX_FEATURES0_EXT		BIT_ULL(39)
 
 const struct tdx_sys_info *tdx_get_sysinfo(void);
 
@@ -223,6 +225,7 @@ u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
 u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page);
 #else
 static inline void tdx_init(void) { }
+static inline int tdx_enable_ext(void) { return -ENODEV; }
 static inline u32 tdx_get_nr_guest_keyids(void) { return 0; }
 static inline const char *tdx_dump_mce_info(struct mce *m) { return NULL; }
 static inline const struct tdx_sys_info *tdx_get_sysinfo(void) { return NULL; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 4370d3d177f6..b84678165d00 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -46,6 +46,8 @@
 #define TDH_PHYMEM_PAGE_WBINVD		41
 #define TDH_VP_WR			43
 #define TDH_SYS_CONFIG			45
+#define TDH_EXT_INIT			60
+#define TDH_EXT_MEM_ADD			61
 
 /*
  * SEAMCALL leaf:
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 9a5c32dc1767..bbf93cad5bf2 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -59,6 +59,9 @@ static LIST_HEAD(tdx_memlist);
 static struct tdx_sys_info tdx_sysinfo __ro_after_init;
 static bool tdx_module_initialized __ro_after_init;
 
+static DEFINE_MUTEX(tdx_module_ext_lock);
+static bool tdx_module_ext_initialized;
+
 typedef void (*sc_err_func_t)(u64 fn, u64 err, struct tdx_module_args *args);
 
 static inline void seamcall_err(u64 fn, u64 err, struct tdx_module_args *args)
@@ -517,7 +520,7 @@ EXPORT_SYMBOL_GPL(tdx_page_array_ctrl_release);
 #define HPA_LIST_INFO_PFN		GENMASK_U64(51, 12)
 #define HPA_LIST_INFO_LAST_ENTRY	GENMASK_U64(63, 55)
 
-static u64 __maybe_unused hpa_list_info_assign_raw(struct tdx_page_array *array)
+static u64 hpa_list_info_assign_raw(struct tdx_page_array *array)
 {
 	return FIELD_PREP(HPA_LIST_INFO_FIRST_ENTRY, 0) |
 	       FIELD_PREP(HPA_LIST_INFO_PFN, page_to_pfn(array->root)) |
@@ -1251,7 +1254,14 @@ static __init int config_tdx_module(struct tdmr_info_list *tdmr_list,
 	args.rcx = __pa(tdmr_pa_array);
 	args.rdx = tdmr_list->nr_consumed_tdmrs;
 	args.r8 = global_keyid;
-	ret = seamcall_prerr(TDH_SYS_CONFIG, &args);
+
+	if (tdx_sysinfo.features.tdx_features0 & TDX_FEATURES0_TDXCONNECT) {
+		args.r9 |= TDX_FEATURES0_TDXCONNECT;
+		args.r11 = ktime_get_real_seconds();
+		ret = seamcall_prerr(TDH_SYS_CONFIG | (1ULL << TDX_VERSION_SHIFT), &args);
+	} else {
+		ret = seamcall_prerr(TDH_SYS_CONFIG, &args);
+	}
 
 	/* Free the array as it is not required anymore. */
 	kfree(tdmr_pa_array);
@@ -1411,6 +1421,11 @@ static __init int init_tdx_module(void)
 	if (ret)
 		goto err_free_pamts;
 
+	/* configuration to tdx module may change tdx_sysinfo, update it */
+	ret = get_tdx_sys_info(&tdx_sysinfo);
+	if (ret)
+		goto err_reset_pamts;
+
 	/* Config the key of global KeyID on all packages */
 	ret = config_global_keyid();
 	if (ret)
@@ -1488,6 +1503,160 @@ static __init int tdx_enable(void)
 }
 subsys_initcall(tdx_enable);
 
+static int enable_tdx_ext(void)
+{
+	struct tdx_module_args args = {};
+	u64 r;
+
+	if (!tdx_sysinfo.ext.ext_required)
+		return 0;
+
+	do {
+		r = seamcall(TDH_EXT_INIT, &args);
+		cond_resched();
+	} while (r == TDX_INTERRUPTED_RESUMABLE);
+
+	if (r != TDX_SUCCESS)
+		return -EFAULT;
+
+	return 0;
+}
+
+static void tdx_ext_mempool_free(struct tdx_page_array *mempool)
+{
+	/*
+	 * Some pages may have been touched by the TDX module.
+	 * Flush cache before returning these pages to kernel.
+	 */
+	wbinvd_on_all_cpus();
+	tdx_page_array_free(mempool);
+}
+
+DEFINE_FREE(tdx_ext_mempool_free, struct tdx_page_array *,
+	    if (!IS_ERR_OR_NULL(_T)) tdx_ext_mempool_free(_T))
+
+/*
+ * The TDX module exposes a CLFLUSH_BEFORE_ALLOC bit to specify whether
+ * a CLFLUSH of pages is required before handing them to the TDX module.
+ * Be conservative and make the code simpler by doing the CLFLUSH
+ * unconditionally.
+ */
+static void tdx_clflush_page(struct page *page)
+{
+	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
+}
+
+static void tdx_clflush_page_array(struct tdx_page_array *array)
+{
+	for (int i = 0; i < array->nents; i++)
+		tdx_clflush_page(array->pages[array->offset + i]);
+}
+
+static int tdx_ext_mem_add(struct tdx_page_array *mempool)
+{
+	struct tdx_module_args args = {
+		.rcx = hpa_list_info_assign_raw(mempool),
+	};
+	u64 r;
+
+	tdx_clflush_page_array(mempool);
+
+	do {
+		r = seamcall_ret(TDH_EXT_MEM_ADD, &args);
+		cond_resched();
+	} while (r == TDX_INTERRUPTED_RESUMABLE);
+
+	if (r != TDX_SUCCESS)
+		return -EFAULT;
+
+	return 0;
+}
+
+static struct tdx_page_array *tdx_ext_mempool_setup(void)
+{
+	unsigned int nr_pages, nents, offset = 0;
+	int ret;
+
+	nr_pages = tdx_sysinfo.ext.memory_pool_required_pages;
+	if (!nr_pages)
+		return NULL;
+
+	struct tdx_page_array *mempool __free(tdx_page_array_free) =
+		tdx_page_array_alloc(nr_pages);
+	if (!mempool)
+		return ERR_PTR(-ENOMEM);
+
+	while (1) {
+		nents = tdx_page_array_fill_root(mempool, offset);
+		if (!nents)
+			break;
+
+		ret = tdx_ext_mem_add(mempool);
+		if (ret)
+			return ERR_PTR(ret);
+
+		offset += nents;
+	}
+
+	return no_free_ptr(mempool);
+}
+
+static int init_tdx_ext(void)
+{
+	int ret;
+
+	if (!(tdx_sysinfo.features.tdx_features0 & TDX_FEATURES0_EXT))
+		return -EOPNOTSUPP;
+
+	struct tdx_page_array *mempool __free(tdx_ext_mempool_free) =
+		tdx_ext_mempool_setup();
+	/* Return NULL is OK, means no need to setup mempool */
+	if (IS_ERR(mempool))
+		return PTR_ERR(mempool);
+
+	ret = enable_tdx_ext();
+	if (ret)
+		return ret;
+
+	/* Extension memory is never reclaimed once assigned */
+	if (mempool)
+		tdx_page_array_ctrl_leak(no_free_ptr(mempool));
+
+	return 0;
+}
+
+/**
+ * tdx_enable_ext - Enable TDX module extensions.
+ *
+ * This function can be called in parallel by multiple callers.
+ *
+ * Return 0 if TDX module extension is enabled successfully, otherwise error.
+ */
+int tdx_enable_ext(void)
+{
+	int ret;
+
+	if (!tdx_module_initialized)
+		return -ENOENT;
+
+	guard(mutex)(&tdx_module_ext_lock);
+
+	if (tdx_module_ext_initialized)
+		return 0;
+
+	ret = init_tdx_ext();
+	if (ret) {
+		pr_debug("module extension initialization failed (%d)\n", ret);
+		return ret;
+	}
+
+	pr_debug("module extension initialized\n");
+	tdx_module_ext_initialized = true;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tdx_enable_ext);
+
 static bool is_pamt_page(unsigned long phys)
 {
 	struct tdmr_info_list *tdmr_list = &tdx_tdmr_list;
@@ -1769,17 +1938,6 @@ static inline u64 tdx_tdr_pa(struct tdx_td *td)
 	return page_to_phys(td->tdr_page);
 }
 
-/*
- * The TDX module exposes a CLFLUSH_BEFORE_ALLOC bit to specify whether
- * a CLFLUSH of pages is required before handing them to the TDX module.
- * Be conservative and make the code simpler by doing the CLFLUSH
- * unconditionally.
- */
-static void tdx_clflush_page(struct page *page)
-{
-	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
-}
-
 noinstr u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *args)
 {
 	args->rcx = td->tdvpr_pa;
diff --git a/drivers/virt/coco/tdx-host/tdx-host.c b/drivers/virt/coco/tdx-host/tdx-host.c
index 6f21bb2dbeb9..982c928fae86 100644
--- a/drivers/virt/coco/tdx-host/tdx-host.c
+++ b/drivers/virt/coco/tdx-host/tdx-host.c
@@ -125,6 +125,7 @@ static void unregister_link_tsm(void *link)
 static int __maybe_unused tdx_connect_init(struct device *dev)
 {
 	struct tsm_dev *link;
+	int ret;
 
 	if (!IS_ENABLED(CONFIG_TDX_CONNECT))
 		return 0;
@@ -146,6 +147,10 @@ static int __maybe_unused tdx_connect_init(struct device *dev)
 	if (!(tdx_sysinfo->features.tdx_features0 & TDX_FEATURES0_TDXCONNECT))
 		return 0;
 
+	ret = tdx_enable_ext();
+	if (ret)
+		return dev_err_probe(dev, ret, "Enable extension failed\n");
+
 	link = tsm_register(dev, &tdx_link_ops);
 	if (IS_ERR(link))
 		return dev_err_probe(dev, PTR_ERR(link),
-- 
2.25.1


