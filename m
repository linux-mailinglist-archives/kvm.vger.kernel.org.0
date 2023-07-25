Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49A9762623
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbjGYWTp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbjGYWS1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:18:27 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18F62683;
        Tue, 25 Jul 2023 15:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323372; x=1721859372;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LWbwHQW6jlU/01VYinlidduuoO6CklVPFtQo9gzVTyo=;
  b=HR/e8fHoFX3RoNcnrCxYjPv+F/gf6ZM9k8OWa8UvEH5gPtNxRrlu6bpV
   JPcsADwFOn2N/Cs5CgGSm+82KJpHAe0S85J9pki6+m1hqYlONgoSBFdYJ
   yoCh3aj4F6uW8TJDXamWe/ewH9S0e2x1RVXfdlKsH23Fp85a8nzS6whXH
   mKdHJfsXJT7A3emYMK/acta6Uqct6FTNVLmrfFEZIgUQuCd4oFf0BImK1
   0RGhiPN3eP7WsrUqGwjbKo4xKI8qzAX7gBim9Dp1vxujEVr02BoWqNuBC
   xtI5ZU+A+OcUxIlg+Q4sFeMv0f5cISNnnMPb5t0mA5jdKM2i+heBtS+DH
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="367882530"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="367882530"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="840001787"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="840001787"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:50 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v15 062/115] KVM: TDX: Add helper assembly function to TDX vcpu
Date:   Tue, 25 Jul 2023 15:14:13 -0700
Message-Id: <13bb1e737232a42ddeb9e1586632942872f2c775.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
v14 -> v15:
- use symbolic local label(.Lxxx) instead of numeric local label
- optimized

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/tdx.h |   3 +-
 arch/x86/kvm/vmx/vmenter.S | 164 +++++++++++++++++++++++++++++++++++++
 2 files changed, 166 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 97b23325ba5e..75711766159b 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -18,7 +18,8 @@
  * Bits 47:40 == 0xFF indicate Reserved status code class that never used by
  * TDX module.
  */
-#define TDX_ERROR			_BITUL(63)
+#define TDX_ERROR_BIT			63
+#define TDX_ERROR			_BITUL(TDX_ERROR_BIT)
 #define TDX_SW_ERROR			(TDX_ERROR | GENMASK_ULL(47, 40))
 #define TDX_SEAMCALL_VMFAILINVALID	(TDX_SW_ERROR | _UL(0xFFFF0000))
 
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 07e927d4d099..b4f1f6117968 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -6,6 +6,7 @@
 #include <asm/nospec-branch.h>
 #include <asm/percpu.h>
 #include <asm/segment.h>
+#include <asm/tdx.h>
 #include "kvm-asm-offsets.h"
 #include "run_flags.h"
 
@@ -31,6 +32,12 @@
 #define VCPU_R15	__VCPU_REGS_R15 * WORD_SIZE
 #endif
 
