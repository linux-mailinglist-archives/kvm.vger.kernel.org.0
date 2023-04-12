Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3026DECFC
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 09:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjDLHvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 03:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjDLHvs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 03:51:48 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF535FE5
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 00:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681285907; x=1712821907;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nkRjwGhxXGcTh2UbgeCl+DLC/p2fpGDlcCsCe5HekTQ=;
  b=AbUscfkPRfox/Xudhkpqfg/J/lnTep/RqIUmZms1zbgBvbElC3Tc91XX
   Ju4OYZib3kGkr534Ke0SnreDzobiHD4jYT7nZVF8o0/QQsWGew9/M/QZZ
   ERShsfDAF9ubNvlgO3M3OHmBzwHR45gL/W1JHhAUykelu9gGffFA5AfvB
   q03hd2ZvJ1RKNpQuQO6dzLVr1sh6nqX1ty+qXsT2MIQmm+l5as0Hqpp1Z
   LYDBc3M8ooHoZldHJoHNIDXHOFJhnl0DS3bAxUpmR7j+yjf2koAmRskRH
   Usxbl6gSasAYlUe6+XnGe6rK8kroyENxF3YLAneUdBp5ZirmIqzj2Jzg6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="345623256"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="345623256"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 00:51:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="812893659"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="812893659"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.238.8.125])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 00:51:44 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     binbin.wu@linux.intel.com, chao.gao@intel.com,
        robert.hu@linux.intel.com
Subject: [kvm-unit-tests v3 1/4] x86: Allow setting of CR3 LAM bits if LAM supported
Date:   Wed, 12 Apr 2023 15:51:31 +0800
Message-Id: <20230412075134.21240-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230412075134.21240-1-binbin.wu@linux.intel.com>
References: <20230412075134.21240-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
index 3d58ef7..e00a32b 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -55,6 +55,8 @@
 #define X86_CR0_PG		BIT(X86_CR0_PG_BIT)
 
 #define X86_CR3_PCID_MASK	GENMASK(11, 0)
+#define X86_CR3_LAM_U57_BIT	(61)
+#define X86_CR3_LAM_U48_BIT	(62)
 
 #define X86_CR4_VME_BIT		(0)
 #define X86_CR4_VME		BIT(X86_CR4_VME_BIT)
@@ -248,6 +250,7 @@ static inline bool is_intel(void)
 #define	X86_FEATURE_SPEC_CTRL		(CPUID(0x7, 0, EDX, 26))
 #define	X86_FEATURE_ARCH_CAPABILITIES	(CPUID(0x7, 0, EDX, 29))
 #define	X86_FEATURE_PKS			(CPUID(0x7, 0, ECX, 31))
+#define	X86_FEATURE_LAM			(CPUID(0x7, 1, EAX, 26))
 
 /*
  * Extended Leafs, a.k.a. AMD defined
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 7bba816..5ee1264 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7000,7 +7000,11 @@ static void test_host_ctl_regs(void)
 		cr3 = cr3_saved | (1ul << i);
 		vmcs_write(HOST_CR3, cr3);
 		report_prefix_pushf("HOST_CR3 %lx", cr3);
-		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
+		if (this_cpu_has(X86_FEATURE_LAM) &&
+		    ((i == X86_CR3_LAM_U57_BIT) || ( i == X86_CR3_LAM_U48_BIT)))
+			test_vmx_vmlaunch(0);
+		else
+			test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
 		report_prefix_pop();
 	}
 
-- 
2.25.1

