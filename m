Return-Path: <kvm+bounces-57203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E517B51A90
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 16:58:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D603D1C23FC0
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 14:54:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4B0E341654;
	Wed, 10 Sep 2025 14:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SdRUMzBk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461E632A82E;
	Wed, 10 Sep 2025 14:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757515498; cv=none; b=n4VSBJMT+crTgednXRYGkpF8lcmZGukubudH5D8VlDJR3vFr0wkisCvqnskVxG0I3TXGW2CH2hq0oC/IafCulOepyDHgqoaKW7j88tG06rWmVrVb1XyuPpZRuOuRciSSnjLY47ZEvIPIH8yx9i8Iwej/vSXO0tWq2veUPiF39DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757515498; c=relaxed/simple;
	bh=4ZCpJjnEs6upFVsJE6QwmCN3SVC1wJk8iSTFF5EfvCg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dv07+z7HdSh+axbenc131ay2IKR/Ms+PrflazRVDKICx6h2LQnTklfdq5+v2I3la39HcjJ9bWOXWS7mYEIBqjcSY0OTOuJQOi9z6F6omGg3cfpQbWzWSU0HYj3kp9nguB/F+f60XTwkmfaMjVABx3j+SxAr+TuVJcw1uW/CM07c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SdRUMzBk; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757515496; x=1789051496;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4ZCpJjnEs6upFVsJE6QwmCN3SVC1wJk8iSTFF5EfvCg=;
  b=SdRUMzBkQELQmcKUItuQZY3Fe3qKOsoJQ4BftqAY7jnPniRQTWaMoCQv
   0nBH5rxwHwH0v8ZoPB0K615QQv0J7l48cI6Au9PgLXZAqDgx6FTW1qGTa
   E7L4xu8Yw5Mp4CTe1SPJ7NOX9NpSvIv3p60C5JR5ZNOBOot526sGhj7Mp
   37km563AfADtl6M6138Lutpeb/1zkp8Ql4hvn4bI9O43XjByFvquKh6vD
   T4MMEOeW7ZhfD1rxC1W+ENRXd4bu4tu18mjyQEpMf0lNX0sYEzh9PrAiR
   UHzngkMVbJWoiJyVIncJeclbh0x+8BhCl6bPEOBwARljQ4XuKqocm1iVR
   A==;
X-CSE-ConnectionGUID: kIj4gw8ERl2EYvwF6aFpWw==
X-CSE-MsgGUID: V4YeMv8tRpeo//Z53RwCTA==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="77434466"
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="77434466"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 07:44:56 -0700
X-CSE-ConnectionGUID: cAxc3ZTJRE2PfatdL640IA==
X-CSE-MsgGUID: 3BKSLaoaToueCnrPHYqOpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="173495772"
Received: from davehans-spike.ostc.intel.com (HELO ray2.sr71.net) ([10.165.164.11])
  by orviesa008.jf.intel.com with ESMTP; 10 Sep 2025 07:44:54 -0700
From: Dave Hansen <dave.hansen@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Kirill A. Shutemov" <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Kai Huang <kai.huang@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Thomas Huth <thuth@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	Farrah Chen <farrah.chen@intel.com>
Subject: [PATCH] x86/virt/tdx: Use precalculated TDVPR page physical address
Date: Wed, 10 Sep 2025 07:44:53 -0700
Message-Id: <20250910144453.1389652-1-dave.hansen@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kai Huang <kai.huang@intel.com>

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
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/kvm/vmx/tdx.c      |  9 +++++++++
 arch/x86/virt/vmx/tdx/tdx.c | 21 ++++++++-------------
 3 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 6120461bd5ff3..6b338d7f01b7d 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -171,6 +171,8 @@ struct tdx_td {
 struct tdx_vp {
 	/* TDVP root page */
 	struct page *tdvpr_page;
+	/* precalculated page_to_phys(tdvpr_page) for use in noinstr code */
+	phys_addr_t tdvpr_pa;
 
 	/* TD vCPU control structure: */
 	struct page **tdcx_pages;
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 04b6d332c1afa..75326a7449cc3 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -852,6 +852,7 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 	if (tdx->vp.tdvpr_page) {
 		tdx_reclaim_control_page(tdx->vp.tdvpr_page);
 		tdx->vp.tdvpr_page = 0;
+		tdx->vp.tdvpr_pa = 0;
 	}
 
 	tdx->state = VCPU_TD_STATE_UNINITIALIZED;
@@ -2931,6 +2932,13 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
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
@@ -2993,6 +3001,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 	if (tdx->vp.tdvpr_page)
 		__free_page(tdx->vp.tdvpr_page);
 	tdx->vp.tdvpr_page = 0;
+	tdx->vp.tdvpr_pa = 0;
 
 	return ret;
 }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 330b560313afe..eac4032484626 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1504,11 +1504,6 @@ static inline u64 tdx_tdr_pa(struct tdx_td *td)
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
@@ -1520,9 +1515,9 @@ static void tdx_clflush_page(struct page *page)
 	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
 }
 
-noinstr __flatten u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *args)
+noinstr u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *args)
 {
-	args->rcx = tdx_tdvpr_pa(td);
+	args->rcx = td->tdvpr_pa;
 
 	return __seamcall_dirty_cache(__seamcall_saved_ret, TDH_VP_ENTER, args);
 }
@@ -1583,7 +1578,7 @@ u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page)
 {
 	struct tdx_module_args args = {
 		.rcx = page_to_phys(tdcx_page),
-		.rdx = tdx_tdvpr_pa(vp),
+		.rdx = vp->tdvpr_pa,
 	};
 
 	tdx_clflush_page(tdcx_page);
@@ -1652,7 +1647,7 @@ EXPORT_SYMBOL_GPL(tdh_mng_create);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp)
 {
 	struct tdx_module_args args = {
-		.rcx = tdx_tdvpr_pa(vp),
+		.rcx = vp->tdvpr_pa,
 		.rdx = tdx_tdr_pa(td),
 	};
 
@@ -1708,7 +1703,7 @@ EXPORT_SYMBOL_GPL(tdh_mr_finalize);
 u64 tdh_vp_flush(struct tdx_vp *vp)
 {
 	struct tdx_module_args args = {
-		.rcx = tdx_tdvpr_pa(vp),
+		.rcx = vp->tdvpr_pa,
 	};
 
 	return seamcall(TDH_VP_FLUSH, &args);
@@ -1754,7 +1749,7 @@ EXPORT_SYMBOL_GPL(tdh_mng_init);
 u64 tdh_vp_rd(struct tdx_vp *vp, u64 field, u64 *data)
 {
 	struct tdx_module_args args = {
-		.rcx = tdx_tdvpr_pa(vp),
+		.rcx = vp->tdvpr_pa,
 		.rdx = field,
 	};
 	u64 ret;
@@ -1771,7 +1766,7 @@ EXPORT_SYMBOL_GPL(tdh_vp_rd);
 u64 tdh_vp_wr(struct tdx_vp *vp, u64 field, u64 data, u64 mask)
 {
 	struct tdx_module_args args = {
-		.rcx = tdx_tdvpr_pa(vp),
+		.rcx = vp->tdvpr_pa,
 		.rdx = field,
 		.r8 = data,
 		.r9 = mask,
@@ -1784,7 +1779,7 @@ EXPORT_SYMBOL_GPL(tdh_vp_wr);
 u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid)
 {
 	struct tdx_module_args args = {
-		.rcx = tdx_tdvpr_pa(vp),
+		.rcx = vp->tdvpr_pa,
 		.rdx = initial_rcx,
 		.r8 = x2apicid,
 	};
-- 
2.34.1


