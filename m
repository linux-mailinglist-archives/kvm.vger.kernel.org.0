Return-Path: <kvm+bounces-30085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A05219B6C97
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:04:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EC20282A4D
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:04:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6724121894B;
	Wed, 30 Oct 2024 19:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OT4v/Sdp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95111D0F74;
	Wed, 30 Oct 2024 19:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314865; cv=none; b=FBfWg3rpF0nSR6K3cCw/jNVh77/ClvPmuk+P0kzrwpNfz+b+e1UG6WBr0GFMeWU8IOB2xPg51sLgG08Fwgvz+duaDiRWU4/BEuefLDUfdBLdtpbvxTiedRvv86Dl5snbOdR95oi4UyO9f/FzKuv4U163ZvKsKLTjoR/BTTKW8ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314865; c=relaxed/simple;
	bh=m6vNof1vbkA2Ig4mR5WEhb8pC979uaUjk9FfOxwxvy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tuKffqBwNPz7Ouy4711H4PqP/V2H2uTBtbfDs310zGkahdNoVoKj3JOlPQGwjAHzdMFcfwt5nlYz6SNoM3IuN6z8NiskZG9crFOprwmxlHwf8uD+7se5CNr/CfFwVapiIvkUZfjOZXPAReRLmxE80LiILkOprzXcCVZhLVVu9kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OT4v/Sdp; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730314863; x=1761850863;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m6vNof1vbkA2Ig4mR5WEhb8pC979uaUjk9FfOxwxvy0=;
  b=OT4v/SdpQXtLDybv+mGzt/QWxIu0MmY84z+07KQAYUYTXoquUj+wBXhj
   mOdjxugQBZedboHntrgTEmYQ0NE/ruBgH4TgEdpMhRjWtfM3SASYa/MNj
   0Di0adbtC1zJuExBdIMOWIuulAKV4QF1uojakz/BTeNyFBTO9NpE6dAbH
   utpNzGJm0JngkTz2Ztvx5ohI9tAHAJJ7Vgbzj63cPgY84wqf88cNrC/0L
   ikTSpUZ0hZS/Zr5ji5qATjlm4E2qTSO4e0Smca3zvd//9HOjlUIT1iefN
   raeKPLvzxZ7VAGO+R4+TZOtYDHQAuNWZfOyGliQZcPJdioKxoA6Dq7qRT
   A==;
X-CSE-ConnectionGUID: nKhZFDz5TyCI/VuMvfkv+w==
X-CSE-MsgGUID: +5Gju/KOQXWG4IK6Eaj6Lg==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17678748"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="17678748"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:00:58 -0700
X-CSE-ConnectionGUID: 5N/qpNJiRrqGCqdstuFtSQ==
X-CSE-MsgGUID: lrpDf6hdTOq/1hNnTyIB+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82499351"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.186])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:00:57 -0700
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
	reinette.chatre@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH v2 07/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX vCPU creation
Date: Wed, 30 Oct 2024 12:00:20 -0700
Message-ID: <20241030190039.77971-8-rick.p.edgecombe@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Intel TDX protects guest VMs from malicious host and certain physical
attacks. It defines various control structures that hold state for
virtualized components of the TD (i.e. VMs or vCPUs) These control
structures are stored in pages given to the TDX module and encrypted
with either the global KeyID or the guest KeyIDs.

To manipulate these control structures the TDX module defines a few
SEAMCALLs. KVM will use these during the process of creating a vCPU as
follows:

1) Call TDH.VP.CREATE to create a TD vCPU Root (TDVPR) page for each
   vCPU.

2) Call TDH.VP.ADDCX to add per-vCPU control pages (TDCX) for each vCPU.

3) Call TDH.VP.INIT to initialize the TDCX for each vCPU.

To reclaim these pages for use by the kernel other SEAMCALLs are needed,
which will be added in future patches.

Export functions to allow KVM to make these SEAMCALLs. Export two
variants for TDH.VP.CREATE, in order to support the planned logic of KVM
to support TDX modules with and without the ENUM_TOPOLOGY feature. If
KVM can drop support for the !ENUM_TOPOLOGY case, this could go down a
single version. Leave that for later discussion.

For SEAMCALLs that give a page to the TDX module to be encrypted, clflush
the page mapped with KeyID 0, such that any dirty cache lines don't write
back later and clobber TD memory or control structures. Don't worry about
the other MK-TME KeyIDs because the kernel doesn't use them. The TDX docs
specify that this flush is not needed unless the TDX module exposes the
CLFLUSH_BEFORE_ALLOC feature bit. Be conservative and always flush.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
---
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

v16:
 - use struct tdx_module_args instead of struct tdx_module_output
 - Add tdh_mem_sept_rd() for SEPT_VE_DISABLE=1.
