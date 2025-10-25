Return-Path: <kvm+bounces-61090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E8C0DC09CBD
	for <lists+kvm@lfdr.de>; Sat, 25 Oct 2025 18:58:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DE5B25615DF
	for <lists+kvm@lfdr.de>; Sat, 25 Oct 2025 16:33:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC7223164C7;
	Sat, 25 Oct 2025 16:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tmBrh1Qy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191622FD7DD;
	Sat, 25 Oct 2025 16:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409577; cv=none; b=F3699Rn/1sffgD+ujSQhPbXamT5cdAeQgX327RUtERqakp51drwJmMXl2M+5A16rKvwQ0J/udHOCtR7IFnrdiFvUlN5IlZ6nHX/Vuj6VxMIBVvZJJ5iQG8V9OOsVAxe3azJLP4hHHB9qLwhZaC4ciBa5LS4za6U7N0zqZRU/4js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409577; c=relaxed/simple;
	bh=aI9x5Ft64P52IloQJOMbGzdMOh0uQz2zl6nsikDg0eU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgfOnxHb7VQ+dGfVUptjWetw9IL5rx/KOSMWeTILiCOHvp3sy9buWSbLb+5S1N0m4tCN3XecZOGZqIQQ1YFFJfI7BxWxarM4GF9APIGaemfd7xtPqFR1saB/cE3wQpQw8nkF7fD8zlgK3zb4Jxh7N5833sCrPh3MZCvtpnmLkmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tmBrh1Qy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5FCC4CEF5;
	Sat, 25 Oct 2025 16:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409577;
	bh=aI9x5Ft64P52IloQJOMbGzdMOh0uQz2zl6nsikDg0eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tmBrh1QyUCUhxb9jFgOx7olS4xh4u3JxS1K29NQ8hxLKvdZKhiurNhBiOVWzlbFr4
	 KoJ2RQahIIm3SdpoyeghGgn4JlaThHgbmDXj15tQkUh2KhpZDHJz1OL76cSPrOLDNn
	 uUwNWokn/KdBrBCLBUorus+0I8fiO9iJpOhqdKPmIoHxGI2jKfZ55NoXkAGfPwF5w6
	 e4Ab8p8JPXGOj6M1Gq8qrtVnK0vMdYgy1jb2h+K6aQWI4SS4efNV3Zy3WXCzIA/DGM
	 2S1955WFyLaWP+4R3jxP/M2LmMAoXzft9HELBOD+gkARQ7kws9OVVn5pzQRsoCdOlP
	 tbRKNEb+aQiig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kai Huang <kai.huang@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Farrah Chen <farrah.chen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	seanjc@google.com,
	pbonzini@redhat.com,
	rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	alexandre.f.demers@gmail.com,
	vannapurve@google.com,
	thuth@redhat.com,
	adrian.hunter@intel.com,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] x86/virt/tdx: Use precalculated TDVPR page physical address
Date: Sat, 25 Oct 2025 12:00:04 -0400
Message-ID: <20251025160905.3857885-373-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Kai Huang <kai.huang@intel.com>

[ Upstream commit e414b1005891d74bb0c3d27684c58dfbfbd1754b ]

All of the x86 KVM guest types (VMX, SEV and TDX) do some special context
tracking when entering guests. This means that the actual guest entry
sequence must be noinstr.

Part of entering a TDX guest is passing a physical address to the TDX
module. Right now, that physical address is stored as a 'struct page'
and converted to a physical address at guest entry. That page=>phys
conversion can be complicated, can vary greatly based on kernel
config, and it is definitely _not_ a noinstr path today.

There have been a number of tinkering approaches to try and fix this
up, but they all fall down due to some part of the page=>phys
conversion infrastructure not being noinstr friendly.

Precalculate the page=>phys conversion and store it in the existing
'tdx_vp' structure.  Use the new field at every site that needs a
tdvpr physical address. Remove the now redundant tdx_tdvpr_pa().
Remove the __flatten remnant from the tinkering.

Note that only one user of the new field is actually noinstr. All
others can use page_to_phys(). But, they might as well save the effort
since there is a pre-calculated value sitting there for them.

