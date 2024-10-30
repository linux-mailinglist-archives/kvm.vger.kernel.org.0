Return-Path: <kvm+bounces-30079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEE5F9B6C8B
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:02:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1FE38B224B3
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:02:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D9AB21500A;
	Wed, 30 Oct 2024 19:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QoRMtM2f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11E21D0DF6;
	Wed, 30 Oct 2024 19:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314859; cv=none; b=FlsiGc0mcUPvT92K+ZWe7aecgXc1f7eeZ/JfoR1TXv2Gjub4u+vz60wofvvvFAuni7mVSAQALjxXltH6fG0vXkc/iiY7v8mFkMAJNOl8fCF/G1UEaAhC9xS7aOG10a+AZLS+7noWS5oipKLCGMeURbm/YVDqJsdk3d/au9mZMig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314859; c=relaxed/simple;
	bh=k+6bY16Z64yOlLYbI2NwSfZnYaym8nehqj2OcKUSP7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EO7qrnWoGmQgBRtSL9l0JVp6IADNP7TpeChpBEpRFVXL6oRtOwezyIlm9KLbSk7IxPQn4hedNpRaY+VtydCZ/Dxue2167Qmu2+uobUbwiGOMIiCgy/fD328FWfO/Q/Qih/sHK5KNGTt+AuBMBBHcxkwamPGoNg8zZVTdXzhnVNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QoRMtM2f; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730314857; x=1761850857;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k+6bY16Z64yOlLYbI2NwSfZnYaym8nehqj2OcKUSP7w=;
  b=QoRMtM2fXXa9QLTaKfZYmBssGSTGm+yK6tHLayW6fiaRc1uGyFElOigX
   HfnggF3SaQAQZ9BxsszMbla4diD6aRzWg1/sB3JYuOMTRmE+vhARWHAfs
   PempsA31NW12ZFojMz+5JtyQk3gQC3miJkQDVKWTASp8kR5GONoKXq/VT
   GGcGGKPyYYtCavbFdlKJyOaP86ImENMc3T6iuwEIMUYIO1nxU4zRgBErt
   LWpCoiFxPSY2C2Xr3Wa/NTLMOPyl5EPnDN3MR4ORtVdzvrJ7UN7XyyUSC
   voCKtWelD20IH5ot1DaHo0juYw25U8JBpFU6IT6zigfxAKyupY9LQSB8V
   g==;
X-CSE-ConnectionGUID: zp4Xw3fkTIK8GWKDITxmiw==
X-CSE-MsgGUID: JliSkwCQRn6Kon9bAvn5wA==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17678709"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="17678709"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:00:55 -0700
X-CSE-ConnectionGUID: eWThE8BCSKmoqvZJ8KYh9A==
X-CSE-MsgGUID: 50ZX0VBMRJuQWM7C+gcjRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82499303"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.186])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:00:54 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com,
	isaku.yamahata@gmail.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	reinette.chatre@intel.com
Subject: [PATCH v2 01/25] x86/virt/tdx: Share the global metadata structure for KVM to use
Date: Wed, 30 Oct 2024 12:00:14 -0700
Message-ID: <20241030190039.77971-2-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kai Huang <kai.huang@intel.com>

The TDX host tracks all global metadata fields in 'struct tdx_sys_info'.
For now they are only used by module initialization and are not shared
to other kernel components.

Future changes to support KVM TDX will need to read more global metadata
fields, e.g., those in "TD Control Structures" and "TD Configurability".
In the longer term, other TDX features like TDX Connect (which supports
assigning trusted devices to TDX guests) will also require other kernel
components such as pci/vt-d to access global metadata.

To meet all those requirements, the idea is the TDX host core-kernel to
to provide a centralized, canonical, and read-only structure for the
global metadata that comes out from the TDX module for all kernel
components to use.

To achieve "read-only", the ideal way is to annotate the whole structure
with __ro_after_init.  However currently all global metadata fields are
read by tdx_enable(), which could be called at any time at runtime thus
isn't annotated with __init.

The __ro_after_init can be done eventually, but it can only be done
after moving VMXON out of KVM to the core-kernel: after that we can
read all metadata during kernel boot (thus __ro_after_init), but
doesn't necessarily have to do it in tdx_enable().

For now, add a helper function to return a 'const struct tdx_sys_info *'
and export it for KVM to use.

Note, KVM doesn't need to access all global metadata for TDX, thus
exporting the entire 'struct tdx_sys_info' is overkill.  Another option
is to export sub-structures on demand.  But this will result in more
exports.  Given the export is done via a const pointer thus the other
in-kernel TDX won't be able to write to global metadata, simply export
all global metadata fields in one function.

