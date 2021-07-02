Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B103BA5C1
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234354AbhGBWJt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:09:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:51166 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233007AbhGBWHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:07:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="195951890"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="195951890"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:21 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814699"
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
Subject: [RFC PATCH v2 10/69] KVM: TDX: Print the name of SEAMCALL status code
Date:   Fri,  2 Jul 2021 15:04:16 -0700
Message-Id: <69fb3df4debc96f3d3e95d731ee5eab8042767fb.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

SEAMCALL error code is not intuitive to tell what's wrong in the
SEAMCALL, print the error code name along with it.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/boot/seam/tdx_common.c | 21 +++++++++++++++++++++
 arch/x86/kvm/vmx/seamcall.h         |  7 +++++--
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/boot/seam/tdx_common.c b/arch/x86/kvm/boot/seam/tdx_common.c
index d803dbd11693..4fe352fb8586 100644
--- a/arch/x86/kvm/boot/seam/tdx_common.c
+++ b/arch/x86/kvm/boot/seam/tdx_common.c
@@ -9,6 +9,7 @@
 #include <asm/kvm_boot.h>
 
 #include "vmx/tdx_arch.h"
+#include "vmx/tdx_errno.h"
 
 /*
  * TDX system information returned by TDSYSINFO.
@@ -165,3 +166,23 @@ void tdx_keyid_free(int keyid)
 	ida_free(&tdx_keyid_pool, keyid);
 }
 EXPORT_SYMBOL_GPL(tdx_keyid_free);
+
+static struct tdx_seamcall_status {
+	u64 err_code;
+	const char *err_name;
+} tdx_seamcall_status_codes[] = {TDX_SEAMCALL_STATUS_CODES};
+
+const char *tdx_seamcall_error_name(u64 error_code)
+{
+	struct tdx_seamcall_status status;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(tdx_seamcall_status_codes); i++) {
+		status = tdx_seamcall_status_codes[i];
+		if ((error_code & TDX_SEAMCALL_STATUS_MASK) == status.err_code)
+			return status.err_name;
+	}
+
+	return "Unknown SEAMCALL status code";
+}
+EXPORT_SYMBOL_GPL(tdx_seamcall_error_name);
diff --git a/arch/x86/kvm/vmx/seamcall.h b/arch/x86/kvm/vmx/seamcall.h
index 2c83ab46eeac..fbb18aea1720 100644
--- a/arch/x86/kvm/vmx/seamcall.h
+++ b/arch/x86/kvm/vmx/seamcall.h
@@ -37,11 +37,14 @@ static inline u64 _seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9, u64 r10,
 	_seamcall(SEAMCALL_##op, (rcx), (rdx), (r8), (r9), (r10), (ex))
 #endif
 
+const char *tdx_seamcall_error_name(u64 error_code);
+
 static inline void __pr_seamcall_error(u64 op, const char *op_str,
 				       u64 err, struct tdx_ex_ret *ex)
 {
-	pr_err_ratelimited("SEAMCALL[%s] failed on cpu %d: 0x%llx\n",
-			   op_str, smp_processor_id(), (err));
+	pr_err_ratelimited("SEAMCALL[%s] failed on cpu %d: %s (0x%llx)\n",
+			   op_str, smp_processor_id(),
+			   tdx_seamcall_error_name(err), err);
 	if (ex)
 		pr_err_ratelimited(
 			"RCX 0x%llx, RDX 0x%llx, R8 0x%llx, R9 0x%llx, R10 0x%llx, R11 0x%llx\n",
-- 
2.25.1

