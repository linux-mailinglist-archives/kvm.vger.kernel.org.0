Return-Path: <kvm+bounces-47537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E515AAC2035
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 11:54:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92243503AE5
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 09:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC4BA229B2C;
	Fri, 23 May 2025 09:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NRUNpqzB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41AB22576E;
	Fri, 23 May 2025 09:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747994008; cv=none; b=BckJh66uTo4PBgwgenUlLkvehvAbpFjNzUTaE9JnO2dimnS8N84Sc+uYI3mYGPsQCKwubxCH9ZzSONxAvS11qe+mgcTWV8ZcWrUtTBq2Wi0p5ijKdQB1XvHN6ipx+q81D4VmSiFs9i2VkC30fpuiSzjcpDE1pgFbPiI9k15rFXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747994008; c=relaxed/simple;
	bh=uDOwhjWlC6SFw0oeKfCiUA109BTevkrEVCjc1t3wJ94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTxjMQYsOksO73XG6tK/eKttQZBFXmXBMElCDSIt7IDPqsHDk4JgGm7B39zwsMyZ+jlSTg+FzG7Dw/UvnfoAFg0FvsWQSY7z1hX1c5uAMV0rBA5EHjHbvDOBnphHfgOI1NZjyQyHufOTUAMGtzfcDeNIAfKiTNz6RC8yQ8fEC8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NRUNpqzB; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747994006; x=1779530006;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uDOwhjWlC6SFw0oeKfCiUA109BTevkrEVCjc1t3wJ94=;
  b=NRUNpqzBnJrT5BAs1Z0MCb1upVAM+S1ATibO94EUxfI4MYPMRyeneREn
   ELdNrnmfzL85TTUqy7oUkvzNrU5n0uCvPddBDYb9teyGWU7a0KWo3dS/6
   9ZRMpjRCpmHErbMzv9p5leLRYUkZnGlVBqQURlGl4xxljH6ZUSXfs/09u
   ejh49kegSEDxVn263ZutnSCoWH7TF8vgq66L2HmKuj4jHsVs7XhDtObVn
   AWEgaZqWTBa4WNFitdyk4dsQQVvmDuM23jpwDZfur/cxRCqieV22DCWaJ
   SEPPliftQrXtvldL/lcL9E7gXa4DRm8LUQ1by6gWwpywqiRA/KSiV3zfq
   g==;
X-CSE-ConnectionGUID: O2v2YXSLR0yd7UsRzcxTCQ==
X-CSE-MsgGUID: ZLXjeRTKSxO61uX/AX8L3Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="75444099"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="75444099"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:24 -0700
X-CSE-ConnectionGUID: 6fstuCAeSlqDa5moTDEeGg==
X-CSE-MsgGUID: ADIJxU13R5OExswirUOP7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="164315038"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:24 -0700
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	x86@kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	eddie.dong@intel.com,
	kirill.shutemov@intel.com,
	dave.hansen@intel.com,
	dan.j.williams@intel.com,
	kai.huang@intel.com,
	isaku.yamahata@intel.com,
	elena.reshetova@intel.com,
	rick.p.edgecombe@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 02/20] x86/virt/tdx: Prepare to support P-SEAMLDR SEAMCALLs
Date: Fri, 23 May 2025 02:52:25 -0700
Message-ID: <20250523095322.88774-3-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250523095322.88774-1-chao.gao@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

P-SEAMLDR is another component alongside the TDX module within the
protected SEAM range. Software can invoke its functions by executing the
SEAMCALL instruction with the 63 bit of RAX set to 1. P-SEAMLDR SEAMCALLs
differ from those of the TDX module in terms of error codes and the
handling of the current VMCS.

In preparation for calling P-SEAMLDR functions to update the TDX module,
adjust the SEAMCALL infrastructure to support P-SEAMLDR SEAMCALLs and
expose a helper function.

Specifically,
1) P-SEAMLDR SEAMCALLs use a different error code for lack of entropy.
   Tweak sc_retry() to handle this difference.

