Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9D66B5303
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 22:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbjCJVnJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 16:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbjCJVnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 16:43:01 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B9A132AB1
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 13:42:49 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id x63-20020a17090a6c4500b00237731465feso3251660pjj.8
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 13:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678484569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=w80rZt1o6cOYQZQj30lqAx7Xyo1RS8UfRwRwdGlfA5I=;
        b=D1LjzQtDn3DaIVmk+eWNv1i1Smgll06esksBMYRtrPoSiyJXPFYHGx8lYzRTrwHy8H
         k6yg5HOeairVqcCZCqaNu+AcodZw7lkuYgDz7s9MLxchdJ80fWDX2PveGpRPNMvDqGbG
         7C0VtGgcqRGW4TYwssBbVw/fQtDTEfymsV2cj96lg2hGaHH5SrwAbmxbqB6QKiEnTTNI
         fRS5j+bf8z102qj3qCWu1WQPwErM85UXnc0/OHiZea1DjI4zo8yrUbV8+vU1FR8UlifZ
         Dj5OhNC4iDvDQwHFKx0UhlSQBgLhPrS874lqzBQkzYZLG7mPurRcKAiodPzPSq0Kju1X
         tDmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678484569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w80rZt1o6cOYQZQj30lqAx7Xyo1RS8UfRwRwdGlfA5I=;
        b=o79vEYugdv+3ZjWODzpr/PB2UrLwLeJZ5EIlR2G/M6aeBlTBxFzR4Kfl0z6eB6RW+G
         i2zO2yAC0vzWpaP8ogMnUTidovNdQkuOha3uIlIdNJy4AB6BOH8ksfqVuRJ/0xJnCad8
         sLq8W596vCUvftJyp/1ew/8yvklzsK8QVcfhXDh82v3nfOCG/ysIYb52wQHIMZWZ5TYg
         bG4bUAuLa9yB/OZPP81Ijmt94PoA4VL8bNf9CVVYWyaocSMgo4ddWYyvX/Ae1so9km4f
         BParxwbWiErsuS82VVjSJl99NHCsLdLexxLd6y1jVFr6A3ECcKGIlpHMCDvAwzp11dP6
         slXg==
X-Gm-Message-State: AO0yUKUupz9/jmAx4IcLtl828BO5vaKrQjlVdzhVDqhG/aQ2CzWsMAlm
        Zaz+EJbhBD++BGGtJcAD+kYEmPjTAVA=
X-Google-Smtp-Source: AK7set/chHdFySMAE+0sGh0GY32mtYKIsRsEXJ0lspanZDAhfl7gHG/0s53w5bZjEP5iS4EgdjHUXDP6zBI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:201d:0:b0:507:4697:392d with SMTP id
 g29-20020a63201d000000b005074697392dmr6810447pgg.7.1678484569126; Fri, 10 Mar
 2023 13:42:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 13:42:20 -0800
In-Reply-To: <20230310214232.806108-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230310214232.806108-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230310214232.806108-7-seanjc@google.com>
Subject: [PATCH v2 06/18] x86/reboot: Hoist "disable virt" helpers above
 "emergency reboot" path
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the various "disable virtualization" helpers above the emergency
reboot path so that emergency_reboot_disable_virtualization() can be
stubbed out in a future patch if neither KVM_INTEL nor KVM_AMD is enabled,
i.e. if there is no in-tree user of CPU virtualization.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/reboot.h |  4 +-
 arch/x86/kernel/reboot.c      | 82 +++++++++++++++++------------------
 2 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index dc2b77e6704b..2be5b89c9a05 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -29,8 +29,10 @@ void __noreturn machine_real_restart(unsigned int type);
 typedef void (cpu_emergency_virt_cb)(void);
 void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback);
 void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback);
-#endif
 void cpu_emergency_disable_virtualization(void);
+#else
+static inline void cpu_emergency_disable_virtualization(void) {}
+#endif
 
 typedef void (*nmi_shootdown_cb)(int, struct pt_regs*);
 void nmi_panic_self_stop(struct pt_regs *regs);
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index db535542b7ab..cb268ec7ce85 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -530,6 +530,46 @@ static inline void kb_wait(void)
 
 static inline void nmi_shootdown_cpus_on_restart(void);
 
+#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
+/* RCU-protected callback to disable virtualization prior to reboot. */
+static cpu_emergency_virt_cb __rcu *cpu_emergency_virt_callback;
+
+void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback)
+{
+	if (WARN_ON_ONCE(rcu_access_pointer(cpu_emergency_virt_callback)))
+		return;
+
+	rcu_assign_pointer(cpu_emergency_virt_callback, callback);
+}
+EXPORT_SYMBOL_GPL(cpu_emergency_register_virt_callback);
+
+void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback)
+{
+	if (WARN_ON_ONCE(rcu_access_pointer(cpu_emergency_virt_callback) != callback))
+		return;
+
+	rcu_assign_pointer(cpu_emergency_virt_callback, NULL);
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(cpu_emergency_unregister_virt_callback);
+
+/*
+ * Disable virtualization, i.e. VMX or SVM, to ensure INIT is recognized during
+ * reboot.  VMX blocks INIT if the CPU is post-VMXON, and SVM blocks INIT if
+ * GIF=0, i.e. if the crash occurred between CLGI and STGI.
+ */
+void cpu_emergency_disable_virtualization(void)
+{
+	cpu_emergency_virt_cb *callback;
+
+	rcu_read_lock();
+	callback = rcu_dereference(cpu_emergency_virt_callback);
+	if (callback)
+		callback();
+	rcu_read_unlock();
+}
+#endif /* CONFIG_KVM_INTEL || CONFIG_KVM_AMD */
+
 static void emergency_reboot_disable_virtualization(void)
 {
 	/* Just make sure we won't change CPUs while doing this */
@@ -787,51 +827,9 @@ void machine_crash_shutdown(struct pt_regs *regs)
 }
 #endif
 
-#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
-/* RCU-protected callback to disable virtualization prior to reboot. */
-static cpu_emergency_virt_cb __rcu *cpu_emergency_virt_callback;
-
-void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback)
-{
-	if (WARN_ON_ONCE(rcu_access_pointer(cpu_emergency_virt_callback)))
-		return;
-
-	rcu_assign_pointer(cpu_emergency_virt_callback, callback);
-}
-EXPORT_SYMBOL_GPL(cpu_emergency_register_virt_callback);
-
-void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback)
-{
-	if (WARN_ON_ONCE(rcu_access_pointer(cpu_emergency_virt_callback) != callback))
-		return;
-
-	rcu_assign_pointer(cpu_emergency_virt_callback, NULL);
-	synchronize_rcu();
-}
-EXPORT_SYMBOL_GPL(cpu_emergency_unregister_virt_callback);
-#endif
-
 /* This is the CPU performing the emergency shutdown work. */
 int crashing_cpu = -1;
 
-/*
- * Disable virtualization, i.e. VMX or SVM, to ensure INIT is recognized during
- * reboot.  VMX blocks INIT if the CPU is post-VMXON, and SVM blocks INIT if
- * GIF=0, i.e. if the crash occurred between CLGI and STGI.
- */
-void cpu_emergency_disable_virtualization(void)
-{
-#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
-	cpu_emergency_virt_cb *callback;
-
-	rcu_read_lock();
-	callback = rcu_dereference(cpu_emergency_virt_callback);
-	if (callback)
-		callback();
-	rcu_read_unlock();
-#endif
-}
-
 #if defined(CONFIG_SMP)
 
 static nmi_shootdown_cb shootdown_callback;
-- 
2.40.0.rc1.284.g88254d51c5-goog

