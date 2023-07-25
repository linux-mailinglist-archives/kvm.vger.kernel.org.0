Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269E57625EB
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbjGYWQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbjGYWPn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:15:43 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDCBBC;
        Tue, 25 Jul 2023 15:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323341; x=1721859341;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JMtVpqNAMjI4Ci0bJaSt8eNsqbuL48mvNaWm2+I8CxI=;
  b=hORLSQlRMTfETKEdi7pCzQ1BVE4mFrY8X0UkjPrN3y/Z7qQFFXqcQR58
   fvOBMbBg4nuWZHJtrhQ7iaR+wk8eLJKEr+eiazN92CiPnVfKw5z9zhRD8
   gMTZld0KzrworPRwCpvNjOJYCClYzYJZZ6ShBNMzdbc4Z4nsfG39LPt6M
   epQCEyh5TFXlJYocvVl7ZJMNrD+32Iaov5tA4iOiwW5uDo/PqZwDw6nC7
   FtusNRvOe1mZWxK6RV/LztuqY+UIWwJVVZtuuCMnv20Lmm31UJJ2c/mZM
   bI90nwdqU5BG+pMKM+Nauw0zs9jL50YEDgf2nxAMWwtrBJz5vFT5eSZXQ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="357863093"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="357863093"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="1056938806"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="1056938806"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:20 -0700
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
Subject: [PATCH v15 013/115] KVM: TDX: Add helper functions to print TDX SEAMCALL error
Date:   Tue, 25 Jul 2023 15:13:24 -0700
Message-Id: <c8588857397ef1f4c265bda57cab5cb70b31b267.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add helper functions to print out errors from the TDX module in a uniform
manner.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/Makefile        |  2 +-
 arch/x86/kvm/vmx/tdx_error.c | 20 ++++++++++++++++++++
 arch/x86/kvm/vmx/tdx_ops.h   |  5 +++++
 3 files changed, 26 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kvm/vmx/tdx_error.c

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 4b01ab842ab7..e3354b784e10 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -25,7 +25,7 @@ kvm-$(CONFIG_KVM_SMM)	+= smm.o
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/hyperv.o vmx/nested.o vmx/posted_intr.o vmx/main.o
 kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
-kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o
+kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o vmx/tdx_error.o
 
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o \
 			   svm/sev.o svm/hyperv.o
diff --git a/arch/x86/kvm/vmx/tdx_error.c b/arch/x86/kvm/vmx/tdx_error.c
new file mode 100644
index 000000000000..6459cbada713
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_error.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0
+/* functions to record TDX SEAMCALL error */
+
+#include <linux/kernel.h>
+#include <linux/bug.h>
+
+#include "tdx_ops.h"
+
+void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_output *out)
+{
+	if (!out) {
+		pr_err_ratelimited("SEAMCALL[%lld] failed: 0x%llx\n",
+				   op, error_code);
+		return;
+	}
+
+#define MSG	"SEAMCALL[%lld] failed: 0x%llx RCX 0x%llx RDX 0x%llx R8 0x%llx R9 0x%llx R10 0x%llx R11 0x%llx\n"
+	pr_err_ratelimited(MSG, op, error_code, out->rcx, out->rdx, out->r8,
+			   out->r9, out->r10, out->r11);
+}
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index d588a5507f5a..9db19c0711a9 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -10,6 +10,7 @@
 #include <asm/cacheflush.h>
 #include <asm/asm.h>
 #include <asm/kvm_host.h>
+#include <asm/tdx.h>
 
 #include "tdx_errno.h"
 #include "tdx_arch.h"
@@ -41,6 +42,10 @@ static inline u64 tdx_seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
 	return ret;
 }
 
+#ifdef CONFIG_INTEL_TDX_HOST
+void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_output *out);
+#endif
+
 static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
 {
 	clflush_cache_range(__va(addr), PAGE_SIZE);
-- 
2.25.1

