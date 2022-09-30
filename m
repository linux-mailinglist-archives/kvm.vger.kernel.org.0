Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5604D5F0896
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbiI3KVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbiI3KTG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:19:06 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F0E166F14;
        Fri, 30 Sep 2022 03:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533144; x=1696069144;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Rdj8i/x6WV4gTaBhgFiEgUILrvKPKY9MlLj3JObbtPM=;
  b=mlN1MPWCXff4rmdyS77acapS5ZitgRJMW9HhyRD6U18P6F+wlQDQSe6C
   41p17eDFGFJ4ThgcFfFoF/dXETiBiKh5rf44DXbs8ZTo2SotZJW1A7Pdn
   swp3yXyjZ2PmzJ9DX5DSkeBWHuDxApcJO2bskmjT4mZyjxNMaMNRDNCiY
   YTpLXRcGbNxMQB5CDwtyIkDGlcQzr/SmRkOJjJNJxVJvAuqiamtYljTMw
   GY24wqnyM0s93KfCc5/pCp1qIrfUeIOA7jBSvcRKNMPmJDk6LIjyB/kg3
   7LSWWH7LkZBOIXzxftVy6fdfzqpkMOeuQLt40dOPczAwPznL3YYiDHh6M
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="285294795"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="285294795"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:02 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807711"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807711"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:02 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 064/105] KVM: TDX: Add helper assembly function to TDX vcpu
Date:   Fri, 30 Sep 2022 03:17:58 -0700
Message-Id: <2fedaedc09669f03c510248320709b964db11959.1664530908.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX defines an API to run TDX vcpu with its own ABI.  Define an assembly
helper function to run TDX vcpu to hide the special ABI so that C code can
call it with function call ABI.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/vmenter.S | 146 +++++++++++++++++++++++++++++++++++++
 1 file changed, 146 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 6de96b943804..edc05c8e61a8 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -3,6 +3,7 @@
 #include <asm/asm.h>
 #include <asm/asm-offsets.h>
 #include <asm/bitsperlong.h>
+#include <asm/errno.h>
 #include <asm/kvm_vcpu_regs.h>
 #include <asm/nospec-branch.h>
 #include <asm/percpu.h>
@@ -31,6 +32,13 @@
 #define VCPU_R15	__VCPU_REGS_R15 * WORD_SIZE
 #endif
 
+#ifdef CONFIG_INTEL_TDX_HOST
+#define TDENTER 		0
+#define EXIT_REASON_TDCALL	77
+#define TDENTER_ERROR_BIT	63
+#define seamcall		.byte 0x66,0x0f,0x01,0xcf
+#endif
+
 .section .noinstr.text, "ax"
 
 /**
@@ -360,3 +368,141 @@ SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
 	pop %_ASM_BP
 	RET
 SYM_FUNC_END(vmx_do_interrupt_nmi_irqoff)
+
+#ifdef CONFIG_INTEL_TDX_HOST
+
+.pushsection .noinstr.text, "ax"
+
+/**
+ * __tdx_vcpu_run - Call SEAMCALL(TDENTER) to run a TD vcpu
+ * @tdvpr:	physical address of TDVPR
+ * @regs:	void * (to registers of TDVCPU)
+ * @gpr_mask:	non-zero if guest registers need to be loaded prior to TDENTER
+ *
+ * Returns:
+ *	TD-Exit Reason
+ *
+ * Note: KVM doesn't support using XMM in its hypercalls, it's the HyperV
+ *	 code's responsibility to save/restore XMM registers on TDVMCALL.
+ */
+SYM_FUNC_START(__tdx_vcpu_run)
+	push %rbp
+	mov  %rsp, %rbp
+
+	push %r15
+	push %r14
+	push %r13
+	push %r12
+	push %rbx
+
+	/* Save @regs, which is needed after TDENTER to capture output. */
+	push %rsi
+
+	/* Load @tdvpr to RCX */
+	mov %rdi, %rcx
+
+	/* No need to load guest GPRs if the last exit wasn't a TDVMCALL. */
+	test %dx, %dx
+	je 1f
+
+	/* Load @regs to RAX, which will be clobbered with $TDENTER anyways. */
+	mov %rsi, %rax
+
+	mov VCPU_RBX(%rax), %rbx
+	mov VCPU_RDX(%rax), %rdx
+	mov VCPU_RBP(%rax), %rbp
+	mov VCPU_RSI(%rax), %rsi
+	mov VCPU_RDI(%rax), %rdi
+
+	mov VCPU_R8 (%rax),  %r8
+	mov VCPU_R9 (%rax),  %r9
+	mov VCPU_R10(%rax), %r10
+	mov VCPU_R11(%rax), %r11
+	mov VCPU_R12(%rax), %r12
+	mov VCPU_R13(%rax), %r13
+	mov VCPU_R14(%rax), %r14
+	mov VCPU_R15(%rax), %r15
+
+	/*  Load TDENTER to RAX.  This kills the @regs pointer! */
+1:	mov $TDENTER, %rax
+
+2:	seamcall
+
+	/* Skip to the exit path if TDENTER failed. */
+	bt $TDENTER_ERROR_BIT, %rax
+	jc 4f
+
+	/* Temporarily save the TD-Exit reason. */
+	push %rax
+
+	/* check if TD-exit due to TDVMCALL */
+	cmp $EXIT_REASON_TDCALL, %ax
+
+	/* Reload @regs to RAX. */
+	mov 8(%rsp), %rax
+
+	/* Jump on non-TDVMCALL */
+	jne 3f
+
+	/* Save all output from SEAMCALL(TDENTER) */
+	mov %rbx, VCPU_RBX(%rax)
+	mov %rbp, VCPU_RBP(%rax)
+	mov %rsi, VCPU_RSI(%rax)
+	mov %rdi, VCPU_RDI(%rax)
+	mov %r10, VCPU_R10(%rax)
+	mov %r11, VCPU_R11(%rax)
+	mov %r12, VCPU_R12(%rax)
+	mov %r13, VCPU_R13(%rax)
+	mov %r14, VCPU_R14(%rax)
+	mov %r15, VCPU_R15(%rax)
+
+3:	mov %rcx, VCPU_RCX(%rax)
+	mov %rdx, VCPU_RDX(%rax)
+	mov %r8,  VCPU_R8 (%rax)
+	mov %r9,  VCPU_R9 (%rax)
+
+	/*
+	 * Clear all general purpose registers except RSP and RAX to prevent
+	 * speculative use of the guest's values.
+	 */
+	xor %rbx, %rbx
+	xor %rcx, %rcx
+	xor %rdx, %rdx
+	xor %rsi, %rsi
+	xor %rdi, %rdi
+	xor %rbp, %rbp
+	xor %r8,  %r8
+	xor %r9,  %r9
+	xor %r10, %r10
+	xor %r11, %r11
+	xor %r12, %r12
+	xor %r13, %r13
+	xor %r14, %r14
+	xor %r15, %r15
+
+	/* Restore the TD-Exit reason to RAX for return. */
+	pop %rax
+
+	/* "POP" @regs. */
+4:	add $8, %rsp
+	pop %rbx
+	pop %r12
+	pop %r13
+	pop %r14
+	pop %r15
+
+	pop %rbp
+	RET
+
+5:	cmpb $0, kvm_rebooting
+	je 6f
+	mov $-EFAULT, %rax
+	jmp 4b
+6:	ud2
+	_ASM_EXTABLE(2b, 5b)
+
+SYM_FUNC_END(__tdx_vcpu_run)
+
+.popsection
+
+#endif
-- 
2.25.1

