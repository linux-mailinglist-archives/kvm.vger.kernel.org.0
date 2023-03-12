Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAB26B645B
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjCLJzJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjCLJyx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:54:53 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31563B66C
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614891; x=1710150891;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6yEnDX8mUdxfoW5opf9C5SZQHRG0tDLqfSg3FJ1xwNg=;
  b=iYr/VX49bp1mRZ0PNpnYrXSAws9Nak2HFoHSwJnWPuohvsLGNY7cEMoj
   z3glxDGewMPToUxn+V6107M5MyEWRZniZVsPsdYJTIMNC5Z0DaE31ADkE
   iQtWr+NkgLNyykYky1DdRrcCjKCZd0BNVAhlU8lvvI4kAkQ+vVoS1tMz/
   sASljQwTlIAWCsuz6GUBc5ReV+L80rx3O62buTFOib1lM887lvSWlh2bQ
   pg16aOTMi/qssvNOyAd3gLK71ocgo76Rsnz0dH9ge3NuZI584w737Ex7Z
   r1bZSzb/9hvGQ3CuI0Zq5Pk9NeeNNjl6cf7MxJH31seXMmjWN2ENO7SQG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316622942"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316622942"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="852409029"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="852409029"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:35 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-2 13/17] pkvm: x86: Add private vmx_ops.h for pKVM
Date:   Mon, 13 Mar 2023 02:01:08 +0800
Message-Id: <20230312180112.1778254-14-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180112.1778254-1-jason.cj.chen@intel.com>
References: <20230312180112.1778254-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pKVM runtime need running as an independent binary, and be isolated
from host OS. Such runtime routines include operations for VMX, which
KVM defined in vmx/vmx_ops.h. pKVM cannot directly reuse from this
file as it contains ASM_EXTABLE and static_branch which pKVM does
not support. The simplest way is to create pKVM its own functions
without supporting such features.

Add pKVM its own VMX ops APIs in pkvm/hyp/vmx_ops.h, and ensure this new
added vmx_ops.h is used for pKVM runtime - __PKVM_HYP__ is defined to
indicate the compiled code is running under pKVM runtime.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/Makefile  |   1 +
 arch/x86/kvm/vmx/pkvm/hyp/vmx_ops.h | 185 ++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx_ops.h          |   7 ++
 3 files changed, 193 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/Makefile b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
index ea810f09e381..b58bb0325bab 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/Makefile
+++ b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
@@ -2,6 +2,7 @@
 
 ccflags-y += -I $(srctree)/arch/x86/kvm
 ccflags-y += -I $(srctree)/arch/x86/kvm/vmx/pkvm/include
