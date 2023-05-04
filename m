Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 226586F67B6
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 10:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjEDIsB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 04:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjEDIr6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 04:47:58 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3627D197
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 01:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683190077; x=1714726077;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eOW017PxGqL1Rd63A+r6F2P7WVekCj7OfV/lMsN6bL4=;
  b=I+fXCw8NCkC7Kr8TzA3Q5mhDleF/Xp1R4q5nWG0fmVoOj6Sm9P40R5iX
   vIkWe3cvSlpdlNbAKi1VVWjHkzr5Uq80esc6X5zNsZlF5u6thF1B/yTgq
   kqmkKkEzkM9KHLips3sSXNyzzA2Q6NPFZ+ve4UGzOkA1OfdUogOzyvLNN
   pGBDJSa7lxfHkoodP2BOUtu+qX0CwTpt6s17KHbkNKIgIHq6srPdssUU1
   tJI32Empw239rEDE+t1c6npeDHmcRju6p3ljR3gSHXyhWqWX821HoCDwr
   Ni0dMcd9ZDR+wiD90+CpjyiA/ZfS2H6Xl/ED16i2vaFDUtrIwAX9LE1QL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="435178177"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="435178177"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2023 01:47:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="766480464"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="766480464"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.238.1.46])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2023 01:47:55 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        robert.hu@linux.intel.com, binbin.wu@linux.intel.com
Subject: [kvm-unit-tests v4 1/4] x86: Allow setting of CR3 LAM bits if LAM supported
Date:   Thu,  4 May 2023 16:47:48 +0800
Message-Id: <20230504084751.968-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230504084751.968-1-binbin.wu@linux.intel.com>
References: <20230504084751.968-1-binbin.wu@linux.intel.com>
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

If LAM is supported, VM entry allows CR3.LAM_U48 (bit 62) and CR3.LAM_U57
(bit 61) to be set in CR3 field.

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

