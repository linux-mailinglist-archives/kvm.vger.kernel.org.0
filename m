Return-Path: <kvm+bounces-47544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 85232AC2042
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 11:56:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37679504D17
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 09:56:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED06223AE7C;
	Fri, 23 May 2025 09:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iZouhb1p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD24227E90;
	Fri, 23 May 2025 09:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747994032; cv=none; b=Q1aYO0VxmmXqOIAs+JNmUTEkkO9IrESq2VS5Y1ZBQT/yLCZjvvd9JNElB67TK0aXDCwk7VStqcK2zFzjP/SPtPID4WOMH1H4eXomloyV6TpS6dzDWe5vP8b7NZZmNGIz+AdIoGdO1c1HtWlF8O18kSJwLpHnSa5sHe12gWRZawI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747994032; c=relaxed/simple;
	bh=Spqzi2KhiF3DQTRtzBKxSzFtvQ3Feg6dLSx3tvfEMAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbtvTnhZfVIklVJuw5dJLnC8n+e3rY/W5plqZyYGPSrk40Los5UxUbY1Rjl/XHnBZWcAu9nyCyRL7POqyQZJjeA4OXZ3h9O0DE7F10CzbJhr3LKwf953C2WGr9jLab5XcYxRXQ3LnT9JILqWwS0PzVwuVVUdgusZJ2PJYuQC3Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iZouhb1p; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747994030; x=1779530030;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Spqzi2KhiF3DQTRtzBKxSzFtvQ3Feg6dLSx3tvfEMAI=;
  b=iZouhb1p3fvWViX0hx0mO/cGr9txaSqFXoFuLSeH7OUz6K1GwaQMvrqX
   Z/t8rqzKo1SzRspBHxp9VqEZLkAwxfiitUNC91tgCaLLSCSddJVdEdkur
   Pa1Ne7DgAoxKoiflfKe7QF1r33SBO82XTpiFxDOY+VurLkg2XWs2EGX1h
   qqiSrQ2ctssk1o8I0NQGWFEGADP0yH+EX5MWaI1plP/x26iesTPinEv3e
   6RzbQ0YQmp+cVjx1g7gK6yPvq7L+v6pvumCh2tlg9DOAzgyfz5o+l4/L0
   /WlZMDiW51ecl4it3dxjMETTVhyr4blQfnJSEknZDrczgTcndshx1M5F7
   g==;
X-CSE-ConnectionGUID: m7RbaU72SmCtLcYHWqjUDg==
X-CSE-MsgGUID: MXvupeUZTziGG6vWWgzdww==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="75444170"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="75444170"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:50 -0700
X-CSE-ConnectionGUID: FkLnFggBRtKp8ClMlrJKdg==
X-CSE-MsgGUID: fEsTitUIQwuXbeMR3EFv5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="164315066"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:49 -0700
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	x86@kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	eddie.dong@intel.com,
	kirill.shutemov@intel.com,
	dave.hansen@intel.com,
	dan.j.williams@intel.com,
	kai.huang@intel.com,
	isaku.yamahata@intel.com,
	elena.reshetova@intel.com,
	rick.p.edgecombe@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 09/20] x86/virt/seamldr: Allocate and populate a module update request
Date: Fri, 23 May 2025 02:52:32 -0700
Message-ID: <20250523095322.88774-10-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250523095322.88774-1-chao.gao@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allocate and populate a module update request, i.e., struct seamldr_params,
as defined in "SEAM Loader (SEAMLDR) Interface Specification" [1],
Revision 343755-004, Section 3.2.

struct seamldr_params includes a module binary, a sigstruct file, and an
update scenario. Parse the bitstream format, as defined by Intel, to
extract the binary and the sigstruct.

Currently, only the "UPDATE" scenario is supported.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Link: https://cdrdv2.intel.com/v1/dl/getContent/733584 [1]
---
 arch/x86/virt/vmx/tdx/seamldr.c | 145 +++++++++++++++++++++++++++++++-
 1 file changed, 144 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index da862e71ebce..cdf85dff6d69 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -11,6 +11,8 @@
 #include <linux/firmware.h>
 #include <linux/gfp.h>
 #include <linux/kobject.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
 #include <linux/sysfs.h>
 
 #include "tdx.h"
@@ -41,6 +43,26 @@ struct tdx_status {
 	DECLARE_BITMAP(fw_state, TDX_FW_STATE_BITS);
 };
 
+/* SEAMLDR can accept up to 496 4KB pages for TDX module binary */
+#define SEAMLDR_MAX_NR_MODULE_4KB_PAGES	496
+
+/* scenario field in struct seamldr_params */
+#define SEAMLDR_SCENARIO_UPDATE		1
+
+/*
+ * Passed to P-SEAMLDR to describe information about the TDX module to install.
+ * Defined in "SEAM Loader (SEAMLDR) Interface Specification", Revision
+ * 343755-003, Section 3.2.
+ */
+struct seamldr_params {
+	u32	version;
+	u32	scenario;
+	u64	sigstruct_pa;
+	u8	reserved[104];
+	u64	num_module_pages;
+	u64	mod_pages_pa_list[SEAMLDR_MAX_NR_MODULE_4KB_PAGES];
+} __packed;
+
 struct fw_upload *tdx_fwl;
 static struct tdx_status tdx_status;
 static struct seamldr_info seamldr_info __aligned(256);
