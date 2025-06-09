Return-Path: <kvm+bounces-48752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 83D4BAD266E
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 21:14:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 084443B0B94
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 19:13:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03E6A21FF4C;
	Mon,  9 Jun 2025 19:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VeTNzltA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EEB21CC49;
	Mon,  9 Jun 2025 19:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749496437; cv=none; b=LzhABjXeffwUoi5GPL+tyP02Vf5hXERBR/3CjdCHixZY6LeiUpqWf2NZW5HaDc9mCyrEV6MLLCkkJkHiyZaBSNx6aeF0zM9JfxRKNKb0uVzS9NEATj+yC4abhk7ZxIHjDLXPW8lqiRmwncmhsG3AHatMOux6kFv4CM43pSbMwCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749496437; c=relaxed/simple;
	bh=nB6JOQr5Y06aT/tqLGB1sCtZdJ11IaKemE4Y42Ams54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iF5XaBWxX/KJQHWGPpxnGHHVJUNx6TvZ/FmITOBf226/gTCYLhqiLd5hXtsI+chFfZ9c0OVycQr3ava2evqmLM7mpNINWRNEs9+vxqDuyJ764JxWdBsRdmWnGduYDb5AhFMqvDy+HKl5bHYMhrGWtVeYbboXUESfuS0IIGRCJuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VeTNzltA; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749496435; x=1781032435;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nB6JOQr5Y06aT/tqLGB1sCtZdJ11IaKemE4Y42Ams54=;
  b=VeTNzltAKVaUW95oMo9ku8JGDfAWXUgibLVnCwLkuBhNEWsEXr7QEv0r
   fToWHwE4vRLewWxyX85yGSxpS1mb7WLkRkp5N1UOISFS1ep6iFMTTVxxq
   kO1Kvyx3xzqUnrPE3MPM8WosQ2lQ9Agk7TOlSZaEmiGdTj9hjBixiii+q
   vejxLCx6TYr7xCXrjAiuC0QjYkjDe9WNe5FUWyDt91m9lDugYlr/vI6lD
   KAUSxvCLTcpfC6cLBtHUuKHDk4ctmvgYG/Pqx+RWGdn/47Bq5dnwW7cRk
   gxiU5n0XWFsBhP8e+yE2sEoDciov2R9MLd70UOhzuAnNs8C3KdXkCWTmd
   w==;
X-CSE-ConnectionGUID: 7ep67eexRbmkQG7+kiVmYg==
X-CSE-MsgGUID: LAY2nM/VTsGsgQNVLGvZoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="51467248"
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="51467248"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 12:13:55 -0700
X-CSE-ConnectionGUID: KnXjtD1HTS61h5p+hpvigQ==
X-CSE-MsgGUID: A1iYLt12TLKcjJbCzm3L5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="147562156"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa008.jf.intel.com with ESMTP; 09 Jun 2025 12:13:51 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 01662168; Mon, 09 Jun 2025 22:13:48 +0300 (EEST)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	kvm@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2 01/12] x86/tdx: Consolidate TDX error handling
Date: Mon,  9 Jun 2025 22:13:29 +0300
Message-ID: <20250609191340.2051741-2-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move all (host, kvm, guest) code related to TDX error handling into
<asm/tdx_errno.h>.

Add inline functions to check errors.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/coco/tdx/tdx.c                       |  6 +-
 arch/x86/include/asm/tdx.h                    | 21 +------
 arch/x86/{kvm/vmx => include/asm}/tdx_errno.h | 60 +++++++++++++++++--
 arch/x86/kvm/vmx/tdx.c                        | 18 ++----
 arch/x86/kvm/vmx/tdx.h                        |  1 -
 5 files changed, 63 insertions(+), 43 deletions(-)
 rename arch/x86/{kvm/vmx => include/asm}/tdx_errno.h (52%)

diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index edab6d6049be..6505bfcd2a0d 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -33,10 +33,6 @@
 #define VE_GET_PORT_NUM(e)	((e) >> 16)
 #define VE_IS_IO_STRING(e)	((e) & BIT(4))
 
-/* TDX Module call error codes */
-#define TDCALL_RETURN_CODE(a)	((a) >> 32)
-#define TDCALL_INVALID_OPERAND	0xc0000100
-
 #define TDREPORT_SUBTYPE_0	0
 
 static atomic_long_t nr_shared;
