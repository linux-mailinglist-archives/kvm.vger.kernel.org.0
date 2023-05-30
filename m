Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C481E7153F8
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 04:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjE3Co6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 22:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbjE3Cou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 22:44:50 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCB6FC
        for <kvm@vger.kernel.org>; Mon, 29 May 2023 19:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685414652; x=1716950652;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Nfrh5MlO6jgGG7ooapUh7ZazwXagg+3zDhLO/bwvz8U=;
  b=DCOfNU6GEX1MGvPDieB+boK08LQkoLGqbPKL6VRzxyolqj7jIPqWDJDT
   GdxZ2zue5hVImdJbvO3u5OimpWmSYkCDehMh/hRc0D0fONaU/cM/MeiuQ
   3BzlIhQsCiuLsxl2PFGH7FShr7GtAaNl9JDyUhXSBVq4GctNgrNa6dyJo
   HTvp11gQ1ikI2H/iju4toUBpDAEPJfJXgfg+7wgu3YaYCCeg0SXN10OTy
   hehIR2FJEc8XMjlWVwrq0Wal9HUAtd7bUrJb43pOxke6BmcaBWPTGMkqJ
   CDiP0XqXOjqxuVXs9ijfrKpSRttBRrpz0qe+MO7ZNIRVz1reLaj5rqeTE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="418287007"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="418287007"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 19:44:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="656658795"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="656658795"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.254.208.104])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 19:44:04 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        robert.hu@linux.intel.com, binbin.wu@linux.intel.com
Subject: [PATCH v5 1/4] x86: Allow setting of CR3 LAM bits if LAM supported
Date:   Tue, 30 May 2023 10:43:53 +0800
Message-Id: <20230530024356.24870-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230530024356.24870-1-binbin.wu@linux.intel.com>
References: <20230530024356.24870-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If LINEAR ADDRESS MASKING (LAM) is supported, VM entry allows CR3.LAM_U48
(bit 62) and CR3.LAM_U57 (bit 61) to be set in CR3 field.

Change the test result expectations when setting CR3.LAM_U48 or CR3.LAM_U57
on vmlaunch tests when LAM is supported.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
 lib/x86/processor.h | 3 +++
 x86/vmx_tests.c     | 6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 6555056..901df98 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -55,6 +55,8 @@
 #define X86_CR0_PG		BIT(X86_CR0_PG_BIT)
 
 #define X86_CR3_PCID_MASK	GENMASK(11, 0)
+#define X86_CR3_LAM_U57_BIT	(61)
+#define X86_CR3_LAM_U48_BIT	(62)
 
 #define X86_CR4_VME_BIT		(0)
 #define X86_CR4_VME		BIT(X86_CR4_VME_BIT)
@@ -249,6 +251,7 @@ static inline bool is_intel(void)
 #define	X86_FEATURE_FLUSH_L1D		(CPUID(0x7, 0, EDX, 28))
 #define	X86_FEATURE_ARCH_CAPABILITIES	(CPUID(0x7, 0, EDX, 29))
 #define	X86_FEATURE_PKS			(CPUID(0x7, 0, ECX, 31))
+#define	X86_FEATURE_LAM			(CPUID(0x7, 1, EAX, 26))
 
 /*
  * Extended Leafs, a.k.a. AMD defined
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 7952ccb..217befe 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -6998,7 +6998,11 @@ static void test_host_ctl_regs(void)
 		cr3 = cr3_saved | (1ul << i);
 		vmcs_write(HOST_CR3, cr3);
 		report_prefix_pushf("HOST_CR3 %lx", cr3);
-		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
+		if (this_cpu_has(X86_FEATURE_LAM) &&
+		    ((i == X86_CR3_LAM_U57_BIT) || (i == X86_CR3_LAM_U48_BIT)))
+			test_vmx_vmlaunch(0);
+		else
+			test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
 		report_prefix_pop();
 	}
 
-- 
2.25.1

