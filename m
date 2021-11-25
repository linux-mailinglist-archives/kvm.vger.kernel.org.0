Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8632C45D199
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352894AbhKYAYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:24:23 -0500
Received: from mga18.intel.com ([134.134.136.126]:32610 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352721AbhKYAYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:13 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="222281275"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="222281275"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:03 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042103"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:02 -0800
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
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: [RFC PATCH v3 07/59] KVM: TDX: Add helper functions to print TDX SEAMCALL error
Date:   Wed, 24 Nov 2021 16:19:50 -0800
Message-Id: <191a97ab8cfa5f9336253b7a6ab41cdb49222b9b.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add helper functions to print out errors from the TDX module in an uniform
way.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/Makefile        |  1 +
 arch/x86/kvm/vmx/seamcall.h  |  3 ++
 arch/x86/kvm/vmx/tdx_error.c | 53 ++++++++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/tdx_error.c

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 75dfd27b6e8a..c7eceff49e67 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -29,6 +29,7 @@ kvm-$(CONFIG_KVM_XEN)	+= xen.o
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
 kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
+kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx_error.o
 
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
 
diff --git a/arch/x86/kvm/vmx/seamcall.h b/arch/x86/kvm/vmx/seamcall.h
index f27e9d27137d..5fa948054be6 100644
--- a/arch/x86/kvm/vmx/seamcall.h
+++ b/arch/x86/kvm/vmx/seamcall.h
@@ -106,6 +106,9 @@ static inline u64 seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9, u64 r10,
 	return ret;
 }
 
+void pr_tdx_ex_ret_info(u64 op, u64 error_code, const struct tdx_ex_ret *ex_ret);
+void pr_tdx_error(u64 op, u64 error_code, const struct tdx_ex_ret *ex_ret);
+
 #endif /* !__ASSEMBLER__ */
 
 #endif	/* CONFIG_INTEL_TDX_HOST */
diff --git a/arch/x86/kvm/vmx/tdx_error.c b/arch/x86/kvm/vmx/tdx_error.c
new file mode 100644
index 000000000000..1a4f91397758
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_error.c
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0
+/* functions to record TDX SEAMCALL error */
+
+#include <linux/kernel.h>
+#include <linux/bug.h>
+
+#include "tdx_errno.h"
+#include "tdx_arch.h"
+#include "tdx_ops.h"
+
+static const char * const TDX_SEPT_ENTRY_STATES[] = {
+	"SEPT_FREE",
+	"SEPT_BLOCKED",
+	"SEPT_PENDING",
+	"SEPT_PENDING_BLOCKED",
+	"SEPT_PRESENT"
+};
+
+void pr_tdx_ex_ret_info(u64 op, u64 error_code, const struct tdx_ex_ret *ex_ret)
+{
+	if (WARN_ON(!ex_ret))
+		return;
+
+	switch (error_code & TDX_SEAMCALL_STATUS_MASK) {
+	case TDX_EPT_WALK_FAILED: {
+		const char *state;
+
+		if (ex_ret->sept_walk.state >= ARRAY_SIZE(TDX_SEPT_ENTRY_STATES))
+			state = "Invalid";
+		else
+			state = TDX_SEPT_ENTRY_STATES[ex_ret->sept_walk.state];
+
+		pr_err("Secure EPT walk error: SEPTE 0x%llx, level %d, %s\n",
+			ex_ret->sept_walk.septe, ex_ret->sept_walk.level, state);
+		break;
+	}
+	default:
+		/* TODO: print only meaningful registers depending on op */
+		pr_err("RCX 0x%llx, RDX 0x%llx, R8 0x%llx, R9 0x%llx, "
+		       "R10 0x%llx, R11 0x%llx\n",
+			ex_ret->regs.rcx, ex_ret->regs.rdx, ex_ret->regs.r8,
+			ex_ret->regs.r9, ex_ret->regs.r10, ex_ret->regs.r11);
+		break;
+	}
+}
+
+void pr_tdx_error(u64 op, u64 error_code, const struct tdx_ex_ret *ex_ret)
+{
+	pr_err_ratelimited("SEAMCALL[0x%llx] failed: 0x%llx\n",
+			op, error_code);
+	if (ex_ret)
+		pr_tdx_ex_ret_info(op, error_code, ex_ret);
+}
-- 
2.25.1

