Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1FC361282F
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbiJ3G2u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbiJ3G1P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:27:15 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BF228E;
        Sat, 29 Oct 2022 23:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111062; x=1698647062;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PZxmuf+iutkFw1axxqZiYqqQxLbEuuA3Sz6U+STmYHk=;
  b=PDi3L3yn0YIs+UV0Nin3YtlI1D6ZHMhPM3s86SSp2TpxIZt7oyYD/kD7
   +/Y6g1h4Dwy7HZWc2g7xLQmqeBHAHug87GnkRsoYep2CXoKGqGILJJyh3
   Eb7eelvUSaVF1wUR7rhJX/3gfWk/+6ySyx5hVAwo7GIxj9QcjCSwlMEL3
   Xw5UEJyX/uK8R1X5xjsHsyNDAm1YezAL8WQuUDrmLhezgXcwprCn5hq6B
   XCbCATJhomg5xVb3I8vxreYdWcINKVnuY1WNrOJ3/2rRg1l5Nq5Lx2heK
   O/dDrUG6RCib4fLDUUigOv2rmbG29RuNuPL9PHHwjmdNm9qirWcMdRWe9
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037180"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037180"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:08 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878393060"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878393060"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:08 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 067/108] KVM: TDX: Add helper assembly function to TDX vcpu
Date:   Sat, 29 Oct 2022 23:23:08 -0700
Message-Id: <b406d6e22a768d7b4faa5f2d9dca338069359f9a.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/vmenter.S | 157 +++++++++++++++++++++++++++++++++++++
 1 file changed, 157 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 8477d8bdd69c..9066eea1ede5 100644
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
@@ -350,3 +358,152 @@ SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
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
+	/*
+	 * Use same return value convention to tdxcall.S.
+	 * TDX_SEAMCALL_VMFAILINVALID doesn't conflict with any TDX status code.
+	 */
+	jnc 3f
+	mov $TDX_SEAMCALL_VMFAILINVALID, %rax
+	jmp 5f
+3:
+
+	/* Skip to the exit path if TDENTER failed. */
+	bt $TDENTER_ERROR_BIT, %rax
+	jc 5f
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
+	jne 4f
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
+4:	mov %rcx, VCPU_RCX(%rax)
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
+5:	add $8, %rsp
+	pop %rbx
+	pop %r12
+	pop %r13
+	pop %r14
+	pop %r15
+
+	pop %rbp
+	RET
+
+6:	cmpb $0, kvm_rebooting
+	je 1f
+	mov $TDX_SW_ERROR, %r12
+	orq %r12, %rax
+	jmp 5b
+1:	ud2
+	/* Use FAULT version to know what fault happened. */
+	_ASM_EXTABLE_FAULT(2b, 6b)
+
+SYM_FUNC_END(__tdx_vcpu_run)
+
+.popsection
+
+#endif
-- 
2.25.1

