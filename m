Return-Path: <kvm+bounces-31966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3174D9CF5F9
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 21:26:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C64EB28D68D
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 20:26:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B08F1E6DFC;
	Fri, 15 Nov 2024 20:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VxiHmVJD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14551E3769;
	Fri, 15 Nov 2024 20:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731702043; cv=none; b=p56dBKmALDZFc5mteO6xPfLb3RxfNzH1oE/LhFTF6uKTrCI0ZfCAAo/cKt81ilpRRk5/vw1+wIfgKUiSfNBIoM5KLzBcmQITRAJ7SlwLEyXT1U4CHV7e823fCu/9km+3eT5y4xJq5aBYKQ8h1o21XQW+MPIzoWwvxFTzt2s+nOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731702043; c=relaxed/simple;
	bh=wMjPzp3QUVhWOaHltapTeuIa/kFRljLy6ptsM08qBv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=su8pZ2VBr3THExQfN28+O/zUvfvPdHG4NtQD1HvN6vdJoJiUzq0BCfUQ51xTq0GlJq9ueckj0dgq4UTi31KQj1Ak+qHiUJUTedVMQBPkdr1rUZ4f2fphE/bmFPfOSMnRGKlF+RcGzPQt15PIDmrnX9CjwmqzG2q2F0IStRSKUDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VxiHmVJD; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731702042; x=1763238042;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wMjPzp3QUVhWOaHltapTeuIa/kFRljLy6ptsM08qBv8=;
  b=VxiHmVJDef/CqKc8dAZWXbswhk+Xjr32DBVfKJKE94bnjqrBUbPPhBeY
   LsVRDlpoYOgTr4teGFMjndwu1LgLQ6Aw3la5UzyOO9eWpI0TBa7HwLSfA
   6q7Ug9ZYc1cONQGVmoRqP1tbdFK79knmw1w0L4VR0OJJVbAN2o1Tt6Oia
   Yha0RbhaU6S/z4sJDBwUnW8OqmTzDbwnZm6ME1aT7YoudyzxfWjca1l4C
   VV+2ZcDRrOsCm1sdEs2g/mAunfJBDP7EpkjllqRmlmYdaiZScqZ11sCvp
   8jvHzcBnazoAaghkwBLhP8XKKKc1yUpSYN6fXWe9vt7ZMJdP6+vTt55e2
   g==;
X-CSE-ConnectionGUID: cgI+B2WkQ+uGBzP2TGzTmA==
X-CSE-MsgGUID: JQ3ptZWiR2W7DA3OXaN8Gw==
X-IronPort-AV: E=McAfee;i="6700,10204,11257"; a="54228333"
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="54228333"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 12:20:41 -0800
X-CSE-ConnectionGUID: 0/4o0IrKS+C2Bubl1YzIiA==
X-CSE-MsgGUID: ZWJy2gddR5WyhKly8HJw8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="93599397"
Received: from jairdeje-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.173])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 12:20:40 -0800
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: kvm@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	dave.hansen@intel.com
Cc: isaku.yamahata@gmail.com,
	kai.huang@intel.com,
	linux-kernel@vger.kernel.org,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	yan.y.zhao@intel.com,
	rick.p.edgecombe@intel.com,
	x86@kernel.org,
	adrian.hunter@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@intel.com>
Subject: [RFC PATCH 2/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX TD creation
Date: Fri, 15 Nov 2024 12:20:23 -0800
Message-ID: <20241115202028.1585487-3-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115202028.1585487-1-rick.p.edgecombe@intel.com>
References: <20241115202028.1585487-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Intel TDX protects guest VMs from malicious hosts and certain physical
attacks. It defines various control structures that hold state for things
like TDs or vCPUs. These control structures are stored in pages given to
the TDX module and encrypted with either the global KeyID or the guest
KeyIDs.

To manipulate these control structures the TDX module defines a few
SEAMCALLs. KVM will use these during the process of creating a TD as
follows:

1) Allocate a unique TDX KeyID for a new guest.

1) Call TDH.MNG.CREATE to create a "TD Root" (TDR) page, together with
   the new allocated KeyID. Unlike the rest of the TDX guest, the TDR
   page is crypto-protected by the 'global KeyID'.

2) Call the previously added TDH.MNG.KEY.CONFIG on each package to
   configure the KeyID for the guest. After this step, the KeyID to
   protect the guest is ready and the rest of the guest will be protected
   by this KeyID.

3) Call TDH.MNG.ADDCX to add TD Control Structure (TDCS) pages.

4) Call TDH.MNG.INIT to initialize the TDCS.

To reclaim these pages for use by the kernel other SEAMCALLs are needed,
which will be added in future patches.

Add tdh_mng_addcx(), tdh_mng_create() and tdh_mng_init() to export these
SEAMCALLs so that KVM can use them to create TDs.