[ dhansen: rewrite all the text ]

Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Rationale
- Fixes a real correctness bug in a critical noinstr path. Entering a
  TDX guest must be noinstr; previously, `tdh_vp_enter()` converted a
  `struct page` to a physical address at runtime, which is not noinstr-
  safe. The patch removes the runtime `page_to_phys()` from the guest-
  entry path and uses a precomputed physical address instead.
- Minimal, contained change in the TDX/KVM code. No ABI changes; all
  updates are internal to TDX vCPU state and seamcall wrappers.

Key Changes
- Precompute and store the TDVPR physical address:
  - Adds `phys_addr_t tdvpr_pa;` to `struct tdx_vp` to hold
    `page_to_phys(tdvpr_page)` for reuse in noinstr code:
    arch/x86/include/asm/tdx.h:171.
  - Computes and assigns the field during vCPU init, with an explicit
    comment explaining noinstr constraints: arch/x86/kvm/vmx/tdx.c:2936.
  - Clears the field on free/error paths to avoid stale use:
    arch/x86/kvm/vmx/tdx.c:855, arch/x86/kvm/vmx/tdx.c:3004.
- Make the guest entry truly noinstr:
  - `tdh_vp_enter()` now uses the precomputed `td->tdvpr_pa` and stays
    within noinstr constraints: arch/x86/virt/vmx/tdx/tdx.c:1518.
  - Also removes the `__flatten` remnant and wraps the seamcall with the
    cache-dirty helper, aligning with other TDX seamcall usage.
- Replace page->phys conversions with the precomputed value at all sites
  that use the TDVPR:
  - Updated callers pass `vp->tdvpr_pa` instead of recomputing:
    arch/x86/virt/vmx/tdx/tdx.c:1581, 1650, 1706, 1752, 1769, 1782.
  - Removes the now-redundant inline helper that did `page_to_phys()`
    for TDVPR.

Why This Fits Stable
- User impact: Fixes potential WARN/BUG and undefined behavior from
  invoking non-noinstr code in a noinstr entry path for TDX guests. This
  can affect real deployments using debug/instrumented kernels and is
  correctness-critical for a guest entry path.
- Scope and risk: Small, straightforward refactor; adds one cached field
  and replaces callers to use it. Memory lifetime is well-defined (page
  is allocated at init and reclaimed at teardown), and the physical
  address of a page is stable; zeroing on teardown/error prevents stale
  usage.
- No feature or architectural changes; KVM/TDX only. No user-visible ABI
  changes. The seamcall helper infrastructure (`__seamcall_dirty_cache`,
  `__seamcall_saved_ret`) is already present in this subsystem.
- Reviewed and tested upstream (Reviewed-by/Tested-by tags), and
  consistent with prior attempts to fix noinstr issues (this replaces
  earlier, more fragile approaches like `__flatten`).

