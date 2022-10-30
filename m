Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E906127C3
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbiJ3GY0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiJ3GYE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:24:04 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D5BA8;
        Sat, 29 Oct 2022 23:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111043; x=1698647043;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rRN5kbq0TqI2b4uCt5j6yH0GqnOcoNEW+tyjQehDDAc=;
  b=QwZdbkst8sRpUhDBuLCuW1ZfCEpWTFGTOweuEll52rAETzhd/ZjyAi0a
   IkkL6cZvxhUjVNWgcSkRs3YbVFORk/ollKZ2bA4ffIuxiIScGn2qxQEps
   4ISjfty+/KSZQOnWfQ/OGGchNrQagOom48GC0DuVCX6m4LXm2wwaqUWN2
   y5+yKk3eK/uxMqFQ0kc2UARI3AhihiclvwJ+tLm4WuU14Wsw4RbdsnnHB
   i/nBCX9InNU7PinkPB/c0S+KCat9LdzOtDKVFJyeQ8Msm2XIlTnFZOPCo
   6bP/PbYyAsUUWS50c0VqB/+SKNFCDcezDxglzWunO+BBJrNfXHonvBCl+
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037124"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037124"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:23:58 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878392866"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878392866"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:23:58 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 012/108] KVM: TDX: Add helper functions to print TDX SEAMCALL error
Date:   Sat, 29 Oct 2022 23:22:13 -0700
Message-Id: <752b25882092134bd8d117b3e429227bd5a18567.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index e2c05195cb95..f1ad445df505 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -24,7 +24,7 @@ kvm-$(CONFIG_KVM_XEN)	+= xen.o
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o vmx/main.o
 kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
-kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o
+kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o vmx/tdx_error.o
 
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
 
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