+ccflags-y += -D__PKVM_HYP__
 
 pkvm-hyp-y	:= vmx_asm.o vmexit.o
 
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmx_ops.h b/arch/x86/kvm/vmx/pkvm/hyp/vmx_ops.h
new file mode 100644
index 000000000000..1692870ee00c
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmx_ops.h
@@ -0,0 +1,185 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+#ifndef _PKVM_VMX_OPS_H_
+#define _PKVM_VMX_OPS_H_
+
+#include "debug.h"
+
+#ifdef asm_volatile_goto
+#undef asm_volatile_goto
+/*
+ * GCC 'asm goto' miscompiles certain code sequences:
+ *
+ *  http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
+ *
+ * Work it around via a compiler barrier quirk suggested by Jakub Jelinek.
+ *
+ * (asm goto is automatically volatile - the naming reflects this.)
+ *
+ * This fix is removed from v6.1, but we see it still need.
+ */
+#define asm_volatile_goto(x...) do { asm goto(x); asm (""); } while (0)
+#endif
+
+static __always_inline unsigned long __vmcs_readl(unsigned long field)
+{
+	unsigned long value;
+
+#ifdef CONFIG_CC_HAS_ASM_GOTO_OUTPUT
+	asm_volatile_goto("1: vmread %[field], %[output]\n\t"
+			  "jna %l[do_fail]\n\t"
+			  : [output] "=r" (value)
+			  : [field] "r" (field)
+			  : "cc"
+			  : do_fail);
+
+	return value;
+
+do_fail:
+	pkvm_err("pkvm: vmread failed: field=%lx\n", field);
+	return 0;
+#else
+	asm volatile ("vmread %%rdx, %%rax "
+			: "=a" (value)
+			: "d"(field)
+			: "cc");
+	return value;
+#endif
+}
+
+static __always_inline u16 vmcs_read16(unsigned long field)
+{
+	vmcs_check16(field);
+	return __vmcs_readl(field);
+}
+
+static __always_inline u32 vmcs_read32(unsigned long field)
+{
+	vmcs_check32(field);
+	return __vmcs_readl(field);
+}
+
+static __always_inline u64 vmcs_read64(unsigned long field)
+{
+	vmcs_check64(field);
+	return __vmcs_readl(field);
+}
+
+static __always_inline unsigned long vmcs_readl(unsigned long field)
+{
+	vmcs_checkl(field);
+	return __vmcs_readl(field);
+}
+
+static inline void pkvm_vmwrite_error(unsigned long field, unsigned long value)
+{
+	pkvm_err("pkvm: vmwrite failed: field=%lx val=%lx err=%d\n",
+			field, value, vmcs_read32(VM_INSTRUCTION_ERROR));
+}
+
+static inline void pkvm_vmclear_error(struct vmcs *vmcs, u64 phys_addr)
+{
+	pkvm_err("pkvm: vmclear failed: %p/%llx\n", vmcs, phys_addr);
+}
+
+static inline void pkvm_vmptrld_error(struct vmcs *vmcs, u64 phys_addr)
+{
+	pkvm_err("pkvm: vmptrld failed: %p/%llx\n", vmcs, phys_addr);
+}
+
+static inline void pkvm_invvpid_error(unsigned long ext, u16 vpid, gva_t gva)
+{
+	pkvm_err("pkvm: invvpid failed: ext=0x%lx vpid=%u gva=0x%lx\n",
+			ext, vpid, gva);
+}
+
+static inline void pkvm_invept_error(unsigned long ext, u64 eptp, gpa_t gpa)
+{
+	pkvm_err("pkvm: invept failed: ext=0x%lx eptp=%llx gpa=0x%llx\n",
+			ext, eptp, gpa);
+}
+
+#define vmx_asm1(insn, op1, error_args...)				\
+do {									\
+	asm_volatile_goto(__stringify(insn) " %0\n\t"			\
+			  ".byte 0x2e\n\t" /* branch not taken hint */	\
+			  "jna %l[error]\n\t"				\
+			  : : op1 : "cc" : error);			\
+	return;								\
+error:									\
+	pkvm_##insn##_error(error_args);					\
+	return;								\
+} while (0)
+
+#define vmx_asm2(insn, op1, op2, error_args...)				\
+do {									\
+	asm_volatile_goto(__stringify(insn) " %1, %0\n\t"		\
+			  ".byte 0x2e\n\t" /* branch not taken hint */	\
+			  "jna %l[error]\n\t"				\
+			  : : op1, op2 : "cc" : error);			\
+	return;								\
+error:									\
+	pkvm_##insn##_error(error_args);					\
+	return;								\
+} while (0)
+
+static __always_inline void __vmcs_writel(unsigned long field, unsigned long value)
+{
+	vmx_asm2(vmwrite, "r"(field), "rm"(value), field, value);
+}
+
+static __always_inline void vmcs_write16(unsigned long field, u16 value)
+{
+	vmcs_check16(field);
+	__vmcs_writel(field, value);
+}
+
+static __always_inline void vmcs_write32(unsigned long field, u32 value)
+{
+	vmcs_check32(field);
+	__vmcs_writel(field, value);
+}
+
+static __always_inline void vmcs_write64(unsigned long field, u64 value)
+{
+	vmcs_check64(field);
+	__vmcs_writel(field, value);
+}
+
+static __always_inline void vmcs_writel(unsigned long field, unsigned long value)
+{
+	vmcs_checkl(field);
+	__vmcs_writel(field, value);
+}
+
+static __always_inline void vmcs_clear_bits(unsigned long field, u32 mask)
+{
+	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && ((field) & 0x6000) == 0x2000,
+			 "vmcs_clear_bits does not support 64-bit fields");
+	__vmcs_writel(field, __vmcs_readl(field) & ~mask);
+}
+
+static __always_inline void vmcs_set_bits(unsigned long field, u32 mask)
+{
+	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && ((field) & 0x6000) == 0x2000,
+			 "vmcs_set_bits does not support 64-bit fields");
+	__vmcs_writel(field, __vmcs_readl(field) | mask);
+}
+
+static inline void vmcs_clear(struct vmcs *vmcs)
+{
+	u64 phys_addr = __pa(vmcs);
+
+	vmx_asm1(vmclear, "m"(phys_addr), vmcs, phys_addr);
+}
+
+static inline void vmcs_load(struct vmcs *vmcs)
+{
+	u64 phys_addr = __pa(vmcs);
+
+	vmx_asm1(vmptrld, "m"(phys_addr), vmcs, phys_addr);
+}
+
+#endif
diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
index 842dc898c972..963865a23bb1 100644
--- a/arch/x86/kvm/vmx/vmx_ops.h
+++ b/arch/x86/kvm/vmx/vmx_ops.h
@@ -81,6 +81,12 @@ static __always_inline void vmcs_checkl(unsigned long field)
 			 "Natural width accessor invalid for 32-bit field");
 }
 
+#ifdef __PKVM_HYP__
+
+#include "pkvm/hyp/vmx_ops.h"
+
+#else
+
 static __always_inline unsigned long __vmcs_readl(unsigned long field)
 {
 	unsigned long value;
@@ -292,6 +298,7 @@ static inline void vmcs_load(struct vmcs *vmcs)
 
 	vmx_asm1(vmptrld, "m"(phys_addr), vmcs, phys_addr);
 }
+#endif /*__PKVM_HYP__*/
 
 static inline void __invvpid(unsigned long ext, u16 vpid, gva_t gva)
 {
-- 
2.25.1

