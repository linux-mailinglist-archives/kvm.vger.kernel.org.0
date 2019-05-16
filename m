Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF11A20149
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 10:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfEPI04 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 04:26:56 -0400
Received: from mga14.intel.com ([192.55.52.115]:24486 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbfEPI0y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 04:26:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 May 2019 01:26:54 -0700
X-ExtLoop1: 1
Received: from skl-s2.bj.intel.com ([10.240.192.102])
  by orsmga005.jf.intel.com with ESMTP; 16 May 2019 01:26:51 -0700
From:   Luwei Kang <luwei.kang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v1 5/6] KVM: VMX: Intel PT configration context switch using XSAVES/XRSTORS
Date:   Thu, 16 May 2019 16:25:13 +0800
Message-Id: <1557995114-21629-6-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1557995114-21629-1-git-send-email-luwei.kang@intel.com>
References: <1557995114-21629-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch add the support of using XSAVES/XRSTORS to
do the Intel processor trace context switch.

Because of native driver didn't set the XSS[bit8] to enabled
the PT state in xsave area, so this patch only set this bit
before XSAVE/XRSTORS intstuction executtion and restore the
original value after.

The flag "initialized" need to be cleared when PT is change
from enabled to disabled. Guest may modify PT MSRs when PT
is disabled and they are only saved in variables.
We need to reload these value to HW manual when PT is enabled.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 80 ++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 65 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4691665..d323e6b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1002,33 +1002,83 @@ static inline void pt_save_msr(struct pt_state *ctx, u32 addr_range)
 
 static void pt_guest_enter(struct vcpu_vmx *vmx)
 {
+	struct pt_desc *desc;
+	int err;
+
 	if (pt_mode == PT_MODE_SYSTEM)
 		return;
 
-	/*
-	 * GUEST_IA32_RTIT_CTL is already set in the VMCS.
-	 * Save host state before VM entry.
-	 */
-	rdmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc->host_ctx->rtit_ctl);
-	if (vmx->pt_desc->guest_ctx->rtit_ctl & RTIT_CTL_TRACEEN) {
-		wrmsrl(MSR_IA32_RTIT_CTL, 0);
-		pt_save_msr(vmx->pt_desc->host_ctx, vmx->pt_desc->addr_range);
-		pt_load_msr(vmx->pt_desc->guest_ctx, vmx->pt_desc->addr_range);
+	desc = vmx->pt_desc;
+
+	rdmsrl(MSR_IA32_RTIT_CTL, desc->host_ctx->rtit_ctl);
+
+	if (desc->guest_ctx->rtit_ctl & RTIT_CTL_TRACEEN) {
+		if (likely(desc->pt_xsave)) {
+			wrmsrl(MSR_IA32_XSS, host_xss | XFEATURE_MASK_PT);
+			/*
+			 * XSAVES instruction will clears the TeaceEn after
+			 * saving the value of RTIT_CTL and before saving any
+			 * other PT state.
+			 */
+			XSTATE_XSAVE(&desc->host_xs->state.xsave,
+						XFEATURE_MASK_PT, 0, err);
+			/*
+			 * Still need to load the guest PT state manual if
+			 * PT stste not populated in xsave area.
+			 */
+			if (desc->guest_xs->initialized)
+				XSTATE_XRESTORE(&desc->guest_xs->state.xsave,
+						XFEATURE_MASK_PT, 0);
+			else
+				pt_load_msr(desc->guest_ctx, desc->addr_range);
+
+			wrmsrl(MSR_IA32_XSS, host_xss);
+		} else {
+			if (desc->host_ctx->rtit_ctl & RTIT_CTL_TRACEEN)
+				wrmsrl(MSR_IA32_RTIT_CTL, 0);
+
+			pt_save_msr(desc->host_ctx, desc->addr_range);
+			pt_load_msr(desc->guest_ctx, desc->addr_range);
+		}
 	}
 }
 
 static void pt_guest_exit(struct vcpu_vmx *vmx)
 {
+	struct pt_desc *desc;
+	int err;
+
 	if (pt_mode == PT_MODE_SYSTEM)
 		return;
 
-	if (vmx->pt_desc->guest_ctx->rtit_ctl & RTIT_CTL_TRACEEN) {
-		pt_save_msr(vmx->pt_desc->guest_ctx, vmx->pt_desc->addr_range);
-		pt_load_msr(vmx->pt_desc->host_ctx, vmx->pt_desc->addr_range);
-	}
+	desc = vmx->pt_desc;
+
+	if (desc->guest_ctx->rtit_ctl & RTIT_CTL_TRACEEN) {
+		if (likely(desc->pt_xsave)) {
+			wrmsrl(MSR_IA32_XSS, host_xss | XFEATURE_MASK_PT);
+			/*
+			 * Save guest state. TraceEn is 0 before and after
+			 * XSAVES instruction because RTIT_CTL will be cleared
+			 * on VM-exit (VM Exit control bit25).
+			 */
+			XSTATE_XSAVE(&desc->guest_xs->state.xsave,
+						XFEATURE_MASK_PT, 0, err);
+			desc->guest_xs->initialized = 1;
+			/*
+			 * Resume host PT state and PT may enabled after this
+			 * instruction if host PT is enabled before VM-entry.
+			 */
+			XSTATE_XRESTORE(&desc->host_xs->state.xsave,
+						XFEATURE_MASK_PT, 0);
+			wrmsrl(MSR_IA32_XSS, host_xss);
+		} else {
+			pt_save_msr(desc->guest_ctx, desc->addr_range);
+			pt_load_msr(desc->host_ctx, desc->addr_range);
 
-	/* Reload host state (IA32_RTIT_CTL will be cleared on VM exit). */
-	wrmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc->host_ctx->rtit_ctl);
+			wrmsrl(MSR_IA32_RTIT_CTL, desc->host_ctx->rtit_ctl);
+		}
+	} else if (desc->host_ctx->rtit_ctl & RTIT_CTL_TRACEEN)
+		wrmsrl(MSR_IA32_RTIT_CTL, desc->host_ctx->rtit_ctl);
 }
 
 static int pt_init(struct vcpu_vmx *vmx)
-- 
1.8.3.1

