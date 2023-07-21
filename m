Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F06F75D588
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 22:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjGUUT4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 16:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjGUUTc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 16:19:32 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AE2359B
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:25 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b8a7734734so13797005ad.2
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689970765; x=1690575565;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BABBYG9T7Yn2sZTHqi5m2u4CXRQ2CmLvyTIjco5c63g=;
        b=L1pQH1k9NYEONtiByxTTURMw61jXy4L9Kk3ri6cUN6Z+iQ6l9paGL8Mts/CoI1ah8E
         p5sh/GxpWGNRTHR8gZR3aL7Z1eHd7efWK8WBAT9JhKhc/YN0RxnOWyQ2JXr/nsvMvRF8
         T8UWXdr1r33MMP2c9F+tPUT0Vx9KzkmzaqkWHFTgRAcqdD3k8r+UJhpBa3ubw0HY3ib2
         imDCqrcruiJZnhVO9V3DRNlFTLXF0AKlqECEJy2mZKhEppb21CSS06AmUP0RyBFxFEon
         XhNIiCfxnzxVY8X+aZED+NIEf02YSjU1tdYg+DMuihX7XrM45w+LABXt9Gv1lLloQIHt
         eExQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689970765; x=1690575565;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BABBYG9T7Yn2sZTHqi5m2u4CXRQ2CmLvyTIjco5c63g=;
        b=DrdsRtyPXboiNRJMnmnrh8PgvZUJDUl+MBU7mvjbzGPSzhWWxNI87ljLr3ckG3FlNG
         1E+ls0NbMiygWpsWcYVor5Nl8vn8spiwmOohLJllXepQysQXdXjbp15ra5QTP5ycTTOT
         jgbj5AUUnKvzOBO5NXs84JY87SnMq4RVg1v4qw2+iP8GnR2S+XxwCqkBsJehQcCYUqYR
         Iy6WHKkI/TGJqkjLr8wnkSNWQomygYnaYgwkyk6cAdUkeAG9R/JbUcvuuxCADMt1oujb
         kVW781SbMvT4tUB9blflrXadpooU9tbhmLYL9i37N+S+UCSiIVIlHKkUWzBJPxDw7+mY
         EC4A==
X-Gm-Message-State: ABy/qLZAYygxUppV6ewpm5wOu7QcrUk5s+Fmm+c/g5S5iQp22zMxetsD
        o9Gf3EuFfO0uk3UDPWyGSPwoaogQlvo=
X-Google-Smtp-Source: APBJJlG7qyKs7dIq2bWnrS/RJELFnYwUdBBi7VqUqUs0BYMwPmd19ZF5uNKykA3UY+W5oKnx/mhTmA8GenQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2308:b0:1b8:80c9:a98e with SMTP id
 d8-20020a170903230800b001b880c9a98emr11974plh.13.1689970764858; Fri, 21 Jul
 2023 13:19:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 13:18:50 -0700
In-Reply-To: <20230721201859.2307736-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721201859.2307736-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721201859.2307736-11-seanjc@google.com>
Subject: [PATCH v4 10/19] x86/virt: KVM: Move VMXOFF helpers into KVM VMX
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that VMX is disabled in emergencies via the virt callbacks, move the
VMXOFF helpers into KVM, the only remaining user.

No functional change intended.

Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/virtext.h | 42 ----------------------------------
 arch/x86/kvm/vmx/vmx.c         | 29 ++++++++++++++++++++---
 2 files changed, 26 insertions(+), 45 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index b1171a5ad452..a27801f2bc71 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -19,48 +19,6 @@
 #include <asm/svm.h>
 #include <asm/tlbflush.h>
 
-/*
- * VMX functions:
- */
-/**
- * cpu_vmxoff() - Disable VMX on the current CPU
- *
- * Disable VMX and clear CR4.VMXE (even if VMXOFF faults)
- *
- * Note, VMXOFF causes a #UD if the CPU is !post-VMXON, but it's impossible to
- * atomically track post-VMXON state, e.g. this may be called in NMI context.
- * Eat all faults as all other faults on VMXOFF faults are mode related, i.e.
- * faults are guaranteed to be due to the !post-VMXON check unless the CPU is
- * magically in RM, VM86, compat mode, or at CPL>0.
- */
-static inline int cpu_vmxoff(void)
-{
-	asm_volatile_goto("1: vmxoff\n\t"
-			  _ASM_EXTABLE(1b, %l[fault])
-			  ::: "cc", "memory" : fault);
-
-	cr4_clear_bits(X86_CR4_VMXE);
-	return 0;
-
-fault:
-	cr4_clear_bits(X86_CR4_VMXE);
-	return -EIO;
-}
-
-static inline int cpu_vmx_enabled(void)
-{
-	return __read_cr4() & X86_CR4_VMXE;
-}
-
-/** Disable VMX if it is enabled on the current CPU
- */
-static inline void __cpu_emergency_vmxoff(void)
-{
-	if (cpu_vmx_enabled())
-		cpu_vmxoff();
-}
-
-
 /*
  * SVM functions:
  */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 71571cd9adbb..6f4fcd82fa6e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -47,7 +47,6 @@
 #include <asm/mshyperv.h>
 #include <asm/mwait.h>
 #include <asm/spec-ctrl.h>
-#include <asm/virtext.h>
 #include <asm/vmx.h>
 
 #include "capabilities.h"
@@ -744,6 +743,29 @@ static int vmx_set_guest_uret_msr(struct vcpu_vmx *vmx,
 	return ret;
 }
 
+/*
+ * Disable VMX and clear CR4.VMXE (even if VMXOFF faults)
+ *
+ * Note, VMXOFF causes a #UD if the CPU is !post-VMXON, but it's impossible to
+ * atomically track post-VMXON state, e.g. this may be called in NMI context.
+ * Eat all faults as all other faults on VMXOFF faults are mode related, i.e.
+ * faults are guaranteed to be due to the !post-VMXON check unless the CPU is
+ * magically in RM, VM86, compat mode, or at CPL>0.
+ */
+static int kvm_cpu_vmxoff(void)
+{
+	asm_volatile_goto("1: vmxoff\n\t"
+			  _ASM_EXTABLE(1b, %l[fault])
+			  ::: "cc", "memory" : fault);
+
+	cr4_clear_bits(X86_CR4_VMXE);
+	return 0;
+
+fault:
+	cr4_clear_bits(X86_CR4_VMXE);
+	return -EIO;
+}
+
 static void vmx_emergency_disable(void)
 {
 	int cpu = raw_smp_processor_id();
@@ -753,7 +775,8 @@ static void vmx_emergency_disable(void)
 			    loaded_vmcss_on_cpu_link)
 		vmcs_clear(v->vmcs);
 
-	__cpu_emergency_vmxoff();
+	if (__read_cr4() & X86_CR4_VMXE)
+		kvm_cpu_vmxoff();
 }
 
 static void __loaded_vmcs_clear(void *arg)
@@ -2818,7 +2841,7 @@ static void vmx_hardware_disable(void)
 {
 	vmclear_local_loaded_vmcss();
 
-	if (cpu_vmxoff())
+	if (kvm_cpu_vmxoff())
 		kvm_spurious_fault();
 
 	hv_reset_evmcs();
-- 
2.41.0.487.g6d72f3e995-goog

