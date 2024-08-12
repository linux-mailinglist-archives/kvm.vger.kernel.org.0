Return-Path: <kvm+bounces-23897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 25B9794F9D7
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:49:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A75321F219E0
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:49:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8647119B595;
	Mon, 12 Aug 2024 22:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MmV85bOW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC1D19A2AE;
	Mon, 12 Aug 2024 22:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502913; cv=none; b=IJABgDo7MyMkTH2eKHtWk4iGEgBJtdavGpUW3EGL6MVmIvSkNj57tIRLgXDSoRjitzZvLfoQxo7BOmGEgiy6bG56GJ3E3Yk/6TTxO8JEOzNXqhrE7sJiEZNvhAk95NY2TzCH51NuFnGWHNapNCh27YT650jSqlGXfYHxaljZ1io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502913; c=relaxed/simple;
	bh=7VrVtd056X10mQnU4hD3X7Kr7wdDDNxHko0rQC+fBRU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JggFN+2Ld0GVJXvdcyEapB6NuH/lzMKQKG21NzfOGZ6HOar8CBdyaCZQUMuLuk8Kzcozm26ulqT8YiRcGSd5dnuff39fRo40c/Ya5yzt3Kp7v2qAsX7RI7EvkcsTMUta4mxppw1vtycpuT4n5B+czb6IxPMpNyHPY3DrryuJuHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MmV85bOW; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723502911; x=1755038911;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7VrVtd056X10mQnU4hD3X7Kr7wdDDNxHko0rQC+fBRU=;
  b=MmV85bOWsB+l6S+VaUIzZOqaWdMEGZ4N3e8QRSctOHRxi4FSH2Q7ZeBs
   xbGmVJ1ej9GMlibbITV8IFilQ5NGuZLzaxKrtye1IqlFW1yr7nGarkf8v
   WceC1IWAH8QEM4sbA7B3b0SJ4KhTCF03QtGJiWc+Ik9xh0AdISL2vliJK
   KxV/swIUsNURSQQj3VavI8ME+K37hM4oFETH0Vw7as2B5v1noKrC66Whi
   dgqvvue0NZU8YJwO/Lr6XnXq6U3igwBmM7/3ln7dmV/8CiiPhoqyUff6Y
   0fX0WNGWGj6p5iSWahfknrBS3LqRC39dv/QF/vcO9PCgqHyyUcLyUYCul
   A==;
X-CSE-ConnectionGUID: no6g4mHXRTmqu1UJaFVuYg==
X-CSE-MsgGUID: yXdeqTt/SgqeyDIRSte00A==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="33041336"
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="33041336"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:27 -0700
X-CSE-ConnectionGUID: rqlTNeK/TeCDGQSczzaj8A==
X-CSE-MsgGUID: e7rvOyWxRX+OHwWmOR9emw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="59008341"
Received: from jdoman-desk1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.222.53])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:27 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH 03/25] KVM: TDX: Add TDX "architectural" error codes
Date: Mon, 12 Aug 2024 15:47:58 -0700
Message-Id: <20240812224820.34826-4-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add error codes for the TDX SEAMCALLs both for TDX VMM side for TDH
SEAMCALL and TDX guest side for TDG.VP.VMCALL.  KVM issues the TDX
SEAMCALLs and checks its error code.  KVM handles hypercall from the TDX
guest and may return an error.  So error code for the TDX guest is also
needed.

TDX SEAMCALL uses bits 31:0 to return more information, so these error
codes will only exactly match RAX[63:32].  Error codes for TDG.VP.VMCALL is
defined by TDX Guest-Host-Communication interface spec.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
v19:
- Drop TDX_EPT_WALK_FAILED, TDX_EPT_ENTRY_NOT_FREE
- Rename TDG_VP_VMCALL_ => TDVMCALL_ to match the existing code
- Move TDVMCALL error codes to shared/tdx.h
- Added TDX_OPERAND_ID_TDR
- Fix bisectability issues in headers (Kai)
---
 arch/x86/include/asm/shared/tdx.h |  6 ++++++
 arch/x86/kvm/vmx/tdx.h            |  1 +
 arch/x86/kvm/vmx/tdx_errno.h      | 36 +++++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/tdx_errno.h

diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index fdfd41511b02..6ebbf8ee80b3 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -28,6 +28,12 @@
 
 #define TDVMCALL_STATUS_RETRY		1
 
+/*
+ * TDG.VP.VMCALL Status Codes (returned in R10)
+ */
+#define TDVMCALL_SUCCESS		0x0000000000000000ULL
+#define TDVMCALL_INVALID_OPERAND	0x8000000000000000ULL
+
 /*
  * Bitmasks of exposed registers (with VMM).
  */
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 1d6fa81a072d..faed454385ca 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -2,6 +2,7 @@
 #define __KVM_X86_VMX_TDX_H
 
 #include "tdx_arch.h"
+#include "tdx_errno.h"
 
 #ifdef CONFIG_INTEL_TDX_HOST
 void tdx_bringup(void);
diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
new file mode 100644
index 000000000000..dc3fa2a58c2c
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_errno.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* architectural status code for SEAMCALL */
+
+#ifndef __KVM_X86_TDX_ERRNO_H
+#define __KVM_X86_TDX_ERRNO_H
+
+#define TDX_SEAMCALL_STATUS_MASK		0xFFFFFFFF00000000ULL
+
+/*
+ * TDX SEAMCALL Status Codes (returned in RAX)
+ */
+#define TDX_NON_RECOVERABLE_VCPU		0x4000000100000000ULL
+#define TDX_INTERRUPTED_RESUMABLE		0x8000000300000000ULL
+#define TDX_OPERAND_INVALID			0xC000010000000000ULL
+#define TDX_OPERAND_BUSY			0x8000020000000000ULL
+#define TDX_PREVIOUS_TLB_EPOCH_BUSY		0x8000020100000000ULL
+#define TDX_PAGE_METADATA_INCORRECT		0xC000030000000000ULL
+#define TDX_VCPU_NOT_ASSOCIATED			0x8000070200000000ULL
+#define TDX_KEY_GENERATION_FAILED		0x8000080000000000ULL
+#define TDX_KEY_STATE_INCORRECT			0xC000081100000000ULL
+#define TDX_KEY_CONFIGURED			0x0000081500000000ULL
+#define TDX_NO_HKID_READY_TO_WBCACHE		0x0000082100000000ULL
+#define TDX_FLUSHVP_NOT_DONE			0x8000082400000000ULL
+#define TDX_EPT_WALK_FAILED			0xC0000B0000000000ULL
+#define TDX_EPT_ENTRY_STATE_INCORRECT		0xC0000B0D00000000ULL
+
+/*
+ * TDX module operand ID, appears in 31:0 part of error code as
+ * detail information
+ */
+#define TDX_OPERAND_ID_RCX			0x01
+#define TDX_OPERAND_ID_TDR			0x80
+#define TDX_OPERAND_ID_SEPT			0x92
+#define TDX_OPERAND_ID_TD_EPOCH			0xa9
+
+#endif /* __KVM_X86_TDX_ERRNO_H */
-- 
2.34.1


