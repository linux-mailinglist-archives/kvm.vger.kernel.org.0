Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F8354DD73
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 10:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376329AbiFPIta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 04:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376319AbiFPIsv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 04:48:51 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627261BE88;
        Thu, 16 Jun 2022 01:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655369264; x=1686905264;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FSN5H84gs5D/Dj5DTDmZALwdCo8U9STbNybYgwFnfzI=;
  b=hGua9T3ZLslif9K98H+1ZuG6OEUTAVy55qzpkheZN4kKDnvPj8lCDU5O
   13xZbkLGscPb9ZZXXziIaHOMKVhkL7Vs5XbIncI9I9LeBQZzQ1JRc58L3
   Jaoxo7YOFseoZvE0wrbkuDY1JybMnO+KexI+b3sme4fyIeLieYvdvjP61
   QGvTXksdFIjsnhUlIiol6lsTHkkyWuvcttv6jEmJnX4wo2KdOYmv1YCIE
   MzcY1peqHUZYP/jxDajaGMuO2d83T48a1yp2N9H5Lw8FBeHPqNph/71w9
   eCs1Ku0mWOb3RncJUsEqwpaewCYeUI2vhOZdDiLbRVW/Xa3owZNm+lc2g
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="259664554"
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="259664554"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:41 -0700
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="613083133"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:40 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com
Cc:     weijiang.yang@intel.com, Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 03/19] x86/cpufeatures: Enable CET CR4 bit for shadow stack
Date:   Thu, 16 Jun 2022 04:46:27 -0400
Message-Id: <20220616084643.19564-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220616084643.19564-1-weijiang.yang@intel.com>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yu-cheng Yu <yu-cheng.yu@intel.com>

Utilizing CET features requires a CR4 bit to be enabled as well as bits
to be set in CET MSRs. Setting the CR4 bit does two things:
 1. Enables the usage of WRUSS instruction, which the kernel can use to
    write to userspace shadow stacks.
 2. Allows those individual aspects of CET to be enabled later via the MSR.

While future patches will allow the MSR values to be saved and restored
per task, the CR4 bit will allow for WRUSS to be used regardless of if a
tasks CET MSRs have been restored.

Kernel IBT already enables the CR4 bit. Modify the logic to enable it for
when the kernel is configured with and detects shadow stack support, as
well.

Rename cet_disable() to ibt_disable() since it no longer applies to all
CET features in the kernel.

Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Cc: Kees Cook <keescook@chromium.org>

---
v2:
 - Drop no_user_shstk (Dave Hansen)
 - Elaborate on what the CR4 bit does in the commit log
 - Integrate with Kernel IBT logic

v1:
 - Moved kernel-parameters.txt changes here from patch 1.

Yu-cheng v25:
 - Remove software-defined X86_FEATURE_CET.

Yu-cheng v24:
 - Update #ifdef placement to reflect Kconfig changes of splitting shadow stack
   and ibt.

 arch/x86/include/asm/cpu.h         |  2 +-
 arch/x86/kernel/cpu/common.c       | 14 +++++++-------
 arch/x86/kernel/machine_kexec_64.c |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 8cbf623f0ecf..a56270838435 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -74,7 +74,7 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c);
 static inline void init_ia32_feat_ctl(struct cpuinfo_x86 *c) {}
 #endif
 
-extern __noendbr void cet_disable(void);
+extern __noendbr void ibt_disable(void);
 
 struct ucode_cpu_info;
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c296cb1c0113..86102a8d451e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -598,23 +598,23 @@ __noendbr void ibt_restore(u64 save)
 
 static __always_inline void setup_cet(struct cpuinfo_x86 *c)
 {
+	bool kernel_ibt = HAS_KERNEL_IBT && cpu_feature_enabled(X86_FEATURE_IBT);
 	u64 msr = CET_ENDBR_EN;
 
-	if (!HAS_KERNEL_IBT ||
-	    !cpu_feature_enabled(X86_FEATURE_IBT))
-		return;
+	if (kernel_ibt)
+		wrmsrl(MSR_IA32_S_CET, msr);
 
-	wrmsrl(MSR_IA32_S_CET, msr);
-	cr4_set_bits(X86_CR4_CET);
+	if (kernel_ibt || cpu_feature_enabled(X86_FEATURE_SHSTK))
+		cr4_set_bits(X86_CR4_CET);
 
-	if (!ibt_selftest()) {
+	if (kernel_ibt && !ibt_selftest()) {
 		pr_err("IBT selftest: Failed!\n");
 		setup_clear_cpu_cap(X86_FEATURE_IBT);
 		return;
 	}
 }
 
-__noendbr void cet_disable(void)
+__noendbr void ibt_disable(void)
 {
 	if (cpu_feature_enabled(X86_FEATURE_IBT))
 		wrmsrl(MSR_IA32_S_CET, 0);
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 0611fd83858e..745024654fcd 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -311,7 +311,7 @@ void machine_kexec(struct kimage *image)
 	/* Interrupts aren't acceptable while we reboot */
 	local_irq_disable();
 	hw_breakpoint_disable();
-	cet_disable();
+	ibt_disable();
 
 	if (image->preserve_context) {
 #ifdef CONFIG_X86_IO_APIC
-- 
2.27.0

