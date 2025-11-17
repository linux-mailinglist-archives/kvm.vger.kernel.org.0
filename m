Return-Path: <kvm+bounces-63321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 105EFC621FA
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 03:41:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 442264E7004
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 02:41:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4BA3262D27;
	Mon, 17 Nov 2025 02:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XPh+ZzNw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAE924503C;
	Mon, 17 Nov 2025 02:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763347152; cv=none; b=FvEON6io4Z8xu+0QyvoAP3NGLScd7YIpUfLpfvAL6tkoYBgeH8DzxFYNEffVGQ1mS5kk2gwAnFCxFVcwnlsFTduAnXugbmKKzn1BsT94HbTANY9Me6fXB/KAXAd8udz1gbI7wWEdp0DCknoiL+nhzq/YDJudKIIHD56ExHVAC6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763347152; c=relaxed/simple;
	bh=CjNiG+QfQrr65X7Bl7i56bGXYQ8Rfu/aIU1ALU9M9b4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AGbfjDusrekPGfTcfWFLqDe8QaDUnJq0q1me5aBhvK+U4HGnBT84S3DJ9yk9QtfK/TtFfj6Ho2rcOynkiX+n7TfnASrdzRb/01K6tS3DDMmgU1kz/jGn7Pl7bCX7zuYZ4nt0/5p0bvL9Vcx/tBiImvTVHWdiE1on6z4cdObX90s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XPh+ZzNw; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763347151; x=1794883151;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CjNiG+QfQrr65X7Bl7i56bGXYQ8Rfu/aIU1ALU9M9b4=;
  b=XPh+ZzNwOQMEB230DpNWgVDZJkseZArYEeMsVT+Me/BvuDq49mT7H1ig
   57ah3ftzy0GsFPcdRIFlkgFWJxNnIGrv6paTMYbbz4EBzHyqOfv+6Z5Tn
   irbT/gzDOYLe/RGPqaeTcrCe3Kbq33IbVIIFM1VjkdZ+of6OIZN09DVWq
   5KOsUz4QcybwCCKCVRcV3al9MGjv/DEgFtIJ+oOUIH7t9fyUCfRgSFHYh
   UG8XUS2/ZDDMgynTXW813oUOXpUQKp7okM65tqWL7oZXxYJMk8pREgLWj
   i9RD8IuOgxQD48aBvZ9a/WVPm7c2fzFdiGhrx12O+KabxzfmDt5oy5TCQ
   A==;
X-CSE-ConnectionGUID: hlkEYNLaTOuXMYTKAeYxYw==
X-CSE-MsgGUID: W1RKw7dGSEi9z/dj7iSJCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="82729602"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="82729602"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 18:39:11 -0800
X-CSE-ConnectionGUID: mNRc3k4+SiSltkOLOEo+GA==
X-CSE-MsgGUID: k7j8EgHOTJy/1YkxHJEwjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="227658496"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 16 Nov 2025 18:39:07 -0800
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
Subject: [PATCH v1 21/26] x86/virt/tdx: Add SEAMCALL wrappers for SPDM management
Date: Mon, 17 Nov 2025 10:23:05 +0800
Message-Id: <20251117022311.2443900-22-yilun.xu@linux.intel.com>
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

Add several SEAMCALL wrappers for SPDM management. TDX Module requires
HPA_ARRAY_T structure as input/output parameters for these SEAMCALLs.
So use tdx_page_array as for these wrappers.

- TDH.SPDM.CREATE creates SPDM session metadata buffers for TDX Module.
- TDH.SPDM.DELETE destroys SPDM session metadata and returns these
  buffers to host, after checking no reference attached to the metadata.
- TDH.SPDM.CONNECT establishes a new SPDM session with the device.
- TDH.SPDM.DISCONNECT tears down the SPDM session with the device.
- TDH.SPDM.MNG supports three SPDM runtime operations: HEARTBEAT,
  KEY_UPDATE and DEV_INFO_RECOLLECTION.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Co-developed-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/tdx.h  |  13 ++++
 arch/x86/virt/vmx/tdx/tdx.h |   5 ++
 arch/x86/virt/vmx/tdx/tdx.c | 114 +++++++++++++++++++++++++++++++++++-
 3 files changed, 130 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index efc4200b9931..8e6da080f4e2 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -227,6 +227,19 @@ u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
 u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page);
 u64 tdh_iommu_setup(u64 vtbar, struct tdx_page_array *iommu_mt, u64 *iommu_id);
 u64 tdh_iommu_clear(u64 iommu_id, struct tdx_page_array *iommu_mt);