---
 arch/x86/include/asm/tdx.h  |  4 +++
 arch/x86/virt/vmx/tdx/tdx.c | 49 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h | 12 +++++++++
 3 files changed, 65 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 9d19ca33e884..6951faa37031 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -124,10 +124,14 @@ void tdx_guest_keyid_free(unsigned int keyid);
 
 /* SEAMCALL wrappers for creating/destroying/running TDX guests */
 u64 tdh_mng_addcx(u64 tdr, u64 tdcs);
+u64 tdh_vp_addcx(u64 tdvpr, u64 tdcx);
 u64 tdh_mng_key_config(u64 tdr);
 u64 tdh_mng_create(u64 tdr, u64 hkid);
+u64 tdh_vp_create(u64 tdr, u64 tdvpr);
 u64 tdh_mng_key_freeid(u64 tdr);
 u64 tdh_mng_init(u64 tdr, u64 td_params, u64 *rcx);
+u64 tdh_vp_init(u64 tdvpr, u64 initial_rcx);
+u64 tdh_vp_init_apicid(u64 tdvpr, u64 initial_rcx, u32 x2apicid);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 16122fd552ff..b3003031e0fe 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1575,6 +1575,18 @@ u64 tdh_mng_addcx(u64 tdr, u64 tdcs)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_addcx);
 
+u64 tdh_vp_addcx(u64 tdvpr, u64 tdcx)
+{
+	struct tdx_module_args args = {
+		.rcx = tdcx,
+		.rdx = tdvpr,
+	};
+
+	clflush_cache_range(__va(tdcx), PAGE_SIZE);
+	return seamcall(TDH_VP_ADDCX, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_addcx);
+
 u64 tdh_mng_key_config(u64 tdr)
 {
 	struct tdx_module_args args = {
@@ -1591,11 +1603,24 @@ u64 tdh_mng_create(u64 tdr, u64 hkid)
 		.rcx = tdr,
 		.rdx = hkid,
 	};
+
 	clflush_cache_range(__va(tdr), PAGE_SIZE);
 	return seamcall(TDH_MNG_CREATE, &args);
 }
 EXPORT_SYMBOL_GPL(tdh_mng_create);
 
+u64 tdh_vp_create(u64 tdr, u64 tdvpr)
+{
+	struct tdx_module_args args = {
+		.rcx = tdvpr,
+		.rdx = tdr,
+	};
+
+	clflush_cache_range(__va(tdr), PAGE_SIZE);
+	return seamcall(TDH_VP_CREATE, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_create);
+
 u64 tdh_mng_key_freeid(u64 tdr)
 {
 	struct tdx_module_args args = {
@@ -1621,3 +1646,27 @@ u64 tdh_mng_init(u64 tdr, u64 td_params, u64 *rcx)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(tdh_mng_init);
+
+u64 tdh_vp_init(u64 tdvpr, u64 initial_rcx)
+{
+	struct tdx_module_args args = {
+		.rcx = tdvpr,
+		.rdx = initial_rcx,
+	};
+
+	return seamcall(TDH_VP_INIT, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_init);
+
+u64 tdh_vp_init_apicid(u64 tdvpr, u64 initial_rcx, u32 x2apicid)
+{
+	struct tdx_module_args args = {
+		.rcx = tdvpr,
+		.rdx = initial_rcx,
+		.r8 = x2apicid,
+	};
+
+	/* apicid requires version == 1. */
+	return seamcall(TDH_VP_INIT | (1ULL << TDX_VERSION_SHIFT), &args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_init_apicid);
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index b9287304f372..64b6504791e1 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -18,10 +18,13 @@
  * TDX module SEAMCALL leaf functions
  */
 #define TDH_MNG_ADDCX			1
+#define TDH_VP_ADDCX			4
 #define TDH_MNG_KEY_CONFIG		8
 #define TDH_MNG_CREATE			9
+#define TDH_VP_CREATE			10
 #define TDH_MNG_KEY_FREEID		20
 #define TDH_MNG_INIT			21
+#define TDH_VP_INIT			22
 #define TDH_PHYMEM_PAGE_RDMD		24
 #define TDH_SYS_KEY_CONFIG		31
 #define TDH_SYS_INIT			33
@@ -30,6 +33,15 @@
 #define TDH_SYS_TDMR_INIT		36
 #define TDH_SYS_CONFIG			45
 
+
+/*
+ * SEAMCALL leaf:
+ *
+ * Bit 15:0	Leaf number
+ * Bit 23:16	Version number
+ */
+#define TDX_VERSION_SHIFT		16
+
 /* TDX page types */
 #define	PT_NDA		0x0
 #define	PT_RSVD		0x1
-- 
2.47.0


