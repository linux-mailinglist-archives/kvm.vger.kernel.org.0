Return-Path: <kvm+bounces-954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 66CB07E429A
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:03:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 979F61C20F34
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 227E8321B0;
	Tue,  7 Nov 2023 15:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LPJ1N5Wj"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2844331A8A
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:01:21 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E1ED77;
	Tue,  7 Nov 2023 07:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369233; x=1730905233;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GuIonCqVNaqAE14bgKHFQ22X22K46ozHe/DhiMKtObw=;
  b=LPJ1N5WjVNz+wnGWibUXq82awzgaZda9Ca+fPHP0BnSnrPMOrgMJDMjd
   KpOxc5KeLp7ZfRrauJtLPmC6RH2m5BrmvlWB31pOJ8L249/HjybXIc595
   asTCteBU2efjM1oyJCE7IRlSUSwWk5WnBXZKibrcOhx8Jqhpq+Xgsr4DA
   C7H7axXAcR/nsRMjcM+MLq9vzYKF3NKJ23BuoXPP1tpPRI2BkGnXkUB1s
   EDsuBKJHpSPWkWO8WUBaNagteP8F7mE2x4EuFGVsrfb+f96HxO5qUJ6pZ
   dpqX1NjK7xAgvhVWiAzF6hvJ4MrZuR7490JElV1JNvF5tV7Oqpv2yAq1S
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462432"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462432"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851455"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:17 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v17 064/116] KVM: TDX: restore host xsave state when exit from the guest TD
Date: Tue,  7 Nov 2023 06:56:30 -0800
Message-Id: <1f114dec3e32d6a785c39eb43744c2c6e2d754bf.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
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
index dded76bf9a85..d5a43803fadb 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2,6 +2,7 @@
 #include <linux/cpu.h>
 #include <linux/mmu_context.h>
 
+#include <asm/fpu/xcr.h>
 #include <asm/tdx.h>
 
 #include "capabilities.h"
@@ -508,6 +509,23 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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
@@ -583,6 +601,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	tdx_vcpu_enter_exit(tdx);
 
+	tdx_restore_host_xsave_state(vcpu);
 	tdx->host_state_need_restore = true;
 
 	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
-- 
2.25.1