+u64 tdh_spdm_create(u64 func_id, struct tdx_page_array *spdm_mt, u64 *spdm_id);
+u64 tdh_spdm_delete(u64 spdm_id, struct tdx_page_array *spdm_mt,
+		    unsigned int *nr_released, u64 *released_hpa);
+u64 tdh_exec_spdm_connect(u64 spdm_id, struct page *spdm_conf,
+			  struct page *spdm_rsp, struct page *spdm_req,
+			  struct tdx_page_array *spdm_out,
+			  u64 *spdm_req_or_out_len);
+u64 tdh_exec_spdm_disconnect(u64 spdm_id, struct page *spdm_rsp,
+			     struct page *spdm_req, u64 *spdm_req_len);
+u64 tdh_exec_spdm_mng(u64 spdm_id, u64 spdm_op, struct page *spdm_param,
+		      struct page *spdm_rsp, struct page *spdm_req,
+		      struct tdx_page_array *spdm_out,
+		      u64 *spdm_req_or_out_len);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_enable_ext(void) { return -ENODEV; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 7c653604271b..f68b9d3abfe1 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -50,6 +50,11 @@
 #define TDH_EXT_MEM_ADD			61
 #define TDH_IOMMU_SETUP			128
 #define TDH_IOMMU_CLEAR			129
+#define TDH_SPDM_CREATE			130
+#define TDH_SPDM_DELETE			131
+#define TDH_SPDM_CONNECT		142
+#define TDH_SPDM_DISCONNECT		143
+#define TDH_SPDM_MNG			144
 
 /*
  * SEAMCALL leaf:
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index fe3b43c86314..a0ba4d13e340 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -595,7 +595,7 @@ static u64 hpa_list_info_assign_raw(struct tdx_page_array *array)
 #define HPA_ARRAY_T_PFN		GENMASK_U64(51, 12)
 #define HPA_ARRAY_T_SIZE	GENMASK_U64(63, 55)
 
-static u64 __maybe_unused hpa_array_t_assign_raw(struct tdx_page_array *array)
+static u64 hpa_array_t_assign_raw(struct tdx_page_array *array)
 {
 	struct page *page;
 
@@ -608,7 +608,7 @@ static u64 __maybe_unused hpa_array_t_assign_raw(struct tdx_page_array *array)
 	       FIELD_PREP(HPA_ARRAY_T_SIZE, array->nents - 1);
 }
 
-static u64 __maybe_unused hpa_array_t_release_raw(struct tdx_page_array *array)
+static u64 hpa_array_t_release_raw(struct tdx_page_array *array)
 {
 	if (array->nents == 1)
 		return 0;
@@ -2026,6 +2026,15 @@ static u64 __seamcall_ir_resched(sc_func_t sc_func, u64 fn,
 #define seamcall_ret_ir_resched(fn, args)	\
 	__seamcall_ir_resched(__seamcall_ret, fn, args)
 
+/*
+ * seamcall_ret_ir_exec() aliases seamcall_ret_ir_resched() for
+ * documentation purposes. It documents the TDX Module extension
+ * seamcalls that are long running / hard-irq preemptible flows that
+ * generate events. The calls using seamcall_ret_ir_resched() are long
+ * running flows, that periodically yield.
+ */
+#define seamcall_ret_ir_exec seamcall_ret_ir_resched
+
 noinstr u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *args)
 {
 	args->rcx = td->tdvpr_pa;
@@ -2425,3 +2434,104 @@ u64 tdh_iommu_clear(u64 iommu_id, struct tdx_page_array *iommu_mt)
 	return seamcall_ret_ir_resched(TDH_IOMMU_CLEAR, &args);
 }
 EXPORT_SYMBOL_FOR_MODULES(tdh_iommu_clear, "tdx-host");
