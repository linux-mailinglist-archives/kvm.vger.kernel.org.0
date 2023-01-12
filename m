Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C51667B9B
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240952AbjALQnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240328AbjALQis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:38:48 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5501CFF7;
        Thu, 12 Jan 2023 08:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541248; x=1705077248;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r/C2Z6f3JcZ/XH9fq4C/D8Dkuxd5FR02GhHzeeKdxOg=;
  b=c6756g9s5eTMC02Qk21a7BjZ/jXCUwPPZ5dStZjHc8Q48xZibbNjYicn
   ZqSnU7OClDQcbajZq+HupJyNTJTtjhbArXEL+9pHfp+HL+P10rxCag9DQ
   XNC/zG8+W8W4/scZVUttErx9E5oa0Y277HZbtP3KVnyvMwPQbFd/7bzSI
   yuQjo0CUid7HCuvfAofalSXe8peDPj1DIpUsLuRedwnenw5NC95MVms2B
   0col7K3yfJQzteJpQ1y1lrYZq7QFVND5Z2Tscf2yFrQtsTFeadcEEDotx
   2agefqkhahFi6pRu8l4R0E+Q1dNd+OEC1x+m1YuDy5D2z6NZGR+5lCQXO
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811970"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811970"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:31 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151859"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151859"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:31 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 064/113] KVM: TDX: Add helper assembly function to TDX vcpu
Date:   Thu, 12 Jan 2023 08:32:12 -0800
Message-Id: <d33212a340582e17fcd76206c41e0ab9dc22c433.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX defines an API to run TDX vcpu with its own ABI.  Define an assembly
helper function to run TDX vcpu to hide the special ABI so that C code can
call it with function call ABI.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/tdx.h |   3 +-
 arch/x86/kvm/vmx/vmenter.S | 156 +++++++++++++++++++++++++++++++++++++
 2 files changed, 158 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index d7ce2217279f..144b719d607f 100644
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
index 766c6b3ef5ed..58516611f31b 100644
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
 .section .noinstr.text, "ax"
 
 /**
@@ -352,3 +359,152 @@ SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
 	pop %_ASM_BP
 	RET
 SYM_FUNC_END(vmx_do_interrupt_nmi_irqoff)
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
+	je 1f
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
+1:	mov $TDH_VP_ENTER, %rax
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
+	/* Skip to the exit path if TDH_VP_ENTER failed. */
+	bt $TDX_ERROR_BIT, %rax
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

