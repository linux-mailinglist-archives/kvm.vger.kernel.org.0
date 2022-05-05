Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A5051C759
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384127AbiEESZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383378AbiEESTx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:53 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4064393D5;
        Thu,  5 May 2022 11:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774568; x=1683310568;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vQdc+7bMp85r+RLxtRflm+8G7MwPp5BRnYdgKX7piSg=;
  b=ihtcdYxJjLJLDjYNIoIYDsHVArbnCA+hoyDvulDoQPCIuJHfdOfaBiWY
   aO20QgT7l+9UmOQtnB+6h3t5iZn82Z2aSnS5V5AfxX6ORQgJU4YykdV5Q
   cWtXofLlgGfwymtXlml5nknYNpXytUtvK0sKiI+enJyopiw09wXfN1mYL
   3Czc2m4IpH7CPQPr2ioXLQczxMDZfUdkj6Bxl/G+qYsVQvDXJTgBebhgM
   5GufE4IGfxp3dU1DbFmmxrTzxPSvyBafolz/hNRSY1PEsyM2zH1rUU9db
   uNOrv+mVXyhSmdLFP6hwOeE6RQ3swSJe6fJsxQL9SbHlih7eYBgS2WWna
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="268354864"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="268354864"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:50 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083384"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:50 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 067/104] KVM: TDX: restore host xsave state when exit from the guest TD
Date:   Thu,  5 May 2022 11:15:01 -0700
Message-Id: <547fe194bc6eccfe7ddb23e68065b36a58d64758.1651774250.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 1aa52a093764..a54ee22b6c64 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2,6 +2,7 @@
 #include <linux/cpu.h>
 #include <linux/mmu_context.h>
 
+#include <asm/fpu/xcr.h>
 #include <asm/tdx.h>
 
 #include "capabilities.h"
@@ -590,6 +591,22 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vcpu->kvm->vm_bugged = true;
 }
 
+static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+
+	if (static_cpu_has(X86_FEATURE_XSAVE) &&
+	    host_xcr0 != (kvm_tdx->xfam & supported_xcr0))
+		xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
+	if (static_cpu_has(X86_FEATURE_XSAVES) &&
+	    /* PT can be exposed to TD guest regardless of KVM's XSS support */
+	    host_xss != (kvm_tdx->xfam & (supported_xss | XFEATURE_MASK_PT)))
+		wrmsrl(MSR_IA32_XSS, host_xss);
+	if (static_cpu_has(X86_FEATURE_PKU) &&
+	    (kvm_tdx->xfam & XFEATURE_MASK_PKRU))
+		write_pkru(vcpu->arch.host_pkru);
+}
+
 u64 __tdx_vcpu_run(hpa_t tdvpr, void *regs, u32 regs_mask);
 
 static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
@@ -613,6 +630,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	tdx_vcpu_enter_exit(vcpu, tdx);
 
+	tdx_restore_host_xsave_state(vcpu);
 	tdx->host_state_need_restore = true;
 
 	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
-- 
2.25.1