The auto-generated 'tdx_global_metadata.h' contains declarations of
'struct tdx_sys_info' and its sub-structures.  Move it to
arch/x86/include/asm/ and include it to <asm/tdx.h> to expose those
structures.

Include 'tdx_global_metadata.h' inside the '#ifndef __ASSEMBLY__' since
otherwise there will be build warning due to <asm/tdx.h> is also
included by assembly.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
uAPI breakout v2:
 - New patch
---
 arch/x86/include/asm/tdx.h                    |  3 ++
 .../tdx => include/asm}/tdx_global_metadata.h |  0
 arch/x86/virt/vmx/tdx/tdx.c                   | 28 +++++++++++++++----
 arch/x86/virt/vmx/tdx/tdx.h                   |  1 -
 4 files changed, 25 insertions(+), 7 deletions(-)
 rename arch/x86/{virt/vmx/tdx => include/asm}/tdx_global_metadata.h (100%)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index eba178996d84..b9758369d82c 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -33,6 +33,7 @@
 #ifndef __ASSEMBLY__
 
 #include <uapi/asm/mce.h>
+#include "tdx_global_metadata.h"
 
 /*
  * Used by the #VE exception handler to gather the #VE exception
@@ -116,11 +117,13 @@ static inline u64 sc_retry(sc_func_t func, u64 fn,
 int tdx_cpu_enable(void);
 int tdx_enable(void);
 const char *tdx_dump_mce_info(struct mce *m);
+const struct tdx_sys_info *tdx_get_sysinfo(void);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
 static inline int tdx_enable(void)  { return -ENODEV; }
 static inline const char *tdx_dump_mce_info(struct mce *m) { return NULL; }
+static inline const struct tdx_sys_info *tdx_get_sysinfo(void) { return NULL; }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.h b/arch/x86/include/asm/tdx_global_metadata.h
similarity index 100%
rename from arch/x86/virt/vmx/tdx/tdx_global_metadata.h
rename to arch/x86/include/asm/tdx_global_metadata.h
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 6982e100536d..7589c75eaa6c 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -52,6 +52,8 @@ static DEFINE_MUTEX(tdx_module_lock);
 /* All TDX-usable memory regions.  Protected by mem_hotplug_lock. */
 static LIST_HEAD(tdx_memlist);
 
+static struct tdx_sys_info tdx_sysinfo;
+
 typedef void (*sc_err_func_t)(u64 fn, u64 err, struct tdx_module_args *args);
 
 static inline void seamcall_err(u64 fn, u64 err, struct tdx_module_args *args)
@@ -1132,15 +1134,14 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
 
 static int init_tdx_module(void)
 {
-	struct tdx_sys_info sysinfo;
 	int ret;
 
-	ret = init_tdx_sys_info(&sysinfo);
+	ret = init_tdx_sys_info(&tdx_sysinfo);
 	if (ret)
 		return ret;
 
 	/* Check whether the kernel can support this module */
-	ret = check_features(&sysinfo);
+	ret = check_features(&tdx_sysinfo);
 	if (ret)
 		return ret;
 
@@ -1161,13 +1162,14 @@ static int init_tdx_module(void)
 		goto out_put_tdxmem;
 
 	/* Allocate enough space for constructing TDMRs */
-	ret = alloc_tdmr_list(&tdx_tdmr_list, &sysinfo.tdmr);
+	ret = alloc_tdmr_list(&tdx_tdmr_list, &tdx_sysinfo.tdmr);
 	if (ret)
 		goto err_free_tdxmem;
 
 	/* Cover all TDX-usable memory regions in TDMRs */
-	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &sysinfo.tdmr,
-			&sysinfo.cmr);
+	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list,
+			      &tdx_sysinfo.tdmr, &tdx_sysinfo.cmr);
+
 	if (ret)
 		goto err_free_tdmrs;
 
@@ -1529,3 +1531,17 @@ void __init tdx_init(void)
 
 	check_tdx_erratum();
 }
+
+const struct tdx_sys_info *tdx_get_sysinfo(void)
+{
+	const struct tdx_sys_info *p = NULL;
+
+	/* Make sure all fields in @tdx_sysinfo have been populated */
+	mutex_lock(&tdx_module_lock);
+	if (tdx_module_status == TDX_MODULE_INITIALIZED)
+		p = (const struct tdx_sys_info *)&tdx_sysinfo;
+	mutex_unlock(&tdx_module_lock);
+
+	return p;
+}
+EXPORT_SYMBOL_GPL(tdx_get_sysinfo);
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index c8be00f6b15a..9b708a8fb568 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -6,7 +6,6 @@
 #include <linux/compiler_attributes.h>
 #include <linux/stddef.h>
 #include <linux/bits.h>
-#include "tdx_global_metadata.h"
 
 /*
  * This file contains both macros and data structures defined by the TDX
-- 
2.47.0


