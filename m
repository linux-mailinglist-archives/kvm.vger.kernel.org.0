Return-Path: <kvm+bounces-32870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 63EBE9E10A0
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 02:04:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28B5F280718
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 01:04:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B97D127E18;
	Tue,  3 Dec 2024 01:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SiPdOf6k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C88238DDB;
	Tue,  3 Dec 2024 01:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733187819; cv=none; b=Qzl2pd+xEsuTXdLS8RqK4Bl38USOcE6LkSDCFDXrlAgU5RcgpRAGJlgsrrnWfRxQqyCWODM1B8y7ZRxu00jcDYidA+Mv7lX50hz49LGwtlYUaGXUfWjnUxj7zn7qGxgBmXvZy7m1/ynBoEN+lQhU+oadI3XjEHfiOOmGD/Ydus0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733187819; c=relaxed/simple;
	bh=54DU+ONjh4pkPzhTAsMKat9UD+OUecZLuC3YL4VA5Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDXrSAwg1O3iuVC0sJvyg2+VEYJj7WRSqwlPUMBPZZV5YTA27KP/5B1ffekx0R6yGoRldrdSpSO+akC7+gGp+73sPCBQQPPnvLaYC/4ecsvZvnypwfe0JfytbpGxPf6/2ugAONvKm3kzYY2L2mBiTzjL19M+p0sjA6rKQEpYTsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SiPdOf6k; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733187818; x=1764723818;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=54DU+ONjh4pkPzhTAsMKat9UD+OUecZLuC3YL4VA5Jg=;
  b=SiPdOf6keHa2RbHiqilztUYmNqiFr1pfnnUrpwuSZhB7vuzQiaKNeueO
   V5+nPtQkNlTVfXLn4QavPr8gDpxN3ApSNZw8pYoFv8xGrA0WNzRxCcq1e
   vsGDcYpsx0ZdW0wTZRtQ1FJyQMRpsSFe2u81uEUTBReCgu7Ea0nGXNKlX
   1scTR1iIU0vNW/IdOSLYDE4JdbP8mE+JBHkZWz34eEc9XGcVe1hZ3F0TV
   BQXJ7e3OcdABUUn6aZyokfK0Q2+To29nLS3bIbqB2TkI86h3HQpb/l1Hz
   MyOi1E9202N9JODbw8ApAX5t4oNLZgVPnuSqLTUnxHn3GDjpVPZ7LS4u3
   A==;
X-CSE-ConnectionGUID: KZVbm9IzQPOQVfhV3jLPug==
X-CSE-MsgGUID: V+tf/fnqQ1inTnITZfHazg==
X-IronPort-AV: E=McAfee;i="6700,10204,11274"; a="36237964"
X-IronPort-AV: E=Sophos;i="6.12,203,1728975600"; 
   d="scan'208";a="36237964"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 17:03:35 -0800
X-CSE-ConnectionGUID: IpUsdDMERxeA+bnUhyRJtQ==
X-CSE-MsgGUID: HilZh7QzTLCppxwX9+G2SA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,203,1728975600"; 
   d="scan'208";a="116535806"
Received: from jairdeje-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.7])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 17:03:28 -0800
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
Subject: [RFC PATCH v2 6/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX flush operations
Date: Mon,  2 Dec 2024 17:03:16 -0800
Message-ID: <20241203010317.827803-7-rick.p.edgecombe@intel.com>
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
attacks. The TDX module has the concept of flushing vCPUs. These flushes
include both a flush of the translation caches and also any other state
internal to the TDX module. Before freeing a KeyID, this flush operation
needs to be done. KVM will need to perform the flush on each pCPU
associated with the TD, and also perform a TD scoped operation that checks
if the flush has been done on all vCPU's associated with the TD.

Add a tdh_vp_flush() function to be used to call TDH.VP.FLUSH on each pCPU
associated with the TD during TD teardown. It will also be called when
disabling TDX and during vCPU migration between pCPUs.

Add tdh_mng_vpflushdone() to be used by KVM to call TDH.MNG.VPFLUSHDONE.
KVM will use this during TD teardown to verify that TDH.VP.FLUSH has been
called sufficiently, and advance the state machine that will allow for
reclaiming the TD's KeyID.

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
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/virt/vmx/tdx/tdx.c | 20 ++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  2 ++
 3 files changed, 24 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 9bc3c1160d43..bbb8f0bae9ba 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -148,6 +148,8 @@ u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, u64 hkid);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
 u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data);
+u64 tdh_vp_flush(struct tdx_vp *vp);
+u64 tdh_mng_vpflushdone(struct tdx_td *td);
 u64 tdh_mng_key_freeid(struct tdx_td *td);
 u64 tdh_mng_init(struct tdx_td *td, u64 td_params, u64 *extended_err);
 u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 6d35ea5b238f..b30ee1cff22f 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1660,6 +1660,26 @@ u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_rd);
 
+u64 tdh_vp_flush(struct tdx_vp *vp)
+{
+	struct tdx_module_args args = {
+		.rcx = tdx_tdvpr_pa(vp),
+	};
+
+	return seamcall(TDH_VP_FLUSH, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_flush);
+
+u64 tdh_mng_vpflushdone(struct tdx_td *td)
+{
+	struct tdx_module_args args = {
+		.rcx = tdx_tdr_pa(td),
+	};
+
+	return seamcall(TDH_MNG_VPFLUSHDONE, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_mng_vpflushdone);
+
 u64 tdh_mng_key_freeid(struct tdx_td *td)
 {
 	struct tdx_module_args args = {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 5179fc02d109..08b01b7fe7c2 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -22,6 +22,8 @@
 #define TDH_MNG_KEY_CONFIG		8
 #define TDH_MNG_CREATE			9
 #define TDH_MNG_RD			11
+#define TDH_VP_FLUSH			18
+#define TDH_MNG_VPFLUSHDONE		19
 #define TDH_VP_CREATE			10
 #define TDH_MNG_KEY_FREEID		20
 #define TDH_MNG_INIT			21
-- 
2.47.1