+#ifdef CONFIG_INTEL_TDX_HOST
+#define TDH_VP_ENTER		0
+#define EXIT_REASON_TDCALL	77
+#define seamcall		.byte 0x66,0x0f,0x01,0xcf
+#endif
+
 .macro VMX_DO_EVENT_IRQOFF call_insn call_target
 	/*
 	 * Unconditionally create a stack frame, getting the correct RSP on the
@@ -360,3 +367,160 @@ SYM_FUNC_END(vmread_error_trampoline)
 SYM_FUNC_START(vmx_do_interrupt_irqoff)
 	VMX_DO_EVENT_IRQOFF CALL_NOSPEC _ASM_ARG1
 SYM_FUNC_END(vmx_do_interrupt_irqoff)
+
+#ifdef CONFIG_INTEL_TDX_HOST
+
+.pushsection .noinstr.text, "ax"
+
+/**
+ * __tdx_vcpu_run - Call SEAMCALL(TDH_VP_ENTER) to run a TD vcpu
+ * @tdvpr:	physical address of TDVPR
+ * @regs:	void * (to registers of TDVCPU)
+ * @gpr_mask:	non-zero if guest registers need to be loaded prior to TDH_VP_ENTER
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
+	/* Save @regs, which is needed after TDH_VP_ENTER to capture output. */
+	push %rsi
+
+	/* Load @tdvpr to RCX */
+	mov %rdi, %rcx
+
+	/* No need to load guest GPRs if the last exit wasn't a TDVMCALL. */
+	test %dx, %dx
+	je .Lskip_copy_inputs
+
+	/* Load @regs to RAX, which will be clobbered with $TDH_VP_ENTER anyways. */
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
+	/*  Load TDH_VP_ENTER to RAX.  This kills the @regs pointer! */
+.Lskip_copy_inputs:
+	mov $TDH_VP_ENTER, %rax
+
+.Lseamcall:
+	seamcall
+
+	jc .Lvmfail_invalid
+
+	/* xor-swap (%rsp) and %rax */
+	xor (%rsp), %rax
+	xor %rax, (%rsp)
+	xor (%rsp), %rax
+
+	/* Skip to the exit path if TDH_VP_ENTER failed. */
+	btq $TDX_ERROR_BIT, (%rsp)
+	jc .Lout_rax
+
+	/* check if TD-exit due to TDVMCALL */
+	cmpq $EXIT_REASON_TDCALL, (%rsp)
+
+	/* Jump on non-TDVMCALL */
+	jne .Lout_non_tdvmcall
+
+	/* Save all output from SEAMCALL(TDH_VP_ENTER) */
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
+.Lout_non_tdvmcall:
+	mov %rcx, VCPU_RCX(%rax)
+	mov %rdx, VCPU_RDX(%rax)
+	mov %r8,  VCPU_R8 (%rax)
+	mov %r9,  VCPU_R9 (%rax)
+
+	/*
+	 * Clear all general purpose registers except RSP and RAX to prevent
+	 * speculative use of the guest's values.
+	 */
+	xorl %ebx,  %ebx
+	xorl %ecx,  %ecx
+	xorl %edx,  %edx
+	xorl %esi,  %esi
+	xorl %edi,  %edi
+	xorl %ebp,  %ebp
+	xorl %r8d,  %r8d
+	xorl %r9d,  %r9d
+	xorl %r10d, %r10d
+	xorl %r11d, %r11d
+	xorl %r12d, %r12d
+	xorl %r13d, %r13d
+	xorl %r14d, %r14d
+	xorl %r15d, %r15d
+
+	/* Restore the TD-Exit reason to RAX for return. */
+.Lout_rax:
+	pop %rax
+
+	/* "POP" @regs. */
+.Lout_regs:
+	pop %rbx
+	pop %r12
+	pop %r13
+	pop %r14
+	pop %r15
+
+	pop %rbp
+	RET
+
+.Lvmfail_invalid:
+	/*
+	 * Use same return value convention to tdxcall.S.
+	 * TDX_SEAMCALL_VMFAILINVALID doesn't conflict with any TDX status code.
+	 */
+	mov $TDX_SEAMCALL_VMFAILINVALID, %rax
+	/* discard pushed %rsi: %rsi is caller-saved.  */
+	add $8, %rsp
+	jmp .Lout_regs
+
+.Lseamcall_faulted:
+	cmpb $0, kvm_rebooting
+	je 1f
+	mov $TDX_SW_ERROR, %r12
+	orq %r12, %rax
+	add $8, %rsp
+	jmp .Lout_regs
+1:	ud2
+	/* Use FAULT version to know what fault happened. */
+	_ASM_EXTABLE_FAULT(.Lseamcall, .Lseamcall_faulted)
+
+SYM_FUNC_END(__tdx_vcpu_run)
+
+.popsection
+
+#endif
-- 
2.25.1

