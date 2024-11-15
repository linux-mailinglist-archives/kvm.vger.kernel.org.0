Return-Path: <kvm+bounces-31969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E1EF9CF62B
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 21:33:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F2BAFB355A4
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 20:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 569231FB8A5;
	Fri, 15 Nov 2024 20:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D8GDWG3K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B251E47A5;
	Fri, 15 Nov 2024 20:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731702045; cv=none; b=GNoTprMUEJcr5JajMrYTqR/lXmZGGpTbenKOwgPHB5vFXGzwTrQA1Q2ftRl7yYCVMF8zgO1OW/zF2L6AIqEnxK0M95UyImVyOr+8CwWa5EMsZR56ddZXpd0rTGMuLZLkcrgP+Xwnv6mMtb/0JLPny1STC3tUKxI6YN88470vLHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731702045; c=relaxed/simple;
	bh=OLXyWc6a+5iTsV6Lvu2X+9Publw3xDvwiHpcQKYgg4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOaRcdm15D4HP6P3+cPNrAq5sjC80igpkeGguG5BKihoXxhE6eV356NQvsvIfobpbPekNWxIZ88ZhqyZhEiqR/ekYTs7tcL9oosOSWEmdIRcDHUBwIXHwfECVXlcflYypPAXIKzT5KSDzXJMlUNsnWQCKx1eE5Ek03rUjyLXApc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D8GDWG3K; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731702044; x=1763238044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OLXyWc6a+5iTsV6Lvu2X+9Publw3xDvwiHpcQKYgg4s=;
  b=D8GDWG3KPdKPSM9ktPhXiPAJaCOJTluOTWnEB9/ahV4PNJY5HH73CAb3
   Qkq3T/AADGtVMLe4/StI1wccYPpeOEVPGkE0LMdm9gsBG40pUxZ3rDmd9
   VEtzZJ7oDhaKFZoDklAp8JBx6gAjLZIu/AeHCZxlHWJQV0N00wJeT+2Y3
   Fg/EN1sOroUuQzPHQ+bqW3iJd0niaIQp3KI17d3sa69CzAvIkpyfYuhBH
   aESYBeGVVeejDJihybmmeoIYNiWvNzVNk+E6Nupd8aNkGykAWb/ZQGVPH
   Z1UJZvc/u77hmjyhdCuUBIrR03Yn6LlyIKCzufngkXK8lRFhvfXwjUaUs
   g==;
X-CSE-ConnectionGUID: fZ4Uvk+QSrm/MJgOVDcphg==
X-CSE-MsgGUID: EaJbIXZYSUiAH+M2Z10Qag==
X-IronPort-AV: E=McAfee;i="6700,10204,11257"; a="54228339"
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="54228339"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 12:20:42 -0800
X-CSE-ConnectionGUID: 7tX84mT3TjCBjIKlEU0Tlg==
X-CSE-MsgGUID: Qz6lTGaNRnSYwaomn9ISKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="93599400"
Received: from jairdeje-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.173])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 12:20:41 -0800
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
Subject: [RFC PATCH 3/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX vCPU creation
Date: Fri, 15 Nov 2024 12:20:24 -0800
Message-ID: <20241115202028.1585487-4-rick.p.edgecombe@intel.com>
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

The TDX module provides SEAMCALLs to hand pages to the TDX module for
storing TDX controlled state. SEAMCALLs that operate on this state are
directed to the appropriate TD vCPU using references to the pages
originally provided for managing the vCPU's state. So the host kernel
needs to track these pages, both as an ID for specifying which vCPU to
operate on, and to allow them to be eventually reclaimed. The vCPU
associated pages are called TDVPR (Trust Domain Virtual Processor Root)
and TDCX (Trust Domain Control Extension).

Introduce "struct tdx_vp" for holding references to pages provided to the
TDX module for the TD vCPU associated state. Don't plan for any vCPU
associated state that is controlled by KVM to live in this struct. Only
expect it to hold data for concepts specific to the TDX architecture, for
which there can't already be preexisting storage for in KVM.

Add both the TDVPR page and an array of TDCX pages, even though the
SEAMCALL wrappers will only need to know about the TDVPR pages for
directing the SEAMCALLs to the right vCPU. Adding the TDCX pages to this
struct will let all of the vCPU associated pages handed to the TDX module be
tracked in one location. For a type to specify physical pages, use KVM's
hpa_t type. Do this for KVM's benefit This is the common type used to hold
physical addresses in KVM, so will make interoperability easier.

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
 - Introduce tdx_vp

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
 arch/x86/include/asm/tdx.h  |  9 ++++++++
 arch/x86/virt/vmx/tdx/tdx.c | 46 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h | 11 +++++++++
 3 files changed, 66 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 4c4d092b7c8e..83aa2a8a56d3 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -128,11 +128,20 @@ struct tdx_td {
 	hpa_t *tdcs;
 };
 
+struct tdx_vp {
+	hpa_t tdvpr;
+	hpa_t *tdcx;
+};
+
 u64 tdh_mng_addcx(struct tdx_td *td, hpa_t tdcs);
+u64 tdh_vp_addcx(struct tdx_vp *vp, hpa_t tdcx);
 u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, hpa_t hkid);
+u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
 u64 tdh_mng_key_freeid(struct tdx_td *td);
 u64 tdh_mng_init(struct tdx_td *td, u64 td_params, hpa_t *tdr);
+u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx);
+u64 tdh_vp_init_apicid(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 311f8d85e18d..c125b1519072 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1586,6 +1586,18 @@ u64 tdh_mng_addcx(struct tdx_td *td, hpa_t tdcs)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_addcx);
 
+u64 tdh_vp_addcx(struct tdx_vp *vp, hpa_t tdcx)
+{
+	struct tdx_module_args args = {
+		.rcx = tdcx,
+		.rdx = vp->tdvpr,
+	};
+
+	tdx_clflush_page(tdcx);
+	return seamcall(TDH_VP_ADDCX, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_addcx);
+
 u64 tdh_mng_key_config(struct tdx_td *td)
 {
 	struct tdx_module_args args = {
@@ -1608,6 +1620,17 @@ u64 tdh_mng_create(struct tdx_td *td, hpa_t hkid)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_create);
 
+u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp)
+{
+	struct tdx_module_args args = {
+		.rcx = vp->tdvpr,
+		.rdx = td->tdr,
+	};
+
+	tdx_clflush_page(vp->tdvpr);
+	return seamcall(TDH_VP_CREATE, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_create);
 
 u64 tdh_mng_key_freeid(struct tdx_td *td)
 {
@@ -1635,3 +1658,26 @@ u64 tdh_mng_init(struct tdx_td *td, u64 td_params, hpa_t *tdr)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_init);
 
+u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx)
+{
+	struct tdx_module_args args = {
+		.rcx = vp->tdvpr,
+		.rdx = initial_rcx,
+	};
+
+	return seamcall(TDH_VP_INIT, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_init);
+
+u64 tdh_vp_init_apicid(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid)
+{
+	struct tdx_module_args args = {
+		.rcx = vp->tdvpr,
+		.rdx = initial_rcx,
+		.r8 = x2apicid,
+	};
+
+	/* apicid requires version == 1. */
+	return seamcall(TDH_VP_INIT | (1ULL << TDX_VERSION_SHIFT), &args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_init_apicid);
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index b9287304f372..3663971a3669 100644
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
@@ -30,6 +33,14 @@
 #define TDH_SYS_TDMR_INIT		36
 #define TDH_SYS_CONFIG			45
 
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


