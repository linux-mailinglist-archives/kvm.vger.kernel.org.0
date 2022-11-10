Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C09D623BAE
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 07:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232378AbiKJGRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 01:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbiKJGRV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 01:17:21 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3CD2ED77
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 22:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668061040; x=1699597040;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dhU3XR4qiKmtU3OBrwyj0ws6KT1curnwZdVb3a04z6Y=;
  b=XM6m1fBzn7AO8q1amHMvarkIcdWbZ2SOwzrqUUtLddJZ8nOzt0pjW0Gc
   SBGX2N8dbYBE0Pyj2Lg0h7sHwm6KoE5g8b/QbG+OMZ2poHm5Fwicvtkdb
   qvMzg0QVP2Y6xUgq7FnpOqMIxSjl6r/bgeZJ71lNE/8ZePtR5Ojc4G8sm
   eU5/6TgRhFN4EExtRHCIIHtmS3GaJege+KQ4xTG/YJUbvptxMI30A4X0M
   92u851XJzMRP0Ir5FEKkn4CNyOgUYuHWFGzdKvjFZIUy9Q6+jc4a5i36f
   zI68ExrOJHg3cqlvKgRr7Oi7qrXCmu516LNxr+oEtrSvgQvMk9MQN8SQV
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="311223529"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="311223529"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 22:17:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="700667278"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="700667278"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 09 Nov 2022 22:17:18 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernnel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, kevin.tian@intel.com
Subject: [PATCH 6/6] x86/traps: remove unused NMI entry exc_nmi_noist()
Date:   Wed,  9 Nov 2022 21:53:47 -0800
Message-Id: <20221110055347.7463-7-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110055347.7463-1-xin3.li@intel.com>
References: <20221110055347.7463-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After the introduction of kvm_vmx_reinject_irq(), exc_nmi_noist()
is no longer needed, thus remove it.

Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/idtentry.h | 15 ---------------
 arch/x86/kernel/nmi.c           | 10 ----------
 2 files changed, 25 deletions(-)

diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 72184b0b2219..da28ac17c57a 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -581,21 +581,6 @@ DECLARE_IDTENTRY_RAW(X86_TRAP_MC,	xenpv_exc_machine_check);
 #endif
 
 /* NMI */
-
-#if defined(CONFIG_X86_64) && IS_ENABLED(CONFIG_KVM_INTEL)
-/*
- * Special NOIST entry point for VMX which invokes this on the kernel
- * stack. asm_exc_nmi() requires an IST to work correctly vs. the NMI
- * 'executing' marker.
- *
- * On 32bit this just uses the regular NMI entry point because 32-bit does
- * not have ISTs.
- */
-DECLARE_IDTENTRY(X86_TRAP_NMI,		exc_nmi_noist);
-#else
-#define asm_exc_nmi_noist		asm_exc_nmi
-#endif
-
 DECLARE_IDTENTRY_NMI(X86_TRAP_NMI,	exc_nmi);
 #ifdef CONFIG_XEN_PV
 DECLARE_IDTENTRY_RAW(X86_TRAP_NMI,	xenpv_exc_nmi);
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index cec0bfa3bc04..816bb59a4ba4 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -527,16 +527,6 @@ DEFINE_IDTENTRY_RAW(exc_nmi)
 		mds_user_clear_cpu_buffers();
 }
 
-#if defined(CONFIG_X86_64) && IS_ENABLED(CONFIG_KVM_INTEL)
-DEFINE_IDTENTRY_RAW(exc_nmi_noist)
-{
-	exc_nmi(regs);
-}
-#endif
-#if IS_MODULE(CONFIG_KVM_INTEL)
-EXPORT_SYMBOL_GPL(asm_exc_nmi_noist);
-#endif
-
 void stop_nmi(void)
 {
 	ignore_nmis++;
-- 
2.34.1

