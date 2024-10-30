Return-Path: <kvm+bounces-30086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EA6B9B6C9A
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:04:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C7969B23711
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:04:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 940F1218D7E;
	Wed, 30 Oct 2024 19:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YDK/dtSN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEFC21765C;
	Wed, 30 Oct 2024 19:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314866; cv=none; b=HUOgsgk85IEl4YRl16nlWoh27p9i+QrgrSq/sf4rIpPHZtZ2/5t8pNAKlbk/ZY4XaXja5zyhSKlBXJmIZzfiIv/0zbl0/Bg37AXcGH9t0R6BAZpB8G7z4R4a0bftJx2idZZm45wLrm3G9hdzLRnFKgeDGQO1g+dvgRRjYrZRGfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314866; c=relaxed/simple;
	bh=SjyU2BjDGns7PRjLKlfcB4VDcu/rQNtiWvnjpu5j1rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnVx2qTBsYtScyP4VD6zBy1eICXyM6hry/LyCmCFief3yAe8rF8zBSitV0AtHlAp9e15PGqF61DCYSNO2/c7v+umAdT46LsoOJe4pVw0Jff3Nm2RSKV/OBP5mBV9s7El64zmXylk9yKkv/s0zr4JUw/IPXbgqQthqZy9KSv8xgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YDK/dtSN; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730314862; x=1761850862;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SjyU2BjDGns7PRjLKlfcB4VDcu/rQNtiWvnjpu5j1rk=;
  b=YDK/dtSNDIcTt7pJBT0CGsUMK+QbG+LXte/eeRfXj50ENendDpiqpXfb
   S0Z5YYwMN+S2NgtfoCMcKsh/sdim/uDqbsNyPuO8upGhe5OO8XOOzzWgH
   jP1h1GUfyP0Fg9nLRNcqX36XNDc3wV4fvTy62LPo0LcDmW50CISdVQ+sy
   8b194zGlwryoqQPcpIn6wqrrU+3lg7aa0n3o/UGVHz+BrUqLd4LDRI2Z8
   T+DLyoEhKUm1WRuP3n9zlu5IEd0Wl2I+MgEiMqsif1ZdLMCoky/DE4k7Q
   NaTHnYpOD5ToIjc2AqVsog5mrNhd1mASARqa2KuCpi3ZfBcpV5cdH3zOj
   w==;