Conclusion
- This is a low-risk, correctness fix to a critical guest-entry path,
  improving noinstr compliance. It should be backported to stable
  kernels that have TDX support.

 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/kvm/vmx/tdx.c      |  9 +++++++++
 arch/x86/virt/vmx/tdx/tdx.c | 21 ++++++++-------------
 3 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 0922265c6bdcb..17a051d9c9398 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -169,6 +169,8 @@ struct tdx_td {
 struct tdx_vp {
 	/* TDVP root page */
 	struct page *tdvpr_page;
+	/* precalculated page_to_phys(tdvpr_page) for use in noinstr code */
+	phys_addr_t tdvpr_pa;
 
 	/* TD vCPU control structure: */
 	struct page **tdcx_pages;
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d91d9d6bb26c1..987c0eb10545c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -861,6 +861,7 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 	if (tdx->vp.tdvpr_page) {
 		tdx_reclaim_control_page(tdx->vp.tdvpr_page);
 		tdx->vp.tdvpr_page = 0;
+		tdx->vp.tdvpr_pa = 0;
 	}
 
 	tdx->state = VCPU_TD_STATE_UNINITIALIZED;
@@ -2940,6 +2941,13 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 		return -ENOMEM;
 	tdx->vp.tdvpr_page = page;
 
+	/*
+	 * page_to_phys() does not work in 'noinstr' code, like guest
+	 * entry via tdh_vp_enter(). Precalculate and store it instead
+	 * of doing it at runtime later.
+	 */
+	tdx->vp.tdvpr_pa = page_to_phys(tdx->vp.tdvpr_page);
+
 	tdx->vp.tdcx_pages = kcalloc(kvm_tdx->td.tdcx_nr_pages, sizeof(*tdx->vp.tdcx_pages),
 			       	     GFP_KERNEL);
 	if (!tdx->vp.tdcx_pages) {
@@ -3002,6 +3010,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 	if (tdx->vp.tdvpr_page)
 		__free_page(tdx->vp.tdvpr_page);
 	tdx->vp.tdvpr_page = 0;
+	tdx->vp.tdvpr_pa = 0;
 
 	return ret;
 }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 3ea6f587c81a3..b54581a795f5b 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1502,11 +1502,6 @@ static inline u64 tdx_tdr_pa(struct tdx_td *td)
 	return page_to_phys(td->tdr_page);
 }
 
-static inline u64 tdx_tdvpr_pa(struct tdx_vp *td)
-{
-	return page_to_phys(td->tdvpr_page);
-}
-
 /*
  * The TDX module exposes a CLFLUSH_BEFORE_ALLOC bit to specify whether
  * a CLFLUSH of pages is required before handing them to the TDX module.
@@ -1518,9 +1513,9 @@ static void tdx_clflush_page(struct page *page)
 	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
 }
 
-noinstr __flatten u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *args)
+noinstr u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *args)
 {
-	args->rcx = tdx_tdvpr_pa(td);
+	args->rcx = td->tdvpr_pa;
 
 	return __seamcall_dirty_cache(__seamcall_saved_ret, TDH_VP_ENTER, args);
 }
@@ -1581,7 +1576,7 @@ u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page)
 {
 	struct tdx_module_args args = {
 		.rcx = page_to_phys(tdcx_page),
-		.rdx = tdx_tdvpr_pa(vp),
+		.rdx = vp->tdvpr_pa,
 	};
 
 	tdx_clflush_page(tdcx_page);
@@ -1650,7 +1645,7 @@ EXPORT_SYMBOL_GPL(tdh_mng_create);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp)
 {
 	struct tdx_module_args args = {
-		.rcx = tdx_tdvpr_pa(vp),
+		.rcx = vp->tdvpr_pa,
 		.rdx = tdx_tdr_pa(td),
 	};
 
@@ -1706,7 +1701,7 @@ EXPORT_SYMBOL_GPL(tdh_mr_finalize);
 u64 tdh_vp_flush(struct tdx_vp *vp)
 {
 	struct tdx_module_args args = {
-		.rcx = tdx_tdvpr_pa(vp),
+		.rcx = vp->tdvpr_pa,
 	};
 
 	return seamcall(TDH_VP_FLUSH, &args);
@@ -1752,7 +1747,7 @@ EXPORT_SYMBOL_GPL(tdh_mng_init);
 u64 tdh_vp_rd(struct tdx_vp *vp, u64 field, u64 *data)
 {
 	struct tdx_module_args args = {
-		.rcx = tdx_tdvpr_pa(vp),
+		.rcx = vp->tdvpr_pa,
 		.rdx = field,
 	};
 	u64 ret;
@@ -1769,7 +1764,7 @@ EXPORT_SYMBOL_GPL(tdh_vp_rd);
 u64 tdh_vp_wr(struct tdx_vp *vp, u64 field, u64 data, u64 mask)
 {
 	struct tdx_module_args args = {
-		.rcx = tdx_tdvpr_pa(vp),
+		.rcx = vp->tdvpr_pa,
 		.rdx = field,
 		.r8 = data,
 		.r9 = mask,
@@ -1782,7 +1777,7 @@ EXPORT_SYMBOL_GPL(tdh_vp_wr);
 u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid)
 {
 	struct tdx_module_args args = {
-		.rcx = tdx_tdvpr_pa(vp),
+		.rcx = vp->tdvpr_pa,
 		.rdx = initial_rcx,
 		.r8 = x2apicid,
 	};
-- 
2.51.0


