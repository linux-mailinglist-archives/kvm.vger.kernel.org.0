Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30BC96AD575
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 04:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbjCGDIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 22:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbjCGDHp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 22:07:45 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E6087A02;
        Mon,  6 Mar 2023 19:06:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678158374; x=1709694374;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qJRDv1JU3EvBoam3ACq+r69aYmF+cFETAZ2lAy63Iv0=;
  b=M4NaJqFjiHGVFafB6zOO46uLyk2CuFmlKks6EFh4Ha+YhS/sER3Texol
   LpEvoOIa2gijPhKFjV+aXNXRsuJ93oF4UMOebHCDNH61bm/VkF4zOUjr5
   d7yyHHJOieuZcKU3pxg+n5AlQ8sS8PzLgugwlt838CEhtxolJjUwRMAdy
   2b0ITG7s86o5Nfx2Jg87su1w+xGr0CKler46DZKvU3jJ2CXGqBXXJGN+9
   CO+qrMZNoiUVRVt+ZBHvY4R04x7QsA8UixD/aGTnmlm1fOeFSHnsJJJk9
   4Ce0sToKVhIU+ZWHOwsbQVMAmnw8U/tO0kA9JpEydOrwZJD9xm091vULp
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="338072643"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="338072643"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 19:05:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="676409959"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="676409959"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga002.jf.intel.com with ESMTP; 06 Mar 2023 19:05:23 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [PATCH v5 33/34] KVM: x86/vmx: call external_interrupt() to handle IRQ in IRQ caused VM exits
Date:   Mon,  6 Mar 2023 18:39:45 -0800
Message-Id: <20230307023946.14516-34-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230307023946.14516-1-xin3.li@intel.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When FRED is enabled, IDT is gone, thus call external_interrupt() to handle
IRQ in IRQ caused VM exits.

Create an event return stack frame with the host context immediately after
a VM exit for calling external_interrupt(). All other fields of the pt_regs
structure are cleared to 0. Refer to the discussion about the register values
in the pt_regs structure at:

  https://lore.kernel.org/kvm/ef2c54f7-14b9-dcbb-c3c4-1533455e7a18@redhat.com/

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v4:
*) Do NOT use the term "injection", which in the KVM context means to
   reinject an event into the guest (Sean Christopherson).
*) Use cs/ss instead of csx/ssx when initializing the pt_regs structure
   for calling external_interrupt(), otherwise it breaks i386 build.
---
 arch/x86/kvm/vmx/vmx.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bcac3efcde41..3ebeaab34b2e 100644
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
+		regs.ss		= __KERNEL_DS;
+		regs.sp		= vmx->loaded_vmcs->host_state.rsp;
+		regs.flags	= X86_EFLAGS_FIXED;
+		regs.cs		= __KERNEL_CS;
+		regs.ip		= (unsigned long)vmx_vmexit;
+
+		external_interrupt(&regs, vector);
+	} else
+		vmx_do_interrupt_irqoff(gate_offset(desc));
 	kvm_after_interrupt(vcpu);
 
 	vcpu->arch.at_instruction_boundary = true;
-- 
2.34.1

