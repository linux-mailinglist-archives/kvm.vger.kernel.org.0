Return-Path: <kvm+bounces-9652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A84D866C77
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:37:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA2152816BB
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:37:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD10658210;
	Mon, 26 Feb 2024 08:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JA1wXDvu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD265646E;
	Mon, 26 Feb 2024 08:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936078; cv=none; b=ZDK+8rCkIf44HCxRSQosSTmb1aV8fYuMzv2d4BPcGAd7+QdJmAyK/zH0ISrdQpZY+KjRbWGsGSP6iCdilmUmWzA8AVeNQl4vRanyz58W6n/pPRUwrLNr/5e8RXcCFULiHDmdncw88QMeNesH4uCsSyaUmq0N8McLqrGbaZQiwCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936078; c=relaxed/simple;
	bh=yABnwpyEKSvL9YUubu3fELC/Z5Mahr2JAsazFYhrkAc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JhXLcLDRNjtZov6/acnpuG4cJGdELFX40z/aKDp7YDWvOtAfNLTD4hbzdmLfILkJg5hMrQkibM7tXsvff0yjrWWM2tdtFCarZa1OiZgQAHmDl0O0Q8tfDJvgw3UXOHqvCPX8bwffK+eHXNLwlMNxcKVd7IlprY+VY0QroYUdY0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JA1wXDvu; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936076; x=1740472076;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yABnwpyEKSvL9YUubu3fELC/Z5Mahr2JAsazFYhrkAc=;
  b=JA1wXDvuqhSljIsuFmR6eRgRyMPxYCafCYb4FHyq4EbyBXejITDSS/8R
   QkB2OM6u+TTmvw+AuvgjdQcm41Reey4rYFiFgv9hpAY+VG9BIE9FIwDb7
   WQutphSdYKWlhFL2VQ2zXAJLueJbXDH0hTjWcwuDlMLxLYAKlVKOKM2rV
   ODbfL53HlUgISovkQvC+1HEQJyWPEoVnf4u6V8/UlRAW0j2Y2XXjSG4OA
   w5rwAyxjgS273vGp5RWMdqs4FF71xp2TT2vCkhATcnvljeOjnTXUAVAvO
   RKzfQ63nMGOjAvLqswPPWSDEanUrpqxExz30V5/iZIsTzqtAZKERL9huR
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="6155259"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6155259"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6615496"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:54 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Yuan Yao <yuan.yao@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v19 028/130] KVM: TDX: Add TDX "architectural" error codes
Date: Mon, 26 Feb 2024 00:25:30 -0800
Message-Id: <ae0b961d80ab90e43c6eff4a675e00ff80ab3b9f.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
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
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
v19:
- Drop TDX_EPT_WALK_FAILED, TDX_EPT_ENTRY_NOT_FREE
- Rename TDG_VP_VMCALL_ => TDVMCALL_ to match the existing code
- Move TDVMCALL error codes to shared/tdx.h
- Added TDX_OPERAND_ID_TDR
---
 arch/x86/include/asm/shared/tdx.h |  8 +++++++-
 arch/x86/kvm/vmx/tdx_errno.h      | 34 +++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kvm/vmx/tdx_errno.h

diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index fdfd41511b02..28c4a62b7dba 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -26,7 +26,13 @@
 #define TDVMCALL_GET_QUOTE		0x10002
 #define TDVMCALL_REPORT_FATAL_ERROR	0x10003
 
-#define TDVMCALL_STATUS_RETRY		1
+/*
+ * TDG.VP.VMCALL Status Codes (returned in R10)
+ */
+#define TDVMCALL_SUCCESS		0x0000000000000000ULL
+#define TDVMCALL_RETRY			0x0000000000000001ULL
+#define TDVMCALL_INVALID_OPERAND	0x8000000000000000ULL
+#define TDVMCALL_TDREPORT_FAILED	0x8000000000000001ULL
 
 /*
  * Bitmasks of exposed registers (with VMM).
diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
new file mode 100644
index 000000000000..5366bf476d2c
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_errno.h
@@ -0,0 +1,34 @@
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
+#define TDX_VCPU_NOT_ASSOCIATED			0x8000070200000000ULL
+#define TDX_KEY_GENERATION_FAILED		0x8000080000000000ULL
+#define TDX_KEY_STATE_INCORRECT			0xC000081100000000ULL
+#define TDX_KEY_CONFIGURED			0x0000081500000000ULL
+#define TDX_NO_HKID_READY_TO_WBCACHE		0x0000082100000000ULL
+#define TDX_FLUSHVP_NOT_DONE			0x8000082400000000ULL
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
2.25.1


