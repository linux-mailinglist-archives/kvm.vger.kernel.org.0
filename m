Return-Path: <kvm+bounces-31576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74CD49C4FB5
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:43:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB7AEB2772A
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:43:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7268C2123F0;
	Tue, 12 Nov 2024 07:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DQM0dRhu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E671320B807;
	Tue, 12 Nov 2024 07:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397182; cv=none; b=roaigA///RjxKBQBUlM8CX+C28ImUPX/DTd4dDzNvRLRwjibMBf4rYCjgE09UbCB5lMrBmQ4X7Xk2yCPW0sFd5uTTsepbUgjirYPZacbf9hlWwuy669+OIwuz0r3BxEISXNyT2cJja6aWTuwijcqCM35yzJwrMG3K83htN9Rauk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397182; c=relaxed/simple;
	bh=ikdXp3Cf8U+u3zRTfMhQoih6YK2g0+SWrWmE8if5VuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KtCWuUhWyDZWyjH9t4LZWlGCBfaVY3n3srhjoYE+w3bWU91LIicL/ac0SALnH0UGYsxh0qlf0cu66xBeiz7FCg/ETsNNHAcUICDg96+DnC3hZYwMMH71GPlhQEHiciKgE3kkm5fa7D01Tc8jaD99HwWx+boiFrmc1N2vMFptk2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DQM0dRhu; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731397181; x=1762933181;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ikdXp3Cf8U+u3zRTfMhQoih6YK2g0+SWrWmE8if5VuA=;
  b=DQM0dRhuDfAN7He3RUdKUJQPJY0cZ8PHDqKIgh2tudsJsNF5/me0eATP
   2MbyVv0Y8+K4MwWJSX1LtfPvcIf+RoTFNCw5hZvwJ6cXQ+Ns4rjftLper
   Oi165YFNFzYm2XZvry1LT0NVXA+MfCPgGXpYvtqYa9BUx/7C5IMpNtueQ
   DN54rqz446rg0VJj/EZY2/pVtVMxfP02w9oIpgC0SJJIqoXRmx5Bx5d8z
   rpg3qjL+NZ+do+ZbvQogB4rG/rEBwOyQS+ulHmb+sfuuIgWOyu9Ub2CUy
   Ftx5PZvHaZ0ypon2C5jSHoSUaBY8z59ZIXjN1MgoifdPLWLp5fiEe73D+
   Q==;
X-CSE-ConnectionGUID: F5ikCOUdRd2a5pLycStS2A==
X-CSE-MsgGUID: PdNWT59VTx6b/CSq77mGrw==
X-IronPort-AV: E=McAfee;i="6700,10204,11253"; a="31311312"
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="31311312"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:39:40 -0800
X-CSE-ConnectionGUID: 4hY3IAFzQPGO9X2uiX7EFw==
X-CSE-MsgGUID: 9cuMzUEzT22BAE2TgoKXzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="124830450"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:39:36 -0800
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
Subject: [PATCH v2 13/24] x86/virt/tdx: Add SEAMCALL wrappers for TD measurement of initial contents
Date: Tue, 12 Nov 2024 15:37:08 +0800
Message-ID: <20241112073709.22171-1-yan.y.zhao@intel.com>
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

The TDX module measures the TD during the build process and saves the
measurement in TDCS.MRTD to facilitate TD attestation of the initial
contents of the TD. Wrap the SEAMCALL TDH.MR.EXTEND with tdh_mr_extend()
and TDH.MR.FINALIZE with tdh_mr_finalize() to enable the host kernel to
assist the TDX module in performing the measurement.

The measurement in TDCS.MRTD is a SHA-384 digest of the build process.
SEAMCALLs TDH.MNG.INIT and TDH.MEM.PAGE.ADD initialize and contribute to
the MRTD digest calculation.

The caller of tdh_mr_extend() should break the TD private page into chunks
of size TDX_EXTENDMR_CHUNKSIZE and invoke tdh_mr_extend() to add the page
content into the digest calculation. Failures are possible with
TDH.MR.EXTEND (e.g., due to SEPT walking). The caller of tdh_mr_extend()
can check the function return value and retrieve extended error information
from the function output parameters.

Calling tdh_mr_finalize() completes the measurement. The TDX module then
turns the TD into the runnable state. Further TDH.MEM.PAGE.ADD and
TDH.MR.EXTEND calls will fail.

TDH.MR.FINALIZE may fail due to errors such as the TD having no vCPUs or
contentions. Check function return value when calling tdh_mr_finalize() to
determine the exact reason for failure. Take proper locks on the caller's
side to avoid contention failures, or handle the BUSY error in specific
ways (e.g., retry). Return the SEAMCALL error code directly to the caller.
Do not attempt to handle it in the core kernel.

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
- Rewrote the patch log (Yan).

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
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/virt/vmx/tdx/tdx.c | 27 +++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  2 ++
 3 files changed, 31 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index bad47415894b..fdc81799171e 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -133,6 +133,8 @@ u64 tdh_mng_key_config(u64 tdr);
 u64 tdh_mng_create(u64 tdr, u64 hkid);
 u64 tdh_vp_create(u64 tdr, u64 tdvpr);
 u64 tdh_mng_rd(u64 tdr, u64 field, u64 *data);
+u64 tdh_mr_extend(u64 tdr, u64 gpa, u64 *rcx, u64 *rdx);
+u64 tdh_mr_finalize(u64 tdr);
 u64 tdh_vp_flush(u64 tdvpr);
 u64 tdh_mng_vpflushdone(u64 tdr);
 u64 tdh_mng_key_freeid(u64 tdr);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 1b57486f2f06..7e0574facfb0 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1713,6 +1713,33 @@ u64 tdh_mng_rd(u64 tdr, u64 field, u64 *data)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_rd);
 
+u64 tdh_mr_extend(u64 tdr, u64 gpa, u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa,
+		.rdx = tdr,
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_MR_EXTEND, &args);
+
+	*rcx = args.rcx;
+	*rdx = args.rdx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mr_extend);
+
+u64 tdh_mr_finalize(u64 tdr)
+{
+	struct tdx_module_args args = {
+		.rcx = tdr,
+	};
+
+	return seamcall(TDH_MR_FINALIZE, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_mr_finalize);
+
 u64 tdh_vp_flush(u64 tdvpr)
 {
 	struct tdx_module_args args = {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 505203a89238..4919d00025c9 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -27,6 +27,8 @@
 #define TDH_MNG_CREATE			9
 #define TDH_VP_CREATE			10
 #define TDH_MNG_RD			11
+#define TDH_MR_EXTEND			16
+#define TDH_MR_FINALIZE			17
 #define TDH_VP_FLUSH			18
 #define TDH_MNG_VPFLUSHDONE		19
 #define TDH_MNG_KEY_FREEID		20
-- 
2.43.2


