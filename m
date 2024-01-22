Return-Path: <kvm+bounces-6662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DD372837848
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:12:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D56C1F2177F
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10B416DD1E;
	Mon, 22 Jan 2024 23:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kp9EzbBb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8905D4F5F1;
	Mon, 22 Jan 2024 23:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967760; cv=none; b=EUn7A+UC4pHmwW+8KFeEvhjDoy2ZTb1bq50MMz64XIKMUIvly+mP/k5QCYjhmLYqKmNJChzGY6R9RFAUdbwfPqXINldE1MbdpycKEaKMqLCHdJbMkiAPw5dLNEHGceLIr3rjVGMrkxc7bRrGwHRNL/Dwfff4AxD35q9Eh7Ui+P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967760; c=relaxed/simple;
	bh=5Wi3VocsOvptzgAHMe7W6mABPI53Gv4SBRgV6vwuePw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MwEy99LZBWgtWEHIe2o4LmDSJOAxz5X3yDDLx4uBNTjZT7p6LPgkwAuwWTSyr3+43yLyayQCGJByGJX4LV6I77I1Wqg+mvIXjyDeiZnqtmXOgcVVBdHx10tTP31hOgWBJ5u76yg74ZQmzaDsAqYgue4FbcSJpvXwMY76O9c8Yu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kp9EzbBb; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967759; x=1737503759;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5Wi3VocsOvptzgAHMe7W6mABPI53Gv4SBRgV6vwuePw=;
  b=Kp9EzbBbyLLZ6w5ZRELtgz1Fq9fP7HB/KiX/XOAK+k7Ic2UFhqINCB40
   helc111VM+1aTDHJIg2mjqO/ojBSJgxXxEd7VjtBHInnZ5/e+BYa2IN7H
   3UiyM0p+1TIya3Tm0tmRNUFniHJty6T9O05wMcG7zY0VeGYbga+FtUPHj
   bu1s9/xC0dQ+FN8Cib1gFMlGZfz7onG8+TnQ0aiU2B56jw7vA7k8JTDuj
   sznIe4wSNR82OfScDMefs376AEJ/EhExXuTAaaZyi/L85Gsu5bOdyQ2l7
   kXtWwU7FCE2nYy5r4SAW1VzIMJMcsbpLCQIBJezlUXZEB+rN9pUvNQ5fV
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="8016521"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="8016521"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1468246"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:39 -0800
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
	tina.zhang@intel.com
Subject: [PATCH v18 069/121] KVM: TDX: restore host xsave state when exit from the guest TD
Date: Mon, 22 Jan 2024 15:53:45 -0800
Message-Id: <bfa1994b79687709aae011ff455147cc7dd97ffb.1705965635.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

On exiting from the guest TD, xsave state is clobbered.  Restore xsave
state on TD exit.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v15 -> v16:
- Added CET flag mask
---
 arch/x86/kvm/vmx/tdx.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 903f4abb3543..fe818cfde9e7 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2,6 +2,7 @@
 #include <linux/cpu.h>
 #include <linux/mmu_context.h>
 
+#include <asm/fpu/xcr.h>
 #include <asm/tdx.h>
 
 #include "capabilities.h"
@@ -584,6 +585,23 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	 */
 }
 
+static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+
+	if (static_cpu_has(X86_FEATURE_XSAVE) &&
+	    host_xcr0 != (kvm_tdx->xfam & kvm_caps.supported_xcr0))
+		xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
+	if (static_cpu_has(X86_FEATURE_XSAVES) &&
+	    /* PT can be exposed to TD guest regardless of KVM's XSS support */
+	    host_xss != (kvm_tdx->xfam &
+			 (kvm_caps.supported_xss | XFEATURE_MASK_PT | TDX_TD_XFAM_CET)))
+		wrmsrl(MSR_IA32_XSS, host_xss);
+	if (static_cpu_has(X86_FEATURE_PKU) &&
+	    (kvm_tdx->xfam & XFEATURE_MASK_PKRU))
+		write_pkru(vcpu->arch.host_pkru);
+}
+
 static noinstr void tdx_vcpu_enter_exit(struct vcpu_tdx *tdx)
 {
 	struct tdx_module_args args;
@@ -659,6 +677,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	tdx_vcpu_enter_exit(tdx);
 
+	tdx_restore_host_xsave_state(vcpu);
 	tdx->host_state_need_restore = true;
 
 	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
-- 
2.25.1


