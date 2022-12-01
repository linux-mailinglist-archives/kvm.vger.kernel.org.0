Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB4A463FBF6
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 00:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbiLAX11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 18:27:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbiLAX1Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 18:27:16 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F56CA790
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 15:27:11 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3b0af5bcbd3so31934067b3.0
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 15:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oOjLsBhtQc4Zwk7j8jnMy1RaD3WNvOTCrnpAR6Y5Wh4=;
        b=iD7DAvdmg/6zF71OGW1W55vNfYRUgmUrzSQ3x+UEEnpmklMmMgQUfTEP1QKNKMSlRX
         TxjAJfp7C02va3ptgeSSWV94pjJBk1+6p5N1AvvEj2k2S9IHil3K+fjpWRQDEypcl0j/
         j8ocO0aDVQ+QsjPt4v69TDSd3UXkBlYv9XKDk9zA79T74/aCGjrFuLNH5IIHtiZbw8kp
         DRWUreIUMwKrhLY3Lmbubt7OnAPJZZ0DizPcMzAQADuXs8vWwGmX9o7ltMQKioHYfJMD
         FYstpPF/MfDvZBN6JBFlSsWFdfMXXtd1YSwGg5tndJytuH6jeVnlrEFk42zns1yga60d
         blLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oOjLsBhtQc4Zwk7j8jnMy1RaD3WNvOTCrnpAR6Y5Wh4=;
        b=vc591g6eGaJnmd3x6CPmBrB+uMdkO3+04zw0cAjFfej0W/TZF1u+KEO+lqFrFiCFdX
         n4dx01lXmvZqlTyP5Qdj1c2yfd0t8EgtTx1Kb1vbJByevtHyYRVUe4BiqYyFh0ilHGab
         aKDJkuMYOcz6F48XG29klcifF6toZObDPNKhTbsZcLKkaksWk9vHFfZ+RhsE4cClgAV6
         Bu9JAv/g9uY3BKgtQwke6Tig4iTyd1C7qNTJWqGwXs2yGFB+zLte3y3JUwqqDuXKomMx
         1ya9ntm02ViAnTSHkZT75reDsENKSQ+lUWuc+XCs+ZWhsu7RahOKD9SFsgADaN0cjLKl
         QmXA==
X-Gm-Message-State: ANoB5plzoFjqWJXzdYIsfar4tnWKinPRRHxHyhabKoczQsUkFQ6mDk+8
        qdQepN7xrs5R/HOwUTO8dAn6qrXOEM4=
X-Google-Smtp-Source: AA0mqf6e3fI8ZKhR812Q6WWT615sHyFSm1ucZmUC1BB457teQBEMBCmdWiFc6wIBLpE6L5mS6tfUF2fQ+xw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9e84:0:b0:6dc:a18d:9ee5 with SMTP id
 p4-20020a259e84000000b006dca18d9ee5mr48977176ybq.88.1669937230726; Thu, 01
 Dec 2022 15:27:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Dec 2022 23:26:44 +0000
In-Reply-To: <20221201232655.290720-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221201232655.290720-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221201232655.290720-6-seanjc@google.com>
Subject: [PATCH 05/16] x86/reboot: KVM: Handle VMXOFF in KVM's reboot callback
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

Use KVM VMX's reboot/crash callback to do VMXOFF in an emergency instead
of manually and blindly doing VMXOFF.  There's no need to attempt VMXOFF
if KVM (or some other out-of-tree hypervisor) isn't loaded/active, i.e.
if the CPU can't possibly be post-VMXON.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/virtext.h | 10 ----------
 arch/x86/kernel/reboot.c       | 30 +++++++++---------------------
 arch/x86/kvm/vmx/vmx.c         |  8 +++++---
 3 files changed, 14 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 0acb14806a74..4f61283b1f52 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -70,16 +70,6 @@ static inline void __cpu_emergency_vmxoff(void)
 		cpu_vmxoff();
 }
 
-/** Disable VMX if it is supported and enabled on the current CPU
- */
-static inline void cpu_emergency_vmxoff(void)
-{
-	if (cpu_has_vmx())
-		__cpu_emergency_vmxoff();
-}
-
-
-
 
 /*
  * SVM functions:
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 40ea16ecb3b8..85ea1fdebf4c 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -788,13 +788,7 @@ void machine_crash_shutdown(struct pt_regs *regs)
 #endif
 
 #if IS_ENABLED(CONFIG_KVM_INTEL)
-/*
- * This is used to VMCLEAR all VMCSs loaded on the
- * processor. And when loading kvm_intel module, the
- * callback function pointer will be assigned.
- *
- * protected by rcu.
- */
+/* RCU-protected callback to disable virtualization prior to reboot. */
 static cpu_emergency_virt_cb __rcu *cpu_emergency_virt_callback;
 
 void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback)
@@ -815,17 +809,6 @@ void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback)
 	synchronize_rcu();
 }
 EXPORT_SYMBOL_GPL(cpu_emergency_unregister_virt_callback);
-
-static inline void cpu_crash_vmclear_loaded_vmcss(void)
-{
-	cpu_emergency_virt_cb *callback;
-
-	rcu_read_lock();
-	callback = rcu_dereference(cpu_emergency_virt_callback);
-	if (callback)
-		callback();
-	rcu_read_unlock();
-}
 #endif
 
 /* This is the CPU performing the emergency shutdown work. */
@@ -841,10 +824,15 @@ void cpu_emergency_disable_virtualization(void)
 	lockdep_assert_irqs_disabled();
 
 #if IS_ENABLED(CONFIG_KVM_INTEL)
-	cpu_crash_vmclear_loaded_vmcss();
-#endif
+	cpu_emergency_virt_cb *callback;
 
-	cpu_emergency_vmxoff();
+	rcu_read_lock();
+	callback = rcu_dereference(cpu_emergency_virt_callback);
+	if (callback)
+		callback();
+	rcu_read_unlock();
+#endif
+	/* KVM_AMD doesn't yet utilize the common callback. */
 	cpu_emergency_svm_disable();
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6e0cc4d03884..6f3ade75a670 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -743,7 +743,7 @@ static int vmx_set_guest_uret_msr(struct vcpu_vmx *vmx,
 	return ret;
 }
 
-static void crash_vmclear_local_loaded_vmcss(void)
+static void vmx_emergency_disable(void)
 {
 	int cpu = raw_smp_processor_id();
 	struct loaded_vmcs *v;
@@ -751,6 +751,8 @@ static void crash_vmclear_local_loaded_vmcss(void)
 	list_for_each_entry(v, &per_cpu(loaded_vmcss_on_cpu, cpu),
 			    loaded_vmcss_on_cpu_link)
 		vmcs_clear(v->vmcs);
+
+	__cpu_emergency_vmxoff();
 }
 
 static void __loaded_vmcs_clear(void *arg)
@@ -8526,7 +8528,7 @@ static void __vmx_exit(void)
 {
 	allow_smaller_maxphyaddr = false;
 
-	cpu_emergency_unregister_virt_callback(crash_vmclear_local_loaded_vmcss);
+	cpu_emergency_unregister_virt_callback(vmx_emergency_disable);
 
 	vmx_cleanup_l1d_flush();
 }
@@ -8576,7 +8578,7 @@ static int __init vmx_init(void)
 		pi_init_cpu(cpu);
 	}
 
-	cpu_emergency_register_virt_callback(crash_vmclear_local_loaded_vmcss);
+	cpu_emergency_register_virt_callback(vmx_emergency_disable);
 
 	vmx_check_vmcs12_offsets();
 
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

