Return-Path: <kvm+bounces-32872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3866D9E10A3
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 02:04:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0948281A30
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 01:04:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AC9E15B0EF;
	Tue,  3 Dec 2024 01:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nEumS/sl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2977558BB;
	Tue,  3 Dec 2024 01:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733187821; cv=none; b=Lf4ykVOWU3xwFlXRT/ZTl1t4yv8pGchtcTzeoMquShv2wlIqhoSlcKGamf534iwcPej9Ny0pgamRDAJUAtTXRyVrrzWa2rVE+BdbGWkWAYO1EpsBnANAphCzKqXq/XhnFEms9t1JLqCofKErcz+Zn3WwNJ58paHhlsmn/Aw8KUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733187821; c=relaxed/simple;
	bh=cEPueJLgUoqsoeO50ks4Jav/oCG91h7phamTZBbX8qM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPO6DrLh01IlTfTd3kBYKPmf+J8Qiykb/5n99zxfQPYMS1TC1WSbTun81zsWvMfU4ILp5z0i2cvG32cmMnM2hKTD4foNEmi9C11m1wWqo02L9jY4nle65sX0Ew6tCJmPGXECbPoouhj+BX8oWzTwRGN4VTDxgWQCsNatU02oejM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nEumS/sl; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733187820; x=1764723820;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cEPueJLgUoqsoeO50ks4Jav/oCG91h7phamTZBbX8qM=;
  b=nEumS/slNqAaS1tbWUklzlE2LWT4lzwASatjM4gWl/nkLkJQ73nqBDi7
   OgEwKw0UFkImYVFJgBkWF/EO8+S2I6AGDXYEKCvzTbGHPFo44uqUvMAk7
   21j5wtrYgnKhBabwWSYa1B84nVz+AKZi2leas0kwuUNf8Egn2ZUOOcYLh
   2mXWqtvCig3LgK7/Ae4uotafN54Ejz7tMrQCq5lHOF5pmvYnvuWf9c3NS
   bu/Ru8tPb3VK5bojA16vFTRafD1yYrZbzE/Iu9tq063s0S0DHmqg2ELew
   SQZJ+Zpxe8J3oUxDg6Y6TKljDlu5E67toQC+z5B8ALD/ga2FIrZlcZtXA
   g==;
X-CSE-ConnectionGUID: 8zyU04K+SQWPVn2xgWv+jA==
X-CSE-MsgGUID: 1VdX1CP4Rma4sFKYUMEJNg==
X-IronPort-AV: E=McAfee;i="6700,10204,11274"; a="36237974"
X-IronPort-AV: E=Sophos;i="6.12,203,1728975600"; 
   d="scan'208";a="36237974"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 17:03:35 -0800
X-CSE-ConnectionGUID: VlQ3gBBFTNin87Mx4nBJlQ==
X-CSE-MsgGUID: dKW3INuAQq+GqNM0IJXmCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,203,1728975600"; 
   d="scan'208";a="116535796"
Received: from jairdeje-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.7])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 17:03:26 -0800
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
Subject: [RFC PATCH v2 3/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX vCPU creation
Date: Mon,  2 Dec 2024 17:03:13 -0800
Message-ID: <20241203010317.827803-4-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203010317.827803-1-rick.p.edgecombe@intel.com>
References: <20241203010317.827803-1-rick.p.edgecombe@intel.com>
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
SEAMCALL RFC v2:
 - Use struct page (Dave)

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
 arch/x86/include/asm/tdx.h  | 15 +++++++++++
 arch/x86/virt/vmx/tdx/tdx.c | 53 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h | 11 ++++++++
 3 files changed, 79 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index a4360a71dbdd..018bbabf8639 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -129,13 +129,28 @@ struct tdx_td {
 	int tdcs_nr_pages;
 	/* TD control structure: */
 	struct page **tdcs_pages;
+
+	/* Size of `tdcx_pages` in struct tdx_vp */
+	int tdcx_nr_pages;
+};
+
+struct tdx_vp {
+	/* TDVP root page */
+	struct page *tdvpr_page;
+
+	/* TD vCPU control structure: */
+	struct page **tdcx_pages;
 };
 
 u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page);
+u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page);
 u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, u64 hkid);
+u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
 u64 tdh_mng_key_freeid(struct tdx_td *td);
 u64 tdh_mng_init(struct tdx_td *td, u64 td_params, u64 *extended_err);
+u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx);
+u64 tdh_vp_init_apicid(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 605eb9bd81d3..d71656868fe4 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -5,6 +5,7 @@
  * Intel Trusted Domain Extensions (TDX) support
  */
 
+#include "asm/page_types.h"
 #define pr_fmt(fmt)	"virt/tdx: " fmt
 
 #include <linux/types.h>
@@ -1568,6 +1569,11 @@ static inline u64 tdx_tdr_pa(struct tdx_td *td)
 	return page_to_pfn(td->tdr_page) << PAGE_SHIFT;
 }
 
+static inline u64 tdx_tdvpr_pa(struct tdx_vp *td)
+{
+	return page_to_pfn(td->tdvpr_page) << PAGE_SHIFT;
+}
+
 /*
  * The TDX module exposes a CLFLUSH_BEFORE_ALLOC bit to specify whether
  * a CLFLUSH of pages is required before handing them to the TDX module.
@@ -1591,6 +1597,18 @@ u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_addcx);
 
+u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page)
+{
+	struct tdx_module_args args = {
+		.rcx = page_to_pfn(tdcx_page) << PAGE_SHIFT,
+		.rdx = tdx_tdvpr_pa(vp),
+	};
+
+	tdx_clflush_page(tdcx_page);
+	return seamcall(TDH_VP_ADDCX, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_addcx);
+
 u64 tdh_mng_key_config(struct tdx_td *td)
 {
 	struct tdx_module_args args = {
@@ -1613,6 +1631,18 @@ u64 tdh_mng_create(struct tdx_td *td, u64 hkid)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_create);
 
+u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp)
+{
+	struct tdx_module_args args = {
+		.rcx = tdx_tdvpr_pa(vp),
+		.rdx = tdx_tdr_pa(td),
+	};
+
+	tdx_clflush_page(vp->tdvpr_page);
+	return seamcall(TDH_VP_CREATE, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_create);
+
 u64 tdh_mng_key_freeid(struct tdx_td *td)
 {
 	struct tdx_module_args args = {
@@ -1639,3 +1669,26 @@ u64 tdh_mng_init(struct tdx_td *td, u64 td_params, u64 *extended_err)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_init);
 
+u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx)
+{
+	struct tdx_module_args args = {
+		.rcx = tdx_tdvpr_pa(vp),
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
+		.rcx = tdx_tdvpr_pa(vp),
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
2.47.1


