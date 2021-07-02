Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79AC3BA5C2
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbhGBWJu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:09:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:51168 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229648AbhGBWHx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:07:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="195951885"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="195951885"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:20 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814686"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:20 -0700
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v2 06/69] KVM: TDX: add a helper function for kvm to call seamcall
Date:   Fri,  2 Jul 2021 15:04:12 -0700
Message-Id: <e777bbbe10b1ec2c37d85dcca2e175fe3bc565ec.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a helper function for kvm to call seamcall and a helper macro to check
its return value.  The later patches will use them.

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kernel/asm-offsets_64.c | 15 ++++++++
 arch/x86/kvm/Makefile            |  1 +
 arch/x86/kvm/vmx/seamcall.S      | 64 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/seamcall.h      | 47 +++++++++++++++++++++++
 4 files changed, 127 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/seamcall.S
 create mode 100644 arch/x86/kvm/vmx/seamcall.h

diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index b14533af7676..c5908bcf3055 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -9,6 +9,11 @@
 #include <asm/kvm_para.h>
 #endif
 
+#ifdef CONFIG_KVM_INTEL_TDX
+#include <linux/kvm_types.h>
+#include "../kvm/vmx/tdx_arch.h"
+#endif
+
 int main(void)
 {
 #ifdef CONFIG_PARAVIRT
@@ -25,6 +30,16 @@ int main(void)
 	BLANK();
 #endif
 
+#ifdef CONFIG_KVM_INTEL_TDX
+	OFFSET(TDX_SEAM_rcx, tdx_ex_ret, rcx);
+	OFFSET(TDX_SEAM_rdx, tdx_ex_ret, rdx);
+	OFFSET(TDX_SEAM_r8,  tdx_ex_ret, r8);
+	OFFSET(TDX_SEAM_r9,  tdx_ex_ret, r9);
+	OFFSET(TDX_SEAM_r10, tdx_ex_ret, r10);
+	OFFSET(TDX_SEAM_r11, tdx_ex_ret, r11);
+	BLANK();
+#endif
+
 #define ENTRY(entry) OFFSET(pt_regs_ ## entry, pt_regs, entry)
 	ENTRY(bx);
 	ENTRY(cx);
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index c589db5d91b3..60f3e90fef8b 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -24,6 +24,7 @@ kvm-$(CONFIG_KVM_XEN)	+= xen.o
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
 kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
+kvm-intel-$(CONFIG_KVM_INTEL_TDX)	+= vmx/seamcall.o
 
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
 
diff --git a/arch/x86/kvm/vmx/seamcall.S b/arch/x86/kvm/vmx/seamcall.S
new file mode 100644
index 000000000000..08bb2b29deb7
--- /dev/null
+++ b/arch/x86/kvm/vmx/seamcall.S
@@ -0,0 +1,64 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* ASM helper to call SEAMCALL for P-SEAMLDR, TDX module */
+
+#include <linux/linkage.h>
+
+#include <asm/alternative.h>
+#include <asm/asm-offsets.h>
+#include <asm/frame.h>
+#include <asm/asm.h>
+
+#include "seamcall.h"
+
+/*
+ * __seamcall - helper function to invoke SEAMCALL to request service
+ *		of TDX module for KVM.
+ *
+ * @op  (RDI)   SEAMCALL leaf ID
+ * @rcx (RSI)   input 1 (optional based on leaf ID)
+ * @rdx (RDX)   input 2 (optional based on leaf ID)
+ * @r8  (RCX)   input 3 (optional based on leaf ID)
+ * @r9  (R8)    input 4 (optional based on leaf ID)
+ * @r10 (R9)    input 5 (optional based on leaf ID)
+ * @ex  stack   pointer to struct tdx_ex_ret. optional return value stored.
+ *
+ * @return RAX: completion code of P-SEAMLDR or TDX module
+ *		0 on success, non-0 on failure
+ *		trapnumber on fault
+ */
+SYM_FUNC_START(__seamcall)
+	FRAME_BEGIN
+
+	/* shuffle registers from function call ABI to SEAMCALL ABI. */
+	movq    %r9, %r10
+	movq    %r8, %r9
+	movq    %rcx, %r8
+	/* %rdx doesn't need shuffle. */
+	movq    %rsi, %rcx
+	movq    %rdi, %rax
+
+.Lseamcall:
+	seamcall
+	jmp	.Lseamcall_ret
+.Lspurious_fault:
+	call	kvm_spurious_fault
+.Lseamcall_ret:
+
+	movq    (FRAME_OFFSET + 8)(%rsp), %rdi
+	testq   %rdi, %rdi
+	jz 1f
+
+	/* If ex is non-NULL, store extra return values into it. */
+	movq    %rcx, TDX_SEAM_rcx(%rdi)
+	movq    %rdx, TDX_SEAM_rdx(%rdi)
+	movq    %r8,  TDX_SEAM_r8(%rdi)
+	movq    %r9,  TDX_SEAM_r9(%rdi)
+	movq    %r10, TDX_SEAM_r10(%rdi)
+	movq    %r11, TDX_SEAM_r11(%rdi)
+
+1:
+	FRAME_END
+	ret
+
+	_ASM_EXTABLE(.Lseamcall, .Lspurious_fault)
+SYM_FUNC_END(__seamcall)
diff --git a/arch/x86/kvm/vmx/seamcall.h b/arch/x86/kvm/vmx/seamcall.h
new file mode 100644
index 000000000000..a318940f62ed
--- /dev/null
+++ b/arch/x86/kvm/vmx/seamcall.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_VMX_SEAMCALL_H
+#define __KVM_VMX_SEAMCALL_H
+
+#ifdef __ASSEMBLY__
+
+#define seamcall .byte 0x66, 0x0f, 0x01, 0xcf
+
+#else
+
+#ifndef seamcall
+struct tdx_ex_ret;
+asmlinkage u64 __seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9, u64 r10,
+			  struct tdx_ex_ret *ex);
+
+#define seamcall(op, rcx, rdx, r8, r9, r10, ex)				\
+	__seamcall(SEAMCALL_##op, (rcx), (rdx), (r8), (r9), (r10), (ex))
+#endif
+
+static inline void __pr_seamcall_error(u64 op, const char *op_str,
+				       u64 err, struct tdx_ex_ret *ex)
+{
+	pr_err_ratelimited("SEAMCALL[%s] failed on cpu %d: 0x%llx\n",
+			   op_str, smp_processor_id(), (err));
+	if (ex)
+		pr_err_ratelimited(
+			"RCX 0x%llx, RDX 0x%llx, R8 0x%llx, R9 0x%llx, R10 0x%llx, R11 0x%llx\n",
+			(ex)->rcx, (ex)->rdx, (ex)->r8, (ex)->r9, (ex)->r10,
+			(ex)->r11);
+}
+
+#define pr_seamcall_error(op, err, ex)			\
+	__pr_seamcall_error(SEAMCALL_##op, #op, (err), (ex))
+
+/* ex is a pointer to struct tdx_ex_ret or NULL. */
+#define TDX_ERR(err, op, ex)			\
+({						\
+	u64 __ret_warn_on = WARN_ON_ONCE(err);	\
+						\
+	if (unlikely(__ret_warn_on))		\
+		pr_seamcall_error(op, err, ex);	\
+	__ret_warn_on;				\
+})
+
+#endif
+
+#endif /* __KVM_VMX_SEAMCALL_H */
-- 
2.25.1

