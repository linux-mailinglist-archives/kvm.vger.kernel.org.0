Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A28B36B6987
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 19:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbjCLSEJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 14:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbjCLSDF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 14:03:05 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D594BEBF;
        Sun, 12 Mar 2023 10:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678643976; x=1710179976;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/UdUs0CKk8UyhwNMLzBDrHVzgjAOPLMcdnM3a9IY5gE=;
  b=IBHHFOYfy50/He+ABSXlKX56b5XLdHHg1N1llLpUMedHk62MjwLPpyav
   lpFjOblO3w4xp/FlhJNRASf6yK20YIoEVH8Ffyj4jS6orjdZBV0+KCjgp
   yS+ON6YiELw/6loomcpKQMGa24dYDPeTeNLtfRi6o/3K6YTFmK8x0dmOg
   y8hvNlkOZNEU+NNS2uSQCDodMqav5/O2D8m6lGLdolYpS2cDarMB5QSfg
   sEEiaKlOiDcOQyojCAxkKtI265mgpX9k9thZ1JU5sWirIHwuaDeqSoas8
   o4+DaEM7G2XnStFxz08GHyZsw0xaxEUKI8xfVYKfZc6T8ysCveP0EW0Me
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="316659960"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316659960"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="742596708"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="742596708"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:09 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v13 066/113] KVM: TDX: restore host xsave state when exit from the guest TD
Date:   Sun, 12 Mar 2023 10:56:30 -0700
Message-Id: <c3d876bb876802bd3d516f4cbd513e48234b147f.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

On exiting from the guest TD, xsave state is clobbered.  Restore xsave
state on TD exit.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 321635a94bd5..21e6fb0eeeb5 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2,6 +2,7 @@
 #include <linux/cpu.h>
 #include <linux/mmu_context.h>
 
+#include <asm/fpu/xcr.h>
 #include <asm/tdx.h>
 
 #include "capabilities.h"
@@ -481,6 +482,22 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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
+	    host_xss != (kvm_tdx->xfam & (kvm_caps.supported_xss | XFEATURE_MASK_PT)))
+		wrmsrl(MSR_IA32_XSS, host_xss);
+	if (static_cpu_has(X86_FEATURE_PKU) &&
+	    (kvm_tdx->xfam & XFEATURE_MASK_PKRU))
+		write_pkru(vcpu->arch.host_pkru);
+}
+
 u64 __tdx_vcpu_run(hpa_t tdvpr, void *regs, u32 regs_mask);
 
 static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
@@ -504,6 +521,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	tdx_vcpu_enter_exit(vcpu, tdx);
 
+	tdx_restore_host_xsave_state(vcpu);
 	tdx->host_state_need_restore = true;
 
 	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
-- 
2.25.1

