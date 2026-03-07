Return-Path: <kvm+bounces-73194-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +Hu/Ett5q2nsdQEAu9opvQ
	(envelope-from <kvm+bounces-73194-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:05:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A9BB2293AB
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:05:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 53B9A310C6DE
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 01:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCE952C15AC;
	Sat,  7 Mar 2026 01:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ur+CzO9e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE867284880;
	Sat,  7 Mar 2026 01:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772845454; cv=none; b=XFPOg+6SNpH/J38EGv1bHlimH/yZ6r/bu+qtiky94YFWIEBNU1qJijpwzlVWhPkcH54gHWotTeWpNj0nBgKJtq0Mg/Ya6nCv14zV5OmRKmUU0/uN51SW20Lrjrpx2M7BppOgaqLtAzJEeJkTkhIhTRj/yL4IBZljJKefvb5otRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772845454; c=relaxed/simple;
	bh=g/D2jQlObfVMXooMIoY7xGv3HKXJWcnBX6Rf9c1bpsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yaz4UyClWSYs3rueMvg5kKZ/EpYllN02J4nxYe+eZrtSLCadQur3OOamd9EyjfhVm97A9Z56nrZTi6hfDOEkX0nOSYturGa6m8wTA4qamxHxPXk+XxiWFjef9sVCdxTqtxfYWEg9q7OJx8t0M9CkYTUR3jYZC3AHNOfuI+wri8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ur+CzO9e; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772845451; x=1804381451;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g/D2jQlObfVMXooMIoY7xGv3HKXJWcnBX6Rf9c1bpsY=;
  b=Ur+CzO9evmcJvXC92Nbkr4DN78PC/P+fZD9/oZSzJ4UZAl9nO3RKnEKB
   aSAzXxwCnJDKZfpM8SkIT9g8ERJdeJ63CkuNlaG2NSZvS5zq7f7nMHKcH
   E5Kw/AB5ALcy+N+3L/L+n9jAz+/aOhLZxzMlSV168ODNwjIFaM/LjEoYt
   MCKaRbhkxpJQ3qqNlv39N8gOaFrPhQ8Uawgs1JAr09cCHSD95ra2oVrNq
   iHrL0owJnitKUFQ5CUg+w7Osn8SIt69OA/go+kP+4BLsNsOqh/CUstZEr
   2B9xd6gpRonDiG05EizeDcSrj4ZtJkU1+cb4PKAkyqWimDqIa6CSPsm+I
   w==;
X-CSE-ConnectionGUID: hMWsm3KQTNG61OGNBrx9WQ==
X-CSE-MsgGUID: hN/ZQvpERYe0risinNRc2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="76565940"
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="76565940"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 17:04:08 -0800
X-CSE-ConnectionGUID: FBMnce3WTIqNwEt6qBdX3w==
X-CSE-MsgGUID: NSaiEWrsSaivLt3guM7IWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="218329617"
Received: from rpedgeco-desk.jf.intel.com ([10.88.27.139])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 17:04:08 -0800
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: bp@alien8.de,
	dave.hansen@intel.com,
	hpa@zytor.com,
	kas@kernel.org,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	tglx@kernel.org,
	x86@kernel.org,
	chao.gao@intel.com,
	kai.huang@intel.com,
	ackerleytng@google.com
Cc: rick.p.edgecombe@intel.com,
	vishal.l.verma@intel.com,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Sagi Shahar <sagis@google.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH 1/4] x86/tdx: Move all TDX error defines into <asm/shared/tdx_errno.h>
Date: Fri,  6 Mar 2026 17:03:55 -0800
Message-ID: <20260307010358.819645-2-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260307010358.819645-1-rick.p.edgecombe@intel.com>
References: <20260307010358.819645-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9A9BB2293AB
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[20];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73194-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.987];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Today there are two separate locations where TDX error codes are defined:
         arch/x86/include/asm/tdx.h
         arch/x86/kvm/vmx/tdx_errno.h

They have some overlap that is already defined similarly. Reduce the
duplication and prepare to introduce some helpers for these error codes in
the central place by unifying them. Join them at:
        asm/shared/tdx_errno.h
...and update the headers that contained the duplicated definitions to
include the new unified header.

Place the new header in "asm/shared". While the compressed code for the
guest doesn't use these error code header definitions today, it does
make the types of calls that return the values they define. Place the
defines in "shared" location so that compressed code has the definitions
accessible, but leave cleanups to use proper error codes for future
changes.