For SEAMCALLs that give a page to the TDX module to be encrypted, CLFLUSH
the page mapped with KeyID 0, such that any dirty cache lines don't write
back later and clobber TD memory or control structures. Don't worry about
the other MK-TME KeyIDs because the kernel doesn't use them. The TDX docs
specify that this flush is not needed unless the TDX module exposes the
CLFLUSH_BEFORE_ALLOC feature bit. Be conservative and always flush. Add a
helper function to facilitate this.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
---
SEAMCALL RFC:
 - Use struct tdx_td
 - Introduce tdx_clflush_page() to hold CLFLUSH_BEFORE_ALLOC
   explanation

uAPI breakout v2:
 - Change to use 'u64' as function parameter to prepare to move
   SEAMCALL wrappers to arch/x86. (Kai)
 - Split to separate patch
 - Move SEAMCALL wrappers from KVM to x86 core;
 - Move TDH_xx macros from KVM to x86 core;
 - Re-write log

uAPI breakout v1:
 - Make argument to C wrapper function struct kvm_tdx * or
   struct vcpu_tdx * .(Sean)
 - Drop unused helpers (Kai)
 - Fix bisectability issues in headers (Kai)
 - Updates from seamcall overhaul (Kai)

v19:
 - Update the commit message to match the patch by Yuan
 - Use seamcall() and seamcall_ret() by paolo

v18:
 - removed stub functions for __seamcall{,_ret}()
 - Added Reviewed-by Binbin
 - Make tdx_seamcall() use struct tdx_module_args instead of taking
   each inputs.
---
 arch/x86/include/asm/tdx.h  |  3 +++
 arch/x86/virt/vmx/tdx/tdx.c | 51 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  3 +++
 3 files changed, 57 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index ebee4260545f..4c4d092b7c8e 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -128,8 +128,11 @@ struct tdx_td {
 	hpa_t *tdcs;
 };
 
+u64 tdh_mng_addcx(struct tdx_td *td, hpa_t tdcs);
 u64 tdh_mng_key_config(struct tdx_td *td);
+u64 tdh_mng_create(struct tdx_td *td, hpa_t hkid);
 u64 tdh_mng_key_freeid(struct tdx_td *td);
+u64 tdh_mng_init(struct tdx_td *td, u64 td_params, hpa_t *tdr);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 20eb756b41de..311f8d85e18d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1563,6 +1563,29 @@ void tdx_guest_keyid_free(unsigned int keyid)
 }
 EXPORT_SYMBOL_GPL(tdx_guest_keyid_free);
 
+/*
+ * The TDX module exposes a CLFLUSH_BEFORE_ALLOC bit to specify whether
+ * a CLFLUSH of pages is required before handing them to the TDX module.
+ * Be conservative and make the code simpler by doing the CLFLUSH
+ * unconditionally.
+ */
+static void tdx_clflush_page(hpa_t tdr)
+{
+	clflush_cache_range(__va(tdr), PAGE_SIZE);
+}
+
+u64 tdh_mng_addcx(struct tdx_td *td, hpa_t tdcs)
+{
+	struct tdx_module_args args = {
+		.rcx = tdcs,
+		.rdx = td->tdr,
+	};
+
+	tdx_clflush_page(tdcs);
+	return seamcall(TDH_MNG_ADDCX, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_mng_addcx);
+
 u64 tdh_mng_key_config(struct tdx_td *td)
 {
 	struct tdx_module_args args = {
@@ -1573,6 +1596,18 @@ u64 tdh_mng_key_config(struct tdx_td *td)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_key_config);
 
+u64 tdh_mng_create(struct tdx_td *td, hpa_t hkid)
+{
+	struct tdx_module_args args = {
+		.rcx = td->tdr,
+		.rdx = hkid,
+	};
+
+	tdx_clflush_page(td->tdr);
+	return seamcall(TDH_MNG_CREATE, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_mng_create);
+
 
 u64 tdh_mng_key_freeid(struct tdx_td *td)
 {
@@ -1584,3 +1619,19 @@ u64 tdh_mng_key_freeid(struct tdx_td *td)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_key_freeid);
 
+u64 tdh_mng_init(struct tdx_td *td, u64 td_params, hpa_t *tdr)
+{
+	struct tdx_module_args args = {
+		.rcx = td->tdr,
+		.rdx = td_params,
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_MNG_INIT, &args);
+
+	*tdr = args.rcx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mng_init);
+
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 95002e7ff4c5..b9287304f372 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -17,8 +17,11 @@
 /*
  * TDX module SEAMCALL leaf functions
  */
+#define TDH_MNG_ADDCX			1
 #define TDH_MNG_KEY_CONFIG		8
+#define TDH_MNG_CREATE			9
 #define TDH_MNG_KEY_FREEID		20
+#define TDH_MNG_INIT			21
 #define TDH_PHYMEM_PAGE_RDMD		24
 #define TDH_SYS_KEY_CONFIG		31
 #define TDH_SYS_INIT			33
-- 
2.47.0


