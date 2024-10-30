Return-Path: <kvm+bounces-30090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 25BB99B6CA2
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:06:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7E06BB22686
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:06:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 939F421A713;
	Wed, 30 Oct 2024 19:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RkqNeDxC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4981D0E03;
	Wed, 30 Oct 2024 19:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314870; cv=none; b=jp8p8Hk4X30cjBZ/lz4OL8evXXEQUa+xQ9laZ90T1iiXZQTPxPsgpy+YwMiM/QxAjCi/ZOrvZ7AZZS4SI7ENvIhZAQ0B/Rwj4ylhJYGt+Ue6gwanVDlY7cBc0kkQuCcIaz0YC79qgGV84GcoMskxMAml0mbVufev61MFoOl6Rs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314870; c=relaxed/simple;
	bh=qwoM3hXtk8NjnongzOLCIGAUZzhoO9es9XXbY37Guow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrqZcUTl+We9I3rtnHUb3maaeIp37Ru0PThtbXinpLuKtMxlks/3nCguUZVPseRJLE6rLFBVMr/uJeQ7QwcQ+eXrkuvl9/uuYHXJG62or0G31AUkBELq/kP1BXY+VukixhkaRZ75tWrvtl0olt9efhCrOGbRqKjD6hBCElp4QdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RkqNeDxC; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730314868; x=1761850868;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qwoM3hXtk8NjnongzOLCIGAUZzhoO9es9XXbY37Guow=;
  b=RkqNeDxCaFg4hRLdYRW68KtldeBjegnus18BsMKhEPlyZK/URlGlIdxn
   h9vYvGme3aZJ1u9oCgfF4JCLONldsEw4P8jNO4QgQUA1rrr06qtzcQbrQ
   jrCBg02fbXj3HGmkDNFn8CXWEM2oJOmM2IIsXeQFku3BoHVPw479x7D50
   cnFfOSQom3wZb6iFIWhQgaspzpEypcEfkjCcoiCW3lN46wUTkXBE39VGP
   A+njbJHASP+qoOesNvLIA+uNZYFnLusCOMnSPurORfkBy9X+XrwFfP8XM
   ZxoPihsg75Y68XysXcf+oW2p7ffOlrOKHIiouc4YLauoR26MPLM1qn8jU
   g==;
X-CSE-ConnectionGUID: vUUTfk5aQJuVmSG+RUZkQA==
X-CSE-MsgGUID: Ib3QRcZuQBma+fK/YnIDaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17678787"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="17678787"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:02 -0700
X-CSE-ConnectionGUID: C23x65XRQvitv7PN8sBfQg==
X-CSE-MsgGUID: AXSKYaAXSlmS86T1AvXEvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82499395"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.186])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:01 -0700
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
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH v2 13/25] KVM: TDX: Add TDX "architectural" error codes
Date: Wed, 30 Oct 2024 12:00:26 -0700
Message-ID: <20241030190039.77971-14-rick.p.edgecombe@intel.com>
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
uAPI breakout v2:
 - Use TDVMCALL_STATUS prefix for TDX call status codes (Binbin)

v19:
 - Drop TDX_EPT_WALK_FAILED, TDX_EPT_ENTRY_NOT_FREE
 - Rename TDG_VP_VMCALL_ => TDVMCALL_ to match the existing code
 - Move TDVMCALL error codes to shared/tdx.h
 - Added TDX_OPERAND_ID_TDR
 - Fix bisectability issues in headers (Kai)
---
 arch/x86/include/asm/shared/tdx.h |  7 +++++-
 arch/x86/kvm/vmx/tdx.h            |  1 +
 arch/x86/kvm/vmx/tdx_errno.h      | 36 +++++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kvm/vmx/tdx_errno.h

diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index fdfd41511b02..620327f0161f 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -26,7 +26,12 @@
 #define TDVMCALL_GET_QUOTE		0x10002
 #define TDVMCALL_REPORT_FATAL_ERROR	0x10003
 
-#define TDVMCALL_STATUS_RETRY		1
+/*
+ * TDG.VP.VMCALL Status Codes (returned in R10)
+ */
+#define TDVMCALL_STATUS_SUCCESS		0x0000000000000000ULL
+#define TDVMCALL_STATUS_RETRY		0x0000000000000001ULL
+#define TDVMCALL_STATUS_INVALID_OPERAND	0x8000000000000000ULL
 
 /*
  * Bitmasks of exposed registers (with VMM).
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
2.47.0


