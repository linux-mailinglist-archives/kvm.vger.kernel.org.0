Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227DC3BA5BE
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbhGBWJq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:09:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:51166 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233020AbhGBWHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:07:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="195951891"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="195951891"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:21 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814703"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:21 -0700
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
Subject: [RFC PATCH v2 11/69] KVM: TDX: Introduce pr_seamcall_ex_ret_info() to print more info when SEAMCALL fails
Date:   Fri,  2 Jul 2021 15:04:17 -0700
Message-Id: <44af6d41af20238916e33fa2a9c041f821e62d43.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

Various SEAMCALLs may have additional info in RCX, RDX, R8, R9, R10
when it completes. Introduce pr_seamcall_ex_ret_info() to parse those
additional info based on returned SEAMCALL status code.

It only processes some cases for reference. More processes for other
SEAMCALL status code can be added in the future on demand.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Co-developed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/boot/seam/tdx_common.c | 54 +++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/seamcall.h         |  6 ++--
 2 files changed, 56 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/boot/seam/tdx_common.c b/arch/x86/kvm/boot/seam/tdx_common.c
index 4fe352fb8586..a81a4672bf58 100644
--- a/arch/x86/kvm/boot/seam/tdx_common.c
+++ b/arch/x86/kvm/boot/seam/tdx_common.c
@@ -186,3 +186,57 @@ const char *tdx_seamcall_error_name(u64 error_code)
 	return "Unknown SEAMCALL status code";
 }
 EXPORT_SYMBOL_GPL(tdx_seamcall_error_name);
+
+static const char * const TDX_SEPT_ENTRY_STATES[] = {
+	"SEPT_FREE",
+	"SEPT_BLOCKED",
+	"SEPT_PENDING",
+	"SEPT_PENDING_BLOCKED",
+	"SEPT_PRESENT"
+};
+
+void pr_seamcall_ex_ret_info(u64 op, u64 error_code, struct tdx_ex_ret *ex_ret)
+{
+	if (!ex_ret)
+		return;
+
+	switch (error_code & TDX_SEAMCALL_STATUS_MASK) {
+	case TDX_INCORRECT_CPUID_VALUE:
+		pr_err("Expected CPUID [leaf 0x%x subleaf 0x%x]: "
+		       "eax 0x%x check_mask 0x%x, ebx 0x%x check_mask 0x%x, "
+		       "ecx 0x%x check_mask 0x%x, edx 0x%x check_mask 0x%x\n",
+		       ex_ret->leaf, ex_ret->subleaf,
+		       ex_ret->eax_val, ex_ret->eax_mask,
+		       ex_ret->ebx_val, ex_ret->ebx_mask,
+		       ex_ret->ecx_val, ex_ret->ecx_mask,
+		       ex_ret->edx_val, ex_ret->edx_mask);
+		break;
+	case TDX_INCONSISTENT_CPUID_FIELD:
+		pr_err("Inconsistent CPUID [leaf 0x%x subleaf 0x%x]: "
+		       "eax_mask 0x%x, ebx_mask 0x%x, ecx_mask %x, edx_mask 0x%x\n",
+		       ex_ret->leaf, ex_ret->subleaf,
+		       ex_ret->eax_mask, ex_ret->ebx_mask,
+		       ex_ret->ecx_mask, ex_ret->edx_mask);
+		break;
+	case TDX_EPT_WALK_FAILED: {
+		const char *state;
+
+		if (ex_ret->state >= ARRAY_SIZE(TDX_SEPT_ENTRY_STATES))
+			state = "Invalid";
+		else
+			state = TDX_SEPT_ENTRY_STATES[ex_ret->state];
+
+		pr_err("Secure EPT walk error: SEPTE 0x%llx, level %d, %s\n",
+		       ex_ret->septe, ex_ret->level, state);
+		break;
+	}
+	default:
+		/* TODO: print only meaningful registers depending on op */
+		pr_err("RCX 0x%llx, RDX 0x%llx, R8 0x%llx, R9 0x%llx, "
+		       "R10 0x%llx, R11 0x%llx\n",
+		       ex_ret->rcx, ex_ret->rdx, ex_ret->r8, ex_ret->r9,
+		       ex_ret->r10, ex_ret->r11);
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(pr_seamcall_ex_ret_info);
diff --git a/arch/x86/kvm/vmx/seamcall.h b/arch/x86/kvm/vmx/seamcall.h
index fbb18aea1720..85eeedc06a4f 100644
--- a/arch/x86/kvm/vmx/seamcall.h
+++ b/arch/x86/kvm/vmx/seamcall.h
@@ -38,6 +38,7 @@ static inline u64 _seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9, u64 r10,
 #endif
 
 const char *tdx_seamcall_error_name(u64 error_code);
+void pr_seamcall_ex_ret_info(u64 op, u64 error_code, struct tdx_ex_ret *ex_ret);
 
 static inline void __pr_seamcall_error(u64 op, const char *op_str,
 				       u64 err, struct tdx_ex_ret *ex)
@@ -46,10 +47,7 @@ static inline void __pr_seamcall_error(u64 op, const char *op_str,
 			   op_str, smp_processor_id(),
 			   tdx_seamcall_error_name(err), err);
 	if (ex)
-		pr_err_ratelimited(
-			"RCX 0x%llx, RDX 0x%llx, R8 0x%llx, R9 0x%llx, R10 0x%llx, R11 0x%llx\n",
-			(ex)->rcx, (ex)->rdx, (ex)->r8, (ex)->r9, (ex)->r10,
-			(ex)->r11);
+		pr_seamcall_ex_ret_info(op, err, ex);
 }
 
 #define pr_seamcall_error(op, err, ex)			\
-- 
2.25.1

