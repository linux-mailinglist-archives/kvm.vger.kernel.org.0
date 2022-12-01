Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1144E63FC01
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 00:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbiLAX2Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 18:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbiLAX14 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 18:27:56 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22C1CCFCF
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 15:27:19 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id w2-20020a17090a8a0200b002119ea856edso7565410pjn.5
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 15:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7SXAjG1M+IBfGsFtMHywIkRjTzn4Js8KsrZjxZEQBMU=;
        b=ACp2sPOEEhtUBdUDYUmigXNlNuydDo0L5gzT5adI9Ji7FnPzwS3jyQFj4800dH1gw9
         aarAXgAVG3T7xg4Qhv/0Lq9enspYAIWfp8dNBJRTmS+OV8tF9ebUWwetC6n5CUXx24+d
         0uT9DyPL9JhKc9a+6znnfRysveD6YN6SmC+p/THzkHUOU2Qy5pq7IvsseLzKTf9lvQpk
         jBnmpRrZ8oaXv4SPUSlSo32xL0T3HTioALanjDXwhPrU8IvuVvweucc4eV0oxIvVYTrE
         6yoSVAkLxA59E0IbPqoP/RYWydh6JrEZiaA0oBmaahC/ifgo4vHX4h36dkajhv5R/+U3
         0NKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7SXAjG1M+IBfGsFtMHywIkRjTzn4Js8KsrZjxZEQBMU=;
        b=AlroynRJsEpLLzks59+0VkNOLPZLSo6o9CRSQUKqeDGbRnt8mpsOLls3comYY4pkIM
         HXw71LuoI8Cp6keMVyxT6Ce60nSHlxnGRxb8JaI3+NOAnNgbYkwd2mJvEc/OxE9AaGFv
         ccOKKEOcLirKHVhmRuI9IGYrDQO1dd44BPkGmiQkMrVxTzxT1KpE2678tGPS6Bzp69Gt
         OhpYtyhNdNYHNNIQjywZDPC3vXBLS7s4Tug8z8sr8S77xhDhErBmT5BP1vENVYqZp+zA
         KtoIK7gwEpPT37MfjxESDmnrs0tjjRUTtW4SUV5vbWR9kTArzMT8cEfJKFPqr+WaIIHA
         I5pw==
X-Gm-Message-State: ANoB5pkExyfuW7ij/LrM25nwFZIyG3Ul2F2NtQS5chxINyWeMWKrPW+z
        TEAcZpF5B6wZwrI8twRLJ3rnoGbzxac=
X-Google-Smtp-Source: AA0mqf5WubwN175lIMTyZxAOD6OhDkttOnqc3F5KtxxV+MMxPH5WaxC+3QCgYB5pFp1bK+wzYaA2AQ5YxyA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d086:b0:219:227d:d91f with SMTP id
 k6-20020a17090ad08600b00219227dd91fmr2875299pju.0.1669937238934; Thu, 01 Dec
 2022 15:27:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Dec 2022 23:26:49 +0000
In-Reply-To: <20221201232655.290720-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221201232655.290720-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221201232655.290720-11-seanjc@google.com>
Subject: [PATCH 10/16] x86/virt: KVM: Move VMXOFF helpers into KVM VMX
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Andrew Cooper <Andrew.Cooper3@citrix.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that VMX is disabled in emergencies via the virt callbacks, move the
VMXOFF helpers into KVM, the only remaining user.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/virtext.h | 42 ----------------------------------
 arch/x86/kvm/vmx/vmx.c         | 29 ++++++++++++++++++++---
 2 files changed, 26 insertions(+), 45 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index c5df63c606be..0b373543514f 100644
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
index 5bdcae435897..8be99651dcc9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -47,7 +47,6 @@
 #include <asm/mshyperv.h>
 #include <asm/mwait.h>
 #include <asm/spec-ctrl.h>
-#include <asm/virtext.h>
 #include <asm/vmx.h>
 
 #include "capabilities.h"
@@ -743,6 +742,29 @@ static int vmx_set_guest_uret_msr(struct vcpu_vmx *vmx,
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
@@ -752,7 +774,8 @@ static void vmx_emergency_disable(void)
 			    loaded_vmcss_on_cpu_link)
 		vmcs_clear(v->vmcs);
 
-	__cpu_emergency_vmxoff();
+	if (__read_cr4() & X86_CR4_VMXE)
+		kvm_cpu_vmxoff();
 }
 
 static void __loaded_vmcs_clear(void *arg)
@@ -2814,7 +2837,7 @@ static void vmx_hardware_disable(void)
 {
 	vmclear_local_loaded_vmcss();
 
-	if (cpu_vmxoff())
+	if (kvm_cpu_vmxoff())
 		kvm_spurious_fault();
 
 	hv_reset_evmcs();
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

