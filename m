Return-Path: <kvm+bounces-31572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 375409C4FAA
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:41:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9A964B224FA
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:41:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21CED1AA79A;
	Tue, 12 Nov 2024 07:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QP93u2OD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD1E20ADDB;
	Tue, 12 Nov 2024 07:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397138; cv=none; b=GtBRCw83PHmXHUqF/Jy3PL8l8N2JhK5OikEb1E3DN4ZBolESFxqwg1bv0QYINH5tALx/kkLwGh5fH5bkoTJWoS7U6pldkv14seAYL9tLNVwExokzd0dPZ88bF8iNhwO6gbrJx7kK/DSEU9wcxOq68PtVyv389E3OKLJa0Z1oQkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397138; c=relaxed/simple;
	bh=HG9MO4y7d/mRf/kaNdvPBYM1BwuKLbFyc7R09Li8cWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWkWK2lIh78ebhhz9bJvBE49qlHUQrELH4O1e3nIjd6KISaq+5sTxL7VUy0hANpVsaNqHfQid4MOKG9Tf/w/vISlBOMvnyyJZX8XxVLPEKtIy9Bs3oAPzKFfDGya4ML4Vc73FWvoPCA8yY1HO7iX9vpYjI8mP//UWr1mZaVC+kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QP93u2OD; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731397136; x=1762933136;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HG9MO4y7d/mRf/kaNdvPBYM1BwuKLbFyc7R09Li8cWM=;
  b=QP93u2ODrz4lj++Z9v2Dva7Nl39vH4hwXbiz4FKbOwfUbchqX1ATbcfo
   fCHiogZGzLtssjqh9SDY+CgOtABOKAScTqVB5tQ0aPwBsvXCZ4BS9By3q
   ZF+Tv3rsbvFe7gsLlHtfoZXXJxBatM71inLxBQW6XrQiXShQcEOpEEDfo
   gZXeTaVH0c3MXJwDcXg/4sZh/BeP1H9fksVLfrVo3kU40ksI3SH27hip+
   faZdOzz8vb8igIb9ezQd/IsDtDArqaaaWOjyJr+4B92fZJAvzn039fgpL
   O96fKSmv1CISTf+HYTSfQCqq4FPpzkOSBhlvfW0AXgeo+OdZBCZS3UeCm
   g==;
X-CSE-ConnectionGUID: i7iy9ORvQs2RB4GJOPmgTg==
X-CSE-MsgGUID: b7LN8y1BTmeM4ZesoFDyqg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31389357"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31389357"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:38:56 -0800
X-CSE-ConnectionGUID: Mq+rblRIRzOqJJ6djdjhvg==
X-CSE-MsgGUID: q6j754+QTCOqD4i820HDNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="87736526"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:38:51 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 09/24] x86/virt/tdx: Add SEAMCALL wrapper tdh_mem_sept_add() to add SEPT pages
Date: Tue, 12 Nov 2024 15:36:24 +0800
Message-ID: <20241112073624.22114-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241112073327.21979-1-yan.y.zhao@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX architecture introduces the concept of private GPA vs shared GPA,
depending on the GPA.SHARED bit. The TDX module maintains a Secure EPT
(S-EPT or SEPT) tree per TD for private GPA to HPA translation. Wrap the
TDH.MEM.SEPT.ADD SEAMCALL with tdh_mem_sept_add() to provide pages to the
TDX module for building a TD's SEPT tree. (Refer to these pages as SEPT
pages).

Callers need to allocate and provide a normal page to tdh_mem_sept_add(),
which then passes the page to the TDX module via the SEAMCALL
TDH.MEM.SEPT.ADD. The TDX module then installs the page into SEPT tree and
encrypts this SEPT page with the TD's guest keyID. The kernel cannot use
the SEPT page until after reclaiming it via TDH.MEM.SEPT.REMOVE or
TDH.PHYMEM.PAGE.RECLAIM.