@@ -127,7 +123,7 @@ int tdx_mcall_get_report0(u8 *reportdata, u8 *tdreport)
 
 	ret = __tdcall(TDG_MR_REPORT, &args);
 	if (ret) {
-		if (TDCALL_RETURN_CODE(ret) == TDCALL_INVALID_OPERAND)
+		if (tdx_operand_invalid(ret))
 			return -EINVAL;
 		return -EIO;
 	}
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 26ffc792e673..9649308bd9c0 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -10,28 +10,9 @@
 #include <asm/errno.h>
 #include <asm/ptrace.h>
 #include <asm/trapnr.h>
+#include <asm/tdx_errno.h>
 #include <asm/shared/tdx.h>
 
-/*
- * SW-defined error codes.
- *
- * Bits 47:40 == 0xFF indicate Reserved status code class that never used by
- * TDX module.
- */
-#define TDX_ERROR			_BITUL(63)
-#define TDX_NON_RECOVERABLE		_BITUL(62)
-#define TDX_SW_ERROR			(TDX_ERROR | GENMASK_ULL(47, 40))
-#define TDX_SEAMCALL_VMFAILINVALID	(TDX_SW_ERROR | _UL(0xFFFF0000))
-
-#define TDX_SEAMCALL_GP			(TDX_SW_ERROR | X86_TRAP_GP)
-#define TDX_SEAMCALL_UD			(TDX_SW_ERROR | X86_TRAP_UD)
-
-/*
- * TDX module SEAMCALL leaf function error codes
- */
-#define TDX_SUCCESS		0ULL
-#define TDX_RND_NO_ENTROPY	0x8000020300000000ULL
-
 #ifndef __ASSEMBLER__
 
 #include <uapi/asm/mce.h>
diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/include/asm/tdx_errno.h
similarity index 52%
rename from arch/x86/kvm/vmx/tdx_errno.h
rename to arch/x86/include/asm/tdx_errno.h
index 6ff4672c4181..d418934176e2 100644
--- a/arch/x86/kvm/vmx/tdx_errno.h
+++ b/arch/x86/include/asm/tdx_errno.h
@@ -1,14 +1,13 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* architectural status code for SEAMCALL */
 
-#ifndef __KVM_X86_TDX_ERRNO_H
-#define __KVM_X86_TDX_ERRNO_H
-
-#define TDX_SEAMCALL_STATUS_MASK		0xFFFFFFFF00000000ULL
+#ifndef _X86_TDX_ERRNO_H
+#define _X86_TDX_ERRNO_H
 
 /*
  * TDX SEAMCALL Status Codes (returned in RAX)
  */
+#define TDX_SUCCESS				0ULL
 #define TDX_NON_RECOVERABLE_VCPU		0x4000000100000000ULL
 #define TDX_NON_RECOVERABLE_TD			0x4000000200000000ULL
 #define TDX_NON_RECOVERABLE_TD_NON_ACCESSIBLE	0x6000000500000000ULL
@@ -17,6 +16,7 @@
 #define TDX_OPERAND_INVALID			0xC000010000000000ULL
 #define TDX_OPERAND_BUSY			0x8000020000000000ULL
 #define TDX_PREVIOUS_TLB_EPOCH_BUSY		0x8000020100000000ULL
+#define TDX_RND_NO_ENTROPY			0x8000020300000000ULL
 #define TDX_PAGE_METADATA_INCORRECT		0xC000030000000000ULL
 #define TDX_VCPU_NOT_ASSOCIATED			0x8000070200000000ULL
 #define TDX_KEY_GENERATION_FAILED		0x8000080000000000ULL
@@ -37,4 +37,54 @@
 #define TDX_OPERAND_ID_SEPT			0x92
 #define TDX_OPERAND_ID_TD_EPOCH			0xa9
 