X-CSE-ConnectionGUID: ILlFkWSmQFOc+7N88JEuYQ==
X-CSE-MsgGUID: ELAXIG+OSBihNCmdVnYzLQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17678755"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="17678755"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:00:58 -0700
X-CSE-ConnectionGUID: ZEZ6jH+BRHu2ufnvsQHr6Q==
X-CSE-MsgGUID: 63WGY/ogRi+CpjPAynOhXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82499358"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.186])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:00:58 -0700
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
Subject: [PATCH v2 08/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX page cache management
Date: Wed, 30 Oct 2024 12:00:21 -0700
Message-ID: <20241030190039.77971-9-rick.p.edgecombe@intel.com>
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
attacks. The TDX module uses pages provided by the host for both control
structures and for TD guest pages. These pages are encrypted using the
MK-TME encryption engine, with its special requirements around cache
invalidation. For its own security, the TDX module ensures pages are
flushed properly and track which usage they are currently assigned. For
creating and tearing down TD VMs and vCPUs KVM will need to use the
TDH.PHYMEM.PAGE.RECLAIM, TDH.PHYMEM.CACHE.WB, and TDH.PHYMEM.PAGE.WBINVD
SEAMCALLs.

Add tdh_phymem_page_reclaim() to enable KVM to call
TDH.PHYMEM.PAGE.RECLAIM to reclaim the page for use by the host kernel.
This effectively resets its state in the TDX module's page tracking
(PAMT), if the page is available to be reclaimed. This will be used by KVM
to reclaim the various types of pages owned by the TDX module. It will
have a small wrapper in KVM that retries in the case of a relevant error
code. Don't implement this wrapper in arch/x86 because KVM's solution
around retrying SEAMCALLs will be better located in a single place.

Add tdh_phymem_cache_wb() to enable KVM to call TDH.PHYMEM.CACHE.WB to do
a cache write back in a way that the TDX module can verify, before it
allows a KeyID to be freed. The KVM code will use this to have a small
wrapper that handles retries. Since the TDH.PHYMEM.CACHE.WB operation is
interruptible, have tdh_phymem_cache_wb() take a resume argument to pass
this info to the TDX module for restarts. It is worth noting that this
SEAMCALL uses a SEAM specific MSR to do the write back in sections. In
this way it does export some new functionality that affects CPU state.

Add tdh_phymem_page_wbinvd_tdr() to enable KVM to call
TDH.PHYMEM.PAGE.WBINVD to do a cache write back and invalidate of a TDR,
using the global KeyID. The underlying TDH.PHYMEM.PAGE.WBINVD SEAMCALL
requires the related KeyID to be encoded into the SEAMCALL args. Since the
global KeyID is not exposed to KVM, a dedicated wrapper is needed for TDR
focused TDH.PHYMEM.PAGE.WBINVD operations.

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
 arch/x86/include/asm/tdx.h  |  3 +++
 arch/x86/virt/vmx/tdx/tdx.c | 44 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  4 +++-
 3 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 6951faa37031..0cf8975759de 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -132,6 +132,9 @@ u64 tdh_mng_key_freeid(u64 tdr);
 u64 tdh_mng_init(u64 tdr, u64 td_params, u64 *rcx);
 u64 tdh_vp_init(u64 tdvpr, u64 initial_rcx);
 u64 tdh_vp_init_apicid(u64 tdvpr, u64 initial_rcx, u32 x2apicid);
+u64 tdh_phymem_page_reclaim(u64 page, u64 *rcx, u64 *rdx, u64 *r8);
+u64 tdh_phymem_cache_wb(bool resume);
+u64 tdh_phymem_page_wbinvd_tdr(u64 tdr);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index b3003031e0fe..7e7c2e2360af 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1670,3 +1670,47 @@ u64 tdh_vp_init_apicid(u64 tdvpr, u64 initial_rcx, u32 x2apicid)
 	return seamcall(TDH_VP_INIT | (1ULL << TDX_VERSION_SHIFT), &args);
 }
 EXPORT_SYMBOL_GPL(tdh_vp_init_apicid);
+
+u64 tdh_phymem_page_reclaim(u64 page, u64 *rcx, u64 *rdx, u64 *r8)
+{
+	struct tdx_module_args args = {
+		.rcx = page,
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_PHYMEM_PAGE_RECLAIM, &args);
+
+	/*
+	 * Additional error information:
+	 *
+	 *  - RCX: page type
+	 *  - RDX: owner
+	 *  - R8:  page size (4K, 2M or 1G)
+	 */
+	*rcx = args.rcx;
+	*rdx = args.rdx;
+	*r8 = args.r8;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_phymem_page_reclaim);
+
+u64 tdh_phymem_cache_wb(bool resume)
+{
+	struct tdx_module_args args = {
+		.rcx = resume ? 1 : 0,
+	};
+
+	return seamcall(TDH_PHYMEM_CACHE_WB, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_phymem_cache_wb);
+
+u64 tdh_phymem_page_wbinvd_tdr(u64 tdr)
+{
+	struct tdx_module_args args = {};
+
+	args.rcx = tdr | ((u64)tdx_global_keyid << boot_cpu_data.x86_phys_bits);
+
+	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_tdr);
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 64b6504791e1..191bdd1e571d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -26,14 +26,16 @@
 #define TDH_MNG_INIT			21
 #define TDH_VP_INIT			22
 #define TDH_PHYMEM_PAGE_RDMD		24
+#define TDH_PHYMEM_PAGE_RECLAIM		28
 #define TDH_SYS_KEY_CONFIG		31
 #define TDH_SYS_INIT			33
 #define TDH_SYS_RD			34
 #define TDH_SYS_LP_INIT			35
 #define TDH_SYS_TDMR_INIT		36
+#define TDH_PHYMEM_CACHE_WB		40
+#define TDH_PHYMEM_PAGE_WBINVD		41
 #define TDH_SYS_CONFIG			45
 
-
 /*
  * SEAMCALL leaf:
  *
-- 
2.47.0


