Return-Path: <kvm+bounces-30087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4037F9B6C9D
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:05:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 005A32829B3
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:05:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCE5C2194B9;
	Wed, 30 Oct 2024 19:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KbxQydTq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D372185B7;
	Wed, 30 Oct 2024 19:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314867; cv=none; b=MTXPUqtR7MXx6+u7YDlAkRiv/IFUoCAuyCcO+2fwXJgA03ItKNdzg0r4URFRxvxN8jOoGVlw8UeAT4xCIkhG9nEh5QgqL7HaAacWWzWhwf1vUdSoMRSzNATUyDY7sFqNbZWPeBUTNEsHe9cRC8TPJ3MUdwehE2t7XVM+sJs4WMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314867; c=relaxed/simple;
	bh=QKmL1dXWlxybwbuO7zWK3CjAUm54v58gDsSxoui5AdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JciO+V4AXg0LKLQfDDPg/NWKrBLSUNj7Oe4kWIqYubG69KX+oo0he2StqB2yygUHsKCD7lKkZITT6YOco+nBwitxDHU0rjIGyRCebJ37R7sw9YEyGiU5qtZkMMj+sojC87VW4FnFVl35OmyLtieB8dZ/3RdKbCAJdxk9AkNdLG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KbxQydTq; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730314865; x=1761850865;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QKmL1dXWlxybwbuO7zWK3CjAUm54v58gDsSxoui5AdE=;
  b=KbxQydTqELORbCQXH5tzi54jjdzC3wW6mCzzPD2J5RaaOVtaK2mcwqUt
   6gpr9C79TjetVCvewDH7Nzkkdoce7Uu6JdTVaiu9uWLnc+HLMpTzbC6EA
   hAIvNYUC6pQcwmqbNV2QEHihe5LUY96c1gsBqW1Y2QZb+KzoPcI5cE/+Z
   Tf0AsiWE2a+xfjSqqHurqJEML8y5ha+Cr9mAQx26D+FUteZVX6nhnAAU5
   kHj1NKOw3EsS+s+H2HgwK2Q4PN1QVbesgBN+VFNLX07m6Nf/hCYKhBcEa
   bRbq1D+v+a/QFetTqKwbKaBbNryEm49k79AFgQDsKY+nmjlp4d66A9VKr
   A==;
X-CSE-ConnectionGUID: Z2wyeFgQSSuhs/uNOxPvxg==
X-CSE-MsgGUID: LFGu1TvySnyp7mdqIn5wsg==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17678760"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="17678760"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:00:59 -0700
X-CSE-ConnectionGUID: Y970gQYWQSKgCZbOx/JWbg==
X-CSE-MsgGUID: eL8nNDU2QlK420knL8JN0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82499364"
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
Subject: [PATCH v2 09/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX VM/vCPU field access
Date: Wed, 30 Oct 2024 12:00:22 -0700
Message-ID: <20241030190039.77971-10-rick.p.edgecombe@intel.com>
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

---
 arch/x86/include/asm/tdx.h  |  3 +++
 arch/x86/virt/vmx/tdx/tdx.c | 47 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  3 +++
 3 files changed, 53 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 0cf8975759de..a70933ec7808 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -128,9 +128,12 @@ u64 tdh_vp_addcx(u64 tdvpr, u64 tdcx);
 u64 tdh_mng_key_config(u64 tdr);
 u64 tdh_mng_create(u64 tdr, u64 hkid);
 u64 tdh_vp_create(u64 tdr, u64 tdvpr);
+u64 tdh_mng_rd(u64 tdr, u64 field, u64 *data);
 u64 tdh_mng_key_freeid(u64 tdr);
 u64 tdh_mng_init(u64 tdr, u64 td_params, u64 *rcx);
 u64 tdh_vp_init(u64 tdvpr, u64 initial_rcx);
+u64 tdh_vp_rd(u64 tdvpr, u64 field, u64 *data);
+u64 tdh_vp_wr(u64 tdvpr, u64 field, u64 data, u64 mask);
 u64 tdh_vp_init_apicid(u64 tdvpr, u64 initial_rcx, u32 x2apicid);
 u64 tdh_phymem_page_reclaim(u64 page, u64 *rcx, u64 *rdx, u64 *r8);
 u64 tdh_phymem_cache_wb(bool resume);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 7e7c2e2360af..82820422d698 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1621,6 +1621,23 @@ u64 tdh_vp_create(u64 tdr, u64 tdvpr)
 }
 EXPORT_SYMBOL_GPL(tdh_vp_create);
 
+u64 tdh_mng_rd(u64 tdr, u64 field, u64 *data)
+{
+	struct tdx_module_args args = {
+		.rcx = tdr,
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
 u64 tdh_mng_key_freeid(u64 tdr)
 {
 	struct tdx_module_args args = {
@@ -1658,6 +1675,36 @@ u64 tdh_vp_init(u64 tdvpr, u64 initial_rcx)
 }
 EXPORT_SYMBOL_GPL(tdh_vp_init);
 
+u64 tdh_vp_rd(u64 tdvpr, u64 field, u64 *data)
+{
+	struct tdx_module_args args = {
+		.rcx = tdvpr,
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
+u64 tdh_vp_wr(u64 tdvpr, u64 field, u64 data, u64 mask)
+{
+	struct tdx_module_args args = {
+		.rcx = tdvpr,
+		.rdx = field,
+		.r8 = data,
+		.r9 = mask,
+	};
+
+	return seamcall(TDH_VP_WR, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_wr);
+
 u64 tdh_vp_init_apicid(u64 tdvpr, u64 initial_rcx, u32 x2apicid)
 {
 	struct tdx_module_args args = {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 191bdd1e571d..1915a558c126 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -22,10 +22,12 @@
 #define TDH_MNG_KEY_CONFIG		8
 #define TDH_MNG_CREATE			9
 #define TDH_VP_CREATE			10
+#define TDH_MNG_RD			11
 #define TDH_MNG_KEY_FREEID		20
 #define TDH_MNG_INIT			21
 #define TDH_VP_INIT			22
 #define TDH_PHYMEM_PAGE_RDMD		24
+#define TDH_VP_RD			26
 #define TDH_PHYMEM_PAGE_RECLAIM		28
 #define TDH_SYS_KEY_CONFIG		31
 #define TDH_SYS_INIT			33
@@ -33,6 +35,7 @@
 #define TDH_SYS_LP_INIT			35
 #define TDH_SYS_TDMR_INIT		36
 #define TDH_PHYMEM_CACHE_WB		40
+#define TDH_VP_WR			43
 #define TDH_PHYMEM_PAGE_WBINVD		41
 #define TDH_SYS_CONFIG			45
 
-- 
2.47.0


