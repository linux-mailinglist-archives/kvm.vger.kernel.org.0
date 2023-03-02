Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B98936A7B1A
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 06:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjCBFxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 00:53:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjCBFwp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 00:52:45 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513B14BE9D;
        Wed,  1 Mar 2023 21:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677736298; x=1709272298;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RB+pcoV+8WefgwtLPP9+JmvXNsCQtNuVUpY6dnzCLDE=;
  b=Swxnp4HCb91tti4020hv6rCY46wgARud6jyH+qTRuPT64oW1y3CdwNzL
   XuogKFv7751KYpgY7olljw5k5I9EA0p8l9/Jt48CzCzgyfgTdEomFeSuR
   nN8zb8hbxLP/D3JBgsIXlmqE9l80khtINTXnKBiA7Iy1rOgPA3Aewnjlu
   QNl/ytgKDyoG2s0/zT+AJgGe2nIb6qqRVm/oO+OomLBO4zZlxqNKSLOi5
   LQJdtQvXC9nz9R+Di6tGy0jud/4Y0ldAi6mW0//J+YPanqK9xhhPQ6WZE
   isreuOdhxkltPB2NcxhFwWSQFriTYA0rOU7HBJeVmN+mou2U2WTPUvyUR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="420887332"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="420887332"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 21:50:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="920530983"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="920530983"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga006.fm.intel.com with ESMTP; 01 Mar 2023 21:50:52 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [PATCH v4 33/34] KVM: x86/vmx: call external_interrupt() for IRQ reinjection when FRED is enabled
Date:   Wed,  1 Mar 2023 21:25:10 -0800
Message-Id: <20230302052511.1918-34-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230302052511.1918-1-xin3.li@intel.com>
References: <20230302052511.1918-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When FRED is enabled, IDT is gone, thus call external_interrupt() for IRQ
reinjection.

Create an event return stack frame with the host context immediately after
a VM exit for calling external_interrupt(). All other fields of the pt_regs
structure are cleared to 0. Refer to the discussion about the register values
in the pt_regs structure at:

  https://lore.kernel.org/kvm/ef2c54f7-14b9-dcbb-c3c4-1533455e7a18@redhat.com/

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bcac3efcde41..30f854015c8c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -47,6 +47,7 @@
 #include <asm/mshyperv.h>
 #include <asm/mwait.h>
 #include <asm/spec-ctrl.h>
+#include <asm/traps.h>
 #include <asm/virtext.h>
 #include <asm/vmx.h>
 
@@ -6923,7 +6924,26 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 		return;
 
 	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
-	vmx_do_interrupt_irqoff(gate_offset(desc));
+	if (cpu_feature_enabled(X86_FEATURE_FRED)) {
+		struct vcpu_vmx *vmx = to_vmx(vcpu);
+		struct pt_regs regs = {};
+
+		/*
+		 * Create an event return stack frame with the
+		 * host context immediately after a VM exit.
+		 *
+		 * All other fields of the pt_regs structure are
+		 * cleared to 0.
+		 */
+		regs.ssx	= __KERNEL_DS;
+		regs.sp		= vmx->loaded_vmcs->host_state.rsp;
+		regs.flags	= X86_EFLAGS_FIXED;
+		regs.csx	= __KERNEL_CS;
+		regs.ip		= (unsigned long)vmx_vmexit;
+
+		external_interrupt(&regs, vector);
+	} else
+		vmx_do_interrupt_irqoff(gate_offset(desc));
 	kvm_after_interrupt(vcpu);
 
 	vcpu->arch.at_instruction_boundary = true;
-- 
2.34.1

