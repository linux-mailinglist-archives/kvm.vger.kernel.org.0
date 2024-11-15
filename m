Return-Path: <kvm+bounces-31968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D6179CF637
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 21:38:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 46DC1B37514
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 20:27:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5533E1FB8A2;
	Fri, 15 Nov 2024 20:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n2UKnDgC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957321E570F;
	Fri, 15 Nov 2024 20:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731702045; cv=none; b=ZgfVSdoUons65+wi9kuW34/Yq3JWbqhoezLbsN8TDCXbOWZabeaTQcW2vIn0TNfngFfeFp/YL+U1KzL5gNy5DhhgDmsXWWc+OB09Nr7IXrsKcGxkbhfiNvIFo6drm2gK3lpopHeD2YVJRZlHtyN6FqaFsD4X1+OpUjSD+p/Wd58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731702045; c=relaxed/simple;
	bh=9zjQlMAVAGFEnQFffV1hBC1dj1KdomkhQ77qmqMyMEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZoXHkHPTHEfCvV0KTcq0EItbmUHXaSigIysuSZejIBlcttWiALohU43kGfpB6r7udHwfWhyAmEIGfZrFMARxdjXMPIJ6ZG+h4wo/Cx/yHzX1Ejr2e62fAoGJf5zW13V9uZIExpDc/RnxZi6wJzwC1BaC5afSOLFc3JvCUQyNM9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n2UKnDgC; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731702044; x=1763238044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9zjQlMAVAGFEnQFffV1hBC1dj1KdomkhQ77qmqMyMEY=;
  b=n2UKnDgCX37OrNoMnSrHhHIz8RPKQtVQYiCHVTqXKJXpOsBoJkCWzGk9
   wg+ckNikTaQSOwcgAMnIKLIcJzbgqTILCjpKM5/7BvtbeSl5ka16FEsFi
   HvIN9tfzBVPR0HvsYmoqjlfL7YvsxnRLWjqMzSKJ3DQZTApCVZ9t9ihDz
   l66v0GM0knzfm9KdR16cz2HCAHbBVrBitJt7/KeZPYtBubjw6KKYpAV5a
   v5VySbYvzhzQf9latdDeCz7rYthMxcis8jJPrCJ6jdj3+0ZJ31mAGTrlL
   0x8g9ASl1wymO2N37e4o6T+lkyw5QdWPIQTPK1eXgwvHvQ3ud+zXZPGzg
   g==;
X-CSE-ConnectionGUID: iG6TDUsVS/u5ch//40dGgw==
X-CSE-MsgGUID: 4dSvbyjmTEiI47v1YgTqMw==
X-IronPort-AV: E=McAfee;i="6700,10204,11257"; a="54228352"
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="54228352"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 12:20:43 -0800
X-CSE-ConnectionGUID: cSdbujAdTA+6FGeXZfrYIw==
X-CSE-MsgGUID: YruSW7q6SrSnsKvY8PfRbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="93599408"
Received: from jairdeje-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.173])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 12:20:43 -0800
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
Subject: [RFC PATCH 5/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX VM/vCPU field access
Date: Fri, 15 Nov 2024 12:20:26 -0800
Message-ID: <20241115202028.1585487-6-rick.p.edgecombe@intel.com>
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

Intel TDX protects guest VMs from malicious host and certain physical
attacks. The TDX module has TD scoped and vCPU scoped "metadata fields".
These fields are a bit like VMCS fields, and stored in data structures
maintained by the TDX module. Export 3 SEAMCALLs for use in reading and
writing these fields:

Make tdh_mng_rd() use MNG.VP.RD to read the TD scoped metadata.

Make tdh_vp_rd()/tdh_vp_wr() use TDH.VP.RD/WR to read/write the vCPU
scoped metadata.

KVM will use these by creating inline helpers that target various metadata
sizes. Export the raw SEAMCALL leaf, to avoid exporting the large number
of various sized helpers.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
---
SEAMCALL RFC:
 - Use struct tdx_td and struct tdx_vp

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
 arch/x86/virt/vmx/tdx/tdx.c | 47 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  3 +++
 3 files changed, 53 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 72de04dc242e..6a892727fdc8 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -138,9 +138,12 @@ u64 tdh_vp_addcx(struct tdx_vp *vp, hpa_t tdcx);
 u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, hpa_t hkid);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
+u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data);
 u64 tdh_mng_key_freeid(struct tdx_td *td);
 u64 tdh_mng_init(struct tdx_td *td, u64 td_params, hpa_t *tdr);
 u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx);
+u64 tdh_vp_rd(struct tdx_vp *vp, u64 field, u64 *data);
+u64 tdh_vp_wr(struct tdx_vp *vp, u64 field, u64 data, u64 mask);
 u64 tdh_vp_init_apicid(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid);
 u64 tdh_phymem_page_reclaim(hpa_t page, u64 *page_type, u64 *page_owner, u64 *page_size);
 u64 tdh_phymem_cache_wb(bool resume);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 6f833d816899..28b3caf5a445 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1632,6 +1632,23 @@ u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp)
 }
 EXPORT_SYMBOL_GPL(tdh_vp_create);
 
+u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data)
+{
+	struct tdx_module_args args = {
+		.rcx = td->tdr,
+		.rdx = field,
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_MNG_RD, &args);
+
+	/* R8: Content of the field, or 0 in case of error. */
+	*data = args.r8;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mng_rd);
+
 u64 tdh_mng_key_freeid(struct tdx_td *td)
 {
 	struct tdx_module_args args = {
@@ -1669,6 +1686,36 @@ u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx)
 }
 EXPORT_SYMBOL_GPL(tdh_vp_init);
 
+u64 tdh_vp_rd(struct tdx_vp *vp, u64 field, u64 *data)
+{
+	struct tdx_module_args args = {
+		.rcx = vp->tdvpr,
+		.rdx = field,
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_VP_RD, &args);
+
+	/* R8: Content of the field, or 0 in case of error. */
+	*data = args.r8;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_vp_rd);
+
+u64 tdh_vp_wr(struct tdx_vp *vp, u64 field, u64 data, u64 mask)
+{
+	struct tdx_module_args args = {
+		.rcx = vp->tdvpr,
+		.rdx = field,
+		.r8 = data,
+		.r9 = mask,
+	};
+
+	return seamcall(TDH_VP_WR, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_wr);
+
 u64 tdh_vp_init_apicid(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid)
 {
 	struct tdx_module_args args = {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 191bdd1e571d..5179fc02d109 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -21,11 +21,13 @@
 #define TDH_VP_ADDCX			4
 #define TDH_MNG_KEY_CONFIG		8
 #define TDH_MNG_CREATE			9
+#define TDH_MNG_RD			11
 #define TDH_VP_CREATE			10
 #define TDH_MNG_KEY_FREEID		20
 #define TDH_MNG_INIT			21
 #define TDH_VP_INIT			22
 #define TDH_PHYMEM_PAGE_RDMD		24
+#define TDH_VP_RD			26
 #define TDH_PHYMEM_PAGE_RECLAIM		28
 #define TDH_SYS_KEY_CONFIG		31
 #define TDH_SYS_INIT			33
@@ -34,6 +36,7 @@
 #define TDH_SYS_TDMR_INIT		36
 #define TDH_PHYMEM_CACHE_WB		40
 #define TDH_PHYMEM_PAGE_WBINVD		41
+#define TDH_VP_WR			43
 #define TDH_SYS_CONFIG			45
 
 /*
-- 
2.47.0


