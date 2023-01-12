Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04618667B4C
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240640AbjALQlM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:41:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238942AbjALQhc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:32 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772C212604;
        Thu, 12 Jan 2023 08:33:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541233; x=1705077233;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LSvblS0zzLFZPSvb7ezpy2oP+GCdiZKRgqQI1tfHIBE=;
  b=Qtdi6t2nARkmRFfZIa1qhA3UrD8z4mxfc2rMPc/qN2Smzc8Pl1auHG2g
   jpTgYWhwBXRA/+y4+v3h17q/xkf/kVn9Ut96SWvftupquVEBRfpDvhSDd
   HjJpJsbz0GJUEOJrp1GU66yyFAw1eRd21EqhNZHWCH1uLH4TJscQMWso+
   Cdnr8pQjH668W+vhJnC1D1wFB1qkbgVQs4N6uTf/dgVfGvDxwqyZeGefy
   8pMA8t+TyzrWk47o9/o/Pg5k21hAiHeg9T/tXXXVVH5N3GBBYpkgdRg3o
   /6ufTG5p6amQOMGExxZlws5yfOw5gJTcJhKv+VC2wnj1uTbHA23Vt7hA4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811689"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811689"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151658"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151658"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:21 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 011/113] KVM: TDX: Add helper functions to print TDX SEAMCALL error
Date:   Thu, 12 Jan 2023 08:31:19 -0800
Message-Id: <da4e44418febfbe4e3d707d17987e717c0c300f1.1673539699.git.isaku.yamahata@intel.com>
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

Add helper functions to print out errors from the TDX module in a uniform
manner.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/Makefile        |  2 +-
 arch/x86/kvm/vmx/tdx_error.c | 21 +++++++++++++++++++++
 arch/x86/kvm/vmx/tdx_ops.h   |  3 +++
 3 files changed, 25 insertions(+), 1 deletion(-)
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
index 000000000000..574b72d34e1e
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_error.c
@@ -0,0 +1,21 @@
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
+	pr_err_ratelimited("SEAMCALL[%lld] failed: 0x%llx RCX 0x%llx, RDX 0x%llx,"
+			   " R8 0x%llx, R9 0x%llx, R10 0x%llx, R11 0x%llx\n",
+			   op, error_code,
+			   out->rcx, out->rdx, out->r8, out->r9, out->r10, out->r11);
+}
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index 85adbf49c277..8cc2f01c509b 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -9,12 +9,15 @@
 #include <asm/cacheflush.h>
 #include <asm/asm.h>
 #include <asm/kvm_host.h>
+#include <asm/tdx.h>
 
 #include "tdx_errno.h"
 #include "tdx_arch.h"
 
 #ifdef CONFIG_INTEL_TDX_HOST
 
+void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_output *out);
+
 static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
 {
 	clflush_cache_range(__va(addr), PAGE_SIZE);
-- 
2.25.1