Opportunistically massage some comments. Also, adjust
_BITUL()->_BITULL() to address 32 bit build errors after the move.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
[enhance log]
Tested-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Acked-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/shared/tdx.h             |  1 +
 .../vmx => include/asm/shared}/tdx_errno.h    | 27 +++++++++++++++----
 arch/x86/include/asm/tdx.h                    | 20 --------------
 arch/x86/kvm/vmx/tdx.h                        |  1 -
 4 files changed, 23 insertions(+), 26 deletions(-)
 rename arch/x86/{kvm/vmx => include/asm/shared}/tdx_errno.h (65%)

diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index 8bc074c8d7c6..6a1646fc2b2f 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -4,6 +4,7 @@
 
 #include <linux/bits.h>
 #include <linux/types.h>
+#include <asm/shared/tdx_errno.h>
 
 #define TDX_HYPERCALL_STANDARD  0
 
diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/include/asm/shared/tdx_errno.h
similarity index 65%
rename from arch/x86/kvm/vmx/tdx_errno.h
rename to arch/x86/include/asm/shared/tdx_errno.h
index 6ff4672c4181..3aa74f6a6119 100644
--- a/arch/x86/kvm/vmx/tdx_errno.h
+++ b/arch/x86/include/asm/shared/tdx_errno.h
@@ -1,14 +1,16 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* architectural status code for SEAMCALL */
+#ifndef _X86_SHARED_TDX_ERRNO_H
+#define _X86_SHARED_TDX_ERRNO_H
 
-#ifndef __KVM_X86_TDX_ERRNO_H
-#define __KVM_X86_TDX_ERRNO_H
+#include <asm/trapnr.h>
 
+/* Upper 32 bit of the TDX error code encodes the status */
 #define TDX_SEAMCALL_STATUS_MASK		0xFFFFFFFF00000000ULL
 
 /*
- * TDX SEAMCALL Status Codes (returned in RAX)
+ * TDX SEAMCALL Status Codes
  */
+#define TDX_SUCCESS				0ULL
 #define TDX_NON_RECOVERABLE_VCPU		0x4000000100000000ULL
 #define TDX_NON_RECOVERABLE_TD			0x4000000200000000ULL
 #define TDX_NON_RECOVERABLE_TD_NON_ACCESSIBLE	0x6000000500000000ULL
@@ -17,6 +19,7 @@
 #define TDX_OPERAND_INVALID			0xC000010000000000ULL
 #define TDX_OPERAND_BUSY			0x8000020000000000ULL
 #define TDX_PREVIOUS_TLB_EPOCH_BUSY		0x8000020100000000ULL
+#define TDX_RND_NO_ENTROPY			0x8000020300000000ULL
 #define TDX_PAGE_METADATA_INCORRECT		0xC000030000000000ULL
 #define TDX_VCPU_NOT_ASSOCIATED			0x8000070200000000ULL
 #define TDX_KEY_GENERATION_FAILED		0x8000080000000000ULL
@@ -28,6 +31,20 @@
 #define TDX_EPT_ENTRY_STATE_INCORRECT		0xC0000B0D00000000ULL
 #define TDX_METADATA_FIELD_NOT_READABLE		0xC0000C0200000000ULL
 
+/*
+ * SW-defined error codes.
+ *
+ * Bits 47:40 == 0xFF indicate Reserved status code class that never used by
+ * TDX module.
+ */
+#define TDX_ERROR			_BITULL(63)
+#define TDX_NON_RECOVERABLE		_BITULL(62)
+#define TDX_SW_ERROR			(TDX_ERROR | GENMASK_ULL(47, 40))
+#define TDX_SEAMCALL_VMFAILINVALID	(TDX_SW_ERROR | _ULL(0xFFFF0000))
+
+#define TDX_SEAMCALL_GP			(TDX_SW_ERROR | X86_TRAP_GP)
+#define TDX_SEAMCALL_UD			(TDX_SW_ERROR | X86_TRAP_UD)
+
 /*
  * TDX module operand ID, appears in 31:0 part of error code as
  * detail information
@@ -37,4 +54,4 @@
 #define TDX_OPERAND_ID_SEPT			0x92
 #define TDX_OPERAND_ID_TD_EPOCH			0xa9
 
-#endif /* __KVM_X86_TDX_ERRNO_H */
+#endif /* _X86_SHARED_TDX_ERRNO_H */
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index a149740b24e8..0c1ae4954f17 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -12,26 +12,6 @@
 #include <asm/trapnr.h>
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
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index b5cd2ffb303e..ac8323a68b16 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -3,7 +3,6 @@
 #define __KVM_X86_VMX_TDX_H
 
 #include "tdx_arch.h"
-#include "tdx_errno.h"
 
 #ifdef CONFIG_KVM_INTEL_TDX
 #include "common.h"
-- 
2.53.0