-#endif /* __KVM_X86_TDX_ERRNO_H */
+#define TDX_STATUS_MASK				0xFFFFFFFF00000000ULL
+
+/*
+ * SW-defined error codes.
+ *
+ * Bits 47:40 == 0xFF indicate Reserved status code class that never used by
+ * TDX module.
+ */
+#define TDX_ERROR				_BITULL(63)
+#define TDX_NON_RECOVERABLE			_BITULL(62)
+#define TDX_SW_ERROR				(TDX_ERROR | GENMASK_ULL(47, 40))
+#define TDX_SEAMCALL_VMFAILINVALID		(TDX_SW_ERROR | _UL(0xFFFF0000))
+
+#define TDX_SEAMCALL_GP				(TDX_SW_ERROR | X86_TRAP_GP)
+#define TDX_SEAMCALL_UD				(TDX_SW_ERROR | X86_TRAP_UD)
+
+#ifndef __ASSEMBLER__
+#include <linux/bits.h>
+#include <linux/types.h>
+
+static inline u64 tdx_status(u64 err)
+{
+	return err & TDX_STATUS_MASK;
+}
+
+static inline bool tdx_sw_error(u64 err)
+{
+	return (err & TDX_SW_ERROR) == TDX_SW_ERROR;
+}
+
+static inline bool tdx_success(u64 err)
+{
+	return tdx_status(err) == TDX_SUCCESS;
+}
+
+static inline bool tdx_rnd_no_entropy(u64 err)
+{
+	return tdx_status(err) == TDX_RND_NO_ENTROPY;
+}
+
+static inline bool tdx_operand_invalid(u64 err)
+{
+	return tdx_status(err) == TDX_OPERAND_INVALID;
+}
+
+static inline bool tdx_operand_busy(u64 err)
+{
+	return tdx_status(err) == TDX_OPERAND_BUSY;
+}
+#endif /* __ASSEMBLER__ */
+#endif /* _X86_TDX_ERRNO_H */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b952bc673271..7a48bd901536 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -202,12 +202,6 @@ static DEFINE_MUTEX(tdx_lock);
 
 static atomic_t nr_configured_hkid;
 
-static bool tdx_operand_busy(u64 err)
-{
-	return (err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY;
-}
-
-
 /*
  * A per-CPU list of TD vCPUs associated with a given CPU.
  * Protected by interrupt mask. Only manipulated by the CPU owning this per-CPU
@@ -895,7 +889,7 @@ static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 	u32 exit_reason;
 
-	switch (tdx->vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) {
+	switch (tdx_status(tdx->vp_enter_ret)) {
 	case TDX_SUCCESS:
 	case TDX_NON_RECOVERABLE_VCPU:
 	case TDX_NON_RECOVERABLE_TD:
@@ -1957,7 +1951,7 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 	 * Handle TDX SW errors, including TDX_SEAMCALL_UD, TDX_SEAMCALL_GP and
 	 * TDX_SEAMCALL_VMFAILINVALID.
 	 */
-	if (unlikely((vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR)) {
+	if (tdx_sw_error(vp_enter_ret)) {
 		KVM_BUG_ON(!kvm_rebooting, vcpu->kvm);
 		goto unhandled_exit;
 	}
@@ -1982,7 +1976,7 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 	}
 
 	WARN_ON_ONCE(exit_reason.basic != EXIT_REASON_TRIPLE_FAULT &&
-		     (vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) != TDX_SUCCESS);
+		     !tdx_success(vp_enter_ret));
 
 	switch (exit_reason.basic) {
 	case EXIT_REASON_TRIPLE_FAULT:
@@ -2428,7 +2422,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 	err = tdh_mng_create(&kvm_tdx->td, kvm_tdx->hkid);
 	mutex_unlock(&tdx_lock);
 
-	if (err == TDX_RND_NO_ENTROPY) {
+	if (tdx_rnd_no_entropy(err)) {
 		ret = -EAGAIN;
 		goto free_packages;
 	}
@@ -2470,7 +2464,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 	kvm_tdx->td.tdcs_pages = tdcs_pages;
 	for (i = 0; i < kvm_tdx->td.tdcs_nr_pages; i++) {
 		err = tdh_mng_addcx(&kvm_tdx->td, tdcs_pages[i]);
-		if (err == TDX_RND_NO_ENTROPY) {
+		if (tdx_rnd_no_entropy(err)) {
 			/* Here it's hard to allow userspace to retry. */
 			ret = -EAGAIN;
 			goto teardown;
@@ -2483,7 +2477,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 	}
 
 	err = tdh_mng_init(&kvm_tdx->td, __pa(td_params), &rcx);
-	if ((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_INVALID) {
+	if (tdx_operand_invalid(err)) {
 		/*
 		 * Because a user gives operands, don't warn.
 		 * Return a hint to the user because it's sometimes hard for the
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 51f98443e8a2..dba23f1d21cb 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -3,7 +3,6 @@
 #define __KVM_X86_VMX_TDX_H
 
 #include "tdx_arch.h"
-#include "tdx_errno.h"
 
 #ifdef CONFIG_KVM_INTEL_TDX
 #include "common.h"
-- 
2.47.2


