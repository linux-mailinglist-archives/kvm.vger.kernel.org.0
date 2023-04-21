Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB43D6EAF8F
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 18:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbjDUQuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 12:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232847AbjDUQut (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 12:50:49 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3718691;
        Fri, 21 Apr 2023 09:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682095847; x=1713631847;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R1cGvPwI+TvLSQM2okFg1qOQiQqzPO7kVX+ps6fOpj0=;
  b=i4SGEPqyZ5+KQFFN8eq5he18EqH1FQ9h4xs355Rz0PXdX5cBXv+mKoNR
   AkcPe72B9rXbjtlKgTAaZlZGetpCL61qYGo/ZCMPF8oXGJ6h+Eb1XF+b5
   TGrPOc21g3bCxw5DifPlMVNU+KPmGUL0XDTOWfAh+JhASsfpkeYionRBP
   21+RNVnpHHtbkeWfbTJKhUkRW/ijkHxUKXahcJuY1ZoYs/YlS/4X8yJr3
   7Eh9QfYwtzzMGbOYwdT0dDMPtR75lZ1/U1g8zgxhl8VPgqrzEDTgG3pWS
   Z/i45hvEXDjjVnUBdiUkJyagrUvX/HdaiZyvWIIX5ieRH/+wRD3m8+pFt
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="344786965"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="344786965"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="722817361"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="722817361"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:42 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Kees Cook <keescook@chromium.org>,
        Mike Rapoport <rppt@kernel.org>,
        Pengfei Xu <pengfei.xu@intel.com>
Subject: [PATCH v2 03/21] x86/cpufeatures: Enable CET CR4 bit for shadow stack
Date:   Fri, 21 Apr 2023 09:45:57 -0400
Message-Id: <20230421134615.62539-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230421134615.62539-1-weijiang.yang@intel.com>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

Setting CR4.CET is a prerequisite for utilizing any CET features, most of
which also require setting MSRs.

Kernel IBT already enables the CET CR4 bit when it detects IBT HW support
and is configured with kernel IBT. However, future patches that enable
userspace shadow stack support will need the bit set as well. So change
the logic to enable it in either case.

Clear MSR_IA32_U_CET in cet_disable() so that it can't live to see
userspace in a new kexec-ed kernel that has CR4.CET set from kernel IBT.

Co-developed-by: Yu-cheng Yu <yu-cheng.yu@intel.com>

Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/all/20230319001535.23210-5-rick.p.edgecombe%40intel.com
---
 arch/x86/kernel/cpu/common.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8cd4126d8253..cc686e5039be 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -600,27 +600,43 @@ __noendbr void ibt_restore(u64 save)
 
 static __always_inline void setup_cet(struct cpuinfo_x86 *c)
 {
-	u64 msr = CET_ENDBR_EN;
+	bool user_shstk, kernel_ibt;
 
-	if (!HAS_KERNEL_IBT ||
-	    !cpu_feature_enabled(X86_FEATURE_IBT))
+	if (!IS_ENABLED(CONFIG_X86_CET))
 		return;
 
-	wrmsrl(MSR_IA32_S_CET, msr);
+	kernel_ibt = HAS_KERNEL_IBT && cpu_feature_enabled(X86_FEATURE_IBT);
+	user_shstk = cpu_feature_enabled(X86_FEATURE_SHSTK) &&
+		     IS_ENABLED(CONFIG_X86_USER_SHADOW_STACK);
+
+	if (!kernel_ibt && !user_shstk)
+		return;
+
+	if (user_shstk)
+		set_cpu_cap(c, X86_FEATURE_USER_SHSTK);
+
+	if (kernel_ibt)
+		wrmsrl(MSR_IA32_S_CET, CET_ENDBR_EN);
+	else
+		wrmsrl(MSR_IA32_S_CET, 0);
+
 	cr4_set_bits(X86_CR4_CET);
 
-	if (!ibt_selftest()) {
+	if (kernel_ibt && !ibt_selftest()) {
 		pr_err("IBT selftest: Failed!\n");
 		wrmsrl(MSR_IA32_S_CET, 0);
 		setup_clear_cpu_cap(X86_FEATURE_IBT);
-		return;
 	}
 }
 
 __noendbr void cet_disable(void)
 {
-	if (cpu_feature_enabled(X86_FEATURE_IBT))
-		wrmsrl(MSR_IA32_S_CET, 0);
+	if (!(cpu_feature_enabled(X86_FEATURE_IBT) ||
+	      cpu_feature_enabled(X86_FEATURE_SHSTK)))
+		return;
+
+	wrmsrl(MSR_IA32_S_CET, 0);
+	wrmsrl(MSR_IA32_U_CET, 0);
 }
 
 /*
@@ -1482,6 +1498,9 @@ static void __init cpu_parse_early_param(void)
 	if (cmdline_find_option_bool(boot_command_line, "noxsaves"))
 		setup_clear_cpu_cap(X86_FEATURE_XSAVES);
 
+	if (cmdline_find_option_bool(boot_command_line, "nousershstk"))
+		setup_clear_cpu_cap(X86_FEATURE_USER_SHSTK);
+
 	arglen = cmdline_find_option(boot_command_line, "clearcpuid", arg, sizeof(arg));
 	if (arglen <= 0)
 		return;
-- 
2.27.0

