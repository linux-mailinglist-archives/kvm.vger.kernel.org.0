Return-Path: <kvm+bounces-6586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F18E083792D
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:31:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA6CD1C2621E
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7B5A54FBF;
	Mon, 22 Jan 2024 23:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MopCPa/q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F4B51C50;
	Mon, 22 Jan 2024 23:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967702; cv=none; b=DiZynXa5jPXkJwjDqlGlquf9O4qnxAwiE0HOFv7crrgWjKRwX8eoiG1kPqbg7cY21c7gJ5Jvfi4yy6TJ+bYqKGCBmhLDqWrFRz79rJ63x55MgWdpSINQqhDAPJxCmEDLH6qvR6WyVvLdN3Q/0X2ip3sfoFy6okYSjuxGUS243W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967702; c=relaxed/simple;
	bh=5AvxFlNnm0cR+E6hdcrN/Wt9IHkP8USJX+E5nC/Jv4s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MT0XoHh+rPZ29gPmJEt1oBH5tdrSCAvWN9mgGVQDywi8WyKenaZ5N3YMl9u8hKx/pMQnG4KCR1Ey46Os82vzar81ixHB1FysB6WshSjMpWBBoo44EZR9NsEs2Hzj7Z9/kJAdGTGQqHgwnSpSB31ApVAN8jHTXk6NLeXv9dEBTQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MopCPa/q; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967701; x=1737503701;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5AvxFlNnm0cR+E6hdcrN/Wt9IHkP8USJX+E5nC/Jv4s=;
  b=MopCPa/qgntT9CPWyQk0ivbJbuEqlEfyJxY5qSf/6r9jmgzAnypdCi/v
   FDkF1ZQrNPu1vJFuuEDPFV6/q2TV07KbQ4Co++8fT3eXg/sRTaFIKPzdD
   9HYx4tY+uS3Utu5/LNB6fPMOwfdx2D/RbZNz5V9UvtKhMG5DmooGXYoLH
   sRoB4mFdz50TQJYn6cDvjMPyNkvk6wk3jtERBgbQb48aRKRO3MCWlYkKJ
   qD9v3mVLGmMFiLzRsDZR0A/KrYb/Nf1Rs1QsxPXfMj/5g9/cr7srMNfmR
   mnsjQNMjsO9PDqfJA/EXC4D1OkG9Q9faNFGTKXTvwEPYuK81xdQrZJmP5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="1217862"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1217862"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1350162"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:01 -0800
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
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v18 013/121] KVM: TDX: Add TDX "architectural" error codes
Date: Mon, 22 Jan 2024 15:52:49 -0800
Message-Id: <212f22ed28e43c016607e3c420d7d98910878007.1705965634.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
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
---
 arch/x86/kvm/vmx/tdx_errno.h | 43 ++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/tdx_errno.h

diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
new file mode 100644
index 000000000000..7f96696b8e7c
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_errno.h
@@ -0,0 +1,43 @@
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
+#define TDX_EPT_WALK_FAILED			0xC0000B0000000000ULL
+#define TDX_EPT_ENTRY_NOT_FREE			0xC0000B0200000000ULL
+#define TDX_EPT_ENTRY_STATE_INCORRECT		0xC0000B0D00000000ULL
+
+/*
+ * TDG.VP.VMCALL Status Codes (returned in R10)
+ */
+#define TDG_VP_VMCALL_SUCCESS			0x0000000000000000ULL
+#define TDG_VP_VMCALL_RETRY			0x0000000000000001ULL
+#define TDG_VP_VMCALL_INVALID_OPERAND		0x8000000000000000ULL
+#define TDG_VP_VMCALL_TDREPORT_FAILED		0x8000000000000001ULL
+
+/*
+ * TDX module operand ID, appears in 31:0 part of error code as
+ * detail information
+ */
+#define TDX_OPERAND_ID_RCX			0x01
+#define TDX_OPERAND_ID_SEPT			0x92
+#define TDX_OPERAND_ID_TD_EPOCH			0xa9
+
+#endif /* __KVM_X86_TDX_ERRNO_H */
-- 
2.25.1


