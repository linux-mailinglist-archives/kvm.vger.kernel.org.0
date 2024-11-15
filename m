Return-Path: <kvm+bounces-31970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 379499CF602
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 21:28:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA05B1F23AE0
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 20:28:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5563D1FBF6E;
	Fri, 15 Nov 2024 20:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="elL8ccAu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27071FB3FC;
	Fri, 15 Nov 2024 20:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731702049; cv=none; b=RFyzkGm8CHQWTit2rQZoYM96cqaPGbHJN42bY76KUztze8CyHgvVa8fL8PmI6e5dvUDlZMDJ0A4cztHvVwp7L0m9hh6QoNSCQalQ1LiG5+Sq+H+W6J814hOMnUTNAwGZLRKRdNEqbAWCRK9szFHw8680txvIb7G/jkTq26J10lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731702049; c=relaxed/simple;
	bh=LkOfsVoQdCHcuFKMR71CUvS0Y3CW9UvgY0qB1HoFsU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVPdmR/f3HyKj+tROnHMyAgEB8Ic+qTQTVEJraXsKqIEQU2nPxOXK+za5xHvqBx0xHQEBoecig9sIw9UH+RzOJPNswIBnGribMc2m+rsQmBG2blYSND/ftna1A9lp/q3DZoo6PCjGnQhfgTRXuStL0zON42dJ2c6rvMCnvqHXKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=elL8ccAu; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731702046; x=1763238046;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LkOfsVoQdCHcuFKMR71CUvS0Y3CW9UvgY0qB1HoFsU4=;
  b=elL8ccAuMpCqn3gnt5VDf5vob0BBIDu8J5UYSFElcEP80RN1J5yuUjY9
   TmlKbiwAGHaWSmHvb7WWmZlCW5pNAHTiYDIKAw005b4GOPf2pBO7Xcvmm
   vb3hMOQ9/Az7RKuyjjtLL6PgS5QxvaA8izSyyRWacJUSgZxe8oYXcr3Al
   NcWXlzeEm5fKZmzNEQxDzbT9zz/OEf71kKbJengiDe+PACiMjx3IT/fFk
   QIpjJmc8c7tkUBhGh20IK2NOEr0nqvhVyeaq0lNmyM/HADXsH9E5QCKw0
   d+wrDSAZqDqeKSAkxs46aKwqZBeY8VNM1/lQslWfRPJO92phsCqYecd9n
   w==;
X-CSE-ConnectionGUID: nG2LAaG4TUqumzcj9daEow==
X-CSE-MsgGUID: UERBc9JZSieNBi1b3qv7KA==
X-IronPort-AV: E=McAfee;i="6700,10204,11257"; a="54228360"
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="54228360"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 12:20:44 -0800
X-CSE-ConnectionGUID: MuSy2kt4RLS9qv7RWaf8Tg==
X-CSE-MsgGUID: rhfJSvtIQGWz91c+K0sORw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="93599411"
Received: from jairdeje-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.173])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 12:20:43 -0800
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
Subject: [RFC PATCH 6/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX flush operations
Date: Fri, 15 Nov 2024 12:20:27 -0800
Message-ID: <20241115202028.1585487-7-rick.p.edgecombe@intel.com>
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
index 6a892727fdc8..7843a88dc90e 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -139,6 +139,8 @@ u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, hpa_t hkid);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
 u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data);
+u64 tdh_vp_flush(struct tdx_vp *vp);
+u64 tdh_mng_vpflushdone(struct tdx_td *td);
 u64 tdh_mng_key_freeid(struct tdx_td *td);
 u64 tdh_mng_init(struct tdx_td *td, u64 td_params, hpa_t *tdr);
 u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 28b3caf5a445..59cfbd1c91c0 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1649,6 +1649,26 @@ u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_rd);
 
+u64 tdh_vp_flush(struct tdx_vp *vp)
+{
+	struct tdx_module_args args = {
+		.rcx = vp->tdvpr,
+	};
+
+	return seamcall(TDH_VP_FLUSH, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_flush);
+
+u64 tdh_mng_vpflushdone(struct tdx_td *td)
+{
+	struct tdx_module_args args = {
+		.rcx = td->tdr,
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
2.47.0