2) Add a separate function to log the SEAMCALL leaf number and the error
   code.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
checking bit63 in sc_need_retry() may be suboptimal. An alternative is to
pass the "NO ENTROPY" error code from seamcall_prerr* and seamldr_prerr()
to sc_retry(). but this would need more code changes. I am not sure if it
is worthwhile.
---
 arch/x86/include/asm/tdx.h  | 20 +++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.c | 16 ++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  4 ++++
 3 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 26ffc792e673..b507d5233b03 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -32,6 +32,11 @@
 #define TDX_SUCCESS		0ULL
 #define TDX_RND_NO_ENTROPY	0x8000020300000000ULL
 
+/* SEAMLDR SEAMCALL leaf function error codes */
+#define SEAMLDR_RND_NO_ENTROPY	0x8000000000030001ULL
+
+#define SEAMLDR_SEAMCALL_MASK	_BITUL(63)
+
 #ifndef __ASSEMBLER__
 
 #include <uapi/asm/mce.h>
@@ -104,6 +109,19 @@ void tdx_init(void);
 
 typedef u64 (*sc_func_t)(u64 fn, struct tdx_module_args *args);
 
+static inline bool is_seamldr_call(u64 fn)
+{
+	return fn & SEAMLDR_SEAMCALL_MASK;
+}
+
+static inline bool sc_need_retry(u64 fn, u64 error_code)
+{
+	if (is_seamldr_call(fn))
+		return error_code == SEAMLDR_RND_NO_ENTROPY;
+	else
+		return error_code == TDX_RND_NO_ENTROPY;
+}
+
 static inline u64 sc_retry(sc_func_t func, u64 fn,
 			   struct tdx_module_args *args)
 {
@@ -112,7 +130,7 @@ static inline u64 sc_retry(sc_func_t func, u64 fn,
 
 	do {
 		ret = func(fn, args);
-	} while (ret == TDX_RND_NO_ENTROPY && --retry);
+	} while (sc_need_retry(fn, ret) && --retry);
 
 	return ret;
 }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 49267c865f18..b586329dd87d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -65,6 +65,17 @@ static inline void seamcall_err(u64 fn, u64 err, struct tdx_module_args *args)
 	pr_err("SEAMCALL (%lld) failed: 0x%016llx\n", fn, err);
 }
 
+static inline void seamldr_err(u64 fn, u64 err, struct tdx_module_args *args)
+{
+	/*
+	 * Get the actual leaf number. No need to print the bit used to
+	 * differentiate between SEAMLDR and TDX module as the "SEAMLDR"
+	 * string in the error message already provides that information.
+	 */
+	fn &= ~SEAMLDR_SEAMCALL_MASK;
+	pr_err("SEAMLDR (%lld) failed: 0x%016llx\n", fn, err);
+}
+
 static inline void seamcall_err_ret(u64 fn, u64 err,
 				    struct tdx_module_args *args)
 {
@@ -102,6 +113,11 @@ static inline int sc_retry_prerr(sc_func_t func, sc_err_func_t err_func,
 #define seamcall_prerr_ret(__fn, __args)					\
 	sc_retry_prerr(__seamcall_ret, seamcall_err_ret, (__fn), (__args))
 
+int seamldr_prerr(u64 fn, struct tdx_module_args *args)
+{
+	return sc_retry_prerr(__seamcall, seamldr_err, fn, args);
+}
+
 /*
  * Do the module global initialization once and return its result.
  * It can be done on any cpu.  It's always called with interrupts
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 82bb82be8567..48c0a850c621 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -4,6 +4,8 @@
 
 #include <linux/bits.h>
 
+#include <asm/tdx.h>
+
 /*
  * This file contains both macros and data structures defined by the TDX
  * architecture and Linux defined software data structures and functions.
@@ -118,4 +120,6 @@ struct tdmr_info_list {
 	int max_tdmrs;	/* How many 'tdmr_info's are allocated */
 };
 
+int seamldr_prerr(u64 fn, struct tdx_module_args *args);
+
 #endif
-- 
2.47.1