+
+u64 tdh_spdm_create(u64 func_id, struct tdx_page_array *spdm_mt, u64 *spdm_id)
+{
+	struct tdx_module_args args = {
+		.rcx = func_id,
+		.rdx = hpa_array_t_assign_raw(spdm_mt)
+	};
+	u64 r;
+
+	tdx_clflush_page_array(spdm_mt);
+
+	r = seamcall_ret(TDH_SPDM_CREATE, &args);
+
+	*spdm_id = args.rcx;
+
+	return r;
+}
+EXPORT_SYMBOL_FOR_MODULES(tdh_spdm_create, "tdx-host");
+
+u64 tdh_spdm_delete(u64 spdm_id, struct tdx_page_array *spdm_mt,
+		    unsigned int *nr_released, u64 *released_hpa)
+{
+	struct tdx_module_args args = {
+		.rcx = spdm_id,
+		.rdx = hpa_array_t_release_raw(spdm_mt),
+	};
+	u64 r;
+
+	r = seamcall_ret(TDH_SPDM_DELETE, &args);
+	if (r < 0)
+		return r;
+
+	*nr_released = FIELD_GET(HPA_ARRAY_T_SIZE, args.rcx) + 1;
+	*released_hpa = FIELD_GET(HPA_ARRAY_T_PFN, args.rcx) << PAGE_SHIFT;
+
+	return r;
+}
+EXPORT_SYMBOL_FOR_MODULES(tdh_spdm_delete, "tdx-host");
+
+u64 tdh_exec_spdm_connect(u64 spdm_id, struct page *spdm_conf,
+			  struct page *spdm_rsp, struct page *spdm_req,
+			  struct tdx_page_array *spdm_out,
+			  u64 *spdm_req_or_out_len)
+{
+	struct tdx_module_args args = {
+		.rcx = spdm_id,
+		.rdx = page_to_phys(spdm_conf),
+		.r8 = page_to_phys(spdm_rsp),
+		.r9 = page_to_phys(spdm_req),
+		.r10 = hpa_array_t_assign_raw(spdm_out),
+	};
+	u64 r;
+
+	r = seamcall_ret_ir_exec(TDH_SPDM_CONNECT, &args);
+
+	*spdm_req_or_out_len = args.rcx;
+
+	return r;
+}
+EXPORT_SYMBOL_FOR_MODULES(tdh_exec_spdm_connect, "tdx-host");
+
+u64 tdh_exec_spdm_disconnect(u64 spdm_id, struct page *spdm_rsp,
+			     struct page *spdm_req, u64 *spdm_req_len)
+{
+	struct tdx_module_args args = {
+		.rcx = spdm_id,
+		.rdx = page_to_phys(spdm_rsp),
+		.r8 = page_to_phys(spdm_req),
+	};
+	u64 r;
+
+	r = seamcall_ret_ir_exec(TDH_SPDM_DISCONNECT, &args);
+
+	*spdm_req_len = args.rcx;
+
+	return r;
+}
+EXPORT_SYMBOL_FOR_MODULES(tdh_exec_spdm_disconnect, "tdx-host");
+
+u64 tdh_exec_spdm_mng(u64 spdm_id, u64 spdm_op, struct page *spdm_param,
+		      struct page *spdm_rsp, struct page *spdm_req,
+		      struct tdx_page_array *spdm_out,
+		      u64 *spdm_req_or_out_len)
+{
+	struct tdx_module_args args = {
+		.rcx = spdm_id,
+		.rdx = spdm_op,
+		.r8 = spdm_param ? page_to_phys(spdm_param) : -1,
+		.r9 = page_to_phys(spdm_rsp),
+		.r10 = page_to_phys(spdm_req),
+		.r11 = spdm_out ? hpa_array_t_assign_raw(spdm_out) : -1,
+	};
+	u64 r;
+
+	r = seamcall_ret_ir_exec(TDH_SPDM_MNG, &args);
+
+	*spdm_req_or_out_len = args.rcx;
+
+	return r;
+}
+EXPORT_SYMBOL_FOR_MODULES(tdh_exec_spdm_mng, "tdx-host");
-- 
2.25.1


