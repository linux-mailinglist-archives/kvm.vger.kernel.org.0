Return-Path: <kvm+bounces-32873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36F1A9E10A6
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 02:04:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EEBE5281BC3
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 01:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B538217E900;
	Tue,  3 Dec 2024 01:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aUlKwO1t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CDE13BC26;
	Tue,  3 Dec 2024 01:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733187822; cv=none; b=j4WEMgl7XZ/2b6V+RctmGMpnatD8Ofyz19ZvZdw5Y+ph/rFjrfl96s0ahjcyU9bSiWR+BVO6UseQ9hc/Z2ILEj/uAyco5S39vhoanpAtzrIPpqlKdTROEyHzf0BhP2Awcvl1b8ScBnZNmYyaQqgRetrVL0Ry31a8D+05tgk3boA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733187822; c=relaxed/simple;
	bh=XgIw8C4zc2FbMwSPSQQEBwUlwsGZvZvMBluPPlEeKN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=so+xJgPhSDLPLJbnH5yT/DXq4rrcMNn2rO5cD5aNbun7zZqAwmV80xn7Y6D/Bt80M/lVsUueovN48VUmcfKyWx/IHKrh36h6V7AKADtC4plH1Kw/0//yJ6gYudGvjJEfWza4ae/l6NKueimBp1Q6ZZoH83tC4rqw7/EwHgLxPDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aUlKwO1t; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733187821; x=1764723821;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XgIw8C4zc2FbMwSPSQQEBwUlwsGZvZvMBluPPlEeKN4=;
  b=aUlKwO1tzdF8D6v+8QvghUqRpRwm/V5MnO5brnvRSwILijkxB7KZ2S0h
   9NLk1cSfKASqf8qE78CaUOD+Uijh6flH7CLl4XXIkGzavvrmGj423Uuhk
   Ok4R+wUKKjNVq8Qm4dGa7ggZNJ0gbUZ0NuBYxj8l7bSHuGh5HGCMz/8xF
   StfM0YNecFb6aIStOUGNaswAl9lBD4WCdkUyMfUIVbGCJfIpbeSsZsC42
   OVmSEB2K9MIMNgdJhnOV4BsFxesWfj1Q3xE0ULZ0mHBSRGtzydNFJBhiH
   YkVMcBBYp52SUwhKYekOKqfarWgNhJyQlWkvx0Zsv1q7rEozYQn7y8tph
   Q==;
X-CSE-ConnectionGUID: guNICuOiSBm4nndHwKj1vQ==
X-CSE-MsgGUID: PheE++vQSNWZoxv9TrzhHw==
X-IronPort-AV: E=McAfee;i="6700,10204,11274"; a="36237985"
X-IronPort-AV: E=Sophos;i="6.12,203,1728975600"; 
   d="scan'208";a="36237985"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 17:03:35 -0800
X-CSE-ConnectionGUID: at0paRHoTHyktfHPe+BhHA==
X-CSE-MsgGUID: uraSvL7rSyWUEXgO90iWgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,203,1728975600"; 
   d="scan'208";a="116535803"
Received: from jairdeje-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.7])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 17:03:27 -0800
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
Subject: [RFC PATCH v2 5/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX VM/vCPU field access
Date: Mon,  2 Dec 2024 17:03:15 -0800
Message-ID: <20241203010317.827803-6-rick.p.edgecombe@intel.com>
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
index f6ab8a9ea46b..9bc3c1160d43 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -147,9 +147,12 @@ u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page);
 u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, u64 hkid);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
+u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data);
 u64 tdh_mng_key_freeid(struct tdx_td *td);
 u64 tdh_mng_init(struct tdx_td *td, u64 td_params, u64 *extended_err);
 u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx);
+u64 tdh_vp_rd(struct tdx_vp *vp, u64 field, u64 *data);
+u64 tdh_vp_wr(struct tdx_vp *vp, u64 field, u64 data, u64 mask);
 u64 tdh_vp_init_apicid(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid);
 u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size);
 u64 tdh_phymem_cache_wb(bool resume);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index b2a1ed13d0da..6d35ea5b238f 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1643,6 +1643,23 @@ u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp)
 }
 EXPORT_SYMBOL_GPL(tdh_vp_create);
 
+u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data)
+{
+	struct tdx_module_args args = {
+		.rcx = tdx_tdr_pa(td),
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
@@ -1680,6 +1697,36 @@ u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx)
 }
 EXPORT_SYMBOL_GPL(tdh_vp_init);
 
+u64 tdh_vp_rd(struct tdx_vp *vp, u64 field, u64 *data)
+{
+	struct tdx_module_args args = {
+		.rcx = tdx_tdvpr_pa(vp),
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
+		.rcx = tdx_tdvpr_pa(vp),
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
2.47.1


