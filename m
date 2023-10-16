Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8DE7CAF6C
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjJPQdQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbjJPQcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:32:45 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC30AB;
        Mon, 16 Oct 2023 09:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473249; x=1729009249;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xf9JEbEMSZzihI7UxRNf62gli24ANbkgRb0nh8DgInY=;
  b=ElT4HCxLKMG93KJN1Ba/wlEonSg80QzLelVmMg+dfHzOeCFZlCdPR0aC
   DwukZemTVO1QB35FTOLaBensB1JwMTzp6G0dLTJIjWILU1pnZx+k9/4ej
   GITlJJYUY3zyJkBmHZ4oHY6Mzm/HR3S7Nv6qLxJLXGoHaGwzpA6SnbJaO
   O6oIz9wZAZyqy/h/IS52sv1KUlVTdpdwpWiibUKudaXsSV3B0J9/8R9gH
   gmQU133Sraz5XgmrHZk2FyzY1aE71QbDBmexJp7yimHmqesY2BoklfPcX
   E6vb8yIQgUAXKHdG/morCKza+HLfVpeOOQrxgxf6TmDg/VciLZHOiDwHk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="365825924"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="365825924"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="1087126003"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="1087126003"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:26 -0700
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
Subject: [PATCH v16 013/116] KVM: TDX: Add helper functions to print TDX SEAMCALL error
Date:   Mon, 16 Oct 2023 09:13:25 -0700
Message-Id: <ec8a2262d14f96a3a4953c4f8cd8bb1783a66972.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 000000000000..d083c79a2331
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
+void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_args *out)
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
index a55977626ae3..c9f74b2400a7 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -10,6 +10,7 @@
 #include <asm/cacheflush.h>
 #include <asm/asm.h>
 #include <asm/kvm_host.h>
+#include <asm/tdx.h>
 
 #include "tdx_errno.h"
 #include "tdx_arch.h"
@@ -57,6 +58,10 @@ static inline u64 tdx_seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
 	return ret;
 }
 
+#ifdef CONFIG_INTEL_TDX_HOST
+void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_args *out);
+#endif
+
 static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
 {
 	clflush_cache_range(__va(addr), PAGE_SIZE);
-- 
2.25.1