@@ -113,9 +135,130 @@ int get_seamldr_info(void)
 	return seamldr_call(P_SEAMLDR_INFO, &args);
 }
 
+static void free_seamldr_params(struct seamldr_params *params)
+{
+	free_page((unsigned long)params);
+}
+
+/* Allocate and populate a seamldr_params */
+static struct seamldr_params *alloc_seamldr_params(const void *module, int module_size,
+						   const void *sig, int sig_size)
+{
+	struct seamldr_params *params;
+	const u8 *ptr;
+	int i;
+
+	BUILD_BUG_ON(sizeof(struct seamldr_params) != SZ_4K);
+	if (module_size > SEAMLDR_MAX_NR_MODULE_4KB_PAGES * SZ_4K)
+		return ERR_PTR(-EINVAL);
+
+	/* current seamldr_params accepts one 4KB-page for sigstruct */
+	if (sig_size != SZ_4K)
+		return ERR_PTR(-EINVAL);
+
+	params = (struct seamldr_params *)get_zeroed_page(GFP_KERNEL);
+	if (!params)
+		return ERR_PTR(-ENOMEM);
+
+	params->scenario = SEAMLDR_SCENARIO_UPDATE;
+	params->sigstruct_pa = (vmalloc_to_pfn(sig) << PAGE_SHIFT) +
+			       ((unsigned long)sig & ~PAGE_MASK);
+	params->num_module_pages = DIV_ROUND_UP(module_size, SZ_4K);
+
+	ptr = module;
+	for (i = 0; i < params->num_module_pages; i++) {
+		params->mod_pages_pa_list[i] = (vmalloc_to_pfn(ptr) << PAGE_SHIFT) +
+					       ((unsigned long)ptr & ~PAGE_MASK);
+		ptr += SZ_4K;
+	}
+
+	return params;
+}
+
+struct tdx_blob {
+	u16	version;
+	u16	checksum;
+	u32	offset_of_module;
+	u8	signature[8];
+	u32	len;
+	u32	resv1;
+	u64	resv2[509];
+	u8	data[];
+} __packed;
+
+/* Verify that the checksum of the entire blob is zero */
+static bool verify_checksum(const struct tdx_blob *blob)
+{
+	u32 size = blob->len;
+	u16 checksum = 0;
+	const u16 *p;
+	int i;
+
+	/* Handle the last byte if the size is odd */
+	if (size % 2) {
+		checksum += *((const u8 *)blob + size - 1);
+		size--;
+	}
+
+	p = (const u16 *)blob;
+	for (i = 0; i < size; i += 2) {
+		checksum += *p;
+		p++;
+	}
+
+	return !checksum;
+}
+
+static struct seamldr_params *init_seamldr_params(const u8 *data, u32 size)
+{
+	const struct tdx_blob *blob = (const void *)data;
+	const void *sig, *module;
+	int module_size, sig_size;
+
+	/* Split the given blob into a sigstruct and a module */
+	sig = blob->data;
+	sig_size = blob->offset_of_module - sizeof(struct tdx_blob);
+	module = data + blob->offset_of_module;
+	module_size = size - blob->offset_of_module;
+
+	if (sig_size <= 0 || module_size <= 0 || blob->len != size)
+		return ERR_PTR(-EINVAL);
+
+	if (memcmp(blob->signature, "TDX-BLOB", 8)) {
+		pr_err("invalid signature\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (!verify_checksum(blob)) {
+		pr_err("invalid checksum\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	return alloc_seamldr_params(module, module_size, sig, sig_size);
+}
+
+/*
+ * Temporary flag to guard TD-Preserving updates. This will be removed once
+ * all necessary components for its support are integrated.
+ */
+static bool td_preserving_ready;
+
+DEFINE_FREE(free_seamldr_params, struct seamldr_params *,
+	    if (!IS_ERR_OR_NULL(_T)) free_seamldr_params(_T))
+
 static int seamldr_install_module(const u8 *data, u32 size)
 {
-	return -EOPNOTSUPP;
+	if (!td_preserving_ready)
+		return -EOPNOTSUPP;
+
+	struct seamldr_params *params __free(free_seamldr_params) =
+						init_seamldr_params(data, size);
+	if (IS_ERR(params))
+		return PTR_ERR(params);
+
+	/* TODO: Install and initialize the new TDX module */
+
+	return 0;
 }
 
 static enum fw_upload_err tdx_fw_prepare(struct fw_upload *fwl,
-- 
2.47.1


