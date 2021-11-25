Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B3C45D194
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352825AbhKYAYU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:24:20 -0500
Received: from mga18.intel.com ([134.134.136.126]:32610 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352690AbhKYAYM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:12 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="222281269"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="222281269"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:01 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042089"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:01 -0800
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
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v3 05/59] KVM: TDX: add a helper function for kvm to call seamcall
Date:   Wed, 24 Nov 2021 16:19:48 -0800
Message-Id: <d089468157dddab3e231a4d757aa1770b380224d.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
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
 arch/x86/kvm/vmx/seamcall.h | 113 ++++++++++++++++++++++++++++++++++++
 1 file changed, 113 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/seamcall.h

diff --git a/arch/x86/kvm/vmx/seamcall.h b/arch/x86/kvm/vmx/seamcall.h
new file mode 100644
index 000000000000..f27e9d27137d
--- /dev/null
+++ b/arch/x86/kvm/vmx/seamcall.h
@@ -0,0 +1,113 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_VMX_SEAMCALL_H
+#define __KVM_VMX_SEAMCALL_H
+
+#include <asm/asm.h>
+
+#ifdef CONFIG_INTEL_TDX_HOST
+
+#ifdef __ASSEMBLER__
+
+.macro seamcall
+	.byte 0x66, 0x0f, 0x01, 0xcf
+.endm
+
+#else
+
+/*
+ * TDX extended return:
+ * Some of The "TDX module" SEAMCALLs return extended values (which are function
+ * leaf specific) in registers in addition to the completion status code in
+ %rax.
+ */
+struct tdx_ex_ret {
+	union {
+		struct {
+			u64 rcx;
+			u64 rdx;
+			u64 r8;
+			u64 r9;
+			u64 r10;
+			u64 r11;
+		} regs;
+		/* TDH_MNG_INIT returns CPUID info on error. */
+		struct {
+			u32 leaf;
+			u32 subleaf;
+		} mng_init;
+		/* Functions that walk SEPT */
+		struct {
+			u64 septe;
+			struct {
+				u64 level		:3;
+				u64 sept_reserved_0	:5;
+				u64 state		:8;
+				u64 sept_reserved_1	:48;
+			};
+		} sept_walk;
+		/* TDH_MNG_{RD,WR} return the field value. */
+		struct {
+			u64 field_val;
+		} mng_rdwr;
+		/* TDH_MEM_{RD,WR} return the error info and value. */
+		struct {
+			u64 ext_err_info_1;
+			u64 ext_err_info_2;
+			u64 mem_val;
+		} mem_rdwr;
+		/* TDH_PHYMEM_PAGE_RDMD and TDH_PHYMEM_PAGE_RECLAIM return page metadata. */
+		struct {
+			u64 page_type;
+			u64 owner;
+			u64 page_size;
+		} phymem_page_md;
+	};
+};
+
+static inline u64 seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9, u64 r10,
+			struct tdx_ex_ret *ex)
+{
+	register unsigned long r8_in asm("r8");
+	register unsigned long r9_in asm("r9");
+	register unsigned long r10_in asm("r10");
+	register unsigned long r8_out asm("r8");
+	register unsigned long r9_out asm("r9");
+	register unsigned long r10_out asm("r10");
+	register unsigned long r11_out asm("r11");
+	struct tdx_ex_ret dummy;
+	u64 ret;
+
+	if (!ex)
+		/* The following inline assembly requires non-NULL ex. */
+		ex = &dummy;
+
+	/*
+	 * Because the TDX module is known to be already initialized, seamcall
+	 * instruction should always succeed without exceptions.  Don't check
+	 * the instruction error with CF=1 for the availability of the TDX
+	 * module.
+	 */
+	r8_in = r8;
+	r9_in = r9;
+	r10_in = r10;
+	asm volatile (
+		".byte 0x66, 0x0f, 0x01, 0xcf\n\t"	/* seamcall instruction */
+		: ASM_CALL_CONSTRAINT, "=a"(ret),
+		  "=c"(ex->regs.rcx), "=d"(ex->regs.rdx),
+		  "=r"(r8_out), "=r"(r9_out), "=r"(r10_out), "=r"(r11_out)
+		: "a"(op), "c"(rcx), "d"(rdx),
+		  "r"(r8_in), "r"(r9_in), "r"(r10_in)
+		: "cc", "memory");
+	ex->regs.r8 = r8_out;
+	ex->regs.r9 = r9_out;
+	ex->regs.r10 = r10_out;
+	ex->regs.r11 = r11_out;
+
+	return ret;
+}
+
+#endif /* !__ASSEMBLER__ */
+
+#endif	/* CONFIG_INTEL_TDX_HOST */
+
+#endif /* __KVM_VMX_SEAMCALL_H */
-- 
2.25.1