Before passing the page to the TDX module, tdh_mem_sept_add() performs a
CLFLUSH on the page mapped with keyID 0 to ensure that any dirty cache
lines don't write back later and clobber TD memory or control structures.
Don't worry about the other MK-TME keyIDs because the kernel doesn't use
them. The TDX docs specify that this flush is not needed unless the TDX
module exposes the CLFLUSH_BEFORE_ALLOC feature bit. Do the CLFLUSH
unconditionally for two reasons: make the solution simpler by having a
single path that can handle both !CLFLUSH_BEFORE_ALLOC and
CLFLUSH_BEFORE_ALLOC cases. Avoid wading into any correctness uncertainty
by going with a conservative solution to start.

Callers should specify "GPA" and "level" for the TDX module to install the
SEPT page at the specified position in the SEPT. Do not include the root
page level in "level" since TDH.MEM.SEPT.ADD can only add non-root pages to
the SEPT. Ensure "level" is between 1 and 3 for a 4-level SEPT or between 1
and 4 for a 5-level SEPT.

Call tdh_mem_sept_add() during the TD's build time or during the TD's
runtime. Check for errors from the function return value and retrieve
extended error info from the function output parameters.

The TDX module has many internal locks. To avoid staying in SEAM mode for
too long, SEAMCALLs returns a BUSY error code to the kernel instead of
spinning on the locks. Depending on the specific SEAMCALL, the caller
may need to handle this error in specific ways (e.g., retry). Therefore,
return the SEAMCALL error code directly to the caller. Don't attempt to
handle it in the core kernel.

TDH.MEM.SEPT.ADD effectively manages two internal resources of the TDX
module: it installs page table pages in the SEPT tree and also updates the
TDX module's page metadata (PAMT). Don't add a wrapper for the matching
SEAMCALL for removing a SEPT page (TDH.MEM.SEPT.REMOVE) because KVM, as the
only in-kernel user, will only tear down the SEPT tree when the TD is being
torn down. When this happens it can just do other operations that reclaim
the SEPT pages for the host kernels to use, update the PAMT and let the
SEPT get trashed.

[Kai: Switched from generic seamcall export]
[Yan: Re-wrote the changelog]
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
TDX MMU part 2 v2:
- split out TDH.MEM.SEPT.ADD and re-wrote the patch msg. (Yan)
- dropped TDH.MEM.SEPT.REMOVE. (Yan)
- split out from original patch "KVM: TDX: Add C wrapper functions for
  SEAMCALLs to the TDX module" and move to x86 core. (Kai)
---
 arch/x86/include/asm/tdx.h  |  1 +
 arch/x86/virt/vmx/tdx/tdx.c | 19 +++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 3 files changed, 21 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index d093dc4350ac..b6f3e5504d4d 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -124,6 +124,7 @@ void tdx_guest_keyid_free(unsigned int keyid);
 
 /* SEAMCALL wrappers for creating/destroying/running TDX guests */
 u64 tdh_mng_addcx(u64 tdr, u64 tdcs);
+u64 tdh_mem_sept_add(u64 tdr, u64 gpa, u64 level, u64 hpa, u64 *rcx, u64 *rdx);
 u64 tdh_vp_addcx(u64 tdvpr, u64 tdcx);
 u64 tdh_mng_key_config(u64 tdr);
 u64 tdh_mng_create(u64 tdr, u64 hkid);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index af121a73de80..1dc9be680475 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1575,6 +1575,25 @@ u64 tdh_mng_addcx(u64 tdr, u64 tdcs)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_addcx);
 
+u64 tdh_mem_sept_add(u64 tdr, u64 gpa, u64 level, u64 hpa, u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa | level,
+		.rdx = tdr,
+		.r8 = hpa,
+	};
+	u64 ret;
+
+	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	ret = seamcall_ret(TDH_MEM_SEPT_ADD, &args);
+
+	*rcx = args.rcx;
+	*rdx = args.rdx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mem_sept_add);
+
 u64 tdh_vp_addcx(u64 tdvpr, u64 tdcx)
 {
 	struct tdx_module_args args = {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index a63037036c91..7624d098515f 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -18,6 +18,7 @@
  * TDX module SEAMCALL leaf functions
  */
 #define TDH_MNG_ADDCX			1
+#define TDH_MEM_SEPT_ADD		3
 #define TDH_VP_ADDCX			4
 #define TDH_MNG_KEY_CONFIG		8
 #define TDH_MNG_CREATE			9
-- 
2.43.2


