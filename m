Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBFD920147
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 10:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfEPI1A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 04:27:00 -0400
Received: from mga14.intel.com ([192.55.52.115]:24486 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726970AbfEPI07 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 04:26:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 May 2019 01:26:57 -0700
X-ExtLoop1: 1
Received: from skl-s2.bj.intel.com ([10.240.192.102])
  by orsmga005.jf.intel.com with ESMTP; 16 May 2019 01:26:54 -0700
From:   Luwei Kang <luwei.kang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v1 6/6] KVM: VMX: Get PT state from xsave area to variables
Date:   Thu, 16 May 2019 16:25:14 +0800
Message-Id: <1557995114-21629-7-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1557995114-21629-1-git-send-email-luwei.kang@intel.com>
References: <1557995114-21629-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch get the Intel PT state from xsave area to
variables when PT is change from enabled to disabled.
Because PT state is saved/restored to/from xsave area
by XSAVES/XRSTORES instructions when Intel PT is enabled.
The KVM guest may read this MSRs when PT is disabled
but the real value is saved in xsave area not variables.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d323e6b..d3e2569 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1000,6 +1000,16 @@ static inline void pt_save_msr(struct pt_state *ctx, u32 addr_range)
 		rdmsrl(MSR_IA32_RTIT_ADDR0_A + i, ctx->rtit_addrx_ab[i]);
 }
 
+static void pt_state_get(struct pt_state *ctx, struct fpu *fpu, u32 addr_range)
+{
+	char *buff = fpu->state.xsave.extended_state_area;
+
+	/* skip riti_ctl register */
+	memcpy(&ctx->rtit_output_base, buff + sizeof(u64),
+			sizeof(struct pt_state) - sizeof(u64) +
+			sizeof(u64) * addr_range * 2);
+}
+
 static void pt_guest_enter(struct vcpu_vmx *vmx)
 {
 	struct pt_desc *desc;
@@ -1040,6 +1050,9 @@ static void pt_guest_enter(struct vcpu_vmx *vmx)
 			pt_save_msr(desc->host_ctx, desc->addr_range);
 			pt_load_msr(desc->guest_ctx, desc->addr_range);
 		}
+	} else if (desc->pt_xsave && desc->guest_xs->initialized) {
+		pt_state_get(desc->guest_ctx, desc->guest_xs, desc->addr_range);
+		desc->guest_xs->initialized = 0;
 	}
 }
 
-- 
1.8.3.1

